Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6971B4A35
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 01:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790040421; cv=none; b=CBgggFvY3Jk6NANE7MUwS+ZhX/JrbB3HEd6zjUiQHk0IUMJd08w33JJBQQ1qSUIcKSYG7cTQ5ZlUVrl1F81ktxrMZ3X3nPsTVoL2iphqbn1dDgx3aW1JVDK3oxvK3uG7FCgyUKGFaV2MtiW32g+oULHpiueiHhgVhiYu+EzB6q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790040421; c=relaxed/simple;
	bh=zx2qeK53W2QWDW/8wyrY8VPuPvJyLbiNrQlZ721NLu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmb/Xrge0LazW/+B1nBsKoZj+Y8qdJvYlxHW1nB4xMRXkbCnduDk2x6g1wPpgQ8JPwphjaf4snMQTDNlYBirb8fHjk/IkjgiECWb0uacjMY6E9l+wPO+9SQOmooVtHhZJwvfhcyf9I0aLut5k/zJ+Nz0gbs6F92cv6BVug+UX08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=PUfGeH9N; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="PUfGeH9N"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccd4f99dso3853686a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 18:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1790040417; x=1790645217; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zx2qeK53W2QWDW/8wyrY8VPuPvJyLbiNrQlZ721NLu8=;
        b=PUfGeH9N4bagfCstzvBdZt3VrYdUhBEuG3VC6exMaDxHjVPzmDCucXhg+tLGBWD0Ye
         9QgI79t1TEA4p3ww2H/ZovKVCE0I1X2dQX/0iBShgRQleO453CeKepDOVsb6t8jKCPuN
         Ky/Kqp98izOXj3xqssZKuydjm4aJ0VwrcgfS1na0VK4NZTIrIxPgJ0iZxXvTqzqeNr7B
         IpJ3VnpQLoVfvu0MnEfvyZuC8EFSfQ2VEhOcYyjLKhRtkfw617e0txSxOR9rVPd7Oaqm
         0tWdXSbOSJJ3qY53IuY2KWvgrhZtlAvUsRnj2mDDzewa19thApmAuWiLR8ggufMzI/Cx
         TIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790040417; x=1790645217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zx2qeK53W2QWDW/8wyrY8VPuPvJyLbiNrQlZ721NLu8=;
        b=AXamUtxzzxotwhajtCoOkiFvDqHh5q7Vg9ldLGhlmBroRKWDwq2uY4KnPN+5lxlZ96
         neQ0zjzLQrUjgKKyDMDHjbiaYHAokP70KTCf7L7ySjJfazdEm7pp8UlFslQiRnacKVCr
         CwjGcMIZ9rbcO3Hwkx/n+PcE7l8swarjvG7bwZ/00C4g+Yrq9n/1o40/cEgVDgE0cdbc
         Fchr4hH9HgRDIWHG7xbsr7pkW+RIMflBUn99AFwy+htQznTUC4LvmvkrOSLRoma5yrit
         8Jyi2kbU7Ly9HNTEH3jt3BVWEDgrMs2VZaIfK+t3A3kDT+ltIcqpkMtIsmSFPzWA+1e3
         dbhQ==
X-Forwarded-Encrypted: i=1; AKwUvBxQgQrr4EEACcj7x7liMc1rkAwdX+PMabHxNxVdiLTV09EllbcfFuzR4M68x0+hg87k4DUEwNilzJrv@vger.kernel.org
X-Gm-Message-State: AFuF++nDDgHh/XEszS80df8c9oX78p1jYFm4yApPd6YlwDVA/nLK2tpu
	E3MbTuZnFOd90+QmvP3XrYXwjuhq23YMAGOnpNWx2fOAps2Vxx2FtLjLie4Y8O2V7DxlW/bgoOQ
	PAx1hpHE=
X-Gm-Gg: AYBFou3VKqMSLwDJ+3FU7RJTSVqYE5AhcntHiUyA0I3RYsohn1oQj2miqTJr/E20HRL
	Tpx4/Htd1kAUJBNs/kPHgXZXEww+d4L3So7A9O0PotmbZJhipEeJ0d65CUhCxgAj8ItfvULLWxJ
	8OEkXk/uoNfxgYCEU5CYCBmhZH2wd/Q0Vvs5u7m8jC9crUouBXIPiMbW0HztrXpjiKy0LXVjRLf
	qBYWil1IRYYFFcu0hiI7LQf8fuv/UHmtbjq8pap4hfZZnGzuUmGQJsvuTmBCFxMLu2Wm+59A6v4
	54sc1yIuGDmqtYg+SW2OtItyp0M4RfTfMGDEF/0PJb5wrLqxAUveTW5xqhjYCyXoHqz9CVVJZDg
	/pLrxo+KHlyF1JLtTxu83SL+mECIMXowrEErPLLz6pFcl6n44nJvQp0dnxdSzXWykn9Z9DbIMZC
	tdJdqZ/qBWwtudJLyzQRZYKeQhxNnHhTL/+GQUOAGITVltGhfKZ14CUT+IlEs591QKxWrP4RmuE
	fmsneQ=
X-Received: by 2002:a17:90b:37cb:b0:39e:6c69:9b9a with SMTP id 98e67ed59e1d1-39e6c69b2eamr13137762a91.63.1790040417528;
        Mon, 21 Sep 2026 18:26:57 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06e5a14a8sm317306a91.11.2026.09.21.18.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 18:26:57 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com,
	martin.petersen@oracle.com
Cc: lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/3] scsi: libiscsi: validate task lookups driven by target-supplied ITTs
Date: Tue, 22 Sep 2026 10:26:44 +0900
Message-ID: <20260922012644.2985852-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
References: <20260804040546.2264137-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Aug 04, 2026, Yehyeong Lee wrote:
> 1/3 bounds the index from below. A transport that implements
> parse_pdu_itt can produce a negative one; be2iscsi does, and forwards an
> unsolicited NOP-In from the hardware with the target's ITT intact.
>
> 2/3 is v1 unchanged: the ITT reflected in a Reject PDU.
>
> 3/3 is the same defect at the lookup that five management responses
> share.

Ping - a second one; the first was on August 22. This series has had no
comment since it was posted on August 4.

A patch from the same line of work went in meanwhile: bce07e2f37b5 ("scsi:
libiscsi_tcp: Check the data direction of a Data-In PDU"), applied to
7.3/scsi-fixes. These three are the same class of problem
in the same driver - the initiator trusting a value the target supplied -
and the series still applies.

No rush, after the merge window is fine. I would just like to know whether
it is in your queue.

Thanks,
Yehyeong
