Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C814217547
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 02:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724899598; cv=fail; b=qmZrfapDyJpl44L0dMzrBk52kNdLW5jrvsoZ94Uits08/S/kgA1KDOCw1829kwqrx3LGLEFWFS8DGCUtwK9zdHG/EgGGm0ttUgsZ7ra3agKbtAxATujd8i8Ow4q72WfEoxBaIGK/flak1m5SyI6Izci2t/N9MU2eXPB70LLjlwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724899598; c=relaxed/simple;
	bh=ZHeGbu7akQKHv03J79o7nW0u4YLFnhF6XfHTjhxnqiY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=bWEMO+xzMbJ7ax4XtlHx2ymWDkR7dfxU+TA/VpNkpKZDFfngsY7gpCdl9KQvB65wMl39A6SLoWRNJu4ubCn6K2dOcheMOwyeEaShLFQB26WRFMFhqZu77sGLUyGfI+h3/k1dkWLyz82NWUOAOfQjXg/iYsWBm9ptMqAQtkvK/oQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EhBpj2Y6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PKRT1QEO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EhBpj2Y6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PKRT1QEO"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1gWi8012454;
	Thu, 29 Aug 2024 02:46:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=OIQV/46OTS9Ny5
	otiKAvz3SToEBpN4MXA79ipoU/XUE=; b=EhBpj2Y6oxuQwINjPVP3Oum2/bANFo
	z3Ll1c3zQ1Ndi1SZNd5pHwKbJFGDWRUkLUgoLB/4HGSfOWbLVi9PPpLiOKVK3vl3
	3onxDqA2E88pFEKqNbdQWvelXtG9llL58RGa6SgCmyviM25GQBq3EmwgWxgEhIQL
	ak95uwg/bgxCkKhFU4mp5XR9BaKR0B3lermw9vMo306v48D0BO8gvkfqeCquNDlV
	MODSkY/xNUOYBj1P6RbOX8IyOb/nhDgVDPDIsoe2X/txuKZBGZPS8AJyZ0Oh7nCs
	FbNNwTxAIroULGdNM++aSs4YPwhTutX/MBYdcU9rEoRAalRoo4we/Uyg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pugu7mc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:46:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47SNd3qm020430;
	Thu, 29 Aug 2024 02:46:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 418j8puwd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 02:46:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yBnbAznDRKyS8yf5ptUaPnzIudK/TxSk2AOyNQIznjMS34UnZVy8o/ClPrXPcHfeen+4N7ssVJp42uzb/TCqj1gBXn6UHTVdz8KSZIeMIuhb3wB4Htjekv7i7SU56k56VxDcOt3sPDI0IAQtkeLGul9GnCbFRQdfIUOIGkVTA+No0wAgbXSVTLoWJC4L8+9Qbo2k2tU3FLiBWyCBNGCU4xk0EBZKdXdUWy721S/+ziqSa5X93c6AQU2Bl41BP0/TjIo6G9K1jGs+y4zxvgnclNHN7GlDJ5s4jPYJiQcpdr2LG9erbxcopYO7Q8uwGQ3VCxsKTyIzIq5RLBLw/UNwKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIQV/46OTS9Ny5otiKAvz3SToEBpN4MXA79ipoU/XUE=;
 b=HzZFCRBOMF2fyaUX1jQqHjRAI7uiRLN2P4lPIocei2XyOyHjvEyKlSxS7ssYnGaBLIMZfgtFw1nv6B4e/x+8aN9HNjG3UfadHaXiFYJ7h+26rTqfSZoTQE2QAHZ32zw7XHKGrPftVrPrF9PHRueEHaXEGoxUQ9IoIpZemGanAySL/yXfK7hIV7OGMJqinCIpZyLICRT6UHr1evzubS9v1RzKhKU4bUMlO85Jwm1NEcpdwl4wqjndbuqUl5ELxt68a2P0m2gov/FzDvsT8DNgtn0fE+HcRABTJFE5w9crplqFwyt00brRkm+QG4otwe2HZ+ABY3r12nIfRESVc641Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIQV/46OTS9Ny5otiKAvz3SToEBpN4MXA79ipoU/XUE=;
 b=PKRT1QEO/RMhKW1JE6aGZquEYGarPovcfwDzdlv8ZHjLxhVMEk23PsSNqgeZC7M6rYaFW0RJF1wwdvlRNizYUGIWo2O2ggr3jAchNb8La/KlDLmldXzT4/TWOEz5Jch3xc2fm917xuxq5eyTNRFeh6y+7Wz4lSf4PUz2uTO6Hvg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BY5PR10MB4211.namprd10.prod.outlook.com (2603:10b6:a03:20c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.19; Thu, 29 Aug
 2024 02:46:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%6]) with mapi id 15.20.7918.017; Thu, 29 Aug 2024
 02:46:24 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
        Mike
 Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 1/2] scsi: core: Retry passthrough commands if
 SCMD_RETRY_PASSTHROUGH is set
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240809193115.1222737-2-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 9 Aug 2024 12:31:13 -0700")
Organization: Oracle Corporation
Message-ID: <yq1jzg0cbhy.fsf@ca-mkp.ca.oracle.com>
References: <20240809193115.1222737-1-bvanassche@acm.org>
	<20240809193115.1222737-2-bvanassche@acm.org>
Date: Wed, 28 Aug 2024 22:46:20 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0645.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BY5PR10MB4211:EE_
X-MS-Office365-Filtering-Correlation-Id: 608ffb8b-f4af-405f-4003-08dcc7d4c568
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m/hgPKeHC9w1wIybhqN77Dm6aO8PJQuB3LylcJETs4RyYCLlZpiIqbgjCK7t?=
 =?us-ascii?Q?tn/IPSEtx/HjZRWLE8oc8Q3uooHrlpZGNYaxFeWRk7KXiPi573WPTBL07Udj?=
 =?us-ascii?Q?aN/n7tRQQAo+LRADWSU5AWf7hBcA+w4pKtHBfXUt3Ut2Qq8fzrJw0W+MoYFi?=
 =?us-ascii?Q?auNul35HQwWaQP0EulUQbOdwVw6ZXpxhC98dpih3hNpmLyHI8ZLTrAuCzuGS?=
 =?us-ascii?Q?cAiikay7W2BgOvdikTC35YnCGOJh/yCDzndSMkFVo0jRoe4o271EyzASXzIC?=
 =?us-ascii?Q?PebLQBEfbrluBI55cbB6ncgXTk9iCfdtYP7KBl0lq8mmypATVz2PXY+8uDz1?=
 =?us-ascii?Q?SOKoqomIMBg9MNYS76FMjL3lTrTHLXUSXvqeHKx0fJYjrJhtYinHln+rcQGh?=
 =?us-ascii?Q?kPqdR6ebpqOYDMUA+IVDfChDQAsBSF0vOJLxA/tste1ztibb1QYgjEP45QBV?=
 =?us-ascii?Q?mQh4fB/MKkmeIKyU2YOO604DR6yVCKncWX8N/94WPB+kKrj31LZPLu5nyxsm?=
 =?us-ascii?Q?ThE2tqtkWaMssJ3zWICSN6NqZfR48T3hq06qh9aeqLf4KyUtS5/YKaPdAnde?=
 =?us-ascii?Q?FDEljULbGTdIOzoFl0ec3rZdzJYCz0skIwEHQnTovEVfbat3rLa9CoXdnEcd?=
 =?us-ascii?Q?PcYMqw8ZHzQ8OeZhwaqN6qkemdeAF+5dPd43V2APw6qhayzIa2br0D/AH5Ry?=
 =?us-ascii?Q?sY7F9lc8QgCcmYLAZQU7WtpBiLRMYnbyd1gPw5xhIdV1nqAs2fddiW0PTYxu?=
 =?us-ascii?Q?TzZn1uO/yNGsDZe/ys8qnE/8BLBgXfqPoA3TmXCpqUk8xgUMM+W5OXapoyDN?=
 =?us-ascii?Q?ewqG0Osd9BMl7qAIy6cXDsty+4FBy9PyTFboBQg5/Q35RKZuKXzzaEMgqsbr?=
 =?us-ascii?Q?3UOqtr7/zglMdbe0nN6IxY/7dxRyDZ7xPD18lbHE25ggOI9X1muotDEol5qy?=
 =?us-ascii?Q?lH0eugnupqrH20BY/KwWV7+CtebS9/ceIQc5TV427I9hpb29AedBza62DXBA?=
 =?us-ascii?Q?IHHRslx11cM341s1IgecBixtYRP7aA/c8e6yBwd/QpkWuneZH2VUEznAkuZ4?=
 =?us-ascii?Q?H0nWF02FsgRkVH27QTXNzisivdC3bWVkhWnMpJ13o3zdjL/xkisbAaDMuQSY?=
 =?us-ascii?Q?tFOts0g+CSBFc3TQVYF3oUqWch9O0ymX4SIaNB0/tZyua2A8If8jWyqdKYZ8?=
 =?us-ascii?Q?a4c2D9SlbqgIikhE36K9uIK6hKfy0PkwXGdwZS27heNsHyxvgJnfRVtCPoiF?=
 =?us-ascii?Q?5GyIvVKnQvgOg2msFKYc1etFaQZm4Sre4W257vUuUlp8+9FlEBNyybqddVm/?=
 =?us-ascii?Q?2zUalJsel7YYU+bc1jN3sbOWNUXfBHcyUN3mjvSCPtAUSw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A9MSTyXO8lK83hvF1wDqQifvCv00Q6EO9gDDJRmvsWU1nPYETs9oCXl2kiAj?=
 =?us-ascii?Q?P+UG1imT0exX6s7ZAryAKqUsR+1da98RNIgrx7nJDqPcvX0kQgtfMMH0Ma5p?=
 =?us-ascii?Q?LaMX2RftezuIbSEAumuv9JOKY8ETAw1s1HuLkRf2h1e2CO6+BQpbhwgalPXK?=
 =?us-ascii?Q?HTrlIUJGjufHmwt79lm5YYtdhlGSCPLhkHETYqFCcTUsSORYFpxTVksu0exx?=
 =?us-ascii?Q?PcC05Bn7es+u0het3UMy4fFoSjHfG6d8VF3lGdlup3S+8yDfyaPG5LJ0L0MC?=
 =?us-ascii?Q?Pryf/Uyo2aI002Ho8hUtVbzbWJQXgKQnA9xJ41eMDKDijpKoud49E/6VsKgW?=
 =?us-ascii?Q?I6A871QakwrcjrzZiUsg3E78jjR+mbBRN/iTdhINSSZwzb6QRir2MhVoCBao?=
 =?us-ascii?Q?qWIjbfcQ0NtVGQ57+1VWPmiheA+d1SWRfY5EnraC6L/ZzOlFILZeDHXwOGa7?=
 =?us-ascii?Q?w6CP1MZ0Bozo9ouFhESqzlRs/pIv/AKMLL0nnA9OHy9Qb2zIckNl8Zs1XGyb?=
 =?us-ascii?Q?VBG0CwSjAblIkbgVTa3qQPhE4tBsTWaHK67g+HlllgVtKGRj1AOSkU3E3bQU?=
 =?us-ascii?Q?XyXDzbMjedGZXunULkXpS3QmdAOuzwBU7psE43v2QS87iQRKVQKk6Zsd49xx?=
 =?us-ascii?Q?PZZjiTum8lz76E5uSd4MIPCoMBv5n4SloA5a/DD9MIsCsxQCVQGio0AxSDzv?=
 =?us-ascii?Q?ZO2HtFLExohPZ7HaBByXDFLH15RLiVZZkWdEsTV1y3OjZ/YOZGlsfEyrQvpN?=
 =?us-ascii?Q?zI+Te+RXIWDZOaOKPzxnlSZkLylvhnCNm5+TU/G5lBaLxzN6gh6YnXtgs5Od?=
 =?us-ascii?Q?j4+9tHLwgrsDWqblTLYNFAXOt5vQ9Ezpi44emT1UsiQxYK8nsIlFtDkZItrr?=
 =?us-ascii?Q?4J+dRqBvfXdzGoBoXrgPUENGw0IDvn+oqbYGhZZoI4uIc4GbRANU7+OQFw4T?=
 =?us-ascii?Q?0LEPZ/IsC7Am35TqAHkVCQCqVkKT7arKEQhNaMT8kOJLvQaAqLvg3CIsOm2p?=
 =?us-ascii?Q?Xj2oJtvWLzDESz23pnSWcjkiEcTG6XdHn/COC8vEMewlWNqZUmoJHjzIV47K?=
 =?us-ascii?Q?N++5JLd41vPhf+WN8WiP5vVq4M0i/eqOYZ1OEmg0KJ678ymSmvZF4B+F1TSr?=
 =?us-ascii?Q?fHt/wKG2jjZLaqy1r5l98M63zgjvfy+VgGmG0U3VwSBxdx+/e6zjNZyeatAI?=
 =?us-ascii?Q?5DX6+ihvdMW1bWBCuYeNDUO9aN8xC5oAcXlgJnmGt6FSGnS66gdBxAMVnsjf?=
 =?us-ascii?Q?l+c66AF3o8vAfa98Fwo2nDFzN8nvfi9VJuJOfCqj+1fI1R/tqIN808Lf+puE?=
 =?us-ascii?Q?EVnFhBF2WDNRqqrCwrJ3Bpz76UEg4G79bQFeRAL36eEp9qdWpyTsUSz0l4Xh?=
 =?us-ascii?Q?QIK7WLFoDlhGCkAKkCaIUEnNJpQ+rRNhe78c0VBPWVmOzxJ0ldKQMjoSilMi?=
 =?us-ascii?Q?eXY9l8VWOGtCAQkW6fJzLTy+nBWhctFWueZDkbvmGCeN/hsWX1qv3bLDw4p9?=
 =?us-ascii?Q?wpETnG3utympJBZDK1n3SG+2Ke0m/ziDRDP4pVi59qlV+A9p1turnGw4M9KF?=
 =?us-ascii?Q?MxzWgqr6Z5Yj0Z4KQnKKXrsVvk9C/Li3kIGLRnyGLYCsN0NTgp+N3zv+usc4?=
 =?us-ascii?Q?hQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XZf0bY76hdbkjGZ/ge7C+FTpgvGACDYqC8egq9zvNc0Auv+wzZjTM19jVrg2VLOi3oLOu8yYQl6nTMT2mxC6VVrngFJD1fVuPeQA6ce93LdKeLzDcCnpxTYkybVTmeRdvdm3ZfeSajCcr/v6OtPVEaIlivKAVsnpmAGRNp3dFSOIdImnDUoUPvDxwC2Irzfn6zij1F87ORB9ndG1ABeGle38aVQVNCoG9HHOOJHwp1kX4KVs0r6rQcTPy/gGbNcrBOcyjMae68fCgiSr/DeKl9dkO0XeBlVOPP/UUhFaCviro9ZQdcpHESF/U79IoZJLCmajsdQ/WVxfrhe14N90xGD1MvDypoDayAc1NFs75rFpAm2Dw9wbIo7DeKD7VXXaknDJNp7QNNt/SM/t8IoO73hbeKPfsL5Y/PwhOUFhiEOB5B442PZPqk+GcRHhoKcIW5jqv3U8aA2VmKaM/YZuyox9b210cXLAZN7EEGCF0KtuZCMZc6QCQaZvUjfUmvvcRugVu5m5IOIZjIyaOoNRgZT3o8Pu3ZGk9LdBQqvJ3kOnJrfxAyHiq3AMIFFVtdh22iMjCyRrTaSDz5XNdNXhQmjJhiEDUDrp9X0YWyIwYgI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 608ffb8b-f4af-405f-4003-08dcc7d4c568
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 02:46:23.9713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgVtQBjIsGVnqhkztJ3O95TlSVhQZSJ1bYyxjrGxVAn2Tdibuydp2ey6Wv5kzr71ohfT17cmdvFMVOkrcbQ1yqmve0WRGDg1jJ3S169tJfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4211
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=874
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408290019
X-Proofpoint-GUID: H9ixmB8OIIbn6bvFMWTG2k72U38yBR_H
X-Proofpoint-ORIG-GUID: H9ixmB8OIIbn6bvFMWTG2k72U38yBR_H


Hi Bart!

Sorry this took so long. I have made several attempts at automatically
retrying commands originating from within SCSI since the lack of retries
is a general problem.

However, in the end I prefer the approach of describing the specific
conditions we want handled using scsi_failure at each call site. Works
well.

> The SCSI core does not retry passthrough commands even if the SCSI
> device reports a retryable unit attention condition. Support retrying
> in this case by introducing the SCMD_RETRY_PASSTHROUGH flag.

FWIW, I find the use of "passthrough" to describe commands issued by the
SCSI layer quite confusing.

-- 
Martin K. Petersen	Oracle Linux Engineering
