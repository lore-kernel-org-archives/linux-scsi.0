From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/20] scsi_dh_alua: Use workqueue for RTPG
Date: Fri, 24 Jul 2015 17:21:15 +0200
Message-ID: <20150724152115.GC29434@lst.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-17-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55993 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbbGXPVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2015 11:21:17 -0400
Content-Disposition: inline
In-Reply-To: <1436346378-96518-17-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

> +	char			work_q_name[264];

create_workqueue and friends now accept printf-like format
string, so there is no need for this temporary buffer.

> +	int			error;
> +	struct completion       init_complete;

Please rename error to init_error and only assign to it before calling
complete().

Also I'm not sure what the real point of init_complete is, shouldn't
we just have a mutex held in alua_initialize and alua_activate to
synchronize the two against each other?

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

How about:

	rcu_read_lock();
	pg = rcu_dereference(h->pg);
	if (!pg) {
		rcu_read_unlock();
		return;
	}

	kref_get(&pg->kref);
	rcu_read_unlock();
	alua_rtpg_queue(pg, sdev, NULL);
	kref_put(&pg->kref, release_port_group);

