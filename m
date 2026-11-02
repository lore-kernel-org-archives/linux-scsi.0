Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793626867;
	b=h3u00I3x2l//SYcCtJfGP36BzRYU+MlCSRk8DbmNr/eQf6s4LInzQECqQ3hwthUG0eTm
	 5QgdZ3XbGgoS0FQLb0plZMEjST4c7L1810GrUtt0MU93UAe+SQUwA2KQP6LhKEinNSi6D
	 mmtjoU99dJjpFr4aFri/Sm2Zha0PXDyZ4RIUvGbjkp/r4ub8hwhL3S5BOQOaOQfDpK+pE
	 u65CieGmGojwKg6s9Qv1Pj0Ywfi/C1FL0+aK2BiDvFO8HkxV4/fLC3iDfX+PKgv44zk6l
	 gfk0tvNn6Tn8VjAjykly0mBxtk3LxUwnDHCgsyg6marYkCrmnks+8o8qpHGQ8JZRhig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793626867;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=sKx9RoPwwM+UyjxoeLB+w/KZrKj8wecorwn0vndvowg=;
	b=5bDUZurdVRtzuhCncQShrBwnW8d3qTsnKfmzFbEpHjB5OPZw0Pqwf5wOGNxWjujxVz2c
	 LFtfNZW36W0IdR1D0uhzec3HLonNGTLGlooKT7d0PKvY25wGL+wCP/PZRhLybeoTv5KCL
	 vD7tA7uA1xNozmEgZYaqrHQUiNj/fIEBWia/5VadWZC/fjHZf0kU5aLV3tR6hJGBeiBuR
	 4DNnsVRVfX4TwUI4zs4LRA671lE63SRsy5RIPIUPwtw/6V2hMxY2FEKaqD408AZUKWf/+
	 vwY24DZXaFI4oEe9PraUdYc/OYPv2lzsUVAfULrnEQahRlG5bMGngRKSUUPaubizHQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EmweB6k9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F9660A263C;
	Mon,  2 Nov 2026 13:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EmweB6k9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D901F00A1B;
	Mon,  2 Nov 2026 13:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793626867;
	bh=sKx9RoPwwM+UyjxoeLB+w/KZrKj8wecorwn0vndvowg=;
	h=From:Subject:Date:To:Cc;
	b=EmweB6k9EsdI2q1BsdBqeoijZm3RU/rISq3MMTa3BbK0vCYEzO2Ou5d8PvKMfJ3tH
	 QlPdpOF5zzqLu6reCZGXCJ0sm9SvVMPFUdVtpeExnEMgWyHIx8zUWFkFkjzaGEIXHV
	 dqRmX/YUcya7lFnb5btfMipj+5IZUxZ7sLoXFjvq1HiHm2RSr2wM9Jq3tkLy4v+HJy
	 OpGqCbJU0omhQkqVnVE6iAXJoozkqqQAoS65hEgeLBce1lml0ciDliuXuM/R1TkR69
	 QZ7D9XVgZMaRHoSk9xPJkc/Qu3cSDLsgKDEpTTn/UO7frL7JhmhnsHJOM6SfsFsQCp
	 qXiUlHEZINjkA==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 0/2] scsi: mpt3sas: Fix delayed not-responding sdev
 block handling
Date: Mon, 02 Nov 2026 08:40:44 -0500
Message-Id: <20261102-sas-abba-v2-0-b3b9ba874b5a@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23MywrCMBCF4Vcps3Ykl9qKK99Dushl0gYlkYkEp
 fTdjV27/A+Hb4VCHKnApVuBqcYSc2qhDh24xaSZMPrWoIQapNACiylorDVIxgXn+lMgPUC7P5l
 CfO/UbWq9xPLK/NnlKn/rH6RKlGjPzvtR9kaP7nonTvQ4Zp5h2rbtC5VcETuhAAAA
X-Change-ID: 20261030-sas-abba-eacfcc45fe36
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1521; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=6a2SG5dLNryOBjAsbfyK3BYN7DzKJDtYv/G+uIDw5V4=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq6JLqSg1uDmT7q0joVyFF+IL0fBiRqb4rplq/v
 Tefdnbnu8mJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCauiS6gAKCRAADmhBGVaC
 FQejD/wI0mbpwZptPuMbVEtV1EggAxe7VgGfxnwvgup2+1sSWWpenlrXQ58vc69KfZf0NJ9Oo+q
 BGfCmXq4obxAbyrnE1b6IzyUJnXkmkA0MBr8+Ma/uCNu+oTz0cOZYr1dULxFzIYXU+WdxrtG8FB
 zKhSePOizr/YBIjLh3WW+C+iuRiMxGbsjhDue3cDSv0uGWeDjEA5A2Cn6X/QwWdBgUQvbVaP4iA
 12+rpNXj/RppVG1kzc8LaSuGJTUx+cm5L4rf8G5tnnDCg4fvGDiFM3kMyAyV8qyqvkDi1hz/0/u
 t1JItM1UdiArjolM0QqASbeojf4+GqCvUlfVRCSElF6zSiy2unSDfcDBvtMUbrQ8GfkZaKexEKR
 15icx+eJeQkWvYIIJ/p+6CflGBUiZL6B9KI3dGJ/gxvq7lHYwM3+oYolmWB9Qq4EZScrlsqJ+Xd
 ZDUCZ//K65i302b3NKLNi9IrpYvzX4M53uvtx2yvOMSBmbUMiFPVvyRCy+28IjagwcjAgrRMnW8
 EZhkJW6C5MmzRsef4qYdJbGeU2OQEv5uK7BFEy3LdBihUjuIDTup6MIjHJqX2s46MPj24uKt9Ec
 soUixV+PY5jLc9xgL8PuMmu8ybDkz/ZSK/rPv8Fe+yMX4Yuyy/CwSj8eejiIyt1v0jNyXjeCO3A
 M4665Rw9EDghtUw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

v2 fixes a couple of issues that Sashiko pointed out.

This fix is for a deadlock that we see regularly in Meta's fleet. The
idea is to break the deadlock by unblocking sdevs after a timeout.

I don't do a lot of SCSI driver work, but this one fell in my lap. I
leaned heavily on agentic help for this series.

If this looks good, it'd be nice to see this in linux-next soon.

Thanks,
Jeff

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Changes in v2:
- New patch 1: serialize the interrupt-time sdev block with hostdata
  teardown in scsih_sdev_destroy() via new ioc->block_lock (fixes a
  pre-existing UAF)
- Do the timed unblock under ioc->block_lock, so it can't race with an
  interrupt-time block
- Clear block_deadline before the fw event worker polls a returning
  device with TURs, so dnr_unblock_work can't unblock it mid-poll
- Link to v1: https://lore.kernel.org/r/20261030-sas-abba-v1-1-b8cdd714a37c@kernel.org

---
Jeff Layton (2):
      scsi: mpt3sas: Serialize interrupt-time sdev block with hostdata teardown
      scsi: mpt3sas: Time out delayed not-responding device blocks

 drivers/scsi/mpt3sas/mpt3sas_base.c  |  10 +++
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  10 +++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 142 +++++++++++++++++++++++++++++++++--
 3 files changed, 156 insertions(+), 6 deletions(-)
---
base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
change-id: 20261030-sas-abba-eacfcc45fe36

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>

