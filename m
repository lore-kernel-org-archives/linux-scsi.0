From: Mikael Pettersson <mikpe@it.uu.se>
Subject: UltraStar fails detection with "Unsupported sector size 524"
Date: Sun, 12 Sep 2010 19:30:45 +0200
Message-ID: <19597.3653.893156.794645@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fanny.its.uu.se ([130.238.4.241]:54497 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab0ILRas (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Sep 2010 13:30:48 -0400
Received: from fanny.its.uu.se (localhost [127.0.0.1])
	by fanny.its.uu.se (Postfix) with ESMTP id A7C486296
	for <linux-scsi@vger.kernel.org>; Sun, 12 Sep 2010 19:30:46 +0200 (MSZ)
Received: from pilspetsen.it.uu.se (pilspetsen.it.uu.se [130.238.18.39])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by fanny.its.uu.se (Postfix) with ESMTP id 6789C6214
	for <linux-scsi@vger.kernel.org>; Sun, 12 Sep 2010 19:30:46 +0200 (MSZ)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I got a bunch of 72G IBM UltraStars that were taken from some
kind of IBM storage server.  The Linux kernel however doesn't
like them, complaining about a non-512 byte sector size:

scsi 0:0:1:0: Direct-Access     IBM      IC35L073UCDY10-0 S27N PQ: 0 ANSI: 3
scsi target0:0:1: tagged command queuing enabled, command queue depth 16.
scsi target0:0:1: Beginning Domain Validation
scsi target0:0:1: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 8)
scsi target0:0:1: Domain Validation skipping write tests
scsi target0:0:1: Ending Domain Validation
sd 0:0:1:0: [sdb] Unsupported sector size 524.

(that's from the 2.6.35 kernel's SYM53C8XX_2)

According to the datasheets these drives have soft-configurable
sector sizes from 512 up to 528 bytes, but they don't say how
that configuration is done.

Any ideas on how to reconfigure these drives for 512-byte sectors?

/Mikael
