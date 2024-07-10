Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8170082C7E
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 19:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720641369; cv=fail; b=UN17Jhyb7LXNVyVcidtHXbDtWFBkSpvypMyv3toy97GUHtMV+66cbB4hxZfFIRl/2VDLx/bHVJzix43wWzjRUEyOXj3uwIcyUo+eVvma0Hj55vmVTFt4FsAzoLV0t8pxxqv6tTd6iRgcBqdeCInIkEt3ezi50FhwNZCl9EY0tds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720641369; c=relaxed/simple;
	bh=fApp6fuYXnUyPIlmi0e/iWOR4SC/q7XzBsV8ZxOx2tA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lFRrltaOWTJtqUsOt2RYiUBxadztRbEUXCroTzmRuEh3IBxG/i2ZoipjWckv3TCTBTeMfNftEpuERs4fRHRlZEMqYbkA+dfJ/OcGP7IDdivqQ79fslVmtnkjFAkPyLZlwyhqWVQQg28B+6n3Jm8Dx+RZ6Tgap755myv89+QzBfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T8IbADN8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I09hC/Sw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T8IbADN8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I09hC/Sw"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AFqoMt029610;
	Wed, 10 Jul 2024 19:56:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=5rSvQitpmd3mfmirf80foisYmbEQA2UTfgOsgoLNfTI=; b=
	T8IbADN8c00NF7xzE9hs0oKkbKNBv0FJylnJfTub2O6/ffWcMP8zFLmZSA3sLlF8
	u2CswATlWTzj9E6n5EnWSr3Pc5SP0xGvcfoKpX6JcEnGOcIr32GoF+27AlMdwea2
	gB3WhIrFQ/U+U9FiaQYh4uWPgOP6OunP/J1TzhKmUledu6v/fhjHAF7KgqHWow2i
	mZsIv6rcSnNjjnh09ntUHb8ui8L+103iqabVzFLbkMMEFTZOXsEnHfztCr4bG/lN
	p3yN6N5RGDHYx0XuOuV5rdUzw7hRfbX3qP7VYXPN7Afc3X4Rdy5YeVZ0hJpu0kFp
	ZV/WwRrZV+a5a+TiXdRRtg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wgq04aw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 19:56:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46AIgBuS033754;
	Wed, 10 Jul 2024 19:56:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 409vv1ah77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 19:56:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gu9yHWAgHAZrdxE6EabemPOkdfe9Vtj3ZGXOgf71huab5IdNspiaw36fhYhwW6OJDgf1Wt19eITBFGP+03PqH4CHBFc2mzDye+QOUQJskC6GvIz0OkmFOKNKKuzLsBEHUSz1f9YUtZjqDlxxhiLbgG57+qFqvISfkRtI1KR0/BkiWSVXoWn9m8lmCHyMS4F3F3IXyi8WKJDxUbxJK74mrgf40nbzq+vYnxbGrszsUDAtKBDmJSaP0HPCdm82ijXPZesq/K8IbfbYBh5OEPFEoLp5foEXImCuo5k4AspcaY+PnYMyavi1gW/s9PzyhPC4DqFOTljkW/8uDinFxqog6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5rSvQitpmd3mfmirf80foisYmbEQA2UTfgOsgoLNfTI=;
 b=hDAEcklIq0aQsJR02+dzZmZvd1Bc21AmnHE426EsxK+BvWHRXimJ6YtMuTBE3vVnTiBeHVGD5+Mfk30ZUc0R90dfyiHpvPW/0AH9N/mtrTiEj4rXPGsHNMJGtcmNg6YfQVRFTl+ErPQdevEg2h9dIBA6oq5UTHZ6xf9aJhAk85WLENayDMHgggc7Ay6LOGuPz/UwxFQ9A0RBAxuaTYZPl+LbyrsWZ22rJbQaRF2VKUCEY+HRUuFKU6esTCjYSs4X1469+cDucQtctBYjckPZ55TgPZwaZ/p4jP1I9Mn3ZKsHatlxYnz9or5NdpTUnyNK9gdK4AofLBdUDBiWyJEPbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rSvQitpmd3mfmirf80foisYmbEQA2UTfgOsgoLNfTI=;
 b=I09hC/SwgoD2EWXg8zJewMhB/L0XG4ck1IwVnx/7K1IGzFJLyJ1aF3ROLqEQ+CccfJC2/j3om6dALBc43wb4WDv1dKMN6726iaFbgloIxhk0RNu/zq2Gs1TaEz7tQGwR2I1WwmzoGcFLyo9l4ZUjmXlybDxDLrMJSokXbsXrJdw=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by CY5PR10MB6144.namprd10.prod.outlook.com (2603:10b6:930:34::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Wed, 10 Jul
 2024 19:56:00 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%3]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 19:56:00 +0000
Message-ID: <496d4076-ba9d-41dd-9992-6ce2141ab75e@oracle.com>
Date: Wed, 10 Jul 2024 12:55:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/11] qla2xxx: During vport delete send async logout
 explicitly
Content-Language: en-US
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
References: <20240710171057.35066-1-njavali@marvell.com>
 <20240710171057.35066-8-njavali@marvell.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240710171057.35066-8-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0440.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::20) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|CY5PR10MB6144:EE_
X-MS-Office365-Filtering-Correlation-Id: b42749ec-71f1-462e-5bd3-08dca11a526c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?eG43bGlxMVVzN0hxN1B0T2d2OGRURVg2aUFRMWJPRFFSK3BMdVdXcXpSUUF1?=
 =?utf-8?B?V00rRXVpeTl3YTAwb1BpamtIQ3lrWExPay9YRjdWeWJwQzFRbkJ2SjU1SXRv?=
 =?utf-8?B?blZTZjY1QlE3TTUwZUthalMvY2ZYV3ViMFhZYVZXVzNjWGs3SG5USUhsajNy?=
 =?utf-8?B?RFBXelo4cjNYRDJkVVpuSkp3ZUhWQUgvRFpHdmhtVDEwNFd4S1RzbVpUeVpG?=
 =?utf-8?B?MkxnQkxXQm5uL2R6WTBXbXFrbFNIeU95Ym1zVUNkbEc3WVBUR08rQUp3ejE5?=
 =?utf-8?B?MFN4bUEwOUI0RDV5dUExTUoxRFRoMnI2SG5XS2xXNUZ2WU90RFQ3YWR1bDVh?=
 =?utf-8?B?SFZJczZ4NW9aZkx3R3dsR2gzMkdiWFNGb2hPdVB2MzdnWTMrNnN6QTAwd1hG?=
 =?utf-8?B?M2xkQ0xDbkp0YnhSbzNqQk51NmlzcFNQQVd4T1UrYXBjSTcyN2ZtWDVJOWNz?=
 =?utf-8?B?ai9LMmlTRjJWM08xTGQ1YmdkaU90bmhpMW0rcTRJYWd1ejVKZW5Sc1VYNldL?=
 =?utf-8?B?Z3hBSjB1VFZUeFFYV0NNMnZZWE9BR2picEd2ZVVrbDdiL1d5cnpIUjNZV2tx?=
 =?utf-8?B?K0NXNDVPZmdadHNHTzI1Z010VnVLN0NSdXJsSUltVlhzeXpGK0xUTy8zUGNC?=
 =?utf-8?B?R25RbmlhY1NQcHdLYjBwaEJFYnRRRzB5Z2tNRWFNa3JHNE02Qm8yZWF3U2Jx?=
 =?utf-8?B?UUxiUXlyVktCMStaVGhyMmw0Z1d3TFY0NVAzSkc1V0FmcEhZMnJnbnZLV2tB?=
 =?utf-8?B?Z3pDZlBDL2xrOXdCeEhrR29GTkUzN1NmUXpJaDY1YXdDRTlvNy9qWDltN2pa?=
 =?utf-8?B?WUpXdDdabENzNTBXMXlzMXpiN2Zmc0JGZkpwWHhvSnZURzBMTVM1eW5jcUFy?=
 =?utf-8?B?TTRBWmFVWFpxMWs3djMyakUwVjVEVm5jMlhTZnAvTUU5TFpyckdtWE9pVEE0?=
 =?utf-8?B?RmkwV2RQczNQckx1NStwZGQwRnljL0lKajV2eGdHb3Z0ejUvcGEweTA1VG05?=
 =?utf-8?B?MEIwRnZma3F5TjFrTFlRbDc5MlMzNy9VOVRSNHRCNmx2cTlteFpvY1NLSVp2?=
 =?utf-8?B?QUh6WXp6bjNuZWxRR28wVUc2M1ZlaWxLZ3hIRnpqRnZicy9iQmFtVzdZT3dI?=
 =?utf-8?B?WTJaSGQvN25XNWIzREpCNEJyQ3hQT2JxNk9ueUFuZDdFdlB1SFU2SGNaLzE2?=
 =?utf-8?B?dG83Z0liRytjSm4yM0ZhTVo1ZUNjS3pxcjJZOGJFNlZabTJNSTVJb3lVMVlz?=
 =?utf-8?B?R3BiSmt3YURLRFBoTUN3K3V6TStHbTRrV0lwczZzMDIzVUdUSUpVSCtHTjFL?=
 =?utf-8?B?MG1Sd1hJZ1M0bGtoenBYMlFxM2dsY1FHWDJ5ejB6QlhPRm9nVVgxaXVodWor?=
 =?utf-8?B?RU1OMjlPU2dyM3N6QlppL3hxWEhEbURqK0l0SGZGcWV1OG1DcjJsRnlJcmFh?=
 =?utf-8?B?My9nTGhHdnU1cVc1NHhjakQ4TVJ4b3NkSVA5ZWFUNmowNTJ1K3BnSmtwUmg2?=
 =?utf-8?B?cktncG80b2JYbGd5dzNWbHVicnI5NHErZkxPWVVWZkgwTW5hTTZIU01ZWDkw?=
 =?utf-8?B?YWlJb0ZyZU1haGc0alZwckFhZzdNUmtsenhzMHVLR2lmL05LaEVKV0N0M3dX?=
 =?utf-8?B?TmtUR2lYRXlTV0ZsRVk4b25qTlVyVTM4bjJYdGt0K29SZWFESFFsWE1BbGpY?=
 =?utf-8?B?RG51cjRzbXFxY1JMM0NsYi9IRGxkVDhjU0pTZ2VJRWVNenRUUDVTcmdndE1t?=
 =?utf-8?B?SXBJWm5UdmVYT1BkRVh6bDlMWjZ5NVlzSkRNczBndVlCL1VjTGJlRnV0a3ZD?=
 =?utf-8?B?Z2RmNkhBL1NiTXJQdTgxQT09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VEJ6Q05iSVRlOVdLN0VHSHprWFlvRXQwNG42WUV6UnNtZzVYbmpSZzZlT1FB?=
 =?utf-8?B?SFF1OEhpL1VqSWpuTkd5R2dDd2VrMnEwL2ZFdjNPWitUOUhyQ3ZYZFc5bis0?=
 =?utf-8?B?TnFoT2F3bFNucS9qTFFIaC8vbnVLVXd5OVhDSjBCK2QxUSs1NW8rNHpDS2tD?=
 =?utf-8?B?UkdVbHFXYVo5TjhuY1pOMjc0SEdPSEZ3RE5BMTU3eFJyR1Q1TXdVS2RMQTNm?=
 =?utf-8?B?VjIzZW92MVhwZmJ1K0d4bDY1OEN3bzJBMG9VNXlvWlhxbW9xUFZ5cTVURUxv?=
 =?utf-8?B?WnpkUEd5ZkdYVFpsSmxSWENaQ0c1NVpFbVJsK3ZKbGJFUVgvTjdmeUVuc3d1?=
 =?utf-8?B?VE9STGFVK2xMT2cyRmNZNEJlUVBEcDNaTE1pMWZOZFZFTUxPamdTbEVGR0ZU?=
 =?utf-8?B?bDV4dmd0ODFsNm5CWDN4eGNHNkNva3Q3c0JNQmdUUzVOMERITTJLZnJrdU9B?=
 =?utf-8?B?WEhQdzBtS2tCYVVtcVI1S3dDUkNsOENEU0FHVG45Qy8yUTk3MlBqZmdCMmtI?=
 =?utf-8?B?ZDhLVjNwbmdEOXN2V2MxS3hTM0c0WjhvMGxTR2M5cGJmdEJVcEZNTTVlSzE4?=
 =?utf-8?B?c3NXeXRwaUU2MXNyYmxyME8wNXY3aHdRc2RLVjNGTVdCZHByRVBOZ2hMS1Zs?=
 =?utf-8?B?aXNaaFIrNEtCUXpvVkFWOU9jNnVpakRaWXZnUkxBOXpQd0MxWFRWZmdqSkVL?=
 =?utf-8?B?VWJaakxOZ2c5SFRhQ0dLVm5ZTlZQcjVLd3l6d0ZkdzI1UGJBOXFVZkZZZDkz?=
 =?utf-8?B?anh4NkM3a0RrVTRobWY3SVlsbkFvd1lPSFg0UFp6U2FHKzNHZ1pzSm5tU1Vm?=
 =?utf-8?B?azhCb1lUN3JESHgwMXBjbWJqZlQ1U2YzbFY4aVI2QU5QY1RENVZHUCtqazN3?=
 =?utf-8?B?VjB5MnFtaStiT2dVNE5oYjNGUXB0QXpqTk9welVDVWR5LzJNQ2R2WjRad3Ju?=
 =?utf-8?B?Q2ZTQTJWb2NJUlBUUzcrdmtncVFZS2VNVTVST0ZKRHdqdytvZjIwN2U4NXMy?=
 =?utf-8?B?V3FUMkpGVnZucjhPL3A0MEtNNnJsTDkxSi9ra0J6WTFuSGtTdVlKaHJWQURy?=
 =?utf-8?B?WVpDQXR2QlBkdXZIdmlzS0d5SFdOL3hsQlgzd2FxN2ZqM2tncklNamJIdlZ3?=
 =?utf-8?B?dE5vSllZQ1FoaE5ZbEVtQUYvUEVtaWFTSkNBWG9ZMUo3TFhhUjFLY0Mva01X?=
 =?utf-8?B?TjVPRTdydlpIUkRBVU5raUduMTBCcWZiUEpTRlRyd1plc2VKY1MyZkw5OU5j?=
 =?utf-8?B?emhNTjNBOFd0TXNhaGhQRysrZnZMOUVxV3pPSFh6Vldkbmk2L24zbTNCREZl?=
 =?utf-8?B?WGdNVzd5UlZOdlZGMERpUUluOTFSQTZPYnpRZXNBK2xTZEFGQTI5c2pSN2lT?=
 =?utf-8?B?U0ZtMmhsbHVqYkNFRjlNb1NHcEdaaGV6Y3JldDJlNFN5cllnNnNqdlNia2tE?=
 =?utf-8?B?S1FacG5BcUJZeE92aWpWSUEzSG5WTlVtbW5zQUorTVh1aVUxL1R5SUoweDd0?=
 =?utf-8?B?TUxJS0F2WFVUa2NVZ1VSdWZRd1l3ZitSelZNMnJkNEZCckpiNGR4a0ZHZjAv?=
 =?utf-8?B?c2trUVFEcTdtNzVmN1lEc25GZmFZL0hoVU93QVZsZURUMzdvMVNpZnhLemVO?=
 =?utf-8?B?YUpzNytIT3RRMWEzUmVoMnN6MGFaQnd0VUcvOWd2akRnaTQ0S3E3ZnBqUUU2?=
 =?utf-8?B?aWlkb3pHZHFjWjV4bm80Wk05ektYVmtEd0YrdWJscWhadVVKQkdQZDlZWkNm?=
 =?utf-8?B?dU1EbzNGVnJ3d1IxNlI5aDd2WHZuaVJUMThyWU1uSlg1Um5UU0E0TWtNbjRz?=
 =?utf-8?B?OHNPY24veFBEcVp3anJGYzA3YU5nU0hEQk9FeGhpczYwOHdpM1FlM0JJYWdF?=
 =?utf-8?B?d3lOZmJZbVdkcVFMbFg0d3lnRzJLZEF2d1dwM2xJVHhIYTBYK3dZVW1Vby9Y?=
 =?utf-8?B?SU5lV1dEVW5Fc2VQdldla2JBb3hLN2RjQU5vVnMrUldaVlpKenhNTjNnN0gv?=
 =?utf-8?B?RGM4ZWZ3dWFTdTJKUkV2Q0V3eDVJcU9pRUdIRUJoZ3ZHMUpwdjh3VjRvV0N4?=
 =?utf-8?B?REdEUTNJWUE0NVhodno5aEtjRkY5cEdINmVDcjZqWlc1dUJiT3JKb29mR2Na?=
 =?utf-8?B?RGUxeTRtZlE3VUFUSlRac0YrVDUyMEVqNEd6VXhyczBNUkF3dXdkZzlvZFhQ?=
 =?utf-8?Q?VAk9XzLWvaCaqZx4Fjw2x+o=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	zo25iirQItQtDtoHq9dJOY5hmlINYy+LH2UZxvBdyFbaDEXmsXVSD81qf0aJ4Kmv20dvHZXQx2S9CV0yJZHsV6kYkJViSTqu/Mtnp/xSgql1Cq2p0UB4m31FMaOA0sTLfo+YA1JtFYVF3WYv+EG2+fASx/dSYe3KDf17IX4ycZDMfAY+/O3C1/3VYiULsf8Ty2jZN71VkebDr09k8iOXJ7jjIcNE64o2zh6oAQlVxwbWaqycVfUPnJ4zvH4ipc/SzDu2CVyrDf17A52KdlFVURDtUCKiZFmwSCzoEz45s30eyJUDyBqF//hozsQRcpJMBwxPn0LV8Ovf3eoFDnDDG0a6DaoeEg/Bfoyrm4jxCO0kVDXIzwoW45Tc+VIsCIC1a1J1o7vwDiryRYm3rM3xQQbawXGQ5z3L2uNtf4SBpcuJlAmDvueW/BaM1yrOf1AtHJJPk9S/7fMnb2VS4CltNsI8rI2v2o3TW3l5bo9lTMSuUDRk1S25MBHqxs3TUr0csPX3qMkcgH1aQ9Y79ww+Bdnt+Hp6feRgrPpTrY61ut6ST7Knm3iSWUIMmGUv+KrYIUWCtUxiUbqETegAnVcWNeMWQcmfmD3Gne1q9yqqORg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b42749ec-71f1-462e-5bd3-08dca11a526c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 19:56:00.6055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mJAS1VkpFZfpAor1y35Bzv/uc7udu2ttMXv4ovHnP7yST90avLPGhCQsaRoHmJ10b2/q+Xbj4P+CtVd+39Z8unfXZce4VGEaPz5eZnegi0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6144
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_14,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407100141
X-Proofpoint-ORIG-GUID: K4pvh0BorFZ0zYuAIPYStYSxVM-bE8j3
X-Proofpoint-GUID: K4pvh0BorFZ0zYuAIPYStYSxVM-bE8j3

On 7/10/24 10:10 AM, Nilesh Javali wrote:
> From: Manish Rangankar <mrangankar@marvell.com>
> 
> During vport delete, it is observed that during unload we hit a
> crash because of stale entries in outstanding command array.
> For all these stale I/O entries, eh_abort was issued and aborted
> (fast_fail_io = 2009h) but I/Os could not complete while vport delete
> is in process of deleting.
> 
>    BUG: kernel NULL pointer dereference, address: 000000000000001c
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    PGD 0 P4D 0
>    Oops: 0000 [#1] PREEMPT SMP NOPTI
>    Workqueue: qla2xxx_wq qla_do_work [qla2xxx]
>    RIP: 0010:dma_direct_unmap_sg+0x51/0x1e0
>    RSP: 0018:ffffa1e1e150fc68 EFLAGS: 00010046
>    RAX: 0000000000000000 RBX: 0000000000000021 RCX: 0000000000000001
>    RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffff8ce208a7a0d0
>    RBP: ffff8ce208a7a0d0 R08: 0000000000000000 R09: ffff8ce378aac9c8
>    R10: ffff8ce378aac8a0 R11: ffffa1e1e150f9d8 R12: 0000000000000000
>    R13: 0000000000000000 R14: ffff8ce378aac9c8 R15: 0000000000000000
>    FS:  0000000000000000(0000) GS:ffff8d217f000000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: 000000000000001c CR3: 0000002089acc000 CR4: 0000000000350ee0
>    Call Trace:
>    <TASK>
>    qla2xxx_qpair_sp_free_dma+0x417/0x4e0
>    ? qla2xxx_qpair_sp_compl+0x10d/0x1a0
>    ? qla2x00_status_entry+0x768/0x2830
>    ? newidle_balance+0x2f0/0x430
>    ? dequeue_entity+0x100/0x3c0
>    ? qla24xx_process_response_queue+0x6a1/0x19e0
>    ? __schedule+0x2d5/0x1140
>    ? qla_do_work+0x47/0x60
>    ? process_one_work+0x267/0x440
>    ? process_one_work+0x440/0x440
>    ? worker_thread+0x2d/0x3d0
>    ? process_one_work+0x440/0x440
>    ? kthread+0x156/0x180
>    ? set_kthread_struct+0x50/0x50
>    ? ret_from_fork+0x22/0x30
>    </TASK>
> 
> Send out async logout explicitly for all the ports during
> vport delete.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_mid.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
> index b67416951a5f..76703f2706b8 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -180,7 +180,7 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
>   	atomic_set(&vha->loop_state, LOOP_DOWN);
>   	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
>   	list_for_each_entry(fcport, &vha->vp_fcports, list)
> -		fcport->logout_on_delete = 0;
> +		fcport->logout_on_delete = 1;
>   
>   	if (!vha->hw->flags.edif_enabled)
>   		qla2x00_wait_for_sess_deletion(vha);

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

