Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58EC8C32771
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AF5122527
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhJh7GdY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgA1AXl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 19:23:41 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54788 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgA1AXl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 19:23:41 -0500
Received: by mail-wm1-f67.google.com with SMTP id g1so600355wmh.4
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2020 16:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8+AmC8/4r7owVCcradZPQNHLvLhaaoqC86qAlaJncnA=;
        b=fhJh7GdY86jvzxHuKSCy4HB0nf8rBDRSLaUuAY16LLVFQl+GGEoHLjoJUSMrJZbbEC
         aMf/vV3lLuireBqmji5v7/qbneajRh8DYEeVAwzdFIVY8qx+LJ/BDcrkMXwkbj/i7SN/
         3P8MenHtrmS5LjzOdt/fGUGShrhxWfqIdvPTyKZSA9aKYfPC1zhOeOwAmp9Tb+sHEonM
         w3Dk8wxqOgABxewSAimq9kY8NJ5ijAuFMMj8+0LabwGHc+Um1Q78lCmPMCCCJlJTyZ0s
         D7j8KLzdCAeHrsk9sqJsyLoAOhi6bEW7zflVGeKajTb6Ctxe+ZOCqnZsQjlosQzo2SFU
         iLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8+AmC8/4r7owVCcradZPQNHLvLhaaoqC86qAlaJncnA=;
        b=UaGnwgXJXMUCQyOQK5Pt9mWGiVtSlU6zYktMLCRetTnr+yqOnfVAnFU7RPrqp34aEc
         X3VsRPNtJ3SAQ971+8tbko7VzUWcQjuO+meykDnb03GSTe9/Dl5/lK3/goQoM6JicIzB
         Xam6oesqs9rS2s+n2X27l/FK6Bkdalg2VT5dNx4bsyvA9yBc3XMxxbL4Q9Y9AOBHX2yM
         wG4mdQciD630p/yXFMbmFpGdquy9BrmiowwaZ8Tpf42YGtMkxCSeqkDNumJlj7rvz4w5
         iZ8q4e+EP9A644VmHGFEwvv3MrYqlcl6bhjtmLwluOxJqlUeFMW7MrK+XFmsh0Fma7el
         QdUg==
X-Gm-Message-State: APjAAAVBl7SmQvKMCEGZfDil7Umf0c5vWvtFBhWzct+X7dK47+noWPBH
        Z7cyFiR4b4wsWyqEPgbiIUKVil00
X-Google-Smtp-Source: APXvYqxpZ+kn9c/XM7rY4FAQilNHvkIGLeKp3f7Vtki+3WYVxonmUgPwjU7iv/pOObsk5lumiBAsVw==
X-Received: by 2002:a7b:cf0d:: with SMTP id l13mr1324955wmg.13.1580171016616;
        Mon, 27 Jan 2020 16:23:36 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm583769wmi.43.2020.01.27.16.23.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 16:23:36 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 07/12] lpfc: Fix coverity errors in fmdi attribute handling
Date:   Mon, 27 Jan 2020 16:23:07 -0800
Message-Id: <20200128002312.16346-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200128002312.16346-1-jsmart2021@gmail.com>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Coverity reported a memory corruption error for the fdmi attributes
routines:
  CID 15768 [Memory Corruption] Out-of-bounds access on FDMI

Sloppy coding of the fmdi structures. In both the lpfc_fdmi_attr_def
and lpfc_fdmi_reg_port_list structures, a field was placed at the start
of payload that may have variable content. The field was given an
arbitrary type (uint32_t). The code then uses the field name to derive
an address, which it used in things such as memset and memcpy. The
memset sizes or memcpy lengths were larger than the arbitrary type,
thus coverity reported an error.

Fix by replacing the arbitrary fields with the real field structures
describing the payload.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 137 ++++++++++++++++++++++----------------------
 drivers/scsi/lpfc/lpfc_hw.h |  36 ++++++------
 2 files changed, 85 insertions(+), 88 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index fa70e2001b8e..8db27e84263e 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2073,8 +2073,8 @@ lpfc_fdmi_hba_attr_wwnn(struct lpfc_vport *vport, struct lpfc_fdmi_attr_def *ad)
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fc_sparam.nodeName,
 	       sizeof(struct lpfc_name));
@@ -2090,8 +2090,8 @@ lpfc_fdmi_hba_attr_manufacturer(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	/* This string MUST be consistent with other FC platforms
 	 * supported by Broadcom.
@@ -2115,8 +2115,8 @@ lpfc_fdmi_hba_attr_sn(struct lpfc_vport *vport, struct lpfc_fdmi_attr_def *ad)
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, phba->SerialNumber,
 		sizeof(ae->un.AttrString));
@@ -2137,8 +2137,8 @@ lpfc_fdmi_hba_attr_model(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, phba->ModelName,
 		sizeof(ae->un.AttrString));
@@ -2158,8 +2158,8 @@ lpfc_fdmi_hba_attr_description(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, phba->ModelDesc,
 		sizeof(ae->un.AttrString));
@@ -2181,8 +2181,8 @@ lpfc_fdmi_hba_attr_hdw_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t i, j, incr, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	/* Convert JEDEC ID to ascii for hardware version */
 	incr = vp->rev.biuRev;
@@ -2211,8 +2211,8 @@ lpfc_fdmi_hba_attr_drvr_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, lpfc_release_version,
 		sizeof(ae->un.AttrString));
@@ -2233,8 +2233,8 @@ lpfc_fdmi_hba_attr_rom_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		lpfc_decode_firmware_rev(phba, ae->un.AttrString, 1);
@@ -2258,8 +2258,8 @@ lpfc_fdmi_hba_attr_fmw_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	lpfc_decode_firmware_rev(phba, ae->un.AttrString, 1);
 	len = strnlen(ae->un.AttrString,
@@ -2278,8 +2278,8 @@ lpfc_fdmi_hba_attr_os_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	snprintf(ae->un.AttrString, sizeof(ae->un.AttrString), "%s %s %s",
 		 init_utsname()->sysname,
@@ -2301,7 +2301,7 @@ lpfc_fdmi_hba_attr_ct_len(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	ae->un.AttrInt =  cpu_to_be32(LPFC_MAX_CT_SIZE);
 	size = FOURBYTES + sizeof(uint32_t);
@@ -2317,8 +2317,8 @@ lpfc_fdmi_hba_attr_symbolic_name(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	len = lpfc_vport_symbolic_node_name(vport,
 				ae->un.AttrString, 256);
@@ -2336,7 +2336,7 @@ lpfc_fdmi_hba_attr_vendor_info(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	/* Nothing is defined for this currently */
 	ae->un.AttrInt =  cpu_to_be32(0);
@@ -2353,7 +2353,7 @@ lpfc_fdmi_hba_attr_num_ports(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	/* Each driver instance corresponds to a single port */
 	ae->un.AttrInt =  cpu_to_be32(1);
@@ -2370,8 +2370,8 @@ lpfc_fdmi_hba_attr_fabric_wwnn(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fabric_nodename,
 	       sizeof(struct lpfc_name));
@@ -2389,8 +2389,8 @@ lpfc_fdmi_hba_attr_bios_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strlcat(ae->un.AttrString, phba->BIOSVersion,
 		sizeof(ae->un.AttrString));
@@ -2410,7 +2410,7 @@ lpfc_fdmi_hba_attr_bios_state(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	/* Driver doesn't have access to this information */
 	ae->un.AttrInt =  cpu_to_be32(0);
@@ -2427,8 +2427,8 @@ lpfc_fdmi_hba_attr_vendor_id(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, "EMULEX",
 		sizeof(ae->un.AttrString));
@@ -2450,8 +2450,8 @@ lpfc_fdmi_port_attr_fc4type(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 32);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	ae->un.AttrTypes[2] = 0x01; /* Type 0x8 - FCP */
 	ae->un.AttrTypes[7] = 0x01; /* Type 0x20 - CT */
@@ -2475,7 +2475,7 @@ lpfc_fdmi_port_attr_support_speed(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	ae->un.AttrInt = 0;
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
@@ -2529,7 +2529,7 @@ lpfc_fdmi_port_attr_speed(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
 		switch (phba->fc_linkspeed) {
@@ -2599,7 +2599,7 @@ lpfc_fdmi_port_attr_max_frame(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	hsp = (struct serv_parm *)&vport->fc_sparam;
 	ae->un.AttrInt = (((uint32_t) hsp->cmn.bbRcvSizeMsb & 0x0F) << 8) |
@@ -2619,8 +2619,8 @@ lpfc_fdmi_port_attr_os_devname(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	snprintf(ae->un.AttrString, sizeof(ae->un.AttrString),
 		 "/sys/class/scsi_host/host%d", shost->host_no);
@@ -2640,8 +2640,8 @@ lpfc_fdmi_port_attr_host_name(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	scnprintf(ae->un.AttrString, sizeof(ae->un.AttrString), "%s",
 		  vport->phba->os_host_name);
@@ -2661,8 +2661,8 @@ lpfc_fdmi_port_attr_wwnn(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0,  sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fc_sparam.nodeName,
 	       sizeof(struct lpfc_name));
@@ -2679,8 +2679,8 @@ lpfc_fdmi_port_attr_wwpn(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0,  sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fc_sparam.portName,
 	       sizeof(struct lpfc_name));
@@ -2697,8 +2697,8 @@ lpfc_fdmi_port_attr_symbolic_name(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	len = lpfc_vport_symbolic_port_name(vport, ae->un.AttrString, 256);
 	len += (len & 3) ? (4 - (len & 3)) : 4;
@@ -2716,7 +2716,7 @@ lpfc_fdmi_port_attr_port_type(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	if (phba->fc_topology == LPFC_TOPOLOGY_LOOP)
 		ae->un.AttrInt =  cpu_to_be32(LPFC_FDMI_PORTTYPE_NLPORT);
 	else
@@ -2734,7 +2734,7 @@ lpfc_fdmi_port_attr_class(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	ae->un.AttrInt = cpu_to_be32(FC_COS_CLASS2 | FC_COS_CLASS3);
 	size = FOURBYTES + sizeof(uint32_t);
 	ad->AttrLen = cpu_to_be16(size);
@@ -2749,8 +2749,8 @@ lpfc_fdmi_port_attr_fabric_wwpn(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0,  sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fabric_portname,
 	       sizeof(struct lpfc_name));
@@ -2767,8 +2767,8 @@ lpfc_fdmi_port_attr_active_fc4type(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 32);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	ae->un.AttrTypes[2] = 0x01; /* Type 0x8 - FCP */
 	ae->un.AttrTypes[7] = 0x01; /* Type 0x20 - CT */
@@ -2790,7 +2790,7 @@ lpfc_fdmi_port_attr_port_state(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	/* Link Up - operational */
 	ae->un.AttrInt =  cpu_to_be32(LPFC_FDMI_PORTSTATE_ONLINE);
 	size = FOURBYTES + sizeof(uint32_t);
@@ -2806,7 +2806,7 @@ lpfc_fdmi_port_attr_num_disc(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	vport->fdmi_num_disc = lpfc_find_map_node(vport);
 	ae->un.AttrInt = cpu_to_be32(vport->fdmi_num_disc);
 	size = FOURBYTES + sizeof(uint32_t);
@@ -2822,7 +2822,7 @@ lpfc_fdmi_port_attr_nportid(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	ae->un.AttrInt =  cpu_to_be32(vport->fc_myDID);
 	size = FOURBYTES + sizeof(uint32_t);
 	ad->AttrLen = cpu_to_be16(size);
@@ -2837,8 +2837,8 @@ lpfc_fdmi_smart_attr_service(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, "Smart SAN Initiator",
 		sizeof(ae->un.AttrString));
@@ -2858,8 +2858,8 @@ lpfc_fdmi_smart_attr_guid(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrString, &vport->fc_sparam.nodeName,
 	       sizeof(struct lpfc_name));
@@ -2879,8 +2879,8 @@ lpfc_fdmi_smart_attr_version(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, "Smart SAN Version 2.0",
 		sizeof(ae->un.AttrString));
@@ -2901,8 +2901,8 @@ lpfc_fdmi_smart_attr_model(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, phba->ModelName,
 		sizeof(ae->un.AttrString));
@@ -2921,7 +2921,7 @@ lpfc_fdmi_smart_attr_port_info(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	/* SRIOV (type 3) is not supported */
 	if (vport->vpi)
@@ -2941,7 +2941,7 @@ lpfc_fdmi_smart_attr_qos(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	ae->un.AttrInt =  cpu_to_be32(0);
 	size = FOURBYTES + sizeof(uint32_t);
 	ad->AttrLen = cpu_to_be16(size);
@@ -2956,7 +2956,7 @@ lpfc_fdmi_smart_attr_security(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	ae->un.AttrInt =  cpu_to_be32(1);
 	size = FOURBYTES + sizeof(uint32_t);
 	ad->AttrLen = cpu_to_be16(size);
@@ -3104,7 +3104,8 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			/* Registered Port List */
 			/* One entry (port) per adapter */
 			rh->rpl.EntryCnt = cpu_to_be32(1);
-			memcpy(&rh->rpl.pe, &phba->pport->fc_sparam.portName,
+			memcpy(&rh->rpl.pe.PortName,
+			       &phba->pport->fc_sparam.portName,
 			       sizeof(struct lpfc_name));
 
 			/* point to the HBA attribute block */
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 436cdc8c5ef4..b5642c872593 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1340,25 +1340,8 @@ struct fc_rdp_res_frame {
 /* lpfc_sli_ct_request defines the CT_IU preamble for FDMI commands */
 #define  SLI_CT_FDMI_Subtypes     0x10	/* Management Service Subtype */
 
-/*
- * Registered Port List Format
- */
-struct lpfc_fdmi_reg_port_list {
-	uint32_t EntryCnt;
-	uint32_t pe;		/* Variable-length array */
-};
-
-
 /* Definitions for HBA / Port attribute entries */
 
-struct lpfc_fdmi_attr_def { /* Defined in TLV format */
-	/* Structure is in Big Endian format */
-	uint32_t AttrType:16;
-	uint32_t AttrLen:16;
-	uint32_t AttrValue;  /* Marks start of Value (ATTRIBUTE_ENTRY) */
-};
-
-
 /* Attribute Entry */
 struct lpfc_fdmi_attr_entry {
 	union {
@@ -1369,7 +1352,13 @@ struct lpfc_fdmi_attr_entry {
 	} un;
 };
 
-#define LPFC_FDMI_MAX_AE_SIZE	sizeof(struct lpfc_fdmi_attr_entry)
+struct lpfc_fdmi_attr_def { /* Defined in TLV format */
+	/* Structure is in Big Endian format */
+	uint32_t AttrType:16;
+	uint32_t AttrLen:16;
+	/* Marks start of Value (ATTRIBUTE_ENTRY) */
+	struct lpfc_fdmi_attr_entry AttrValue;
+} __packed;
 
 /*
  * HBA Attribute Block
@@ -1394,12 +1383,19 @@ struct lpfc_fdmi_hba_ident {
 };
 
 /*
+ * Registered Port List Format
+ */
+struct lpfc_fdmi_reg_port_list {
+	uint32_t EntryCnt;
+	struct lpfc_fdmi_port_entry pe;
+} __packed;
+
+/*
  * Register HBA(RHBA)
  */
 struct lpfc_fdmi_reg_hba {
 	struct lpfc_fdmi_hba_ident hi;
-	struct lpfc_fdmi_reg_port_list rpl;	/* variable-length array */
-/* struct lpfc_fdmi_attr_block   ab; */
+	struct lpfc_fdmi_reg_port_list rpl;
 };
 
 /*
-- 
2.13.7

