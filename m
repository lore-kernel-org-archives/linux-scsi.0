From: Jeremy Linton <jli@greshamstorage.com>
Subject: [PATCH] 2.4 sym53c8xx driver residual problem
Date: Thu, 5 Oct 2006 14:50:58 -0500
Message-ID: <200610051450.58156.jli@greshamstorage.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_iIWJFT0SXKVwr+D"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from austin.greshamstorage.com ([216.143.252.250]:50446 "EHLO
	austin.greshamstorage.com") by vger.kernel.org with ESMTP
	id S1751072AbWJETvT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Oct 2006 15:51:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: groudier@free.fr

--Boundary-00=_iIWJFT0SXKVwr+D
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello all,
	I've got an application that depends on the residual data information in 
order to send it to another application.  The basic problem is that if a 
single SCSI transfer size is greater than a single scatter gather region 
(generally ~32k), then the residual length is based on the size of the 
scatter gather regions and not the request size. When the two differ, and 
there is a residual data condition the application computes the transfer size 
incorrectly. 
	The attached patch is against the sym53c8xx.c driver in the 2.4 tree, I 
haven't tested the 2.6 sym53c8xx_2 driver, but a quick glance at the code 
seems to indicate it has the same problem. When I get a chance, I will test 
the 2.6 driver as well, for the same problem. The patch basically saves the 
original request length into a new member in the ccb structure called 
orig_data_len. Then, when the residual len is being computed, it adjusts it 
for the original data request size. 

	BTW: We are using the old sym53c8xx driver instead of the new one, because it 
passes more of our validation tests in 2.4 than the sym53c8xx_2 driver does. 
Our tests use the sg interface exclusively, so I'm not sure about behavior 
with other drivers (st,sd). 




--Boundary-00=_iIWJFT0SXKVwr+D
Content-Type: text/x-diff;
  charset="us-ascii";
  name="sym53c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sym53c.patch"

--- sym53c8xx.c.orig	2006-10-04 18:40:39.132184101 -0500
+++ sym53c8xx.c	2006-10-05 12:20:48.252759592 -0500
@@ -1990,6 +1990,9 @@
 	int		ext_sg;		/* Extreme data pointer, used	*/
 	int		ext_ofs;	/*  to calculate the residual.	*/
 	int		resid;
+	int             orig_data_len;  /* used to calculate the correct*/
+	                                /* resid based on the original  */
+                                        /* data len, not the scatter len*/
 };
 
 #define CCB_PHYS(cp,lbl)	(cp->p_ccb + offsetof(struct ccb, lbl))
@@ -10666,8 +10669,8 @@
 	**	unknown), then no data transfer should have 
 	**	taken place.
 	*/
-	if (cp->phys.header.lastp == NCB_SCRIPTH_PHYS (np, data_io))
-		return cp->data_len;
+	if (cp->phys.header.lastp == NCB_SCRIPTH_PHYS (np, data_io)) 
+		return cp->orig_data_len;
 
 	/*
 	**	If no data transfer occurs, or if the data
@@ -10676,7 +10679,7 @@
 	if (cp->startp == cp->phys.header.lastp ||
 	    ncr_evaluate_dp(np, cp, scr_to_cpu(cp->phys.header.lastp),
 			    &dp_ofs) < 0) {
-		return cp->data_len;
+		return cp->orig_data_len;
 	}
 
 	/*
@@ -10685,14 +10688,13 @@
 	*/
 	dp_sgmin = MAX_SCATTER - cp->segments;
 	resid = -cp->ext_ofs;
-	for (dp_sg = cp->ext_sg; dp_sg < MAX_SCATTER; ++dp_sg) {
+	for (dp_sg = cp->ext_sg; dp_sg < MAX_SCATTER; ++dp_sg) 	{
 		tmp = scr_to_cpu(cp->phys.data[dp_sg].size);
 		resid += (tmp & 0xffffff);
 	}
-
-	/*
-	**	Hopefully, the result is not too wrong.
-	*/
+	
+	/* adjust based on original data length */
+	resid=cp->orig_data_len-(cp->data_len-resid);
 	return resid;
 }
 
@@ -12096,6 +12098,7 @@
 	int segment;
 
 	cp->data_len = cmd->request_bufflen;
+	cp->orig_data_len = cmd->request_bufflen;
 
 	if (cmd->request_bufflen) {
 		dma_addr_t baddr = map_scsi_single_data(np, cmd);
@@ -12136,6 +12139,7 @@
 	int use_sg = (int) cmd->use_sg;
 
 	cp->data_len = 0;
+	cp->orig_data_len = cmd->request_bufflen;
 
 	if (!use_sg)
 		segn = ncr_scatter_no_sglist(np, cp, cmd);
@@ -12175,6 +12179,7 @@
 	int use_sg = (int) cmd->use_sg;
 
 	cp->data_len = 0;
+	cp->orig_data_len = cmd->request_bufflen;
 
 	if (!use_sg)
 		segment = ncr_scatter_no_sglist(np, cp, cmd);
@@ -12191,9 +12196,7 @@
 			dma_addr_t baddr = scsi_sg_dma_address(&scatter[segment]);
 			unsigned int len = scsi_sg_dma_len(&scatter[segment]);
 
-			SCATTER_ONE(&data[segment],
-				    baddr,
-				    len);
+			SCATTER_ONE(&data[segment], baddr, len);
 			cp->data_len += len;
 		}
 	}

--Boundary-00=_iIWJFT0SXKVwr+D--
