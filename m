Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6456534EF03
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 07:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782978601; cv=none; b=pTQmnn56Jyeob7VfBVhRl61q2DSQLjNXHAFX04dM3Vl1DqT/nLRBSOvC887KDKdtXJKny4EAtlAXqaBIEIDeGMkSPDZll4lascj4LmfPTF4nI7Fa/cEj955T87bFc9q82qS7twNpmpLhdLDmLrJuPogB9MmFl/iCaSvJVrtgKEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782978601; c=relaxed/simple;
	bh=/QK23YA5B51C042jTB7VpX+A7kWU/DcuJxKWdmEbgoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hPNg4UX/e0LWHT5Z7HOH0bNHSDRoNKxmL5gLHag0FvmpjkI7lrQZdxQ0Euu2lkjsCDp9VtoSny+HKqWRuWRydJ8qHYjHm2GsEmsFdz8i9Ew/1r/ngwsuqnrQaaZlsxykLLAuwoMh5haU6Lneq5ehEvoirJHiSn5iCZEh8zWXkOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XQYJfahc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UKnIYph4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XQYJfahc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UKnIYph4"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6627TsAZ3964218
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jul 2026 07:49:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	S7ozycuXvkZs4Tkt6aCM8DhAm1NjHTo0vIUPCujt0Z8=; b=XQYJfahcM+dBOGoa
	P0CjOjEXDvaEjFa5G/kPEVvKk0YlcRw+Q0zJiMC1Cx711gkJ0JAG6XU1M9Jptodg
	NuBIHZKqpQd6Jz627Rv5CiqE+WX7XkiNM/VJTHqwm2MonNWcBXFZFeLUxh8AIxo1
	bQnmZ+n49XAoEI/CtVgtAxRXTsahWquPrq50YzWyJPscf/P61gnUJJvKFav2oF2F
	M4SSZJUbNXoErbVnAqkIioo1GFpqdXXzk+Pq1qKqo+hm/OO0dHe4bBF2mfD8B+nE
	rR8bukToiVRIon0IYXE5JtI++QrjcbLexXerhpizqmKgyPNobyYWNKM+7cV4K9b0
	Du0ZjA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f5knc02gn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2026 07:49:58 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-845317fa7e6so2351273b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2026 00:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782978598; x=1783583398; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S7ozycuXvkZs4Tkt6aCM8DhAm1NjHTo0vIUPCujt0Z8=;
        b=UKnIYph4SE9XF//hko2wYNfWFKY7PJ10hXqYP544lUl0tQUPCJvGyYRSjmewmxaTs6
         fFq0qDeuFOD5kFsxDrOg2EdYjh7rONHzHp7OF0wIe1UmStECRTjB2uUyZd14r6CqEjL2
         w9FbEcA6fB4uPyVTwoDC8mojm2buJhxyvckvzQnPuZA4+oNioEb6/RwrrwSUCMpDxm5P
         XhvpI94QH6MQgmaRA77Wm9ET7psCE8vQ0KU82cQCgyhfNlSW9BEzV1Lblq0FtNgzjReg
         brVSkwlr/yIK0GppS+cH7do9Jx0YO1LloxaTtF7c5eKQks+QwVqthkeINTUB7KwVPYkb
         +Uqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782978598; x=1783583398;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S7ozycuXvkZs4Tkt6aCM8DhAm1NjHTo0vIUPCujt0Z8=;
        b=WoTPiA1f28bztjbZTtfbr0zCXHcvQkL8qu+0GxNcM1xx1blhyDKB9d94ffnA8wGETM
         fjj/WtEFZ+IGfNont4hQqLBdhgHxzxPRhpOcDr0zHNwriG72/5jr/ab5cMFV7ZyZKIlW
         /tsdSXi7HUXgLf+NLWgxXDqfGK2rle4XcpLrP0qbZ9Yo/gYCxuNMyJS+nNXlYZ7E5aT1
         ngV9LBh8ValUu6fiTZH1n+8s40Sc0J1JxQfhHRSNsmZJ+hsXmu6xo6SzDOf90HgAQWPu
         LNnl61G9ygkA2COnW3X44kvzI7rONg5CeGVil/t/vnYfaSylxJWuXceCdf3lJFYY2Hdv
         j+yQ==
X-Gm-Message-State: AOJu0YyW9s7xyz3KppVgFp+UPVRc57IoX4aDOc6+876P0ISooZVVKf2Y
	NW8o+Sne/VpiQ64THa59+f7q0UW0c5oUJHAYIZnv7BAD/ebemo1HVQq/opN0cYdgqwMxf5rpwBQ
	Ve6vjWN7UYaSOh0UqB7u3hLNGu3l8uH0ztI81m3AfNsCU8T6NnEGWAWq2Dq0iPGlfG4UdPB/14I
	0=
X-Gm-Gg: AfdE7ck/FW/FvW86ExJ9anypZ09TVHlMnqI1Bsv0mGoLBY3IwFKyEHDT064mlutwwTI
	jnlZZyfl9qHGa0lw9iSHmlJ/JSzuO7F+Q9Hx/oVyqr58272qW6MpyYEoIEy5tCGIN6rWgjCihm5
	qHnnMmbVzqcwScMNUJ9OR7J3hY/jH9PX4NM2ZXqv0ZMKG0grmw1iTdm42Gz1POB6bMbjSgahKCz
	l7qgWWFuRr6PYLsEPIxskiAEIoJZQbfHUsrHEICM8oL5EYdlHRwvsvAlny2VBhPYOQs1QP2dLru
	ZUGey/PUaxIhzKTq7L7EH77unPuHK5/5No03XDDwaIGDMJmgGETNxSi/Lu86zI0ZRY4UJSiYn39
	jGURB1zaYYDPkuYwwoPc36D+N469nlsVaEypEoAelzZkyjXrLOHhJSqNqvxqffFdR
X-Received: by 2002:a05:6a00:1702:b0:842:6a97:52fb with SMTP id d2e1a72fcca58-847c07966a8mr5068808b3a.18.1782978597916;
        Thu, 02 Jul 2026 00:49:57 -0700 (PDT)
X-Received: by 2002:a05:6a00:1702:b0:842:6a97:52fb with SMTP id d2e1a72fcca58-847c07966a8mr5068789b3a.18.1782978597241;
        Thu, 02 Jul 2026 00:49:57 -0700 (PDT)
Received: from [10.110.61.213] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb75e7e8sm958602b3a.20.2026.07.02.00.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 00:49:56 -0700 (PDT)
Message-ID: <763e75d3-b603-4e90-8877-e602fa6168a5@oss.qualcomm.com>
Date: Thu, 2 Jul 2026 15:49:52 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] scsi: ufs: Harden TX EQTR error handling paths
To: Can Guo <can.guo@oss.qualcomm.com>, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org
References: <20260625121306.1655467-1-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
In-Reply-To: <20260625121306.1655467-1-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: IjLEUfzKbws379H21delVfw6tWb5_fZp
X-Authority-Analysis: v=2.4 cv=a4kAM0SF c=1 sm=1 tr=0 ts=6a461826 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=qGogzAylIKSnPewOibIA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDA3OSBTYWx0ZWRfX+/AwdwYVNuxm
 pT5wsrume39flwqsh1+c5BCiWkFcf+Rg2Kr/8+TmDEO2LB3rRKg32XM3a2gFFEdAKf3sxkTqhab
 rp2zxUk7wHUt1kHYyD2qx+K78E38BHu8rOGdGqu9tunP47YpoKA4TWJKryyw8hFTR8Rm1OQgID1
 hJ8XNlcATqys7N46tNkk6YDqY7qJhmC74VJccBQlNw69+ekTH4JISMuuVoW3rCfpP2H7kvB4uFn
 QCdOEiWD1kyNrRdPsgxUNcd8V8EbWK3GR/mkGvcrSsbYe1DykOafpp0HlCzZPyY1FgZtvUnyW0q
 DE55848Nnc5CHW/RMIncPCfCUnGsgLSl4VDvbXdsfSdA4kfeh1ApIjgVAjRsCV/FzCPfhdALVtm
 vUTnccBC/hXoMiOstkOuaRtsDs9tF6wyK4+UOFCH7pLcSc55M1H4Rd7JePViSQBIF3pqIkbYm/w
 o/rVrd6IJi5GRWiu8kA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDA3OSBTYWx0ZWRfXzWoYUZQN3R6t
 T5E8twr09butXQlDeUC+FypIBvV5rxFgxdtESm0CEVMacVcKDs2sT5tRfXUBPh+YiKSIcA/QXqc
 RjqG3YFQA6d57C6fw2FDkYbCbpW0r6E=
X-Proofpoint-GUID: IjLEUfzKbws379H21delVfw6tWb5_fZp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020079


On 6/25/2026 8:13 PM, Can Guo wrote:
> TX Equalization training currently has a few error-path gaps that can
> make the flow brittle and can leave variant/device cleanup incomplete.
>
> This series hardens TX EQTR in three places:
>
> 1. ufs-qcom: route SW FOM setup failures through the shared cleanup path
>     so temporary device TX EQ settings are restored and link recovery is
>     always attempted before exit.
> 2. core: treat RX_FOM DME read failures as best effort so TX EQTR can
>     continue, and force failed lanes to deterministic 0 FOM.
> 3. core: always run tx_eqtr POST_CHANGE notify once PRE_CHANGE succeeds,
>     even when TX EQTR fails, so variant cleanup is not skipped.
>
> Together these changes improve TX EQTR robustness without changing the
> normal success path.
>
> Dependency note:
> PATCH 3/3 depends on the patch below, which is still under review:
> https://lore.kernel.org/all/c71af930-c7b4-4480-b125-f35cbe35a16f@oss.qualcomm.com/
>
> Please apply this series on top of that patch (or a tree containing it).
>
> v1 -> v2:
> - Adopted Peter's comment (Patch 2)
>
> Can Guo (3):
>    scsi: ufs: ufs-qcom: Restore TX Equalization settings on FOM failure
>    scsi: ufs: core: Tolerate RX_FOM read failures in TX EQTR
>    scsi: ufs: core: Always run tx_eqtr POST_CHANGE notify
>
>   drivers/ufs/core/ufs-txeq.c | 33 ++++++++++++++++++++++++---------
>   drivers/ufs/host/ufs-qcom.c |  9 ++++-----
>   2 files changed, 28 insertions(+), 14 deletions(-)
Reviewed-by: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
