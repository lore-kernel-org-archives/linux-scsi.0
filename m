Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794613290;
	b=F7oHHO3uTX6/cDb/PW+bwLd/ltQ7WLxcTHTKTVwGIbM5t/pDX74wA3cT90fpcNx/EXlg
	 myXwmTQgFtTMe2/8tudZB+wEH4E/SQjhWBDHv7QM1RoGtLLuHjgPm4aw+zBs5fuaxfoLS
	 Sz4QJEHve5QuBOZ8nZoDw5GeKlkneF4TLIPz7+7MUbCGaQlEwTX+HMOq2PhoFmEucJ1RC
	 TYWM2BWBgzrQEFBZeE+feRKB+VXe+TD4hu3mHuk1AK1W5BZc3CbM7Fev6aNVLkcBnS8bl
	 AV2f6HnvO7Kv5XcUrSritrT7A/uaBFDkgCdBRm5zxD6e0JP4FmEB/ECX9irryTc/1Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794613290;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=eoY0Ce+zIXviOGVXKcEuESzYd3gN7v+fOQcLylmkKcQ=;
	b=ImQRh4H249nR/wCwp3Z74u3+cx36WvLKl7XpftFn0gqpuLgVm2iP157GqTAe1a1OATJg
	 5TP2+IeLFvG0ESODlNrnu+VKJUr1zwLSB8AQHtVyg/yWL18vRy01aGmz8I/QYojModgR4
	 Bk2OoU6MT7Ud3FRklCniohsvnGRs2U8eM4zSaq9VNMT/CNpBISKPvM/kv1mrEm099mW6R
	 5jKQvNHyishCplwxRskGiU1pXscSVXWXzKX3XXQg+/pqZc2Ci5luuT59+Fth/IPAKGRB0
	 A86LMPTVsFZbzbndYig8KVJkyURRYGD54+gcujTCea8wu2JDiPtqWrYoatHHis/2X6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=BO1DCqUd;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07650606A33B
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 23:41:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07650606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=BO1DCqUd
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8b9c51097e2so865605b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 15:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794613289; x=1795218089; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eoY0Ce+zIXviOGVXKcEuESzYd3gN7v+fOQcLylmkKcQ=;
        b=BO1DCqUdoI5EeWNE4IxpBasbkVnQpZUmrVobgUz9Fiblto1d8zpT/tmmybzkjOlQdM
         1QMJUlLplanMObhM2eUOOviwvptfRNvDWxT4bpseKT/eP5HanAm8K7ueeJXB52BeLLRD
         3l85RP3dERYeWJq1qsLWAxbTdOuYTYDyGnBvjYCGlx4al8nJ0Y0f8RC6JytCSFasj6cq
         J4VlM4aSLJVGndSL6xC6E7sp7B265UJrXJQlAhbPdZvg8bCgF6clOeTKfAZ3lvXN3A4L
         8ZZum4FMWKCZ+f9+Ty5Su9S6A/UwPlmUtni4Tk7kY5h2U12r5ZgL29WEvLgd1kHwPxNR
         GHOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794613289; x=1795218089;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eoY0Ce+zIXviOGVXKcEuESzYd3gN7v+fOQcLylmkKcQ=;
        b=KVkRLeu/yEeAstJyg7EZREQXbMMMAHBWDIhoAqbHL2qpFoRFQcizw8eEYyZk+FvNUJ
         1P8ueVjii/+SRaab6lhbrgMaqTwGBStYqQ1KtoU/zWnmUZyDQBrXIcF2RzQ2v8da5wdE
         nE4ONZmC741mGyE5wLyOePZo+HqrWA6MGi5PIHF2DYMTcr9NNHX78BF4KIu/J9p1xJBb
         FZF5xrTSgjz/QAPrnAtjxh+QAh/Fwop4O9U0TA7GbatMoB6qwVWVf/HQWm6aiG9pj80T
         DEu8auKXGAFE9Kr+qOx2KRF6io7Rt7fdEfwhqE0B7wx1c7H0G8LQ5/0LLkY/qAxW6yW9
         FKRg==
X-Gm-Message-State: APuU4Z/HVj/nwz9C6Ok98LTQ/0Mr98mpuqT2Ors5kVUpDbipaCIoXBj7
	pFYsz1fDW5+Ih7LfjbB6Wv28FjzEWWy3+E6AYcHBgFR3VWracgbMDOxtIRRhiA8f9Jw=
X-Gm-Gg: AYBFou00Or6lCNp2XSZtLzgJGPYKqmhfT7meOx5vee8XWEZ012uLtTcK5CpCqVZjQWX
	gt49POuB48gAGbx+SN9fq7+Ob80pXpiAjFi2LHWGxUtio0eP4Csvlo7nOTDoZU8vh/YeVpVtiJp
	VMS/j1HCjOcwTA4Tet8OdTq+RJ88sKyBQnfK1pJBlwIAQkuvoFO+6ucZSyCPCGwDX3NjFeprSpH
	JfzL7JsRdCIHIEubtyWdPoFbyWsEKI+hSgDZQh8dZ9+KmKjq86VgZChmAyEfsBaHYpiJdCoQxen
	40fOhT7QdvIAr3v9C7nFqHURX63RIcA/IeTCjmvVMmp2lu0eNr0sflVDvcZfCGPW/mklpZijz94
	hPcx1Nxs+Bps57DqSyTWYEjOti4j4SaN0dCVaDGUanIHS/VLzjNRmOBiXO7njWk4jQ9R4b9MPiM
	7j8II3hwCYX1cbHZjfXxcMqDoC2JjevVXiXd1+CAdcu4J2FIjajUVVuaZtCBN8Ak3AcEmxlOnId
	RKyIucFUnalSilBWHtU7lxzdpoEl0zyJXZYPuUYha6WSh15psM2cRJlupSYSEa+8ImNrp1VnGuj
	Sc7ESyppYntMzfq3F51ejUu/OA5rfmzDSG+oNIMzJO2scLibQ2dM/LIV9VDaIDc5VgfWR6nmg6D
	mmrNPybZdNFiTBAUb/josyv3mlbZsfOi2s0cjoD0=
X-Received: by 2002:a05:6a20:9188:b0:3eb:9c9f:8b8e with SMTP id adf61e73a8af0-3f7a91e5a11mr3426778637.92.1794613289234;
        Fri, 13 Nov 2026 15:41:29 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed205364bsm1768831b3a.33.2026.11.13.15.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 15:41:28 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libiscsi: only complete a task that has been sent
Date: Sat, 14 Nov 2026 08:41:20 +0900
Message-ID: <20261113234121.397606-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113145140.282504-1-yhlee@isslab.korea.ac.kr>
References: <20261113145140.282504-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v2, which is unchanged and now sent together with
the follow-up patch that depends on it:

https://lore.kernel.org/all/20261113233938.397415-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
