From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 7/7] scsi: Add 'eh_deadline' to limit SCSI EH runtime
Date: Wed, 16 Oct 2013 19:22:01 +0000
Message-ID: <1381936290.1864.11.camel@dabdike>
References: <1372661455-122384-1-git-send-email-hare@suse.de>
	 <1372661455-122384-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:53319 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760237Ab3JPTWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2013 15:22:33 -0400
In-Reply-To: <1372661455-122384-8-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <5F7285D48A0ED848BBEB4AA4E301163E@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>

On Mon, 2013-07-01 at 08:50 +0200, Hannes Reinecke wrote:
> This patchs adds an 'eh_deadline' sysfs attribute to the scsi
> host which limits the overall runtime of the SCSI EH.
> The 'eh_deadline' value is stored in the now obsolete field
> 'resetting'.
> When a command is failed the start time of the EH is stored
> in 'last_reset'. If the overall runtime of the SCSI EH is longer
> than last_reset + eh_deadline, the EH is short-circuited and
> falls through to issue a host reset only.

OK, so the specific problem with this one is that potentially it will
spend all its time mucking about with aborts (which most often time out
on non FC kit because of the issue problems) and then proceed to host
reset, which mostly does nothing for failing devices.

If you want to impose a deadline, then we need to spend only 50% of the
time attempting aborts and the rest of the time escalating the resets.

[...]
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f43de1e..84369f2 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -89,6 +89,18 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
>  }
>  EXPORT_SYMBOL_GPL(scsi_schedule_eh);
>  
> +static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
> +{
> +	if (!shost->last_reset || !shost->eh_deadline)
> +		return 0;
> +
> +	if (time_before(jiffies,
> +			shost->last_reset + shost->eh_deadline))
> +		return 0;
> +
> +	return 1;
> +}
> +

What about instead:

static int scsi_host_eh_past_deadline(struct Scsi_Host *shost, int percent) {
	if (!shost->last_reset || !shost->eh_deadline)
		return 0;

	if (time_before(jiffies,
			shost->last_reset + shost->eh_deadline * percent/100))
		return 0;

	return 1;
}

which allows us to have

if (scsi_host_eh_past_deadline(shost, 50)) {

in scsi_eh_abort_cmds()

if (scsi_host_eh_past_deadline(shost, 66) {

in scsi_eh_bus_device_reset()

say 83 in target reset, and 100 in bus reset.

Thus ensuring we at least get a crack at the reset chain?

James

