From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 3/6] scsi_dh : release the refcounts in scsi_dh_alua
 handler when activate is complete
Date: Thu, 29 Jul 2010 19:12:07 -0500
Message-ID: <1280448727.4441.942.camel@mulgrave.site>
References: <E463DF2B2E584B4A82673F53D62C2EF4D05DC423@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37148 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180Ab0G3AMN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 20:12:13 -0400
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4D05DC423@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

On Wed, 2010-07-28 at 16:59 -0600, Moger, Babu wrote:
> This patch releases the refcounts when activate is complete in alua handler.
> 
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> ---
> --- linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh_alua.c.orig	2010-07-23 05:58:39.000000000 -0500
> +++ linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh_alua.c	2010-07-23 06:00:54.000000000 -0500
> @@ -287,6 +287,8 @@ done:
>  		h->callback_fn(h->callback_data, err);
>  		h->callback_fn = h->callback_data = NULL;
>  	}
> +	kref_put(&h->sdev->scsi_dh_data->kref, scsi_dh_handler_cleanup);
> +	put_device(&h->sdev->sdev_gendev);
>  	return;
>  }
>  
> @@ -684,6 +686,8 @@ static int alua_activate(struct scsi_dev
>  out:
>  	if (fn)
>  		fn(data, err);
> +	kref_put(&sdev->scsi_dh_data->kref, scsi_dh_handler_cleanup);
> +	put_device(&sdev->sdev_gendev);

This sequence is asking for trouble: having to remember to release two
separate references at once.

Logically what should happen is that the reference seems to be on
scsi_dh_data->sdev, so it should be taken when that's initialised and
put in scsi_dh_handler_cleanup ... so no-one has to worry about
forgetting it.

James


