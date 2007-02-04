From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 00/12] Roll-up of sas_ata patches
Date: Sun, 04 Feb 2007 01:21:05 -0800
Message-ID: <45C5A581.1070504@us.ibm.com>
References: <200701300915.l0U9FuPu010198@d01av04.pok.ibm.com> <1170541934.3345.69.camel@mulgrave.il.steeleye.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35225 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXBDJVL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Feb 2007 04:21:11 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l149LAGk019467
	for <linux-scsi@vger.kernel.org>; Sun, 4 Feb 2007 04:21:10 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l149L9mS294252
	for <linux-scsi@vger.kernel.org>; Sun, 4 Feb 2007 04:21:09 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l149L9et009226
	for <linux-scsi@vger.kernel.org>; Sun, 4 Feb 2007 04:21:09 -0500
In-Reply-To: <1170541934.3345.69.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

James Bottomley wrote:

> There's a problem somewhere with your error handler changes (which I
> picked up thanks to the problems with the V28 firmware).  What I see
> without your changes is that for a directly attached SATA device, when
> the firmware begins its death spiral, the commands all return and
> eventually send I/O errors to the filesystem,  With your patch series
> applied, it just loops forever giving messages like:
> 
> Feb  3 12:07:06 localhost kernel: aic94xx: escb_tasklet_complete: phy5: LINK_RESET_ERROR
> Feb  3 12:07:06 localhost kernel: aic94xx: phy5: Receive FIS timeout
> Feb  3 12:07:06 localhost kernel: aic94xx: phy5: retries:0 performing link reset seq
> Feb  3 12:07:06 localhost kernel: sas: --- Exit sas_scsi_recover_host
> Feb  3 12:07:06 localhost kernel: aic94xx: control_phy_tasklet_complete: phy5, lrate:0x8, proto:0xe
> Feb  3 12:07:06 localhost kernel: sas: Enter sas_scsi_recover_host
> Feb  3 12:07:06 localhost kernel: sas: --- Exit sas_scsi_recover_host
> Feb  3 12:07:06 localhost kernel: sas: Enter sas_scsi_recover_host
> Feb  3 12:07:06 localhost kernel: sas: --- Exit sas_scsi_recover_host
> Feb  3 12:07:06 localhost kernel: sas: Enter sas_scsi_recover_host
> Feb  3 12:07:06 localhost kernel: sas: --- Exit sas_scsi_recover_host

Interesting, since the opposite happens with SAS disks. :)

The infinite loop is usually what happens if a scsi_cmnd gets pulled off
the eh queue without being scsi_eh_finish_cmnd()'d.  Can you send me the
whole dmesg?  It's possible that we're trying to abort a command, which
of course fails for a SATA disk, so we try bigger and bigger hammers....
and the big hammers don't call scsi-eh-finish-cmd.

Did these SATA link reset errors only start showing up after the v28
firmware patch, or has this always happened?  I've noticed lately that I
get link reset errors if I run a short exercise on an ext3 filesystem on
a SATA disk, yet dd exercise runs just fine.  But I had also thought
that it was just my flaky hardware. :)

--D
