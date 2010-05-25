From: Hannes Reinecke <hare@suse.de>
Subject: [LFS/VM TOPIC] Barriers and SYNCHRONZIE_CACHE
Date: Tue, 25 May 2010 13:00:57 +0200
Message-ID: <4BFBADE9.4060904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52296 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485Ab0EYLA7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 May 2010 07:00:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf10-pc@lists.linuxfoundation.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

[Topic]
Barriers and SYNCHRONIZE CACHE

[Abstract]
In recent years some design flaws in the barriers implementation
became apparent:
- No indication about _which_ blocks to flush, so all outstanding
  blocks are flushed
- No error handling for SYNCHRONIZE CACHE
- SYNCHRONIZE CACHE affects all I/Os, so if a LUN is used by
  several virtual guests _all_ guests are affected
- SYNCHRONIZE CACHE has a rather severe performance impact
  on RAID controllers (if executed directly)

To overcome these issues I would propose to modify the
barrier interface so that individual blocks can be
marked as 'flushing'/'immediate'. This would allow
the lower layers (eg. SCSI midlayer) to restrict
the barriers operation on the affected blocks only.
EG the SYNCHRONIZE_CACHE operation could be updated
with a block list. Or more advanced methods (like FUA
or tagging) could be used, avoiding the need to issue
a SYNCHRONIZE CACHE altogether.

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
