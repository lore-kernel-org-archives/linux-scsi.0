From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.15-rc6
Date: Sat, 24 May 2014 17:51:13 +0400
Message-ID: <1400939473.6956.40.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48193 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751262AbaEXNvU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 May 2014 09:51:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a single fix for a bug exposed by a sysfs change in 3.13 which
now causes libsas to trigger a warn on in device removal.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Joe Lawrence (1):
      scsi_transport_sas: move bsg destructor into sas_rphy_remove

And the diffstat:

 drivers/scsi/scsi_transport_sas.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 1b68142..c341f85 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1621,8 +1621,6 @@ void sas_rphy_free(struct sas_rphy *rphy)
 	list_del(&rphy->list);
 	mutex_unlock(&sas_host->lock);
 
-	sas_bsg_remove(shost, rphy);
-
 	transport_destroy_device(dev);
 
 	put_device(dev);
@@ -1681,6 +1679,7 @@ sas_rphy_remove(struct sas_rphy *rphy)
 	}
 
 	sas_rphy_unlink(rphy);
+	sas_bsg_remove(NULL, rphy);
 	transport_remove_device(dev);
 	device_del(dev);
 }


