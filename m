From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/1]  fusion: fibre channel: return DID_ERROR for MPI_IOCSTATUS_SCSI_IOC_TERMINATED
Date: Wed, 20 Dec 2006 17:11:19 -0600
Message-ID: <4589C317.60709@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030100080004020407090000"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:40283 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161008AbWLTXLY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Dec 2006 18:11:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Jeremy Higdon <jeremy@sgi.com>

This is a multi-part message in MIME format.
--------------030100080004020407090000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The fibre channel IOC may kill a request for a variety of
reasons, some of which may be recovered by a retry, some of
which are unlikely to be recovered.  Return DID_ERROR
instead of DID_RESET to permit retry of the command,
just not an infinite number of them.

Signed-off-by: Michael Reed <mdr@sgi.com>

--------------030100080004020407090000
Content-Type: text/x-patch;
 name="mptscsih.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mptscsih.c.patch"

The fibre channel IOC may kill a request for a variety of
reasons, some of which may be recovered by a retry, some of
which are unlikely to be recovered.  Return DID_ERROR
instead of DID_RESET to permit retry of the command,
just not an infinite number of them.

Signed-off-by: Michael Reed <mdr@sgi.com>

--- kdbu/drivers/message/fusion/mptscsih.c	2006-08-04 02:10:22.000000000 -0500
+++ kdb/drivers/message/fusion/mptscsih.c	2006-12-16 12:54:13.952128107 -0600
@@ -702,9 +702,14 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 					}
 				}
 			}
+			else if (ioc->bus_type == FC) {
+				/* i/o killed by IOC */
+				sc->result = DID_ERROR << 16;
+				break;
+			}
 
 			/*
-			 * Allow non-SAS & non-NEXUS_LOSS to drop into below code
+			 * Allow non-FC, non-SAS & non-NEXUS_LOSS to drop into below code
 			 */
 
 		case MPI_IOCSTATUS_SCSI_TASK_TERMINATED:	/* 0x0048 */

--------------030100080004020407090000--
