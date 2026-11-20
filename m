Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186820;
	b=mZ6+ZH6knX0Fm9uAp8jH0TxwRwuPm6JD9Z1N9LSVfcHP6at+T0pqvCKSdo5HQcBOBO5p
	 TjwDrEMCIGPhDRN+GHvKePsVDcgZ+SFKPh693H0GMclaIaimIxlQ7C+bIOd/qoNDArKP3
	 W+z6X3tj92yVmvdK2xfheCFu02lZTUuBiiEL2HFdbCZZjfLpSvp3ZtQNQC4RW9BdW3Yha
	 JTECh8ZgWExsva+X6xYd4aVqiUNWdru/+Leb2hjBnlSRcbnuwdz3Koh1pTc+FIB0jWJ6i
	 l8aV1ELNOnq3DUEft8okkxwdsEA/7sX8d2GuB+nv80TeNbfrJpK/+eY1BE9qi2NZX1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186820;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pEW6L5/3vwL8JocGYWFqUuSpQbz1WLUbXyb+gDrb1+I=;
	b=Jlo9IUB9Fxj3YxO67q/H+VwrIXUpPck7YpfwV3nxeMzOdLS185/G9LXeuR1Ok33W8X7y
	 8zWkuy+r9uChoN5EIZS/my185zDhekXmScU2krDyJXkjy1Eg5Cyh2pnlMdnnsRiKUPNiL
	 s3ElKVv0b9qCgH3igSTLsYLWfUuPYSs4xecAlWNMXqZC/IEaf7W5EK40XoKKKpjmWfw/e
	 +3ftnM4FA8Mbj6r4q/7E1ONjfZvg3Ws2q6Ypb08S3faQHnIK7YE6P03HH+RThcYzXe6eV
	 x6Eew9FOzLodxeD26wL7vvG2LhMXQhJIaQkEYKMNNXPg6bhTeJ1HGe4fKN9KW0OrxKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=l483reJ1;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275C060A6F64
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 15:00:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 275C060A6F64
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=l483reJ1
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8c700d6cc0bso1212034b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 07:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186819; x=1795791619; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pEW6L5/3vwL8JocGYWFqUuSpQbz1WLUbXyb+gDrb1+I=;
        b=l483reJ1HSfaBFm4fY0MTe/lry4/P5sQoGDW60yBak29u2MjUQUk6jITVev4xtuvVK
         HbpRptwY/VYAKrKehfe/lAhEDOSd6+0XcSopFWIZQHIZBJHK0/jAOl8ZCd1oRWH1XjW3
         fIIkhhhxrttINQ2xTjIw9ryiJM8IG+e0rcBD+tWlPC2wNFGl2K3Mch8cQq1ePQjewAfC
         WqnuxjdNZXnbMNALHVYSA+O8CfC5c84VqT38rNPpSHD9jEF25Et6dlSr1B1hXoIN0kBn
         1MQ23u2q7eifkTSgnocjKLtDrLMpC5CuDG4igoApUtDz4UBoIrK/7ITdz/heejG5PpmB
         GbdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186819; x=1795791619;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pEW6L5/3vwL8JocGYWFqUuSpQbz1WLUbXyb+gDrb1+I=;
        b=q2SxqJBiz1nJx41vVqO3u0NO7YfENywyksT4GyiMY/WCTVYZWBpnh6Jg2J2HbsPe28
         Agimx6TWRyYrHtxc3hJHbWMunrjume28GbuTD1FHKcULeMdzA0Xy2BCQqvR0tQTZxWsu
         CaEla1IWhoPK9EmNRBoeKuf59Sds6ub5WmoC4tjLwUKG4470rSmGTnZ8L8Tk2rhNVubI
         rY/qWJF7gg44gH9RDh8v3R7WpSyvzdkYjnmJGRiDAFLm+GFPXEKwoYpJH+BDL/Ln3fdC
         iWUaYeF5VfJ3kjlmT9sGe8lyabCQPFktu/c+IjQCj1CnVgT/QlIOo0lH4MntP0P1aFxn
         M69A==
X-Forwarded-Encrypted: i=1; AL+hErFXPYUXUA1WlLdKBg37LenCsFS+FwXcubk1cjd+4JCE3mUGxxQjzxZ/3GUSoCEbgwBUrNLKZjE47LIJ@vger.kernel.org
X-Gm-Message-State: APuU4Z87DglYU/8I0lZlQUJpo+mMdaNB33f6+CpLWshPTr6RzzrqMUvV
	cmyfalc5QcG+Lc/flcBh7SXYKzpYydpkmLtC23f8+ZQsmFeIr0EdTyAvV6ta4zTwezQ=
X-Gm-Gg: AYBFou3OZ/k0uR5aH5rO5bQkzYVrk24ovWNW0Hm70MmhWqqnczuhbuMSn9mBoXTaVKg
	EHHz7pVVwofVmo4psoibgqcPAXw4y5+XYI+1WgHn2iLmCrMYAb7g1Qq74zBSgyIzmHgJudTk7cW
	QQHz6bdqBTLuMSe5vJ7Wif32w46eapXWXKer2adWs10snqFzb7JV3Xut87ESTu++cGGwcc6oJrx
	bDWhCxNTFHWKtPaeZVuJ+BVPOltSrdv/5TIhCqTxewhJBk3afN+A9p8Vw5nAM+O05gcht247tpu
	kfnC+QBfDjsg2u+WpcUUvJ94IeTeastmM30qgWmu9l7ddSKMYpJWVlkJ03PYSw5EbRg2bXdl9p/
	FMDRX/KsyeiDdI2uXuPSqjoo/Lb3uRBMEIwWCUKjDX5YLsjAXpJDTGKnQbO9MynO9ZmDmpT2Cqs
	BHhb8eiTzEDio6Tbb+y4jM5OFmCeam8NLRAjBbRBxFmyJ7WOsiH1mW0t7PkRymdaGj/A3aRI8ss
	otEBO9wV4UVLWNyvhvEq8vck5yYtLC3i8XC+STi7Dp3yXpbESJmkNCq5KfNlwVT1h2dfV56XJn9
	XXAzVjhWH6cOMnniWvA08bWDkekUKfz2meEejj1JyoKLR8QBqrOBtExMYaEHje3A+OAjJHwMwhq
	nTQ1MDpfKkbXfUvVrvYuE9Y9C89YXEPcwgSkS
X-Received: by 2002:a05:6a21:3b8e:b0:3f9:16d6:f227 with SMTP id adf61e73a8af0-400ad19e5d5mr3975394637.10.1795186819395;
        Fri, 20 Nov 2026 07:00:19 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfc80d4sm1462545a12.6.2026.11.20.07.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:00:19 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Sat, 21 Nov 2026 00:00:14 +0900
Message-ID: <20261120150014.3128138-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014011808.3479480-1-yhlee@isslab.korea.ac.kr>
References: <20261014011808.3479480-1-yhlee@isslab.korea.ac.kr>
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

On Wed, Oct 14, 2026 at 10:18:08AM +0900, Yehyeong Lee wrote:
> mvumi_hs_process_page() takes max_io, the two command entry sizes and the
> list depth from the firmware handshake page.  The entry sizes are u8 fields
> used as shift counts, and 1 is an int, so a count of 29 or more makes the
> << 2 applied to the shift overflow an int; a count of 32 or more is
> undefined outright.  max_io is a u16, and the sizes derived from the shifts
> are multiplied by it in mvumi_init_data() to size three unsigned int

This is superseded by v9:
  https://lore.kernel.org/all/20261015045213.3975845-10-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
