From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/11] Take #2: Resurrect sdev during scanning
Date: Mon, 18 Jun 2007 11:00:45 +0200
Message-ID: <467649BD.7040206@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbXFRJAq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jun 2007 05:00:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

this is a rework of my earlier patchset to address the outstanding 'sde=
v
oops during scanning' issue. Problem is that any sdev in state
'SDEV_DEL' is still visible to the host until the refcount drops to
zero. When a scan occurs during this time we access a half-initialized
sdev and all hell breaks loose.

To address this issue this patchset expands the sdev state-machine to
allow a transition from SDEV_DEL back to SDEV_RUNNING. This is
implemented in the function scsi_resurrect_device(). So during scan we
only have to make sure to call scsi_resurrect_device() on all sdevs as
this will guarantee us that the sdev is operational during scanning.

In order to do so I reworked the sdev allocation and removal so that
we're more aligned with the sdev state machine and the driver core's
device_initialize / device_add logic.

Additionally I have expanded the state machine even more by introducing
a SDEV_NEW state, which will transition into SDEV_CREATED once
slave_alloc() is run.  This will allow us to detect from within the
->release function whether slave_destroy() should be called.
With this we don't have to modify any LLDD, thus addressing the issue
hch had with the earlier patchset.

Comments etc. welcome.

Otherwise, please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
