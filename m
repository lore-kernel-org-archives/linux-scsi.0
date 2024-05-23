Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3094AD2C
	for <linux-scsi@vger.kernel.org>; Thu, 23 May 2024 23:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716508581; cv=none; b=aA6eNajcjSAfJwcrPvnEKFghO1/uBdUY3H0kQjXIu6eWSx4Xo1PQ2JVyEG9gZnFGl2t9wSNpc1vNY3NSu4ihzUNynEwni0yx4vwx6UHF2Fug2ibMb77K1ps09hmhVDWQa/YrZTouVca8sb/52Fz0sNfATdKa1lTNXvLQ0NUTu0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716508581; c=relaxed/simple;
	bh=Q+KvU0oLvca8ovAHLR6eF077NY2tGTdk+AFMRrDUktQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=PHt5fcYEAqSq8w4wMNg9b6gUVzVfYmT6K7MC/4vUhLR+sfjhdbPc9b+xnFuXSBh3RgczerYuHwsmznrZQ8p/6O2k0lOeQXPVRsG1H5TbFNIfgdVPdpAR+j8se3vEZWym4U8jv3Y85A/4Hmu7EQl7XFJQ5fKjtJQH85J4U9X94QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=adC2gtcw; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="adC2gtcw"
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240523235616epoutp017aa2579fe503640bc6993b85c537d857~SQ3S0f7Q21117711177epoutp01K
	for <linux-scsi@vger.kernel.org>; Thu, 23 May 2024 23:56:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240523235616epoutp017aa2579fe503640bc6993b85c537d857~SQ3S0f7Q21117711177epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1716508576;
	bh=rwOlfClFjOkWWM2PUxxGFjT0Rypn1JfWpa8Qo6yo6KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adC2gtcwpHZi+D0VjLUBiI9swjzVc/wzgQv+XqHFww44869Y9VXjprOsbFtgUM+98
	 3muGpHCm/v9D3RaVBPE6ODgeryL/0cPMfEzdvdx0RdYlcw+JtYpkVGUo4/Q5DgaLYI
	 qJmbgcB7iyi2aBCRNovmK2f3x7/a5e9ujMZ7bINc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTP id
	20240523235615epcas1p45cc0b38562bcde2cdde65bc5e51f2bdb~SQ3ST332r0266102661epcas1p4y;
	Thu, 23 May 2024 23:56:15 +0000 (GMT)
Received: from epsmgec1p1.samsung.com (unknown [182.195.36.222]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VllSH3xY7z4x9Q1; Thu, 23 May
	2024 23:56:15 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
	epsmgec1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	B0.EF.09696.F97DF466; Fri, 24 May 2024 08:56:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240523235615epcas1p282b2405bed41b94ef8a40633066f1d4c~SQ3Rf2n6t0712807128epcas1p2q;
	Thu, 23 May 2024 23:56:15 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240523235614epsmtrp1f19aa23990c3339365ae0e36957fc8ea~SQ3RaVsmb3240532405epsmtrp1S;
	Thu, 23 May 2024 23:56:14 +0000 (GMT)
X-AuditID: b6c32a36-553ff700000025e0-88-664fd79fa749
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	02.83.09238.E97DF466; Fri, 24 May 2024 08:56:14 +0900 (KST)
Received: from lee.. (unknown [10.253.100.232]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240523235614epsmtip190345a8816f60141ab7a0f270931bdda~SQ3RNMoMq1202612026epsmtip1Y;
	Thu, 23 May 2024 23:56:14 +0000 (GMT)
From: Chanwoo Lee <cw9316.lee@samsung.com>
To: cw9316.lee@samsung.com
Cc: James.Bottomley@HansenPartnership.com, alim.akhtar@samsung.com,
	avri.altman@wdc.com, bvanassche@acm.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
	powen.kao@mediatek.com, quic_cang@quicinc.com, quic_nguyenb@quicinc.com,
	stanley.chu@mediatek.com, yang.lee@linux.alibaba.com
Subject: Re: Re: [PATCH] ufs:mcq:Fixing Error Output for
 ufshcd_try_to_abort_task in ufshcd_mcq_abort
Date: Fri, 24 May 2024 08:56:13 +0900
Message-Id: <20240523235613.1103161-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240523002257.1068373-1-cw9316.lee@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmvu786/5pBmeOSVk8mLeNzeLlz6ts
	FtM+/GS2mHGqjdViYz+HxeVdc9gsuq/vYLNYfvwfk8Xbu/9ZLCZd28BmMfXFcXaLpVtvMlq8
	azzM6MDrcfmKt8e0SafYPHY+tPRoObmfxePj01ssHhP31Hn0bVnF6PF5k5xH+4FupgDOqGyb
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCjlRTKEnNK
	gUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFZgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGUt7
	lrIU3OapuPxQq4FxJlcXIyeHhICJxPObX1i6GLk4hAR2MErMPNfCDuF8YpTYuu0gI4TzjVHi
	28WNjDAtbzdvYQOxhQT2Mkrsb9eFKHrCKPFk7nKgWRwcbAJaErePeYPUiAhISczeMZcJpIZZ
	4ASTxOrvc9lBEsIC6RJflu1lB6lnEVCVeNqsBxLmFbCV6Jh8HGqXvMT+g2eZQWxOATuJ9Ysv
	sEPUCEqcnPmEBcRmBqpp3jqbGWS+hMBaDom1k/tZIJpdJF7v/M8MYQtLvDq+hR3ClpJ42d/G
	DtHQzCix8M1xqO4JjBJfPt5mg6iyl2hubWYDuY5ZQFNi/S59iG18Eu++9rCChCUEeCU62oQg
	qlUk5nSdY4OZ//HGY1YI20Ni0tuH0CCdyCjx4/ML1gmM8rOQPDELyROzELYtYGRexSiWWlCc
	m55abFhgBI/V5PzcTYzghKtltoNx0tsPeocYmTgYDzFKcDArifBGr/RNE+JNSaysSi3Kjy8q
	zUktPsRoCgzhicxSosn5wJSfVxJvaGJpYGJmZGJhbGlspiTOe+ZKWaqQQHpiSWp2ampBahFM
	HxMHp1QD04yeozsu1C0KuCy1RknhREZI7LvN6UG3UvXWKE3Tfbz3tZjg9iKOE5dvKO0sNmSs
	v582t+Wrbdnv9nO39rjNKuhISeXMMCkMzI5/d+lT0Kv26E/mh1u2eFXonHhxNdrK9trCX8t9
	unhmdf7es3oJu6Lo0lU7N3v0ssQrF768r5xTntU+Z9PH8NIZ1hPecrDPcIwVVVGWP8z1J3j9
	dvm5Lfcmta6tvy0ZOO3I2psb5TZUXvLfwBfKtvVW3Mu9/c/3fHnFFjtZYOrSx38P2F3RyDRN
	6/rVcPDNg58HJ36Zzy+6TVEmfqWRydM5ft56y/rjuh6ki2qH1vaF3uL2d8x/q6F0c3pZS27e
	ZykWWb+ICCWW4oxEQy3mouJEAFcn85NBBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWy7bCSnO686/5pBpeOmlk8mLeNzeLlz6ts
	FtM+/GS2mHGqjdViYz+HxeVdc9gsuq/vYLNYfvwfk8Xbu/9ZLCZd28BmMfXFcXaLpVtvMlq8
	azzM6MDrcfmKt8e0SafYPHY+tPRoObmfxePj01ssHhP31Hn0bVnF6PF5k5xH+4FupgDOKC6b
	lNSczLLUIn27BK6MpT1LWQpu81RcfqjVwDiTq4uRk0NCwETi7eYtbF2MXBxCArsZJXYcXMQE
	kZCS2L3/PFCCA8gWljh8uBii5hGjxLqvW5hA4mwCWhK3j3mDlIsAlc/eMZcJpIZZ4BqTxJFJ
	sxhBEsICqRJf1n5nBKlnEVCVeNqsBxLmFbCV6Jh8nBFilbzE/oNnmUFsTgE7ifWLL7CD2EJA
	NZ8adzBB1AtKnJz5hAXEZgaqb946m3kCo8AsJKlZSFILGJlWMUqmFhTnpucmGxYY5qWW6xUn
	5haX5qXrJefnbmIER4uWxg7Ge/P/6R1iZOJgPMQowcGsJMIbvdI3TYg3JbGyKrUoP76oNCe1
	+BCjNAeLkjiv4YzZKUIC6YklqdmpqQWpRTBZJg5OqQamh+suvz5pWj7ztsWyNUymmz3/rJ/8
	L27RyaW+ghUcTpcVDNberGM/dmXZ7VY7g6lT6r4r+0/NWzjvbNzrOsE/U84KyNjvPNWyu+xO
	jqQTb9iyKd8cmV/caF4atjRjv8Hp7JDE1ZXuvzi1BG/NKvY8Epyo1ZKSY+qSbGF1zcTmeser
	upiZp88Gi+gu/KC/SqP0x68q3SjXqI0Ha8/aNf0+07bhwZoP0xKzek/JV2cVVggf+1kZWLl0
	uu/GA6/EZ6Y//fs+njl/Qk7YPx05J+mn86+IrpWz+R92xmDms/UfzNIW/dvqu7BrXZPIiVc/
	SmY/nXXDj/ezzfuyvErfX4qfwwRuc/y3uKT7IvNyOxv7ISWW4oxEQy3mouJEABU6Dk8FAwAA
X-CMS-MailID: 20240523235615epcas1p282b2405bed41b94ef8a40633066f1d4c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240523235615epcas1p282b2405bed41b94ef8a40633066f1d4c
References: <20240523002257.1068373-1-cw9316.lee@samsung.com>
	<CGME20240523235615epcas1p282b2405bed41b94ef8a40633066f1d4c@epcas1p2.samsung.com>

On 5/23/24 22:43, Bart Van Assche wrote:
>On 5/22/24 17:22, Chanwoo Lee wrote:
>> An error unrelated to ufshcd_try_to_abort_task is being output and
>> can cause confusion. So, I modified it to output the result of abort
>> fail. This modification was similarly revised by referring to the
>> ufshcd_abort function.
>> 
>> Signed-off-by: Chanwoo Lee <cw9316.lee@samsung.com>
>> ---
>>   drivers/ufs/core/ufs-mcq.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
>> index 005d63ab1f44..fc24d1af1fe8 100644
>> --- a/drivers/ufs/core/ufs-mcq.c
>> +++ b/drivers/ufs/core/ufs-mcq.c
>> @@ -667,9 +667,11 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
>>   	 * in the completion queue either. Query the device to see if
>>   	 * the command is being processed in the device.
>>   	 */
>> -	if (ufshcd_try_to_abort_task(hba, tag)) {
>> +	err = ufshcd_try_to_abort_task(hba, tag);
>> +	if (err) {
>>   		dev_err(hba->dev, "%s: device abort failed %d\n", __func__, err);
>>   		lrbp->req_abort_skip = true;
>> +		err = FAILED;
>>   		goto out;
>>   	}
>
>Why does the word "Fixing" occur in the title of this patch? I think
>that this patch does not affect the value returned by
>ufshcd_mcq_abort(). From the start of that function:
>
>int err = FAILED;
>
>Thanks,
>
>Bart.

I thought this patch would be appropriate to "fix" the following log.
  * dev_err(hba->dev, "%s: device abort failed %d\n", __func__, err);
If "Fixing" is not appropriate, could you suggest another word?

Thanks,

Chanwoo Lee.
