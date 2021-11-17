Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15021C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 10:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E509F63238
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 10:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhKQKqF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 05:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbhKQKqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 05:46:05 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2698AC061570
        for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2021 02:43:07 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id b11so1744465pld.12
        for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2021 02:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=T54WfLJKrVRvLZ1LMuisO39598TAhuMzh2M+iNDr5Ms=;
        b=hJZw53UGdTsLLFNbsXG70vbZYSz8bOFvQN7Y7KrwuXSeJl9r1p1D2A70rEHGAqEf2w
         uZkC1V0Q35mjAAX8BYM422j4rJqc5bWq1wkVTKtSGbN8Y0vKjrkrOU1nWLi0x2tc9sVa
         6q8itPt8FD1cAGSRm/L/uRaXjMo43YdeB88ig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=T54WfLJKrVRvLZ1LMuisO39598TAhuMzh2M+iNDr5Ms=;
        b=ZdpfCMUL1EC0phiLQtn8rkd3MjlUO3h9Rphstn+tkuc8onj7JdW2oZtY9oHHriX6Y6
         lA0M/D+bY5Z+m3NWbRs8GhJS8vR4bTooTiUbyLbUnQpoPhCoYCt1jFRb3nikrwmSZoiN
         ll5qgYwGML7FX8Hrnsn5iWvuLc7Fy1xM4M2o4IQScFa8v63ler+0Xqf3kWh2cJ7Ytkny
         tyiCWpO7ka/Ct0Vz9m3iD5VdXFdaFCZm/eTBC2b3AE5DQLFGQ22moO7ijqcqLSurdixZ
         4damjKcu8/v2aqPFzeH0wHVC4evu+7+bzAV96Md97ybw+fCWP7JXBicLOlmZOFxY9/TE
         B48g==
X-Gm-Message-State: AOAM532lBJnHxlMOQTkntOisMG/3iZHs/JWHHzgM5fe+xDtNK1v/+fae
        IHyj94ZmdY5cuc4/1jDOXYcGs2f28opCQV6vOOoAUFPpSsvrhy32hwTc4oabZwuET+tLByQQqJc
        1aZ4PhSbMMmfUZXzW1UZfhIbs7fKwjAvzQKFuADn3dvHkWqdXKSRP3gK7dfOhdzNr1G5Vo9lKC2
        bFyeAhPwoK
X-Google-Smtp-Source: ABdhPJw1Imp0YoKyxzTQVGjuNjbIsGvVx6HaRyCVWIqxUJ6SP9SWEAwO8KTFkr4IAMtvnVhb3WRJ+g==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr8292504pjb.157.1637145786272;
        Wed, 17 Nov 2021 02:43:06 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id om8sm5392708pjb.12.2021.11.17.02.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 02:43:05 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     suganath-prabu.subramani@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH] mpt3sas: Fix system falling into readonly mode
Date:   Wed, 17 Nov 2021 16:20:58 +0530
Message-Id: <20211117105058.3505-1-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001065bd05d0f9b547"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000001065bd05d0f9b547
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

While determining the SAS address of a drive, the driver checks whether
the handle number is less than the HBA phys count or not.
If the handle number is less than the HBA phy’s count then driver
assumes that this handle belongs to HBA and hence it assigns the
HBA SAS address.
During IOC firmware downgrade operation, if the number of HBA phys got
reduced and the OS drive’s device handle falls below start of the day
HBA phys count then while determining the OS drive’s SAS address
driver uses the HBA SAS address. This leads to a mismatch of drive’s
SAS address and hence the driver unregisters the OS drive and the
system falls into read only mode.

Updated the IOC's num_phys to HBA phy’s count provided by actual
loaded firmware. So that while determining the SAS address driver
uses updated HBA phy’s count value instead of using a
start of the day’s HBA phy’s count.

Fixes: a5e99fda0172("mpt3sas: Update hba_port objects after host reset")
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  4 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 57 +++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index db6a759de1e9..a0af986633d2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -142,6 +142,8 @@
 
 #define MPT_MAX_CALLBACKS		32
 
+#define MPT_MAX_HBA_NUM_PHYS		32
+
 #define INTERNAL_CMDS_COUNT		10	/* reserved cmds */
 /* reserved for issuing internally framed scsi io cmds */
 #define INTERNAL_SCSIIO_CMDS_COUNT	3
@@ -798,6 +800,7 @@ struct _sas_phy {
  * @enclosure_handle: handle for this a member of an enclosure
  * @device_info: bitwise defining capabilities of this sas_host/expander
  * @responding: used in _scsih_expander_device_mark_responding
+ * @nr_phys_allocated: Allocated memory for this many count phys
  * @phy: a list of phys that make up this sas_host/expander
  * @sas_port_list: list of ports attached to this sas_host/expander
  * @port: hba port entry containing node's port number info
@@ -813,6 +816,7 @@ struct _sas_node {
 	u16	enclosure_handle;
 	u64	enclosure_logical_id;
 	u8	responding;
+	u8	nr_phys_allocated;
 	struct hba_port *port;
 	struct	_sas_phy *phy;
 	struct list_head sas_port_list;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index bb0036b41825..589d0515a00c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -6406,11 +6406,26 @@ _scsih_sas_port_refresh(struct MPT3SAS_ADAPTER *ioc)
 	int i, j, count = 0, lcount = 0;
 	int ret;
 	u64 sas_addr;
+	u8 num_phys;
 
 	drsprintk(ioc, ioc_info(ioc,
 	    "updating ports for sas_host(0x%016llx)\n",
 	    (unsigned long long)ioc->sas_hba.sas_address));
 
+	mpt3sas_config_get_number_hba_phys(ioc, &num_phys);
+	if (!num_phys) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	if (num_phys > ioc->sas_hba.nr_phys_allocated) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+		   __FILE__, __LINE__, __func__);
+		return;
+	}
+	ioc->sas_hba.num_phys = num_phys;
+
 	port_table = kcalloc(ioc->sas_hba.num_phys,
 	    sizeof(struct hba_port), GFP_KERNEL);
 	if (!port_table)
@@ -6611,6 +6626,30 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 			ioc->sas_hba.phy[i].hba_vphy = 1;
 		}
 
+		/*
+		 * Add new HBA phys to STL if these new phys got added as part
+		 * of HBA Firmware upgrade/downgrade operation.
+		 */
+		if (!ioc->sas_hba.phy[i].phy) {
+			if ((mpt3sas_config_get_phy_pg0(ioc, &mpi_reply,
+			    &phy_pg0, i))) {
+				ioc_err(ioc, "failure at %s:%d/%s()!\n",
+				    __FILE__, __LINE__, __func__);
+				continue;
+			}
+			ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+			    MPI2_IOCSTATUS_MASK;
+			if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+				ioc_err(ioc, "failure at %s:%d/%s()!\n",
+				    __FILE__, __LINE__, __func__);
+				continue;
+			}
+			ioc->sas_hba.phy[i].phy_id = i;
+			mpt3sas_transport_add_host_phy(ioc,
+			    &ioc->sas_hba.phy[i], phy_pg0,
+			    ioc->sas_hba.parent_dev);
+			continue;
+		}
 		ioc->sas_hba.phy[i].handle = ioc->sas_hba.handle;
 		attached_handle = le16_to_cpu(sas_iounit_pg0->PhyData[i].
 		    AttachedDevHandle);
@@ -6622,6 +6661,19 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 		    attached_handle, i, link_rate,
 		    ioc->sas_hba.phy[i].port);
 	}
+	/*
+	 * Clear the phy details if this phy got disabled as part of
+	 * HBA Firmware upgrade/downgrade operation.
+	 */
+	for (i = ioc->sas_hba.num_phys;
+	    i < ioc->sas_hba.nr_phys_allocated; i++) {
+		if (ioc->sas_hba.phy[i].phy &&
+		    ioc->sas_hba.phy[i].phy->negotiated_linkrate >=
+		    SAS_LINK_RATE_1_5_GBPS)
+			mpt3sas_transport_update_links(ioc,
+			    ioc->sas_hba.sas_address, 0, i,
+			    MPI2_SAS_NEG_LINK_RATE_PHY_DISABLED, NULL);
+	}
  out:
 	kfree(sas_iounit_pg0);
 }
@@ -6654,7 +6706,10 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 			__FILE__, __LINE__, __func__);
 		return;
 	}
-	ioc->sas_hba.phy = kcalloc(num_phys,
+
+	ioc->sas_hba.nr_phys_allocated = max_t(u8,
+	    MPT_MAX_HBA_NUM_PHYS, num_phys);
+	ioc->sas_hba.phy = kcalloc(ioc->sas_hba.nr_phys_allocated,
 	    sizeof(struct _sas_phy), GFP_KERNEL);
 	if (!ioc->sas_hba.phy) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
-- 
2.27.0


--0000000000001065bd05d0f9b547
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOn+zbhNwhBr8FfPOYMN
z5LhKrAz44FTphz6L7kusnLZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTExNzEwNDMwNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBIivLSVi/cjXgphAFBWM12aPTw+FzfQIRsvd4r
MHKR8oCjEHx0ZTZVUsSJQp2xk2rxTaFqmBKnzg9aL8PaGwg8lQMDyvtVecXUTHFryx0djuSHewSN
F6Ze2un915Ji6VAwXfJu1cYVWnUm/LyRz3pXnsIsjY2/Z69mMFDZ3oLTyY23fWy0/IO52DNlOU9E
ZxgCYe+7+51g7IeSkVuRcQTSct6OzQoFp9Py3kRU5XU/d8Txtxtyho+ARTnJndSw3dC8ExcWuRXT
qB6mIXB6iCXqjf/mLPL+5ooLcV9dVyXlVad2x9YS0rFDzKgnJ8FweiovMrQhk0zEVinE9NVP8X1m
--0000000000001065bd05d0f9b547--
