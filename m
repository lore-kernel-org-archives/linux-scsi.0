From: Eric Piel <eric.piel@tremplin-utc.net>
Subject: What should be done with wrong warning "please use bus_type methods."
 on sd, sr, st and osst?
Date: Mon, 24 Mar 2008 15:00:45 +0100
Message-ID: <47E7B40D.1000509@tremplin-utc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailservice.tudelft.nl ([130.161.131.5]:11578 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013AbYCXOAw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Mar 2008 10:00:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Cc: James.Bottomley@HansenPartnership.com, Tilman Schmidt <tilman@imap.cc>

Hello,

Since commit 751bf4d7865e4ced406be93b04c7436d866d3684 (scsi_sysfs: 
restore prep_fn when ULD is removed), the warning "Driver '%s' needs 
updating - please use bus_type methods." is generated for several scsi 
drivers (sr, sg, st and osst). It does so because it thinks that the 
driver remove() functions will not be called (cf 
__device_release_driver()). Actually, they are called by scsi_bus_remove().

This has been noted already a couple of times [1] [2] [3], but it seems 
absolutely nothing conclusive came out of the reports.

What should be done? Delete the warning? Change it so it doesn't get 
triggered if drv->bus->remove == scsi_bus_remove? Merge 
scsi_bus_remove() into the driver remove() functions? Disregard the 
monthly warming reports?

Eric

[1] http://lkml.org/lkml/2008/1/10/47
[2] http://lkml.org/lkml/2008/2/20/547
[3] http://lkml.org/lkml/2008/3/22/198
