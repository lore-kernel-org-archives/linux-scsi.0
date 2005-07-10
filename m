From: Ben Collins <bcollins@debian.org>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sun, 10 Jul 2005 11:58:39 -0400
Message-ID: <20050710155839.GC14956@phunnypharm.org>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de> <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org> <20050710033431.GB13883@havoc.gtf.org> <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [206.246.247.150] ([206.246.247.150]:4324 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261963AbVGJP6n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 11:58:43 -0400
Content-Disposition: inline
In-Reply-To: <1121009100.5078.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

> The only possibility for a problem might be that the code you quote
> massages the MODE_SENSE data for every device, whereas the SCSI changes
> only do it for RBC devices ... are the devices reporting difficulties
> non-RBC?

Ah, this function wasn't in the patch:

static __inline__ int sbp2_command_conversion_device_type(u8 device_type)
{
        return (((device_type == TYPE_DISK) ||
                 (device_type == TYPE_SDAD) ||
                 (device_type == TYPE_ROM)) ? 1:0);
}

I didn't see that the scsi code made a distinction here. I thought it did
the conversion for all devices if use_10_for_{rw,ms} was set, and did the
fallback when it got ILLEGAL_REQUEST. Is there something in there that
will disable use_10_for_{rw,ms} if it's not TYPE_RBC?


Ok, I see something different in the MODE_SENSE:

drivers/scsi/scsi_lib.c(__scsi_mode_sense):1579

        memset(data, 0, sizeof(*data));
        memset(&cmd[0], 0, 12);
        cmd[1] = dbd & 0x18;    /* allows DBD and LLBA bits */
        cmd[2] = modepage;

For TYPE_RBC, scsi sets modepage to 6 (drivers/scsi/sd.c:1384), which is
normally 8 for all other devices.  However, the sbp2 translation did not
change the modepage:

	SBP2_DEBUG("Convert MODE_SENSE_6 to MODE_SENSE_10");

	new_cmd[0] = 0x5a;
	new_cmd[1] = cmd[1];
	new_cmd[2] = cmd[2];
	...

Looking the pre TYPE_RBC code, I can see that the modepage change wasn't
there, so sure enough we were using 8. Could this cause an
ILLEGAL_REQUEST, and thus disable use_10_for_{rw,ms}?

I'm starting to understand some of the code paths here. So before all of
this, TYPE_RBC was not recognized by the scsi layer as a "disk" type
device (which is why sbp2 forced TYPE_DISK for TYPE_RDC devices when
commands passed into the scsi layer).


-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
SwissDisk  - http://www.swissdisk.com/
