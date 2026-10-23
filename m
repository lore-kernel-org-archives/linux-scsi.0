Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792758876;
	b=EmiTpZ82ggoqEReHHSWCDLU+yQYSBrZMX7CwkR8BXhqGq3bo1It5m/bCD+CBiwusNGr2
	 iERxoQbgIPYxML4Dhj8DTtac+wzMTVgSYVsoYQiF3uszQH9wD3Rxr0Tt9aaD2wB8XvgvP
	 dkP6FplhESKCXzn7Uzk0FQrY4jsVfJVjk/gXmjcobOT+zPNY5FdxvjFzgz1B3h2cXyXZH
	 /MY8W/Rw7DivCWC+OvlZqlIx069wU1yZ8Yd4wDrVxYLQ+tYpO7IhQJR39LPkSlOf9D+iu
	 3a7IbuPSaMrvpKKppLmevVZ35yZg+a/8hrD2O6OIvhlV64o9wLXoIii4KNDdwJMiTfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792758876;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GbI9dWRYHQC4FFZk8/mMBImcoolC/UhXap4+Lg16pBQ=;
	b=m4LXRzMf28Qjp77Wp3vSTFHdxW4ur3rNP6fH/i+b3x9S9/VAo2Z6HUt7jLAtLffUwg5K
	 Z0QJc/9gWhdZcXnfcqdNVPJXewaGSlNnBs95HnJRz65mBRdXXqZT2h9mVQlSAPlluc/34
	 0M+40/iFDhAd0IDp/KyRvO4IYS/+LV/oHf09DjrIdgrEGJjEUeD1utGd7CdbAuob0GpRB
	 3cafv/GdE5Kj5UpGNswtW4iJYy41oWPKsNJ0aSwq7Ip/+UwaWEdMzE4LIPQfPFS66Lhix
	 OkUvZsYrROe8oCDSKSq5u8edQQPrQ68anWQcP058Pxrk+bo8qMJ4UcVs4R1JEx91o1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ePFoj4Ji;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAA1606A31F
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 12:34:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEAA1606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ePFoj4Ji
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so473500a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 05:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792758875; x=1793363675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GbI9dWRYHQC4FFZk8/mMBImcoolC/UhXap4+Lg16pBQ=;
        b=ePFoj4Ji6UHC64tiavSfZtLS19cFHWa1RIj49Ihu0WgCjTj2eFsnrdkfPYSD0DN3xl
         gfhn9yka82e7p/ZwJZurTV6x4+I5M6k7+zBV3NCM2SYWIEYyWz9Vjt9lLNBvmXFXkmOo
         rPUA/V2XXYemSU0f8ranX3yXG5eKLF0HZ45o6NsHSCVMs7S5tr26XFER5LWndeIhtzPo
         XY7uAMvzrmYoKR6AUkGtV6ialZhpJBCVsMV6fyTcNCwaw41H95tIV1kVgXseYcAbzPyd
         ofgcIIsVMRys77aeNnETAAplDW9ALACdWziyrrZni/7WXxpUMshhY0eeFxTA35STSbba
         6H3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792758875; x=1793363675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GbI9dWRYHQC4FFZk8/mMBImcoolC/UhXap4+Lg16pBQ=;
        b=D8UcSzdqXmPvEUJq/OK1TgMjabPni3isJLWOgaZVnaYpV/ETiqkFID3def1+ms1JdH
         cixKGCA77Rvc04yGjlGhB5Db1ZmNoAQQ1yNGP5UV2X/0L2yPYQBH31cAoargfQPHTeg6
         wx7raTe2jqelS7h5EqkO6af21Q7dQBn+yddUt2nsajcgGeumaLSnhXEm4giHLs2WT0mb
         rvnTO+agGdlF7R8CAAcVSiCa8GjkvBAbG694Ml/TwVp1GWYwCkG9pNKHJu+28j48XfQv
         lfEuTkdvAkMF2GP6ZTzQm1TJEIc4sy6S4bcBu/znaOwtLzStQJE7iTImPKdtFWqV37XR
         kZcw==
X-Forwarded-Encrypted: i=1; AKwUvBz6VREoEWNhHzSNY/qhvq+on/QPprWRRWAyUfnDuLfoUYcZ07vzp3eU1Fl7AVIOcbaKBetdIpOafUCS@vger.kernel.org
X-Gm-Message-State: AFq9FYK5n+1nC2tF2idpkAmiKSYjurJF/kf8+xZXFcPqxEFu/IicjOil
	15OApuZiPoxFzAPwyOPxAjGpOf5uPjNDli+GdLDli0EUo1Thq0UWvf4/
X-Gm-Gg: AYBFou2PFMCvdskndrZerMZWkq6JUZg1wHToRzTVTcuRFJze2flIOraQW2HSlOdeff/
	oNZIsFVMDtFqshejUfnaFfDZF8IWrbJCPJvTAiqBBWJjIbYrqbBfvt94lpWdtwzwhltRIIe8eze
	000NPixwNm9gi7XzTPCAAvngIXP4uO0odCMAfOigQMV+1haXq21cHjiU02V1Vj603f5gM9vPksV
	u9CaQbFiwA4BYj8iSss0pIFoXxDLSOY/K6Z8yM7yBzVlgvao0yZc8u4O7J7NiX43x/wgrgBf1HU
	MgfNpYJz2ru4Hj7NHbxByRMdwLK0FtT3UEPOlzLGqwnwaCi6LCdD522H/Y65DcRrJ8R5dq5EHU0
	aQBFsqr8s33bafATgeERKNoleKwZxiw93XP1eVgiBxqn5QJhq2HHDjdG5owj8ezPeAifXZUyiPT
	Cv4qHac2e60Pvuq6mnWILkqwB/51jQCetLLZqPUn/lw9eOowMD2zDlvxgOohtcpus++1yviyE+f
	lWvI+X+QyBSMs7pGNcAUjdyXNNzfZrEh17HO7kipBpjAw7SZVCoO10crsbcXnVhONjrQwU=
X-Received: by 2002:a17:90a:d007:b0:3ac:9a5e:9ce9 with SMTP id 98e67ed59e1d1-3adce02dfbdmr1807811a91.29.1792758875260;
        Fri, 23 Oct 2026 05:34:35 -0700 (PDT)
Received: from DESKTOP-NM9EKIA ([125.134.240.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3addd8864f0sm110001a91.17.2026.10.23.05.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 05:34:34 -0700 (PDT)
From: Joonhoe Kim <26rote@gmail.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: mani@kernel.org,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: qcom: Reprogram ESI after a host controller reset
Date: Fri, 23 Oct 2026 21:34:29 +0900
Message-ID: <20261023123429.1967-1-26rote@gmail.com>
X-Mailer: git-send-email 2.55.0.windows.5
In-Reply-To: <a3298437-21c9-4b91-94f0-417d92045afc@oss.qualcomm.com>
References: <20261022165006.1275-1-26rote@gmail.com> <a3298437-21c9-4b91-94f0-417d92045afc@oss.qualcomm.com>
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

On 10/23/26 9:45 AM, Konrad Dybcio wrote:
> I'm not sure it's related, but with this change, do you still need
>
> https://lore.kernel.org/linux-arm-msm/20261007143716.2161-1-26rote@gmail.com/
>
> ?

Yes, they fix different problems.

With MCQ enabled (which needs DT changes not yet upstream for
Kaanapali) and without FORCE_MEM_CORE_ON on the UFS PHY AXI clock, the
MCQ configuration is not retained over s2idle. The first command after
resume then triggers an SMMU fault and the error handler resets the
host; on my device that happened on almost every resume. With the clock
patch the configuration is retained, and I have not seen a reset over
s2idle since.

This patch is about any host reset, e.g. from the error handler after a
UIC error: the reset clears the ESI registers, and ufs_qcom_config_esi()
does not program them again, so completions fall back to the legacy
interrupt. It does nothing about the s2idle faults themselves.

Thanks,
Joonhoe Kim
