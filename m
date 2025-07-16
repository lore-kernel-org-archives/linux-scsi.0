Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4A11A76BB
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 13:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752672934; cv=none; b=njOaRtpiYeNodcTjygnidn21X+DIT2qkagbWf/y6O4ypt15+NzE0QudcXEW8dGk2lVDhDOq4dQarcewP/kklZ6RHUsHzi2VZ+6GokjmoVZHFz6yUK7ADmIFhYyyLJCUktxT89mH3RT7UIIWTyWbQgX1aJ8IxFThs9eQvRVFvcvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752672934; c=relaxed/simple;
	bh=2oKO/AzVdfPR8Wpjzi8Nl7IZi7J/WRzySf6dhuzgK2g=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l/qn163TrqgWeqDV+jGBZnsfw5iF9/1EoVNOgztxGETjhXT6eLFs19LlKOgVIcCJ66mGRZrCtWto5FGL0ApthCVbE3tFwGOXuU35Vod3MbUHvayLLib+MoOAJwF+54NXVKpX279t2HJkO8SbDODcuwdhlI0XaIR+6NHaes1MV0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pltdgmgq; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pltdgmgq"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6099d89a19cso11989465a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 06:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752672930; x=1753277730; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2oKO/AzVdfPR8Wpjzi8Nl7IZi7J/WRzySf6dhuzgK2g=;
        b=PltdgmgqpWfsV57YqygbOSH4v6cdSoNsXYPWM5XXSCk7N/U7Y4XHvH3u5K5Trtcm3h
         1Qz/AX+dk4mO2vG2ZhI8gRtYHtdlDpFuB2h/amjtzflAUr5SZNOkKootr5zEEbT1aSPt
         tklXMAgD9HenXikKFKWYGVgLHRrnGwH7ljt8T6rN4+no8/KXs1VKi3zfCtTgHud9b1ve
         KEkwIMCTa9qx/s7ifCy0Nmvl6NbR6NrisHZuh81cQEqmcFLMwv2XbM3udi7WXeqldOWT
         eeasYmi66i/a7pcQuKbX/dCv/gcvSStJO/2l32UDNhI2swwcwl68JPt/YyNU3GSTbaUt
         N0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752672930; x=1753277730;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2oKO/AzVdfPR8Wpjzi8Nl7IZi7J/WRzySf6dhuzgK2g=;
        b=wUbBz4jAChWAfweaQoQ3g1XT+mmWN6Pff0hlwkjEVimHUe2Oej8LvkY0G+ENNG7dtE
         BF9lDBmvkWJmedO5FgnCZAfyq5Wy7WiNvvMQZk7tv/J0csoojH5BPdSD1p/p7BmKIjxd
         A9lAsnoDCRi9AnuB18eCyRmDyf7ByXC5C6dRiIH/OkKPTqXA6+HCg4jNuAe7GIg40Dnj
         ve0JOdfKksWb+sqcSoh3LrpnMYmWtbN5KX/A+YbgkKDF4mj41NECylU/OsnfoQPJfiPD
         8vEDn1+FjUm1DT9jFCqXAlxJl1V+qgXV3PxxzbKUgaID8jU5uvmiU5tcQWibfOxxBEom
         V2uA==
X-Forwarded-Encrypted: i=1; AJvYcCVYPpEezrqd/btgu5G9j7HohUYvQsKUbaQQWUI8qgnYRGSxEYCcOi3DW9tClkBrKrdT12R7d3n3JpQq@vger.kernel.org
X-Gm-Message-State: AOJu0YwP6EkLmP2X+Dd5ltY1paUeBn3SJzGBimWO03fNoHNwpK84P99E
	td5Pt+7bvMTNBTWQt6qFowsjv6AdJv8zabQBCrnpOZdK7KBXs3ADHuwT
X-Gm-Gg: ASbGncvJXIim1XODG6h7SR3qszEEFlYkTaFy2bglr9+vNhXenvYhJ3HPuXHzuYlZv/p
	m5WotsRt1D2ktV1hS1lTvUKkPa25Wnv+IurEshFL/aVUJYDCOcIdIBezXsMFE2IwMNf+yYral99
	PhnnQbopm5ePOtw10y/hZbBWPjAf7xWAfPxe6PSp01rTdhbSUdDjOPrNhuYrrKBQtdnjNqmWBRw
	+K+K64iTMNnajVFrCqLsrTdNCgTk4u5RZtml++7BSWYZh4/xLqEpKYRMLBkYCOAWPTEykUhSstA
	JvFBRpgMmUko06OCHDg5+ZN9ngAb3mqSzkA8xoHQCCtVxSmuZi51J6x4wOtxuRZOVnVpO2FWv0V
	LslJJE2FcZ0NHVK6q/MCKlBnH
X-Google-Smtp-Source: AGHT+IGwp5ed/fGA/zS30OvBkiVMn4KaEbT0ajD3WAq/QbAM12JGjnSebE17T5kMQhQNHLlSoE5ktQ==
X-Received: by 2002:a05:6402:2347:b0:5f0:48df:25ae with SMTP id 4fb4d7f45d1cf-6128590b4bbmr2528072a12.2.1752672929958;
        Wed, 16 Jul 2025 06:35:29 -0700 (PDT)
Received: from [10.176.234.34] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-611c976d9f7sm8745537a12.54.2025.07.16.06.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 06:35:29 -0700 (PDT)
Message-ID: <ff93d49524dd1b79968b690753a3727e695f852d.camel@gmail.com>
Subject: Re: [PATCH] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
From: Bean Huo <huobean@gmail.com>
To: Seunghui Lee <sh043.lee@samsung.com>, alim.akhtar@samsung.com, 
 avri.altman@wdc.com, bvanassche@acm.org,
 James.Bottomley@HansenPartnership.com,  martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, sdriver.sec@samsung.com
Date: Wed, 16 Jul 2025 15:35:27 +0200
In-Reply-To: <00f301dbf626$2b2a1550$817e3ff0$@samsung.com>
References: 
	<CGME20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b@epcas1p2.samsung.com>
	 <20250714090617.9212-1-sh043.lee@samsung.com>
	 <b8fa773234058e68e6006127b3cd848046b75e6f.camel@gmail.com>
	 <000901dbf52f$63a69090$2af3b1b0$@samsung.com>
	 <cd0959939d2fefe927b66ca12620c094c4cfb7a2.camel@gmail.com>
	 <005801dbf61f$7287e7d0$5797b770$@samsung.com>
	 <00f301dbf626$2b2a1550$817e3ff0$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-07-16 at 16:49 +0900, Seunghui Lee wrote:
> > -----Original Message-----
> > From: Seunghui Lee <sh043.lee@samsung.com>
> > Sent: Wednesday, July 16, 2025 4:01 PM
> > To: 'Bean Huo' <huobean@gmail.com>; alim.akhtar@samsung.com;
> > avri.altman@wdc.com; bvanassche@acm.org;
> > James.Bottomley@HansenPartnership.com; martin.petersen@oracle.com; linu=
x-
> > scsi@vger.kernel.org; sdriver.sec@samsung.com
> > Subject: RE: [PATCH] ufs: core: Use link recovery when the h8 exit fail=
ure
> > during runtime resume
> >=20
> > > -----Original Message-----
> > > From: Bean Huo <huobean@gmail.com>
> > > Sent: Wednesday, July 16, 2025 12:22 AM
> > > To: =EC=9D=B4=EC=8A=B9=ED=9D=AC <sh043.lee@samsung.com>; alim.akhtar@=
samsung.com;
> > > avri.altman@wdc.com; bvanassche@acm.org;
> > > James.Bottomley@HansenPartnership.com; martin.petersen@oracle.com;
> > > linux- scsi@vger.kernel.org; sdriver.sec@samsung.com
> > > Subject: Re: [PATCH] ufs: core: Use link recovery when the h8 exit
> > > failure during runtime resume
> > >=20
> > >=20
> > > You patched ufshcd_runtime_suspend() to return -EBUSY if
> > > eh_in_progress is true =E2=80=94 meant to avoid suspend during error =
handling.
> > > I don't understand why here parent is not active?
> >=20
> > After checking the RPM devices, I found that the parent device is
> > suspended due to the failure of ufshcd_wl_runtime_resume.
> > Even if we guarantee both the completion of ufshcd_runtime_suspend and =
the
> > error handling completion to avoid races, ufshcd_recover_pm_error can't
> > fully recover from a runtime pm failure scenario.
> >=20
> > >=20
> > > would like to try return -EAGAIN?
> > >=20
> > >=20
> > > Kind regards,
> > > Bean
> > >=20
> >=20
> > I've tried that as well, but it doesn't work either.
> > [=C2=A0 328.915154] [0:=C2=A0 kworker/u32:7:=C2=A0 941] ufs_device_wlun=
 0:0:0:49488:
> > runtime PM trying to activate child device 0:0:0:49488 but parent
> > (target0:0:0) is not active [=C2=A0 328.915156] [0:=C2=A0 kworker/u32:7=
:=C2=A0 941]
> > ufs_device_wlun 0:0:0:49488: ufshcd_recover_pm_error: rpm set_active re=
t(-
> > 16) [=C2=A0 328.915157] [0:=C2=A0 kworker/u32:7:=C2=A0 941] ufshcd-qcom=
 1d84000.ufshc:
> > ufshcd_recover_pm_error: rpm set_active ret(-11) Due to this error,
> > pm_request_resume(q->dev) for each scsi device can't execute.
> > This causes the I/O stack to become stuck.
> >=20
> > This issue arises from the race condition between the runtime pm worker
> > and the error handler worker.
> > I believe it would be safer to handle recovery within the runtime pm
> > worker itself.
> >=20
> > For reference, ufshcd_link_recovery is useful for the similar issue.
> > (resolving the race condition between the runtime pm worker and the SCS=
I
> > error handler worker) https://patchwork.kernel.org/project/linux-
> > scsi/patch/20230927033557.13801-1-peter.wang@mediatek.com/
> >=20
> > I'll add Fixes tags and modify v2 as requested.
> >=20
> > Thank you,
> > Seunghui Lee.
> >=20
>=20
> I would love to find the previous tag, but it's old code.
> And plus, it's hard to pick one commit for Fixes.
> Please understand this.
>=20
> If this commit is okay, please review this commit.
>=20
> Thank you,
> Seunghui Lee.



Based on my analysis, the tag might be:

commit 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and other=
 error recovery paths"),
This commit added the error handling logic that calls ufshcd_set_link_broke=
n() and ufshcd_schedule_eh_work()
when ret is non-zero in the ufshcd_uic_pwr_ctrl() function.

your patch adds a check for pm_op_in_progress to skip the error handler and=
 use link recovery instead during PM operations.

Therefore, the appropriate Fixes tag for your patch would be:

Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and other=
 error recovery paths")

But, the problem is dd11376b9f1b ("scsi: ufs: Split the drivers/scsi/ufs di=
rectory") reorganzied the UFS code layout,=20
it is true that not easy to add a proper tag,=20

Or we can use both fix tags, or just the last one.

Let Bart comment on this,

Kind regards,=20
Bean
