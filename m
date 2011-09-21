From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: RE: [PATCH 2/5] libsas: fix ->change_queue_{depth|type} for sata devices
Date: Wed, 21 Sep 2011 05:27:36 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A9018AE1E1@XYUS-EX22.xyus.xyratex.com>
References: <20110920220819.1094.12265.stgit@localhost6.localdomain6> <20110920221024.1094.58367.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20110920221024.1094.58367.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: jgarzik@pobox.com, JBottomley@parallels.com, Jack Wang <jack_wang@usish.com>, Tejun Heo <tj@kernel.org>, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

Good Stuff

-----Original Message-----
From: Dan Williams [mailto:dan.j.williams@intel.com] 
Sent: Tuesday, September 20, 2011 6:11 PM
To: linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org
Cc: jgarzik@pobox.com; JBottomley@parallels.com; Jack Wang; Tejun Heo;
Xiangliang Yu; Mark Salyzyn
Subject: [PATCH 2/5] libsas: fix ->change_queue_{depth|type} for sata
devices

Pass queue_depth change requests to libata, and prevent queue_type
changes for ATA devices.

Otherwise:
1/ we do not honor the libata specific restrictions on the queue depth
2/ libsas drivers that do not set sdev->tagged_supported are unable to
   change the queue_depth of ata devices via sysfs

Cc: Tejun Heo <tj@kernel.org>
Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Jack Wang <jack_wang@usish.com>
Cc: Mark Salyzyn <msalyzyn@us.xyratex.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/ata/libata-core.c           |    1 +
 drivers/ata/libata-scsi.c           |   44
+++++++++++++++++++++++------------
 drivers/scsi/libsas/sas_scsi_host.c |   11 ++++++++-
 include/linux/libata.h              |    2 ++
 4 files changed, 42 insertions(+), 16 deletions(-)
______________________________________________________________________
This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
 
Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
 
Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 
The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
______________________________________________________________________
 


