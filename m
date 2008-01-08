From: Ethan Burns <eaburns@iol.unh.edu>
Subject: Size of SCSI READ_10 commands
Date: Tue, 8 Jan 2008 15:30:32 -0500
Message-ID: <20080108203032.GA22448@postal.iol.unh.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postal.iol.unh.edu ([132.177.123.84]:46247 "EHLO
	postal.iol.unh.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYAHUfn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 15:35:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Robert D. Russell" <rdr@postal.iol.unh.edu>

Hello,
	I am working on a project with the University of New Hampshire
iSCSI initiator and target modules.  I am seeing an issue with the
SCSI commands that are being given to the initiator side.  We register
the initiator as a SCSI device with max_sectors=1024 in the host
template.  When I do a read from the /dev/sda file (which corresponds to
the UNH-iSCSI initiator) I am seeing that the SCSI READ_10 commands given
to the initiator device are getting split into awkward sizes.

I would expect that all of the READ_10s would have the size 524288 (1024 * 512)
bytes, since we specify a maximum of 1024 sectors.  The largest READ_10s
that I see, however, are 262144 bytes in length (512 * 512) (scsi
WRITE_10 commands seem to properly be sized to 524288 bytes).  In
addition to this, a large number of these seem to be ``split'' into
two READ_10s (one for 4096 bytes followed by another for 258048 bytes).
These split reads are causing problems because of the extra overhead
involved in doing a separate transaction for only 4096 bytes of data.

Is anyone familiar with this issue?  Does anyone know why the read
commands would be getting split like this?  Is it possible that there is a
parameter that I am setting incorrectly in my host template?


Any help would be greatly appreciated.  Please reply to all, or CC me on
any response, I am not subscribed to this list.


Thanks,
Ethan Burns
