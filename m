Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF611236437
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 23:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765410301; cv=none; b=mFc825b/4DTwwSGsLRJAAIUWHtyUjxKPotaK54pZI9cUaFtvoYfwsprK+Caxb3kYgQVrad0wEBBDGbmx2iZa1DqXD9V69xRD0Co61W0O8cprhLmKC/pj4RAjlZJrBMG6oQC4Edmxl4K7GEwUcvwNzazLfykB2Uku3/iFtqfe16Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765410301; c=relaxed/simple;
	bh=RugvdEoOGYRx8CQwiBeJNwn5hM9T3vTNDELridYr7Yg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aSdRQVo0Tbz6xGuk/GNu7nXKfKgAZCFUpJD6/n+P+VEQW/XhnAE1G4+cSehRI+7T6Xn/+/gKDoXkxfvQ4KWqY0Y6kz3e0qtR7igp06on97jnF6CO+S8KwzO79PG4YIXzXt8x4IwHW8TP6tEHlaHF3qky/r+RJbazCdRKaZERuxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HEqrZBLs; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEqrZBLs"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee0ce50b95so13651331cf.0
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765410299; x=1766015099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Lw8kR0IFn64iT60xzStWHklNm7jM9IWf2qBFmhqQdA=;
        b=HEqrZBLsUQLJzzNBJY8C5IE9/tMWHd6cSL1cIDrMQWfgOmIx+WAxBw6dfk75FQrZay
         3C+Zwdi4HWKQE5OfpVUMOMRiCREOvEIr7czLEYgKPCoh8U+IEzh+Y4wcEs7pNggyH/HS
         o5/wQpIEJUShHG2f0QSmw4f3sYn/fAQjToL/a+M8F9HqsSXSwt1CIuXg/KiUOHP8gYAr
         17OxgDoQhu+H9arEfi61+2rDXjdrinKHo2v5iQZV4zDZI60vdiWL65/eLTWcE33zpzik
         m3lxJSB8aC/i0gvuWDPhtYadYVx4lFnYJPntGHBwv31EsR9TpQfj/Z6Oh+JIdUs56tzo
         ewnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765410299; x=1766015099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Lw8kR0IFn64iT60xzStWHklNm7jM9IWf2qBFmhqQdA=;
        b=ZAjwVTZIeSRUYi2JYDLgkHEs6kNfJ7QRNNY2wDu26wxPWX9QEMXXyT6MwNDg90T9oS
         9O/RoeTJSk+ON/tVOWlj1prgkfv/ueIPLKxW8sCbZxyKjITbVxgF+YwgR9cPKPJr9hLP
         5w/QCJHVNEzh6ytXpU7dnbO2EN+SeUJTfyjz5GVkuTvVuB9WYIXVpC1FavD1Qqqo3Adr
         EGK42y55S3y1TMxCtDIsHPXrnXyoUDZDowsDdVj7Vn/jjyOk26l2HhBcK5OyBnTKO1F3
         Vx8qYheRLuaQjBILDncWxYXD8Y0vpbE9PnNtfA1b7ry7lTj7vpArQ/bOHL/9W4Z0bxtI
         sWow==
X-Gm-Message-State: AOJu0YzmrC9IrQ4kii8JkT/wHbZPsLD0s1/eWMn+7CZfV0iU+yuIiWU6
	xUcMseDzpi6GAawH6tetJmz2y/mBEe4sRUcmCCDwDHjmX3Ptjfu6Nkk+rUnRp7Og
X-Gm-Gg: ASbGncsZX8IsB+nUDi2kkb6uhtwaWev9YJ/+C8h/J4c88xUEWuIXsxxfMlE1Zzc8Rjx
	MKMi6A8J/En8tWEE7vps5vVCie6zGehkepcj+IrblX92OG7kxoXHs4NNLrt+gB97Hj/LddXA9pb
	07HrjQ2jFApGGHkXeCvoeldgwUinUDBN7mqNKemwcRU2YW4Y/s9+aecQxUtmurpDCAPgj82as9c
	petQNudZl9XpXEAP3VbAoq1NrMeaBB5Xnqu4pbCX9eWwd5k23Co8+FVEZGo04nvk1xWH4mCvsGg
	0J0AZpLKE/tg+Mk06se9I7C24cvYLoeQfwuQuL5+q/6YaK2jWDJkP26gjUKGFDXSXEPHdHZCQGU
	VeCZwHMf57eVr6aZxmOOfmD31eyHiOPR67FxGf3xdXnc/yZ8FaJ0J4exGG5k5R8jX/c7OJTmaO9
	sDurGJSaSs0IlnAwozVmbdqopipmlYYYYb914awR5sXZsE76yyXEb8lWiqg8o4IBl37Y79m6o=
X-Google-Smtp-Source: AGHT+IGfCNBMoTtXPBQuAUeW7F2FOFJHFjICPrGmqtSZGa6InEDUBtPb1IREkx7nMtIe6KVcY9ERPw==
X-Received: by 2002:a05:622a:1a9c:b0:4ed:e55b:767e with SMTP id d75a77b69052e-4f1bffc3f56mr2161201cf.15.1765410298610;
        Wed, 10 Dec 2025 15:44:58 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f1bd6b502asm5869051cf.16.2025.12.10.15.44.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Dec 2025 15:44:58 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Sarah Catania <sarah.catania@broadcom.com>,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/3] scsi_transport_fc: Introduce encryption group in fc_rport attribute
Date: Wed, 10 Dec 2025 16:16:57 -0800
Message-Id: <20251211001659.138635-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251211001659.138635-1-justintee8345@gmail.com>
References: <20251211001659.138635-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sarah Catania <sarah.catania@broadcom.com>

Introduce a new structure for reporting an encrypted session over an
fc_rport.  The encryption group is added as an attribute in struct fc_rport
and reports information in fc_encryption_info.  This structure contains a
status member variable, which stores a bit value indicating an encrypted
session.

Signed-off-by: Sarah Catania <sarah.catania@broadcom.com>
Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/base/transport_class.c   |  8 ++++++
 drivers/scsi/scsi_transport_fc.c | 42 ++++++++++++++++++++++++++++++++
 include/linux/transport_class.h  |  1 +
 include/scsi/scsi_transport_fc.h | 12 +++++++++
 4 files changed, 63 insertions(+)

diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
index 09ee2a1e35bb..69c6ac2e8263 100644
--- a/drivers/base/transport_class.c
+++ b/drivers/base/transport_class.c
@@ -169,6 +169,12 @@ static int transport_add_class_device(struct attribute_container *cont,
 			goto err_del;
 	}
 
+	if (tcont->encryption) {
+		error = sysfs_create_group(&classdev->kobj, tcont->encryption);
+		if (error)
+			goto err_del;
+	}
+
 	return 0;
 
 err_del:
@@ -244,6 +250,8 @@ static int transport_remove_classdev(struct attribute_container *cont,
 	if (tclass->remove != anon_transport_dummy_function) {
 		if (tcont->statistics)
 			sysfs_remove_group(&classdev->kobj, tcont->statistics);
+		if (tcont->encryption)
+			sysfs_remove_group(&classdev->kobj, tcont->encryption);
 		attribute_container_class_device_del(classdev);
 	}
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 987befb02408..b95c46a346fb 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1328,6 +1328,46 @@ store_fc_rport_fast_io_fail_tmo(struct device *dev,
 static FC_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
 	show_fc_rport_fast_io_fail_tmo, store_fc_rport_fast_io_fail_tmo);
 
+#define fc_rport_encryption(name)							\
+static ssize_t fc_rport_encinfo_##name(struct device *cd,				\
+				       struct device_attribute *attr,			\
+				       char *buf)					\
+{											\
+	struct fc_rport *rport = transport_class_to_rport(cd);				\
+	struct Scsi_Host *shost = rport_to_shost(rport);				\
+	struct fc_internal *i = to_fc_internal(shost->transportt);			\
+	struct fc_encryption_info *info;						\
+	ssize_t ret = -ENOENT;								\
+	u32 data;									\
+											\
+	if (i->f->get_fc_rport_enc_info) {						\
+		info = (i->f->get_fc_rport_enc_info)(rport);				\
+		if (info) {								\
+			data = info->name;						\
+			if (!strcmp(#name, "status")) {					\
+				ret = scnprintf(buf,					\
+						FC_RPORT_ENCRYPTION_STATUS_MAX_LEN,	\
+						"%s\n",					\
+						data ? "Encrypted" : "Unencrypted");	\
+			}								\
+		}									\
+	}										\
+	return ret;									\
+}											\
+static FC_DEVICE_ATTR(rport, encryption_##name, 0444, fc_rport_encinfo_##name, NULL)	\
+
+fc_rport_encryption(status);
+
+static struct attribute *fc_rport_encryption_attrs[] = {
+	&device_attr_rport_encryption_status.attr,
+	NULL
+};
+
+static struct attribute_group fc_rport_encryption_group = {
+	.name = "encryption",
+	.attrs = fc_rport_encryption_attrs,
+};
+
 #define fc_rport_fpin_statistic(name)					\
 static ssize_t fc_rport_fpinstat_##name(struct device *cd,		\
 				  struct device_attribute *attr,	\
@@ -2633,6 +2673,8 @@ fc_attach_transport(struct fc_function_template *ft)
 	i->rport_attr_cont.ac.attrs = &i->rport_attrs[0];
 	i->rport_attr_cont.ac.class = &fc_rport_class.class;
 	i->rport_attr_cont.ac.match = fc_rport_match;
+	if (ft->get_fc_rport_enc_info)
+		i->rport_attr_cont.encryption = &fc_rport_encryption_group;
 	i->rport_attr_cont.statistics = &fc_rport_statistics_group;
 	transport_container_register(&i->rport_attr_cont);
 
diff --git a/include/linux/transport_class.h b/include/linux/transport_class.h
index 2efc271a96fa..a009d66db15a 100644
--- a/include/linux/transport_class.h
+++ b/include/linux/transport_class.h
@@ -56,6 +56,7 @@ struct anon_transport_class cls = {				\
 struct transport_container {
 	struct attribute_container ac;
 	const struct attribute_group *statistics;
+	const struct attribute_group *encryption;
 };
 
 #define attribute_container_to_transport_container(x) \
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index b908aacfef48..9f30625aa0d3 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -317,6 +317,15 @@ struct fc_fpin_stats {
 	u64 cn_device_specific;
 };
 
+#define FC_RPORT_ENCRYPTION_STATUS_MAX_LEN      14
+/*
+ * Encryption Information
+ */
+struct fc_encryption_info {
+	/* Encryption Status */
+	u8 status;
+};
+
 /* Macro for use in defining Remote Port attributes */
 #define FC_RPORT_ATTR(_name,_mode,_show,_store)				\
 struct device_attribute dev_attr_rport_##_name = 	\
@@ -364,6 +373,7 @@ struct fc_rport {	/* aka fc_starget_attrs */
 	u64 port_name;
 	u32 port_id;
 	u32 roles;
+	struct fc_encryption_info enc_info;
 	enum fc_port_state port_state;	/* Will only be ONLINE or UNKNOWN */
 	u32 scsi_target_id;
 	u32 fast_io_fail_tmo;
@@ -691,6 +701,8 @@ struct fc_function_template {
 	struct fc_host_statistics * (*get_fc_host_stats)(struct Scsi_Host *);
 	void	(*reset_fc_host_stats)(struct Scsi_Host *);
 
+	struct fc_encryption_info * (*get_fc_rport_enc_info)(struct fc_rport *);
+
 	int	(*issue_fc_host_lip)(struct Scsi_Host *);
 
 	void    (*dev_loss_tmo_callbk)(struct fc_rport *);
-- 
2.38.0

