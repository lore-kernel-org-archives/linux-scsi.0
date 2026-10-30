Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793378565;
	b=1aX1q8CTyOujCLH2n/upVH1iRW+G/EzQsw3jzAjPikes+jQvk874rKQnhST7v9dRMaos
	 SECjdTEe/NhRerVVXck4YQ0Hk6wfo//6ACu23zcq8t/hIM7lcseAFu7A+LOS1rStnh87P
	 UWW2RhoA0n3w1A0/scoGm1VwOKXIfPI65AuX1NhT8a3r5J56RB3Q5vxHevZ/h/qJQn3lk
	 eJfptPxg3bfk/t7YeitFq2nA1p23w7dKtz0A3GybHv51uBxnEYqR5FkGMh7IkI71VRXRU
	 1a/4Cl/JgtYYpOjehEspxNbTKG89qh5xcaYpxYW/Cxj7pLZ2wH/BYRg6rEr2IrI5Omw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793378565;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ok3D/afU2nVjQzmvIGoUXuLtqcy5MauRxmbOFQz2KJE=;
	b=AkkERedKsh9sVEb5LVgrAILOuswgEa3uKWkgKvpLmXLycS2ehToA9dJAzS+Cpq4kbnyC
	 T15745Mk20NsY4N6VGCiNqEPl+bejMWkOnOHaZwRn3OBruURolSS6HKIj17VECiCJ8Tg1
	 Qa9gzAI/vRtzZHW6s6mjd891FPO+w9uWkuslIaxERHqtGQvjgrJ5vXR7uUkb2dbPsbaNS
	 becYbGbVneVZpQlWR3xPCWxF7RQUbgdrItmi/TrnNpy/Uif9YCpUXuGKCaMWO3Mrg++Qr
	 1PppBNgDK+GNuIKtd9rkMEpgF6SOMG27mjh7rKJEY7HPXbjQj1c3B9cPrRFR9OVYabA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=aJ8BVuHe;
	arc=none smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AA8606A324
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 16:42:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01AA8606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=aJ8BVuHe
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-36a18fc7a38so2265540eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 09:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793378564; x=1793983364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ok3D/afU2nVjQzmvIGoUXuLtqcy5MauRxmbOFQz2KJE=;
        b=aJ8BVuHeldtz9OI9GB9aOqjNrb5jTwSxyQsjpBrtDdDfWvwKON98ioFrFFLwHC/zTV
         5UCa4e1UCpwRnFeRht1kk3Ola8k9SUZltnkmJ8aMrX7lZoyK0Q8Q1PV+z6ajn3HJd2Mv
         3+XdjTR/iv318Dwa2ApGvJO/LLMCCHNxFTADVaHKSLNT9p+wGG5EzVmx0N7qwkYrOHvz
         rYLXXLzhMc6YSXU+4zbaLEmniG4cpC5sQp+/jrn5ivppZQmhQCZ02MQTFaqscLJ9b4wN
         8o/9jNw/7ESKYnAfimPbIdRTnVHnDxiJ5gnq8zt7ArfvDyNm4iDF9Mst57zaqHrJhCzt
         ooXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793378564; x=1793983364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ok3D/afU2nVjQzmvIGoUXuLtqcy5MauRxmbOFQz2KJE=;
        b=XkK9roF1Xlc/GzES3wpwPt3N3YNrgBXUtHVwZcutboAV24yZV0A+6hCdxotQwuiMM7
         W7Gb4r+TPzx+Ep0v7tsjz+nMZxvylhiXQ5NR0QyG8Y6u7dTq90vwz/XQqPnSc2NM1alz
         TENoMEiYF+2vIyWd1Wm1sTjYJFE2FQpIt0a2kvmuE11tXf+mQkjg7RxH/D7sClwoO4/e
         ifsLhmVylVmoEcJgD1ArN2a+NbuKeC/jpKv/+fSNrgNsKJk/kg5jwd7rVSKHv69NtGUy
         XTl3Fpr9O1eKAiY/nGJaniB8e7FZNHL2BIutHRwxn/QX+hfmdO4U69/i7ZEvHc4UIlks
         d3Ng==
X-Gm-Message-State: AFq9FYIlmm7NKu+UEb6M+3gD08PIl9GlwvJpSZuzJ/9bx7mi7Han8Y+B
	G4KtDN3Lv1afRnSP444a0WV8zer9wf//GTIxCAM2WAWFy5nr++CoAAdHi44BZ/1ulLluAs7ulnj
	x0xRsb/nTSEo8nrqpvzUNE7fn/aSLXkqcj9fnCDePBAhIOQvTkHJ3ELIHOMQf5rNQVNfjMe8ue9
	WgZtKMqhKU5kBibEskLdcD7fInh9anej880VWwsM0q96PmKlx9JHA8F+S4p3kAjss3M4K0dT9/S
	ccoTNFt1zivfbem+2Ec2xvcx8dM5VPzl18ETcNGyvFhbKk8cOzQiw==
X-Gm-Gg: AYBFou3giM7FF+oxO0GNANcVEUoVtN53645hS94qy8SsaJIqN/QmMUaIHc9xBKHhwFE
	R94LE7KYFMP9ikDeMUYV8U+OHDztBKoeh1nBWLmtGSYu3ePYdFC+beEGUzF9P534rwFSp39hAF5
	+mupCf0oAfeh2kj6jiY8YHUE28FgJmC5GoYf6S/CO5LTP5ayyMP3We+ARJHnaycYntqpuJdoSCk
	V9vwZxwhKuIYIOhsEvdw9iG6pLpPAGJNzvA7Iro1X/W++HID5tEHFTZE3saqRuffqo1U2nmNfIm
	GPyt1td1+k53jvc++Q68ObfGkfevj3CVpwbFNHNYosH8lERu2M1K82+RvWKqXaWQajPH318CDc5
	dqFaTI3dIR2qYqtAedSCj869Cosr5LT0ZT2LEjgqcFtv7ZnKVjUF6cLlW2MM9ZV31z2Qv71XnUO
	DXuwJQ+QYFUQB15SQsl1VWrzkbviZnVgZpTpeei9gw0ALF/xwGt7W9F3anBXYrX3aS9Vz/bcCYC
	Vrhly/wROuICmWo402E4OxhLg/Fguu+33kaRnByTZebmKcbMxi8zLEMKtJ4lpfI9tMjCBnqoCuk
	TYgo8BeNdniPj+zzDnstJaImAgcY9THvPEA2RiZBYlVdZslen1LoaF+5GfjHRA5SEF00gOHIJwR
	C+/AmZHi8zZKL9TAgB6+V9332WAxCvuNXIzTI4fUdDKGqZlB0l4V5okMYK4lCcC/aT5pwpoyF9Y
	SN54DJ+70FMiu7W2dgpXw=
X-Received: by 2002:a05:693c:8107:b0:351:6b27:d67d with SMTP id 5a478bee46e88-36a4241aa57mr3973297eec.30.1793378563798;
        Fri, 30 Oct 2026 09:42:43 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4294419dsm8475040eec.18.2026.10.30.09.42.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 30 Oct 2026 09:42:43 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: lijinlin <lijinlin3@huawei.com>,
	Wu Bo <wubo40@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-kernel@vger.kernel.org,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH 1/1] scsi: core: Restart a stopped queue when sysfs sets a device running
Date: Fri, 30 Oct 2026 09:42:29 -0700
Message-ID: <20261030164229.10037-2-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030164229.10037-1-brian@purestorage.com>
References: <20261030164229.10037-1-brian@purestorage.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A device that its transport blocks has its queue stopped. If the SCSI
error handler then gives up on the device, it moves it from SDEV_BLOCK
to SDEV_OFFLINE and leaves the queue stopped. When userspace later
writes "running" to the device's state attribute, store_state_field()
moves it to SDEV_RUNNING, still with the queue stopped, and rescans it.
The rescan takes the device lock and waits for I/O that can never be
dispatched.

Nothing restarts the queue after that. When the transport later
unblocks the device, scsi_internal_device_unblock_nowait() rejects a
device that is already in SDEV_RUNNING and returns before
scsi_start_queue(), so the device is left running with its queue
stopped for good. The task that wrote "running" hangs forever holding
the device lock, and anything else that takes it hangs behind it.

This shows up with iSCSI when a session drops again just after
recovering. iscsid onlines the session's devices after a relogin by
writing "running" to every device it finds offline:

  1. The session is blocked, which blocks the device and stops its
     queue.
  2. The error handler cannot recover the device and moves it from
     SDEV_BLOCK to SDEV_OFFLINE. The queue stays stopped.
  3. iscsid writes "running": SDEV_OFFLINE -> SDEV_RUNNING with the
     queue still stopped, then the rescan sends an INQUIRY that sits
     unsent while holding the device lock.
  4. The session recovery timeout calls scsi_target_unblock(). The
     other devices go from SDEV_BLOCK to SDEV_TRANSPORT_OFFLINE and get
     their queues restarted, but this one is skipped because it is
     already running.

A vmcore from such a hang shows the device in SDEV_RUNNING with
queue_stopped set and the queue's quiesce_depth at 1, the rescan's
INQUIRY never started (MQ_RQ_IDLE, no start time or deadline), and
iscsid owning the device lock while other tasks wait for it.

Restart the queue in store_state_field() when it moves a device to
SDEV_RUNNING. scsi_start_queue() only unquiesces the queue when
queue_stopped is set, so this is a no-op for a device whose queue is
already running, and it keeps a later scsi_start_queue() from the
transport balanced. If the transport is still blocked, its own
readiness checks in queuecommand keep commands from reaching the wire,
as for any other running device.

Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after offlinining device")
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_sysfs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fe54792ed69e..f5416a1548bd 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -811,8 +811,16 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 		ret = 0;
 	} else {
 		ret = scsi_device_set_state(sdev, state);
-		if (ret == 0 && state == SDEV_RUNNING)
+		if (ret == 0 && state == SDEV_RUNNING) {
+			/*
+			 * The device may have been offlined while blocked by
+			 * its transport, so its queue can still be stopped.
+			 * The transport's unblock skips a running device and
+			 * would never restart it, so restart it here.
+			 */
+			scsi_start_queue(sdev);
 			rescan_dev = true;
+		}
 	}
 	mutex_unlock(&sdev->state_mutex);
 
-- 
2.56.0

