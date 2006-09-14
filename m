From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] libsas: move ATA bits into a separate module
Date: Wed, 13 Sep 2006 17:21:54 -0700
Message-ID: <4508A0A2.2080605@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:51851 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751257AbWINAV4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Sep 2006 20:21:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>

Hi all,

Per James Bottomley's request, I've moved all the libsas SATA support
code into a separate module, named sas_ata.  To satisfy his further
requirement that libsas not require libata (and vice versa), ata_sas
maintains fixed function pointer tables to various required functions
within libsas and libata.  Unfortunately, this means that libsas and
libata both require sas_ata, but sas_ata is smaller than libata.
Unloads of libata/libsas at inopportune moments are prevented by
increasing the refcounts on both modules whenever libsas detects a SATA
device (and decreasing it when the device goes away, of course).  If the
module is removed from the .config, then all of hooks into libsas/libata
should go away.

This is a rough-cut at separating out the ATA code; please let me know
what I can improve.  At the moment, I can load and talk to SATA disks
with the module enabled, as well as watch nothing happen if the module
is not config'd in.

The patch is a bit large, so here's where it lives:
http://sweaglesw.net/~djwong/docs/sas-ata_2.patch

Thanks for any feedback that you can provide!

--D

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
