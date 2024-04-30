Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com [148.163.137.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D547D174EDF
	for <linux-scsi@vger.kernel.org>; Tue, 30 Apr 2024 14:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.137.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714486989; cv=fail; b=hULxyG2GTZkmwDt8cF3zpUBIfk04UNHHPL3DG7o6OVx+SRL4We3nVFrE1uj+eLU4Ch5aSFm1QZq2YD9wJ4LP5/f0XFjQlvwoOBr2yi5plGFlJTzKQmXS7/tBTR6eRR1EM3inTRdWftZOoweusXZLEWbdBY4HzNpn+gmI5rko5+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714486989; c=relaxed/simple;
	bh=/DJ5s+hgZ7eDx9FNKuYJHzLBfxFT9WXfVsRB503WM+Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RoUf59xUl+NQ9InCdiSV8+VClhcebNWgDyNVF/i0MjAngG3aeQ69E6rwh3CJdYwArSgtEVqvkiAu9Wtg9cID7RR5qeYUVx4cqhMz9ekSSs0tiXzH7jddbBMj0d1EQsxV/5wwgRcBfpDlD8lt5e7MBhT4RhULUdq3asiMrMy0SZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=vvg+FprS; arc=fail smtp.client-ip=148.163.137.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="vvg+FprS"
Received: from pps.filterd (m0170394.ppops.net [127.0.0.1])
	by mx0b-00154904.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UAa2Sq021872;
	Tue, 30 Apr 2024 10:22:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=/DJ5s+hgZ7eDx9FNKuYJHzLBfxFT9WXfVsRB503WM+Q=;
 b=vvg+FprSsYSDge2esa/kfSPwbsWwDgOlkn8I1VBf/JYEGo1v4HyCMLOkdkscpshAp8dK
 2SoUkWSqL5WmtKRK8TpxvQ7q3tmUVB5Df8wenPwzJqNir9uPs25z+lLxkVpUxBGhOhIl
 Fonr1t3AamLkuPVe+eK+zX5WId/zyW6QqMsmP9EBJ0WwXDR0uRrrH1OjAcg6uyiZF4rV
 Ql4d8VGe/yxxBfJBp69atqPzIJjWzq4NJa05sqVcGpbUa0AxaA2KDaAuDhOzD/y43sd0
 T3S0vmQiunjAQj/zyvmGJ5u2gz0s1BDsEa///XoMliESsgQnuVuCgz1MKPhicQBp8a63 RA== 
Received: from mx0a-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 3xrux8v08v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 10:22:58 -0400
Received: from pps.filterd (m0089484.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UCK4lg008785;
	Tue, 30 Apr 2024 10:22:57 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 3xu0j4jcmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 10:22:57 -0400
Received: from m0089484.ppops.net (m0089484.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43UELctr023948;
	Tue, 30 Apr 2024 10:22:54 -0400
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 3xu0j4jcgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 10:22:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8S6dPx/Rns9Te0EP0Wprvz3kStwHaLZ/n4GSpRlf2/Hpr+OY2euZOD5+3gTd6lrOD25MoOjIjzUmAOzjtiMx3l1F1vtLD2lVCmf9SydAksgcJQLcQx4qFW3h0mcKrtw6zPVx1QSyfSQACKprsRRgVlauI4LFIGD0DmA9hhUa3JD7XNTW3OcqgP1baIh7K5mMMK3JnCsnMxKEHC43dyxQZ/X4tXhLKSYEEdADFOtojOD67KKIBv1DMHzb/CiKFG8n/eITV2Rraob7kOLL7sIwLvgsSSiQ9vYcPR1uX4vt/QyGcl0do+to0q4B7Cj+oUzoq8LXxGhE4Oqp+zA/1lbsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DJ5s+hgZ7eDx9FNKuYJHzLBfxFT9WXfVsRB503WM+Q=;
 b=MjhGU7DYloruYjthhrx4haj9eUwYukatFKVGnu9AOgYf53rRYf5qt7sY6J5kvB3KRjgJ1mFvv9DDu1RBaBKE1eg6HWCBU73NnG/ECpbrtMeft637oJNmx522Cv1CRpcNxcAPyv96hGQM8kGMDX0EWzrcy+vz/eRL7hyE0FADu1I6IqINEUySD+SKKKxOO9vi/V8/NOMX5+ZcE4I+EQY4lYAvHmWrRHNZR1EOzLXV0bnYBjF5QcA9vOV8aI1/vst6u8M10dahlT7O7q3IoeMDliWURSJxiIMIZHl1Nk2wzFnKYa2gZCeEN9EVo3viJn7pSX75D8FDhhmLwjjeuoW/oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com (2603:10b6:a03:3e2::13)
 by IA3PR19MB8661.namprd19.prod.outlook.com (2603:10b6:208:51f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.31; Tue, 30 Apr
 2024 14:22:26 +0000
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47]) by SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47%5]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 14:22:26 +0000
From: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>
To: Jason Yan <yanaijie@huawei.com>, John Garry <john.g.garry@oracle.com>,
        "james.bottomley@hansenpartnership.com"
	<James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Topic: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
Thread-Index: AdqWJbfhv3GSaG0rTeK0+6km85YpNwADuoMAACHtcIAABC5uMAEPIjxw
Date: Tue, 30 Apr 2024 14:22:26 +0000
Message-ID: 
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
References: 
 <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <09dd80bb-09f9-481f-a7a7-b9227b6f928f@oracle.com>
 <b1a5552c-689e-d220-88d3-56d24752be5b@huawei.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
In-Reply-To: 
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ActionId=9c4c8b42-f443-4c39-97f3-50db21a897ff;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ContentBits=0;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Enabled=true;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Method=Standard;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Name=No
 Protection (Label Only) - Internal
 Use;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SetDate=2024-04-25T04:57:26Z;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR19MB5415:EE_|IA3PR19MB8661:EE_
x-ms-office365-filtering-correlation-id: bf529273-9d80-46e9-ffd1-08dc6920f5ef
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-7?B?bTYzYzRSVkVnRHZ6R0JpdDA3ZTB4TDRVNzdkakRRL0xZN0JhWFl1b0lqNVZy?=
 =?utf-7?B?VmZaZXZlWjdlZjNpNHZyVnFibnlHNE5xeHIxZzRZMXJtL2dnOHgrLXVDRDFv?=
 =?utf-7?B?Wnc1VlowMjkxQWw1TktldWkzUHhLUjJCdGJ5TnE1NistbG1iRUp2WUxPcDUz?=
 =?utf-7?B?TWFoSk1SWnpvQnhLQ09raXBWb0pHSistUGFlMU5rZS9WTHU2U09abGZzWlhi?=
 =?utf-7?B?ellYbER4WDRsOEJDSystVldmOXpSOEFiRlpaNGlLR2NLQlJ2ZUN5VGZMbGo=?=
 =?utf-7?B?Ky1Nc1FiQ1l4VkZJSVViQVpHcmsxVlJSVWRjTHBsWC9mS2M1S0p4aTEzSk1B?=
 =?utf-7?B?RXVRNE1HQkNMb1lRTmROZkl5Ky01L0FXei9ERG5iVkVOaVEzaU4wUnJvKy11?=
 =?utf-7?B?bGYrLUN2NVNLbk1ralhPUURKSlNFNWk5NTg3T0pzVVhVVDRnODV5Wi9tZFVh?=
 =?utf-7?B?WnRsYmlhYUw3NistUzNaaTNza0xZWHRINmhLUVVnb29qVWFhMHgvS0M5dTg5?=
 =?utf-7?B?cGpoTVNKcGc4ZVhtcWRHZmlyS2cxSDVtMDd6SEFOcUt4amx3bXFKVVdCRFZt?=
 =?utf-7?B?bVgvL080VUtzd2ZzOThqUkEzVUlPQTJxcnA3Ky1EMkVNR25IN3ZYS1hGM3FE?=
 =?utf-7?B?U3RSM1JMdDYyZW1UTzhYVWVXWCstVXNKZ2Y0ajhhV0FjNjlkZUpuU1Jsa2NG?=
 =?utf-7?B?L3Rrc3E3ZXFyT0g5SlAvRU5Xd3N0MDlSbG9CZjdGQWVDbmRZRGtaTGVaWUVU?=
 =?utf-7?B?RmpTRTl0VWVmcmh0QU90cHRCaXVPbzBHRXFUd1NEbUs4WVRKeHZlWjB0Slpx?=
 =?utf-7?B?ZjhqWXVKR3BpUUhqSGJESFBXT2xlWkVVcWlrbnk1UmdIQksxenpSVXVyZGtV?=
 =?utf-7?B?OU8rLWFDa2NFYklMRllmMjg3T0tWM2pTY2pPOVhRczBkR1phVVZDQXFRZGpa?=
 =?utf-7?B?clFJWENnazFUY0tEZGsyQW5hKy1ja0pZODhCQ05uVm5HTjFiKy1MdHhrWXFL?=
 =?utf-7?B?MFQrLXBvN1pKS24vM2ljS3ErLUhhbGpBSEVaUG5sblkyZy9icmx2VjRqd3N3?=
 =?utf-7?B?VUZIc3lYYXIvdjc4Y2RnclZwRWZ4MTlwZHRVUGptZ24zRGZQWEZRQWk5V09O?=
 =?utf-7?B?cXVKNTdTWWFmZXE5cEtMVVE0eTk5Uk1rSHZPbVFLTnhqTG1rMktlUmF2cHBL?=
 =?utf-7?B?S09EYnhtYVpyUldUVzN6YURGMkdkLzNRRjEwS29nWWFXbG13ZGtPNjNQb2J3?=
 =?utf-7?B?UXVhTW55SzhjcDY1Y0NiN3NZcm9ZSzFpVjFwc3lXWTFCN01JMjVCbzBlOHhY?=
 =?utf-7?B?bjBkTDhRMFJlTERMQnNaWSstTFlIbS9yKy1rVW1mU0EyZTgwRGpFSGpPY09P?=
 =?utf-7?B?Wm93M0h1clFYODN2RystNnlQcjNIUVI2anZLTUVpZUthZm5ucUF6cTF4WU9m?=
 =?utf-7?B?Y1BaaU05MWRCMzJKMGZpUmpQOEJCR1hMNTA3ZUFmYXVGZHg4bm9IMWhtZTBW?=
 =?utf-7?B?WkZuRVBRMlQ1RWJ1VW0rLWJac1JESDkxYUNZcHg5SnJRTkQ2a2wyaTJjM3pr?=
 =?utf-7?B?M1F2b1MxYXRra2hNSE1Jc3V5dHpGOEhuaFBGd2VXRzh5NUlBMnhrRzh3T3Jx?=
 =?utf-7?B?YzVVWlF3V3FXaUJsTnl5THMrLXY2b3d2QlVKTTQ1czZTUUxiWHNoRDExOTNk?=
 =?utf-7?B?UmpMRkhGQTNDTGlaZVI0NVlnRjlMSUtIajM3VFF0ZVExTlI4eUFmRW1aa3dY?=
 =?utf-7?B?T2tmSWlCejdhaThhQnpsY2dEdm1QNmwyRmZKWndIVzRMR3YyOWkvcXFLejVs?=
 =?utf-7?B?OHh4MkxsUC9oeTA5b2FHRGRmYUhrR2ZMbHRXeVYvMWV6QndqM3crQUQwLQ==?=
 =?utf-7?B?K0FEMC0=?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR19MB5415.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-7?B?bDJxRFZlYm4vNGowZGQxRlhHa3FkU1NWNy91RUE3bkJSWGZnUHFjSHQ2YzFN?=
 =?utf-7?B?QVlydHc2UXRnbjYrLUZuTzE1VnVuc0dkbzRGRkp1Y0FjbUpZSnFrZXNjdDc=?=
 =?utf-7?B?Ky1Ra2xlVUJXM1Bhb010eElaSXFqTjFQcC9LRHYzT2Y3NHFOMCstMUwxZFJ2?=
 =?utf-7?B?T0dzdWhqa3R0eklNQ2lpemFzd3hNdDJWbFMxMThVVmJjM25hZzY4ekxvQTNh?=
 =?utf-7?B?M1Qvb3BaYlZNWmJDUFNrWGFUZjRkOU95TEpIdDFnRDBEbjk3ZE1JZndNSzFy?=
 =?utf-7?B?Ky1BMmtJYi9ONnJUd1JZM3lyYU16YS94a3FYRVdYaU5uWlM3Ky1PNTVSMlRH?=
 =?utf-7?B?MXVoOWExNkpNU2RHMkRnYWpNcSstQ2dhbGduVmdXKy03cHUzbHJyL3g5cUZw?=
 =?utf-7?B?S3dzamwwUXYxWUozcmlkc1ZDTDJ1T3BwTVFwVkJhS0pvQlZoYmxZa1dGVVho?=
 =?utf-7?B?ZVE1eThWek8yTVdOWXRrUnhlQzRYTXFIRGEwQzdaMGtUYnhTNG01SXJybkd1?=
 =?utf-7?B?VFp1Y0VycFVMSjVSdU9UcGpjZ1BMeURzcGpkU2ErLWNPcFVXekRsY0hoRFlU?=
 =?utf-7?B?UVY0SzFUKy1xMTV6NWNYbmpBc21LTUNGMHIvanNEMEVwY0paNFM4TVUxckJC?=
 =?utf-7?B?Q2tUdXRZdFErLUpGZXNQbERDR2ExTk15MWVFUGwwQUQrLWhjR2Z3UGxGWkIz?=
 =?utf-7?B?cEVsVzNYd1FQZXAxY0Exb3oyV1VZTVlkcGZ3d3htRzRvUFozOXl0ZFd5aDFz?=
 =?utf-7?B?U3RJZjI2dkFDczJ3WEkvMk1XN0plYkFPVjRGTDVrNVJCbVhZVWRsSVVtUUJx?=
 =?utf-7?B?cjdNcFduYjJIUm5mWVZMTW1pZDBwckovWHdlOFNIbTdrcHc3T2syYTdSYThN?=
 =?utf-7?B?ZnhIcjI4cXJDdnMyTWZ0ZTBvMnZwQlFabVR0R0NrOG1OZlpjNVVpODd5dFA3?=
 =?utf-7?B?QnRCVEtHVlNUZVduemczWUJQZkZIc0w1MThhUUhHQXFpTWVYeGRvSGFPaFc2?=
 =?utf-7?B?UUhsOVRvRThOY3JyZXoxR0grLUdzV3pxZDhLSDJXUUJ4NXlDeistcjhVZUd2?=
 =?utf-7?B?ZjI5amhkVnRjZ2I3MVhEZDRJMFdKQURiM1V2Ky02aHBYb1NGWDloZkx6TmVu?=
 =?utf-7?B?aUF3bE9IZFdFd1Y1VkYzYXJqU1lpZmJlWlpUd0tQTmFBKy1kdWgwQmZ4ZnVH?=
 =?utf-7?B?UVJEZFkrLVJzcistdXhOVkg1UnNtaWdQWHZOL3Q5YUZZc3dPdCstOU8zTldp?=
 =?utf-7?B?T2JNaVpGU3lWaFFuZktTa0l1YnZ6VTNJTEtIT2JsVGtNeDlaTXNwRzNOSlFY?=
 =?utf-7?B?c3lXZlpRekVORm5RZVhyYWJzYW1CUnVFRW9oQUw0ZTZELystREFMa25tN1NL?=
 =?utf-7?B?UUJKM0VqN3U5eG05S2o2T3JYT1QyWFViaDZSeWhrZlRmUzZ5djlMU2ZOYm45?=
 =?utf-7?B?REVsenE2T3VIaWI4Y1pNTXJsQ3dBOVZ4SjNyQWQrLUFMeTNmWjVFeURLNExi?=
 =?utf-7?B?UHIybWs5WjFUR3JvejVnY2g2T0l2eFFvLzVCNGhLd3FvQzZzVWhOYkhucjhS?=
 =?utf-7?B?VjNIWGhuTDJLMWJBUlVFaVh4cWtHUUFWbkJON1JETzFLV2NDV1J1cGQrLW1S?=
 =?utf-7?B?SWh3Rld2c1RITTI4cVB3QXdGL2srLWRmbDFkeUlRLzdnNTFrQU1kWEhJMmtr?=
 =?utf-7?B?dFdrNHlHQ090Y1ZSaVB2di9TVndRVkljcy8vTU80dUI2ZXhoMU8xVElEWjRM?=
 =?utf-7?B?MUxjZGo5VVltV0huUlE5dDY1QlFKc0czRzdaZUNhV2hIODlLeXRKVW95cXo4?=
 =?utf-7?B?T2FScXl6aktjTllweUhrcEt1QzVMY1Jsa2lmTWJoTUN4cWdjMC9PQUErLU1Z?=
 =?utf-7?B?bWUwb0NMa3liaTB0Ky1SMFNhTzZQNHRKUzZqZWwwTkIyYVd6WWNOb2xxRGxZ?=
 =?utf-7?B?N1VrNUR2RFlvRm9WVVh2YzBJenhqQUl3bjB2dEFHNjBlZTNWSVRlU3M1WVpJ?=
 =?utf-7?B?ekhhRlFYMFB5MFRBZjF3NVdNWlFKSzNpT1N5a0VVdk0xR29SRGZYeVFhVzBH?=
 =?utf-7?B?WlM1S0QzUm9FWXRkNXZacEdTeEZ2TDNjdHlTRGFGM1RiWVcxMSstaXNSMk9C?=
 =?utf-7?B?Nm5NOGhwbm9DcWo4a3FQUU85d0swRHk0M3ZWZXhBK0FEMC0=?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: bf529273-9d80-46e9-ffd1-08dc6920f5ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2024 14:22:26.5412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C5RORrqqXgmbu/ABtn0J5K1IO8fK37RBlEYcPm5n4b86LIaIlHq0yetgINaa4+UGOcsJ3BXfx08uUcWKV8Ob6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR19MB8661
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_08,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404300102
X-Proofpoint-GUID: fhL8-5PgSMRFqAXWdxnMExPydjG4Wa4w
X-Proofpoint-ORIG-GUID: fhL8-5PgSMRFqAXWdxnMExPydjG4Wa4w
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404300101

I suppose you have got the log file I attached.
If not, please let me know.
Any update about this?

Eric LI


Internal Use - Confidential
+AD4- -----Original Message-----
+AD4- From: Li, Eric (Honggang)
+AD4- Sent: Thursday, April 25, 2024 1:04 PM
+AD4- To: Jason Yan +ADw-yanaijie+AEA-huawei.com+AD4AOw- John Garry +ADw-jo=
hn.g.garry+AEA-oracle.com+AD4AOw-
+AD4- james.bottomley+AEA-hansenpartnership.com+ADs- Martin K . Petersen
+AD4- +ADw-martin.petersen+AEA-oracle.com+AD4-
+AD4- Cc: linux-scsi+AEA-vger.kernel.org
+AD4- Subject: RE: Issue in sas+AF8-ex+AF8-discover+AF8-dev() for multiple =
level of SAS expanders in a
+AD4- domain
+AD4-
+AD4- +AD4------Original Message-----
+AD4- +AD4-From: Jason Yan +ADw-yanaijie+AEA-huawei.com+AD4-
+AD4- +AD4-Sent: Thursday, April 25, 2024 10:58 AM
+AD4- +AD4-To: John Garry +ADw-john.g.garry+AEA-oracle.com+AD4AOw- Li, Eric=
 (Honggang)
+AD4- +AD4APA-Eric.H.Li+AEA-Dell.com+AD4AOw- james.bottomley+AEA-hansenpart=
nership.com+ADs- Martin K .
+AD4- +AD4-Petersen +ADw-martin.petersen+AEA-oracle.com+AD4-
+AD4- +AD4-Cc: linux-scsi+AEA-vger.kernel.org
+AD4- +AD4-Subject: Re: Issue in sas+AF8-ex+AF8-discover+AF8-dev() for mult=
iple level of SAS
+AD4- +AD4-expanders in a domain
+AD4- +AD4-
+AD4- +AD4-
+AD4- +AD4AWw-EXTERNAL EMAIL+AF0-
+AD4- +AD4-
+AD4- +AD4-On 2024/4/24 18:46, John Garry wrote:
+AD4- +AD4APg- On 24/04/2024 09:59, Li, Eric (Honggang) wrote:
+AD4- +AD4APgA+- Hi,
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- There is an issue in the function sas+AF8-ex+AF8-discover+=
AF8-dev() when I have
+AD4- +AD4APgA+- multiple SAS expanders chained under one SAS port on SAS c=
ontroller.
+AD4- +AD4APg-
+AD4- +AD4APg- I think typically we can't and so don't test such a setup.
+AD4- +AD4-
+AD4- +AD4-Eric,
+AD4- +AD4-
+AD4- +AD4-I also don't understand why you need such a setup. Can you expla=
in more
+AD4- +AD4-details of your topology?
+AD4-
+AD4- I believe this is common setup if you want to support large number of=
 drives under
+AD4- one SAS port of SAS controller.
+AD4-
+AD4- +AD4-
+AD4- +AD4APg-
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- In this function, we first check whether the PHY+IBk-s
+AD4- +AD4APgA+- attached+AF8-sas+AF8-address is already present in the SAS=
 domain, and then
+AD4- +AD4APgA+- check if this PHY belongs to an existing port on this SAS =
expander.
+AD4- +AD4APgA+- I think this has an issue if this SAS expander use a wide =
port
+AD4- +AD4APgA+- connecting a downstream SAS expander.
+AD4- +AD4APgA+- This is because if the PHY belongs to an existing port on =
this SAS
+AD4- +AD4APgA+- expander, the attached SAS address of this port must alrea=
dy be
+AD4- +AD4APgA+- present in the domain and it results in disabling that por=
t.
+AD4- +AD4APgA+- I don+IBk-t think that is what we expect.
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- In old release (4.x), at the end of this function, it woul=
d make
+AD4- +AD4APgA+- addition sas+AF8-ex+AF8-join+AF8-wide+AF8-port() call for =
any possibly PHYs that
+AD4- +AD4APgA+- could be added into the SAS port.
+AD4- +AD4APgA+- This will make subsequent PHYs (other than the first PHY o=
f that
+AD4- +AD4APgA+- port) being marked to DISCOVERED so that this function wou=
ld not be
+AD4- +AD4APgA+- invoked on those subsequent PHYs (in that port).
+AD4- +AD4APgA+- But potential question here is we didn+IBk-t configure the=
 per-PHY
+AD4- +AD4APgA+- routing table for those PHYs.
+AD4- +AD4APgA+- As I don+IBk-t have such SAS expander on hand, I am not su=
re what+IBk-s
+AD4- +AD4APgA+- impact (maybe just performance/bandwidth impact).
+AD4- +AD4APgA+- But at least, it didn+IBk-t impact the functionality of th=
at port.
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- But in v5.3 or later release, that part of code was remove=
d (in the
+AD4- +AD4APgA+- commit a1b6fb947f923).
+AD4- +AD4APg-
+AD4- +AD4APg- Jason, can you please check this?
+AD4- +AD4-
+AD4- +AD4-The removed code is only for races before we serialize the event
+AD4- +AD4-processing. All PHYs will still be scanned one by one and add to=
 the
+AD4- +AD4-wide port if they have the same address. So are you encountering=
 a real issue? If
+AD4- so, can you share the full log?
+AD4-
+AD4- Yes. We did hit this issue when we upgrade Linux kernel from 4.19.236=
 to 5.14.21.
+AD4- Full logs attached.
+AD4-
+AD4- +AD4-
+AD4- +AD4-Thanks,
+AD4- +AD4-Jason
+AD4- +AD4-
+AD4- +AD55XU4AUgeYelIp/wE-
+AD4- +AD4-
+AD4- +AD4APg-
+AD4- +AD4APg- Thanks+ACE-
+AD4- +AD4APg-
+AD4- +AD4APgA+- And this caused this problem occurred (downstream port of =
that SAS
+AD4- +AD4APgA+- expander was disabled and all downstream SAS devices were =
removed
+AD4- +AD4APgA+- from the domain).
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- Regards.
+AD4- +AD4APgA+- Eric Li
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- SPE, DellEMC
+AD4- +AD4APgA+- 3/F KIC 1, 252+ACM- Songhu Road, YangPu District, SHANGHAI
+AD4- +AD4APgA+- +-86-21-6036-4384
+AD4- +AD4APgA+-
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- Internal Use - Confidential
+AD4- +AD4APg-
+AD4- +AD4APg- .
