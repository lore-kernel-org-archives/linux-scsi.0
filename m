Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF337248F7C
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 09:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767085559; cv=none; b=qqlT7QXE0yuvpNCuR+P2OCYNcnymgUcO9T9Sn3chi+jorm8DVPi0x+wagYSBa5LO9FDy0RE+Y0m8TcNDaXymQOoDIfKSg30mbPPI7qd5a28bZB993T8qTNAFrWNCh0/deUSk7LDC3MoMwkBx0dyuuXJhZJ0yA2IouWl6JLLuido=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767085559; c=relaxed/simple;
	bh=viRDd6TSB2NyW57t9e0rKnq8mtr7/AeCGI2eS97q3FQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kGceTjwXryFFhYPzMUODLWDRU0rTAHpUyfW/VbZLPQ9umpsEentK1webHL1MPU+xcYdk/bHtqJgUCz1lqBdVZH+qLXN8xJbzoiPabI27ohFpinbTnGK8DDbjNPXXdxOvoknkOys6il8mHDsgGT6kJ+e+uwKt+uZCGW55qZlBGx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=U8HrbxgI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NT0q8Ifp; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="U8HrbxgI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NT0q8Ifp"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BU3jbV03555789
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 09:05:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	viRDd6TSB2NyW57t9e0rKnq8mtr7/AeCGI2eS97q3FQ=; b=U8HrbxgIcSBfMdjB
	3PD8GkH+mb3HT/R3hY4JMxjXYXVykwAv+3Ju6VbXp7wlMMBUt9ZSgGWo3l45RPEV
	rJOZ9WJVAnEqcP0H+T63svUzcXMoyTkIIUUj6+U6UDT/tH6seBse34NWtI9sCOxK
	CEmAwfjqyAIqtP0kaf4dlQHBIuFv33KxgC+hwCt+wMwMTgfJSEQjDZdCPXzG8tnG
	KEgIF31sYpq2m+L3WcihYshLcpXE79XhlvkWXMy8U3qkn729rEFbXdz0SiCJnBv+
	ZC4KvDs0IrPmDl80W21ML5lMYLjQtvu+zkuMAlgaM57IVFRhVZSFi8uecajs2/oW
	LQmfkg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bc7460nvp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 09:05:56 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a0dabc192eso228672445ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 01:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767085556; x=1767690356; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=viRDd6TSB2NyW57t9e0rKnq8mtr7/AeCGI2eS97q3FQ=;
        b=NT0q8IfpSftRP78gRkbDOttReRj6D50OK1dSZ9gHpWCCWiyzqErNj8QX7yEz0W66Cx
         zK+tt9h/m71Iq1BQN7v9PaUKxYNllDjamWY/iwsakkZ81CGPqYCj+JYfkdQBBamBn/2J
         JmQCy2SGWfGv1PYFh7WcwtFBn5wupgpO/S4xSUJCew8u0QdTlI4/zY+FDKLYpIoiTRl+
         kkN5W3uEJO6YK0PpsCFfWC6En1+1NlAvNsJHCRAVLLqjw9GM/qk5LwlueRVqqcaBN51U
         s/w0D5pg+c2rffXSTVnMaF6Xy1jLRTe7WD1BlZR2bXAh1GZewkDTbbseYEJXwGkl09Jr
         9wLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767085556; x=1767690356;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=viRDd6TSB2NyW57t9e0rKnq8mtr7/AeCGI2eS97q3FQ=;
        b=JIM8MJnNHwNBIQOg4svYj0Kyg1O71vOGExHegKRBaNZpMXxGKBTmxm2FKb4RSEeWwx
         6i+Zmlr+8fwV7hbvZuOYmHx5oYXx2DlApsXxXWaOtJUn4rbDFoEu8T/sZyjItkvejxmW
         DviqW9lj1Ul/sOgCCe6P9hoEgp6l/eckBjq/y2V3T3TByLojAsQIPDez2LkVLXya9umF
         OIfD7cjsna5mS5edbbjNrhnjBnNqgpE/R7Zotrh9BDBz/vqmVxHeuXsMYAIc4hzCwjR2
         UtfrXmJ+TMulZ1iixARAPwhh5nVn6j1FpI/qQESjnM9H7XTrRSuIS2sEOAoklDkePO9w
         auYQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2D1TsfTbm+RpSvlc7aVYI6HHyVV73zc0/0OCmwkixgGk9FqvnhAf4m8F6QAy5896pDgqtu6sefTTe@vger.kernel.org
X-Gm-Message-State: AOJu0Yxjc2G38zFoftBhWFJVdYjpE17iPmBbuRsjTRFk1uIR824ND16r
	8oOpjrP/CAfAzD6WDm/oqtuWJseyvvJs0yzR7bsFiR4G3viMLQkDE1SK6a5nH7t9EI8JlnTc2aS
	MAxEJgnJTmqMevzn2KduDi1Kj+9jcvQYV5vcxINxhW73ju1xH0ZTQLYuDsUK69Yrj
X-Gm-Gg: AY/fxX7IIY+G2icJWoqnx0eRqB3T4Mbs4iTG4T9e34uSGgyqlvBQJRab+KzHqaU9RNc
	plZXkhFzHLovFtqBQGyNsQw4h/DGo7MjA01ZPM7E8yDWrEilOPTObvFxuuI9SaeQAvSxwHr2mn5
	UgGu5CTFkFgmx2nLFW8+YjEL03q8HubvZ/fdk2vyGvLEbNIfCcCx6z4+J19b/CcTFVCCzv2+M1q
	OxrQb56D4rHKCm+rBtntL6XSj29+AvTToVVb+4pPCzEmh8UP5lcg6BVTUOb4gHXHvIxaIdMU4QR
	K35Tp6cCo89K5S9tLiYKZh74wTZnkyDG1+lLuggSQEwKWL39wVWKshfngKsjky3ajBcGU7/f4Rp
	aji1QsKw6C5ndLL9PkNSVMz8uWbkYcNaDV9tXa7vMeRpUpCwPci8=
X-Received: by 2002:a17:902:c403:b0:2a0:ccdb:218d with SMTP id d9443c01a7336-2a2f2214ee0mr292308845ad.17.1767085555647;
        Tue, 30 Dec 2025 01:05:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFFlbJO0Yg7sa0nVvN5mfG82L6hyMbf7a1UIusHtFGqjnnAgGqR5DWD6lTmqGSeTvwTy1nKmw==
X-Received: by 2002:a17:902:c403:b0:2a0:ccdb:218d with SMTP id d9443c01a7336-2a2f2214ee0mr292308515ad.17.1767085555123;
        Tue, 30 Dec 2025 01:05:55 -0800 (PST)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c65d66sm290751605ad.20.2025.12.30.01.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Dec 2025 01:05:54 -0800 (PST)
Message-ID: <86c649c8-7529-45c0-be13-93ff8f05aa44@oss.qualcomm.com>
Date: Tue, 30 Dec 2025 14:35:48 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 1/4] scsi: ufs: phy: dt-bindings: Add QMP UFS PHY
 compatible for Hamoa
To: Krzysztof Kozlowski <krzk@kernel.org>, vkoul@kernel.org,
        neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, martin.petersen@oracle.com, andersson@kernel.org,
        konradybcio@kernel.org, taniya.das@oss.qualcomm.com,
        dmitry.baryshkov@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
References: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251229060642.2807165-2-pradeep.pragallapati@oss.qualcomm.com>
 <f87a8caf-6c65-48b8-a372-1ebff95cb6f8@kernel.org>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <f87a8caf-6c65-48b8-a372-1ebff95cb6f8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Do9bOW/+ c=1 sm=1 tr=0 ts=695395f4 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=YiUacr96smqfDrfpFg8A:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: qq-b14hwewB2PYDT2AXWiCZhPJOMIaei
X-Proofpoint-ORIG-GUID: qq-b14hwewB2PYDT2AXWiCZhPJOMIaei
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDA4MSBTYWx0ZWRfX8rUblbShEEk/
 Hat6D8zSVKAjb9P0pA9rTwJSAYl+eX2df7a5utMTZ9rbTONB1agVzkc5bcoR6XwFHH6FdTbWYM9
 j7Bps1sjyOdr4hNnnOrsSOIRtKdGjqDG9kBYTCA5QasXIBqY+zVB2JdPyZZnNHYQoFFmBeX8hul
 G3NxjgW4sbO6QXNZvWRLWthFm74KNNVMLKSKYV+Un8KNpIBip8zEaWFkUhGyzp9Rvkno4VFud2B
 ZiHG/I3YCeowA0q/loGKvJ8l0ywKjmBirnxKwasv6DGhZJSogXHQhnpkJi+3cqzQR+dCuYlHTbW
 6rylro2JFyPgKSl9Ok/cJsHOxfhslV5Q5TsTEo8dKRxcK3m0Q7fTFCppuQucR7C29LECLFYQdVG
 QkXDt3Nw469XGHWUy4zHPQz7so7G2PbIY/OX6p7UByIQ7t5IFU92bhizcmTc6MbQfaGn0gUY7gu
 Tu7AYXh1pd0Na2d9ZSg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_07,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512300081


On 12/29/2025 12:41 PM, Krzysztof Kozlowski wrote:
> On 29/12/2025 07:06, Pradeep P V K wrote:
>> Document the QMP UFS PHY compatible for Qualcomm Hamoa to support
>> physical layer functionality for UFS found on the SoC. Use fallback to
>> indicate the compatibility of the QMP UFS PHY on the Hamoa with that
>> on the SM8550.
> Last sentence is pointless. You keep explaining what you did, but you
> did not say why. Why Hamoa is compatible with SM8550, but not with SM8650?
i will update in my next patchset.
>
>
> Best regards,
> Krzysztof
