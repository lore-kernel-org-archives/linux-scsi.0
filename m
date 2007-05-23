From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/9] Resurrect sdev during scanning
Date: Wed, 23 May 2007 10:53:21 +0200
Message-ID: <46540101.8060608@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:34947 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757277AbXEWIxW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 04:53:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

this is a patchset to address the outstanding 'sdev oops during
scanning' issue. Problem is that any sdev in state 'SDEV_DEL' is still
visible to the host until the refcount drops to zero. When a scan occur=
s
during this time we access a half-initialized sdev and all hell breaks
loose.

So to address this issue this patchset implements a
'scsi_resurrect_device()' function which will put an sdev in state
SDEV_DEL back to SDEV_RUNNING, thus allowing normal operations again.
In doing so I also had to clean up the sdev allocation and removal a bi=
t
so that we're now more aligned to the state machine and the driver
core's device_initialize / device_add logic.

The entire patchset has been tested quite heavily with SLES10 SP1.

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
