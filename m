From: "goggin, edward" <egoggin@emc.com>
Subject: RE: Mid-Layer handling of NOT READY conditions...
Date: Mon, 31 Jan 2005 09:07:37 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A734@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.lss.emc.com ([168.159.2.31]:26014 "EHLO
	mailhub.lss.emc.com") by vger.kernel.org with ESMTP id S261207AbVAaOHw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 09:07:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: 'EXT / DEVOTEAM VAROQUI Christophe' <ext.devoteam.varoqui@sncf.fr>

 

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of EXT / 
> DEVOTEAM VAROQUI Christophe
> Sent: Monday, January 31, 2005 4:46 AM
> To: 'linux-scsi@vger.kernel.org'
> Subject: Re: Mid-Layer handling of NOT READY conditions...
> 
> Hello,
> 
> a related discussion is ongoing in the multipath area.
> 
> Edward Goggin, EMC, noted a LU can be remapped anytime, by 
> way of an HBA
> recabling, or a LUN masking reconfiguration or a LU renaming. 
> If IO are
> queued to sda (LU id == 1234), sda goes unreachable (say 
> because of a cable
> unplug), when sda come back online it may not be 1234 anymore 
> but 4321.
> Requeuing the IO to sda will then silently corrupt 4321.
> 
> There needs to be a way to ask the HBA driver to error out 
> immediatly IO
> submitted to sda.
> Can you confirm a "timeout" driver module parameter set to 0 
> can bring us
> this behaviour ?
> 

Looks like the SCSI mid-layer may be already doing __most__ of the
"right thing" - but (1) the right thing isn't happening for EMC CLARiion
or Symmetrix logical units (maybe other storage also) because they are
not being treated as "removable" units by the mid-layer and (2) there
Does not seem to be any refresh of the cached inquiry data
(vendor/model/rev) in the mid-layer's scsi_device data structure.
Not clear to me if these storage systems should be setting the RMB
bit of the standard inquiry reply (which CLARiion and Symmetrix are
not doing) or if the linux SCSI mid-layer should just be treating all
SAN storage units as removable units, independent of the state of this bit.

The SCSI mid-layer (scsi_io_completion()) detects a SCSI sense key of
UNIT_ATTENTION after most any attempt to access the SCSI logical unit
With the "new" identity for the first time.  As long as the logical unit
is viewed as "removable" media, the most of right thing happens, namely,
the I/O in question is failed and the device is marked to prevent any
further I/O.  Apparently calling check_disk_change() from the next
sd_open() will at least clear the changed field of the scsi_device,
thereby allowing I/O to the device.  But, the cached inquiry fields
are not updated (possibly via scsi_probe_lun()) to reflect the
possibly new device identity.

> regards,
> cvaroqui
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
