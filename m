Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189054B95C4
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 16:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789577191; cv=none; b=iN/lJUQP/clVXqCqK84zsvdHYf5P7Wv/CmA/dlg8CveE53FmXuofEWKy1VZi+VUGraAgjF27wOlThEG+OFrs0WWYRp0uTSrgtZVCKLChBD63Qcmtdt573u4tbnic6LGS4ySXbh2rrBrUyko4Lq108FoQII61lvCfKvuO7XnyOVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789577191; c=relaxed/simple;
	bh=1fs5/9PJdlbuBhTs0ZxkDNW+v2WItpOPk3QzGFWOdbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBNTwWloiDq6GHR4mSKjheF4fq19iFIZVU4xolluQXi3hyOEII0fOzuD0MF6WiiBbCa1R1RcnF90RH4ZgyH8lzFYTuki4rFmeuvXXVvaxnVyHb14SKasV9v5ejYtl/T4kNhELxRh4KB9AX3f/OsS85QSemCa/p3ZvJ7PDiRfP+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QMSLSCTc; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QMSLSCTc"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccd66bb4so1082995a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 09:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789577171; x=1790181971; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1fs5/9PJdlbuBhTs0ZxkDNW+v2WItpOPk3QzGFWOdbk=;
        b=QMSLSCTcLtJ+AiMJ6XECO+C16YHQOAZXJqddh+1hwfr5SVCU4HFWiTSJa1dhNOAfge
         pfYOyTxgh+G7+nYzG29DcTK0mbanmL4Ki5CnnFA1nBDvUO6vmqKWePAB+FZ5FpUy7ybf
         NvpmQd8hmW1D58fLfNxQ2IO4hTT5eo54DBnXZzh2iajCO69bt2cf5NtANoLSgFqyO5/A
         9LEmXnDntVcj3+khqajRkChzL+EBb5PV7pHymXnMoVk6pz3eKRz4jysRegqRDLaw73Fi
         qXC75IwpNB6FudUN9Cqwzv40xMcW2rJfnS4fRbIUZsdSRYywhbx5SH4WUeYfZTSmmPUN
         0lKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789577171; x=1790181971;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1fs5/9PJdlbuBhTs0ZxkDNW+v2WItpOPk3QzGFWOdbk=;
        b=oopVhpNrRnpmtJ/TnGyjAs4qhlShOXQk0yMLUFpdyFIWNNoNrBkbq7hmY7NDq7V88S
         pXCVewB1YVhs2yzu72OpmY6k2+muypkBVd2fs1LJO7pDpEJukQ74JHMs1SQBHXjtVKMV
         n9fczTJjYGWFR2lSLH9ElgKggcQnRyA8CJH7XJxPgIH0eviiGi2XwPIleaU5SMzpfV/7
         GfnUJMDZ+olLFapzMEp5jeHUktBs6w+koATWv7RRm/b+Yz8WNsLdSeyxqByaXtyOC4PO
         kzX7YercSbFQYKDBlx3aHBvj4+hsVnRgzsKlSMptmtCD2zvt2H0V13oxt2eJyumFweth
         /zew==
X-Forwarded-Encrypted: i=1; AKwUvBwNMNM5W1QJ+tz1c7ULhP4haiiybORTPEhLjdgzLsNvPBD/z/LM0fdj6vUYYR6KkpDIun6JQYU68zp1@vger.kernel.org
X-Gm-Message-State: AFuF++kLPyP850NK1C42l+8+mEiKp7veJQKhvxh7Rpr+19oJxDaxRYGr
	U2ak6im6Kl/KWJfi8G/TcD4UrhbZKh+WI9J+FgHQ2ZpPL/Waae9vWPco
X-Gm-Gg: AYBFou22bhzFlDeqYGfp+TZnQG0/QPNieliZGTP/l12HqTF+xNUfbv1BNk7V63ibfit
	DMinSDwOVn18kne0di1jk5ZbURm94ImW2IF7xZ35ij2kvWQeKiREABUtj/1qOKnmyo62vvuZcVq
	eGdlyezgbzC2cjxAKqOa9z0HB1hGhZWNva8w6zUloZAglNCRE2wIKJUTe9meJGCbBNlfhMbKJsX
	4AKr9G31oFEkCvSg+zjN3L58ddvixedZaTLqRA3l4gvqVpx4GRaB8VR2uzQDCaboalVPaoFWxwd
	hlm8Yhcm3XEcpdFMBmanjXpBOJbsKPvY2cmTVFdx7lBInix3Qh8m+cvQpoiRn94imxrcQld1Rwz
	IAelHVebysX9Ha8vR9fWdsJHYA4oQCWuyJiktCgBOkyXe9HrJtj0IXgFT1zV3EW1kC+6p1GVhu7
	+bI2V/R51yQVJS5c2+zKrKUryUymqQM/Zlr7L2EP6zNB4LTRHimRtgfRgWK1dO6tF83g==
X-Received: by 2002:a17:90b:560d:b0:39b:3109:10ce with SMTP id 98e67ed59e1d1-39e1e45cbaemr7258907a91.16.1789577170531;
        Wed, 16 Sep 2026 09:46:10 -0700 (PDT)
Received: from jm-X870 ([2001:e60:20dd:7c28:de1c:fff7:d3a4:d8c7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3617443asm292100a91.9.2026.09.16.09.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 09:46:09 -0700 (PDT)
From: Jaemyung Lee <ldc.jml@gmail.com>
X-Google-Original-From: Jaemyung Lee <jaemyung.lee@samsung.com>
To: Bean Huo <beanhuo@iokpp.de>
Cc: Jaemyung Lee <jaemyung.lee@samsung.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	bjorn3_gh@protonmail.com,
	Benno Lossin <lossin@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	work@onurozkan.dev,
	linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
Date: Thu, 17 Sep 2026 01:46:01 +0900
Message-ID: <20260916164601.2562349-1-jaemyung.lee@samsung.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <4c38f13af8f75020fefc35827463e9bc643b99f4.camel@iokpp.de>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com> <4c38f13af8f75020fefc35827463e9bc643b99f4.camel@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 2026-09-11 at 23:44 +0200, Bean Huo wrote:
> You still use scsi everywhere in your implementation protocol/scsi.rs
> builds READ_10/16, WRITE_10/16, SYNCHRONIZE_CACHE and UNMAP CDB, so
> "decouple UFS from SCSI" really means "copy a small part of sd and the
> SCSI error handling into a UFS driver." while JEDEC defines the UFS
> application layer as SCSI, the SCSI work doesn't go away, you just move
> somewhere else, and it has to be written again.

I agree. By "decouple" I meant independence from the Linux SCSI mid-layer,
not removal of the SCSI command set from UFS.

The current RFC has CDB construction and only a small part of completion
disposition. It does not yet implement enough sense, retry, recovery, and
disk behavior to show that the complete UFS-specific version is smaller or
simpler. The cover letter stated that conclusion too early.

> The "friction" claim is weak. SCSI has already been changed to fit UFS.
> Two examples: UFS now uses SCSI simple copy, group number in scsi write
> command.
>
> I doubt how far this can go. do we really need to pay effort for a new
> RUST UFS driver, I am not very confident, unless SCSI is removed from the
> UFS spec and JEDEC defines native UFS commands, or we talk to the device
> directly with UPIU. please name the JEDEC feature that the SCSI midlayer
> really blocked, or that was historial issue which has been fixed.

Also fair. I cannot currently name a public JEDEC feature that was
shown to be impossible to implement because of the SCSI mid-layer.

One of my main motivations was the amount of cross-layer reasoning needed
for product EH and PM problems. In product work, I often had to follow UFS
state, generic SCSI recovery state, block queue state, and device-PM state
together. That experience is a reason to investigate another design, but
private product experience is not proof that the upstream architecture is
wrong.

> I would also like to see the heavy and hard parts, because they are the
> parts that decide if this design worrks:
>
> 1, error handling: abort, LU reset, retries with limits, sense decoding,
> this is the very hard part of UFS driver.
>
> 2, user-space tools interface: SG_IO and bsg (sg3_utils, ufs-utils, FFU
> with WRITE BUFFER), and the UFS sysfs tree..

I agree. These are architecture requirements, not small follow-up features.
Before claiming that standalone is useful, the design needs to cover
timeout, abort, LU and host recovery, bounded retries, sense and Unit
Attention, late completion, DMA safety, PM-aware recovery, and request
disposition.

I think the next step should be to document these responsibilities and
compare the standalone design with improving `ufshcd` before completing a
second implementation. If RUFS only reproduces the same behavior and
complexity, the standalone design would need to be reconsidered.

> Did any AI tool help write this code? If so, please add the Assisted-by:
> tag.

Yes. An LLM helped during reviewing, testing and preparation of the
submission. I will add the tag required by the current kernel documentation
in the next revision:

Assisted-by: LLM

Regards,
Jaemyung
