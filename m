Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794568452;
	b=uoJu4r5cA+ldLNLvpbLk8xJMPSPKTU3kl8WtcRMX1jX2A8fmFH+mjgLcb1QQ1FkaOqyO
	 PJiH0lyRJMq6+QQ6nJtxVdO1p231ZYqVQBMqUq6tHb1+UdNeIdN7ruak7CjyO+C9cwvuz
	 b0vj8Mt2Fkzd3PTdXnCxTXi+fWuM4gzwOFMEL6KxXjTTCl7IUgJyg9aVmAJo4dr56QECs
	 OEHU6YiC6oB2a40US3sko1Odhaaj2P8kK+fuXmH6qnqIeWL8J5VVSEjd126NWuXZuVoT4
	 88+DrsWW7ZG75gJXQDddaC4Zbjfg6mVYs6V16GA6GZgItICWTXtfdJKA3J4rO36Oqsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794568452;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ezeDFgt+7atYRovKBFaoESCiQDt0qKhUHXV+O9nHsvs=;
	b=KB/NkPFgIDqA5xZD6tzZpzMp95foCG9MS/Ue307ejaPjquqIUiAICH6V1xsXJY2yxUql
	 DD76/zu5LEtj2b+RVPzgebLwsIyXLWUFt3PO80CXWDNGaIHmG1WwXLj7rilZ5RfX1L8HV
	 QmVbN2PEhzPQFxUEqDuIunJOgDadQ+YI8Av1ovJnYiP8I1ks7n+tlI7eI4sxSTTNT98DV
	 akyVfnMlc8EhuTEUmoonI+RyCT3PBLJ5DrcSrX9huixaFT433Wddnfyrp7ToFP58rrmBa
	 u0tOixW26wo/k5IOncCYfI5d6icj5BBoHnRw0Uunu8zzCcz9ldz218xOpQbOQmTrdOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=A12qJRHs;
	arc=none smtp.remote-ip=209.85.215.198
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33B2606A323
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 11:14:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C33B2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=A12qJRHs
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cddc4bde4adso337953a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 03:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794568451; x=1795173251; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ezeDFgt+7atYRovKBFaoESCiQDt0qKhUHXV+O9nHsvs=;
        b=A12qJRHseNOEaZYx7qBqIgqcM72XffvjFu773eJzQFdnDXjLpWlbsW65cLMMiylJUC
         5OJkBoZgGBcppTv0mukKgKItiPpleXt3HDGGYgZtbFDM20YjJ+4TU+SVd6ya7C+lTpV+
         02q++QeyNAK8alM2Qy12Vms74lJeZ6llIWGvHkOgF6EpDpwwcmNBYLh5MknmvbTyC7/K
         kDqi/zZRhBREu/AGckP00Anj0d1sxzxMpr0oL+HoKoDKsgwEGYmcjFME8uVi/87r2HlN
         1r72D0fAksCrahsOYS86wIcJMh+3Oh+pigF7QAPQEF5lbcL3OoD++vz8qgo22mOLDROr
         l5Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794568451; x=1795173251;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ezeDFgt+7atYRovKBFaoESCiQDt0qKhUHXV+O9nHsvs=;
        b=U8q/ot+t3n+RS00VYQSn+7udn+z/LE0iCXzqKR+uoUeU8nszF/aaTQ+ETnxG0b6Zs3
         FC4lKT8AtRPvQ9TapMSoLnUPn58EyDeqrsq1Psa1SQ2Aq8BnFKfavnFREn7KeP/RYr5K
         JcXNAeJrOVxxBplQd9o+OW+t09eyks7958iyMEud+TUBOSAhpe7gsNlnavdi8FoOvGJ5
         aJTG3IllObJwnhAaokul8M9nve4xIiinsmxAyUYUF/UMsA/ixZ3CcyNSBvQO1HIVZNHh
         HfziKXmo2jLW3+P3L81scQtfkBffeBkK3BhSBOyExf1zaP7zC7L5Ktf+HcsIBDfzI+7n
         scow==
X-Forwarded-Encrypted: i=1; AL+hErH3Xt7o7Tq2IBLWbdvfvgR6M0oyfY+7NbJzeBEO7ok+jxZ4PGbSRKKJoR7+2TWcqBr+b6DQoOaGoQ41@vger.kernel.org
X-Gm-Message-State: APuU4Z856gsoEXyBGSz9q1UCVsS9FTOSaY53lqLWZifH8mCUeD2z+f1Y
	6jHAUqry7KqAKckfCy1Nf4UxWX4F3E697VAOy3p7+SeLtzvTua77LcU8rOqgamr8EfcNJ7PKyTh
	dva9hcnkv42/gf9RAYWNENQ==
X-Received: from pfhk7.prod.google.com ([2002:aa7:9987:0:b0:8a0:941b:f002])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:d043:b0:3e1:dc9a:56cb with SMTP id adf61e73a8af0-3f7a72babf9mr1889436637.17.1794568450840;
 Fri, 13 Nov 2026 03:14:10 -0800 (PST)
Date: Fri, 13 Nov 2026 19:14:08 +0800
In-Reply-To: <59c577b6-4749-4edc-9dd9-a83f2a124adb@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261112051542.1539779-1-stanleyjhu@google.com>
 <20261112051542.1539779-3-stanleyjhu@google.com> <59c577b6-4749-4edc-9dd9-a83f2a124adb@acm.org>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261113111408.3567353-1-stanleyjhu@google.com>
Subject: Re: [PATCH 2/9] scsi: ufs: core: Defer link recovery on reserved PM
 command timeout
From: Stanley Jhu <stanleyjhu@google.com>
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, 
	"Martin K. Petersen" <mkp@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>, 
	Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Hongjie Fang <hongjiefang@asrmicro.com>, 
	Praveen Talari <praveen.talari@oss.qualcomm.com>, HOYOUNG SEO <hy50.seo@samsung.com>, 
	Brian Kao <powenkao@google.com>, Jens Axboe <axboe@kernel.dk>, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Stanley Jhu <stanleyjhu@google.com>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 12, 2026 at 07:19:32AM -0800, Bart Van Assche wrote:
> I don't like the approach of this patch series. I think this series
> changes much more code than what is necessary. There is a much simpler
> way to fix the issue reported in the cover letter: instead of calling
> ufshcd_link_recovery(hba) from ufshcd_eh_timed_out(), remove that call
> from ufshcd_eh_timed_out() and instead call ufshcd_link_recovery(hba)
> from ufshcd_set_dev_pwr_mode() if the SCSI error code returned by
> ufshcd_execute_start_stop() indicates that the SCSI START STOP UNIT
> command has timed out.

Agreed. Recovering the link from ufshcd_set_dev_pwr_mode() is much
simpler and avoids adding new driver state.

I have sent v2 as a 2-patch series following this approach:
https://lore.kernel.org/r/20261113111202.3551341-1-stanleyjhu@google.com
