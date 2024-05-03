Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com [148.163.137.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB9D21A0B
	for <linux-scsi@vger.kernel.org>; Fri,  3 May 2024 03:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.137.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714706152; cv=fail; b=o/n9EqxCXpZOlHN5wM8arByucdzWnAEGB3VI87T3QAQxID3+oJVEeCoXszSup88piJWon1hpUXCPWrP92gVhNXgvVIhgfquleWPx1eF01hjFkrgMlXAXkBnoKF1z1e7rVkuJAHANuaEf0oBew91AtusbePiG50bGJJJ3OJ2S1QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714706152; c=relaxed/simple;
	bh=b7I6GaMPKcNGu1ZB1YZE8kfuhrs9LRQ0Q8xCIq0Nfvk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dS3Bvn0Dl5SWv3NM6vaGozL/fLDTOeJs2ApLA+mh5uEqD3KkC7LjZRRI5qlVRA7Bff+2STO+KxuLAOfvdHHgnUpN6FK1wLbDEV9nqit22lZvnunFX+04aM8TRdarDMjls1zrKqiFtCi0TN52kWd8hiajC4ANhtvautsz//t3ATc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=fgScBtfU; arc=fail smtp.client-ip=148.163.137.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="fgScBtfU"
Received: from pps.filterd (m0170395.ppops.net [127.0.0.1])
	by mx0b-00154904.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44324Gif015285;
	Thu, 2 May 2024 23:15:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=b7I6GaMPKcNGu1ZB1YZE8kfuhrs9LRQ0Q8xCIq0Nfvk=;
 b=fgScBtfU/3QxYJmPdScwVoH207tqOso3KOcrnIhW4kMaqIIGywqBZyy+6xX6M8Gp5xat
 BgNf5cfjsJ8BXEiIxwMAB9cjygNwouZhXHlp5eXrc1PrZiMZdv10u8BGXa4GHIhGHsML
 rlEFqaR0MvxYL26e2lJBVgaC745yv9l7mxXnuyxYmoZYVIQ9NQPB8/Qe2dyF3ZNEEh0m
 WS77FVUcG0Jk5sjidpvogNJEssXXowrL1Wz+wX5R5wwkfzT3+1e4Jb2U19+uC5lHth42
 TerHVH0Sb/mySSP3zgxOiSJEBx/Rv6MiCnRRXZdnRZA51Dclr9f3ExL99VUaMXr+Fjkq Dg== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
	by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 3xrx1sr5sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 May 2024 23:15:46 -0400
Received: from pps.filterd (m0142693.ppops.net [127.0.0.1])
	by mx0a-00154901.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 442MF4bd004204;
	Thu, 2 May 2024 23:15:45 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 3xvhukbg97-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 May 2024 23:15:45 -0400
Received: from m0142693.ppops.net (m0142693.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4433Fgwi002659;
	Thu, 2 May 2024 23:15:42 -0400
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by mx0a-00154901.pphosted.com (PPS) with ESMTPS id 3xvhukbg90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 May 2024 23:15:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mh7IE/8rHgpioBKxCKkSlr60wva/xT1PfFCcT9gQK0wSRy/8IJJ5D5JT6i4z69aHLYrMHx7XsWiqOXZ2sxAqzxMuirw1jcetvEwgGc2nOpuvd3sKqRhGqRKUZzoqlrWQYYwhaTLCUmGVD9nIKCfv/aHjVvhraIVSS3iMui4yLmoMV0xq/BTWgbG11nooYqCOo7qtcWtpOce0agnP3R3jG40MOfMmwc0WzyXnmssmlvY8O1QEXJMdWdGBgWCPnh1Dek2McpK6OWoFYGpCFGRWujgrWvRo/4sIVTVe2zrf7fA6ZjZgvxugUMQNeytI9uoIXvrW62zbUw9SAAVi/ED8iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b7I6GaMPKcNGu1ZB1YZE8kfuhrs9LRQ0Q8xCIq0Nfvk=;
 b=bXN2K/+P+LCuy0+y21wmugXZ+WBQ7l7riu+rC7GEoWgj+qcwXqgBCeyFDBsMGuf17i3gxWV/YRrahUr8+wO27BoEKMHZL92CW4xPT3dYb4JwpR+/5+e0G7ovsEdZD7x/BHJ14rprBmEbg6miD/ksV+5Hrb/YKgij6tcZXhh5Fx2aq6gJ/rhd9QR87DtsUpdVx4ZjUYLU9yyp04J8K5rV/iRqSgu6c1mdkVNLneWlDELT1+5qkpwSFefQaAr+FVWZiVyWCt62A4bNfAGk5Aw/2Kfc9Ervp3+oh4bZFe85eJknbZNTzi3E+fiGx+tOCNNsnpQuusQ0ZiPklbf2mYl5Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from PH0PR19MB5411.namprd19.prod.outlook.com (2603:10b6:510:fb::13)
 by PH0PR19MB5362.namprd19.prod.outlook.com (2603:10b6:510:f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.30; Fri, 3 May
 2024 03:15:38 +0000
Received: from PH0PR19MB5411.namprd19.prod.outlook.com
 ([fe80::d042:8333:1fbb:a72a]) by PH0PR19MB5411.namprd19.prod.outlook.com
 ([fe80::d042:8333:1fbb:a72a%5]) with mapi id 15.20.7544.029; Fri, 3 May 2024
 03:15:38 +0000
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
 AdqWJbfhv3GSaG0rTeK0+6km85YpNwADuoMAACHtcIAABC5uMAEPIjxwADJmXIAATNqvUA==
Date: Fri, 3 May 2024 03:15:38 +0000
Message-ID: 
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
References: 
 <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <09dd80bb-09f9-481f-a7a7-b9227b6f928f@oracle.com>
 <b1a5552c-689e-d220-88d3-56d24752be5b@huawei.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
In-Reply-To: <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ActionId=d5c30d63-4807-479d-83e8-231384b78fd8;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ContentBits=0;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Enabled=true;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Method=Standard;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Name=No
 Protection (Label Only) - Internal
 Use;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SetDate=2024-05-03T03:04:31Z;MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR19MB5411:EE_|PH0PR19MB5362:EE_
x-ms-office365-filtering-correlation-id: a79231b6-485f-4ae1-d297-08dc6b1f4eb7
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-7?B?QjVITmZsSTRKT0VtT2w0ZUViNjN3QjZVWUF1VzRibXp4bXJBQzlzTDhMMjRt?=
 =?utf-7?B?TSstSERIbWJDRHNuU1F0Mi9ZSzVPeDV1VjUvVEZWQ090b0l4R0VybGRaRDdw?=
 =?utf-7?B?SHdPaDV2dHhhbUVsL21OTnh2MHNJeHpTeHQwZ3RQSUFRNlIxbTF0VWlnOG0v?=
 =?utf-7?B?bW91bWY1ajBWNkN5bnhWeTBKZnlYR3hEWVQ4ckhqVmZwUkcwRHhUdUVnY2tL?=
 =?utf-7?B?b1R1VFZnRG9Wb09IZ2lWb2xSV0dGL00xZnlIUGRUdlV1Z3RRSmhKbnVhMnY3?=
 =?utf-7?B?Ky1CazNGZ3loRzNObng0bGlscFFVbnZFZy9IRnlnMjZndzFKd0FQSHp2TDlj?=
 =?utf-7?B?dUtXUWIxWjdlc0l5VUZCVXRzV3ZYSHZ1bXUrLXJqRFNmdU5XaVpvMGFIRmdQ?=
 =?utf-7?B?WC9hLy9mTldZaThGRG1IMW9PSDQxVThUc25EWVJhdTR5RUFLZ0JUWDE0SWZ0?=
 =?utf-7?B?U0p5MUZPKy10cW1ObDg4M3FtdThHbnorLWhicVR1dlFmZVV0bDR0Ky1yRGw0?=
 =?utf-7?B?UllWTllKYVlESUFpUVIxZ2xEZlFCZ2FmMnRhNnJCSVJMSncwSTRLV3NQb3Zp?=
 =?utf-7?B?TWUrLVRnNjJCTklyR01yMnBHeFBDdUpkNE45WkVTTXZwRXR3TlZHTkNqOTAw?=
 =?utf-7?B?MDVMS1hJeXpST0ZUdDZQaEN2SWRSVzRvWmhXRjlHYUlkSUtDTXozdDN6OWs3?=
 =?utf-7?B?Tnh4VXdNbkZqVUVpalpmWFRNQ0hXY3Y4TE5tdGI4QWd6bDZjT3BKeVd4UGN6?=
 =?utf-7?B?SllHSDlFdHhlenJtSnBmKy1wVGZXNmIzOElBaXlKMUlvQzI2Q2pFQlE3NnVK?=
 =?utf-7?B?Q0tZdC9zazlrbnBsZ3UrLUtYaUh3ODBSUGdCMUJxRlNsR3Jwd2pHTVo3YktR?=
 =?utf-7?B?SGxFTzVpZlllaHhCZklQeXg3OEcxQW9aeGZIdUxSNTVENUNwb3VSR1RCai8=?=
 =?utf-7?B?Ky1BV2NnY0cyTlN6anplQ1o1WDFDMXlrRDFYMSstckxlbkkyN251WDA4aFpu?=
 =?utf-7?B?QXRnMU91TnBNSjJpbHJEbjR2WTVCT1FKTk5taHFicGxsa0xpOEV0RWJZb1cz?=
 =?utf-7?B?NEUvaHpOVXIyN2pwM040WGN5aGpWMlNZR0dtQ0crLU5kcHo1SkhoRi9STFI5?=
 =?utf-7?B?enhXdUxBaFh5bXdHTFVIQVkzdXUyMmVXSG50SkFNVi9xZGUzQWFQUHZ5bjZu?=
 =?utf-7?B?dm0xOUZZSzFSMExJMllxaFpZOVlGUkdlQlhHVHM1bXRXZ2RaYW8yTWl1eWxB?=
 =?utf-7?B?OWxKcTRBb1JFR3B4WnIxam5Ra1lVa1MvVUlzL2hRcFBLdHFSRnBrSmo4UFVW?=
 =?utf-7?B?VjFqMGRabW0wVDliOFA5UEhuM1czcGkxMnE5dkswd3NNR0o4UkhXQm00cU5l?=
 =?utf-7?B?V3E5ZzZDV1U3eWYrLXdydystaWFzNWd3ZXM3M0svWGNSeFpQSE5hQlM2Y2pI?=
 =?utf-7?B?bnA5SUxVQjhCTXNEWklhYUFrejByNk1hNElPNFEwRVdEQm9TY3NQVistREFu?=
 =?utf-7?B?YystbkRDeUZpbkIyNmp2NEFTVUthQUlMY0JvcTRBaFBEeXFOMnFkLzgwM3JG?=
 =?utf-7?B?SlU2YTRMNkJBQmxUY2VlcGlsVnlyZXBEaU9Ld1pQWkc2bTVjMk9JRjFNdjl1?=
 =?utf-7?B?M2QyUnplWkJuN1JWT2VZMXY5Z1VodThTdGFyNnR5WUp5V2VCcEhLalZzTk54?=
 =?utf-7?B?WmZMcnBGWFZqTEQ0UHFYTUh2Snh0Z0pnUUJHUkJ5b3cyMnNnc0RsOERwR3Ew?=
 =?utf-7?B?aVpuU2djWXZyMUFEUUlUcE8zN09tTkJGR3dkWGt6UG1OdEYzWDNVNFhhQ1BB?=
 =?utf-7?B?YUxoSHVJL1dWQ29kL2lwV2wzYmlBSjNjVENGVy9NYkd3K0FEMEFQUS0=?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR19MB5411.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-7?B?M3NXRHBveE43V0t1WlR5aGtLMVZEbVBuc255cDhDWU1yeU1KY2doQ3ExOWJw?=
 =?utf-7?B?Tnp2dHpxMjFVZXppRm9hU0REZlJ5bmo3RTlnNHkwRHExTSstemZVRW5XbEZX?=
 =?utf-7?B?VndUWDNFS0FoS21md3U3NWVZSVFYNkMxcXNsKy1RN1pIOU1mdFV0Q2tTUnhW?=
 =?utf-7?B?aDgvQ1NSL2N6YnJIYkhJNXREVTZvZ2d6OUorLU1oN2oyRkJxUlVBbEEzNjY2?=
 =?utf-7?B?TTJxQUo4cDZzREF6ejlvSDVpSVRGYlZjdzhIa2Z5NTR0TW84ZWU3Y3BtQ1F2?=
 =?utf-7?B?TGJneVJESUlBU3loNEVYbUFTSXBFL294YWxCcG1jL3ltU1QrLXpDMTdEL2U0?=
 =?utf-7?B?SU0rLVJNVkNWalFMWEMwbXNkNjlxeHBRblQxcSstVHU2SkYwVnFnZkpyb0xD?=
 =?utf-7?B?VTdkMjI5cDl6RmE3ZWttdXZoNVhoSWN6T3p2YzI3b1M1V2o3c3Buc0dIM0J5?=
 =?utf-7?B?ZUxpYTZsMVZoRXBlQjViUGJjS2pTVFVxdUVrKy1ieUxiSWx4ekRvVGVYRW9Z?=
 =?utf-7?B?Q0FqRTl4aVRZUTRoSnN3UXVEYTcyWnV6TGF2WFM5Y09uZ3BkaystL2oxWTFV?=
 =?utf-7?B?VDc0T3hTMGR3MnhEWEdsV1N4NWtScWplWkk5RnI2dU1vN29qbkdRTTZtVDBK?=
 =?utf-7?B?ckpTNnp0VVJmN2VQYVdwM3drT3hZYjgrLWR3eFZGYkRmRktCYWtCRkMxbGI=?=
 =?utf-7?B?VistTnk1dmxzZFRGSzZtVERHYkgxV1dzcERySTFGMEZkMWpKR2M3dUtMdzU2?=
 =?utf-7?B?c2NrcnBCRTBaRWJvcW9qNjRSUzRoODlmSXhFRjBIUUlVRDZSSDRxL2xaQzlZ?=
 =?utf-7?B?S0VpUm5ncXZQamQ3ekY4azNRSWVqUllXZlpZVGFHd3ZPSnN5ZWVlL014eUVN?=
 =?utf-7?B?a09VYUhLcGczdEthVzg0SldiRE41ZWRDdjV2aXZxT09xelBpaThqKy1LNlAy?=
 =?utf-7?B?eHdRZEpjNGlLQkR4M3VUMVRqTVFHR0FLOTlwRDNaZUkweGxuQVArLXN1eWVu?=
 =?utf-7?B?NnpaNystR1BXTDA5VGZyR0Q4TUVLTi8vcFo0L0JYVnNnL3FtdDI1LzdSbEVw?=
 =?utf-7?B?b2Z4cE1jUUZLZk1sNDBFeVJiMzJwQUtqbktsTEQyUFUxNVd6TFovd2kxL1NZ?=
 =?utf-7?B?dnBUY085eVpSckZGeFYvU0xqaXZUZHU1bjVMdnp5QVlMak5qWmx3UExDMWth?=
 =?utf-7?B?R3NCQ1NtQTk3cUtTVWVYWTJSL1k3d3ZvRWg4aXlBbmhJMVhSRlhkbENiQSst?=
 =?utf-7?B?ZllQVG1XcTB4MDFWQ3MyVU1EcGppVFhlOU01c3FQY0tBSXZEdmVaZElLTEhh?=
 =?utf-7?B?M1JPOFBMVHIzS0dWSVMwSmZDYmFZbnlZU0dPbEk1bEhMakFseHpuOGJha2d1?=
 =?utf-7?B?d01HUkRpQ3pOSXdpL1hVamdaRWFTUmlmejVOL1Zqb0d3MkNmZWRidG1wWFJl?=
 =?utf-7?B?OU0zSm9kbTByZHNaNk5jV3BBYzFXOFhOQldqNWQ2YllxKy1pM2tqZU9xZnBP?=
 =?utf-7?B?UHBEQ09TM2hQQXNTbFpzNkIySUFiRSstQXdLczNOR2lxdnA0amx2bnZHaXJ5?=
 =?utf-7?B?MHkvV0xlOEhLQkdVKy0zNVNaYUtkYWRoc0FKRnFGNnRPWTBHMENtMmFvSE9R?=
 =?utf-7?B?M2N4ek0vN2pnVUc1NGdySHJiKy0rLW5hd1c1WXVSN0hIVGlTZ3BWR29XTHZl?=
 =?utf-7?B?ZnlENVlZVG9oRU1NbDFhZnFhVVE4TFk3SEFxY2pLbTY5a2NleUpZMHhtdnVP?=
 =?utf-7?B?WVJad3dhd3VrMzAzbHNPRFhLV3ZiaHdsd0RBZXpoNEFqQWpzZ0hxYnYyMnZx?=
 =?utf-7?B?MDdoS0hoS3JocHIrLUM4NHFNQlZMaUloV0U2RllTUG05U1k4UG9oZVJUZzZR?=
 =?utf-7?B?ckxGSFhWcEFIU2lGdjNvNzh3ZjN0aTlUUm80Ky1RMFlYY1R3VmNHS2JJNUdv?=
 =?utf-7?B?U1NEbmM1dXFnYXQzNUw3dVhRYW1yd2o3ZVFBVkdSUllzMHp0QkJINUFGaFgw?=
 =?utf-7?B?eFA0YWN6YUQ5eXpRVDY0cm9kUFYwKy1wKy1veU9KNE01aXpFVm9sa09WN0Y=?=
 =?utf-7?B?Ky1BTVFhQVVKVGpZOEl5ejkzYlJRM3JNQW5oNU1pcHQ0aW9YRGtSZlk2N0R3?=
 =?utf-7?B?Qk1KTUtuZGZoNFV4c2o5YklqWXREeU02VC8rLVVFcytBRDAt?=
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
X-MS-Exchange-CrossTenant-AuthSource: PH0PR19MB5411.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a79231b6-485f-4ae1-d297-08dc6b1f4eb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 03:15:38.8387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /rONYSobVgSwrFwdLV4yWHNrTjGk6Ts3oO0rqeLZ1cled1TzcxEy7CXz6Hf91zWhrbFxtbNknHEKM+EmDjYchA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB5362
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-03_01,2024-05-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405030021
X-Proofpoint-GUID: -DNNGFRV9uK-ZbVAbMl5NewHIHxvoVBZ
X-Proofpoint-ORIG-GUID: -DNNGFRV9uK-ZbVAbMl5NewHIHxvoVBZ
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2405030021

John,

I agree that the call to sas+AF8-ex+AF8-join+AF8-wide+AF8-port() is not man=
datory. In fact, some logic here is similar to that function. We don't need=
 to do it again.
But just updating the phy+AF8-state may not be enough. I suppose you still =
need to add that PHY into the corresponding wide port by calling sas+AF8-po=
rt+AF8-add+AF8-phy() and update phy-+AD4-port.
Just updating the phy+AF8-state may avoid the port disabled in this issue, =
but other missing piece of work may cause other issues.

Eric Li


Internal Use - Confidential
+AD4- -----Original Message-----
+AD4- From: John Garry +ADw-john.g.garry+AEA-oracle.com+AD4-
+AD4- Sent: Wednesday, May 1, 2024 10:24 PM
+AD4- To: Li, Eric (Honggang) +ADw-Eric.H.Li+AEA-Dell.com+AD4AOw- Jason Yan=
 +ADw-yanaijie+AEA-huawei.com+AD4AOw-
+AD4- james.bottomley+AEA-hansenpartnership.com+ADs- Martin K . Petersen
+AD4- +ADw-martin.petersen+AEA-oracle.com+AD4-
+AD4- Cc: linux-scsi+AEA-vger.kernel.org
+AD4- Subject: Re: Issue in sas+AF8-ex+AF8-discover+AF8-dev() for multiple =
level of SAS expanders in a
+AD4- domain
+AD4-
+AD4-
+AD4- +AFs-EXTERNAL EMAIL+AF0-
+AD4-
+AD4- On 30/04/2024 15:22, Li, Eric (Honggang) wrote:
+AD4- +AD4- I suppose you have got the log file I attached.
+AD4- +AD4- If not, please let me know.
+AD4- +AD4- Any update about this?
+AD4- +AD4-
+AD4- +AD4- Eric LI
+AD4-
+AD4- So if you revert a1b6fb947f923, but then remove the call to
+AD4- sas+AF8-ex+AF8-join+AF8-wide+AF8-port() re-added in that revert, is i=
t ok? I am just wondering are
+AD4- we just missing the call to set phy+AF8-state +AD0- PHY+AF8-DEVICE+AF=
8-DISCOVERED after v5.3?
+AD4-
+AD4- Thanks,
+AD4- John
+AD4-
+AD4- +AD4-
+AD4- +AD4-
+AD4- +AD4- Internal Use - Confidential
+AD4- +AD4APg- -----Original Message-----
+AD4- +AD4APg- From: Li, Eric (Honggang)
+AD4- +AD4APg- Sent: Thursday, April 25, 2024 1:04 PM
+AD4- +AD4APg- To: Jason Yan +ADw-yanaijie+AEA-huawei.com+AD4AOw- John Garr=
y
+AD4- +AD4APg- +ADw-john.g.garry+AEA-oracle.com+AD4AOw- james.bottomley+AEA=
-hansenpartnership.com+ADs-
+AD4- +AD4APg- Martin K . Petersen +ADw-martin.petersen+AEA-oracle.com+AD4-
+AD4- +AD4APg- Cc: linux-scsi+AEA-vger.kernel.org
+AD4- +AD4APg- Subject: RE: Issue in sas+AF8-ex+AF8-discover+AF8-dev() for =
multiple level of SAS
+AD4- +AD4APg- expanders in a domain
+AD4- +AD4APg-
+AD4- +AD4APgA+- -----Original Message-----
+AD4- +AD4APgA+- From: Jason Yan +ADw-yanaijie+AEA-huawei.com+AD4-
+AD4- +AD4APgA+- Sent: Thursday, April 25, 2024 10:58 AM
+AD4- +AD4APgA+- To: John Garry +ADw-john.g.garry+AEA-oracle.com+AD4AOw- Li=
, Eric (Honggang)
+AD4- +AD4APgA+- +ADw-Eric.H.Li+AEA-Dell.com+AD4AOw- james.bottomley+AEA-ha=
nsenpartnership.com+ADs- Martin K .
+AD4- +AD4APgA+- Petersen +ADw-martin.petersen+AEA-oracle.com+AD4-
+AD4- +AD4APgA+- Cc: linux-scsi+AEA-vger.kernel.org
+AD4- +AD4APgA+- Subject: Re: Issue in sas+AF8-ex+AF8-discover+AF8-dev() fo=
r multiple level of
+AD4- +AD4APgA+- SAS expanders in a domain
+AD4- +AD4APgA+-
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- +AFs-EXTERNAL EMAIL+AF0-
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- On 2024/4/24 18:46, John Garry wrote:
+AD4- +AD4APgA+AD4- On 24/04/2024 09:59, Li, Eric (Honggang) wrote:
+AD4- +AD4APgA+AD4APg- Hi,
+AD4- +AD4APgA+AD4APg-
+AD4- +AD4APgA+AD4APg- There is an issue in the function sas+AF8-ex+AF8-dis=
cover+AF8-dev() when I
+AD4- +AD4APgA+AD4APg- have multiple SAS expanders chained under one SAS po=
rt on SAS
+AD4- controller.
+AD4- +AD4APgA+AD4-
+AD4- +AD4APgA+AD4- I think typically we can't and so don't test such a set=
up.
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- Eric,
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- I also don't understand why you need such a setup. Can you=
 explain
+AD4- +AD4APgA+- more details of your topology?
+AD4- +AD4APg-
+AD4- +AD4APg- I believe this is common setup if you want to support large =
number of
+AD4- +AD4APg- drives under one SAS port of SAS controller.
+AD4- +AD4APg-
+AD4- +AD4APgA+-
+AD4- +AD4APgA+AD4-
+AD4- +AD4APgA+AD4APg-
+AD4- +AD4APgA+AD4APg- In this function, we first check whether the PHY+IBk=
-s
+AD4- +AD4APgA+AD4APg- attached+AF8-sas+AF8-address is already present in t=
he SAS domain, and
+AD4- +AD4APgA+AD4APg- then check if this PHY belongs to an existing port o=
n this SAS expander.
+AD4- +AD4APgA+AD4APg- I think this has an issue if this SAS expander use a=
 wide port
+AD4- +AD4APgA+AD4APg- connecting a downstream SAS expander.
+AD4- +AD4APgA+AD4APg- This is because if the PHY belongs to an existing po=
rt on this SAS
+AD4- +AD4APgA+AD4APg- expander, the attached SAS address of this port must=
 already be
+AD4- +AD4APgA+AD4APg- present in the domain and it results in disabling th=
at port.
+AD4- +AD4APgA+AD4APg- I don+IBk-t think that is what we expect.
+AD4- +AD4APgA+AD4APg-
+AD4- +AD4APgA+AD4APg- In old release (4.x), at the end of this function, i=
t would make
+AD4- +AD4APgA+AD4APg- addition sas+AF8-ex+AF8-join+AF8-wide+AF8-port() cal=
l for any possibly PHYs that
+AD4- +AD4APgA+AD4APg- could be added into the SAS port.
+AD4- +AD4APgA+AD4APg- This will make subsequent PHYs (other than the first=
 PHY of that
+AD4- +AD4APgA+AD4APg- port) being marked to DISCOVERED so that this functi=
on would not
+AD4- +AD4APgA+AD4APg- be invoked on those subsequent PHYs (in that port).
+AD4- +AD4APgA+AD4APg- But potential question here is we didn+IBk-t configu=
re the per-PHY
+AD4- +AD4APgA+AD4APg- routing table for those PHYs.
+AD4- +AD4APgA+AD4APg- As I don+IBk-t have such SAS expander on hand, I am =
not sure what+IBk-s
+AD4- +AD4APgA+AD4APg- impact (maybe just performance/bandwidth impact).
+AD4- +AD4APgA+AD4APg- But at least, it didn+IBk-t impact the functionality=
 of that port.
+AD4- +AD4APgA+AD4APg-
+AD4- +AD4APgA+AD4APg- But in v5.3 or later release, that part of code was =
removed (in
+AD4- +AD4APgA+AD4APg- the commit a1b6fb947f923).
+AD4- +AD4APgA+AD4-
+AD4- +AD4APgA+AD4- Jason, can you please check this?
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- The removed code is only for races before we serialize the=
 event
+AD4- +AD4APgA+- processing. All PHYs will still be scanned one by one and =
add to the
+AD4- +AD4APgA+- wide port if they have the same address. So are you encoun=
tering a
+AD4- +AD4APgA+- real issue? If
+AD4- +AD4APg- so, can you share the full log?
+AD4- +AD4APg-
+AD4- +AD4APg- Yes. We did hit this issue when we upgrade Linux kernel from=
 4.19.236 to 5.14.21.
+AD4- +AD4APg- Full logs attached.
+AD4- +AD4APg-
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- Thanks,
+AD4- +AD4APgA+- Jason
+AD4- +AD4APgA+-
+AD4- +AD4APgA+- +eV1OAFIHmHpSKf8B-
+AD4- +AD4APgA+-
+AD4- +AD4APgA+AD4-
+AD4- +AD4APgA+AD4- Thanks+ACE-
+AD4- +AD4APgA+AD4-
+AD4- +AD4APgA+AD4APg- And this caused this problem occurred (downstream po=
rt of that SAS
+AD4- +AD4APgA+AD4APg- expander was disabled and all downstream SAS devices=
 were removed
+AD4- +AD4APgA+AD4APg- from the domain).
+AD4- +AD4APgA+AD4APg-
+AD4- +AD4APgA+AD4APg- Regards.
+AD4- +AD4APgA+AD4APg- Eric Li
+AD4- +AD4APgA+AD4APg-
+AD4- +AD4APgA+AD4APg- SPE, DellEMC
+AD4- +AD4APgA+AD4APg- 3/F KIC 1, 252+ACM- Songhu Road, YangPu District, SH=
ANGHAI
+AD4- +AD4APgA+AD4APg- +-86-21-6036-4384
+AD4- +AD4APgA+AD4APg-
+AD4- +AD4APgA+AD4APg-
+AD4- +AD4APgA+AD4APg- Internal Use - Confidential
+AD4- +AD4APgA+AD4-
+AD4- +AD4APgA+AD4- .

