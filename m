Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA0C8405C
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 02:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761100099; cv=fail; b=aZeOTuPAv1O7renbMNm2O1HZgSLG60MMNSqQs5bQQuDK0z9anvVOxzJm39XuotC1V4vxIuDndyG7RQDI9rI1nIUPA65xF44OpfExUIe8KnQqKc48kkX0gxXPyMMsJvHPF/kjU8bQGkPAHcXKi/SGrjtmXVVhby/k2SyUmuekfb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761100099; c=relaxed/simple;
	bh=TuLp2SY+ubL7a5qDVzN+y0cjtMKCSoj8qRQmsSZoOmg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Lq6IVp+6z80IktfnBov19eiLCPS2y4l3+LXOgIStf+cwHMXoENk7C0znFjAzvanWGuJcwZBw54kdkMw9LOXuUNkugfUiuWXpfbWyXGpMbKDeibXKwKzT2I1r1ehtUhw3Os7VUh5FwynnSeWm4vjDvhC0iC0nfE5V97FGTotN+JI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ji1DVQy/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mq+o7YJj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ji1DVQy/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mq+o7YJj"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LMuVjT013696;
	Wed, 22 Oct 2025 02:28:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IYmxXKptnmCQj5tXR5
	bcfX9uy8/enc/Vhh7LjRuoIjw=; b=Ji1DVQy/b5vPNSx/I4tSoSPJYGGf7SAERh
	DTDx7MTTTu4TQ8jdX2JV25wl0rEQf2RiSF7XA/x5fGM7FbiU0zMY5qqnUkhQcxSc
	Q05nPPdiGCRT2IB3VQA+sOuNT7cCc6bdV8G4UwNeoxLtHURI7yALnDRLjROHMwYi
	+kwo2OZQPbQRk4xuBB1zITE8u+6TmiUB48D4S8QO1YnW1oyVmZcL9vViig5UizUI
	2YwZs7SsNai7qkfScAN5sn53nspzQ9XoxS2IeJqTGmSWbA0LH7txbPAJCVz3zxjQ
	xQKR6Q2/gcJUwugVn9gjxbus0+f1aW8gp3SabH2xbxsTYF7tQpeg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2waxu24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 02:28:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LNPfiF007244;
	Wed, 22 Oct 2025 02:28:04 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013042.outbound.protection.outlook.com [40.93.196.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bctcvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 02:28:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JzGUIjK44zYtrlKrxeVn6tZeUckFN4QYopqB6zFwqdGWfjdlDWpdsW3EnHX0axZ7+G247ZTYVQoSQoFHyNANV7U89xaQYnu8RH4nSDZM1g+A7JZ2BL2usRuQVQ8F9zeBbkF6j8ysLWAGoZlNRvUVgfgN64P/O6v5lrxK/UVtvanGUwtiA6Ew6UOSHAtj4Co+GtrL404d2UIBi07QwZBgrj1RyBJi0DNTDdZfOB1lFHtrYzn76LkVwxZsoe7j1Ktu/bTBlSxoL6+boOoO6Aq7IUGQY6a0yF9kCP1rrIAZAVa9mR0z+IHj4Y/ttD6hQd3feFnGUXw8vILY0ha1lw7Xrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IYmxXKptnmCQj5tXR5bcfX9uy8/enc/Vhh7LjRuoIjw=;
 b=WHCiYdmLjGcPo8NUHmlRFD730payeq4u8Sehd/OmNPk48HizjOg1TL2lkaWzEmg3vkIceEFJYw6h0xDBIUywWO7Ktk2KZK8rfhowuc6uXgDr22LnMiHOABXrYBLGNdWJP92eViap1FnuROCPT3XEk/u1u73cmW2O4neFui39Xl4gDiqrzszQYIMPOpxI2501llk3HQ8bXDvDRpn/rtD6d5LzWAaubHYg9ed9oxFTuqjfY/CJzmUxKqG7gKUQao68LWwuTFSVQonNK1SPypMzwjePEXEbS1UAJMH7DRY8r6CPZ23VJFpyK3YrwcjFwMsWCwq43ZbGYtCoGHp48vX9tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYmxXKptnmCQj5tXR5bcfX9uy8/enc/Vhh7LjRuoIjw=;
 b=mq+o7YJjVdUBi/ik0Wmq8y59ai6ZT2HGhaxMV1zXQ9lpY2w627zxRzYe7wR+h57UlOUwY+tnipyD/B3KGiYV2BDt7pdMSgDdSsgY5njazheex374eLOsJ/2odQGSn+9sCh2vULlK19LHX7AxiNXSf9OOJXRNESfPfpTonftLVBc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB5101.namprd10.prod.outlook.com (2603:10b6:5:3b0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Wed, 22 Oct
 2025 02:28:02 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 02:28:02 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Kai =?utf-8?Q?M=C3=A4kisara?=
 <Kai.Makisara@kolumbus.fi>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        John
 Meneghini <jmeneghi@redhat.com>
Subject: Re: [PATCH] scsi: core: Fix the unit attention counter implementation
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251014220244.3689508-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 14 Oct 2025 15:02:43 -0700")
Organization: Oracle Corporation
Message-ID: <yq1zf9j3c2i.fsf@ca-mkp.ca.oracle.com>
References: <20251014220244.3689508-1-bvanassche@acm.org>
Date: Tue, 21 Oct 2025 22:28:00 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0291.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB5101:EE_
X-MS-Office365-Filtering-Correlation-Id: 92a8a94f-e51b-4a81-714b-08de1112a001
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4nG8BRMZ68+BZA8gdAeeisv5co3ndsAH+6rfl7cmqhVSdjz58WK3RkAfKpHO?=
 =?us-ascii?Q?pEfBwE52sp9vrs4oRx3VKMbn8UAGXFQ+qP2l4UUzQGV8jbIiLsio7h9ytgAe?=
 =?us-ascii?Q?wKb+eIc8c83R2EJNIBP1LR7t+GR+9RN0NbrG/TCoHk+baLz/yRxEDLKyWU5V?=
 =?us-ascii?Q?0S2sL59OxbCjHeT71cXD9UvlUdnabZtLVroAoHGxuFFBWgFaY29YRvzcBzqq?=
 =?us-ascii?Q?rTsOt9yQER+NyxssfeavMN83BiLY9SzmujRc3hW26dss2w2bZCJFHP27PvRQ?=
 =?us-ascii?Q?KTNzD+30ziSnYHZOML7qUjh0Xw9WWa7FG4iCiYkduDxIdQPOt+ud0Id/QP6P?=
 =?us-ascii?Q?hHhHWLkZvjDdRke7J6BPXQzTUj7x+zJQULw7NBguPA6g8FvtP6s7PE08Nfq9?=
 =?us-ascii?Q?qpiBg42eEQm1YVA3fGGKTnfT+rDIQYqDCP/P/DW5gY8p8dHe+wMmZ2xu1eKE?=
 =?us-ascii?Q?GBadEm81D15dyvGNmvt4l/J6bncIDtMmNnfzOIX0dyDwzMDzJ86H1aqRj/ND?=
 =?us-ascii?Q?qck5R0NhzwwdhcaVQP5ODWH2oIOx/QmSwl90bUzPq0hExmMBZ/YdKYF0Ca3B?=
 =?us-ascii?Q?5MnKy0yd0PxcSG5XUE1dr1IhysmogbJosPVCnnxRhxglVQt9ql66pAoVazHF?=
 =?us-ascii?Q?xl9mUu1+ocBAZvVJvmAsLRUAK9rg2KGgsZTJzfKyMuGf5iObic7CmtMoefZo?=
 =?us-ascii?Q?71m12TdDeLCle77p3BktQWovmsiw0iDoZmvFYBvR+mwG5rSXCXdXbFAGNv37?=
 =?us-ascii?Q?Q44K+RsRgeAjd5ecj5WxJSrzbYx+wcq9UfDiWX2sp/g3c8Wm2Zc0fPgz9LZT?=
 =?us-ascii?Q?yATa+v+MC33gAqOXTIvDZ1g+Nx/No5iSGZ8ReUJ+LydH6TJ9h5PRptGvlCJn?=
 =?us-ascii?Q?AbmMl1NxOageBUeQ8te3igBLlUyGxRNFrVuA3gyvXerrQHgGLoMJgx0DcCNT?=
 =?us-ascii?Q?jeyWVkqnV3YRXGmTWYQwBRh3UOEVHHFkGkq8JUon3c8HAm5sbrwKTj35U0k4?=
 =?us-ascii?Q?H3PtwFMnNf1MywGRsGgtnY3kobp9yRDyNAUPeIRRI82yRqgOncUzwyhgg+5Z?=
 =?us-ascii?Q?I1nI7Tp19O+OkIcOB8rK/nkYrRaPCAw4mNZ/OqDgu5IZm9tmaSmxY52L/F8N?=
 =?us-ascii?Q?SnMnECc6jmKEWJRLorLHqdhluJ2L+kVAHhgRplmfrczUQF+T+f2ief3nbYvt?=
 =?us-ascii?Q?JoEbwXGcO21tLoLrzyXBHevvOFouIDFKl650rbG9ZyViyGOMfJXkB5kT7xf9?=
 =?us-ascii?Q?XfvHJiSBJYvdmQY/MGKLjvwEBVyFXcs8BFn888UPc7D3tMiFBUrV/mg5ylwD?=
 =?us-ascii?Q?xSB67pT10V6HDiWnpsKQTJMUdxiPGrenvRAMnFpm+XCb0AHCxoCxCZ6Fe3AO?=
 =?us-ascii?Q?G+Occ/VBTzkuke/U6CRv89JocZAqUvdgQlDz9ZmINK6nrkNWR6FJ3kbPlWgP?=
 =?us-ascii?Q?rpHyvL2CqnN9gvzwJ++z80kCFpIf0zr3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c+lF7Fk3Z4QIinmSpgVnsHFhpq49DuoK5kYrPGlr/KgpdizDIej2o41/NHKY?=
 =?us-ascii?Q?t12pp0MbZ/v9zDH8FtpjxBSKqXXWNVST+6dz62DxaIJp3MrVPVgM3N6neTcR?=
 =?us-ascii?Q?ufGpxvT5ldtco3MaeJ9jwGP95W2PN0As7n1ET+QKIHDXv5nEvAPRO2NTKkn0?=
 =?us-ascii?Q?np/Q6I2Q8F8CI0u3ayxwRfPn7KKM7FV+Yzsz6xyF5CrU/dtrepZ15qz4g0YO?=
 =?us-ascii?Q?3FnmHk49f0p+36N0sFQNhPRs6YHdW7u/NS49yT+E5GbVEiyuXCP71X72Kw7t?=
 =?us-ascii?Q?WV1e8Gyi7LKWf4TWd50DkAacSXpbdURmiX2IrICMWiDK7Ny+5+IRIxORGpaP?=
 =?us-ascii?Q?lpiQuWRq7PhEu2vRZjAsSXlYyTD6VuteclPilcrgTZlZKqnnjk6iuBRMxFon?=
 =?us-ascii?Q?gDuYOijoy3sjeJy04pIuV07M0t2lcm3LHA+Ep2O3O+3Q17BHVDWFvgk450Pk?=
 =?us-ascii?Q?ZEt8mnrRgIU8u82iYzqbXfj98ofwzcdUddemhl0UCVhpNA4rtrfrDj+65Olw?=
 =?us-ascii?Q?DvkuBgCOqrUyUJ56Sa6chuooPlnY7yX3PETnY4QeRXbITtzsF0S5Za7hz861?=
 =?us-ascii?Q?o1G/TY7APvrUX+w3t6g7IFQdR9uU7r+R9ph/pavI5tLvdyKK8yF8NjtnQhBa?=
 =?us-ascii?Q?Q5aaqTNoPlTt0BRZpq44byK2bjAirZ7vSvtEOY39WwUD0RF6We8AwTEURhLZ?=
 =?us-ascii?Q?3anQqNGfM1UPl6CaePlQPAcKe8N7z0dCteb3Uz+iFmHnCkUHbhpvNERqkmLg?=
 =?us-ascii?Q?+uYXR5bYCZkGQPEC0E2H/WM1ye2b/DkMYy7cyDpOrS9K73gddfpIHT4G6MKN?=
 =?us-ascii?Q?Q/cBNzJoYLxqe/u3quu/ZQXdsw2bMZSB1hofNbRxfUZddgwxJgxOApwYCZ8N?=
 =?us-ascii?Q?dREND58vicsjthGhGDpPkg3o4k38f60M6PMab8lfRKAO2v9URJrrX3Nwd81f?=
 =?us-ascii?Q?575Ve1wEGOc32Y6XsHJVTerqS5CD7LTH7oeR1Ogd6vtm0tIRSTF19bVQbxtU?=
 =?us-ascii?Q?61lpzIDpE+jWEa95Dj2KShLvHIF54xIzXWonUhTHr57bFAwv/yoFBx0cNiCj?=
 =?us-ascii?Q?Ntw2WS2CuuGrkoWh318jWxF1GZaqTR3pZHjKY5JacprTBMxBd77BjakeTRfo?=
 =?us-ascii?Q?E9j55waCAcIv4GySvHvm8pShr+6tRLwJ+PP1kVhV9T0Z8X/22BtugWc8QMOy?=
 =?us-ascii?Q?XXBXWCTZXa0GHIlDyTtt0f9WBGrSi5yvVdfXSGEx4XOYJeB7opAxEh3FS+T9?=
 =?us-ascii?Q?GL6vKvbIGpdwz91FAlVPq3lY7FPhQeB2lMs9mLX5yduykE7hSD/cb+Y4mFL6?=
 =?us-ascii?Q?aq6v7D5BLV4RqZYGgqgNSXCaK2OlrDWluLsVwUUQk8QEC9O0JH3MznAlAF/0?=
 =?us-ascii?Q?bExZ6gSw6bjKi84tF4VEVRc/KbCgob4COY65fJNlwLpIQdCyHoDogtdzvcKq?=
 =?us-ascii?Q?JounLKh2q/Au5zGgRblexXzSMFxag/BYEgeId1QodfUKugMWspFsjhZG8Oo8?=
 =?us-ascii?Q?tz2Jne0dVLYJskSB/NTk6VunDGPZCIowiaOUkeVO8Uai98di6o1Xx9YiqTNA?=
 =?us-ascii?Q?3OVB23ou3Fara5YkTGo/Zma69EknTcFJO0ES5YN86DHVS977sDhd/I0vK2BG?=
 =?us-ascii?Q?sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n7JuvV5LyZRYE4zivp7+/KGIpPW97ITOGazBuL+nrUU3sfh3NjaHlzXJNnIKgjvRyoH7o9Vr43mQcRgEAuOPh18ad02Wts+ODmUDCknW0rR/kciHD738ZzxWGpURKL8UEiAaOxHI+Lg6sFCLWkz3b5lHqOTFFt1i3wlCM7MJ+GLwFzT5bFONikpBXheqsJ5kXZ0gfY5l/E/+6dkWP5QO3dvBneqPKCrbw1XYOgJ8F891QEgrFHDb7AEjyAqRilAsOMQZQsbEZnhZSEpYslq675x+fsZyzq6ZuTO0Lmfao55hgso4HmeaLO5HfsZXMnveIadP0A1n+mcThAePcaozkUn/fPm+xmIhc0ysoEh/VFC0VhPHRD5LV1uiX0qX0N7dqxz7+OpESDMCtEEmxSA6IPiwUvb6VrwtmItbJ0bwIb6IqFgu1sSAbigMsxtBquJ7HX059i+IMGiAheKIh2sPBPlfW2j4XciEUiAky/HOwLRNJr6P6FLW2RvbFjBvQRlG9wqCMmQuVsoRW8uQpMRNbxgi/OAzLZhcjVpA6Xbcz63Etx3T37Mysut7gH+bK7rEDDjpC3yawxWBpDlZ2UBY/eYkGmIsA+bj/aO3taW1euo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a8a94f-e51b-4a81-714b-08de1112a001
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 02:28:02.6139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qiZzaP4lNEfbpFsG8RSMgrgk+ArOOwcJCC9fNLJQZ1J4OqUnXM1mXAm6BPdbpT2hh0rnuuOzHjvs0zTtBuHY1aqB6D45YpKygT1Dy3LW++Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5101
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510220018
X-Proofpoint-ORIG-GUID: FT0J7A5NdgExdYD_zXs_Y4sQSmVj5B0E
X-Authority-Analysis: v=2.4 cv=Pf3yRyhd c=1 sm=1 tr=0 ts=68f84135 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=w8z3O_r4Bh-EAORG-hcA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX5PstQkZ/Zwei
 UTO9bLrBmU7SVVqlm9ttvN/1q1pCRwYTGPpPpP8QcILXiOIDGFzD2PUI1M6IwhE5YxMr+p/zFP1
 brdgbjc9RT0VBGf8+icvX8h1MYaBMwYPhzLi8drRGl2R4zcPDOnQZ+fVyixqCKzlepjfZN/VI2c
 FqXl9MpZw3Y+hKhRnWoAy0S9R1XFbUnE2rPpWrIwLj/QLd83NibhzEtxJWfL6v+BCeJd+KbIlZ9
 9feBVlxe/6RsaV90Yp0MQ6HKLsM52r3WSgIdJQJaPmc+8siAQ1eTTWNA/OMyf+BRxxrLOHXXb5e
 AF2ZFAKU9sK/1IK2fN0zWmKKWccE918DFtqt/W+ne5ndwLnwMbZRhwCzyXN3do8VZ3KRx6hasYf
 g1AoNTdLULCl6X3TkijOhcz/+b2WHg==
X-Proofpoint-GUID: FT0J7A5NdgExdYD_zXs_Y4sQSmVj5B0E


Bart,

> scsi_decide_disposition() may call scsi_check_sense().
> scsi_decide_disposition() calls are not serialized. Hence, counter
> updates by scsi_check_sense() must be serialized. Hence this patch
> that makes the counters updated by scsi_check_sense() atomic.

Applied to 6.18/scsi-fixes, thanks!

-- 
Martin K. Petersen
