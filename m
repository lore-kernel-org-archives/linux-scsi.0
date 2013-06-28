From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 7/7] scsi: Add 'eh_deadline' to limit SCSI EH runtime
Date: Fri, 28 Jun 2013 09:29:38 +0200
Message-ID: <51CD3B62.9010609@acm.org>
References: <1370862713-41323-1-git-send-email-hare@suse.de> <1370862713-41323-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:36440 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3F1H3m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jun 2013 03:29:42 -0400
In-Reply-To: <1370862713-41323-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On 06/10/13 13:11, Hannes Reinecke wrote:
> +static int sdev_eh_deadline(struct Scsi_Host *shost,
> +			   unsigned long eh_start)
> +{
> +	if (!shost->eh_deadline)
> +		return 0;
> +
> +	if (shost->last_reset != 0 &&
> +	    time_before(shost->last_reset, eh_start))
> +		eh_start = shost->last_reset;
> +
> +	if (time_before(jiffies,
> +			eh_start + shost->eh_deadline))
> +		return 0;
> +
> +	return 1;
> +}
> +
> +static int scsi_host_eh_deadline(struct Scsi_Host *shost)
> +{
> +	if (!shost->last_reset)
> +		return 0;
> +
> +	return sdev_eh_deadline(shost, shost->last_reset);
> +}

Hello Hannes,

I would appreciate if you would choose other names for these two 
functions and also for shost->eh_deadline. To me a deadline is a time 
instant. As far as I can see the two functions above check whether a 
deadline has been passed, and shost->eh_deadline is a time interval. How 
about the following names: sdev_eh_past_deadline(), 
shost_eh_past_deadline() and shost->max_eh_jiffies ?

Thanks,

Bart.
