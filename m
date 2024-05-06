Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com [148.163.137.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1C141C77
	for <linux-scsi@vger.kernel.org>; Mon,  6 May 2024 01:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.137.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714960203; cv=fail; b=XBbcmB1IMesGi9CXzDt4cEm2YkWbNSOzHCnsoxFfgkGCxhJPxlZG6eBLk71orUIrT/kOr+0wUxLieumY6Q0JHhTLWOwdTjbzoFTGbribj/81pVaAGDKbmeMlEA8i/rZt6peK8h0XKrLpDv3Jm20gBSNyrQFI7TmGt19o54IvS8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714960203; c=relaxed/simple;
	bh=LlxKmNpCJsIShoFSFykVl6BI+HmChI8LU+4WZIxAG3w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D/UUhlQ/0ZQUamnA/JsxLCbqcfKXQ8qVZxH35ocSDcapYXZ1r31HaOtuKwOnzxXklgr8bIeMd+yq963CfcCEozH4F8A6cUCQfx5ZvfjfeiXElfuCA+Rr53YltJusjp6Gj1lq4okcXR6xCfkw28atilkfDVA58lT84nB+3dhsc4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=D8FZ7snY; arc=fail smtp.client-ip=148.163.137.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="D8FZ7snY"
Received: from pps.filterd (m0170397.ppops.net [127.0.0.1])
	by mx0b-00154904.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 445EZuPU027225;
	Sun, 5 May 2024 21:49:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=LlxKmNpCJsIShoFSFykVl6BI+HmChI8LU+4WZIxAG3w=;
 b=D8FZ7snYFb+R4LDrN1cdhyOuogG6PI5JreO0neAdaYzqnosN2NU1aMSlUR0BE0bwaLLM
 Bw82VZZylkP12c3i4CJ8EP2lztd/9K9Aq/G1GyUYvsCLcu/xXYISl2q1zd71/6hoYgRX
 MSnkFRI+xY/T3Rko061spf/wX8ccHqDrdJWiLbidk7Xe83IGglSvM9wW7cOs24yEuVOi
 PIRvd/z4ZD7EC0e+pNqHCGD0V+SHGqCPC/OfW/AofqhK2+0p7JFkKsj2xZ4//6dbRQxZ
 8Pe6pDpJY85XXmlBi3f7/9mfVj0HOBBuMjU+PC+Lr1sLGsKkcDeo5sr2ZOhmVpHGF0li kA== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 3xwe3vc6h4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 05 May 2024 21:49:49 -0400
Received: from pps.filterd (m0142693.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4461RUFq025149;
	Sun, 5 May 2024 21:49:48 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 3xxnjfr5yj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 05 May 2024 21:49:47 -0400
Received: from m0142693.ppops.net (m0142693.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4461lNXo015000;
	Sun, 5 May 2024 21:49:47 -0400
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 3xxnjfr5yd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 05 May 2024 21:49:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lr3zV/xjm3P5T4QnfSZKuHnIRHvJVoAwAnzv+UP9HjCqIwnSklfC20+kVXFB2myeKr0vH6gZK5H0wsqFP25mnEI/T5GTUHEfMBJW+slcm5JymiN/yfYyyqlGJ6YSRjRLX85kduaJoEMA/kS3Fsf5r9Hwoz6e6XkuTjfEcAfsmT9+pVUDcNXTzraTulEjrXT1KiUPGQIrmXRFDC1URRaTzBrZQ9zGBrjtfKtqtVGlKoLewSJXDZMMpRe5q1BzEPuQM5m5NfFcU5WlPBPkWPe06aJ3GY+CiazfMZcAYh2zR7MdAFataCYw3poTwXJe9nFakM4LxYMAGJ9+b+vrkR/GOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LlxKmNpCJsIShoFSFykVl6BI+HmChI8LU+4WZIxAG3w=;
 b=F0NfpWDGsBy+DwhuTPACpJ8jk1Ey2K4mr+Lzym6/lPfDxA3xB1ksd+tZvGKzpcWkMWR30r47N+KRSvw8z/0bEZUypsYJAnJsqKVHgfKMiQkPmA+EMKr3LupP0GfhN1jdPgoUolzHC9bIoTIkzgqar4RWlZ3edFO3wIaUuikMzCJR84lzxzHVh5eca7e0iZAWejnvEx1CsBnmvedoqML1iWZs65UUnHZqa74NvvsZvic7zQBmkfWDXYpj8cRrLsrUJHqO7uF2+Bx4ErpoBTwNOkUPLe+RGnNoP+CZdICQXKFUu7d339volXTgkH3E3XAB1coRAPO2G8hFx8DqHW7zag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com (2603:10b6:a03:3e2::13)
 by SJ0PR19MB4461.namprd19.prod.outlook.com (2603:10b6:a03:289::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 01:49:44 +0000
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47]) by SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47%5]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 01:49:44 +0000
From: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>
To: John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
        "james.bottomley@hansenpartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Topic: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Index: 
 AdqWJbfhv3GSaG0rTeK0+6km85YpNwADuoMAACHtcIAABC5uMAEPIjxwADJmXIAATNqvUAALeYiAAIffgZA=
Date: Mon, 6 May 2024 01:49:44 +0000
Message-ID: 
 <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
References: 
 <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <09dd80bb-09f9-481f-a7a7-b9227b6f928f@oracle.com>
 <b1a5552c-689e-d220-88d3-56d24752be5b@huawei.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
 <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
In-Reply-To: <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ActionId=2b9aab1b-1798-405e-94c0-bef086fd0c92;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ContentBits=0;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Enabled=true;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Method=Standard;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Name=No
 Protection (Label Only) - Internal
 Use;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SetDate=2024-05-06T01:23:33Z;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR19MB5415:EE_|SJ0PR19MB4461:EE_
x-ms-office365-filtering-correlation-id: 500c998d-1d9c-4805-a871-08dc6d6ecd83
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-7?B?eGRURDJZaEVvWXRpUjZmSlZzNWRnaXM5L3d0TDJUKy15UlNYdVBEaUJmeUNB?=
 =?utf-7?B?QXNQZkc0TU1vcy90aGxCTkhyQ2JyYlBFNEtmT2hwUndOTjRWMnRIb3FDQ21t?=
 =?utf-7?B?d0tvWnZCWlFPbWM5ckRNTVlpc1ZxTlQwZ0FmZEUrLWZGL2RSZ3plWEdEbWx1?=
 =?utf-7?B?VistSEhFbUdqcE1YMC9xaUpmZXo0UTlvZW42S0F4dG9KT05hQ0g0d0E4QkxH?=
 =?utf-7?B?YWs0enc3SEVranM4T1RUa3BvVnZFUHhLbSstV1VNZDhUQW5DRkdaNjVXYmwz?=
 =?utf-7?B?Z3dGMHZYenY4QmpsbDNYQVFBRkk3VW1IWVhrVkNiejlWRTdkZktDbUNaaFpk?=
 =?utf-7?B?N0FtcWlRNlJZODI2b0xER1ZES011SlRmQkJKT3NSVGdVVVhuU2lrQzNOQlNx?=
 =?utf-7?B?dGZCMUxrQzNIc0c2SElYTElpSXgwM0htYm94RVFSL0FBZWRBc1hScllBYlls?=
 =?utf-7?B?MSstOUFTY0h3a1RvTm5XVDhXRFJoS2RmYk94dlMzTEdJNzRFc2plWW9PYzVS?=
 =?utf-7?B?cEkzTistQTRYbnA1cmlpdEJKYzlXTXlyVmpDUlA4VFVSUnJxL0t3RXVlRGhL?=
 =?utf-7?B?VVBJUEhBVkFJM2Z5cGZwYXFCWU50SXJ1VDdnNE5temE0MGtwVzF2V0JlUE5z?=
 =?utf-7?B?QmthRS8vODRlb1hTTmM4bjRpaGRhQ1NoNVFJOXR5enJRdU5WMkNrYWE0VjRU?=
 =?utf-7?B?MDl0QnNObngvWGw4QWJuKy1hZnpwbWM5Z1Q4a1JOa1VxZDVOOGt6SHhYUDRv?=
 =?utf-7?B?bystQkg4bnROdkZYMlFBZXRqMk9iSmNvN2ZXQjUrLXBwKy04cWhzamxWaGFT?=
 =?utf-7?B?OVVIOGt0ZjU1V3M1elU1WVVIREhHSk4vOWR0TTRUYUVsTldpZ05ZVUgrLU5H?=
 =?utf-7?B?d3FJVk5tYUhOZFd1cjVGdzBvRGdCNk9MaS9FcEdJMWdSRk10ZWFPRnlIdHNq?=
 =?utf-7?B?T1g3clNrRGNjMURuc1RPZnBROGc1WDU0OWlwaEFPbWlibSstQ1hsVVE4cHJl?=
 =?utf-7?B?QUdKbDlHNlZJOVB3MUltM1BkSTMvOWFlRDhvd25aVjdibUZzZHVFOHpvS0tO?=
 =?utf-7?B?WGpZVUsvcmFmeDZ3enZrRGxObVkzc29qTGR0L0xYbjFJbjhMQWw2UUw3Z2dz?=
 =?utf-7?B?RjhvQnpoY1g0Vy8zdUJYS0dkN0d2a2FyaHJBRHE5c3I5ZHRLaE1oejkxMjI4?=
 =?utf-7?B?SWloQ2ZOZ1RJR3NMVURSaXhjek5ZdE04ckhFUE5YNDdYL1NrZ1A3NmNpMlRL?=
 =?utf-7?B?VGc3MkllSW9LKy1BTzRCN3VvYXZPN0NsTG9hRHZ3dE9QeEYxYVhNcno3cTNW?=
 =?utf-7?B?RTZTbDk4dmVaR2JWajJEamRMWi8vakVqQ21DbExSdXMxbjlWSmtFRWlGamh1?=
 =?utf-7?B?Qmt6MzZoVTl6RmpqUFFETnNuVHNDNEx6eFVKZ253UlVlQVk2UkxOeG5VR2FQ?=
 =?utf-7?B?N1VuZmxiQ1Q3V1ZBUXI2NVplRW5hQTBlM1J5d3A4THBNU1R4M2JyZmRENDlu?=
 =?utf-7?B?UmRNeWkrLTVyMVRXdUdFL0I5Tml3TlU4VGEzb0ZXNGlXM0NOSzlnVmRKT0t1?=
 =?utf-7?B?WnQvZTltM2dvKy1OSnJueVBnQW9YVW1MdXlHRGpCdk8rLVppUystQTZoSm1S?=
 =?utf-7?B?eHJ1OHVtSmI3amdhTVNTY3hkZmVxZzk2MC9tR3dabUxvWUtyZldOeVpiQ2k3?=
 =?utf-7?B?Sjcyc0VFMmc2RG1UMFFNTk9yNDFJNTN1bzFIb0RlWk5NL2srLUd6T25sZUhF?=
 =?utf-7?B?QWgxZTYyTjJ6aWlkdXNyRGVGV1p5cG5INTdKYWJ5V284Sld0NzZhZSstdVlV?=
 =?utf-7?B?VFlyTWlVMVpIKy02QlVKVWhVV3lrN08wbnl4Mko5Q0JFYlVRK0FEMEFQUS0=?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR19MB5415.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-7?B?N0RobDc2L1grLUNuVlNoTnNWT3F2WVNKVEU2WUlyZ21OY3kvUC9PNkpoWUtX?=
 =?utf-7?B?SU92ZUp1Qi85dHZqT0ZiZjZBcXFIRDdoYUpNKy1Za0IzMVhLMGx3bFBqWmh3?=
 =?utf-7?B?TXR5WEUvU3R6eXVTaE11OFJPdXNYYWdDaHRDS3hicENRUk5UN2lTWERNamlk?=
 =?utf-7?B?akVGbzh2WFBHOVFwQW1xOUgwL0tyc3huVDNuTFgvV0NDU1FMSi8zM0RLYzNG?=
 =?utf-7?B?RkxGNXVyMGd4b1FlOFZRZ0gyTW9nblR4T2hhNTE1aTB2T2FabUFJVFA3NnNC?=
 =?utf-7?B?WjNscDVEREZZUUpYU3NZdjkyWjI2bkxqeUhpakxBWFZzZm5LaUFBSko2T3Zp?=
 =?utf-7?B?SVpIdHpzMkYwOGM1UkQva2x5b2RnOEZkeEF5UHFFdjV0VTRveistR0lQcCst?=
 =?utf-7?B?STR5Yk1CaFN2WlUxMldUZGpFZ09tU05RNjhweHVXQTRuNE9Oek1jYjdYazJN?=
 =?utf-7?B?Qjg2OURLMldpODJqRFFpSjZwZUQrLUFudHpYQktFcENmNHpZVXk3YWhabERj?=
 =?utf-7?B?VWZwUSstb2ZkTjRWTm5Pd1c2UHB5YmhMMkRKSko0QldMOG9FeSstMmxSQ0FR?=
 =?utf-7?B?RkdweG12RklLRk13RGRUNFZkRTBsSGYxcW9WUVYzblRjMDc5NGI0NldwT1Fr?=
 =?utf-7?B?MHNVZ3FUTDNZNXk1N2s3Zmp1MG91TVZVdURaMjNIOVVZU2dZMThScHRFUXNE?=
 =?utf-7?B?enZYV0hSWDdxMGJXTXNDTGtISUx1czJ6TUo2ODU5YS9LaDVvTzZOdzloTjZW?=
 =?utf-7?B?czNZMVFEVHJEVTk2MTRCanJIOFR5ZGw0ck4yZ2RIOTlZMkxnUWdZKy0vbXBS?=
 =?utf-7?B?ZklMYSstY2FlTXg5L3lxUldQQTJkZmJHS0VGd0hPOCstM2d0VWVSWHF6UkVh?=
 =?utf-7?B?V3MrLVJpcjdlOWUxRXl0VlNYZ1M2Nk96YjNRUEtNNVcvbUhadWVVblo5SDFn?=
 =?utf-7?B?elpQRXJ1eWVaS1A5cmtKQXV2RnNISzhXNnRhTnpzQlNQempNMCstdGdkblN5?=
 =?utf-7?B?cnV6UmhwQ3V1WXVJeCstSlFwbXNxRDBkUXZWTTMyYzF3enhiS1pwOVJBWVE3?=
 =?utf-7?B?ZmtjSHl4SVRWMSstUjdKQXkrLTkyeFQ1S2IzeklRVk5CTW10REtBemJTaVdu?=
 =?utf-7?B?eUNMMlZ3Y3BtMzlsUnJyYXJvKy1QVDF3NUsvMVBYMHNrc3kvZi9LVlplWDRG?=
 =?utf-7?B?czQ5MVk0YTU1cU5hdVNPUmMwcjZHSWNqc3BxZGVycWU5YTkyclJSSlF6eElW?=
 =?utf-7?B?NTFUTm9URjVYZDcyZ1FFZXBvbE5UTlVQT21rM2I4b2xMdC9TaEdPTCstZmV4?=
 =?utf-7?B?VmRkS0pJUUpLTUJpMjdCdnoweUpaM3E1cUlMY1NQSzc0aFJvaS9WcSstLzFn?=
 =?utf-7?B?b3EzZmRCeFVINDJDMy9SQ1dTNlJLTistRUx6SklZa0NWZkR5M0xtY1ozYnRE?=
 =?utf-7?B?cFVzanlyblFXWURjQTlKV1FvMnFKS3lwNmVERjcxc09vUmZnMVV1SmNCZ1Rz?=
 =?utf-7?B?TElUSTRuc3dETistamlIakxTeHI4bTRDUlZJR2dCZWlGWGF2VGFReXd2UVRC?=
 =?utf-7?B?MWtZaXQ0by9vQ0lPMTZGKy04RTQ3aTBkZmg0YmV2RkE5YTgvNFdYS1dZY3li?=
 =?utf-7?B?QnVJT0I2YjVHNy8xdENDeWo5RHFxRFR2TVpCSENFakJlNWFPV2t1eHk3eWpN?=
 =?utf-7?B?V0dyL0lNSEV6T3haTnk5VFBSKy1pdUNaZWpjQXk0U1F5N3ZsSTJWbzhrMzZm?=
 =?utf-7?B?WUpLT3cycWdIb0J5MzlrSEorLVhoa1NIUVJBQmlLdVpEeXdhTmlDNWNsOHlW?=
 =?utf-7?B?MFo1Z2I1akRHY3UvdmlpZnczNVpNZ1FhUUZtQkJzMU9oZisteWExOGtZUVF3?=
 =?utf-7?B?NEltdXlyenAwbHFXWkR1dFZtY0YxUzA3WmsxcUprbTBwQTJMMVZxbVBPeElu?=
 =?utf-7?B?VmQxZEp5aGJyOTZqU2lhL3RaOFlQYzU2Ylo0TmpNLy9HeXVQb1YrLVF3WlRH?=
 =?utf-7?B?ZzFwNnlGbDBLNXRvelpvSG0yanZJMXFSRXpOU1d4a0hEM2VMajBuSmVqbHEy?=
 =?utf-7?B?Z0FqeldvM0VVbmdrNC9HNUVVeDZ0Rkd3M09vWkNNT3d3bXJvNUthcUFmbUhp?=
 =?utf-7?B?bzdxKy1raSstTzB1bll5UjNDVDlVZ3poWEpzZmdzWStBRDAt?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR19MB5415.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 500c998d-1d9c-4805-a871-08dc6d6ecd83
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2024 01:49:44.0956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: We+Tl1QhF5WLImErIs5mv9M/6xjPdKh7bY4lSnsgedbBu10lNbxXFPXI98Dzw2TJw8LgCIpvSPLGDDOgHMhmWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB4461
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-05_17,2024-05-03_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 phishscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405060006
X-Proofpoint-ORIG-GUID: H38YAZ2aqpwFt2SyBrJ86oBA08g6LgHD
X-Proofpoint-GUID: H38YAZ2aqpwFt2SyBrJ86oBA08g6LgHD
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405060006


Internal Use - Confidential
+AD4- -----Original Message-----
+AD4- From: John Garry +ADw-john.g.garry+AEA-oracle.com+AD4-
+AD4- Sent: Friday, May 3, 2024 4:33 PM
+AD4- To: Li, Eric (Honggang) +ADw-Eric.H.Li+AEA-Dell.com+AD4AOw- Jason Yan=
 +ADw-yanaijie+AEA-huawei.com+AD4AOw-
+AD4- james.bottomley+AEA-hansenpartnership.com+ADs- Martin K . Petersen +A=
Dw-martin.petersen+AEA-oracle.com+AD4-
+AD4- Cc: linux-scsi+AEA-vger.kernel.org
+AD4- Subject: Re: Issue in sas+AF8-ex+AF8-discover+AF8-dev() for multiple =
level of SAS expanders in a domain
+AD4-
+AD4-
+AD4- +AFs-EXTERNAL EMAIL+AF0-
+AD4-
+AD4- On 03/05/2024 04:15, Li, Eric (Honggang) wrote:
+AD4- +AD4- John,
+AD4- +AD4-
+AD4- +AD4- I agree that the call to sas+AF8-ex+AF8-join+AF8-wide+AF8-port(=
) is not mandatory. In
+AD4- +AD4- fact, some logic here is similar to that function. We don't nee=
d to do
+AD4- +AD4- it again.
+AD4- +AD4- But just updating the phy+AF8-state may not be enough. I suppos=
e you still
+AD4- +AD4- need to add that PHY into the corresponding wide port by callin=
g
+AD4- +AD4- sas+AF8-port+AF8-add+AF8-phy() and update phy-+AD4-port.
+AD4- +AD4- Just updating the phy+AF8-state may avoid the port disabled in =
this issue,
+AD4- +AD4- but other missing piece of work may cause other issues.
+AD4- +AD4-
+AD4-
+AD4- If you check the commit in which that call to sas+AF8-ex+AF8-join+AF8=
-wide+AF8-port() was originally added -
+AD4- 19252de - it was added together with the comment +ACI-Due to races, t=
he phy might not get
+AD4- added to the wide port, so we add the phy to the wide port here+ACI-.=
 However the code to set
+AD4- phy+AF8-state +AD0- PHY+AF8-STATE+AF8-DISCOVERED already existed befo=
re that commit.
+AD4-
+AD4- When all that code was removed in a1b6fb947f923, I am just wondering =
if we have kept the
+AD4- phy+AF8-state +AD0- PHY+AF8-STATE+AF8-DISCOVERED code.
+AD4-
+AD4- Anyway, would we really join a wideport with the downstream expander?=
 I would just
+AD4- assume that we would be creating a new wideport, and a subsequent sca=
nned phy would be
+AD4- added to it.

+AFs-Eric: +AF0- I don't think the code removed in a1b6fb947f923 is the rig=
ht way to fix this issue.
It just happened avoiding this issue occurring.
I think the root cause of this issue is the order of function calls to sas+=
AF8-dev+AF8-present+AF8-in+AF8-domain() and sas+AF8-ex+AF8-join+AF8-wide+AF=
8-port().
My concern here is whether or not we still need to configure routing on the=
 parent SAS expander before calling sas+AF8-ex+AF8-join+AF8-wide+AF8-port()=
.
This part of logic is not present previously and I don't have environment t=
o test this.

Back to your question, I believe we do need to join a wideport to downstrea=
m expander.
Changing the phy+AF8-state to PHY+AF8-STATE+AF8-DISCOVERED will skip scanni=
ng those PHYs, by not calling the function sas+AF8-ex+AF8-discover+AF8-dev(=
) to subsequential PHYs within this port (so this issue wouldn+IBk-t hit). =
But those PHYs are not associated with a SAS port. This may trigger other i=
ssues (for example, any change count changed on that PHY, or SAS topology i=
n sysfs, etc.)

+AD4-
+AD4-
+AD4- +AD4- Eric Li
+AD4- +AD4-
