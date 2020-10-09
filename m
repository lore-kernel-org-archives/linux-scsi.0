Return-Path: <SRS0=VN9r=DQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A19CC4363A
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C7622284
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Oct 2020 17:14:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YIaD2A6h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733147AbgJIROj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Oct 2020 13:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733083AbgJIROj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2020 13:14:39 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12B9C0613D7
        for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2020 10:14:38 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r21so4334030pgj.5
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2020 10:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=IclO2HlxPRhT4BbIN6P/mDHLjuqK7FEWZ1hl5dUZ3Qw=;
        b=YIaD2A6hrS6lnJK7Wgl//l+8HKqH+6Ugq+KRO5zjhAyYGQIT2prKxlo3+TDk09sE6O
         ftm533z6UpPwNOiKBCzhEpzfQtGigYDrzrJiDJf/FQ+QmftowfsTHunj7xuMSLIymy35
         g9FzlQU0cxWH9kp352Z97TQV35V9qNW+6W3ww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=IclO2HlxPRhT4BbIN6P/mDHLjuqK7FEWZ1hl5dUZ3Qw=;
        b=mydkx8QIBQ7/ul4dtQobqVgvaDtWsfuFZBpWriF1yL/0JPTT/49GCvWUA4EflOPO2Y
         3duP0ZfoPXIjKlzrnqM/gD7m7l0SVItQyEc2AA3Jf2y8gGWvXACxO/CiIjlk882VxCss
         gc5X6zoVQCNR7QST8A6UeZYksTbSrKGIXq+AL8ZDbkLos1KHcqEYtKUeDabW4NfKni3q
         lO4hvY3MAJRSvm/L7sJ70wqFO97QtRIT45F3p58tZwznXREN1iNX2DwLZiKr/iIYhbsS
         H+jFh4hQ60gmfoYiFNLS2uLA6Bi/8skRrXoRWp3yi0kRDPKKXsPjMSXwL+5Z2HH/CMyG
         MwUg==
X-Gm-Message-State: AOAM530f8JRSRTiZJNtnl/I2qQBQxjU+rD4K6qPkGpBUxbbM+y09iCoI
        Jow4pjdljAPW2UD5lPBK4w2ihA==
X-Google-Smtp-Source: ABdhPJzatC2CJByEegYlUWznb99ju+/0AsD15UY49sqsXkptSdD7G35Y/nsAHM78+HohhK6ER/H58g==
X-Received: by 2002:a17:90a:6fe5:: with SMTP id e92mr5592756pjk.98.1602263677904;
        Fri, 09 Oct 2020 10:14:37 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id fy24sm12299055pjb.35.2020.10.09.10.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:14:37 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 08/14] mpt3sas: Update hba_port objects after host reset
Date:   Fri,  9 Oct 2020 22:44:34 +0530
Message-Id: <20201009171440.4949-9-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201009171440.4949-1-sreekanth.reddy@broadcom.com>
References: <20201009171440.4949-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000064fad205b140157e"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000064fad205b140157e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

During host reset there are chances that the Port number
allocated by the firmware for the attached devices may change.
Also it may be possible that some HBA phy’s may go down/come up
after reset. So the driver can’t just trust the HBA Port table
that it has populated before host reset as valid. So it has to
update the HBA Port table in such a way that it shouldn’t
disturb the drives which are still accessible even after
host reset.

Driver follows below algorithm to update the ‘HBA Port table’
during host reset,
  I. After host reset operation and before marking the
     devices as responding/non-responding, create a temporary
     Port table called “New Port table” by parsing each of the
     HBA PHY’s Phy data info read from SAS IOUnit Page0,
        a. Check whether Phy’s negotiated link rate is greater
           than 1.5Gbps, if not go to next Phy,
        b. Get the SAS Address of the attached device,
        c. Create a new entry in the ‘New Port table’ with
           SAS Address field filled with attached device’s
           SAS Address, port number with Phy’s Port number
           (read from SAS IOUnit Page0) and enable bit in the
           ‘Phy mask’ field corresponding to current Phy number.
           New entry is created only if the driver won’t find
           any entry in the ‘New Port table’ which matches with
           attached device ‘SAS Address’ & ‘Port Number’. If it
           finds an entry with matches with attached device
           ‘SAS Address’ & ‘Port Number’ then the driver takes
           that matched entry and will enable current Phy number
           bit in the ‘Phy mask’ field.
        d. After parsing all the HBA phy’s info, the driver will
           have complete Port table info in “New Port table”.
  II. Mark all the existing sas_device & sas_expander device
      structures as ‘dirty’.
  III. Mark each entry of the HBA Port list’s as ‘dirty’.
  IV. Take each entry from ‘New Port table’ one by one and check
      whether the taken entry has any corresponding matched entry
      (which is marked as ‘dirty’) in the HBA Port table or not.
      While looking for a corresponding matched entry, look for
      matched entry in the sequence from top row to bottom row
      listed in below table. If you find any matched entry
      (according to any of the rules tabulated below) then perform
      the action mentioned in the ‘Action’ column in that matched rule.
===========================================================================
|Search  |SAS     | Phy Mask | Port    | Possibilities| Action            |
|every   |Address |    or    | Number  |              | required          |
|entry   |matched?| subset of| matched?|              |                   |
|in below|        | phy mask |         |              |                   |
|sequence|        | matched? |         |              |                   |
===========================================================================
|  1     |matched | matched  | matched | nothing      |* unmark HBA port  |
|        |        |          |         | changed      |table entry as     |
|        |        |          |         |              |dirty              |
---------------------------------------------------------------------------
|  2     |matched | matched  | not     | port number  |* Update port      |
|        |        |          | matched | is changed   |number in the      |
|        |        |          |         |              |matched port table |
|        |        |          |         |              |entry              |
|        |        |          |         |              |* unmask HBA port  |
|        |        |          |         |              |table entry as     |
|        |        |          |         |              | dirty             |
---------------------------------------------------------------------------
|  3.a   |matched | subset of| matched |some phys     |*Add these new phys|
|        |        | phy mask | (or)    |might have    |to current port in |
|        |        | matched  | not     |enabled which |STL                |
|        |        |          | matched |are previously|* Update phy mask  |
|        |        |          | (but    |disabled      |field in HBA's port|
|        |        |          | first   |              |tables's matched   |
|        |        |          | look for|              |entry,             |
|        |        |          | matched |              |*Update port number|
|        |        |          | one)    |              |in the matched port|
|        |        |          |         |              |table entry (if    |
|        |        |          |         |              |port number is     |
|        |        |          |         |              |changed),          |
|        |        |          |         |              |* Unmask HBA port  |
|        |        |          |         |              |table entry as     |
|        |        |          |         |              |dirty              |
---------------------------------------------------------------------------
|  3.b   |matched | subset of| matched |some phys     |*Remove these phys |
|        |        | phy mask | (or)    |might have    |from current port  |
|        |        | matched  | not     |disabled which|in STL             |
|        |        |          | matched |are previously|* Update phy mask  |
|        |        |          | (but    |enabled       |field in HBA's port|
|        |        |          | first   |              |tables's matched   |
|        |        |          | look for|              |entry,             |
|        |        |          | matched |              |*Update port number|
|        |        |          | one)    |              |in the matched port|
|        |        |          |         |              |table entry (if    |
|        |        |          |         |              |port number is     |
|        |        |          |         |              |changed),          |
|        |        |          |         |              |* Unmask HBA port  |
|        |        |          |         |              |table entry as     |
|        |        |          |         |              |dirty              |
---------------------------------------------------------------------------
|  4     |matched | not      | matched |A cable       |*Remove old phys & |
|        |        | matched  | (or)    |attached to an|new phys to current|
|        |        |          | not     |expander is   |port in STL        |
|        |        |          | matched |changed to    |* Update phy mask  |
|        |        |          |         |another HBA   |field in HBA's port|
|        |        |          |         |port during   |tables's matched   |
|        |        |          |         |reset         |entry,             |
|        |        |          |         |              |*Update port number|
|        |        |          |         |              |in the matched port|
|        |        |          |         |              |table entry (if    |
|        |        |          |         |              |port number is     |
|        |        |          |         |              |changed),          |
|        |        |          |         |              |* Unmask HBA port  |
|        |        |          |         |              |table entry as     |
|        |        |          |         |              |dirty              |
---------------------------------------------------------------------------

V. Delete the hba_port objects which are still marked as dirty.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 337 +++++++++++++++++++++++++++
 1 file changed, 337 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index afb381d..05d43c4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5816,6 +5816,341 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	return 0;
 }
 
+/**
+ * _scsih_get_port_table_after_reset - Construct temporary port table
+ * @ioc: per adapter object
+ * @port_table: address where port table needs to be constructed
+ *
+ * return number of HBA port entries available after reset.
+ */
+static int
+_scsih_get_port_table_after_reset(struct MPT3SAS_ADAPTER *ioc,
+	struct hba_port *port_table)
+{
+	u16 sz, ioc_status;
+	int i, j;
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2SasIOUnitPage0_t *sas_iounit_pg0 = NULL;
+	u16 attached_handle;
+	u64 attached_sas_addr;
+	u8 found = 0, port_count = 0, port_id;
+
+	sz = offsetof(Mpi2SasIOUnitPage0_t, PhyData) + (ioc->sas_hba.num_phys
+	    * sizeof(Mpi2SasIOUnit0PhyData_t));
+	sas_iounit_pg0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_iounit_pg0) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return port_count;
+	}
+
+	if ((mpt3sas_config_get_sas_iounit_pg0(ioc, &mpi_reply,
+	    sas_iounit_pg0, sz)) != 0)
+		goto out;
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
+		goto out;
+	for (i = 0; i < ioc->sas_hba.num_phys; i++) {
+		found = 0;
+		if ((sas_iounit_pg0->PhyData[i].NegotiatedLinkRate >> 4) <
+		    MPI2_SAS_NEG_LINK_RATE_1_5)
+			continue;
+		attached_handle =
+		    le16_to_cpu(sas_iounit_pg0->PhyData[i].AttachedDevHandle);
+		if (_scsih_get_sas_address(
+		    ioc, attached_handle, &attached_sas_addr) != 0) {
+			ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			    __FILE__, __LINE__, __func__);
+			continue;
+		}
+
+		for (j = 0; j < port_count; j++) {
+			port_id = sas_iounit_pg0->PhyData[i].Port;
+			if (port_table[j].port_id == port_id &&
+			    port_table[j].sas_address == attached_sas_addr) {
+				port_table[j].phy_mask |= (1 << i);
+				found = 1;
+				break;
+			}
+		}
+
+		if (found)
+			continue;
+
+		port_id = sas_iounit_pg0->PhyData[i].Port;
+		port_table[port_count].port_id = port_id;
+		port_table[port_count].phy_mask = (1 << i);
+		port_table[port_count].sas_address = attached_sas_addr;
+		port_count++;
+	}
+out:
+	kfree(sas_iounit_pg0);
+	return port_count;
+}
+
+enum hba_port_matched_codes {
+	MATCHED_WITH_ADDR_AND_PHYMASK = 1,
+	MATCHED_WITH_ADDR_SUBPHYMASK_AND_PORT,
+	MATCHED_WITH_ADDR_AND_SUBPHYMASK,
+	MATCHED_WITH_ADDR,
+};
+
+/**
+ * _scsih_look_and_get_matched_port_entry - Get matched hba port entry
+ *					from HBA port table
+ * @ioc: per adapter object
+ * @port_entry - hba port entry from temporary port table which needs to be
+ *		searched for matched entry in the HBA port table
+ * @matched_port_entry - save matched hba port entry here
+ * @count - count of matched entries
+ *
+ * return type of matched entry found.
+ */
+static enum hba_port_matched_codes
+_scsih_look_and_get_matched_port_entry(struct MPT3SAS_ADAPTER *ioc,
+	struct hba_port *port_entry,
+	struct hba_port **matched_port_entry, int *count)
+{
+	struct hba_port *port_table_entry, *matched_port = NULL;
+	enum hba_port_matched_codes matched_code;
+	int lcount = 0;
+	*matched_port_entry = NULL;
+
+	list_for_each_entry(port_table_entry, &ioc->port_table_list, list) {
+		if (!(port_table_entry->flags & HBA_PORT_FLAG_DIRTY_PORT))
+			continue;
+
+		if ((port_table_entry->sas_address == port_entry->sas_address)
+		    && (port_table_entry->phy_mask == port_entry->phy_mask)) {
+			matched_code = MATCHED_WITH_ADDR_AND_PHYMASK;
+			matched_port = port_table_entry;
+			break;
+		}
+
+		if ((port_table_entry->sas_address == port_entry->sas_address)
+		    && (port_table_entry->phy_mask & port_entry->phy_mask)
+		    && (port_table_entry->port_id == port_entry->port_id)) {
+			matched_code = MATCHED_WITH_ADDR_SUBPHYMASK_AND_PORT;
+			matched_port = port_table_entry;
+			continue;
+		}
+
+		if ((port_table_entry->sas_address == port_entry->sas_address)
+		    && (port_table_entry->phy_mask & port_entry->phy_mask)) {
+			if (matched_code ==
+			    MATCHED_WITH_ADDR_SUBPHYMASK_AND_PORT)
+				continue;
+			matched_code = MATCHED_WITH_ADDR_AND_SUBPHYMASK;
+			matched_port = port_table_entry;
+			continue;
+		}
+
+		if (port_table_entry->sas_address == port_entry->sas_address) {
+			if (matched_code ==
+			    MATCHED_WITH_ADDR_SUBPHYMASK_AND_PORT)
+				continue;
+			if (matched_code == MATCHED_WITH_ADDR_AND_SUBPHYMASK)
+				continue;
+			matched_code = MATCHED_WITH_ADDR;
+			matched_port = port_table_entry;
+			lcount++;
+		}
+	}
+
+	*matched_port_entry = matched_port;
+	if (matched_code ==  MATCHED_WITH_ADDR)
+		*count = lcount;
+	return matched_code;
+}
+
+/**
+ * _scsih_del_phy_part_of_anther_port - remove phy if it
+ *				is a part of anther port
+ *@ioc: per adapter object
+ *@port_table: port table after reset
+ *@index: hba port entry index
+ *@port_count: number of ports available after host reset
+ *@offset: HBA phy bit offset
+ *
+ */
+static void
+_scsih_del_phy_part_of_anther_port(struct MPT3SAS_ADAPTER *ioc,
+	struct hba_port *port_table,
+	int index, u8 port_count, int offset)
+{
+	struct _sas_node *sas_node = &ioc->sas_hba;
+	u32 i, found = 0;
+
+	for (i = 0; i < port_count; i++) {
+		if (i == index)
+			continue;
+
+		if (port_table[i].phy_mask & (1 << offset)) {
+			mpt3sas_transport_del_phy_from_an_existing_port(
+			    ioc, sas_node, &sas_node->phy[offset]);
+			found = 1;
+			break;
+		}
+	}
+	if (!found)
+		port_table[index].phy_mask |= (1 << offset);
+}
+
+/**
+ * _scsih_add_or_del_phys_from_existing_port - add/remove phy to/from
+ *						right port
+ *@ioc: per adapter object
+ *@hba_port_entry: hba port table entry
+ *@port_table: temporary port table
+ *@index: hba port entry index
+ *@port_count: number of ports available after host reset
+ *
+ */
+static void
+_scsih_add_or_del_phys_from_existing_port(struct MPT3SAS_ADAPTER *ioc,
+	struct hba_port *hba_port_entry, struct hba_port *port_table,
+	int index, int port_count)
+{
+	u32 phy_mask, offset = 0;
+	struct _sas_node *sas_node = &ioc->sas_hba;
+
+	phy_mask = hba_port_entry->phy_mask ^ port_table[index].phy_mask;
+
+	for (offset = 0; offset < ioc->sas_hba.num_phys; offset++) {
+		if (phy_mask & (1 << offset)) {
+			if (!(port_table[index].phy_mask & (1 << offset))) {
+				_scsih_del_phy_part_of_anther_port(
+				    ioc, port_table, index, port_count,
+				    offset);
+				continue;
+			}
+			if (sas_node->phy[offset].phy_belongs_to_port)
+				mpt3sas_transport_del_phy_from_an_existing_port(
+				    ioc, sas_node, &sas_node->phy[offset]);
+			mpt3sas_transport_add_phy_to_an_existing_port(
+			    ioc, sas_node, &sas_node->phy[offset],
+			    hba_port_entry->sas_address,
+			    hba_port_entry);
+		}
+	}
+}
+
+/**
+ * _scsih_del_dirty_port_entries - delete dirty port entries from port list
+ *					after host reset
+ *@ioc: per adapter object
+ *
+ */
+static void
+_scsih_del_dirty_port_entries(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct hba_port *port, *port_next;
+
+	list_for_each_entry_safe(port, port_next,
+	    &ioc->port_table_list, list) {
+		if (!(port->flags & HBA_PORT_FLAG_DIRTY_PORT) ||
+		    port->flags & HBA_PORT_FLAG_NEW_PORT)
+			continue;
+
+		drsprintk(ioc, ioc_info(ioc,
+		    "Deleting port table entry %p having Port: %d\t Phy_mask 0x%08x\n",
+		    port, port->port_id, port->phy_mask));
+		list_del(&port->list);
+		kfree(port);
+	}
+}
+
+/**
+ * _scsih_sas_port_refresh - Update HBA port table after host reset
+ * @ioc: per adapter object
+ */
+static void
+_scsih_sas_port_refresh(struct MPT3SAS_ADAPTER *ioc)
+{
+	u32 port_count = 0;
+	struct hba_port *port_table;
+	struct hba_port *port_table_entry;
+	struct hba_port *port_entry = NULL;
+	int i, j, count = 0, lcount = 0;
+	int ret;
+	u64 sas_addr;
+
+	drsprintk(ioc, ioc_info(ioc,
+	    "updating ports for sas_host(0x%016llx)\n",
+	    (unsigned long long)ioc->sas_hba.sas_address));
+
+	port_table = kcalloc(ioc->sas_hba.num_phys,
+	    sizeof(struct hba_port), GFP_KERNEL);
+	if (!port_table)
+		return;
+
+	port_count = _scsih_get_port_table_after_reset(ioc, port_table);
+	if (!port_count)
+		return;
+
+	drsprintk(ioc, ioc_info(ioc, "New Port table\n"));
+	for (j = 0; j < port_count; j++)
+		drsprintk(ioc, ioc_info(ioc,
+		    "Port: %d\t Phy_mask 0x%08x\t sas_addr(0x%016llx)\n",
+		    port_table[j].port_id,
+		    port_table[j].phy_mask, port_table[j].sas_address));
+
+	list_for_each_entry(port_table_entry, &ioc->port_table_list, list)
+		port_table_entry->flags |= HBA_PORT_FLAG_DIRTY_PORT;
+
+	drsprintk(ioc, ioc_info(ioc, "Old Port table\n"));
+	port_table_entry = NULL;
+	list_for_each_entry(port_table_entry, &ioc->port_table_list, list) {
+		drsprintk(ioc, ioc_info(ioc,
+		    "Port: %d\t Phy_mask 0x%08x\t sas_addr(0x%016llx)\n",
+		    port_table_entry->port_id,
+		    port_table_entry->phy_mask,
+		    port_table_entry->sas_address));
+	}
+
+	for (j = 0; j < port_count; j++) {
+		ret = _scsih_look_and_get_matched_port_entry(ioc,
+		    &port_table[j], &port_entry, &count);
+		if (!port_entry) {
+			drsprintk(ioc, ioc_info(ioc,
+			    "No Matched entry for sas_addr(0x%16llx), Port:%d\n",
+			    port_table[j].sas_address,
+			    port_table[j].port_id));
+			continue;
+		}
+
+		switch (ret) {
+		case MATCHED_WITH_ADDR_SUBPHYMASK_AND_PORT:
+		case MATCHED_WITH_ADDR_AND_SUBPHYMASK:
+			_scsih_add_or_del_phys_from_existing_port(ioc,
+			    port_entry, port_table, j, port_count);
+			break;
+		case MATCHED_WITH_ADDR:
+			sas_addr = port_table[j].sas_address;
+			for (i = 0; i < port_count; i++) {
+				if (port_table[i].sas_address == sas_addr)
+					lcount++;
+			}
+
+			if (count > 1 || lcount > 1)
+				port_entry = NULL;
+			else
+				_scsih_add_or_del_phys_from_existing_port(ioc,
+				    port_entry, port_table, j, port_count);
+		}
+
+		if (!port_entry)
+			continue;
+
+		if (port_entry->port_id != port_table[j].port_id)
+			port_entry->port_id = port_table[j].port_id;
+		port_entry->flags &= ~HBA_PORT_FLAG_DIRTY_PORT;
+		port_entry->phy_mask = port_table[j].phy_mask;
+	}
+
+	port_table_entry = NULL;
+}
+
 /**
  * _scsih_sas_host_refresh - refreshing sas host object contents
  * @ioc: per adapter object
@@ -9790,6 +10125,7 @@ mpt3sas_scsih_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_DONE_RESET\n", __func__));
 	if ((!ioc->is_driver_loading) && !(disable_discovery > 0 &&
 					   !ioc->sas_hba.num_phys)) {
+		_scsih_sas_port_refresh(ioc);
 		_scsih_prep_device_scan(ioc);
 		_scsih_create_enclosure_list_after_reset(ioc);
 		_scsih_search_responding_sas_devices(ioc);
@@ -9837,6 +10173,7 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 			ssleep(1);
 		}
 		_scsih_remove_unresponding_devices(ioc);
+		_scsih_del_dirty_port_entries(ioc);
 		_scsih_scan_for_devices_after_reset(ioc);
 		_scsih_set_nvme_max_shutdown_latency(ioc);
 		break;
-- 
2.18.4


--00000000000064fad205b140157e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
Rag/s/0IKyxAQsoBcla5ZufuDE5ir/mlnYktkPJdg+kns/OPDsINSyWqNYE9PKy9+3cp/fItNFtH
krg1AgMBAAGjggHTMIIBzzAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsG
AQUFBzAChkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2ln
bjJzaGEyZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29t
L2dzcGVyc29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEF
BQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBE
BgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWdu
MnNoYTJnMy5jcmwwJwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNV
HSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4E
FgQU1CyhXqcQo40SZ7kFS/AiOnRW6lMwDQYJKoZIhvcNAQELBQADggEBAFeMmmz112eNFAV8Ense
5WremClV5F3Md1xS0yXKqxlgakUJaOI/Fai7OLQaQqsEoxW6/QqWEi1wbZOccbdritOkL5b7sVUp
SU9OfuIlV8c3XMLaWSIluy+0ImtRJ49jDCI4KtQESHrqfQRZcc1C/avZvNED3U4b10U6N3SY+59b
fm2Vlwacwp+8ESTp49DsLcJqc4U/0rUZxLWtgPokzS+ovX+JAu8zx1SmOzUC4hj4Bp6Vnfd5KWUK
JJQBmQHXii+acSeTgHmPWUYs3tYQ0uIX0Yy8LUWPdGbEq+KWepzY2otC+iVWdngCCv8Nf1Xo1jki
AGJ6hrlWFE0qJVWv25sxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9i
YWxTaWduIG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hB
MjU2IC0gRzMCDBmG1a14/wFg8qBhUjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg
b8QOMx+Z0rm3uRdUuvLvIrzrUKq+XE3VUEV1FzW1pyIwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDA5MTcxNDM4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAHkKLzgTvoI4qeuYGkJP
HAY+17C2j2jEyHi6hvTmHtcsBLerztADQWQYiUoDQVEKXDvqNVWvobvC6pyqH6vBVT/zYdIjWvcc
Kvr4aDHMbdVU3DKXJSa0I9nEDnl5Biq5UglA+SetFTIgW3pf3KZmtJB0CfnvaBX3/0qCMuC+WgZ7
ftmWID8CDsj+e8uLBG7fzKNL0A6usxL6jJpxs78v1ALAxLl7m/eNYWYzY9jvjb5v9WH5xud6ERLu
6LaoKGTInh3I8whw6ypxW1gw7H3wP/tkr0KTbz4VIINPsk70IDSz8b+tl1MZTS/8ILnb8vA33B13
BNe9K+jW/msUSxMB75Y=
--00000000000064fad205b140157e--
