Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B0239EF0B
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 09:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782122074; cv=fail; b=gD9Bf5aePY9xprDPzsC01AHAj0D/qhOhZKfvlohwCKA5TyrIm2T3vvdtkJkpit9KY/VvsXGMABWT9Vgf0hHtIoulzB4QLFZvKYs3S9VW7KbnibiKKRcJILZO6ebhbWyvzVJpplXrlzov4jnposz+pqfJiK9yBwffncUJn+DYvHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782122074; c=relaxed/simple;
	bh=WQ5iUcHBomT/b0OMJLtH58/oSH21aPiy1+srkVUTIBI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ImQoJnQUzJlxQgrH2yylqeSDRWXAMgy7GuzwTqqDP0yFdmqakC0cnTOWg6YBFcu/lOaS1UzOncRw9XZ/SzcNjMIb7To1zxHoyjIfAtsKO0GGkoWuUf6UPCDN1qku2zU/aswNwDtPYP0JNm/e8xWYkg/MJm/ZrNYGaGZxTeKUggA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Kh2y11UJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Awz7+JKB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kh2y11UJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Awz7+JKB"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65M9NaXd1307806;
	Mon, 22 Jun 2026 09:54:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Jk9RtekCRlaXo67EJzIi5JYTEJbuG5TrN6ycg36aFQY=; b=
	Kh2y11UJcefHyXa7z1ir2dub2buwb0unXINh3Ez/r0IUkQrqAElOsyNims3gwXcf
	3AnY3lMM7gr29zT0SRLIEGstuqAjP+r/U22ND7e8stcN9wuGYcj+ufLkxIO0U1G/
	cuUdotJzOAVa+79nK+YhetHHnmtTqvFivGbyNihYlz9jaNgNzQu8FAjacCOYMJ/0
	GDZo/Ie1eN5G64ISaglYKYG4OX++aEy713axV3f/gNij3lk1pUiwsXRSU4rNEPF5
	TLC74RQgM7IEi8ZfJJrsTiHPtCLDOasRxM/442mc8r/UxlLze9ISw3L358ETgW1+
	HRlSNDO+iGSdoUah/D8RDg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ewhf1hny6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Jun 2026 09:54:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65M9rVFT035204;
	Mon, 22 Jun 2026 09:54:21 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012010.outbound.protection.outlook.com [40.93.195.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ewhangtar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Jun 2026 09:54:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vi5+k9n9mqUMs4TAchtGfZlS4F+JXq7Z7v4NBJWSLBIRtoQgu6I29AjJtrMEQtxitjrkSSphVPzU02eVuBssC5VZ7RISKK6ZZkk9AIks3pAZRRPzJLK4OM9ZY/cUH5e1EZdSuOuGsD+k+JX2S0ZUkWfBzwDzUS1BYQHEC2aifruaJzKpJB2Qy0qsmawq93Gjqp+6XYrYeuCkmx8nt66PC2DDMGp9dcvydFGbTNNr5DhHrjYdWdruHidYc2vqWrMzerejpJlKjHOSFijzkxczCL9xHgaCnx78IpoOnRtDaA1eBNZKzHRTxPYD6UuBLEYAfp9QPpYaLiKdV/VqCVko0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jk9RtekCRlaXo67EJzIi5JYTEJbuG5TrN6ycg36aFQY=;
 b=N+CUlQlg3QgBDT13atLc5lHrX9PyGZbLQfHyUOoC1b9Pdz3t8shkX55BMNM1L+99x3tmLZeVUlY+6KqTbBLEG64d3kxrZNJPU9hvvb0na27irQGargNyvczcxmCtZ4kUufCp7Euvx39hNXFgrSwhC65i5cOV25S9MivcDuwxmjfdT+1XryvkEVy1tqxti8Uua0qnoE42ke/TmQDhaXC0tKxpMCX35qKUB5JWipnrZcolMlz9GNjFJ2SNqK8qEP7swyS39Pb9rjZ157q2aJ+WCLnHZyxDytbSr129QGa5Rf2WchYW8M/OR0A7plAYeLaZvfAXnFAbugr7mtat6CsQow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jk9RtekCRlaXo67EJzIi5JYTEJbuG5TrN6ycg36aFQY=;
 b=Awz7+JKBSuSyrOLJYm9CxhZMhOwQ/sgRxZFlwT28ZhmdbCxVgVDQvqWybqNNUKHIVBLmsvjKJaPcNu824BqhbQtYsjssHZVi3OjvTerWrIFb3J6CVxu1xuS18KF7laVBQoV80EEh7031bdkmBVPlbzFpVmdodfYnJvgV16wxh+Y=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by MN6PR10MB8071.namprd10.prod.outlook.com
 (2603:10b6:208:4ef::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.19; Mon, 22 Jun
 2026 09:54:19 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0139.009; Mon, 22 Jun 2026
 09:54:19 +0000
Message-ID: <236acb3d-374f-4316-a0f5-4c3e4320152a@oracle.com>
Date: Mon, 22 Jun 2026 10:54:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] scsi: core: Drop dev->dma_mask check in evaluating
 max_sectors
To: hch@lst.de, linux-scsi@vger.kernel.org
Cc: iommu@lists.linux.dev
References: <20260612103819.568200-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260612103819.568200-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0363.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::8) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|MN6PR10MB8071:EE_
X-MS-Office365-Filtering-Correlation-Id: c2458ef2-38cb-4ad8-8b96-08ded0443a6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	c3owR99fYt4kN3qoQWSwd4evKje5enbr/W94aIvhusbtOZWSgCsTOYrdhmKNouK/Lxp0LtE6PGqOXZjQDVQMU9iYRdELQa2PcQNt1HIPo1zNIasHDyaxI4DM2zHw1OGka+g3iCz9zNFWTxRgZKwoPOKYPJ9tjAPcqjdU/YVh7AgI20BJqwzbf0UF9vaFLeR2/3aGCN7qdBBCemDOjDvPvo3j5O6OzZT6b+KnY/2azN1JcnNBSQCsiwSXccEbDv3CQP6JVCeFGSc6Lj01eyLjEeEl90+OFldYWwEikwzW4i8W9nB08lS/cD0KJXCslVWkPHWCdx5zB9ze5udJz/cmldgT/jzSl1RE6FOjpTyAkw51hrUJsBQtMr9TApj87iyL/vxk8FEaluErqVgsvisJmYelPSNFFlx/ViDDd8eUJGdTicoIte4susnXQKhl3lYaO7pWLUXh0Yv29ZCw871zvJjFv/QTnwoznqU0f9ZG5z3FLLu6Plv36DO4+//K1P3KQq/6icqJnQao26Xnr1nSnwEl6xJ4RafwxLwCvDWF8F09YHV5LRIb0Tzp46Pa3G0psnJ5dRCVsgD+7us+v7yv6bIBQdLCwxrLLrGOZN7Q/xYswCgpDYHX7OhRXlnQVdE4zMttKgROoynFEcmzW60nLN8Pet6mQFwYn4weYOK7kDM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDlhbmZDRVZneHRTNnh5dFlQVStvWmpjY1lYNnF0emtyUGVYSzJ3dFlLRXdt?=
 =?utf-8?B?NHdabU10M3NEUDFrcXZNQ1RKZEt5MUxVb3VOelQ5UXVwZC92ZlVwNWhCZ0NG?=
 =?utf-8?B?S2xYZGFhSTdMLzZJRXVEMGpvNU1lOVB3QWhYQ0RsMFhveE9YM1cxeXhHRzJP?=
 =?utf-8?B?NDlyeWlsL0JreEg2OUtmbUJtdk10Sk0rYzhGWmFuQWFJOTcyT3FjSG1XZ3h0?=
 =?utf-8?B?OEF2NEdCS2w2ck1TVUZoWHhnTTg3NDQwSkczQ1JHdWFxMVNZVnVzK2lZR2JV?=
 =?utf-8?B?bFArdUFzeTdENHJ2ZW9wUTNMbnY1bXVuN2dxclF2dG1NQ2h3M2hBV1Q5WmxW?=
 =?utf-8?B?TkNDVmxtKzBqUWNIRXI3UFE5YUNkZVNITm1QSTZFOW9EN1VSRi94M0oxelVI?=
 =?utf-8?B?QTkrNDU1L3dQMTVlb3U3bzlIbGVHUjNxdlQxcGxHUS9CdlFHR1BtQ2ozdmJs?=
 =?utf-8?B?ejRUcGxDazhEcHJ1YUQ1ckhwVHE2a2lFdTJrU3ZzYVlzd1RySVZ1dWRoZFEy?=
 =?utf-8?B?dHFkbzBmQWZkYXFYRmlWSnZybG9iWmxmeEhTcjRKaWlaRWNHYnhxcmZTMytm?=
 =?utf-8?B?dUdaT3FveFU2SnFBeHRVMlpLTjFoUmpMODkyY25jU09HY2lxTEJnbkx2UTFB?=
 =?utf-8?B?elN0UGoveFduZjhpQy8wRHFUTUE5MDJzREF5VEdEdnQzb1YzNHN3STdSamgv?=
 =?utf-8?B?Qk1TczFhSDFEenE5R1ZleDZvRi9vNFBnV0pmVStrWHJVSm85ZVo4cDdMYy9l?=
 =?utf-8?B?dG1vL05tL0ZRSktqWWlXWVE2dFNqRDA1ZklEQ21JQmx3RVQ4UUV1MXpHTU5D?=
 =?utf-8?B?SVd3Zm81QjBYZU9nQ3JxMU12SHVYUitaU3c5bVFKKy9LaW9ycDN0OUdpT24z?=
 =?utf-8?B?R1ZaZ1lHVm1IN2RBa0pEQ3cxeXBpa0dFRVlqZ2IvbE9zQ3RPSUdpT0loQmhv?=
 =?utf-8?B?TXpZQUNIa3Y4NlJwSEpEcEdNeWpFc1JtZkFpTmQ0amFXK09jdVJETXFkNWV4?=
 =?utf-8?B?bjFBUUFIU0tHaG5xYVNMR0JoZ2t6RDBkSGJrSmlGYUFsWVUxRjFacDVpRFRS?=
 =?utf-8?B?WW9FNThjTHBMQ2U5cFhNdGx3dXhBd1NIZnlOYkp3RC9hemw1ak9rQjBLNkZD?=
 =?utf-8?B?NkUxeUNrWUVpUm9ZYW1oNDdxZWo1UUNqYjNvZnE3bGZPZXNkNGVCSWk3Z29I?=
 =?utf-8?B?QnE3eHRpT3I1anpZNXl4clE1YnM0K3NyTytTbUtYNHVMOXRwMWticXpvVzE3?=
 =?utf-8?B?c3ZmcVpoWklkSVBYQ0tkNU5EMThsdEVKMTNQaEtmQ3F0OTgvMGZLa3ladC9n?=
 =?utf-8?B?MWxhTVVENktSMWNEWVlFYjNqOWNqcjdnd2FhbWx5bzNvbDR2eFRNOEMwWEds?=
 =?utf-8?B?SHhUSEd4Q3dkR09qVGVZbUhYckF5U1BuQkxCcG1nZHBBMVJ0M3RYUlBHOFdG?=
 =?utf-8?B?dERzdDJjNmVYeDVHaGxibk1iamtDY2JHd3Nna3NpVG83Z0NBVGVYVk9sUzM1?=
 =?utf-8?B?RXU1VTZrTVFXMEltQ2hyaGRMb0RsbVg2QnFEMFZKYW1aZnp3TDY5Y2JodlJ5?=
 =?utf-8?B?NzZ3c1htNzFid05reUFZUUZNNnpOR0JJM2dRZnhkMGNTVTJNc1JEN042Yzhz?=
 =?utf-8?B?U1ZJdmtmNEkvZVlpRWw1bTBQN09WT2kyZ2dvYjg0TnRZMmRhMWtJVC9PUmVU?=
 =?utf-8?B?NUtaclI3RG55T092UkY0cEd1QkNLT1NlZ05sbVJtVE5LMjNoV013MmZaUit1?=
 =?utf-8?B?aHpLTkZ2RGVrS09vYnhvemV1cGNZQm8ycE9jWU1OQVlUMDRmOFRLdjg0WG96?=
 =?utf-8?B?c0t0OFVFQmx0WmlIeHVUeERZaWdER284aUlzNEV0TWxpaVZLTFQ2QXFPMHhG?=
 =?utf-8?B?bnczVnFaTEVQaS9YOVhOL2ZmN09wYjNuZjluSjhzUjZuQXlleDl6aThRdFIy?=
 =?utf-8?B?ckdVVndkSERmbG1tVFUxWmd0VlFMRUV4NUFyeXE0YUY1eng0K3dUaDZhRllx?=
 =?utf-8?B?RmtQdGREZzM5MFVMMW1menQ5NHdmQ2hKbEZ1Vk5uaTN4cEhsOVJTcHh6cmNE?=
 =?utf-8?B?U1N1WktYZURkQ0t6UTM2STlGcyszL0Voa1NmQ0ZJM2hrWFFZU3RFa1NjNGp5?=
 =?utf-8?B?eHZhZ1JmSGh4dVZ4Qy93MWdRRGM2dElMdXBlZHBWTmFWcndIdDlCc0FmMDZ2?=
 =?utf-8?B?QXNCeFBLYkRldXF4NUdoRHpzTU16eWNicWh0cVhsNjZwNStLK3NTaExVRDVE?=
 =?utf-8?B?ZEl5MkhNd2pQeGQ1T296NllXTHdzUm1lc0ZkNE1uUzdRcFZYQjhtdlRnQjNO?=
 =?utf-8?B?ZURHUElBNHgrRjNidERyZDhpcDFEcWJpZTRjQjBDUjJlSUk2TVVtZz09?=
X-Exchange-RoutingPolicyChecked:
	j8pX2cWRxTVk/SkuTKcJnCyqJtr0EhjC4jfCPmPMzKQUmnZC1BQJcqC1q2HGbUpf4IZhfvIUWIyZdf+MRIxqripcG1xlmGtuU1uByaio2yd9NyAiHO5STL8+xiJcuVGHCV0FV+CdL5hUbADc71ZOjrF0psdUhUDbkKvvx7JvsN+IlXpVqoUK1lqUX1K+tUthqtpjykzAVaZ0hFE5rcily3EARRVTZezoZ2gnwr8NFYF80SUXvnCTwDmlyF3pjCVrusVf0znezzucXRwYPEV2kJdVH9+MqM/MGxDPPUN3WgQYioV1ba0DsOe88mNLOKnJ4GwjAZBGAsQ/FKK00IUIUQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kd6Y6GL/HVA/v8EgJAeyhWt1DPgtygifGzhuIwkJUtH2uIszvwYUzOYdtKfy+8nyETYdVpv1ky+5Pw7n+DU9FUr1eFFqfnfghicp3IFsvmFX8AtuifDkKmqwit3JEVmmH8hod+a107SWsiGEDP/4FTRXRJwNA8A8S3NyO+a1kF9QScm5R2QZJh29lX9yUWdWxEGE656WJHNMPXdPljRbpw2wyKL4vWQj/xKQZIlGEPz7ImwDQrV8udw6noSRfyJjECM90w8CMsluz+Z9mB8aD53gCZtc2Pv27jpmkTelBF4GvUJ2mmc2bnf8ueS12S/7P/zp7cdY61TJ5JN/QJLj8bjEte+grP60RMfUyVuxlyBLOKzPBrI9sSGd59RGw0zM43QgSKnzy2QXVE4S9Bpov54we7PIuuYJ4T7XrD6HUVzLb6uyZjKMfkF90OOJlgkck3MGmq1+xnps3OtM7ik0KPZrAaDFMFa8ZrNkfxPsP05ZG1UZ6CDa/R3Sf+w3fxwikUgySCLByYwhyh2FxvgSNhr1haBmlRrTvSGKVidYVo0ZryaNVzwHdcN071TL5sKn7uPD7ncjRiwDgeBeKn4TgkAM3WVyvLmy4i6ggJdLonY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2458ef2-38cb-4ad8-8b96-08ded0443a6b
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 09:54:19.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZP1YaX/yP9/ExeMhOgmRtmY0oMt8GXQ1e1B3vgC0Uqmx9AT7E9frW3knrgJRFdo0lcqaBmCxtKGGMvZ35tOXOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8071
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_01,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2606220097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDA5NyBTYWx0ZWRfX2LDygekBrQ7c
 IA+LFEDaGCn16D1DNg2j5uBDK6dHVjKvn97svfOeie+W6TBWDwJVE3lxMVReNBqa7vDzeSZ64lF
 w09bOrdLCXvDl7nODjjQiHS1ftzyAdLFvg0VhwFYv4QSrmCWyV6PsJq9SzJyVjyK3BcpU7lro/8
 eKtybP/T2Za+e22yh7vgXuB/EHVEcnUmIZFTkKiUNxDHlFOrU4qAL1lAGHjVThOmQ9TC/RIh5ff
 5TSeaduayOHI1Da574DQNBzai9C5aZITed1Isu5O+eRbgByL6OhkByI8mDBirwiy34Rx0+n6L82
 ORMcvjItddYZvvR5BF9z5y+4sziyueCwlqbS6JV3gSdMBgKe4Xxc7q1J5xoTzAodKTiXk9vH9iw
 J/Bn4aJ+/u+8H0TAoOljUSnNVFp7eNWSzkWDj7Wvuer3blLcPjpySkFJ7mxzZ4nlJKi8RcOi13V
 szLf3JTVclAZKYgLbs05ff5VRkV974/AZrD7IGIs=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDA5NyBTYWx0ZWRfXyc6G5btopVqz
 ohiZ0pm1XB5/wz8MufYK3ZjmfM/44v5qk4/89dlZPNFC9CcqlYX8KBCoNXwisnSK08QMvRHgI1J
 OxV0JgY19M9U84PQPl9iMg9zY8N3886QcUzIlxS0wtVCjiLHZZtD
X-Proofpoint-ORIG-GUID: MpHcLEu2QufvTX6l2wqCs_-cuU3sKT6l
X-Proofpoint-GUID: MpHcLEu2QufvTX6l2wqCs_-cuU3sKT6l
X-Authority-Analysis: v=2.4 cv=A+lc+aWG c=1 sm=1 tr=0 ts=6a39064f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8
 a=aqf-EVUMqY4jMkQqvfAA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12313

On 12/06/2026 11:38, John Garry wrote:
> When evaluating shost->max_sectors, we currently check dma_dev->dma_mask
> is non-NULL, as dma_max_mapping_size(dma_dev) could previously not handle
> dma_dev->dma_mask - this is no longer the case.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
> I set this as RFC as I think that this change is broken, but it would be
> still nice to get rid of such checks.
> 
> I don't think that dma_max_mapping_size() can always safely handle
> dev->dma_mask == NULL.
> 
> For callchain dma_max_mapping_size() -> dma_map_direct() ->
> dma_go_direct(, *dev->dma_mask, ), we would expect a NULL ptr deref when
> evaluated *dev->dma_mask.
> 
> static bool dma_go_direct(struct device *dev, dma_addr_t mask,
> 		const struct dma_map_ops *ops)
> {
> 	if (use_dma_iommu(dev))
> 		return false;
> 
> 	if (likely(!ops))
> 		return true;
> 
> #ifdef CONFIG_DMA_OPS_BYPASS
> 	if (dev->dma_ops_bypass)
> 		return min_not_zero(mask, dev->bus_dma_limit) >=
> 			    dma_direct_get_required_mask(dev);
> #endif
> 
> And I did see a crash for scsi_debug (which has dev->dma_mask == NULL) on
> ppc64. This is because ppc64 selects CONFIG_DMA_OPS_BYPASS and in this
> case *dev->dma_mask is evaluated.
> 
> Suggestions welcome on a proper change.
> 

Maybe something like this:

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e047747d4ecf..d512080268af 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -252,10 +252,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, 
struct device *dev,

  	shost->dma_dev = dma_dev;

-	if (dma_dev->dma_mask) {
-		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
-				dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);
-	}
+	shost->max_sectors = min_not_zero(shost->max_sectors,
+			dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);

  	error = scsi_mq_setup_tags(shost);
  	if (error)
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 23ed8eb9233e..3cbef25a01ed 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -985,6 +985,9 @@ size_t dma_max_mapping_size(struct device *dev)
  	const struct dma_map_ops *ops = get_dma_ops(dev);
  	size_t size = SIZE_MAX;

+	if (!dev->dma_mask)
+		return 0;
+
  	if (dma_map_direct(dev, ops))
  		size = dma_direct_max_mapping_size(dev);
  	else if (use_dma_iommu(dev))



