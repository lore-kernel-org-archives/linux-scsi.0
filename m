From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler modules automatically
 inserted
Date: Wed, 18 Mar 2009 12:31:39 +0100
Message-ID: <49C0DB9B.2010105@suse.de>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59897 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbZCRLbr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 07:31:47 -0400
In-Reply-To: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

Hi Chandra,

Chandra Seetharaman wrote:
> Hello,
>=20
> Currently, SCSI targets doesn't have modalias support. It wasn't an i=
ssue
> until SCSI device handler came along.
>=20
> We want the SCSI device handler modules to be insmodded automatically
> when the specific SCSI targets are probed and found.
>=20
> This set of patches adds the modalias support for SCSI targets and
> also makes the relevant changes to SCSI device handler modules to=20
> make use of it.
>=20
> Applies cleanly on 2.6.29-rc8 and is tested on the same.
>=20
> Please review and consider this for 2.6.30.
>=20
> Thanks & Regards,
>=20
> chandra
>=20
Well, agreed in principle. But do note that ALUA handling really
isn't supported well here.

Problem is that ALUA hooks off a different setting (namely the
'TGPS' bit in the inquiry data) and _not_ on the device name.
In fact, it's well possible to support _both_, old-style
proprietary failover and ALUA.

So to handle this properly we should be adding a 'tgps'
setting to the sysfs data and use this for ALUA keying.
With that we basically can get rid of the device table
in ALUA and live happily ever after.

I'll be posting a patch for this shortly.
We really should be integrating both of them, as
the proposed modalias support is a Good Thing (tm).

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
