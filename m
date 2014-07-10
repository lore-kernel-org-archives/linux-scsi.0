From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 4/4] scsi: pm8001: fix pm8001_store_update_fw
Date: Thu, 10 Jul 2014 15:30:32 +0200
Message-ID: <53BE9578.3060902@redhat.com>
References: <1404746401-25229-4-git-send-email-thenzl@redhat.com> <20140710064301.GA18156@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbaGJNbD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2014 09:31:03 -0400
In-Reply-To: <20140710064301.GA18156@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

On 07/10/2014 08:43 AM, Christoph Hellwig wrote:
> On Mon, Jul 07, 2014 at 05:20:01PM +0200, Tomas Henzl wrote:
>> The current implementation may mix the negative value returned
>> from pm8001_set_nvmd with with count. -(-ENOMEM) could be interpreted
>> as bytes programmed, this patch fixes it.
> This still doesn;t look correct to me as err mixes up the driver
> internal FAIL_* codes with Linux error codes.  It seems like for the
> FAIL_* codes should only go into ->fw_status and the return value
> should be a proper Linux error code.

And the fw_status might be later used to show error strings in pm8001_show_update_fw,
if it is so it depends on the flash utility but it seems likely. 

>
> Funny fact: the FAIL_* / FLASH_IN_PROGRESS codes seems to be the same
> between aic94xx and pm8001.

And similar story there too - asd_store_update_bios -...- asd_poll_flash(might return -ENOENT)

Maybe the flash utility ignores the return value or it has never happened.
---------------------

I'll try to find what seems to be the most probable way and post it in few days.
This patch is not related to the patches 1-3/4, so just wait with this one.

Thanks, Tomas

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

