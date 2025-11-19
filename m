Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AD6304967
	for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 06:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763535423; cv=none; b=VnTOAluaOdjNx0+LNxow6Ou8gW23Hx8PIqE2kDMW0gkkzSiw/evuVa2FJFcgAK0EGdYoOpHRHlFoTLvOHPP1w/yeqa0YC2Yt6RO2+j5OaPekMpgKASJzwCpErcuIRi5ZK35vkAiOsAdK56frmQ+UiQZaJHfco+9SkjEktw7Mzoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763535423; c=relaxed/simple;
	bh=f+Xbq93Jqa1GglMCTJ3Ab2B1j85mBFmSLN2S6spPTW8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IzejJJEIgwDbNwfNwSZd7+PcWHjVaCSjfUb6IK0QTrx75+gBAzaELne8Wzo7QTs8/af0gVvWdwQcAiBdlT4DYQOIN19JrHb3W7eFTtz0abS1V1nRciVQx+fBFUh/jKTzd+DntocqybfKWRdDr2+LrTde+2yeG45MxT1LefsiVIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nGAv2YTM; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nGAv2YTM"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so5542581b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2025 22:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763535421; x=1764140221; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f+Xbq93Jqa1GglMCTJ3Ab2B1j85mBFmSLN2S6spPTW8=;
        b=nGAv2YTMdFARE/C0BOvphrGuueDIWaFHSvmGrRkoIvLpoB9l5ds4FH4efiBgr8oG6m
         AV8f4GojmeaQMXy9vmq4A2KegUF6WNemwk9aqKR37Dve8UZ4/4tFFQ7/mGJVHw0LcEdv
         e2okKnQsu/8vEHazmcGz1TDeWcksm9CTU0ydYNie1DgIcUCXgiMzUFIfN0ZdEEFk02II
         w1xG2fhfJ49R5f9ldDqVIxaklJVM+7EV8OXydK59Y9KcGZSkd0CUuAYEf3zC7zQsKDfW
         rM0GpOsxgZsCM7kyVmdFKBFS9aHmTNESfy7N9jU7AHjdjz9El+CnXvIVmNczRVA9r1Oq
         zjOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763535421; x=1764140221;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f+Xbq93Jqa1GglMCTJ3Ab2B1j85mBFmSLN2S6spPTW8=;
        b=MIarPF/zTvR7kVoMpWAMtiZyoj0fuvDvgSAwvwuPqL1usUXK3zYQbWzyBYOjf626iw
         ffu4fqqyjWttGtY0wbTKs25TXruu6gpeQSIvt8eB8wfwYUM2wOQQEyTy1pSIBIR1xA8M
         r3/E78/BP/LHGZfe4vLq03wHjOGhfv+ujRqyv7Zlz10PnZwIaJcE4oqnNRfa5QVpSey3
         yBNZIhtXQJJA8QE8PKJxtl0YoN/2HtOrcxMv2ShQtsKNicjCD3oEvUTQErNJiQa8z3zP
         1Qe/uAeqg1Z1NXEJBCl6Tqeco5udMCitC1T06DnZS0ZqnvH/pDHovNp4xEjvWJLqoLno
         V+8g==
X-Forwarded-Encrypted: i=1; AJvYcCVfwpRbpyNR5Bpd+AU9Ii8zT/PzRxEzZ1EoXPfk8YVEOXftYQ3b3XEcB2biibekTdFLjm2XZPQFG61o@vger.kernel.org
X-Gm-Message-State: AOJu0YweLPW+CTdiC94gdsDN/RVrGGJn8RPnEWxjNykjqqaxse+T8XxG
	0axFoGudjSmU+CX3uKZeRy1xuSG/fD1CkUZFMtjEGXbIZJnPS5KeInue
X-Gm-Gg: ASbGncs+5YwskL198b8La2LuY+Hhu5VXHHMX0kz9KuQi5rtjydVE8CB2lssYCokxV9c
	f4DJ2zCgFLHXcYWlTmoyfDXjN0DDkOGVgldy01k9NappSLpw11ok4gLh7pWKHqFe4gDJh5crU9q
	itLsEH/dsS9pQNfMWeiVwXWun/o/FLQeILddTsqJIysy3roqT5Q5GKICCugaEJYannm88nG3k8D
	07hMGXWA7kiRbKjRlRIdMAXFSQJFCutvg8LFDAnrhfytLxz6nNAaIRrHp+3ThjfSyyR7iYoc8Fh
	6zyY9hNP0iUx4TDHNSGDDeJpPVWMy2M/wCIdQIkPfT2ai6N+2Tt4/yHJbcuScCTrPn2GYm8kLlD
	umIxgYQLbdizRJNjVU5Z9Ee1Z/s2/ixHzilRjN9+zgRKmaKb3LbkYHZ3JI2kYBmSXEJP0C0IxYs
	fpPshRhY/yFIfCWZAuo/Z6XpvmUnhjx0mH6Jh5OMy/KF3hdBAm4NfB
X-Google-Smtp-Source: AGHT+IERGkisUKHUwsOjkdpflgk7YzL2d2g8MYKyQEpliF7eLvTfwwHOMqHduRY3E4k3gg5i/JsKmw==
X-Received: by 2002:a05:6a20:7283:b0:342:873d:7e5a with SMTP id adf61e73a8af0-35ba228d01fmr22648983637.36.1763535420725;
        Tue, 18 Nov 2025 22:57:00 -0800 (PST)
Received: from ?IPv6:2401:4900:60d7:2218:52ea:a17:db14:a44? ([2401:4900:60d7:2218:52ea:a17:db14:a44])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc36db21e8esm16856928a12.5.2025.11.18.22.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 22:57:00 -0800 (PST)
Message-ID: <231f839b3b567f16360ad2a24f51add1d40ea575.camel@gmail.com>
Subject: Re: [PATCH] scsi: fix uninitialized pointers with free attr
From: ally heev <allyheev@gmail.com>
To: Dan Carpenter <dan.carpenter@linaro.org>, James Bottomley
	 <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 19 Nov 2025 12:26:56 +0530
In-Reply-To: <aRyBI_j77mQaQxgT@stanley.mountain>
References: 
	<20251105-aheev-uninitialized-free-attr-scsi-v1-1-d28435a0a7ea@gmail.com>
	 <6d199d062b16abfbf083750820d7a39cb2ebf144.camel@HansenPartnership.com>
	 <f6592ccc-155d-48ba-bac6-6e2b719a5c3e@suswa.mountain>
	 <407aed0ff7be4fdcafebd09e58e25496b6b4fec0.camel@HansenPartnership.com>
	 <f7f26ae6-31d7-4793-8daa-331622460833@suswa.mountain>
	 <bed8636bc4d036f4b2fe532e7bb4bb4b05c059fc.camel@HansenPartnership.com>
	 <aRwPcgDXSE9s4jKS@stanley.mountain>
	 <9c62ff497aa00bcdf213f579272d3decdd22ea34.camel@HansenPartnership.com>
	 <aRyBI_j77mQaQxgT@stanley.mountain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1-1+deb13u1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

As per the ongoing discussion
https://lore.kernel.org/lkml/58fd478f408a34b578ee8d949c5c4b4da4d4f41d.camel=
@HansenPartnership.com/
, I believe there are no changes required here

Thanks,
Ally
