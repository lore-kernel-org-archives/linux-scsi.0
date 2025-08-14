Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422D72E8899
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 08:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755159906; cv=fail; b=J0z0Y9cF2yft/SwokPrzfJo0zn1NgKNE/j5/35uwDWeiDKIvG1Avuzc1DA3Wsfn9nKeMMxEc4NvI82MTbEEhEteakMojewSvhzFcw6oO8rI84Az6y2/Prv6+XPwVTDcah1gTwMa/fPX4VUy+PaEn6H4ZoITaUF+1CcnK+iEqyoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755159906; c=relaxed/simple;
	bh=7LcfpYSsv9bQhhaDYTTTxWPwKA6RukQVA2GTN/YLdL0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=T/LmQ4CL4/aIh9WmxKrzSDfBQ//dV1OucdmqEu4VtEBbvzlJ2N39EOVULsZeJOppqTW72IR/nuYkWbeGdXLQRLJfe4LnmFq3f6G2s9/evGvMGJTnFqrUXI6mL+kf8WeNXk2bB+JxdULN0Ay0UW2BQnGYidM+2uewXuEkeydWvaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TAbyDSMJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ktAEeMH3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TAbyDSMJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ktAEeMH3"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57E7uA6K008689;
	Thu, 14 Aug 2025 08:24:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rWAuCQKC/aLMeS38Qg+3URphySoqalK0VD6zEMDjVH8=; b=
	TAbyDSMJpS2g6m5TlunQu0ngFEykyq8i4i/9Bwqr/yYv7idXmr7PnVPSkpRq6JMF
	3BP4YCsGkZGZFYx/9RmsyPCaAJJFyOOkXv14SqnKdcG+mugmNYDYTRLJ/umIsaD4
	NY6lFPuTgPpA/EP1KJcg+63a+38NKxgM/vimfhebG7k/SeAz+9qA4OfCrK3E3N4A
	4PW3KIYnF7LXDZNY8to5SGqIPOVBXM6yKD2IaLfQwOOruPBS72Pu6MRjQxNwBR1v
	pZ3CsExjl4pzvf5GZPvw9u9kDA+OFAunQp96rm4sfoc5f4mzb7cPbqsHUspVe6Nw
	xm3u4ZMp3IUPPk6YfoKYRg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48h7rmrhp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 08:24:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57E7unKJ030340;
	Thu, 14 Aug 2025 08:24:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvscf3dc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 08:24:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r+IZzV0rjSPiB9KfzTXN5m2fJiO7m5MNLO8hZji/6gkXL/xZAZtJRTlDkYZg4DX1/cPTuOtt/VaoGwDbE5pC1Yc/IkubF+gRS+Kq5EOqgbuPNhCnYvvVTnzYYOWSCYN0jEE7W5vZdKkhPl1ku+LP30jjUPEju11cucevOniQIzD5Dx57vls9TE/1Bv9jc6fB5u9Xaeydz5Fw9hPhs8tDmFOddqm2MgEuCxuFJLznQd15vItPDcYNd6pFDAB/Qw80sGWz5Mb+AyxmFvY+2SLz64EZhF/FLso/XlNLhII7ZXDLJYB5i9oeON5pJOK1DQ3GAprs+wzLesmvJ6ZI6/1uJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWAuCQKC/aLMeS38Qg+3URphySoqalK0VD6zEMDjVH8=;
 b=OsVW1HmFvuFewcZBuy6QuYKvZXOLsg+jBJv6XCtqG/yJgxwHDUsWKtzOi92N67Xk4F8w8Z1Vllc+RAxTlS3yoC0mP6t672mRPmkQne//oYo45kCyBMIJy1n8ysCQPzulAcRKcm7Bf57Z9vbg6UwZERxxChYbHKdwq+t/OK0DgkcopWZvWKGDCKInyHkYLOfqhVdWPAxsmU5J0MYOZgNtMrr8uBd2Q1DZTL+2k8UjYp/CtexN3k4kVHhlWY8OSayIlYQrXWYcpKEUMek6+RWqlSdKyGZV3kig2Gr7QOcBa8SZ5GdRgoGVod4nYJ7QL34NgIUNDsmUiQ1duB4C2rwwvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWAuCQKC/aLMeS38Qg+3URphySoqalK0VD6zEMDjVH8=;
 b=ktAEeMH31b3412oZbdzBixkIWkFDgN4YBEYP4sxWAMfOuwqWomlf729xX41ZWoSwKCQ59wrSJc826fBcNuttYHzlqtcWncaBNFn6kh8N/YmieiDitv8f/ACFhHsEjMqaY2xdi0KhW3PqWePS+bCChmYY7wTDrDdDMMXNNpDwFOw=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH3PPF61A2638A8.namprd10.prod.outlook.com (2603:10b6:518:1::7a7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 08:24:42 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 08:24:41 +0000
Message-ID: <dcb3c431-c9d8-4f9e-acda-a3111bc05c38@oracle.com>
Date: Thu, 14 Aug 2025 09:24:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/30] scsi: core: Introduce
 scsi_host_update_can_queue()
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-6-bvanassche@acm.org>
 <b65c0887-82da-42c7-b6dd-4a42d593fb69@oracle.com>
 <26558c0b-d793-4804-a60e-a21ab7116d1a@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <26558c0b-d793-4804-a60e-a21ab7116d1a@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0484.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH3PPF61A2638A8:EE_
X-MS-Office365-Filtering-Correlation-Id: c0598d83-b819-4106-93bf-08dddb0c045c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?blZmOWdKdUh1VHpEZDFvOEdsazR1ODZIWllYTWxWaWxQeU5lbkk0a281MFlr?=
 =?utf-8?B?MXR6Z21OaFluUGlmMmdyQkYwczJVS05YVHZOcW9UOVFmV1dNeW9QM2ZoVTBW?=
 =?utf-8?B?Z0dXRmNmN2kyeWQ1cXJTMnM2SnkvZ0VyNmdmQm1QMllqaVhFeUVRV2IwRTVU?=
 =?utf-8?B?Z2Iyams5OUJ3Z0xuN3RySCtBbDhuQU1vNE1XT2Y2bDN1bjB1R2pVODRVbG51?=
 =?utf-8?B?VU9LSS95eWcrTEtObGV5czJJN09xcmlOQ3NEQ3hUV0J6Z1JsTzFIV29zRkRS?=
 =?utf-8?B?NEVUbmxZdE5kZ2RUZnU0V1RCNE8xMWdwRWU2K1hzcDlpc1RKK3Zmalh0bHJz?=
 =?utf-8?B?TGNYckZ1cE9DMXErMkRmVktDcVlhUm9iSkwweUlVUmdpQ3hZMHFCaUhJVExh?=
 =?utf-8?B?N1lmVk9QNENTeDJSelQ3OTBaRXRCTFhSdHcwWnBFQzBwUnZ4ZnJGR1lNR1pM?=
 =?utf-8?B?U2psVFY1U1FPbFFkOUd6SVlvYVNNanB4dSs0Tm90Q0dxdEptTFZ0T1R2SUwx?=
 =?utf-8?B?ck9DaWlPWVkvbXpYL2RDMWFmMm1DMldsbDhybmh2SEdkT3RveERrR0xMbUpu?=
 =?utf-8?B?L2c4Y3JXaHZhMGxjeXdrYlpkQjlYM1J0bTc3VUtwVWNVRmRiMUJiNm14V3FL?=
 =?utf-8?B?bkpnaHpSOHZreWIyRGdUdUJWUWk5dmEzMS9iZTZ3NlZIZkZNVVhuekdVdUlk?=
 =?utf-8?B?Sm5DSkNjL0s1dUZMMUpVTGRIcFZmcDUrVTJGbDE3eU9keGpvRXVHOVFxYldN?=
 =?utf-8?B?MmVlK2lWWGxqcklqbDcyQzE1MVNCNjRhZ2xsb0pkUkdRTFVyTkl1eE8yclVK?=
 =?utf-8?B?enFuUlBiK2E3TWFNNEJrQlE1QzdiS2NCd29FYnIxWnlVZi9vT251cXlsaVJk?=
 =?utf-8?B?RWo1c3hIRkNnM1JlenU4ZmdTdEFETlNkcVl4YVVJQ015c2FjWlhIRkljVlMr?=
 =?utf-8?B?TzhQaDZlNi9zSFFWeTZEU25zSm5Na2ROamY2QnAvbGlkY0JxU2ZNRzY3Mi9G?=
 =?utf-8?B?NGE5QTZHdEhLdnBHNlFINmFMYTk4WnFCRFNKc05EbStnMTE3b1hsQVJiRzM3?=
 =?utf-8?B?aUVrczd1VVlLd2wyTldWc1BYNWU3Z3JIWjhTMGlyanQxOWRyMFFkK0xmUzZv?=
 =?utf-8?B?RnFBc2daMWswMlFiQXBKaXVodVNkM1hFM2w5Wm0vNVViWUluT1BMQmhCUm5p?=
 =?utf-8?B?YkwzWlZHdjUyc1BWUnMzMjZSUzRhVXc4dWpTV3c4YU12UnhWcGtwNUJyTTF4?=
 =?utf-8?B?Rkx5VE9CUVRBUHk0ZnlsZ3ROSzVlcERsZ1BSb2M1MXREbVBtdzVqQWlwWHVp?=
 =?utf-8?B?Y0JCWEEvbU9YejFaakdZbStCTlRoQkp6U09hQ0xBL3dFaTFGaDJ2ZlpHRFNj?=
 =?utf-8?B?QVVmQXVsRG5GOG9HWDlaVm1VY3RuekFLWkhkU3pVT0NvUk9KOGl1a3c2RlVV?=
 =?utf-8?B?SGhqY1NyQW5kSkFTUU43TEZESDQxRVZLY3Z2TFdMak9yNXpPQytxaVB1VjRH?=
 =?utf-8?B?UG9jVUZaZUpGRDZFMCtHOE5BREQ0cEUrY3liNGx1NUVzakU0SHllUHVVRXdS?=
 =?utf-8?B?N0plY3ZGK3greXI1OTdIcVB5cDhYTlE4UUlxOFB3dm1OcFFpeUQ3a0wwcjRx?=
 =?utf-8?B?aVFsMk9oM0JvUGVHRHZmVTZxTmJwQmRYekxuS1Y3Zk5vTW92cXVuOEpUdmZ2?=
 =?utf-8?B?YjVNN09icjYyRGhmRjVXaUJlWDE2SXRiRHdodlVQWjNTeUZLRXNnMnJhNTZ2?=
 =?utf-8?B?V1Zka3VVVGdZRUw3MzY5RUtrQ2kvLzlvcVVBa0J6K25rbkd0MEZPbURMWEs1?=
 =?utf-8?B?Y2NmVFYzUG1mSXowMDQ0TnViSXJENlBUWlBFTUc3ZlI2ckJYOVBYSjZUSFhV?=
 =?utf-8?B?ci9IWHZFMGFrVVRDaGpJdytTNWxBczFHbERtYmpGKzNtZ2tPYXd4KzhRZ3Fr?=
 =?utf-8?Q?wN+p/mIQZ5k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFgxVkdDRHV0b0lJNmhNamttTlo5YTBLRUhzMUYzb0ljZkkya0JKdFVTRVpj?=
 =?utf-8?B?L3hXeEhqVjVwdlYrNTJMT1JuUUNWak5CVUZ3cFpFbDlJMUpyKytXc0xnVjRQ?=
 =?utf-8?B?TFhoZzgzQzcwdkU3SzczQTNIUVJ4K3lBNjBTRWJhNFVSNktteDJjaEc5ZEN5?=
 =?utf-8?B?d21NaUxUUE9WNEkwTjd3YVBCaEpRMUNMTHU1U3E0eldvOENna2ZSZCtTRjJj?=
 =?utf-8?B?WkhuOS9SamtCcFAvUmdrZzQ5cXBoVjZLakEySHNMUUtDcUo4c3kzYlppcG8z?=
 =?utf-8?B?MGFhZFJ0WVJCelJIdnBKMDV3Nml1eTNlb2x5UG5xOHBaMHcwbHNIalo5bXhZ?=
 =?utf-8?B?cVNFMExFaXdrM2pQNEJUdTFyT3F0VzdGcENsK3N0MGttaWE1ZTRkS3htTEFt?=
 =?utf-8?B?V2VBSHR4MnlISUV6TWUyT2ZINGxFTTMzZUFUVmx0ZlJyYWtkcDVTWkhYTjZ2?=
 =?utf-8?B?R3JFVUVnVDR6OVB6eGFsSW5Dc0k1VzdVaHpIcUhXZ2dkNjRKK3hpb0xMWFlU?=
 =?utf-8?B?ek5aWnEvR3Uxc2VNVW1wS092cGlYSnFyTGhxUG1jL2dmazRBUTJEdkVVT1Ja?=
 =?utf-8?B?M3V6ZUM1NXFTcWVCOFFpQ2czbXI4YWxvamgvZTFhUC9OUnFoZm9zVEZjd282?=
 =?utf-8?B?UjhkbjBrUGttZS9nU29yVDZZM0VGQnFNT3IzTkZSdW1vVE00N2dCSStFL3p5?=
 =?utf-8?B?N2x2bHRIOWRDZ0RuODJiRU96QU9ya0phRjIxZkorTThRd05TUVRNbDliMDFm?=
 =?utf-8?B?TmZlaWc0U0NpazV2ZWJ4Wm9BMWdjajRHMXlsZWlPdi92aWhFT0xDcC9WZkUx?=
 =?utf-8?B?THVIM1luY3c1UFA2anN1Rk1mandIdHd3V0lUKzJ3L3NpL2wzM0Q5eFkyS05w?=
 =?utf-8?B?Ny9oN0I0TjhlaEZMcGxacnd0QzV5RUxmMitSWGttZXFwSmF5MVFqRGNMNFdj?=
 =?utf-8?B?dHBjUXM5UUNMVCthbEdmV3d2djNabFVGWit0d050RU9lNVIrTXJFQVBKUXJU?=
 =?utf-8?B?VUc2dEFVWGREWXg3MzBVSis0cGk4ZlFseExBaHQxb3RlSUNLVkhjUTJNYUZO?=
 =?utf-8?B?RDBGcVRFdEtMVjVjL1IzTysvZDZ5TVZzR0dQWDFPcDJFUjNudmgrMUpwUEt2?=
 =?utf-8?B?ZkprUVg5VnZQdWpFQmZnc3hkVGUwM2pKaE4yOEJPOFZLaFk4emw3T1NidTcv?=
 =?utf-8?B?UG94Yko0QmdqaytRTzRyekJud3BQT1Q4aVY5WnpMSkc2RzFpNE8wc25QN000?=
 =?utf-8?B?Y2lQV2E3Z2JjbkVNZm5VMDROKzVwbExORlduT01ESWpTZDFEWUxuV00wTFJI?=
 =?utf-8?B?bGNVTEpWZTZubEE0eFhjdWpuSSs2Y0EvQS9GL09BQlo2SHdBa1lVRDQ0Q3dx?=
 =?utf-8?B?Vzh3aytSUTB2NWRJOGJhaEJ2SUlKYkcxTlpaeHZocGs2QXpqbGhXM1ByNXdx?=
 =?utf-8?B?bmRra3R0TXpkVlM0cGJ3WGI4NEl1SlNFK3pmUHRXbXhETy9MMERMSHVyamJr?=
 =?utf-8?B?bkJESDFvcmdVTlo5YUdod2F5djk4Z0dncE1MRmxISjBFUTNYOHFZWXE0QWhZ?=
 =?utf-8?B?OHVEV0t2d1pEUFNZcTNvSStLL0pFWTJlRkg4Rlp0eDVkRENJRHVNSDRPU2pN?=
 =?utf-8?B?RkRaRWx3Y0EyczJ2d0VDdFJReU5Ud01hazU3NUZLMiswYitLM20vblN5Qjgr?=
 =?utf-8?B?UzB0TGEvMEM1djdBOWI5b09QOGxuV0FKSXRiYUpOdFIzbVI5MkRMa2lnVHpF?=
 =?utf-8?B?QlhIY3lpTUNsa1kzS2ozSXI2M0MwcnRQZHppVk1saGtiRHhxRmxFK0xyalRP?=
 =?utf-8?B?ckNHUDllOWpMeEVPKzBFR0JoT2JBS09FNE9PR2Qwc0RRUHhVWFl0NEJQSEtq?=
 =?utf-8?B?T21tVWxMY2krbUlYT2J5cGlESWFxY0RmTlkzOTRvZGVZb1ZDYUozdjV5REJk?=
 =?utf-8?B?TTJaUXZZeUYwNXNzb0dsMGZYVStMNHJvSGNYSDU3VGx1NkVJdUpUdFFaci91?=
 =?utf-8?B?K3lxYVdlZnJPNk50K1RtL25PVytySzB1S3RSc0VSRlBNc21SdWkrWktsTHVv?=
 =?utf-8?B?dG1zRitvY0VFcHA5SHE1UWNEOEh3QlBwcFZKSlN4OFA0ckY4N0tQeXloSkk1?=
 =?utf-8?B?Vnd2T3ZqcHNRM2VLSmppcVg2TmEzMkFqTnRsMU9YeHlDVzJHTVVnSmlRTG9i?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sbmvhGbqUwcSzq7HI9rWGGDMpt7IdFG7remntZH+lcr8R4buPepsbptuq2stN6u0wEH7J4UYQCqsOE7yPETYrsMMT5yuMVhnQHdWHM60a9Ewjo1LBin/v+qabNQFBqrS5K4505E5CHxgnNpK5kGU+vSfneiA7LOBhd3M23EdpCB/Th+KSG5yFqtIjWCyKjL6b7mA//Jd14fFBUIQyhW/rYja7CvFkzwQbLgY+h84pPM3L0mD0U6nadrOej2EGmlIrJyvdhh70xQThBLgJXPmV13+TmFKvzrvLrenPrS33ukMsc0EMa7HY5UIunyslhtdCCHBHd+3NgA/q14xRG4LVrEPtWaq/73dyrORzkgTuZD5BUkQhkk+Pbr7koVt5nhA1Ts5XjVlNDKI9Y6UWPgp+pcwQxvqZTTtAXPjNhBUlLw05IMiwyKp4wB4ZZfXAYmuYnVTyLTvt1aj/FOZFovx0jslgGL75YXW1MaYZ+6B9s41kGbMhtGak6y4rYR8L5rJj5v7vwv4iF4oeDRy1gLMlV/jrholITO0aRaE0S9qUdF9UTv4d9hlYyzw6uon5wcaVHuNOLSbTpRTgPYE4dYun7ayFDxyVEr1bpSZkh4RCow=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0598d83-b819-4106-93bf-08dddb0c045c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 08:24:41.7597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5pEdB+7YH18HbDGTE6pci2DqgRqHfoItIo9eZhPyaWerEE7kX7GZhX7pHl0LHYG6qezyBGKQlMkhPPtCHzTTRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF61A2638A8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508140068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE0MDA2NyBTYWx0ZWRfXw7fUZCD3Ptsw
 74rbwuWQ72JOxj4aZTAiU/67np1Ro64I0CAzSp0I+a2mtBUNR4YWZKNGDoH18I/6pPWVbTbJq0a
 qZsYrwpIEtsKmP0zMgiTzdAzPaUB74MZidCOGuF6ayllt7DwK5b+bDbUtRqwEOSSJ55vhHHRNGJ
 FsSBUf8N5SG0Adq7e8Xf8z7eA1uxSXq2WNpHfZrs2Wfn658mmb41D8fNgio2M2NwRQmiRN94NeI
 hF9yG7pzQprPWqjopI8Ur0xMuQp85sMxFyE7UWHVIOoSEJdcpu415JYna+ARvHCuriGNwRL0dBj
 unTthUkcyy6FRAfRwYfOa3kAk7nGtBJ+lMc3oV6W6GFbxtklrZhwPHHyhvciXVL/wTckHg+CM3C
 du5iO8rzfyk6qjt1y/QHMWPh9cazyCZP9i0aeNQUJ9K9WL4gFNpEhAphM1NIQ3LZwAWduSUH
X-Proofpoint-ORIG-GUID: 4qCyQUhxxaudLRfvt3fi83d6VG4OfiD3
X-Authority-Analysis: v=2.4 cv=UN3dHDfy c=1 sm=1 tr=0 ts=689d9d4d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=6rIem9AlwNQ7D8b6-K0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 4qCyQUhxxaudLRfvt3fi83d6VG4OfiD3

On 13/08/2025 16:23, Bart Van Assche wrote:
> On 8/13/25 2:47 AM, John Garry wrote:
>> On 11/08/2025 18:34, Bart Van Assche wrote:
>>> If a SCSI driver must use reserved commands to discover the supported
>>> queue depth then the queue depth must be initialized to a small value 
>>> and
>>> must be changed after the queue depth has been queried. Support such 
>>> SCSI
>>> drivers by introducing the function scsi_host_update_can_queue().
>>
>> why can you not just query this before allocating the shost via a 
>> direct HW access?
> 
> Hi John,
> 
> Hasn't that already been explained in the above patch description?
> 
> The only way to discover the maximum queue depth

To be exact, do you mean the device or the host? I assume device.

> supported by the UFS
> device (bQueueDepth parameter) is by sending a QUERY REQUEST / STANDARD
> READ REQUEST to the UFS device. The current approach in the UFS driver
> is to reserve one command slot for device management commands, not to
> make that command slot visible to the SCSI core and also to have code
> for sending and completing device management commands that duplicates
> some block layer and SCSI core code.
> 
> In this patch series the choice has been made not to duplicate any SCSI
> core / block layer core code. Hence, the SCSI host is allocated first
> and the QUERY REQUEST is allocated as a reserved command.

 From my limited understanding of ufs architecture, we have a ufs host 
and a single ufs device.

The host max commands is read in function 
ufshcd_mcq_decide_queue_depth() and only MMIO-based register accesses 
are required for this.

The ufs device max commands is read by sending some query command to the 
device. This is held in hba->dev_info.bqueuedepth.

In the driver, we seem to combine the host queue depth and device queue 
depth into a single value, hba->nutrs - see ufshcd_async_scan() -> 
ufshcd_alloc_mcq(hba, bqueuedepth) -> 
ufshcd_mcq_devide_queue_depth(ufs_dev_qd)

ufshcd_mcq_devide_queue_depth(hba, ufs_dev_qd)
{
	...
	return min(ufs_dev_qd, mac); //mac is host max commands
	
}

ufshcd_alloc_mcq(bqueuedepth)
{
	...
	hba->nutrs = ufshcd_mcq_devide_queue_depth(hba, bqueuedepth)
}

And hba->nutrs is used for the shost->can_queue. And that is why you 
need to re-add the shost, as the hba->nutrs may change after querying 
the ufs device, which can only be done after adding the shost (in this 
series).

Am I correct so far?

If so, I just don't know why the ufs host and device queue depths are 
not handled separately like other SCSI drivers. That would be the 
shost->can_queue = ufs host queue depth and the scsi slave device qd 
would be the ufs device queue depth.

Thanks,
John

> Existing SCSI
> core functionality is used for submitting that reserved command and also
> for handling timeouts. Hence the need for the
> scsi_host_update_can_queue() function.
> 
> As one can see this approach allows to remove a significant amount of
> code in patch 30/30: the entire ufshcd_wait_for_dev_cmd() function is
> removed.
> 
> Thanks,
> 
> Bart.

