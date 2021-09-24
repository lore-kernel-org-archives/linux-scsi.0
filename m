Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FC2C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 23:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9CD66103B
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 23:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344720AbhIXX2n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 19:28:43 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:55832 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344528AbhIXX2m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 19:28:42 -0400
Received: by mail-pj1-f47.google.com with SMTP id t20so8017114pju.5
        for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2021 16:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hvmKI3tI6Lk4GZK8bAnGDjaIMCCkPERzd2sV5e3PG90=;
        b=AgbTRRnHYI0P7v7iK+UEBS7VNVGZ4oLxm9sLaI6xjRJVi2RZQBBEYQA5tut6f7BS3B
         UiX2hy03cLr30zuvDtkY0G0wrvvGmNusjOZzcVHu+yYGyUkXAmwjc32LSheMmr2dPp9q
         5qpL1/vqVLsmct84+1r1opErs2YIWtukwpZ1pl4R8buglIrig6ihUPr35Wm02uLyKQ7V
         kDJN0JzRk0paJY2VofVlyOp0CEjryAX226wmtbQ9DaY3jT2peWKtxAzEeFaUkjmQi8F7
         rS+Id4jP4pyYv6RRKNcRFFZ6usq3YaKLjGptxIl0F4D+YIrkDv2rhRUHQ2xqqdEXZwzI
         KVcw==
X-Gm-Message-State: AOAM531vUkvceyIHdI8TGRGpVSQdCI/KoY3k7K0zwGSxCeKUG7aSytqj
        57/g4lrtdiMi1HE9n9B4Y9M=
X-Google-Smtp-Source: ABdhPJxu9ZI2W7kH9n7B3aENAtfI5AeM/38bZWObcpTflAUSc+brIGNiLKFTFbt6K7iDOl/u3zuGCA==
X-Received: by 2002:a17:90b:1b48:: with SMTP id nv8mr5192152pjb.228.1632526028330;
        Fri, 24 Sep 2021 16:27:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ee5b:ba55:22d5:49c9])
        by smtp.gmail.com with ESMTPSA id b142sm10200043pfb.17.2021.09.24.16.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 16:27:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microchip.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Brian King <brking@us.ibm.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        ching Huang <ching2048@areca.com.tw>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Yufen Yu <yuyufen@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/2] scsi: Register SCSI host sysfs attributes earlier
Date:   Fri, 24 Sep 2021 16:26:34 -0700
Message-Id: <20210924232635.1637763-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210924232635.1637763-1-bvanassche@acm.org>
References: <20210924232635.1637763-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A quote from Documentation/driver-api/driver-model/device.rst:
"Word of warning:  While the kernel allows device_create_file() and
device_remove_file() to be called on a device at any time, userspace has
strict expectations on when attributes get created.  When a new device is
registered in the kernel, a uevent is generated to notify userspace (like
udev) that a new device is available.  If attributes are added after the
device is registered, then userspace won't get notified and userspace will
not know about the new attributes."

Hence register SCSI host sysfs attributes before the SCSI host shost_dev
uevent is emitted instead of after that event has been emitted.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/ahci.h                        |   2 +-
 drivers/ata/ata_piix.c                    |   4 +-
 drivers/ata/libahci.c                     |  20 +-
 drivers/infiniband/ulp/srp/ib_srp.c       |  44 ++--
 drivers/message/fusion/mptscsih.c         |  26 +-
 drivers/message/fusion/mptscsih.h         |   2 +-
 drivers/s390/scsi/zfcp_ext.h              |   2 +-
 drivers/s390/scsi/zfcp_sysfs.c            |  12 +-
 drivers/scsi/3w-9xxx.c                    |   4 +-
 drivers/scsi/3w-sas.c                     |   4 +-
 drivers/scsi/3w-xxxx.c                    |   4 +-
 drivers/scsi/aacraid/linit.c              |  24 +-
 drivers/scsi/arcmsr/arcmsr.h              |   2 +-
 drivers/scsi/arcmsr/arcmsr_attr.c         |  24 +-
 drivers/scsi/be2iscsi/be_main.c           |  17 +-
 drivers/scsi/bfa/bfad_attr.c              |  52 ++--
 drivers/scsi/bfa/bfad_im.h                |   4 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c         |   4 +-
 drivers/scsi/bnx2i/bnx2i.h                |   2 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c          |   6 +-
 drivers/scsi/csiostor/csio_scsi.c         |  16 +-
 drivers/scsi/cxlflash/main.c              |  32 +--
 drivers/scsi/fnic/fnic.h                  |   2 +-
 drivers/scsi/fnic/fnic_attrs.c            |   8 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c    |   4 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c    |   4 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  10 +-
 drivers/scsi/hosts.c                      |  10 +-
 drivers/scsi/hpsa.c                       |  22 +-
 drivers/scsi/hptiop.c                     |   6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c            |  18 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c          |  18 +-
 drivers/scsi/ipr.c                        |  18 +-
 drivers/scsi/isci/init.c                  |   4 +-
 drivers/scsi/lpfc/lpfc_attr.c             | 296 +++++++++++-----------
 drivers/scsi/lpfc/lpfc_crtn.h             |   4 +-
 drivers/scsi/megaraid/megaraid_mbox.c     |   4 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |  20 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h       |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c        |  56 ++--
 drivers/scsi/mvsas/mv_init.c              |   8 +-
 drivers/scsi/myrb.c                       |  10 +-
 drivers/scsi/myrs.c                       |  22 +-
 drivers/scsi/ncr53c8xx.c                  |   4 +-
 drivers/scsi/pcmcia/sym53c500_cs.c        |   4 +-
 drivers/scsi/pm8001/pm8001_ctl.c          |  56 ++--
 drivers/scsi/pm8001/pm8001_sas.h          |   2 +-
 drivers/scsi/pmcraid.c                    |   8 +-
 drivers/scsi/qedf/qedf.h                  |   2 +-
 drivers/scsi/qedf/qedf_attr.c             |   6 +-
 drivers/scsi/qedi/qedi_gbl.h              |   2 +-
 drivers/scsi/qedi/qedi_sysfs.c            |   6 +-
 drivers/scsi/qla2xxx/qla_attr.c           |  98 +++----
 drivers/scsi/qla2xxx/qla_gbl.h            |   3 +-
 drivers/scsi/qla4xxx/ql4_attr.c           |  32 +--
 drivers/scsi/qla4xxx/ql4_glbl.h           |   2 +-
 drivers/scsi/scsi_priv.h                  |   2 +-
 drivers/scsi/scsi_sysfs.c                 |  21 +-
 drivers/scsi/smartpqi/smartpqi_init.c     |  22 +-
 drivers/scsi/snic/snic.h                  |   2 +-
 drivers/scsi/snic/snic_attrs.c            |  10 +-
 include/scsi/scsi_host.h                  |   4 +-
 62 files changed, 568 insertions(+), 571 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 2e89499bd9c3..a1f632bb6c8b 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -376,7 +376,7 @@ struct ahci_host_priv {
 
 extern int ahci_ignore_sss;
 
-extern struct device_attribute *ahci_shost_attrs[];
+extern struct attribute *ahci_shost_attrs[];
 extern struct device_attribute *ahci_sdev_attrs[];
 
 /*
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 3ca7720e7d8f..9edeb9ea1cc7 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1085,8 +1085,8 @@ static struct ata_port_operations ich_pata_ops = {
 	.set_dmamode		= ich_set_dmamode,
 };
 
-static struct device_attribute *piix_sidpr_shost_attrs[] = {
-	&dev_attr_link_power_management_policy,
+static struct attribute *piix_sidpr_shost_attrs[] = {
+	&dev_attr_link_power_management_policy.attr,
 	NULL
 };
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 5b3fa2cbe722..7df5d11e6bd2 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -108,16 +108,16 @@ static DEVICE_ATTR(em_buffer, S_IWUSR | S_IRUGO,
 		   ahci_read_em_buffer, ahci_store_em_buffer);
 static DEVICE_ATTR(em_message_supported, S_IRUGO, ahci_show_em_supported, NULL);
 
-struct device_attribute *ahci_shost_attrs[] = {
-	&dev_attr_link_power_management_policy,
-	&dev_attr_em_message_type,
-	&dev_attr_em_message,
-	&dev_attr_ahci_host_caps,
-	&dev_attr_ahci_host_cap2,
-	&dev_attr_ahci_host_version,
-	&dev_attr_ahci_port_cmd,
-	&dev_attr_em_buffer,
-	&dev_attr_em_message_supported,
+struct attribute *ahci_shost_attrs[] = {
+	&dev_attr_link_power_management_policy.attr,
+	&dev_attr_em_message_type.attr,
+	&dev_attr_em_message.attr,
+	&dev_attr_ahci_host_caps.attr,
+	&dev_attr_ahci_host_cap2.attr,
+	&dev_attr_ahci_host_version.attr,
+	&dev_attr_ahci_port_cmd.attr,
+	&dev_attr_em_buffer.attr,
+	&dev_attr_em_message_supported.attr,
 	NULL
 };
 EXPORT_SYMBOL_GPL(ahci_shost_attrs);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 71eda91e810c..957bed2d1829 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1026,10 +1026,14 @@ static int srp_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
  */
 static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 {
-	struct device_attribute **attr;
+	struct attribute **attr;
 
-	for (attr = shost->hostt->shost_attrs; attr && *attr; ++attr)
-		device_remove_file(&shost->shost_dev, *attr);
+	for (attr = shost->hostt->shost_attrs; attr && *attr; ++attr) {
+		struct device_attribute *dev_attr =
+			container_of(*attr, typeof(*dev_attr), attr);
+
+		device_remove_file(&shost->shost_dev, dev_attr);
+	}
 }
 
 static void srp_remove_target(struct srp_target_port *target)
@@ -3050,23 +3054,23 @@ static ssize_t allow_ext_sg_show(struct device *dev,
 
 static DEVICE_ATTR_RO(allow_ext_sg);
 
-static struct device_attribute *srp_host_attrs[] = {
-	&dev_attr_id_ext,
-	&dev_attr_ioc_guid,
-	&dev_attr_service_id,
-	&dev_attr_pkey,
-	&dev_attr_sgid,
-	&dev_attr_dgid,
-	&dev_attr_orig_dgid,
-	&dev_attr_req_lim,
-	&dev_attr_zero_req_lim,
-	&dev_attr_local_ib_port,
-	&dev_attr_local_ib_device,
-	&dev_attr_ch_count,
-	&dev_attr_comp_vector,
-	&dev_attr_tl_retry_count,
-	&dev_attr_cmd_sg_entries,
-	&dev_attr_allow_ext_sg,
+static struct attribute *srp_host_attrs[] = {
+	&dev_attr_id_ext.attr,
+	&dev_attr_ioc_guid.attr,
+	&dev_attr_service_id.attr,
+	&dev_attr_pkey.attr,
+	&dev_attr_sgid.attr,
+	&dev_attr_dgid.attr,
+	&dev_attr_orig_dgid.attr,
+	&dev_attr_req_lim.attr,
+	&dev_attr_zero_req_lim.attr,
+	&dev_attr_local_ib_port.attr,
+	&dev_attr_local_ib_device.attr,
+	&dev_attr_ch_count.attr,
+	&dev_attr_comp_vector.attr,
+	&dev_attr_tl_retry_count.attr,
+	&dev_attr_cmd_sg_entries.attr,
+	&dev_attr_allow_ext_sg.attr,
 	NULL
 };
 
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index ce2e5b21978e..3ae5233ea4dd 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -3218,19 +3218,19 @@ mptscsih_debug_level_store(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(debug_level, S_IRUGO | S_IWUSR,
 	mptscsih_debug_level_show, mptscsih_debug_level_store);
 
-struct device_attribute *mptscsih_host_attrs[] = {
-	&dev_attr_version_fw,
-	&dev_attr_version_bios,
-	&dev_attr_version_mpi,
-	&dev_attr_version_product,
-	&dev_attr_version_nvdata_persistent,
-	&dev_attr_version_nvdata_default,
-	&dev_attr_board_name,
-	&dev_attr_board_assembly,
-	&dev_attr_board_tracer,
-	&dev_attr_io_delay,
-	&dev_attr_device_delay,
-	&dev_attr_debug_level,
+struct attribute *mptscsih_host_attrs[] = {
+	&dev_attr_version_fw.attr,
+	&dev_attr_version_bios.attr,
+	&dev_attr_version_mpi.attr,
+	&dev_attr_version_product.attr,
+	&dev_attr_version_nvdata_persistent.attr,
+	&dev_attr_version_nvdata_default.attr,
+	&dev_attr_board_name.attr,
+	&dev_attr_board_assembly.attr,
+	&dev_attr_board_tracer.attr,
+	&dev_attr_io_delay.attr,
+	&dev_attr_device_delay.attr,
+	&dev_attr_debug_level.attr,
 	NULL,
 };
 
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 2baeefd9be7a..70c0ee22423e 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -131,7 +131,7 @@ extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 extern u8 mptscsih_raid_id_to_num(MPT_ADAPTER *ioc, u8 channel, u8 id);
 extern int mptscsih_is_phys_disk(MPT_ADAPTER *ioc, u8 channel, u8 id);
-extern struct device_attribute *mptscsih_host_attrs[];
+extern struct attribute *mptscsih_host_attrs[];
 extern struct scsi_cmnd	*mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i);
 extern void mptscsih_taskmgmt_response_code(MPT_ADAPTER *ioc, u8 response_code);
 extern void mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd);
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 6bc96d70254d..9b48673789a3 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -185,7 +185,7 @@ extern const struct attribute_group *zfcp_unit_attr_groups[];
 extern const struct attribute_group *zfcp_port_attr_groups[];
 extern struct mutex zfcp_sysfs_port_units_mutex;
 extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
-extern struct device_attribute *zfcp_sysfs_shost_attrs[];
+extern struct attribute *zfcp_sysfs_shost_attrs[];
 bool zfcp_sysfs_port_is_removing(const struct zfcp_port *const port);
 
 /* zfcp_unit.c */
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index b8cd75a872ee..72e3acaff457 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -783,12 +783,12 @@ static ssize_t zfcp_sysfs_adapter_q_full_show(struct device *dev,
 }
 static DEVICE_ATTR(queue_full, S_IRUGO, zfcp_sysfs_adapter_q_full_show, NULL);
 
-struct device_attribute *zfcp_sysfs_shost_attrs[] = {
-	&dev_attr_utilization,
-	&dev_attr_requests,
-	&dev_attr_megabytes,
-	&dev_attr_seconds_active,
-	&dev_attr_queue_full,
+struct attribute *zfcp_sysfs_shost_attrs[] = {
+	&dev_attr_utilization.attr,
+	&dev_attr_requests.attr,
+	&dev_attr_megabytes.attr,
+	&dev_attr_seconds_active.attr,
+	&dev_attr_queue_full.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index e41cc354cc8a..fcf45006f873 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -197,8 +197,8 @@ static struct device_attribute twa_host_stats_attr = {
 };
 
 /* Host attributes initializer */
-static struct device_attribute *twa_host_attrs[] = {
-	&twa_host_stats_attr,
+static struct attribute *twa_host_attrs[] = {
+	&twa_host_stats_attr.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 4fde39da54e4..fb07bc84b227 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -198,8 +198,8 @@ static struct device_attribute twl_host_stats_attr = {
 };
 
 /* Host attributes initializer */
-static struct device_attribute *twl_host_attrs[] = {
-	&twl_host_stats_attr,
+static struct attribute *twl_host_attrs[] = {
+	&twl_host_stats_attr.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 4ee485ab2714..168aecec276c 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -532,8 +532,8 @@ static struct device_attribute tw_host_stats_attr = {
 };
 
 /* Host attributes initializer */
-static struct device_attribute *tw_host_attrs[] = {
-	&tw_host_stats_attr,
+static struct attribute *tw_host_attrs[] = {
+	&tw_host_stats_attr.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3168915adaa7..7e6b913d3fce 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1442,18 +1442,18 @@ static struct device_attribute aac_reset = {
 	.show = aac_show_reset_adapter,
 };
 
-static struct device_attribute *aac_attrs[] = {
-	&aac_model,
-	&aac_vendor,
-	&aac_flags,
-	&aac_kernel_version,
-	&aac_monitor_version,
-	&aac_bios_version,
-	&aac_lld_version,
-	&aac_serial_number,
-	&aac_max_channel,
-	&aac_max_id,
-	&aac_reset,
+static struct attribute *aac_attrs[] = {
+	&aac_model.attr,
+	&aac_vendor.attr,
+	&aac_flags.attr,
+	&aac_kernel_version.attr,
+	&aac_monitor_version.attr,
+	&aac_bios_version.attr,
+	&aac_lld_version.attr,
+	&aac_serial_number.attr,
+	&aac_max_channel.attr,
+	&aac_max_id.attr,
+	&aac_reset.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 6ce57f031df5..7081a84bb43d 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -1041,6 +1041,6 @@ extern uint32_t arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *,
 	struct QBUFFER __iomem *);
 extern void arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *);
 extern struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *);
-extern struct device_attribute *arcmsr_host_attrs[];
+extern struct attribute *arcmsr_host_attrs[];
 extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);
 void arcmsr_free_sysfs_attr(struct AdapterControlBlock *acb);
diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index 57be9609d504..f152da9c0da7 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -58,7 +58,7 @@
 #include <scsi/scsi_transport.h>
 #include "arcmsr.h"
 
-struct device_attribute *arcmsr_host_attrs[];
+struct attribute *arcmsr_host_attrs[];
 
 static ssize_t arcmsr_sysfs_iop_message_read(struct file *filp,
 					     struct kobject *kobj,
@@ -389,16 +389,16 @@ static DEVICE_ATTR(host_fw_numbers_queue, S_IRUGO, arcmsr_attr_host_fw_numbers_q
 static DEVICE_ATTR(host_fw_sdram_size, S_IRUGO, arcmsr_attr_host_fw_sdram_size, NULL);
 static DEVICE_ATTR(host_fw_hd_channels, S_IRUGO, arcmsr_attr_host_fw_hd_channels, NULL);
 
-struct device_attribute *arcmsr_host_attrs[] = {
-	&dev_attr_host_driver_version,
-	&dev_attr_host_driver_posted_cmd,
-	&dev_attr_host_driver_reset,
-	&dev_attr_host_driver_abort,
-	&dev_attr_host_fw_model,
-	&dev_attr_host_fw_version,
-	&dev_attr_host_fw_request_len,
-	&dev_attr_host_fw_numbers_queue,
-	&dev_attr_host_fw_sdram_size,
-	&dev_attr_host_fw_hd_channels,
+struct attribute *arcmsr_host_attrs[] = {
+	&dev_attr_host_driver_version.attr,
+	&dev_attr_host_driver_posted_cmd.attr,
+	&dev_attr_host_driver_reset.attr,
+	&dev_attr_host_driver_abort.attr,
+	&dev_attr_host_fw_model.attr,
+	&dev_attr_host_fw_version.attr,
+	&dev_attr_host_fw_request_len.attr,
+	&dev_attr_host_fw_numbers_queue.attr,
+	&dev_attr_host_fw_sdram_size.attr,
+	&dev_attr_host_fw_hd_channels.attr,
 	NULL,
 };
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index e70f69f791db..e342dd88e67b 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -163,14 +163,15 @@ DEVICE_ATTR(beiscsi_active_session_count, S_IRUGO,
 	     beiscsi_active_session_disp, NULL);
 DEVICE_ATTR(beiscsi_free_session_count, S_IRUGO,
 	     beiscsi_free_session_disp, NULL);
-static struct device_attribute *beiscsi_attrs[] = {
-	&dev_attr_beiscsi_log_enable,
-	&dev_attr_beiscsi_drvr_ver,
-	&dev_attr_beiscsi_adapter_family,
-	&dev_attr_beiscsi_fw_ver,
-	&dev_attr_beiscsi_active_session_count,
-	&dev_attr_beiscsi_free_session_count,
-	&dev_attr_beiscsi_phys_port,
+
+static struct attribute *beiscsi_attrs[] = {
+	&dev_attr_beiscsi_log_enable.attr,
+	&dev_attr_beiscsi_drvr_ver.attr,
+	&dev_attr_beiscsi_adapter_family.attr,
+	&dev_attr_beiscsi_fw_ver.attr,
+	&dev_attr_beiscsi_active_session_count.attr,
+	&dev_attr_beiscsi_free_session_count.attr,
+	&dev_attr_beiscsi_phys_port.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 5ae1e3f78910..2ad8e1d15951 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -956,35 +956,35 @@ static          DEVICE_ATTR(driver_name, S_IRUGO, bfad_im_drv_name_show, NULL);
 static          DEVICE_ATTR(number_of_discovered_ports, S_IRUGO,
 				bfad_im_num_of_discovered_ports_show, NULL);
 
-struct device_attribute *bfad_im_host_attrs[] = {
-	&dev_attr_serial_number,
-	&dev_attr_model,
-	&dev_attr_model_description,
-	&dev_attr_node_name,
-	&dev_attr_symbolic_name,
-	&dev_attr_hardware_version,
-	&dev_attr_driver_version,
-	&dev_attr_option_rom_version,
-	&dev_attr_firmware_version,
-	&dev_attr_number_of_ports,
-	&dev_attr_driver_name,
-	&dev_attr_number_of_discovered_ports,
+struct attribute *bfad_im_host_attrs[] = {
+	&dev_attr_serial_number.attr,
+	&dev_attr_model.attr,
+	&dev_attr_model_description.attr,
+	&dev_attr_node_name.attr,
+	&dev_attr_symbolic_name.attr,
+	&dev_attr_hardware_version.attr,
+	&dev_attr_driver_version.attr,
+	&dev_attr_option_rom_version.attr,
+	&dev_attr_firmware_version.attr,
+	&dev_attr_number_of_ports.attr,
+	&dev_attr_driver_name.attr,
+	&dev_attr_number_of_discovered_ports.attr,
 	NULL,
 };
 
-struct device_attribute *bfad_im_vport_attrs[] = {
-	&dev_attr_serial_number,
-	&dev_attr_model,
-	&dev_attr_model_description,
-	&dev_attr_node_name,
-	&dev_attr_symbolic_name,
-	&dev_attr_hardware_version,
-	&dev_attr_driver_version,
-	&dev_attr_option_rom_version,
-	&dev_attr_firmware_version,
-	&dev_attr_number_of_ports,
-	&dev_attr_driver_name,
-	&dev_attr_number_of_discovered_ports,
+struct attribute *bfad_im_vport_attrs[] = {
+	&dev_attr_serial_number.attr,
+	&dev_attr_model.attr,
+	&dev_attr_model_description.attr,
+	&dev_attr_node_name.attr,
+	&dev_attr_symbolic_name.attr,
+	&dev_attr_hardware_version.attr,
+	&dev_attr_driver_version.attr,
+	&dev_attr_option_rom_version.attr,
+	&dev_attr_firmware_version.attr,
+	&dev_attr_number_of_ports.attr,
+	&dev_attr_driver_name.attr,
+	&dev_attr_number_of_discovered_ports.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index f16d4b219e44..ec7b1e9a72f0 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -174,8 +174,8 @@ extern struct fc_function_template bfad_im_vport_fc_function_template;
 extern struct scsi_transport_template *bfad_im_scsi_transport_template;
 extern struct scsi_transport_template *bfad_im_scsi_vport_transport_template;
 
-extern struct device_attribute *bfad_im_host_attrs[];
-extern struct device_attribute *bfad_im_vport_attrs[];
+extern struct attribute *bfad_im_host_attrs[];
+extern struct attribute *bfad_im_vport_attrs[];
 
 irqreturn_t bfad_intx(int irq, void *dev_id);
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 8863a74e6c57..be1dfbde343c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2951,8 +2951,8 @@ bnx2fc_tm_timeout_store(struct device *dev,
 static DEVICE_ATTR(tm_timeout, S_IRUGO|S_IWUSR, bnx2fc_tm_timeout_show,
 	bnx2fc_tm_timeout_store);
 
-static struct device_attribute *bnx2fc_host_attrs[] = {
-	&dev_attr_tm_timeout,
+static struct attribute *bnx2fc_host_attrs[] = {
+	&dev_attr_tm_timeout.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 663a63d4dae4..f6f26f97ac47 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -795,7 +795,7 @@ extern struct cnic_ulp_ops bnx2i_cnic_cb;
 extern unsigned int sq_size;
 extern unsigned int rq_size;
 
-extern struct device_attribute *bnx2i_dev_attributes[];
+extern struct attribute *bnx2i_dev_attributes[];
 
 
 
diff --git a/drivers/scsi/bnx2i/bnx2i_sysfs.c b/drivers/scsi/bnx2i/bnx2i_sysfs.c
index bea00073cb7c..dc90a6c30a51 100644
--- a/drivers/scsi/bnx2i/bnx2i_sysfs.c
+++ b/drivers/scsi/bnx2i/bnx2i_sysfs.c
@@ -142,8 +142,8 @@ static DEVICE_ATTR(sq_size, S_IRUGO | S_IWUSR,
 static DEVICE_ATTR(num_ccell, S_IRUGO | S_IWUSR,
 		   bnx2i_show_ccell_info, bnx2i_set_ccell_info);
 
-struct device_attribute *bnx2i_dev_attributes[] = {
-	&dev_attr_sq_size,
-	&dev_attr_num_ccell,
+struct attribute *bnx2i_dev_attributes[] = {
+	&dev_attr_sq_size.attr,
+	&dev_attr_num_ccell.attr,
 	NULL
 };
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 3b2eb6ce1fcf..8bc9dbf33788 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1460,11 +1460,11 @@ static DEVICE_ATTR(disable_port, S_IWUSR, NULL, csio_disable_port);
 static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
 		  csio_store_dbg_level);
 
-static struct device_attribute *csio_fcoe_lport_attrs[] = {
-	&dev_attr_hw_state,
-	&dev_attr_device_reset,
-	&dev_attr_disable_port,
-	&dev_attr_dbg_level,
+static struct attribute *csio_fcoe_lport_attrs[] = {
+	&dev_attr_hw_state.attr,
+	&dev_attr_device_reset.attr,
+	&dev_attr_disable_port.attr,
+	&dev_attr_dbg_level.attr,
 	NULL,
 };
 
@@ -1479,9 +1479,9 @@ csio_show_num_reg_rnodes(struct device *dev,
 
 static DEVICE_ATTR(num_reg_rnodes, S_IRUGO, csio_show_num_reg_rnodes, NULL);
 
-static struct device_attribute *csio_fcoe_vport_attrs[] = {
-	&dev_attr_num_reg_rnodes,
-	&dev_attr_dbg_level,
+static struct attribute *csio_fcoe_vport_attrs[] = {
+	&dev_attr_num_reg_rnodes.attr,
+	&dev_attr_dbg_level.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b2730e859df8..be17b9eb9fa7 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3103,20 +3103,20 @@ static DEVICE_ATTR_RW(irqpoll_weight);
 static DEVICE_ATTR_RW(num_hwqs);
 static DEVICE_ATTR_RW(hwq_mode);
 
-static struct device_attribute *cxlflash_host_attrs[] = {
-	&dev_attr_port0,
-	&dev_attr_port1,
-	&dev_attr_port2,
-	&dev_attr_port3,
-	&dev_attr_lun_mode,
-	&dev_attr_ioctl_version,
-	&dev_attr_port0_lun_table,
-	&dev_attr_port1_lun_table,
-	&dev_attr_port2_lun_table,
-	&dev_attr_port3_lun_table,
-	&dev_attr_irqpoll_weight,
-	&dev_attr_num_hwqs,
-	&dev_attr_hwq_mode,
+static struct attribute *cxlflash_host_attrs[] = {
+	&dev_attr_port0.attr,
+	&dev_attr_port1.attr,
+	&dev_attr_port2.attr,
+	&dev_attr_port3.attr,
+	&dev_attr_lun_mode.attr,
+	&dev_attr_ioctl_version.attr,
+	&dev_attr_port0_lun_table.attr,
+	&dev_attr_port1_lun_table.attr,
+	&dev_attr_port2_lun_table.attr,
+	&dev_attr_port3_lun_table.attr,
+	&dev_attr_irqpoll_weight.attr,
+	&dev_attr_num_hwqs.attr,
+	&dev_attr_hwq_mode.attr,
 	NULL
 };
 
@@ -3125,8 +3125,8 @@ static struct device_attribute *cxlflash_host_attrs[] = {
  */
 static DEVICE_ATTR_RO(mode);
 
-static struct device_attribute *cxlflash_dev_attrs[] = {
-	&dev_attr_mode,
+static struct attribute *cxlflash_dev_attrs[] = {
+	&dev_attr_mode.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 69f373b53132..0d52fab56087 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -322,7 +322,7 @@ static inline struct fnic *fnic_from_ctlr(struct fcoe_ctlr *fip)
 
 extern struct workqueue_struct *fnic_event_queue;
 extern struct workqueue_struct *fnic_fip_queue;
-extern struct device_attribute *fnic_attrs[];
+extern struct attribute *fnic_attrs[];
 
 void fnic_clear_intr_mode(struct fnic *fnic);
 int fnic_set_intr_mode(struct fnic *fnic);
diff --git a/drivers/scsi/fnic/fnic_attrs.c b/drivers/scsi/fnic/fnic_attrs.c
index aea0c3becfd4..78fc5a3385f1 100644
--- a/drivers/scsi/fnic/fnic_attrs.c
+++ b/drivers/scsi/fnic/fnic_attrs.c
@@ -48,9 +48,9 @@ static DEVICE_ATTR(fnic_state, S_IRUGO, fnic_show_state, NULL);
 static DEVICE_ATTR(drv_version, S_IRUGO, fnic_show_drv_version, NULL);
 static DEVICE_ATTR(link_state, S_IRUGO, fnic_show_link_state, NULL);
 
-struct device_attribute *fnic_attrs[] = {
-	&dev_attr_fnic_state,
-	&dev_attr_drv_version,
-	&dev_attr_link_state,
+struct attribute *fnic_attrs[] = {
+	&dev_attr_fnic_state.attr,
+	&dev_attr_drv_version.attr,
+	&dev_attr_link_state.attr,
 	NULL,
 };
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 862f4e8b7eb5..38aac1d0f4c0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1749,8 +1749,8 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 	return 0;
 }
 
-static struct device_attribute *host_attrs_v1_hw[] = {
-	&dev_attr_phy_event_threshold,
+static struct attribute *host_attrs_v1_hw[] = {
+	&dev_attr_phy_event_threshold.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 236cf65c2f97..93c786696e33 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3542,8 +3542,8 @@ static void wait_cmds_complete_timeout_v2_hw(struct hisi_hba *hisi_hba,
 
 }
 
-static struct device_attribute *host_attrs_v2_hw[] = {
-	&dev_attr_phy_event_threshold,
+static struct attribute *host_attrs_v2_hw[] = {
+	&dev_attr_phy_event_threshold.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f4517f3eb922..914b33e7b856 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2771,11 +2771,11 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
 	return 0;
 }
 
-static struct device_attribute *host_attrs_v3_hw[] = {
-	&dev_attr_phy_event_threshold,
-	&dev_attr_intr_conv_v3_hw,
-	&dev_attr_intr_coal_ticks_v3_hw,
-	&dev_attr_intr_coal_count_v3_hw,
+static struct attribute *host_attrs_v3_hw[] = {
+	&dev_attr_phy_event_threshold.attr,
+	&dev_attr_intr_conv_v3_hw.attr,
+	&dev_attr_intr_coal_ticks_v3_hw.attr,
+	&dev_attr_intr_coal_count_v3_hw.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3f6f14f0cafb..f424aca6dc6e 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -480,7 +480,15 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->shost_dev.parent = &shost->shost_gendev;
 	shost->shost_dev.class = &shost_class;
 	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
-	shost->shost_dev.groups = scsi_sysfs_shost_attr_groups;
+	shost->shost_dev.groups = shost->shost_dev_attr_groups;
+	shost->shost_dev_attr_groups[0] = &scsi_host_attr_group;
+	if (shost->hostt->shost_attrs) {
+		shost->shost_dev_attr_groups[1] =
+			&shost->shost_driver_attr_group;
+		shost->shost_driver_attr_group = (struct attribute_group){
+			.attrs = shost->hostt->shost_attrs,
+		};
+	}
 
 	shost->ehandler = kthread_run(scsi_error_handler, shost,
 			"scsi_eh_%d", shost->host_no);
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3faa87fa296a..4668f5aac1e3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -946,17 +946,17 @@ static struct device_attribute *hpsa_sdev_attrs[] = {
 	NULL,
 };
 
-static struct device_attribute *hpsa_shost_attrs[] = {
-	&dev_attr_rescan,
-	&dev_attr_firmware_revision,
-	&dev_attr_commands_outstanding,
-	&dev_attr_transport_mode,
-	&dev_attr_resettable,
-	&dev_attr_hp_ssd_smart_path_status,
-	&dev_attr_raid_offload_debug,
-	&dev_attr_lockup_detected,
-	&dev_attr_ctlr_num,
-	&dev_attr_legacy_board,
+static struct attribute *hpsa_shost_attrs[] = {
+	&dev_attr_rescan.attr,
+	&dev_attr_firmware_revision.attr,
+	&dev_attr_commands_outstanding.attr,
+	&dev_attr_transport_mode.attr,
+	&dev_attr_resettable.attr,
+	&dev_attr_hp_ssd_smart_path_status.attr,
+	&dev_attr_raid_offload_debug.attr,
+	&dev_attr_lockup_detected.attr,
+	&dev_attr_ctlr_num.attr,
+	&dev_attr_legacy_board.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 61cda7b7624f..39f6db6b418c 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1150,9 +1150,9 @@ static struct device_attribute hptiop_attr_fw_version = {
 	.show = hptiop_show_fw_version,
 };
 
-static struct device_attribute *hptiop_attrs[] = {
-	&hptiop_attr_version,
-	&hptiop_attr_fw_version,
+static struct attribute *hptiop_attrs[] = {
+	&hptiop_attr_version.attr,
+	&hptiop_attr_fw_version.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 1f1586ad48fe..76291babbc97 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3588,15 +3588,15 @@ static struct bin_attribute ibmvfc_trace_attr = {
 };
 #endif
 
-static struct device_attribute *ibmvfc_attrs[] = {
-	&dev_attr_partition_name,
-	&dev_attr_device_name,
-	&dev_attr_port_loc_code,
-	&dev_attr_drc_name,
-	&dev_attr_npiv_version,
-	&dev_attr_capabilities,
-	&dev_attr_log_level,
-	&dev_attr_nr_scsi_channels,
+static struct attribute *ibmvfc_attrs[] = {
+	&dev_attr_partition_name.attr,
+	&dev_attr_device_name.attr,
+	&dev_attr_port_loc_code.attr,
+	&dev_attr_drc_name.attr,
+	&dev_attr_npiv_version.attr,
+	&dev_attr_capabilities.attr,
+	&dev_attr_log_level.attr,
+	&dev_attr_nr_scsi_channels.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 50df7dd9cb91..711e77a8d613 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2064,15 +2064,15 @@ static int ibmvscsi_host_reset(struct Scsi_Host *shost, int reset_type)
 	return 0;
 }
 
-static struct device_attribute *ibmvscsi_attrs[] = {
-	&ibmvscsi_host_vhost_loc,
-	&ibmvscsi_host_vhost_name,
-	&ibmvscsi_host_srp_version,
-	&ibmvscsi_host_partition_name,
-	&ibmvscsi_host_partition_number,
-	&ibmvscsi_host_mad_version,
-	&ibmvscsi_host_os_type,
-	&ibmvscsi_host_config,
+static struct attribute *ibmvscsi_attrs[] = {
+	&ibmvscsi_host_vhost_loc.attr,
+	&ibmvscsi_host_vhost_name.attr,
+	&ibmvscsi_host_srp_version.attr,
+	&ibmvscsi_host_partition_name.attr,
+	&ibmvscsi_host_partition_number.attr,
+	&ibmvscsi_host_mad_version.attr,
+	&ibmvscsi_host_os_type.attr,
+	&ibmvscsi_host_config.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5d78f7e939a3..562887803ecd 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4236,15 +4236,15 @@ static struct bin_attribute ipr_ioa_async_err_log = {
 	.write = ipr_next_async_err_log
 };
 
-static struct device_attribute *ipr_ioa_attrs[] = {
-	&ipr_fw_version_attr,
-	&ipr_log_level_attr,
-	&ipr_diagnostics_attr,
-	&ipr_ioa_state_attr,
-	&ipr_ioa_reset_attr,
-	&ipr_update_fw_attr,
-	&ipr_ioa_fw_type_attr,
-	&ipr_iopoll_weight_attr,
+static struct attribute *ipr_ioa_attrs[] = {
+	&ipr_fw_version_attr.attr,
+	&ipr_log_level_attr.attr,
+	&ipr_diagnostics_attr.attr,
+	&ipr_ioa_state_attr.attr,
+	&ipr_ioa_reset_attr.attr,
+	&ipr_update_fw_attr.attr,
+	&ipr_ioa_fw_type_attr.attr,
+	&ipr_iopoll_weight_attr.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index ffd33e5decae..e46d72331f2d 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -142,8 +142,8 @@ static ssize_t isci_show_id(struct device *dev, struct device_attribute *attr, c
 
 static DEVICE_ATTR(isci_id, S_IRUGO, isci_show_id, NULL);
 
-static struct device_attribute *isci_host_attrs[] = {
-	&dev_attr_isci_id,
+static struct attribute *isci_host_attrs[] = {
+	&dev_attr_isci_id.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index b35bf70a8c0d..3f3345ee3aef 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -6396,157 +6396,157 @@ LPFC_ATTR_RW(vmid_priority_tagging, LPFC_VMID_PRIO_TAG_DISABLE,
 	     LPFC_VMID_PRIO_TAG_ALL_TARGETS,
 	     "Enable Priority Tagging VMID support");
 
-struct device_attribute *lpfc_hba_attrs[] = {
-	&dev_attr_nvme_info,
-	&dev_attr_scsi_stat,
-	&dev_attr_bg_info,
-	&dev_attr_bg_guard_err,
-	&dev_attr_bg_apptag_err,
-	&dev_attr_bg_reftag_err,
-	&dev_attr_info,
-	&dev_attr_serialnum,
-	&dev_attr_modeldesc,
-	&dev_attr_modelname,
-	&dev_attr_programtype,
-	&dev_attr_portnum,
-	&dev_attr_fwrev,
-	&dev_attr_hdw,
-	&dev_attr_option_rom_version,
-	&dev_attr_link_state,
-	&dev_attr_num_discovered_ports,
-	&dev_attr_menlo_mgmt_mode,
-	&dev_attr_lpfc_drvr_version,
-	&dev_attr_lpfc_enable_fip,
-	&dev_attr_lpfc_temp_sensor,
-	&dev_attr_lpfc_log_verbose,
-	&dev_attr_lpfc_lun_queue_depth,
-	&dev_attr_lpfc_tgt_queue_depth,
-	&dev_attr_lpfc_hba_queue_depth,
-	&dev_attr_lpfc_peer_port_login,
-	&dev_attr_lpfc_nodev_tmo,
-	&dev_attr_lpfc_devloss_tmo,
-	&dev_attr_lpfc_enable_fc4_type,
-	&dev_attr_lpfc_fcp_class,
-	&dev_attr_lpfc_use_adisc,
-	&dev_attr_lpfc_first_burst_size,
-	&dev_attr_lpfc_ack0,
-	&dev_attr_lpfc_xri_rebalancing,
-	&dev_attr_lpfc_topology,
-	&dev_attr_lpfc_scan_down,
-	&dev_attr_lpfc_link_speed,
-	&dev_attr_lpfc_fcp_io_sched,
-	&dev_attr_lpfc_ns_query,
-	&dev_attr_lpfc_fcp2_no_tgt_reset,
-	&dev_attr_lpfc_cr_delay,
-	&dev_attr_lpfc_cr_count,
-	&dev_attr_lpfc_multi_ring_support,
-	&dev_attr_lpfc_multi_ring_rctl,
-	&dev_attr_lpfc_multi_ring_type,
-	&dev_attr_lpfc_fdmi_on,
-	&dev_attr_lpfc_enable_SmartSAN,
-	&dev_attr_lpfc_max_luns,
-	&dev_attr_lpfc_enable_npiv,
-	&dev_attr_lpfc_fcf_failover_policy,
-	&dev_attr_lpfc_enable_rrq,
-	&dev_attr_lpfc_fcp_wait_abts_rsp,
-	&dev_attr_nport_evt_cnt,
-	&dev_attr_board_mode,
-	&dev_attr_max_vpi,
-	&dev_attr_used_vpi,
-	&dev_attr_max_rpi,
-	&dev_attr_used_rpi,
-	&dev_attr_max_xri,
-	&dev_attr_used_xri,
-	&dev_attr_npiv_info,
-	&dev_attr_issue_reset,
-	&dev_attr_lpfc_poll,
-	&dev_attr_lpfc_poll_tmo,
-	&dev_attr_lpfc_task_mgmt_tmo,
-	&dev_attr_lpfc_use_msi,
-	&dev_attr_lpfc_nvme_oas,
-	&dev_attr_lpfc_nvme_embed_cmd,
-	&dev_attr_lpfc_fcp_imax,
-	&dev_attr_lpfc_force_rscn,
-	&dev_attr_lpfc_cq_poll_threshold,
-	&dev_attr_lpfc_cq_max_proc_limit,
-	&dev_attr_lpfc_fcp_cpu_map,
-	&dev_attr_lpfc_fcp_mq_threshold,
-	&dev_attr_lpfc_hdw_queue,
-	&dev_attr_lpfc_irq_chann,
-	&dev_attr_lpfc_suppress_rsp,
-	&dev_attr_lpfc_nvmet_mrq,
-	&dev_attr_lpfc_nvmet_mrq_post,
-	&dev_attr_lpfc_nvme_enable_fb,
-	&dev_attr_lpfc_nvmet_fb_size,
-	&dev_attr_lpfc_enable_bg,
-	&dev_attr_lpfc_soft_wwnn,
-	&dev_attr_lpfc_soft_wwpn,
-	&dev_attr_lpfc_soft_wwn_enable,
-	&dev_attr_lpfc_enable_hba_reset,
-	&dev_attr_lpfc_enable_hba_heartbeat,
-	&dev_attr_lpfc_EnableXLane,
-	&dev_attr_lpfc_XLanePriority,
-	&dev_attr_lpfc_xlane_lun,
-	&dev_attr_lpfc_xlane_tgt,
-	&dev_attr_lpfc_xlane_vpt,
-	&dev_attr_lpfc_xlane_lun_state,
-	&dev_attr_lpfc_xlane_lun_status,
-	&dev_attr_lpfc_xlane_priority,
-	&dev_attr_lpfc_sg_seg_cnt,
-	&dev_attr_lpfc_max_scsicmpl_time,
-	&dev_attr_lpfc_stat_data_ctrl,
-	&dev_attr_lpfc_aer_support,
-	&dev_attr_lpfc_aer_state_cleanup,
-	&dev_attr_lpfc_sriov_nr_virtfn,
-	&dev_attr_lpfc_req_fw_upgrade,
-	&dev_attr_lpfc_suppress_link_up,
-	&dev_attr_iocb_hw,
-	&dev_attr_pls,
-	&dev_attr_pt,
-	&dev_attr_txq_hw,
-	&dev_attr_txcmplq_hw,
-	&dev_attr_lpfc_sriov_hw_max_virtfn,
-	&dev_attr_protocol,
-	&dev_attr_lpfc_xlane_supported,
-	&dev_attr_lpfc_enable_mds_diags,
-	&dev_attr_lpfc_ras_fwlog_buffsize,
-	&dev_attr_lpfc_ras_fwlog_level,
-	&dev_attr_lpfc_ras_fwlog_func,
-	&dev_attr_lpfc_enable_bbcr,
-	&dev_attr_lpfc_enable_dpp,
-	&dev_attr_lpfc_enable_mi,
-	&dev_attr_cmf_info,
-	&dev_attr_lpfc_max_vmid,
-	&dev_attr_lpfc_vmid_inactivity_timeout,
-	&dev_attr_lpfc_vmid_app_header,
-	&dev_attr_lpfc_vmid_priority_tagging,
+struct attribute *lpfc_hba_attrs[] = {
+	&dev_attr_nvme_info.attr,
+	&dev_attr_scsi_stat.attr,
+	&dev_attr_bg_info.attr,
+	&dev_attr_bg_guard_err.attr,
+	&dev_attr_bg_apptag_err.attr,
+	&dev_attr_bg_reftag_err.attr,
+	&dev_attr_info.attr,
+	&dev_attr_serialnum.attr,
+	&dev_attr_modeldesc.attr,
+	&dev_attr_modelname.attr,
+	&dev_attr_programtype.attr,
+	&dev_attr_portnum.attr,
+	&dev_attr_fwrev.attr,
+	&dev_attr_hdw.attr,
+	&dev_attr_option_rom_version.attr,
+	&dev_attr_link_state.attr,
+	&dev_attr_num_discovered_ports.attr,
+	&dev_attr_menlo_mgmt_mode.attr,
+	&dev_attr_lpfc_drvr_version.attr,
+	&dev_attr_lpfc_enable_fip.attr,
+	&dev_attr_lpfc_temp_sensor.attr,
+	&dev_attr_lpfc_log_verbose.attr,
+	&dev_attr_lpfc_lun_queue_depth.attr,
+	&dev_attr_lpfc_tgt_queue_depth.attr,
+	&dev_attr_lpfc_hba_queue_depth.attr,
+	&dev_attr_lpfc_peer_port_login.attr,
+	&dev_attr_lpfc_nodev_tmo.attr,
+	&dev_attr_lpfc_devloss_tmo.attr,
+	&dev_attr_lpfc_enable_fc4_type.attr,
+	&dev_attr_lpfc_fcp_class.attr,
+	&dev_attr_lpfc_use_adisc.attr,
+	&dev_attr_lpfc_first_burst_size.attr,
+	&dev_attr_lpfc_ack0.attr,
+	&dev_attr_lpfc_xri_rebalancing.attr,
+	&dev_attr_lpfc_topology.attr,
+	&dev_attr_lpfc_scan_down.attr,
+	&dev_attr_lpfc_link_speed.attr,
+	&dev_attr_lpfc_fcp_io_sched.attr,
+	&dev_attr_lpfc_ns_query.attr,
+	&dev_attr_lpfc_fcp2_no_tgt_reset.attr,
+	&dev_attr_lpfc_cr_delay.attr,
+	&dev_attr_lpfc_cr_count.attr,
+	&dev_attr_lpfc_multi_ring_support.attr,
+	&dev_attr_lpfc_multi_ring_rctl.attr,
+	&dev_attr_lpfc_multi_ring_type.attr,
+	&dev_attr_lpfc_fdmi_on.attr,
+	&dev_attr_lpfc_enable_SmartSAN.attr,
+	&dev_attr_lpfc_max_luns.attr,
+	&dev_attr_lpfc_enable_npiv.attr,
+	&dev_attr_lpfc_fcf_failover_policy.attr,
+	&dev_attr_lpfc_enable_rrq.attr,
+	&dev_attr_lpfc_fcp_wait_abts_rsp.attr,
+	&dev_attr_nport_evt_cnt.attr,
+	&dev_attr_board_mode.attr,
+	&dev_attr_max_vpi.attr,
+	&dev_attr_used_vpi.attr,
+	&dev_attr_max_rpi.attr,
+	&dev_attr_used_rpi.attr,
+	&dev_attr_max_xri.attr,
+	&dev_attr_used_xri.attr,
+	&dev_attr_npiv_info.attr,
+	&dev_attr_issue_reset.attr,
+	&dev_attr_lpfc_poll.attr,
+	&dev_attr_lpfc_poll_tmo.attr,
+	&dev_attr_lpfc_task_mgmt_tmo.attr,
+	&dev_attr_lpfc_use_msi.attr,
+	&dev_attr_lpfc_nvme_oas.attr,
+	&dev_attr_lpfc_nvme_embed_cmd.attr,
+	&dev_attr_lpfc_fcp_imax.attr,
+	&dev_attr_lpfc_force_rscn.attr,
+	&dev_attr_lpfc_cq_poll_threshold.attr,
+	&dev_attr_lpfc_cq_max_proc_limit.attr,
+	&dev_attr_lpfc_fcp_cpu_map.attr,
+	&dev_attr_lpfc_fcp_mq_threshold.attr,
+	&dev_attr_lpfc_hdw_queue.attr,
+	&dev_attr_lpfc_irq_chann.attr,
+	&dev_attr_lpfc_suppress_rsp.attr,
+	&dev_attr_lpfc_nvmet_mrq.attr,
+	&dev_attr_lpfc_nvmet_mrq_post.attr,
+	&dev_attr_lpfc_nvme_enable_fb.attr,
+	&dev_attr_lpfc_nvmet_fb_size.attr,
+	&dev_attr_lpfc_enable_bg.attr,
+	&dev_attr_lpfc_soft_wwnn.attr,
+	&dev_attr_lpfc_soft_wwpn.attr,
+	&dev_attr_lpfc_soft_wwn_enable.attr,
+	&dev_attr_lpfc_enable_hba_reset.attr,
+	&dev_attr_lpfc_enable_hba_heartbeat.attr,
+	&dev_attr_lpfc_EnableXLane.attr,
+	&dev_attr_lpfc_XLanePriority.attr,
+	&dev_attr_lpfc_xlane_lun.attr,
+	&dev_attr_lpfc_xlane_tgt.attr,
+	&dev_attr_lpfc_xlane_vpt.attr,
+	&dev_attr_lpfc_xlane_lun_state.attr,
+	&dev_attr_lpfc_xlane_lun_status.attr,
+	&dev_attr_lpfc_xlane_priority.attr,
+	&dev_attr_lpfc_sg_seg_cnt.attr,
+	&dev_attr_lpfc_max_scsicmpl_time.attr,
+	&dev_attr_lpfc_stat_data_ctrl.attr,
+	&dev_attr_lpfc_aer_support.attr,
+	&dev_attr_lpfc_aer_state_cleanup.attr,
+	&dev_attr_lpfc_sriov_nr_virtfn.attr,
+	&dev_attr_lpfc_req_fw_upgrade.attr,
+	&dev_attr_lpfc_suppress_link_up.attr,
+	&dev_attr_iocb_hw.attr,
+	&dev_attr_pls.attr,
+	&dev_attr_pt.attr,
+	&dev_attr_txq_hw.attr,
+	&dev_attr_txcmplq_hw.attr,
+	&dev_attr_lpfc_sriov_hw_max_virtfn.attr,
+	&dev_attr_protocol.attr,
+	&dev_attr_lpfc_xlane_supported.attr,
+	&dev_attr_lpfc_enable_mds_diags.attr,
+	&dev_attr_lpfc_ras_fwlog_buffsize.attr,
+	&dev_attr_lpfc_ras_fwlog_level.attr,
+	&dev_attr_lpfc_ras_fwlog_func.attr,
+	&dev_attr_lpfc_enable_bbcr.attr,
+	&dev_attr_lpfc_enable_dpp.attr,
+	&dev_attr_lpfc_enable_mi.attr,
+	&dev_attr_cmf_info.attr,
+	&dev_attr_lpfc_max_vmid.attr,
+	&dev_attr_lpfc_vmid_inactivity_timeout.attr,
+	&dev_attr_lpfc_vmid_app_header.attr,
+	&dev_attr_lpfc_vmid_priority_tagging.attr,
 	NULL,
 };
 
-struct device_attribute *lpfc_vport_attrs[] = {
-	&dev_attr_info,
-	&dev_attr_link_state,
-	&dev_attr_num_discovered_ports,
-	&dev_attr_lpfc_drvr_version,
-	&dev_attr_lpfc_log_verbose,
-	&dev_attr_lpfc_lun_queue_depth,
-	&dev_attr_lpfc_tgt_queue_depth,
-	&dev_attr_lpfc_nodev_tmo,
-	&dev_attr_lpfc_devloss_tmo,
-	&dev_attr_lpfc_hba_queue_depth,
-	&dev_attr_lpfc_peer_port_login,
-	&dev_attr_lpfc_restrict_login,
-	&dev_attr_lpfc_fcp_class,
-	&dev_attr_lpfc_use_adisc,
-	&dev_attr_lpfc_first_burst_size,
-	&dev_attr_lpfc_max_luns,
-	&dev_attr_nport_evt_cnt,
-	&dev_attr_npiv_info,
-	&dev_attr_lpfc_enable_da_id,
-	&dev_attr_lpfc_max_scsicmpl_time,
-	&dev_attr_lpfc_stat_data_ctrl,
-	&dev_attr_lpfc_static_vport,
-	&dev_attr_cmf_info,
+struct attribute *lpfc_vport_attrs[] = {
+	&dev_attr_info.attr,
+	&dev_attr_link_state.attr,
+	&dev_attr_num_discovered_ports.attr,
+	&dev_attr_lpfc_drvr_version.attr,
+	&dev_attr_lpfc_log_verbose.attr,
+	&dev_attr_lpfc_lun_queue_depth.attr,
+	&dev_attr_lpfc_tgt_queue_depth.attr,
+	&dev_attr_lpfc_nodev_tmo.attr,
+	&dev_attr_lpfc_devloss_tmo.attr,
+	&dev_attr_lpfc_hba_queue_depth.attr,
+	&dev_attr_lpfc_peer_port_login.attr,
+	&dev_attr_lpfc_restrict_login.attr,
+	&dev_attr_lpfc_fcp_class.attr,
+	&dev_attr_lpfc_use_adisc.attr,
+	&dev_attr_lpfc_first_burst_size.attr,
+	&dev_attr_lpfc_max_luns.attr,
+	&dev_attr_nport_evt_cnt.attr,
+	&dev_attr_npiv_info.attr,
+	&dev_attr_lpfc_enable_da_id.attr,
+	&dev_attr_lpfc_max_scsicmpl_time.attr,
+	&dev_attr_lpfc_stat_data_ctrl.attr,
+	&dev_attr_lpfc_static_vport.attr,
+	&dev_attr_cmf_info.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index c512f4199142..c1d5f1210e19 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -428,8 +428,8 @@ void lpfc_get_cfgparam(struct lpfc_hba *);
 void lpfc_get_vport_cfgparam(struct lpfc_vport *);
 int lpfc_alloc_sysfs_attr(struct lpfc_vport *);
 void lpfc_free_sysfs_attr(struct lpfc_vport *);
-extern struct device_attribute *lpfc_hba_attrs[];
-extern struct device_attribute *lpfc_vport_attrs[];
+extern struct attribute *lpfc_hba_attrs[];
+extern struct attribute *lpfc_vport_attrs[];
 extern struct scsi_host_template lpfc_template;
 extern struct scsi_host_template lpfc_template_nvme;
 extern struct fc_function_template lpfc_transport_functions;
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index d20c2e4ee793..0877608fee90 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -305,8 +305,8 @@ static struct pci_driver megaraid_pci_driver = {
 static DEVICE_ATTR_ADMIN_RO(megaraid_mbox_app_hndl);
 
 // Host template initializer for megaraid mbox sysfs device attributes
-static struct device_attribute *megaraid_shost_attrs[] = {
-	&dev_attr_megaraid_mbox_app_hndl,
+static struct attribute *megaraid_shost_attrs[] = {
+	&dev_attr_megaraid_mbox_app_hndl.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e4298bf4a482..f72500f21df0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3481,16 +3481,16 @@ static DEVICE_ATTR_RW(enable_sdev_max_qd);
 static DEVICE_ATTR_RO(dump_system_regs);
 static DEVICE_ATTR_RO(raid_map_id);
 
-static struct device_attribute *megaraid_host_attrs[] = {
-	&dev_attr_fw_crash_buffer_size,
-	&dev_attr_fw_crash_buffer,
-	&dev_attr_fw_crash_state,
-	&dev_attr_page_size,
-	&dev_attr_ldio_outstanding,
-	&dev_attr_fw_cmds_outstanding,
-	&dev_attr_enable_sdev_max_qd,
-	&dev_attr_dump_system_regs,
-	&dev_attr_raid_map_id,
+static struct attribute *megaraid_host_attrs[] = {
+	&dev_attr_fw_crash_buffer_size.attr,
+	&dev_attr_fw_crash_buffer.attr,
+	&dev_attr_fw_crash_state.attr,
+	&dev_attr_page_size.attr,
+	&dev_attr_ldio_outstanding.attr,
+	&dev_attr_fw_cmds_outstanding.attr,
+	&dev_attr_enable_sdev_max_qd.attr,
+	&dev_attr_dump_system_regs.attr,
+	&dev_attr_raid_map_id.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index f87c0911f66a..10668d85944e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1939,7 +1939,7 @@ mpt3sas_config_update_driver_trigger_pg4(struct MPT3SAS_ADAPTER *ioc,
 	struct SL_WH_MPI_TRIGGERS_T *mpi_tg, bool set);
 
 /* ctl shared API */
-extern struct device_attribute *mpt3sas_host_attrs[];
+extern struct attribute *mpt3sas_host_attrs[];
 extern struct device_attribute *mpt3sas_dev_attrs[];
 void mpt3sas_ctl_init(ushort hbas_to_enumerate);
 void mpt3sas_ctl_exit(ushort hbas_to_enumerate);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 770b241d7bb2..61b567691387 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3842,34 +3842,34 @@ enable_sdev_max_qd_store(struct device *cdev,
 }
 static DEVICE_ATTR_RW(enable_sdev_max_qd);
 
-struct device_attribute *mpt3sas_host_attrs[] = {
-	&dev_attr_version_fw,
-	&dev_attr_version_bios,
-	&dev_attr_version_mpi,
-	&dev_attr_version_product,
-	&dev_attr_version_nvdata_persistent,
-	&dev_attr_version_nvdata_default,
-	&dev_attr_board_name,
-	&dev_attr_board_assembly,
-	&dev_attr_board_tracer,
-	&dev_attr_io_delay,
-	&dev_attr_device_delay,
-	&dev_attr_logging_level,
-	&dev_attr_fwfault_debug,
-	&dev_attr_fw_queue_depth,
-	&dev_attr_host_sas_address,
-	&dev_attr_ioc_reset_count,
-	&dev_attr_host_trace_buffer_size,
-	&dev_attr_host_trace_buffer,
-	&dev_attr_host_trace_buffer_enable,
-	&dev_attr_reply_queue_count,
-	&dev_attr_diag_trigger_master,
-	&dev_attr_diag_trigger_event,
-	&dev_attr_diag_trigger_scsi,
-	&dev_attr_diag_trigger_mpi,
-	&dev_attr_drv_support_bitmap,
-	&dev_attr_BRM_status,
-	&dev_attr_enable_sdev_max_qd,
+struct attribute *mpt3sas_host_attrs[] = {
+	&dev_attr_version_fw.attr,
+	&dev_attr_version_bios.attr,
+	&dev_attr_version_mpi.attr,
+	&dev_attr_version_product.attr,
+	&dev_attr_version_nvdata_persistent.attr,
+	&dev_attr_version_nvdata_default.attr,
+	&dev_attr_board_name.attr,
+	&dev_attr_board_assembly.attr,
+	&dev_attr_board_tracer.attr,
+	&dev_attr_io_delay.attr,
+	&dev_attr_device_delay.attr,
+	&dev_attr_logging_level.attr,
+	&dev_attr_fwfault_debug.attr,
+	&dev_attr_fw_queue_depth.attr,
+	&dev_attr_host_sas_address.attr,
+	&dev_attr_ioc_reset_count.attr,
+	&dev_attr_host_trace_buffer_size.attr,
+	&dev_attr_host_trace_buffer.attr,
+	&dev_attr_host_trace_buffer_enable.attr,
+	&dev_attr_reply_queue_count.attr,
+	&dev_attr_diag_trigger_master.attr,
+	&dev_attr_diag_trigger_event.attr,
+	&dev_attr_diag_trigger_scsi.attr,
+	&dev_attr_diag_trigger_mpi.attr,
+	&dev_attr_drv_support_bitmap.attr,
+	&dev_attr_BRM_status.attr,
+	&dev_attr_enable_sdev_max_qd.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index f18dd9703595..68fd42ed367a 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -25,7 +25,7 @@ static const struct mvs_chip_info mvs_chips[] = {
 	[chip_1320] =	{ 2, 4, 0x800, 17, 64, 8,  9, &mvs_94xx_dispatch, },
 };
 
-static struct device_attribute *mvst_host_attrs[];
+static struct attribute *mvst_host_attrs[];
 
 #define SOC_SAS_NUM 2
 
@@ -773,9 +773,9 @@ static void __exit mvs_exit(void)
 	sas_release_transport(mvs_stt);
 }
 
-static struct device_attribute *mvst_host_attrs[] = {
-	&dev_attr_driver_version,
-	&dev_attr_interrupt_coalescing,
+static struct attribute *mvst_host_attrs[] = {
+	&dev_attr_driver_version.attr,
+	&dev_attr_interrupt_coalescing.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index a4a88323e020..1378ff0d1967 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -2190,11 +2190,11 @@ static struct device_attribute *myrb_sdev_attrs[] = {
 	NULL,
 };
 
-static struct device_attribute *myrb_shost_attrs[] = {
-	&dev_attr_ctlr_num,
-	&dev_attr_model,
-	&dev_attr_firmware,
-	&dev_attr_flush_cache,
+static struct attribute *myrb_shost_attrs[] = {
+	&dev_attr_ctlr_num.attr,
+	&dev_attr_model.attr,
+	&dev_attr_firmware.attr,
+	&dev_attr_flush_cache.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 07f274afd7e5..0b82e67a07bf 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1510,17 +1510,17 @@ static ssize_t disable_enclosure_messages_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(disable_enclosure_messages);
 
-static struct device_attribute *myrs_shost_attrs[] = {
-	&dev_attr_serial,
-	&dev_attr_ctlr_num,
-	&dev_attr_processor,
-	&dev_attr_model,
-	&dev_attr_ctlr_type,
-	&dev_attr_cache_size,
-	&dev_attr_firmware,
-	&dev_attr_discovery,
-	&dev_attr_flush_cache,
-	&dev_attr_disable_enclosure_messages,
+static struct attribute *myrs_shost_attrs[] = {
+	&dev_attr_serial.attr,
+	&dev_attr_ctlr_num.attr,
+	&dev_attr_processor.attr,
+	&dev_attr_model.attr,
+	&dev_attr_ctlr_type.attr,
+	&dev_attr_cache_size.attr,
+	&dev_attr_firmware.attr,
+	&dev_attr_discovery.attr,
+	&dev_attr_flush_cache.attr,
+	&dev_attr_disable_enclosure_messages.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 7a4f5d4dd670..1a7b3850e535 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -8062,8 +8062,8 @@ static struct device_attribute ncr53c8xx_revision_attr = {
 	.show	= show_ncr53c8xx_revision,
 };
   
-static struct device_attribute *ncr53c8xx_host_attrs[] = {
-	&ncr53c8xx_revision_attr,
+static struct attribute *ncr53c8xx_host_attrs[] = {
+	&ncr53c8xx_revision_attr.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index a366ff1a3959..70b6435f37b9 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -652,8 +652,8 @@ static struct device_attribute SYM53C500_pio_attr = {
 	.store = SYM53C500_store_pio,
 };
 
-static struct device_attribute *SYM53C500_shost_attrs[] = {
-	&SYM53C500_pio_attr,
+static struct attribute *SYM53C500_shost_attrs[] = {
+	&SYM53C500_pio_attr.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index b25e447aa3bd..8ba2b9b0a8a4 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -1002,34 +1002,34 @@ static ssize_t ctl_iop1_count_show(struct device *cdev,
 }
 static DEVICE_ATTR_RO(ctl_iop1_count);
 
-struct device_attribute *pm8001_host_attrs[] = {
-	&dev_attr_interface_rev,
-	&dev_attr_controller_fatal_error,
-	&dev_attr_fw_version,
-	&dev_attr_update_fw,
-	&dev_attr_aap_log,
-	&dev_attr_iop_log,
-	&dev_attr_fatal_log,
-	&dev_attr_non_fatal_log,
-	&dev_attr_non_fatal_count,
-	&dev_attr_gsm_log,
-	&dev_attr_max_out_io,
-	&dev_attr_max_devices,
-	&dev_attr_max_sg_list,
-	&dev_attr_sas_spec_support,
-	&dev_attr_logging_level,
-	&dev_attr_event_log_size,
-	&dev_attr_host_sas_address,
-	&dev_attr_bios_version,
-	&dev_attr_ib_log,
-	&dev_attr_ob_log,
-	&dev_attr_ila_version,
-	&dev_attr_inc_fw_ver,
-	&dev_attr_ctl_mpi_state,
-	&dev_attr_ctl_hmi_error,
-	&dev_attr_ctl_raae_count,
-	&dev_attr_ctl_iop0_count,
-	&dev_attr_ctl_iop1_count,
+struct attribute *pm8001_host_attrs[] = {
+	&dev_attr_interface_rev.attr,
+	&dev_attr_controller_fatal_error.attr,
+	&dev_attr_fw_version.attr,
+	&dev_attr_update_fw.attr,
+	&dev_attr_aap_log.attr,
+	&dev_attr_iop_log.attr,
+	&dev_attr_fatal_log.attr,
+	&dev_attr_non_fatal_log.attr,
+	&dev_attr_non_fatal_count.attr,
+	&dev_attr_gsm_log.attr,
+	&dev_attr_max_out_io.attr,
+	&dev_attr_max_devices.attr,
+	&dev_attr_max_sg_list.attr,
+	&dev_attr_sas_spec_support.attr,
+	&dev_attr_logging_level.attr,
+	&dev_attr_event_log_size.attr,
+	&dev_attr_host_sas_address.attr,
+	&dev_attr_bios_version.attr,
+	&dev_attr_ib_log.attr,
+	&dev_attr_ob_log.attr,
+	&dev_attr_ila_version.attr,
+	&dev_attr_inc_fw_ver.attr,
+	&dev_attr_ctl_mpi_state.attr,
+	&dev_attr_ctl_hmi_error.attr,
+	&dev_attr_ctl_raae_count.attr,
+	&dev_attr_ctl_iop0_count.attr,
+	&dev_attr_ctl_iop1_count.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 7e999768bfd2..eb947b5b83f1 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -733,7 +733,7 @@ ssize_t pm8001_get_gsm_dump(struct device *cdev, u32, char *buf);
 int pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha);
 void pm8001_free_dev(struct pm8001_device *pm8001_dev);
 /* ctl shared API */
-extern struct device_attribute *pm8001_host_attrs[];
+extern struct attribute *pm8001_host_attrs[];
 
 static inline void
 pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index bffd9a9349e7..3c3794375e4a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4097,10 +4097,10 @@ static struct device_attribute pmcraid_adapter_id_attr = {
 	.show = pmcraid_show_adapter_id,
 };
 
-static struct device_attribute *pmcraid_host_attrs[] = {
-	&pmcraid_log_level_attr,
-	&pmcraid_driver_version_attr,
-	&pmcraid_adapter_id_attr,
+static struct attribute *pmcraid_host_attrs[] = {
+	&pmcraid_log_level_attr.attr,
+	&pmcraid_driver_version_attr.attr,
+	&pmcraid_adapter_id_attr.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index ba94413fe2ea..cddd61c71358 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -498,7 +498,7 @@ extern void qedf_process_abts_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 extern struct qedf_ioreq *qedf_alloc_cmd(struct qedf_rport *fcport,
 	u8 cmd_type);
 
-extern struct device_attribute *qedf_host_attrs[];
+extern struct attribute *qedf_host_attrs[];
 extern void qedf_cmd_timer_set(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 	unsigned int timer_msec);
 extern int qedf_init_mp_req(struct qedf_ioreq *io_req);
diff --git a/drivers/scsi/qedf/qedf_attr.c b/drivers/scsi/qedf/qedf_attr.c
index 461c0c9180c4..814e0838c464 100644
--- a/drivers/scsi/qedf/qedf_attr.c
+++ b/drivers/scsi/qedf/qedf_attr.c
@@ -60,9 +60,9 @@ static ssize_t fka_period_show(struct device *dev,
 static DEVICE_ATTR_RO(fcoe_mac);
 static DEVICE_ATTR_RO(fka_period);
 
-struct device_attribute *qedf_host_attrs[] = {
-	&dev_attr_fcoe_mac,
-	&dev_attr_fka_period,
+struct attribute *qedf_host_attrs[] = {
+	&dev_attr_fcoe_mac.attr,
+	&dev_attr_fka_period.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 9f8e8ef405a1..3e4f872e85b2 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -22,7 +22,7 @@ extern struct iscsi_transport qedi_iscsi_transport;
 extern const struct qed_iscsi_ops *qedi_ops;
 extern const struct qedi_debugfs_ops qedi_debugfs_ops[];
 extern const struct file_operations qedi_dbg_fops[];
-extern struct device_attribute *qedi_shost_attrs[];
+extern struct attribute *qedi_shost_attrs[];
 
 int qedi_alloc_sq(struct qedi_ctx *qedi, struct qedi_endpoint *ep);
 void qedi_free_sq(struct qedi_ctx *qedi, struct qedi_endpoint *ep);
diff --git a/drivers/scsi/qedi/qedi_sysfs.c b/drivers/scsi/qedi/qedi_sysfs.c
index be174d30eb7c..d1c1c00ce434 100644
--- a/drivers/scsi/qedi/qedi_sysfs.c
+++ b/drivers/scsi/qedi/qedi_sysfs.c
@@ -42,8 +42,8 @@ static ssize_t speed_show(struct device *dev,
 static DEVICE_ATTR_RO(port_state);
 static DEVICE_ATTR_RO(speed);
 
-struct device_attribute *qedi_shost_attrs[] = {
-	&dev_attr_port_state,
-	&dev_attr_speed,
+struct attribute *qedi_shost_attrs[] = {
+	&dev_attr_port_state.attr,
+	&dev_attr_speed.attr,
 	NULL
 };
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index cb5f2ecb652d..3238d5a12b8a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2482,51 +2482,51 @@ static DEVICE_ATTR(fw_attr, 0444, qla2x00_fw_attr_show, NULL);
 static DEVICE_ATTR_RO(edif_doorbell);
 
 
-struct device_attribute *qla2x00_host_attrs[] = {
-	&dev_attr_driver_version,
-	&dev_attr_fw_version,
-	&dev_attr_serial_num,
-	&dev_attr_isp_name,
-	&dev_attr_isp_id,
-	&dev_attr_model_name,
-	&dev_attr_model_desc,
-	&dev_attr_pci_info,
-	&dev_attr_link_state,
-	&dev_attr_zio,
-	&dev_attr_zio_timer,
-	&dev_attr_beacon,
-	&dev_attr_beacon_config,
-	&dev_attr_optrom_bios_version,
-	&dev_attr_optrom_efi_version,
-	&dev_attr_optrom_fcode_version,
-	&dev_attr_optrom_fw_version,
-	&dev_attr_84xx_fw_version,
-	&dev_attr_total_isp_aborts,
-	&dev_attr_serdes_version,
-	&dev_attr_mpi_version,
-	&dev_attr_phy_version,
-	&dev_attr_flash_block_size,
-	&dev_attr_vlan_id,
-	&dev_attr_vn_port_mac_address,
-	&dev_attr_fabric_param,
-	&dev_attr_fw_state,
-	&dev_attr_optrom_gold_fw_version,
-	&dev_attr_thermal_temp,
-	&dev_attr_diag_requests,
-	&dev_attr_diag_megabytes,
-	&dev_attr_fw_dump_size,
-	&dev_attr_allow_cna_fw_dump,
-	&dev_attr_pep_version,
-	&dev_attr_min_supported_speed,
-	&dev_attr_max_supported_speed,
-	&dev_attr_zio_threshold,
-	&dev_attr_dif_bundle_statistics,
-	&dev_attr_port_speed,
-	&dev_attr_port_no,
-	&dev_attr_fw_attr,
-	&dev_attr_dport_diagnostics,
-	&dev_attr_edif_doorbell,
-	&dev_attr_mpi_pause,
+struct attribute *qla2x00_host_attrs[] = {
+	&dev_attr_driver_version.attr,
+	&dev_attr_fw_version.attr,
+	&dev_attr_serial_num.attr,
+	&dev_attr_isp_name.attr,
+	&dev_attr_isp_id.attr,
+	&dev_attr_model_name.attr,
+	&dev_attr_model_desc.attr,
+	&dev_attr_pci_info.attr,
+	&dev_attr_link_state.attr,
+	&dev_attr_zio.attr,
+	&dev_attr_zio_timer.attr,
+	&dev_attr_beacon.attr,
+	&dev_attr_beacon_config.attr,
+	&dev_attr_optrom_bios_version.attr,
+	&dev_attr_optrom_efi_version.attr,
+	&dev_attr_optrom_fcode_version.attr,
+	&dev_attr_optrom_fw_version.attr,
+	&dev_attr_84xx_fw_version.attr,
+	&dev_attr_total_isp_aborts.attr,
+	&dev_attr_serdes_version.attr,
+	&dev_attr_mpi_version.attr,
+	&dev_attr_phy_version.attr,
+	&dev_attr_flash_block_size.attr,
+	&dev_attr_vlan_id.attr,
+	&dev_attr_vn_port_mac_address.attr,
+	&dev_attr_fabric_param.attr,
+	&dev_attr_fw_state.attr,
+	&dev_attr_optrom_gold_fw_version.attr,
+	&dev_attr_thermal_temp.attr,
+	&dev_attr_diag_requests.attr,
+	&dev_attr_diag_megabytes.attr,
+	&dev_attr_fw_dump_size.attr,
+	&dev_attr_allow_cna_fw_dump.attr,
+	&dev_attr_pep_version.attr,
+	&dev_attr_min_supported_speed.attr,
+	&dev_attr_max_supported_speed.attr,
+	&dev_attr_zio_threshold.attr,
+	&dev_attr_dif_bundle_statistics.attr,
+	&dev_attr_port_speed.attr,
+	&dev_attr_port_no.attr,
+	&dev_attr_fw_attr.attr,
+	&dev_attr_dport_diagnostics.attr,
+	&dev_attr_edif_doorbell.attr,
+	&dev_attr_mpi_pause.attr,
 	NULL, /* reserve for qlini_mode */
 	NULL, /* reserve for ql2xiniexchg */
 	NULL, /* reserve for ql2xexchoffld */
@@ -2535,17 +2535,17 @@ struct device_attribute *qla2x00_host_attrs[] = {
 
 void qla_insert_tgt_attrs(void)
 {
-	struct device_attribute **attr;
+	struct attribute **attr;
 
 	/* advance to empty slot */
 	for (attr = &qla2x00_host_attrs[0]; *attr; ++attr)
 		continue;
 
-	*attr = &dev_attr_qlini_mode;
+	*attr = &dev_attr_qlini_mode.attr;
 	attr++;
-	*attr = &dev_attr_ql2xiniexchg;
+	*attr = &dev_attr_ql2xiniexchg.attr;
 	attr++;
-	*attr = &dev_attr_ql2xexchoffld;
+	*attr = &dev_attr_ql2xexchoffld.attr;
 }
 
 /* Host attributes. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 8aadcdeca6cb..df1831ab8cb1 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -742,8 +742,7 @@ uint qla25xx_fdmi_port_speed_currently(struct qla_hw_data *);
  * Global Function Prototypes in qla_attr.c source file.
  */
 struct device_attribute;
-extern struct device_attribute *qla2x00_host_attrs[];
-extern struct device_attribute *qla2x00_host_attrs_dm[];
+extern struct attribute *qla2x00_host_attrs[];
 struct fc_function_template;
 extern struct fc_function_template qla2xxx_transport_functions;
 extern struct fc_function_template qla2xxx_transport_vport_functions;
diff --git a/drivers/scsi/qla4xxx/ql4_attr.c b/drivers/scsi/qla4xxx/ql4_attr.c
index ec4352818fbf..17124b695668 100644
--- a/drivers/scsi/qla4xxx/ql4_attr.c
+++ b/drivers/scsi/qla4xxx/ql4_attr.c
@@ -330,21 +330,21 @@ static DEVICE_ATTR(fw_ext_timestamp, S_IRUGO, qla4xxx_fw_ext_timestamp_show,
 static DEVICE_ATTR(fw_load_src, S_IRUGO, qla4xxx_fw_load_src_show, NULL);
 static DEVICE_ATTR(fw_uptime, S_IRUGO, qla4xxx_fw_uptime_show, NULL);
 
-struct device_attribute *qla4xxx_host_attrs[] = {
-	&dev_attr_fw_version,
-	&dev_attr_serial_num,
-	&dev_attr_iscsi_version,
-	&dev_attr_optrom_version,
-	&dev_attr_board_id,
-	&dev_attr_fw_state,
-	&dev_attr_phy_port_cnt,
-	&dev_attr_phy_port_num,
-	&dev_attr_iscsi_func_cnt,
-	&dev_attr_hba_model,
-	&dev_attr_fw_timestamp,
-	&dev_attr_fw_build_user,
-	&dev_attr_fw_ext_timestamp,
-	&dev_attr_fw_load_src,
-	&dev_attr_fw_uptime,
+struct attribute *qla4xxx_host_attrs[] = {
+	&dev_attr_fw_version.attr,
+	&dev_attr_serial_num.attr,
+	&dev_attr_iscsi_version.attr,
+	&dev_attr_optrom_version.attr,
+	&dev_attr_board_id.attr,
+	&dev_attr_fw_state.attr,
+	&dev_attr_phy_port_cnt.attr,
+	&dev_attr_phy_port_num.attr,
+	&dev_attr_iscsi_func_cnt.attr,
+	&dev_attr_hba_model.attr,
+	&dev_attr_fw_timestamp.attr,
+	&dev_attr_fw_build_user.attr,
+	&dev_attr_fw_ext_timestamp.attr,
+	&dev_attr_fw_load_src.attr,
+	&dev_attr_fw_uptime.attr,
 	NULL,
 };
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index ea60057b2e20..b1bd47f32e31 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -286,5 +286,5 @@ extern int ql4xenablemsix;
 extern int ql4xmdcapmask;
 extern int ql4xenablemd;
 
-extern struct device_attribute *qla4xxx_host_attrs[];
+extern struct attribute *qla4xxx_host_attrs[];
 #endif /* _QLA4x_GBL_H */
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 6d9152031a40..d983a7df4a49 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -143,7 +143,7 @@ extern struct scsi_transport_template blank_transport_template;
 extern void __scsi_remove_device(struct scsi_device *);
 
 extern struct bus_type scsi_bus_type;
-extern const struct attribute_group *scsi_sysfs_shost_attr_groups[];
+extern const struct attribute_group scsi_host_attr_group;
 
 /* scsi_netlink.c */
 #ifdef CONFIG_SCSI_NETLINK
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 86793259e541..2591e7ade4b1 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -424,13 +424,8 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	NULL
 };
 
-static struct attribute_group scsi_shost_attr_group = {
-	.attrs =	scsi_sysfs_shost_attrs,
-};
-
-const struct attribute_group *scsi_sysfs_shost_attr_groups[] = {
-	&scsi_shost_attr_group,
-	NULL
+const struct attribute_group scsi_host_attr_group = {
+	.attrs = scsi_sysfs_shost_attrs,
 };
 
 static void scsi_device_cls_release(struct device *class_dev)
@@ -1584,18 +1579,6 @@ EXPORT_SYMBOL(scsi_register_interface);
  **/
 int scsi_sysfs_add_host(struct Scsi_Host *shost)
 {
-	int error, i;
-
-	/* add host specific attributes */
-	if (shost->hostt->shost_attrs) {
-		for (i = 0; shost->hostt->shost_attrs[i]; i++) {
-			error = device_create_file(&shost->shost_dev,
-					shost->hostt->shost_attrs[i]);
-			if (error)
-				return error;
-		}
-	}
-
 	transport_register_device(&shost->shost_gendev);
 	transport_configure_device(&shost->shost_gendev);
 	return 0;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ecb2af3f43ca..0b3e150c9f86 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6631,17 +6631,17 @@ static DEVICE_ATTR(enable_r5_writes, 0644,
 static DEVICE_ATTR(enable_r6_writes, 0644,
 	pqi_host_enable_r6_writes_show, pqi_host_enable_r6_writes_store);
 
-static struct device_attribute *pqi_shost_attrs[] = {
-	&dev_attr_driver_version,
-	&dev_attr_firmware_version,
-	&dev_attr_model,
-	&dev_attr_serial_number,
-	&dev_attr_vendor,
-	&dev_attr_rescan,
-	&dev_attr_lockup_action,
-	&dev_attr_enable_stream_detection,
-	&dev_attr_enable_r5_writes,
-	&dev_attr_enable_r6_writes,
+static struct attribute *pqi_shost_attrs[] = {
+	&dev_attr_driver_version.attr,
+	&dev_attr_firmware_version.attr,
+	&dev_attr_model.attr,
+	&dev_attr_serial_number.attr,
+	&dev_attr_vendor.attr,
+	&dev_attr_rescan.attr,
+	&dev_attr_lockup_action.attr,
+	&dev_attr_enable_stream_detection.attr,
+	&dev_attr_enable_r5_writes.attr,
+	&dev_attr_enable_r6_writes.attr,
 	NULL
 };
 
diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index f4c666285bba..1b51f131a9aa 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -374,7 +374,7 @@ int snic_glob_init(void);
 void snic_glob_cleanup(void);
 
 extern struct workqueue_struct *snic_event_queue;
-extern struct device_attribute *snic_attrs[];
+extern struct attribute *snic_attrs[];
 
 int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int snic_abort_cmd(struct scsi_cmnd *);
diff --git a/drivers/scsi/snic/snic_attrs.c b/drivers/scsi/snic/snic_attrs.c
index 32d5d556b6f8..eaad670a16df 100644
--- a/drivers/scsi/snic/snic_attrs.c
+++ b/drivers/scsi/snic/snic_attrs.c
@@ -68,10 +68,10 @@ static DEVICE_ATTR(snic_state, S_IRUGO, snic_show_state, NULL);
 static DEVICE_ATTR(drv_version, S_IRUGO, snic_show_drv_version, NULL);
 static DEVICE_ATTR(link_state, S_IRUGO, snic_show_link_state, NULL);
 
-struct device_attribute *snic_attrs[] = {
-	&dev_attr_snic_sym_name,
-	&dev_attr_snic_state,
-	&dev_attr_drv_version,
-	&dev_attr_link_state,
+struct attribute *snic_attrs[] = {
+	&dev_attr_snic_sym_name.attr,
+	&dev_attr_snic_state.attr,
+	&dev_attr_drv_version.attr,
+	&dev_attr_link_state.attr,
 	NULL,
 };
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 75363707b73f..5afdc094a445 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -476,7 +476,7 @@ struct scsi_host_template {
 	/*
 	 * Pointer to the sysfs class properties for this host, NULL terminated.
 	 */
-	struct device_attribute **shost_attrs;
+	struct attribute **shost_attrs;
 
 	/*
 	 * Pointer to the SCSI device properties for this host, NULL terminated.
@@ -695,6 +695,8 @@ struct Scsi_Host {
 
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;
+	struct attribute_group  shost_driver_attr_group;
+	const struct attribute_group *shost_dev_attr_groups[3];
 
 	/*
 	 * Points to the transport data (if any) which is allocated
