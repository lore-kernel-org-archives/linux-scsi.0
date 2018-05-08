From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v6 08/13] firmware: add firmware_request_nowarn() - load firmware without warnings
Date: Tue,  8 May 2018 11:12:42 -0700
Message-ID: <20180508181247.19431-9-mcgrof@kernel.org>
References: <20180508181247.19431-1-mcgrof@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508181247.19431-1-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, keescook@chromium.org, josh@joshtriplett.org, maco@android.com, andy.gross@linaro.org, david.brown@linaro.org, bjorn.andersson@linaro.org, teg@jklm.no, wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com, zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org, torvalds@linux-foundation.org, Abhay_Salunke@dell.com, jewalt@lgsinnovations.com, oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khc@pm.waw.pl, davem@davemloft.
List-Id: linux-scsi@vger.kernel.org

From: Andres Rodriguez <andresx7@gmail.com>

Currently the firmware loader only exposes one silent path for querying
optional firmware, and that is firmware_request_direct(). This function
also disables the sysfs fallback mechanism, which might not always be the
desired behaviour [0].

This patch introduces a variations of request_firmware() that enable the
caller to disable the undesired warning messages but enables the sysfs
fallback mechanism. This is equivalent to adding FW_OPT_NO_WARN to the
old behaviour.

[0]: https://git.kernel.org/linus/c0cc00f250e1

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
Acked-by: Luis R. Rodriguez <mcgrof@kernel.org>
[mcgrof: used the old API calls as the full rename is not done yet, and
 add the caller for when FW_LOADER is disabled, enhance documentation ]
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 .../driver-api/firmware/request_firmware.rst  |  5 ++++
 drivers/base/firmware_loader/main.c           | 27 +++++++++++++++++++
 include/linux/firmware.h                      | 10 +++++++
 3 files changed, 42 insertions(+)

diff --git a/Documentation/driver-api/firmware/request_firmware.rst b/Documentation/driver-api/firmware/request_firmware.rst
index d5ec95a7195b..f62bdcbfed5b 100644
--- a/Documentation/driver-api/firmware/request_firmware.rst
+++ b/Documentation/driver-api/firmware/request_firmware.rst
@@ -20,6 +20,11 @@ request_firmware
 .. kernel-doc:: drivers/base/firmware_loader/main.c
    :functions: request_firmware
 
+firmware_request_nowarn
+-----------------------
+.. kernel-doc:: drivers/base/firmware_loader/main.c
+   :functions: firmware_request_nowarn
+
 request_firmware_direct
 -----------------------
 .. kernel-doc:: drivers/base/firmware_loader/main.c
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index abdc4e4d55f1..2be79ee773c0 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -631,6 +631,33 @@ request_firmware(const struct firmware **firmware_p, const char *name,
 }
 EXPORT_SYMBOL(request_firmware);
 
+/**
+ * firmware_request_nowarn() - request for an optional fw module
+ * @firmware: pointer to firmware image
+ * @name: name of firmware file
+ * @device: device for which firmware is being loaded
+ *
+ * This function is similar in behaviour to request_firmware(), except
+ * it doesn't produce warning messages when the file is not found.
+ * The sysfs fallback mechanism is enabled if direct filesystem lookup fails,
+ * however, however failures to find the firmware file with it are still
+ * supressed. It is therefore up to the driver to check for the return value
+ * of this call and to decide when to inform the users of errors.
+ **/
+int firmware_request_nowarn(const struct firmware **firmware, const char *name,
+			    struct device *device)
+{
+	int ret;
+
+	/* Need to pin this module until return */
+	__module_get(THIS_MODULE);
+	ret = _request_firmware(firmware, name, device, NULL, 0,
+				FW_OPT_UEVENT | FW_OPT_NO_WARN);
+	module_put(THIS_MODULE);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(firmware_request_nowarn);
+
 /**
  * request_firmware_direct() - load firmware directly without usermode helper
  * @firmware_p: pointer to firmware image
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 41050417cafb..2dd566c91d44 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -42,6 +42,8 @@ struct builtin_fw {
 #if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && defined(MODULE))
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
+int firmware_request_nowarn(const struct firmware **fw, const char *name,
+			    struct device *device);
 int request_firmware_nowait(
 	struct module *module, bool uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
@@ -59,6 +61,14 @@ static inline int request_firmware(const struct firmware **fw,
 {
 	return -EINVAL;
 }
+
+static inline int firmware_request_nowarn(const struct firmware **fw,
+					  const char *name,
+					  struct device *device)
+{
+	return -EINVAL;
+}
+
 static inline int request_firmware_nowait(
 	struct module *module, bool uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
-- 
2.17.0
