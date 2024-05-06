Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676BC47F4A
	for <linux-scsi@vger.kernel.org>; Mon,  6 May 2024 05:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714974879; cv=none; b=IKnTDF9rUfaB884MhUycafesQNeFHWsTJozjcfkg+xdBEk6g1tADpaXILf0Y4ieRLh4uB6dSk6J92l8mzFOEHkc6fLIoQbIWKWRca8uImJJXw7c1iXVz0NHgUR8lfNfDlJx36C3Kfcr13+4dQQOrOnHIh1P8qdTUZsTyyZgV+vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714974879; c=relaxed/simple;
	bh=3YIl6H60nRmRZgaQQdqN6oVC/tFUWjWZlIBglXvFsjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KUI9i+qCNTgTIRxOfUqY5RP8/CeBBX6vnlujZ0oypiLR5aV8G95puOBeQnpzFjcK/CGzqZx7zXtlmt9fN5z6/BLPHdIq04FWEz/pzDxo1qKDWkkGHH3QIzExa0Q48rinTTog3q7cMXlWhpYH7KKavhmzaWilxm10cF7/EMYHnGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ABE8D68AFE; Mon,  6 May 2024 07:54:33 +0200 (CEST)
Date: Mon, 6 May 2024 07:54:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Martin Wilck <martin.wilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
	James Bottomley <jejb@linux.vnet.ibm.com>,
	Ewan Milne <emilne@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
	Martin Wilck <mwilck@suse.com>, Rajashekhar M A <rajs@netapp.com>
Subject: Re: [PATCH v2] I/O errors for ALUA state transitions
Message-ID: <20240506055433.GA5220@lst.de>
References: <20240503195606.13120-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503195606.13120-1-mwilck@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> -static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
> -					      struct scsi_sense_hdr *sense_hdr)
> +static enum scsi_disposition alua_handle_state_transition(struct scsi_device *sdev)
>  {
>  	struct alua_dh_data *h = sdev->handler_data;
>  	struct alua_port_group *pg;
>  
> +	/*
> +	 * LUN Not Accessible - ALUA state transition
> +	 */
> +	rcu_read_lock();
> +	pg = rcu_dereference(h->pg);
> +	if (pg)
> +		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
> +	rcu_read_unlock();
> +	alua_check(sdev, false);
> +	return NEEDS_RETRY;

This always returns NEEDS_RETRY, so you can drop the return value
entirely and handle this in the callers.

