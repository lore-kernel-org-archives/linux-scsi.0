Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F380277026;
	Wed, 20 Aug 2025 01:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755654848; cv=fail; b=fhqNheg2v5kBKM4z2u/m8TKtq6WkPQSCumDTGBwunKtCPNOMZGLbq5zLllFQqLYoO2/36B1N+miJ5yYqCuAuHfp/B5pRvsdykTeBtT9i+FvtNNKWYKYdmOhx98wqN/1hTpMt5z041mYzun9spD5cGVrJivirjC9XbMyktYO9y50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755654848; c=relaxed/simple;
	bh=aOEBljS4t1BrMR1nF7YErjs7W59Km3DlCpqKVo67Qeo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=J9xryLhDzSNgvT1vsEBxHz2YvdkxDfu2IrybY3vdn3/1dMAb8JzBun7trNxY/8+66R6gFyJhHZA7bwEV+jid69LVrNdxDPhrlOfxzZ1t/5xkp/i4YROsjDCEZIpNHTkofGVjLpDExRdnkEVXObV7mygra3h3EK006fW1qRykkmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jejm+J6E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z5rEckpZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jejm+J6E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z5rEckpZ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBrNA005739;
	Wed, 20 Aug 2025 01:53:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xHGidzExrLEymXwIyj
	yKiV1K3wELDNidDqZjAno93T4=; b=jejm+J6Em+MLJdM1eeljQSxdgQjqR46RWL
	dYTuFXkXXcnHxQQohNeLW227+5zIe6J05gN6NRjDJBhUhKkj37sM6ch3zJdl+jE0
	j0UbvUMDFP/oon+chwll5lb4MhvXr3QHqXL7CR5IUbbio4a9zQQRhnoab8R/OXYM
	NEE8Z6Wxf8EgNO+7DPaiJYj/yxafZaQ5pv+FISpXBf4waq3uG9qfZRyHh+Bcz8RX
	as/vfIrmC2GdCflQz0GEFh1Qa7HGzDbRA6GFPqbJTvBhwWdAy/vDCgAsl9/U2sTC
	fI7LMad/EOJBrXof7Cz3VWb+7z0PwSzhILVIKugjwGkWRb4z4tiA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tsr999-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:53:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K1Xqid001649;
	Wed, 20 Aug 2025 01:53:58 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3ykbn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:53:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NP0Wyok1R3+li78KAyCCBJyRhVSKPRCjAocIc/XKl2c8OyBBQSwIQRM6EuFtU2tKcbSJBSmUQmRs69nFM1+T5LHzmCf+F/DkzB29JDpOdvzMndyeuRhk7Pdl8xhK1EBrWiIBdR6rKFRnJzg+D9zz+gClcafoP4Lf7GaUA0qxFUVEwrLTiFjjssKZkNElHCtUe5DKNeeniVVRiTQB1j9piPegEfWn5o6Xdt6ATnHVLBFWcHoKkW1OuybUf8MzLe0xVhUrM+EbHXHF6Of6bzrp51sd+toeNHv5LfnhvXnLeDFHV/JjMYDi+bvUW1YEzfFZ/xMQhCo5V7GwV9p8NGfzag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xHGidzExrLEymXwIyjyKiV1K3wELDNidDqZjAno93T4=;
 b=qnBMSExGUNTa/zO0gLlRlLZ99pMaaJjULrPBXLt2TaPibAa231J331bwaAR6ARLDsjwgEt4k0Ylx+0CnJeG3QNJuZRXMQnTzHF0cQ8hILARsVhGkrNPQmjH+jj3LK6Nq+f+CVT6l6HD0GBlvRTCuSOiy6fr4ZnDxjjtM3fOHaxDGLTd98f7lxg8XfLNCfuyyssMPw6wtSqfx+8dIi/cDFcO2IwlniiBggmo1uIUrLbojYNiDdB/yBCxB16mn+oXqCDW9ev6HzNYcqaAGiAASe7QAN7quxzKXdhc/czcCyhk/ilRdsMJsgM5TX9+zjCxM1ygIK9rhba6CwbWvNEU5yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHGidzExrLEymXwIyjyKiV1K3wELDNidDqZjAno93T4=;
 b=Z5rEckpZsWAUn88h2x12uaH+7z3MGoLhCkST7AUWS7JsNYhem+vtddJNogkOi+htiY/O/SOlqrOk9+xfqrK2G5n+RSk8AsTd17YU5uPyU3LUG4s3nqD680YVdTi7pZK8f19rvPRyzUISR6yMko7zBaSl9r6Y0LDycTvJlYoWcCQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB6614.namprd10.prod.outlook.com (2603:10b6:806:2b9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 01:53:54 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Wed, 20 Aug 2025
 01:53:54 +0000
To: Cryolitia PukNgae via B4 Relay <devnull+cryolitia.uniontech.com@kernel.org>
Cc: Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        cryolitia@uniontech.com, storagedev@microchip.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangyuli@uniontech.com, zhanjun@uniontech.com,
        guanwentao@uniontech.com
Subject: Re: [PATCH] scsi: hpsa: fix incorrect comment format
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250806-scsi_typo-v1-1-ec353a303b31@uniontech.com> (Cryolitia
	PukNgae via's message of "Wed, 06 Aug 2025 11:13:16 +0800")
Organization: Oracle Corporation
Message-ID: <yq1349myd0b.fsf@ca-mkp.ca.oracle.com>
References: <20250806-scsi_typo-v1-1-ec353a303b31@uniontech.com>
Date: Tue, 19 Aug 2025 21:53:51 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:a03:255::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB6614:EE_
X-MS-Office365-Filtering-Correlation-Id: 5df30b56-3d83-4add-580b-08dddf8c6b21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qZ6yl/GHAjXDgYZPDPtX4aZ5tGiwgLr4dUoK1h/dGxd+f7NzfoNFF+lNiIob?=
 =?us-ascii?Q?5gwudAyQ43M0WejRrlOYeOQ9veDYs+6EbrdK16a1axoTIeU2iCHxJhGTU15I?=
 =?us-ascii?Q?GuIupBU5j48nC9wgMRJgkevMdkMFku8EOGENAKao6s/vRXTI1rW5uZaYZzN9?=
 =?us-ascii?Q?EfNZeHA26IUdXjp4n0VwP2cWwMxswW9616MjfLB2+4woK+QuG/1i6n4xkuOX?=
 =?us-ascii?Q?Fpht/nwPk1Z/GUPTaysPk/SVnKK5T+6zIZw2LRuXH1ucZjH1uebzcKb2ynus?=
 =?us-ascii?Q?j3yUcfi0GrLBE69COLKbe4W/+y76u3m35rpBvFrJa1NyaJjR+3zsoll35S8G?=
 =?us-ascii?Q?QEMc1i9sTJf8z6/u3oD3WP4dgUnp20+ISDHPLWT9OjInXyYbGjcmm25pKOGz?=
 =?us-ascii?Q?cViv72Z+XtpNee0FlltXrh/lyDpRwCmPEuG/Yo5vYDvK/4ouBVsiJIL24tJB?=
 =?us-ascii?Q?dB2Q69X66MXzI5/uBDtfAEp1uTKOfhLliYnTicKo5szGtA78dfThMv3Km7FB?=
 =?us-ascii?Q?2B65+jQunn74LzUUhQqKAjAhEU2nUlIJtIrb3CwQzJ/35PqaCzeHYCiLeegu?=
 =?us-ascii?Q?dYjy8i3txJqox066tBSi/xkKVju347i5Y7jpDxJ+xkYeL7W4xPXq+Jy5Js49?=
 =?us-ascii?Q?bm6eT5OzaqR6SSjjm30y/a23OG9B2pONrYkku7sViVaTJVtTqxfpA2O0qKwt?=
 =?us-ascii?Q?eKO8P63CuzUZcldWT3VxSEyqBIUcz4ONW+4rn7uMQWDD93Ach2W5fNCc2CTH?=
 =?us-ascii?Q?9tiBHQ+ZAyedI9V13hwVW69szqqrlxBfyj4tHeQSGHtp9+bKbAzPKAur6HZS?=
 =?us-ascii?Q?Nh0YfJGp/YQ4srWv31bYo6iJO7wzD3R7HhOCwFOgaFasrsW590qF5wiiCqcN?=
 =?us-ascii?Q?VAX6bd3it6xTieXehxLx2zO+pweDvwpHOdFtNJQ1AQ/vsl92Fz0LzwXSSxQH?=
 =?us-ascii?Q?aDpQ4/6NztIgUZY7eKGCRVB+5tHIuys+tQk8uCyZWxYeVcoe38gZfJRtxmPZ?=
 =?us-ascii?Q?GHgoKVRl0DsadJP+hLmzWWmuFi+TqQwZEmHL9KXd3IR/NX8uGI4TgsGQ/vJ6?=
 =?us-ascii?Q?Clk0u01ssA5fhQOwNUXc8mJI/LwImhihYUJc9ZRR6cROXllrKxgg2TXBA7i2?=
 =?us-ascii?Q?ATaXnetvHmRydIa2UtlU10ZB6Liz7+W235HrMgg0qm52zi33uL7y0WH+9l7d?=
 =?us-ascii?Q?ZR0ZiyWw70TF71BxseB6Rxq4fm9awrXJRajdvK6l+psSf5S2c335nusuvF5x?=
 =?us-ascii?Q?C5dJq1bxEiCYJauP1bAD6iWQNIUipf+C4Nk4YOdhDS7HNBrYHp34uxklRmy9?=
 =?us-ascii?Q?VrGR3uCr0iQlFwIBgHQhu8Wcj1Kjz9aR7uLImydsjgV44xMXvt3CyjYGB0h7?=
 =?us-ascii?Q?g9RC7egPZyFy7VO7P8B9wIyMoDTzejF3VwddC773JrbHwQVeNSfzTyUON/NV?=
 =?us-ascii?Q?oeWTvhza0B4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?66vtPcMcLalAogSTU9Z7jTFv5EEy0SkirQa7/IfwdtfXU3Qn4sRJdMtCTD7c?=
 =?us-ascii?Q?NYAw6OtvkNDLZilIMa2oAL4rX1X5ow03mBEN7bI7urW1hruHR2Tf+i+XlSp8?=
 =?us-ascii?Q?RodY4NjO8LaR3mmCuFH3FYCPQRYBPQV6Nm4ljtIvo0ZyaUkMxRHL7cQSICSm?=
 =?us-ascii?Q?Jc7i82sFONABt1N6f74UekuOzJUYHZXVnrfsqRjrMErtVhNvgVUzjDPX1aYo?=
 =?us-ascii?Q?WMbn1VGFUuHSa4BChpJ7Wvj4sFlmaV5R94sm6lnjJZ8A2Rjt7Yy21a/zLho3?=
 =?us-ascii?Q?GpE69SEfrHpyT3X8ucZD8ayDiJPpl6rO9nsc6T6FYcFws/y54fwIiu5SBCgs?=
 =?us-ascii?Q?JFvQNFnpizfz0sPg3WR812dtcNnQYqCoap7j8ZyFVcOWOoXPJlG1OercaKih?=
 =?us-ascii?Q?CRqlu/P8TQp1/XYjAmgnzkGq2hBKBzs34MikvAUUAbNRNNZCMx5s9P7Vgra3?=
 =?us-ascii?Q?tSybUk7wvKSGpPXQAOfTKBgxojytE706TMOHlzQtXz6TdVVdjFGWGWxzXX88?=
 =?us-ascii?Q?lUXg1qW743KjiUKRimsfk3ub7gaAW2xlxWYbBkdElgHyU+RB6YQpmcyRD4g+?=
 =?us-ascii?Q?8snU3LzXIzs06l2KGzU/boMSO1v+jahaG9FmH7A7ryPZV10XQnIXsM1drO3O?=
 =?us-ascii?Q?C9BJMB//bfdsTgL6+p+cPlWGjDebFosLWagWoffWrM1grG5D9UrBS2cGKV3N?=
 =?us-ascii?Q?OX/wPWBhxWP5dxgnKjONTAbkC43SaKYGlecE4Y3VZzaEw9xOpzEOjYTA9zHz?=
 =?us-ascii?Q?XJYmGnmBLYPpq5hwpV+vCYgp69VXf0N7RWx9OHoXz/J1SzWIiflZ+oogt4VA?=
 =?us-ascii?Q?ahaWxECoHAog4DrEW59o0aVUr8ne1lFo7D7tccbJWB1FwdqHBAET1TnR6V1B?=
 =?us-ascii?Q?Fc49ja5c41LmakzbdRPoq32DoMWbYkcV6samy37hSILjcbVnaxWMEFeVzJ0J?=
 =?us-ascii?Q?RRBroIrerhLPpx9Hb+oyyBvBB6aBTieSKS5LzjJROaucOFwdzDFGGCLnyyJv?=
 =?us-ascii?Q?vGbtQAySa0fGEGeQ2d51WLV4vAQOinZkEmUNNsQHX8cUwb3X/m7mGz1f8tSi?=
 =?us-ascii?Q?N+8HpQ519wllledrHyjUgvZ9I3npsOxMURvwGZVZcyAgaQ/w/4+DRDpPHu6f?=
 =?us-ascii?Q?GfRO7Pj+SPI4o0IplSFHeI2YddaIeDfAN345F7lIqvm0D9wgPnT80NM3JIq5?=
 =?us-ascii?Q?Rr+2NcO0ASItCRa1IjzyXpb8kwI1V4ba0COa4t68HQsAkQplkphhRTYr7j92?=
 =?us-ascii?Q?j+MkzWatPk+Z/3war9sWsJWdg9v8+G+7xrnR4Ow1DzHMhSGiG2q6wVNUAM5K?=
 =?us-ascii?Q?7AX8bhzeDRoiWQ8dDT9WqWxyV5J83oBzPSNIZnpM+hhpxgV36v46tMYoeSS4?=
 =?us-ascii?Q?ohFtawIuIAvzBnyodv24aI+RpPZk7hjMTOuorsrG6FTAwsmNzdgzPDNlnSus?=
 =?us-ascii?Q?U/R/szU8jvNI8Czl4fIGr17Ai+Pcbr89pO5III4SPPzjKt7LyKynUkzYlf0Y?=
 =?us-ascii?Q?PThVkRzAj5ATQIFH2knBTfXJzFLgbp7aaLafqBi5epumhMs4HnIlAFveZiOD?=
 =?us-ascii?Q?jO9COXQBhhzam2BNvGulo4v3oxwfLeg/tbSk5pSl9B+Q9lLMyXaUXCsnsFbP?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CXxzA5ayqR4CIl8zIg/aaiLFWeljmpwoXc2GXb6Dy9azu1LE8/gk5uzNlEiIufR82SKzXEln/NMyGkfjW+9n60FpVi7iIRRWolaIEJKJwMn3NBZFimTfUJCazOvUlVOZ0zA7EMuZXtblMjuCYjBf79VeivH6tmcbE+LvaudhusJDW6j0GdYtWnYQuKbeD8rrYdPKEYZi7+lhSAp8l3E6i+Z3191rwn0N6spIAaycEhkOj+SYo3auPMASB/MFr4APhAJe6rS1j/Kt4eDBxdNEin9bWQVYcVHyM4jsKi3lNFZ0g7oE7r7bUvGPyhf9XsVkm3yyjma1+0iY91VFEA/oBOhhAjP+A1Q2nlWne9t4pnmWapztIOxYyCvPyoJTmwaZvgKTxJSJcgULewC+YoG6hU6Fl3ZoTMwKyXcEqTMXsPQZx1N6JgowGiAhRHApBGtitHUpP3d2bWw8WvGC4zM4AXlexHBhYy6c5CWb6SorsJ/FWPBu8P888AcdSNQGvGn2AyswXoKscWFlqKY2J4Jz4CBc8lZRK03HRSAhkQV5pXScFhvmj+f4uIa48cRvMo0E/ZE/W2X4Qqbjaq3T1BYbAqZbpQCmy5k3PYrF28tWnTo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df30b56-3d83-4add-580b-08dddf8c6b21
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 01:53:54.3349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZnuuc2Alc2oofBCd5AxZvJ8Zx9LhTGa6a9qOsalh94k7kzvQ6EXeTv44Zrq8kAX49KleLxQ8JEtEjb6LepvmDz8KaUS++dU3Yeiq5Cy7qg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=693
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200013
X-Proofpoint-GUID: Dea3pC6zM8kjPC_XC4lzLBfnHvB8fqai
X-Authority-Analysis: v=2.4 cv=S6eAAIsP c=1 sm=1 tr=0 ts=68a52ab6 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: Dea3pC6zM8kjPC_XC4lzLBfnHvB8fqai
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX/aw73JCN1yU4
 urGIUtVENnsMTQo7akOLwyRsmSVlPzo12T2RZW9vJMQWGTKaZTFE7jxOGBHrEEnfAqKRLiQ15Gk
 5xO4QiiPXho4Q9GUNRmFclocCcoq/1g+aDHSWEbTe9u4Hgg1asRo+WhYz6U0wVGw3Z4CecWVRnt
 GQFoFIqN725kD1m8Vud7goavQMy6+PdrbUQovI/DmTqkZJhcob9STBzLjYaUjLA2KTLAjBAYS5q
 N8m3oSvxM1yRJCa5tQgU1ZaUu+lRYELDSzV6dUqh3CoBAUBY/FwV54cK625+PV2FKAZM5nrrzud
 HFYhLXxiboDQ04dPq9B8SQIxAmf3/6eRYIzUEWfAR55c2WY8Bq0HvWDZ5mgg/sRVqbq5RzaIDQx
 0QJFe+92Q7AoFA2d4V1kNpqAG/0W7+FFhpB13affM6g7jSnNf3E=


> Comments should not have a leading plus sign.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
