Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B92D3A1E8A;
	Sat, 20 Dec 2025 03:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766202347; cv=none; b=M7AO07KE24D1AZhdv8VsCE0zhU6vtkautxd85f2nG6huwVzIR1XimJlRuEujdKeFj/PXML9HOQWYqknqJzsqUY4tLSwK6Jg+paGgBynQo3RxORNE2lFfohQ7PNBTwiLvdO/yXHl6JhwmikS9xGyA26bORHVUXQa/KpSfiG/pvLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766202347; c=relaxed/simple;
	bh=ljS74JXhPZ1LeDdwxkTAIFvssMwAF5gNuyDs6g2Lvkg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=MzQftxZxbG5htjh2AhLmkxPl6CR3gsw5/5q1GOyGlm9ywdiJbReEvz9a4+ywFUUsGbZeVAdikynSgAKQ6OkpsbpUGgZcS2q/VAYIw6KKWNlxWIsuPzkRdHri9X0gXe3ckIsyR/IvFN+HAreB9kWi7G18VoMAVHQNHG7DOWIl7os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FGvGo+PD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FGvGo+PD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185FAC4CEF5;
	Sat, 20 Dec 2025 03:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766202345;
	bh=ljS74JXhPZ1LeDdwxkTAIFvssMwAF5gNuyDs6g2Lvkg=;
	h=From:Date:Subject:To:Cc:From;
	b=FGvGo+PD/nNfCOaX8txlV3nLiWO1kQMANyyOZarWkPgzRN1ZzoisIvtHP9im0H0XN
	 WtM+ZGQiI9o1/OTImi8KpD3I6Qnlnh7rnlxrvZufcFIzsArBLs25KS2Q6Ntld+Fp1J
	 7M/nt2ZI47QHkQp2FAonYjhlgqJShWFYG4jIAPNlx2V9Ao8RvfVtL5dqlwlud0ELiL
	 8m7v8YnvCH0aI7vW9rnsd8H9I6zBLle2piEl14Wnkh8q/XcNEgDPLMbYRoaUkBfBdF
	 APvnoC+uSsLlmw4pl9G4gAzjTiBQ1H+MC/4lRjYfINbjlOjeSu/B8vwUA1FN4bcQZL
	 CAjLYy8bev6dQ==
From: Daniel Gomez <da.gomez@kernel.org>
Date: Sat, 20 Dec 2025 04:45:34 +0100
Subject: [PATCH] driver core: attribute_container: change return type to
 void
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251220-dev-attribute-container-linux-scsi-v1-1-d58fcd03bf21@samsung.com>
X-B4-Tracking: v=1; b=H4sIAN0bRmkC/x3NQQqDMBBG4avIrDtgUgLSq5QuYvxtB8pYZqII4
 t0NXX6b9w5ymMDp0R1k2MRl0YZw66h8sr7BMjVT7GMKMQw8YeNcq8m4VnBZtGZRGH9F1529uDD
 mMKTc3xPGTC30M8yy/yfP13letsSkTnQAAAA=
X-Change-ID: 20251218-dev-attribute-container-linux-scsi-ef185a035eba
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
 Aaron Tomlin <atomlin@atomlin.com>, Lucas De Marchi <demarchi@kernel.org>, 
 linux-scsi@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daniel Gomez <da.gomez@samsung.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5359; i=da.gomez@samsung.com;
 h=from:subject:message-id; bh=C9R4j2gXxzAQ0FMyEnLzcTXh2qpavqW/CQxI9RtuaTA=;
 b=owEBbQKS/ZANAwAIAUCeo8QfGVH7AcsmYgBpRhvl/TipJts2/zduU3dlzQGOSL7wBvzxHK1Bo
 QtvAGVCBuCJAjMEAAEIAB0WIQTvdRrhHw9z4bnGPFNAnqPEHxlR+wUCaUYb5QAKCRBAnqPEHxlR
 +/fnEACQijbOWjMz4xwTfKB5VFrS+jiCrreEcqLKJOEUcR7NyyDtTWLABQyl/Xab2/0jJRsfvQN
 MsEfjsLdtVU9t5p5u3qfyAPC62OjYZezDbFnfBj3zTcVT1SuWR3B448V76s6E/Rx5aoClyHL2gd
 odzOXp1io4dRnbNtrLWQgV4kUpkIirk9KCQ5gtS8NEnlompR52FJCv31pB7jiU1myeLW7k8bNJz
 HQrPPceOvhhMVJssyx4kB/s1YvUitNHkstSDwAYW9n1aAjlgrOctksAqCVAFGuPcf1gkW+DOzDZ
 i9mHTmtY/aqlQQkqfmQrhLJJPCdQRuQ68SbUR1wdqsizpalCsaZoPePkpQ91s3fAKr7U0GYE+1z
 RWp/9TPiDFfskDq1wLJBBXyVcIIDawc5w18GeWetjzDzjVLc7RSUX3y56cxmpmbEvmujgBRGawo
 buHKIMf/pkRI6pCSOqoHrrvM9jxOwO7Pv7vCiG4ee3QcenNhAhS2h3i4CHL4ZgZxUrmiPl1uCes
 OND+/F1JRqaPSe5y7ru02gmgiqZMOmD5+rGbUvWd+Jq89R9vy0iwxXVeVGljg1vDvSjyjoVbqdB
 5zR5/WCkw7aprnQcscQrRoOgNpcdBT3UZHVvSBPfcdz6NyZSZfEshZPKxrub1GQmtAczob2IwWp
 Aoj+YA/DGuFx2Bg==
X-Developer-Key: i=da.gomez@samsung.com; a=openpgp;
 fpr=B2A7A9CFDD03B540FF58B27185F56EA4E9E8138F

From: Daniel Gomez <da.gomez@samsung.com>

attribute_container_register() has always returned 0 since its
introduction in commit 06ff5a987e ("Add attribute container to generic
device model") in the historical Linux tree [1]. Convert the return type
to void and update all callers.

This removes dead code where callers checked for errors that could never
occur.

Link: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git [1]

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
Cleanup. Found while reviewing module_init() return values for the
-EEXIST issue [1] on the scsi spi transport module.

Link: https://lore.kernel.org/linux-modules/20251220-dev-module-init-eexists-linux-scsi-v1-0-5379db749d54@samsung.com/T/#t [1]
---
 drivers/base/attribute_container.c  | 4 +---
 drivers/base/transport_class.c      | 8 ++------
 drivers/scsi/scsi_transport_spi.c   | 2 +-
 include/linux/attribute_container.h | 2 +-
 include/linux/transport_class.h     | 6 +++---
 5 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index b6f941a6ab69..72adbacc6554 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -69,7 +69,7 @@ static DEFINE_MUTEX(attribute_container_mutex);
  * @cont: The container to register.  This must be allocated by the
  *        callee and should also be zeroed by it.
  */
-int
+void
 attribute_container_register(struct attribute_container *cont)
 {
 	INIT_LIST_HEAD(&cont->node);
@@ -79,8 +79,6 @@ attribute_container_register(struct attribute_container *cont)
 	mutex_lock(&attribute_container_mutex);
 	list_add_tail(&cont->node, &attribute_container_list);
 	mutex_unlock(&attribute_container_mutex);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(attribute_container_register);
 
diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
index 09ee2a1e35bb..4b1e8820e764 100644
--- a/drivers/base/transport_class.c
+++ b/drivers/base/transport_class.c
@@ -88,17 +88,13 @@ static int anon_transport_dummy_function(struct transport_container *tc,
  * events.  Use prezero and then use DECLARE_ANON_TRANSPORT_CLASS() to
  * initialise the anon transport class storage.
  */
-int anon_transport_class_register(struct anon_transport_class *atc)
+void anon_transport_class_register(struct anon_transport_class *atc)
 {
-	int error;
 	atc->container.class = &atc->tclass.class;
 	attribute_container_set_no_classdevs(&atc->container);
-	error = attribute_container_register(&atc->container);
-	if (error)
-		return error;
+	attribute_container_register(&atc->container);
 	atc->tclass.setup = anon_transport_dummy_function;
 	atc->tclass.remove = anon_transport_dummy_function;
-	return 0;
 }
 EXPORT_SYMBOL_GPL(anon_transport_class_register);
 
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index fe47850a8258..17a4a0918fc4 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1622,7 +1622,7 @@ static __init int spi_transport_init(void)
 	error = transport_class_register(&spi_transport_class);
 	if (error)
 		return error;
-	error = anon_transport_class_register(&spi_device_class);
+	anon_transport_class_register(&spi_device_class);
 	return transport_class_register(&spi_host_class);
 }
 
diff --git a/include/linux/attribute_container.h b/include/linux/attribute_container.h
index b3643de9931d..fa6520e192be 100644
--- a/include/linux/attribute_container.h
+++ b/include/linux/attribute_container.h
@@ -36,7 +36,7 @@ attribute_container_set_no_classdevs(struct attribute_container *atc)
 	atc->flags |= ATTRIBUTE_CONTAINER_NO_CLASSDEVS;
 }
 
-int attribute_container_register(struct attribute_container *cont);
+void attribute_container_register(struct attribute_container *cont);
 int __must_check attribute_container_unregister(struct attribute_container *cont);
 void attribute_container_create_device(struct device *dev,
 				       int (*fn)(struct attribute_container *,
diff --git a/include/linux/transport_class.h b/include/linux/transport_class.h
index 2efc271a96fa..9c2e03104461 100644
--- a/include/linux/transport_class.h
+++ b/include/linux/transport_class.h
@@ -87,9 +87,9 @@ transport_unregister_device(struct device *dev)
 	transport_destroy_device(dev);
 }
 
-static inline int transport_container_register(struct transport_container *tc)
+static inline void transport_container_register(struct transport_container *tc)
 {
-	return attribute_container_register(&tc->ac);
+	attribute_container_register(&tc->ac);
 }
 
 static inline void transport_container_unregister(struct transport_container *tc)
@@ -99,7 +99,7 @@ static inline void transport_container_unregister(struct transport_container *tc
 }
 
 int transport_class_register(struct transport_class *);
-int anon_transport_class_register(struct anon_transport_class *);
+void anon_transport_class_register(struct anon_transport_class *);
 void transport_class_unregister(struct transport_class *);
 void anon_transport_class_unregister(struct anon_transport_class *);
 

---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20251218-dev-attribute-container-linux-scsi-ef185a035eba

Best regards,
--  
Daniel Gomez <da.gomez@samsung.com>

