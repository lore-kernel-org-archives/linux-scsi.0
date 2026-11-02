Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.209.128.23
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793586133;
	b=LusRWN5BmS+sxHqboqMEDtPBVpr0J9+5yiQdVe1ydAJGGGHIZkeWeaElmwxGxgIMsPLx
	 gFWzJrA28ezsZdyB99vxjB1h3ywXwi6AsAzSx7N5nSW+ypMWJlJqWlyRb/mfn2o/dlusy
	 /iW6v5gYKlJ0WuRQliJCA/BLfMvFH9JVP17fRJ3u7uRjSVVvSzv+4V2rVvtP92pZ0y4o8
	 hPlYYQium41h8KAPBPBDqj3XfLL5+foFrDuJ+ny8hBsfx1MWgC88zFHzVnuybvg/yEOdh
	 5O3d5TIEXw4FXWN6AtcUnUkq+DKRIGlcPDH5nj6E07jyY7No6WhPb7Ch4gmUrdLeS1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793586133;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=NtWSNvWjOki+d59llwOajUKFgz6zcndrxirPp/gVJU8=;
	b=lIxbRf5tTETWBMRHjXEmZErygm4zouGYimsL9PE3e1VFGZtx8RmD+dumYYbGXVX88c8r
	 XmpiZnLSl15mlXfQXSBv3ffqjnZ6kgXlZtUw2BCay7yQmZahrP2Jm5oPI5/9Qc6SWOQmY
	 0At2LKJ0uZSKT0MkFU2LoUP5iRqGQoFtYlSTkHRXc566Onq+YCR9TdDXN+eJaZUPsyanT
	 VHWxWBKldMqZZka4nFwxOHFY4JtQ3eyrJvOKzzYiLOIIqtIb5z8AlLSOCkaWKi0Y33j7L
	 f1yBRo6XKyhbwWOo3VSXCzIAvHiQOlczapRDPnVU+84ILIEgw7vdDzruisn+FdeJTMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rock-chips.com;
	spf=pass smtp.mailfrom=rock-chips.com;
	dkim=pass header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=U71mDQ87;
	arc=none smtp.remote-ip=103.209.128.23
Received: from mail-m12823.netease.com (mail-m12823.netease.com [103.209.128.23])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06257606A326
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 02:22:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06257606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=rock-chips.com header.i=@rock-chips.com header.a=rsa-sha256 header.s=default header.b=U71mDQ87
Received: from localhost.localdomain (unknown [61.154.14.87])
	by smtp.qiye.163.com (Hmail) with ESMTP id 531c1cf04;
	Mon, 2 Nov 2026 10:22:01 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-rockchip@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH v3 0/2] Retry the full device init on fatal link loss
Date: Mon,  2 Nov 2026 10:21:52 +0800
Message-Id: <20261102022154.3903115-1-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.25.1
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
X-HM-Tid: 0aa19a10494403a4kunmbd08b4a83acecb
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZQk4YVklCGU1MSU9ISk1OSFYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlNSlVKTk9VSk9VQ0xZV1kWGg8SFR0UWUFZT0tIVUpLSU
	9PT0hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=U71mDQ87pecw0v2j+iNMvK+NaT3KxKEwOX9+a2fmDpUf4yt3GJQzfRozDhqCmyazz5+WfIlZCjqqkRJwWPDBbSyhCXNbjFZBUgU2xmbsus092kTMK7Lk1nbseQfd0UMIJYrycNpWrK/5eSTyyWFR7OvGV9nA7DvY4dTtqEo/iHs=; s=default; c=relaxed/relaxed; d=rock-chips.com; v=1;
	bh=NtWSNvWjOki+d59llwOajUKFgz6zcndrxirPp/gVJU8=;
	h=date:mime-version:subject:message-id:from;


On an RK3572 board the UFS device is sometimes reported dead during the
initialization at boot: DEVICE_FATAL_ERROR | UIC_LINK_LOST is latched and
the following UIC query fails with -EIO, leaving the device unusable.

  [    2.784068][    C0] ufshcd-rockchip 2a2d0000.ufs: ufshcd_check_errors: saved_err 0x880 saved_uic_err 0x0
  [    2.784112][    C0] host_regs: 00000000: 0187011f 00000000 00000200 00000000
  [    2.784125][    C0] host_regs: 00000010: 00000000 000005e6 00000000 00000000
  [    2.784137][    C0] host_regs: 00000020: 00000000 00031ef5 00000000 00000000
  [    2.784148][    C0] host_regs: 00000030: 00000008 00000001 00000000 00000000
  [    2.784159][    C0] host_regs: 00000040: 00000000 00000000 00000000 00000000
  [    2.784170][    C0] host_regs: 00000050: 02dd3000 00000001 00000000 00000000
  [    2.784182][    C0] host_regs: 00000060: 00000000 00000000 00000000 00000000
  [    2.784193][    C0] host_regs: 00000070: 02dd4000 00000001 00000000 00000000
  [    2.784204][    C0] host_regs: 00000080: 00000000 00000000 00000000 00000000
  [    2.784215][    C0] host_regs: 00000090: 00000016 00000000 00000000 00000000
  [    2.784266][   T13] ufshcd-rockchip 2a2d0000.ufs: ufshcd_err_handler started; HBA state eh_fatal; powered 1; shutting down 0; saved_err = 2176; saved_uic_err = 0; force_reset = 0
  [    2.784334][  T168] ufshcd-rockchip 2a2d0000.ufs: ufshcd_query_flag: Sending flag query for idn 1 failed, err = 5

Recover by resetting the device and the controller and redoing the whole
initialization sequence, up to three times with a 100 ms settle delay in
between. Patch 1/2 moves the initialization sequence into a new function
so that it can be retried as a unit, and patch 2/2 adds the retry loop
around its call site in ufshcd_init().


Changes in v3:
- Stop the controller before draining the error handler and clearing
  the error state, so that no interrupt can re-latch errors or
  schedule the error handler during the cleanup(sashiko)
- Remove the hwmon device and reset the exception event masks
  between retries, since the device reset wipes their state on the
  device side; also remove the hwmon device on the init failure
  path(sashiko)
- Only restore the MCQ mode after the controller re-enable and let
  the next attempt configure the queues(sashiko)
- Take the address of the by-value host_lock for
  spin_lock_irqsave()(sashiko)

Changes in v2:
- Move the initialization sequence into a new function and retry by
  looping over its call site instead of adding more gotos to
  ufshcd_init()(Bart)
- Stop a pending error handler and clear the error state latched by the
  failed attempt, so that the retry starts from a clean state(sashiko)
- Reconfigure and re-enable MCQ after the controller re-enable, since
  the HCE toggle clears the MCQ mode setting(sashiko)

Shawn Lin (2):
  scsi: ufs: core: Move the device initialization sequence into a new
    function
  scsi: ufs: core: Retry the full device init on fatal link loss

 drivers/ufs/core/ufshcd.c | 124 ++++++++++++++++++++++++++++++--------
 1 file changed, 99 insertions(+), 25 deletions(-)

-- 
2.25.1

