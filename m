From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v6 04/13] firmware_loader: document firmware_sysfs_fallback()
Date: Tue,  8 May 2018 11:12:38 -0700
Message-ID: <20180508181247.19431-5-mcgrof@kernel.org>
References: <20180508181247.19431-1-mcgrof@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508181247.19431-1-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, keescook@chromium.org, josh@joshtriplett.org, maco@android.com, andy.gross@linaro.org, david.brown@linaro.org, bjorn.andersson@linaro.org, teg@jklm.no, wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com, zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org, torvalds@linux-foundation.org, Abhay_Salunke@dell.com, jewalt@lgsinnovations.com, oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khc@pm.waw.pl, davem@davemloft.
List-Id: linux-scsi@vger.kernel.org

This also sets the expecations for future fallback interfaces, even
if they are not exported.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_loader/fallback.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index 3db9e0f225ac..9169e7b9800c 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -662,6 +662,26 @@ static bool fw_run_sysfs_fallback(enum fw_opt opt_flags)
 	return fw_force_sysfs_fallback(opt_flags);
 }
 
+/**
+ * firmware_fallback_sysfs() - use the fallback mechanism to find firmware
+ * @fw: pointer to firmware image
+ * @name: name of firmware file to look for
+ * @device: device for which firmware is being loaded
+ * @opt_flags: options to control firmware loading behaviour
+ * @ret: return value from direct lookup which triggered the fallback mechanism
+ *
+ * This function is called if direct lookup for the firmware failed, it enables
+ * a fallback mechanism through userspace by exposing a sysfs loading
+ * interface. Userspace is in charge of loading the firmware through the syfs
+ * loading interface. This syfs fallback mechanism may be disabled completely
+ * on a system by setting the proc sysctl value ignore_sysfs_fallback to true.
+ * If this false we check if the internal API caller set the @FW_OPT_NOFALLBACK
+ * flag, if so it would also disable the fallback mechanism. A system may want
+ * to enfoce the sysfs fallback mechanism at all times, it can do this by
+ * setting ignore_sysfs_fallback to false and force_sysfs_fallback to true.
+ * Enabling force_sysfs_fallback is functionally equivalent to build a kernel
+ * with CONFIG_FW_LOADER_USER_HELPER_FALLBACK.
+ **/
 int firmware_fallback_sysfs(struct firmware *fw, const char *name,
 			    struct device *device,
 			    enum fw_opt opt_flags,
-- 
2.17.0
