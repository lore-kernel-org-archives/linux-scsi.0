Received: from mail-pz2-f27.google.com (mail-pz2-f27.google.com [74.125.228.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BCA343896
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 01:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790040435; cv=none; b=DuEwBXuEa/pnfFJ46ZFzm90sp4uSPKgKsTFvXH4YAQgBO2ETZfWAOqVviN7A4YRrEDSAywPHBvovdku7wJYPj3o4T537F9PqFm+cQcWf1pbyVKqhlXdAYZtE/angWQ9kAKtPs+6QpAqsOVTN0Yac8ztuli/R6c+RyCf8unA+5i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790040435; c=relaxed/simple;
	bh=qM1sOFVcD9e4ZOGoSRa5abdh/qEsuPN8ibWdJIVKCCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNSjtb/dJyGDN9zGhfcF9x58QVlsYXvl8yBgJjYCh0LOduNTO9jwokMHh+wc2TA/KQNDeTbp8LCj5kqMCcIWOxNaOKx1jsKYZF5FMsTgS1WW5ihRxqd0UCb7u0/OZnwsYegxWj/HStZoYZbyOcMbvMveFispVCKqyduEU7FHkS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=piGJyi+H; arc=none smtp.client-ip=74.125.228.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="piGJyi+H"
Received: by mail-pz2-f27.google.com with SMTP id 41be03b00d2f7-cc1cea50dc3so2592232a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 18:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1790040433; x=1790645233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zmv1I8B7jGwrDYXGoWBBg4/RAfv0VqCyIxhyTjjzmzk=;
        b=piGJyi+HBw78GEZ7KfjH5w//PfifSLrbyKCqwpgFY1xNkCHYzz33kHK0dHa5r2Q96I
         3NG8zsqJAABacfJqPfk/8ZvLK/TA8ZT15Gd1Ic4liVGaNvY682cVwcsLQiqqVv6Z6mcQ
         RlAC8HrqsLlU70557YdAI5fa1Idz0e8jH8gUkjRAIseQuyDcRyHKYIPBzNE047vMi59A
         LD786Hpq57zIqDCr1Fxdjqqxucxe47/0xZy5uOYx4n3ez7lKq/nBV0wTGwmf8i5cqpSJ
         XTlDoTPrPVLEUIsCvla91hTkZCh8aYYTfxh9DwpXoKigUL5v+/UCzWhj1XGnTisvJOnV
         Racw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790040433; x=1790645233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zmv1I8B7jGwrDYXGoWBBg4/RAfv0VqCyIxhyTjjzmzk=;
        b=Dv9OKWzn8AbUa9ym9MkI8KkcZ4r4GuYC2LZqPsNTxMfQDlpSckFSUIDqy36vGgA34W
         hLGG0hnvAOfTvRzQSl+2NAVtp8Ih4QtYaStMRxFX7/Yc6hriA/K7Tkxbf5N/K1K7s/6b
         Gk0GIiP1TCZSJR9I8XfWfwk+1MxTiK0bJt8UEiOI3+xWY47GIw8MbtEHKyfkVKTU9N2h
         29KzzpMMq11/PN4SNIvUKDkk2o1Vdye8dCPRb8MksIKUZ6nAudxfj6i9K1CdGYi3fexI
         lmVTckp2byf3vavEMqpoVREfw6qfaMelGY+FmaX6D6HC6UAJOml0M7wTYYW4s3tIaxx8
         7U9g==
X-Forwarded-Encrypted: i=1; AKwUvBzH+4yV7V5y7Z3xTuviYSBCpehnTVYPvj3yeybhNAvWBSd3mR69gUyYhDCnKi1Ue+EWto2h9SNmiFCe@vger.kernel.org
X-Gm-Message-State: AFuF++nK7XYOdFv1GOenL4+k0dsskrT/G7xc8VrDpur6tNX4MuNNXZ1p
	IOyE+dsNlCLTZMau2aFcuE2WQR4nc0AplbEN8NyL5z6KMzTtddF2bcURgmaSzqmI7Bo=
X-Gm-Gg: AYBFou2DkFycNMHsXAfmFFhlXj/sUMlZWxlfQVq7TO/gpg5wPUEAHqnUufqtNQXoGXR
	H83CnDiz+2r3i4HA+FvedWQQDRXfTZDmDuQTtC61q7gJ0tqgBOSkCCMxE49w3r2QbfOHz1oMT0o
	FM/nL4zG3nhkJ2bdI2jmdPY3N0FVu2VUR0CgzQPLeWxQYYbXku7SzdxA9u1JlMbjqm2rnHOPGpL
	SP/p17VHgZe1ued7q7S6Zrgc/EVreMzmMi/hhQ5jOESFddz0+n4KnMRcwkUznxxswjiwf8T+RfF
	JhkLhyCWhpwBPBXscCWHkL1zryGSYcvZqYpnyR7UQ7Fox/UtbWzDazySDdrHisW5LwFZ9/qm7Sh
	9DCYSK40jJkea7aS9bA76W6iiX20RtGApxyeDHcauENaFsBKyfFWHMCmBLMFkDiviwliuGE2wXD
	e82jD376BZ2xIKDAT/Ndd3N1DFXsmXh+hpbHC4/HnS4cwkJFm3HLjH/RBuVMsmzO51NSTjNQM/V
	2F/Vg==
X-Received: by 2002:a17:90b:554b:b0:39e:6c6a:4b64 with SMTP id 98e67ed59e1d1-39e6c6a5438mr10598058a91.46.1790040432890;
        Mon, 21 Sep 2026 18:27:12 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a067021ca6sm1728579a91.2.2026.09.21.18.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 18:27:12 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com,
	martin.petersen@oracle.com
Cc: lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: libiscsi_tcp: check that a read got the data the target claimed
Date: Tue, 22 Sep 2026 10:27:03 +0900
Message-ID: <20260922012703.2985899-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814121428.359541-1-yhlee@isslab.korea.ac.kr>
References: <20260814121428.359541-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Aug 14, 2026, Yehyeong Lee wrote:
> Over a 1 MiB pread of a file that had never been read, 999424 bytes came
> back as the contents of an unrelated file the same process had written
> earlier.  pread() returned 1048576 and errno was 0.

Ping. No comment on this one since August 14.

bce07e2f37b5 ("scsi: libiscsi_tcp: Check the data direction of a Data-In
PDU") was applied to 7.3/scsi-fixes and touches this same
file. This patch is the other half of the same problem: the direction check
refuses a Data-In that should not have been sent, and this one refuses a
read that ended without the data ever arriving. It still applies.

No rush, after the merge window is fine. I would just like to know whether
it is in your queue.

Thanks,
Yehyeong
