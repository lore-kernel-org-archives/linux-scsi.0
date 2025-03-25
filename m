Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ACC2E338E
	for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2025 01:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742867700; cv=fail; b=YP4L24PapuHb+727Z78YNxJ7NRw/r/wzUY9+7390cKB/Qp9d9OoGig+FOenSNHDkYmu71ahkE8zscP2X829FPAQxFxlISBDIhcT8p9Czn6iiZCFICc0mVULC6jhuMy271gu77bu6LmEezEbFMdBsMU5AjKncdXv2Qn+K7p4mdaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742867700; c=relaxed/simple;
	bh=tD1FmNQZs33KweNGqpuOVTETwulR3RsNPeglRxx4zoY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D0XbxSjapVhOMddIlmZJX39t4BmUx+6CDHWIHGcSUxo1nq+nThjbTAyyr97BPfcpGSfzRAUqACkXW2nvjM1CGQ5Eid6JDB0AB270xiAaITgdikgAyf5Zc7p49gBtnKUhSRcaZDohYoJ8zTK48S9Tq7WmYlxPnYx5Xc2SdBhdaoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=luQEAPiQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xYAphFhb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="luQEAPiQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xYAphFhb"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52P1Bu0l020721;
	Tue, 25 Mar 2025 01:54:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=yBCmigqTLWCriTX9I6G1ochBJVsfIacy3SCs3Gti1T8=; b=
	luQEAPiQS8FZHjqGiGUhFmpzCfHv37DC1zDWJla+sXAy4/Z41HJ6/45U80BYgR1l
	I2Rn+Ig588J81rN5bo/0wVq551qBeOZ0jbfPjCDFRFqFCYAFu4pR4/+mPrGvRkg/
	ioMMbyTCC6+s7eyvUy/4+NTgePFm6hWyznl27Kq/wye/pEL/H8EeIfOXwO89NMb9
	VR1ofAiLrwaaKpPcQ772xyaGQQJGnZ3NRwqsNsQj8REKv13WU+ryOKyydJxuzPKE
	nH7yniX3Cnd1E9ys572HmHFI7VflcGxynle5eGBqL0pQH6YZhgBtYQt7lBP0DDZi
	ox3gd4VekoGCN5FtsS+pDw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hn8b5wjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Mar 2025 01:54:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52P0S8Cq015177;
	Tue, 25 Mar 2025 01:54:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45jj915ft0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Mar 2025 01:54:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dEnCPED6lLnNeaBt+WhBqhgUbw6hPUSZQDKgKq/UoMDwJbaR8RtYtApvyJjqekKY+ym50DPSPQ2w6iNKU0nUcBj4XCwbL/AQpBXucOALDgMHm6x++Qp/t5fAt8bausRLD5OqeViPSMpW7XG+GAVWsEu8KQH6imcHF7Q0HHpqBmIpEgpiF86sx0bxdTOhuzTM80SVSnHSfZHFRuQhGH5QmfnR2m4ftH42FZclSDRwrWZsQkRn7KVq8Dri+k6D6oW2G5aQ3CmlU9h/vMacgUnKxiu/v1n2m9mu5olEcSXsd3XGJcRfCZAw7Gj7pm0XElTXPXEsPmJ7VznN6Or7rlGpDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yBCmigqTLWCriTX9I6G1ochBJVsfIacy3SCs3Gti1T8=;
 b=vftqaF1AzHjFW1Tx2u4TQdcGF7UKoW95JofKRxyhElWp+yUYOdDINcAnsT7gCuOJzOsr366nAtAlQm3KktT7Zk9X2IwbiXLpVs75jj1p6QMoc7KSn7M135REdG7YRVjRWsSBWHV+nAA65bU0S57KJrHcTujRkiOBvOpecT1bljSjaMr1WMdPjoSm/5Ldzf4N51VQWvGtK1w0hrMccQL87W4PXs0bIAhnkEoqTKvD8J6Yx+ubiLd3VbFXh7i8XabJ67fGU4DGdLlIdgCfVrVp8WDr0x0f0V59RVeZLGA9E9d7NEe7OjCe6dm/MpdmaaIGaFH0uyH2RTAVmlIfU+c0xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yBCmigqTLWCriTX9I6G1ochBJVsfIacy3SCs3Gti1T8=;
 b=xYAphFhbiDCeV96khoBWYGHAaXgqBrGKwIFMs5USCX1SgtStZ0ksVJfIRCqNuLeu/pkLDlRlWPA7lP/RWPhguxUJDVseVE5TznYRbrjYW3QN+NsqStPoKaJedDL8oM91Vm730n8CCQNKaYSeisDTZ4l39zU1IOIDjRVJ2WSIl7A=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB4954.namprd10.prod.outlook.com (2603:10b6:610:ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Tue, 25 Mar
 2025 01:54:43 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8534.040; Tue, 25 Mar 2025
 01:54:43 +0000
Message-ID: <01aaa273-f068-4013-b4ce-25cab5ad7d4f@oracle.com>
Date: Tue, 25 Mar 2025 01:54:42 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [v2]aacraid: Reply queue mapping to CPUs based on IRQ
 affinity
To: Sagar.Biradar@microchip.com, jmeneghi@redhat.com, hare@suse.de,
        martin.petersen@oracle.com, pheidologeton@protonmail.com,
        kernel@roadkil.net, maokaman@gmail.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        thenzl@redhat.com, mpatalan@redhat.com, Scott.Benesh@microchip.com,
        Don.Brace@microchip.com, Tom.White@microchip.com,
        Abhinav.Kuchibhotla@microchip.com
References: <20250130173314.608836-1-sagar.biradar@microchip.com>
 <yq1mseqwoaa.fsf@ca-mkp.ca.oracle.com>
 <PH7PR11MB757026166DDB8068830AE420FAFF2@PH7PR11MB7570.namprd11.prod.outlook.com>
 <8433b8b8-bb9a-43e0-a760-d8745d28d0d9@redhat.com>
 <yq1eczsjaaz.fsf@ca-mkp.ca.oracle.com>
 <2eca14e0-3978-440f-a4a4-32c9c61baad4@redhat.com>
 <84a87c16-0738-460d-b83f-55f8181d536e@suse.de>
 <c3f77605-3061-461f-8406-8eb0493c71cd@redhat.com>
 <PH7PR11MB7570A7E66942E50167648A56FAA72@PH7PR11MB7570.namprd11.prod.outlook.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <PH7PR11MB7570A7E66942E50167648A56FAA72@PH7PR11MB7570.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR06CA0001.namprd06.prod.outlook.com
 (2603:10b6:208:23d::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB4954:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c0ff1f2-d82d-4fcf-7575-08dd6b400329
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b1ozV3Irc2JQci9RbERhN0tTZ05ST3ZVcTF6S2E1RnhCblUwK3Q0RWNhdUp0?=
 =?utf-8?B?K1hlOW5pR1FRQkxZVmtsSE1KOHdkb1V5MlZMR3grRjUzd29KT01aYlR6QmVh?=
 =?utf-8?B?dUErbTBmWXlaRktucHJmMWQzRFhpS1RaZ1JVdUczUGo2RUREUGtJZmpiTzJt?=
 =?utf-8?B?bk5xb3l6K0ZQRWlRSDlyNlVXc1I5K3c2Rnpja0phQThhSWhHOXR6SGtjNTRR?=
 =?utf-8?B?MEpadmo0QXg0Vlp4bklzUFZRTUNBZnNCNnNaWkFnZ21VUVRDSmZpWm4raWd1?=
 =?utf-8?B?QkFRSTI3RU0yTEpEdTNtQ1EzOEpyejdBbWVzT1FCVkZDMzFBcFRVN1hSZGVL?=
 =?utf-8?B?V0JwYVI1WU0zSWhyU3NaZjdCbm9uODRYL1pPQWFBNU1WSmtiUkF1UXdVOGFj?=
 =?utf-8?B?NktqOUR5NnhOT0F1RW05eCtqSlRUTm5zRy9kV2s2SkN4UHZ3d2tYbGFZS1ND?=
 =?utf-8?B?djBYTi9aWVhoY1JIeEM5TzZWUTlCaTl6c2ZIT0pFdVdZUmM4SkNFVjlyMnY3?=
 =?utf-8?B?T0JFUHFiVm1ORjhRUzFyYzhDeDBLOFpSNlc2ME51cEtVT2RhZ0dnUW5FYmlR?=
 =?utf-8?B?Q3RTd25PRlFUYXFKQzl6NXJWeGRodHZZQ1VhTG4zaE00U3pUZkxKS1o2MGFB?=
 =?utf-8?B?bDAybytlbHFkakZobG0xQ0RoSWgvVEFrSjByQUxWMVBFWUJHazlDQ2NyRWhO?=
 =?utf-8?B?NVIvUEllcjlsaTEyTEVxZzRHM1laZXRuRjFEc2F6d0VEUDlkcm1TZGtQRnpY?=
 =?utf-8?B?RHJlbHR3SWxyNWVPUUh5MkNpSUFhSjZVVjRnRXNTTmkwUFRuZVVMRUFTWmJT?=
 =?utf-8?B?TVdBR3hVbCswQlN0bkRLekpqb2pmYVFGaHBTWkQvS21tUGFOU1pXV2kraFdY?=
 =?utf-8?B?eXdPV2pXU2JaUm8rOTdKWm9xYzQ0WVJvaW9NMngvbjZqUUJxM3piaGdwSm9k?=
 =?utf-8?B?aFFqRWVlUDh6Z0dpZmRsdEFzVkI2TW9BQWorMi8zWTJ4SUQxbVV1WnM1aEUx?=
 =?utf-8?B?dHpSSFlpVFNtTDIwUjV2Y0E4cTN2dUlRUncxV3JpcVJNcnFMQTNzNEN3S0hj?=
 =?utf-8?B?SlB0ZHpDS01QL2dwQmdpcFRzM0g5UVhIZEdScDlNWkp1WmxKYVljZ2xtc3dH?=
 =?utf-8?B?TzF2ckY2b0tjWDN4dW9BMWNWNHFpbWE1Q3ZQWHA4R0VDR1ZEOWluYnFRYnZr?=
 =?utf-8?B?Y2xKTjNPWTBGSGZlalR3SEd6NjJhdU41NU5lNUw1SnluZThrNmREQWtFaDFj?=
 =?utf-8?B?cjhiZHVUUnk3TnJSa0pXaWEyU0REQ3hqMHNlWndlWU5RSHNvV2VGd1E1cUFP?=
 =?utf-8?B?WEwzL1Vka2lwVGUrVitDRW9EeDhHNWt2eEJJRGxXbWk4UGFhbUhxNHFrUCtj?=
 =?utf-8?B?NXg1eVVicnhVemoyNTdUQXFsa3N6cGZSMC81aFlFMzRMbEY4ZlhJWmFiVFpq?=
 =?utf-8?B?OTBsWWJCRXpZdTJhR1E0dDNiZDgvR2toVHRPTXFOYUkrcHVNenBkUlBvcExG?=
 =?utf-8?B?anJmOEVESmYycnBqSUhzNzlQeDlvdk9tcnhHRzJObkVJS2hwd1VYNmZtd2VZ?=
 =?utf-8?B?NG8vWEJsN0lCd2U2Z2w3aGlqallVMjlFOERadVcwZEFxaFpDWXpMdVM4bDF3?=
 =?utf-8?B?N25wS3hmTTlneVRNYkxuS1FOTzZhTDZCeVZHZnlVbXJKUElUOE5zYlhuWmgw?=
 =?utf-8?B?bHdZUG9mM2NZOEVURG11OGpXQnJ6bi90T25FMUJ5WUtTUmZQOG4rWHRYeTYx?=
 =?utf-8?B?MXdqL0RrN0lSczBkM0lxdjZCaERkbklmNXk5LzdqT0U5SG16Zldtbm9Wc3Yw?=
 =?utf-8?B?SGVJOVpER1VMd1Jya1l0dnZRdjU0MW9hQmpjOXd0bEhMOFZJdkFScmRtanB2?=
 =?utf-8?Q?EJ4h5lOlr1Sbv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2R6UkhaSjhyWmJHZVZzd0hyOWNOTTdGL2pYTUNXL0lqSEk0RGRjR04rS0FH?=
 =?utf-8?B?ZWQvYkZ0TmtEQmQ0ZFc3YnBUTXVtVHp6TnlmN1Q2N0FiVEhzVm5pYWIwc2tD?=
 =?utf-8?B?UGJuM29rSXowaktlVVRzVE9jNjZHb0RWQ1ByYzIrUGd1TmNnc2c0R3B2VjIz?=
 =?utf-8?B?T2NubGUwbkw0Z0RCTHl0czRmWk5mRExPTHBIM0RoNzRnN2x4OVZHanZTdHlR?=
 =?utf-8?B?UU1JWnBJeVR2U2J6c1JYejAwYXJqTTBnYWJLNVl4SGd6Z3N4TnR6K3R2a0px?=
 =?utf-8?B?QzU1bjZmTWRSN3hwbE5NSHJiS0dTSUdiSEp4U1dFR3lPUDlTNUR5dTcwdU5Z?=
 =?utf-8?B?bGRnZlRIVU9FMzZtS3l6TE9NN1JSNzhHVU9lbUhzbzkvenI3TWFBaU9Mb0tS?=
 =?utf-8?B?cW5BSjdNQkI5bCsrejdBMmVBSDJxZ1dEYTJObDNrNDg2alA3NFlGUHpMSjd4?=
 =?utf-8?B?S2pobjFqTWRwLzliQ2lvaS9KdmJjYk1scUxKV1NYWng3NTdYR05sTVgwS3Mw?=
 =?utf-8?B?djdOS0swM2JVeHhyN2pHK0JiM0ZTbHJOcC9CMUdJdWJyWHdXZUE2ZVFOSldy?=
 =?utf-8?B?Q1R6dmQyYi9iaGZZdWlWc3pGV1VMRldxalo4VzB4QXoxMVpqR2dwbnZKQkRX?=
 =?utf-8?B?bHo0c3lKbWV2bnBaS0hjZlB5ZkwrL0lYQlpNQ0FXbmpPY3QzeUQ3bHlmNG1I?=
 =?utf-8?B?aW1BZk1pSzMyQ1pkNkRlZWJscGJmLzNGeTQveFp3Q1VlMlM3c3R0MWxoKzJX?=
 =?utf-8?B?TE1BU2dEZ1BXNytkRERZZkNzL0c5V2RpMUtSay95OVdhVkQzOTJHcTNMTXpv?=
 =?utf-8?B?SXRhQlZ0NVQrU1Q5ZTNRSGtFb3VTUHJHTWVpeVRnQ2VmSDNOOXJQYkNmMmM5?=
 =?utf-8?B?QXM3dXNQYmt1UytLdUVWZDJmRmgyUXNUZjVCYmZ4a21Lc2NuNjVRK0NyNEJS?=
 =?utf-8?B?WjMvalZzK0ppL2JqQ09SdFE2M1hGejBPQjJBblR3OHFoakFmVXVtblUzQTFW?=
 =?utf-8?B?WTVNNWFUTnFuaTRiTDJkdGNYTDdFeVBZMXkxUHZGdmFYK2Y4ZWRqdEdVY0Rr?=
 =?utf-8?B?R2JXazd2bUttRmx6WFNKaXVBT3FxREdlWUdLbjVzWHVwaXB0TFd2M09EZnlF?=
 =?utf-8?B?OHZ6N0ZBVnU2c2t2cy85dGQ1QUNyRjNBdkxLdUJvUkpyYnloRVN3S0JwK1Iw?=
 =?utf-8?B?OEZ2VkFTM0dibHkrdU5RS2YxTVphNGxwcmYwQXErUCtyVXhCOStHU2Flbmt3?=
 =?utf-8?B?Y2FrSUFCV2RwcUp5UFNQZ0pLVis3ajdTN1VvMzA4QmtBUXlkRVFGRjl6dW9R?=
 =?utf-8?B?T0FKWDFaM05FcFI0WjFhYlp4VmwwZFRvYUtnOGxNWXdtQjgxZ2tNeGZETmkz?=
 =?utf-8?B?cFZ4WTBsYXZ3a283QzNTRGRiOThCVTJWSDF5NWdkV2ZCWjNoSzNJaUozNk9l?=
 =?utf-8?B?TkI5b1E2bW5VNkQxL2xFMlZsQlZ3NU50RGVkT3FVK2Z1NDdUK0h4YXp1dDN5?=
 =?utf-8?B?OHI3dzRUSUtsMUNRYzVPWGVERFp2ejhCc3BLZWZlWU1KdDBlQWNnRVhoam1h?=
 =?utf-8?B?bVg0bkJsSUE3dnJicjV1aUhRbjEwbSs3V3hJMjFhTmxZSktWT1BJYlIyQ2lr?=
 =?utf-8?B?UWZpVEZWbnlDdlRVcmdqMHdFRnNDb0RMWDFXeUVZWlpTUDVPcmJBVmFTVmc3?=
 =?utf-8?B?RGtSWHJ2WXhlc1JyejRUVTBzcnRQbUs5bTJOUmpCUUtIS1hRQU9laXFpdVdG?=
 =?utf-8?B?d0NZK0oxVVBEaDEyN0xiZGRNTTNYaWJGY2IxNnRRQWQwYVhTUzRxTHlwcDlU?=
 =?utf-8?B?dVhWb3dTWXZXUENRbDRrWklOZmdYS1JXMmk0MTgvQW1zYnZodXhIYVpuMG1Y?=
 =?utf-8?B?emEzSmllSWd2UHRsdk9QUWlwSUNWWHJJVmhxMFZBZ0NwSG01dVRLaUlHNU4v?=
 =?utf-8?B?NkkzaHpVc0NtY1BDZEJtbHpZbWdaVUNVYzNVcGlPSjV5M015cXhqNStEM2ow?=
 =?utf-8?B?YkxQUnl3Umd1cTV4Mmg5b2hrZS81VktwbjBUMFZ2TEwxaHVyWW9oM2RmZFM0?=
 =?utf-8?B?eUNRZ05MMUhiS2I3djhNYkJmTjBxa0I2N2t5NWNsWS9va0p0bmdzY2ZOZGZa?=
 =?utf-8?Q?hPTFhUw8lStbRGKI8OwgGDdJV?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k7sV5TRv6nW6rcGkXtoBhHrcLIRw30NUjA+3uxXNblEvTFfR6OjZtwqXifoRsvvKcULZne6rOVqk4t4tqEobMwKLyfSY60uF80IwQlXBI70ilodUCqYWjdVSm2vy3uAAkYy2YTas1qvyNDno8YLJ9ZSvpic3fcWohG/L9DibK+Ww0qu6skGrS7b2fVOn3ijps10nD50QX9FApj7MHfxcrjbo/Fa3bZEACo/kRVYlfU6WPCuSsJO6VtLhFGfzRK0MEGgXjCf/RlHKIxHqd3t86uwxsK/nLNx5UiCAcb+loTSjju/U5GNF6ElPz7+IY1vbMQpALwqI1k7FdogI6Aopu4LgSIWPIkvvGqSOQEkC5lIENedTaWX2uz8k+eyxDbckAnzLabG3GdG3aBvd66MrbAd5kTtqAkg1tgQiCHBn35qtfqPHKbtfiX+E7d0vwvRq0n7wHSrRT4GvQzjihuYTlhZUYnVwDlqWBausXe/z6semp7SDKR82yA5E5ZaKsy+/UiDo1funxclYcHGimzBAAisYszQoCjZy88EhPlfmnztFbxKrMOfjF0TgwBuokrnh3a3KMkQJKgrfyUI4Km7PQBLw29tCOA9ROWRNE+kyajM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c0ff1f2-d82d-4fcf-7575-08dd6b400329
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2025 01:54:43.3199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4ciFSnjVo2JO3cLiFHr3LnaRjhK36rTQ/neR+BkMBjuFTdfAziPX1NNNTJOBs4pBcaMrQbL9DrU9bNU8W0nOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4954
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-25_01,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503250012
X-Proofpoint-GUID: VilUJTZPEVPMIK44_6Av3s78Hvp2azY-
X-Proofpoint-ORIG-GUID: VilUJTZPEVPMIK44_6Av3s78Hvp2azY-

On 25/03/2025 00:16, Sagar.Biradar@microchip.com wrote:
>>>>
>>>> I've added the original authors of Bugzilla 217599[1] to the cc list to
>>>> get their attention and review.
>>>>
> Historically, the aacraid driver relied on the can_queue member of the scsi_host structure to determine the total number of cmds the FW could manage.
> With FW supporting 32 queues, each capable of handling 32 commands, the total command capacity was effectively 1024 (32*32).
> 
> This limit is a HW/FW limitation specific to the aacraid controller, which restricts each queue to a maximum of 32 cmds.
> 
> Starting from kernel version 6.4, the introduction of the map queue mechanism treated all queues as having the same capacity as can_queue, inadvertently exceeding the 1024 command limit.
> Consequently, relying solely on scsi_host->can_queue became unfeasible.
> To address this, the patch introduces logic to dynamically assign can_queue based on the number of available MSIX vectors (i.e., the number of queues) multiplied by 32.

I have not read all this thread, but ....

in case unknown, if you set shost->host_tagset when setting 
shost->nr_hw_queues > 1, this means that the total queue depth of the 
adapter (from block layer PoV) == each HW queue depth == shost->can_queue

If you don't set shost->host_tagset, then total queue depth (from block 
layer PoV) is shost->can_queue * shost->nr_hw_queues

> This approach ensures can_queue correctly reflects the hardware’s total command capacity, preventing issues caused by exceeding the 1024 limit.
> But this change causes a performance drop in some configurations.
> It's important to mention that the patch does not modify the queue depth itself but rather aligns can_queue with the hardware's fixed limit.
> 
> For comparison, competitor controllers typically support up to 256 commands per queue with an overall capacity of 8192 (256*32) cmds or more.
> While the aacraid controller's design has stricter hardware constraints, the patch ensures it functions optimally within these limits and hence the reduced performance.
> 
> Conclusion :
> A generic fix is not practical - given the performance drop.
> As John Meneghini suggested, instead of a modparam we could embed the same fix inside a kconfig option.
> 
> Should I submit a new version with the kconfig option?

