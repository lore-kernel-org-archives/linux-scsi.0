Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043414;
	b=2zAC8oEAA7RwfoWzCar+3NQt+RFQLw06Mt0UkT0BTcWPCtpdRa9jljMEIFIZw6gtXxXS
	 AZ/X+xIJ/fYxjCNLN270o/6L5BfeGE3ZipayV+sum/u3alM8fZgA+dN4VwGSqEaCYaJHx
	 6dcQcCPYMvQ6MXMZSK5a4dOKfD+TshMUj3xlNxBkXt9qRcDVDRV8tFqe0tmJwlyLPbWFu
	 ySuMO6p9bMFLsRuephWdpW+rEWTCyTEYafwoBRlCD9GjMXakXEMNpQkOk9tUq/fvDADta
	 pg+MKHZGf7pc96gOaWLDpIpSHTOwQf1xm18PekAALoVQ7bP61kxPHfHNIfrP9oozt0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043414;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=RqvOwZeZpvi8IBF0Ali24CLpZ5dJRE1DJYzbo6SS6tE=;
	b=MWCLzJ5tfVUpVY9hL3NK7756tQ/vk47s+ivCqh0In91DoH7D8h3tB4dt/8g7iglN63H1
	 8ez5Db9I1wY8brwyRWKGVPdXzmYPI2ADUr9YngjQ7ehFeEOgMIi4OsJ9iwcU/Xe8OHgjg
	 5DhI4SQwyXAu0APNBQIQS7li9eOHfiip8IBCVDFQ+gkzZtDnDL6Q+dm/zrf7zOx9/bxih
	 lYhxgMuSzxdgnUwNPq+HJrxbdCYFXY/1tebDpB0vJ64pLUb4Cv92pOkICOBeUsiMUAbFk
	 wXySvB8NS4yE4IBG87BqM8G5wTQJVxh8/WDQhroCyijTY9CCFsyLQm/jQzzuDIZEptw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eb64CMsn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61F960A2639;
	Wed, 18 Nov 2026 23:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eb64CMsn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0FF1F00925;
	Wed, 18 Nov 2026 23:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043413;
	bh=RqvOwZeZpvi8IBF0Ali24CLpZ5dJRE1DJYzbo6SS6tE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eb64CMsn7nq1qn+Q2lRMELlXB8V9DcGvRbHjbQVQ1NCQ4sdianVm6vNeSq4Tgyeh9
	 sgJGZR+5D7EfzMFQeRTSVY+56LaECsCiOrdJnVt7x4X4Wu9x/WADzGb4nVOv/h2OWg
	 naZqIVQXzxd9G12nHy/5IQU3L04pe/PcmbnB3PoXJ3aVEJIgGBPONbCa3SRYcDbznK
	 8XJl+ZW22lHrHst7YaTY0Q4pJSzCjZXgQDZCFSFgKY8wbvZnR9SDmCRKLqicXMV6y4
	 f4aZfq1lgwSKuTAvW5MEhyG9wuQFLxB/gmXlRoY0bWnDYk88FasQo2hp8dinCmT618
	 pnqw8sohTpm9Q==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 18 Nov 2026 15:10:02 -0800
Subject: [PATCH v3 05/11] scsi: mpt3sas: Restore unblock retry in
 _scsih_ublock_io_device_wait()
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
Message-Id: <20261118-sas-abba-v3-5-5562d690cf61@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1674; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=9h/o8hPn8IeFtFt6FUsYTOpuEHNHFS1pe7wtbE87WQE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq/jBQD+vvXfLkVyXYlqytWg0FUHvVMQ0z3tVQ4
 MWv4faE+IOJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCav4wUAAKCRAADmhBGVaC
 FQuvD/99uyQXSGrneoHmP51UUCky7boUJR1WxIm5a7ZAooTFd+e44W8Upwdmsl4ISscMDTyw5Ly
 /qTOzWbvrM7wh1WXwZBhg0f7OCjcihquryULU0CLqhfwIPfBMtEBIdJ9TSbuLRyZ72fEyglzKDm
 Iedqd3/de62tCY1kuORl6fd/hBAAykCLlGYNAjg2FY4r6m3DNC0Oqno6zpKxdIF0VWZ5e2Aw7a9
 +OFRyFBj3/38QMxdXFQNFKF/XTYSC8tGbguE1o09Fd2bWjdkVPt5hbv3mY5KFKQ3yHbNtwa6520
 cjuHeMgtJKgpMn0Q46ObTyAJ9cO/drRwdpARqrRMcXB+EG0cGNGm/uEhBCgIrcbg+q/ATrD1Bnm
 RrdUvtnFVUamR7PUeGBEEFa2t8zXM3uxZ6hCvIOPFmgIVPbeDgFEel3w0mi1PW34bU3VqUbBXIi
 AYXMdg7CfjHIAWvB5ZF5yazKMbPciBq4oAnGFL2DPmvg98nDv14jNCmZPU8DJTkyzct4+WMUtwz
 qD3J/zbDQGkaIt+NAW3/OxbIKsieIUAsg4uvg2zND+RP/uSTqFoykjUkK1Nkksw8caYhk9v6qAA
 WZrVuH8rtgL4VZ0ElZLRRsrnBWHhvzknC7/3kaeZhcdoYuQr3B9KydIH0IMhxcqSPHj/jy6v0FH
 /tHdkwDyC79mN0Q==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

When the firmware reports that a device responds again, the event
worker unblocks the sdevs of the device. Previously, the worker used
_scsih_ublock_io_device() for this, which uses
_scsih_internal_device_unblock(). The unblock can fail with -EINVAL, if
the SD layer set the device to SDEV_RUNNING while our block still
stopped its queue. Then that helper blocks the device again and
unblocks it, to restart the queue.

_scsih_ublock_io_device_wait(), which does a TUR check, replaced
_scsih_ublock_io_device(). It open-codes the unblock without that
retry, so such a device can stay stalled. Use
_scsih_internal_device_unblock() in _scsih_ublock_io_device_wait() too.

Fixes: aee682fad6cd ("scsi: mpt3sas: Improve device discovery and readiness handling for slow devices")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 45419f0ebedc..5d494ad12c54 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4247,10 +4247,9 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 		    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA)
 			&& count++ <= command_retry_count);
 
-		sas_device_priv_data->block = 0;
 		if (rc != DEVICE_READY)
 			sas_device_priv_data->deleted = 1;
-		scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
+		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
 
 		if (rc != DEVICE_READY) {
 			sdev_printk(KERN_WARNING, sdev,

-- 
2.56.1

