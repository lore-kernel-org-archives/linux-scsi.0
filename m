From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 0/7] scsi_sgtable implementation
Date: Thu, 05 Jul 2007 14:51:24 +0300
Message-ID: <468CDB3C.4060500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10463 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754191AbXGEMGq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 08:06:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

 This is a proposed implementation of the scsi sg tables
 solution to scsi-ml in preparations for support of
 bidirectional scsi commands.

 A complete bidirectional solution on top of these patches
 can be found in the usual place:
 http://www.bhalevy.com/open-osd/download/sgtable_bidi_varlen

 It would be best if these patches can be accepted into Morton's
 tree as soon as the open window for 2.6.23. So it can be tested
 as much as possible before actually getting accepted into
 scsi-misc and eventually into the kernel. The reason I say
 that is because there is a small but scary difference between
 scsi-ml with accessors over old code and accessors over new
 sg-tables code. And that is the absence of the IO members in
 the case of a DMA_NONE transfer. An un-careful coding can trip
 on it. OK I admit the chances are slim but exist.

 The code is kept backward compatible with unconverted drivers
 all the way up to the last patch. So it can be run and tested
 with some drivers unconverted. Applying the last patch will
 remove compatibility.

 [patch 1/8] stex driver BROKEN
   Once patch 2/8 is applied this driver will no longer compile.
   So here I comment out some code. The maintainer of this driver
   said that driver will be fixed soon enough in the proper manner.

 [patch 2/8] Restrict scsi accessors access to read-only
   This patch should be accepted now. Even into 2.6.23.
   The rest of the patches are dependent on it.

 [patch 3/8] libata-scsi don't set max_phys_segments higher than scsi-ml
   Also this one is relevant now. But once scsi_sgtable is used sata
   will stop working without this one.

 [patch 4/8] RFC scsi-ml: scsi_sgtable implementation
   This is the actual patch for review. Please see comments
   inside and than fire away ...
   (With old code so not to let diff make a mess)

 [patch 5/8] Remove old code from scsi_lib.c
   For easier viewing old code is removed in second patch

 [patch 6/8] RFC scsi_error.c move to sg_table implementation
   Logically belongs to 4/8. Kept separate for easier review.

 [patch 7/8] sd.c and sr.c move to scsi_sgtable implementaion
   And these too.

 [patch 8/8] Remove compatibility with unconverted drivers
   Once this patch is applied any unconverted files will not
   compile.


Free Life
Boaz

