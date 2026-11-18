Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043415;
	b=0//PYgpSlUedscJyDjWaYJF1Zk7KrxJk/XJ4cdwFtOTTaQq7g4XsQmyzIe+F79XTBg7W
	 4E2TTCOPKvTaZU+4Azhl14Ib8AFNTlk868Rk6OUz4aLylDsmZeNTj3AHAqt9iDYZWY0/F
	 Wl3OIDkohHEJTBPpmaDkjtXL++88pp7RTvC8q+ua/kxD5CwpSkOpiPq1gE71WXu+Z7ecW
	 bmaXuqGCz7zuTchGO14qFT5idkkRVuyQFwojQ8iQxFfVmpTjdXvCh2QWdGupQiqe+hGJo
	 QWEdbRyrr47dcjKhTn1vjPBh2wIoIouGyKd44bmhKalzbpdkYtziC+bBTA8dsmGQ3UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043415;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=98gzbUeo8vcQaD7nyJvjJoaYXb7ud2EdtFUfp4zBrxQ=;
	b=XfAbKmEVOPuRUMuvz7y55u/5a0fRsqgoz1P8I6qbpqo7tONI3bWS98I1u31okc85SrjZ
	 RiM1+Ku97VD01okCYyYRAFipaxPuqMvaT/1PfWHUVsJOBQXnBWBYu53izk41GPCF2WFaC
	 yGAsxznunNmMtiXuv+6TNUO3d4PNjo8AjWxbwJ5ANVKzJb+9HfZ+c9Xn01snPuYuMraDZ
	 FnOSpv4zZ8sDNoTtw4bADkg0VoarkRQmVRE5j+lsQtrHcc2UTOgOjdNxQj0nMzshFyb5z
	 TtJxdTmpqVVV0r4kHeuEpioF0JhQXZGs5bnVaVlX2+kJCW1QeMQ9ap16hErnTfiWR4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bnvklFOM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996D060A3831;
	Wed, 18 Nov 2026 23:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bnvklFOM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1269B1F0092F;
	Wed, 18 Nov 2026 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043415;
	bh=98gzbUeo8vcQaD7nyJvjJoaYXb7ud2EdtFUfp4zBrxQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bnvklFOMgnNgKz1jj6II6+oYRERQt1whTkDKA9G206vmh8SmsG7lxTP6XGoeYyMWD
	 dEvG/8OzyvugcLhxndUjOjzVrAxAmH5zI9Wh5mXtSYMU5+si4YASv3mQ6P1hAaCHcd
	 oGXLjSywSUxQIaxD10Ee8lmKT84t5nNCPL5M/WdCNOnL+gwBjllQWS2vBuJT7aoP/t
	 pd1kqegnxXaiYQbziOxi1CuZBVSjcSIAOJ0xE8abmTYLtORuDre2hXRW+s2jz9jF9L
	 6UQ3N2uxb03+8MnEwv6fk0HTdHY2CEo94ogOcYUpT7dOnjt0RQlORBR73/xL1vlbJX
	 eIngR2hUtqN4g==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 18 Nov 2026 15:10:05 -0800
Subject: [PATCH v3 08/11] scsi: mpt3sas: Cache the missing delays the IOC
 actually uses
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
Message-Id: <20261118-sas-abba-v3-8-5562d690cf61@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3608; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=K0fdyMV98/3nylNqbCI1uwwpC7KswRXV/gdfvVRaUUY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq/jBRExULbnnNvlmhXJRfoKe4MkaWblhWln/Y8
 ul//AMel4qJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCav4wUQAKCRAADmhBGVaC
 FZiTEACx9n2Wh3wV2DSFRvjbsqllYzhjmjytm2vFt/uwWzC73hEdLp/BroUD9Vj56MyvvZyNfJD
 shXHdfaOp4EyKmqgoLj2CpkSMVQU/AJQvhWvd6Omrz9CR8ntd9I/az6zMzmqK8m2VK+bjDrmXMb
 DHy/oPWJpPJHRXXecVz3LcME1BryU3INMADsJEE6L4Posivq+Kwz8c6atLEzUNgRLvysR8R58Y9
 CT2V4U6CHaJh/A3RZkzHsDBpmkjDVIKvqoV+0b66RzZoi9lTglgpYzpMn6vyayO98iuV40ZdZEk
 RNlFh06d7jfjdoCr+3jF7Di/RXzlFen2aZwbqjIAjZv9X/SsIohfEdk6bEEpUa9pWwKlH0MgNBw
 4uYZWmSGWIprUkRCVbxI0ctXxSVGitAQLd4em1o+TMevqEvnVVkJpRwhYyQMqCooJ0zNzz5tjoH
 AnEdMAoMCsUU2sTzNrIxtOq3+pIiIzszDFKGfh0uQKFHT39dZn0pJNc/zY/x6hl7AVWUIlxF7ZS
 G+xta3iVCOBLNmZ5HDrdPPvitryiCt+T9W7AqRgt5p0QFiYurMzl9AyJybuWyn/mgEmFVTj73Ud
 pTMInDTTK3nTYf1xcqMpsXjN6A1hyug0XElSYaEOldBomFuo5mL6JTcaz9igTlCdqCkn4ZAvt3S
 82eBm72M2GYj5ZA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

When the missing_delay module parameter is set,
mpt3sas_base_update_missing_delay() writes the new delays to SAS IO
Unit Page 1. If the write succeeds, the function caches the requested
values in ioc->device_missing_delay and ioc->io_missing_delay.

mpt3sas_config_set_sas_iounit_pg1() ignores the result of the
WRITE_CURRENT request. It returns the result of the subsequent
WRITE_NVRAM request. If the WRITE_CURRENT request fails and the
WRITE_NVRAM request succeeds, the cached delays do not match the delays
that the IOC uses. The device_delay sysfs attribute then reports the
wrong value.

After the write, read the page again and cache the delays that it
reports. If this read fails, cache the requested delays if the NVRAM
update succeeded, as before.

Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 46 +++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 5c957044eded..07e16acc8abc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4923,6 +4923,7 @@ mpt3sas_base_update_missing_delay(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2ConfigReply_t mpi_reply;
 	u8 num_phys = 0;
 	u16 ioc_status;
+	int rc;
 
 	mpt3sas_config_get_number_hba_phys(ioc, &num_phys);
 	if (!num_phys)
@@ -4969,23 +4970,38 @@ mpt3sas_base_update_missing_delay(struct MPT3SAS_ADAPTER *ioc,
 	io_missing_delay_original = sas_iounit_pg1->IODeviceMissingDelay;
 	sas_iounit_pg1->IODeviceMissingDelay = io_missing_delay;
 
-	if (!mpt3sas_config_set_sas_iounit_pg1(ioc, &mpi_reply, sas_iounit_pg1,
-	    sz)) {
-		if (dmd & MPI2_SASIOUNIT1_REPORT_MISSING_UNIT_16)
-			dmd_new = (dmd &
-			    MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK) * 16;
-		else
-			dmd_new =
-		    dmd & MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
-		ioc_info(ioc, "device_missing_delay: old(%d), new(%d)\n",
-			 dmd_orignal, dmd_new);
-		ioc_info(ioc, "ioc_missing_delay: old(%d), new(%d)\n",
-			 io_missing_delay_original,
-			 io_missing_delay);
-		ioc->device_missing_delay = dmd_new;
-		ioc->io_missing_delay = io_missing_delay;
+	/*
+	 * This returns the result of the NVRAM update, not of the update
+	 * to the current page, so read back the delays the IOC now uses.
+	 * If that fails, assume the requested delays are used if the NVRAM
+	 * update succeeded.
+	 */
+	rc = mpt3sas_config_set_sas_iounit_pg1(ioc, &mpi_reply,
+	    sas_iounit_pg1, sz);
+	if (!mpt3sas_config_get_sas_iounit_pg1(ioc, &mpi_reply,
+	    sas_iounit_pg1, sz) &&
+	    (le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK) ==
+	    MPI2_IOCSTATUS_SUCCESS) {
+		dmd = sas_iounit_pg1->ReportDeviceMissingDelay;
+		io_missing_delay = sas_iounit_pg1->IODeviceMissingDelay;
+	} else {
+		ioc_warn(ioc, "failed to read back the missing delays\n");
+		if (rc)
+			goto out;
 	}
 
+	if (dmd & MPI2_SASIOUNIT1_REPORT_MISSING_UNIT_16)
+		dmd_new = (dmd & MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK) * 16;
+	else
+		dmd_new = dmd & MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
+	ioc_info(ioc, "device_missing_delay: old(%d), new(%d)\n",
+		 dmd_orignal, dmd_new);
+	ioc_info(ioc, "ioc_missing_delay: old(%d), new(%d)\n",
+		 io_missing_delay_original,
+		 io_missing_delay);
+	ioc->device_missing_delay = dmd_new;
+	ioc->io_missing_delay = io_missing_delay;
+
 out:
 	kfree(sas_iounit_pg1);
 }

-- 
2.56.1

