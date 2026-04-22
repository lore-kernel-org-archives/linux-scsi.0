Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ABF3CB2E7
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 18:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776881228; cv=fail; b=FQh4y6FkhhQ+m4yi7FbY9MHf3k2zCgdGE8ewlREwGmAIQG+cy8qqixkMrfRtD7oFUETVPRDPm/5GFROPdIwEdDn2h13k/qwSA0M7JlpHHRUtnffYWyjHwcw9hQGw97w5efsRGVsWcsua4rLcTknRSpjGZFZkA1Fj/aF7qYHkUZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776881228; c=relaxed/simple;
	bh=ooCfMEKX4Zwi4mFsvGNH1Cpdr9l2MKXBKtBm+LWz8rQ=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NK0ipblE98w09hnm1UrcTkyx9gRRCAqZuu/n+vk5fdBn746TbMvO5lvIi5Aw+a3S8iwWUh/Fn/NWTkk41poNFLRGqLnzFn5fgkAGgcfA8aQ2rbAdM06jjbqmoRcfvWVCqQZABZO1wqworeoB5wqwXt7HBR9gk0NECpnsun2W8dI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JvPYF2lu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Xfc/TTtE; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JvPYF2lu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Xfc/TTtE"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63M97HBm2337294;
	Wed, 22 Apr 2026 18:06:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9sUsg5+dP7SBxcTy5Hec9CNoBlfhMJlEPviMtlfVTGI=; b=
	JvPYF2lu9eTsk38W8ZZD3BzWqWO9Y7V5hu+QGmpdBzAN/hcoy2gvm3+LQvprH4bY
	V1wx4J+/zNKZO+dx+0exlchFcd+DHZWUpD6tTllfUz0fn8fzKmySNQWOxsQRRdIb
	J5jqLp8LdAdMVE0VdWOOPfWJL+zhfcl0VC06c2kjUWsjBARYTVJf0hz5A/YySz/a
	iTI+qI9OUCoYvCfEr9GAnH4PMItKKATSg0El9WjsgWaY5LCscZZfBn9DGTZy6R6O
	VnH4VDinXEtJsOzdh+GmSHilW7CSjjc099EgzfdgC395wR5tl3w5wMReM00V2sy9
	1dTS1aykTpfl2oRbJ5rSsg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dpenmsw1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 18:06:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63MI6CaL010070;
	Wed, 22 Apr 2026 18:06:56 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010054.outbound.protection.outlook.com [52.101.56.54])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dpjjf2n2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 18:06:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Phi2zcYmoHEyXVhlweMRYCYvQOeuagHDtuYSEWVQMywDU+p/s3li7XvYbl1LnqijtWQQ/jZVsw4ifcxS8FSCaXwnmnyAEzjWQ44cfsLUe9/M4ufxdHCa/Xuip4GRIAuf243FayGMRb1AmXvH5DxEM3N1eDvQU870JpUL7vF09gXj6+ABWT0MngDjjCKijkWdGqLgf8D+kd88MnLpslw2JOxh7ZD/gsSp0/x+4nOOziLxj2Wgbhnno98WPVNEP6cSFXnyas1RPBzEKkonbmB0LDt9jOHPH5YcsptiIahIC8QpIsFpjSdiY9xuoU1vtrnv7obsQ6jf7Cjg78mU3a/V4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sUsg5+dP7SBxcTy5Hec9CNoBlfhMJlEPviMtlfVTGI=;
 b=n9ar9vBAACxQBaD1hIaajZSgPy9VImcR1t1b1Fe+KDRzTVsnsP3HXs/0we+VBk7P2eZRPlewSv3s1H5I/MURT1WE6hSFTKFmzC2sHOAuvuJXAHxua7IztPXAhL7ix6LsWnIEWtVA7KpMRLPMr43R+ZWQYqVEHBm8A7a6NPGgA4WqEOBKfn/WF+SK97dBCKHFJ9EtoYi9NQrqhAfrjfW8mHinbJ9mydo0wJrA8CODVlUvxmG83kVo+KZ3yjC/f5IPWeOHaYjk8dE7f3qGVBci1KAQlTtDrWiLtxbEMW7nqgXmisDY5tp/5cPDge5RnAuV5ph5U8pqa7R3OcgvcDFXTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sUsg5+dP7SBxcTy5Hec9CNoBlfhMJlEPviMtlfVTGI=;
 b=Xfc/TTtEbkEcGVs184MGw1vDuRTUlrnp7Ix8diPdPE5aqOKS2dECRhjt2mOOGRJqXXkQOXQxtQ3rNPDSqJ7Id5p+3COko6NKEkrC/M9tkFtS+7zKJcHtYoE9+UC58u3pJQRFYfJWxipKD2f7XVPwfb0rr2K4KYh7KKRFeGmtyN8=
Received: from PH3PPF8C8C3D129.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b6) by MW5PR10MB5713.namprd10.prod.outlook.com
 (2603:10b6:303:19a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 18:06:51 +0000
Received: from PH3PPF8C8C3D129.namprd10.prod.outlook.com
 ([fe80::6b83:fd:b694:9db3]) by PH3PPF8C8C3D129.namprd10.prod.outlook.com
 ([fe80::6b83:fd:b694:9db3%8]) with mapi id 15.20.9818.033; Wed, 22 Apr 2026
 18:06:50 +0000
Message-ID: <05b125e9-081e-415b-aa12-0ebb2c9529d1@oracle.com>
Date: Wed, 22 Apr 2026 13:06:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: Support scsi_devices without a device wide
 limit
To: Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        virtualization@lists.linux.dev, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com
References: <20260417230751.117836-1-michael.christie@oracle.com>
 <20260417230751.117836-4-michael.christie@oracle.com>
 <448302b1-3950-4e6d-ae8b-337cad09f3fe@suse.de>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <448302b1-3950-4e6d-ae8b-337cad09f3fe@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::17) To PH3PPF8C8C3D129.namprd10.prod.outlook.com
 (2603:10b6:518:1::7b6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF8C8C3D129:EE_|MW5PR10MB5713:EE_
X-MS-Office365-Filtering-Correlation-Id: ea7defe4-7147-439e-7a41-08dea099ed45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	hgxL7M4OE4bnIPLXFXGNPOB+3K9jsWAqi7gJsvl5sqPGP7/t+V247lz4Xv/SVG9kcptX1y1OVPnYZVpHTQoqqQZLQFi763voAGiH40DpPuQ13zjR+XM/M5csjrkoI0utKnZiPMLad/aMlceOU0PqIouElclke7XJXr9tyfUgsCq6Ucj3rWvvcrXtyd6TwnsrUbqN4WTmQopUhadr9BnpoDMLwmLdpI1wxCyh0pgeODeIewIUBSTZ9bjwg1z9GR1rYL52j2QCZnRcw9JSFukdJ5QFggAzfU96+/5pvBq5gE99JkzZGS353hKHY1i48iSqr+S6mqvCPrb5vL+RpNn9frTaaCRoZdMCBJsqUFVQlwnjwA3gqd1R8yUhrJK/3Gb/GAdxBApVUHWI+Ad3I0/wp9N/AwpoNTgSr2HKlFXFhQQEH4vSRk1zaH45Pa00Vfi/rOqf6OTJDxRoj2sxOpoyk41sXRs1RfYHoub3pXY59nzA1qSVPTXG+OFvzLjzyESjZIPNgH3YAyaiMrlZyb++CSJMLmECKQ/O++ihsnh8M3jTlQW0cgTn1KtFqkZ9CB1++J/XSWo8I+wIOXIlyNWXUc2Q3rNy30+b9rfTzdwQ8qOWrWDfiXJ5IG8RjnBejg8XTpGizVTG69p3TVLsCVWD18v5qbWdsl6OFqD3bIn3qvbPjI/1BupF1y/M1Szt/twY7gmG2vOc3vO4v3eSzeo+RCgK1NB9jevih+yinDdukfQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF8C8C3D129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXBTeGZQS2NZV25wMFY3UzBOQitxbzF0UkZVSGVQbXdLejUrSDdRWFlkYTZi?=
 =?utf-8?B?YUlualJibStndXNJRU5MV3l3dGJpM2hvTG9CUFZHQi92dlRWZkNDa0xoRkx5?=
 =?utf-8?B?VDhZYUsyUzY1SlRlV3JNVGJDcHREamh5cUpuNTdlQ2F2ZHd6L3ZyRUt2eGxJ?=
 =?utf-8?B?Ri9VbDlON0cwaFprWDZSdEVrYW1ZTFNNS2grU3NVcU5weUh5MkpjWS9OOGhM?=
 =?utf-8?B?UWdYWThGK3RPLytEVGZHS3JxUU5YaHVER3R5Z2dTVjBrRWdHc1dGUDVSdWZO?=
 =?utf-8?B?Q0dmd1R6eUp6ZFVKbmlJK2cvVzJKZmdxdnV2dTN4KzBwN2Jyc2R6ZkNrN0Yy?=
 =?utf-8?B?ZXdHRnJEUVVveE4rNVpjR1JXVEo2V3F3VDUwYVR6a0JsbC9PaFNrTlE3S3Nz?=
 =?utf-8?B?ZUV0N1ViRFJ1RTBRQ25CRjBoR3hHZlJSYXZCOVBraVlaamlkRVRxenp6YXdu?=
 =?utf-8?B?T0lYUWdVVWpkdmVFNE1IWGFsait2M2hMWmo2SDlrVEcxeU9KNHNLVElHcXIv?=
 =?utf-8?B?aUxES0dGcm5zZEtuejZMcEF3RGlNY1MrM1FmV1AzVDhORVRuNGdsc1hQNklL?=
 =?utf-8?B?eW93amlnekhJMnVHZ1J3VmltVjlKbzhlMVAzQ2JoUW1ycVl0ZU5wTjlINkd3?=
 =?utf-8?B?MUtaUW5aNXRGSnNtcWtrb1NsVFdwelBOT0p6K3ZkWHRYWFJBNzJ6dzdUNm1k?=
 =?utf-8?B?VjUwUGxvME1oaUVGVjhaQXp5eTVvSHdkMkwwNU1rUG5nVlVDd0dCTWhyYWl5?=
 =?utf-8?B?MDJ5aVVDblNDWUpCdHd5WmdkU2tBWFlVaWFVTGtJa1g2bnNtWWUzbGFRWW03?=
 =?utf-8?B?cERqUG5XOTYwMkI0Ui9qemdzQzg1cE1QQlozUHkvQ1NmOE1uUjBTY0Rwczla?=
 =?utf-8?B?Y0JvaVo4UXpWVDZCaUpaK3FLWEV6T0tQZCtyMEJHVVM5ZlFMQlVJaURPUTNH?=
 =?utf-8?B?ejJiZmRxQ0tZTEhCRzJweUU2cGlTQlZUTHhCQVpoempzc1Bjb2FkSnpWK1Yy?=
 =?utf-8?B?SUpibTk3YjNiUTFFeU11RTQ0bUhqR1Fmb1BReGZ0SUhPWEZ1Sk5OZTlFVys0?=
 =?utf-8?B?dFB6UzZDOFltWklVZ1JzUmFPaEJjeU9uUTBRODgvRnEzK2QvMFZranI5SFBL?=
 =?utf-8?B?ei90ZUNtdjkvdCtMN1VRdXYrbjBaM2FueHJVazh3b3YzS2oyZFlKMFpPc3I0?=
 =?utf-8?B?NFhwM1hGOUpwQlRQdXJOVUFIRm1LcHZQeC84Sm12eVQvUG05R2Y4M0tZWkJa?=
 =?utf-8?B?RHBBak1Sc2NZQTlHZ2lkdW1INlMzdjhlb0k4c3BBZVZoeTdkUWRNbXRSZklO?=
 =?utf-8?B?R3A0dXZXZkp5cTYveVNXMTJjaWJ6b0cydTZaTlptRFBnRElYOXVPYWxDRE9Q?=
 =?utf-8?B?OHE5dlNoQUtDMHptcVhLQVg0N1dQTE9FdUZRc2FraFlOaWpMS01hRXZDZWNC?=
 =?utf-8?B?d093RnF4cy80MGV1RjNqRjNhdkRWK0dsVDIrMXZvcDB2QnBoZ2gxNVhRQ21X?=
 =?utf-8?B?ZmNEYlJtdDRGemJvNi95dEp2WS8yV0NXbnF0STlrdEhzQVB5dnRVRitpaVpq?=
 =?utf-8?B?Ni9ZbTlIeWxETk45L0FtdFhMaDNxQVBwN2VOZ25EcXErVXVaUzNGcW5iZVJC?=
 =?utf-8?B?emFSVkZwdSt2bEw3aUtQbUtLbDhXbXMvc0s1L3krbk1Ndk1ENDNRWDFyVFFU?=
 =?utf-8?B?NjM5SUFxay9ISncwY1BrQTN6V0xTZ2ZPYko4dFhuOTlFWEFPUkJTR2tSQ3VC?=
 =?utf-8?B?VTVHanY4dndjRjdSazY3OUlDMnhmSWxEMXRQbVBJbFk0V05LSmduNHhZSWla?=
 =?utf-8?B?OE9XSmRpV2dVbW45WXBQN09MNXNzL1kvUEFOSDNvZjNocU0rSE82aHR3YTQ3?=
 =?utf-8?B?OTN0cmF3UDJrelo3UlMrME93QXhWOGtBVm1VMWgzMDRncXRRNjR4OHNFa1g1?=
 =?utf-8?B?TlhONWVmOFp4bHlCSHdWSStlZHViR0hscUpkYVRWamVFKzcyR3dTOFdWZkRC?=
 =?utf-8?B?Z1Mzbk9qUjVoa3hsNHJ5c0daOVJ3eVBzR2F4WklMR2U2TmRYdG5OczJZN01L?=
 =?utf-8?B?L09PQStMejA0dXJraFRhM0dYOEZ1RTN3R0tzdWlldUFuSkg1Y0pWUC8xNTFs?=
 =?utf-8?B?NVdheGFBQk9menl2N1JSc0hxSFd1TDBYbXdMR25qNHBKSnhOZzRZOEtJOHZp?=
 =?utf-8?B?MlVYWUN6N0VDblpkVFVCdjZXYW1HaUZnWDE2UFhwM2sxa0NOQk1HTFRyNVd0?=
 =?utf-8?B?ZW9mTkVsN2FrRzh2SUZKV3RoU0ZaNlZnVkNMa0ltNTJNV2xEUTJvN1hXNnE2?=
 =?utf-8?B?aWlRVE0vQW90N296QXJpZ0NjN1psUHBlUjlzdWJPTHVSbEE1R0U4RHM5NnY3?=
 =?utf-8?Q?OwwkBwlE7HatLwVk=3D?=
X-Exchange-RoutingPolicyChecked:
	j+6vDVVNXFZTRdO9qDKzb+KIgGrl4gynsJ5VvNpd5KOL1yjWMsqB/7FlJS7/mu1r9KdgxWLdGWmtYyMeCLueZf11Uv8qulDTWQMxHA46O0nr6M35GTYrnuJAnZbqQPztg5k81Cyy6u8BSDvPPJ1QhU4YLd1gFCYtNCo+/O/5qbWNP+Q8NfNOA0CNILGBxog7fTl3WXJvLVcU67z+6Vu0HOfqMTUpqxqbcB/00bJAuHnoF0zh8K9ve9gSHDwYSWT0wSN4qbUwS1C75Y7WXJvzuM6IPe0+l1uwoiPeYwEOk87ZLe61ftTdq8dOcGDWbDx1OXXIa5H6zP0MDsTL/z0GfQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jKQL6dH15u9MPevcr33RPRSWpxxz1W7wo5fIva8Vr/grslLkTiK8z0hVOkRK+SUHjLyuMJTiOsJTFFqIhOQMwCn/tqlAOWyL+G1l+71aRXzVt6iBaV5IeFLqLukf795afxjas3HhEujyrL9MyUiLGNAIskO9Fc+k5rQVXj1BVCWR74WG380iBfVN0WjAR4amZ2dl6aR3keDlkkT9mws+uBd6p+o4gPJxEz1BRWTXMP1TfjijjOdpFUo2UxBl3DiLzfUiLSPAxAMDgD6WBHf6IbnpvcznUKZ7fZfre5rvKW4Us/AEVg+n+0hUhOqOpgdWkWyvaUX17/G99dWQr0VN8ZE2T2FyTU2LytDanS0E/bqt2aEaRGwMfpuxWA81256f1JjRh10ZdXhpez/oQjkMiysR/ILvKRjUT33uEu6E8ocMLaFJOifLLwzvihVtCfEUGcARAXnAu98P4e7pfd/LCduM1HMht6dNhDlVafjXadfKm5BZsYubn3b673bLapOseRctXHFXbMiSXnfsqO8NfuJD1PhsoiuP308R8WDnqAP5Q04BgAzMV/5COR0dPZuLmuBg16FG3t016ON42KssbJM5o91mYsrgu94Hds4Ambk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea7defe4-7147-439e-7a41-08dea099ed45
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF8C8C3D129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 18:06:50.5812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0pUR0y/LpDfwDsbtioCQc8igLy6dPi7N21WCYNeHdvVLQxDhoGnE4egOa5kla/QN0NZebNtjlLjxJTxgiwPbdXtT3h/xznzgMouZ1wrF8mU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5713
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-22_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604220175
X-Proofpoint-GUID: LmKofmTS1e5zb90xf4veI6nvSHJackES
X-Authority-Analysis: v=2.4 cv=Z6/c2nRA c=1 sm=1 tr=0 ts=69e90e40 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8
 a=aFK6StHWCpoAtPI4IgMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: LmKofmTS1e5zb90xf4veI6nvSHJackES
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDE3NSBTYWx0ZWRfX4a1WHsApCbLn
 d0V6Wi1cVDjdBJSKlgQ8bYdXRc2Fy0iNzNvdazyC2nQVmCMK97Bs2jWShAyXlGPY01mCANEVKWI
 wNNdEh/SoWhvVjmrFwE6CJfwn55w7r+9MdahdsfjCOVeutpMf0Z9LgkdNW1q7xMsz/EmNeiFQKW
 Kbqw5faWqGdiosIRT9cEkNzgQrxTWA5D56MNk8QHZdFPQjLGqkQvD1JVcDQRYAr7H9MUCiUck9P
 euPVo45/xCjyg7A7epqzMQkLZc0dzR/Bx3m10otBi5Qn5y8tl4UwDLHnFWSKV63lkg/FByMEI/s
 FDWvDClCAMTO3KGW5Zz3kSd5zjYOaXshK02I5iwr1Wh4T7T8KZfWxG6IPwgkuimaBGALopGaTwN
 Wfer8HWlNXBXQ/bap377hvJa8wpTG4+xX/POzLMfstYBVCot+0JpPCVlC5Fa4+iVg9T8jYM74pi
 mI4dTm/PAZl6gchXTcA==

On 4/22/26 8:15 AM, Hannes Reinecke wrote:
> On 4/18/26 00:57, Mike Christie wrote:
>> For virtio-scsi, we export a wide variety of non-scsi devices like
>> NVMe (local and RDMA/TCP based) drives and block based devices using
>> ublk. And then it's common to have multiple high perf devices im a LVM
>> volume. The problem for these setups, is we can easily hit the 4096
>> scsi_device queue depth limit so we end up throttling IO in the guest
>> when the real device can handle more IO.
>>
>> In these situations we don't have a device wide limit that maps to
>> cmd_per_lun. We have per hw queue limits or on the host we are doing
>> more dynamic throttling. To allow for these types of devices, this
>> patch allows drivers to set SCSI_UNLIMITED_CMD_PER_LUN for the
>> cmd_per_lun. When set, we will then only be limited by the per hw
>> queue limits.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/scsi/hosts.c     |  5 +++--
>>   drivers/scsi/scsi_scan.c | 25 ++++++++++++++-----------
>>   include/scsi/scsi_host.h |  4 ++++
>>   3 files changed, 21 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index e047747d4ecf..c93c59e847c5 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -238,8 +238,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>>       }
>>         /* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
>> -    shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
>> -                   shost->can_queue);
>> +    if (shost->cmd_per_lun != SCSI_UNLIMITED_CMD_PER_LUN)
>> +        shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
>> +                       shost->can_queue);
>>         error = scsi_init_sense_cache(shost);
>>       if (error)
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 7b11bc7de0e3..ecc3638c1909 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -352,18 +352,20 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>>       if (scsi_device_is_pseudo_dev(sdev))
>>           return sdev;
>>   -    depth = sdev->host->cmd_per_lun ?: 1;
>> +    if (sdev->host->cmd_per_lun != SCSI_UNLIMITED_CMD_PER_LUN) {
>> +        depth = sdev->host->cmd_per_lun ?: 1;
>>   
> Why don't we use a simple flag in the host (or host template) to
> indicate that cmd_per_lun should be ignored?

That's fine with me. I don't need it per scsi_device, but had thought
someone might. We can always change it later to a scsi_device flag if
it comes up.


> I'm not in favour of using magic values for a setting which
> otherwise is a limit.
> Look to dev_loss_tmo as a bad example ...
> 
> Cheers,
> 
> Hannes

