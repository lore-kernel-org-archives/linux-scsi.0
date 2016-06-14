From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCHv2] libfc: Update rport reference counting
Date: Tue, 14 Jun 2016 12:20:02 +0200
Message-ID: <20160614102002.ia3h55u3z6yz34y4@c203.arch.suse.de>
References: <1464070318-69866-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbcFNKUJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2016 06:20:09 -0400
Content-Disposition: inline
In-Reply-To: <1464070318-69866-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, May 24, 2016 at 08:11:58AM +0200, Hannes Reinecke wrote:
> Originally libfc would just be initializing the refcount to '1',
> and using the disc_mutex to synchronize if and when the final put
> should be happening.
> This has a race condition as the mutex might be delayed, causing
> other threads to access an invalid structure.
> This patch updates the rport reference counting to increase the
> reference every time 'rport_lookup' is called, and decreases
> the reference correspondingly.
> This removes the need to hold 'disc_mutex' when removing the
> structure, and avoids the above race condition.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
