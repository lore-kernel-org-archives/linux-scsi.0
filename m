From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: RE: [patch] fix unnecessary activation of blk tag queue for qla2x00
Date: Wed, 12 Oct 2005 14:20:09 -0700
Message-ID: <200510122120.j9CLKVg29381@unix-os.sc.intel.com>
References: <20051012210930.GK12468@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr21.intel.com ([143.183.121.13]:63883 "EHLO
	scsfmr001.sc.intel.com") by vger.kernel.org with ESMTP
	id S932070AbVJLVV6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2005 17:21:58 -0400
In-Reply-To: <20051012210930.GK12468@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Vasquez' <andrew.vasquez@qlogic.com>
Cc: 'Patrick Mansfield' <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Andrew Vasquez wrote on Wednesday, October 12, 2005 2:10 PM
> On Wed, 12 Oct 2005, Chen, Kenneth W wrote:
> > Yeah, that would indeed be a very good thing to do.  It reminds me
> > a while back, I was investigating cache miss profile and we
> > consistently see cache misses on tag[2] variable defined in
> > qla2x00_start_scsi (used by scsi_populate_tag_msg).  Removing it
> > would be a very good thing for driver performance.
> > 
> > Should I generate the patch?
> 
> Drop scsi_populate_tag_msg() interrogation.

Great! Got a couple "unused variable" compiler warning.  You forgot
to delete the variable declaration in a hurry ;-)


--- ./drivers/scsi/qla2xxx/qla_iocb.c.orig	2005-10-12 14:17:31.544219754 -0700
+++ ./drivers/scsi/qla2xxx/qla_iocb.c	2005-10-12 14:18:08.124297431 -0700
@@ -316,7 +316,6 @@ qla2x00_start_scsi(srb_t *sp)
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
 	struct device_reg_2xxx __iomem *reg;
-	char		tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;
@@ -737,7 +736,6 @@ qla24xx_start_scsi(srb_t *sp)
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
 	struct device_reg_24xx __iomem *reg;
-	char		tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;

