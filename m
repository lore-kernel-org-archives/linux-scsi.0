Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D2F31D367
	for <linux-scsi@vger.kernel.org>; Sat, 21 Mar 2026 03:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774064295; cv=none; b=QrF2U73ZKePZkcokiCPrx9xqO3QCSEY1Tf0/WN2XZXeZoPFW+vwAsIVoj9TXdKON2yhZFlI7X7zT32u9Se6yftV0ty413N7i3i9UktoGeT2YwsHV2IBNXDVTuC/+wHRDe463jlqKMDmPcli/VCP/6Xi87BJBQeFMKQUTGwJzpLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774064295; c=relaxed/simple;
	bh=Kz1ZCjKgB0sIdJi4IBnkiL2gSeKn6AkhNJ04EPbvHWY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rpymRoXwyew4BAkmxbJwXQjTTLaAa9dzEKUjqIu2Pht1973RC7JL7v67cTn1X38gmEGNtsItIEemFzL3no38Afr9AenJetZAhPpoz/VH2wlQY7dhfWcbY67baYym0/gRX6gRv25fmgt5CmFR4IJMJZw14DjPPWQjL3sitrsNnjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z5IbJFLT; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z5IbJFLT"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-509061dab77so24273681cf.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 20:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774064292; x=1774669092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6B2CDNY7UG/sAWansjMq2Hcz4vu6SmMLIBCAlbIfga0=;
        b=Z5IbJFLTDooqFZ1Ad+Xyfga/Bmy2/EUbgeVDDqzh64b8eFmWuc0pe2uJxzp5T80UHD
         bJENOa1PeU+WtbUWnNJ8Bv8sjpTclorvubBwSkw2K76R3AO9Yob0bRWulfIG9CpOjoax
         LoVzRAuFBxC3d86MNu98cdU+Xi6eiVpvFFF2CsQL4A1OhQY2fH6niqggCVPOZnaCcWrp
         hXkE85tfCovAU77RxISmRaCcky0yChf0C0fXFSMAgt6X39OOmyTM8ZnNkIBa6a2IQ2re
         4L5i5juOrd9Np9nKNld10haq1Cz55GOWak7LG7fFhSTwN/a01uWOcaZHrgD0jTNcOM19
         e8pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774064292; x=1774669092;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6B2CDNY7UG/sAWansjMq2Hcz4vu6SmMLIBCAlbIfga0=;
        b=bB3eqzUAYEpvbKhWZT4yZxK9LnIEnj+AHI2C7mwIM8fNjItPP2q6uKkJ9wXas088o/
         ErSqY1xZTzXexbi5tiqjsAOw9IonFJGdKQIeTm/9MbUw+jT4eijwm9K3gN847uPGS8X8
         4LJGxOuEQ8rCSrrXRUm92rQEXddL5wmo6fRjSbvjXUhQgRWdBxjg/plmJHfiATh4Ux5Q
         c2reomQifB57xVn85HLtAooc32R8smqFagY49M9PiSrx4lrtDLZaB+vKHpja4uGJu2J8
         0A5EqY7B6x7kE3QcDy+rApd4QVt+YhWqJonP6wsZ6OnBqQRmTt53gRAquMcFbKWTGi1R
         XUZw==
X-Forwarded-Encrypted: i=1; AJvYcCV/UwVW9HaNXgY9t8v7ATTQfMlpAVPSoVy5z03jtNU5MHxYuMlMD4CGztTNH+1Sj25FsZJ4L8Oyn8TP@vger.kernel.org
X-Gm-Message-State: AOJu0YyFgGF5ZyoJzedXgJWJqTDSn4oF6tLm+qJHUv7oB6r518sQplq3
	/zYuuPKzk/KevoD4e6gi3MAt9GYpgGL1nPn5BHsPhgyeWqmOZ41WZHaWp4V1foYu
X-Gm-Gg: ATEYQzwWY2thfmPMtenPtOhGh6pLcZbTHG4SvCtxgfJ+9Je3WOsoQfREczFoycKozTE
	uvgDDdtYy3XUvwmbnn0LlaK4QTUWUH9MU/7LxgUH3RK8iDblW1DH7B0Pvt3vxwbu3gE5bz3bwRr
	PQYb8ROKGdSDYRAbGauPxfZbY2dZyFpCkVeKhj6DgBneAdfPe9DFFkC2DopKS/Yq1Eo1O05Fth4
	N4SIh8+NdQ+ZEYs03ljMYueFza1fClpXMGA8xWGhduOonxyowU/2WI39+c1Q33pUSW+GNXzLkmt
	LTLpLCYtaz+DHD5IKYgjcY/+waqWkYAf7z5nJL/9hVHqd2INammBccbKAFfaEfWGpUOcnSp7CCK
	jFw99JJOm7zEejjr16vGd2BBT8R1XWT6tx7WH7ivnrkrY3uc5ieaTWOjtifut9LR7UByi573FDz
	pcFxm9AWAmjkFApFFj6erw0DWC6KDKjsDuwpk6KEMqRcEJ78GjEXtIf1rLxSK0I8XBiz0HFskcQ
	rWf
X-Received: by 2002:ac8:5a91:0:b0:506:8738:651d with SMTP id d75a77b69052e-50b37599714mr83159151cf.62.1774064292055;
        Fri, 20 Mar 2026 20:38:12 -0700 (PDT)
Received: from CS-396-Lab-Machine.. (c-24-12-10-127.hsd1.il.comcast.net. [24.12.10.127])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b36e9abd8sm32406071cf.27.2026.03.20.20.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 20:38:11 -0700 (PDT)
From: Tyllis Xu <livelycarpet87@gmail.com>
X-Google-Original-From: Tyllis Xu <LivelyCarpet87@gmail.com>
To: tyreld@linux.ibm.com,
	martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	linux-scsi@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	danisjiang@gmail.com,
	ychen@northwestern.edu,
	Tyllis Xu <LivelyCarpet87@gmail.com>
Subject: [PATCH] scsi: ibmvfc: fix out-of-bounds write in ibmvfc_channel_setup_done
Date: Fri, 20 Mar 2026 22:37:54 -0500
Message-ID: <20260321033754.899928-1-LivelyCarpet87@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ibmvfc_channel_setup_done(), the firmware-supplied
num_scsi_subq_channels from the MAD response buffer is assigned directly
to active_queues without being validated against scrqs->max_queues, the
allocated size of the scrqs->scrqs[] array.

A malicious or compromised hypervisor can supply a value larger than
max_queues, causing the loop to write attacker-controlled 64-bit cookie
values beyond the end of the heap-allocated queue array and corrupting
adjacent kernel memory.

Use min_t(u32, ...) rather than min_t(int, ...) to clamp active_queues.
The firmware field is a __be32 whose decoded value is assigned to an int;
a value exceeding INT_MAX would produce a negative int that min_t(int)
would pass through unchanged, storing UINT_MAX into the unsigned int
scrqs->active_queues. Using u32 arithmetic ensures any out-of-range value
is correctly clamped to max_queues regardless of sign.

Fixes: b88a5d9b7f56 ("scsi: ibmvfc: Register Sub-CRQ handles with VIOS during channel setup")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Tyllis Xu <LivelyCarpet87@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a20fce04fe79..5694530c4b2f 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5039,6 +5039,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc_event *evt)
 		flags = be32_to_cpu(setup->flags);
 		vhost->do_enquiry = 0;
 		active_queues = be32_to_cpu(setup->num_scsi_subq_channels);
+		active_queues = min_t(u32, active_queues, scrqs->max_queues);
 		scrqs->active_queues = active_queues;
 
 		if (flags & IBMVFC_CHANNELS_CANCELED) {
-- 
2.43.0

