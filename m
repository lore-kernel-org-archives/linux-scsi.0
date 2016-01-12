From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 08/22] scsi_dh_alua: use unique device id
Date: Tue, 12 Jan 2016 18:10:47 +0100
Message-ID: <20160112171047.GB23947@lst.de>
References: <1452613258-94084-1-git-send-email-hare@suse.de> <1452613258-94084-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38985 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551AbcALRKt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2016 12:10:49 -0500
Content-Disposition: inline
In-Reply-To: <1452613258-94084-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

> +struct alua_port_group *alua_lookup_pg(char *id_str, size_t id_size,
> +				       int group_id)

Not too important, but I would have preferred alua_find_get_pg here.

> +{
> +	struct alua_port_group *pg;
> +
> +	list_for_each_entry(pg, &port_group_list, node) {
> +		if (pg->group_id != group_id)
> +			continue;
> +		if (pg->device_id_len != id_size)
> +			continue;
> +		if (strncmp(pg->device_id_str, id_str, id_size))
> +			continue;
> +		kref_get(&pg->kref);

This needs to be a kref_get_unless_zero
