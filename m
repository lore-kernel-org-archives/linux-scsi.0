Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6709F35A3A4
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 13:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785762120; cv=fail; b=KyuG9+fpFAXcfcFAIIEIwnidxDhhO/cjFKStWs6fE/ixLg1WnmUzjs4YUPGeN/eVaz9dq8p1+YKm6M5X+r/QOnaFZ219TaNphI43lP/AmsY4jSW7TM/Oe4FFDZTWD5pfn/jmGgH1jF3xeVSHbDFLEBtUpFwmq6MP2PZSTvAhu5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785762120; c=relaxed/simple;
	bh=CBkATTAWLofDnGh5GFx9qG1Q1MiX05SPIvbj85SDBKA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LHbvIv0gVKkvah5+56YhOeLabkgRGpjEaJ1zKmKj9FYRWuLQdZYyaH8QOagign5GleSnyaMvZdL0J7mlAMNnlPkb2kA/MqLnqA9ih4ur7SzHUGr1H19RMWsjdD9OByszI2nOnegEs2PxPRuYjx6KxMUQiRyU9BKjm4Q6DwkdhlE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qyiX3GxG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZcyVclrr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qyiX3GxG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZcyVclrr"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673C4ZmM2725589;
	Mon, 3 Aug 2026 13:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4/iSTOhfdSwUms6J1bx9ExigwIyqXBeHyZyZn+mIcVY=; b=
	qyiX3GxGzKOBb8JSQqlkv0uxVYvKXKu6C6oYrlsgqzCq8jG0ssInBWpMOtKXhK5p
	0QtFTre9jr88OA/DavwmzCTjnLM61D5tuG1YuDdqUw/GbdcW6MGFf1MlPAeywe6W
	pt1d+KJlv/nm/pWv4LMexZR/LsIZ60oe2TbtPZLZWy+mvrF1LqyudRD4rhiDQlvP
	59aUDOvKhFkEmVSY5i7gcGfYCcTeacvDL+exElhJRl4aDZgzT8rw+jKRY5DOZj4D
	a6zxkKMET1X3MUNZn3n3Xci1K32iyaZNDElwG2xUfuS/7ptm/NHAu2XJKfZratoI
	Kv7NfYZhZaAwQiGha2j2Og==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8e4uq9j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Aug 2026 13:01:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 673CtTD5029983;
	Mon, 3 Aug 2026 13:01:48 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010021.outbound.protection.outlook.com [52.101.61.21])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78rr2bw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 03 Aug 2026 13:01:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DbtCPgW1Zonk8ozJrDn6DIG0Pl3krXfQ749HO1qZQGbVwLqbobUEcnPztv1kQLXqUtdPpa0mYQeiHmvUGJJHiWM62hab4gj9A3fFUOrZbHcha/PQHhbyFZon2brxn5zgXL2F8/QkogQrubxhy72BmW/bI/3TCDzDB07o/jboVAF6/bSlWxMRNRJMTr3TC/CLlBP6cgQJUMEi7dVhrkYXHqGs8pbWgJbFzM8odY2LfDJbBIEX5/WgHwaEP4kQixFs6/Y6XPstii4h3sMCHV95v3kUXURcG33YD4tu6uVfXLRhR7i6ebuKLuiMLq8SHilJSdHniwmKJKatMVFdy7ulBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/iSTOhfdSwUms6J1bx9ExigwIyqXBeHyZyZn+mIcVY=;
 b=vngvPo8L1BXuX+y+ORP2fcrl0X+yDxMJ4Z/KRC+OqM+owOdYnK+I9z0R+pxnrZCQcFqckYHjKELcYA1NRwSmXDnBKaHhGuzazeG1kxAePJasMsjHVCSB+IOIFMrmkAJS0rhM31Obiei8EPNEyPRURHw+srUlzM+muwe+EEjWTMfrOwMdfbEPytEAVqUKP6JswNiMf0FH7leHzp/V438bZF36hszp5+equW3M0UyQETuNoE+jM+QhvFZmkEkmwcEqyTiHRAQzcGaJO5FotWcyIe/Cdf+Awt4EMFji2+K3i248uxjdEGollqEmk6zma8d7HhON2AfVe+twFL+wD2310g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/iSTOhfdSwUms6J1bx9ExigwIyqXBeHyZyZn+mIcVY=;
 b=ZcyVclrrBnDoezItOdlg1ziiH0iOxEQ77P2lxY5dy4GgRdcvacl/2xkj6mSBh49bjOVslDdG7jhHuiEn660XdkqItwLZ/AOSfeCp3Hy/boIG4VIq+nj4LH1Jwduj3Gk+M9sTu7lFGWLpxNY+CUCCqKdO/v3p/JnnidgGlhxi+IA=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ0PR10MB5631.namprd10.prod.outlook.com (2603:10b6:a03:3e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 13:01:45 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 13:01:43 +0000
Message-ID: <98049e01-09ac-43cb-aa5e-593bd5fb25c0@oracle.com>
Date: Mon, 3 Aug 2026 14:01:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] scsi: core: Pass the SCSI host pointer directly
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
 <0f417deef926f1574c555ec44fb2036e997a727c.1785534721.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <0f417deef926f1574c555ec44fb2036e997a727c.1785534721.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0172.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ0PR10MB5631:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ecc8132-79be-4303-7aa0-08def15f5dae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|18002099003|22082099003|4143699003|56012099006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	lx+KFae/5CY8izFubTGf0gpdXoQ/Rck9+4ddvt4eIHoUqNQAqSPfUHv/O0Kavu/xQPxluVo/9XOAhrYSJVzoIymVUFow51tnnUwWN6A1ORbggNuDH1lYykh351/lZaLYFsyXY3vyFs1NALihMMihbCl9yCOPvaCr/+zdsmaeQmTvNNnYBfMB5TV9JMTcBfqrY+ogYbgiNgx5wAqjp/MC/T8HtD5nzqEmGM9kCDfxqtxd9mCWxgvlTvxxyIloCQ3vxIpe1dQO3yKmP8FjaShcgByaJyHNbNqewzy75ZOiNhLk+hN4tNED0ZbdjSW0V5W/KgR+8jFCX2XcN5mF504HT3+c9FB4TnFAvIse2x6t7lMiVjC6J/1qRXVw6qmHdvPL2egWQTFX/xxCPlLqE90hA7+ACC8c1q9Ensmo2U3Rk5RoF3gddNZLLUenbWVx9mYKlqJP6jDE0FXwGf/yFW06gExr0mwJI/sxwiGLbp/E7bCra4xJ2G5Yod44iQqgb5vkxxudslLp03zHAWn9LWB1yyv+JR8Of3VB9JHE6JPbUVr6a3ADkaiqTMtbOgdNZQ67XYoFEM56BXg0aWhP6ihaDN44CTqPx3YAlzq+lrFwMQLLcw240TV/+zhWfyjKPopE1W/99DriF66LXoKZXNa1+l6EOjcEgsuYJGje9YtRDR8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(18002099003)(22082099003)(4143699003)(56012099006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekVIZmdVYXMxQ1JQalBoeWFUR09PY2xKVzNlTWw3YXl0NkZuSm9xR2pOOSts?=
 =?utf-8?B?QlF3REowNTZ3YlQyL0JRb1RKR0NFSTJaUjRyWkRsSHZhTmUrSExyVjI2WXpF?=
 =?utf-8?B?UVFxc215T0l6YzljMEZGQ09GTzVidlNleEh6ZklwbkdLb3pkTGJzSnRoUnR4?=
 =?utf-8?B?SkJZYnJKQno3aG5CMTNhU0VEQzQ4b1BoTTRxc0tWaCtCY0ZPdUZGWXdNOUtq?=
 =?utf-8?B?akNZS3ErQ2hWbWZ3RFZzR20rL1kvQnJ3N0xaTUtydDUxdHluRnVwYW5vVHhw?=
 =?utf-8?B?T1AvUGNtN1ppcnFFMzNRZTRSTENYbmxSU2dpSUJFaXRQRmdOUE16ci9mL2RW?=
 =?utf-8?B?ZW1RY0lsUUx2MDFTQTh3NW0wRzBaMjgwR1lRRFQ4UkFodC80bC8zdFdHbWNL?=
 =?utf-8?B?WVZTcmZJMHlZc0xsWXJERDcxbmtGWWdWOG9ST3djcmpqdnNTcHpFblNqZTBu?=
 =?utf-8?B?czJlZTljc09hYWNodk5SSXh2RzIwdTFHTFd2dlpaZHZXakw0ZjAvVGxub1p6?=
 =?utf-8?B?Zml5cjVoanFNU050T3E1TWpnMGVDdWtrK00rc1ZBSThoK2ZGMWpCVDFZZmoz?=
 =?utf-8?B?YU03d1BuZU82M2Y3TGVjUHkxQ20vMWJVNElTVnhUdHpWWURORC84UFREWFpk?=
 =?utf-8?B?OXZJS29GMm5YSmhDZTdlS0R3b0wrZUpYbDB1UDRmdmxZNWZSUHVmVzhmdEdQ?=
 =?utf-8?B?LzUyVVNGN3l4UlNXQlF3MDluMkVmOTNnNXZ1OEVOaW9mWkRDWitPNVhTd0xm?=
 =?utf-8?B?MHNPSCtydFJ0SnZuWm45Y0tHM001UDFPT3Q3TzFvSVRSSWRJQkZWR2hkUy9M?=
 =?utf-8?B?N1llRG0yOExBWWkxbVF0ZDcwY0s4cGZZMWxDMmRCU0lwcDg5bHorTUNPbXV1?=
 =?utf-8?B?UEFhTjNOUFlzb2JuOVNwU3dOOUVBeGlwNmtiZDlZRDFDQmRRNHhRSEwyWVNE?=
 =?utf-8?B?YWNreW1yKzhTeFVzUDQvMmRDankrZ1pkMjhNOFcyamF6UWdVaHRWNDBTbDVK?=
 =?utf-8?B?OU5ZZ0drRk5hZDd6QzZ6Q2twclJKUExiVm9nUUNyOUMvR285bUwwNG9XVUF3?=
 =?utf-8?B?ak1pM1B1QkZxNkhQeThtaHFodm9mWTlvaGEvUWdtanRsTmxlY3JiU0Vjbk1B?=
 =?utf-8?B?V2JScDdoMGpyUGFXM2Y2Zk5SemZuT3l4ZnhpV1FMSWs0dVdVNlg5dXlFNGZ5?=
 =?utf-8?B?ckloajVMOUxJVjl5bzFXNkNtSUxFTmFnQ0pxeDVNaE5GWDljZ2JJZVhXdmNn?=
 =?utf-8?B?bzNlVWNvdk9hMlhTTmhFeUkyU3AyUUNWbE5pWkdmSUtkR1JpODl3ZEQvUVRP?=
 =?utf-8?B?L3pJZnVBSHowY2ZGSm82a2E5UGtMQ0lzeU10T29YY1JwVno4RHVxQXpKMGpG?=
 =?utf-8?B?WlBxQ0RMMmE5bjB1U21BSzhGNDVyVitVcTNaY1FSQmpJdHhCWTJvSnAvdS92?=
 =?utf-8?B?MDdTSlk1RXQ1R0hDZEpLUG5ia1dFMU9JbEF6ZDB5b1g4OFNDcnFsS3ovdnlX?=
 =?utf-8?B?emRPN2JvY1Zlc2wzWTZNTS9YNTR3d2hoVEVJaG1ON0dkdEhlQ2VUcGJPd3hv?=
 =?utf-8?B?V2gveWhMTk1CZnQ1TkY4blgyRnNtMmFYODdRL20vVUdKc0Rsano1WHJiWmsy?=
 =?utf-8?B?M3JFeENBOXFiM1REallwdmErbzJzTVlGZUNjZThldHhLbzRjVFlhOVVFc0Vo?=
 =?utf-8?B?Y242RklFK2ZZT1N3bFgvc2pGRTR0LzNWbU90WG1Ec2haUUdsVkZRZ0ZvRTFW?=
 =?utf-8?B?UzMremx5YVgzSGFnSStpQjJxMGtqRlZiS01STStjQ3ZPeVhMOXI4ZmVSZWEz?=
 =?utf-8?B?OHpxTmJzNmpScmpPU1B0ck1zbEtNVlB1Y01iVVBjVlJ1S0d0VDFnR1lMM1dK?=
 =?utf-8?B?SVNURWFTd0t0bnczQTdHV2Y5WG1yMzc5T25ybXlzQloxZ0h6WnNjNUdLTDkx?=
 =?utf-8?B?bXZMNFc3cWlvbEJZdVhrMHlodXA1T3YydUg3a2VCbkhZemZZakF3NFBJR29v?=
 =?utf-8?B?dzhtNy94OXZ1UmEzb1FyTUtRSk12WTk1ekFiWnd6NmpEbGhmZXlYWkl1UW5O?=
 =?utf-8?B?TForWDBzOGpzdDQzMHQ0eTRMRE5HVTU2RnB0K0RkOGhxeG9yTHVxaTFuK3Ri?=
 =?utf-8?B?ZUFVZGsxOEtlbGUxRE15bm1OWFpSRzNFZklVbVVyUTBuTzA2ZlFBWFg2ZzlS?=
 =?utf-8?B?Z1pDTTBWTHVBZzdXNHd4VEtGVGZ3RHgvSzVST2djYnVwSjY1NHFUT09CeUsx?=
 =?utf-8?B?NVVsNlVXSkRrSjBla1E3Q053a0dDTWl0QXA1dWc0SW8xK3FscUh2cGNDYlk1?=
 =?utf-8?B?ckxBeTRLNHhIS3lVMXdrUnpmZXMyTEdkYjdVZ3BXU3V6TkVsTHRpUT09?=
X-Exchange-RoutingPolicyChecked:
	V94bkbijGLFNq9inAvhgs0sLQwo4g+054pxIyiT7RX6h6AhvPCcm4nOgb8+cRzHKlatFlQ2dFmWEx3D8h/3wVhraViZy44iwMh73SXzHI0BSgys4U0SLNx8FMzJC1XyZnDXiAEBY5rUbnZGyN1nlSMMBAzKKKS2uUkbm6XKu51ZBl3WI3hlcoPB9Mf4PmC0LdJHOn+z3aQHOZwO08i9Mmoug3ia+/CB5qfPuew0Vg6rQaA2bw2P67mRl1v8nFEX+8VdI7QMBlBagB6UZvZDGRqonUKKvARNgrzJ+8c6ru8BCLGI6VfbFBWEEw51M514GfNEhI0LRNZ1/xgYK0MM6Kw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zk6IkR0BtskQPMWUqZpwDgwhnWtpbhczxzdECYxpqxub3tXmqUKDQPxPTJCP6gvBf+KYgaIpzuF/EnrKL9L+1RyhK/Lm3Crpja5iiyeFIql4t1a2swaP5Emx5GacXspT4edwgY0GJocrdEQYLHL/vhF5js/ynY/yHTQ9Wr7PcxZwTahye1zB8lSMZTxGuDG2SaTT4ZzmnJQXPDly5/6ket6H8gTC9NbWyzqUw3A5IN/y7ON7LSNN9KJPtw0JjUbTVQBrrzExJcqeoNvllOue1SDmAYtySQFUYMql90RETMcKZ/c1iCZUC//eVYsjPbtj197gQc9nKYs5AYx8/ldVE2+1Lrjxvz/gzz93kMq9jTmr3dqj+yPb8pc2TKcirGBKC4z0BJqQCE5IoVcJq+Vl95Cylemipf+zRI74HXwdPEYVZev9MjU2ZwOT6k28M6oPRXsqkU8kOdo0fPtH+V3qQhfVYKxlIdjYxFajOyCWg3qOejZNHOkeCk47LaSNCUzp0bIAgVqNbrPVlmVGtAJyEKPN7wx2Hj9go1HkBM121X/5B9GICfcGdhE2dxvjpjdLjmmMEzqgaa/qNlW/YnTRqtn76y8nFr4yl2pStHpHKjc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ecc8132-79be-4303-7aa0-08def15f5dae
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 13:01:43.2125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SWUW30GDSGVEVD4eNoWf4KIRnbfYAI/Ll8gybXAh5JIu9o+Gh9XEQyJAL6cwPXHkSYMHwE5vEZD+j9n5lqIuOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608030116
X-Proofpoint-ORIG-GUID: fxpddrzuELfFZATIMe0jWxtFeuVEA1Ay
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDExNyBTYWx0ZWRfX/G5LGTIIzz+x
 LyQBhY+eXHQNjbSZPq/7DgL+hRf+4UdCW7qkdWueyhsqttaGKESV4M1UxFQC3FQX2VTbTwOpLT0
 jLWq4kVvi2EEC9K5DuJztvjK3nfScXqQyH4vhu3WzQvqCdWytzZI
X-Proofpoint-GUID: fxpddrzuELfFZATIMe0jWxtFeuVEA1Ay
X-Authority-Analysis: v=2.4 cv=M/t97Sws c=1 sm=1 tr=0 ts=6a70913d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=N54-gffFAAAA:8
 a=b8ImYamQUx-A8hjVkO4A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDExNyBTYWx0ZWRfX4qEp9JYQoRZv
 XrEOvMraU7Jo+Brk/sSpfdhbwwpCdYq8oyxWSYMNMaCzXMLl3wmX5KVFAPaKT8TzdAATVu5h/Dx
 +IuiYF4rR/zA3sIE2swTq/q3FiV0tZp0VIB4xmKx7BzmUPY2jmRx06RoS8GG2BjK6fzPm3TCT6u
 mSZCzGelR5UgBCSd2ml65qHP94yi3T4gHjdFhG72241jiMz+2TQjh4CiPY6aS/B4Ewcf1ZbNTxO
 eBolv9nLImWEhU3aV2O9EtIWDv2DcrzkRahJMn8rpsxZaPBU1xjxyXR+NiXdDk9jlPBi6gQ7ALU
 lmahF9GIhqHuWHWCdxftIIWPmNU8f+fbH6OMc5Pyi11E71DnPyGGtwjKTgP5XLZrEmBAqlkFQl+
 YFWzH9+d9xdkXcktpLHoAao1cWeWz2QwvmRT0bT+7v6e/0cr2jLKC2dM3e6vTXdnF1K2Xr14wBE
 Z7lqjfl6ZCfix43YHMVk20ZmevfEfNzQZC8L4eqw=

On 31/07/2026 22:52, Bart Van Assche wrote:

"Pass the SCSI host pointer directly" - that's too vague a title.

> In the functions scsi_probe_and_add_lun(), scsi_sequential_lun_scan(),
> scsi_report_lun_scan() and __scsi_scan_target() the SCSI host pointer is
> derived from the SCSI target pointer. Pass the SCSI host pointer
> directly. This patch prepares for enabling lock context analysis.

How?

> No
> functionality has been changed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
