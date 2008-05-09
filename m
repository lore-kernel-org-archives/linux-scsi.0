From: Hannes Reinecke <hare@suse.de>
Subject: [RESEND] [PATCH 0/5] scsi_dh framework update
Date: Fri, 9 May 2008 11:38:49 +0200
Message-ID: <20080509093848.GC24546@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbYEIJiv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 May 2008 05:38:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

Hi James,

this is a repost of my patchset to update the scsi_dh infrastructure.

It's now based on the current scsi-misc tree and includes some
bugfixes:
- A typo in the ALUA prep_fn function
- Fixed a request leak; none of the scsi_dh handler do a
  blk_put_request() currently.
- Made the comments kernel-doc compliant.
- Added two new return codes SCSI_DH_DEV_NOTSUPP and
  SCSI_DH_SENSE_AVAIL.

Main features of the updates are:
- Use a single callback for the notifier chain
- Merge all device maps into a single list,
  which will be scanned by a generic function
- Add a sysfs attribute 'dh_state' for each sdev
- Add a generic SPC-3 ALUA handler
- Update device handlers to check if the
  device actually supports this handler.
  When attaching manually we are able to attach
  to basically any device, so we have to make sure
  that the device handler is actually supported.

Two issues are still outstanding:
- Argument passing to the device handler:
  Some device handler have options which cannot
  be determined automatically. We need to be
  able to pass these argument down from the
  device-mapper layer.
- Update the RDAC device handler to attach
  only to devices supporting RDAC.
  Chandra, your call :-)

As per usual, comment etc are welcome.

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
