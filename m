Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F95BC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 13:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354505AbiELNud (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 09:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354694AbiELNu1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 09:50:27 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD26E2550A9
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 06:50:26 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c14so4865158pfn.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 06:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=rM70m8eZ0pakv69/iTvtJzOWiFpVeylcQX42wha9Z4w=;
        b=NQvrMdOzQ4dB6DLqQpRKShb6bsG3gRH87u39uKG3sWdMYrTB4uckttbH5k/TS5esqK
         SwfAumu4PlCxn5MJFp9kiuI1OTD6/EJQwvs5Uu7GkSd8rVwAPYHLBYPfvsfLDMggPZlz
         od7FKf1ktwA8aO27pXmA0QonFkgrCb4N204cw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=rM70m8eZ0pakv69/iTvtJzOWiFpVeylcQX42wha9Z4w=;
        b=HkSwtQCMAMKiYJEO6r6o34LPw7cTITsNM0lmbIMSjf3pt38YmuRmZJQZI5X26LuuGa
         Wn1h5scyBHKoVaQdjnYFBKza9hupG3kJYND+uqpUxBoRatuHdkHDJ+wxiuwa/0G5Fb0+
         TjD0PjiC9SuMeVZ6lZ96upB4jg2VvpBYHBLRtZs3Dx1xwcNa5LuybJpaD+jIBqT9gctt
         IXDaCujxl+BALlHJXEaVj7+WyMh4aNkx8Yo6CkxRULU5f6t7d3sTRIYHyPw1VcSKFvLq
         WNHVN6rLaT1Wtkp1+0MXrJSslgKRnuaYT1bsRDB9MZoknCP55zQ6hVknQHiXoa2i37Yi
         Vzzg==
X-Gm-Message-State: AOAM530ppGI65aJWQJGJDuNrRTv4WzPd8jAygk8X292CWeo4RIdxyBUJ
        1utGL5VCrVipRAV9tqgCRgLxkPKqDvLHKEX9Z2MC341H8+sOylYYahTTX55o7IYsK8zwg/pIF8b
        xp9zXK0NQyAYhHL9sb0eoyOwwTXCfF3uQp2HyoMi06Q45rWKdyMA6krMzLVStFR0OaI3a81QwgP
        htUSwy82/7
X-Google-Smtp-Source: ABdhPJzNvt2R6ul81nFckPjiuczwAWfxRNLv86HNvyvOBsyPKmR5kBLCcBWV6e47Xxy6BhwGVZyBNQ==
X-Received: by 2002:a63:d907:0:b0:3c6:c6e3:1498 with SMTP id r7-20020a63d907000000b003c6c6e31498mr15433803pgg.535.1652363425593;
        Thu, 12 May 2022 06:50:25 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.252.250])
        by smtp.gmail.com with ESMTPSA id t21-20020a17090ad15500b001cd4989ff47sm1872409pjw.14.2022.05.12.06.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 06:50:24 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 1/2] mpi3mr: Add shost related sysfs attributes
Date:   Thu, 12 May 2022 19:30:45 +0530
Message-Id: <20220512140046.19046-2-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220512140046.19046-1-sreekanth.reddy@broadcom.com>
References: <20220512140046.19046-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000d114a05ded0d7a4"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000000d114a05ded0d7a4
Content-Transfer-Encoding: 8bit

Added shost related sysfs attributes to get the controller's
firmware version, controlller's queue depth,
number of request & reply queues.
Also added an attribute to set & get the logging_level.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 139 +++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 73bb799..c9b153c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1558,6 +1558,140 @@ err_device_add:
 	kfree(mrioc->bsg_dev);
 }
 
+/**
+ * version_fw_show - SysFS callback for firmware version read
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Return: snprintf() return after copying firmware version
+ */
+static ssize_t
+version_fw_show(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+	struct mpi3mr_compimg_ver *fwver = &mrioc->facts.fw_ver;
+
+	return snprintf(buf, PAGE_SIZE, "%d.%d.%d.%d.%05d-%05d\n",
+	    fwver->gen_major, fwver->gen_minor, fwver->ph_major,
+	    fwver->ph_minor, fwver->cust_id, fwver->build_num);
+}
+static DEVICE_ATTR_RO(version_fw);
+
+/**
+ * fw_queue_depth_show - SysFS callback for firmware max cmds
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Return: snprintf() return after copying firmware max commands
+ */
+static ssize_t
+fw_queue_depth_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", mrioc->facts.max_reqs);
+}
+static DEVICE_ATTR_RO(fw_queue_depth);
+
+/**
+ * op_req_q_count_show - SysFS callback for request queue count
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Return: snprintf() return after copying request queue count
+ */
+static ssize_t
+op_req_q_count_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", mrioc->num_op_req_q);
+}
+static DEVICE_ATTR_RO(op_req_q_count);
+
+/**
+ * reply_queue_count_show - SysFS callback for reply queue count
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * Return: snprintf() return after copying reply queue count
+ */
+static ssize_t
+reply_queue_count_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", mrioc->num_op_reply_q);
+}
+
+static DEVICE_ATTR_RO(reply_queue_count);
+
+/**
+ * logging_level_show - Show controller debug level
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ *
+ * A sysfs 'read/write' shost attribute, to show the current
+ * debug log level used by the driver for the specific
+ * controller.
+ *
+ * Return: snprintf() return
+ */
+static ssize_t
+logging_level_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+
+	return snprintf(buf, PAGE_SIZE, "%08xh\n", mrioc->logging_level);
+}
+
+/**
+ * logging_level_store- Change controller debug level
+ * @dev: class device
+ * @attr: Device attributes
+ * @buf: Buffer to copy
+ * @count: size of the buffer
+ *
+ * A sysfs 'read/write' shost attribute, to change the current
+ * debug log level used by the driver for the specific
+ * controller.
+ *
+ * Return: strlen() return
+ */
+static ssize_t
+logging_level_store(struct device *dev,
+	struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
+	int val = 0;
+
+	if (kstrtoint(buf, 0, &val) != 0)
+		return -EINVAL;
+
+	mrioc->logging_level = val;
+	ioc_info(mrioc, "logging_level=%08xh\n", mrioc->logging_level);
+	return strlen(buf);
+}
+static DEVICE_ATTR_RW(logging_level);
+
 /**
  * adapter_state_show - SysFS callback for adapter state show
  * @dev: class device
@@ -1591,6 +1725,11 @@ adp_state_show(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR_RO(adp_state);
 
 static struct attribute *mpi3mr_host_attrs[] = {
+	&dev_attr_version_fw.attr,
+	&dev_attr_fw_queue_depth.attr,
+	&dev_attr_op_req_q_count.attr,
+	&dev_attr_reply_queue_count.attr,
+	&dev_attr_logging_level.attr,
 	&dev_attr_adp_state.attr,
 	NULL,
 };
-- 
2.27.0


--0000000000000d114a05ded0d7a4
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJd9OfeSuUZWU1h+j+lD
6KthZ0+bFmVzSaZkAiy/nonXMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDUxMjEzNTAyNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCeG9/Kzs9j+SJzU37j/4i8PwtWd3t9Ds+mv3zK
UUX9NuI+aYBhcwE3HY6ToAIphj0PIKZsQrdngu+l4vdm/HnlW/ryzzXokikYwUla/aU3xIN5nQHz
tvE34ahqADy9zl3yiw6S2bcUUCyT8SLDj5qCf2Ci0MLP23qp6FclaQfAkjXvAHHBA3KGCbG/+ab6
4Qxck3NE41GEOFnIMt7pgzbP7jYrJmqZ/4UsVpabxKKddPlTYGEAWzduj2QV4YGCVOKoVxX8WO1J
lPwIa5KnbaqnvsvgFF9F8VPYet1hS+qXxAKDVl86GG8kWpepSDVu74Hto47hnlUb0xUz3TQWr8NP
--0000000000000d114a05ded0d7a4--
