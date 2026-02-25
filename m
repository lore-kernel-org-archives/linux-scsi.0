Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4042879CD
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 03:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991371; cv=fail; b=Qnfw/JKjoWctogC5MOYWlxuiXvmQHHtKiwunOHKXA31nlUOchb8wjXvSjCFSc/8JSIjkCyB2nYT0rh8QLj9//z9R2aByI/pU0BQSyS2TcYM66GaPUtl4ejEb8guvY42oi8A5ayOpsiozGx5kqFBG5zBgbbT/+91xy3VsytTW6F4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991371; c=relaxed/simple;
	bh=UPc4YcRravlrzByKHvrWAtW06BtzD7q6xzE25dNh3mk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=n8EYyJxlPfsWZiTGcSFMmk3X7nWuTTXDJrjOPSbzILo89oe+T8TVk+Vv9Cnmuu7Nlpdi6STqaKhCdjRmruOWHf0mf01DltOKK8vBz8LUI4ymJx9V9UJngZZV3Qm4bIfmo+dNtTwK2BuOAXhwU087oTdDXR1u9sGVXtTFJlg7Im8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gczFDsuy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eVJOysYq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gczFDsuy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eVJOysYq"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OIu6kK4019509;
	Wed, 25 Feb 2026 03:49:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gNMwQDGUkvNmt2Q7iJ
	/cHbo+EteD1OPg5HSZHXZSa1Q=; b=gczFDsuy1mAPGvHiveNHcfFt++Mg9f/t0a
	EwR95dX+jMBgd4oQ/ECViLl7wqCv798d7klfcxSqopZaJmJiFIHas8r+ZBKk0+i/
	UIXz0nOKEPx4p/6RFVuQXN98lIdIwo5F9ga8oJ/P8A0ML5PIWBO38jsfSfrc/T7Z
	r1271kgpV2BnJcw/psjv7tQhDaIJAFskj3IAyoAcnY54IFrGp1KC1E62UVW3V9e8
	bxGPfIg74BUz9eA3lq3ECGXvJ1C0xoXDmx6z3YuLIVs7Kt03KJeQ6zAYFrq7rs9o
	ICXf4BnKR4kFhZmQJUoSOHtOuK6kfxxUqkapGPIXbWmDQ5V3I70g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3a05gp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 03:49:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61P1FvTB028471;
	Wed, 25 Feb 2026 03:49:15 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010052.outbound.protection.outlook.com [52.101.61.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35aj6pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 03:49:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oPTmgpWd4WCN7vFwHEV42xQwujzun84Onppr5IYMdUPteeR5vbHIRfAzxVwtXW7G03iVU2ImYpAjNnuxvq87wYY3NUn4I/KtQ2Vgp+NxMxBjO3nk0l8GOGLA3SUrD2BDYaVAWyDw8YA2d0VbmCghzKyu13UZZJYY96j80RUoV72a45CtUeIvxVEkfAWX5WR8cMvn5HzKmL6R357bWuDdv5T2cLP7KJbIJS02w2U3vDjWQLVBDVJVDv/Qk5O/OVlyDp4PtAOQoQuLKPoS+64NFMpF9RTz2Ss5gGQYbeqfldSm4rMxfocxMCWIZ2W5vIoIsp11+xbxY5waPoThpykaRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNMwQDGUkvNmt2Q7iJ/cHbo+EteD1OPg5HSZHXZSa1Q=;
 b=RbqH5EFgu1+1c7HV8UwdWKEKEFj+3NOoyUeArnQbx7Ku2fqfXwtIOIXwrjd1xfoRucsW8sx1rqIcLvVdk+hGLDBL61sFFakuIh/4PiOrHAx1FWwu9YaKsCG5Rp/DrwWUx3+Tq/Gr1qcCAgZttqBdLo9tjBv52mCkPxXOHkKqtiYnqdAICDS70VKESFmfrJB0elOa6imzTmqyWjG9RHfGHfHcUBRxYXAjQG7C/q8r8pkHpagam7WcRyeGpkTvE8fB2E2CQwbaJAm4Cj74MzgADtsH+GYSBQdpoi4hhR1tk25sJXyf6MmvROM0YWejlXoG0oId3MZ+1ati4a0AFS8Nvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNMwQDGUkvNmt2Q7iJ/cHbo+EteD1OPg5HSZHXZSa1Q=;
 b=eVJOysYqGFM55YGqWUXkDg2sSqEzRYZm4FnsLcpz9ofpwt8cu18C3uteR8RZeNkYbLhLnCtQ+5tt/JXajoKnmDri24DTyJVNOrcQGtfuGB7ITP4H0PTmU7gdbyGHJv7hrTHCb3lXLh9Yc7sKZ0eZ4KFKEFvS/vFvPTCr2qjOIJc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW4PR10MB6486.namprd10.prod.outlook.com (2603:10b6:303:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.20; Wed, 25 Feb
 2026 03:49:11 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 03:49:11 +0000
To: Martin Wilck <mwilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Paul Evans <pevans@redhat.com>,
        =?utf-8?B?VG9tw6HFoSBCxb5hdGVr?= <tbzatek@redhat.com>,
        Hannes Reinecke
 <hare@suse.de>, Lee Duncan
 <lduncan@suse.com>,
        Martin Wilck <martin.wilck@suse.com>,
        Bart Van
 Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Chris
 Hofstaedtler <ze1ha@debian.org>,
        Xose Vazquez Perez
 <xose.vazquez@gmail.com>,
        Daniel Horak <dhorak@redhat.com>
Subject: Re: linux-scsi project on GitHub & SCSI user space utilities
 maintenance
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <e99744196d8a0ca2bffec1d13109eea071c99096.camel@suse.com> (Martin
	Wilck's message of "Fri, 20 Feb 2026 16:01:50 +0100")
Organization: Oracle Corporation
Message-ID: <yq1pl5t5wlf.fsf@ca-mkp.ca.oracle.com>
References: <e99744196d8a0ca2bffec1d13109eea071c99096.camel@suse.com>
Date: Tue, 24 Feb 2026 22:49:08 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0115.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::8) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW4PR10MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cf1e333-9136-423d-7047-08de7420d5ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZqXEThVR5wfvnmPZceYcQ0+vO4lDtN4EYMJtUBTRBJnJlrq58KK5BjlDRt/z?=
 =?us-ascii?Q?SGp/ippYRQ8tXDFZqBphGERTwYaTEAnRbELh9bBBVhS6dZTmXm5ZPV3SAd4a?=
 =?us-ascii?Q?8yzZmBO51MjQrWea4BvJz7UzvGDTdk2GFgs9RB0SlsaUdgnEphxsIKFKBZXo?=
 =?us-ascii?Q?5+a4vUzd1/L4FW0ayvTtUancD/kTU1tZeg+m4u3QdPr2fEiyWWXXCOePOPKp?=
 =?us-ascii?Q?yFm2Pq3DMzbbSdoSefqA32lSzJTfZ1iPHpQWsLkXHpFMURiHb8ireLPI81jA?=
 =?us-ascii?Q?HWp2D+W+CjDraaCj88A0us0b4iw+zCE8rxDQyZogMbP5jYffRMaOkAeKaEI1?=
 =?us-ascii?Q?rN0JdkQk1Vf1Ys+nbvlj8hlnadbDaxXgpLe5DcPfVZOQClA+tIkuV01iI26Q?=
 =?us-ascii?Q?ftbK3ppDbkfD0N3QhWh2SaRmzmoh3xjwE7rxAuSBlpWGKczYeaJI05oYuLDU?=
 =?us-ascii?Q?2GDWkITh1vP8n9qBXsFqH8YE+EvKEo1FPb/+rz0ob8qdAIh79R8546sKxde9?=
 =?us-ascii?Q?yqblDLwVqfRTFjuQvkf7J4sWcoSAleSE8pAGeSO0S4cMh6J+ey2uquIHwSK0?=
 =?us-ascii?Q?xL+MSIl7waW+h6DVC6xszWDrGgYbgoQnVaVu2EPO5tkq49hjQT26tX8D5eGn?=
 =?us-ascii?Q?rqCKiNhUkQAzQXJ8OJMeChp7zIoHyhK13nkNlNq8xXQiQwF5pKwuDWCXrFpy?=
 =?us-ascii?Q?ZoadoQdGW572BDdM9kYQfsiQMRs9cSwqKaTRn8DSH1OyauI0UYkIbdjcf5vp?=
 =?us-ascii?Q?fBnOxoMlKrOA6xeDmHQwvwKMepSJMr0ncDhaOcYTscHsfDjPmLugc2lb7O8u?=
 =?us-ascii?Q?bmyKpe066RHu50Z4zdx4gfPXXrSCwWcSHhdFEF5pMHmTFewVMatACX5RTN+j?=
 =?us-ascii?Q?/F3l0TpBC2GXAZFrPD/mn7iELFP4WHprtUI3Z2XYCfqrcapLpFmQnZF5/eVP?=
 =?us-ascii?Q?OgK6EB7lUoTYDyEOTQcIWjjpkxUPTR2acMuxXu3Ut4GrVDw1DOzaRSWa5m7i?=
 =?us-ascii?Q?I4vSl1ortS11oqvuYmos6weEKFyNSByrxL19VLIAQl3fWlpLrg8BJydrZFa7?=
 =?us-ascii?Q?FzK0uH5vxi8gv88XIuf5VPvWlaE7o8bVv59bks5+ZCdq3UjzZTJgUNO9INpO?=
 =?us-ascii?Q?iFpy4kdOKr5V7Wbyw0rfTzODmnrMiZmh3dA1dp8ZJT259oMQ09S9CrnL+YnJ?=
 =?us-ascii?Q?M49ZVwUX9ancVxiM8gT3V54vz5ZBF9dVX7N2dQerIy6XhV8MOaETESMfZ8wp?=
 =?us-ascii?Q?r2v3C1dysQvhMp6Jy/Sbclx8V2o3jBAoXG8onnqEcqqxSct93IBY+NGyEV9I?=
 =?us-ascii?Q?mcw7iPEjdmuTqapVFwP2Zf6Cyib5nKW9HkQLWcIOSdCeeAOkztalJhrw2whQ?=
 =?us-ascii?Q?eQIjBi5av4unFaQuBvHQctlF1vPY5t+RiVUDYsdORE/1c9ehcpzzexWj23wM?=
 =?us-ascii?Q?AfD2DvsBmZ0QjBxXR093fee+h9y6usBjvHGAa4cJvgf/cOArNR2kAU+Srfkp?=
 =?us-ascii?Q?9lXbM2mKyStBliUgSMOg4VWRwq7zl03sl8Wru+5CoHVkAXAmcBtDzvmoLuSP?=
 =?us-ascii?Q?CbIwT1U5IN/Hfo/DILQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fmnzKItecToik6Xi0Ea+hYJtJJ+PqrFPlStcSfxrTlja0J7Q9ttqDgpZhZwt?=
 =?us-ascii?Q?uCTfPwoCj612SQp01+Wiq23J9xDdzJ/D2RcRsTRkxG1ktV7adVkmVeyxZlgS?=
 =?us-ascii?Q?kagQ85I1IPG5oDB+AgGYu1H2KBAJ8r86zmpLtnl8E28hPWxeZ1ZltjqsHVjh?=
 =?us-ascii?Q?1BpVy35nYyOWvDE8g9tU8mrcjqFOU2RXZLc+HaRWdn4vtXhNiUyn2eb9ASO/?=
 =?us-ascii?Q?bqCkQrsStj7mZfbuFLmnbTv7PHycLHKtO1oDx7yWRJYAAmZsYY4KHeA2FCGE?=
 =?us-ascii?Q?b+BQ5ovuEpqvCWY7VBpHxlF4ICqVP6gm5Np/MbthdIE8clny3bq18O2v4xj9?=
 =?us-ascii?Q?flvyqKxPjvFfT/42FPBRfXpQS3UQoX4Hn5swnkt3iD8qaYhnS+WWfSqDrb5T?=
 =?us-ascii?Q?wbvOSJyY9RzFkr5nIL7Z/om6HEBxB/uVFCRAsnjLM2e7N30wfKscPhMDyeHO?=
 =?us-ascii?Q?Y6e9Lrkr83X7k9+4P2AxZI3e4uprEdsgC878OHW99EANkEvs3g4euP0pnjel?=
 =?us-ascii?Q?ntW1OJSimdGSyHTJpJn3f5ojoyEkopp0ayuJPS1kJDQCRcYxXoqQW1g9mmES?=
 =?us-ascii?Q?MHzft5F7hwVMVTgxVoupeMphqP8Jm6sca8yjtmAvqmxtCQqmMKg4V87TJdjb?=
 =?us-ascii?Q?H1M1MBz77RgI3zCjCdQSqDpJIaTQTFj2VAUgilK7CmPugGhT5L/3DK9P0afC?=
 =?us-ascii?Q?XkPYafb9v8orVEEqcRDLDwYBtEmEIkkAI6ayMizvqEur6AG55Nq0eXgwPka4?=
 =?us-ascii?Q?F28L4Fvl7Oh73vCb2u+87SNwyb8tIKUrbiQIMrvv+AWuLOoAl3IZTpHDcR3L?=
 =?us-ascii?Q?GpRnFjpGrMVvuRj5I6NZzHkfIMwOstNmGEtT0oPplqtuurBk1npp/eVSCaki?=
 =?us-ascii?Q?SZTGgGmLwGmwgMufH8qTyZny27Y9MMZlwv9jP6RtZdWR/+wYGCst1vEHe4VI?=
 =?us-ascii?Q?73XIdDcVoTzvcaEZJ7QYOr+Mw7hQwk4hiSN3N/Y42uU1iLhJT1ZHKJMAzxXf?=
 =?us-ascii?Q?C7BqMbRSJhvnxp6IVJNdQoyLWwZGBvdTtYug2dkt98PbsMl54EjFW7mR6H5W?=
 =?us-ascii?Q?8v2N1ljjJlRzPo0nHCGwtuO7EOjC/uDp232Ny9c6+oyIqXZFFxgMhDrRPBD5?=
 =?us-ascii?Q?3GUgr9GrTTkB6btCjun8ncBbLFgbq1MfCpc3Ddxug6uUvjLDoxvJFmwLHAWu?=
 =?us-ascii?Q?67YiezpOPhq717cim8pq7deZFoCHFCEKAQ1d1E8b18VSAF4MpC0LYkuO/tH/?=
 =?us-ascii?Q?w1vJuaB9zoWmf6ZxijnoYNyT4ZPFnM8ibCJMWBMdwcKsTJYAVoMKAKUa8wd2?=
 =?us-ascii?Q?nqSc/NCGoX5pJvGywEtD7zBDjf5Uw8MblFuuBIz569p4Nsq8cgSfBdWX1lQK?=
 =?us-ascii?Q?zbd/PYBiv5HRxHDTgFf9rcwPareaXzVYFp3X6aoC303dkzfptnxI/FmrfUfl?=
 =?us-ascii?Q?gow9ojeVwNFdje8CMCKhGOE0PH5V/i2B9DoPPNxlZuAUCIKyU3RlmKGTTo/P?=
 =?us-ascii?Q?LiPG5Z0APSxixPhpXuctlrXdW2nGxot+/y0/8G5ycgnwawBPIUe946LjA+SI?=
 =?us-ascii?Q?Cco3ZzaYrfsfnhMbtL8oZfrSnNjpA2nXKDGt58cLoyveiMnK2aQao2BA44FO?=
 =?us-ascii?Q?x12OF/fJebQYwAipldbQX82dIjo/Ea3s1pNuLzZrm2OM3nCZob2FoWxPDe/R?=
 =?us-ascii?Q?XM0jbPKGuE3uOalMLVL+PLlaGZ750msAJDN+lPCBrSb2hkP6u50Xrzzr6kMy?=
 =?us-ascii?Q?x+HjQavnISjVxDlmam2MzIrp9ia3p1o=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bp/wW2bLZqrngxngJQJYlFkj4AJwoD9mjUAzsehd4ulG6qMxLCWsqazDu5BgIrADF/5KxoYDwCHgTm7cMdh+78gCWZCN7nQIGHnn9XrbmrW7u7jEtHl4z+cat9B556InxvZC/K9L6Td2mT9MzzMjIRYRvviHU8FnGXv/lLMEKeWOaCxo3YDCU/A1j4SHcbdYc+O4bD27ZFpIan68jwBktc+3ZBNAZLO5bAAjakOg3h+G9T03Ee6mTLh3aaeP64O9q6j5CvTrjArlhswVjT8jX6u+QTfKNMXjYoGUhdjp9J2rg5QOBk7VrAlETMxtO2kXeJQBXbqitYRNkR76xoTl0l0Z16bi0vUhM/tm7wmycFEB9GL0ncFbQyhR1q19ZshR8qMzeBCSELXofZeBVoHe62Yds8S8f3hZFqAA60HO3oL5VOjSKuiP0zCNhJ+5Nl60y2OyEx0c8i2vrTZwJfWoW6eGuK2yfBq+xQJIbJfag41TClY7Z77j2Mh3VVTfmznrw1A2dBScy2frWpjLpvBU0Y3Nh1pt2cwj5wyFLiBNY1XY84TKcynmoRY1J2hkA32X9KTPD9sV2dupuBY26Lh01unG5AlbeiEf2PVDQ5Kz0SM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cf1e333-9136-423d-7047-08de7420d5ba
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 03:49:10.9315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +LvDm98QSXxghrEysEHXjbX8y2VkGuLpR35362HN3Q6HYavksFUHV7ewDEMXbXm2WIgkIcRgZyjidza6Ndj1wtFY4WcIw/frVhznnB9Gm8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6486
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250033
X-Authority-Analysis: v=2.4 cv=IskTsb/g c=1 sm=1 tr=0 ts=699e713b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=CZwm3y2N8gMuj3nHjQkA:9
X-Proofpoint-ORIG-GUID: XBMzfk6xYu0fAYbFLnPKvUTvPt0HhBJd
X-Proofpoint-GUID: XBMzfk6xYu0fAYbFLnPKvUTvPt0HhBJd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDAzMyBTYWx0ZWRfXxXuq4NOPw2fF
 ePpuhAsob4h8eUscnwn4/93MDC8pQwvgM3rejFf2YjIMJu2ATOGQRaks+tBaA1pQjcM78BFXJb4
 MiJ6SPlQzBXzyXYeY6mGTeBg8uQdfQmQ6AKIt92ppubv/Z5UFHUivh/7Db6aaMpAtj3DD5EokBK
 VAPpmyyqBg/uPrNwzd/UlbBzppzyV3l5Od3k4XFFfJ0y1ecrb5AW5JVVL0U8I8uiI8aJl9i7h56
 ekgoMXoETiCBpidtvVbSw3KIf395k3bXEtZm6M8y2idBqRLczR9Y6UBw4HTIwLUc4SThwlVClWi
 MhdfpFS7hsh4gan758Q20rnbXyu6+kRltgVc2ZmPcMbM2CmblNLXX30CL0uxG+Suztuy8pG8Qux
 oFmoBELcDX8d1O/I6JH3COUH0KwOWWG76BTU5f0Ruuf3ngEPWSBA91xesRL/dq1TVTxcuJzeT4i
 HAQ3gaI/04lCZI7UBcg==


Martin,

> While we have clones of the repositories there that were previously
> maintained by Doug Gilbert, we haven't applied any changes,

Because nobody has submitted any patches or pull requests.

> IMO the main problem is currently that people are lacking permissions
> to access the repositories in the linux-scsi organization.

I am not sure I understand the "permissions to access". What is
preventing anybody from cloning a repo and submitting a pull request?

> Once permissions are set up, we'd start to migrate the open issues and
> PRs from Doug's repos to the linux-scsi ones, and then start working
> on them.

Ah, so the intent is to migrate open issues from Doug's repo? Is that
even worth it?

Why not just send the relevant patches to linux-scsi to have them
reviewed? Or open a new bug if web is preferred?

Note that I don't have a problem adding people to the GitHub org, that's
fine. But I really don't understand what is currently preventing people
from submitting patches...

-- 
Martin K. Petersen
