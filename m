Received: from sonic301-20.consmr.mail.gq1.yahoo.com (sonic301-20.consmr.mail.gq1.yahoo.com [98.137.64.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BD779DC
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 03:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=98.137.64.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717731642; cv=none; b=PNwkFvEEBp8dI16sDn6Kb0hbi9upZKt/cKWBq5jT5s73JjftJIXv5onQmM/oN0P6FGk7mJcCMZqStN3OFxvyM74LqZTTV0p/r4gCt6VNSeYOE3MEM/ntPIIIadrdu5M/QgEvOcDBm6M7N80X7rhP9esGZ8Mi6+v76gXwK0pgVjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717731642; c=relaxed/simple;
	bh=bue3JtM59gCHPb3/MA4YuPASt++NJ+AkR9hEtDleJQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j8VoS7Ojxje++dkqT74HIEow7I9G8f1aGxmQ6pD1S99pdLbWTrxmzBs9urHBqEPtnEjl57qMAMuB+qgnFKjvuUCUiuxNpDCOSPD6Sx7lL7CIEAPVwG16m5RCc8AvRClliFWxeq2PVgmIF/CRyLLao4MGwTz3a3YQBJlOkfLMtww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=J37sF5+s; arc=none smtp.client-ip=98.137.64.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="J37sF5+s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1717731641; bh=+Jc4NLWEcBYVUaXY827BS4XfdcmOeE+CPKXiNhnJHAA=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=J37sF5+sZYaXFrlk9a/iW3vVtATXqG5WiAb5h3icse+6mBuR9SX7M5lPjMK0RuJZZxy2xrSAsjV7uAaBwHa4YI6nj9gQFYr0duZrro1h6h4aklsbULrfGsBqIs+7Knyq317RSBG6+crMkL3KTo3GDlFHJCfcBmi5of4F/dkeaD6orsA3efnjhmvUo/qKoSbZSDrrOFIl5gblNDlKCJjH4iHUx2YdXDU3o5/AP8FskepJRq6uUc1KZbyyfOrWrAhumo0Ppe9PvcINX/SpTEmPKGBHDb7Gth1Of08Ry0+0UCB24jS0GABECb788jsm5hjhT9i6guJGoBWSnZlVtkDSRQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1717731641; bh=xu+uzunCmbXYz6u8zdUctLPE8hU2cbNDbeR6co7Stxq=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=BzbBEr5RzI9dUyYBbhzPpUKwZLxXRwoQI7TJGDtFig36183eUF2kj2KtyNJfVIKSgOaomSDMwVE9Olj1j0OtE+eSZ403kbYEEPMT9DSNC4ubBHJvjdyKednX0czzSXlysBFA5d9O3zsqf5fTXMYDImznOTz5Gy8fBnpJ+l8FCepO0vHSEu5uRGtuEMrLPInU9ZDHr40IMztfmULeJSvpGPAB+EMJE+p3UrY3EfaZTqgRzfrf5QzCSLjtQZbyg3HQ5ajCe5DK6Bn/EF4byKt6/rtXyqESoHYCxh2/YeeLlB6e69nPimmFm+zdPgJv6vneOK9NfJ4b3vJF62UkXYki+w==
X-YMail-OSG: jnzRMfIVM1l9v0wbN9a1N2w1UyQVg4B2Dfch0cASSvKGBgMK6afysTr1y5tR.RC
 4zu7vztXi6Z.ZYLN.6lEZORt1E1AHbGItOJVDl26iUHjdm0ux_zq7bi7MQopaB1eSD1XhiCqSshJ
 pmCYHtFWJws.uArFmkhAaSE2YSEEGd2HfJFU4fDpzvL8SaFtDWec0Q4.corVQZrH7oDG7LLJmoj2
 U1yexc0t_ZonQFQc6QFyPrwpVmZNH4rptpaF20aWiA3UjyGizvUePeAKFL7tVB1LanREpQw.rd7v
 ojwyk4FpdbrWAwSKUrYCyLnAgIPdpuwB5Kw5hj0xuiq_5LK9R0GTtoI9wTt0rBpVtSCh0ovh1Dn3
 6XwxGq9F0NZONxcb74VT0r3cnvbOS4mWv2l3QlvDE.HWGTTu1aMSXqQxOkIq9Q.vLfnKIoZj_KSP
 y5mu3.M0vyxPZpOlDWaglTK.cMMlsT.e_4X2G.GenfKSs2_RdGsr5Kxj4s3mT1Muf9HZ9d00X.Rx
 wPdH_rN2HuQWWxEPlgRih66WMfp74U2S2B2_o6u0yqQ9VpLPIAL2ahdxV_dGPRKRq5yk7y58.7lP
 BOrnsTssBoIVEYuH8pU4_LDAcwXyXDsxaPouTrtXRC_jt06p9Mm2ZxkexJeRKv5gkZKAysfFYQFD
 AuxsYQhAn5OdtTM81frxPH8WM.VHsFHKzyVU5ylRYftjfoHRW20Lx_8PhzbCMOQM0fHwzbYWFdWD
 SwoIogm4TBR1EZ76soIxh3A7iltsfx38mvytKk7acbMbg_RVwH8cw25rckCb3eOA7CvzWQc_lfao
 psaou66n8eCjFPaGbXeZrliapZEDWHGXQOp8Z7WKAbOJtmCrNKL5irdAGsr0CNdzGxuu7OCa4aAM
 g9vOSAVkoO1hYYzM9w_SthZ2L4TdHiJ0N.hUdB70lcgUgh4bXxGYgHsm9sJzUUCs1RlRRUR8_fWH
 G4qQBuDia1XfSDQ8SRDIE4kMUimbBEzPaMUNtBYjHnw4NZuHSb_CJ17XQ5BlLylLEUp5IRtZfpVb
 u2S0OjeZv_cCiwnBUp0p.1faY1wRam5ifZ366MpTdide1jrnsymVYIs1w23YT48wEO.WrmPT1t93
 wx1U1Nveoj4KQNzZHD3Hip9ct3SI.1r4.ezg_PMoDLk5SUgqc__WJQM.cKzdkbHXWJdbBIIpD.bX
 OvZQuzE4RyRGLUMaUYBwiimnf1DnGngNV06.nvmVJvJVxH7jeFmOltda6sRipuZZT_1CJjI9l_mF
 PsWHvFjZiI2gXtd3wp66hJy4MjW7ZUIuOxxX483mVT5uROzB8QFr1aotHyox25OzFgpLrRiR2CLf
 brAcHj7HeFq.tiO1oVV7gBRQUwi6AnlgRBZWi8LAwppiFDoMvMOibLcpOEb.rTto.qsdtacHgrBJ
 9pPqfM2gpqCS3XqCgRA.iNDhOpW7K814Q6xRo_TiHiljD8JZ8BecOijvhp8_7seYjCw4OTJwa5B8
 QCreSuiM_k6mfDzf5j4ENMK04U3OyUmnN0L.EF3eney7K_Wiyy3RZ9kfCEJk27x.p5myk4ib4Js_
 LWmMFZMx7pXag5Z89SehYOYfgQXgikG1a2tGLe8ytklXglCcvM068QK1VO.ywbNusRA.YrFCufFj
 8kYw30SQ63oEY4CooBaVaj.KdDMnizvBm8yuPvzdOWPmn50e_A3eCdqVlCp0B9niMxYxToXelsXH
 MWvm4lHHRANNd7hDmYaLCRlY6h4VobLc28S3BB7BxgTOAkDd0PSaOBUKFUyJpLrXxsJJWbvJoNPM
 dXntspyseLZUgy5YTKpSofhlmn9W8aFSsY_Yuvm6f_EC7_lHdaCe9T5A01ulzRE38mkgy_BRBggp
 BrbTyhiIYocKdkj4mGBlTuDGKuI6T_PYIgFljkSUTQa3a4sC5m8LbBmlE2BX9O.O3.f7GYnoyRhP
 FU5gCXkz7P4zzsKsa6XP2n.BP.4.ow8Q_ah9qA_r0gEXGwsp8HhpbnDeKE45MplQE0NgkEHy_19F
 m2Cc0QEa4cPZJHQgr38.35102aQ0XzyVVYvq4iBHTjKNxCZ7keo6p6k2OHwz9iPXvnxbbu0co6T6
 VjQwiwtEz.ZAEim1qEVLMM3wqEGCJeOw1QA8nEcUJJiWT9fo28.M9_J0VPUqh0sarzNfMH8yeFBz
 CxAL.ZibqE_8wRS3ihal.HV89170dEnwQex5ar7zub83KZZGnUcra_4EuNZtdNTvHttaQ_COwTh5
 Xxy6iNrf8rGDGzrrrG7.KMW7759FwADwHoKqdXX.a890YJT3FGQ--
X-Sonic-MF: <sgoel01@yahoo.com>
X-Sonic-ID: 0e569a19-2113-41a8-bdad-a5b9f423f4ec
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.gq1.yahoo.com with HTTP; Fri, 7 Jun 2024 03:40:41 +0000
Received: by hermes--production-bf1-5cc9fc94c8-f7jgm (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 384f9e98e1da2ce7f9ca1a16818211fd;
          Fri, 07 Jun 2024 03:20:23 +0000 (UTC)
Message-ID: <a5b96b5f-9a6d-4356-afd6-9962829cfaea@yahoo.com>
Date: Thu, 6 Jun 2024 23:20:20 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] uas: set host status byte on data completion error
To: Oliver Neukum <oneukum@suse.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <675774215.2024605.1717624320352.ref@mail.yahoo.com>
 <675774215.2024605.1717624320352@mail.yahoo.com>
 <4a60e45b-de56-414f-85eb-71541e5d2cf5@suse.com>
Content-Language: en-US
From: Shantanu Goel <sgoel01@yahoo.com>
In-Reply-To: <4a60e45b-de56-414f-85eb-71541e5d2cf5@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.22407 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 6/6/24 2:30 AM, Oliver Neukum wrote:

>
>
> On 05.06.24 23:52, Shantanu Goel wrote:
>> Hi,
> Hi,
>
> thank you for the patch. Good catch.
> Could you submit in the form that the Docuemntation describes?
> That is inline and not attached, with your sign off also
> inline, preferably generated with the script?
>
>     Regards
>         Oliver
>
>

Hi Oliver,


Thanks for your feedback.  I'll regenerate the patch with 
git-format-patch and resubmit it in a separate email.


Regards,

Shantanu


