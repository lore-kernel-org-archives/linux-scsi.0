From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 16/16] scsi_dh_alua: Use workqueue for RTPG
Date: Fri, 14 Feb 2014 20:03:26 +0100
Message-ID: <52FE687E.7000100@acm.org>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-17-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:60641 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751946AbaBNTDc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Feb 2014 14:03:32 -0500
In-Reply-To: <1391160600-19652-17-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 01/31/14 10:30, Hannes Reinecke wrote:
> +static void alua_check(struct scsi_device *sdev)
> +{
> +	struct alua_dh_data *h = get_alua_data(sdev);
> +	struct alua_port_group *pg;
> +
> +	if (!h)
> +		return;
> +
> +	rcu_read_lock();
> +	pg = rcu_dereference(h->pg);
> +	if (pg) {
> +		kref_get(&pg->kref);
> +		rcu_read_unlock();
> +		alua_rtpg_queue(pg, sdev, NULL);
> +		kref_put(&pg->kref, release_port_group);
> +	} else
> +		rcu_read_unlock();
> +}

>From the implementation it seems to me like the target port group data
is kept just as long as it is in use ? Has it been considered to keep
that data as long as the sdev exists instead ? I think that would result
in far fewer reference count manipulations and hence in code that is
easier to read and to verify.

Thanks,

Bart.
