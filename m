Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793082150;
	b=w2YfbWVgCcZNofyLedPWa1m2MYdXBS83UfLLoE6+2mnSjlrImVdr8Flq2442BGahIs77
	 5ib+AYUBi8HChb/nEQgJpk0l0ReSOCkNt4Q9xA/NME7z2yyzJ7W46hos2+zWg9/QpJYWq
	 HtZkCCOypOBb7MBNW3qO27w9guEOnCE3RnzIMfzPW0jUyG4WZULJ/7clyZjOoLF5xIYD8
	 VWYTaSyXip8pPvBeh6oJF9Hr+JGn44u5B+Exfz17wXBNhR0cb1/vwlFroe1fYNtFONodk
	 L3XG+w23W7RLXutx3ShVe9GsthsA3MGV9RpyK+u2VefAzwrkf7FZYiK+mw1ICCnx35g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793082150;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=pb4Br9/vfh3JVQQfd+eU+eg6IJow6IVC4FUCyw6gp8Y=;
	b=wPbZVhLQYFHRbHe1bomZJjwK6f1IjIKyUavblh5AikJJwZvHH+IlsQkWba0WGCX+uVbi
	 p7L4Nb14jMxw02X3s4zrzGYaCqvRZ96OsJKfR247e/ll280EuH76kMDnO1hnoWOfreIxe
	 ky5efbg2gtATob/B8gPdNpOozmLHrScnh1lvDPV438DH8Sswu6SweRl+bzzl5mY1wPir0
	 RC5o0pVWbuBAmIQXaOyxoOBusg2vIJrjITuJUNQofaEmUfuTGlLAk1ifchCW57VtNVU23
	 7LrmnVgb8rn1HwKg1U9PbazGBGRkVyfp2IJ0gBpCzbNe/xqYhV2bqBc8GucYlKDCT2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=FGfPa3OZ;
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09488606A320
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 06:22:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09488606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=FGfPa3OZ
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-89f9fdbabe1so5314758b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 23:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793082149; x=1793686949; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pb4Br9/vfh3JVQQfd+eU+eg6IJow6IVC4FUCyw6gp8Y=;
        b=FGfPa3OZPqu5KX+0CwdB0xB3NYxeVGxztvP2JFEmJuhKsWM1/1A5qvWsqJP1vUWFDC
         mz97b+0aS9zkQebuBxwrBSGXU2YYe7ZAzp9s9kvk0o3uM3IrqyobT9XzNl8kA5P1VtfP
         YnZp3MuD1JVVEletQKD6vZ+iyT8IHXJtDLzTq8EcWivPyKZEp8HuGRGDu/PRW+YRMtUr
         gzjR0NTSK0qYdukNjpF6TyyWGZJ5RYjJt1eSYNjk0IkeLjTPuOz27nESgTork1gutSad
         9Wo8tsYWeQ1NR8JDcfBNEmSuGkLqi3+1C+gZbxdVVAt8tGSZt1Ol39OvxZsY2W162ktQ
         /kOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793082149; x=1793686949;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pb4Br9/vfh3JVQQfd+eU+eg6IJow6IVC4FUCyw6gp8Y=;
        b=E1nbTK/S2aO01m8l8uy79+W47jTeosNNCcrpU6SEfbvmVMcOdlQaqx1Qa9Z0a1tNVF
         W6ZSgsPUfc1CfaFoKWrWt2kTq6/SHnXU0VGFREVNEM9HY4VmwD7a9VLM3z41uKUWI5JY
         9lCRBkbgFChRSAfv+CKS7/FVuL8FNAPuHDxEAf25qbOzwaJtrOtBOOZok6qkRVMIgkK0
         xuH2Pzu6ynwvkVrpBXf0qNFnWOUpPEo8ECvW26PLyBFvG1i3FLZUd90tufP692SlL9eP
         E+XKWFL5YbZX2MjLgtANqQ+2g/X5y4oX7J5ZKvcX8tx2YmZMktn7mlyePj0/MTFrhwlQ
         QeFQ==
X-Forwarded-Encrypted: i=1; AKwUvByFq3CPSv28u9ZRyMsA/Km8j2urCYCGFbQMOCV5iRiHkBHhnfTC62+ecRBfOQ6afD9qcDmINwPlNZNW@vger.kernel.org
X-Gm-Message-State: AFq9FYKbwdmfkZaMl0x7DxfAiCIsiTbEPBwOt42Ic43UL8Cjc7clPG40
	wlkaG2WCmeFdA4w+4rbevjgSNska3J/StQgDhF8OuGHnvVnKFzYZ1vntcnovWLi1ryFRPnXdyz0
	F5dDbPU44Ar2gp5zVt38PWw==
X-Received: from pfbbo7.prod.google.com ([2002:a05:6a00:e87:b0:89f:dd5e:68c4])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d01:b0:882:fafe:9874 with SMTP id d2e1a72fcca58-8a368aa1b6emr6990163b3a.31.1793082149110;
 Mon, 26 Oct 2026 23:22:29 -0700 (PDT)
Date: Tue, 27 Oct 2026 14:22:27 +0800
In-Reply-To: <5adbbab4-11f2-48be-9924-9d14a06d0ed7@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <5adbbab4-11f2-48be-9924-9d14a06d0ed7@acm.org>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027062227.1955867-1-stanleyjhu@google.com>
Subject: Re: [PATCH 0/5] scsi: ufs: Fix device management timeouts and runtime
 PM errors
From: Stanley Jhu <stanleyjhu@google.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, Peter Wang <peter.wang@mediatek.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On 10/26/26 4:26 PM, Bart Van Assche wrote:
> Patches 3/5 - 5/5 introduce a behavior change: a failed runtime suspend
> sets power.runtime_error but leaves the W-LUN in the RPM_ACTIVE state.
> Today, sysfs, BSG and hwmon accesses still work in that state. With this
> series they all fail with -EINVAL until the error handler's
> ufshcd_recover_pm_error() clears the flag. Is this behavior change
> intentional?

Thanks for catching this. The v1 cover letter and commit messages were
wrong to claim that a failed W-LUN runtime suspend latches
power.runtime_error.

In __ufshcd_wl_suspend(), every runtime suspend failure path
(ufshcd_bkops_ctrl(), ufshcd_set_dev_pwr_mode() and
ufshcd_link_state_transition()) schedules error recovery and sets
ret = -EBUSY. The vendor vops->suspend callbacks return 0, -EBUSY or
-EAGAIN. rpm_suspend() only sets dev->power.runtime_error when retval is
neither -EBUSY nor -EAGAIN, so a failed W-LUN runtime suspend leaves
power.runtime_error at 0 and runtime_status at RPM_ACTIVE. In that state
pm_runtime_resume_and_get() returns 0 and sysfs, BSG and hwmon accesses
keep working as before.

I checked this on QEMU, with and without this series, in SDB and MCQ
modes, by failing ufshcd_set_dev_pwr_mode() during W-LUN runtime
suspend. rpm_suspend() returned -EBUSY, runtime_error stayed 0, and
sysfs, BSG and debugfs accesses all succeeded.

pm_runtime_resume_and_get() only returns an error when the W-LUN is not
RPM_ACTIVE and runtime resume fails, or when runtime PM is disabled
while the W-LUN is suspended. I will send a v2 that drops the incorrect
runtime_error claim from the cover letter and commit messages.
