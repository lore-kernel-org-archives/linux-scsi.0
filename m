Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1415819A2A3
	for <linux-scsi@vger.kernel.org>; Thu,  8 Jan 2026 08:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767862058; cv=fail; b=AavMDiGbkR/Ge6NpEJkewPtBS9gtm+g1JOBxcqyY+a8iQUgangol/U8Gnh0t30vJBEMQRFEEQ5U/hj0gV1MBvst+Bl/ygh2UbaTZCMCMcmiN/TiNaDCRIJdBik3ymTNCPuvuIIcmFgR0rEkm0yVqMRhIX/d62ARxmSb0FdjBUT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767862058; c=relaxed/simple;
	bh=mvFqwjh0dCKIMJdigVlfPitGvrpo8W/WbgylMojzwRE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BEWh9yE9VCU49R73fhfRfzIw7IoeBaWare11GMo/df1UtqCKqnceyLJf2iK7qYzz/moWZ1DCVSKTjGpwINf0LvOMdh/KG5wI1rQpSM9GjjnbU3NtVQ1Z3URZGsbPZjrrFwZ/+X8x14vDXSE9b2JO0Z49BBTZx2WfpfpfO18k4IE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kFJEefby; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vI3aFDvN; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kFJEefby";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vI3aFDvN"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6084a1aV3711156;
	Thu, 8 Jan 2026 08:47:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Vxmx74AepCiLpRH8rNGJ6z+uuzrkjIJyYoh6peyR6zg=; b=
	kFJEefbytX6wUKCaHQhY86NalxQFT8K/S53kDMcACAjZn4omKuRvW/k/kChb3sZ0
	DY0OV68NBe7IZih+Kn/z3VvJI6dzRdtVzige5usR5kOO1uoSz7cClzuAF7ANCMBC
	awtl4dHGrDA5UA+a4uXqfDljKFHTXYnX7iUZJUG3aQCmwqsbUqUm3OE7Za5VNPgb
	ZcQkGvDNUwk1Ek81Xw8aHapFRGuSVuSN0VSadpDp0UaJXqHuwINzu/7Vi4Ajgb3H
	dV06bbC9t+PW5lSUluY/jEq7OcdxsU1hldHND490vsMwGy1uNVPvYS7HD/ICJLuj
	on91Thl043+SPayGOIRgIw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bj5pnr73y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 08:47:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6088hAi4015540;
	Thu, 8 Jan 2026 08:47:25 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010008.outbound.protection.outlook.com [52.101.193.8])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjakb9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 08:47:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y+xeMfzjmR945y8hs8v6VCeLu4wQRclFxRm07FJATJTmGfqLGqxUDBuy8D7sU6XBBA5KCoMBvL2XM0Wd83hpEj5JjOss7jxX5TsDH3lbe7lMJuaUX7zYeL4baL/kCOqmmdrjSaQZj39pfpegxhPb0xZFpU3TdKnDFl2OQUhxABpyUilR0dfFfKiamoeEdOZYvzlbqpg63ZVDRV2lNacSUV6MCX9z+2h9yHEkk/ee/rIU9X91YXLr7eiqv3kRwZ1FnsSmr6kOLt+9QW+B5tSpgnsAMlY2ChsvP0f+QZZXt2y4xpBiu/4Ys3tALVrmvVNhEOr3dvG4Z+LddX2SeaL77A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vxmx74AepCiLpRH8rNGJ6z+uuzrkjIJyYoh6peyR6zg=;
 b=go18cN9YEGfleAQojYxbpatuhwqv7rcbZ5gT8/MT8Lsvsg75gc5odCAnGTCzWwCIK5LFRfT3/k3T8ssonY//Vv+vHuxyayASm+0ujaoyflLdqOUD+o45Qf6ILLzdV2ZAZMOZibSiTEQ+llY+/fZhl0sV82n5GvRRploVl++qDPyLflbYZ4b2DmvDY+lqtkFWYbfX/XjqFmbQLjI4WOKiiBUuaNptbLvxFbSX53blCSXk78IsloXdds0eyMboB3t4Snem/TkQHMXcm49YXd8fOtVCnoyLihwwl3ZtHTvzqJK2A+AcBhtNsBTKdCdWJwHSznn3ILJTtVAjqscZmCDRrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vxmx74AepCiLpRH8rNGJ6z+uuzrkjIJyYoh6peyR6zg=;
 b=vI3aFDvNUI79Lhg5LdG2byGJvjiSHfS7HwFodRgHjiPZi/fTlM6zG2HEVJqphlxbz3wQ4tft2WrXVPHdg33/3AhsqcIMQiuyCLVFzf7+hYXGvY67mOXCJWyoB9RFmvQZESCboj/jAnTMmCSFY79JFnmUUhhEsNsTIEFHzS2j0cQ=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CH0PR10MB5113.namprd10.prod.outlook.com
 (2603:10b6:610:c9::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.1; Thu, 8 Jan
 2026 08:47:21 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%8]) with mapi id 15.20.9499.003; Thu, 8 Jan 2026
 08:47:21 +0000
Message-ID: <07d4a3ea-1a30-42d2-a105-343773de9750@oracle.com>
Date: Thu, 8 Jan 2026 08:47:18 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: core: Revert "Fix a regression triggered by
 scsi_host_busy()"
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260107174753.3089238-1-bvanassche@acm.org>
 <20260107174753.3089238-3-bvanassche@acm.org>
 <e820c7d7-f11d-4fab-a505-11b1fcc33d3b@oracle.com>
 <c5b9bf3f-cad7-47b1-b000-661e7ec87a9c@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <c5b9bf3f-cad7-47b1-b000-661e7ec87a9c@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0615.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::17) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CH0PR10MB5113:EE_
X-MS-Office365-Filtering-Correlation-Id: ddcdf9d1-ba23-4663-5a5f-08de4e928952
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NGhYNFU5YmFsQjdWdnp3RmlDWUVvdlpBZm5laXZvMVIwc01MUnNxRG5kZXk3?=
 =?utf-8?B?L21SaGxNR095STIraWVFRWJGZ0hYMHU0ZHVDaVRNME1CZkNLTVJXSERKa0lL?=
 =?utf-8?B?Z045Sm1yYk9zUVNnL05QaWdGYUxJcitKWE5HYmZDMTJUVStvLzRsNWV4VkZC?=
 =?utf-8?B?TnRZOUUxcEVsc21YN2N4Q0ljM1JrTFNkK1ZnTXY1Y0dsMnB2SWhPek93WmJ5?=
 =?utf-8?B?MFozS08zeUprVkV1UkdHVFBJWWZxUGZSQWtFMjhNRGZiS2ovT0pWSzFNQ08z?=
 =?utf-8?B?UmQ4MUpTcGVuUUVrbDNtdm45NFA0QmNSYSt5NUNvaHJrOGZZMEsxb21XSk1Q?=
 =?utf-8?B?S0J6YXFlbytLbWlVdDdKVzd6WkJwR2hnMFlXemF2c1p1K01WV0NvT0laRkdl?=
 =?utf-8?B?YzBtM3IyRHZxQk5jUkd4NGNuL1B6VjgvUkcwMEcxaHZsN1MvVHA2UEswM0JG?=
 =?utf-8?B?Sm5tR1FxUTZGY2R6VmlwY21BQXozZlFjZ1F1ZGNXUjFNb3diNzU1YUpwdmtF?=
 =?utf-8?B?eHA2VmZuZlZ0ZDNMcTZWWWFxcUFXcGJYNnZmYkJVV3AxeldIS3lISjV0Zmgx?=
 =?utf-8?B?ZVRJbkpEV0dXOENDeC9qYUxZVTZCVzgyYlJsQ0I2V3Z5TTJJa2g2MXpjSkFr?=
 =?utf-8?B?aTI4ZFB5YTRtUWxqY01WbjdCWkxMTlg5bGxoNmR1dFhMNThQZWlrUlo0VkJ5?=
 =?utf-8?B?UmdVNW9Ddk9YTVpNSzN4di90NUVLRWpTYnJ3MGpHVGZlc2I0YjBHeURTRXJY?=
 =?utf-8?B?Qy8xWjgvQ0FBb3RROVBoRzRaNWFsdFgyVVM1Q0dOYUVJWkl2bmFmYTRSZitQ?=
 =?utf-8?B?SFRpNmp5MWtwQldmV0J6bVpqM3NIOVJKdDFMTmRLUm1aMmZmY2FYVFJ5Qmxo?=
 =?utf-8?B?amhUN0Era1ZrUEhud1U5WTEwNFozd1FTRWNqbUFWVFYvTmFnUFZvZlpWL3lI?=
 =?utf-8?B?S2E5RkpIcXZTKzYvdmhqOXNCWnNvYlhzTFA1bW1QY211eFZYcEdCQldldnRR?=
 =?utf-8?B?WnU0UlIyMHo0Mm9ITDhPYk0zcDkwV0pUakpVaEJnWlltV3huZTY1Nk1OQUpy?=
 =?utf-8?B?UzlvZEZYNi9CWGJBMGdxZWRud21HVEJNWEMvd1p2NG5oSU8wS1NQZzhmZUhu?=
 =?utf-8?B?Nk5mRDBSVW9nT2hvbEJYNlp4N0krSjhBNDh3bjBUa1JRN1pDM2xiTE4rOUhI?=
 =?utf-8?B?RjRVdEc1eGVDbzJYYkhUZ3VqeEl0RHBtWGNXc01BUzBMQmFNd2pVZzh5OWlQ?=
 =?utf-8?B?bnp4d1hYS3FjbmNYaGdsMzVIQk40aWlHV3pnSlc0MXJzVUpyb1JmbUV5a1Bt?=
 =?utf-8?B?WXJSM0VvK1VoQlN4ZGNsdEw0eVhwaWlhT1Y1S1RyOEFzdmtmS0JGMW9jU01r?=
 =?utf-8?B?SDk2MGNIdHg0VG9FeDhVTHNMWEc1K3VSYitVdkhyNXQ4RDRPSVBtOHVvc3c1?=
 =?utf-8?B?V0xSem9JZ2M5d1pBeWRQKzNVZzR1Q0lyWk1BbFZCdlkxT1I0Z3U1TkJ6NThm?=
 =?utf-8?B?TmcrR2pBby9vRHFWNjBHdUdDU3J0MURQTVo1V1pwZys2Zmg5UVh4RkFTTkhF?=
 =?utf-8?B?NG1WUWdpbW5IZ2NqZHMwaWwveU5OVjBQMFd3YXpndiswWEZMR1V6Zk9yMDBh?=
 =?utf-8?B?TllCQ25oNzhnOTlqbTV3ZlQ4cVZxMklPWmpmREppcU9wd2JTNVB3R0pJWTgv?=
 =?utf-8?B?MFcwdjVPR3c2UTF4WnFaOURPbkpDdXl6ak82WXdZMDZMamFTd1dtTTUzVTdH?=
 =?utf-8?B?WnkyVmxpNjE2NWtxNVJPZDRsY0s4UkdMa1N0N1ZWSzduclBvVlFtMGtYckdM?=
 =?utf-8?B?VHZWN3NwZjNybWphdjkxTVhYOXNxdDVuL1NRcW5pdVJLSjNOM0JtaUlNZ1g0?=
 =?utf-8?B?a0ZHcHlxZTlXb1ZDRTd0dDIvbm1kR1NyTHl1MVljUEJDcVB1ek1ubWQvY2Fw?=
 =?utf-8?Q?06DJxKLkZBOMuuuHOIcTIqRokpno4gVS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1ZqUnEweDV6WVRyVEFDY3BXeVpPZDlJUEdMVUY0QmF1aUI1QWE1RW1mU3BB?=
 =?utf-8?B?Q01vZzJrREFIelE5VlM3UXBpQS9wRktxbXM2a1NyaWFQU2hNQk16YkNvVUtZ?=
 =?utf-8?B?dklwbFhDdjJQazJaY2NiNG1aN3NpMFdhRWtqdE15Wk9RdEdNM1MxTCs4b09U?=
 =?utf-8?B?UVNNK3p4Vzl0bDU2REduTzYzVExPVXFwbnZoNFlDbVVkZmV0SzkwSWh4cEdR?=
 =?utf-8?B?K2JyOFF0bStaVS9naFdxZHNlb2NCYURkUG95Vlk4c3FZalFwY3dnVHo2V0xa?=
 =?utf-8?B?elpTdHcyQUpobUhudjFKTUhkcWNhZDB0dWp3WFFOcU1hbkJhWit0SzFYUU45?=
 =?utf-8?B?cjBLY2oxc0RQOVd3L25ON0pvVGRiTTQySnZBU3BDMVg0U2RVRDZxaTQyNzdi?=
 =?utf-8?B?ZTI3alNna0lLQUFCTHlMOHZUNTkySzZqUEdML0tOUm1vUFdaRERZV1A5L3FC?=
 =?utf-8?B?eXF4dENtdS9TcnJDaDNQVE5GcWQzSlBoVU9UR0xhZlVFaWFCMkUrcVhIaUhi?=
 =?utf-8?B?SmluMVN0c05SejRPeWJEbzlNYUp6ZVUzOWVHWDdoQlF1UjNqSUxoZkJDcGtr?=
 =?utf-8?B?akhYUi9lZk1ydXdVZlFmSFVzU3hYa2wwQ29NdTRzcHFUdzdQa3poZy9VRkZB?=
 =?utf-8?B?N2NqYU9RWGJ3cm5ybnBxY09TZFBxY0t4TVFMZ2JFcytWVXRaTWNkTTNteDd5?=
 =?utf-8?B?ZzlkVm1pTXlhbzlTdmhOZlZjaTBtWWFld2tFdUdnUUhQWGlsN01YbjVOTUIx?=
 =?utf-8?B?UVFydWRHY3Y2YWJNYVZCVk5kdHprdGp4NXppRy9uYVZtVmJUUllRcWlTYzlt?=
 =?utf-8?B?LzdVMUE2c1l0SFVrVTJzck1YYTVMQW9VOVNSUTFwQTF2TUh3R2NkNEhNajNi?=
 =?utf-8?B?Ukxod25WVG1EM24xaXJrYzJQNW15VDVMd0JGYW1VRkRoRTMyTGVvcHJSVXJq?=
 =?utf-8?B?WmQ2QXpSZWw0czZQbmVGQ0t2UWRGbXRsM205R3FhVEs0Y2FSU1B2SUlvdkJl?=
 =?utf-8?B?dXFKN1hqUU8rYlpnWnhTdFNsYUZyRU4zOFlndE15Y3ZmR29sdFlWbHRhTUZu?=
 =?utf-8?B?SzhWNnJ1MkdjUm5Uem9HbGRwTWJtdWtPNDFXUW41SWZmMzd6TlBsWkwwcDBx?=
 =?utf-8?B?ZmYvTHE1T0E5dnQ1a2xuUHJyeVpSdnVOMnoyQk9qb3FqcWZXbTVzeTd4OHZX?=
 =?utf-8?B?NGpxYm8zNGdJZzJ6SCtKNFVNMnJhc3dsQ3lodXNTVG9hUGl1d3BXUExtNk9C?=
 =?utf-8?B?anUwV2JTTmRQOTh0V2ZwTUs2cDJkcGRIdVRSTldtUXU5aGUrTy8rU3VkRHpS?=
 =?utf-8?B?T2hLNlNiSWx5UGFLenlUUVNWT3Z3cnpkQ0d3ajNnUmNER2VWdGJsOHFVdi9k?=
 =?utf-8?B?OURWQVZRdnZ2aktjSDgwQ0huRHg0SkJRQ2hnUWxscmJsR0ttbGIzVEJqcUxp?=
 =?utf-8?B?c1VtOWhJYUVOZG1UUXJsakhIWk5mbXB6Y2p2WnNLemljWkFEaTlHenhkMERv?=
 =?utf-8?B?MmtXdlJaMmwyaWFRVndWWkgycjd6UEpqL0tZSU9jZU5RR1YvUFNqcU5qN0dr?=
 =?utf-8?B?ZUs0OTFwQi9TaHM0UDNaOHg1YXRnaHNuM1ZqdU0zeGQ3emVHSGVnWTV4R1VT?=
 =?utf-8?B?TjlKOGt0QzR0KzVoaytEazN0ZldpUDBydWdTbi9hZ01PNDYrZDFSNUc1SlBF?=
 =?utf-8?B?Yk04dWJ2V280KzZ4NjkyWW8wZlNyOXp3M0lQSmpPNy9qQTBKT3dCUk53cmQy?=
 =?utf-8?B?YWVRaWxaSkZqODYzc2pPbk9YVmxkZ0M0Vk45dTBUbjFPWmMyaERpRTltT01m?=
 =?utf-8?B?QlZCM1d1VCtPQWNDTlZtckRaMTI0S3RhUituSFp1Tm41akVmd2NUUnZrZm56?=
 =?utf-8?B?cEhpUUc0bVhlTVB4K1FVRmZzSXAxYlprdE1RMVFXUFIzS3hoVmRSWFpjbXk2?=
 =?utf-8?B?R3RrN2tIV3JSNzhPUFFCMnM0S1JrbFh1QkpmVWRaaG9PRm1jRFRLeHFVOFFL?=
 =?utf-8?B?NmN6TlFSc2VUU0dPTXQzalVReGMwZWdpSnM0SWdvOGF1aUhjZWszSC9mNHli?=
 =?utf-8?B?ajZZbytReDk4WGJKQkZEaTdxRnhLN0VLcGZtQ015NEZGYWlIcDBkeDdTd1V1?=
 =?utf-8?B?eDRLa1U0Q3pQbnRlTWF2TUJKaGpGbGFpc2lJTzJTWFNFVC9rYmdpWXdrNGdB?=
 =?utf-8?B?anc5Mzc2K2xiSis1NG5MNkluVWpXYWZ6bXRSYk4yVkIwa2RaOXdFWUpWZ2tQ?=
 =?utf-8?B?d1V6YVBBWWpVRjR5N2I4Z3hzSHBjYUhwZllFODZ6emdqRklQN2pUUDFGa0Ra?=
 =?utf-8?B?L0RIWXVOZWpqSkF4NktndW1yY2UzUUJVRWZXYkk4K0J2ZThVSTFEdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R4qzVqnVP3amXZymijLTbLz8WvJLpmNkqryZxqKYs5yo2pctJkGwp2fugfU6t2iH2yOQ9/cqBJDxoO1I9VNpXHWpPB22YiVfwR/PHDn/Vgh8TkxPzMxj4/vmGtWo3kDwjM0oEILdJa8TnOw5TjznG91Ztz7+3KfUet372BDhQOHz33k9KJSKeswxU4ViHfxwGu60UqV3aopMd2HL9S4ASxXKn3vC+9wQHzPE6h8rbIEgbynP2DoUqGdPvVyvq6JRpghR+Gh8V1q+UCdcW3Tqt1P3Jxodeggk6hKG4weowEy1lMYd70Y4zaAkjT12aajPSn9ffPlmbVYw2auxNH1r4p6Ue3CP1o3qqKjRyGFiEYGOwyvvhQH//e45aygLZEdldYrVPWTNXTdmcBRllJoDnZkCOQWhAcfhZ6xVT2ZHPALLlL2JXFayDW06spBuXoXyMt/zZBUj9fip+msOXQY25dy+OBqb3Nogn5EedFQcbMqbVj7D43CdkhKnrH/uE3J5wPVA/znlTKMnvepI/n5Mm7Xf1OtfkDxO7Sr6L/r+BMOs72Oq1v6ZtsQ99/BY3eI8eWzLyZZgEPy6DIdifl8mzoB7DERtEAANiekNJBdAJ5M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddcdf9d1-ba23-4663-5a5f-08de4e928952
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 08:47:21.1214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z79FvesN5hrC3u7Scxips5BVkQp+2Rbc6xtQJClo54Prp5UK9pryrHZQ3D5161mOAD6I+AgSpy/w75/0JXlISQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_01,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080058
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDA1OSBTYWx0ZWRfX569irPCfV/4M
 69c+Ttsyt9KHH1+xttuRwIZg+RQRHDHIM/5WSj9lQRNX+uaF6m0o79LuyEnd21S7GS8Y5WzxecY
 xOJ8rgw5PATMPzoud8sBQpD1niRSht2MLnAMDYx4GeV+30jJhd1hSn74VfqjmFlcLKsDB2s+1G9
 s2kSuYxnuLpHH9AnI3SBRb+iMpYSY4+OkrBy5h4GXRBBltJtzxzcv+1/UgraTJiAKmqE+8eOIJJ
 lYSV9d2fJup9DXGwUIH8oKWZa0p57HnUpv34NXx5X0bgkyJppKAJPT4sRy/eb3obRurTAbGBw04
 /x2Hg4FGfj7sQ4JhS8RgHyvg9MoIVj3aHSfJK4EhXL5iXGS+rX82U2ogVZ3XmEk1vVq6drmXStT
 1gF5JpUzthDXvdD/sX5ehKgeI/KlrQOIFiT+xrDRCEDHazs+j/5XSIoH4LETo6AuZoenjTNYJ/t
 UljCqCXWORE641SJfTA==
X-Proofpoint-GUID: onFV8mg6b2e9O2NuYOJZ1qW04_iNf8_c
X-Proofpoint-ORIG-GUID: onFV8mg6b2e9O2NuYOJZ1qW04_iNf8_c
X-Authority-Analysis: v=2.4 cv=dOerWeZb c=1 sm=1 tr=0 ts=695f6f1d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6HU25xUHHiC4soiKiXUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10

On 07/01/2026 18:38, Bart Van Assche wrote:
>>>
>>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>>> index 196479cbfe6e..f1dd71a2d89d 100644
>>> --- a/drivers/scsi/hosts.c
>>> +++ b/drivers/scsi/hosts.c
>>> @@ -626,9 +626,9 @@ int scsi_host_busy(struct Scsi_Host *shost)
>>>   {
>>>       int cnt = 0;
>>> -    if (shost->tag_set.ops)
>>> -        blk_mq_tagset_busy_iter(&shost->tag_set,
>>> -                    scsi_host_check_in_flight, &cnt);
>>> +    WARN_ON_ONCE(!shost->tag_set.ops);
>>
>> If shost->tag_set.ops == NULL, then we will detect it like before, 
>> right? If so, I don't think that it is required.
> 
> There may be drivers left that I overlooked and that call
> scsi_host_busy() before the SCSI host has been added. Emitting a
> kernel warning is more user-friendly than letting users figure out
> why blk_mq_tagset_busy_iter() crashes.

I bodged the code to create the crash, and got this stackframe:

[    0.471149] scsi_debug:sdebug_driver_probe: scsi_debug: trim
poll_queues to 0. poll_q/nr_hw = (0/1)
[    0.471965] BUG: unable to handle page fault for address: 
ffff8c36386ca000
[    0.472120] #PF: supervisor write access in kernel mode
...
[    0.472120] PKRU: 55555554
[    0.472120] Call Trace:
[    0.472120]  <TASK>
[    0.472120]  blk_mq_tagset_busy_iter+0x31/0xb0
[    0.472120]  scsi_host_busy+0x37/0x60
[    0.472120]  sdebug_driver_probe+0x3db/0x420


So not too difficult to know where the problem is being triggered. 
Furthermore, just checking !shost->tag_set.ops does not help so much in 
debugging. Better would be to add a message in the WARN, like "shost not 
added yet ...". Finally, having the WARN does not stop the crash, and 
just swamps the console.

Anyway, I would not bother with the WARN at all. I would just add a 
comment for scsi_host_busy() saying that the shost must be added before 
being called.

Thanks,
John
