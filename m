Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3F4327798
	for <linux-scsi@vger.kernel.org>; Mon,  1 Dec 2025 15:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764603201; cv=fail; b=o00u3QE+KywO9opLMmBmi6Vz/DB+g0l1m6/nuwi4HXas2sdg2Bh9jOxXJw2FucOPIkdPQfypck9KQBQDix51GEyb49Ac5O1EXvDvAm0lE1XK+H6wtr6Z2CLkthdASLARvvJDnvY4hsarFjnTaRM9iEP9qmPhVyNY1KPxHgPPFXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764603201; c=relaxed/simple;
	bh=xvskGOHPntVrQTrSWtEcZuxlr0jdFpdTL7TYS87X/jw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JWiwv9RGuBDbkMqhTc5IAf1IahP7D7DJEVaWp9Iig8g4OFM4FN+aCzu6UHAEk/LDo2K2+vXiOCIgSCFX6pWfx3FI/QxhbDzoaO/8/WCsCbnK9KFx9eUK15lXu9tCo7qcQrvc3ZZ0GvHx0b+LsDZJgVTwzZSgf/WL0amBupxeNFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jkyrCMNQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bLQy3d85; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jkyrCMNQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bLQy3d85"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1FNnab2246609;
	Mon, 1 Dec 2025 15:33:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=juGO8PhiYncOXvdjJbkxjioaJQ4qN51zOEo5m/5S6Qc=; b=
	jkyrCMNQm5VWkVtsW0E/pQbcBc/xqqE50Y67CvOnGqq+JWf/q9HoAaOows1OGJhW
	WfhWz5CxdoWRwYlsDsj0B4sTYCdmoQwsoAOQ84vXBC9o6raNRYaZptTI3/hFDlsV
	4QCpOfNyp7pvHQNIUkkXOka5crjur5dwiAuDknxP21VhNIMQftdh6dvxg7MW4B3B
	EcIvaMEAi4o9pOMFeCNZQJtmJZN6xWJ88gxIlrTw4TbsZ80ssu1jyZ6tIAaAjVhm
	GAWJw7xn/Ymsxqhza5/9pMaSu+TDT3yEmqXNM5ZXmTViH/gEtdaK8mjh8bGy/LRc
	D9wyxHbZezVGtsbmy1dVRw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as7f20rnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 15:33:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1Eoj6p035444;
	Mon, 1 Dec 2025 15:33:02 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010050.outbound.protection.outlook.com [52.101.46.50])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9j5g78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 15:33:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yPULebZiqCHtuWdleKEw6ytqBNuypZ36HwRalQ29cqXEIIwPYWmBIsXouXmYmms9dnnGETcziOKI9/HWrGz4i/9VwQv5P4epJ2F6e92CcT+kDiSPgihV3UJs892ceYZHQMTgXv6dizMtIO6BZkb81s7/ykMibX7hZ5t4iU6SH7WDiu3mFRGahOaxwhYKPl5Y5pHR9nljpH4EbM3lGBbM9MFlPZiH7yqU4xK5X4Obo/uVDKmgff1vol9rqu1wZm7VNeHKxGttceZtV6c1JWyjWu5egKvKx7MtmtEc/2GZpnFyyquDe85AkiL0659SZsWS7WPXHj6e9yCagAqjtNZrPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=juGO8PhiYncOXvdjJbkxjioaJQ4qN51zOEo5m/5S6Qc=;
 b=rebcP+24DfKrFJRAXKeP8ZMq5JYXuiWVN+dM2qy9VYEd0VIamdTLifmsH/m1GjXWPh9YwHiqr2Yu5XJIxrsKuSaSZRWxBwGlH7uP+RPeEQWXHbG/RTDnSesk2U95jplrsmegB8yHluVnQXgiDTAflQF4f7fQi+4iKSfFxJ8scSYcJm9yBPS40ct2h+HYK1EZd28qcciUQQHgsZ9+KJpwivvnK//X4zFBlZ0UiCwj7yuWvQ0jHOVzTYGjFSKTo7VWHZUvxQrKe2cvkIRGOBjDgMrJ6fWeaacjjn72jAFdepIs4NKAJRthP3ZJsNcd25nG9bsjj5AMncDmTOQgbdXhTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=juGO8PhiYncOXvdjJbkxjioaJQ4qN51zOEo5m/5S6Qc=;
 b=bLQy3d85+dOtdadSQw0DKJHmhxLzl2uI44NON3A0qhOcLzm/hMfPM2U1kTBpJ5uhc2o3cX6w/c9TZhwrWsKsc1yNhk5AyUkLD7bx+KtYZf7i8KkkkyZ7tHXxMyp2grdvrb6MaAp7RYDDJ3/WL20knDX1g+wbOx+bmTlU/zvciQ8=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH0PR10MB4615.namprd10.prod.outlook.com
 (2603:10b6:510:36::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 15:32:50 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::cfc4:ca2f:d724:5088]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::cfc4:ca2f:d724:5088%8]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 15:32:50 +0000
Message-ID: <28ec2d8d-0da4-4ca9-9a8b-3c2c42d6de9c@oracle.com>
Date: Mon, 1 Dec 2025 15:32:46 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFT 0/6] scsi_debug: fake timeout handling improvements
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, jiangjianjun3@huawei.com
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251113133645.2898748-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0010.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::20) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH0PR10MB4615:EE_
X-MS-Office365-Filtering-Correlation-Id: f5d3bb55-35f0-4eb4-3bba-08de30eee2aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjBQK0NLU1JYZnR5R0pJbnZycy9vNVdlY21jZGR2UE9aSlErVURoV2dpNTJj?=
 =?utf-8?B?SFRrelJUYWlibmRFempMSkY1Q2hvOU1TT280ZERkZENDcjJTb1JjU1VCZzlY?=
 =?utf-8?B?bTFSRU1YTHNwTDA0bEFOZVUvak9sTy94WDdXME5FL2JPSms5cjY2NnFQTDVv?=
 =?utf-8?B?RVMyeVF5dm5McDZON0t6aFNaK3dDaTdhN0x6WStEYkFNMzVtWUNpaitkT3U4?=
 =?utf-8?B?aW9iMnR3TGNLZDVra1ZWZUxwN2NyNllNSm5KT2NjL2k5QUVSWnpHckJOMElO?=
 =?utf-8?B?NG9meThKREZtdzJDUTQ1aHJyeUI3TW1YTXFoWWVIOW9WSWJ5ZkhZdWtYZlkw?=
 =?utf-8?B?dDFxRDd4VW5EMVBGUDNaWDU4eXhpVWpyWlJOWUEvZm15U3IvcTROUFRDTE9K?=
 =?utf-8?B?cTZWU3JWWWJaSzZKcHllZUVtSmhFaHp5M0NHZVFGMGp1cXYwZThYVzN0YmYr?=
 =?utf-8?B?OGZSQkNUOWdhb0xGeXM5VXZrWnByYklzaEcwU0lVNVIwT29KOVlsVWc4SXJx?=
 =?utf-8?B?Vk5jRXdNRjB6dlh0VzgyNmZnZGsybk5sUzNFL05ydW56SWpFalRoTzJ0eWVD?=
 =?utf-8?B?eXA3TENyaVRtM3d1RjZPaWhobHoySFhiUElsYWI5T0RNK29oOEJsOUF1MnAx?=
 =?utf-8?B?Mm9TTCsrVy9wNDU1a3c1TmNMMml5RjNpbkR5NFRxekRsSktyTm9ORlVhVDlY?=
 =?utf-8?B?WjdGTUF0alpPS3J5Q3M4cGZ0RHViSFFFTWZYK2VodWhVT0p5V3JOVlM2TjN1?=
 =?utf-8?B?M2VkaUNVSmEwUTVZY1BNZUlpd0ljOFpYT255c2owdW9JYWdVZHhkdDlnSWJs?=
 =?utf-8?B?cGxSTVRLYTQ2M2FCWDRWdmFHSXdxUFlQdHB0alp6MlBtUFBsR0tPM1pDNUI1?=
 =?utf-8?B?RktsekpTQXo2UDF3MUZQZG1XeXM1Z2UvYjEweE0rdHMzUlVDejN0L2syeTMw?=
 =?utf-8?B?dVhYYmZZSXdmVXptOURBRlJnZXRKSU4vaWFSUld2OEtOaDkrUXgzZ2IvMjVL?=
 =?utf-8?B?YU1HdXFIUXNpc2Y3WlZFTmk1V0lCcG41eWpteEREeFVNdWNTV2lTdUk2ckVi?=
 =?utf-8?B?RHF4cnkzKzY2ZVNTOEpLdW5oQ01ROEJxWlJWUE05ZzZzWEl4RDZHQXpzZlNR?=
 =?utf-8?B?NTByeEo4ZE8rN0dBTzR6dFhyTHNrOFdPZnBKUHFKR3MrMlNRNS9HczdpRmhM?=
 =?utf-8?B?RmRvbHdpODg0djVVL2JCaTZ4Umw4S1pLUVYyaWxvWFh0L0dQZlNXSHd5S0xJ?=
 =?utf-8?B?bittdU1aMDYyeTArNDgwcG5qaS9sZ0IwWmVLcUhQTzJuWXo0Wjl3OVRTTzU3?=
 =?utf-8?B?NG5kei83UUtoeTBoem45RWRhd0p0MUppdVIxOFhoTk9MU0RaR0MyZzBBak05?=
 =?utf-8?B?UGxCYzNlU3o3dHY3akttTXZDYWM5ZVg5a21qaURidENOOFhuenNncFFybXFO?=
 =?utf-8?B?VDF1SjBNanpNcEN0NDJMNHcza2VyazZZWVc5VVYxRkVlYzE3UWJwaHJvdGpw?=
 =?utf-8?B?c2dsZnlEeWEzaThVWWNkVlc2TkE5aG5SRENMVm9iSVAzVlhRSDA4a2c3S2Iv?=
 =?utf-8?B?VHVKZksrQmN3SWhqb1hwNjdWdFBQMjFPek5OUGVrZkViQzlzWXdyNi8vRGhk?=
 =?utf-8?B?dzhIallxS0ErMkdPU0ttb1J4UmlpRncxMms4aWlTZ2pzd2hPUEZkeTQyTHAy?=
 =?utf-8?B?QmNGV0hyRURGd040N2o0ODBVeDJKaVNwRGtGaDM3Q0tXTFIrdkVjdHVYbm5j?=
 =?utf-8?B?WUJwdmNuRnhRUXlFeWtlVXl3NUFLOXoyc2c4WDMwaVdnR0RHSzFaRzcyU24z?=
 =?utf-8?B?MjBmT2hrRzRKT2Y2STdkRVk1Z05XZUNPWElQdkMvbWtabkRGeGdIS2tkcU5u?=
 =?utf-8?B?UnBjVGZnWTEwTHZCU21lS215N0MzU21uV0dXR0d4dkR3ZXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3lHUVpwL2htQlEwMjJ5NHBEZ29GTlJRT2JpeWZTM0dNK29EN2NtcjkvWFRL?=
 =?utf-8?B?bXkzUERFZ3hoYVV1SnorYng4VTNQYkoyOTgyKzFydTlYZWhSQmNGZ2ZGOGIw?=
 =?utf-8?B?UTV4U0MzZlRkZTJYb1FOVFZPTGorRzg0ald0SEYvVEQvWm5MK1ErSEpONW83?=
 =?utf-8?B?MDhkT0JSbk1wUUc1Q09JOTRjMDFoaUlvSWpsZEM1UlZvWnJYNWp1cDl0MTh4?=
 =?utf-8?B?cm9VRm80cmhydzZHSHNGQXE5U01QNTQwMWdqKzh2T2M5YzBrSWl5VHhQU3Ax?=
 =?utf-8?B?aWtGdU4rUnZRL0djTlRNTzNIbmhMVTV6cHcyZjY1YnVsWFlzNzVnRENjSitR?=
 =?utf-8?B?OUloWk1aa2VGSEdEQjQ2a0dzWW1ickM4ektkVktGRlJRdnZxc2dPNnp5aDkv?=
 =?utf-8?B?cjRmeUJobXF6Q1ZKZ1luMFREdCs3U1JBS052czRrbDhaTkptQUIyTm1NeWpJ?=
 =?utf-8?B?K2dQWGRNb2FuS1VuNll3OEh0QjdLd1FySncySjc3NTM0YzZiT1BSTWhBRnY1?=
 =?utf-8?B?OWRRSmE5Sk5lM2s3eGVkUUVaVVRsU0tuY3ZiTTVvUWNnVjdYd1BLU0YreHV6?=
 =?utf-8?B?ZjJHa0JOZldGOUJ3MWYwcVppTnNNTk9JNEpLWnBjQ3J1NUpYOFFhZFVVemJV?=
 =?utf-8?B?aVNXcms2cVJnUGpzN24zckVXbmh2SUJTTkVNWE50QSt0M1E1T21FdTdkY3hl?=
 =?utf-8?B?aWZiWGcycFRCa3d1Vmx1Mmp0YStyQ2daOWo5YWtCN1JHTXFXd2RYUW1mN0Fp?=
 =?utf-8?B?M0ovYnNycVVhMnp2dlYrL3N5VnVWdEY0Nm8zdDJDWHRmTFJ5cFl4TWhuMEhu?=
 =?utf-8?B?ZFkzMll2aGdsUkNXaFBEUWpsbmlUanlxNktUclZGd3hmUi9tbE9GWUEydXRJ?=
 =?utf-8?B?dzllK3JxdTlqRkFERHJXWEhhTjZDRWJlZkNTSnVISHNNM3ZNdDQzVlNWQVdC?=
 =?utf-8?B?YWhvT0cwa3ZLbUNvbys4Y3FmcEpPeXl1YkxZZ29hZVVsRnJtTDZuZXFURm05?=
 =?utf-8?B?bFRWT1ZxSlpCYWV5dGFPdjlTR1RvbmhUZkp1YVVVMXVWYkx5VkdqZEVkbE4y?=
 =?utf-8?B?eUdkQ0FMRjduTW9rOHRRdk1YOE5hNWxoeTZmeHBhRHdvZlhyMElGOUZ4WjJw?=
 =?utf-8?B?ZFlPdFA0eUcyN3BRd2ZZWXdkUmNjVVorSzVmLzJYNlNXZlNsejlFUFBVV1Vu?=
 =?utf-8?B?L1o3NG5SQ2F3aXRUSW5WM2lUeERuZ1p1NEJJMnJsRVFmZlJNeWJodmpNakdE?=
 =?utf-8?B?RXhTVGdtMzJva1dYODRkQ21jcXNxVFl1TUJoWFFpVmY2YkZwZndua3ZBRWdr?=
 =?utf-8?B?QTF4Z3NXVWNycmJhL1k3TUVvaEtTbEpmc1kwTGZRRWVpQndVWjRINGpreUU4?=
 =?utf-8?B?dlVIcUhpV3V1b25BcFdoK01VL2p6ZnpEanNNSzc1M05HYkg3N2hpNmtXamdF?=
 =?utf-8?B?cjFjaVNTa3Y3ZjJDa1IxL2lDQnltdmRnNWJPempMcVpPYS9wU2ZmRXlrUW9h?=
 =?utf-8?B?Szl3TktRQ1FwU0Q0MFFoU1JkTE54NG05RWNRZDRwNFlSR1ZDSmNZckkrditG?=
 =?utf-8?B?TnhKdldwdGZJcDNaMHdrWE1qSGl1blNDV3U5Q3dYS09QWDdNNDRKUmRTM24r?=
 =?utf-8?B?bGV5TFBMVG1nVUc3WHdwRmJuTWVqVlR1MXV5QjdGWUUydm9xc3dybG9kd2sx?=
 =?utf-8?B?algwL0NYaDlsNEdYVzdJYkVOZjBZSzZ6dThlLzBMN3J3RG1DL0JRbC9sTGNM?=
 =?utf-8?B?NHcyd2RxZmd0NnNKV3RpaEhhQ1ZBL2JraVBQQThzaFNtbW5vU0poQ05sVlds?=
 =?utf-8?B?dkUrbXNXa2ZDeU9DOVdDRlVPNWlDd3VHUVN5RUVRWWFEREdXcVhNbjdxdE5k?=
 =?utf-8?B?NWNZdzR3TDQ0Q0gzNUI5MCtyZFBzZVNFYktFSWZ1VGQxVDJzVFo4UEpCTGFm?=
 =?utf-8?B?bkRDUWFkR3dFQnM5SFFVa05xdmJ2VXBOSkRCSDFFRHoxTnpJeEdwY0gySXEv?=
 =?utf-8?B?ZUVCZ3hidnRoZ3c0ZWErMHZ4NWpFWFJjZlEvdzZTekpMWEx2U3JFTDUrdm5E?=
 =?utf-8?B?TXl5OWRsQUhXeXYxckt0S0V6LzlyWEVRaWlXOUFqQ2d2ZG1WWHBnN0dkc0N5?=
 =?utf-8?B?YTdvUHd0YVova0pIS3NNV2M2WlhrWGpicjJ4MWEzRUhOVHNzcmVlUUpFSm5w?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wSJun7LAIgjggQygzTzXpkyt2G2wSMPDpgU1sHcijOtc6FTbGgWsXAXQ36ZuCV1KiznlL1u2hHDpdF0Bqf7Ummqf78UiTiAJKXmF928Vz//wbnyOXGTfFyHUJvy0lSa2/7o7PpLMCGjDWtSsZ4SUBLpCKlSKy1wYwAckwEvPFG/nBEHh2kL4QbGyu3Jtsxn9zQk2RWYavrAD/vc8ZFORZPZ/aQziCWrubJJ71djleSGxSPkpA6Qhj9JZU1K3sUJZ1ifdJu9hI9x9QuWopmENdw/grJaC7TpnC6zs4I0OL4tLEv413NVx8o3ruQWG2HkLituyN8sy1c0AUhN48AkaLp2nuZ/svKYQ+0/B/sZ9UKit9MOc1BSP9QXGj8AjGWEikdp5d2t3ut5GqS8wguL3lflmWn3qTE1I3vn1tN8++dqAkexGuHemFyx48EiidCOtpP3Tam9ieW38FnvRwzBS2AWp+4MPQsmUkP5aXowQkaB4arA0q9Jy7DWNE9uGobMS3ibIJ7izQAfOD1xRpyjri2Ri2FfIVcApfQotGPP//4Cquk/TorAOHSydpQflSJJsstu7i/oKsemDsL7CBF1ewvP8TGCL7wrqvLmTtK/8sK4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5d3bb55-35f0-4eb4-3bba-08de30eee2aa
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 15:32:50.0281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QPqHHLd1Yc94TnobBub/elUM4c5fESVU6XDy1bVUiXcFAs+aXw3j3NqnAwnpU67QKNeJbZF8bx1NuFocRvp4dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4615
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512010126
X-Authority-Analysis: v=2.4 cv=QMplhwLL c=1 sm=1 tr=0 ts=692db52f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8 a=riL8yLjqQHZVHZOqydgA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13642
X-Proofpoint-ORIG-GUID: wu1jU8YAdViG-eEx-o1m1dKS9upJoU4N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDEyNiBTYWx0ZWRfX0VRTq7Zhqbw4
 vhf6Y7smoKqnnTmV93w4DmxLYy3A2M1H58LaeB43RbLtlEBsN0XGlj+5SnTu4x7oC4+sPfYWZoz
 qbCxwcso59tyP3UZk/kUVk4LrldLp6OW/kzGXaJcEOileyeUqC3mQF3pqYJur30p8Lc60IM1ZRj
 H7YZyYxjOe3rphJmL5N8VAKRoQu6odF2fAP1a8yfzJwwWYheXXJIyzu2wIK6u6K4Vn6HP8bhN/7
 9EScrEDAARoZ6QOzqy6KiX/5ZJZ5OLs8DHqnItUGXz7vSCVZGR0ntwzBkbZ0YwY2bZfiuR+V9NZ
 2fzm8HBb4A/9v2fnrUF45Z8ce/0P9MHiBuxiPAhZNnKGd9iLat3qHzJJbwC61IFb+hC4tn9pSSf
 mB/MFoQ5nDFg9jpHcVSWoYMOInKlmkhQx9SSFEpDeE9r6kngOrY=
X-Proofpoint-GUID: wu1jU8YAdViG-eEx-o1m1dKS9upJoU4N

On 13/11/2025 13:36, John Garry wrote:
> This series includes improvements to fake timeout handling.
> 
> Specifically, when we try to abort a scsi_cmnd which has fake timeout,
> we check the deferral type, but this would not be set properly. In
> addition, we need special handling for fake timeout in the abort handler
> to ensure that we don't get confused with any other deferral type.
> 

Hi Martin,

Can you please consider picking up the first 3 patches in this series? I 
am awaiting feedback from JiangJianJun for the rest.

Thanks

> I am setting as RTF as I want to test more. I also would like
> JiangJianJun <jiangjianjun3@huawei.com> to see if it can solve the
> problem reported at https://lore.kernel.org/linux-scsi/4efb45b3-455a-44e8-83fa-e64ca8b9192a@oracle.com/T/#m2092593f3bc4b5fdde3f77376b65c10ab7bd605c
> 
> Finally some tidy-ups are included, which are not RFT.
> 
> John Garry (6):
>    scsi: scsi_debug: Stop printing extra function name in debug logs
>    scsi: scsi_debug: Stop using READ/WRITE_ONCE() when accessing
>      sdebug_defer.defer_t
>    scsi: scsi_debug: Drop NULL scsi_cmnd check in sdebug_q_cmd_complete()
>    scsi: scsi_debug: Call sdebug_q_cmd_complete() from
>      sdebug_blk_mq_poll_iter()
>    scsi: scsi_debug: Clear sd_dp->defer_t in sdebug_q_cmd_complete()
>    scsi: scsi_debug: Add special abort handling for fake timeout
> 
>   drivers/scsi/scsi_debug.c | 163 +++++++++++++++++++-------------------
>   1 file changed, 83 insertions(+), 80 deletions(-)
> 

