From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 7/8] Fix refcounting for attribute_container
Date: Tue, 18 Mar 2008 14:32:28 +0100
Message-ID: <20080318133228.7B58F159166@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:51373 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbYCRNcb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2008 09:32:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


attribute_container_add_device() takes an explicit reference on the
parent device, making it impossible to remove the parent by doing
a simple put_device(). So we'd rather _not_ take a reference here as
attribute_container will be handled explicitly by calls to
attribute_container_remove_device()/_destroy_device() anyway.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/base/attribute_container.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index f57652d..6c7e633 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -114,10 +114,8 @@ static void attribute_container_release(struct device *classdev)
 {
 	struct internal_container *ic 
 		= container_of(classdev, struct internal_container, classdev);
-	struct device *dev = classdev->parent;
 
 	kfree(ic);
-	put_device(dev);
 }
 
 /**
@@ -164,7 +162,11 @@ attribute_container_add_device(struct device *dev,
 
 		ic->cont = cont;
 		device_initialize(&ic->classdev);
-		ic->classdev.parent = get_device(dev);
+		/*
+		 * Don't increase refcount here, device will be
+		 * removed explicitly by a call to _destroy().
+		 */
+		ic->classdev.parent = dev;
 		ic->classdev.class = cont->class;
 		cont->class->dev_release = attribute_container_release;
 		strcpy(ic->classdev.bus_id, dev->bus_id);
-- 
1.5.2.4

