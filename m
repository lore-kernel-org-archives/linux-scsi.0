From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: Re: [PATCH 16/16] scsi_dh_alua: Use workqueue for RTPG
Date: Tue, 21 Jan 2014 16:25:47 +0800
Message-ID: <1390292747-8412-1-git-send-email-vaughan.cao@oracle.com>
References: <1387541621-54967-1-git-send-email-hare@suse.de> <1387541621-54967-17-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44179 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaAUIZd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2014 03:25:33 -0500
In-Reply-To: <1387541621-54967-17-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: linux-scsi@vger.kernel.org, vaughan.cao@oracle.com, jbottomley@parallels.com, sean.stewart@netapp.com, marting@netapp.com


On Fri, Dec 20, 2013 at 8:13 PM, Hannes Reinecke <hare@suse.de> wrote:
> 
> +static void alua_rtpg_work(struct work_struct *work)
> +{
> ..........
> +       if (pg->flags & ALUA_PG_RUN_STPG) {
> +               spin_unlock_irqrestore(&pg->rtpg_lock, flags);
> +               err = alua_stpg(sdev, pg);
> +               spin_lock_irqsave(&pg->rtpg_lock, flags);
> +               pg->flags &= ~ALUA_PG_RUN_STPG;
> +               pg->flags |= ALUA_PG_STPG_DONE;
> +               if (err == SCSI_DH_RETRY) {
> +                       pg->flags |= ALUA_PG_RUN_RTPG;
> +                       pg->interval = ALUA_RTPG_DELAY_MSECS * 1000;
>

Is the line above a typo?

pg->interval is measured in second unit. You won't want to set it as
milliseconds*1000. And ALUA_RTPG_DELAY_MSECS is used for queueing delayed rtpg
work, not for delay in retry cases such as state of transitioning. What you
want may be set a new delay time to start, similar to "pg->interval += 2" in
alua_rtpg when state of transitioning is returned.

Thanks,
Vaughan
