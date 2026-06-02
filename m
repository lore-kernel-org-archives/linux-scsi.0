Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5647A3BF685
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 08:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780387482; cv=fail; b=a1ltrbOu7/sORzBwGresavaZ1WOcLqczGFtrZedHsLtIyenQ09QgoNEH/2rdhyEBhqZUcqErKyfp6GkYcAk52ry6Cg6mhAufccx/S8ZcoL9MqXR8yAkfxFZJArOYOZIHqVH1Mo6+ezLmInrdFlI+4OdZo9YRaCoDzOwC0ClZTNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780387482; c=relaxed/simple;
	bh=tQYm1JJoQCK9SbL4t4KPAHCTVS6WIOUIEyw7Z4HziOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GqFkBOfp3dkJBcEAFq2SXwzEK7DRzyfDKhM5EDUpm8z8LaKlLiaCCvNWeGa+oemA0bLLpyO6kLsSxKEIntG3JOco2WbRM4ehGzjL41VVK+2HiKn+awp0RLw/ohCY/gK+i6VL3/RrTfk0BpVQqQ4uMX3My69bByS9aHCFxYx8fLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=KqCJ8iFO; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="KqCJ8iFO"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6525PxAO1025271;
	Tue, 2 Jun 2026 08:04:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=tQYm1JJoQCK9SbL4t4KPAHCTVS6WIOUIEyw7Z4HziOU=; b=
	KqCJ8iFOIuc8R6WNh1780WvCwFjTTwmFMPVdCJO+tkarusSeVswN6KpZpEW5W4mi
	Ckc0bkTQfFe0XIQSw6SshpmoD5TMnU3N5HFhlUyGrOR/WlrBRgNuvwA1UHBCfado
	VRt2uPmnkkMGTsPbYwXzxFeZrwtsoXmV8MC+XR54QS90ZbVr90n6IVyBuLDJYGZ9
	Lu8DIboABaO2TFuzSLjqKdfc593v9dAsZWoTAOVIG8jYNoqKreW6BE442NtSnI8G
	InF0OUuL1AVukwkB1ZLp5plL+qeH9k1DYD4dRv5K90w2qMnM9Dt5V7bz2GSM87V4
	XhkoiKZ8S2Q2fbDtEV1SjQ==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012033.outbound.protection.outlook.com [52.101.43.33])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4efn404dfg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 02 Jun 2026 08:04:22 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MdJ32Ql6Vj25+rsC9fASwwP9o9M7yhhusB4jycNph+3EZrR4qygUPE/k/dOgxEIaqLDGNTpialxjpLwoDX1+ruIXRvJDSuRrLpN62I11MWzr2n/+HUUAAj/9clD24phUrlm51VnyFh8kB3GUgcbx+G8aufW7F3sSzfAbL97ggeECD7wpYDjZklsIL5BpKOkUX63GJqBRVQZu4MYAyje3FqOWgPruq/ohoURbTSPMTLwuRzRa85ZxUkvmuk9tFw9Kf1DSHzR/eiUFK5e613UqSfAlH/C69ua3al8F5vYy4U4geNv+V6bSww2O4x28KRXeXCPwye1KoAmMo3VQMz0w8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQYm1JJoQCK9SbL4t4KPAHCTVS6WIOUIEyw7Z4HziOU=;
 b=Sqcg1TwPIwvvR5N9H1HRZ6x6zlQ1Af+Ve8C6Z2hJ/E8pBR8V74meQgw/TWA/th8V66BRAP1otG4mHbR2Wjdk8QJlaqakX0tLvzGnwunmEAZBC1Lvc65AhxBULNdA+uK64AIP53sGarLO/clB9EqLQDWZfDpu/fKbSEEZS2fIGhT7SnchtFlGh8UIg4m0vapqO2ip2N7Bl3eNItHqLT0M6oy8JConDglhO5lU5eK6OrDAGYTW7iJUKU2AyM9Ba24Ll3Cq5kqS9sHh0gPryhPazbqblJKz7LNEw9xp2mS9Xhyhm19Xm9QpqCe4L6RnM6jxetnQaMl9thai2tmEMv++mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com (2603:10b6:a03:4cc::8)
 by IA1PR11MB8224.namprd11.prod.outlook.com (2603:10b6:208:44f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 08:04:19 +0000
Received: from SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced]) by SJ2PR11MB7546.namprd11.prod.outlook.com
 ([fe80::ca9b:dcf:8881:bced%4]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 08:04:19 +0000
From: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
To: martin.petersen@oracle.com
Cc: hch@lst.de, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Ionut Nechita <ionut.nechita@windriver.com>
Subject: Re: [PATCH v8 1/1] scsi: sas: skip opt_sectors when DMA reports no real optimization hint
Date: Tue,  2 Jun 2026 11:04:04 +0300
Message-ID: <20260602080405.35528-1-ionut.nechita@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <yq1mrxdafa9.fsf@ca-mkp.ca.oracle.com>
References: <yq1mrxdafa9.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR08CA0207.eurprd08.prod.outlook.com
 (2603:10a6:802:15::16) To SJ2PR11MB7546.namprd11.prod.outlook.com
 (2603:10b6:a03:4cc::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7546:EE_|IA1PR11MB8224:EE_
X-MS-Office365-Filtering-Correlation-Id: c53cbc71-ada1-491a-a058-08dec07d8c3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	iTv0CqgdevITOWTbhI2C2rnSbJb45W1J+shyR7twOtyJqgSG7lRvY06wWECUtkssX9MXRNw1L4Iir4qBBgsYDSutR1xwRPC8Ssq0HxMx90uO8LJKReBitkVhxlRgTlTRt5I7YjEo51nadi5AhQymvVuZTFrVkfp1RTGmES+58UPmpO8roGGLs064TgGB+hobJpfid4yL4iYYJu3HMh8U6I6BB139CeWRt66sb1Y7lDuOB3KeFgye2oivwGpX4qMeoEsc6gPsup0sh44/erzUQ9xRccD1KP+iyRWxppvoHOyOfqjcKOe0wNYnZ3tdY0/c/D+Xwlek98P9DTwtjXotxGClLlGAxgtOhquQeZPqLTmHEWUiqdxOozCM+6We2NgmJ7JIlvBXwx12iFAF409kkrV5dTsc7ERbcACmmc0PPsB3JgIN8napK76xDDl48MA3hbqMkB9CLtQdkV8XLB+GhaquE+jPRsxoXG40PX4N2Kh/KMX6a0TCMbHD3pNPdwndQxbYasvEtdhXUfLMzLjWNcX5M8EDE5mbYS49GYn7s7b/XOpBqBuJgV3JQsZVIZ2N4XxzH9YJWCfl2UpQEdz5dE+tRfNfSJnbUusG2t1Esoa8ObGGgrqrTHVIRxtXvDExBLEuvDYiiEarxLqpae8z/Nm553wCdNyZOZY0uOCQtdPEYZvOatMLmIctUVov+lBRUscP15lmITZR2AYCYtAa74r2+m+UcT2frxnGwnktmouKFcaUjYalm8/QsQFI22JV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7546.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0ZCM3oyWlZhK0xQV2J3UjZQRTA4SjJJK01LV2YwVENPRmNUTnl3amRjdkdF?=
 =?utf-8?B?d053aW5zNG9WazMvemxEVWJtSjJxUjJNdGcwaVdsN0RYZXdQSXc1TnRubHIy?=
 =?utf-8?B?RFQ2cDZ1MHpvQm8vbGNkVEpNRG5rc0RMdHdodG1MZDg1RTlvdTFvTG5nQUJW?=
 =?utf-8?B?VE9MWTNlODNqcng1eHZpam94OVBqZEgvaGxlWnY2L2lSNTkzTFg2aE9FOU9v?=
 =?utf-8?B?Qjk0OVI4ZDJWV25rcDY5L3ZyaVk5Y25ka2xOZTh4ZXBQNFJPVUIvVk1qeXo3?=
 =?utf-8?B?d1Z2b2xTVGg3OG5KK05TMmFjM3ErSTJlMG0yTXFWcFdEdDZvMkFGaG5DVzJ4?=
 =?utf-8?B?UXZhZjBHV1BUUkZzRDVtb2dmV0RnMDJnVU13S25JRmFjdHQ1VHJkQkxoY2xr?=
 =?utf-8?B?TU05YVFVcUgrc2lmSzlzUUhKL1ptVFYvMS9rZlkzdmYvOUg3eVUwRURoWUNt?=
 =?utf-8?B?c2RaUmc1b1h1cW5JYkhNa2E3N0UvSVp6eUJzQlhrR3ZUS2xaaEk5a01JYnBx?=
 =?utf-8?B?aDBuNDNLREdERG1Ccm5nbVQwYzJEY0hWeVNMMzJKVktsdEJQRW5uN25xT1Bp?=
 =?utf-8?B?UTA3U1dZK1BRVkU5b2k1dXQvaDY1cy9uTmZpN01aWHkzWWsyZ0RlQ1JtZnBq?=
 =?utf-8?B?cmFySDVTeDF3UmZDZjhPL1Y2VjJGUDlHL3VSeWVXVzgydzFqMTBEK21uYnRk?=
 =?utf-8?B?djIvWkVSRExmQ2ZuZ2pnOXpWeVJIbjRpNWh4YTUvTmEzcjRjR1JKejM0NS9t?=
 =?utf-8?B?WXZHRlAwSGphZzBOUStKRDlmaWNwOHF0NmgwenA2S0FUalRYSC90RHpLUTBm?=
 =?utf-8?B?NDdrRno0WWI5UkI4NlFHcCsxUnd2Rk5PTE1uKy9xMGhyS2g2NW1vVG1NM2pl?=
 =?utf-8?B?QVVxS1ZxdjZOVzRIYVlzb0hGNkxEQ3NBM0wwcWRuejNQbzRKTDhPK3ZucUd4?=
 =?utf-8?B?aXNIZ2tyUFpJL3VVUE4ybkdzcitRclFvaWk1a21YM25qNWZ4cWorSG9reXYr?=
 =?utf-8?B?a2hCYy9zMWYybWErRkpTYVVNRGwyK0JENERxTWsvL2pwSHlRYkhZUFgza0pZ?=
 =?utf-8?B?U2tlNmFRc3dFK0ZrZkZOTVA3eXd4dENlTTJTSXRxRWM1S3p5UlZ0VEJ6T0Rx?=
 =?utf-8?B?cFFLOEk2ckh2MHA0UUgra051K2xWSzVHN0F3Qkx4V2pnaFRyUjNXTlU4Ry9O?=
 =?utf-8?B?azZXSDQyWHNjZHNjYTFPMXJEZDNuZ0g5a2ZDRDZMLzM2cDlZL0ZKSkx2SnNB?=
 =?utf-8?B?NWkrOFY2Nk0yUDZNMFN5eVVEbUV0K1BwTEk0QytxVEtaaXptdTMzTkJ5M2J3?=
 =?utf-8?B?OWtOWXB5TGxjVS96Ti9kbC96K3lkMjFLamR4TFVnZG00NTVJM1g4cW1jUmVv?=
 =?utf-8?B?ajdrUFdOVU9nUGJGaUNuT09FZHdYUTlUOWk4SThzWVFFdEZ5VjREWGZndlpY?=
 =?utf-8?B?Uk1PMHQ1U2VQMjNHK0pLWnhvTEwrYXVFQ05mbUxWVU84SWUyaUNrUlFZNElH?=
 =?utf-8?B?NkNIeWdWZzNMMXlzQlpsSVJnS3lYYkwrK0dldlZVTmE5S2E4WTJZNSsrWjdJ?=
 =?utf-8?B?STViYm1RSVFvWlQzTDk4K296K21qS0NiajNPaGVVVy9BK3dzS2FqSi9LOHFY?=
 =?utf-8?B?b1kzSjczUTc0bGpzMDBHUHhBNWZyU0xiMzBPM2RUcUVRU3FnWmEwTUR0ZXRk?=
 =?utf-8?B?ZS9NOEV3cXJxRjJJbXJKSzh1WlRkRER6RGd2eE40WER1WDNxUHEvcklsa2Jj?=
 =?utf-8?B?L2pTRW41K001M2pKRi9IdnFRMmNYdXdCcFo0TWd4NGpHdHRqSmRjeHptOG51?=
 =?utf-8?B?YTVMVjg5eEkxMFQ5VXZ4cHJOL1pXcFgyVGMzOFFoMW5RQ3AvT0pCaG41TElp?=
 =?utf-8?B?aituSjg2MzRETEY1dnptYWJzNnpmRkZ5MWlDdTlwaVU3ekl2NTdDL1U1cWEz?=
 =?utf-8?B?QndzZTViWW94Ykhpa2lBYVdhK2dWVDBWT3FOOTYzaXJlZmMxcS9SbTYzdUpq?=
 =?utf-8?B?Z21nNnNrbWUzS1M4N2s3MXlSWitJdklaVkJKOEMvSlplVk51VUVUK2dGVloy?=
 =?utf-8?B?em4yMnVoNk5MRlQ0TnI2d01mdGJoS29lbmx0VTRNbVRvTld3WjNJaVJnT2Qv?=
 =?utf-8?B?RUV6K0g2UDNkK0l1bmZOOHA2WnNBVXMyKy96NjRtYkk1djJYSUMwYzBKSVlB?=
 =?utf-8?B?RXJ4a2JZeUQvQWRDVTA0TkM5RFlNb1ZaNUdocUxzUWcvb2FCWEwxUzlUOFVz?=
 =?utf-8?B?NnNSVi8wSlpZREgrRXpEdjNBNjRodUl3a2w0N05sOEpqeTZLWXFuRFFORXpU?=
 =?utf-8?B?L0tnU09KT0JUbi9wZGlxMjAwWjVkNXRBdlBycGpKMjJJdnVZaTdNRlVPK09l?=
 =?utf-8?Q?g/kKpbAp+EuDa8nI=3D?=
X-Exchange-RoutingPolicyChecked:
	VyPSFw4IMHKqpHYFE6FOz5veDOwQwm9dwfiRWRE1J3MItVEhkyl+uFp7XCL1fcghEnBLzilJI4XbQnQIb4TMeHDufYvctfF9hUgLCZ8KodGuRV/HldDaaYPOHHu2KPkv7BiP3YSpynktamcl4V1/oB1bvTYBn/sMl7LcKOwN+gAyyRaly7nTZXd43HEeOaAun8WqWJsdaULa6Wuw/9vvKCOtaNuMMmKOQLJECo2F2sLRU3nDPfQYGpTQCcs/CCzdzERZltVDlCWlKx24zooAT4gebo852Vq9a31vEADncxXIvsU9nOn6cxuSyyBATyd38XrTgNkteW3nHilZUNYH/A==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c53cbc71-ada1-491a-a058-08dec07d8c3d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7546.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 08:04:19.2434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RLBEJnXGTAOwRDyjQBLcHeSw5FTdak1dYIiTQVDh+6ilUJKJ9OfNbyd7QX4uS0YUX9cMOcwEY3YVeItcT6qoqNSQZB3rYWLyxT2dgzm6gew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8224
X-Proofpoint-ORIG-GUID: 7qrwJIsYg9etLBvkK5SkSi7t7CIPVwVr
X-Proofpoint-GUID: 7qrwJIsYg9etLBvkK5SkSi7t7CIPVwVr
X-Authority-Analysis: v=2.4 cv=GI441ONK c=1 sm=1 tr=0 ts=6a1e8e86 cx=c_pps
 a=BRoDR27eCUDGJJSfTO8W4A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=t7CeM3EgAAAA:8 a=11XPjPHhOfc736ptFf4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bw_wPOzcWo4A:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDA3MyBTYWx0ZWRfXyyCKDdSDnMWb
 RroDRQ1TrHskpEgnug862bUCT3hrouvhCrK2XzT6XXsKZLZU7wULUtk/mNnWsZQmNvtM8zpGlHD
 s3ns1F0QCtYE8O+I+GO1eHICBmJPWS8DbdQxTGW2qRDpQjefanGbI08Dk2CyHyGKJ0KSIqPYtWK
 TfrtL4lH7mIQx0WkAi3F/PQezXqGZYO+32MP9fLxDDIeDGngMi+kxQ9k+euSo/d7+rAzVeGecLM
 jB6ZnEjpmtrEzSVCMmOm+91WcYxh4ZIGuiSiLBK0pCZ3GuAC62r6P+tUNCezopWNFA/W5L5sHNP
 /01A8ZGHwRjZS3iCUUM2Q7pgjTlPyuE9DAzWBXHc7HGBqQRoWBoBpoIjVSWzeAaqCifw/hSERkb
 syX6m2BmRc547tPIX8rRtWVj9dWe/9jnBSCL18ZNtXyEaLafrqNpRoCLE5uVRrFHRBSUUMcseCh
 Yo4SFg8mAyNpsK9mErQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606020073

From: Ionut Nechita <ionut.nechita@windriver.com>

Martin, Christoph,

Thank you both for the review and for picking this up.

Much appreciated — happy to respin if anything else comes up during
the staging cycle.

Ionut
