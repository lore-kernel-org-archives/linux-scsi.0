Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC43DF54
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706668645; cv=fail; b=quS9xAfvHKhKPZvJpn1iEvNXiF4YUN8yt/QaIpVKVXwf9Tp2igL2HT1x+/o4XXm5HoQw1F0OTvki0QgI2kf7Fev6nSghnLi7eUtEUx09ewCwqNWv4SqDXx3yYK1zLMuacYsn2/vEVMtTQR6Zhe3azxB0ooTm+dlqPYSC5WdvoBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706668645; c=relaxed/simple;
	bh=LyGLFTY3op7JpC7wI6ac8xTzfKo/6R4hXsjZOm0Gab8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fO5WJboWrGK3I6hwTX0CGo3mTQIqw45XRItyAloxahrrbrUaIoQ1EtG90dr327zj8bNZRgUXXkbfAiNPOVVGp6TvqLQn0zB6H+QXhgnquAJxeIah4jvlw9IzzgLmF9QxFbcrnTM0kIgl2j+Z5G4zuxE7sl83ohwXon5+wUUm6T4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gO8F3qo8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oMaLSJif; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gO8F3qo8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oMaLSJif"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxAul021977;
	Wed, 31 Jan 2024 02:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=r+KuJ2qZ/ZKvkDAjiqUtFTOC/WP1l7LML796tRxJxZw=;
 b=gO8F3qo8jqW1vQX3egomhHOh9UPrhFy4nXKs6iKadFNlrYHt3yicBSgAg1ga+CEqSXYg
 tqzv1Wg9FLlhUn1mKrhexmrHFgwxNTCVwNBVW7EqduSV4iXDhZaHR+OKN8FBzQU3wiy9
 sv7NtC20+ywK/e4tBqg32s3G7NjmPfRRfzpJosfLV5JG0Ulu9N3NBHScrVLI/H+mqq2/
 DGZGHR/Cpm6vwLd+MF5uXNH9kN+FojAV8PboP9uJ/0zBiSeef6pae9eMkPxvrYIBFHR6
 gN2Xp3unSky6TgvpdSO3cnnF3K9FNOVnyyfID6AvEZMz5BmExIOwPOzE2LDfjZY36xQ5 cw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvrm40nbe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:37:21 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V1N5Bm014473;
	Wed, 31 Jan 2024 02:37:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr984bm4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:37:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crwwiEHopcOZOE/w1sAiRMkpaKWAuoUyPEHpS0IKy1WcqHh3H+LELNTUOprvtRrqPTAQU8tuwGtLlrALn00YEqgpVuZx69nIgYpLPUqUzGw770CcVxsjSYJ5MvlN+lqYQPJ4RldqLs5qGSY1/gIzDV1wvNDTt9E78DpUKwnbaKg4vXnf02rTrl4sXjf89itH3bRUK5fIvckNhcidby/3Ia9Yz2rGovRYN16vLDqxPy/YE0DgFHPZpa5ETrgiVEJ8G4nQafw78hY6Y15J2GUFEg/adwRutnmFM9Ns8N5OwrqS0vRazUFmLHsB7UI0OzGs21tChcsblYNRZAisqnjE+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+KuJ2qZ/ZKvkDAjiqUtFTOC/WP1l7LML796tRxJxZw=;
 b=lHIk/Jui+R5X+njPVd3CDTWiQzyz0Y1O7yt/GdoYSKkcL3OZal3czKenA0XbLc2Z7Ut50tW2tjmaqDeTvjV0kTLzF3hUvIQuH0EqzruVINJahTlUjpL9CA5AcCSkyQkZLqXPwMCaozZEnIVvYSGSYC9yQ76cuRvOWKzXgPPDLHVPNw4F6oX0R8C7cKUmlFdxm3yxBcJ0AXaATC1coIL7100JoxIlfYD7tQ2B7+H6x7TruI9hukgC9G/lWx8WzLVeRUOBbAepgEfqBCy0pJFQUCbB0Qr+HjsOR+bZMEiuGaKdb4nWRXXjEePMbm4Xly3ietw32C7idKENtN61KrQPqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+KuJ2qZ/ZKvkDAjiqUtFTOC/WP1l7LML796tRxJxZw=;
 b=oMaLSJifYuBsc3a88mNetu1yn4GXeIQKNo+FjPR8Og62cEETiYWOxPfQ+I1xO8hw/8mThY9ykl+Gifbd06xHmfxxJRCz7p4YA3YNDR7dOLXZci9A9nKq8/P4gmJIug29sVSRbkJVpu3gjDoGfc+/y68Rg+uMZtzMEwkbCrmhUGM=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by MN2PR10MB4159.namprd10.prod.outlook.com (2603:10b6:208:1d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 02:37:18 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:37:18 +0000
Message-ID: <e44dfedc-f085-4794-9357-0bbf7c58dd6e@oracle.com>
Date: Tue, 30 Jan 2024 18:37:17 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/17] lpfc: Remove NLP_RCV_PLOGI early return during RSCN
 processing for ndlps
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-7-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-7-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::22) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|MN2PR10MB4159:EE_
X-MS-Office365-Filtering-Correlation-Id: 66356fc0-d4ea-48ef-a3cf-08dc22058b03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	QBNKhzLRhauIDQTkUvS5Bz8JCmRIMU7N4v1+08fbQYDjasbDGhJRlJlLmTRt/WbfFWPAkMcUnvJKVkMSY2UcCR1XAegP391EqRLuoTVSYGgnmghhtc84AxPxe2YMhp62XjIwIthO5m9qwY/g9Ss345y1zx3KXF1tMEeXnR9k2Tsz4YGpIse8UZlHw36syWhlLAB4eGz91VaSh0tVGGxbkm42s4e/y9wpbOduwZ1YJltHQHZCTrhYq21Vz/AsOW7DpInx7vxzR3HepSCagf/6JehLxEdAXD+rODbfwjQJ6FudogdJGPrl69UOEJeR0hk5m3fW2S3BEvzxk/QMUcVWaoFZbnLTh+c7ZjWQ+hBuIiRJtD4ywC/yIeisZEshXu56sc5C0D73NcNG87W9N+mV7oPCGAnf5XN0MwigvN5eOdYAsSHlNQQlJXK/T+MV3/SR7xTSgCZVJCabGwwFGO1V97ArVZWJFcsXFVmnskmDFoIVibMD8C+LC9q0q0zSqweonU8evnF7S6WIQ8LyCgMOr2oXIi5oaSPXpDOTLaqJ6ISyLvl1SW79RSuA8Vob26bH1aX7saXvJzijxPLGzMUCqPTj9qIIKYZ54bd3PFvuOgGXIKq/HkBBExq7/xra/+VtXpGOjj0toNKn863FJPDomHXBV7iUOvvdP23QAqk69O4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(346002)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(31686004)(5660300002)(66946007)(26005)(6486002)(66556008)(66476007)(2906002)(83380400001)(53546011)(6512007)(36916002)(6506007)(8676002)(478600001)(8936002)(316002)(44832011)(2616005)(4326008)(36756003)(38100700002)(41300700001)(86362001)(31696002)(17423001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?YVNhWTcyc0hjUVlkeXRnNHJKUXplajhxQUF5ZTFLSVJadmhSbmpnVktDRytq?=
 =?utf-8?B?bkI0SEpMeXdrT1AyRnZ1MW8wM2NIQWh6V2dnU3FZV0pKR2FVRk5rODF6OFlY?=
 =?utf-8?B?VEVYSjJQSG93UU9sejNVd2pPYWszQ2dBeVBST2tWcUp3U05TMmRsYndIMFpn?=
 =?utf-8?B?dTV0MW5rT0J4RWtLMWZBZUQxTUtDQUdzZXFBVzFGTVR0YVpjUlErWVZQQjYz?=
 =?utf-8?B?cHRiY01VUHdiLzdWNjYyK0tvcUVLM0cwY3A0M0NNSjM2WVc4cTBMQjV5REVh?=
 =?utf-8?B?NXZuRG1mczl0d2xXR3NZZTZMQ3pvd2oxdS9sYlZSSHZQL05BUFNkNGV3dGxE?=
 =?utf-8?B?S2loWVF3TW9zdTFPSy9OT1o1MTQwK0ZQSk5IU21UT2Z3UTRJU3JHRiswWU1O?=
 =?utf-8?B?TnkzZGZNYUd6K1haenZRcjdBQjBTRnpIRk1qSUwzekE2VEd2a2U5L29ndTl2?=
 =?utf-8?B?U3dnalRsZnQzVzRoWmpMRUswK3YwYlNNbWJXU2dhazM4VXdFVDNDblhzTDZ5?=
 =?utf-8?B?ZEtiQTdjYThMVDhRZEIxcVM1OXFpQndjSzIyaVhRc1dQaUd1MmdTekp2UVNz?=
 =?utf-8?B?eG9lZnFFcWhUb05SQUZid2VyVDhPaWxyWXJXaEcraE9sdFB5MjZxOVBBeUJj?=
 =?utf-8?B?L2poU1M0SE5pUHRCU0Q4eVd4K3NlTUE2ZnVoRUFyaCtxRHhOSVJlaU13eDNR?=
 =?utf-8?B?bktMcVBHaTlPVFBwMnRiRVIzbWt3TXFPcjI1RXhZaFlMbUlCbVo5OGtwSFZo?=
 =?utf-8?B?dFNPRmo4UDBsd0dYbUZ5Z3YxYVFoZ2h5dGJMY0ZpdklkK1NJRnNudmI4REVP?=
 =?utf-8?B?SDBqeU53MWMxd2tYZHJtVHdWT05rWHc3MkhObVZXcFlEUzhXRVJ4dUpVVUs3?=
 =?utf-8?B?UW1jbERDSWQ4L2hKODFObUYxMEdyN3pqNXBEMkhsSzN3WURidHI4b0ROV2Zm?=
 =?utf-8?B?UHdod1l6bFVtOHV1dmRRVTdRTzk3OTg3NDYrcFc4c1RsSitjRFlscWFaL1kz?=
 =?utf-8?B?VXc1SVM5WjNNaWRvNUp0UTB5bjh3b01zM2JoNGRFS0hyQnRkbi9ZTmcxMnZi?=
 =?utf-8?B?UVlxVUl6bmZibklHOUU2NGFUUDVKeW9rWkgzaVFnUHpySmRNd2RqK1d1bURL?=
 =?utf-8?B?ZExKby9Bb2krUFJRNlF3ZlRwK3JpWGdqbFJoQnd1cGtBV1pKWGRISWw4V3Ja?=
 =?utf-8?B?RmppcUJNaDAxVS95MVZUYVZBTmcwTUhha0RmOTF3UTNCRW1mckFPN0s0dTBU?=
 =?utf-8?B?ZWtPc2JNMS9zalg0bElFWUhjVEFHNDVnZGlOdUdJSWgrWFBRWlVCbDNjRFNS?=
 =?utf-8?B?VTBUaFVKYUZvenFjU21NYTFZcUxCeDEzZUk0OUVsa0JKa2d3aEdtZXJHdlh1?=
 =?utf-8?B?N3hwUjM2eE94S0lsYTNMVWl3amlaRmpjQXNwajQxYzQyQnY4azB4MkRnVmgr?=
 =?utf-8?B?UG1RWUNSYjVWekMrQ0RqL01tWjhLZGxmL1NFNjE3ekN3TzZIQ3hlaHBIejdI?=
 =?utf-8?B?TXFBWnFxODgzdUpadlRpL2Z6NG9CTmhYRzRtVG9KeGcyM1l3VlpRNm9NeFdN?=
 =?utf-8?B?OVhzK3JQOUUzOEN1TjZwMHpNZUJoTzlIVXM4VUdtZllkQlUyZENYS0VXMVZu?=
 =?utf-8?B?cUY5b21sMUkrQUxGL1BRaGt5djh3d2R2SVFBYWVXdW92NHFDaWVFV3czQXBD?=
 =?utf-8?B?VTlFcFpyOUtoL0cvSlBoYjlRdEVMZTRYamJmS2pLcFBRZ3JnZ0xJVWtsVUc1?=
 =?utf-8?B?QUZLNHNoRERZdTgxSFBHRCtON0NoSFJqV1lhR0pnMUlXM29Gb1FtOEJZSW5o?=
 =?utf-8?B?UGo3ajZ0UkQrV01WamwxZk0rb2hLalg1ZDUxdG5Lc3F1ZkJYcjcxdTAvamo4?=
 =?utf-8?B?ZFFIQkU3ZlZwQTFQQVp6V1V1L3lsUk1EREU4OXVVL3pwQUdWQmxtZ3RUZWZX?=
 =?utf-8?B?RWlpSUh3OHd4V2l4bDEyNkhHV3FlRm1naEhtTmN5cmhDMGdmVGcxdlV3aWxJ?=
 =?utf-8?B?b2c3MllQTys2MUo0QTRUdTRmaVBaNjc1YWJwdzZqWHR2TDNwbkdqK2NUMzlh?=
 =?utf-8?B?WUFCWk9ncDVvQVBpMGV6QjlxUDZDaWplZVhYSFk2OCs4Ry9Nd1lmQ3k0ZkxR?=
 =?utf-8?B?SEtjSW9XYUJZRWVWVitwYnJ4SnpoWUlIdDBmRXRYNFdpUXFmS2MrRlFxTFBR?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Xiu+fbLdzTAomjASK1avQdqFcBuSca7dBvxnd8JEq+64vqBkPs8qhLeRsNds3ZQb7WXZLCQ6wB2Jm+F10sIVc5A5JXTAyX5EviSzBbsFIYLAxtbX/c0/XLU8rlNZHrRVOLzJUolPwQ0+V1sUE7ka00RqqYj1Spjl4ddRRDngLc/vh/FdTK7YCasTgOmhtW14j8jNOUoJDFnxZx6Rbig1oR9z9E3KWMZrtwt+rMJEWqUGsx7ZC9o5cszU4dBu8uQ8JTXXUmhDZ6rve8QnR/q0TkHVg03xi7ktoYcTEYrw7xhwp+gX0EAuu7VaaQ0f6pYaNB59518CXmjc7xEvTY9BAGKvIKpMyw8DRbUYc4EtoMhlXUBHj6kLmijk1th4f8oCrElsLboHbqagJiZw6L+dLN/z9kG25/FMnX+EygWq04/Ax+flMq1153GTlQ978vfKefXYS9UUU+zkxk260BBPgeU/f5rz8xAWyfh87RjnagpMBuZi/IABLq5ochQERUlQlGJwRE6dN41lI7fIJJ0HVM3wyxTYUCySeUWqrywB79j7/lQtGLD3NXLIvrfPhXeOJKXi4QdZJfhQUzvtL5tML+aTmx9FvZqrbuDHJ/h4i7A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66356fc0-d4ea-48ef-a3cf-08dc22058b03
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:37:18.3797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYl3vV6Dv9cOOu4AO/d4TNMPIB3OjXmfZbR3aVi5NpMNviFRRJnyrRzARM85RlXkye6TtTVQRJ66T/L54vmznz8Riz/zCz/5my3yATVtGCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4159
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310020
X-Proofpoint-GUID: IT5qmqGCKYObEfa3qLKVR91e4zjaCozT
X-Proofpoint-ORIG-GUID: IT5qmqGCKYObEfa3qLKVR91e4zjaCozT



On 1/30/24 16:35, Justin Tee wrote:
> Upon first RSCN receipt of a target server's remote port that is
> initially acting as an initiator function, the driver marks the
> ndlp->nlp_type as an initiator role.  Then later, when processing an RSCN
> for a target function role switch, that ndlp remote port is permanently
> stuck as an initiator role and can never transition to be discovered as an
> updated target role function.
> 
> Remove the NLP_RCV_PLOGI early return if statement clause so that the
> NLP_NPR_2B_DISC flag gets set.  This allows for role change detections.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc_hbadisc.c | 8 --------
>   1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index f80bbc315f4c..35ea67431239 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -5774,14 +5774,6 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
>   			if (vport->phba->nvmet_support)
>   				return ndlp;
>   
> -			/* If we've already received a PLOGI from this NPort
> -			 * we don't need to try to discover it again.
> -			 */
> -			if (ndlp->nlp_flag & NLP_RCV_PLOGI &&
> -			    !(ndlp->nlp_type &
> -			     (NLP_FCP_TARGET | NLP_NVME_TARGET)))
> -				return NULL;
> -
>   			if (ndlp->nlp_state > NLP_STE_UNUSED_NODE &&
>   			    ndlp->nlp_state < NLP_STE_PRLI_ISSUE) {
>   				lpfc_disc_state_machine(vport, ndlp, NULL,

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
