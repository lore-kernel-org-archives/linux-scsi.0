Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9C220B7EA
	for <linux-scsi@vger.kernel.org>; Wed,  2 Apr 2025 07:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743580173; cv=none; b=hccMcvjNluxGp31iFTp8N1U/x6tl6IBGh6H78uqyfxgvOLWrv9VfyN8oexV9Rfu6w7ZxtOPp0o9VW0fGYMgnr7i5cpoKZsbgYE/w/nXtcOPRvKviyyOkittMzTskeLQDAXyb67VA/rA4/QeNYuKBRzlrYZdUaHnBWyhPm5sPxOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743580173; c=relaxed/simple;
	bh=xmsf9FMkTnLa6YAKeXtlG8+Rxsp/QvAWVR2i827suLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hw+v2pvJJc8i3bNoQQqP2RAv1f7weAKH1BI3JHSo9bT5+Moeh0KW4Q4EDq7KohxZMDfG3sOZs5YdMdbfRRG26ZQyW7j/F/oiAeUorSzTA/X1PcqlU0YPSu4HVtpJ/iGpIpsMyRaY3WciGA0J92sMOCS3szm8T9Zm8vePJEvB7Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XLz/UdiN; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XLz/UdiN"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-301302a328bso11008873a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 02 Apr 2025 00:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743580171; x=1744184971; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2aqgbCkNx0PW0vbsTMdXqyfUcPH4h5hP0whKc+xvuD8=;
        b=XLz/UdiNOeZYPvTlaxBXuCF4iyGbtGkpwLGU2CdXzfEHhWDDUToWKOj62SV4eLL/3X
         PNQrjiTWzlrwQlQysPxAmSqdZ3YmDSeijR4pFNX4EpkfNIZ7+3RlB/UV/Ua2d4Sh0DyD
         kNbYn8yw5i73p5ipWIcOdGkxI5k06wDcXZl2hGQ7+M8HD+mRLyKxuZFA33HlAQMsk4jS
         r2Qc0D39PYtaaMjsC+q9BewowLdm0f5SuJU2XWd7N5dncbVb3y8ogmqY5n3lhoi7d132
         agcypRSlU6ryt5uIqxrEZjz5BAOL3OnR24mlZoSuMGZXJwmuAHW4L0XOaN8bqg7WMaul
         onDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743580171; x=1744184971;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2aqgbCkNx0PW0vbsTMdXqyfUcPH4h5hP0whKc+xvuD8=;
        b=wyz5RiKVMgUu4dGZA1ggMDZVQK3gXHWs3rmKdARaLz3mwFdc79dQ1NCRyg/4jeq1PQ
         dx5/GukpmeA8A/YDDx+aSHGxRSA5xzz7tiOk68KP7XxKEUUV69x1LgPwRxEWND3zsXk8
         +/DRx9E2Se8StordxTzJ+JJM9QqGKYAp2aUIxic329B3Uk0KzWXsoGg1CsxrZJdD/luS
         pQOZgAjWXKiitXLMe0t9GGnS0ErPcU9MerU+7ec3o75j+UGajtDCTGEJQUqPHBOslEu9
         b/YLlsY9WHYpCRT0UDM0t1dVKBSoFL/6qT4CZlv+YlBvEmsKyvWdQqjHI7rvI+aXAsp0
         u/uQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpHfv/PjvMMhuXEN1hPbwDDDwbHkQ5Bj0YxQr3bYZmf4QsnJt8SPMqOlwlPZ97d66uX1uYotnG8hxH@vger.kernel.org
X-Gm-Message-State: AOJu0YxUH1568N1TrIjeDfyNW9bejwK6cyoINog2PiX3tvX18C03M35w
	gZrHu/Cf2NtlcL7sRJuiKZ5Hv58N4nUQVLsg9YRrZLkYLuiYF0g5IvXdgsO3lg==
X-Gm-Gg: ASbGncv2Enn8TA8lYlcOed/4CvT+6PMJd9SzHTBwCzguSU3uL1PGYQnFaZKzrJYfbg7
	ji94CxFRwONYU+vTo5+mn4smt2mpUayZRrsHNNCqPdb7F1FMj8HA6nwdGZCGMtu1NDvepnxph/v
	lmXDtPFAKJH7UJiqxpiouVMlvjpgmMKQpDvD/OEJq7J6NCTDqrEOTPHfWXf6ZMQI7kCr+vw/Tph
	j3wX1smhPTqvnwT+W9wk7/qoEEiLWZrAuSIfXg71c3m24UCbldvZS5xQHKFv0VarM0LI3l4gv4I
	ZUC5k83G5iv3CbCI3AuvQtjhMEPgd6OdTkqbVLhUU/5CVCXIP6GNB+Gc
X-Google-Smtp-Source: AGHT+IH8Jzdp+kwIVinSdsTnAiNYI68lWe6D/QP0YRmgVUgFc10NP2fNsve2H8szQGsEUFhU7VB1aA==
X-Received: by 2002:a17:90b:2b88:b0:2ff:62f3:5b31 with SMTP id 98e67ed59e1d1-3053216ddc9mr24513921a91.29.1743580171478;
        Wed, 02 Apr 2025 00:49:31 -0700 (PDT)
Received: from thinkpad ([120.56.205.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3056f83ca51sm892730a91.13.2025.04.02.00.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 00:49:30 -0700 (PDT)
Date: Wed, 2 Apr 2025 13:19:23 +0530
From: 
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Arthur Simchaev <Arthur.Simchaev@sandisk.com>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>, 
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>, 
	"peter.wang@mediatek.com" <peter.wang@mediatek.com>, "minwoo.im@samsung.com" <minwoo.im@samsung.com>, 
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Bean Huo <beanhuo@micron.com>, 
	Keoseong Park <keosung.park@samsung.com>, Ziqi Chen <quic_ziqichen@quicinc.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Gwendal Grignou <gwendal@chromium.org>, 
	Eric Biggers <ebiggers@google.com>, open list <linux-kernel@vger.kernel.org>, 
	"moderated list:ARM/Mediatek SoC support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>, 
	"moderated list:ARM/Mediatek SoC support:Keyword:mediatek" <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: add device level exception
 support
Message-ID: <yzy7oad77h744vf2bdylkm4fronemjwvrmlstnj6x5lzjxg672@zya6toqv4aeg>
References: <4370b3a3b5a5675bb3e75aaa48a273674c159339.1742526978.git.quic_nguyenb@quicinc.com>
 <SA2PR16MB4251229744D717821D3D8353F4A72@SA2PR16MB4251.namprd16.prod.outlook.com>
 <c5ab13ec-f650-ea10-5cb8-d6a2ddf1e825@quicinc.com>
 <0a68d437-5d6a-42aa-ae4e-6f5d89cfcaf3@acm.org>
 <ad246ef4-7429-63bb-0279-90738736f6e3@quicinc.com>
 <3d7b543c-1165-42e0-8471-25b04c7572ac@acm.org>
 <4cb20c80-9bb0-e147-e3c0-467f4c8828ba@quicinc.com>
 <989e695e-e6a4-4427-9041-e39ecf5b5674@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <989e695e-e6a4-4427-9041-e39ecf5b5674@acm.org>

On Fri, Mar 28, 2025 at 07:02:20AM -0700, Bart Van Assche wrote:
> On 3/27/25 5:45 PM, Bao D. Nguyen wrote:
> > Thanks Bart. How about we change the current utp_upiu_query_v4_0 to
> > 
> > struct utp_upiu_query_v4_0 {
> >          __u8 opcode;
> >          __u8 idn;
> >          __u8 index;
> >          __u8 selector;
> >          __u8 cmd_specifics[8];
> >          /* private: */
> >          __be32 reserved;
> > };
> > 
> > Depending on the opcode/transaction, the cmd_specifics[] can be type
> > casted to access the LENGTH, FLAG_VALUE, VALUE[0:63] fields of the QUERY
> > UPIU. The __u8 array[8] would also prevent the compiler padding to the
> > data.
> 
> Are there any user space applications that use the osf3/4/5/6/7 member
> names?

Yeah, we should be cautious in changing the uAPI header as it can break the
userspace applications. Annotating the members that need packed attribute seems
like the way forward to me.

Though, I'd like to understand which architecture has the alignment constraint
in this structure. Only if an architecture requires 8 byte alignment for __be32
would be a problem. That too only for osf7 and reserved. But I'm not aware of
such architectures in use.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
