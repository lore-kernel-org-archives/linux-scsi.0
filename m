Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48688C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 09:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239018AbiBJJs5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 04:48:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239005AbiBJJsm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 04:48:42 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029D61DD
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 01:48:44 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y7so1375626plp.2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 01:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=lzQOXGXhqrqY4OfQORGWZaxpYZH91DvMSkjTFfI0Lic=;
        b=JPHmzTwH7d0t9HdiV19D5Zxm2fqDMh58Onbpn86ggwECtWs2sfJ68h1hpumXy13ZT7
         c1DivFEDJVzmT1FhxCRdPezsEdW2LF4yeP8Ume+lQtkTHUyxErfdl6RE4KqyvvgMNSjb
         OZA6maMrlPKPOYMjgWv4IlK9XR0AnAgH9hWYg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=lzQOXGXhqrqY4OfQORGWZaxpYZH91DvMSkjTFfI0Lic=;
        b=4kSZV3BXoAu9XzBfhVTs2CebDDO47EiIxxBTOe5xbO1UxLYp+C1XDDh/upgQIlGvAi
         z42Cyst7c+JuIqvhf6sNihgXlyyp0PZuXB7MQn8gJxBRZNIQI9ZK69RtkB/pb1KuBu0j
         1n4ts10Go40Od33s/e6LISPkx1KE6zxrfro5EzGvZN4jzy2iSsDUQe7rPwWsqA1fnV6Q
         ifVDS43d4BILHklWgF89h2ZD6hQ5RHbmjUrO5K4CqkMubeoZo5mG3ZmYaLAQqi2PWf+W
         kO3tMDEoWO1J/tn/upM1BEOJwrjH/mIzAUPs/WkHk1Ohi5ajbod1rAFlB/BNpm4mQhJk
         cS9A==
X-Gm-Message-State: AOAM533eXB5nPDeprL21AlYi7XE08BDr3qCUCvjKUE8xFTcod7MigE/u
        S+RKoC/Q5klmK6oJyFLp1dvXfvXo2ibguLoaAjajuQPpRw9j7n/cUtTcR4Seeyi5myq/cqUlXuh
        JybqGgXWoP35mKjbj4RWhF7dS2aWTs+ifQDRAyl1wKuiqthDNsp1F5wIt4gr1SFGdBUs1PvYOTp
        6jh21ZTYdfECI=
X-Google-Smtp-Source: ABdhPJzcfYNJ/OrV54lCSA/+EH5ih2C2CdhAmrcfekQinu3ZZMfzwiypTLZnZL06Heg0m/atP9CKdQ==
X-Received: by 2002:a17:90a:2fc5:: with SMTP id n5mr1881686pjm.67.1644486523100;
        Thu, 10 Feb 2022 01:48:43 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o21sm23706698pfu.100.2022.02.10.01.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 01:48:42 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 5/9] mpi3mr: Fix cmnd getting marked as inuse forever
Date:   Thu, 10 Feb 2022 15:28:13 +0530
Message-Id: <20220210095817.22828-6-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220210095817.22828-1-sreekanth.reddy@broadcom.com>
References: <20220210095817.22828-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000137f9d05d7a6db87"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000137f9d05d7a6db87
Content-Transfer-Encoding: 8bit

When a driver command which requires the driver to issue
follow up command using the same command frame is outstanding
and a soft reset operation occurs then that driver command
frame is getting marked as inuse permanently and won't be
reused again.

Clear the driver command frames while flushing out the
outstanding commands and avoid issuing any new requests
using these command frames while soft reset is going on.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 43e5cc6..1c2e7d3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1583,6 +1583,9 @@ static void mpi3mr_dev_rmhs_complete_iou(struct mpi3mr_ioc *mrioc,
 	u16 cmd_idx = drv_cmd->host_tag - MPI3MR_HOSTTAG_DEVRMCMD_MIN;
 	struct delayed_dev_rmhs_node *delayed_dev_rmhs = NULL;
 
+	if (drv_cmd->state & MPI3MR_CMD_RESET)
+		goto clear_drv_cmd;
+
 	ioc_info(mrioc,
 	    "%s :dev_rmhs_iouctrl_complete:handle(0x%04x), ioc_status(0x%04x), loginfo(0x%08x)\n",
 	    __func__, drv_cmd->dev_handle, drv_cmd->ioc_status,
@@ -1623,6 +1626,8 @@ static void mpi3mr_dev_rmhs_complete_iou(struct mpi3mr_ioc *mrioc,
 		kfree(delayed_dev_rmhs);
 		return;
 	}
+
+clear_drv_cmd:
 	drv_cmd->state = MPI3MR_CMD_NOTUSED;
 	drv_cmd->callback = NULL;
 	drv_cmd->retry_count = 0;
@@ -1649,6 +1654,9 @@ static void mpi3mr_dev_rmhs_complete_tm(struct mpi3mr_ioc *mrioc,
 	struct mpi3_scsi_task_mgmt_reply *tm_reply = NULL;
 	int retval;
 
+	if (drv_cmd->state & MPI3MR_CMD_RESET)
+		goto clear_drv_cmd;
+
 	if (drv_cmd->state & MPI3MR_CMD_REPLY_VALID)
 		tm_reply = (struct mpi3_scsi_task_mgmt_reply *)drv_cmd->reply;
 
@@ -1677,11 +1685,11 @@ static void mpi3mr_dev_rmhs_complete_tm(struct mpi3mr_ioc *mrioc,
 	if (retval) {
 		pr_err(IOCNAME "Issue DevRmHsTMIOUCTL: Admin post failed\n",
 		    mrioc->name);
-		goto out_failed;
+		goto clear_drv_cmd;
 	}
 
 	return;
-out_failed:
+clear_drv_cmd:
 	drv_cmd->state = MPI3MR_CMD_NOTUSED;
 	drv_cmd->callback = NULL;
 	drv_cmd->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
@@ -1796,6 +1804,9 @@ static void mpi3mr_complete_evt_ack(struct mpi3mr_ioc *mrioc,
 	u16 cmd_idx = drv_cmd->host_tag - MPI3MR_HOSTTAG_EVTACKCMD_MIN;
 	struct delayed_evt_ack_node *delayed_evtack = NULL;
 
+	if (drv_cmd->state & MPI3MR_CMD_RESET)
+		goto clear_drv_cmd;
+
 	if (drv_cmd->ioc_status != MPI3_IOCSTATUS_SUCCESS) {
 		dprint_event_th(mrioc,
 		    "immediate event ack failed with ioc_status(0x%04x) log_info(0x%08x)\n",
@@ -1813,6 +1824,7 @@ static void mpi3mr_complete_evt_ack(struct mpi3mr_ioc *mrioc,
 		kfree(delayed_evtack);
 		return;
 	}
+clear_drv_cmd:
 	drv_cmd->state = MPI3MR_CMD_NOTUSED;
 	drv_cmd->callback = NULL;
 	clear_bit(cmd_idx, mrioc->evtack_cmds_bitmap);
-- 
2.27.0


--000000000000137f9d05d7a6db87
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIN9Nfg/tTVjJDlsuQUom
r81UYTH4G6w/gYNLBAl9R2PmMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDIxMDA5NDg0M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCRKCzYItWgPDX/4hbhdcXLXi7WSWFiBCzCnEMQ
YbRANcLrvo8T08KDXbr64J9LhbboWHAso+y4/ba8D5wR9DUU7O9XHUiz8UFCo+7ioBDlNu8adI5F
Bubzqv5b/Z5b5VC2l6SwjbLjd2SGYqZTsuPPWy4+GvnKqyNZRtalMDDF1qcYnZUKMHMywLs4ehN+
A1ogXkwQW21Kh/1h/nw5iSZ6UAkhHQSv/nGlDvpJqwcPLRIMrmMRzFoTjTcn8afuFNwt1aCWFAqf
PN4rXvIOmEouMIGQMrOEV/7XByBbaXffTgy4HY2cX6ULv8ZBBQv/8iSh3AUOlxRSF0emcNb2Gj5C
--000000000000137f9d05d7a6db87--
