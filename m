From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/7] scsi_dh framework update take #2
Date: Tue, 20 May 2008 16:04:27 +0200
Message-ID: <4832DA6B.3050702@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:33640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbYETOE3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 10:04:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

Hi James,

this is the second repost of my patchset to update the scsi_dh
infrastructure. It includes the comments by Chandra.

It's based on the current scsi-misc tree.

Main features of the patchset are:
- Use a single callback for the notifier chain
- Merge all device maps into a single list,
 which will be scanned by a generic function
- Add a sysfs attribute 'dh_state' for each sdev
- Add a generic SPC-3 ALUA device handler
- Update device handlers to check if the
 device actually supports this handler.
 When attaching manually we are able to attach
 to basically any device, so we have to make sure
 that the device handler is actually supported.
- Manually attach a device when a hardware handler
 is specified; this allows multipath to override
 the built-in hardware table.
- Update dm-multipath to explicitly attach to
 the specified device handler. This allows
 overriding of the built-in table by the
 multipath values.

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
