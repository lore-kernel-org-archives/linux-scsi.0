From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi_dh_alua: add missing transitioning state support
Date: Thu, 23 Sep 2010 09:44:38 -0400
Message-ID: <20100923134438.GA17966@redhat.com>
References: <1282073039.30453.37.camel@haakon2.linux-iscsi.org>
 <4C7B7B9E.3020002@suse.de>
 <20100831151129.GA18855@redhat.com>
 <20100920153539.GA28284@redhat.com>
 <4C98180F.1020707@cs.wisc.edu>
 <20100921193320.GA5110@redhat.com>
 <4C992026.5080402@cs.wisc.edu>
 <4C99D6B3.3090003@suse.de>
 <20100922122901.GA10218@redhat.com>
 <4C9AFEA7.50706@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab0IWNoy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 09:44:54 -0400
Content-Disposition: inline
In-Reply-To: <4C9AFEA7.50706@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Thu, Sep 23 2010 at  3:15am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> The device_handler will keep retrying any path in 'transitioning'.
> After ALUA_FAILOVER_TIMEOUT the device handler will either have
> updated the port state to something other than 'transitioning' or
> returned with 'SCSI_DH_RETRY'.
> But yes, you are right; we should be setting the port to something
> else than 'transitioning' then. Probably 'standby' is a good choice
> here.
> New patch attached.
>=20
> Thanks for the review.
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

> From db02ba3c33a4a1dbfcdc4de1b73e378f7b3d8925 Mon Sep 17 00:00:00 200=
1
> From: Hannes Reinecke <hare@suse.de>
> Date: Wed, 22 Sep 2010 12:09:07 +0200
> Subject: [PATCH] scsi_dh_alua: Handle all states correctly
>=20
> For ALUA we should be handling all states, independent of whether
> is explicit or implicit. For 'Transitioning' we should be retry
> for a certain amount of time; after that we're setting the port
> to 'Standby' and return SCSI_DH_RETRY to signal upper layers
> a retry is in order here.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: Mike Snitzer <snitzer@redhat.com>

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
