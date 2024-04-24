Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0119D29E
	for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2024 08:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.133.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713949184; cv=fail; b=EKsWOWhRzwFs54j5ZyDt14hV0YTGFGy1ZuZWDK1FEZJRFJtVIZpF8XMgescHAELrrqif0gbv+EnYbtH+Vb5RE777gRX//+P3kPws1m0P46g6FzogwOjGAtlS6pWfNiz7jSlzOWA2HxQz216eGmqzTryJOOL/lFI6bxTbpZSMvxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713949184; c=relaxed/simple;
	bh=u9IHpOjIOW+wALqL6LHqTOocFn50tY2BJ6vvDbIRvdc=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=YODdUsKRf7Y0QrPNg+ZhERHAJXCtLet8yod6E6A+F+v3y1sc5LO/8HLFFCHapYyIV+qSY7qWFFhPnaKlKxrupyUkOPZDDVnup3HjwhIc/atgFF3XNF9+64aKNwfBdbdkwTi23EJQhDBEB8ofHuseglQ2JrV4YRrNM6Oww9Zr6k0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=nCHAOde8; arc=fail smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="nCHAOde8"
Received: from pps.filterd (m0170392.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43O2IXXT007240;
	Wed, 24 Apr 2024 04:59:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=smtpout1; bh=u9IHpOjIOW+wALqL6LHqTOocFn50tY2BJ6vvDbIRvdc=;
 b=nCHAOde8w7rrnFfiN9xX2ZjG3SZtk5nDHHBaq4uV+sgPNaFOitaGGEJ/rSxnYIco8nQR
 ccyhRbY+oCynUIVVWO/185zX+mTXk7KCxDCTK8od85BW4Q4rJBBT8/ucwuaSBXDjlNB9
 xPS77jIwzziSA/ElPootZsSP1PFmrYOvwKh2FNm7c/jEMOQJYelEa+HpF/tz64Qh3Ml0
 IlNwePCUvO7nooDvZCERRaFHCK9l/VedPBgPF7kF8qH6SNyF9B7FG14coDnuwVdFGBnF
 IXb2I2+OlLj8yvlKU0MsWlKvwSgnBbdhLTOyMnXmc7BFPTxmqiwaUiq3iFa+dALwzZzR xA== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 3xm8vf0ch0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 04:59:40 -0400
Received: from pps.filterd (m0142693.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43O8W6KV026347;
	Wed, 24 Apr 2024 04:59:39 -0400
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 3xpw5nsp6a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 04:59:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glNsPJShtXD6NGuZDtAG+/qOIrddFZODDNT75h5LmnpL6EBkViA8NIotcVaRAeuXJPFIm8C8bSuJcmnwlMa/9fNYHwTqr3q0yzaF/H14bt9n2hfLj7pF8DW4wSl9Ke4sbKow9TgXAjRRTZyWWjQOp1NYNIb/rbFT6jU7b2YR4NUPklvub2BmHrr/q7ie36GHSls6928MtcRsA+7zj+Lyb/ecJ/0dSbXRG7vsoXeUjNnu/e7yNd+zDb7eoJ8d7wauA9x4KPd7WuoOBegavAXw95xi+C1/RzrR2tqPJt3Z0U1gR3Hg1MZqFds1txQrBZ9CC0wKH9u2yz93jaU2O6TVPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u9IHpOjIOW+wALqL6LHqTOocFn50tY2BJ6vvDbIRvdc=;
 b=FukaEe9YtISaFS8JcbBfE0e5R77vUoi85R69MMkrlV61S9LkIi3heD0djBSrPp3HPYZIVBKuG4+fVdAHSw+kh0bJs7Dx0NmklCtZLmK28dji0vdNtwCmUJgqv52DsmwXP5iV60MzzSBTs5SmanG4pY2kVGUqAZW8UZR0hVNKSe6fyAU68/3jQ0btSDmqQphd39jezVIMpUkZ+8K5f9ujjEJKVyL44dHGDGLfiXN6jXd7Ujf7DvQQNwuHyEu34Hl6V60TkIQsXdkQY831FeTaCrxZHASjazhilmf0kYmWY4uftMOfEqY6UO2cBlbblXncUQb1FTyFpvCDE6dLjSSjXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com (2603:10b6:a03:3e2::13)
 by SA1PR19MB4959.namprd19.prod.outlook.com (2603:10b6:806:1a6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Wed, 24 Apr
 2024 08:59:36 +0000
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47]) by SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47%5]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 08:59:36 +0000
From: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>
To: "james.bottomley@hansenpartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Issue in sas_ex_discover_dev() for multiple level of SAS expanders in
 a domain
Thread-Topic: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Index: AdqWJbfhv3GSaG0rTeK0+6km85YpNw==
Date: Wed, 24 Apr 2024 08:59:35 +0000
Message-ID: 
 <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ActionId=c72966a7-d738-4949-9a39-373528caf1eb;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ContentBits=0;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Enabled=true;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Method=Standard;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Name=No
 Protection (Label Only) - Internal
 Use;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SetDate=2024-04-24T08:58:21Z;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR19MB5415:EE_|SA1PR19MB4959:EE_
x-ms-office365-filtering-correlation-id: 5c596912-b9f8-47f7-21c3-08dc643cddb3
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 =?gb2312?B?Z3I2ZkdCTUViTSt3ejRnR09nd0tWbDFCTkFpcTg3ZXBhcXlGT0Y3YTFubzJj?=
 =?gb2312?B?OXpGMTk2UkI4c2orUVRnZUpvNHFrVmNtZnRpZmxwdEFUK1Y2T1NleDVpcDBR?=
 =?gb2312?B?MFRiRXFPN2U4WjJiV2NIK2g0S2hZckJoQWJKNlhYMzJwaVIyOUJnOS9IYVUx?=
 =?gb2312?B?Vzg0bVRYcE1YNEdjSGFPcmZxWGk3bHI3UXpqTGFCSlpUT1Y1UkNjSCtkT0pT?=
 =?gb2312?B?RWVMWlNCdVFOK0E0d3lnT00vZzZHa3dzWkx5RnNYMURpbDVlaWEzbmc0Z1hQ?=
 =?gb2312?B?Rnd1QlI1bUI4bXliRmtVYkZWc3dZWUJpL2F4RmxHbzFrWElQSkZqTGVkV2pT?=
 =?gb2312?B?QWtqb1poU1FGTG9TWUwxRHNObHFWcXJzTTUxaVV5UzFRTW5zZ1FXQ0lUdm9k?=
 =?gb2312?B?WGI3aUFWN2gydDJseW93MXVMay9hWmtRdHpMdjByVHhSYmxHSFV3KzIvRWl3?=
 =?gb2312?B?Lzg1YTBPYU1Ja2ljTElORElBenExdS9SWmU3UzlkTzMvU3lJNHZBNGVOQ1hS?=
 =?gb2312?B?Z3Fka3FQL0dIdk5NYWFVa25OMVVsZW1BTnhjTEhlRmQrcUJSb1YycXEwalVo?=
 =?gb2312?B?Rk02UHFSN3ZRTGpXL1lPMmNWWHNkakdRZTNiNUpJL0x1YXJOT0hNYTlrL1Fa?=
 =?gb2312?B?b0htOHFBeFBlK2RPQ1FLd0RrTFd3QWNyM2w5VXIzU0RsUDN6ZGJqYWxtcFBz?=
 =?gb2312?B?RSsram5RcDQ5N0wrZ3VyWUdCdFU2c0srSVJKUlNYcHJzVnluTWVESE0yZ25U?=
 =?gb2312?B?c2d3TlZVZ2tnRmFDOUcyVFlPSVIwMXRlUmdlamxhdWlNZlJKU3IwY291OWw3?=
 =?gb2312?B?Q3ArVkJDUlJEeU1lZUR4MFFVOUVnQXVZUTFwZUVDeG4yWkhjRkZCd1FsNFhB?=
 =?gb2312?B?d1JQTjVwSWhJME1kZ1NBTktoM0kyaDRPZkpYRnBwY3lnVC9IRVB1aEttOTds?=
 =?gb2312?B?MWxPRFZEOW9oWHRBQ0dCTGpvZ0d2ZS8yOHM5TDExdG0wSmJkOGF5OUlRcUgx?=
 =?gb2312?B?cEN5MHhOaktsaGxYK3dhK0RMbkp2SzdkdGdMZkJxdTVNNGIrTEJWVENDTWV4?=
 =?gb2312?B?SWNySW1pbjZQYklDMGg5RW1YVFZnNHlneGJveis4bGdMY2tZR3BKUG5rb2Ey?=
 =?gb2312?B?ZUVqc0lqaXZEaHMvbWpURzBvZjNGYXNkUlB2MEFRRlp2bWpsdUQvUjJJS1Vv?=
 =?gb2312?B?c3Bqb09Yb0t0STBsc1JqYUQ4aWF6bTdicmErcDErYVlpWUI5d2hhQ3pWOWIw?=
 =?gb2312?B?SzN2Q21oK2dVSHNHTmxnM2htbUFyRU5NaXlOYmZWek82T3lzQXgvYTVvZ2N4?=
 =?gb2312?B?UlNRMUhWcDIxbDlLUUlYOFdLSlVDYmVVY1N6dkNTUHdodlhMYVJWamtiRTNY?=
 =?gb2312?B?Zm1iVnZaT3hId1lLd3ZiTm9HcStyV09uU0JzcHN0S1VKWjM2cGZhSGVSVFBI?=
 =?gb2312?B?ZHF0MTlNN0NYWnJMa0ZGNTI4QjlHTHJuWmhkVW9QeTcwc29IbUZMUExrazQv?=
 =?gb2312?B?WERST3E3bHQ5c1RuQ1BGYmlUR0EvYmFaRVhtWCtnQ05vQ0FOU0wvNzZuSWJt?=
 =?gb2312?B?NkV3OWlxbmhhYTJGSjREZ25zTFNLc1B4MEY1ZkFiYXkvSlRjY0lJYndOUUZG?=
 =?gb2312?B?dkFvZnowcG4rSVNnTHNlYWs0b0FacUZHMmhlc1lmdGROYzV2NUkvZ3JFZlVF?=
 =?gb2312?B?SE1BZlR0Q3FnYmZySjNHVERheGR5bDRpRks4Tkg0R0dXMExjU2xQMW5QM3Ju?=
 =?gb2312?B?YTFOVis1NXRwYkthSldUaTloWUEreGdBZGpVZjJrUCt1NW1ORWhxaVNsUFB4?=
 =?gb2312?B?QS9xL0ZqWGh4MHQwUXpBUT09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR19MB5415.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?gb2312?B?YWRLZXIzZTNSMHlXc0xON2hSeVVTcmtGZDRaYWpBWCt6ZUsvZUticGdJaE1N?=
 =?gb2312?B?OFBzZTNCcm1ON1RYTC9nOGxoNThTY3hRMGl6ZE56d2s0OFQ1UEw3WWxFTXU2?=
 =?gb2312?B?cmNNY3JZMG0vRTY4TVhtMU80K1NKUGpiZElKL21tbHNYZnkwVFVjRWNpSlBE?=
 =?gb2312?B?N0s1UURkV1E1WEJSKzZPNGcxbVl3SE9YQWdiTjBFbStvNmc1akpIUFpMUjh6?=
 =?gb2312?B?TFR1SzlvTkZ2WFZWRGRsb0JIaEhhVTVDbGwxVnBlbUpJSVlPMXFpUk5PdXRB?=
 =?gb2312?B?a280dW03aXdQck5zUXZSb0RmbmlIU0pSRkx0NHJXRVhtNTlKam9lTjRFZndr?=
 =?gb2312?B?K2dGalNtem01VlZhdmVPR3VlcU16dzl1clpVRG1CVTNBSUo0RDdwbitWT1NC?=
 =?gb2312?B?UERPdk5WYXZOL2doTUxRS25UZ2s1UTVXcG9xbHJRdVRPdVVObTVoYXNYb2hR?=
 =?gb2312?B?dGl2Zk4wREU4YlZvdVZBdWkwNmJyYkZGWGJMNzRycGZoYndlbFdkYlArcEZw?=
 =?gb2312?B?WnB6ZW94TjJVejhYVVV6WVFyejFrU21pZTU4NWhjRkdOazM4eTZMYnlSVHNY?=
 =?gb2312?B?N0ZzRWFZUGtBYXhZM2xuY2ZqZGgvVGd1WnhIRmdEYmljQjRLREUwMk8zSXZh?=
 =?gb2312?B?bk9tb1NCeGIwQXNrdmROa3NtcWVYNVEzdzAxN1d4QXlZek1nTmhYWW0vcFY1?=
 =?gb2312?B?ejNjV1BhbmRkZTdTUlk3V1g0dEpMNDRGRUI4SUF5cU52YUU2d29SRjZmVXNB?=
 =?gb2312?B?WGpwOXF2eDJzTFp3Sks2a1BjbnA3RUhTdlNpaUhscXZpZTlRbE5YZE5XT0VF?=
 =?gb2312?B?alVIR2lHMXdQOFZQTStxTjBtRU92OGNCNjNtNG5aU3czY3hUUEIraE5Najc1?=
 =?gb2312?B?dWUvRFpRRTRIQWVHZ0RIUWhiZnYrd3pPODdleG1rSEhxc2xhNTF2K1hJSG5B?=
 =?gb2312?B?T29xMnU4U0ZueHFHVW5JUUZnYkpyZEVIMVNSb01IRE9Gb1p3R1Y0M0xYUy9U?=
 =?gb2312?B?eHNnYlVQOWI5cHlqUEJvbzBMODNCdkZhb0dxWG1CWnVBR1NtZi8yVUhycXMy?=
 =?gb2312?B?alNaUmJkMTNncDJLK2RxbElKTHVkVTl5eTErN2JpbmxVdm84ZG85UklubXF3?=
 =?gb2312?B?QjRVSDJPd1BQaDlRUWdBclZFRDRhWklzYkRpQW9vQzR5UVA4cUluekRrUmNs?=
 =?gb2312?B?N2EyRmtzRlZVdEllZG84R1pFVDZTN3RidjFwUVBkUVVPem5pOWZNY2l3VE9W?=
 =?gb2312?B?T29JWmd1UE44SDB5VSszdStja2R1a0VKdnR0YW1sTGVDbzRycGZJeG5OZWJR?=
 =?gb2312?B?aHpVZ3JJU0RBZlZmVmNJNnB4Ukt2cTlqUzlXWko0WC8zTTNqTlFWVE8wd0Q4?=
 =?gb2312?B?M05vZ0xEVytWWnFRMFJDbElzMjhkUUdJbmFTd1MrV3BBaytWL09Oa2U3NFIr?=
 =?gb2312?B?MkhhUFFtd0l1Y1d0RFhIMkhCdmdDV2xBZC9wajdVWk91QzlKN0g1SnVJdW5F?=
 =?gb2312?B?NloxWTJEU1hvcStJbFltOWJ6VmtIUi9iclN4MWdJRXlEaktUQzNxTG8zb1Y5?=
 =?gb2312?B?amtVTHE4QW81cURuaGEyUWZpcnNnV0hUc2FPaGI5Vi9USUIrbVJyVGFhSGRK?=
 =?gb2312?B?QVo1WDd0OHpxbHFCV2FsOHRYSGl4bDQ4RGI2Z2RkNDc1WXNDNkRaUzBiZldP?=
 =?gb2312?B?Q05pY3lPNWQ3WmU2b0F3eU9ZM2JTMytQckxlaUl0MmtWbjBaeWpieEhYWFFI?=
 =?gb2312?B?NkdhMlNBMnFHQlprTkdRYUQ1TnVCWXBaODF1aWhqUmRBQUhURU9LaElmNFhR?=
 =?gb2312?B?am0rU3gvQ2prcFlRUXg1WWdIUE9UVjJVdkppalVVQ2c1d1UzWm1pNjdaU1p0?=
 =?gb2312?B?a2JrY2RUM24vU0VyWVVld3daQldJRzBrOUw0RTdmQ1ZsZmVoWVlUWDNtc3Y1?=
 =?gb2312?B?RHZXRlo5cWJTdDFMRHFWSEFGS2hTTlZaQmVKYk1ZNlh1K054WjJUVExFZE5Q?=
 =?gb2312?B?M0pGWjQxT2NTd1JseWdRa3JJSXA4SUxhc1lveEdURWgxa3Z3Y1VZdjl3ZEZ3?=
 =?gb2312?B?WS9qZXErWHJmSlhqN3BzUS9jemh3Zy9leENPcld1K1UwTGhZZTFsWVQxY0JY?=
 =?gb2312?Q?eeY4=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR19MB5415.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c596912-b9f8-47f7-21c3-08dc643cddb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 08:59:35.9688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rjqWLWxkoGMh/a7XUJHUOINsco6PQi4b1PzbJUh8MMc4M5RyEjcabEOUhEtE6zMSD9DYOsR89x30Uce+jKOHUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR19MB4959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_06,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 adultscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404240038
X-Proofpoint-ORIG-GUID: C9uO8SukCoMEXD9qVfzCGxFbsROUXQzj
X-Proofpoint-GUID: C9uO8SukCoMEXD9qVfzCGxFbsROUXQzj
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404240038

SGksDQoNClRoZXJlIGlzIGFuIGlzc3VlIGluIHRoZSBmdW5jdGlvbiBzYXNfZXhfZGlzY292ZXJf
ZGV2KCkgd2hlbiBJIGhhdmUgbXVsdGlwbGUgU0FTIGV4cGFuZGVycyBjaGFpbmVkIHVuZGVyIG9u
ZSBTQVMgcG9ydCBvbiBTQVMgY29udHJvbGxlci4NCg0KSW4gdGhpcyBmdW5jdGlvbiwgd2UgZmly
c3QgY2hlY2sgd2hldGhlciB0aGUgUEhZoa9zIGF0dGFjaGVkX3Nhc19hZGRyZXNzIGlzIGFscmVh
ZHkgcHJlc2VudCBpbiB0aGUgU0FTIGRvbWFpbiwgYW5kIHRoZW4gY2hlY2sgaWYgdGhpcyBQSFkg
YmVsb25ncyB0byBhbiBleGlzdGluZyBwb3J0IG9uIHRoaXMgU0FTIGV4cGFuZGVyLg0KSSB0aGlu
ayB0aGlzIGhhcyBhbiBpc3N1ZSBpZiB0aGlzIFNBUyBleHBhbmRlciB1c2UgYSB3aWRlIHBvcnQg
Y29ubmVjdGluZyBhIGRvd25zdHJlYW0gU0FTIGV4cGFuZGVyLg0KVGhpcyBpcyBiZWNhdXNlIGlm
IHRoZSBQSFkgYmVsb25ncyB0byBhbiBleGlzdGluZyBwb3J0IG9uIHRoaXMgU0FTIGV4cGFuZGVy
LCB0aGUgYXR0YWNoZWQgU0FTIGFkZHJlc3Mgb2YgdGhpcyBwb3J0IG11c3QgYWxyZWFkeSBiZSBw
cmVzZW50IGluIHRoZSBkb21haW4gYW5kIGl0IHJlc3VsdHMgaW4gZGlzYWJsaW5nIHRoYXQgcG9y
dC4NCkkgZG9uoa90IHRoaW5rIHRoYXQgaXMgd2hhdCB3ZSBleHBlY3QuDQoNCkluIG9sZCByZWxl
YXNlICg0LngpLCBhdCB0aGUgZW5kIG9mIHRoaXMgZnVuY3Rpb24sIGl0IHdvdWxkIG1ha2UgYWRk
aXRpb24gc2FzX2V4X2pvaW5fd2lkZV9wb3J0KCkgY2FsbCBmb3IgYW55IHBvc3NpYmx5IFBIWXMg
dGhhdCBjb3VsZCBiZSBhZGRlZCBpbnRvIHRoZSBTQVMgcG9ydC4NClRoaXMgd2lsbCBtYWtlIHN1
YnNlcXVlbnQgUEhZcyAob3RoZXIgdGhhbiB0aGUgZmlyc3QgUEhZIG9mIHRoYXQgcG9ydCkgYmVp
bmcgbWFya2VkIHRvIERJU0NPVkVSRUQgc28gdGhhdCB0aGlzIGZ1bmN0aW9uIHdvdWxkIG5vdCBi
ZSBpbnZva2VkIG9uIHRob3NlIHN1YnNlcXVlbnQgUEhZcyAoaW4gdGhhdCBwb3J0KS4NCkJ1dCBw
b3RlbnRpYWwgcXVlc3Rpb24gaGVyZSBpcyB3ZSBkaWRuoa90IGNvbmZpZ3VyZSB0aGUgcGVyLVBI
WSByb3V0aW5nIHRhYmxlIGZvciB0aG9zZSBQSFlzLg0KQXMgSSBkb26hr3QgaGF2ZSBzdWNoIFNB
UyBleHBhbmRlciBvbiBoYW5kLCBJIGFtIG5vdCBzdXJlIHdoYXShr3MgaW1wYWN0IChtYXliZSBq
dXN0IHBlcmZvcm1hbmNlL2JhbmR3aWR0aCBpbXBhY3QpLg0KQnV0IGF0IGxlYXN0LCBpdCBkaWRu
oa90IGltcGFjdCB0aGUgZnVuY3Rpb25hbGl0eSBvZiB0aGF0IHBvcnQuDQoNCkJ1dCBpbiB2NS4z
IG9yIGxhdGVyIHJlbGVhc2UsIHRoYXQgcGFydCBvZiBjb2RlIHdhcyByZW1vdmVkIChpbiB0aGUg
Y29tbWl0IGExYjZmYjk0N2Y5MjMpLg0KQW5kIHRoaXMgY2F1c2VkIHRoaXMgcHJvYmxlbSBvY2N1
cnJlZCAoZG93bnN0cmVhbSBwb3J0IG9mIHRoYXQgU0FTIGV4cGFuZGVyIHdhcyBkaXNhYmxlZCBh
bmQgYWxsIGRvd25zdHJlYW0gU0FTIGRldmljZXMgd2VyZSByZW1vdmVkIGZyb20gdGhlIGRvbWFp
bikuDQoNClJlZ2FyZHMuDQpFcmljIExpDQoNClNQRSwgRGVsbEVNQw0KMy9GIEtJQyAxLCAyNTIj
IFNvbmdodSBSb2FkLCBZYW5nUHUgRGlzdHJpY3QsIFNIQU5HSEFJDQorODYtMjEtNjAzNi00Mzg0
DQoNCg0KSW50ZXJuYWwgVXNlIC0gQ29uZmlkZW50aWFsDQo=
