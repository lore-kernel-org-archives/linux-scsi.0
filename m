From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] aic79xx: fix deadlock & cleanup
Date: Tue, 07 Feb 2006 08:51:20 +0100
Message-ID: <43E85178.5020709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:61874 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932450AbWBGHv2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 02:51:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: "emmanuel.fuste" <emmanuel.fuste@laposte.net>

Hi all,

this patchset cleans up the aic79xx drivers.
- Convert qfrozen count to atomic_t type.
  The qfrozen count is the low-level equivalent to the scsi-ml
  scsi_block_requests. Converting it to atomic_t gets rid of
  the ahd_lock / ahd_unlock and thereby removes some deadlocks
  in the recovery code.
- use scsi-ml tcq functions.
  SCSI-Ml already provides some tcq funtions, so we might as well
  use them.
- remove dead code
  Removing some dead code which have been left over.

The first patch should fix the deadlocks people were seeing during
recovery. Emmanuel, could you test them whether your problem is resolve=
d
(and ignoring the 'overlapped command error handling', as this patchset
replaces it).

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
