From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: RE: [PATCH 1/5] libsas: disable scanning lun > 0 on ata devices
Date: Wed, 21 Sep 2011 05:28:07 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A9018AE1E2@XYUS-EX22.xyus.xyratex.com>
References: <20110920220819.1094.12265.stgit@localhost6.localdomain6> <20110920221008.1094.34064.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:37302 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753384Ab1IUMfo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Sep 2011 08:35:44 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20110920221008.1094.34064.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Luben Tuikov <ltuikov@yahoo.com>, jgarzik@pobox.com, JBottomley@parallels.com, Jack Wang <jack_wang@usish.com>, Xiangliang Yu <yuxiangl@marvell.com>, Darrick Wong <djwong@us.ibm.com>

Good Stuff

-----Original Message-----
From: Dan Williams [mailto:dan.j.williams@intel.com] 
Sent: Tuesday, September 20, 2011 6:10 PM
To: linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org
Cc: Luben Tuikov; jgarzik@pobox.com; JBottomley@parallels.com; Jack
Wang; Xiangliang Yu; Mark Salyzyn; Darrick Wong
Subject: [PATCH 1/5] libsas: disable scanning lun > 0 on ata devices

Currently mvsas and pm8001 have custom ->slave_alloc implementations to
achieve this.  Uplevel it for all libsas drivers as isci encounters
problems
with atapi devices when scanning past lun0.

Just do what Darrick suggested [1], and limit the scan for ata devices.

[1] http://marc.info/?l=linux-scsi&m=116604101119861&w=2

Cc: Darrick Wong <djwong@us.ibm.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Jack Wang <jack_wang@usish.com>
Cc: Mark Salyzyn <msalyzyn@us.xyratex.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/scsi_transport_sas.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)
______________________________________________________________________
This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
 
Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
 
Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 
The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
______________________________________________________________________
 


