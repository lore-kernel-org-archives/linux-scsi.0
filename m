From: sagi grimberg <sagig@mellanox.com>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 16:01:10 +0300
Message-ID: <53A97696.6040302@mellanox.com>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-2-git-send-email-sagig@mellanox.com> <53A920B2.9060503@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53A920B2.9060503@cs.wisc.edu>
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, martin.petersen@oracle.com, Christoph Hellwig <hch@infradead.org>
Cc: nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/24/2014 9:54 AM, Mike Christie wrote:
> On 06/11/2014 04:09 AM, Sagi Grimberg wrote:
>> In case protection information exists on the wire
>> scsi transports should include it in the transfer
>> byte count (even if protection information does not
>> exist in the host memory space). This helper will
>> compute the total transfer length from the scsi
>> command data length and protection attributes.
>>
>> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
>> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>> ---
>>   include/scsi/scsi_cmnd.h |   17 +++++++++++++++++
>>   1 files changed, 17 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>> index dd7c998..a100c6e 100644
>> --- a/include/scsi/scsi_cmnd.h
>> +++ b/include/scsi/scsi_cmnd.h
>> @@ -7,6 +7,7 @@
>>   #include <linux/types.h>
>>   #include <linux/timer.h>
>>   #include <linux/scatterlist.h>
>> +#include <scsi/scsi_device.h>
>>   
>>   struct Scsi_Host;
>>   struct scsi_device;
>> @@ -306,4 +307,20 @@ static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
>>   	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
>>   }
>>   
>> +static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
>> +{
>> +	unsigned int xfer_len = blk_rq_bytes(scmd->request);
>> +	unsigned int prot_op = scsi_get_prot_op(scmd);
>> +	unsigned int sector_size = scmd->device->sector_size;
>> +
>> +	switch (prot_op) {
>> +	case SCSI_PROT_NORMAL:
>> +	case SCSI_PROT_WRITE_STRIP:
>> +	case SCSI_PROT_READ_INSERT:
>> +		return xfer_len;
>> +	}
>> +
>> +	return xfer_len + (xfer_len >> ilog2(sector_size)) * 8;
>> +}
>> +
>>   #endif /* _SCSI_SCSI_CMND_H */
>>
> I found the issue Christoph is hitting in the other thread.
>
> The problem is WRITE_SAME requests are setup so that req->__data_len is
> the value of the entire request when the setup is completed but during
> the setup process it's value changes
>
> So __data_len could be thousands of bytes but
> scsi_out(scsi_cmnd)->length for this case was only returning 512 which
> is the sector size. This is because sd_setup_-write_same_cmnd does:
>
>
> rq->__data_len = sdp->sector_size;
> ....
> scsi_setup_blk_pc_cmnd()
> ....
> rq->__data_len = nr_bytes;
>
> and scsi_setup_blk_pc_cmnd does scsi_init_io() -> scsi_init_sgtable()
> and that does
>
> sdb->length = blk_rq_bytes(req);
>
> and at this time because before we called scsi_setup_blk_pc_cmnd we set
> the __data_len to sector size, the sdb length is going to be only 512
> but the final request->__data_len is the total size of the operation.


Hey Christoph, Mike &MKP,

So just got first look in this thread, didn't have time to reproduce it yet.
Mike's analysis makes sense to me, I think the below change should 
resolve this one.

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a100c6e..2afd9c2 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -309,7 +309,7 @@ static inline void set_driver_byte(struct scsi_cmnd 
*cmd, char status)

  static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
  {
-       unsigned int xfer_len = blk_rq_bytes(scmd->request);
+       unsigned int xfer_len = scsi_bufflen(scmd);
         unsigned int prot_op = scsi_get_prot_op(scmd);
         unsigned int sector_size = scmd->device->sector_size;


Moreover, since bidi and dif are adjacent, this will also needed:

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 3f46234..abf0c3e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -386,12 +386,14 @@ static int iscsi_prep_scsi_cmd_pdu(struct 
iscsi_task *task)
                 rc = iscsi_prep_bidi_ahs(task);
                 if (rc)
                         return rc;
+               transfer_length = scsi_in(sc)->length;
+       } else {
+               transfer_length = scsi_transfer_length(sc);
         }

         if (scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
                 task->protected = true;

-       transfer_length = scsi_transfer_length(sc);
         hdr->data_length = cpu_to_be32(transfer_length);
         if (sc->sc_data_direction == DMA_TO_DEVICE) {
                 struct iscsi_r2t_info *r2t = &task->unsol_r2t;

Let me test and queue it up.

Sagi.
