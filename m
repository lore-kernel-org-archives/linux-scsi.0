Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E259F2FCA6D
	for <linux-scsi@vger.kernel.org>; Tue,  6 May 2025 02:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746497421; cv=fail; b=py8tA5vmyT1+RYYHRjlKj8C1X8uYY/5pQ/LhHBpGt9YtaSO4gUgztVrp71KnjwT3GdtopQe8tB5t4lC0eF57+OGM4brDz8axYa/Ui0XzOSTd5uWqMx4QoGzTh/A4+oH9PnVK8qukYi+RLY6oF2qL/8Fq+f+ItcTM7u8qM7R581A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746497421; c=relaxed/simple;
	bh=9lQqqD9TD1Hfvc8vlmMhZLkVbWriBzY86M8vmq/BRak=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=eUkMWxdTHR0NqV2vGEA8XuMKd8BmmfrcFk4IXXyLCspMilBPcaeevUKv/rhKtreabb4d8gF3qNChXttJsfaZrlLVFnJ1rI/+Wz/jNxrZ9fZU2EsynvnBZGaD/tN+eODFYtToIgnm/5BYLlIXQLT+W2DhmXOHRSQKS6Qdo66CCuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZbzqU7iI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=emffhg3z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZbzqU7iI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="emffhg3z"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5461o2mh002441;
	Tue, 6 May 2025 02:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=JBbp/R/JcwN/DjnhdK
	Zn1XJyLhBkejDZehOpcaDDFMk=; b=ZbzqU7iI33Gla2u/9ynyT77n1WEbmKygF4
	pcx9juTv2ab8K6cX6zLuUAUvNVEIK4mFOPtZRl6R/7dsKVDH05bP49CCKfgYovOc
	XUcJAJUsIKtbvT4XKP9ioEwRF+6nJNrZFsRVzuuc8/ZfzFtj+dpKDNiA5jV3Apch
	kJl7Wh919I/7OILc+E92/V+0+ukUwydboHc6M+ZdapJVP8+iAgrZKMazGBAc5BL6
	ab6OF7jasr8ZV8d+x2wGFyi9zhVz1r0y4yJZhkSuy2ILisei8tP9oki9MnrDAkMI
	1/xdjbe2UoFoZXsAWnyh1KtcOJpWAQrb/mdIib/N1i+JdlRJULLQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46f94200pj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:10:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 545NrrcY036039;
	Tue, 6 May 2025 02:10:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2043.outbound.protection.outlook.com [104.47.70.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k95qc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 02:10:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QKmMai723x0hO9ghp0l75lnLYnRSEXvfD7b8p8WJbeU0y1+JP7lSgt/VMd3BJeYCfyLRvu+dhLMOJxvIiJLUWjHIkHadyLxzlfADwPR1KnqJl6sJ5bkwx4mODmdZ43UffqeBpZyaytzkT4m2zhQbcPZu+iivyTNyVSwCmz93dd0sORXoAHwlAXr5uU1OdPaLGQmBepaC1mVjzT6bKWl1Z+8ckp1ejup0KK6skGHOSVX8O/ML679CxCcqPYaCVzDYi3fH6Awk4YomHK7cwaDMd7n80T6XWOnaIjXAkaZDjEeW2d11X0qnSVUJuZjY1D6uHRt9M3hPgLzuQLB4bS2ENw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JBbp/R/JcwN/DjnhdKZn1XJyLhBkejDZehOpcaDDFMk=;
 b=IPtLWbXtKuiWGMcHkltmXnK2TOMCxIiqDIlXWBp2pzIWVeVOq8dW6wE3oqvre7gqEY7RXx6AcF5bxK6QE8qFt+cHeiGOFhqjspnGhgan2FU8JX4JXSrMi8LUEA2nvnrn4KCnmWpS+nKRtewZj9JS7d5tqYC+5/OA79g8PMHmsp/psAVqCwbzsxYDnn2zA07FsizJr9OE3HtFOgW2obG8USdq19lZbesgB8CgIuCovC/qoY6H6wn42atkKcxarbaC1c7FhGDAZXMBgLo2GG9AjuUmhxlSI8Ke2fYNpHWUm+iMS5ytkt0H95+5E9zZ+fT404gZB4VaCjDsu/1O11Yc3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBbp/R/JcwN/DjnhdKZn1XJyLhBkejDZehOpcaDDFMk=;
 b=emffhg3z6/7iiRkussoqY+A94xePHmuFAGMgfJ5KWtnlP/Hg5Gye5gMBKV/4UYX/oL0uzIty42b6Zpz+zL0VnOXPyEGywoGo7UDoRoNMuTEcdsXD0x3fAryC7/YaasPQxsWT9pE5nDPeMLkHvy0UHdrRCAMwPITCStNJwV8Vbpw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH0PR10MB5871.namprd10.prod.outlook.com (2603:10b6:510:149::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Tue, 6 May
 2025 02:10:10 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8699.012; Tue, 6 May 2025
 02:10:10 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: scsi_debug: Reduce DEF_ATOMIC_WR_MAX_LENGTH
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250501100241.930071-1-john.g.garry@oracle.com> (John Garry's
	message of "Thu, 1 May 2025 10:02:41 +0000")
Organization: Oracle Corporation
Message-ID: <yq11pt2wkw7.fsf@ca-mkp.ca.oracle.com>
References: <20250501100241.930071-1-john.g.garry@oracle.com>
Date: Mon, 05 May 2025 22:10:07 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0211.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH0PR10MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: 4121ef40-9439-47fa-b5e0-08dd8c432102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kymhWtWVuLzc7TKejADxTFGm5IrG+OLeXYBkKH0zReT7hWkh3s81b2mNJE5B?=
 =?us-ascii?Q?l646p3jcORMnodVLOvcxJ4bIQ2aupvbJtorgNQpPQ9P+cmAaiHiRoIdJ+US0?=
 =?us-ascii?Q?O0gddHMdcExY+s84kJyjrtEPKIrggly66ngOCHlKv3hPX9EWxd9aC1oqoxnT?=
 =?us-ascii?Q?qtXnjTFYclsfn7EnEYhrLUnvfdkxx4XkGGwUaHh66NzeDxxYcWVeAGSZ6zYj?=
 =?us-ascii?Q?OEJptJB7SYnij95t9ecaZ1i4Bm+TZjv6aEp1pCwwu47Cum1pjMTiMForr3Fw?=
 =?us-ascii?Q?9VCqnYzn6oK/K8kszeqdv4XR56EVYT1xjaGLNIu3MejOnYDYihIDDqv5AxmU?=
 =?us-ascii?Q?wl3O02S715HHtgFaZEbqSKPCvVblp4LtktyqJT2hgJQkJPGeFs76LItEOU7Z?=
 =?us-ascii?Q?QlfVBYz0Oksjm/WBgDYP1mbLLNk0kHL2I8nN6odXK9zGvUki/0JHxMlYNs88?=
 =?us-ascii?Q?DlO/sC2TNLhEmraOFadHp0s+3XW9GnHQiBpbG3W29Fweaqv/q2g+hlYfJiXY?=
 =?us-ascii?Q?9XXM3F0qjx5c4Z+H7R0icTZPUSswHdBfvJuZE6Fr+g6zc8oQBFgNZNuKmZ9n?=
 =?us-ascii?Q?JdAouw8jWZtAk7ea1QOYZ8pCda/bf6bomR2yFwL6EO9iot8M2pnV/D8LGgsB?=
 =?us-ascii?Q?0r1YIn3De5XktOftkMUGe6Cvus6ocEfzbvi0YvelLNmY+NfNqlZSyRu42R+U?=
 =?us-ascii?Q?OV3RZI88V6KjT8HfA7Oatngey8Z/dWzDE1ZTmqmCOjCoS1+X6Tkg5I39OzPE?=
 =?us-ascii?Q?mp/UaUi7F4Vn/aUMRX0T2lDBHyXUlk8pJH88tA35G14acEzkqfRJPEXvhQC7?=
 =?us-ascii?Q?yOI9PsimJCgM5gYgs3N62u5oQiabKXDpyhFVtfnA7YCPwBHDaSiieP/AwIkx?=
 =?us-ascii?Q?0Lmz2TuFIq4kGcLuuwssziZlMZTTufQzutWWnhASMYHqd+qE5P2vz0bTRnOh?=
 =?us-ascii?Q?sG1RZTfmXsUJQlHfmepNUB03YVs8hOZRkWM49FB59xHj5hOJlFSZzSyRaygh?=
 =?us-ascii?Q?kW4aS2g061PsnejZRP/YiSqZKqStifMdNLiaLEkgHhQdHiS1/KhCISKBUrF0?=
 =?us-ascii?Q?54EsdHdJ8mba/rncRoNlUwyUJQO94uTJsyyuSAMVjEaU7KHaiD5B+NBUcdhW?=
 =?us-ascii?Q?g/Xn/FxvzHf7ou+ldNRPPdC9ObXt1x7K71oUIJ+RqfN6uSxutSDvI/q7ar+I?=
 =?us-ascii?Q?PwBWOv5+n4NnZCEBw0XbnbLhIo1inlni0KFBFoapjY6SiDyaUUFGRyC8+gLF?=
 =?us-ascii?Q?JI7cb+w+fizte7DA8enIUmAH1mtCRNw9Wvp66VU4tZcf7Pan04dhb/MyxUDt?=
 =?us-ascii?Q?NC4bvvSYShTkMYfoozn02TxlTN6AWJYEJEpkvO8mVx6n0fo0sPzieLj9tkyX?=
 =?us-ascii?Q?KwIIdoWGqKKmuK6UyUPfxTFdfTAkiXonss06qX2/XJLjjy6LDjinh+P2qpEl?=
 =?us-ascii?Q?PJAEcTnQB8M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3so7B56qP9IlQiU86ab37TCt/OmgHSA/AuK5NXKIKocEwCk3VVaP9ApetkSa?=
 =?us-ascii?Q?iC0DTcGRHS2q2d/QtUw+vvyhU/GCphDT1mc7s291bEZRrcUOK2Y/M5fYjPuU?=
 =?us-ascii?Q?SkTlQLd8BxA8OCA51D3Vf4LTFW2lhLckh+fPeMRF5og1S3b57ZAvFv93k7qv?=
 =?us-ascii?Q?GIjdUH7oqxUUE1sg4PuKh1Sr9pOi+uCBK4CrWTO3WT+3Zow9jz/eWKMKqjDX?=
 =?us-ascii?Q?xWS+qQz5VE/zz2CjSVtNvScxKl/1/5nwlKa+YBKFq8rWf1FXPAJgFn/x2vgz?=
 =?us-ascii?Q?INvPooKDfnnmQLs+Fynif7RKPFhvUGOqTYBmkUPwVaqlWkF6HUXud6/ZTSKW?=
 =?us-ascii?Q?Rx/HrZ0SEQc7iYzKB8aqgbKV2s5sl22uHaS6EtY3OYlwEH4sg4++Ui3dJ4pf?=
 =?us-ascii?Q?2PUuos7dfptXNk3BTbYyRx/28sB2vrVxNVjJfkTPWkXm3+OOI0hBxAWxTKV4?=
 =?us-ascii?Q?X/EoXHOpzo0X9SLHVePur3xfq0dJbJ47Sx4nhmGSIo/AjT1mUDOkwS1tdB11?=
 =?us-ascii?Q?DQzh9G1dvTi8RSqnoX2+plVzXnJfOjNzULP6oxcxrDi1stFmd1iUZnLf9Yfr?=
 =?us-ascii?Q?3UrXFYS/kkoL0mDNW9/E8g5OAamBjPnv6276hEhFuX5DmewnDCSSfopPuKCV?=
 =?us-ascii?Q?zqYgs8KeuNNXej56knETE4w0KaF4cY7DkM5kAQBT6gI9RwtVlCLiMoedgboe?=
 =?us-ascii?Q?XnYPV/8iTsL2B1PbQHu/PY23I1BayF/IUBKgoan6Od/9BWgENSviAQEQOqCI?=
 =?us-ascii?Q?5n/0O1qG939Y/rQczvgr8Ukjmny+knvl8wFH32p9KmKc1WhqWM3crAoSTepN?=
 =?us-ascii?Q?nfQJLyeHvjelRdqSKA2H/rWSFJTSDNHTcjYZkn6ZvNUsq/9qDxKDFOGQFGf/?=
 =?us-ascii?Q?vo8etqRGfggEpI+geH0uR/K0Wr7HLc1Efy7gSBU0VTlUdmGwr9Agci7ka/v4?=
 =?us-ascii?Q?jO6W3O69fxXt6qvahn+PdPEPx2fVg28MXGoC4QUReqEk2Ppxo1UElMCJda1N?=
 =?us-ascii?Q?q049AE5Ox1T1oyirXwEOmFcYI65YdZSPa3r2vOeucDTRVcEoo2qBVdKaTpXs?=
 =?us-ascii?Q?wMRcjPhVJA8TIzzi3OBxntMOgpH36XTOCSAtzikPVk6Zf5/ir/qBpY0qc5nU?=
 =?us-ascii?Q?DAXmC6PbqXPDnh/tgAr1J6wdgCjm8niQmU7QSdYQOxHmynHwP4ytF2fWP6Du?=
 =?us-ascii?Q?T7UMLQcz1EhF0mmEzzXXnI0EbKqsJGXgo41zrzM41qZQTQ457y2fwzCWv2oM?=
 =?us-ascii?Q?eN5ZkVdOdxQIcghPMRAQWNgZz208DoXuRySL/zGC69ALzYbq7H2r33kBncFn?=
 =?us-ascii?Q?BnByDFu3FRGp2R3VnGFaByiO6NWAYned2+Fr3Nb2+r41h1O0V14eeI5PGBkn?=
 =?us-ascii?Q?9JqVpTFEcZlYAmAgqNS4E7ajUV7YHVA8Dd+c26T4z9PVBx8vhC9BLSMQMs1J?=
 =?us-ascii?Q?zG3rK+SI3yiS+gsKhQECmYuzny9+atlWH1S2z/9VlbbwVin6PuYbvw2/kzN6?=
 =?us-ascii?Q?dj8gd9iROgyQ9Jp1hWFREu3LIVL5ZG3XiouZGmEtSw1rstvzgIoi6ANNN0vn?=
 =?us-ascii?Q?ZyGtv8XlM5pqrR4l/7ZDUcGn8uSYOo/k6FY87/efU9c34ELbPfB6cRL322hn?=
 =?us-ascii?Q?9g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ChxH8f1sPMdFF1JCv4qqTvhw4SfxZaIdL/Ohn+UVC8VG1QCL2yc62SGM7sATeQJKujD6zZKDhXrYRZhD4GYxwnxlvcrg7SMhsl4YWRiDo6E/u2w4gEXaPzsY/8lbdKoEK++iCbOE9+Ao0bb4xZv372CZHeBic+R8RHZ2cmHXDz71o8s4i8TIyOpkzIb6a+LHb6ayCQEPYL/dM8HGQiJzz+6YRguNpEJTn27kigfItS+vDEkgf4iNyEcJ7coT3ahHPZp+yBqoI8ZwxeK3lXSY0Xj+4OEjVnyjvcv9PXb5Y+BFVzkFwvS+csMawlfbHtQzZTfAMaR2hsBORE3N0PP4NLMMXD2Gx98gxM4C35AD4PdWjB/3V5l1xhwx4c+8r90VrZMmkxuzOtCAkz0vjFHnpIed06LctcrhgSxJPzXlmPXH6wscomSGk+mlMJb+9XtrNxpx1JNmVnU1cBCrcP9yfmjii3IY6oOvRFJUBjPd7jNO8bb0jGSxAycyEqHKnkkpbHJd1gJ5v0yRPwrLLv/ZQgoiVgBccDbvvo9RopR7F6dN71rieD0RfHeU9ZabA5B1C30zTjRiB/43nLtOsr498vwZkh6VZBdJYI368INk4sY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4121ef40-9439-47fa-b5e0-08dd8c432102
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2025 02:10:10.2286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9kivKI+3y7ZRlXjSgRFXggu36y751Bl6NBpk8luPSfnevXegqX6dpZL/J0ERnC2F83Egbz8MHwndojzLzXuxn50oCYMqFhgHYlq+bH0Y/Hg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5871
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_01,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=841
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505060018
X-Proofpoint-ORIG-GUID: caHQlHZQOKSPntkTROr_IiREftyeBpIy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAxOCBTYWx0ZWRfX/aKdyyebEesa NxygeZ7S+mEa/bQ452ANZ4LKr283B+ygdne2eB/uRYRCWYxU+t0cQWtNDXEAHhNC47DUJ0bdiPf 4/LCMx9kfgCZawbRViu3/rIhBQToyPtv37nBB0+savs4QyRnfKzjiAycdO6rkLLu4DpP2XeSmwO
 +uRBqB/KkYoU3mwdQZvh/qxwf1p0ZMTQWOP+O5fj7iYC6GverjOB8ufifl567rkwRcDerBfE/91 QsBuKQqcOM2shNdKDFmzhhbDgAkEAI10d1rTZo53olFUezzqYxdVPXYf+6iioFDUwFV7+ll39nz mlLFpCdVsBO6SqmsfmBuY4SYTZ00kfe3qnnpPkSTYG2PzM71+VTJb/6o1MwQYy/dCtgKZcddJol
 /wHFcvhA/LufNSasu84PyWDPkbXTvrmnQLd4NfSQvk/jdlPfF5P2fJsnSkKq6EjfZPXGBfCR
X-Authority-Analysis: v=2.4 cv=VOjdn8PX c=1 sm=1 tr=0 ts=68196f89 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=q32mctcrirO_PcNCel4A:9
X-Proofpoint-GUID: caHQlHZQOKSPntkTROr_IiREftyeBpIy


John,

> The default atomic write max length in DEF_ATOMIC_WR_MAX_LENGTH is
> excessively large.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
