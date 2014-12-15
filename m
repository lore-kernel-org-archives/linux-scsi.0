From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM TOPIC] Integrated Unit Attention handling
Date: Mon, 15 Dec 2014 16:17:43 +0100
Message-ID: <548EFB97.2080501@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbaLOPRp (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2014 10:17:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

Hi all,

I'd like to discusss 'Integrated Unit Attention handling' at LSF/MM
2015.

Currently we're interpreting some Unit Attention codes and send out
uevents, with the hope that some userspace application will make use
of this.
However, some UAs are easily handled within the kernel directly, eg

- REPORT LUN DATA CHANGED: this could easily trigger a rescan of the
  scsi host driving that LUN.
- INQUIRY DATA CHANGED: Rescan the VPD pages and INQUIRY data itself

When implementing such an integrated UA handling, however, we would
need to revisit the design choice of having the inquiry data fixed
to struct scsi_device. Currently any modification to the inquiry
data requires a complete device removal; this is not really feasible
for integrated event handling.

I'd like to discuss if such an integrated UA handling is desirable
and, if so, if devices should become flexible to have the inquiry
data changed on the fly.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
