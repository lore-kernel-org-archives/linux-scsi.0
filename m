From: Eric Moore <eric.moore@lsil.com>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.17
Date: Fri, 30 Jun 2006 21:21:42 -0600
Message-ID: <20060701032142.GA25967@lsil.com>
References: <1151723367.8921.68.camel@mulgrave.il.steeleye.com> <003201c69cbc$ed640e60$241015ac@ericmoore> <1151724190.8921.70.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63928 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932151AbWGADc4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 23:32:56 -0400
Content-Disposition: inline
In-Reply-To: <1151724190.8921.70.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jun 30, 2006 at 10:23:10PM -0500, James Bottomley wrote:
> On Fri, 2006-06-30 at 21:17 -0600, Moore, Eric wrote:
> > I noticed you didn't pick up the mptsas patch for zero base port ids.
> > Is that because your eventually going to have transport do
> > the port id assignments?
> 
> Actually, no, it just got lost in the rush to get everything done and
> tested before 2.6.17 turns into a pumpkin at midnight tonight.
> 
> James
> 
> 

Here is the patch. Please resider it:

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-06-27 15:24:01.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-06-28 16:53:39.000000000 -0600
@@ -644,7 +644,6 @@
 	struct work_struct	 fc_rescan_work;
 	char			 fc_rescan_work_q_name[KOBJ_NAME_LEN];
 	struct workqueue_struct *fc_rescan_work_q;
-	u8		port_serial_number;
 } MPT_ADAPTER;
 
 /*
diff -uarN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2006-06-27 15:17:03.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2006-06-28 16:55:25.000000000 -0600
@@ -144,7 +144,7 @@
  * Specific details on ports, wide/narrow
  */
 struct mptsas_portinfo_details{
-	u8	port_id; 	/* port number provided to transport */
+	u32	port_id; 	/* port number provided to transport */
 	u16	num_phys;	/* number of phys belong to this port */
 	u64	phy_bitmask; 	/* TODO, extend support for 255 phys */
 	struct sas_rphy *rphy;	/* transport layer rphy object */
@@ -171,6 +171,7 @@
 	struct list_head list;
 	u16		handle;		/* unique id to address this */
 	u16		num_phys;	/* number of phys */
+	u32		port_serial_number;
 	struct mptsas_phyinfo *phy_info;
 };
 
@@ -493,7 +494,7 @@
 				goto out;
 			port_details->num_phys = 1;
 			port_details->port_info = port_info;
-			port_details->port_id = ioc->port_serial_number++;
+			port_details->port_id = port_info->port_serial_number++;
 			if (phy_info->phy_id < 64 )
 				port_details->phy_bitmask |=
 				    (1 << phy_info->phy_id);
@@ -529,8 +530,7 @@
 					phy_info_cmp->port_details->port_id;
 				port_details->num_phys =
 					phy_info_cmp->port_details->num_phys;
-//				port_info->port_serial_number--;
-				ioc->port_serial_number--;
+				port_info->port_serial_number--;
 				if (!phy_info_cmp->port_details->num_phys)
 					kfree(phy_info_cmp->port_details);
 			} else
