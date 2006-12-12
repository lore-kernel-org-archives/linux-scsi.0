From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v2] libata: Simulate REPORT LUNS for ATAPI devices
Date: Tue, 12 Dec 2006 14:24:28 -0800
Message-ID: <457F2C1C.1030503@us.ibm.com>
References: <4574A90E.5010801@us.ibm.com> <4574AB78.40102@garzik.org>	<4574B004.6030606@us.ibm.com>  <457D8637.5070707@garzik.org> <1165855489.2791.7.camel@mulgrave.il.steeleye.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:35299 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbWLLWYc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2006 17:24:32 -0500
In-Reply-To: <1165855489.2791.7.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Douglas Gilbert <dougg@torque.net>

James Bottomley wrote:

> I thought we were closing in on agreeing that the SPC/MMC
> inconsistencies made this the correct candidate fix.

I tried out the patch below, but with it applied, SCSI still issues
REPORT LUNS to the device.  It seems that sdev->type = -1 and bflags = 0
when scsi_get_device_flags is called because the type code is not set up
until scsi_add_lun, which is called later.  In any case, the check
doesn't work for me because the SATAPI GoVault reports itself as a
Direct Access device, not a CD-ROM.

> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
<snip>
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
<empty>

Was there supposed to be more to this patch?

--D
