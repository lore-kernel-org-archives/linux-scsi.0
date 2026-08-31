Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5AC3DB629
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 08:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788164784; cv=pass; b=EGBvZ3tO/vD3mBVo8kQ9DQxmEEuruN3QI4VuM9hcy7ilSMiSKW5eCX33zVWEVrTBSzIuL8naSI3/TSxAqWDTcH/xAE+GBVXWOCr2UPzXpchYIZkGAHF7F9pAr+gPIXTYIm7MNmmT72UChVaS6QuvwxVrujCB9fH8H1pR63Cewws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788164784; c=relaxed/simple;
	bh=i7Pvgb3oiy1hq0LGOiit/djv7hiLdC62LcWzykGTNDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dgw6a/bW0xZ4QAzgh3uEsD5j9ry6dioSI+B1M92quHb3sUlVrShIC2VKuwWS5Cj/KcrDcWDj1Y45qxF/uiMzpSPjFaTkBBt809xd4/+Y0VifCy7oft/YPaMBRhseBrSDg0siaU0di9HbiivVTyRpn6J7RWgxoPjgWCrFjAShUc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Arv2w2P3; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Arv2w2P3"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-52faa58bff5so324671cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 01:26:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788164780; cv=none;
        d=google.com; s=arc-20260327;
        b=XQ4os3ICMzYqf/Y/GvHsI9BY1UgoHZC6AidcYP8ccN705k90Ze0oh91LkBdScaLiof
         D4Hl4EJD18NNEG78Io4IsUsn7GzdELxqy6794hY4QFB+P9vGmdyRHUXGz8ZR2fjoF9My
         021oDcM7icOv6teh/Jy7tJnPlhhkcpjHxJ5OYmxuZYNj9kmgdtP1qMCnANJO0nm4YpkO
         hIPM7fMK09b9dGgcWcoIlAOTfEeFBBygXPyh3g1Ln+rsqWY0AIypcWCI/lhd49odff4F
         /RMZaV+cTDuNMz/m4ZRYjnd1mx/UMAdMCzoYGfjKFGihKtDRtl6UWBk3x3x+f3AYP2/7
         lh/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=i7Pvgb3oiy1hq0LGOiit/djv7hiLdC62LcWzykGTNDg=;
        fh=f9/VcjgqmhjeO2xeqvn7QATDWbastD6G5BTgpTIBKTw=;
        b=XeSt1nosDXAVWLppZXLWUyDbWVjFNxuRnFvh0HZ+0/Wdtja0pyOAnnwLVsRzWWS1/n
         Ua42wHhwQ3shrS/L61aTMk5DJiydbLsfeS1PlnwHEpJVD321ZQRkIxcY6wwQsaf0vvLt
         YfymaemKj2opiKBiygTTcV30n+u+oC41VdJxVSCNg5SnInaeBASiQ5OsElp2QQ4X57lT
         L/Jblm+u8lPvp88PfnEcoYmi7a5SEkFTuedYxxPNcTGqT+H4gjt5tA+Ydy/WhZ7A1vKb
         nPYONBX6vMhUFG+ethuKCoTwIhFW5XhSMiNEUntMQ/UUVRrCWggLXWFsh3ZNh1y1fR7e
         ZGUw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788164780; x=1788769580; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i7Pvgb3oiy1hq0LGOiit/djv7hiLdC62LcWzykGTNDg=;
        b=Arv2w2P3TIZLnRD6C476tlrQY5qFr4a7yCxon8MfJGbh95sgrsIdZ0z/gbktbfV/Gl
         YnWBtIzpiGvGFFn0t3goA3aPn0JAXVWJdHN5rApV934smTQnSO0UqbgGy4fWiHqLHdLj
         EhNclZ+wGZIowEBKlkPoK23OR3tQUCKaPsa4Va0eYFOXdfseCFzn7m0C5kwR+XaNioRY
         PuP3tictKr8g73Li+Lgo/sVDrBqEeWceQ1qnv5iOPC092xvSNaRNglda0setAOj9ttI0
         nlUZKrNTtEknL+24kAWnyTmzII/8alk2dxO5wR12IV47qnvXX5/e5hlMHJKWGiRfoPPq
         QGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788164780; x=1788769580;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=i7Pvgb3oiy1hq0LGOiit/djv7hiLdC62LcWzykGTNDg=;
        b=eq5zpD85OjtAOvOjpmhFQoPzA1vDQfbH1fc1YM909s9TH1hPbaSnLuQltjYBN+sYuv
         +a7QTupFmfyc9uzf6k3rbZXJtDNZFZ8OqocAFhCQB9EA2pyk+po5HpvuQ60Gc5Uub7vV
         DAbEDsJSvUOFNA1+8DiqMXaUx8TYvI9B3XGShg+BKSEktogyZWJnUN3hIkyIKn1N9nwZ
         0C1BLUEISg7vXLbzs7suxnxwVuYWekksE/ijCbHpbR83GPQKuXrxtSYw+cA8cfQSdQR7
         KKfjYCNJszVHc9xNuqA0C72IbDVgl5b3u4uYJJDTGfAhe2am+Q8U6QHpDgXALYL+CgVF
         T/dQ==
X-Gm-Message-State: AFuF++ljnt6uiQgKNlAKQ08AhQ0f2ZhaDkF6k3Px2UpgBV9ItUE2W8UU
	G8ZpqoIpTBxjT4zRTEfpLq7OGB5xsiMWT3Ck2Ilx8H7mJtRt2Pqgx75cmhxSDGcmCwQZ82VnsDO
	Y9R9z+ZcQKJH8jsj4Ok7wsl74GNXJ7xg7BMxWebBn
X-Gm-Gg: AR+sD116WsFr9DGcAW7lv5vNZTjBb38PBO+2KJdXvR1tgdY15HZlYnCIlHLLCG0Edgj
	INklQdxZpVvw9r0VNsz9PlIuDWyJRVRXe2ynHLChpHKWIUeYHD8csL+8hE6WSIFg1LDwpK03JDY
	6BL+jKLgjH7c8CrwlKuxLX86qHgPek3Br8S/HFdOzbAG7twlIfc1nglnynHYpsznmNKAg6aie+Q
	Z1cmkPaaGkv6QfN84uMD2c0Cjtgx8RV+3Puh+FouOE1lpmu88npVK7+a8pWug/TJDWfbVRCdmwQ
	nOektnSUOCcpZJ9TwusfWnQOJGgdMJayHMaIW65CrFwG4YCtUqvWoviqk1Fi0PmXOB2F7pwCej+
	eWg==
X-Received: by 2002:a05:622a:64c:b0:519:b655:235 with SMTP id
 d75a77b69052e-52ff711704cmr26458811cf.3.1788164779732; Mon, 31 Aug 2026
 01:26:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827070345.2853821-1-jorge.ramirez@oss.qualcomm.com> <20260827070345.2853821-3-jorge.ramirez@oss.qualcomm.com>
In-Reply-To: <20260827070345.2853821-3-jorge.ramirez@oss.qualcomm.com>
From: Stanley Jhu <stanleyjhu@google.com>
Date: Mon, 31 Aug 2026 16:25:42 +0800
X-Gm-Features: AcwNN1Wql6TjF2E32SMAe0niU5XIn-Fsgvx0mgJJYkagFD8DWijLMQS03XBChpU
Message-ID: <CAE14pdczcD5zsOm57pBaDqb04btPY8abOncDgFwF0_E4LP9sKA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
To: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>, beanhuo@iokpp.de, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	beanhuo@micron.com, can.guo@oss.qualcomm.com, sumit.garg@oss.qualcomm.com, 
	jenswi@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	op-tee@lists.trustedfirmware.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 27 Aug 2026 09:03:36 +0200, Jorge Ramirez-Ortiz wrote:
> The RPMB authentication key is derived from the dev_id handed to the
> RPMB subsystem. OP-TEE implements the eMMC RPMB flow, where the dev_id
> is the eMMC CID: a fixed 16-byte value the key derivation depends on.
>
> The UFS RPMB id is "<device_id>-R<region>", which is variable length
> and longer than 16 bytes. Handing it to the RPMB subsystem as-is would
> tie the derived key to a length OP-TEE does not expect and diverge from
> the fixed-CID eMMC ABI, forcing OP-TEE to be taught about
> variable-length UFS ids.
>
> A fixed 16-byte dev_id is needed so the derived key stays stable and
> unique per region while matching the eMMC CID layout OP-TEE relies on,
> keeping the key-derivation ABI identical with no OP-TEE change. The
> reduction to a fixed 16 bytes must also be reproducible by the
> bootloaders (such as U-Boot) that derive the same dev_id.
>
> Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
