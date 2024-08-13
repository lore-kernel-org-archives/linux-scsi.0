Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBC3BA42;
	Tue, 13 Aug 2024 01:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723513217; cv=fail; b=bKZhffZH9bX6oa1zHvU61UMHDP9HnHgNdV+QvJ5PEJ+mRaWnUsTClhDjhgrDkkq9jTXAjUorj8dgaHZZYL2tSMmwNJOLVp8VY+87wtf67t7cuNJ2pHGo3TERx1Y0XGsWxbIH2SszSCeDCDMfaiPVkn/3ALRa4gkqu5WB4yOl2Hc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723513217; c=relaxed/simple;
	bh=Xpv02WYL+JIgUS3TYFsJkMj55UxJ4icS7UuubE572vY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=peKvcQypKakP9SEkL2DHyr5qeMFYNcpy1MJ36CiciOVTJtayc4/072+nzFUw1DXjUnVWbIWq6puDFOGuJBmQk5FyENJzWs73f+3KL4jBMseSFk65uAZSCm0it962KF9RxJe7pEW4Qs5hh8o9HzddNUC7kawUWpsL4uT4Cy6jZDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eQeyZZlo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CyDJ/Bes; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eQeyZZlo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CyDJ/Bes"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7J1J002268;
	Tue, 13 Aug 2024 01:40:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=dIESQCsdatUy5f
	c/pDztA3gg8djfCE5HIALJucTecuU=; b=eQeyZZlosMZ8ThxBliIFRpUtMCcz9B
	qBalD+oZaPb/vq0Ptl6YL/WqxmkRr34KboNWql6E5x+88yiwICQEJmiau5En7uaF
	FySdjdMCNZiCddxEBnJelv80BeWgISnSteCfGCxHl+WgjzJXIUiWu4Y5Ig3NU9uJ
	LKm8OfS0OXwbnp5rsj8JevNxBr3/YkB8OeKFNEx4rm3T47wL5pZSazEzA9EEV2pa
	PA/PAOpDrNnngsFHQMETJDT++z5H/+ci19/wv3XYSb5lGJlBXu+zJSuUQOuyvb46
	n8z4d9puEyRS4sDA6OVH3SEQFnv4JzFvS8GoSmezA1Eg7dKb62EtTg3A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x0394sbr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 01:40:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CN7AOl010728;
	Tue, 13 Aug 2024 01:39:58 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2047.outbound.protection.outlook.com [104.47.55.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn7wduw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 01:39:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xywmx10Yhv3XRtarhQNM7YoWxbI5S5NTlZx8sv8z8vWy47FIzwMTjitO+AHBiJoHFofNbAfLfxRPUkMCwTo1yN23HrUJKm5OCu5Y/ASOFrHcKQ1EeNUujh7FseaBLCD/VH/LsP7zXepzEmRQ1v+8QZUslHKWZuOsLWEUpg6bP+Qs0RkCOwtcrfKzQ3XS4v7Z///wMw3RslcoV2acIFiYqSJJPENiibwQptJZ4714YFt8VO0Lv37FOt4oOqsE+3YOsosmNswh2RKy1B84AWtLmW2Us68XShuTaOQaNJ6i4jme75cH+7XKT1CXyaMeTEPfA0L30Z4+ndZjoR0OP9xGuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIESQCsdatUy5fc/pDztA3gg8djfCE5HIALJucTecuU=;
 b=euOB90mLdJY8tb8ArVG2SOBO6FbUa4kMw5oFlThWOE2e4+rELZm7xhgFOYfHL9xxnPijuLrH7dJ95jRSsIEvrjEbAiN2DlNSGieQsUQcnYWYCEED1mz7xsVmkVEEp9fpbgAl6fNLjQlRK1ndD8Le5gMikweiytnY6pbslW6CgwEoBoU9iDV6uQwT0KUvf5UEbcQ6sf+D0jj/Z+b9V7VKvQIvIUAvxDffbbad/VFvi9otavm85YIDw9amYDkW+TRW0lsnsk6WRfWO1vjvfgiBJMi8xRbqCIRUhVE13WZ4RTLORImC4jA2HqTLKvyGf9fd2sySXg+65GUIlA4lqzQbIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIESQCsdatUy5fc/pDztA3gg8djfCE5HIALJucTecuU=;
 b=CyDJ/Bes9zkJsxFRmtvhHB2D1PLukxDhUXraIWsfvu+5+11I3gv0PbWUbR6r22Kvx7sVc8TSnwT4LMPMgzeL4imZP2I8+vxINlHEOookU8MikFLVTY9WuOHCUkM9Us5ndYK1UqhqpUYYq7QXWT72tOeK5d9yOEGXvbeyA0zzGeo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH4PR10MB8001.namprd10.prod.outlook.com (2603:10b6:610:23f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Tue, 13 Aug
 2024 01:39:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 01:39:56 +0000
To: Breno Leitao <leitao@debian.org>
Cc: martin.petersen@oracle.com, Sathya Prakash
 <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        leit@meta.com,
        MPT-FusionLinux.pdl@broadcom.com (open list:LSILOGIC MPT FUSION DRIVERS
 (FC/SAS/SPI)),
        linux-scsi@vger.kernel.org (open list:LSILOGIC MPT FUSION
 DRIVERS (FC/SAS/SPI)),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] scsi: message: fusion: Remove unused variable
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240807094000.398857-1-leitao@debian.org> (Breno Leitao's
	message of "Wed, 7 Aug 2024 02:39:59 -0700")
Organization: Oracle Corporation
Message-ID: <yq15xs5xkta.fsf@ca-mkp.ca.oracle.com>
References: <20240807094000.398857-1-leitao@debian.org>
Date: Mon, 12 Aug 2024 21:39:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0135.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH4PR10MB8001:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f0a677b-a6d5-42cc-4a41-08dcbb38d5c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d1h2gwmINHN6f3uKmcnXdwWY1lUFAruPqDcUGQRbtSavWjkez6c5Kwn+RjC1?=
 =?us-ascii?Q?CK32royQFaNiqBaq1A+bWBpRlP51OVIeMZd8G3bfJoBRQXteZtVJQ5UkRaP/?=
 =?us-ascii?Q?/U5novOKPb85FgXOjLEkGvAufLn1ZOd0SfPMdIt4IXCfRFtjjulCJtyN8k5p?=
 =?us-ascii?Q?PVDVv98nZ/+N4SaAj65z9ghG+b6KlEdh7CcYoag+DffODEF5rKKt8gjmdDnw?=
 =?us-ascii?Q?+6hoUWYgi/JU5hJWA2dpYIRPDxIa05tLf1DAjxGq5fPhg+gy6CRNsQlWymJl?=
 =?us-ascii?Q?tqY0a5WU9XqGuT3cNuWC2AucZzu1/cGWJJRsyw6M8qPBgSjddqpmdqcjhvp+?=
 =?us-ascii?Q?fWxbGlDEQLTAdLd9TWG2SgL/601ezUzCbX7Q3L9gDYwX+dAER7+j2dekAUFL?=
 =?us-ascii?Q?mp5HzxIlDwk12qV1/TQduxO2hBZz9AnaLErVMfq86bP29TuTpnpu9kcFjHEN?=
 =?us-ascii?Q?R4kX8vDS/wuQ693G3npK1E6v4nBK9m18ze3VIdl/bK8mra8A//Gh+PkCVofg?=
 =?us-ascii?Q?Zy0R0SNhIgs6rIe1WwY0kTdzpccXrBm9d9cq4A29Pmih7qdh760XXSdcQ+rv?=
 =?us-ascii?Q?EKwwVEJr6vYVcEllKpOpn45n9u4sbSx6htiLSppuzox5gH4TTvZL1gTbyAot?=
 =?us-ascii?Q?X/glWE6LrWsN2gsmbMrC+G+5RDWfOxrJVWKRax0BuaaBVkq7XLibBL+86Jp+?=
 =?us-ascii?Q?RIbS5+Kj97nKXeKMEzuKT2UhzXY0G9TuDkT6A64MeWs5rs84Oy90RHbqgp7j?=
 =?us-ascii?Q?ygMwrN6DvadBkKDh39NPJ4sifX8rCnSmKs6O5RABDTSXel5SgJB8t/7LUudb?=
 =?us-ascii?Q?qpjPd9I8FHFrC0Y95mLiHsAsadqXXyKt3RJX9dKR+NUAhhpb4mx5WY6HT+v1?=
 =?us-ascii?Q?aTYOOtOpQYdyYBasiBIrlbC9Y3g0swJ9bs8/bkcM2w21etOARdVeHCNcTnXO?=
 =?us-ascii?Q?jODhE8Xp0Lu1RlmAp1d64Kdms+TvyYHo51SFe9aQWs3pXfjUddYUObITt+wh?=
 =?us-ascii?Q?IxR1NO8LB1XB9edZEsz3Sx5XIZ8Qw8EoiQi8HfKTza5ZmxnWpES6QEfjhRhB?=
 =?us-ascii?Q?UlqJ4SoBLDDYqmPnTisHZAX7DEOhyyJ8YmL8p9EcoN3lE0ZZDK/eHWdVC/NY?=
 =?us-ascii?Q?0AwjkDzEoe8Se3bvVbQ5sWDm9ULI5bVboEHGLl1EI38xhn0qf9JHlQmoLTI0?=
 =?us-ascii?Q?+Wy12Kv3CvQIx5SGp20At9iXJeyONS4ReX5+LJJpB4Gr1/nz+O0cD8Bfm47X?=
 =?us-ascii?Q?+kiosucTYj4nfTwhIzcZTwRp2Wzt/g+XbBx/XWAqRIOIKSAm8cq6i7/WunYh?=
 =?us-ascii?Q?z8Az7oHiVUXydEfWPxPpNJ0fE3MEPQs4O8HO194kj+i54g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H1d4QfkJ9EXQAKuXXDxPcbSo8rLxGH4ELT2xaYr06tdQYxm0NoVmMlcMiIpX?=
 =?us-ascii?Q?oWfR3YKS8IkfBEKxLWTkGaVenujv77IQsgvtKjwDsNGEpIRwKdOlqJzrha76?=
 =?us-ascii?Q?eQByEfVpfet9gpjpB57fgRThiH7e1HRSmL9mSZAPjPXvbfHmb92dOxgHnvzY?=
 =?us-ascii?Q?WZWKigrYjiy5xEYiZReWY+cUdutve0ji5sU3T8ShOx81pHVcfVEhmYL/rX/m?=
 =?us-ascii?Q?lXSWKGref9p6j3ESrRjXlXuRcu65Nlv1cNRsRCoa9zHX3Na5DvuOLB0bHD0X?=
 =?us-ascii?Q?r3CGJHEOzF1OMCXm/MLRUd0KBdy3fpzQANkiYkNwGVifiUpxYR5yYaJZ+N6H?=
 =?us-ascii?Q?km3oOqsMcmHJQK/eEWb/GPFnX9akEv8imvt1ALxgV44f4L2JefBOnZmWI0iY?=
 =?us-ascii?Q?YDf4XlTAlBMPc0e2WWS1biWHliQeapSBu0J82Frs02w9ccKPGaIcdAqC5DiG?=
 =?us-ascii?Q?Z9XZfKYVjFa/TYEa17hxlM5OIgRAcytuPzeHBH/zhCxqtUoNoRcRiA64G7vQ?=
 =?us-ascii?Q?wasq8rG87q4akHcpOreWkQVfIbtDbHQ4JaNhV1xa+Y+3xEZab6ILa/BlOKQ1?=
 =?us-ascii?Q?cuDJY6ASGxg9QPhuwCKQEmPcdw0EmLYk/P6gykF+f4DT15llo9ewlECIuAYY?=
 =?us-ascii?Q?P2Rtzspu59aOFjb6u56PMn2/Bv8B5RGlGr/UqUF20baEWVEVhhdgkedbsJEL?=
 =?us-ascii?Q?I0VUWD8PayYBfPvu/n3WQYuQk7OlOVZV7gAzweO5y7f1rnn3harF1EHPnTwD?=
 =?us-ascii?Q?WtczAP8bT9yHw9aoQpL8rvGjQ3fOjpPvweZnoOoBb2POwkHm/0p6QBGASh07?=
 =?us-ascii?Q?h+wHXxvTBJ/LtUBDIiu04zIaKMjWHZMUCiLGBaoVwah/UbvVQ4IFHz2LH3W0?=
 =?us-ascii?Q?qpvgpWj7eD2IcR7pp+CrnXiSSE7Mp6ouEuo4aIO/ALO21C+CAT7pJsJbZQng?=
 =?us-ascii?Q?VotP9o2T9nuIAACHLgVz0/pqW4+MNAdvsoYa50nlub0NQFhPvQlP8RhWwHcU?=
 =?us-ascii?Q?Jypy4/kYHrsckEEk8sggxE5FIE895FdgnHtc+JzgWhHP2D6ywjxxIdDkdNLa?=
 =?us-ascii?Q?Vt2oPkrxYRSRnkG1+NIRqKdcHnYL/6dAT4xdIB0okYtsoxJrgaT65ndJ5leS?=
 =?us-ascii?Q?E+dcmHJhDe5GmoeuzjjPKT2x7xXN07FnRlFX9wpNw5nzCtnCgXHI9f84YdGi?=
 =?us-ascii?Q?+RCauJZIwthNGClEWLTvBvOMU2ygaCNsTWPeTfdv+NKOZJ8PeoiaysySLBJb?=
 =?us-ascii?Q?H8o2epZqgJmc04ovECmStFPpW/IbHbzj3kMZoNaCXvvUkAWgH7HQiKBMGr9R?=
 =?us-ascii?Q?BDTM8AVmecepTxcoxWae/X6h25B3/vgj5W4Tgw4ZGuAU8OCKhdNdh+02zYRH?=
 =?us-ascii?Q?immQzkhdup5vBigVgsDzXuzrJLmKZ0te3+a0nAZFu1rRc8t8qNXutwzO3o+d?=
 =?us-ascii?Q?N+DmAeVo1g8Oy6oAOnzP5CMj05QWgPlLIJBLQ6vfCvTh9Ye3Kcx2MCs70qqW?=
 =?us-ascii?Q?fmfZDRY5DLW2OJbUmRfvvPsoxdlGXDCfIDYryq1BgAJfXedW5uOFtIiNX+RD?=
 =?us-ascii?Q?b8aw7qowxC++uVNWVNDtSesjnsOJoK2gsKVRN4EmYTkyTEPdn32rReMI+BwD?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YJv+lv+Kh2ulBzhXlVOTPEucyAinziQSUHJJATMTlxJa8wP7cQK1RLHHIx/mmHTMH4yDl2mtatzW9aB5NtTs+rBNowJw37J8IN3P+cZXlcwAyo3WwZqrZnA1QHl/hgd669SzE+mauKyyI1XVFSxMMmKPr/lyyk0zwRKx9ym6asqbCdDXx2rjmPelAjookXZ2MphCT6WCnfczVV5Qymz1nSzbPi+RfVyx9n5kWeNeUfWZucLDTD9/vFNgvNE6Q3Ns0STC/Iauz1zYmFAuU9T983SEZTsCspQM4hwpxic1hmqO7Ys+UtpwzZ+gpwLUvOyNH5ymKqpbajYnvzPhBR8xsAgFx3ebNBU5zI6QgrJ8GQ1dJEw62u2jq4xU1B1NcqCPkUt43muN6YGfuz4AHzxAHYcc9Wf5ObTJTi8rrW/R8RaQSpNS3nonz3tfV7IlxXTc+AnnY2GZRs01CkNg+ZPyQBE/Ognkl+0Xfc9M1CeZn3FN1vpwnd3UI5C3QMlNYAAo6JJieG0QaEi11Q1aQX0Nfu+NjcGYnuW/OwvVQh26OyaLFyXDcVXjmdxf8zBt1x4wnHXuALT7V3kY3Zm0ka78+hbkbAGuVrqf2+mJ7nQsHKk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f0a677b-a6d5-42cc-4a41-08dcbb38d5c4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 01:39:56.0183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kWqn1UN+n/C1Y9BrL0GSScNOdmfOSiZ1KCjZ8+Xx0nYP9enOSSdMSOASCEKV6+54mBDyytCz1YPQ2iK/Gp8x/2yez+VTQp+QwfBEGKVM7h0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8001
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 adultscore=0 suspectscore=0 mlxlogscore=722 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408130009
X-Proofpoint-ORIG-GUID: T4dR67xHc8Pk4WhQNYAFr7i7aQHFqasp
X-Proofpoint-GUID: T4dR67xHc8Pk4WhQNYAFr7i7aQHFqasp


Breno,

> There are two unused variable in mptsas, and the compiler complains
> about it. Let's get them removed.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
