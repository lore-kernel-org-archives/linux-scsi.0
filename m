From: Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: STANDBY IMMEDIATE failed on NVIDIA MCP5x controllers when system
 suspend
Date: Mon, 11 Mar 2013 21:51:50 +0800
Message-ID: <513DE176.7050405@gmail.com>
References: <513D52BE.7040307@intel.com> <1362991742.2395.9.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59301 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3CKNwF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Mar 2013 09:52:05 -0400
In-Reply-To: <1362991742.2395.9.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Aaron Lu <aaron.lu@intel.com>, bladud@gmail.com, Joe Sapp <nixphoeni+kernel@gmail.com>, Alberto Mattea <support.intranet@libero.it>, Peter Dons Tychsen <donpedro@tdcadsl.dk>, Robert Hancock <hancockrwd@gmail.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On 2013-03-11 16:49, James Bottomley wrote:
> On Mon, 2013-03-11 at 11:42 +0800, Aaron Lu wrote:
>> Hi all,
>>
>> I've seen some reports on STANDBY IMMEDIATE failed on NVIDIA MCP5x
>> controllers when system goes to suspend(this command is sent by scsi sd
>> driver on system suspend as a SCSI STOP command, which is translated to
>> STANDBY IMMEDIATE ATA command). I've no idea of why this happened, so
>> I wrote this email in hope of getting some new idea.
>>
>> The related bug report:
>> https://bugzilla.kernel.org/show_bug.cgi?id=48951
>>
>> And google search showed that Peter reported a similar problem here:
>> http://marc.info/?l=linux-ide&m=133534061316338&w=2
>>
>> And bladud has found that, disable asyn suspend for the scsi target
>> device can work around this problem.
>>
>> Please feel free to suggest what can possibly be the cause, thanks.
>
> You really need to discriminate better between conditions we should and
> shouldn't care about for suspend.  so in sd_suspend, we definitely care
> if we can't flush the cache of a write back device because the power off
> could lose data.  We don't really care if the disk says I can't stop, so
> this is probably the correct fix.

Yes, this will make suspend succeed, but the problem is still there -
the drive does not respond to this command, while it will if async
suspend for the target device is disabled. I don't think scsi code has
any fault here, it feels more like a chip bug to me.

And if we solve it this way, affected user may complain about long
delay when suspending or uncomfortable with the error messages in dmesg,
since that command would eventually timeout. So I hope we can nderstand
what is going wrong here and perhaps do something to avoid it.

Thanks,
Aaron

>
> ---
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 7992635..384b621d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3079,7 +3079,11 @@ static int sd_suspend(struct device *dev)
>
>   	if (sdkp->device->manage_start_stop) {
>   		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
> -		ret = sd_start_stop_device(sdkp, 0);
> +		/*
> +		 * this is informational for the disk we're going to power it
> +		 * off anyway, so don't bother about the return status
> +		 */
> +		sd_start_stop_device(sdkp, 0);
>   	}
>
>   done:
>
>
