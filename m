Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423F923A8
	for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2024 00:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723510339; cv=fail; b=itStIK2M7SOHwE9TmI9qc9+i113uSvrv8icjbYniI+ITpKlpqX62BTkF8ftbTHgaEjvMeSTR3ytBsJDweDGGnJz7aVoDLE0+XuihsUWjQghDUmwEnztrIUnmD91Nn6Uxx0WFchjd+QcERsHzrl8AQxgnp1Ntzi1ePc3Z4x9U3Ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723510339; c=relaxed/simple;
	bh=lcYtueP9IYjvKUGqbnJczwH6CIPik5eLLJqIxcSUepU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=AoOhqu99Rpp59px+9KUgiA0mdw1UMyuYwJpQFKEPv2FRe7brvkHdVxK1ojbfv4yP/27e/fjEbcqI3rBNd99gnnCa57PdE/2tvizo6Z/IU2sN/RvCGP9E60nTStQ3bkBu0zbp6b1Fa9ZTzjxS/tAreEfnhPJxqx328C1vlhhzouE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RvoCeMjw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eAFaqroE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RvoCeMjw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eAFaqroE"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7JH9030907;
	Tue, 13 Aug 2024 00:52:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=2zCGSfWXJxwxF4
	z3hV9Srayohid9qO+Wj3kHKRdVhEM=; b=RvoCeMjw2mNQ09qkLjttdQACE/c/sc
	RXgN7gPebLUMEu41W58KZIJ4J3mKWu8c8N5hlE8B+Ji0cxtNFDh5NZyDPyRURiKZ
	WMcmOpssAhMD1nN1YjJlQF7rn1d+4yWAGZpRwu0CRiZyn/5faR2euZiVsFEDWaEz
	oxHPdJbgkGDSNJi3s/dQzIhZ0wATrv5YlYDBJ+vhUmy1IZvtcIa0hkIInaHduRuF
	EOVhm2lC+0bRvSkeRjHUI8N1dy+g7P9mRoWc2wPI0QtauzBg09MK5tGakQQ9T52B
	SZj09jo+E5d9wMdNozzqkMi2l8PW0w3qG5x+/vA9YmzDwgAMnngczj/g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wxmcvrrr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 00:52:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CNZduW021781;
	Tue, 13 Aug 2024 00:52:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxnecnd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 00:52:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bTAp4u57inyGN3QNBWQJhQSYD2aFv9BYSxQQf3rLh0m+ugQOWn4g5GSbNFXE0E2XKiZ6GUu1D9i4n6053LT8WIj6Dol6PDDnklsVUT5uywbcpbHnD2u3Z3kWsy7dSDNhQwL9gbyN8Q37EFFNkkH31SXl/2L75O66pwp4okwvs23xAidI+uM4DKDekQGtwoCYhfyUtrB1zkQg7kItDw7c46+7xzTDINPtmgjtlMxVaPoHDl/kLIQYXbdhimvxwFXQYXohbDD0KSEZSkExShFCpv9FjD2jWYpgkzyJrNggohwKwZvNX4RdRMRaa2hvd3YBLHZoGjAolDAogDOilwO5rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zCGSfWXJxwxF4z3hV9Srayohid9qO+Wj3kHKRdVhEM=;
 b=wXoC3nRhDcgvoRrztrUhIQFbw5ZRbRifygJqNPH0EouMA3dyC87LxWPsOBKjRc84yTMxkYFjNcekZyCGg//vzmt/kvLe89kebp9EjTbzO3dJWSpmIf/bLbuiROWDf836FhX34JPSYox5IdUiKftqXJNfGmL9AWoNs/2GnKO0cD3PvSXl9zRzP4Ehasg3rzkfBC4tKNiqVplnwXtwwuxR7FZ3bnhppB0awgdLoXoJ0rqDApvQucXzjH3gdPZaGlUNIQnujyg8Pn9vCwmghcCgVzrh61+WU7+AAb4YfAzv0OS2XzXyWbtuyqWXgu7AXZOdh7eJOAa7KnxYLs10bl4Wcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zCGSfWXJxwxF4z3hV9Srayohid9qO+Wj3kHKRdVhEM=;
 b=eAFaqroE+Cn+D1/U7vhwjYLh8v2rUdDP/bNuRPGHxEuS9RnXENoj+AiRTLhCKS+N5fQxlAwm7rLujJN9Sxht2v8WTyygSiLHVB5DxR2szAsqE/BnSp5pobFyDjD38VQC51V0y0C98uE4ViVoMEWzqkzb5AJRXAKdbP4owc+lbeI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4382.namprd10.prod.outlook.com (2603:10b6:208:1d7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.13; Tue, 13 Aug
 2024 00:52:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 00:52:11 +0000
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sathya Prakash Veerichetty
 <sathya.prakash@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: mpi3mr: Avoid MAX_PARE_ORDER WARNING for
 buffer allocations
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <uizpmw3e6qigb46xoel6a3xuelfzex3xt5rpk5fqgdzbsrrchl@wjdx6c7mlnj2>
	(Shinichiro Kawasaki's message of "Tue, 13 Aug 2024 00:23:20 +0000")
Organization: Oracle Corporation
Message-ID: <yq1mslhxn15.fsf@ca-mkp.ca.oracle.com>
References: <20240810042701.661841-1-shinichiro.kawasaki@wdc.com>
	<20240810042701.661841-3-shinichiro.kawasaki@wdc.com>
	<uizpmw3e6qigb46xoel6a3xuelfzex3xt5rpk5fqgdzbsrrchl@wjdx6c7mlnj2>
Date: Mon, 12 Aug 2024 20:52:09 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0084.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN2PR10MB4382:EE_
X-MS-Office365-Filtering-Correlation-Id: ad43daf9-5f1e-47aa-7fe4-08dcbb322a5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/b7A6Ge8FpV/866opp799thU13Ollyswhy6a4aFB/4TXH2nCbmXpqrHo2ouL?=
 =?us-ascii?Q?gTQ//fMFKU0ocZx/8Mrku+hZrboBBxnZujIH5R0yeh8rhsroM7hNCrrAPuag?=
 =?us-ascii?Q?aLkukDjJ4iJ6s728ccUnaRO1oiowc5GIM55nf8ydXFZ9WJKTnUSikBafDqag?=
 =?us-ascii?Q?WxlDeDrZTpavrCTbo64H34IeR1GsxPclqlX33R+l+nqfnUsKyLgf6nD0gPVv?=
 =?us-ascii?Q?DK206tscw/PAvzd+QAXjI3LtpllbjvNiKfF1dtLaUMulSCwoQwMnzCIE8nTQ?=
 =?us-ascii?Q?lMnFCJoIhHtZScpl1LfFV+q69KoaHrX1qpkJ94ap/F+l/V3KHl9Gl+TalKB6?=
 =?us-ascii?Q?oNA66QUGMr6LK2oqTkE1XkpCmoLSgsMemxyGd0/kd0jBMWmWSlSaPiNG33hQ?=
 =?us-ascii?Q?kwvJmbd6urfJeekZu2E75EcwpDcVE/QsQtYZTdMhpRJbURgDzJMKyIz7LZ5J?=
 =?us-ascii?Q?xCBnGyRLCvt69YmTM2i/e8KSVd3citfxHyoZt2CErsEZPHcrh7LrBRgM+4rN?=
 =?us-ascii?Q?/YSAKXweq/Ykx2WaNTXAgFgsw9LzSRm3Oxn2FT8V52SLWuiAIbf+pnvHk1Zw?=
 =?us-ascii?Q?54DdhGVkkpmz7dByuvlW3OBgtDlD9ZWsY7/EQk18E6LNM0xNT7fRCW72om8W?=
 =?us-ascii?Q?VOMzIOW7kH4nYp5jIS/GDpX4t9fcpIiuQkjYDvU+rw0zmDrkMkm6nkVKbFwv?=
 =?us-ascii?Q?aBUYkV7DLe/u6q7LBJI5TFXonScmh73NoKdd6oI3EQSxWwDy4ptmEgdiraJk?=
 =?us-ascii?Q?hFb1ujH7eS4Z2KjeWmXSmjrl2dmuhtZRxRnDNjscAVV3leu8kqAvKyFyRGvQ?=
 =?us-ascii?Q?HXni+NI8pIvXXglu3Rq5vy88M5gQwtjeEgXGGi8YdjPhvyaTffxulyxPLyNa?=
 =?us-ascii?Q?U+rL1eEMHW8DB62kUhi9jktZDWDonOZZ7R9vG8KY/o4FLkfc1m1FQ0R5B04x?=
 =?us-ascii?Q?fBgtTH+Zgdo23dkgDAak88A4lvvk07nHQoVrfc2MGA304ox2KgVXF7sLzYJX?=
 =?us-ascii?Q?sEOH0krA2inv7CYTTdeoTZHa+XhZIbfJ3Iqo1AbqXXm9u1MGxw97IzVYZFfk?=
 =?us-ascii?Q?VPGRDi1gEfDnJw3FN4coPX8aC3XrMNSGwz8FeMIZAckwfQOmjlrMxcnWKNrB?=
 =?us-ascii?Q?DKZ9Ex/3o16+OVTrkeOJ6+MnzwdFcLIoZjjv0MtjGOvcCWJwtq+LB0F9sxX0?=
 =?us-ascii?Q?/bRfOzn8wTCj1D/6a+RCff8BW3tlKrukXKRWV4XX6/RtZkg3Zxc/1iTSzvyY?=
 =?us-ascii?Q?3Cy4uzFTTpDl9X+RBdGgGVCYvcRoGOTxjg/6L5y1lztU/ZhQhl1ISiuHxyQA?=
 =?us-ascii?Q?Elj7/xYFPaWjO4a+f/uzTFuc1Mb57vnfcuBJ/gjfIa2H7A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qFPQu3gS1rQuKVfCcYfpCOrVi7GfiNQtdmXDwnNRzIBpiXBXcVPKVR4k+wfQ?=
 =?us-ascii?Q?qUoD/tNEIUJtWWmQXGFsHR9UR03jn+a5gEmQloHSserVpYSh8g3Wzo18TiCr?=
 =?us-ascii?Q?8SHzJ8IHjHD3sVaIKI1WHdT7vBFRQvx4uqeNVj+MGmuWoxkvmwMlEW6Walem?=
 =?us-ascii?Q?RzpxyuLLnUB6Oz39LKnLeVsFGsR3hO1HKbVLP47suZiJ7DCLXQyeP35az5WR?=
 =?us-ascii?Q?UzpTA7UDEJDDrtTRE4pjVZGKYag3yl44Jjq07JPBHRNVQVuMlBcviK/C7ZNr?=
 =?us-ascii?Q?VGHZiVfWNuiQI2azWA0jy99ZI5RgPaWosOKjv2DAR/CHsq2XhJ6hc6XPQdN0?=
 =?us-ascii?Q?sFwWFz4ZH0vVczs353lw/biZ8igWKrxnag1G+jOiY9e2BGOiiQp3Lmnqz5ed?=
 =?us-ascii?Q?STDh5qyQzgsosQq4offaXqulGoHW7FX3SMeR62dAjEbT3wdiTFeImYyUnCx3?=
 =?us-ascii?Q?O3cMW35+Su2eGaZJcJ8rxSyPZrayelFz0v4JaFpZtSNCdHdMrKQ9AbvpaWh+?=
 =?us-ascii?Q?H6/djObouaKUdI2sm+JkNaH7QqVyyAlFv/9hMj+FPlv9Ft8FRmRRrHcEsLEx?=
 =?us-ascii?Q?h+NE09NUx5FQC1QhbvVJak5OPs4tln1nvQGI1IPF3HxNQJ3ybxpUHJy03xEd?=
 =?us-ascii?Q?ku6qwNWAoxEBdlc8+L1JOZM76pyTcgkgZ1CHGrJuqFaYMS7eRVcljUcdsge6?=
 =?us-ascii?Q?ACWfAXTuvC2Rg2s5vQ9Gggc1sQ/H1Wmt8XUZURePIxCFvzMlMNb08xxvdP4x?=
 =?us-ascii?Q?ZcP24r2/07suHFiRSjDdV9zyL9rT4Algz0IEWRnERty5tnAWJQq+TYeXBhax?=
 =?us-ascii?Q?MMuhL4MDrcOmJdRrKTQjiTcyYvnPRVn/wCAVgHH9u4IWEysntXRE6V1mREOe?=
 =?us-ascii?Q?6HLlid2PDX/8hS2AZh056bxeXUo6MayxdBxZy4n3ORdX+VsTHbHzmIBk7Idp?=
 =?us-ascii?Q?4soJ4+affKCOf3szuJZ0d3a4d4ux9m80Dr8GFJcO1ZwFYZqKYFQdCDX3SN/A?=
 =?us-ascii?Q?PbZ2KgEDrzyHZqmfe/L7S+di/xKWqDwWAutPrQjlQx0g+60jeAVtFwp9PqaG?=
 =?us-ascii?Q?gU+tgdk+OWUoReZshZZQFU5zAselvWaoycxm64wriiRuAn9tCcwFSnWLs827?=
 =?us-ascii?Q?dNwajA0cxdb5x6SmDFWwp8FeXCJwwMxj/d0/JENS5YP3jXXO5Uc+jfb/7BzV?=
 =?us-ascii?Q?EIZFdNu1GXPjMTdvUyGPnd27BhXaTbgpIzFfCCWWPEHWESBYh8aLrtqSeGUO?=
 =?us-ascii?Q?KyU4o0WuL5K+IWaIftjYgu2c1px0OUS/uQ7bmZVEwdVuQVBFrG6VNOJqYjjU?=
 =?us-ascii?Q?m6e9EhwV2BY5NzEYolpQNruNx0rU7Y4v2fSNv5lKs3GzO77D2orUOjxomdb3?=
 =?us-ascii?Q?4VdxFCGDwTwQOeTYR6p7ic0McMKMivEhVHuS0PcU+MLUJ8xNr2FEFkGDhcm+?=
 =?us-ascii?Q?+oslpQ9Wk2lYZLoedUOynUqSQRzO1VRqDLfmZqYNgNJRGMTqZ5pFX7KAkXVs?=
 =?us-ascii?Q?r6HNgywq3XTnBNtMuEhCXWUC3wR+n5i/0DZrUV/sjwfP6OyUNInDQPlkDp1H?=
 =?us-ascii?Q?tV40FbGyqzsiQA5KcPILBJm6f+ObWebKaP58/Ph9LnUmS6bAbiRMSTjDXNR2?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ubA61RNkQj1zRhetp530NALJVquZk1WFh3jhO77RzSLdLeCm35Nzg0gKmzE0jwYPk99Qmw5m+G9E/zCSOXoRA2HNQ58V0FMJ7wYqoJkfgmXj8LkPDtY8H5RO3VYxly6ST1hdfSh1yqrJPjRpZFz3Wj/Mmw4AuuUzWaUnPjT89bZlcIi/R4KNBZvvMDVWFOjE9iJGpZDliPVeqp3Gfd98pCyn2dFyxMeLRSBLeQ3dG44WG9p6Re6hZVzyvw+9yXwm/ZzuqTXQybHELPPcDkF2FjHM22gx8+RSkM3XG2b2FBA5vdKh5Ln5bO0dE4PRAC4Tnv3GZ4qucy5Kup9aJl6iTmn4QS7GxNS3lecxBYbqBdaHImkOuxtZWXey0Ms+n/OdMYSdDKqN1IZobnF7OFH98c64JwRArrxhNIcNTdZMFoGcRCPUl87TiRP7oFtpXIZAGkpwuzysQ1MFg6S3mLlWpzKAGrd2PlAStuir5TAm4qm+Q4havbBscYUSLVoDcnVYTYhZq7QRXSgzxZquywsnJm4YZXW08i9Kruj8GVB6pr2AzGyYkGMdWOEglVQZkebtMYaG+dQrDFHwSByNq57c8nhpZX5qlhWAbMis2fQqzmc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad43daf9-5f1e-47aa-7fe4-08dcbb322a5f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 00:52:11.4460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 75oOBMAkmdZGcsFm2dCdx2xq0WxfC05rd/NmeFdtdVNe4fpm6DvMfmYZCEUo7coAYiyfLdVTY2oj45QFUqI8+EL1HrllEnj+sk4luGgtYd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4382
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=757
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408130003
X-Proofpoint-ORIG-GUID: aooIx_GqjD20Iggxkzny4SfqhoA8tKqh
X-Proofpoint-GUID: aooIx_GqjD20Iggxkzny4SfqhoA8tKqh


Shinichiro,

>   s/MAX_PARE_ORDER/MAX_PAGE_ORDER/

I fixed it up, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
