From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] aic7xxx/aic79xx fixes
Date: Mon, 23 Oct 2006 15:17:59 +0200
Message-ID: <453CC107.2050300@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:16842 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S964801AbWJWNSB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Oct 2006 09:18:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

I've prepared a new patchset for aic7xxx/aic79xx updates. They mostly=20
bring aic7xxx & aic79xx in sync again; additionally there is one bugfix
for aic79xx which fixes external device reset handling (see also the=20
recent thread about this).

Patches en detail:

- Fixup external device reset handling for aic79xx: We really should
   take care to not confuse the SCSI bus upon external device reset. Th=
e
   fix is actually taken from the original adaptec sources. Kudos to
   Justin Gibbs and Luben Tuikov for this.
- Fixup precompensation for aic79xx: precompensation is actually handle=
d
   by a separate iocell chip. We should take care to update the chip
   according to the DV setting.
- Remove slave_alloc for aic7xxx: Running on a multi-initator bus I
   still see BUG_ON() in slave_alloc for aic7xxx. And as it already has
   been removed from aic79xx we can use the same logic here, too.
- Print out signalling for aic79xx: As aic7xxx has the sysfs entry we
   can as well add it to aic79xx. We don't have HVD but still can
   distinguish between SE and LVD.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
