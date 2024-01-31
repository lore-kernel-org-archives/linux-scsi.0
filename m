Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B8818AFB
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726257; cv=none; b=dxlYLXEYzEgJzkG6fFLZZpBtRwtBvLw7uZ3iuL9FKxUQzedNpe7I5XfHHjHZly1er/myvhjDjyoBUdQauslFla4UBRlZWdMgx6PExA6euyjMPWZHgZ97uxnd0rIlaqri0Ca9DQeJhzkgpd7qoteKjvKe0lS8W0vObIheEWTmZJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726257; c=relaxed/simple;
	bh=fENfE+2taATpG8zMPnRHK+IPAjw94up1gMclrRMAQl8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vBXoNH0MUcRS6OXgoLKOLf1iq6IPglphtpmB6zCAbOG++iGfh5xE3nONYX3gFHFvah9+FLO2E36/oCn3vqrMO3f21M21I5KW1cf/fyJSkPaC6R3iH2t2br3mAAcxMJzPx62M+/TB47Cs8YPRiKb/ptk87WeSBbKkV3/d5nK/WQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UHrTC/lt; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UHrTC/lt"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-68155fca099so205896d6.1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726255; x=1707331055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibjgYaa6wb/dw+dNOSbYOZCQG8CUbfsWp5AK3uimKgg=;
        b=UHrTC/ltP6TDxWq5WDAwt7FtJ5PUrugzfVFxFfyxHLlNsOec1M36kRwL4Q8Ar2jc8g
         /TUvjo0/uRSA3XLfzFYjjI+0RowrwHnxIM2W1606Aa2/FqAoqYSbApm5bnpcwMRJWGd3
         yGDYoF0jiOj+z4tyI1FVfUeZ5xp1tFz4LC5lB3d5mHqGoEenByNHxdzWincA97XKUQou
         lqwTgeuENvQwUGH1D3TlkHFZ0bPAHzw5CMNNhJwUxwqqykgTCze0ECWBEqY2BJ3lSXcm
         kloy6859QpUbykfrNWpRLJmc9hI7C/jmTfDo7ezMisA9tNGo+MZPhP7r0rbU1Tb/gPCP
         OZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726255; x=1707331055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ibjgYaa6wb/dw+dNOSbYOZCQG8CUbfsWp5AK3uimKgg=;
        b=wtozGifacDQBC2TgkDCEDWrnS3plNGFQHxeyK7JtpghA9HG7JBYrGTK8K6ZjCRHXZD
         3tlldRvzV1YsRLjTBwNzZvpQEAUYFMRUvrsBPjMgwPQtwmRhlWMTe94UkiMtY+0VnJxb
         IPhwfXZJZd4hF5WUGWFcK+wqZIVDQFzPOYBMR8pLk1TVHme5jTwrGpo7zG1sEiZzlfaS
         V83GeY+JVJ7kEnJ8TaEPMJE7Vejn31hQTjq/4AErW034WcfRztPsXlstBrcf1qezOkWH
         MmLvxITskEaSv1cG/l38nkdQStmWw4k+Mh12Pq3Byqc35IB2ZGKSkdX0mV5pmtxA+6Tl
         x3TQ==
X-Gm-Message-State: AOJu0YwTvr8QNVFXLtr6A9d1lc8JyhkooD1AUXqNW7Uhvugv3IwQcTfx
	T87Y2PEEbHaZnvuWQKoPtmCUUvl0UdJol3Vl+FMjpoC2TxqCDzRloBL3KHsn
X-Google-Smtp-Source: AGHT+IGN6O0K6V99vAWLuLbZlDH9BETw6rXallwtVQPZOxFYmK6gNDNM1xqXfM8NiZcryBUfw/epbg==
X-Received: by 2002:ad4:45b2:0:b0:686:9e90:96c0 with SMTP id y18-20020ad445b2000000b006869e9096c0mr193730qvu.4.1706726254968;
        Wed, 31 Jan 2024 10:37:34 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:34 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 11/17] lpfc: Remove shost_lock protection for fc_host_port shost APIs
Date: Wed, 31 Jan 2024 10:51:06 -0800
Message-Id: <20240131185112.149731-12-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Desiring to reduce the amount of unnecessary shost_lock acquisitions in the
lpfc driver, it has been determined that there is no need for shost_lock
protection when retrieving fc_host port information because it is only for
display to user via sysfs.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index d3a5d6ecdf7d..1f9a529e09ff 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -6429,8 +6429,6 @@ lpfc_get_host_port_type(struct Scsi_Host *shost)
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	spin_lock_irq(shost->host_lock);
-
 	if (vport->port_type == LPFC_NPIV_PORT) {
 		fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
 	} else if (lpfc_is_link_up(phba)) {
@@ -6447,8 +6445,6 @@ lpfc_get_host_port_type(struct Scsi_Host *shost)
 		}
 	} else
 		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
-
-	spin_unlock_irq(shost->host_lock);
 }
 
 /**
@@ -6461,8 +6457,6 @@ lpfc_get_host_port_state(struct Scsi_Host *shost)
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	spin_lock_irq(shost->host_lock);
-
 	if (vport->fc_flag & FC_OFFLINE_MODE)
 		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
 	else {
@@ -6490,8 +6484,6 @@ lpfc_get_host_port_state(struct Scsi_Host *shost)
 			break;
 		}
 	}
-
-	spin_unlock_irq(shost->host_lock);
 }
 
 /**
@@ -6504,8 +6496,6 @@ lpfc_get_host_speed(struct Scsi_Host *shost)
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	spin_lock_irq(shost->host_lock);
-
 	if ((lpfc_is_link_up(phba)) && (!(phba->hba_flag & HBA_FCOE_MODE))) {
 		switch(phba->fc_linkspeed) {
 		case LPFC_LINK_SPEED_1GHZ:
@@ -6568,8 +6558,6 @@ lpfc_get_host_speed(struct Scsi_Host *shost)
 		}
 	} else
 		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
-
-	spin_unlock_irq(shost->host_lock);
 }
 
 /**
@@ -6583,8 +6571,6 @@ lpfc_get_host_fabric_name (struct Scsi_Host *shost)
 	struct lpfc_hba   *phba = vport->phba;
 	u64 node_name;
 
-	spin_lock_irq(shost->host_lock);
-
 	if ((vport->port_state > LPFC_FLOGI) &&
 	    ((vport->fc_flag & FC_FABRIC) ||
 	     ((phba->fc_topology == LPFC_TOPOLOGY_LOOP) &&
@@ -6594,8 +6580,6 @@ lpfc_get_host_fabric_name (struct Scsi_Host *shost)
 		/* fabric is local port if there is no F/FL_Port */
 		node_name = 0;
 
-	spin_unlock_irq(shost->host_lock);
-
 	fc_host_fabric_name(shost) = node_name;
 }
 
-- 
2.38.0

