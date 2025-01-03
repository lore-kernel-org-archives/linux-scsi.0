Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8553E1CCEF0;
	Fri,  3 Jan 2025 08:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735894647; cv=fail; b=jC79VsGxeiJfecgzG2ynNESE68rdCJdMcMUtiXPGAsbMVEm0KVdd8tf6J1oQtU8LXBd9xhM9p7QJxXT/I5oNtxkjmTxmbEKb88AvJg+ug670WuFL6OWk5JUT6h9BKDMmNxeoNFILoRndmrhWZW1XoR+TxxTSdnUBmm0DTS5UhdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735894647; c=relaxed/simple;
	bh=dGmmCBiYU118NOyTyevNZjZDumXtr8lc5mnPxKYKXlM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MoPtoLzXBgmHptUvodT6wSfoDTi/9tRh8Y8TVeFqRPnSwCuY8l3dtIBvlgoqKYzuv0M+YrYETEr97KaVqIubJlfbmwDdB+SBNq3+KfeW1GijGZOalrFdbMBO8Wse+JRLUcfOMIN/gsn4CfKC/dS6aTXlCDEQSJ81xA0WZsDddxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g/edaRGh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FbJz244U; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g/edaRGh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FbJz244U"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5032NarZ011864;
	Fri, 3 Jan 2025 08:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Rln61LMa4GKGC36nxD+e3TYDKTUSylRU/PF+oMmYHXA=; b=
	g/edaRGhmsNRttqvMJe6Wq77cAUJDhefbmv6J8GHYJMA8hsO0CtYYWe3VCcyCpFV
	jJPm4lP384mFN4G6K0+7zECRu9fDh4517utJ1Jbcs0xQovDeq1N8TPGz41ns4bO9
	YXsaIDg+lBioE+I30sE7RHhXPS3iL0dqe3v2obmO4DUteXnO/jOBz523X/r8Xkvk
	KgDDYh12tQaMle1tTvvLb/RaO80nRnkPhanXUuMHQEmN5CyTy1qrp84p+8J9DMHt
	FNS99pOrJvnbn3uCmWAZAaEatRKCFgJrG+hJmLJuOED1zkbz7WHwQ8osa+G6JJSk
	IhCh+50pNnJnDbjMVkYJog==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43wrb8arcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jan 2025 08:57:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5037KuDK033469;
	Fri, 3 Jan 2025 08:57:17 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s99780-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jan 2025 08:57:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FQ3IKzQMNboaT1knWDGam9dxPbBCbduR+kQrWilMFHV/ZBiCcXwF5UhImuKi1JUH1gRGNzUZy6X/b/E39zilMiCwE0rRarAaZSfFgAc+oKWKdB+BswUWlUptElhaDG3+XzgnTex5UzSRd3N7HzoOs3BqB844r014VdO1hE19UmV1wDOJgpg9L9IrF3kplcQoQmyspos4B8QqXuNmhIONoz2mneln6y3tEuXApu4TzRsaaSgplC2hFqiUc8uFVvQCj3udCyykcvIKYbFMpy7djvaj3kJWih6l3ME1GRmelbY9Fc67r5EbPRkltpipXsvZaUv8gShyCw7HmZNiQ8hetA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rln61LMa4GKGC36nxD+e3TYDKTUSylRU/PF+oMmYHXA=;
 b=TEkr7oDHZFyENfF5sClGorYLtmF2M2g9C9X4lex6d1tzJ0NelHUdRzVOlj6sGNapZcwcH9pDxf4OtFdQc/dvXMsFs7dt4mVtgIJXm37cvGv9kEN8cL2FGatcMNyg6EJljBaf3mI7kIuZuMbZK1WxRKEgvKixqf9NOB/kMQZyxc5bjnUEBXUDbq2O6qLwKuWTawjia9XEuIT2nz5JVKURuyWw7Fn50oYR7hvA1M5n9uDzG1WPJxec79R101ZGo5ZSZl6lzD4CwSXIz9wHY8F5YX8RTM4j2o9vxK7cw3NAD/FKfQvBFc7wg2bXjTjvLH5MxnOVLiuJA3xctRgCR0VHqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rln61LMa4GKGC36nxD+e3TYDKTUSylRU/PF+oMmYHXA=;
 b=FbJz244U2qB07Ne3nX89qTY+mRuuJ2ditgYvTGdS9HPLc0I5syz/4WGFMzHaop8z0OKtpuX8eoNmMEf9yo57GKvoZPnNfBYFh7SGkflNIADvLAG53IFtu/43H2V5ljUECnSrdcpaLiutscNvAx9wz1z+y8u2NFw+SVrUqzd0zdU=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7610.namprd10.prod.outlook.com (2603:10b6:610:171::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Fri, 3 Jan
 2025 08:57:11 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8314.012; Fri, 3 Jan 2025
 08:57:11 +0000
Message-ID: <9bcbd01f-98b4-4721-a470-1d9ab0d1ecbd@oracle.com>
Date: Fri, 3 Jan 2025 08:57:08 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] block: remove blk_mq_init_bitmaps
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20250103074237.460751-1-hch@lst.de>
 <20250103074237.460751-3-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250103074237.460751-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0062.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::26) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7610:EE_
X-MS-Office365-Filtering-Correlation-Id: c537f7bb-81a9-4cb7-f6b1-08dd2bd49c2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZDBodGd0by9WalcxSlJ1Yk9ZWlZEa2hmcU9OVi9VMVQzVnhNT3Z0U05Xa0N1?=
 =?utf-8?B?ZTdiRGVYSXZyUGI3RExzMWltSUdwNzhFMlhiam5qUWJFSW5LNmxmZFkwNDg5?=
 =?utf-8?B?R2ZVWjRsTGNlWmpid00rRnRGQWZrdEJJNEdMN3NDbXN2TDJrZUZ1VDBQSTMy?=
 =?utf-8?B?a205bmo5aGFqWVVwV3JGYmVsbENWZFNtNVhXRlYvYUIvMkdpZ25iY3pKWVFC?=
 =?utf-8?B?dG5EZ2FmQTBEbVRCTlBuYll5c2lxakoxbGwySmVmNG1QMm1NQ0JkeldPUloz?=
 =?utf-8?B?L2hnUk96T2J6TmNMc205WUo3WUMyMVhoS0NsNWVDbklQWHRnc0RWWjJQZ3BJ?=
 =?utf-8?B?bTJXTFBscmdmVGQySmd4ck5hQTRWZ1BOQ1F5OVJpL0RNUHpodFJNc2RFSVJh?=
 =?utf-8?B?Z1FxZFkrRWNZS1cxbzlOMUgvT2VrdmRaU3pZMjMvUjEzTk5nLzNrWEszSVFZ?=
 =?utf-8?B?blZlMDRrSlR2bDRYL2prMVFiNkYvUDFTYkpXUVUxcEtmclU0MFl0MVpTalJB?=
 =?utf-8?B?bUpybGJzakpjNzBCTHRrKys5c0tDN3NZWVAzVjNyT0xDejVDNE1TMUZUMDl2?=
 =?utf-8?B?REd5enVPVlZvV0NuSUVFZUZrSk9aK3BLc0UwbEFQMUR3ZXMyYWdrWWQyRDVH?=
 =?utf-8?B?V0ZwSVc5YmlMeDY3UkhkenUyNWxOVk5wMUF1T2MvcCtKaEkveHRDbHMxa1U3?=
 =?utf-8?B?Wkdld3VuckQ3WkFXT2o5RFgrNXVjMnVoajI3MjBkZGN3NlVsZmFSdVc3MGZ6?=
 =?utf-8?B?RVp6Nmo2eklyNFNjN01QcVRta2JzdFdVOGlRVUQyKzB4WldqNWxJU3BLbXBW?=
 =?utf-8?B?UHpkUDdLVytlVVJpaWpzdVZGbkczallGWHhYWXpXSFhCUmVwVHNNZ0VoTDND?=
 =?utf-8?B?NlgxZjY0S0kyQ0pHazFqenhYUXEwTGh6aXp0ZjJMSFZlMVI2NWNkTlRlRVJ5?=
 =?utf-8?B?MGpGZXZ5VEhLUUFWYVlMK2VtemJ1RVppNnA3eTlwN3cySVhLeHZWSDQ4MDRU?=
 =?utf-8?B?WUNBdisxQ0NYQXc3VzdnbEZjTnU2eStTYjFVV3Q5enIwbjlLb1JVOFprZmkw?=
 =?utf-8?B?bDdBVmIwYUpmaGxFUVEwbytGTjYyc2doa0Zob1VqWnFSU1ZkTERQdWI2UVdq?=
 =?utf-8?B?U2JSUGRvdDhOQ0tJWVlSZmxGMTZiVFNUMXBRQnFWUjY3OEdXMVNQcEJlcmEz?=
 =?utf-8?B?Q1pJY0hBQU16NUtYZ1FDcHRqUFFxbHlXd0VzaWFadzFvdk5ka1VEOC9md1FD?=
 =?utf-8?B?WjlNaXo0QVRaaVdFYTB5WDI3dDlLVTBFS20wUG1nUEhuOTNiMmN5S3o5UmVP?=
 =?utf-8?B?QW51RWFhbDFoVWlPRVJjeVRLeXYwaS8vRlZ1VTlzTjZDUkhkL09VN0p2ZVJl?=
 =?utf-8?B?NDg2ZHBCcy90NDBwbUw3NWRielBvRVVJKzZ2TkdBQUl1SUtadjlpVmxaSTBO?=
 =?utf-8?B?RUhkM1NkSTY1enVQWXM3UmgzT1ZsUWFXZkZDWWwycno1eW1NNXVhamZtMHFR?=
 =?utf-8?B?YW0vY3dnUnVYSHA2UDBJRHRSKzNZWmhXMHdOaDQvRHJoVXdpU2FWaVB1MlNi?=
 =?utf-8?B?aUUrSFVONkxhNmdLN1ZrVGlsZWc1THJXL3RKRDdKZXZXT2VJUXZScW83bEdY?=
 =?utf-8?B?YXI4K25XQ3E1WEo0NjQ5VkhvcVk1MnRhSElWN0ZEWFk2QW4vVzVyTjRHNkIr?=
 =?utf-8?B?S2RaaGplRDFKbmRZQzZJL3R2dXQ0aFRteTVYUVFBM0NPU0RrZVpIaVNJNE44?=
 =?utf-8?B?Wld4NjVyV21EV21RazFMUHUxZ2M4MFh5QXdyUTFDbWhhVUtDU1hkNDBpT0NL?=
 =?utf-8?B?OW9sWEJuQU1TMk1TZStyM3RuN1BIRmowQ1VMRktMckc3WHc3YnZiV29GNlJu?=
 =?utf-8?Q?d2Wb2lSslV7HY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVJHV004V0lCT0ZIbkQxTk5sbkxkNkV6TE1rTUVtS083OG1jRlY4Z3VzY0RR?=
 =?utf-8?B?d2pvbmUyTG13ZXlneWZzSjZaOE5pOTlNdEdzWkVOSEVCUFpwMHlqUU1ldTlx?=
 =?utf-8?B?ZDRWTXlaaWNEeGhMUVlsQmlIRXdOcy9LaUxSc1hoVnNmUHdFRW1nMVM1WDAy?=
 =?utf-8?B?WkliaDlmUDUrZ3FpNG9TNXdtM251QnpWVzlSNDJ3Q1grNE9pKzh6NEFNd08v?=
 =?utf-8?B?YyszVzQ2U3FtT3JaVWRSSW8wbHZqUjdCN0VOYzJPcWZtZTAwZi8zU0xNNmRZ?=
 =?utf-8?B?eng3dzUzWEYwdU5USjNLVUhMNTBEUFQxby8wMXgzY2dPZWNMRXYxeVBHaktV?=
 =?utf-8?B?MlhlUmtteTJKMzRlOVhuVktBTityUTlEMHplczlXWVErSU1CNHlWQXlvanM4?=
 =?utf-8?B?TzNzN2d2K0ZvN3dNcnQ2WGhWbWlQTUxYcDEvYlVWU0huTTI5YU44aGw0V2p5?=
 =?utf-8?B?U3hPZ0pZUGNQZ3ZFS2Ntdm8zZm9aOFBLQXhZdytXaFhLQmcrZkVZdlI3dHhU?=
 =?utf-8?B?OWtCRS9aU2htd3U1WGZrMG1GS1UzUkcrZTc2bGFQR2daakZlT3lEUVlYNmFQ?=
 =?utf-8?B?T1lrS3V4azNISFcyT3pCY3ljOVhBVS85WEhjeGY3VlhwQVROZU9Uc01uMlFO?=
 =?utf-8?B?TVNMSDlEQ3ZhYUJId2VnZFljTWZtc3Z0QU5GajB4R3hxbThGMjN6Vm1jYUdZ?=
 =?utf-8?B?T3BpU0g5VlNrbG84NmMwWVZCRTU4YmdUeERJZHFpcHdEeENQb3BBV25RSThn?=
 =?utf-8?B?Q1NWSXVCUnQ1aXBIejRiYml1OE5BajhmQjdIYS9Rd0NhWml1a1FLZmJVSVFj?=
 =?utf-8?B?cmtwdE45ZHdjYWxKaVQ0TGJJdlRNejAxRkF0aXJQZWRGSkpWUTlsdXN0Z2N4?=
 =?utf-8?B?TFJGSWRKSlRaZVU4cHM1cGIwMmljb3dRN3I3TkZrRUVBTDNWZ3hyYmlHR2JI?=
 =?utf-8?B?eWVSREw4R2xac1ZueTBmTjBBcXZJQlNpR00yT0dESSt4T1ZzQ1pYNExjcDUz?=
 =?utf-8?B?VThQaWQvV0ZBK3BFMUFRQmZkTGYzQ1VBdVB1SDRrU20xRVdSdjk0Q1lpY0lK?=
 =?utf-8?B?TGNSMUFWT0FVczh4ajBpRzhLVnN0Uk4vdnlTZDJmTUxrSHdDVjRSdmZlTXVQ?=
 =?utf-8?B?aHdEbUlmWExObDZtMkZGRnFCcjd1MlB1QytVdGUwMDVSQXlDWDc2dEZURlJ4?=
 =?utf-8?B?cU9oc09OdUFOeFA1NGZlbllzWldMV09yWGFEaTRMYW94UGRWU3NDUFRHaWFS?=
 =?utf-8?B?VFY4UHo2YkwwNkFVblNWU1V1cmpVRk9lb3VrRjhSb3Z4aTIrSUt2WEhCOFMx?=
 =?utf-8?B?bXNpS040d3lyVXEzZVdIODZManNjSE9jR212bGpmblV5dEU0Ymw5SURCbFdL?=
 =?utf-8?B?OE0wY1VxR29zSFNEVGxMVlJjSjFoOWFXcjh0THFyUXlieEd1S0tDY3VGQng4?=
 =?utf-8?B?NU5wOTJVdjBlMTN1TlJmNEw3Nmlyd2VpMTZtcmNXVGRpaDkzVnBZUFREZGpD?=
 =?utf-8?B?SDRVRGs3WG5kTHpvZTBDVWdYN1NPbHFHenBrVkhNWU9oUm5IVzMycWZJUDdo?=
 =?utf-8?B?MmllT2tGRHFsRmpRMmZSWlUzY1VCZWkxcVBTL2l6WW4wMFhYWGI4cWRHcDFv?=
 =?utf-8?B?bnpRclZscy96VzR6TENxbzdzMERxRnREdVh3S0c0bG9NemRuSG1hQUR0enZx?=
 =?utf-8?B?YXFYRHJzQmhEOTh6R0VYaWR3WG1wZCtqL2piMXBLd0lUMjdhUktQNm5YY3li?=
 =?utf-8?B?TVhZWWZSVXZ0VHV5MGMySVNGVXRvNFFXSkxub20zMzdha2R1RTI0cGVJaVdl?=
 =?utf-8?B?blhBcXdRakZaRXZQTHBWb3FsZ1hjVjgwdWRUZmFGQUV4MFRTMTUxdUl2WnRU?=
 =?utf-8?B?TFpFQk1sUHRIcjhzblVtMGtJM0p3aDhuajQvQ0RpYlNWRkZJSno2c3VwMXJR?=
 =?utf-8?B?dDQwblNOenk3L2Q4UjVaREYwbHlqREhuVllSbGRTU2MzbWxPVVR5ZkgwQzJP?=
 =?utf-8?B?WERpVDRYOEsxT0orR1JzKytUamRJQ0lidmVuUi9VdTloU3VESjhSdnMwbWNM?=
 =?utf-8?B?RmRwZHZFRXE5NjQzRExwVjQ1cVJIT016Ull5MzlxempST3h3RXliZERZaENi?=
 =?utf-8?B?UDN1ZXRQRTFCSlRYaXlLZXU5OHhQWVMvUVppY1NicHRtd0lQaDhodmwwVmMx?=
 =?utf-8?B?K0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8MUaf+dN/oDKBpzJAswOFNQ6oOMHvOpKL5Ul+mi1VkrYbkIvBZPg0H9Ytl58/jVf+S+aNHMX7SeXd2dLFgPLowLzBlxp1ZKPr0O/PTbskbkBt0EAj4j4oRVRjYKlqiP+en1SPBHJQaiiwSZR3/Lvy3KNpQMQuHtYbiLRArrnMfinOjx5RjVOzw30NQtK7CexvYD2Y4QvNgCrbY+6GS0qQ+tgEiCZKo9+/VaFOIUdRc3olWSCt51CqDesuD1KIfUpK5gxoEV40PcP964+yB5fGBfW62ASGrwjYaC3ZU2c4reblxTgn/38HT6/O4EwbfgIXdAkT/ZMAGcm4wQ9snEJSI1w60KVBPE2cskW3h1eNRxx4U8qHdirQKvDPvdzHEv2rzMPvLCyI0KDH2jkklb70VMlPignYRa5IYJfRn/9KVm/rqmDNwabQKawHijr+YJpTedK98ClINTyIYDDmI20skre6Fn3hSsP1Z0R9CHKD6OjVb8i20iTqLaNDIjIFummB5c+gMlAySP28wr7XPMjWt1QWCgNFZbYvlfpVODXSRE8Q+tD0m5K0MjUHoey+hWWRFL8c19st7+75lPUoFR4AIvPTjrAa+jkiwUQUcY82fM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c537f7bb-81a9-4cb7-f6b1-08dd2bd49c2a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 08:57:11.2234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhOEYaYPPAcyRX0PrXxdiOqMy2qW5oQY12Kb7UcytrIv9zW78XG037YBuvPkSNI4lEjtufoQLKdM3Tj1JmY79w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7610
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501030077
X-Proofpoint-GUID: -C7dQxK-1sXrjh5dVjSZIT2kzslXKtt0
X-Proofpoint-ORIG-GUID: -C7dQxK-1sXrjh5dVjSZIT2kzslXKtt0

On 03/01/2025 07:42, Christoph Hellwig wrote:
> The little work done in blk_mq_init_bitmaps is easier done in the only
> caller.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
