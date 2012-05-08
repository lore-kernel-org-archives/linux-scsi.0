From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] dm mpath: add support for using previously attached
 scsi_dh
Date: Tue, 08 May 2012 08:22:27 +0200
Message-ID: <4FA8BBA3.3030705@suse.de>
References: <1336447147-3830-1-git-send-email-snitzer@redhat.com> <1336447147-3830-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab2EHGW3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 May 2012 02:22:29 -0400
In-Reply-To: <1336447147-3830-2-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com, babu.moger@netapp.com, sekharan@us.ibm.com, linux-scsi@vger.kernel.org

On 05/08/2012 05:19 AM, Mike Snitzer wrote:
> Use the previously attached scsi_dh if "default" is provided as the
> hardware handler name (the new 'use_default_hw_handler' flag is set i=
n
> the multipath structure).
>=20
> Leverage scsi_dh_attach's ability to increment the scsi_dh's referenc=
e
> count if the same scsi_dh name is provided when attaching -- currentl=
y
> attached scsi_dh name is determined with scsi_dh_attached_handler_nam=
e.
>=20
Not sure it that's the correct way.

Using 'default' as the hardware handler name has the drawback that
the original information (ie the original hardware handler name)
is lost.

So if there is no 'default', eg if the kernel module hasn't been
loaded, we wouldn't know which hardware handler to load.

I'd rather have a feature 'default_hw_handler' which then could be
passed into the kernel module. With that we would retain both, the
original implementation and the default case.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
