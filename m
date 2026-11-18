Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043414;
	b=QhBm2Nv5g1JYROmKAD2fG7hdUtPTjMcRjUQ9Dgll/zF5u4iudu/WrLhtoncE9JxCSC6N
	 bZV6oFrHoX4smoexI3SaDesm046Q1ik0Yu9vjzCZeuqLSKCfA/lGYeS06MRVxaPtU+GU+
	 CFRQjW6hH9+W6D1goT4sFbMhXgHg8bGH5kXcwO/2d/1JalPy2YeUEBTMDjeepbVvoqwE5
	 dPXZV4DpQCIt9GwbLxHVtIQd6px4c2wCufCkN4noXMAGQvPTGvyRTLF6+M8LJHLCP3RFu
	 dKLIoc8BFe4b19hmQLDdDaxaoegrUZg4ba2oTsh/xayPKARU6LbXEXWh9GujsQZnV8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043414;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=DMQFxeiRzYPom4Xbw7gA+RFQaIOVsiCalGL9THJ7Vfc=;
	b=0p4gEd1TLIHWm7GQVw93hcIGU9VRcdwmVThBVabZh+lBmesbFH+p9xs7aTItD76Swdoc
	 UF/hw9TOuz6eMftXxqdIESAGkBtY5TE+IQEh97USakZv/IrnVyYYAlLGFbAJv48FLW4zM
	 TbDX0H5wiFo0J7dAR0qRYjTE9iOgwkCGaD735lQAib/vt4JYGED+8aTSyvFnsRCkXelKK
	 d9/qimfB4R/QqYfLfFmnk9ejnO2ZPHREPrAmL/e8K0k4MaX+/4FP+9rleBh7y5xaOgNqp
	 loA7+W+J/ly6Wmcn56/B6iEQgGDZojzxvV+hQIMA6Afhlxi7mJCMn3y7Q4sMECFHaJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Roiqk0WH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A57360A262F;
	Wed, 18 Nov 2026 23:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Roiqk0WH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DA01F000D4;
	Wed, 18 Nov 2026 23:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043414;
	bh=DMQFxeiRzYPom4Xbw7gA+RFQaIOVsiCalGL9THJ7Vfc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Roiqk0WHasCLAa3TgJ0aVQ/K1BPsRmz4OHaKz0SWnRLnbIMnFNzexJEIrGsXmS/Cx
	 VS4xUYF3Td0bkZGX+uBEha6yYJfcD2XsXD4N66IiXM7WFPx7q/6bMJkioEzMYh1TVA
	 34aOpumc7A6T1M/jTV/mch+Z2QCP97Y+Nm0GHnSHDSqLo3hZMqZmZKn05J9YtoSIR1
	 lUh11wrIicTzXXDm02Ww1nM9W3OA8EESHL21JWb6TKVoO1oLeQ6vIMIzvx/YZiPkfG
	 VkGT4SR6SEa3vZriLv927aHpLlWe/Epms+p+f0ZN2ZC0psBjnRJPy/692QX49xNzBu
	 S7V/pr6WVzR8g==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 18 Nov 2026 15:10:03 -0800
Subject: [PATCH v3 06/11] scsi: mpt3sas: Stop polling devices when the
 unresponding scan is cancelled
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-sas-abba-v3-6-5562d690cf61@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
In-Reply-To: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Ranjan Kumar <ranjan.kumar@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, 
 James Bottomley <JBottomley@Parallels.com>
Cc: Keith Busch <kbusch@kernel.org>, 
 Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, MPT-FusionLinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2980; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=2UfJrp2YgJZAnB9yQIkKe+VDoHCGByQ6nZNxNG3H4GU=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq/jBRKl+xYM73BIk0/IMFZlrISJ5LKOIBpidMN
 t8hsotUdeKJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCav4wUQAKCRAADmhBGVaC
 FaMXD/9Ysi8pZ2gIEraNlKrSsMt0SQ8aaoIRzIIbysp4kYd8ERL5kSuqPO9o+XklIhRx3ZWyATE
 jn6sxQxlY37ZPNjVP+/PCeoWNXlnL/RLO3kMYG7irenuyIVBBQKiWwR85bCSziGIYWsnTleW56e
 pkqFlJDy8qF0ILd+2+OJHMKMi+6nrTHmsyQ2ROFhFsUxgnGsyNdxJdT/rhQM+MsDcYx35icHn/y
 frqYFWTW+IGs+Waj2rlgiMy7ymqC1Kx10TmIbrKLPw5bA/Pe6QpIeuaPhabuT639QQ3kOxUqZH2
 bmkQ5zOcQW2QIJjCPK/RV64bhoCeHaWwWfamYx+rlT/nUn0AMbz53PR7s3lekVBuN+QoJSH3HPK
 wPQR+Kz0NEhdBd687w02zptZBv9JgxsitMdyrE6sJbJKVaUNL9VhOtVWY1Mawk843e6hAUD5/tO
 GWyStYEriotOE4KtqjYoJLK5T2TU0JxDFlQi3Ke0I/IX8qH3D2Wqr+mffQkulecLj5j9bHPLVM1
 yxADKz4/xYCIZjr7yprdhpjsy5AAwLU5DoVR3FxnqZELR7Eid5F8xGA7Wpv4nqd8pP8QOXN8ms3
 1FcSlWZ/VGfaZYVEN26Z+5v/aPOpaiGCv3Qjy4mzjSyBb3fqnY/twsGO0E87dsuKi8KO1JXa4Bx
 o0UfKWBpeo4eJmw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

After a hard reset, the MPT3SAS_REMOVE_UNRESPONDING_DEVICES event polls
each blocked device with TEST UNIT READY in
_scsih_ublock_io_all_device(). It retries a device for up to
command_retry_count seconds (144 by default).

If another hard reset starts during this time, it sets shost_recovery.
Then _scsih_fw_event_cleanup_queue() waits for the event in
cancel_work_sync(). While shost_recovery is set,
_scsih_wait_for_device_to_become_ready() returns DEVICE_RETRY and does
not test the device. Thus, before the reset can continue, the event
consumes all the retries of the device that it polls. The event then
marks that device deleted and offline, although it never tested the
device.

If the event is cancelled, or if the host is being removed, the event
already returns before it polls. Do the same check during polling, and
stop polling if the check is true. The remaining devices stay blocked.
The reset queues a new MPT3SAS_REMOVE_UNRESPONDING_DEVICES event, which
polls them after recovery ends. If the host is removed, the removal
deletes them.

Fixes: 72340fecd0c8 ("scsi: mpt3sas: Add configurable command retry limit for slow-to-respond devices")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 5d494ad12c54..5657bda241f7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4057,6 +4057,22 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 	}
 }
 
+/**
+ * _scsih_unresponding_scan_cancelled - should polling devices stop
+ * @ioc: per adapter object
+ *
+ * While the MPT3SAS_REMOVE_UNRESPONDING_DEVICES event polls devices, a
+ * hard reset or the removal of the host waits for it to finish, and the
+ * readiness check doesn't test devices during a reset.
+ *
+ * Return: true if the event is being cancelled, false otherwise.
+ */
+static bool
+_scsih_unresponding_scan_cancelled(struct MPT3SAS_ADAPTER *ioc)
+{
+	return READ_ONCE(ioc->remove_host) || READ_ONCE(ioc->fw_events_cleanup);
+}
+
 /**
  * _scsih_ublock_io_all_device - unblock every device
  * @ioc: per adapter object
@@ -4114,7 +4130,13 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 				pcie_device_put(pcie_device);
 		} while ((rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
 		    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA)
-			&& count++ < command_retry_count);
+			&& count++ < command_retry_count &&
+			!_scsih_unresponding_scan_cancelled(ioc));
+		if (_scsih_unresponding_scan_cancelled(ioc)) {
+			/* a reset queues a new scan, which polls the rest */
+			scsi_device_put(sdev);
+			return;
+		}
 		sas_device_priv_data->block = 0;
 		if (rc != DEVICE_READY)
 			sas_device_priv_data->deleted = 1;

-- 
2.56.1

