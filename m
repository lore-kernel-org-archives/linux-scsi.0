Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B1B8F6C
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 04:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753936984; cv=fail; b=EpuAtr9YsVF+SsUpvDLZ2Xzzej2HqYRvqSMEFvmIKRRdNxgxcgfIRmquqxppMJx+4PU92DY7q+gUAv02ReVraVtq8xbUCN0Vjf+wfKt/yNmdXmPcWOUp34cy4IW5Fdi4e2Nhj4ItDDLsKwEmIMFFeL4iijZnk5/TEm4j58hdxWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753936984; c=relaxed/simple;
	bh=5bPz+SpQ5csZ7vZP7ohiseRUvr6aY34toJLyhi2CfAc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ZDjL6O11CgN+UN9oUO8aSx1E+/VBF1jvCEUCA2xuf8OuHrMxzswhiHTftNbrKn/7zLUIn2VPf1ZrZ3s1AB1px8OV7QxWTRSye3Wr3P51D1f+EO2a11IxT6LI7wNmFKffDTSGsA16NE1Y/xI+jtodHt6PjVl8px05GReIrZRC+CM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KUWGjWrI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VwOXchzR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KUWGjWrI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VwOXchzR"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2g2tQ025843;
	Thu, 31 Jul 2025 04:42:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=W6lJoVtvTdhsEsoFXM
	MqMpjLR/a+V8EQpZXWWY1MZdI=; b=KUWGjWrItf2Cze5KF3bhi9asSoTihEoUPG
	edW4Z3aNyXMqs+J5NTX8ns7XDYtSyw2QspB74MOZuHQOSqIoFndRr4qkB4yPUGJ1
	jb3BxYJre923IBDU2pOEX3NsqbautaUdEpwHDxo4DK3cYM/mwfubOxu4ENnyKdfd
	lZGz8AfsXqSGKTPCLcBH8LaZrEorMlhaHK7+pFi+MTk2KFyZxrqYPFd1zAQQMlVk
	2zTJpplpxhQiQy8141vJSwyRrtcqfnBRah/0tT3qIKxr6ccszUi5HuxAhczpieqP
	GHgcQMOp64kL+Vy30kbroIFpw4BZMy4AyhcNgKH0owsN+mmyV7Og==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4ebdy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:42:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V3FZ8O037813;
	Thu, 31 Jul 2025 04:42:58 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nfbrmf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:42:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eo1plNdJiBN+gIDIR8hZcYrIFkAdvTbyfHoh/Qj4Te0C9Qo5hIIRCQgTlQqpKNLSa8YgA/9eXTKNwtCiphGfgWBO6uq1FZq3U+pWn2+nGhiw24DCruIUpHGLLVwTT/pcQLgTRTpeG83l3n/5QkgWwG+EPFP6Coqha1DPiWfrKMJrWKUs6YsKOKkGX4cga1Rb0skd6KoNYi5N/ZHY3e250xDLy2C0yKi4T9Q3aDFn4PZGv0tSnqn+s6rlHyYEHwjewqOxi6g1xAT/9x5sUXhYi7i77Xpoc7RheiVw1BbkqiHQQ7q2hvj2epcC954yGvsFBBH7NZd/GRvUoe5zxb8Igg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W6lJoVtvTdhsEsoFXMMqMpjLR/a+V8EQpZXWWY1MZdI=;
 b=aFerICj2UtmmR2RTEHih6UXEuSd9v2C6v9fwdmagXugbzNcr7eChIkdZQlVQOqR/07JOCsRQp6FKIdJIgHgeY9byXfiZU1nCoggNgvOWee97+nYnUnxWsfDyNIwYJUTdanXfRQGeUaDpe/SEekakQG9tybMtQS4c1/KpSgxABo0HrQKlf9MQW5ZhzxoujHj2spZEOn5H+fcEyY1D4sSm1TMqo2cT+FaHnx6YasMClVngB2FDDHO48//FvDiAiKrPlV9yzo31OGvt3ZGe2WMjfoLxIvbAOlTQqFQP285AfNM8LzSxq7jWsKoB2u2d8lnEWC2q3y9TUWXgfgk0F7KEzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6lJoVtvTdhsEsoFXMMqMpjLR/a+V8EQpZXWWY1MZdI=;
 b=VwOXchzR3Ukpn7TuKRW7Toj/vtb/sFTZ7dxZ3xppooJ/v3pHMJN0+7mx9bthp1cxTCBajAH3CA63KIiwoz3ikmr7MjL6BjLhRIHrB0QjE1gyd8BbS4ZvYanggKBBhWThBBRN6sJI2gkwjTuKce5ZPMX7Ikf359wOZVSLOqUq3og=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO1PR10MB4578.namprd10.prod.outlook.com (2603:10b6:303:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Thu, 31 Jul
 2025 04:42:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8989.011; Thu, 31 Jul 2025
 04:42:55 +0000
To: Kurt Garloff <kurt@garloff.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: Patch [0/3] Support eager_unmap for non ldpme sd devs
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <ccc3be81-1c8a-4960-a340-bd424749de55@garloff.de> (Kurt Garloff's
	message of "Tue, 29 Jul 2025 09:32:26 +0200")
Organization: Oracle Corporation
Message-ID: <yq1h5ytghl6.fsf@ca-mkp.ca.oracle.com>
References: <936a460e-eacd-40a8-834a-76021bf3ce8c@garloff.de>
	<yq1ms8nlhtk.fsf@ca-mkp.ca.oracle.com>
	<ccc3be81-1c8a-4960-a340-bd424749de55@garloff.de>
Date: Thu, 31 Jul 2025 00:42:52 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0065.namprd17.prod.outlook.com
 (2603:10b6:510:325::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO1PR10MB4578:EE_
X-MS-Office365-Filtering-Correlation-Id: 99221472-f0e2-4ec7-0f0f-08ddcfecb736
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?no5+Wf/vAnUpouIdgdnB0IFABF4XdjWMpzR8eB4a/h5nDIHdBkUP+USAQF5Z?=
 =?us-ascii?Q?ps2ilZZB2d2Jfa0LhabbG1htb25OtvCGdlu/9IYPVG16YlnMvPRRhVpYIBo1?=
 =?us-ascii?Q?JjVgGJVzp0Ew5KjAIuCpuDj94enieJcOMMeg5Luxq9Bj+mP0C7+nFdtaiA4b?=
 =?us-ascii?Q?cYt8P91ZbFVTWbFZhSYjRyWunSo+S9UqWCX1Yx+ke8QsvYbzuArlLvFJeJB3?=
 =?us-ascii?Q?3vXCH9pFtnS2fm5LYB3QWYQmKIiHXUYZnsihU/3GmD7eE8qAZO7Dd89hdm/i?=
 =?us-ascii?Q?RWaCiv2c9AfD/6OQHRMyVT2gzFLeTegQQfv3lvR27jNUct0lUVBefBvEoI+v?=
 =?us-ascii?Q?WN75/m3C/m01Rep4k9wVaY7ahttbSMSPWPNP7PKjKDEQSQOE3zxiXijvaUA7?=
 =?us-ascii?Q?Vsm2x/tJ/0knYhlFn3OyTFjqUJXik+W1ckZOaU4KnxwGhaWcccVEdNfe0xDO?=
 =?us-ascii?Q?HaquSnU3mTDSuVWZucw1DPJ+knGkEfZdmoMcTwPaF3ZQfReS3AN4VwP+F6R3?=
 =?us-ascii?Q?q31PM8V8yiM0mGm0TxSh02xuYCCzKmi7sd4G5runLRcdPHNZ9ebIqbWz90oJ?=
 =?us-ascii?Q?DbJ1PAaiZFbY4x2TRb9j14kmhsuEylFe+ZQhy3Y/ALFJsNbgr56uPS840Z7x?=
 =?us-ascii?Q?MmPeNv5eTYWaL8eSMKMWwi93vJ9bHxKMdUMRd+FRTcSS/07Pnx9lDmj/A16B?=
 =?us-ascii?Q?lP0xwuTtSppQjYw7RZ33udb87VBVOBN0od+rfLw/ftdU0ZpfCpWFnTx1OaCz?=
 =?us-ascii?Q?t6Uss/oWjY5xtBfmVfY9BDgKy2Xejy6Fo8wOy/q8LS0ry+58T0bRrXhG2dfw?=
 =?us-ascii?Q?leqK/6AiCLA7z0sHFzMfcDVKey+cwH67o76aGJ6GkbBm1o23XZWqwplW2PYQ?=
 =?us-ascii?Q?HZIq9LYJd8ffRM6CKHZr1yGqhsf9WfMvKlFMy8hBc8Z0RUJuYfWbJZpmp2Da?=
 =?us-ascii?Q?tZclldbR8IL/vD9/v1/J0OuOv7a8bLsTGebslQuRHAgunzHu5bussjGTnyiS?=
 =?us-ascii?Q?i6Wch29XdmGFiCLhlZBq1zydNX3a9l2PWJaaG6wFvr0atg1zAGJgMQUsMIS3?=
 =?us-ascii?Q?AHTgzlrpB8nPO9Q6ZRyd0rD9rfbbIc5IreDk6VfpyBoDWKEOkqHoSema6KFk?=
 =?us-ascii?Q?OC+OqlYKimguqghblu3VCaC6Y9yvm+4ICdV2srCr/5P+HCWd9kVO8GoI22XY?=
 =?us-ascii?Q?b4JhjcpuamfwLzxFXzEP+xBsFxsKtdzi52HawePDgV4oES+dRBk4I2UmcZTd?=
 =?us-ascii?Q?AZFYfk5XsWaDrL1KPzuQ8C25xpMXoSGFLckEIKuPRwbVxHtyxTlYumCvj1W5?=
 =?us-ascii?Q?Mk4sAiJgkHqTni/4JV0nZykd4WQ4TvSspzWNxht68mh2aPCr6LInvo0jyerz?=
 =?us-ascii?Q?CCmWOTa3xIQPxrsZFro75SAhnmkQNDBUyIZGUmair07foIZv9hzAV/uyZi9J?=
 =?us-ascii?Q?iDgu1Cy9Uiw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JxTWAZrMSVQWOOBYQDr9nG9rgqYDj/VO7Js1Pq9wjVRfwyboWf32HJ2/pfWh?=
 =?us-ascii?Q?itsk4FyYRZyjIWIndBqr+vybzKtRTTsyZ/VHKxl4X7tBOmy17YaoLaGHjk++?=
 =?us-ascii?Q?wgXKeSGwxqE13nEwnPGuYqme+y+Xgy/oItEcJe7ETNm+hNNxAMYWDOmAV+Sw?=
 =?us-ascii?Q?QUlcF3/uujH3k3sb2rF7M5iXVZv37xHIP95izetvGP292SYzjGYJxBGe0GT5?=
 =?us-ascii?Q?osieX1H3b3hMJlEic6MaeQGb5bz9yvX6kfiaVujw9rF3rY470/V6rQNubJeu?=
 =?us-ascii?Q?aT9wOJjwGnC6j/jNaxrrGNPkjDR+VRWJh1e8SMm5PhXRq+H2ms3UQiwzDTwq?=
 =?us-ascii?Q?XACfdCE27mrcfGZJB3Pi4nwBhAObmVrchmOWLUEiHvPh8sOokcdNS/rKQMMa?=
 =?us-ascii?Q?czjPpPPmmbyETQ5V8SOPpZSxB4S6mjvZA7vgMOCZu/tNTqxbgazwOJ0Qwodm?=
 =?us-ascii?Q?TfPGArjRAk6IL0kBFBT2/H4bG2qa/8FOUu9KOpBJUQLRLPJlSBuxgD08ZNYf?=
 =?us-ascii?Q?lZeuucxRyUbfnwkcRwkOfaf2kL1O+BT4LKtTPVuemfMhrISIKXSXiJvb3TOE?=
 =?us-ascii?Q?xWzcT8Bo4G/QaMSosMa8dvcRxXT+d2i1zvN8y9/R+PC1x619Iys+YyEF1XXF?=
 =?us-ascii?Q?FY4Pc5vT5kZPi4F1DBoCVtmPuW6wxku6B2074g9nsxSGtoeg59oGtoVrSIna?=
 =?us-ascii?Q?GxjNfkO8KSMrnkU3UpEThhxvgXPBQAkoYFXGCPeHD3bW/lAe/EVevn0jVuHl?=
 =?us-ascii?Q?Wtm7mQjITMjBcnFUz7vZ9L/LmfxVH7SkjddqYCPRGXNKEfDCdCdEotAwhsBP?=
 =?us-ascii?Q?uE8aftnPyPWUo1i8X9BPXDPtxqvkOQQoWa3W23O+x/Ctce/BBJzmAVsqYtpq?=
 =?us-ascii?Q?bk86c3nJ9DUxLiKYeQH6giO2i+BMMNX4GlJSzrKx4jmwlx/GehqFpNREF9o7?=
 =?us-ascii?Q?Ea2a7r7agFe4cqbM6AS33ibToazD4yRWe54l1zkAvToGEx3jTtRD1jSfUq2q?=
 =?us-ascii?Q?re37jAyX1ji5w1tiU2bofQvfPC46pt3q3S8rBedvOr/M52bkzaF8JeJu0F/u?=
 =?us-ascii?Q?WQCN9ajbVoIVhR2F7cWCvZkSl1Ky+ACji4rI9YXXRwqBrpXS0tF/2OhSh2jn?=
 =?us-ascii?Q?WxTEsvDnqfQA3ipsGBRpnC9ZDAeiqkqZBwvsaLM1lK+TT7rk46jaNnaC5kus?=
 =?us-ascii?Q?lNa96VZ/Um7Mm1jhGtawjfWn4QE+JjvOMULy2Y3sf/LN0a3MHSJt9C4AdKnM?=
 =?us-ascii?Q?XHVQKhKciMGBRZEL/j5MVPYLSF90U1RpCr2KJsOqzIzOhZ1S5j6plIfQ2Z9U?=
 =?us-ascii?Q?6/EBvcVckiU/X+i0fv4NIFdTVM3nEukLOz6GEuz2PzNtlfvYg7/xOSkCtoGH?=
 =?us-ascii?Q?1L30fRxj2O/1DHOPUH48qDydfTh75MNFq6ZchiFD8yaqdLUeCV5KpN3M3tEZ?=
 =?us-ascii?Q?Y0hD2Q19r4d/j7+j5BrijWlp7yzp9dWBAt+HriBj6J3AtVnJJixJVE2gobzK?=
 =?us-ascii?Q?j3SrI03XCbFt35y97r1Ip44dlY0oiZhA2mB3qni42bp0SAw3Bqvb4MbQzgCZ?=
 =?us-ascii?Q?DXevfjOO874L/6iYgJgPUSDQUYNdPAaXIEiotn9QQtEQ3MVc9/S4RwS3akrU?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zYKSBNQsylxO8qA7Y97DCYDsap/XuFCcthUs48T/wrEZJ+ap8sSXAN3Fm5B56EzT5P4Ynt3N7crqNmkbjfKaiIzfPUpXRCH2xjcSqZCAZRUfzdotN8fqPuQELNygIUJ0z4sw5VXOH/zTsaRxq+yuRcO6ooZFoYNswdA60vTjKMquPWqIh3N1KAdnN9ss59GWXO58JkARfId8lHacKEFX1hZKyGq36sGXxdNM7wAS+UzVeG/nts5bi87tzigk48VbS3oP1z7egWPtZc73uMScEuypW4RgCWpixblbRr8WyJpGSPfrx3LygCt1Qr4Va4j+K2mEBrUO8JhmRQ1VCgkqRIySfD2cPuUnL1PayxSP+Uy8IIRpyEJtvNeMvoroTkZ4ibpOnxSQd7YmhqDU4d6jSxXm++YUS51xkSLDXlEO8GyLY/mwKkKEuRN1ub4VbwOo7SZztxivsWqVxeHDsLv4DG4w/Ws/VgQkNnvsLBKE/u+/+FZOoO3RY6fK9/VKZeLJ6IP4N0ar9YaCmjxJZySLITVAxZNz0gJcp1Mm6x0uXYLBPo/eyVYPIqk97nmvjdKm40nRUKolhG3GZTpiZDDiVSQZ74XUbedUhq4OeW2fKXc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99221472-f0e2-4ec7-0f0f-08ddcfecb736
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 04:42:55.1111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PCO4w2saZw0+wxQIwBGvOFRXlZ2/UXHvGc8Z32qHt1XqjDdK6dclEgvVIG8ZLjT75+OiYuMit/BZgvqBUQFEGsas1nAVsBe6LRkRC9h53wE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4578
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_01,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507310029
X-Proofpoint-ORIG-GUID: NQj-VfJjSW-sm2Wq4RLI8esUoO7Q-7Of
X-Proofpoint-GUID: NQj-VfJjSW-sm2Wq4RLI8esUoO7Q-7Of
X-Authority-Analysis: v=2.4 cv=QZtmvtbv c=1 sm=1 tr=0 ts=688af453 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=hpC_RTOsRHtdzBlmuqgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAzMCBTYWx0ZWRfX/MK6ox4SB1ec
 2tBOCfbLNcIoD6yPLCFFlniWVbvT0b88NJptnK3QSGybRq8ZzX0HJTr/eVsJPrXmmgerGMYIGOO
 4tg/PN8n5M/UUNs/YmPDk3pGVteULSiY5WDCAYzpe0y/ox4mWXY8JsRZLIt29nPE3UQJM1iLOJX
 l4Kv3gtMQ6lulyJId2A1PxDTrZ9m7MUnw7qX3ho37FKYcvpFXj52UGhs4BdtkrjR1S4CKvmedhB
 PaEyjhMSs+jowKFMpUeI3b9deXVOLKEeSRzfLvHeoc1R92wkToUnURxWsvggXHkRViQZSri8Qyi
 0ARgEbNL1wBv5KOjpKtM+3l8uduD50V8trfPUH1Cuk+m1C2WMdAE/whoftBFg4DZvggtKgxl8qd
 z2yfDSnLSxVmPUD4G9Vacx7wKx+2+lc+1FhPi/wsveqEUYre/SlioVl0fwkG8nvTQNWZMoyS


Hi Kurt!

> Some docs mention LBPME in context of thin provisioning, which
> is not a good description of what SSDs/NVMes do.

Logical Block Provisioning is how discard and other capacity
provisioning primitives are defined in SCSI. SCSI devices which support
unmapping logical blocks are required to set LBPME. This includes SCSI
SSDs which support "discards" as well as storage arrays which implement
thin provisioning.

LBPME was originally called TPE since it concerned itself with thin
provisioning only. The flag was later renamed to accommodate devices
using other provisioning models.

> One could argue that the NVMe-SCSI translation is incomplete and
> should be fixed, but that discussion is now many years late.

Unfortunately SCSI-NVMe translation isn't standardized the same way as
SCSI-ATA translation is.

Implementing SCSI-NVMe translation requires an appropriate understanding
of both protocols. There is no formal translation specification to rely
on.

> Linux nvme driver don't care about LBPME.

The Linux NVMe driver doesn't know about SCSI protocol flags. The
protocol translation is being done by your enclosure's bridge device.

The flag corresponding to LBPME in NVMe is the DSM flag in ONCS in
IDENTIFY CONTROLLER. That is what your bridge firmware should have
translated to LBPME=1.

The flag corresponding to LBPME in ATA is TRIM SUPPORTED in IDENTIFY
DEVICE. It appears your device handled that translation correctly.

> Remaining question is whether we'd recommend users to use a set of
> udev rules to fix up or whether we have a sd_mod parameter to ignore
> LBPME (if LBPU/LBPWS/LBPWS10 are set) or even ignore it by default
> (and only provide an opt-out parameter).

The SCSI spec requires devices to set LBPME=1 to enable Logical Block
Provisioning. This is not optional. It is perfectly reasonable for a
device to report LBPWS to indicate that the WRITE SAME(16) command is
implemented. That does not imply that Logical Block Provisioning is
actually enabled. You could plug a hard disk into your enclosure, for
instance, and therefore LBPME would be 0 despite the bridge indicating
support for WRITE SAME(16).

We are not going to add an option to ignore LBPME. It is one of the most
reliable "does this device know what it is doing?" heuristics we have.
And we really can not trust a device which fails to handle even the
most basic bits of the SCSI protocol.

Twiddling the sysfs file via a udev rule is the appropriate way for
users to enable discards on devices which fail to implement the spec
correctly.

-- 
Martin K. Petersen
