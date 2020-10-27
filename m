Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D087C388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BC03221F8
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Cd6gKEMW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751870AbgJ0NIo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 09:08:44 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:40566 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751867AbgJ0NIo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 09:08:44 -0400
Received: by mail-pj1-f53.google.com with SMTP id l2so719477pjt.5
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2020 06:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=iCjNlkAC1hiqYl20R4fS0nBpC9MmmscC3JayasWz/pg=;
        b=Cd6gKEMW335MwUKGAtPU0Y3984+LurxobwvO+EFmUirn3ME9cwXWEU3ZItnlhOXU79
         nfhbQUKp/8xLyH8CBOnLwGxPuoPqfgPiJeycXQoam6d7F3PjBZNK3aZgKEOKvT+yucOM
         HLI/tkVFFzdJ6X05Nr0LrZdHQJ9843QuvA/EY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=iCjNlkAC1hiqYl20R4fS0nBpC9MmmscC3JayasWz/pg=;
        b=d13Fy/+OdX0yVxYVYpaLvy7cQ7YYcg7PWAb/NEc2JWbkqkNNVjXLhgYueylLt/tQbm
         Wx2puIIBHQVYfZhYmuO4Fwv71nK0AhxnX8R0L9KVoRG6xiLjaxZgs5bpJw12rgSDTEYQ
         z1yOGnT6MbVmj8qfxbymKN6VXhXRJqwRZ0WrZ6ZIpgAU4on0Mw+dsdVwPkGN1d0MsB1P
         C5/RIDoTxzAuFgYkm8uZ/mK8IUtqpbkA2fIpVGBeF2lLSP31XmfK1Ghk3B55EKCO7DdC
         oB413FyKXP1X7l3aBOdAfnftpU40QtUZuuU0QcOEnOJNTFdCN3jiU/6BmerKRn1ME4r3
         iEUg==
X-Gm-Message-State: AOAM5332OZkIit/0oytbYmhVMqdtr6sybAyu/q1GCW3rVtyo1+oTl5y4
        lLpigWJucO63OPWNitR+MGFbDQ==
X-Google-Smtp-Source: ABdhPJz+LPTGlTTsoogpGDgcbLvzWMIPFZ0FdOE2zwkMz6bFuA8SJQedIrz4KRETHuit9SxRSn8FCA==
X-Received: by 2002:a17:90a:9504:: with SMTP id t4mr2073176pjo.82.1603804122770;
        Tue, 27 Oct 2020 06:08:42 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b24sm2009319pge.59.2020.10.27.06.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 06:08:42 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 08/14] mpt3sas: Update hba_port objects after host reset
Date:   Tue, 27 Oct 2020 18:38:41 +0530
Message-Id: <20201027130847.9962-9-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
References: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000e37b505b2a6bf73"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000000e37b505b2a6bf73
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
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v1:
Fix below compilation warning reported by kernel test robot,
drivers/scsi/mpt3sas/mpt3sas_scsih.c:5940
 _scsih_look_and_get_matched_port_entry() error:
 uninitialized symbol 'matched_code'.

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 338 +++++++++++++++++++++++++++
 1 file changed, 338 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index afb381d..3752314 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -5816,6 +5816,342 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
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
+	NOT_MATCHED = 0,
+	MATCHED_WITH_ADDR_AND_PHYMASK,
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
+	enum hba_port_matched_codes matched_code = NOT_MATCHED;
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
@@ -9790,6 +10126,7 @@ mpt3sas_scsih_reset_done_handler(struct MPT3SAS_ADAPTER *ioc)
 	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_DONE_RESET\n", __func__));
 	if ((!ioc->is_driver_loading) && !(disable_discovery > 0 &&
 					   !ioc->sas_hba.num_phys)) {
+		_scsih_sas_port_refresh(ioc);
 		_scsih_prep_device_scan(ioc);
 		_scsih_create_enclosure_list_after_reset(ioc);
 		_scsih_search_responding_sas_devices(ioc);
@@ -9837,6 +10174,7 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 			ssleep(1);
 		}
 		_scsih_remove_unresponding_devices(ioc);
+		_scsih_del_dirty_port_entries(ioc);
 		_scsih_scan_for_devices_after_reset(ioc);
 		_scsih_set_nvme_max_shutdown_latency(ioc);
 		break;
-- 
2.18.4


--0000000000000e37b505b2a6bf73
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
NQBIWibQVsUIzuc6tSaJmQFTahbi8vqFX8otmnMf9UQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDI3MTMwODQzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBACM9teJQRNfLL1OJQbhh
CrqKkrbgT7MHINZPb7eYDkC8KzRo/mCLs+NcvkgcBI0+1a0VwW1ttTMF+vbGj/uggPEMnYaGeV2K
fxMNswhGWmwx+FkKTnlORtx2FNx5neggWTDXAGdQ1YbCQ00Q56fQ5WCwuRPCsuZ14Q43k8nCsHuT
GRVjRxUusrlVItGeC/Kwx3JHyfTDxUx7f8t/0ATFlbnjrmmmHbzQvMPmkZ1lHptRadBg4lSlh7ZS
nIS1f6Gb+p1L+jlpjq2Gf4M1zi7+c0T2WJI8/TKDYRL9iSelhWglFhjyMxvgRNtDc7ZJhTxM+hWJ
NdyLQBQHIOTUA/RVvz0=
--0000000000000e37b505b2a6bf73--
