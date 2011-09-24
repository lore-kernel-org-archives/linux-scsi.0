From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] libsas: fix warnings when checking sata/stp protocol
Date: Fri, 23 Sep 2011 18:09:11 -0700
Message-ID: <20110924010830.5292.26480.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48798 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab1IXBJM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Sep 2011 21:09:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Xiangliang Yu <yuxiangl@marvell.com>, Jack Wang <jack_wang@usish.com>

Several sas drivers legitimately check the protocol against the union o=
f
SAS_PROTOCOL_SATA and SAS_PROTOCOL_STP.  Provide a SAS_PROTOCOL_STP_ALL
to silence warnings like:

drivers/scsi/pm8001/pm8001_sas.c:438:3: warning: case value =E2=80=985=E2=
=80=99 not in enumerated type =E2=80=98enum sas_protocol=E2=80=99 [-Wsw=
itch]
drivers/scsi/mvsas/mv_sas.c:798:2: warning: case value =E2=80=985=E2=80=
=99 not in enumerated type =E2=80=98enum sas_protocol=E2=80=99 [-Wswitc=
h]
drivers/scsi/mvsas/mv_sas.c:1783:2: warning: case value =E2=80=985=E2=80=
=99 not in enumerated type =E2=80=98enum sas_protocol=E2=80=99 [-Wswitc=
h]
drivers/scsi/mvsas/mv_sas.c:1886:2: warning: case value =E2=80=985=E2=80=
=99 not in enumerated type =E2=80=98enum sas_protocol=E2=80=99 [-Wswitc=
h]
drivers/scsi/isci/request.c:3565:2: warning: case value =E2=80=985=E2=80=
=99 not in enumerated type =E2=80=98enum sas_protocol=E2=80=99 [-Wswitc=
h]

Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Jack Wang <jack_wang@usish.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/scsi/sas.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index 9038d40..3a00297 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -108,6 +108,7 @@ enum sas_protocol {
 	SAS_PROTOCOL_STP		=3D 0x04,
 	SAS_PROTOCOL_SSP		=3D 0x08,
 	SAS_PROTOCOL_ALL		=3D 0x0E,
+	SAS_PROTOCOL_STP_ALL		=3D SAS_PROTOCOL_STP|SAS_PROTOCOL_SATA,
 };
=20
 /* From the spec; local phys only */

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
