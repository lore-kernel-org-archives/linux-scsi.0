Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793257908;
	b=ukwepXHG2Y8ZpwbEry87FQISh1UPFwoanOqYHAcGTuIpmLSQ3GdFy6vzGk3jAhobb8gf
	 VMV1iYMM27Ne8SX2EI4Zt6Z5p9sHlePz3lIbrUDuwTacIzq1JO2Z5wm2XdHT96LQy5C7V
	 FQT7gkElbty5dA8Syx233u7H3H3jn2kcPK7/akO+wy5Iw8m3bufwHuVnfGfVhp0ZQWs3A
	 qTQb+vrd+ElK/A46wAxpZP5vmbq7DxxTy4Wa4iOcNiWRnSPabynYXvH/3PcASebn+8BPM
	 DauBPrOuLqp1fWGq6mjsvOVnc2ZOWkMnjRcCN73JVwBlVoIh7hMq7IU8dzDm3nEEeMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793257908;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=Iu7Uqt4YczqlMrxp9jzAO7KekNm49X3RSeLMX+ma4tE=;
	b=qDUJ1AAobXhPaho64DBdmMT6ayVxztkm58dEtAKlRc8AymG9PGRW/Fo6Fa4KWyGJ3gkm
	 Cslio+K+TrmMoew75/2jgeAzID5E9XnTURsprvE+4zHagaW4HkuHDku5iJTBZujPxfi5W
	 sB1xHrJ3vcQBk6FyY5YH6X0uMH8XE8UMTdn+j1XH5VqNeAGy6/cLpCFWXcUEGx7bNnsqR
	 x0ujNbzyZJJq7o7kLmXLpsnd6WOKi8eR/wlHFRb7gHMCmeT3Uw0+Gx1C81uON0s32CLNx
	 tuKm4AVs7dl9fJ+HDv8JShtdTbQCPToNxybirKyBjy7s2wo4eRVzJArc2vNCRAi8hkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RnbylbY5;
	arc=none smtp.remote-ip=209.85.215.197
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1095606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 07:11:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1095606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RnbylbY5
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd67d4bbdffso1391716a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 00:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793257907; x=1793862707; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Iu7Uqt4YczqlMrxp9jzAO7KekNm49X3RSeLMX+ma4tE=;
        b=RnbylbY5TpsAV+pUsapBaJcX2gIJQOOj6Vbx1fYDLjvfitKc0kiwcEVP+6mNXflR5S
         hW8oTxs57FeA9+gGUM6bv2zvZ05drHDUVw/JN4ckopktY0gVRyuv1LIp+Qzp30p/YHwM
         nr96nHJcpDyytaocE+ZgpTYz71E3RD9VhcS2l6SDBLi+Ha+2C3QDduyGYhW2yC0CC/wj
         td6kIXqU+I2v9vzLVgz2kAXZ1RFhl2MRDPxJk36fX8tSx+9IeeacIOJ9EEZYIkK4ZTOJ
         qAvTxMBhIhQDDjjo7oUfmz7pylK0Lc8ZZkyAUElbmH47GEMOvgbhEmvix2K2iTVOBZp8
         AJ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793257907; x=1793862707;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Iu7Uqt4YczqlMrxp9jzAO7KekNm49X3RSeLMX+ma4tE=;
        b=blcPRoevoDdghC8/r1mgmR4ptB7AODUTjeH7Xc+BfpBEcquhQcNiWPGF+yfQh9sT6m
         8WVF2CX93VwqqrnC2Yx1InMFPELGYha6cO1RyG3Op1FokNhINXEvSCPx9EomOlU98lAc
         H1EQCXchgMcYK14LURHQabPIJO/mDa4O009eW4pCXk08ROhId7IBAU5De0VgE66MHlEJ
         ljC4ExAnf9bAYAMXQTcom9BrWw2qUgJomRA34P5k2qO5wV1Wy+j4VLuuhOdCYhwkaJG9
         wVDbf/1LgUH06AUDoIiX/1IR4YCeW58RgxOWZVHKohy7WNnBY5amdoRD8DiCqerm+yIZ
         DmJQ==
X-Forwarded-Encrypted: i=1; AKwUvBxOHL4ldV7OU2o09X0SoVgGOFG/pcWX6CrLLnj9NUrecJDiVjT2WWI2ot3wBR3wTr4vyg8oYw6/MnuY@vger.kernel.org
X-Gm-Message-State: AFq9FYLphUT8IwKsTSKGk/1pHA7QfD0p6R26vji8uR0ACGnZysWTR2U8
	RzvB5gadwzbK6HhFcYucbrUuSwE7HsSOzFVPe953gbh8GwRG3BIIEZE0Ibivh2Ur/qb47ATa7+h
	DrtDz4KqmDLojtGq60Z4VuQ==
X-Received: from pfbk11.prod.google.com ([2002:a05:6a00:b00b:b0:89e:861c:6b39])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:258d:b0:3e1:d5f8:692c with SMTP id adf61e73a8af0-3e90234d133mr4462716637.21.1793257907155;
 Thu, 29 Oct 2026 00:11:47 -0700 (PDT)
Date: Thu, 29 Oct 2026 15:11:45 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261029040005.2100005-1-stanleyjhu@google.com>
Subject: [PATCH] PM: runtime: Update runtime_pm.rst for non-fatal resume errors
From: Stanley Jhu <stanleyjhu@google.com>
To: "Rafael J . Wysocki" <rafael@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Pavel Machek <pavel@kernel.org>, 
	Praveen Talari <praveen.talari@oss.qualcomm.com>, Jonathan Corbet <corbet@lwn.net>, 
	Mark Brown <broonie@kernel.org>, Brian Norris <briannorris@chromium.org>, 
	Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, 
	Bart Van Assche <bvanassche@acm.org>, linux-pm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

Since commit eef1d74bf88f ("PM: runtime: Only set runtime_error on
suspend callback failures"), rpm_callback() no longer sets
dev->power.runtime_error when ->runtime_resume() returns an error.
However, Documentation/power/runtime_pm.rst still states that the PM
core treats any ->runtime_resume() error as a fatal device error and
refuses to run runtime PM helper functions until the device status is
manually reset.

Update the resume callback semantics bullet to state that on error the
PM core resets the runtime PM status to 'suspended', returns the error
code from synchronous resume helpers, and leaves power.runtime_error
unset so a subsequent resume request can invoke ->runtime_resume()
again. Also drop ->runtime_resume() from the ->runtime_idle()
comparison of callbacks whose negative return codes are treated as fatal
device errors.

Fixes: eef1d74bf88f ("PM: runtime: Only set runtime_error on suspend callback failures")
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
This updates Documentation/power/runtime_pm.rst as discussed in the v3
thread for commit eef1d74bf88f:
https://lore.kernel.org/r/CAJZ5v0ga8qqYg79+hQVtO8T=FOCj8XLmTz3HpEKoOykV_K-HSQ@mail.gmail.com

Two .runtime_resume() paths assumed the old latching behavior:
- blk_pre_runtime_resume() (q->pm_only underflow):
https://lore.kernel.org/r/20261029040001.2100001-1-stanleyjhu@google.com
- __ufshcd_wl_resume() in UFS, where after a failed resume the retried
  resume releases the clock-gating hold a second time:
https://lore.kernel.org/r/20261029040002.2100002-1-stanleyjhu@google.com

Should other .runtime_resume() callbacks that undo suspend-time state
on failure, assuming no retry, be audited?

 Documentation/power/runtime_pm.rst | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/Documentation/power/runtime_pm.rst b/Documentation/power/runtime_pm.rst
index 40a5c23d5259..04dc2a538352 100644
--- a/Documentation/power/runtime_pm.rst
+++ b/Documentation/power/runtime_pm.rst
@@ -222,11 +222,12 @@ what to do to handle the device).
     I/O operations as needed.  The runtime PM status of the device is then
     'active'.
 
-  * If the resume callback returns an error code, the PM core regards this as a
-    fatal error and will refuse to run the helper functions described in
-    `Section 4`_ for the device, until its status is directly set to either
-    'active', or 'suspended' (by means of special helper functions provided by
-    the PM core for this purpose).
+  * If the resume callback returns an error code, the PM core sets the
+    device's runtime PM status back to 'suspended' and returns the error
+    code from synchronous resume helpers.  As with a suspend callback
+    returning -EBUSY or -EAGAIN, this does not set power.runtime_error, so
+    the helper functions described in `Section 4`_ are not blocked and a
+    subsequent resume request can run the resume callback again.
 
 The idle callback (a subsystem-level one, if present, or the driver one) is
 executed by the PM core whenever the device appears to be idle, which is
@@ -250,9 +251,9 @@ call to pm_runtime_autosuspend().
 To prevent this suspension (for example, if the callback routine has scheduled
 a delayed suspend or determined the device cannot be idle), the routine must
 return a non-zero value (typically -EBUSY or -EAGAIN).  Unlike
-->runtime_suspend() and ->runtime_resume(), the PM core does not treat negative
-return codes from ->runtime_idle() as a fatal device error; any non-zero value
-simply stops the PM core from suspending the device.
+->runtime_suspend(), the PM core does not treat negative return codes from
+->runtime_idle() as a fatal device error, and any non-zero value simply stops
+the PM core from suspending the device.
 
 Core Guarantees and Synchronization Rules
 -----------------------------------------
-- 
2.56.0.313.g2479322e68-goog

