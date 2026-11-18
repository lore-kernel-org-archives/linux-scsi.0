Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795002028;
	b=lX+Tvvpg4WlSZP66hT7spRPnW3ipWSAUOB/yrAc97h7bvEkMJ719TvxQ60JD5RtlMudq
	 QFpC3cI31Sw28ps8VPi0tk7Smoc4OGpWE4WtesBE4RsN2SnXm0u9QvNlDEswJYCY9ASmd
	 FlHo7rpTbyhGYqOF79wUHxIuksKQ+O6pgqIcFQBfTZ/shyEULu1dpzQ0JhlmQ+NSJzlr7
	 UdvDolWWdXfjJxTUDFIzNJjT66U0uTenM1L07WxINEMW3pwiB80bYCwx51gww+2euIDR9
	 pUmUlZ3xbxQL7XXhOY8rHdJpTOtjkCVcB4zza1wy4xSneDT1gzW8fGtNdkygbzB4pAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795002028;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=joKPrh60l9RacrgiLaA7oi1DDDf9ZOY+t9J3WM0zaLk=;
	b=OaL7AevBocJx0PIo3QA4Zpb6PnZdLZ0OmWxnTI6GVbZYGU8RTm4oKWIJqpyaAfV8lMMA
	 bfNKsdzzJvV381YT1xcrvdJhmgz8fKbNc/E7zzlqjLdKnmWN8fBLS1mglZy3qi1CKljBu
	 2+qF0BPJgEBne4dPXKE5VYq9eTg9cKgUFlWfRfMyI3PuqSv1ahc/2CXpp+E5stEyXeumz
	 5Hlu7a60TGBkgOdJn+YDX+zD4JO+XHWuw3I1FzaF9Ejd0UngXCV9bturFbGmD+pkwA5Kn
	 EjMMsrtNOnLj08zW1rpLFLNiKHgoARqqU0IBsC199/qvuOckA95O7es9oE43Vcvib9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Ri4FMxE0;
	arc=none smtp.remote-ip=209.85.215.174
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD7F606A325
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 11:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FD7F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Ri4FMxE0
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-ccca948203aso573084a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 03:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795002028; x=1795606828; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=joKPrh60l9RacrgiLaA7oi1DDDf9ZOY+t9J3WM0zaLk=;
        b=Ri4FMxE0ENmt5ExlIpMFuucBbg8Ff7sKAf10q/8ianryZQyKtbi3YXq+ktSfczLSfu
         IctLlAj/ddfPqpMpLdJSQfghV9HsCVBQXGWEkWXn72XaqMlG1/eCJwwmgrY6/N3rntfN
         ZfpbOVhacSiGr87oYY/VR6SGrjRQ6qgHuYNfoBwiKRW/cuRuT2NWrM5Mu7Gx4VZAQNMu
         gxJRzVDdgVqV3Xko6LFK3vws1WamrlKSqKm9s8WgCUZWPHAPe/9bwG6Cn6uK0NqjWDH0
         EzCBn00mfADqxTRlXynqAz78TtowHCugr1TZsMaq4UJcPOVvGtmybUrhGNu/nFBP3gme
         pEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795002028; x=1795606828;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=joKPrh60l9RacrgiLaA7oi1DDDf9ZOY+t9J3WM0zaLk=;
        b=xX7HLazpHnZ7pc22tyxl5fLJcvWimOfN5RscppiiC0b/xQkF/izDVjWUbKERZjmdvZ
         11+4xUGn4soSGMQbT7vHmTVZ6WYjlCFnv2Xgx5VTtu+tJZxe8KCp4BnLk5AjiYVJR1lF
         sIVSs+AX/EFWy1Z+3U0Hl/YXHjpJo03ShAgYFiRZKKPYD6fkM6FDsgh8swhwjKOy5ZyA
         5YtPyCSmPNLBKJo994vyqHGxYZUKaj229JyQFdJSvlir3IW9Evax4d4E/RoGeiZpEElX
         v8jniQda8TJqcLXLbk5GkfIvYqTqk+7z9mFIav2oB/tneK209eyGTB57OWYzPAi6HH86
         cspA==
X-Forwarded-Encrypted: i=1; AL+hErFtuhROeoIsOmJwIldWATCvbtFyN7qS326XoqKuSv65aXMxFchEPgPjrIN5MtpwzaZq0eOulMv6e5B0@vger.kernel.org
X-Gm-Message-State: APuU4Z/0Si1wvwXc5xvegIUlpLs/yxveirMk7OUlWgUszH711Wy12DWB
	rLkfDMO288Iq9NtGP5s7iFohRaMIeZaFSv/XdOmFx5B1kksvnV2xi1GJRezqlviQmqg=
X-Gm-Gg: AYBFou3O6N459xI5tE0GjQ6Szbn21snn/dnX6tqoKFKkXB2VcfVOMcqqHPe1CsqImnI
	e6D2KfM7BLTElsQ1gl1y/3g48YUaY4PiVWSNQjlGVvz4Cj9wIDCJuJKlnLrERCBKcgR11PPZ89Z
	y3fK56eVNuPHJMabWVLklYemoEoPfDRUSwk0cvvNtGn9X5jCqwtGvuklWYI6mMPcz4UWt4CYdyA
	KpTE5hFpQEDtbGgZ87xdGuXqw3zuhCQc04oNPY5UD/qGLjdNEVZ+QaqhgUaRTQk5XdFSEUJsglu
	z2UKBOC89W6Egw0TmfZ/QP/iVw+q2cOHR+RvvpV2lbMTdsOl/JGoBA9KSeYy0RY8ViaphCpClUU
	k7pFLi5sdSmzJFpm2KPB7wIwQCIiV5UHgWDixVP1gNgmGBsnBUqHw/qAIHhkWfuVk+lqSCUVmNV
	7gIeqiVflnZKoS5L7z/o3+NLiIOOT5n8yxezIFbzzGXSzDQA7tRt+eQMlhoMg++k0NetGWtcIAp
	p+PTLNN1OB7f6UZlkrkCk5bgDCzcyWlHRfxudkaJE2eIPw4tfoqrxIK/sN6Y3Bmqu3yiv4YJR5N
	YhE+aFBv8Y04m6M+xnfeFfrVORp/vvbTYHz13zFpIQCEMz2H5VTxF4UlK8CwGJ5UGlEmuPqZsEh
	HEuYjpfn0rMK9annyAfg1EkftEMRgNmMWoUU0Gw==
X-Received: by 2002:a05:6300:6690:b0:3fa:988:1ba7 with SMTP id adf61e73a8af0-3fe86bdc721mr2207986637.11.1795002027791;
        Wed, 18 Nov 2026 03:40:27 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5cb35db4esm1038189b3a.35.2026.11.18.03.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:40:27 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] IB/isert: finish a Reject the target core allocated itself
Date: Wed, 18 Nov 2026 20:40:19 +0900
Message-ID: <20261118114019.2362132-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
References: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v2:
  https://lore.kernel.org/all/20261118113905.2361969-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
