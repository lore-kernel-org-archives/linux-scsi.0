From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH 1/5] fusion: fibre channel: return DID_ERROR for MPI_IOCSTATUS_SCSI_IOC_TERMINATED
Date: Thu, 4 Jan 2007 20:44:01 -0700
Message-ID: <20070105034400.GA14068@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43882 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030315AbXAEDmQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jan 2007 22:42:16 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

A repost of a patch forwarded by Mikael Reed from 2006-12-20.

The fibre channel IOC may kill a request for a variety of
reasons, some of which may be recovered by a retry, some of
which are unlikely to be recovered.  Return DID_ERROR
instead of DID_RESET to permit retry of the command,
just not an infinite number of them.


Signed-off-by: Michael Reed <mdr@sgi.com>
Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-12-23 21:00:32.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2006-12-25 01:51:26.000000000 -0700
@@ -701,6 +701,17 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 						break;
 					}
 				}
+			} else if (ioc->bus_type == FC) {
+				/*
+				 * The FC IOC may kill a request for variety of
+				 * reasons, some of which may be recovered by a
+				 * retry, some which are unlikely to be
+				 * recovered. Return DID_ERROR instead of
+				 * DID_RESET to permit retry of the command,
+				 * just not an infinite number of them
+				 */
+				sc->result = DID_ERROR << 16;
+				break;
 			}
 
 			/*
