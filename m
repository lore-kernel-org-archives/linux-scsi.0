From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/10] scsi_dh: move 'dh_state' sysfs attribute to
	generic code
Date: Thu, 9 Jul 2015 10:24:24 +0200
Message-ID: <20150709082424.GB1419@lst.de>
References: <1436346425-96635-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51806 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbbGIIY0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2015 04:24:26 -0400
Content-Disposition: inline
In-Reply-To: <1436346425-96635-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>

On Wed, Jul 08, 2015 at 11:07:05AM +0200, Hannes Reinecke wrote:
> As scsi_dh.c is now always compiled in we should be moving
> the 'dh_state' attribute to the generic code.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks fine, but a few coding style nitpicks:

> +	if (!sdev->handler) {
> +		/*
> +		 * Attach to a device handler
> +		 */
> +		err =3D scsi_dh_attach(sdev->request_queue, buf);
> +	} else {
> +		if (!strncmp(buf, "detach", 6)) {

Switch to en else if here.  Also may=E3=81=B9e move the activate case u=
p as it's
relevant while detach is dead now.

> +	return err<0?err:count;

Please add the missing spaces here.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
