Received: from mx0a-00154904.pphosted.com (mx0a-00154904.pphosted.com [148.163.133.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59541D54D
	for <linux-scsi@vger.kernel.org>; Tue, 14 May 2024 09:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.133.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715678611; cv=fail; b=rqTh1ZW2724sy5rQ/aA5ErmRJulrszwH6O0q+BPndE0cJkZIAfbnuNaW3PEQJ72V14zCLICNUFcleb/IpcFMuka0HH3+t8M8qibaA9Kdz4YakhEL0yE82H8V9tmwgMop9CrtlAnSOwNWpidU1jpRyID48reGMFE/5+KScCuAiF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715678611; c=relaxed/simple;
	bh=hqkyh4yhFqt9JYdATR+2L5ZulwNG8eUqIlLIQmP8xXE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K4TbCljEuRsNYACX9n1GqJXN+TlbaTtYbRHVqYZ4TQXHi65froCQF5mkoOWNvJd/DLDBHQDhs9K3VhzPNq7pifUB6ozHTepel8kTa2mtAq5Z22oi2WnZIUN2tbTAaNAB7prz3w54fCcVmxhcL2+gkIP1xS9Pz0a3gLiCniO0Mwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com; spf=pass smtp.mailfrom=dell.com; dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b=s9nKys3k; arc=fail smtp.client-ip=148.163.133.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=Dell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dell.com header.i=@dell.com header.b="s9nKys3k"
Received: from pps.filterd (m0170391.ppops.net [127.0.0.1])
	by mx0a-00154904.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44E8w3PM018982;
	Tue, 14 May 2024 05:23:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=hqkyh4yhFqt9JYdATR+2L5ZulwNG8eUqIlLIQmP8xXE=;
 b=s9nKys3kkGVvVhn5uqLFkIiE5syj3ChyoSlj2NyF2+1H5wzjEa3xIrCZ2LZpljUbNQck
 41DIVCInAhOK6NkXoaLddGOit6kS6uAtAsXupi5JOO3fB8uewaBeNvY/+XUTP9uVtvCu
 1Cxbp4ntftblVd3SBiHqrX4Z2ZweCoqOofyDfIApb+cOT+jIChYVaEDRZ/T9s3Ih2D1r
 B7pwEXgyZCPLJpXFKR7e3F9h2RzgEkZpBOfL3AFA9XYGHU+eSvlPqV7l+HFqOzKIVcBq
 yovimEIuawIsQX1TusOUZEMpIK8OOYKwzwjUUDt3Ic3Lu79ReI9t1VXRd7dlmUQsXdh7 Eg== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
	by mx0a-00154904.pphosted.com (PPS) with ESMTPS id 3y23txvp1d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 May 2024 05:23:20 -0400
Received: from pps.filterd (m0144103.ppops.net [127.0.0.1])
	by mx0b-00154901.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44E8VPun023562;
	Tue, 14 May 2024 05:23:19 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 3y43f69pma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 05:23:19 -0400
Received: from m0144103.ppops.net (m0144103.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44E952Jt010246;
	Tue, 14 May 2024 05:23:18 -0400
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 3y43f69pm4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 05:23:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mToeS/0CyPdKSA3uqaIbm/YqP3hbUycTZNvYP+E/uDrvYPs1pIPBzE7hI1hRygxIFV0T1rAPA6RbJcYQszRR6St1v7VafEOxw1uXLkTVzyH5vakhsDCTyH1Rtx03yoorQDIdvuyt6xcEpI5ETm/Y8OdO7qujC+DS5+nwzHJbyCEHQFH9LJQw2ttDCEBZ2y60TfZ8U8mTCaNGgQhzYVhq9qvvPi1Rxjfg18bid+0tjUJto6hYG6Fqu2FknpPxVBUBJZTtmUoMm+0qZhyQiAeW+NNzGwTuJmrOK+TZEkTKe9l0nO7cm9uMEC7sgH4xEXPx5N/05hNPTg5biRq029AmSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqkyh4yhFqt9JYdATR+2L5ZulwNG8eUqIlLIQmP8xXE=;
 b=Opo4dVzJYbWAYomANPatEgsIdguIlLXSH1E3T7PtCqXjeEgORyWhPheZR50YejpMNCy1so8qLiPvlLHEww4Roh1X719lV+k+O33BONwlj1f68Uwb4YMcbsA0sZQtpvu2lNEEs9x+pdsak3DXH45o3cAhev5PRKbeTNUkc3IyAi633r1vT2t0A5dFa+SfICKMBpiEM70/uNMw4pgto/0zQMfPcHi5bSuRfJA20SFZfUxKdyHvy7WJqUy4tzSqGRwBGtJ/ZpVE7WN8zSB50nJd+JmUl0BZQVVf1nAl4CmUFIiQZnvu02rrt1o5nITRicH5mbtPNx3a/I5xC1MY6NJsBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com (2603:10b6:a03:3e2::13)
 by CH4PR19MB8711.namprd19.prod.outlook.com (2603:10b6:610:232::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 09:23:15 +0000
Received: from SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47]) by SJ0PR19MB5415.namprd19.prod.outlook.com
 ([fe80::74b4:8ac3:e695:ed47%5]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 09:23:15 +0000
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
Thread-Index: 
 AdqWJbfhv3GSaG0rTeK0+6km85YpNwADuoMAACHtcIAABC5uMAEPIjxwADJmXIAATNqvUAALeYiAAIffgZAAQPLpEAAB4+wAAANgfMAACRv3gAAUU6tAAA5fz4AAALb0kACNhawAAKKd7xA=
Date: Tue, 14 May 2024 09:23:15 +0000
Message-ID: 
 <SJ0PR19MB5415CA74D010E7D35263FFDCC4E32@SJ0PR19MB5415.namprd19.prod.outlook.com>
References: 
 <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
 <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
 <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <PH0PR19MB5411390C5A29A953CAA70062C4E42@PH0PR19MB5411.namprd19.prod.outlook.com>
 <7081399f-d4e8-4af9-9cff-2bcb1e4c6064@oracle.com>
 <SJ0PR19MB5415A5F70B0D51BA96CBC76DC4E42@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <b82bee4f-67b7-4355-a152-1f13d4918220@oracle.com>
 <SJ0PR19MB5415CFA77DCC17E0BFAEEF76C4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <eb90005b-1ef7-4bb6-bc62-84af5a03e3e7@oracle.com>
 <SJ0PR19MB54152471D18241A020914B2AC4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <ec087459-ae19-f593-f046-846c041e397d@huawei.com>
In-Reply-To: <ec087459-ae19-f593-f046-846c041e397d@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
 MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_ActionId=b46c10d7-e9bc-4162-981c-7d27da6c0870;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_ContentBits=0;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Enabled=true;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Method=Privileged;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_Name=Public
 No Visual
 Label;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_SetDate=2024-05-14T09:17:31Z;MSIP_Label_dad3be33-4108-4738-9e07-d8656a181486_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR19MB5415:EE_|CH4PR19MB8711:EE_
x-ms-office365-filtering-correlation-id: a33188eb-b6df-4b70-27b6-08dc73f77c30
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?MEFJcmJHREhOYXV1eE1OMFp1cEt5V0wyY0g5dGpyN1hrTTRnQWxWRDFLNUlh?=
 =?utf-8?B?UGVtREtqbnpBNjVJVStXSEdZR0dzUzNna0svdEE0WWtlSVJSUGNtOWlML0V6?=
 =?utf-8?B?OC9rYUxBM0NIWnBkN2RwaXdSaGQwb25mbDYvRXpKWEpyVGZVdm54VVpMNzdr?=
 =?utf-8?B?cXdmblpFQzV5c3V2eU9wVjluR2FzVEhVRlY3dW82SkJHSjZsY1JTL1RWMzhI?=
 =?utf-8?B?M2dFN0JpMHo3M3J5Ync5RGFhcWUxdmIwOXNEa3ltZUVML2J6RFgybVdkY3Iz?=
 =?utf-8?B?c21NWFF0YUlYcHRPTFc5TU5YSjNPMC9qZHVjaitqMjhqU2VMRWgwY1ZZYXVD?=
 =?utf-8?B?aXZNZnNsNEtRRk9NS1lqZ0ZwVkl4dG95VzJYeHhhUkR6NGFTS09IcDN2SFFC?=
 =?utf-8?B?Y05SZHNhT3c4eDJHRjZyay9teWhZRWc5TDNjaEtBOTRyNzFGWGZTU1RyZS9W?=
 =?utf-8?B?M1hnYS9mdnp6MHJuL1RrSVhUbzdSYlc3MzhlbDR0VUU5K0M5US9ISG04K3FR?=
 =?utf-8?B?cU8zaEJKQ3Vacy9Cc3ZjL0RMUnpES214RXBDVUkrbjZTV0tRSDROZy83Mjg0?=
 =?utf-8?B?Y3ozZElQczNObUZlbXNMaE9VUVJ0dmxuRCtUb0tzOEdoczYxMkdQLytWcW1S?=
 =?utf-8?B?RWZvWTFrZEpxSmxEWTNhRVZtSUNlN2xGTVBGSktobGNPYTlXaXNCNmIzR0hl?=
 =?utf-8?B?d05XbGpqQThoRHZDY0NSWU8zemNyczloR2dVRjZYUHJKZ2V6SVh5TVBkNHZT?=
 =?utf-8?B?OWt5S3JSeFQrS1I0Qnl3S1lyS0dwRGtCL3hlV0tjbzJHR3I1RVVRdXZwTkhz?=
 =?utf-8?B?cU9kRndBNExRTHZLT05keFpudzhSMGFTOHVpdmUvT3dWK1RNbGNGYTdxZDBD?=
 =?utf-8?B?UUY5VVhGMkxubjRtcE9FRTlwQkFXcEV2dVluYlZHQjQ5Sjl5VWl4bXFBMjdM?=
 =?utf-8?B?M1k1WFBaTElqRkRscTdqQkhYYlBnUzdaRzY5YUxwb0sySnJ5WC9rVU1ZTE1P?=
 =?utf-8?B?TUpaUWZnSXZGeTBQUE9lbFZkQ0lTNWpxalJkbmlPZFFMcXNNOU9mNDJCT1lo?=
 =?utf-8?B?Q1lMT2ZUdjRuNTc3SEQ4OVV2SkJKU2JvNXZnU3N4MHFJeEk1R1dnWTFLc1Fm?=
 =?utf-8?B?NTY3Vk9LaWYyRlJqc0FlU0ZkWlFmeEtkWjU2NUg5YjNnendtbnBOVmlzTE9X?=
 =?utf-8?B?dWRtUkNHZUJ1dkN3V0MrQnAwa1RuQzJRdENQY3BaWkluREtZWk8vTXl6R3A1?=
 =?utf-8?B?cHMyeVNINC9IYU5iQVNOODVmMHp2bzdqREI4dXR3NzVST0I1K1FDQUVEanFs?=
 =?utf-8?B?TlQxM2tLaFVrN0E3cnFYTVN1V3JkTGhEMTZKeTNZLzZobTJVSTM3MGdpelF5?=
 =?utf-8?B?NFZGNjlxakdob0ZmUm80N2ZtZS9mWS9rQ1Rray9nQ1V2VDlSOUFMRXRNUnh4?=
 =?utf-8?B?TVFUcWRoZUhiUTFXbVlSZnhwY0FlQXJFM1kzRTdmSi8vYzA3TlQwejNGMUVn?=
 =?utf-8?B?UFRwa3Vjd0xmak53VnZFOXNYM29uc1J4UzNQL2FjNFM0TG1TSnlvSlhCaTJ2?=
 =?utf-8?B?SGNFcGtEamcyNlVaeVRMM0Q2enU0YytDSHFZemhrYmVvbklocHFkb2o0SUdv?=
 =?utf-8?B?TmNwOHdYaVpDRk1kTTRPalhFSXdpMmxTU2k1aXlJN0FSTHY5dXd6dnBlZldE?=
 =?utf-8?B?Lzkwem1jbXBJOWlkMVVJODQ5SDlQaExaUDZ6TUdiMldicDU0YW5pUk9aYnZB?=
 =?utf-8?B?WURJd0JQcG9FWVVtakFIdmQrSGVPQklESTNiMDFIa29VR0dYdTBMMEdqZW5i?=
 =?utf-8?B?RjQwanVRaUpqTXB3R2hrZz09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR19MB5415.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?eXhVcm1hMFRwM1JGZzRQRVRRK2RsM0NYbis2ck5ZSkhYd3RrYlJKS1RRV3d0?=
 =?utf-8?B?T0o4WGV5SXRKa2lWd1Y1endRQ2dYb1dvU25CTXAwNkxRc2x6TFJ0R0xDTFVz?=
 =?utf-8?B?NmdpNFYwM2ZOdkdob3d0RWtlTmIyRjJsZUZKM255ZFFCM0hOYkJuQTRCL05T?=
 =?utf-8?B?Nmw2NE1LYm4reW5xajIyZU5rQVNqaExjczBmaGE0UnMwKy9WWkxKVEJVQWlZ?=
 =?utf-8?B?bTFNa0lSeEY2ZmVITTI0YXBKUFpGUTVlN3ZmRHJDcW9zUFc5a0FoNm1RZ0lP?=
 =?utf-8?B?K0lCb2U1c2hjL2ZmWkVGQlkvZ08ybk53SDR0QjdKUGlvUFZKV0tRandOMFkx?=
 =?utf-8?B?cm4zQkFMejd0RTRMZ01GQ3VUNjV0eGROc0w3Qm9wK1RObUFXMm9PeDNYbXpk?=
 =?utf-8?B?UUxLd2daQ1FzcWxOTkhKc0E5S05LL1R3VDFKeGVLVVlzY0dFSzU2MEhPNVFq?=
 =?utf-8?B?dUUrN1JPdjZUbGN0a3BaMFNXWm1HK21SWEp0enNDc2pwa2JCMHoyZGFib1Yr?=
 =?utf-8?B?eFhONi9QUHBTUmRXY1JCMkl6aE81NW5VK2FGUVRVUjRlZHhUbTZDWDg5aFhu?=
 =?utf-8?B?a0JVRXBwZ2R4K2NwNVEyNGhOUXpYN3AyZWdmM0x5Sm1sZUk0YWR0N3AvTmRV?=
 =?utf-8?B?Ry9VZEZtWFJZVi9GUzlEZ0NMY0o2czRURzBzOTNhTXBsb2szWk1BUmEvTU1j?=
 =?utf-8?B?ZVNUT2NINm9iR3liZHdyelFDdnFGa1ZkVXc5N0xQTnorK2kzRVNZRHBjWmRz?=
 =?utf-8?B?NW5ua1E0UFdxd1JRV2NzM1ZyT0M4MVNhTFI4amdzWjhjeWZuc3FvdWVaOXRC?=
 =?utf-8?B?WXdhODkxc01xcXBzaS9vZVNLU2VNd3pWRHFMVEhWNmw0R3ZINEtHUi9ocmM1?=
 =?utf-8?B?L045TS82bTRRREFQRFZVRUxjUjVpNGh6a0xMdHpEWmZHUTFMKzVWS2s3ZEhj?=
 =?utf-8?B?ZCt2T014L2x4QkhYUjlqaUttU09SUTl6cVBWKzlKVTl6M3JvOFVndW9DNHBj?=
 =?utf-8?B?SWlCY0Zrak1CNURUOHRCdTlTU1o1QVhiVHc1Slk1MXh1TnF4bEJSajgza3dr?=
 =?utf-8?B?cGg4dEpzVllTWHgwa3ROYzlzWlgwa3ZUVWhuTjZxYXpUN1lCNGp6Q1BhREor?=
 =?utf-8?B?eVZWNVhIOXVsUUs0SzYyY3IyUjZ0M2JXT0habW53djZacGw1MlQ3d2FaV2gz?=
 =?utf-8?B?aVN1RHlKOEVFc0NhUVNxd3RNc09sbDVqR2JtYTQzMXRYd0JNZlQ4NUNxSDU3?=
 =?utf-8?B?cEk0S0RKYnc5aGtWUDQ2aFg3b0h0bXRxUVhFc2NNYWFNd3lPRXVyeUtJNmJZ?=
 =?utf-8?B?MnBoRm5aTU9CdFN2dE5kY3RrVFlCQVpRMXIwTTVXUnozNHJPejZjVE1MZmY2?=
 =?utf-8?B?TndIdUNnd3dqcWJROGc0WkdOYUFJa2tLS2FOeGdlVE1BLzVwSUwxdXlwZFQ5?=
 =?utf-8?B?TGlKL0NOK20yNXh0cjY1YzhiWEx1a2tVeGE2OVg0Qk5jbVQ2N0QvcDRIRENJ?=
 =?utf-8?B?aWoxVUhKQXZCdWp6M0RvMGpBdFc2SnpPTkw4dWVMaEtKcUxrS1VjZmRpbUx0?=
 =?utf-8?B?UWpTcDNCZFFzT1dCUE5TWCtPZWtHajFJOVNjV2k3RUVLYkpBN1BJaEkycEZ0?=
 =?utf-8?B?MkEzVDhwa3JmVHZpWDQ0VCtLenNXY0E3MDl2eDFWaWxVL3Q4TnlnVHkxdDNJ?=
 =?utf-8?B?dGY0bUVFTEJNbXBrL0F4alNhMHphMXJYWUlhS1k1L3BjSmljTFYySTRNT2lp?=
 =?utf-8?B?L0tJRWp1ZjV6TGtlYU84ZmhTaXoxbUI3TS9OTFRyNkpTUEZ5TmxHbGY5aGxy?=
 =?utf-8?B?MmZCakxtenEwcFU5SURRRndaK1VNbTVvby8rcUVlQld3MERMV3Rqb2tpWnlW?=
 =?utf-8?B?a01EK0VZUko5cC94Tkx5OHUyVnlJaDk2R2FxSFdHRlpQTmJNUnNMbCtDWk9X?=
 =?utf-8?B?VXlVVzVVNFZqMXBrUzRaZ1hmZ0RMZlJuSzlOZERRMGhyRlR0Mm9OSFJJb0w1?=
 =?utf-8?B?WlY0TXpSZGlRTDNMc244Um1PMEttSStRVnR2cGVsaWF1VFB3RW9WU1lxcjZ0?=
 =?utf-8?B?Q3IxajlGbExnTHVBNlljM09oOHhOVldpTWp4eklhRmNjcjlBMEg4Wml4cEZB?=
 =?utf-8?Q?nfdA=3D?=
Content-Type: text/plain; charset="utf-8"
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a33188eb-b6df-4b70-27b6-08dc73f77c30
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2024 09:23:15.7315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NNQDAI03HwPBYWD5KDzo0jFDftV81joZ/DfG0w77delvokJQBWnaqcpa6VgldWwsBK9uZ6s4j3yB/cVxcZq+Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR19MB8711
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-14_03,2024-05-10_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405140065
X-Proofpoint-GUID: eJZMZWQ0RNQGwdqkNX4EOwGrlgYR20K8
X-Proofpoint-ORIG-GUID: eJZMZWQ0RNQGwdqkNX4EOwGrlgYR20K8
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 clxscore=1015 mlxlogscore=999 malwarescore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405140065

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYXNvbiBZYW4gPHlhbmFpamll
QGh1YXdlaS5jb20+DQo+IFNlbnQ6IFNhdHVyZGF5LCBNYXkgMTEsIDIwMjQgMTE6NDEgQU0NCj4g
VG86IExpLCBFcmljIChIb25nZ2FuZykgPEVyaWMuSC5MaUBEZWxsLmNvbT47IEpvaG4gR2Fycnkg
PGpvaG4uZy5nYXJyeUBvcmFjbGUuY29tPjsNCj4gamFtZXMuYm90dG9tbGV5QGhhbnNlbnBhcnRu
ZXJzaGlwLmNvbTsgTWFydGluIEsgLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5j
b20+DQo+IENjOiBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogSXNz
dWUgaW4gc2FzX2V4X2Rpc2NvdmVyX2RldigpIGZvciBtdWx0aXBsZSBsZXZlbCBvZiBTQVMgZXhw
YW5kZXJzIGluIGEgZG9tYWluDQo+IA0KPiANCj4gW0VYVEVSTkFMIEVNQUlMXQ0KPiANCj4gT24g
MjAyNC81LzggMTY6MjksIExpLCBFcmljIChIb25nZ2FuZykgd3JvdGU6DQo+ID4+IC0tLS0tT3Jp
Z2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IEpvaG4gR2FycnkgPGpvaG4uZy5nYXJyeUBv
cmFjbGUuY29tPg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIE1heSA4LCAyMDI0IDM6NDggUE0NCj4g
Pj4gVG86IExpLCBFcmljIChIb25nZ2FuZykgPEVyaWMuSC5MaUBEZWxsLmNvbT47IEphc29uIFlh
bg0KPiA+PiA8eWFuYWlqaWVAaHVhd2VpLmNvbT47IGphbWVzLmJvdHRvbWxleUBoYW5zZW5wYXJ0
bmVyc2hpcC5jb207IE1hcnRpbg0KPiA+PiBLIC4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBv
cmFjbGUuY29tPg0KPiA+PiBDYzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4gU3Vi
amVjdDogUmU6IElzc3VlIGluIHNhc19leF9kaXNjb3Zlcl9kZXYoKSBmb3IgbXVsdGlwbGUgbGV2
ZWwgb2YgU0FTDQo+ID4+IGV4cGFuZGVycyBpbiBhIGRvbWFpbg0KPiA+Pg0KPiA+Pg0KPiA+PiBb
RVhURVJOQUwgRU1BSUxdDQo+ID4+DQo+ID4+IE9uIDA4LzA1LzIwMjQgMDE6NTksIExpLCBFcmlj
IChIb25nZ2FuZykgd3JvdGU6DQo+ID4+Pj4+IENhbGwgdG8gc2FzX2V4X2pvaW5fd2lkZV9wb3J0
KCkgbWFrZXMgdGhlIHJlc3QgUEhZcyBhc3NvY2lhdGVkDQo+ID4+Pj4+IHdpdGggdGhhdCBleGlz
dGluZyBwb3J0DQo+ID4+Pj4gKG1ha2luZyBpdCBiZWNvbWUgd2lkZXBvcnQpIGFuZCBzZXQgdXAg
c3lzZnMgYmV0d2VlbiB0aGUgUEhZIGFuZA0KPiA+Pj4+IHBvcnQuID4gU2V0IFBIWV9TVEFURV9E
SVNDT1ZFUkVEIHdvdWxkIG1ha2UgdGhlIHJlc3QgUEhZcyBub3QgYmVpbmcNCj4gPj4+PiBzY2Fu
bmVkL2Rpc2NvdmVyZWQgYWdhaW4gKGFzIHRoaXMgd2lkZSBwb3J0IGlzIGFscmVhZHkgc2Nhbm5l
ZCkuDQo+ID4+Pj4NCj4gPj4+PiBJZiB5b3UgY2FuIGp1c3QgY29uZmlybSB0aGF0IHJlLWFkZGlu
ZyB0aGUgY29kZSB0byBzZXQgcGh5X3N0YXRlID0NCj4gPj4+PiBESVNDT1ZFUkVEIGlzIGdvb2Qg
ZW5vdWdoIHRvIHNlZSB0aGUgU0FTIGRpc2tzIGFnYWluLCB0aGVuIHRoaXMgY2FuDQo+ID4+Pj4g
YmUgZnVydGhlciBkaXNjdXNzZWQuID4+DQo+ID4+PiBPSy4gSSB3aWxsIHdvcmsgb24gdGhhdCBh
bmQga2VlcCB5b3UgdXBkYXRlZC4NCj4gPj4NCj4gPj4gSSBleHBlY3QgYSBmbG93IGxpa2UgdGhp
cyBmb3Igc2Nhbm5pbmcgb2YgdGhlIGRvd25zdHJlYW0gZXhwYW5kZXI6DQo+ID4+DQo+ID4+IHNh
c19kaXNjb3Zlcl9uZXcoc3RydWN0IGRvbWFpbl9kZXZpY2UgKmRldiBbdXBzdHJlYW0gZXhwYW5k
ZXJdLCBpbnQNCj4gPj4gcGh5X2lkX2EpIC0+IHNhc19leF9kaXNjb3Zlcl9kZXZpY2VzKHNpbmds
ZSA9IC0xKSAtPg0KPiA+PiBzYXNfZXhfZGlzY292ZXJfZGV2KHBoeV9pZF9iKSBmb3IgZWFjaCBw
aHkgaW4gQGRldiBub24tdmFjYW50IGFuZA0KPiA+PiBub24tZGlzY292ZXJlZCAtPiBzYXNfZXhf
ZGlzY292ZXJfZXhwYW5kZXIoIFtkb3duc3RyZWFtIGV4cGFuZGVyXSkNCj4gPj4gZm9yIGZpcnN0
IHBoeSBzY2FubmVkIHdoaWNoIGJlbG9uZ3MgdG8gZG93bnN0cmVhbSBleHBhbmRlci4NCj4gPj4N
Cj4gPj4gQW5kIGZvbGxvd2luZyB0aGF0IHdlIGhhdmUgY29udGludWUgdG8gc2NhbiBwaHlzIGlu
DQo+ID4+IHNhc19leF9kaXNjb3Zlcl9kZXZpY2VzKHNpbmdsZSA9IC0xKSAtPg0KPiA+PiBzYXNf
ZXhfZGlzY292ZXJfZGV2KHBoeV9pZF9iKSAtPg0KPiA+PiBzYXNfZXhfam9pbl93aWRlX3BvcnQo
KSAtPiAgZm9yIGVhY2ggbm9uLXZhY2FudCBhbmQgbm9uLWRpc2NvdmVyZWQNCj4gPj4gcGh5IGlu
IHBoeV9pZF9iIHdoaWNoIG1hdGNoZXMgdGhhdCBkb3duc3RyZWFtIGV4cGFuZGVyLg0KPiA+Pg0K
PiA+PiBDYW4geW91IHNlZSB3aHkgdGhpcyBkb2VzIG5vdCBhY3R1YWxseSB3b3JrL29jY3VyPw0K
PiA+Pg0KPiA+DQo+ID4gYmVmb3JlIGNhbGxpbmcgc2FzX2V4X2pvaW5fd2lkZV9wb3J0KCksIHNh
c19kZXZfcHJlc2VudF9pbl9kb21haW4oKQ0KPiA+IGZpbmRzIHRoZSBhdHRhY2hlZF9zYXNfYWRk
cmVzcyBvZiBQSFkgKHBoeV9pZF9iKSBpcyBhbHJlYWR5IGluIHRoZSBkb21haW4gb2YgdGhhdCBy
b290DQo+IHBvcnQsIGFuZCB0aGVuIGRpc2FibGUgYWxsIFBIWXMgdG8gdGhhdCBkb3duc3RyZWFt
IGV4cGFuZGVyIChpbiBzYXNfZXhfZGlzYWJsZV9wb3J0KGRldiwNCj4gYXR0YWNoZWRfc2FzX2Fk
ZHIpKSBUaGVyZWZvcmUsIEkgdGhpbmsgd2UgbmVlZCB0byBzd2l0Y2ggdGhlIG9yZGVyIG9mIGZ1
bmN0aW9uIGNhbGwgdG8NCj4gc2FzX2V4X2pvaW5fd2lkZV9wb3J0KCkgYW5kIHNhc19kZXZfcHJl
c2VudF9pbl9kb21haW4oKS4NCj4gDQo+IEhpIEVyaWMsDQo+IA0KPiBDYW4geW91IHRlc3QgdGhl
IGZvbGxvd2luZyBwYXRjaCB0byBzZWUgaWYgaXQgd29ya3M/DQo+IA0KPiBBdXRob3I6IEphc29u
IFlhbiA8eWFuYWlqaWVAaHVhd2VpLmNvbT4NCj4gRGF0ZTogICBTYXQgTWF5IDExIDExOjMzOjM1
IDIwMjQgKzA4MDANCj4gDQo+ICAgICAgc2NzaTogbGlic2FzOiBTa2lwIGRpc2FibGUgUEhZcyB3
aGljaCBjYW4gZm9ybSB3aWRlIHBvcnRzDQo+IA0KPiAgICAgIFNpZ25lZC1vZmYtYnk6IEphc29u
IFlhbiA8eWFuYWlqaWVAaHVhd2VpLmNvbT4NCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvbGlic2FzL3Nhc19leHBhbmRlci5jDQo+IGIvZHJpdmVycy9zY3NpL2xpYnNhcy9zYXNfZXhw
YW5kZXIuYw0KPiBpbmRleCBmNmU2ZGI4YjhhYmEuLjM5YTg2ODU3YmM1MiAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy9zY3NpL2xpYnNhcy9zYXNfZXhwYW5kZXIuYw0KPiArKysgYi9kcml2ZXJzL3Nj
c2kvbGlic2FzL3Nhc19leHBhbmRlci5jDQo+IEBAIC02MTgsMTUgKzYxOCwxNyBAQCBzdGF0aWMg
dm9pZCBzYXNfZXhfZGlzYWJsZV9wb3J0KHN0cnVjdCBkb21haW5fZGV2aWNlICpkZXYsIHU4DQo+
ICpzYXNfYWRkcikNCj4gICAgICAgICAgfQ0KPiAgIH0NCj4gDQo+IC1zdGF0aWMgaW50IHNhc19k
ZXZfcHJlc2VudF9pbl9kb21haW4oc3RydWN0IGFzZF9zYXNfcG9ydCAqcG9ydCwNCj4gK3N0YXRp
YyBpbnQgc2FzX2Rldl9wcmVzZW50X2luX2RvbWFpbihzdHJ1Y3QgZG9tYWluX2RldmljZSAqZGV2
LA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1OCAqc2Fz
X2FkZHIpDQo+ICAgew0KPiAtICAgICAgIHN0cnVjdCBkb21haW5fZGV2aWNlICpkZXY7DQo+ICsg
ICAgICAgc3RydWN0IGRvbWFpbl9kZXZpY2UgKnRtcDsNCj4gDQo+ICAgICAgICAgIGlmIChTQVNf
QUREUihwb3J0LT5zYXNfYWRkcikgPT0gU0FTX0FERFIoc2FzX2FkZHIpKQ0KPiAgICAgICAgICAg
ICAgICAgIHJldHVybiAxOw0KPiAtICAgICAgIGxpc3RfZm9yX2VhY2hfZW50cnkoZGV2LCAmcG9y
dC0+ZGV2X2xpc3QsIGRldl9saXN0X25vZGUpIHsNCj4gLSAgICAgICAgICAgICAgIGlmIChTQVNf
QUREUihkZXYtPnNhc19hZGRyKSA9PSBTQVNfQUREUihzYXNfYWRkcikpDQo+ICsgICAgICAgbGlz
dF9mb3JfZWFjaF9lbnRyeSh0bXAsICZkZXYtPnBvcnQtPmRldl9saXN0LCBkZXZfbGlzdF9ub2Rl
KSB7DQo+ICsgICAgICAgICAgICAgICBpZiAodG1wLT5wYXJlbnQgPT0gZGV2KQ0KPiArICAgICAg
ICAgICAgICAgICAgICAgICBjb250aW51ZTsNCj4gKyAgICAgICAgICAgICAgIGlmIChTQVNfQURE
Uih0bXAtPnNhc19hZGRyKSA9PSBTQVNfQUREUihzYXNfYWRkcikpDQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgICByZXR1cm4gMTsNCj4gICAgICAgICAgfQ0KPiAgICAgICAgICByZXR1cm4gMDsN
Cj4gQEAgLTk3Myw3ICs5NzUsNyBAQCBzdGF0aWMgaW50IHNhc19leF9kaXNjb3Zlcl9kZXYoc3Ry
dWN0IGRvbWFpbl9kZXZpY2UgKmRldiwgaW50IHBoeV9pZCkNCj4gICAgICAgICAgICAgICAgICBy
ZXR1cm4gMDsNCj4gICAgICAgICAgfQ0KPiANCj4gLSAgICAgICBpZiAoc2FzX2Rldl9wcmVzZW50
X2luX2RvbWFpbihkZXYtPnBvcnQsIGV4X3BoeS0+YXR0YWNoZWRfc2FzX2FkZHIpKQ0KPiArICAg
ICAgIGlmIChzYXNfZGV2X3ByZXNlbnRfaW5fZG9tYWluKGRldiwgZXhfcGh5LT5hdHRhY2hlZF9z
YXNfYWRkcikpDQo+ICAgICAgICAgICAgICAgICAgc2FzX2V4X2Rpc2FibGVfcG9ydChkZXYsIGV4
X3BoeS0+YXR0YWNoZWRfc2FzX2FkZHIpOw0KPiANCj4gICAgICAgICAgaWYgKGV4X3BoeS0+YXR0
YWNoZWRfZGV2X3R5cGUgPT0gU0FTX1BIWV9VTlVTRUQpIHsNCj4gDQo+IA0KPiANCg0KSSBhbSBz
dGlsbCB3YWl0aW5nIGZvciBmZWVkYmFjayBmcm9tIG91ciB0ZXN0IHRlYW0uDQpGcm9tIGZ1bmN0
aW9uYWxpdHksIEkgdGhpbmsgaXQgc2hvdWxkIHdvcmsgYXMgaXQgc2tpcHMgc2FzX2Rldl9wcmVz
ZW50X2luX2RvbWFpbiBjaGVjayBmb3IgdGhlIHJlc3QgUEhZcyBpbiB0aGUgd2lkZSBwb3J0Lg0K
QnV0IGZyb20gbG9naWMsIEkgdGhpbmsgaXQgbWFrZXMgc2Vuc2UgdGhhdCBjaGVja2luZyB3aWRl
IHBvcnQgaXMgcHJpb3IgdG8gY2hlY2tpbmcgc2FzIGFkZHJlc3MgZHVwbGljYXRpb25faW5fZG9t
YWluLg0KSnVzdCBteSB0d28gY2VudHMuDQo=
