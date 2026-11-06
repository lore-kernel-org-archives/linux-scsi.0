Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793996989;
	b=ngr7OfFNF3rK3yzqq3msD/BSXteQ7IrXaNNHW0jh+BJgbZ1NyOxaQ4p2pR42sxtjgDy2
	 VN1KvrT4WmUM4xfRg1rpmrlb7BmKmcc9TfV1pOwrReeaRgL7kWMjvHsO4i97giYLeZvwt
	 dj4nxtoBZ6QIy1tZVpSAjhtKZIiR4DGxBJWAhh3A79YN74nUe2LIhdYXjdPRyZHsgxcD7
	 lDPEonnV4HrKiIXNfIrmotB9nHRtXc1ldqUzgx8aszMzEPEX6zh86OdwBZ6Sfo0Qbv/Iv
	 aS6YUVfcAZmFYJkBsC7ek/zZbtMJsUhWUTbu48j2SPa2yLIlu1thTDsWswpxJv405xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793996989;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=yFkuY78U7mNDn1bmgLyjLlr/7s0mrmUmQYJZsbo144c=;
	b=CQ1mD0CHWS+8HI8/f4gsFt+fc0Swf5KZzAdChQalEpTHk7FyHjhVpjU0VylsyRGE/rcB
	 Bv5qoY39MyvuE9TubB3KtQdH6UVKEzEqiescNY4Q1B6i4GMPLqthovqNGqVzel0Byh7Sy
	 tvOFmAXyK1QNDwBmPTfhPL8NxDYem1N6uzxbJtySBE7VG6anhv2KZisE+NVRUzqt/AI27
	 jb84tk/LIzEeZuS6yWsk8p2sSTb4RhJW2VJbcbVUpqa3t8N4Ie4fkvdYor93uKarqw5sc
	 1ubA9oYUs93q3TK5ErqIlIQZJ0paY3uzO4awCwQTJMzk6ghIFkeIIZuc9M0vlhwEOOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WpXwaXhi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C36606A326;
	Fri,  6 Nov 2026 20:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WpXwaXhi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F781F008BC;
	Fri,  6 Nov 2026 20:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793996988;
	bh=yFkuY78U7mNDn1bmgLyjLlr/7s0mrmUmQYJZsbo144c=;
	h=From:Subject:Date:To:Cc;
	b=WpXwaXhiEjrSUMt4RxxxgWYuM+7qCiptSl5qt3Qqv4R+ZRL+9hcMMlkKEjfcwnxe0
	 tFbxdojdvvqIQnCK1HJxsI1nse3cbvfi28VdRndtY5t7MG4BWhmzkWtZDAf70aDQz5
	 Z9/H7WjlGFeVKHbBe03onC3S+1tgBosuWuDb+T5eFE4UNyQFqpbWMr14Cx9+sXqBgf
	 icWwB0xuA0x2T2g4/WBpIChXtHsb699G9geC1juX6ElfPFNt6ayvqXpgRIB4C1QD1H
	 RnYksbBP/oidaAVveblpnXEUgviIhIVa3Gyw6lcG3APRHxWyXhZkmPDEnhTGedGXgT
	 wXbWkGe/1pCmQ==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v3 0/2] scsi: mpt3sas: Fix delayed not-responding sdev
 block handling
Date: Fri, 06 Nov 2026 15:29:25 -0500
Message-Id: <20261106-sas-abba-v3-0-571b854594aa@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22MywrCMBBFf6XM2pE8+tKV/yEuJum0DUojiQSl9
 N9Nu1HB5bncc2aIHBxHOBYzBE4uOj9l0LsC7EjTwOi6zKCEqqXQAiNFJGMImWxvbVn1rGvI93v
 g3j231PmSeXTx4cNrKye5rn8iSaJE09qua2RJurGnK4eJb3sfBlgrSX1MKdSXqVCg0eZgqG1KU
 9GPuSzLG0xwCMrbAAAA
X-Change-ID: 20261030-sas-abba-eacfcc45fe36
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Ranjan Kumar <ranjan.kumar@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Keith Busch <kbusch@kernel.org>, MPT-FusionLinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2204; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=xsOdkWXlaL+BC8vXFypsq8J+1VT0Ki6qqi9Om7Mvy0E=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq7ji1HG/B4arNvIMUmwU46kRTeF6AQvTjG69PI
 kQXHyORZsSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCau44tQAKCRAADmhBGVaC
 FSFnEADW7nD3SLDrAFLjCo2Qd4y9zrfKgj0jlIBh+EhVObO9m+/lge6e2SogOI3JogcYTXZeWTQ
 lil6/g5844DxUaHK1Li/uKPRyRfxE7kUdyyE+9/LCDbF9/0UyJb5xhwhRCM/3oLp41eRWb+8D+k
 5lXnY+Lh70JCAIGyh6p+5U+wjbM5MoziH/+0pT8PK1laOeeK3+3RzQlthu+2FRZ25roKx0lv0HM
 1TytdpP3BChrQpiHlHao34X0VmEnuaHsdXBvgqP9CuNz0SeCo8am5SZHc8BKFkmsdrPk87b316m
 pYpycnlVx6s1X5VELoi1u4vnKvXbG+5abk3teddypZo+aIoFiGaS1emMtBPPmwPc6mNaaAz1hcm
 VzmlLyTYHN+K8tPT3HSxRbYs06GhWA4wRo/GD4RmqCa1O0Gc7EP1XP0M10DEhsKQdKYKaaq/k36
 wnt36pG6zrb7DQTGNvsej041nHhhXLf5wuQiCp8wCOcfuO+Bl92JJkymeuNH3h3bRtO84qFNEzp
 Xqxq9Q3sfGKptE2hD1lE2wbROt6Hy8vKY5KGxfbPac6ECw7EPhIKvfZXDF2lwv/CdgcEu1LxemD
 sr9e88VVU41ebfAXWeGWDLfCGy3VTMBFB75+yYZSJqKHsVkOxg+a6RqVcNFO7csfzn3c+FE4sIg
 klvtmy1RiLTZ0xg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

v3 fixes a yet more issues that Sashiko pointed out.

This fix is for a deadlock that we see regularly in Meta's fleet. The
idea is to break the deadlock by unblocking sdevs after a timeout.

I don't do a lot of SCSI driver work, but this one fell in my lap. I
leaned heavily on agentic help for this series.

If this looks good, it'd be nice to see this in linux-next soon.

Thanks,
Jeff

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Changes in v3:
- Patch 1: publish sdev->hostdata under ioc->block_lock in
  scsih_sdev_init(), so the interrupt-time block can't see it before
  its sas_target store
- Clear block_deadline on all affected sdevs, under ioc->block_lock,
  before the fw event worker starts TUR polling, not per-sdev mid-poll
- Take ioc->block_lock in _scsih_block_io_all_device() and clear
  block_deadline on already-blocked sdevs, so dnr_unblock_work can't
  unblock them during broadcast primitive TM
- Defer dnr_unblock_work while scsi_host_in_recovery(), and use
  mod_delayed_work() for the retry
- Link to v2: https://lore.kernel.org/r/20261102-sas-abba-v2-0-b3b9ba874b5a@kernel.org

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

 drivers/scsi/mpt3sas/mpt3sas_base.c  |  13 ++
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  10 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 245 ++++++++++++++++++++++++++++++++---
 3 files changed, 247 insertions(+), 21 deletions(-)
---
base-commit: 8b7179210b22f8e48a82c5ceacb9d56a9c4cfec4
change-id: 20261030-sas-abba-eacfcc45fe36

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>

