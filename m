From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Date: Wed, 29 Jul 2009 14:11:14 +0300
Message-ID: <20090729111114.GA15239@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:32857 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbZG2LMR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 07:12:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

scsi/scsi.h is exported to userspace, so it should
use __u8 instead of u8 as other userspace-visible headers do.

This fixes the following errors when application includes scsi/scsi.h
generated with make headers_install:
include/scsi/scsi.h:145: error: expected specifier-qualifier-list befor=
e =E2=80=98u8=E2=80=99
include/scsi/scsi.h: In function =E2=80=98scsi_varlen_cdb_length=E2=80=99=
:
include/scsi/scsi.h:156: error: =E2=80=98struct scsi_varlen_cdb_hdr=E2=80=
=99 has no member named =E2=80=98additional_cdb_length=E2=80=99

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/scsi/scsi.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 084478e..dfcfaab 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -142,10 +142,10 @@ struct scsi_cmnd;
=20
 /* defined in T10 SCSI Primary Commands-2 (SPC2) */
 struct scsi_varlen_cdb_hdr {
-	u8 opcode;        /* opcode always =3D=3D VARIABLE_LENGTH_CMD */
-	u8 control;
-	u8 misc[5];
-	u8 additional_cdb_length;         /* total cdb length - 8 */
+	__u8 opcode;        /* opcode always =3D=3D VARIABLE_LENGTH_CMD */
+	__u8 control;
+	__u8 misc[5];
+	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
 };
--=20
1.6.2.5
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
