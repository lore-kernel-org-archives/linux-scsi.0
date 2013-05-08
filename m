From: "lindar_liu" <lindar_liu@usish.com>
Subject: RE: [PATCH] sas: unify the pointlessly separated enums sas_dev_type and sas_device_type
Date: Wed, 8 May 2013 09:50:12 +0800
Message-ID: <007301ce4b8e$63b441c0$2b1cc540$@com>
References: <1367963046.4108.25.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:42006 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab3EHCBH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 May 2013 22:01:07 -0400
In-Reply-To: <1367963046.4108.25.camel@dabdike>
Content-Language: zh-cn
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>
Cc: 'Lukasz Dorau' <lukasz.dorau@intel.com>, 'Maciej Patelczyk' <maciej.patelczyk@intel.com>, 'Dave Jiang' <dave.jiang@intel.com>, xjtuwjp@gmail.com, 'Xiangliang Yu' <yuxiangl@marvell.com>

Thanks for fix.

Lindar.

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Wednesday, May 08, 2013 5:44 AM
To: linux-scsi
Cc: Lukasz Dorau; Maciej Patelczyk; Dave Jiang; xjtuwjp@gmail.com;
lindar_liu@usish.com; Xiangliang Yu
Subject: [PATCH] sas: unify the pointlessly separated enums sas_dev_type and
sas_device_type

These enums have been separate since the dawn of SAS, mainly because the
latter is a procotol only enum and the former includes additional state for
libsas.  The dichotomy causes endless confusion about which one you should
use where and leads to pointless warnings like this:

drivers/scsi/mvsas/mv_sas.c: In function 'mvs_update_phyinfo':

drivers/scsi/mvsas/mv_sas.c:1162:34: warning: comparison between 'enum
sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]

Fix by eliminating one of them.  The one kept is effectively the sas.h one,
but call it sas_device_type and make sure the enums are all properly
namespaced with the SAS_ prefix.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---


