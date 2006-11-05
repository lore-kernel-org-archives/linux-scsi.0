From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] SCSI/SD: clearer output of disk cache state
Date: Sun, 05 Nov 2006 09:47:30 -0500
Message-ID: <454DF982.3050508@torque.net>
References: <472336.19994.qm@web31803.mail.mud.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:17877 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030319AbWKEOrY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Nov 2006 09:47:24 -0500
In-Reply-To: <472336.19994.qm@web31803.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> --- James Bottomley <James.Bottomley@SteelEye.com> wrote:
>> On Sat, 2006-11-04 at 11:54 -0800, Luben Tuikov wrote:
>>> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>>> ---
>>>  drivers/scsi/sd.c |   17 +++++++----------
>>>  1 files changed, 7 insertions(+), 10 deletions(-)
>>>
>>> This patch is 8 months old.
>> Um:
>>
>> patching file drivers/scsi/sd.c
>> Hunk #1 FAILED at 1354.
>> Hunk #2 FAILED at 1382.
>> 2 out of 2 hunks FAILED -- saving rejects to file drivers/scsi/sd.c.rej
>>
>> I think the code you're trying to change has altered a bit in the latest
>> kernels.
> 
> Re-based:
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> 
> --- 
>  drivers/scsi/sd.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 84ff203..ffbd021 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1467,7 +1467,6 @@ sd_read_cache_type(struct scsi_disk *sdk
>         res = sd_do_mode_sense(sdp, dbd, modepage, buffer, len, &data, &sshdr);
>  
>         if (scsi_status_is_good(res)) {
> -               int ct = 0;
>                 int offset = data.header_length + data.block_descriptor_length;
>  
>                 if (offset >= SD_BUF_SIZE - 2) {
> @@ -1496,11 +1495,13 @@ sd_read_cache_type(struct scsi_disk *sdk
>                         sdkp->DPOFUA = 0;
>                 }
>  
> -               ct =  sdkp->RCD + 2*sdkp->WCE;
> -
> -               printk(KERN_NOTICE "SCSI device %s: drive cache: %s%s\n",
> -                      diskname, sd_cache_types[ct],
> -                      sdkp->DPOFUA ? " w/ FUA" : "");
> +               printk(KERN_NOTICE "SCSI device %s: "
> +                      "write cache: %s, read cache: %s, %s\n",
> +                      diskname,
> +                      sdkp->WCE ? "enabled" : "disabled",
> +                      sdkp->RCD ? "disabled" : "enabled",
> +                      sdkp->DPOFUA ? "supports DPO and FUA"
> +                      : "doesn't support DPO or FUA");
>  
>                 return;
>         }

The definition of the DPOFUA flag (in the block descriptor
returned by MODE SENSE for direct access devices) is a bit
fuzzy in practice. When I queried the t10 reflector a
member from a disk company said it should be interpreted as
... we support DPO and/or FUA.

I also noticed that one disk manufacturer's unit attention mode
page had a bit to disable FUA (force unit access). So you can
set the FUA bit (in a READ or WRITE), we will ignore it! The
associated note says that it improves performance :-)

Doug Gilbert
