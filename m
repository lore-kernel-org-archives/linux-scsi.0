Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA50C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 16:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60153613CD
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 16:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbhDXQsN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 12:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbhDXQsM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 12:48:12 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B57DC061574;
        Sat, 24 Apr 2021 09:47:33 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id g16so9864906plq.3;
        Sat, 24 Apr 2021 09:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=4g/f2KIFhJuVcmwVk6yfNv3Pv09IsAtYgatq8dseNnQ=;
        b=b/BXxqHwhGD5TF4/6PxQ8m5C4WHZHJyEUtVn2VmU1NVtVc5FLJDoH9xFDi6y3EjuEk
         llx06s57ZsGTC/LpUHzUiu5LOdiz+mMHg8q6mZGvSm5CM4+NYri2wH5w/bRJynG6aUPN
         vXIIxaEA8R4M0s4VlvBEeqJB9Q4u7PpUB6B/LTxxUQguhX39d0ItibpETfylXdI84UMn
         g7WYKn5CAuGEybLxuNhnPlOyyYNCoD6WIT/zAV/BhWPutX5EILwyyo9Q2N8xonTiPHHr
         a4uzNk8dxIe2oXz5XKwir+iGh5yoomy2gkTJCWDk/hc/+Nti0GSGRG+5Ew8rFNaSEVpr
         yURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=4g/f2KIFhJuVcmwVk6yfNv3Pv09IsAtYgatq8dseNnQ=;
        b=VG5+iWfH+kqCTDTOfuSAYSAMXgk+93RgI3NwiVrBseV7P9EgF5GR8IEZZA4UfsLNF5
         1uXcsg2IiGRIJxjevAwZLUMgY99GbhK0EK5P5/uF+e2tXzMsHn+UQt0pyUXBcuKd+8+w
         2NDEqBYd1AKPdpzSixz/AlAhy6fX3QW/I3yU9RWOSwWAS0y9oqO9anyQLbUnv/K3LPhX
         5+mWpu3Ean8Tk41naSExI0huICWzhy1tylzyR86MNrdbBZoBJaHDZkgzbgyejLJwMbtJ
         fSY5IEpeItHUkfdAWEW99nZp68jjxBuGW0ZJt0nDNzWRAeRI4IZxEXY628rPf8Subh+/
         6Kqg==
X-Gm-Message-State: AOAM532B2z+dcQYX7uleJ+DSUEJRmqrz3/NfRU1TVHZWj7vhUK1Un2ui
        6HuMqVAFVkMRMelNpomTUDc=
X-Google-Smtp-Source: ABdhPJwEle4P739oSmuBUALs9mXK/yNc/+7eA8GL/GRySEToVQzyNwGKVXx9jNbZVrW1FHtzFwuHdw==
X-Received: by 2002:a17:902:263:b029:ec:a39a:419b with SMTP id 90-20020a1709020263b02900eca39a419bmr9463357plc.84.1619282852807;
        Sat, 24 Apr 2021 09:47:32 -0700 (PDT)
Received: from localhost ([157.45.125.75])
        by smtp.gmail.com with ESMTPSA id n48sm7202192pfv.130.2021.04.24.09.47.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 24 Apr 2021 09:47:32 -0700 (PDT)
Date:   Sat, 24 Apr 2021 22:17:23 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     sathya.prakash@broadcom.com
Cc:     sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, sanjanasrinidhi1810@gmail.com
Subject: [PATCH] drivers: message: fusion: mptsas.c: Fix spaces during
 declaration
Message-ID: <20210424164723.jkklwilvcabhy5ep@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Spaces have been added after a ',' at the time of declaration
Extra spaces have been removed at the end of closing ')'.
Tabs have been used instead of spaces to maintain uniformity.

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 drivers/message/fusion/mptsas.c | 45 ++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 5eb0b3361e4e..b8d312e15c58 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -406,7 +406,7 @@ static inline MPT_ADAPTER *rphy_to_ioc(struct sas_rphy *rphy)
 static struct mptsas_portinfo *
 mptsas_find_portinfo_by_handle(MPT_ADAPTER *ioc, u16 handle)
 {
-	struct mptsas_portinfo *port_info, *rc=NULL;
+	struct mptsas_portinfo *port_info, *rc = NULL;
 	int i;
 
 	list_for_each_entry(port_info, &ioc->sas_topology, list)
@@ -491,7 +491,7 @@ mptsas_port_delete(MPT_ADAPTER *ioc, struct mptsas_portinfo_details * port_detai
 	    port_details->phy_bitmask));
 
 	for (i = 0; i < port_info->num_phys; i++, phy_info++) {
-		if(phy_info->port_details != port_details)
+		if (phy_info->port_details != port_details)
 			continue;
 		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
 		mptsas_set_rphy(ioc, phy_info, NULL);
@@ -684,8 +684,8 @@ mptsas_add_device_component_starget_ir(MPT_ADAPTER *ioc,
 	RaidPhysDiskPage0_t 		phys_disk;
 	struct mptsas_device_info	*sas_info, *next;
 
-	memset(&cfg, 0 , sizeof(CONFIGPARMS));
-	memset(&hdr, 0 , sizeof(ConfigPageHeader_t));
+	memset(&cfg, 0, sizeof(CONFIGPARMS));
+	memset(&hdr, 0, sizeof(ConfigPageHeader_t));
 	hdr.PageType = MPI_CONFIG_PAGETYPE_RAID_VOLUME;
 	/* assumption that all volumes on channel = 0 */
 	cfg.pageAddr = starget->id;
@@ -879,7 +879,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 		    "%s: [%p]: deleting phy = %d\n",
 		    ioc->name, __func__, port_details, i));
 		port_details->num_phys--;
-		port_details->phy_bitmask &= ~ (1 << phy_info->phy_id);
+		port_details->phy_bitmask &= ~(1 << phy_info->phy_id);
 		memset(&phy_info->attached, 0, sizeof(struct mptsas_devinfo));
 		if (phy_info->phy) {
 			devtprintk(ioc, dev_printk(KERN_DEBUG,
@@ -912,10 +912,10 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 				goto out;
 			port_details->num_phys = 1;
 			port_details->port_info = port_info;
-			if (phy_info->phy_id < 64 )
+			if (phy_info->phy_id < 64)
 				port_details->phy_bitmask |=
 				    (1 << phy_info->phy_id);
-			phy_info->sas_port_add_phy=1;
+			phy_info->sas_port_add_phy = 1;
 			dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT "\t\tForming port\n\t\t"
 			    "phy_id=%d sas_address=0x%018llX\n",
 			    ioc->name, i, (unsigned long long)sas_address));
@@ -931,7 +931,7 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 				continue;
 			if (sas_address != phy_info_cmp->attached.sas_address)
 				continue;
-			if (phy_info_cmp->port_details == port_details )
+			if (phy_info_cmp->port_details == port_details)
 				continue;
 			dsaswideprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 			    "\t\tphy_id=%d sas_address=0x%018llX\n",
@@ -949,12 +949,12 @@ mptsas_setup_wide_ports(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info)
 				if (!phy_info_cmp->port_details->num_phys)
 					kfree(phy_info_cmp->port_details);
 			} else
-				phy_info_cmp->sas_port_add_phy=1;
+				phy_info_cmp->sas_port_add_phy = 1;
 			/*
 			 * Adding a phy to a port
 			 */
 			phy_info_cmp->port_details = port_details;
-			if (phy_info_cmp->phy_id < 64 )
+			if (phy_info_cmp->phy_id < 64)
 				port_details->phy_bitmask |=
 				(1 << phy_info_cmp->phy_id);
 			port_details->num_phys++;
@@ -1218,8 +1218,8 @@ static int
 mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 {
 	MPT_SCSI_HOST	*hd = shost_priv(ioc->sh);
-        struct list_head *head = &hd->target_reset_list;
-	u8		id, channel;
+	struct list_head *head = &hd->target_reset_list;
+	u8 id, channel;
 	struct mptsas_target_reset_event	*target_reset_list;
 	SCSITaskMgmtReply_t *pScsiTmReply;
 
@@ -2585,7 +2585,7 @@ mptsas_sas_device_pg0(MPT_ADAPTER *ioc, struct mptsas_devinfo *device_info,
 	SasDevicePage0_t *buffer;
 	dma_addr_t dma_handle;
 	__le64 sas_address;
-	int error=0;
+	int error = 0;
 
 	hdr.PageVersion = MPI_SASDEVICE0_PAGEVERSION;
 	hdr.ExtPageLength = 0;
@@ -2748,7 +2748,7 @@ mptsas_sas_expander_pg1(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 	CONFIGPARMS cfg;
 	SasExpanderPage1_t *buffer;
 	dma_addr_t dma_handle;
-	int error=0;
+	int error = 0;
 
 	hdr.PageVersion = MPI_SASEXPANDER1_PAGEVERSION;
 	hdr.ExtPageLength = 0;
@@ -3307,7 +3307,7 @@ mptsas_probe_hba_phys(MPT_ADAPTER *ioc)
 	int error = -ENOMEM, i;
 
 	hba = kzalloc(sizeof(struct mptsas_portinfo), GFP_KERNEL);
-	if (! hba)
+	if (!hba)
 		goto out;
 
 	error = mptsas_sas_io_unit_pg0(ioc, hba);
@@ -4255,8 +4255,8 @@ mptsas_adding_inactive_raid_components(MPT_ADAPTER *ioc, u8 channel, u8 id)
 	struct mptsas_phyinfo	*phy_info;
 	struct mptsas_devinfo		sas_device;
 
-	memset(&cfg, 0 , sizeof(CONFIGPARMS));
-	memset(&hdr, 0 , sizeof(ConfigPageHeader_t));
+	memset(&cfg, 0, sizeof(CONFIGPARMS));
+	memset(&hdr, 0, sizeof(ConfigPageHeader_t));
 	hdr.PageType = MPI_CONFIG_PAGETYPE_RAID_VOLUME;
 	cfg.pageAddr = (channel << 8) + id;
 	cfg.cfghdr.hdr = &hdr;
@@ -5157,10 +5157,10 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	int			 numSGE = 0;
 	int			 scale;
 	int			 ioc_cap;
-	int			error=0;
+	int			error = 0;
 	int			r;
 
-	r = mpt_attach(pdev,id);
+	r = mpt_attach(pdev, id);
 	if (r)
 		return r;
 
@@ -5211,9 +5211,8 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			"Unable to register controller with SCSI subsystem\n",
 			ioc->name);
 		error = -1;
-		goto out_mptsas_probe;
-        }
-
+		goto out_mptsas_probe
+	}
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 
 	/* Attach the SCSI Host to the IOC structure
@@ -5310,7 +5309,7 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 
-	if (ioc->sas_data.ptClear==1) {
+	if (ioc->sas_data.ptClear == 1) {
 		mptbase_sas_persist_operation(
 		    ioc, MPI_SAS_OP_CLEAR_ALL_PERSISTENT);
 	}
-- 
2.17.1

