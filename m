Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601DC182
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 02:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752027037; cv=fail; b=D8XGj28ytzATqYTMPCyIUDTYELC7xvUtEciOHcBpvzSp5Ijib2GWVqovZ80eYgh+efHIn2IslXVNNPy3e93tHF3kYmQZ0ZdHq2li8slz7aAGZLzFk3DP6nYcBvkfD3C5xf7tB8VymisqERxsqgNa66MznSJtLMJ2cLwpbSrFJ2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752027037; c=relaxed/simple;
	bh=hagm2Fd+4hcBfYs5c7mDeC+gnyIxZCB6/EYnMEU0LvQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ttaFJRbxTDSHUed2OdvKHRZKR2zCbjbk2Sy32/UHt16l4S56V0Nk4rnWsnurbW6Jw9ARZvH+xELXHV5djOXG/6HUm2QwPRDHLQRJd4X28bH3ZtfmtkbBwOnIVV5EYuPMQzadX6CS5d7F1eBWnCb4Zl5OyJt+4iT4pCucFZmq1gU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HXVunH7d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TRa3E6vS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HXVunH7d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TRa3E6vS"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56926uPh019875;
	Wed, 9 Jul 2025 02:10:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=bP5oF/c9GIqdls8AX5
	idVrJdSOORih9mIwhT3Tv5+BM=; b=HXVunH7dYQGqax7HLwNQRWPAsWScDfpCN7
	BWsEyE5mtzAKmAcqyfQ6PGpRnmVBei/VqARnxeRxVZ5P9h9lBWd9xmTkMZA72e0M
	VNfV98AVTlygAaO7kUpvL1TTSaaRDUTyVswtmYWdOl9E0KANGntYwMmv/fp+e8ld
	sc4res+F/s5lRD6z+/vzvV1mTp5rB5ltcqItWiAzH+KVG5t+2uDsXLfOwg/AVyQi
	zw9DLIJAKUSc/P1pyaI6Ma0uByKtGXCS5V639jV7qUNVidSQLMOLLTllgRSkjcEy
	xljV32VttbRLpyVOFqS60HCBlikMCxvuZzXZEBCtGR4eGOBt4ekQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47sfbp802y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 02:10:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 568Nt1i8021500;
	Wed, 9 Jul 2025 02:10:28 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2075.outbound.protection.outlook.com [40.107.96.75])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgabhac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 02:10:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ArDYcG6Q+OV9DDKhRBzBc9dSrvWwBT6hoUCXpGGneVbdP7lyFCoSgB3ha3/JSXpvuNxDOf+ErnnVO3fEVJZB+rAhySAVFIdjrLWXXTw1VGnnTmO4+3AVUVmKheh4ULhZGDbs7hNTfMG+/VpDqvEYt7vLeX00NnL2UDHSVZZzEWQFpMZyyu9hDLQUh4gVSdVZ5G0DFh9n93AAYRdX8msLb9FYw9wYorMqaLQGBRaCeaQndl98VQ+zgxYCwAVZumNjmyu5+V1AUv0N6a98nJTj66yf8niUcaUnbDeKg4lqFMcgdCluTBzZFx5djCkvwCHNv9mfoBwQ/S120jlCOP+SXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bP5oF/c9GIqdls8AX5idVrJdSOORih9mIwhT3Tv5+BM=;
 b=TE0pBoLZ84jIXBp6HS3tJqlAg25CARm5vVB/CfjszFogXH5Q2HJKowASLZkyXRuq0LUdA+WRU/c2rIicHsXyMmFYQIEFk3nHEYadbqNClejfXUuIYUVkWVbkCuEwwYhtx+IYC92X4+vyfPDrL58nJYT0PY1b1V3/H8pNgWaLpFKHCuw6JB69LOkLWgVUnB/ogoSoP1k8u4JGjdLBRBMuDYSK7Kqsrk3Tp92xTwQQNJwiEOqA94ZGmc4Os2wKMDt6qx8UcrME++B9WE6mo0H6IxkdJR338OccjIOAQWQ56vlV2ifBthRIAhytmEuZw6UgzgsIkk1F22isp/ZkX+WZ+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bP5oF/c9GIqdls8AX5idVrJdSOORih9mIwhT3Tv5+BM=;
 b=TRa3E6vSYPqPeZO0mHE7LScCYNZ+LGw3urK9gNJbbwygaOXBU6geiPU3ueUJWzGQe9eRi+iPCoJNFBCZUbPedI2hsc3jA1HMl23cu8f7tcLMOqdxKA+TKCB9LAsR8wGnTokuLkklkN1a8iTwp42Xp4eDzr2ChqjhmfH8NjN2Nm8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7977.namprd10.prod.outlook.com (2603:10b6:8:1a8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 02:10:26 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 02:10:26 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes
 Reinecke <hare@suse.de>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] scsi: core: Make scsi_cmd_to_rq() accept const
 arguments
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <302f9d94-bc03-463d-8150-d0e0166f3e36@oracle.com> (John Garry's
	message of "Fri, 27 Jun 2025 13:05:41 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ms9ecdxn.fsf@ca-mkp.ca.oracle.com>
References: <20250624210541.512910-1-bvanassche@acm.org>
	<20250624210541.512910-2-bvanassche@acm.org>
	<302ceae2-176e-4c89-8f44-aa2169ca2840@oracle.com>
	<c6b5d62b-e039-4e3b-80a0-6ddd19624c29@acm.org>
	<302f9d94-bc03-463d-8150-d0e0166f3e36@oracle.com>
Date: Tue, 08 Jul 2025 22:10:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0029.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::42) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7977:EE_
X-MS-Office365-Filtering-Correlation-Id: fe679183-0645-4661-d858-08ddbe8dc541
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KbYHj2fPkHsVUQdzRjsr0LCDn1TeOaU/m1PxSWs4skvynSw2/hh1L+B5sS1U?=
 =?us-ascii?Q?sba5mqAjzvROfEiors/z/g6iOzJr39Y5KHyYvfsJr6gODYHCN7IO5e84c9Ye?=
 =?us-ascii?Q?KXY95la6ByMWvwyEFII1e7JkG0PCE5XjhEIQrW9d9LmKWVR25BAaF0QrOBUH?=
 =?us-ascii?Q?DbE8iRehnlfpyfM2debFH+xs72ShPqtSPbJqhT1CDMsCT30waimzjLU/fSDt?=
 =?us-ascii?Q?p3Tz1a2QBcR0AK217SQSP3UV9sURpEuALkgtUNJ1/8zHvJjeI/mKYfdchpjW?=
 =?us-ascii?Q?v5ziKcdb3ppIV6obgIq1fMgp90cbrllddZUW6KDh3fU+0W4DGum8/cu3fqvH?=
 =?us-ascii?Q?sEJhrGK4l5ZM2hvdJtQ7R2xt5qTdyDOh7rHAF9mV1wQv3ryjlxZtjMB58CVP?=
 =?us-ascii?Q?ZsIlYx1c9mKhHO3Ek+BuHge2zqTw0GIuZim+56pbfA4hji0khscFCbGm1XHO?=
 =?us-ascii?Q?KfKS7AJTLRv3fzCwx63AuFoKNlLZofM6LJqyVIzBo4O9z0FL2IRtgtuABvVC?=
 =?us-ascii?Q?0c9MqZlhUj/0t/4p3d4KaX9Wthr+dxlSMLqtIxZ0L6c4OLD6vY3jPK1boW9J?=
 =?us-ascii?Q?YiGxrHCrXLziTOw+zbAxWIYg6v42AaeYg09mDbLoMHgOgosQcpxui82gouMd?=
 =?us-ascii?Q?CR5dBigxRVMIZ4DoeQzzYabNjP0rDIoQbChuvt77LYUu2L2TCshvLTR7ySSk?=
 =?us-ascii?Q?hDoBwxteQpqzsO92FsaG9o+yI2tIaIrDO4NsYCkWmCZ90XnkRWFkZxGVYvL1?=
 =?us-ascii?Q?4wgqugWYouhn6JT1xEtBl6NXjC42opxGUM9lKa1xP+SscJD893PJPk4yFO/g?=
 =?us-ascii?Q?5w9Xw/KFD0umUHTVGPmirxkQCfAR2Z1Znda70xHc3EtPIFpJU3imWROoHHSM?=
 =?us-ascii?Q?YMhmBeULds+IG9RhywcawUHkD7HrbBiCliHCee7ho6yy9jX1zNcPP1gvzue6?=
 =?us-ascii?Q?ki9YI+wpdAc6GR7Q6drAdleSMttILDNGmxnQAsoXX27GRMb50y6v6PO9dZVX?=
 =?us-ascii?Q?JS7RzjJwqHkjFxxvYwSGVMMRxFS2upCfLzpci4DUz+J+KoeRqWJbCTZk5ULI?=
 =?us-ascii?Q?qTSLIyFQKQ3QVbEISxunCGcUdr9OlPfL4QrnuD5XWx13AOOfzbSDr8mcsPPj?=
 =?us-ascii?Q?MZ1aX3l77TPyEcqrXaXpCLMZqjpHDAdKUdQB5ryyc9kck4rtk3GQtQD8tnP5?=
 =?us-ascii?Q?pUhBQExb2Sm/A7hD31CrBWygiNw1vy2BAE7+3J0OIgnx+v1CEyMOPy8sCdQB?=
 =?us-ascii?Q?FQiTqd0W4TwvGdju38EzG9os/gz5/NL83p+wshWF1QtdmPeXlmFQwbWtZpHw?=
 =?us-ascii?Q?ZobDVjZE7mJdJsCJo4PpIZgkEg6UZpAIt4ysf8FJtpSnx4ppcxgTv7mdlI+H?=
 =?us-ascii?Q?xUzhq4gcUkmRTu7ARwYgIMMcafE+NjJt9NOnmr+deazGCWzlZIclkPtsRMWv?=
 =?us-ascii?Q?+HwPxjuDUg0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CoBAuvML+SKfltKJQZWRTzb2K8xZHJsuZyvaE2KuiC9TGqXDfixQQ/2pkB5C?=
 =?us-ascii?Q?JRvU+FsWLCQDD4gi1X3d+BR8vLajy1S+stqQFqHu71EUcXmM3gmKDSDsPnzh?=
 =?us-ascii?Q?eDgctB1G7rExnltKXFkmkQZ8OUjO2SGnxFL/8RRxjPGIJSZgjPdCPo6aw24D?=
 =?us-ascii?Q?+kG3sy1lg0Qs1Lg3bIsNaBgVNkIGtg/yENI12YfV7agt6NrUBue+ICaA4OJX?=
 =?us-ascii?Q?C9658O+u6SFtp/oclmouy2wL2mX+FKRE1m8y9Ewq0OEtmfi6LStFtl17P6bo?=
 =?us-ascii?Q?9lIk3RX29xudlUA3/69YEccHd3RB2/CEbsqSyLvvI7Qg88al1d5YZTFmJEh1?=
 =?us-ascii?Q?/VIkOR8XdTkH9q3PeudxYVsU1/WWsupdJibujA/LYFsLYhM2mjDKw5e7A8hw?=
 =?us-ascii?Q?Uxiy748P1tJaTX2Yb8GQdXdb+OD9pxOvjm8y5ZjOF744IzB7D54bT8ljA475?=
 =?us-ascii?Q?qO9/9OL2OBA026SPzCoh7KINeXlmnyUTAaseodfRid3pf1uZ/BHUBKKmI8bK?=
 =?us-ascii?Q?Lo3wj9LzyRbuejbT/HC5V/CIOnjuh0fOSFLr3BnZmCjJmynWAlkWTkRnm4WF?=
 =?us-ascii?Q?9OqiFh42zBBpJdN4DU9CEhU5dCqLNshvql+XAttu6lmawuTSb12mI9Ah87DW?=
 =?us-ascii?Q?4DH9sJLZ48Y8fOzG/pI1hLKCEnlYDsPtuvmhVkJpZWS2LiRC21YHSLAVmYwz?=
 =?us-ascii?Q?Wwp8LqaO/6NbHWEDh+FBjPsX0fLobIs6fXNTY1walxu4wScZCjKq/Ej1KohZ?=
 =?us-ascii?Q?zmD4BEc8QO8WusEJutJYSwyJUJxWBI/waujz7lQ1YouT2EDquOiIwWFLPr3m?=
 =?us-ascii?Q?eJhGvXh0c8VcntOtAdLFXXTfPTMDZ6uYHpbNGLkdtOIyGmtN1y7mXMHukDom?=
 =?us-ascii?Q?SqcJ5HSwnCGjHc5dU6zvbWllNO63d9lkJ5VcifCBfM5FYYTzcuu8ClJn9AQ+?=
 =?us-ascii?Q?TO/NvmHoBYFAvMdPUvb5q2g3eHqr8fJIAYNj0MuGTzuhvsa/BKftPUWFm1YD?=
 =?us-ascii?Q?Xv0VcGiFFRGdPN63HgWFm5rlXjFzyNTVVFfIVrvRIlyc1g6UDNws4B+jDRY+?=
 =?us-ascii?Q?EYI7qY0Gxofu7uE91vNnyOnFa89ycw6qLncXPYA0ny4WMHVWQkHuQe8nuR9T?=
 =?us-ascii?Q?ys7jx8Xzk1D71wxsH1+XmhENeHFDt9lcrJHOITDfGcZ1u46gLkNqfExxJ0B7?=
 =?us-ascii?Q?uHbJHWsf3uHFaE7yKRQd5yy/67DSqaeQ4abmUE3ViW4VOcKs3efDEEEg/jjA?=
 =?us-ascii?Q?k+dInpi13z363zsUMZXSKDst28jgHWL0vfwwaPQ7opXrfVjguol/PidCL7L2?=
 =?us-ascii?Q?GVY4esceURKBOLu8ES2BK8LgNBJAY4PTskMtbfxA3VCJQ/jRdVZON51Y0Pdy?=
 =?us-ascii?Q?dpKMY8Am31weDl21Qzg+ZmJ/ngTE3ORu9fsjKOv0/3tIXWpCaYuxzy7L/Vp8?=
 =?us-ascii?Q?Lf2KR+4ic107Sh9gcWYOIfVj7dzycdnuLLF3JHQ5h65N/azbq0VtOu+2DwyO?=
 =?us-ascii?Q?t8tpUNCNQu4fzmcU564ojOA58SULhyoPf+BQea7IvjbYEztcW+IEIgpvWrtu?=
 =?us-ascii?Q?NOfM8pk0rJ0XDKJz9AhzcFCwYGumPg5McG8qp1WFq40SzFCkmKXr9+nH2Xv7?=
 =?us-ascii?Q?Ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U5y2kYNIdlVDTTJod/+I6rDlj8+mN2DzxuZOTDeUecp2N6ZR6ZMgrjOnwwVb1r1F5WBs9bhlUDjL+OwKsrTMacgc5kD9w7OSKiY6p5+4UJYiH1mmQJLi4dPMKrTUfpj0qKN3CY/0nhYa2g2dPD9JfFT2HediCxZs68ZwqF0nqDCjxWuvjC05oR1wrMJx8AJpHkLs8zPchbSGIY1fvbEcWuqJ6ms2ZiJgM0zFtev3Ma5afp3qRL1y4/MTz61cMjsgdrnhdtNw3PEbe7mcdI26c+5IMipFvHYUPRhZIwwBSm/J0+2JFADZa3r2SeWSnkWbeJO4NH8MR78SHPkqDXOqv8X5qS1mY1ur/Mgwx6/lcJpF+uWO47ptv45Z1TeEuQyUEXCxAarq8BMDVmWNzX8lYlodpTHs/bkZKn2F3lv7A/LkOJuDnvOIGkYeLvVX1bsOXJuyq9NBd8KoD4ROsNRvJGgwULIbVeLyRCvQjwrWtlFeLNXMLKJHEv2JTBx+31dO9PdmCZX0KOKWLQy6JL8KLfxfVXa5/5NQr0/TjqtM7Rgy5GFZpwxGmssb+pVl6NCVGNqH3v6OOQ2Qb61aT9YHA6oIvASGJz9InyihLKQ/6ag=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe679183-0645-4661-d858-08ddbe8dc541
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 02:10:26.6642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oQLTLpgBehI1vbQqYWkcBOmMllNuKRo0gTqTqAHwnfLLDjaxlChMRYGMBnWHHN/JTY0QFDq1HLV+LCTE6iE5zkUxDMQk3bWUrAgVIDvu8wI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_01,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=833 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDAxOCBTYWx0ZWRfX5xIVEpmoCNRx 6CPJl3/0ut4dOzXEdXVvTBEtmucOiodOIYyXjsEbEVuParH13t4jBMEDsXRIcUt7jrz/2oKnPsG uWT1AdpDzxJNUvzszuD2sLF1+RzflnsJidXCtgMpknBW4JJSpjyfAbxJds+ateUU9ek/T+EM1uk
 9oLnwIoK+O53cLgNUTrP2QY0dvkazJcubZn8/70hlRHjbeDRXN2yw/fVLMcCsG3v9HYyXrJR4mZ vTq7TVvvyI7KTpxkk04d3wa52oxMYsI3oEU9setfZR/qzChcBgbZdFRODW6TkTS+1UiVZQPLc0j AgbOSdF1+VHygRLiZENuxH7ptycWTF5VdZE0WmcdW8Ttc5zyeVnnFxg8Bl3AuAHDubA7qLaSRqm
 gc6+HZFFO/DVhgs4P7YUcnSElgO4a+f0JtmuKRsRmCRPxckdzYEqAcgPIBYl8sd93cMrYIdX
X-Authority-Analysis: v=2.4 cv=AMKwVr6n c=1 sm=1 tr=0 ts=686dcf95 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=h6b8SllTYfoiK1yJQhoA:9
X-Proofpoint-ORIG-GUID: ZtkDuYcCRCEkKqzquKmxRgw_4qKC0Dtj
X-Proofpoint-GUID: ZtkDuYcCRCEkKqzquKmxRgw_4qKC0Dtj


John,

> I don't have a strong feeling on this change either way, but I'd be
> more inclined to get rid of the const usage in the logging code.

I agree. Don't really see the benefit.

-- 
Martin K. Petersen
