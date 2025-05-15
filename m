Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2699225C6F7
	for <linux-scsi@vger.kernel.org>; Thu, 15 May 2025 18:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747332305; cv=fail; b=BoWDAXpCDyPpgVFTx7FOQm26mBf37klHtQDlyZv30MPiqIY+EcX+rXGeB/lo2WlmPvLMWmBrkvg78RO1lpg4wiW7mvMjKe1hv6ru+AtFdQlFITASPSVjERJEd+oFxmSKO/aUn3V6g2xzypzYjbXGX5jfr3aA6tbS4Gyl4q7oP8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747332305; c=relaxed/simple;
	bh=z0O/P+RdV3LbpyqoiEg5s5XEupyj0cAyMZs/UYTU9Rg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=En4be5+UXzLJXkvYgBQtS7/yoisMlycKdWc03nbRXB9hdyLx+rMFc5mWYSDdbG90z/D5t7EPCDmK7q/AbpfU5fs9sZ6ECrG5pj4AaIMSXRr2uUacltw+PYmTbBNztYrWmixnguy++HFrj7JEhMfeQbU/pvDzT6eX+G+8qktQi/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rfslALdG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iVjNscV0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rfslALdG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iVjNscV0"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54FF1ncb028457;
	Thu, 15 May 2025 18:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Wj4np9pSpltg0xvuORx+09ZsG54T3fIhFZ71EZ+iEc0=; b=
	rfslALdGnm6TCRwJ4LLuzD/RH3nMnC4bXlIcmTbC/lORU+Bq48EsDBEKmB4V8t1w
	hzacEVjkKxw2mznDDXwzTeU0DrFB4WWL52sCs9oGJ/HuVfm16rcg9/tl752OQzpY
	eb+027eUVkqcUQEk+Op0QXw/guskAS2dGNRQbFVVXWOiaiFLkBLDeW2TN22025vM
	GlKtRIQN7DU0sEbW4SeAU7VaplR7ozycHIdNRTROEPFwFE2jEJz8yb5ZRac8ve5Q
	z8E7AsHhsJ9hrCY7AdBqRli1e3Z2chfnMi4XzTC11BhjYb1yz8Cw6ozv8J2VxKlO
	3iaeidDOZNJPa82z7yDs1Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcmmuj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 18:04:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54FI2DMQ004708;
	Thu, 15 May 2025 18:04:47 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17010020.outbound.protection.outlook.com [40.93.12.20])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mqmdrwrq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 18:04:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O2mZyXsL/YKgZQ1oBe2w9g9M2WxcDRWiVjgdBiKZh3LxPgNCkeRyQiSUp6qMEivi+viT70UmqH4BXNufrjbg9/bss03XKoBWl3Vo1dLBoO9byjimGZ7HGX+3SDX32ix1pFyuAMwfzP82fQUeFfnzUo9N0gE9yGA+AzBf4c+kzf3N28o3KJHow4ZMVdUC5Lwj+OsOo5EyPjpFyuda6bH2kdXeFoJhw1zgmwZqY5CiPXv5kCDj2mDPgyB2oe/dUBA/Hs7AkJWKplCNFNDtFJjzf3Gxkcg4VgU4mYpVuL96f4OrzdAOgd2YtH7Ymd7mh3Zmjf3nTqnSc8lGtZUo6omhdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wj4np9pSpltg0xvuORx+09ZsG54T3fIhFZ71EZ+iEc0=;
 b=mvIyknpePXSmn/NTTlnJej6i7M2ag3BNlY4dYvyBqV56O1kLjdwTrM4l+oYhSBNP+KbmcaTP4rMrVdjQw7nzKX0QLuXZ8+j6mlBcN4dVN2IlL7Zvr2C8uFdVA6UInmVyPAhIv7Crq4liaed/s1J6J2wz5XC7RFKDiF3UBZK+maoH/bFHe0815XXa30RgQlFmMbs6HLlk44Rqeg7DzcgOmrrXU2pRu/ERDsgwD8shaOwWhokjWae+a7VXPCCSp/J1lNXiPxbE9ixAUJ9rMaNPXnDovR0G/TXSGbaDgYtEnkBtprIDJRW8O2YS/4svz15hFQF79qX0320Q3gATLa1EDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wj4np9pSpltg0xvuORx+09ZsG54T3fIhFZ71EZ+iEc0=;
 b=iVjNscV00yQsvWsVyhR20VkNwTBr6oPfDTJJyBPkyzj5eP1LfWKx1eC29IZ4QOBZiVA5U1zr5epg1iVxgwTxRtkZ5iA4Lf7FEBT8jcGSBmj/94K1RJuCp+V3qgQS8awapyfoVmRUlCzYvRW59ny+nz4sSj+kaAhvfG/EGrACIsY=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by LV3PR10MB7721.namprd10.prod.outlook.com (2603:10b6:408:1b7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Thu, 15 May
 2025 18:04:45 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.8722.031; Thu, 15 May 2025
 18:04:45 +0000
Message-ID: <da0c5ef2-4bb9-4229-9486-c595df25347d@oracle.com>
Date: Thu, 15 May 2025 19:04:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi_debug: Make max_sectors configurable
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250515173537.1024421-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250515173537.1024421-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0402.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::30) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|LV3PR10MB7721:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fbc2316-a28e-4390-37fd-08dd93daf908
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0ZOaXBhcDY1V0kvSmNiMG9LcXI0VGp4OEVYOVpZVDJyaVJpWnhIRmoxQUI2?=
 =?utf-8?B?WEM4OHMremg5RFBySDFoWE9GWlA1blNRb1F4by9FRnByamRlWlNOR2Z5TTBX?=
 =?utf-8?B?MkYzOWVzRWVPUGZiWThBYTNhMTVUaEtub2Z5MDE3aXFIak5CWmhnSERYdjBP?=
 =?utf-8?B?STRwbUNRR0l2MDFtcDNVNTVZRGhZOEtMNW5mSDdRSWZJZ2ZMaklFSlJRdXFO?=
 =?utf-8?B?MVcrWTdLYWtEYmVpRzdKc0puL21wVmxUMVBCNW1iOEF4L0NSQTJQRFJCODZ5?=
 =?utf-8?B?U2htRlo1Y1RGTklGRGRCSk0zWTB6U0p1bUttVy9LeHZRY3k1NG9Id2JFNFdQ?=
 =?utf-8?B?WFo5UDkwUWdzNzdNcVRZL3JRb0JPdWsweTNpdGdvU2MxWHJQUis1LzdJTmlw?=
 =?utf-8?B?M1Rnc09SNVhtU2xWaExZZjJ6cjhnZVJqY1hvVDBOUU83TmhydGQxaENoS0VJ?=
 =?utf-8?B?akhvYXR5QzR1dHdNQkgxU0JIK0hnZjZjcGlhelJienA4RC9Ed3JnMzc0VDhQ?=
 =?utf-8?B?VW0rc2IycTA3c0Zpd3hXa3BoTlZRVXM4akpnVCtiSEJRSGVxWmVBMU9pek44?=
 =?utf-8?B?TTF3QjZneUxKbC94S2d6VUliVzJmQThxaE4xU2k3WGo4eis3eU0xck45Ynhm?=
 =?utf-8?B?dHhLMS9WOVAzTzlXK3RvdEVGWGFkdGFHMjlJWFpmeEZwcWpjSm54VkxPeHU2?=
 =?utf-8?B?MVhLSTNPY3I2ZzhmaS9WSEExVVZvZk5tajQ3a0tYaEdIMVpQNDQxSHhOK0pZ?=
 =?utf-8?B?dUpqQXl0V09HY1dwZUNaMDlzTDJueElHTVBVL21WUE1jSGROK2hwVDRFNmUx?=
 =?utf-8?B?UFp6c3ZqeWxCb2U3cHY0UFZySzJSNHFiYzI1YVpmdDNVY1NKVWYxYzFiMmhx?=
 =?utf-8?B?Z0J0bHpvaXBGNElZUVJVOFRJZi9JOG11OFZqMkdaci9UQXloTjI2Nit5NFN3?=
 =?utf-8?B?U3Uya2NlL280N3VMSy9uV2xHSlh5SS9tU1BDdEEwMlE5OUVLdGxvUmFDNERG?=
 =?utf-8?B?Mmd4blpEWUdzQk9Cb2ViS1N6Q2tnbnVRUE4zUHJLd3Y0OFdLeGxzaGZrSUZw?=
 =?utf-8?B?QzJTM1VmMUVHY1NrMnkySWhVOFVBcm44VldiY28xQ1NocmRvaUJZTjN2ekt6?=
 =?utf-8?B?dUJNME4yVnExWGZxcy84T0NwZ2FkUnNnTmVYT1pDSEZUSnZDbDJsNHpRc3Vr?=
 =?utf-8?B?TEVCYlZsZ2pDNjYwZE1kTHRRVjUwS1RiQWlOUTZGdjc4ckQ4RFRUT096UXNt?=
 =?utf-8?B?MndVT2pmOU4rZU5UeXdvVVhPdWRHWFRxNWlWK3VTQlI2M1RqZVZrWHY5NnlR?=
 =?utf-8?B?cUZNVmU4aTdFNXRUais0emg2K0VCMzluMVAxcFFZM21HREFpNjZQM05Jck9H?=
 =?utf-8?B?eDl3eUNzWlJNUmpreFQxU2Faa2JKVE1QWUVHTTZML3pyQzdwUEdyVzR5cHAr?=
 =?utf-8?B?SjZUUVJpWmU2M2t2ZHBLcnNiQ1l6Yi9NTzN2WFlsZWVoRUFtb2gxTWw2TkRB?=
 =?utf-8?B?L3hKV2MzN0w4VHlYYjk3U3R3bjRUelJFME5rMDZyeStUTTNqaTNNdDhrdWZw?=
 =?utf-8?B?QnBlT1hhc3RJSFlJeWx3MGR2S0JaZGgwZ3FBM1Rqa0pHQXRhcHY5T0thaWtn?=
 =?utf-8?B?Yzg3bHR1bm1PblpwTk56T292T1VSUEozd2UxYnVuZkExTHdSNDAxNHB5M3dO?=
 =?utf-8?B?R3RlQU45akRBbnRkU21mbEI0Wkh5bVQwVC95RzZ6YWZSUW1IWlNKdUgvZXRY?=
 =?utf-8?B?aFpTVzVzUFlDYW5EZXBkNnEzQ1hYWUdsSG5QdEZEN0tBb0lYWDAxeldVTjI5?=
 =?utf-8?B?NzAvWlZIS1E0eUdKeHRvd0x2YXlZUDZUYUpwdzZ2UGF0VzJnYUxBT2luUk9G?=
 =?utf-8?B?aXVqNlNBR0FpVTYwd2Vvbmpjc2JCTjVyU3VPZnh6Uy80ZHV6amgyZkwwanlK?=
 =?utf-8?Q?RWjVf8Hk9bA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SC9YNFhEcTY1ckFsdGp0M0t1T2lHb0hIT1Jia1hvUkxwa1ZVUlR5ZVA0SC92?=
 =?utf-8?B?K0gva2M3QWVsL3RlaG9jRzdHdjdLNFNJWFlRdDFERkVBbXNOZGpkWW82ZzNT?=
 =?utf-8?B?OXhNT25LbzYwSVZkY0Z0WVU0bXZ0RmNPVXljc25neENVK0YzNkJmN2oxTDJk?=
 =?utf-8?B?R1pJUDdLWmlibzNYMlJubktUOTNlQzZlYVg2V3gzeTQvODJma25IeHR0YUZC?=
 =?utf-8?B?SG9ZUTJSU0xBUjdBSUR5b1B1Ukg1blhMRmpPbDJZTEdjSFpncnBiRDNlRndW?=
 =?utf-8?B?Q2lZWGtIeW1Od09XOFhzVnJ5Tm9oc1ZhRFlUY0lBaUtUckVvMjBJWmk4ZEpI?=
 =?utf-8?B?T2xYc1hsVXV4dzRxWnlDbUttRnRacWNsaVFubVpPWTc0WXhSQTZTclEvRC9z?=
 =?utf-8?B?RVhocnN5WEtTSUpjRGdJbHcvbXkvL3Ezbk82TFVYMHNWUDU3NDVHZGt2OVlt?=
 =?utf-8?B?dmNCdjRWZ3FxWHplOFFoQ0lXM2RIQ2d6aHpMYkJnamRsT2czR2tVajI4VjJu?=
 =?utf-8?B?R0J5cXFQMUpnSWdzekpGL2hJMDBuSHBLZ0JkSWxmNk9WWmVwZkV4cDlJM01y?=
 =?utf-8?B?aEdMbTQxQmwwalZJUzRaRGxDTHJBYXZQZWFDNi82b2pWZ25xQjFBQVJwYlM2?=
 =?utf-8?B?YldkazRZUm1XMjA1MFFIVGlGaGZCR2ZPMFlLOHdrS0ttdUZoYkFwaUl1MmRh?=
 =?utf-8?B?MWRGdGUreFVGMDduM2hPekErbDdHVjE4VWtWazBCUEQ3M01QUitOcVFGa1dN?=
 =?utf-8?B?NGYzc0Y1VXI4YkFzMHZqeGRoeEwwSGlZREgrYkRVTGgzZjNmTzFmUFI5Yndx?=
 =?utf-8?B?WXY5eVZmaEh4eG9iTVFQMEZ6bnRnSzloTEU2Ymw4WUc1eXZKNjdFb2RjOVVU?=
 =?utf-8?B?VytGTjFRSEFGSVBwbi9MSTN1SUgwZXlzUXhhNXVyWm9Wbm4vYnkrcGZJOUcv?=
 =?utf-8?B?YzBMcG9JTTNjanJ6YVhtVlQ2SGlYUk9MbStqS3pYZVdBd1pPb2RMRUxVeUFO?=
 =?utf-8?B?eTdFOHlBVjdTd01JV0U2RmkvbGlGUmlRTGhWK2x3c2VkaGsvS2VHbjBkTmFS?=
 =?utf-8?B?L2ZxdmdFemcvQUhSb0JETVJSR2x0c2FIcncwN25zc0ViNjJRQmJYY3JiYXp3?=
 =?utf-8?B?OVFZbDVTVkNZOEN6Ymd3U04zd2Q4cm4yRSt2R24ydlYzVzFLTVhYMFAvREtD?=
 =?utf-8?B?ZDRlV2xlRTFualJ2eWFXd1l6em0wcHFQZFd0TXJHeUE5Q0o2emh6VnpaMEps?=
 =?utf-8?B?eWRXTFpRM2tibHM3Q1drUTUrS2pVVkZLcEFNa0FjaUJlZlo4TWFpdzRWVkRF?=
 =?utf-8?B?UnVlWTlnRnpya1o4T2FiK0c0dkFvZGc1c1h2L2hPa1hyc2lZeTZGdm5xeHpN?=
 =?utf-8?B?dHE1NVpqRmNyMmxjK3FsWFZLVzF3cDJjdzk0TGRRWFdNSHFWN3ZnUTVCektj?=
 =?utf-8?B?cWdOaWFTVDZ2Z2FOQXk1RFVsdEV2WWF6bFpkTThvSE1xRjR6YkxGUk9lRHB6?=
 =?utf-8?B?TUpZVkd1cEV3ZWZaOTA2NTd0eDBaT082RGIxTFdSL3hnOTdZbUNSKzd1TFdE?=
 =?utf-8?B?YjdoQUgvd0orY0U2R1N4VGlidHBOd2h2YjlhVnN5ayt0TzdwYzNSRDRRL3FB?=
 =?utf-8?B?cHpWd1haWDlRMEZBVzJabld6VVlWcHdQdmtGbitkZlVERFZ1K1NQaDk1UXVD?=
 =?utf-8?B?WmFUMmJvbnJOeXFtUmswT09weTBnakN5aGErTDUxUXh3SUlNVUUwb21ZNDMv?=
 =?utf-8?B?NXk2eFNzeTE3a2x0Y3JCUW5Lbm1FVEkwUFZiS1dZZ3hSc2hZSVNqelhFZ0w3?=
 =?utf-8?B?L0laclRvMk5TK0NwcHNPWEFLcmxpc1N1YWVLdmRCSU1Kd050eFRVRHVkN3M3?=
 =?utf-8?B?ck1BaFZNVDBUcFR6NDcwbTEyNkE0a2Z0QWlIdERjRS9ZcTRrVFY0UUFSZ29D?=
 =?utf-8?B?cHVLMEc4Y0VRcTVmZmFoS0VJMFBsVFVpdit2MG1kSktoZXZXNk13QkNJRDRG?=
 =?utf-8?B?WWpTL1hrQnBXOThENnR2RnFhYlVCTzJSbnRJbXpkWnVUbzJYRURnRG05bWM4?=
 =?utf-8?B?V3hwKy95dDNmeXJkbHhyWEFaY0ZGZHFtLzRtWEJsUU9tZTd6ZWg1SSt2aHUr?=
 =?utf-8?Q?XlqcJzknHhztdmP56NiuUkzNI?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	26d1+0rW348OUO5c4uO5JzdwMgRcSYjxJhgs1Ewfbt3v/CNc6dk3fg50Rg66KciuBR+gDiqunN5WuVLXV9QV/DOcS71mKlOQF5zM/upeC16d2fdtbmYuQQU/5O+mTS4Xpui7m1qewI3oiGyhcuXw/X4dRHchB+oenIE6hVxT1PkBvku7QQDJ59IwE5pBQaVBkXbTvkziIMv88ae9OjPasizse7xqIUytsw/Y34W6HdRE6y2eVi3+kBDoHi1PY0mKXO9pah6Jg1a7CJwK1iYBfdSC8ZPRzAYO18D+3UiubWWjs0WK58dlShnwlmyINbiXTVKjgfoOKXoEa0zyw/GTVq77zD/NqJqJxMINA6F/2OV2dOWHac98u6smveuIi7hdWH+wKzr3fCOkI6cqSu7c+X12lUwIWzgHFOC1oRG0VUK1CUrGTMbKcacJKOBfIJSf92D+eakXD+Lv3U9eCfvc5x4UWfB0Xmo2LrdjXfWU9z1FKMlN5kY07LcNGPCZCc5ZJe0M5CbpnSB5d6lfTyycRJ+bfZnSjQP52TsAXxBiWUaBVJSRv5Rrs3yjcKvSxmDSuM1bRsU4T4E7/+XM2pan7WxXn+WjsYYMXIB5875c180=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fbc2316-a28e-4390-37fd-08dd93daf908
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 18:04:44.9078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PW7ZyLqSqhIjQTubZWWs13vkOLVi4z4v/K3lULk8d6j10GXrIUwM7W4hMfFJ7FJ8ZGqhuRjzOIVzpDFsOnoRLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_08,2025-05-15_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505150178
X-Proofpoint-ORIG-GUID: oZKP9Gi9lWuf5H4B_pucBM8B62DPFYJ_
X-Authority-Analysis: v=2.4 cv=f+RIBPyM c=1 sm=1 tr=0 ts=68262cc0 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8 a=jSF7fvFO0SBUk0cnFk8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDE3OCBTYWx0ZWRfX9IIF4KtSLawQ KmVv+sahTz3zime7ZPBGBE+DAvIhloCCsoSS3HzGir7CxQmtJhpnc+bQN9/fn6d7cKprVd6TT7+ ZC96msNpzpIBFP9EdGGM26XYzFL1c0a/1Z/+mj4hKLdkYFyFxqB7J/Fn8wm58wTYlXI9ydfn6ey
 zTb4qMMNKHGI4MpFvFFiC9d1WhZ5btvzEI8aDVakwDqvyDPHDuA17etW59Y4zSjjm/eCu8rz4E+ vtO/oSJE5I+VuqgVer/GxMvR7yECWDXRJSxPAV+lvemjRNSIoaTOYHRKSZzEXea4DBn+LZSBfD6 erymWeIuuddjmGGwIXlV1yrrpoQkSx8OcDuMzPSg7RpOxKU6hyeNuJJnonMRrIfq7iXl6QKSrB8
 Z1E/rivs1QdiEPo3ik0kErnt5neDRA8LxsNi6dKty3pGPvmQ2CTPwU3zGpgqPrWbm4CQaIKn
X-Proofpoint-GUID: oZKP9Gi9lWuf5H4B_pucBM8B62DPFYJ_

On 15/05/2025 18:35, Bart Van Assche wrote:
> Make the SCSI debug host parameter max_sectors configurable to make it
> easier to trigger request splitting in the block layer.

Obviously we can do that via sysfs with the max_sectors file.

Is that really not good enough?

> If this parameter
> is not set then the following SCSI core code will set max sectors to 1024:
> 
> 	if (sht->max_sectors)
> 		shost->max_sectors = sht->max_sectors;
> 	else
> 		shost->max_sectors = SCSI_DEFAULT_MAX_SECTORS;
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_debug.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index aef33d1e346a..101a96530b11 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -913,6 +913,7 @@ static int sdebug_host_max_queue;	/* per host */
>   static int sdebug_lowest_aligned = DEF_LOWEST_ALIGNED;
>   static int sdebug_max_luns = DEF_MAX_LUNS;
>   static int sdebug_max_queue = SDEBUG_CANQUEUE;	/* per submit queue */
> +static unsigned int sdebug_max_sectors;
>   static unsigned int sdebug_medium_error_start = OPT_MEDIUM_ERR_ADDR;
>   static int sdebug_medium_error_count = OPT_MEDIUM_ERR_NUM;
>   static int sdebug_ndelay = DEF_NDELAY;	/* if > 0 then unit is nanoseconds */
> @@ -7314,6 +7315,7 @@ module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
>   module_param_named(lun_format, sdebug_lun_am_i, int, S_IRUGO | S_IWUSR);
>   module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
>   module_param_named(max_queue, sdebug_max_queue, int, S_IRUGO | S_IWUSR);
> +module_param_named(max_sectors, sdebug_max_sectors, uint, 0444);
>   module_param_named(medium_error_count, sdebug_medium_error_count, int,
>   		   S_IRUGO | S_IWUSR);
>   module_param_named(medium_error_start, sdebug_medium_error_start, int,
> @@ -7395,6 +7397,7 @@ MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (de
>   MODULE_PARM_DESC(atomic_write, "enable ATOMIC WRITE support, support WRITE ATOMIC(16) (def=0)");
>   MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
>   MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat address method");
> +MODULE_PARM_DESC(max_sectors, "maximum sectors per command");
>   MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
>   MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
>   MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow on MEDIUM error");
> @@ -9465,6 +9468,7 @@ static int sdebug_driver_probe(struct device *dev)
>   	hpnt->cmd_per_lun = sdebug_max_queue;
>   	if (!sdebug_clustering)
>   		hpnt->dma_boundary = PAGE_SIZE - 1;
> +	hpnt->max_sectors = sdebug_max_sectors;
>   
>   	if (submit_queues > nr_cpu_ids) {
>   		pr_warn("%s: trim submit_queues (was %d) to nr_cpu_ids=%u\n",

Regardless of my view on the merit of this patch, we still have 
max_sectors = -1 in the sht - is that still required?

Thanks,
John

