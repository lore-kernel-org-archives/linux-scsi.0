From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] FW: USB 2.0 external hard drive problem
Date: 06 Feb 2004 10:24:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076081067.1823.5.camel@mulgrave>
References: <Pine.LNX.4.44L0.0402060946350.830-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:15334 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265476AbUBFPYt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2004 10:24:49 -0500
In-Reply-To: <Pine.LNX.4.44L0.0402060946350.830-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Joerg Schilling <schilling@fokus.fraunhofer.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, magliery@csb.yale.edu, appro@fy.chalmers.se, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2004-02-06 at 09:59, Alan Stern wrote:
> Who says it's wrong to retrieve sense information when there is an
> underrun but not Check Condition?  Can you provide a reference to a
> published (or draft) document that states this?

It's not wrong according to the SCSI standards, a REQUEST SENSE issued
to a device with no sense data will produce a NO SENSE key.

However, because of the way sense is processed in contingent allegiance
conditions (suspending the I_T_L nexus until sense is cleared) it is
dangerous to issue arbitrary request sense commands because you may
receive sense for a different command (and prevent that command from
erroring correctly).

The SCSI mid-layer definitely does not expect this behaviour.  A driver
either does not do any sense commands at all or it only issues a REQUEST
SENSE in response to a Check Condition status in order not to have the
nexus halted because of a contingent allegiance condition (simulating
ACA if you will).

James


