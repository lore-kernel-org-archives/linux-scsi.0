From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] virtio_scsi: check on resp->sense_len instead of 'sense_buffer'
Date: Fri, 18 Jul 2014 17:00:02 +0200
Message-ID: <53C93672.8030805@redhat.com>
References: <1405695438-18485-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761861AbaGRPAR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2014 11:00:17 -0400
In-Reply-To: <1405695438-18485-1-git-send-email-ming.lei@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Il 18/07/2014 16:57, Ming Lei ha scritto:
> -	if (sc->sense_buffer) {
> +	if (resp->sense_len) {

In the (unlikely) case that sc->sense_buffer == NULL, you'd pass a NULL
to memcpy.

If you want, you can change this if to

	if (sc->sense_buffer && resp->sense_len)

but frankly it seems like slightly pointless churn to me.

Paolo

>  		memcpy(sc->sense_buffer, resp->sense,
>  		       min_t(u32, resp->sense_len, VIRTIO_SCSI_SENSE_SIZE));
> -		if (resp->sense_len)
> -			set_driver_byte(sc, DRIVER_SENSE);
> +		set_driver_byte(sc, DRIVER_SENSE);
>  	}


