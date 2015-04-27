From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v3 3/5] target: handle odd SG mapping for data transfer memory
Date: Mon, 27 Apr 2015 22:03:25 +0900
Message-ID: <CAC5umyh4fjdXnYfSZkVQkRyg-69mkLp+7rezA5nVCWUQZz-saA@mail.gmail.com>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
	<1429972410-7146-4-git-send-email-akinobu.mita@gmail.com>
	<553CB8E7.8060402@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <553CB8E7.8060402@dev.mellanox.co.il>
Sender: linux-crypto-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: target-devel@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

2015-04-26 19:07 GMT+09:00 Sagi Grimberg <sagig@dev.mellanox.co.il>:
> On 4/25/2015 5:33 PM, Akinobu Mita wrote:
>>
>> sbc_dif_generate() and sbc_dif_verify() currently assume that each
>> SG element for data transfer memory doesn't straddle the block size
>> boundary.
>>
>> However, when using SG_IO ioctl, we can choose the data transfer
>> memory which doesn't satisfy that alignment requirement.
>>
>> In order to handle such cases correctly, this change inverts the outer
>> loop to iterate data transfer memory and the inner loop to iterate
>> protection information and enables to calculate CRC for a block which
>> straddles multiple SG elements.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: Tim Chen <tim.c.chen@linux.intel.com>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: linux-crypto@vger.kernel.org
>> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
>> Cc: Sagi Grimberg <sagig@mellanox.com>
>> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
>> Cc: target-devel@vger.kernel.org
>> Cc: linux-scsi@vger.kernel.org
>> ---
>> * Changes from v2:
>> - Handle odd SG mapping correctly instead of giving up
>>
>>   drivers/target/target_core_sbc.c | 108
>> +++++++++++++++++++++++++--------------
>>   1 file changed, 69 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/target/target_core_sbc.c
>> b/drivers/target/target_core_sbc.c
>> index edba39f..33d2426 100644
>> --- a/drivers/target/target_core_sbc.c
>> +++ b/drivers/target/target_core_sbc.c
>> @@ -1182,27 +1182,43 @@ sbc_dif_generate(struct se_cmd *cmd)
>>   {
>>         struct se_device *dev = cmd->se_dev;
>>         struct se_dif_v1_tuple *sdt;
>> -       struct scatterlist *dsg, *psg = cmd->t_prot_sg;
>> +       struct scatterlist *dsg = cmd->t_data_sg, *psg;
>>         sector_t sector = cmd->t_task_lba;
>>         void *daddr, *paddr;
>>         int i, j, offset = 0;
>> +       unsigned int block_size = dev->dev_attrib.block_size;
>>
>> -       for_each_sg(cmd->t_data_sg, dsg, cmd->t_data_nents, i) {
>> -               daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
>> +       for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
>>                 paddr = kmap_atomic(sg_page(psg)) + psg->offset;
>> +               daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
>>
>> -               for (j = 0; j < dsg->length; j +=
>> dev->dev_attrib.block_size) {
>> +               for (j = 0; j < psg->length;
>> +                               j += sizeof(struct se_dif_v1_tuple)) {
>> +                       __u16 crc = 0;
>> +                       unsigned int avail;
>>
>> -                       if (offset >= psg->length) {
>> -                               kunmap_atomic(paddr);
>> -                               psg = sg_next(psg);
>> -                               paddr = kmap_atomic(sg_page(psg)) +
>> psg->offset;
>> -                               offset = 0;
>> +                       if (offset >= dsg->length) {
>> +                               offset -= dsg->length;
>> +                               kunmap_atomic(daddr);
>
>
> This unmap is inconsistent. You need to unmap (daddr - dsg->offset).
>
> This applies throughout the patch.

Thanks for pointing out.  I'll fix them all.
