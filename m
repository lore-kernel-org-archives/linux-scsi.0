From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/8] Rework SCSI target allocation
Date: Tue, 18 Mar 2008 14:28:09 +0100
Message-ID: <47DFC369.3010406@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:42871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbYCRN2L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2008 09:28:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

this is the patchset I talked about at LSF'08. The main idea
here is to align the SCSI target allocation code with the driver
core. For this I've done several things:

- Move all SCSI objects into the SCSI bus: the sysfs 'scsi'
  bus now contains all SCSI midlayer objects, equivalent
  to the 'usb' bus
- Use default attribute groups for SCSI hosts: with the
  all attributes are present when the sysfs dirent is
  created; we don't have to wait for them anymore
- Move target cleanup code to the release function.
  We only should cleanup the SCSI target structure once
  the last reference is gone, hence all cleanup has to
  be done from the release function
- Remove reap_ref and sanitize calls to scsi_target_reap:
  _Every_ target has at least one sdev connected to it;
  once the last sdev is gone the target will be deleted, too.
  So we can as well call scsi_target_reap from the release
  function of the sdev, hereby ensuring that the target
  will _always_ be valid during the lifetime of the sdev.

There is only one driver-related fix:
lpfc and qla2xxx re-use the existing 'state' host attribute
to fill it with some link details. This really is an abuse
IMO as it differs from all other SCSI host attributes.
Hence I've renamed the attribute to 'link_state' to make
it more obvious what's going on. But obviously I'd need
the ACK from the maintainers for this.

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
