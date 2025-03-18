Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477FF182
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 00:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742256250; cv=none; b=NFv1hpSm0761HgXv0An1HMsN8QTfM1FS79J1YIN3ryeu3Nbvdw3Ah6g7FePiOs9Urpyslb8VZdiCjoLv7KPFEX6T/JtZmBRn5z/qOOnm6Swej/nz7JrkcUfi+bjoLMGe0RhLd+awZ1Am9TqbTOKwEq7FXpP0ykpqKI3x6jR+BDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742256250; c=relaxed/simple;
	bh=0UtYWkT13wtYvAr8lsedc2YPxGGT85wLQrjGwPQXQ4w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AN8VE48obIVdAe2L7T0/1CnmoTLKE5bgWWNFUrFvMD6us6apffrCeu8K13AcEv41fKdZ28f3OSKlZsDxMKdNHCbLH5Gw0zwN6Cyit8oMtx94TXL2/45PqcCw1efI/ly8PhInNYLsFnJ+84V5pVlTyaA0J3pp96o3Q3CLpgYxrRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NBTdzW2r; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NBTdzW2r"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6feb229b716so46649987b3.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2025 17:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742256248; x=1742861048; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0UtYWkT13wtYvAr8lsedc2YPxGGT85wLQrjGwPQXQ4w=;
        b=NBTdzW2rAAcG2+E32BuS57Ngw+sIw1gNE6rfqtdnAKzh76C5bbbYa0XCpKczwQtqSb
         8tDX5jar4LrT88K96kVd8B+hf5P47AG6rv3qewustqUQUzSGnRca9tBpqVy1Eym0cdsX
         SbfLS2CCMGsw5Mx1hivL0ejZIcO0OYxqfZkPWizX95QT08aHqZ1sOSc6zz6kXTjZIweP
         N5AzxvIcr3RWlA7iU/ZxG1XGuxDK1W1/YA9e4Qq023pd8ZoHC8dtH0vytZQkcCmq6LjX
         OM2NGKrjp5/kAjTkOT34ainJba5ZdDOPsFWKxuODoj0Cx9O55J5qy6qacDidbpNobfUh
         T64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742256248; x=1742861048;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0UtYWkT13wtYvAr8lsedc2YPxGGT85wLQrjGwPQXQ4w=;
        b=tZQgwk5p2n0uOJkUdUQ7Aye7aQg99T1J1jYa2wV0J6qZMgskT2ru7SqgbPz7qpL1Wa
         7RjWad6c1u4nRvlw2luXQ1KUUSUDl6AS+FFJMM9sSBL6bY1po86ArLcarn9neyTY4zC+
         zd4a55ZAGBwej/o+xr78vy/bhoxPgbjZLxJr9b0DBzXY4ZrvE/+TiYuahuDs62N61kSV
         yJumo2vvTlZT0m4ZebNUv0Dye+TIwVYyGZkiwKu0r4+oVk6b8IAxu/Wn4g8LujkdMTO+
         6eaZQ4ZGFLj4N35SVVBEcaQu/4N9uWpfnh1N6gG5IZMXuqVmxo1b4avJn04to/A4bZHq
         3Hbg==
X-Gm-Message-State: AOJu0YyBSYJwUKRS4JYtLQ1NtRGeVG7ZCYP6+QzBFuLiYQ4o/H3XGpEd
	RaDYeoyvun7sdMiXZ4hmrahgQAwRDac/DHKxo6faJgV5Q+3544vYNnEz+8s5VcNa+MYy04+ctKe
	ahfum4C+ERNlHlHhSkA/2wn7qMUI=
X-Gm-Gg: ASbGnct69sqm/7oyixFEpeuqT6vk86zfnq8DYOy0/ZBXfnU35w9mOO5N37RhsoYcA/K
	Wab46msU+vu6g/bKKQ3fyM28hVkyeay+ewA8EeknWF1Emxw/NL854EbHj7XDuPOxdeuJjuM2gSZ
	u1Rk6taWSNWJ89xNIVR/ZQ4X/WFjOv84Sn/FByzw==
X-Google-Smtp-Source: AGHT+IGvDZLePdWqEiFKpfNVdP9U5124FddHys5UTvFAKddKuMwqPU2fTes/DGXIj35B2NPIeFU+5YQTCWNX1/0vl+A=
X-Received: by 2002:a05:690c:620c:b0:6fb:9663:a5f with SMTP id
 00721157ae682-6ff460fc31emr193569877b3.38.1742256248129; Mon, 17 Mar 2025
 17:04:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317163731.356873-1-emilne@redhat.com>
In-Reply-To: <20250317163731.356873-1-emilne@redhat.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 17 Mar 2025 17:02:49 -0700
X-Gm-Features: AQ5f1Jq7QN_hHolH0v0w4apdLVpA61pds67Jv6KcAdDbdDDZcsBRvNAt1nzw2gE
Message-ID: <CABPRKS-7sbG=XW1pt4aXqMfHO5T-jPfT86tfJAD3fHz=U1RHbw@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: restore clearing of NLP_UNREG_INP in ndlp->nlp_flag
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org, dick.kennedy@broadcom.com, 
	james.smart@broadcom.com, justin.tee@broadcom.com
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Thanks for fixing, looks good.

Regards,
Justin
