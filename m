Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C972A1B8;
	Fri, 23 Aug 2024 01:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724375354; cv=fail; b=oAb4RfdeekKr6fId1/4C4Bp0TCeYIRg8JEmcyLYm4HoSxGtjrTqm42q8bFxZfchMG0roACHivjSIKb2QH6cXbjm8KcoG/3TvYt/osALvVTPfJJ5ZHwimtm1DrYfGHGjFBc9aR8MssJJMejynhUD3MjD4c6ZOhippzVqfn+YT3/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724375354; c=relaxed/simple;
	bh=YU7JaV5rDnzN1ECYf8I9b32BTl95HcZmbJ72ct0fSxc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=YKU5STrzzwVtf4mjkcELwL86Nbf3wh/kqpebTiZ+r4fqRlB7G/xG/zsuBXDWwBIOdPfuQEEnkzyeidHPPdOUVVuA2uXDufZy0vfvWMU82F4dFTEPS8N75tEewmRc1gezWVccr6xOk4WZAYv/Fa1kqoTkpsYb/QweLxgfaUfALBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OsAOxJeK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WJ8L+cJV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OsAOxJeK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WJ8L+cJV"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0BXSL014700;
	Fri, 23 Aug 2024 01:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=STQkhQ4Cua2TNy
	Sbanz8Ufmo8QOEEoCgK20aNzyRGv0=; b=OsAOxJeKaqPft9FAHfFxTzzPezM3KV
	8UZVyE2OGHsCUbkaW31drVy4sWLvCiMCQqgphaHXe6aneYCBs3T4c+OfovP32yDn
	oQlN8e34kk2ZlscCOfJu/yw4cnljF8D4cmfiWhosg3j1x1QV/Qqb84qbOAuoYnq0
	8Y6LcVFwcO11xcof57NS1vW43ngzVTjVOWqsUimtSGmHgu75oJOYdmc10IOfbZEh
	3YeVbIq7JFZLGg0mjIc1IMcnoMeFsOQeh1YTEWcRXKJMS3T19YxUk8Zgkmk0EdWT
	t2cCch5XBZF35Ea5wyCAZvo7yvitPOTzZOF7sCCiyYw54zsAHkg9QevA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m6gkbvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 01:09:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0Y9qC012036;
	Fri, 23 Aug 2024 01:09:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 416g0e8s0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 01:09:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Psm1LXPZzUsthQUz25zCS0VXuatMjoYwaihrcKZw0ZcwJTBpmtrbjAToy2rdDrJBZIydSHgKAF28uxuDaOki0+FAvCHLbnC8il5W9MVSxVRWdW0y7vuuveljg8eAsqOOWGxW6wmmrvj5WtD84Rffy/wKkF/3dsDzoCoHXaHJAZ8m01/9rTJDu8t9Q5UY4BeqppiQdH3RJk8APuLX5R0NvluCYnrdOrP+k/TO2V4lrbtpW1hZ9O9/GGr9sm0WwGpqY8b9QTYWqFuN7Aqose0+YX5KW0GovgsTeXY4brj0rdLibKMMiBC7s11LBNrk1urtlEWMMZRJTY6G5/kXc42H3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=STQkhQ4Cua2TNySbanz8Ufmo8QOEEoCgK20aNzyRGv0=;
 b=WowiNFMuEkB6awJ4msI35zmlsou1vDLQHshns+QcLav4lV+SThhZceF79/nYp08vMVrXnddp3zi78xC2TcQnLonxn4QVoPe43XkIGCcjGQyDFrc0aTl0iycgvjpreGASD3zkap9DOTJfl+uEkcdZtmdPEMXH06ydE19BQ4BhRWSAvwEipwnxHj+94cBCa2xxJPTXTQ4Q/QYjHOqhStbbepSPa9/yPGnpa5TvClsguDEaiaUvvH4bS8auueQjtGWnEog4i/ymW8DYugI5NNe2pYhvwOYeG/6xJkGA+JOewipFigZvRQ0C/1Y3KVlLQHAYU9alUP1938w/GCU9E9fU8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=STQkhQ4Cua2TNySbanz8Ufmo8QOEEoCgK20aNzyRGv0=;
 b=WJ8L+cJVCJ+BjovdB03Wrk0oEqEc4K7HPdLPg2+rz3o7h3stWeDkVBwumISRWxQKnnZhGBOhUh1BoBIQYzUk6PzPUT9geo7RDbcrqc6Ngv6N9VDGIfyEg7nUnMqLmDwXQFTQ+TtEQUP0XXngbm5nbexgd/vHxCYDMyH5AZiLohc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB7353.namprd10.prod.outlook.com (2603:10b6:610:12c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Fri, 23 Aug
 2024 01:09:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 01:09:01 +0000
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: James Smart <jsmart2021@gmail.com>,
        James Smart
 <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner
 <dwagner@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: libefc: potential use after free in
 efc_nport_vport_del()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <b666ab26-6581-4213-9a3d-32a9147f0399@stanley.mountain> (Dan
	Carpenter's message of "Thu, 15 Aug 2024 14:29:05 +0300")
Organization: Oracle Corporation
Message-ID: <yq1ttfckpul.fsf@ca-mkp.ca.oracle.com>
References: <b666ab26-6581-4213-9a3d-32a9147f0399@stanley.mountain>
Date: Thu, 22 Aug 2024 21:08:58 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB7353:EE_
X-MS-Office365-Filtering-Correlation-Id: fbd1bad1-27f6-408b-bac3-08dcc3102c75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SXFBDOT3P2BYQbsTAG7pH38sQDl3RV1+k3BPon4c9NEPMiDD+t21d11gsct5?=
 =?us-ascii?Q?qDfgty8ig4GrW6Lv5oUAEm83hWSLwucCiAIYuO023EUKOhhA6uQBr+HytsCP?=
 =?us-ascii?Q?nMAINnGmjwS0IbjvQTjKXSBpNmfS6VpDJebf15trWTM3d3DabgMYOdk31k1Q?=
 =?us-ascii?Q?vbBjSAPEihMdxtA1ZcVIpzNxIT9j3G6ewh0kVkzxse8WBIk61Yu+C1oP+LGa?=
 =?us-ascii?Q?f98ZttBQUbC4jqol2jMnL+hJZ63e3hwS/KbGRjS5lhRvBQFDxwdlgsx93t6E?=
 =?us-ascii?Q?ccvdp33UPfe35NFp6SkVnPrniu5Fd6m5vdCmWoPzwt4H0R2tgkrGN8tGtgxt?=
 =?us-ascii?Q?C8hrvhKmOBm2COv+d0KeY/mpdPjMJnvF6lEEsnhkOUfxetjQtYfp0ySdHx2K?=
 =?us-ascii?Q?Z7/9l6jptaml2p1AVQgzwXvKZBW+XKxfjyTdBcVO7DdiWrcD81VGHpf/pPuW?=
 =?us-ascii?Q?RHUAYS3DLJZ443X5MRb9oHf6TTQxwSf8hXMhTssx7MYWvw9hIrA77mUXfG8M?=
 =?us-ascii?Q?0HMdgSY8QwXeG7awgvBnaODA7CWfAr4B7JmaZpE+85t837L/UUQs67u7lsQt?=
 =?us-ascii?Q?5E1iQS5Vg8+DyIWVPMwUCVw15fPWuvgj71vexLTKcsrwHWDwwu6UP0lC+qji?=
 =?us-ascii?Q?kfuFAxnMXsHIljSHKOkRI/Ly8npfF6hszz8yQIEL8prrZ7KKg5U6Sp4cYX8N?=
 =?us-ascii?Q?GpCcYn0qT+1HnoyQ9aaMYuygox7nwepoTbd20uyemjEnvw6G77sS1VC2bymD?=
 =?us-ascii?Q?fnDh2tEHIhnMvWcZiI6JExaCw9qW16kfUJmzxBuuyI401YYmI+7D0sV3YWj7?=
 =?us-ascii?Q?Z5NpRowwmQzUsJwiwah/bTY8XRkFND0JQIUe3BK6XfXL8WgO5hUwrhlkA7ZO?=
 =?us-ascii?Q?y6GOX9mzzfGBhwV6hXlGTfE9Iiuv/eXgEeNcoEux/xxwjBCml2AP9+U4Nz52?=
 =?us-ascii?Q?N5BfV3e27Ikm5SWXfp8gzKqARs2FsAR+24c/YLeu5bsPzvwAw06n/5J825Jo?=
 =?us-ascii?Q?xPymVqNgxA0UMhN85AJpCkItEKUuRMVfvvgP4lYJqdpNwghYIj9ygzedOPzI?=
 =?us-ascii?Q?g1yljoXf8h1zW88WecaFmzA//Uv84cTDyfBF6Iw6rBUKdhQGID/DiincZmH6?=
 =?us-ascii?Q?UsUNiHTgf2USgKplpP/OWnP5Vow2yF/YKRQEjZO//to8PrbH6RIJlxw+kA4s?=
 =?us-ascii?Q?tj9oztUo0csC/zBR4mk1PfLdvk+7kf3SoLEki4GJqV6bQjipulofdOss/Mfp?=
 =?us-ascii?Q?dS0C8ETQRWpznylNV8KKYLpL/llQUtyVhV388j3nyYWNyWR4NvrnDe1C0Cdh?=
 =?us-ascii?Q?XGE/u5YUfJ4oX/VUCQdFS+61RFSbnruHDSZcg6zxHoa7dw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eKuyORJ5f4VLv3sB7S4UVew8xjA9J7w8tuP1BkA3GXbCXdJDXaKwLDKE3Xs/?=
 =?us-ascii?Q?40kJntSLHZWEjNhHydlHVNZ6+QOciJHTbcEcZ/ImfXhw7No2bwyh4qWEHjpE?=
 =?us-ascii?Q?XN3ZhNVIuuatz1pIj3CB84x8kzNCdvxKn4Sguv/uf/N1mxiyfxOGQH51YZE5?=
 =?us-ascii?Q?OMhNFOeqg6cBv9zw5G2cOH+xboS+PpNDg96qJUKMxfX3uhIhDs4WAPKBE7cR?=
 =?us-ascii?Q?ptbzsR9GySMUzRU3pCqCZmgzWXAsEhZbMDssjgMuxwfaVtEd19Nf1vHqLdv5?=
 =?us-ascii?Q?kf2axdFVYZg+4iHR6P0FPjYUsHZnr6aflRR8kdw0Ot7ie6wTXsN+m9Sq5AQP?=
 =?us-ascii?Q?9ibn0QBQaODTu8GNmj0Vdj6ot9ROpInlCWOdC6K+H5VM6yq0dclEsP/6OEoz?=
 =?us-ascii?Q?c7dMg6iEVPuP58iYqX5zi3U5Y0czyYAsJGdHzLe/l2BEx2m0w2Ogx5HEH5AN?=
 =?us-ascii?Q?vXTD+LJRcf4ojt0njGY17RDj0Kxvc3Dbo/J1ECpncurvGzWzEBjoT1yItkv/?=
 =?us-ascii?Q?czhio0YxGnyC08SiatkrY8DV6IY6sWT/lTx0ogtN3FXowxxr2MN1SoI3QL/Y?=
 =?us-ascii?Q?s2WiRiTbuqLQJEvuR6HSHCRKktKlPVl3dH1flouX7rkENnC0sl2h70SiMXJU?=
 =?us-ascii?Q?UIbXorcqekvKoz25axPfZuiyR6r2zutGD7ljCAAp7u7izeRJyGZIC3coMBqb?=
 =?us-ascii?Q?GAfjyIWhcWBtuy9Hk09p1DXJw0dYMjY+pnFVdfBv/sFclLVfA0bkRBngdhd+?=
 =?us-ascii?Q?vTFDBx2C239Hq2UH8PcZx4/MJ40+Qmyau+FaXXH+Qtdvn2fpYJuTm6Gq/sb5?=
 =?us-ascii?Q?d45qciWBI0vX+GNbhhSyUE3GWlzSwCpIJY7oGkEt1qZqsEJse9yCVnY8NWcf?=
 =?us-ascii?Q?+6yQ/Y2PuKwDzhOxmP8pDFz4tiTSgV3XgQI44YiNlcr35NhugUHTCz3sUPwf?=
 =?us-ascii?Q?OalZ7f4mElDn0nbGSWszcxPdDAI7J88fC4WVgg2YwMIkxcigj7DEX0KLQyLE?=
 =?us-ascii?Q?u5hrjwhVe64JNRFli85oa3BN5RwDnk6pbopjpdObjdXUaP2umaOjk2bQdWnP?=
 =?us-ascii?Q?Z5jnq4kpmE46z3aZcLzoee380MI8+agr/WKiywFFWOXFPTE26gGM+l7HfZ2l?=
 =?us-ascii?Q?um6RCGc9PaVg9B3KfrmoETa/Pqpom9ObJyeaSASZaopPyI8G1y/M8OnS+2T2?=
 =?us-ascii?Q?jzVD0cfzlhlBJnVXaGviKz4uPXserhxThRA4NUBCDKitJy6sNyXlTR/lUyvD?=
 =?us-ascii?Q?Jyjc38srCfbX1DkDCDcUHtFoi16shEUajaMtu7nJ1w97lo+FQIH7LKDLrlU+?=
 =?us-ascii?Q?btXi7fu3HAjPuliP694PRcLC6eIViDbvdiucyGCcnUfuFbDrkeGIGWbrLKqr?=
 =?us-ascii?Q?/nC4GnLOa92gSAATJkIREeiPfvRWIJBcQ5uOwo2YPsIAy3v1GQDK1BIPE3kV?=
 =?us-ascii?Q?NwuVs1NBwesqOThnx1UsUvZK9sapYy8dqh8tAwdnOwFWS4btaKzAbrE00pmF?=
 =?us-ascii?Q?tU2aHiDZC0kHxeQKPVcriHqCf9gQClQoR3a+57AyDRrRsfJ3/a3DjXJif4/4?=
 =?us-ascii?Q?yacI1km+0quAhb2hKh6OmhzMtCESQ0gzUwgIhhy/E9ScKbpGfSR8dbk3etta?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sh7t+fRirHMojh0roG/vGMoennLEWvR+4g9tgPHxRLgWZV8Uwdrh3/Vb4D8i/pj/Kxj1+HrSpa766HKCqxImcEn/Td6QNPuBnKGdH/o5l6yzvO0CqhvlppQdiIrF0MU26kgwskoN1v66aF8KiHY8hjKIjBvc1IQ11ZRSo4p5CD/0Aczvy2lqaB49gcZr3lEexzIG6J3pN5FmfmeF1sojHSuAZE+GBgn0qBcTOTIjZHcM2l9hTRO8jMctUIVH2RnBv9ycw0s9LzosXDPeRaIiqV9lQLVbu4bf35UqKgmYeBxpwoN37FV2bF8JzFXkMsgAmGyLgLCdUp9lbKFBg1+nQ16iwpKPujAssphQ5vtwkNF2cKmbkyPPC+q9g+bZIbOLdIMwwC3H0Y2ADnRrWwYgs227EGp2a0lq+rN4YdL3HiER1A23/X2NhIWHzdNEKIR+jblkKkzwwVNX2CHU9JOC2PT59jCQg7S9Sl/Ik75B7Yw4NjHLUnGAjy6LR/qttSrWn/Br2+8FyNDdkBvK1GHE4C5EkljLqxJchuWNaHGABYXUE8c/HaF8QUorZkWPpqVyuTSZKAgfcf5sc8ZNN3LEKuM51wuy8IQ7kqn4IIVzrvU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd1bad1-27f6-408b-bac3-08dcc3102c75
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 01:09:01.3586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: geP8MpISsyQamiYV1iTXRM8TJNxDlvvNnMqnFLeecu+jI5j4Ka/59Cn91rWpM6W+D8G4sNDkekmleEMw6nQhpm0wrwiiDD0e0YJ1w4jMn6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7353
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-22_17,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=578 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408230006
X-Proofpoint-ORIG-GUID: freGVDp6eQxDsc2ehjWz2IkQbouO6YRH
X-Proofpoint-GUID: freGVDp6eQxDsc2ehjWz2IkQbouO6YRH


Dan,

> The kref_put() function will call nport->release if the refcount drops
> to zero. The nport->release release function is _efc_nport_free()
> which frees "nport". But then we dereference "nport" on the next line
> which is a use after free. Re-order these lines to avoid the use after
> free.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
