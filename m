Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63749242D89
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 13:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782220123; cv=none; b=HH/3xUwiEJ5ck0QXgK2HWSLAxTq/KIgArpnIN83X2ESTo1FRdQaAu5kYAhJcvlpyy+eO3RhW9SPAU5/Cmaxuc95dZzr6j0lgIRPN52zo+LAL4sdIWbT/Xo/TCyuqZPSf9slDDZC2iTlXvAc2OTi36yyQCzgdWidTzeBORHjlAR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782220123; c=relaxed/simple;
	bh=dX3M0lxFvDhCVyZaJikvZU/6GknByqMsbJzElYPQrBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hFMNR/KsOpyTvEqFoUpzWKOHj9XzPBxmZ0d0UeJdhz/FE0a7Y99Z41v0JpreMmG8Lt++UADX0tHci3puON5aSAz202R+ddz/y9mZVEkN3i8gnZIrO5BMBCXijBY8IV7j4QRauPfTJD7onAhb3qXUH12rOYNm1aniZ45zpxZMfMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nWGiDuI7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=S2OWOIb5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nWGiDuI7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="S2OWOIb5"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65NBZN1S4017407
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 13:08:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kq3/D/BC/RvOm7IrhRgaq8LAkg0fMyEGRtGKjug4xjU=; b=nWGiDuI7hd3h1Nh2
	sxaEBVJy8ctBKiiuBV9D5MC0Io66Xnz2xV7kbS8yEW/t8cgvqt5+p1au4bDfBuNa
	O2IoDpUk5DiZXOc+9Dk5WvRdfX3jf8hHpSfbNqbCPkYvmJCekvjrYCERCgVfTius
	ZV4ulqiLMPXyDFWS923F/IBLHvTQkPkcSEZGYYWs05jPejAlAAZHFzTGhykPVgmS
	kRUVwhITGmJia/1Lb4lSmqDC9zLq6WlkdXlewUtzW0M4hZU3WeLfep44bbeYCqlu
	KsBQfv1TlNK2oRQISW3MQHXjf4aCWnuBC6eLmxbTqG9QJVNA6NV9jb6bRWM6+FpS
	idZ39Q==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eygkjjcxd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 13:08:38 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8423f3e4728so3611285b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 06:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782220117; x=1782824917; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kq3/D/BC/RvOm7IrhRgaq8LAkg0fMyEGRtGKjug4xjU=;
        b=S2OWOIb5VQqJ8RhOLmiYZgzSFKmIP61wYOvHK/vdQ63RFYuq6bZ4iK/7qOsEJoWcsG
         ZQyQ2SdmZUAy7md/Q0FwirFOovy/2HEsOLfUL+pIFnNYJ24ZoFsVqwJo3w87vgj4XHdN
         azafZjakBY9lkkyKk8zH0dUJDgtgaJ38BRaQ7KOCAgTYtgZewyVHaHCE1gJ3rkPB3Kw0
         bLhhI4wstYo3KI1tfJcXn1sCGzjEOcP+LzOWXipLi9rXD/u1HSQLzf2QVIVVwG+ZV/37
         P0WTefh18apwn0Bq2sJqJiQOhcw271+s0gswQqX+eXQBRrAd9+vpVdbcKuVZ24Biz3Nt
         uZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782220117; x=1782824917;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kq3/D/BC/RvOm7IrhRgaq8LAkg0fMyEGRtGKjug4xjU=;
        b=JMkw18jGorC0xttStLlOCM38DYIQDLagN8pD6ByVXhOeZbxWqQhSw3zIKca30wpI8a
         KRNjiNj64AetmYon/20PGeuntmB5RbzSVyt6igyFwXHI/NQqeWfC4EC2g96lyKlz3f/o
         HrIQ0ViW9TThXyZa8oYkAoZiKK287YOWPmTpu9hQx8O1ZMzt1xUK26eCKoZijYeT5D1F
         D8Dk0/RI9fDQoGjaPPR6r7D+MMb29QyOIb6PT51sMLtvksW9Dtj7smsHsXrqUq0d5G2y
         acNi8wx2GEcVdU91xfE/hYV9kUFphJM/Iukp539V/Wmyy2UNBSJzngkecbF+6kR4kZs1
         F02A==
X-Gm-Message-State: AOJu0YxQwoo0Ya31evFpUp8Tri+M+EZVW5eLED4BvbRuWYaE82SgSIql
	za8M5JfTMnTD4LgFajrc8i9lqBMS5NzoaXVsCqmAiB04JTvdKaKvqDnIz+qLXupnMI3QLh4fOSy
	XKVr7hpTZVKI+o7s0LesZEKQcU4joHM7/Hulpa4pnsgZGhnrDa6nG/Fmu+89p5duBX7rRyJZf
X-Gm-Gg: AfdE7cnY1vE7rt4JpA6sMxwx5zhkmfavEySQaT7lY0EkQ7/lP14pJILoXWum9sR9b9+
	jyd4blz9nELhVFmAejPRm6kCusekeUwAbHKHM0exRE8uLRE+FASBojGt18uxHhSb5l1Wih99Ea0
	G7OPJaCnEV4X0i4XjjsImcR+nqh4aLC99Nkwi+/Tb0F0sp0fA5bc83ooiNym4velLMR+ARiiRiF
	pKQ/Cu8ipyKolU5cgLlGRdwE3yrA0KGiC7U7T6FVksw4rWSPt7PiKG9wwFlQPQggdE/jaN32S5p
	xilCU08ccjqecYIGD3k/QZVv+ZLvKXsECmX1wgpEOBRgrxHB9cy6H8NklZqap5X59LEWcO1X6hf
	JyRbDrDkM3f3S9wH6N/uBUFONX4Rr8jdkOWekCThJs3qgn6C0vITElxXTLp4FTSGg67Rkh/olDl
	N4
X-Received: by 2002:a05:6a00:950b:b0:82f:9985:d4a1 with SMTP id d2e1a72fcca58-845952fa1a0mr3520950b3a.24.1782220117022;
        Tue, 23 Jun 2026 06:08:37 -0700 (PDT)
X-Received: by 2002:a05:6a00:950b:b0:82f:9985:d4a1 with SMTP id d2e1a72fcca58-845952fa1a0mr3520921b3a.24.1782220116574;
        Tue, 23 Jun 2026 06:08:36 -0700 (PDT)
Received: from [10.133.33.180] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564e745cfsm10655846b3a.31.2026.06.23.06.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 06:08:36 -0700 (PDT)
Message-ID: <96c0d9d2-d902-4e07-9854-2ca5ddcc5eaa@oss.qualcomm.com>
Date: Tue, 23 Jun 2026 21:08:31 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: ufs: core: Tolerate RX_FOM read failures in TX
 EQTR
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "mani@kernel.org"
 <mani@kernel.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20260620080322.3765210-1-can.guo@oss.qualcomm.com>
 <20260620080322.3765210-3-can.guo@oss.qualcomm.com>
 <bd4c01727a6a3f0b4d1cb716caa35662fae7d41a.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <bd4c01727a6a3f0b4d1cb716caa35662fae7d41a.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDEwNyBTYWx0ZWRfXzN7jPvXK94R2
 BT3DwgBCebF//Al6koRQc1AQUMcyd8kqu6UKoiuSWthmo1QoU1s70RhsB1ze1EsbtJRolChGVQ0
 aWF8UGZrubN5ksIWNoFEae+HEDqAUXWRK9SY9vlRL35mMTKALVdhJF4IiZfNHADIAVHDYYyIegX
 RqYQ2jeDcPuMVBqEKbNwi85tKGO8GxLkYowTVaF5i+f7ueJy7S55yQ0oczvDRqTsmD7oZVtskoa
 2NmmF6f0uB3/G3EB7AdBv3mx4urwC4/NJ2LCQV7DQ6mTIrFfA6nWLAc4VtDusElJM2m5d4OSijG
 /d1joXJx1ZDqyWvjhrTifdEYZeP8jHxcWTiI55NFE3YWmzO8NnRUUhcXXl241a6QeNvWAfBApP4
 ame1eBfYhsRRkiTbOMaVTUf+ump/lgJymU2QIzFRLyBVF3wo/oHFTTTcqBYeCaSJ0JL9G41Rv8a
 LaMEhDveQkkmGRy3jAQ==
X-Proofpoint-GUID: cuxlSIefY_N6ThLAv_h4yQzKXhoh-5Yk
X-Authority-Analysis: v=2.4 cv=SoKgLvO0 c=1 sm=1 tr=0 ts=6a3a8556 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=Muby7z2g3K1BkzpCY48A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDEwNyBTYWx0ZWRfX6hQ08AJcVlDA
 ZokiXou/Ep7+YTvDvkIxzQJ6R+5lyFv3CSh4OJkROufyqpWOQzKRcxLl9pooWphlrIDnd2Z7Lu0
 ZQt3u5Feoi2LrT6/u4zZ2iVmkasHYgg=
X-Proofpoint-ORIG-GUID: cuxlSIefY_N6ThLAv_h4yQzKXhoh-5Yk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_03,2026-06-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606230107



On 6/23/2026 5:05 PM, Peter Wang (王信友) wrote:
>
> On Sat, 2026-06-20 at 01:03 -0700, Can Guo wrote:
> > @@ -494,22 +496,30 @@ static int ufshcd_get_rx_fom(struct ufs_hba
> > *hba,
> > 
> >         /* Get FOM of host's TX lanes from device's RX_FOM. */
> >         for (lane = 0; lane < pwr_mode->lane_tx; lane++) {
> > +               h_iter->fom[lane] = 0;
> >                 ret = ufshcd_dme_peer_get(hba,
> > UIC_ARG_MIB_SEL(RX_FOM,
> >                                          
> > UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
> >                                           &fom);
> > -               if (ret)
> > -                       return ret;
> > +               if (ret) {
> > +                       dev_dbg(hba->dev, "Failed to get FOM for Host
> > TX Lane %d: %d\n",
> > +                               lane, ret);
> > +                       continue;
> > +               }
> > 
>
> Hi Can,
>
> I suggest setting h_iter->fom[lane] = 0 when an error occurs,
> as this approach is clearer and improves code efficiency,
> for example:
> if (ret) {
>      h_iter->fom[lane] = 0;
>      ...
>      continue;
> }
Thanks for suggestion, and I like it, let me adopt in next version.

Thanks,
Can Guo.
>
>
> >                 h_iter->fom[lane] = (u8)fom;
> >         }
> > 
> >         /* Get FOM of device's TX lanes from host's RX_FOM. */
> >         for (lane = 0; lane < pwr_mode->lane_rx; lane++) {
> > +               d_iter->fom[lane] = 0;
> >                 ret = ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(RX_FOM,
> >                                     
> > UIC_ARG_MPHY_RX_GEN_SEL_INDEX(lane)),
> >                                      &fom);
> > -               if (ret)
> > -                       return ret;
> > +               if (ret) {
> > +                       dev_dbg(hba->dev, "Failed to get FOM for
> > Device TX Lane %d: %d\n",
> > +                               lane, ret);
> > +                       continue;
> > +               }
> > 
>
> The same applies as above.
>
> Thanks
> Peter
>
> ************* MEDIATEK Confidentiality Notice
>   ********************
> The information contained in this e-mail message (including any
> attachments) may be confidential, proprietary, privileged, or otherwise
> exempt from disclosure under applicable laws. It is intended to be
> conveyed only to the designated recipient(s). Any use, dissemination,
> distribution, printing, retaining or copying of this e-mail (including its
> attachments) by unintended recipient(s) is strictly prohibited and may
> be unlawful. If you are not an intended recipient of this e-mail, or believe
>   
> that you have received this e-mail in error, please notify the sender
> immediately (by replying to this e-mail), delete any and all copies of
> this e-mail (including any attachments) from your system, and do not
> disclose the content of this e-mail to any other person. Thank you!

