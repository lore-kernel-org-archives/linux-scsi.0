Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4800C1865
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660522; cv=none; b=RszfT5EndkMRNfJ//ExFyOIZbWJQy4pEHtaHbNnRyW6jIvPnxhapUH2JkJSPKSE/Tj56bSRozJCL9BOTfgh749ALDtdRJnIfEkW0eCSsEDywPCTrGQbGg6NlJ3kEwk2FT+g1mIl5E2qF41jchqlZq99Du42assk0pc6cremaq/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660522; c=relaxed/simple;
	bh=fENfE+2taATpG8zMPnRHK+IPAjw94up1gMclrRMAQl8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N5CO1oXD0wUwyE7nSdqpgHrj6Xvtim9fBj2EUji6RfLx1pqHvhLu+/jgamJsvw9K7vdkU1N47v1pkqA4Qb74MSoed3d5Z0B0nW0imy8dW2hyFXMt8r1LBSWqRvsUj6nzT0kHs+Z9ss0Zs0t3Diz5XlRf3gTUGB5BMK9waeFK9U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QnWPq17j; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QnWPq17j"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-68155fca099so3304956d6.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660520; x=1707265320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibjgYaa6wb/dw+dNOSbYOZCQG8CUbfsWp5AK3uimKgg=;
        b=QnWPq17jDHruCbEEVivnT/18b4H8nEZa5bPLarWPACeu5LvkrrwVhYlFOIE9m3wFlt
         JXB8ZyOiPORHwXo7G19pvFafKUfD2PgVlHicIyw0jwQ4VXiPbUPQ0hh/u/KY3/gjyW8x
         vdrwb4r0e5I3kXK0NHxLqWSxqXhfEm6Yelc5ngBDEhPSHpZflwHJE8/0bE8iJ6ZKtUS6
         3KVjq81twhFDIX/If+7sTeAGBXe2n8NxBseCRkyD7VZ4mznUEzAQnO8rPMc2dXw5pwTb
         b2Lmg9TEyh/g/CFVQ0U69YeibbOflUrz8IxTUqNj34uAAOvhQrkdbmb18obS09pv93NC
         gq7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660520; x=1707265320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ibjgYaa6wb/dw+dNOSbYOZCQG8CUbfsWp5AK3uimKgg=;
        b=QK9ofSHCA3NG1KEdgEKSJQbeMAB76UEq0PWTqZAlrglP3OPvfiFT7l7VubsLqRrkQe
         HsfM2SmGmK4y+XStzIyvN+Xw1Ac+U14ikON6ltZ1oqR5esXBkm9PahXUq4HGErv1p1km
         r9XOUIjKhmYpkXLfkVrLJkqkECPHwHquWs5+PgehFQpMIxhOVrxKB4CdOzrUL9mXVMei
         maz29wVC+6Ju+jkdP2i0HFKPF+dIQFCYsXS0+sCoq5d60Jn4ruplBgXegaQaGdKs8H8J
         yhjOGtQpBEY3ZR0Q+/yRV+6yhHZ1K4B/+VGlPhGcZ7yv6OVg3iXjYZbc5treir419FnM
         XqNA==
X-Gm-Message-State: AOJu0Yz1zrYyxZC/h9I0A4tgeFF32Myzx+PegUKO6eafaE6BnUD1rhue
	BFt4xpSWPUkVcAv5BRiQUpOAfN2w/L1/DMucDC4sL4BX0GNBuNf8qb2D0c5+
X-Google-Smtp-Source: AGHT+IEI/m343O5gedP4VEqsH6pExT2wCUXoQ0tSJ5ebhUjVNM+aXz1cIlinDK0bEgjsmmBxPVW6NA==
X-Received: by 2002:a05:6214:226c:b0:68c:4db6:3423 with SMTP id gs12-20020a056214226c00b0068c4db63423mr164989qvb.3.1706660519884;
        Tue, 30 Jan 2024 16:21:59 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.21.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:21:59 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 11/17] lpfc: Remove shost_lock protection for fc_host_port shost APIs
Date: Tue, 30 Jan 2024 16:35:43 -0800
Message-Id: <20240131003549.147784-12-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131003549.147784-1-justintee8345@gmail.com>
References: <20240131003549.147784-1-justintee8345@gmail.com>
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

