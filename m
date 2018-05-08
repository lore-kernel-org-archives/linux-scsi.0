From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v6 03/13] firmware: rename fw_sysfs_fallback to firmware_fallback_sysfs()
Date: Tue,  8 May 2018 11:12:37 -0700
Message-ID: <20180508181247.19431-4-mcgrof@kernel.org>
References: <20180508181247.19431-1-mcgrof@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508181247.19431-1-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, keescook@chromium.org, josh@joshtriplett.org, maco@android.com, andy.gross@linaro.org, david.brown@linaro.org, bjorn.andersson@linaro.org, teg@jklm.no, wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com, zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org, torvalds@linux-foundation.org, Abhay_Salunke@dell.com, jewalt@lgsinnovations.com, oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khc@pm.waw.pl, davem@davemloft.
List-Id: linux-scsi@vger.kernel.org

From: Andres Rodriguez <andresx7@gmail.com>

This is done since this call is now exposed through kernel-doc,
and since this also paves the way for different future types of
fallback mechanims.

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
Acked-by: Luis R. Rodriguez <mcgrof@kernel.org>
[mcgrof: small coding style changes]
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_loader/fallback.c |  8 ++++----
 drivers/base/firmware_loader/fallback.h | 16 ++++++++--------
 drivers/base/firmware_loader/firmware.h |  2 +-
 drivers/base/firmware_loader/main.c     |  2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index 529f7013616f..3db9e0f225ac 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -662,10 +662,10 @@ static bool fw_run_sysfs_fallback(enum fw_opt opt_flags)
 	return fw_force_sysfs_fallback(opt_flags);
 }
 
-int fw_sysfs_fallback(struct firmware *fw, const char *name,
-		      struct device *device,
-		      enum fw_opt opt_flags,
-		      int ret)
+int firmware_fallback_sysfs(struct firmware *fw, const char *name,
+			    struct device *device,
+			    enum fw_opt opt_flags,
+			    int ret)
 {
 	if (!fw_run_sysfs_fallback(opt_flags))
 		return ret;
diff --git a/drivers/base/firmware_loader/fallback.h b/drivers/base/firmware_loader/fallback.h
index a3b73a09db6c..21063503e4ea 100644
--- a/drivers/base/firmware_loader/fallback.h
+++ b/drivers/base/firmware_loader/fallback.h
@@ -31,10 +31,10 @@ struct firmware_fallback_config {
 };
 
 #ifdef CONFIG_FW_LOADER_USER_HELPER
-int fw_sysfs_fallback(struct firmware *fw, const char *name,
-		      struct device *device,
-		      enum fw_opt opt_flags,
-		      int ret);
+int firmware_fallback_sysfs(struct firmware *fw, const char *name,
+			    struct device *device,
+			    enum fw_opt opt_flags,
+			    int ret);
 void kill_pending_fw_fallback_reqs(bool only_kill_custom);
 
 void fw_fallback_set_cache_timeout(void);
@@ -43,10 +43,10 @@ void fw_fallback_set_default_timeout(void);
 int register_sysfs_loader(void);
 void unregister_sysfs_loader(void);
 #else /* CONFIG_FW_LOADER_USER_HELPER */
-static inline int fw_sysfs_fallback(struct firmware *fw, const char *name,
-				    struct device *device,
-				    enum fw_opt opt_flags,
-				    int ret)
+static inline int firmware_fallback_sysfs(struct firmware *fw, const char *name,
+					  struct device *device,
+					  enum fw_opt opt_flags,
+					  int ret)
 {
 	/* Keep carrying over the same error */
 	return ret;
diff --git a/drivers/base/firmware_loader/firmware.h b/drivers/base/firmware_loader/firmware.h
index 4f433b447367..4c1395f8e7ed 100644
--- a/drivers/base/firmware_loader/firmware.h
+++ b/drivers/base/firmware_loader/firmware.h
@@ -20,7 +20,7 @@
  * @FW_OPT_NOWAIT: Used to describe the firmware request is asynchronous.
  * @FW_OPT_USERHELPER: Enable the fallback mechanism, in case the direct
  *	filesystem lookup fails at finding the firmware.  For details refer to
- *	fw_sysfs_fallback().
+ *	firmware_fallback_sysfs().
  * @FW_OPT_NO_WARN: Quiet, avoid printing warning messages.
  * @FW_OPT_NOCACHE: Disables firmware caching. Firmware caching is used to
  *	cache the firmware upon suspend, so that upon resume races against the
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index 4d11efadb3a4..abdc4e4d55f1 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -581,7 +581,7 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 			dev_warn(device,
 				 "Direct firmware load for %s failed with error %d\n",
 				 name, ret);
-		ret = fw_sysfs_fallback(fw, name, device, opt_flags, ret);
+		ret = firmware_fallback_sysfs(fw, name, device, opt_flags, ret);
 	} else
 		ret = assign_fw(fw, device, opt_flags);
 
-- 
2.17.0
