Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A66C388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B19B220829
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:08:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Uo8/LQYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751847AbgJ0NIY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 09:08:24 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:47048 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbgJ0NIY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 09:08:24 -0400
Received: by mail-pf1-f195.google.com with SMTP id y14so870088pfp.13
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2020 06:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=RvqD1hxbCJTNgIjxswx7vVCFxQ+/FHoPoM4NS3H2xJg=;
        b=Uo8/LQYNyiVEDaOzpydbGNMyeIfM6uBfnurGruOv+urUpNBdulJVZitOF2Xwk7VxZT
         kds3hfQ+fyYqjvj1zPrKUA7GjkVOemZWueUFa2+YXEgynVySDxdHh6iDFfxntmfZADcC
         gDABGSL9C1lEVlLs+AprMMECxQpgV3e6jD+YY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=RvqD1hxbCJTNgIjxswx7vVCFxQ+/FHoPoM4NS3H2xJg=;
        b=nZ36DOewmLgmwvPPktkXy9aNSlP16xXgPy5Wdi6EjZ/zjmZcCI/Y+taU+ztRWhxy1e
         ldwtADFnnaWpu8x2TV0kG/GIquMiYvCxKFONDvkDrSvy2RvMNxOqJrWSSqRD9XYR4tIQ
         9Qr5mDCsPpgMLh5YjSKs7IGv17Ymg+75fJ1XKqPB/3BVCGPEDxQA1lEzsNcfP/HsEl1n
         s7z/7mJdUkIQ9e7NlUCpruwZMW2eiJk6PtgoIaWtiSiw/U1gA8FRRr+J+Q2OhifYFovH
         4kc9HBFMJpBwCQoL6vnZRLmNsUWqVU+UTVorcoLBalOHFWIP6+iIQeBkOsWeQbBlUyZg
         OH1A==
X-Gm-Message-State: AOAM530fkQTefjlVc9pYfA3PFj1xSNnC60F9I2Ajj5hUN2MZvFBXkWVI
        Bd1IbmrEViymJfAcqhNYMlmYuw==
X-Google-Smtp-Source: ABdhPJyOB8+gIFYKCtmOrb3g1KRIUnI7+eDo4ltsnroXtp/zNjvRDtztHJl07/TKe8GW9INCtzqNrg==
X-Received: by 2002:a05:6a00:2294:b029:163:f54d:46e5 with SMTP id f20-20020a056a002294b0290163f54d46e5mr2288062pfe.27.1603804102626;
        Tue, 27 Oct 2020 06:08:22 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b24sm2009319pge.59.2020.10.27.06.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 06:08:21 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 01/14] mpt3sas: Define hba_port structure
Date:   Tue, 27 Oct 2020 18:38:34 +0530
Message-Id: <20201027130847.9962-2-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
References: <20201027130847.9962-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000db2d8005b2a6bd89"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000db2d8005b2a6bd89
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Defined a new hba_port structure with holds below variables,
- port_id       : Port ID of the narrow/wide port of the HBA
- sas_address   : SAS Address of the remote device that is
                  attached to the current HBA port
- phy_mask      : HBA’s phy bits to which above SAS addressed
                  device is attached
- flags         : this field is used to refresh this port details
                  during HBA reset.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
v1:
No change.

 drivers/scsi/mpt3sas/mpt3sas_base.h | 35 ++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index bc8beb1..2dde574 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -420,6 +420,7 @@ struct Mpi2ManufacturingPage11_t {
  * @flags: MPT_TARGET_FLAGS_XXX flags
  * @deleted: target flaged for deletion
  * @tm_busy: target is busy with TM request.
+ * @port: hba port entry containing target's port number info
  * @sas_dev: The sas_device associated with this target
  * @pcie_dev: The pcie device associated with this target
  */
@@ -432,6 +433,7 @@ struct MPT3SAS_TARGET {
 	u32	flags;
 	u8	deleted;
 	u8	tm_busy;
+	struct hba_port *port;
 	struct _sas_device *sas_dev;
 	struct _pcie_device *pcie_dev;
 };
@@ -534,6 +536,7 @@ struct _internal_cmd {
  *	addition routine.
  * @chassis_slot: chassis slot
  * @is_chassis_slot_valid: chassis slot valid or not
+ * @port: hba port entry containing device's port number info
  */
 struct _sas_device {
 	struct list_head list;
@@ -560,6 +563,7 @@ struct _sas_device {
 	u8	is_chassis_slot_valid;
 	u8	connector_name[5];
 	struct kref refcount;
+	struct hba_port *port;
 };
 
 static inline void sas_device_get(struct _sas_device *s)
@@ -730,6 +734,7 @@ struct _boot_device {
  * @remote_identify: attached device identification
  * @rphy: sas transport rphy object
  * @port: sas transport wide/narrow port object
+ * @hba_port: hba port entry containing port's port number info
  * @phy_list: _sas_phy list objects belonging to this port
  */
 struct _sas_port {
@@ -738,6 +743,7 @@ struct _sas_port {
 	struct sas_identify remote_identify;
 	struct sas_rphy *rphy;
 	struct sas_port *port;
+	struct hba_port *hba_port;
 	struct list_head phy_list;
 };
 
@@ -751,6 +757,7 @@ struct _sas_port {
  * @handle: device handle for this phy
  * @attached_handle: device handle for attached device
  * @phy_belongs_to_port: port has been created for this phy
+ * @port: hba port entry containing port number info
  */
 struct _sas_phy {
 	struct list_head port_siblings;
@@ -761,6 +768,7 @@ struct _sas_phy {
 	u16	handle;
 	u16	attached_handle;
 	u8	phy_belongs_to_port;
+	struct hba_port *port;
 };
 
 /**
@@ -776,6 +784,7 @@ struct _sas_phy {
  * @responding: used in _scsih_expander_device_mark_responding
  * @phy: a list of phys that make up this sas_host/expander
  * @sas_port_list: list of ports attached to this sas_host/expander
+ * @port: hba port entry containing node's port number info
  */
 struct _sas_node {
 	struct list_head list;
@@ -787,11 +796,11 @@ struct _sas_node {
 	u16	enclosure_handle;
 	u64	enclosure_logical_id;
 	u8	responding;
+	struct hba_port *port;
 	struct	_sas_phy *phy;
 	struct list_head sas_port_list;
 };
 
-
 /**
  * struct _enclosure_node - enclosure information
  * @list: list of enclosures
@@ -1009,6 +1018,27 @@ struct reply_post_struct {
 	dma_addr_t			reply_post_free_dma;
 };
 
+/**
+ * struct hba_port - Saves each HBA's Wide/Narrow port info
+ * @sas_address: sas address of this wide/narrow port's attached device
+ * @phy_mask: HBA PHY's belonging to this port
+ * @port_id: port number
+ * @flags: hba port flags
+ */
+struct hba_port {
+	struct list_head list;
+	u64	sas_address;
+	u32	phy_mask;
+	u8      port_id;
+	u8	flags;
+};
+
+/* hba port flags */
+#define HBA_PORT_FLAG_DIRTY_PORT       0x01
+#define HBA_PORT_FLAG_NEW_PORT         0x02
+
+#define MULTIPATH_DISABLED_PORT_ID     0xFF
+
 typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
 /**
  * struct MPT3SAS_ADAPTER - per adapter struct
@@ -1191,6 +1221,7 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  *	which ensures the syncrhonization between cli/sysfs_show path.
  * @atomic_desc_capable: Atomic Request Descriptor support.
  * @GET_MSIX_INDEX: Get the msix index of high iops queues.
+ * @port_table_list: list containing HBA's wide/narrow port's info
  */
 struct MPT3SAS_ADAPTER {
 	struct list_head list;
@@ -1483,6 +1514,8 @@ struct MPT3SAS_ADAPTER {
 	PUT_SMID_IO_FP_HIP put_smid_hi_priority;
 	PUT_SMID_DEFAULT put_smid_default;
 	GET_MSIX_INDEX get_msix_index_for_smlio;
+
+	struct list_head port_table_list;
 };
 
 struct mpt3sas_debugfs_buffer {
-- 
2.18.4


--000000000000db2d8005b2a6bd89
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
piINKwvi7U/uYzTu4GDmW5YgtmLxNJ7iP3/e4hqSDu8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjAxMDI3MTMwODIzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjAL
BgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJGLUx6vZufvstCvJaYv
K0KSrGHwJD5G3n7cBNEZlE6JrJnNDMvaPb8hUC4IHSKFuPqflusBQBV1QQvb7t24kKOT02F8vnE5
x2rRLsNzDfbr0JEIBKnCdBStv+lcaeSap28ac1AkoKHefeqCDMY7DoN9ULui/ZEfoqutlWo3PmTt
pgLgqJFGMWsJlXB3V6PdlUWEZFtDIeAQqA3drVU+PrE9UnRwPtvqh9K3c2aMJ40eyj9n6hlyQu2t
cCCKMCMrWQEb8y4xpCyLy1ymjDKUR2dHrSXXNmPJcLzU0ClMh13ah4r5sZF0XHKFMb2yyoyuc/x8
c0OWxmDCp366lZceQ8I=
--000000000000db2d8005b2a6bd89--
