From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 00/12] Roll-up of sas_ata patches
Date: Sat, 03 Feb 2007 16:32:14 -0600
Message-ID: <1170541934.3345.69.camel@mulgrave.il.steeleye.com>
References: <200701300915.l0U9FuPu010198@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43317 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751749AbXBCWcl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Feb 2007 17:32:41 -0500
In-Reply-To: <200701300915.l0U9FuPu010198@d01av04.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

On Tue, 2007-01-30 at 04:15 -0500, Darrick J. Wong wrote:
> This is a roll-up of all of my ATA related uncommitted patches against
> libsas and aic94xx to date.  Per James Bottomley's request, I'm pushing
> these patches out for further review in aic94xx-sas.  The big changes in
> this patch set are a lot of bug and locking fixes, the conversion of the
> EH routines to interact with the SAS EH strategy routines, and of course
> the separation of the SATL code into a separate module.
> 
> These patches should apply in number order cleanly against 2.6.20-rc6 +
> scsi_misc + scsi-rc-fixes + aic94xx-sas.  They've been fairly well tested
> on a bunch of SATA disks in a x206m, though the ATAPI support is not so
> well tested.  However, I have run these patches in other loads for a while.
> Hopefully these patches are ready for more widespread testing in
> scsi-misc, and thank you for any comments or feedback that you provide.
> 
> (Apologies for any stgit mail misconfiguration on my part.)

There's a problem somewhere with your error handler changes (which I
picked up thanks to the problems with the V28 firmware).  What I see
without your changes is that for a directly attached SATA device, when
the firmware begins its death spiral, the commands all return and
eventually send I/O errors to the filesystem,  With your patch series
applied, it just loops forever giving messages like:

Feb  3 12:07:06 localhost kernel: aic94xx: escb_tasklet_complete: phy5: LINK_RESET_ERROR
Feb  3 12:07:06 localhost kernel: aic94xx: phy5: Receive FIS timeout
Feb  3 12:07:06 localhost kernel: aic94xx: phy5: retries:0 performing link reset seq
Feb  3 12:07:06 localhost kernel: sas: --- Exit sas_scsi_recover_host
Feb  3 12:07:06 localhost kernel: aic94xx: control_phy_tasklet_complete: phy5, lrate:0x8, proto:0xe
Feb  3 12:07:06 localhost kernel: sas: Enter sas_scsi_recover_host
Feb  3 12:07:06 localhost kernel: sas: --- Exit sas_scsi_recover_host
Feb  3 12:07:06 localhost kernel: sas: Enter sas_scsi_recover_host
Feb  3 12:07:06 localhost kernel: sas: --- Exit sas_scsi_recover_host
Feb  3 12:07:06 localhost kernel: sas: Enter sas_scsi_recover_host
Feb  3 12:07:06 localhost kernel: sas: --- Exit sas_scsi_recover_host
....

James


