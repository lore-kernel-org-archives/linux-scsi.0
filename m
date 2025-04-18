Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE551ADC83;
	Fri, 18 Apr 2025 11:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744976758; cv=none; b=P+iWccP2ZRfx3DqTBhwBNl8BJyhSgUBfmKTXzAGaiwyso5xKlO8XrTEvJucFjfSGR3AcItR7z6snf9dsiXDl8BQYMNVzO/2ekVTm+Tg4HmtAVLY7W/ZHPZAu5VGoP8kgdhgu+ZXfSU9d9qiwpyWoNY0rcCXNHbaSiV1khfjkHTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744976758; c=relaxed/simple;
	bh=8sWcMKjQ6OT0tOeRZS/baZJCKkaENqyhduVFXdYqwvg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=dA9NECuFUsAh4+4z6vt5iDD12IGG87nhJJIqeQ9bhaxH7ZxaxEiRtYOijXI7E3j8O/ZHGf/1GF7xnaOqwkh1QunmII5mFU0yUQrXOmK3j8K+8qHRdql2bpUslUF9Bo+JHHnRTVzaqsTnMi/rIK8uYtuingOAhO/lc4z4xATh2D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRAdi/2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRAdi/2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E220FC4CEE2;
	Fri, 18 Apr 2025 11:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744976757;
	bh=8sWcMKjQ6OT0tOeRZS/baZJCKkaENqyhduVFXdYqwvg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=WRAdi/2WrQfahZ7+3VX//BZ5sKlZhjvyigm06fWPaaul2I+APGgVTFJp81yI7XBRi
	 7tJrvHd8QAVcLhJOmydcUsfPEgaStUgjEYbKfGSDLY1blniGfuBNp6fWF24Fun35UK
	 8Dvg6pxtX9gx1ZZI06u4BRsDya4JSSO6NJn8CGKQRdWBJAt62bihDkLM5zIpXOleTK
	 Hk2WgoiSD7pg43+9dSXmzQQJI/A7vY+ojHrOgCwruTv/JQBds2WeA7qBtj+OrK2Dk3
	 e24a5RG5+TJP3m9MB6zoP7od1+vufeXB4wevc02WLPGta8wX8c9BO72ekdFjO1ZzP7
	 Pw+1UwXT8r94A==
Date: Fri, 18 Apr 2025 13:45:55 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
CC: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_2/5=5D_ata=3A_libata-scsi=3A_Fai?=
 =?US-ASCII?Q?l_MODE_SELECT_for_unsupported_mode_pages?=
User-Agent: K-9 Mail for Android
In-Reply-To: <5cf44067-4e3d-49c5-93e0-721337b0302d@kernel.org>
References: <20250418075517.369098-1-dlemoal@kernel.org> <20250418075517.369098-3-dlemoal@kernel.org> <aAIQG2PpFMZeRwUx@ryzen> <5cf44067-4e3d-49c5-93e0-721337b0302d@kernel.org>
Message-ID: <DC50C6CE-E3FF-494C-8167-4B662B03A48F@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



On 18 April 2025 11:30:35 CEST, Damien Le Moal <dlemoal@kernel=2Eorg> wrot=
e:
>On 4/18/25 17:40, Niklas Cassel wrote:
>> On Fri, Apr 18, 2025 at 04:55:14PM +0900, Damien Le Moal wrote:
>>> For devices that do not support CDL, the subpage F2h of the control mo=
de
>>> page 0Ah should not be supported=2E However, the function
>>> ata_mselect_control_ata_feature() does not fail for a device that does
>>> not have the ATA_DFLAG_CDL device flag set, which can lead to an inval=
id
>>> SET FEATURES command (which will be failed by the device) to be issued=
=2E
>>>
>>> Modify ata_mselect_control_ata_feature() to return -EOPNOTSUPP if it i=
s
>>> executed for a device without CDL support=2E This error code is checke=
d by
>>> ata_scsi_mode_select_xlat() (through ata_mselect_control()) to fail th=
e
>>> MODE SELECT command immediately with an ILLEGAL REQUEST / INVALID FIEL=
D
>>> IN CDB asc/ascq as mandated by the SPC specifications for unsupported
>>> mode pages=2E
>>>
>>> Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-p=
age translation")
>>> Cc: stable@vger=2Ekernel=2Eorg
>>> Signed-off-by: Damien Le Moal <dlemoal@kernel=2Eorg>
>>> ---
>>>  drivers/ata/libata-scsi=2Ec | 11 +++++++++++
>>>  1 file changed, 11 insertions(+)
>>>
>>> diff --git a/drivers/ata/libata-scsi=2Ec b/drivers/ata/libata-scsi=2Ec
>>> index 24e662c837e3=2E=2E15661b05cb48 100644
>>> --- a/drivers/ata/libata-scsi=2Ec
>>> +++ b/drivers/ata/libata-scsi=2Ec
>>> @@ -3896,6 +3896,15 @@ static int ata_mselect_control_ata_feature(stru=
ct ata_queued_cmd *qc,
>>>  	struct ata_taskfile *tf =3D &qc->tf;
>>>  	u8 cdl_action;
>>> =20
>>> +	/*
>>> +	 * The sub-page f2h should only be supported for devices that suppor=
t
>>> +	 * the T2A and T2B command duration limits mode pages (note here the
>>> +	 * "should" which is what SAT-6 defines)=2E So fail this command if =
the
>>> +	 * device does not support CDL=2E
>>> +	 */
>>> +	if (!(dev->flags & ATA_DFLAG_CDL))
>>> +		return -EOPNOTSUPP;
>>> +
>>>  	/*
>>>  	 * The first four bytes of ATA Feature Control mode page are a heade=
r,
>>>  	 * so offsets in mpage are off by 4 compared to buf=2E  Same for len=
=2E
>>> @@ -4101,6 +4110,8 @@ static unsigned int ata_scsi_mode_select_xlat(st=
ruct ata_queued_cmd *qc)
>>>  	case CONTROL_MPAGE:
>>>  		ret =3D ata_mselect_control(qc, spg, p, pg_len, &fp);
>>>  		if (ret < 0) {
>>> +			if (ret =3D=3D -EOPNOTSUPP)
>>> +				goto invalid_fld;
>>>  			fp +=3D hdr_len + bd_len;
>>>  			goto invalid_param;
>>>  		}
>>> --=20
>>=20
>> I would prefer if we did not merge this patch, as it is already handled=
 in
>> higher up in the (only) calling function:
>> https://github=2Ecom/torvalds/linux/blob/v6=2E15-rc2/drivers/ata/libata=
-scsi=2Ec#L2582-L2589
>
>This code you point to is for mode sense=2E This patch deals with mode se=
lect,
>where we are not checking for the subpage support, which is wrong=2E
>

I linked to the wrong line=2E

https://github=2Ecom/torvalds/linux/blob/v6=2E15-rc2/drivers/ata/libata-sc=
si=2Ec#L4081

The rest of the comment is still valid=2E

This case that this patch tries to fix can already not happen=2E


Kind regards,
Niklas



>>=20
>> We only break if "dev->flags & ATA_DFLAG_CDL && pg =3D=3D CONTROL_MPAGE=
"
>>=20
>> if this expression is false, we do a fallthrough,
>> which means fp =3D 3; goto invalid_fld;
>>=20
>>=20
>> Kind regards,
>> Niklas
>
>
>--=20
>Damien Le Moal
>Western Digital Research
