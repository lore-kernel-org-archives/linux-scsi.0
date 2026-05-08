Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F094137F75E
	for <linux-scsi@vger.kernel.org>; Fri,  8 May 2026 09:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778231336; cv=pass; b=mWGqEG/HT3XTy2VkHWHVNF5biZc7fuVMY2mPmLqkq8cSvU4YpZPCm8ZQ7eYzJ1LzzNMJBsTeO0zqkhAyVSS+jkjqnmTHBLEFYBjPBPxu5e8NqJepFLjO/Ryao7d1PbEyhRnpM+0wVLzTuazfCsCdN4hgrkFvWJtIi2l34VzpHv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778231336; c=relaxed/simple;
	bh=94w0YpZVYjdenOX1+6NN9zU71Com+qkFKFw9MeOEQw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BjXjeTzlOpwtoMb4J69Ocj4Nbs8/TwgeAXiQapJZAFtao50K9bhnseydAIsqQVgUfE4AVgjsVaD+n+hApvBe2D93Mw2cteJ6Rnj8pb+4OVSusBvXEtqezejPFGBAK6AyjKuBn71d0JFSqEZV/pTPcg27GSXb49LYpWZea3Oy2yg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ab7y2RlC; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ab7y2RlC"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso5926a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2026 02:08:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778231333; cv=none;
        d=google.com; s=arc-20240605;
        b=AoQbdldT5DhZhdHVClRLHZO1qTZRbXeh9mR/12d5df8xwFegI77oUblXDpcUTVbScC
         Vo0sxL1Aza4+hjFgIkx/jo0wKGAXblB8f+CkZJEXYQAaQBganuSlnBhsrUpY73SSq5kB
         oHFic8KYc42v7S/DkzZNWPsv8UzQYx2TnYnxSYkpgtHaGsMsPOTvR21FiEnVQ1BU16ZD
         wpg5aSLZ+lx1SnbdzVcuW1Jc7BzTZb16ikflI/kXvyFG6NmtJf/fYrVXcDSl8YCOvwLo
         gqTEWJcxoo7ZmWVtBpZpBJzWTw+ifJbbYDWtBQXtPl9jlHT46VNRvOj+wnFWIRNhYiVm
         eTcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q6KlhDsCCbA+sGxBJibljaCbp18JVPvqTbjbGVM7CSw=;
        fh=ZsnA0alHkpCPoMw9lK77lf9mBnN+bq7Ryt5fOSpRBzM=;
        b=d6xm7p3DzNZDsNfq6PLZTuTvNZhIFZlcCn3J0zmvVMih8clH9XooVbsFDmHzwefT1y
         79xierXWPCzesib+XrIkvdV4k4gzrQEd3BkhcFS/VPg2w8gPdT/ES10GHjX/sSaqrKDI
         HPdVmZps1WfU9Dqprmj89IHfR/CZDUyk+5xOpPsnCvRd3xt+C/kNX2L9Zab0ej9XEWaG
         qJtXYQvykwrw1/SZgt442201L78auC6E/67Ich9ZIZHw6kuSEajVPV1BhFdc9eLYLj2B
         GwBSYCyAv8h6KN5numQTjRxKVEaGsYBpzbE4LxBrSSZbScy4S+V4QY/VWr1fl1ChbGNY
         Sdew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778231333; x=1778836133; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q6KlhDsCCbA+sGxBJibljaCbp18JVPvqTbjbGVM7CSw=;
        b=Ab7y2RlCST4S2pgTKpGNX4la4kQfZJlyWRQB0dRwcR+p6a5QEsUG/nFq5+b+KOI2jV
         UPghOCUma9KYenbVsJR54o4rSUYm9RzNB+hRVyx/+fipUCTbM7cGzhmOJtOhLPu40xdk
         TBVcOunvbIeJilE7rjkfVf9lW0uamXGiMtxEi4zlxsJFQN60uX04A4xCkPbM+YAx5K1A
         ycWfW0QxZtCaTTwNFF1J4vo8UjBdO1qIY2ZyeskzX6mk9fiBbhnWKWZmaDfVACunThUf
         XCl6nwDdjk7LTV5i3yRJgMQ9q6fAn6l2Sshq2qAaOQPsRjDeMSPm2kjV17oajBAmZZSs
         cD8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778231333; x=1778836133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q6KlhDsCCbA+sGxBJibljaCbp18JVPvqTbjbGVM7CSw=;
        b=oOCqeqGUisF2KOKVOLwrUtALEkjUnpODuJndVzOTKgSS8JARYY6JGxq584n7Nmtcx5
         DVtRDxtnis9d0X9UYJ3CrKFwEWcAkyDtTwRnwMXLVHJ53eoY20rNr035SC+pueSQEb7v
         grGzrCNZ6HIsNo4KgeVxcmS7NJeib5A3k+SJk0mao72bGHZlaSmp+E1g7Wlv5J8U5raD
         A+nm+8KtHp3e9FyKZk8J02VFKLIjoZPyX/Zc+1h8BLI4+WAOXUIHaBO6Iuxq4C5Ac/uH
         TeZJK3baKNFYFG0zkKmVrb9K+UOOHJ84HKDPlXqmokdPRstCo655gQJoJ3WpTRGQfH7X
         yyQg==
X-Forwarded-Encrypted: i=1; AFNElJ8geeaY80ii0T8h0yd8NnxOjDkdeTFbAGcsdXXqAY8Ej1sxM8H+enxPAb3mh3YSuZgMaAwjlyJt6YSS@vger.kernel.org
X-Gm-Message-State: AOJu0YwByIBSZ/ahi8WXYptz0G8oew0aFZQ5k8D+/jwFSaNAIfaof8Se
	NLvxFiz6WMDOHG54ZQLCi60ndph+IntyaCv1rI2U6RGHNJD9Qizv8ukvtD8iUbIWqdG2utV5dm3
	L9tZESMer/lIJ1XTkm9d272e2nScG92g0O9XsDEHu
X-Gm-Gg: Acq92OF/pU85dqcsIA/yqryDfOM+7efMIfka8uJYx+j01OS2fiXQm9f2jEfYxSCy7F8
	h9mXDFEeS1ydw9Pp5WJpcHcSp/zWVy8VOwRlihLXLPamVmJ8kk+QDnf/Y6u9NzD/Gkzpbjn7Xxf
	IKV8SoZN8/oozDTR7y71ZL8phJJT0VAoVuds6SGzEJSMWpZ++ZMSha246IvUusoZRNVcskTz+jY
	zm/pMb3RaF6IHikOGK2J2skCAYLq2xqjasKAHVvzajc7hM+9iFwyjSiLgwEbGXajmmimtkw+y9S
	8DfaxK2BNsAD9AVTlQ==
X-Received: by 2002:a05:6402:2b9b:b0:678:93b4:1fd3 with SMTP id
 4fb4d7f45d1cf-67ec504bd96mr67552a12.6.1778231332759; Fri, 08 May 2026
 02:08:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260424151420.111675-1-can.guo@oss.qualcomm.com>
In-Reply-To: <20260424151420.111675-1-can.guo@oss.qualcomm.com>
From: Brian Kao <powenkao@google.com>
Date: Fri, 8 May 2026 17:08:38 +0800
X-Gm-Features: AVHnY4LIqzhUM33Lc9nvgwPYliVZYAlT4EhlRo-azUqGcat35M2qLFy1sDt566E
Message-ID: <CA+=0d2bunGi-Ht+3ZZ3-+E2FfMObU27QCMYX+r_5RqoAEQq5Ew@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] scsi: ufs: Add persistent TX Equalization settings support
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com, 
	peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2026 at 11:18=E2=80=AFPM Can Guo <can.guo@oss.qualcomm.com>=
 wrote:

> 2. Add TX EQ settings persistence flow:
>    - Read stored settings from qTxEQGnSettings & wTxEQGnSettingsExt.
>    - Decode and populate per-gear TX EQ parameters.
>    - Use Bit[15] in wTxEQGnSettingsExt as validity indication.
>    - Store trained settings back to these attributes for future reuse.
>

Hi Can Guo

Is using Bit[15] as a validity indicator reliable here? Since this
isn't part of the JEDEC standard=E2=80=94which defines bits [15:6] as Reser=
ved
for Future Use (RFU)
Are there plans to propose this validity indicator in a future
revision of the standard? If so, I would definitely support that
proposal.

Thanks
