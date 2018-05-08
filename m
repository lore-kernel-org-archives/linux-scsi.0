From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v6 07/13] firmware_loader: make firmware_fallback_sysfs() print more useful
Date: Tue,  8 May 2018 11:12:41 -0700
Message-ID: <20180508181247.19431-8-mcgrof@kernel.org>
References: <20180508181247.19431-1-mcgrof@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180508181247.19431-1-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, keescook@chromium.org, josh@joshtriplett.org, maco@android.com, andy.gross@linaro.org, david.brown@linaro.org, bjorn.andersson@linaro.org, teg@jklm.no, wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com, zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org, mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org, broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org, torvalds@linux-foundation.org, Abhay_Salunke@dell.com, jewalt@lgsinnovations.com, oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khc@pm.waw.pl, davem@davemloft.
List-Id: linux-scsi@vger.kernel.org

If we resort to using the sysfs fallback mechanism we don't print
the filename. This can be deceiving given we could have a series of
callers intertwined and it'd be unclear exactly for what firmware
this was meant for.

Additionally, although we don't currently use FW_OPT_NO_WARN when
dealing with the fallback mechanism, we will soon, so just respect
its use consistently.

And even if you *don't* want to print always on failure, you may
want to print when debugging so enable dynamic debug print when
FW_OPT_NO_WARN is used.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_loader/fallback.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index 9169e7b9800c..b676a99c469c 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -690,6 +690,11 @@ int firmware_fallback_sysfs(struct firmware *fw, const char *name,
 	if (!fw_run_sysfs_fallback(opt_flags))
 		return ret;
 
-	dev_warn(device, "Falling back to user helper\n");
+	if (!(opt_flags & FW_OPT_NO_WARN))
+		dev_warn(device, "Falling back to syfs fallback for: %s\n",
+				 name);
+	else
+		dev_dbg(device, "Falling back to sysfs fallback for: %s\n",
+				name);
 	return fw_load_from_user_helper(fw, name, device, opt_flags);
 }
-- 
2.17.0
