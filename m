From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] fusion: mptsas, fix lock imbalance
Date: Mon, 22 Jun 2009 10:52:05 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C141A2C1DF0@inbmail01.lsi.com>
References: <1245621541-27008-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754046AbZFVFWV@vger.kernel.org>
In-Reply-To: <1245621541-27008-1-git-send-email-jirislaby@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jirislaby@gmail.com>, "Moore, Eric" <Eric.Moore@lsi.com>
Cc: DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Support, Software" <support@lsi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jiri,

Consider this as ACKED patch.

- Kashyap Desai

-----Original Message-----
From: Jiri Slaby [mailto:jirislaby@gmail.com] 
Sent: Monday, June 22, 2009 3:29 AM
To: Moore, Eric
Cc: DL-MPT Fusion Linux; linux-scsi@vger.kernel.org; Support, Software; linux-kernel@vger.kernel.org; Jiri Slaby
Subject: [PATCH] fusion: mptsas, fix lock imbalance

Fix two typos in mptsas_not_responding_devices. It was mutex_lock instead
of unlock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/message/fusion/mptsas.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 20e0b44..55ff252 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3518,7 +3518,7 @@ retry_page:
 		} else
 			mptsas_volume_delete(ioc, sas_info->fw.id);
 	}
-	mutex_lock(&ioc->sas_device_info_mutex);
+	mutex_unlock(&ioc->sas_device_info_mutex);
 
 	/* expanders */
 	mutex_lock(&ioc->sas_topology_mutex);
@@ -3549,7 +3549,7 @@ retry_page:
 			goto redo_expander_scan;
 		}
 	}
-	mutex_lock(&ioc->sas_topology_mutex);
+	mutex_unlock(&ioc->sas_topology_mutex);
 }
 
 /**
-- 
1.6.3.2
