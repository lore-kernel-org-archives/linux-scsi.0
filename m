Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08F033B6EF
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 17:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776707271; cv=fail; b=j3nYl2LlxHYa7UbonW5FfJu54PJ/e1eXZ/MeG3PNGn3FiQRVJyguFasBxS/go4FTL71npJJRIdxJcv+8HPJMjsfN0FYq+cccvoN1Yk0xyWqaSE559fBio8kilnRzqN0Uv6JMhOm5bqzWRO11wnjAa22aBFUQhGBivHt3sjGy9QI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776707271; c=relaxed/simple;
	bh=+eu7F/eVSaAUBHwJ5NUgyeV5z3MCdNPF7Iy2sTVMSy0=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mWuR6VY1+f/r+2N/k+PW37B33XDwsjEex6WKg5Ovt+n+a6bnHvsGTOAVKt4oo/Ehz7neFBznsPo4XBUxsYaasY4m4W2iv4MlwxvIvXeDdntgYC6WirCJx+M9sz1Ww8xHw22dLiP19zHu6YoJ452CsMSqfVAUTO8eo7/7hIJoV10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ed7h0eV5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KwiIqQ50; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ed7h0eV5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KwiIqQ50"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63K8QqJg702718;
	Mon, 20 Apr 2026 17:47:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5zYh7fk3VYt98MeEHGd+vOWESKhfan5DO6UJ9c9T/vk=; b=
	ed7h0eV5Uw3TQUc3HuysyaKjpPl8u7bYp/MQfkIUDRwBssZM5O3ga6ZRpeCtr2RB
	AihbYZb81NXXsYIZW0PHHr05FFc7vbZarn5daaBz0CDf+qfJNtSfcz0TVe2ZvhOk
	KPSiRrtYNGkDfyhEVTkoH5Oj9M1+lb1+YXt+AukCCpq6KoDPJ4ecG/mIyeK7NYWu
	i6r/Ko/t8DclJh2KZc0WAdhXDj1V8BbvAH0eC03epeYzkAhUERZs10pPkNb+YDFh
	Lem0gsqYdqFcsGUx+cRKHfPKC9PkSTg683+dpj1tETFXB+V8vLzGOZq8rr3t2VTv
	uHsuI66Yu0q4zYhvbZs+iA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dm2a5uuma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 17:47:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63KHkFLU038575;
	Mon, 20 Apr 2026 17:47:38 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013004.outbound.protection.outlook.com [40.93.201.4])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dn176fyej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 17:47:37 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xGeXb7MnF1Xw2W/eyyL7qzhfDRFIH1AUg/OVxMPkxRV8CAUXrZhOmbxmeTmifYNgvd7nCK5lqyU2IakNmYRcaOApxs0DlRz/RTOgCwtYzE3P5BHByINPHYBZR7V2m/u2hfKtUj4asJLXNT0BXdRq043gOn4l7mTaZ8MmsPn0/C1p4XIfm2Hds/Y2zeDNrZ49D/XW19oeAKT7mxE/JqteS8ya5dYTekvaVOdNjDUB/HYcXjtM7ajbOuryST7t2RiRH618zJh3uy1RlrvIvdfdQ0Sm82r2pv9vpRCPE+xp6u7iTP/8SR9OkWYVix/uTpIXHgBY/huxhxOH4Hm2ikb5Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5zYh7fk3VYt98MeEHGd+vOWESKhfan5DO6UJ9c9T/vk=;
 b=Jl5z+iX0O1lum0Aj+Hbn8cGYNY2CzFX1FfRxJYcaQyeBQV0gMdbVKggaYwx4ewNtUvJj7XJbXZu5LuYdssFefAE9ZhkXxlfh8F0EVS+3owpj0vYvJCg3v8s0yuvJZZxC2owOF2LhtVeMsLTc8YIG2wCRAfIOf8K84W1+lolaU5f9HLtkqxW6FERawiArB7VouTv5z4lO03w/xdTYF0i/Aa2yT2djJY4cIcS3K0arEaAfCjBbgKP0HiEbx55/d3tJaEQiPO0EnMftGS82F3kLBssDlEJz6GEXkl9cUjxbBtQ9hEsltVv2fku+wKlnTBdIZGGtj8LpIfkPIuCHeZggUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zYh7fk3VYt98MeEHGd+vOWESKhfan5DO6UJ9c9T/vk=;
 b=KwiIqQ50DdcUvp1FS6dP4qDY+U+J4GeW/TWwC4++nBDwX/fhfpopRdUt9BVLzfZBIT4C+RsviRT/rEk6ydn0IVj3EKU5iYL/Q1ReTXjR9R7JxU692OjJE6QJiZLnOLey+otDbKekzZgDQ2ULt1WovVH+DtxkRm5QRX07c9mJc0Q=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by MN6PR10MB8048.namprd10.prod.outlook.com
 (2603:10b6:208:4f4::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Mon, 20 Apr
 2026 17:47:35 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4713:6549:d8c2:52b5%8]) with mapi id 15.20.9818.032; Mon, 20 Apr 2026
 17:47:35 +0000
Message-ID: <b3234b38-7eba-4628-a7df-24cd7460df14@oracle.com>
Date: Mon, 20 Apr 2026 12:47:31 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] scsi: qedi: Fix command overqueueing
To: Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        virtualization@lists.linux.dev, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com
References: <20260417230751.117836-1-michael.christie@oracle.com>
 <20260417230751.117836-3-michael.christie@oracle.com>
 <197fd58e-2cc7-4ed8-a662-52120f39c5e2@acm.org>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <197fd58e-2cc7-4ed8-a662-52120f39c5e2@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::22) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|MN6PR10MB8048:EE_
X-MS-Office365-Filtering-Correlation-Id: f782d58f-d41b-49af-cb88-08de9f04e799
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	jM7bFRiUhs8hpzkEGpWLSxDZI9C9WpkP9UXJshD33btDvY6w3W8zzUvTg05T7ICYd8PwBBAxLZr241CIZRqqPPvGvaUMYQkNWGGw9Y942zhrelO8nCDLm4PKZCZFqzAT7uglFmzbgFz9n0aPDy9U5wWndO79Z6FSBYwn3v2IHSXMzp+eBVq8AzT/1OhgNjA19Ipwp63O6AleIF/UIflEoVgzXiT/qAopIiCp7omk4k4TpOc3uy19rDXKAPrtAmarWUTRxlQc3WWecvAml0ZKYJXPORKQVMAg2M+tBUxFfK8vSRI3o5jJtWsIk8B+HlUb0VSVflwgIymdnHQXFrgFVR7nMi6xE6G5SkIVv06c6DxOXX8b6SENsuo14YlS4u8lszqw76AXmsAlIJcuo732h/K/DofwUAVjy+v65DVjd2I4Tf7XZamgyleB+sRpIaWVq/VaX1I1F3wEpmdK71AeGyrAECU3vKx8ZmqmiS6wHAdLji98D20gGytKmIBPhgw6PXw9+Mlep2Bwez5v541Ys2YpPA3oVr6BVQ7a3q7ziI2PoyZQBfqoSiMhZmLPehpIsyV32MDPVDxmGjawTh/7DnDKwR57Y0YMnl1meoq9Smkj0RPGlZIuurVbE3n93iDEVO57zz//hvAZ+4Oaakq+bv2M0OtqwniSEW3DRB5b+r7zW/Gd8wmLOXgURYJbsl85fUa91TEq1ggcD7gCiVEAnB/kL+RsxheI4KqJXDC937U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjFuaEM2WGhLa1g0d09mVHN6VUJwRXArWGtEUUpQL0hndFVZYWcwRDJteXFs?=
 =?utf-8?B?ZmJEekpxRkdBMmVKYVd5UVhEOTB0eXA0cXhzY0JqWFBCUHZGa3RsRm85b2Ro?=
 =?utf-8?B?dVFQYmdmaDN0d3UvTC9ZbEZHUmpYQklMaEhJRm9DOUY5REJ5QTVyZXhKTFlx?=
 =?utf-8?B?YTVJWnB1ZFBraldUM3V2Z2VVZVcxRktIaUlRVHdCRCtzdjlZYnNxVGVidXB0?=
 =?utf-8?B?a0NsVHdyZE9oUjhMbm5jWkQxOVpOVEFSUEV2aHdxdjAwN05JUzR2c1VnQUhz?=
 =?utf-8?B?dmtzTzlzcUJqNk9pUldoaUlOZ0lJSnRhTjNTNGlNbXU1RDNSQWx4ck9mQ2hR?=
 =?utf-8?B?K2JhOXllMEVBSVk4d0ZRb2RWNDZteExucG5pcEp1eXhTREtPZ1pyNXJ1aXhE?=
 =?utf-8?B?bmx3ZFhoYmtnb2orMXJpT2JwdFhPc3RrckRHUWxueHk4VTBKVW96bERJYW13?=
 =?utf-8?B?bkRnNVZHWmtHTU5kd1l5TkhCczZ4RkRJREs4M1JDWkFCaENlZ0FRdVBkeEE3?=
 =?utf-8?B?NmNFOTlibTNRMjFhbkZtWWVHQkg1c09HdFBBVVFJVllxT1I2NDJ0Y0diN0M0?=
 =?utf-8?B?blB4TDY2L2QvUGxaU2dPeWZtMVdBRFNaUGpvNWQ3enFxLzFsbzdJTGZFeTkz?=
 =?utf-8?B?QjFzZGVZY1c4MUdQQ1NRRmxBeWREOUJ3VzFRWjJtK0xlbHlJL2hLVmU4Rmtw?=
 =?utf-8?B?eC85cDgyblhYTDdCaUVLNXpxbko5anpUREplSHBpMW0rTGFTM2phNHhvY2lS?=
 =?utf-8?B?VTZ2M3Q5R1hTOXRJNGN1NnNJcHB2Vjh0a0dqZGltdWdJVzAwbzFsU0RydTZR?=
 =?utf-8?B?UU9CNTBkcmIxb3NlclVmaVFPalYrbVpGMzAzNVpnOGpLY3lxUFhtd3dEMGVT?=
 =?utf-8?B?dWljVDVzS3VZTHlXWjZVZ3R6Q3NZamw0Y1Jzc3U0WHVta3Q3endtTVJnamFY?=
 =?utf-8?B?VnFSMUNmOWxqelN6eHhhVXd3ZjlqcFpwcGtBUEt0eUFSejhmKzhnVDU3bXpY?=
 =?utf-8?B?aEREUjVrSmxnODI0V2pyTHFaekVMWXAwdWRHUFBteGZ4eGZVeEVBK2labWdD?=
 =?utf-8?B?TElRYkJsNVMyRU5hdkVUREZzRWdJaVIydDN1VWd0ZEtvcnFYZW1TdTQ4V2t5?=
 =?utf-8?B?YVk5NkcvdW85OHVFRjhjMSs2QmNrRG9pbEI1aUp0S21WQWd5TmNwTlhZN2lD?=
 =?utf-8?B?OUVib1c0ck5VUS9EbHdBUFBNdUtESGIzVUwwQVVhVlFBNDNYVVRrM1lzNlc5?=
 =?utf-8?B?NVVGdmdhSnVIV1Qyd1Uzd3NqTGRDU3lEWXd3b1ZxU29PSVMwRUUxeXRMb1hJ?=
 =?utf-8?B?ODlONnNBc2JxWGpzS21mYkRmTnlZUDE4UGd1MWFJYTBtbkNUSnFRMTZUWjJ2?=
 =?utf-8?B?ampEWVZuNVNUaTdtNFptdkV6NVdOY2hIS1NmcXJuOTM0cCtWL05pdEMwbXhk?=
 =?utf-8?B?S25lem12aE9kYytOamJuYzE4bzVXYnBlRDRHUE9pTXFaOTVnM0h3MHFta3hl?=
 =?utf-8?B?alFYNWlyZDAxdmQ3ZjJKaHdHOTNVclZWL21uNXZUeW5EUlM2c25VVFdtYndU?=
 =?utf-8?B?RjBqZ28vS2RiWG81NWtyRFluNS91NWZaaDRXWlk3c2x1YmJiQkVlMGpyQ1FK?=
 =?utf-8?B?UFdFamc4Zk5Ub2Fib3lscDhjSEJmNjhwdnQyUERIT1hNOHFDM1cvYXdjdVM4?=
 =?utf-8?B?SHpua0tPYjFQYzFmVk1xUk5PWER1U21xNkRzdTdlV2E3dUJublBaS3haVEd1?=
 =?utf-8?B?Wnh5cnZKMkhBbFhyZXorK0w4WEs0MkJqbGliN1c1VXVpai9HZ2Zma0xoMGRP?=
 =?utf-8?B?Zkxmb2tIKzJISGlwYklGMHRlWldmV2ZNWEgxditwcm9PMGRpdFFlVUNZOCtV?=
 =?utf-8?B?M29GZWJkb1FFZzl6a01NOG4rS3I2eTVESElQditBQUs2dnJOM0UxZ3IrVGti?=
 =?utf-8?B?T2ZBQnQ3a0krUXhZd3hRdW5MQmFIRjJWY1JPYnpubFRiTFg1WGVSekJXMlRP?=
 =?utf-8?B?TVJRS3BYWDgxckw3OHNaZmJTM213dHo3TURLdHQvMS9CbW5ra1pYeEVNVGsz?=
 =?utf-8?B?ZjdwMFkrNzMxWWUxcDllQVE3QUZGMHBvU0ZYRkUxNVlWNUcrSGVOa3hnVm5J?=
 =?utf-8?B?QTU5QXN3b29sSWNQQjlseTltM1hkRmdpVlZZY0tTYmlBMlJhS3VXUDBsdGNy?=
 =?utf-8?B?elp1dzd2WGtmUTV5RUV6NVp0MGRrZzJjWG1kS0Z3UU5LdXFtYVZhUDB6cmlp?=
 =?utf-8?B?TE5tWGxMc0dJUDR0SnN5TUhkc1Q3ckphQlRqdGFBR1hhU3czVjUxa1F4M3Y5?=
 =?utf-8?B?bnRqUk4rdVUvWFA2TGd6ZkFGb1l0V0FOZkFwRzN2RjRFN2xwWitvMHJBNGN2?=
 =?utf-8?Q?EXSF5QkqSLKPNQgY=3D?=
X-Exchange-RoutingPolicyChecked:
	Rm/5qLrfplNfVQ1AekE6mdJ5yD+9dK59IAIhn9o09BMjLAV/M/nQVDgOJ16lsimCwRrfHI0WE57Kp46abTcPSR6RB2rh7ouFt1p/Qcg8K3TbLq4K6CiTqbhemhKozJ8HUFdR46SC/fB4Lu8glSwjU9JXf5X+vEp79YPd4nEavHROPvvcDyp2C1w5YAaQYWHXq2rJjk1IIKEKqQj7hEgXPlPZA74VrDJCYjizFabe9EhUiJhrg9AlEPuiqd/dydU+3ph2PmMB5IVJYm6p1GKMbyMQOLc7d/hMQzk4QRMiFUsNESBZhsYGzxGEnzAzM33+V7SIzVlDz1vN46n9l2vLQQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HslJ8VZ9UOhBVYKJNFlopBghUNYRttvv+tAJrpq32mmb2MJWrdthx/R+mhofh9nakfBl5u30Ir2x2sbckCWxpvWlsCb1RHXG2Vkljy88CMS4zb60CcDOBbWJ+jYwLfTDPEnndm6lj0by71Ly6WpyFdGlQ9F++FSdwXRJwoq41LQ2BABO9Mt0UIx8R7nGWHYPAlfR58j7155nKflDYDbKyi2RcG0GSwvHvodrL96gYLJI72alZ1ylwIpsOmj7EfMGdmE65cJqMpxRwKdz5DfQ/oVH/dUR7Ef38WHt4X3q5kTd1F3sD48P4pbMVddguLk5J23Cjqk0jcaSSKjrAeJ8lNWdCbFehdRrP77xAqup0uvaVEhiSe+G6IggagxoyH1zgfxGofC98YzchixKMQtwELVTzsbKweWv1sCaYcnMUIJMuXbCVVo6awnx3TgXQtSGPfLLs22yH3ULKXgLJ0sk+8/lEQ4BROj+f1m+pk0Sd0c+lNQDUMayxNgtd14oLhxmIpYb+Qn3OC/2Nl64gmUwt3dpCLcKO1z2Gmd/lBmxLb49b3KQ6Cy+qTotD1tBsrq49CMDNZY1DhO/obHsrznln5Mh/FNK7gtW6kp5lAh1iJw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f782d58f-d41b-49af-cb88-08de9f04e799
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 17:47:34.9769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mlPMbLO7EXojCFSAYh0ebe5bBDCjopsK/4IggP9xn/OoQOLQDIX8GuvY9tIuF9OzfIGvbFdTZgweE15APhpgWxm3cjmWFMrx40HIoPAIb2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8048
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_03,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604200172
X-Authority-Analysis: v=2.4 cv=U46iy+ru c=1 sm=1 tr=0 ts=69e666ba cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8 a=YcTM0fTZOCpCr_tWOfoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 5fr8y2nGdbCmVat6v0Ro885PHurwGtzR
X-Proofpoint-GUID: 5fr8y2nGdbCmVat6v0Ro885PHurwGtzR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDE3MSBTYWx0ZWRfX/rjNP8xfDQn5
 sp0EjI8O/rwuv6Fg78PcCWv1B5nRDtil0Qio/12AndsqKZj6PjVExUcjuvOUa+qCZIi5waknjuQ
 8WGb1TbJfVNurdLm3d96fyofZLLUz1DzO5X/pY1uTNV+E28j7Bjs9wjQ9lR3drq/iKzNlFVcjcD
 PzTR06bHaayonD0YdkXTR2DNZs5X0X7DgYRitFQmLRo83Kalotl4w8khY16Hom6uaf7E/f8OdE1
 8letOzWnbegQjoYJWXE+sskaS7S22zekTeBDqeGr4KDXGJETYik+6xBwodD8Hb+RQmsVXLDtpgS
 p3UMnIjy+0HoHL8vbTM45roAFZrRwqi7OaT2Is34zNyoC7XWyMgQGGaYTLSbga7UTKC4gjJcXDJ
 7mp+zewXRP3QZdYRaLXpcG2hoDPnzX41bxfkyWO5nkQ9eahWO6+so5l+n1fFm6JSE5NMd1v0PEZ
 mX3ARHI8DczRnUiZPGg==



On 4/20/26 11:45 AM, Bart Van Assche wrote:
> On 4/17/26 3:57 PM, Mike Christie wrote:
>> qedi supports a total of can_queue commands over all queues so set
>> host_tagset when multiple queues are used.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/scsi/qedi/qedi_main.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/ 
>> qedi_main.c
>> index 227ff7bd1bdc..0be0a9f30ee2 100644
>> --- a/drivers/scsi/qedi/qedi_main.c
>> +++ b/drivers/scsi/qedi/qedi_main.c
>> @@ -657,6 +657,8 @@ static struct qedi_ctx *qedi_host_alloc(struct 
>> pci_dev *pdev)
>>       qedi->max_sqes = QEDI_SQ_SIZE;
>>       shost->nr_hw_queues = MIN_NUM_CPUS_MSIX(qedi);
>> +    if (shost->nr_hw_queues > 1)
>> +        shost->host_tagset = 1;
>>       pci_set_drvdata(pdev, qedi);
> 
> Why "if (shost->nr_hw_queues > 1)"? It is safe to set host_tagset even
> if shost->nr_hw_queues == 1. See e.g. "[PATCH] ufs: core: Use a host-
> wide tagset in SDB mode" (https://lore.kernel.org/linux- 
> scsi/20260116180800.3085233-1-bvanassche@acm.org/).
> 
But you can't do batching with host_tagset right?
