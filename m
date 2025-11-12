Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E40317555
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 09:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762939789; cv=none; b=D70wiIPmKSI4SwfG/16Qg95YFCYuVpFrwoFmwiaJ5MzbG2o6usaOxobTitQZJwxolJwt+pR3bY1munsSHR6UJwYZ1BrTx0mK1BOxaNt86uSooLs3JhmS31+BknLo5UjdA8c3A40fhRYzfx48JJJQ4qx6vw81giODamZsO/LEA6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762939789; c=relaxed/simple;
	bh=/SrrSeNMAopqflkaPGG2jrixna9JAS5KOvMi4P6Q/Rk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uzJiu7OHEJztc3cxJ19J6yxd5w+kGKjMxXYabubwF8CZLxfvcob4tAhmBWAYYpbqw2NGCrCkD47TQ3bz1fWqWH8jAdytyI1YHogNXlmct3G+KaeLyV1xOr3sp51MfcI9z3aA+DYLKmDzacAVZy1dSU5HWCESLzoMHmu2LsdgfAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NM+LYDEE; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NM+LYDEE"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ede12521d4so67231cf.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 01:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762939787; x=1763544587; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5TSHEBlUSLVv3QGJ9/nVqxUrLzu7sFbsdH5gS1hKkU=;
        b=NM+LYDEEeU7PtJ/Dq5oG29OS1r3Z9aM1ZUApE0ApB3NfmPvibfZ7F+0zUgAxMtf6Ax
         /kuA45pFkX5oY4CiDuGsv2ij0Epg8oZ4nnr5WEX10KNO91BJDIv1D5xOqdRwkE3eUNtj
         QOksfLXKgjWK9+55B7JHzijB/HjAUQPpeSqNSMXisuWcK3drJeaj09VauYC5KuTwznB3
         IOutVeb/GXBD/E6b3RGbxQdEmDZgtmCyIKFiS9aWiG+5dM450bClxwHabzBON3gR2zfV
         A7KIlhyfxBDgwGHYp5b93eAPw9HP9PFYA5UeVoSohcdd3fqM7ZWZ+YPq4OjTibq6IY4a
         XS1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762939787; x=1763544587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a5TSHEBlUSLVv3QGJ9/nVqxUrLzu7sFbsdH5gS1hKkU=;
        b=MT/Qd92hRhJ4s5iT6yYVL+wg8uflYkIcqUm42o+SgOyxuRvmX/w9nMVvIVxCJSIEZu
         PampulIBBBssIwtLYhk/A1Lk3koLT25+yOf0RULXRFlyRCnuXc+Msc1IeICRa9Ywgtbp
         3qHlhHL/jcIWIdqnzburZjktDTQ6MIyWX31w7Y6Bc5DoiJFgkhQnR0XBf+5wm+MZmSN4
         8/dbDNAOb+FutTxCOpjtm4K6dvyWVsp5qxmAnzPJVU4S5DiQcFeAImP3boMIZoowrbb9
         IYkRevh/+W8NuY76Tg3p6giqTqlrXQ8Ch9bT27ASGcmAnp89oTp7UK5PbRHJpGkxXsea
         MYOA==
X-Forwarded-Encrypted: i=1; AJvYcCXESBWFO+XYQehTrwv3C3mt0H1O7TybCw3qlSf+V3ZBbdi2TrhrhRwnStdDo+VkEbXi9UdbTvHUmjtb@vger.kernel.org
X-Gm-Message-State: AOJu0YxmWY143yAQ0Kzh0O3yWpahzqmyfS0OuXI280PVG7LZUdL/tzbM
	y5LrHRxELDdYVxtfkyyNrOdHXxOwrtHzfkILH7nD+v2HXXcCCzo6tmadvAwdwc10EHWYmXitJou
	UCpRtO0SR7BU0TOuWiKEuSt+QUKBB+xPud1xxp/5h
X-Gm-Gg: ASbGncunMzlxXzOquotgHURcN7IXV+rvW1sPmXGK7uhIHEm2wdrlVD6dpDiZ2R5bFeR
	FXfUAR+xO85pUIf6gwiFemnO9bvttzA7c3fMU6geztjhfJ3OF8exvF71tnwZv4sd+lcAX+zocGe
	7NCm3HdiIZIvpcm2ElfKx0xDBk1eMHkfGQYFb67BF0sH3bqo6FDBXLPPOLWAJc+THuFehbwMnfE
	IbqSmRMTzFW54J8WzvsxclMy53KME2DwN3LHrHGGkCRws1y648JCRsl4B1O2Vnr3/se1HcVwdtT
	X5I=
X-Google-Smtp-Source: AGHT+IE1UnP9YAjW69wspkWvib/yFN91pFbf8yTPtTGC65vwyZrBTJvG/kZSA6tQtuJ7wkmUzlaLCIchCCfo3Zfw9WI=
X-Received: by 2002:a05:622a:11c3:b0:4e4:f2b9:55aa with SMTP id
 d75a77b69052e-4eddd22ec83mr3792801cf.17.1762939786978; Wed, 12 Nov 2025
 01:29:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251112063214.1195761-1-powenkao@google.com> <7d964e31162bf93f583e6e78a3044152894ecb94.camel@mediatek.com>
 <CA+=0d2YnrDL41DXtC8kDmtXioy4+hohGsmrOPxJY31jqt22uww@mail.gmail.com>
In-Reply-To: <CA+=0d2YnrDL41DXtC8kDmtXioy4+hohGsmrOPxJY31jqt22uww@mail.gmail.com>
From: Brian Kao <powenkao@google.com>
Date: Wed, 12 Nov 2025 17:29:34 +0800
X-Gm-Features: AWmQ_bm6yVAxBQBYLc5dlpBZPSzRJBuD2oWZ9PsLsko59Gxdh4yxUm5oFNzq8YQ
Message-ID: <CA+=0d2ZpZkTw_2Wdnz4NKS3ZuoQHH5rESxKNkUNwkxdeM2tKMg@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume error
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Cc: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>, 
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, 
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, "mani@kernel.org" <mani@kernel.org>, 
	"James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[RESEND using plain text]

Hi Peter,

This log actually is triggered by fault injection when wlun is suspended
echo 0xf > /sys/kernel/debug/ufshcd/3c2d0000.ufs/saved_uic_err

In a real-world scenario, this situation can occur when an error
interrupt calls `ufshcd_check_errors()`, which schedules the error
handler before the system reaches `ufshcd_set_dev_pwr_mode()`.

Thanks,
Brian


On Wed, Nov 12, 2025 at 5:18=E2=80=AFPM Brian Kao <powenkao@google.com> wro=
te:
>
> Hi Peter,
>
> This log actually is triggered by fault injection when wlun is suspended
> echo 0xf > /sys/kernel/debug/ufshcd/3c2d0000.ufs/saved_uic_err
>
> In a real-world scenario, this situation can occur when an error interrup=
t calls `ufshcd_check_errors()`, which schedules the error handler before t=
he system reaches `ufshcd_set_dev_pwr_mode()`.
>
> Thanks,
> Brian
>
>
> On Wed, Nov 12, 2025 at 4:17=E2=80=AFPM Peter Wang (=E7=8E=8B=E4=BF=A1=E5=
=8F=8B) <peter.wang@mediatek.com> wrote:
>>
>> On Wed, 2025-11-12 at 06:32 +0000, Po-Wen Kao wrote:
>> >   google-ufshcd 3c2d0000.ufs: ufshcd_err_handler started; HBA state
>> > eh_fatal; ...
>> >   ufs_device_wlun 0:0:0:49488: START_STOP failed for power mode: 1,
>> > result 40000
>> >   ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume failed: -5
>> >   ...
>> >   ufs_device_wlun 0:0:0:49488: runtime PM trying to activate child
>> > device 0:0:0:49488 but parent (target0:0:0) is not active
>> >
>>
>> Hi Brian,
>>
>> How is ufshcd_err_handler triggered before the parent device
>> resumes? I mean, what causes ufshcd_err_handler to be
>> triggered, an error interrupt or something else?
>>
>> Thanks
>> Peter
>>
>>
>> ************* MEDIATEK Confidentiality Notice
>>  ********************
>> The information contained in this e-mail message (including any
>> attachments) may be confidential, proprietary, privileged, or otherwise
>> exempt from disclosure under applicable laws. It is intended to be
>> conveyed only to the designated recipient(s). Any use, dissemination,
>> distribution, printing, retaining or copying of this e-mail (including i=
ts
>> attachments) by unintended recipient(s) is strictly prohibited and may
>> be unlawful. If you are not an intended recipient of this e-mail, or bel=
ieve
>>
>> that you have received this e-mail in error, please notify the sender
>> immediately (by replying to this e-mail), delete any and all copies of
>> this e-mail (including any attachments) from your system, and do not
>> disclose the content of this e-mail to any other person. Thank you!
