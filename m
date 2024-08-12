Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC78016E866
	for <linux-scsi@vger.kernel.org>; Mon, 12 Aug 2024 10:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723459637; cv=fail; b=M+xrKn3Q7vpyN2ZR9aP2pg7g8tsb+3XGKR1u7szWDcxifEJjfl8++6AsKIxbPJd1p7dIll3X+WSd158wo+eqizOHBe/nYE7HCxNXWl7GDPpEBdQIPMfVj0V+TLao+DoyuPsiFboGYMwsMserujxfHxjTdu+8DCoPNfNqxzDbE6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723459637; c=relaxed/simple;
	bh=kaE75NU/CAT3qbWa7Je42Ld/jc/UM4LwEFEx4Td75EI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OiN0i6aE2X322zD08UbYrPe67bhoqwla/sJZ49NfWlWx0AprjNBn1IF1iTzohHKWVLVX0i2A4g2/ldnlFZha6+BEMHbouRwBZl8rIfgdx/dZQroyDLC9YDj8iFwMw6Of8L97FAa6T0BnL8s+dz15T4dZRv14FzD4CtplzVEU1Go=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jFbIVuuQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JyXzkCIF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jFbIVuuQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JyXzkCIF"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47C8wiwn020501;
	Mon, 12 Aug 2024 10:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=EAHi296PeoGeHvSkDCEWlWuvyzRV4kBrN5r6lJ+/0t0=; b=
	jFbIVuuQzQATs3L15LasxDnCjksDfpiU4e3IlCsj7ocWeIdlzOwu0w34oNe6Vp8e
	whT0WlC9Kn8mK/LTtBlwwx/v1WUoFe1mkyCT2ciC1R4YFJVouKoe7P/RSjgovC0u
	FdrV+Di7mZi4Cy55J36VmeA9b5Y9kZltzz6b30l3Jufchx1Pc/EmxCRAAlE5+6R0
	yFh6gSVprKSoCSidyQ/AYU1TM+VapB7JIwTK+CZ/zAgVFMugIzw448lT3TQZ96l1
	XQlj/0nGepCQLwSWgukFKMd9FXgk1QHlyotqadD81YTPmQ2lf09JlAFlmkFnlDKG
	iNaVS6Mx/zuSlf98mPqZRw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x08cj9es-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 10:46:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47C9hMDT021115;
	Mon, 12 Aug 2024 10:46:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxndfdx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 10:46:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y2fcV53aXOm8MNCjlrlDFGBQhvb13X38SG4vFJZsOPns6btKpC+ELMdfUMFdWG88azvMFJMHVeVe+EEcHoZ/ryFGPlEoMge2RhrJrKY7v8AGt2antgOdyVOiGuh8qVTlpJmIOsyOwtne4hCFFd8wI+/Dshp+GNXI68lI7quPFsQB+0kD0uKHSLA9bLciMVBSkFs2vuaqS3V9TsLK+5MGsTpG187qyNQb9vKg0XkPOYsQEM+lpuNEyowsygXm0HmsPy76EdezV2H+JRt+qPrwLSlFKnWmTeKjA3mneVG+WxXC4yHkSHDWR+LCTRMFFi1AxVbnBe7vRFoomDhcQ6Xdsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAHi296PeoGeHvSkDCEWlWuvyzRV4kBrN5r6lJ+/0t0=;
 b=R1pyQ64NzQ1Xdj1T6ZfgzOA1hOnkPGGIbJWPNN39oxNPQhu5DTaYg0CW2VWg3NyM1Ga+HqMXq6pMhJoyVlO3rUnix5z1y7CwGeoBb6dWCJJPoCER7yXmjZVj8dldN6nQ6ovGlUwexs4h4i0rmziyD/0DXo9uzKIuSB41ANb5L+d2hTeqOKzUd5Gz+gThRGdmjD73nFAH58SPsiULISNsZUxSd6O4o4gBJzLsR73rNeiQlBs06l4MD6yzlwmaiXwrCvUuEhfi8x7i6p5XTRBK427Y8nf+DSiygEWwbJA/+pQI/l4SNfuHupI6zzZ87VJEDQDw93ZITesiRc3tfIpL1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAHi296PeoGeHvSkDCEWlWuvyzRV4kBrN5r6lJ+/0t0=;
 b=JyXzkCIF0x/U4nq6frXIUfjICVb182REZkSE2/1XIxeLGiHPQlV9lbMDHz0/aWj7ROi4LihFC7If2NyRuZKa2pCLFiYSlrZ7rnuuhoGFxTbLvJcik3pdanJT6bmNALSuPDoMbNJ4G3Jg2317u0SgrOEfzAz3pOUExDgvLweQAgQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BN0PR10MB4854.namprd10.prod.outlook.com (2603:10b6:408:123::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.30; Mon, 12 Aug
 2024 10:46:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.7875.012; Mon, 12 Aug 2024
 10:46:39 +0000
Message-ID: <2839fb1b-0547-42e2-9f85-8acf43a2545d@oracle.com>
Date: Mon, 12 Aug 2024 11:46:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] Driver core: platform: Add
 devm_platform_get_irqs_affinity()
To: Bart Van Assche <bvanassche@acm.org>, lenb@kernel.org, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org, tglx@linutronix.de, maz@kernel.org
Cc: linux-scsi@vger.kernel.org
References: <1606905417-183214-1-git-send-email-john.garry@huawei.com>
 <1606905417-183214-5-git-send-email-john.garry@huawei.com>
 <1d8d8bcc-e70e-45d1-b722-4931d2a65ae0@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <1d8d8bcc-e70e-45d1-b722-4931d2a65ae0@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P302CA0021.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BN0PR10MB4854:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c6777c7-0809-4d3b-95eb-08dcbabc0be1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWJ3QVRSNU9EVVI3TzdJWFR1VTVGUkltc3Q4SDJKR0g2ZXVwUFNCRzlmZ2hz?=
 =?utf-8?B?cWN3a2lxSXY3Z2NVZmNDT1hJVG1sUFJKVWVkcjRjTnAwOFlub05EMjBWTWky?=
 =?utf-8?B?emJvZ1Q5K3ZRZ25ZNURna3dlNFhBaGdSSVlobWN5ODBETGg5byt1RXFHVGxK?=
 =?utf-8?B?MFB6aXEzVmVCaU9LY3dIeWIycFNOaWhrSE1PR2owNkcyTCtLcWplV3lpY1hj?=
 =?utf-8?B?UG8xUlFta3BONUtETU9YcEdXT0JMSzZ6eTNGb1A4SzVqQXNPRXdReDhLUStZ?=
 =?utf-8?B?QStxWm5GZDlpdzhqSENyQzlLZzlOL25JQ2Zza0xmUU9PMis0WkxVbkRtVjVa?=
 =?utf-8?B?ajljQno4cm45Ulg2bTFLZkV5RVZQcXlMTytvRWdVU0ZWcWs2a2pEdGR3YitM?=
 =?utf-8?B?QVk5d0VrMjNYc210SmtkZHhuaWJMdjhmSVFZMHRYeWw1VWhiTkpuN3ZqTkhV?=
 =?utf-8?B?YVJYaDRtRDhnUVJqOUNXZi9YRk9jNkZkY1NRL1ZMV3htMVU0ajZBcFZGQ3Zr?=
 =?utf-8?B?UzNLQ1EzcjhvV2tTU1plV25obWRvV0IvN0dBNXYxelNMR05jVGZJWmhDZDR4?=
 =?utf-8?B?OXhGNWs3YVNTTGs1eU1yMnp2SVlvcnlnT2VzZ3dmaWVtRkU4dElFYUNZTk9q?=
 =?utf-8?B?ZWdFTXV0dThNQWtoTFJsK2lZT0ZwYVRYTW1ka0NIbFl1M3VyWTVSbURoMU9C?=
 =?utf-8?B?ZVJORUpWMktzMDFITmpYL2Z1T080MU9JanFRRmVWOXVGMnFoQkVqMFF2MWZF?=
 =?utf-8?B?c1pROEl5N1N0STFxZDdnS0VST3FaSXlRVm95cVdVU2NZeXZ4ZzdLYVdkWERv?=
 =?utf-8?B?YTIrRk4wemMrUWZkUHZNVjJhTktmZ2h3MEVxamZlWjJoT3RqWnRjamdKV2lv?=
 =?utf-8?B?WHlCTmxMWWFNYTh3N1FHOUFPUkNFQ3pWOUhmRFJjTDNVZG81YzduVjRTWFVu?=
 =?utf-8?B?dzJOZ2NIdUErWU41ZDBHQldwR2QzN24wZmtSZTBXaHpuRmdtRUpxc2kxYVRQ?=
 =?utf-8?B?dExVTjdpUzh6aENmUU1BaE5laG9KTFNJRU5YYXQ4YmNURmdndjVWRjgyZUZW?=
 =?utf-8?B?WThPZEhIamVMRit0STRNUTBHZmk5QTc2NGFxa0JrNng5MEVPem1WY0x1bmZq?=
 =?utf-8?B?UEdBcnJnYW9EMDVnRlhCeDN5Y2lTa2xFeWRyYjV4UnYzQTZrRHBNaTh5dEFp?=
 =?utf-8?B?SkJHSmh2Q3E5Vm9DL3hSNHVaU2pDQ2xkRVpRNjFHQWRjSGRSWkVIc3F6U3B0?=
 =?utf-8?B?Yk52Rlg1UDJ4K2dMQ0NSRk1Lbjd1dWFVRnBvTXU5aWxsNk1BMTlPQ0pQOUhK?=
 =?utf-8?B?ak12TnNqQVlSWTVsZzFpMGoxOVVEOXJEaW1RYXZMK2xGSnBPWjVTOGoxaS9p?=
 =?utf-8?B?dDcvRWR2M0lzam5ZSTZ4TUp3d2FDaDhGZnFoWHNrREl2QVV0ekdSckFHZWx2?=
 =?utf-8?B?NmxQejBGT2pLaDFha003Sk1mTFgzbUpLN245Vlgxb3prUXQ2Qjltc3hRWVdV?=
 =?utf-8?B?ZDBYOUV0ZW5xMmFmOEMvZUVWQ1pGNjJWelM4WTZwUkVpSHhNQ0xISFBWd1l0?=
 =?utf-8?B?VGVvTEx2SDQ1QXFDOE1vQ2I1Y1BVTWxqNmZoNG91ai9QcUQ0UVFUVTlmc3dX?=
 =?utf-8?B?YmRpd3NBb0g3VmVoMEFJM1Yzb1czd2Y5TUZyd3kydys0WCt2OFBlYVlvajdQ?=
 =?utf-8?B?bnRqd3I3aU9ENE1iSElrNFpHa2xJeU05bVBnZXRoekYvOEgxMTNHajZzTHhJ?=
 =?utf-8?B?cVpZVTc5SElqSElwL25yNFFNemorOXZmMDk0RHJTci8vRWpXdXBDakdwNmlj?=
 =?utf-8?B?aEFQRGVCRmkrQUhnWTdsQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjQvLzZUK2c1eFN6UXdnbDJ6djYzalZaNHFLNERWTmIvbm5MV0czRkxLNGZZ?=
 =?utf-8?B?Y3N3QTlqR3BpVHhLb2pDMVRIamFueXBMb1ZHejBGS3lKSzNhcE1DQzd2Zjhw?=
 =?utf-8?B?RDQvb1ZBN2hUZHdCb1lSbW9ZZzB3QS91TUJJLzdKSkk0TGk4dVpnRmY3ejlR?=
 =?utf-8?B?U0RvM0NFcEUraC81OEZsOUcrU243N3ZjL0JSU2IrblFnTUlMb2VhVFBaSE9i?=
 =?utf-8?B?eUN5dU53YVJBOHhld0llN25RTG04V0l6ZVlOQXQvSHpTNUFseVFLL0FjYzJz?=
 =?utf-8?B?UkxZTUVVVEcybnVrbER0K3MwVEVNSkREUzJRdWhwL0VVM0FrY0Z0WFhnS29t?=
 =?utf-8?B?TzhrcjY0TzV2anhndVQxc3JtckNIRHRBSjBET2dkVktlVjJ5M212bTBuc2N5?=
 =?utf-8?B?N0FWQzNhMkIzTmVWVVVPNVozK1JBWUhFaEdTcGw1bHJ5b2hmVVU2RkhmNUV2?=
 =?utf-8?B?VVhjTUU1Ny9XMTNyMnhwMCs0d0Z5ZU8xMnZhTXEyQUZVMGNvdmFVcjJJR1Bm?=
 =?utf-8?B?QU04VDNHZzFlMW9RYWZkaXBOdkY0TnlWQ3JoME90STVXK284dWdVNjRZTUFz?=
 =?utf-8?B?eEVDcHhWTW1kNlpRNmNQUnUzN05wWGx3SHYzeFVObktTdkQ4WGRyc29hNkpR?=
 =?utf-8?B?Vk56QWRlaUcySWd2b3lPZUxRZ05UcE95eitoT2RUK3E5VWNqK29jS3N0UGdk?=
 =?utf-8?B?RWs3a3IxY1lZRDBDdFdvOG9VMCtONHV5dElYc2lIdTcyS0Y2NDNhaU5HcWk2?=
 =?utf-8?B?aEwzcWZkcmt0Kzd1TDl0N2FZQ3ZHSk5NR3FHUkJ2NVhWalB3SDJLU05qSW5W?=
 =?utf-8?B?WmhaaWpDdHMyS2JQQnQzSGFPdE9xeVJyMVdxUmF2WC9maFBpSUwvc3R0VlJy?=
 =?utf-8?B?d0ZYT0tTMUF3UlByV1ZNMGlpL3Vxdmk5aEUzRjNhWTB1MjhQK3FnaERHdm11?=
 =?utf-8?B?Z0xWeWwvdVZzMzZ2bVgvQzVyRkR5bk1IRWZHL3JITHgrNU1kSldUaFdOaGEz?=
 =?utf-8?B?REg5ZEhVdGU0SDV0cDVQQkIrR1NKb0w4WTcyNnVOaWZmVFhqV25BQVJ5Smh1?=
 =?utf-8?B?RE05bVRUdlJxUXl4bWpoWDdocjNJSHJib29TSW9NWjJzUGRmWVVvaXJFSUlZ?=
 =?utf-8?B?aTdNeWI4cTNCMU9sUDRCRmkvc0xOTVpCMEZUcFN5ZEI0eC9BV2EwcUZEM2Vy?=
 =?utf-8?B?Y0hzSTNpRnl3ZWdYNGwrTHIxOFo5cld5b0pmT3NpbjlLU2hEdHZIWEZFY1I3?=
 =?utf-8?B?Yld6ZmNYV1FSMExVUWRPQUJPS0E1K2hIcXg0dXBVQU5XZFZ2NFRHUXQ3OVkz?=
 =?utf-8?B?NlF5Z29idHpIUGlCT21qZGpNVjJPd2c1QnpLRWNHSEliYm1WWjg0NWh0U3JH?=
 =?utf-8?B?cDVwdGpWSkxod2cyK1dIajRoT0htNG80VlJTKy9LbCtMMnd1QnpsNGo1UlJ0?=
 =?utf-8?B?c1JVQTlQcmw0ZGpQOE8rNUhndm9ZL1pIUkkxdGdtd0V0NUpzNTlPSDIrWW1C?=
 =?utf-8?B?WEF0VDEvdlhNQ3dXWGExUXM1T3hUYTg0ajlqRmpDMTlFWTZHOFgrNEdXNER1?=
 =?utf-8?B?OVJxZHA0OEhBcTBqZzNic1lxYjNNa2pNbEdDTWUvUlRBdWl1TzUvRW05aDBD?=
 =?utf-8?B?bHlCdHVuM3Jvci9WMittNHBmTzRpQnE2TmpTT0VlMDZRSzlFRFd6cVNTd1BD?=
 =?utf-8?B?MjErUENQaVdyM1lYLzZoUkxhc1dXV245ZzRMQTExWHJXUmVVVkdlTDF1WW1a?=
 =?utf-8?B?Qi9tYmdJcjNMVDQ5Q2hTdGVTNzZjRmVvamFVejQveitpVWxCcHlKd0d5Qm9O?=
 =?utf-8?B?NzJRK2ZlbzZtSzFmaXpXQ1RWMWtNQTdKaUxJV1VVK2pZT1VTdzN2QWR3bERD?=
 =?utf-8?B?UTRRYUVGOFNyS1orRWh4Umt5dGpCY0dJV1BLMHFuNXZTNzUrTVF6S1dPYXV2?=
 =?utf-8?B?Mm9ib1VDKysvdWlxMTJwRldaK0tFMjdTSVVSUnhVVGZCRi83TFBSc09NdXc1?=
 =?utf-8?B?akhINlJKQnJkOVhYNDZGYVpxdzBUaG4rMFRybC9GNVRMZ0k2UmFYMERTSUYr?=
 =?utf-8?B?WGNrcG82V2x0cHFyYlBvczRqL3VsS1AvKyttSzZKSXJQVVU4RU44cVZzSGIv?=
 =?utf-8?Q?HVU//w1niIHlJfLEj6G7dOQ1W?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uxhnaDzXlIHoK3Iy9w49yvpUexgQeV3fD+RoiI9jrrkvC4VjueZSoLTSLIiJdqwTTm7HlLijPsDUHthWQYvmxT+I6IOBFldFlC0QpPmOYWsVyGbu6mxImUdjH6TBCHoLL/H3ygYiYZQLdIn5ETGSJ0hzwtWIQCu+7I9qwsa7OhcIVcQxUmk6u90+wXQFh//m1e3ZZoCnkKxKMK6IqFDdzq8i+42AO4IaoJ1DuP2Xs1bgVuUeTe5okMnVbDW8WfFFDl4coctB3O+qxxlhr7J9sx/gTDc4OybFraVSP6ZpI5eM0ZlZPXaNpUK5SxyWFlLhxDy5IFnPJGchVp2WKmn7GtJMV7LcDp2qZCwF/3064QhAix6zre+xfpqa6xkB/WwWcdeMFr6dy9C0HBk3K7xbSyqe+SWS8sCCFZjQ4/Kk5uwgyi6mbxr8X3EBagkZjDkknwqTOXTgLHEUR6zeZ62+yLYvI4nOlVH9WGBAbH0kzNx/qhD3YzEoPz5Rt8a5WHO+3cz+AD4Ly1xrneek84EOnCfKXxXWk5RmXhM1biRihTOjecd0ncnn8uMK/RzcEmaqcULNBK3vfAER1syoLYLAYAC4t5SZhumsHhjFyhijDKM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c6777c7-0809-4d3b-95eb-08dcbabc0be1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 10:46:39.7595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KW/rw836kWf+1ldhtacbMNdV2nL7i+tievQygf1VYYS8V9oaBR/H0MJUBazQNVFI5zEWUcLLYj//tyZlO4HAqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4854
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_02,2024-08-07_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408120081
X-Proofpoint-ORIG-GUID: jv6OyzCMfjmtuK6NgLGULxa-PInfQoOv
X-Proofpoint-GUID: jv6OyzCMfjmtuK6NgLGULxa-PInfQoOv

On 09/08/2024 19:11, Bart Van Assche wrote:
> On 12/2/20 2:36 AM, John Garry wrote:
>> +    for (i = 0; i < nvec; i++) {
>> +        int irq = platform_get_irq(dev, i);
>> +        if (irq < 0) {
>> +            ret = irq;
>> +            goto err_free_devres;
>> +        }
>> +        ptr->irq[i] = irq;
>> +    }
> 
> (replying to an email from four years ago)
> 
> Why does this function call platform_get_irq(dev, i) instead of
> platform_get_irq(dev, affd->pre_vectors + i)? Is there perhaps something
> about the hisi_sas driver that I'm missing? I'm asking this because this
> function would be useful for UFS controller drivers if the
> affd->pre_vectors offset would be added when calling platform_get_irq().
> 
int devm_platform_get_irqs_affinity(struct platform_device *dev,
				    struct irq_affinity *affd,
				    unsigned int minvec,
				    unsigned int maxvec,
				    int **irqs)


Function devm_platform_get_irqs_affinity() gets the irq number for a 
total between @minvec and @maxvec interrupts, and fills them into @irqs 
arg. It does not just get the interrupts for index @minvec to @maxvec only.

For context, as I remember, hisi_sas v2 hw has 128 interrupts lines. 
Interrupts index [96, 112) are completion queue interrupts, which we 
want to spread over all CPUs. See interrupt_init_v2_hw() in that driver 
for how the control interrupts, like phy up/down, are used.
