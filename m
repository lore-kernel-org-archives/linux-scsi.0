Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27035446C1E
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 06:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786082870; cv=none; b=NseUSLMzLV7puRcqpzu4ifqS2eTEzYO2bjGnULi1toPerP//ZIrZb+r1ajlP2Lu/Tc5ODP8xK6AKWII+1uPeu9NseTbVczlEVdHCzb0uzMag489dz8BYvxCmZp7fO82lY+CJkBCNaKrHuthOCwWSdGy//nd3r3ZvL0UWkqgTV0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786082870; c=relaxed/simple;
	bh=8nK3zk0LJnwP8Kr6V61I0Wwu+5q7KeBflm9aUfHvG3g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TbnD+6hh+0CLc0QfZ5I3PVcjxiH3Se3QQVhMTXRblNVRqW70UCU+nl+U7/EikEHHZr24OPcivG+5jUFxLQY6ljhqaGgeduBqjz13y5GjsbQ7Yl+2aYF+J8iKfmEtI/jHghA/AY+RXnIwy/RRzGc62/foN4WSiBKFxM4xfQdqGbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k/x95HHT; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/x95HHT"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c0cea8883so14772501cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2026 23:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786082868; x=1786687668; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HQf34kglk1Yh8CWS1BUF21oEZ3LoRTy5y/WvEz9+4IA=;
        b=k/x95HHThjboC8AVoHcl28lLtjXggobDvkBbhqJ1QMp4h9jPg/F1ajjjWrSkztfZOW
         wd68q55nVYQywtFejKuhfc1rnZxPqWd+XdTJqb2wRGv2n9gdN3YMXKXeJwal1TGLvpfV
         D6rqT8QVJ6JvFAO4iNR4BzuVezhe6rqEzajAEr1Ml6oQ1HrOgOXFV4AHlZdYcu3NAXg5
         6z2Aku2fSeCafhLvTXiDHE2olj/pPSlZpPcAq2TxfbMNPB2hzQHzfeEG2ni/4UuCeCpp
         IwbX75gV9NiktKX+4rQbi6dS+1qv7WKFLv+B8IYLiaeqf6apZ2D7Ce0D0rVu7yxUR4Jz
         sV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786082868; x=1786687668;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HQf34kglk1Yh8CWS1BUF21oEZ3LoRTy5y/WvEz9+4IA=;
        b=ogRXg5BAqryc7STeRnMJ3NaBil4JQWax1acu2Q1tcEr8Wxg2UpnDKsVG1qheD5ZWZ5
         NMWWn61px2g8Gk51vo827Z9W7YGd+PBNm7kynqwnC0ytg/jae9R+tvsw0CJ1TWLEbTM9
         3zfllDqH+UTm9T3Jxq6I0ZexBd2/TqQgS12XoYmDpXsyWHzCkMBt5rjMCiMdp1y86FsW
         fhsZMY+SeZwZUJMGYq9IYb9wQ2zrnk7SUzUTCsrAsqWNpNCjduO+t8dGM3pUUx1XvHDp
         KCgKeybOyn/IIiwnuTQj8m142c7ezgRYb862zsrw+80rv2vLABEmIKo+oSrTIOefxlmu
         wPmA==
X-Forwarded-Encrypted: i=1; AHgh+RqJws9C4icEaufx1M3CNAt8m5OyHOaO02ObcjnYroVExcPURXcuCPMrnfSLXqv0XhAcsjiR6uRqP/+d@vger.kernel.org
X-Gm-Message-State: AOJu0YzQswtWSpU6sXUarcOgVgedRbz7nSFZcpZeSBZZ57Y6t7OFxdCT
	hP13B1gCDV/iPmx//wFOz7wzO/cGDA8dylSshXyi6KNmzBD2CRiam9GO
X-Gm-Gg: AR+sD12lYR2ndQJooj2Zc78EvyQg4T8lDN7DpkcC1yfpO3P5faHUknXKVgLy+b5ApRF
	GVH0gU4uBDb0cUjdaVfOodrLwsxfxIwHELAQi32dOe63asH4lINPoDeKjsD+2hVCLVjulYdL3f+
	27+Dm56KEbVBjjP7Uo8l8oAn0Zv0lQrtjPyMkMvW/1n+3lEs1YnYa/iuSDU8TRhCNwV8xLdxupG
	pdZv0c3uauyo0stKbNArejy2JVpT31vFJRN1d8h6syEvKwh9twMjN5xPtiq/jWNHgCaI+nWGD+E
	6LJSWaF1htDYG6Dl/+m0URNdXCtWUl+/INKSmfkI1nyfYi9LCX4/lEGWXCFWnOs6vLL+BTp1V96
	yHTg6KrEZ1oW728QW7jtf7iCR7M2SX5sms8bNKlLimGl/qAynTo1pS1MTxMaTJ1+V2XM2tjN5/O
	jdPf6J/sev+hYlO0GhyatMjC3rqcowC3VDprAvikPmERHklK1wZRiWadho8uzvT2IthiQs5IpaF
	mrDDwt5ygcvhzoE7A==
X-Received: by 2002:a05:622a:4d86:b0:51c:b91a:33f9 with SMTP id d75a77b69052e-52cfb00255dmr137405711cf.13.1786082868001;
        Thu, 06 Aug 2026 23:07:48 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908a92ff8d1sm1985816d6.25.2026.08.06.23.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 23:07:47 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] usb: gadget: f_tcm: keep port count until LUN teardown completes
Date: Fri,  7 Aug 2026 02:07:33 -0400
Message-ID: <20260807060733.3186624-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tcm_usbg_drop_nexus() permits session removal once tpg_port_count
reaches zero. However, usbg_port_unlink() currently decrements that
count from the fabric_pre_unlink() callback, before core_dev_del_lun()
waits for active se_lun references to drain.

If removal of the last LUN races a nexus removal, the latter can observe
a zero port count and call target_remove_session(). This frees
sess_cmd_map while an in-flight struct usbg_cmd, including its work item,
can still be accessed.

Overlapping the last-LUN unlink with nexus removal reproduces this
lifetime violation as a DEBUG_OBJECTS "free active" warning for
usbg_cmd_work, followed by a target-core BUG/Oops.

The generic target-core unlink path has no callback after
core_dev_del_lun() completes. Add an optional fabric_post_unlink()
callback and use it for the f_tcm port count. The count now remains
nonzero until core_dev_del_lun() has finished draining active LUN
references, preventing nexus removal from freeing the session during
command completion.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
---
 drivers/target/target_core_fabric_configfs.c | 8 ++++++++
 drivers/usb/gadget/function/f_tcm.c          | 2 +-
 include/target/target_core_fabric.h          | 2 ++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 166dbf4c4061..ab8f81650710 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -690,6 +690,14 @@ static void target_fabric_port_unlink(
 	}
 
 	core_dev_del_lun(se_tpg, lun);
+
+	if (tf->tf_ops->fabric_post_unlink) {
+		/*
+		 * Allow fabrics to release state that must remain valid until
+		 * core_dev_del_lun() has drained all active LUN references.
+		 */
+		tf->tf_ops->fabric_post_unlink(se_tpg, lun);
+	}
 }
 
 static void target_fabric_port_release(struct config_item *item)
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index b3fa5a17fd2d..98414e7611c0 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -2024,7 +2024,7 @@ static const struct target_core_fabric_ops usbg_ops = {
 	.fabric_enable_tpg		= usbg_enable_tpg,
 	.fabric_drop_tpg		= usbg_drop_tpg,
 	.fabric_post_link		= usbg_port_link,
-	.fabric_pre_unlink		= usbg_port_unlink,
+	.fabric_post_unlink		= usbg_port_unlink,
 	.fabric_init_nodeacl		= usbg_init_nodeacl,
 
 	.tfc_wwn_attrs			= usbg_wwn_attrs,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index e9039e73d058..390ace5bb252 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -95,6 +95,8 @@ struct target_core_fabric_ops {
 				struct se_lun *);
 	void (*fabric_pre_unlink)(struct se_portal_group *,
 				struct se_lun *);
+	void (*fabric_post_unlink)(struct se_portal_group *se_tpg,
+				   struct se_lun *lun);
 	struct se_tpg_np *(*fabric_make_np)(struct se_portal_group *,
 				struct config_group *, const char *);
 	void (*fabric_drop_np)(struct se_tpg_np *);
-- 
2.43.0

