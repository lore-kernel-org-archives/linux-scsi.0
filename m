Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CFC1DFFD;
	Sat,  7 Jun 2025 16:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749313407; cv=none; b=UPaovUgIVxc5WUqaDnM8ALAoZb0XAhfvRgz9v6AGYySzakpi3fmLM3uBeKridJoxBI6BHbOfY4Kk+IY8ixR9cNZ8o9a+34Ru+EQ2Tp6N7Yc7nhwU43DX6UMxle+PJ0wFEeIaetVBQvYQGtFMuKAqLgRDd1YV/7q9MJRC5ArT7LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749313407; c=relaxed/simple;
	bh=/C8aKTgpxFq/51Om8jvnGyrWGjteETkE8yR5x4OCV1A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p8HKZqqzUNRBVC1rCo3FDxwcCFZ1myX7apfksuM7k5SzQFm1O+3g8oL0NTpin6S0m0GcTEiRWK/ZQEOfrwvWqD8LHUNqaEe9PaLGcnctv64lHesrLz3VTXT+Gaqeiw7yGScrBiWk4HGzNTahB0RweABRb4/EED31Uf50yYGV0uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bAATkdTf; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bAATkdTf"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 557Ce0lg011099;
	Sat, 7 Jun 2025 16:23:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=VNQcpR3FgrVvkaxcmYX2339ffI8LJ
	aNen8iQlJEMRQM=; b=bAATkdTfPDMniHDK+iOn63SkYVctFQBAbKVMcfuXwNgXa
	c0AoYOV/IsyLfqppKAJJ5Iajb/av8HRx5NaFw4lPAeCJYL6Wf5kHTQSE+yvDZD/e
	CP/4/pDIL37+/rWoInMh9nnsJNGOSuZuRk9yJYM8zrlENVrhsl21oYRM3uKmNXjA
	wbTOoG0Q5QCaveo37YjFGHrW2O7DPA2VVLLrtyN2d3R0jl41HkGT/gjvFBBkYv7i
	mVqQMip4jaN2OTKEPKSiZpXBJ1HHDzy9J0lCxluf9ye4tI2r6UNJ9vpYPP+Im8uF
	64HFLJvuUq8ntxnkf1EylkbEbnrQ+ajdkf8JrMasw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474dywratb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Jun 2025 16:23:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 557CKxhK020775;
	Sat, 7 Jun 2025 16:23:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bv6utcx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Jun 2025 16:23:08 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 557GJakY008514;
	Sat, 7 Jun 2025 16:23:07 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 474bv6utcp-1;
	Sat, 07 Jun 2025 16:23:07 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: corbet@lwn.net, linux-doc@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com
Cc: alok.a.tiwari@oracle.com, himanshu.madhani@oracle.com,
        darren.kenny@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: docs: scsi_fc_transport: Add documentation for FC Remote Ports
Date: Sat,  7 Jun 2025 09:22:56 -0700
Message-ID: <20250607162304.1765430-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-07_06,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506070117
X-Authority-Analysis: v=2.4 cv=fdaty1QF c=1 sm=1 tr=0 ts=6844677c b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=Q_fQxBA_vzZ2BlmfIw4A:9 cc=ntf awl=host:13206
X-Proofpoint-ORIG-GUID: bReM-n9k3kUoaxYAJBYAL6mirJ5ouhh7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA3MDExOCBTYWx0ZWRfX1u2FmG1l6S/Y FttwI4P6fLJm+1LQclFNscljvD7N7HivIxK5oXWt/edqmCVi2oKlLdQGCuMOCah+g2WCUn81xME ajm9/tRNqwQ1JnE8z+IFqzJejU2IQ05PYP56lSlN/ZIZClCIbNWG8Lxmw6NuN621uDYQeCkZT/Q
 YqPTj1e4jrPOu9oS/QNlfBJtBqSa6xsBK7mGU5c085v5Ip3hn8kgXeITx/j0h2NOq7VZ/9y6aB/ OHzMqOkmcnxVzaJqJhL5+uXv835Kq5K5sBUMyACI4cwnJPW4vWIFkRDAHiwPATHX8CWPvaX9EX5 2qW4SJWBrmDeYoAbC2+NM/+wXY9inBStfqGdy8vtuPjTO61GhIJ30/c3vGN6PDx4C/AnbVtLVDk
 IloODh87WgL79T/QwLOyD/nYvu7alSEPBwZGf9ZPmbDaRqjplPYqy50XMFM9twibnXZAlMT6
X-Proofpoint-GUID: bReM-n9k3kUoaxYAJBYAL6mirJ5ouhh7

This patch updates the scsi_fc_transport.rst documentation by
replacing the outdated << To Be Supplied >> placeholder under
the "FC Remote Ports (rports)" section with a detailed explanation
of remote port functionality in the Fibre Channel (FC) transport class.

The new documentation covers:
What rports are and their role in FC-based SCSI communication
Their representation in sysfs (/sys/class/fc_remote_ports/)
Common sysfs attributes such as (port_id, port_name, node_name,
and port_state).
Their typical lifecycle (creation and removal)
Guidance for driver developers on using fc_remote_port_add() and
fc_remote_port_delete()

This change improves the completeness and usefulness of the
FC transport documentation for developers and users interacting
with Fibre Channel drivers in the Linux SCSI subsystem

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 Documentation/scsi/scsi_fc_transport.rst | 35 +++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/Documentation/scsi/scsi_fc_transport.rst b/Documentation/scsi/scsi_fc_transport.rst
index e3ddcfb7f8fd..5ef75575924e 100644
--- a/Documentation/scsi/scsi_fc_transport.rst
+++ b/Documentation/scsi/scsi_fc_transport.rst
@@ -30,7 +30,40 @@ This file is found at Documentation/scsi/scsi_fc_transport.rst
 
 FC Remote Ports (rports)
 ========================
-<< To Be Supplied >>
+
+  In the Fibre Channel (FC) subsystem, a remote port (rport) refers to a
+  remote Fibre Channel node that the local port can communicate with.
+  These are typically storage targets (e.g., arrays, tapes) that respond
+  to SCSI commands over FC transport.
+
+  In Linux, rports are managed by the FC transport class and are
+  represented in sysfs under:
+
+    /sys/class/fc_remote_ports/
+
+  Each rport directory contains attributes describing the remote port,
+  such as port ID, node name, port state, and link speed.
+
+  rports are typically created by the FC transport when a new device is
+  discovered during a fabric login or scan, and they persist until the
+  device is removed or the link is lost.
+
+  Common attributes:
+  - node_name: World Wide Node Name (WWNN).
+  - port_name: World Wide Port Name (WWPN).
+  - port_id: FC address of the remote port.
+  - roles: Indicates if the port is an initiator, target, or both.
+  - port_state: Shows the current operational state.
+
+  After discovering a remote port, the driver typically populates a
+  fc_rport_identifiers structure and invokes fc_remote_port_add() to
+  create and register the remote port with the SCSI subsystem via the
+  Fibre Channel (FC) transport class.
+
+  rports are also visible via sysfs as children of the FC host adapter.
+
+  For developers: use fc_remote_port_add() and fc_remote_port_delete() when
+  implementing a driver that interacts with the FC transport class.
 
 
 FC Virtual Ports (vports)
-- 
2.47.1

