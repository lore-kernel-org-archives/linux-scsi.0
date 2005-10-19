From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Wed, 19 Oct 2005 20:01:17 +0200
Message-ID: <20051019180117.GB21488@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:28552 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751207AbVJSSBk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 14:01:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, Eric.Moore@lsil.com
Cc: linux-scsi@vger.kernel.org

Add a flag to mark a PHY as attached to the HBA as opposed to beeing on
an expander.  This is needed because various features are only supported
on those.  This is a crude hack, the proper fix would be to use
different classes for host-attached vs expander phys.  I'm looking into
that.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptsas.c	2005-10-19 15:30:29.000000000 +0200
+++ linux-2.6/drivers/message/fusion/mptsas.c	2005-10-19 19:49:35.000000000 +0200
@@ -760,7 +760,7 @@
 }
 
 static int mptsas_probe_one_phy(struct device *dev,
-		struct mptsas_phyinfo *phy_info, int index)
+		struct mptsas_phyinfo *phy_info, int index, int local)
 {
 	struct sas_phy *port;
 	int error;
@@ -853,6 +853,9 @@
 		break;
 	}
 
+	if (local)
+		port->local_attached = 1;
+
 	error = sas_phy_add(port);
 	if (error) {
 		sas_phy_free(port);
@@ -918,7 +921,7 @@
 		}
 
 		mptsas_probe_one_phy(&ioc->sh->shost_gendev,
-				     &port_info->phy_info[i], *index);
+				     &port_info->phy_info[i], *index, 1);
 		(*index)++;
 	}
 
@@ -989,7 +992,8 @@
 			}
 		}
 
-		mptsas_probe_one_phy(parent, &port_info->phy_info[i], *index);
+		mptsas_probe_one_phy(parent, &port_info->phy_info[i],
+				     *index, 0);
 		(*index)++;
 	}
 
Index: linux-2.6/include/scsi/scsi_transport_sas.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_transport_sas.h	2005-10-19 15:30:29.000000000 +0200
+++ linux-2.6/include/scsi/scsi_transport_sas.h	2005-10-19 19:49:35.000000000 +0200
@@ -56,6 +56,9 @@
 	enum sas_linkrate	maximum_linkrate;
 	u8			port_identifier;
 
+	/* internal state */
+	unsigned int		local_attached : 1;
+
 	/* link error statistics */
 	u32			invalid_dword_count;
 	u32			running_disparity_error_count;
Index: linux-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_sas.c	2005-10-19 19:49:35.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_transport_sas.c	2005-10-19 19:50:55.000000000 +0200
@@ -266,6 +266,9 @@
 	struct sas_internal *i = to_sas_internal(shost->transportt);	\
 	int error;							\
 									\
+	if (!phy->local_attached)					\
+		return -EINVAL;						\
+									\
 	error = i->f->get_linkerrors(phy);				\
 	if (error)							\
 		return error;						\
