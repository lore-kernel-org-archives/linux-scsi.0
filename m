Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794568327;
	b=YXeBFZzyUruIXsF8M0lpGikaDLtJQ/knLzn5qawiXAL3uOe89o5rs5SZuGiv/quSYPTv
	 5sDpt6YAJkv19XMTcNJ2NHSyrmXpvsZ7wGd7pVWpswZeeCkAKOrmRcYfwsqqpfhF2h5bZ
	 1NaEwaQ7srnP6SE06LKqVeHj3CqsjZaGOT1H3i5stWrdgwvB3yuxcx76s12ynbKrT+Zc1
	 5igCkbuonKhjlcJXcfSmQNx43tdQD83mUQaLqd3YSH5umF7cZ7O1rYLbQHqssQSz0EeOu
	 Tdr7xLno/oVAoC3sGAy1xl7zhRjyLZZUta72kiNe4s8tTjxbjJNGmiNu9tqCf8y/Pjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794568327;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=QVHTU60vGRb+Zvv52jZBctrQrlA3sz5HwG1d7pGxaWY=;
	b=nlW326A6r6C1ocf4kreeIwq779jDXqy69vXyI1ZPtRFSmqZudlpcZkp2lsBG2N0Kx0X9
	 IW4Imur20dY3+A6XZQDFcBl6IWku7F31mxsC9EoevhC9IOSH8d8xDCmLV4BsoQ41TW1P2
	 9652sa2LW9rvMq3vrSFiq3yFIvmrMrQuwUkTUmyLm5traETeolQq3CYT7zkF+qEQ2BiAv
	 aIEvW4KVJKCt+L0J8TRV3KcHYGW7eqD0JrTzkvwxHHS+5l/8Y7lvhjmP+FqV12S8g8Dde
	 EIfqdwaoEP8WVPPVgHLgORX0+boi3/+sL6qCEd2W+XUYnBMXsovbiBQnj0gPPNvJGzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XFG031gm;
	arc=none smtp.remote-ip=209.85.210.200
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D868D606A31C
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 11:12:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D868D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XFG031gm
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8b69b8c6dd5so1240342b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 03:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794568326; x=1795173126; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QVHTU60vGRb+Zvv52jZBctrQrlA3sz5HwG1d7pGxaWY=;
        b=XFG031gmS/DYARWYVF9N1b5qeQ3QCbIlj7fbLhel2SA7kiLMTbfx3DxyndMFiroata
         Zim3QTF2gEnUpqge94EXyNyjUd02BCMWSgGOKaoe65EAotqpboFDgfToVqoRmc7jyutI
         bg3RHw+R9iWe83kJc5PfZMGWB22Huc7WH6CZ7lTVpQjwszkCETZypTAyywn5MKcoUXHw
         pQxZdRBylEd1U2EkAn7p2vCvspsdny1MSr1GLIpyiqNxQCDeXw6+UeOk9APupIOWNdJf
         n/xrdOfLFBz0SNNtQ+JpvdS5yUX8+gX+PbquvAhB/srvgRNxYus+P0dDWthZsvmLPQUq
         k5FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794568326; x=1795173126;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QVHTU60vGRb+Zvv52jZBctrQrlA3sz5HwG1d7pGxaWY=;
        b=xnWbRZoixdPbYp3kX2PdnDa7O2g8KncfVE/Uu6N4ymt2/zZkOg/MWngOjRWYnj5T0u
         BLiqQZbVYCM2IymF1ZE7Ipe8w8NwZJ3h2ANVM0jkWMmif8K7ZE9rrZeSvy8gDUOtYYaO
         +fwZ4CZRl9CSS9z22cOhZBiyMZzgFho9Xxt9t4pZIPk1pLyy6CiGw1Z1+23x7rCTxxfB
         6ALpSEVXAwO9/6MqanQKLO+UEInCdl17xU191Rlkte9s/KmHrxdIslTDgpYb/1gH+2Kh
         jR5kMHEBtEk8EcpoSsdlafRECZWBzDplW5cZ46isnWTBeQsBS56lsO1XhfJaBDHtACG6
         djkw==
X-Gm-Message-State: APuU4Z8dI9LVgZebGn2otemxOV750/MgIhaFJQs4KO8bxcTZ2a7l/yXf
	pK87thnvsu7u0MAfXIVTL3vTYUhElw6rDJDOmlpVYg7XMMN7E9UZQuUfmUrvKZLi3VDHx6ICE2g
	TGPPh0AHOvGpx02O+3QybzpBVRMzLmw5+kASifK8MjUxrl95IWuJp1HR7Y8SdO9y3AwdGLqBLE2
	OFUuYjcMuh4p72Yv5tis13E16+1CSHJlE4zcZEPZDG23SiNMAjlyX77fM7weNbkUE=
X-Received: from pfbff16.prod.google.com ([2002:a05:6a00:2f50:b0:88c:682e:9aab])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4fc3:b0:89f:b166:bde6 with SMTP id d2e1a72fcca58-8beb8cc8ad6mr2186766b3a.54.1794568325401;
 Fri, 13 Nov 2026 03:12:05 -0800 (PST)
Date: Fri, 13 Nov 2026 19:12:00 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261113111202.3551341-1-stanleyjhu@google.com>
Subject: [PATCH v2 0/2] scsi: ufs: core: Fix device management and PM recovery
From: Stanley Jhu <stanleyjhu@google.com>
To: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Brian Kao <powenkao@google.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Hongjie Fang <hongjiefang@asrmicro.com>, 
	Praveen Talari <praveen.talari@oss.qualcomm.com>, Hoyoung Seo <hy50.seo@samsung.com>, 
	John Garry <john.garry@linux.dev>, Hyeoncheol Jeong <hyenc.jeong@samsung.com>, 
	Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
	Stanley Jhu <stanleyjhu@google.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

A UFS power management callback holds hba->dev_cmd.lock and the only
reserved tag while it sends device management commands. When one of
these commands times out, ufshcd_eh_timed_out() calls
ufshcd_link_recovery() inline, which needs the same lock and reserved
tag. ufshcd_err_handler() also calls ufshcd_link_recovery()
concurrently with an active power management callback when
pm_op_in_progress is set.

Patch 1 stops the host controller in ufshcd_eh_timed_out() instead of
running link recovery inline, recovers the link in
ufshcd_set_dev_pwr_mode() for START STOP UNIT, and forces
ufshcd_err_handler() for timed-out reserved requests.

Patch 2 removes the pm_op_in_progress shortcut from
ufshcd_err_handler() so error handling waits for the callback, and
recovers the link in __ufshcd_wl_resume() when START STOP UNIT fails
while a fatal error is scheduled.

Based on mkp/scsi 7.4/scsi-fixes.

Differences from v1 [1]:
- Replace patches 1/9 to 8/9 with patch 1/2 per Bart Van Assche [2]
  and drop the external series dependency.
- Rebase v1 patch 9/9 onto patch 1/2 as patch 2/2 and recover the
  link in __ufshcd_wl_resume() on UFSHCD_STATE_EH_SCHEDULED_FATAL.

[1] https://lore.kernel.org/r/20261112051542.1539779-1-stanleyjhu@google.com
[2] https://lore.kernel.org/r/59c577b6-4749-4edc-9dd9-a83f2a124adb@acm.org

Brian Kao (1):
  scsi: ufs: core: Do not recover the link concurrently with a PM
    callback

Stanley Jhu (1):
  scsi: ufs: core: Recover link in ufshcd_set_dev_pwr_mode() on timeout

 drivers/ufs/core/ufshcd.c | 62 +++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 29 deletions(-)


base-commit: e550f2b2b4aab4c5f12db89d04d8978ce4ed7b4e
-- 
2.56.0.611.g1030f0b940-goog

