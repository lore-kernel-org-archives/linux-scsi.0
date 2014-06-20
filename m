From: Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH v0 2/3] ata: Fix the link down in first attempt for the
 APM X-Gene SoC AHCI SATA host controller driver.
Date: Fri, 20 Jun 2014 11:40:31 -0400
Message-ID: <53A455EF.7000808@redhat.com>
References: <1403253147-14341-1-git-send-email-stripathi@apm.com> <1403253147-14341-3-git-send-email-stripathi@apm.com> <53A45286.2040000@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbaFTPmE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2014 11:42:04 -0400
In-Reply-To: <53A45286.2040000@cogentembedded.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Suman Tripathi <stripathi@apm.com>, olof@lixom.net, tj@kernel.org, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>

On 06/20/2014 11:25 AM, Sergei Shtylyov wrote:
> On 06/20/2014 12:32 PM, Suman Tripathi wrote:
>
>> This patch fixes the link down issue by retry for the APM X-Gene SoC
>> SATA host controller driver. Due to board design issue and short margin
>> limitation, it is observed that once out of many thousands power cycle
>> test, the sata link may not link up.
>
>> Signed-off-by: Loc Ho <lho@apm.com>
>> Signed-off-by: Suman Tripathi <stripathi@apm.com>
>> ---
>>   drivers/ata/ahci_xgene.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>
>> diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
>> index 5f0f750..d43b6ce 100644
>> --- a/drivers/ata/ahci_xgene.c
>> +++ b/drivers/ata/ahci_xgene.c
> [...]
>> @@ -235,15 +238,21 @@ static int xgene_ahci_do_hardreset(struct ata_link *link,
>>       u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
>>       void __iomem *port_mmio = ahci_port_base(ap);
>>       struct ata_taskfile tf;
>> +    int link_down_retry = 0;
>>       int rc;
>>       u32 val;
>>
>> +hardreset_retry:
>>       /* clear D2H reception area to properly wait for D2H FIS */
>>       ata_tf_init(link->device, &tf);
>>       tf.command = ATA_BUSY;
>>       ata_tf_to_fis(&tf, 0, 0, d2h_fis);
>>       rc = sata_link_hardreset(link, timing, deadline, online,
>>                    ahci_check_ready);
>> +
>> +    if (!*online)
>> +        if (link_down_retry++ < MAX_LINK_DOWN_RETRY)
>
>     Could be folded into single *if* (and so indentation decreased).
>
better yet, for readability, a single while() loop

>> +            goto hardreset_retry;
>
> WBR, Sergei
>

