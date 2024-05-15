Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA06613E8B5
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 13:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715780560; cv=fail; b=IUWECUEXjjDk5eZj33Td3PjhCdHkiBHYHRGUQlbXA2RuC+czlgCS/DeELPgTzOcNkkkT9cLfg9/Tv/n7TPcJ7jBsVX+qI0yERUqsf5O3c+6+fiIUY1l7A+NGJGB8JtGAZ3uBTKP/j323L5uPaIolqO8OSoAcyVzqNw0EROn92DA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715780560; c=relaxed/simple;
	bh=7jHYQGHYKXK/Zrq9yqk5QBctbXJ1Kd8N7WX/h7u90iQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=hqu3GVhc+Wk8P2xQRkUyGCtB949E8JRNlDyu3t8hBH3MALi2mbbreMaenFCvOjChGhp0BzATBx57tAU13YsHzW4sC+k3j11S26ET+HTNTP1hOus/E+YptIFpmjCPbGFRtMAshbLoCc7JcDo4IS7ewH5bhGw4HjZgrAeuOccMqPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fVeCtgPH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kOhMVGf1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fVeCtgPH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kOhMVGf1"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44F7n0VG008470;
	Wed, 15 May 2024 13:42:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=BKvgrQRxaFbuG6JqAs08g369J58ZNGTLWGpjM9Wvjvg=;
 b=fVeCtgPHyLHKk5d/gLfFxQjQWjPxQQkXgZjHmRDdxIu8lG+skVi8mhr32WAwdBnUVhWS
 jUijRbQ8RC0cDBzioDhkfMbOpP/K12ipQtGlH+3Xm8/S/8CSRgKKD888pTT5PcHACVle
 mMB4rF8U+XZxO6aQreqykjAR8cjLkUq9DRph7AV0nzx8VAd7i5uVkqhR7kQdAXk1TZ4z
 Sy4eZl9iTNLcG7VKrypotwedRVsPZqW563lwx6jkUbASn34zqT1bf7TZK8BcewOSPlTI
 Zbb8h2xDR9sLJrORACcoEOkJ3irR+/WzSUk8xJRcqjhlqammT2p6OioAWAVaoGHXvCIS EQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3t4fd27k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 13:42:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44FD64om018212;
	Wed, 15 May 2024 13:42:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y4f1694-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 13:42:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiOwHd7uMmEWUkKhyjfIyurEdqArirL92ifCTM71zP42UMj3KRnBP8WpvLVioDr3INYPfs+8sUOJ63f7wpnp4cnFsEVEGmlH5d/VvSlV2NPI13Nf4oQlp+Kd3GvL/KW20sqhoZXmUF6NsRSsIBDvSddrqHFaDDI8FgBgraH7nsT5jDarNyTH/mh6eg2aqG2Jm26qDQIJ7gtTmjqizrWm7SZCGtJggdfvw7eEzCW+zStBiU1H4odan4dFcOwoB5BoBr247SMQIENy7UWiGyfut8UK+Y7eLoCmta8MT9Mhq7v5pFBDw/nh2rCkN28itIH9mxt1S/5wtHoPIPwihNRU0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKvgrQRxaFbuG6JqAs08g369J58ZNGTLWGpjM9Wvjvg=;
 b=mSevRIa3vhDEHlbiYsCUTrJn57qGWCc5fL8GmQSQSwagoBsTl66w+jGYu71WcQSdfP1DdVkXQC7tfznmaJTPZJzSNOgKR0LATRtaJqaIQy8kmhmqN9X/qfahqKXt49FyHOFLasTE4vAyITX9hI15hk/4QT3f7jtCyb1q5VJd5x8L+9g7K8q+qluG/PTHj07dlJ1ovZm6MN91hbvo4tYpuaLxREVlzrEd3O9iTdutDaGO8/QbUwvHzYiqWb2S02u4t1OqewYMYIJuorduSwao36kenls3AHGLHp5S7tXuYi/de6+X6iFHSyljbo0LoB6pNU/BXIIIv1y20gd+Z9mmug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKvgrQRxaFbuG6JqAs08g369J58ZNGTLWGpjM9Wvjvg=;
 b=kOhMVGf1bB6DybsvpY1K8VwakRUOW+Lqmfi9MgDqPjeEjHKmoqXSTj07XICtSR0VEXCQ3Oakzs3wWq1WKRjis5FsQF0ZAjPnGYT8kRbtH9aHY2xCgDwQMOb0UfCOjE6x/BB3jpRzEg7J4G9jTrFCRRqACcqC8loffhCyGjvvz5E=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB6716.namprd10.prod.outlook.com (2603:10b6:610:146::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 13:42:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7587.026; Wed, 15 May 2024
 13:42:14 +0000
To: Nathan Chancellor <nathan@kernel.org>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley"
 <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>, mpi3mr-linuxdrv.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] scsi: mpi3mr: Use proper format specifier in
 mpi3mr_sas_port_add()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240514-mpi3mr-fix-wformat-v1-1-f1ad49217e5e@kernel.org>
	(Nathan Chancellor's message of "Tue, 14 May 2024 13:47:23 -0700")
Organization: Oracle Corporation
Message-ID: <yq1y18bry3h.fsf@ca-mkp.ca.oracle.com>
References: <20240514-mpi3mr-fix-wformat-v1-1-f1ad49217e5e@kernel.org>
Date: Wed, 15 May 2024 09:42:12 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0127.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB6716:EE_
X-MS-Office365-Filtering-Correlation-Id: d176672d-377b-4034-ac27-08dc74e4d432
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?PG2dvcgPvc4oUcw8kwcInTWdP5r0z5wHfEjgu7umrJVbbmC39qtmahvCQIOm?=
 =?us-ascii?Q?AN5AWl6otjyNCALihWAmWFRvtdnD2f6MStp0bVJpEKJvyOpW9nP0MwyF7mmx?=
 =?us-ascii?Q?4mnOuPbGxZEgO5E6YQLcPQUyLJqs+NCZNc6ef/iupxzQATp9BuxFd5suG6dI?=
 =?us-ascii?Q?IQBAR5IoqV7eqmTXksOHPZjaFxNtYvfYiSseAcL/Jz8sTi1ZUlLj4DfC68Lx?=
 =?us-ascii?Q?kI7YDhd0fqEEXFhAauWoQKGaKHJzyetSHw9Iek5GKNe+QPY8jpFoE9PphA7Y?=
 =?us-ascii?Q?kYEqUd8GCbcdwT+lZuBPXXQu2fHPiZSPlj5qP4qOO2C9hktsMjG5f1c5Rh3C?=
 =?us-ascii?Q?QKTqj8X8pqwPryR579pI14gtlBlHw/5rgVToDP8GMBTWPbspvmEf1mARrvk3?=
 =?us-ascii?Q?GyfO2YCQDxfg2NjvHWZQHQn9PITZBzlNwZGU/o15RN/ATkf0mWYDntpvH4Ir?=
 =?us-ascii?Q?E3P/3TEzDvO13qa6XB2w7UcebEGfSqxMrRg6UKor+Wf/kq4D9Tw2T3atCGV4?=
 =?us-ascii?Q?PbyyZie2LdJxlCTO01FdO/EWdCDebnoqwen9r7blQtAkXMIj7LEBbgg9p7y+?=
 =?us-ascii?Q?Z62MBB5NkNW82oJ/4inYMhgdCTGY3poordwObBor8lyla5kOUsK/IE64L6vo?=
 =?us-ascii?Q?TrtPQZ8O/NrwJFsl2ITouMnaBArdFADIE32tAmjNueBhjAHrDwI2Z8bNBULr?=
 =?us-ascii?Q?dh0+FvD+EcZUxSLxKyatdRWAyvrqX8xtJ4J9XetQWTYSPOE4pgm1HVpr/gu6?=
 =?us-ascii?Q?o3d0CF+JGTLGYXECTEgaZWYTc/Lk/jfV2uRyb9AaNKL7Ec5MYJchy/JPzk/W?=
 =?us-ascii?Q?fAy6KWEdJlZr4AzzEZ9098tprMTsohFcaLngD3NwzCXbaTrfD/qQOa3EmIhB?=
 =?us-ascii?Q?Mbm2oaBbkBljI5PWNvcLGjxnXLaNUHER9zQ7W87T1DSwCH+ol4CPVkoxhjLQ?=
 =?us-ascii?Q?iS0+JfLPItiaK7pK2R0WV24dlPGCF8/YH8Q9za4meQ5rTgU2LmW+3FoWlO09?=
 =?us-ascii?Q?muF3TLMjUx/AlyMKy3SaH80QyipsG6r/i7hKRzOWcRVkWQ1uVIqRMMalUfMW?=
 =?us-ascii?Q?Tijzp7Q+CDrvBy0vg6b9JskN54fFnCv4+ykpo2HyFVXHugC9Yt+9t6g0R2Im?=
 =?us-ascii?Q?fZiqvs4QmbUBTpJ69sYpVC0KsQpcuPBpPpYrg1x4IOgTT5MlwyRuN+T09YC5?=
 =?us-ascii?Q?acNNpMYYcArfYgogqKWOZM//V2Z9EQWP6c4OmWmgpfxrOuHJFRtTeFIkKZPf?=
 =?us-ascii?Q?HKoQP8JjAFB7D2+idV2KQSdws02h1v+S6mwMON2SJg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?YY1jY1KBgxn8s36VFnpTJPXaeK/T9mn6TuGCYz4Xlmo386VVENlKVpu+nPJk?=
 =?us-ascii?Q?1S/1COS/gFgmo4okk4VL/GMUY+6Vhby0MTDNw/X7aRsq7SIz5URpgUZnHhS0?=
 =?us-ascii?Q?cwmerDM7iqjmBgQnU8xyVCEsHaRfyw7XxS3XY0WqnKMDXIECw/0Htmr3Z/63?=
 =?us-ascii?Q?wgP93TTRzmxwq6K2cbXO6yM0vx793ThkhVz2vV35dl/KI6eqnJyFLE1JXL9i?=
 =?us-ascii?Q?Qxs4PXKNrNBx75WwavRJqOkpQme278oix/Ohx/QrDo6B5tDUo3Q22cEDw6pK?=
 =?us-ascii?Q?CckuN+JvRI2/wZ9Z/0yGW8y0hkvsUQITB5yINJqdUK9M3Qmw0RPBTelbL5MN?=
 =?us-ascii?Q?ztrBXKITizQRbum2qN960eeMjWo7At8m9doMM90xMwN5xLYXYJvzRCKGIdqP?=
 =?us-ascii?Q?P14OokKwjvArygte5l6RmxDlHgTcjFfW2hQQRQvFA8fPJGa6dbhd5ulOyv8o?=
 =?us-ascii?Q?jRl+kcltKm9cFU/IP88W0SwmRuverQiu2WoQ9mlTQYFNHxst4mX+Che4eXIF?=
 =?us-ascii?Q?ZlYtJV3qscNSvCFXuNhDynpr5Up8bR9CckmdhOnPciqQ7jxrnYLNpQ55RlXv?=
 =?us-ascii?Q?HWvs7pYhWyObTEPXtWRzGdHXSPxTE778pKWig5p1UYCYY8sx2tWG4k+K5Zjl?=
 =?us-ascii?Q?noxcQyjUroS5n0qFfPeWkbBQOsi2hKYON27O4cuWVc7vPeF6Gw6epB8UYDiT?=
 =?us-ascii?Q?yVPKCT39b/CNXCIJ/71o0N5V/YHzCLwJNlK8+864/SMbzlRzBv+aQUsj7qf9?=
 =?us-ascii?Q?8g/SoUQGombwpPm2oEQ23b/XC4vj6mP/7WiHDLahIb7C5V1KPz7cQTlOrN6J?=
 =?us-ascii?Q?hritgPZKzFby7uKHU3AGBUEw5KBfXWFhxafdgMfh8D6/DV0nqZlRYu9hcubD?=
 =?us-ascii?Q?Lqmz6nJFexJYDf5Q+J4P4dj8r6nO/ISiX3EzCbU86ypCMoPG6+8D6q7s3eZs?=
 =?us-ascii?Q?NGEfeP84GLMESlD2K2wH/xGTsPsvdd1gPWx8XMyxIUysiB63TWxGVp4FecUK?=
 =?us-ascii?Q?IkomCIzRXj7+kyC/opEL6kpHzAo8NH8jBnaNoGsibWuNlJe+3pXloiQq2e0B?=
 =?us-ascii?Q?9EcYeZGPjq6/9sr7fJePOboEYweUgPTKaQChpRtt9xssDC/8qMF5BGgS/PvA?=
 =?us-ascii?Q?LBdbydFwtDeefyS472V25feAydrqHXge9qYMZfivsUjPypnC58HESjUn7Ie9?=
 =?us-ascii?Q?uedmY/xJHgW0o832KuC4jtS69xas/AaGqjSmP+4qj1eLh7LmWOzJM5QzYJJI?=
 =?us-ascii?Q?KdNKtYg8eeW/yN7wB92u1Tc3wz/h3IJU8c9g57SIlul20lkwgrJ23aH+nkkf?=
 =?us-ascii?Q?f75cTCsB6S0mqqTfXGQjyTCtRNwaGGwsumYiggRiuP01nEr35YwXp/1iiWMd?=
 =?us-ascii?Q?o7uozo4eYZ4rSbQg6JNCG1ZWAfuF3Vbvo5hWqKM7jSVHcGjwRt5LrBkb+Dn8?=
 =?us-ascii?Q?dDpvCk/Yuy0Ht7SqtrlfITdfM3K032Eb30tCKDzDJ2udwjjkw+Q/2dYSVzPR?=
 =?us-ascii?Q?dNLAzHymZyMDWzTaqNdbrenj5ctTenmE7a0HtLHUuMOyAd//x5vEjEi0+vIO?=
 =?us-ascii?Q?cKk4Nj7owBFVGd/Y8w3w8rIMthCT/6inPuFPg/YI2bu3MJBVZ2iKinOFhHW+?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	pbwONkha2eUy4i5YmfWT5BQKgm8OBKkST4Ia9VUuO27ho8iF1bV2gc8+z2/zTlaTdgNut6er6ZBg6nD5nfjx67Zwb+pyXgt4x0MDXvg7jbV4x6B4mjZMiDf/8GyMSJQUM1JdwsGgEBvhfHZ/TqNq1JzIQudArWdCjgdvFF1nUbove96rD2SBD+0AQ1CFTVs7FXrIEtV/JqQc9x9u3dqar27agICVPO6pRcumwL/3opSc4KSWSdC4H0yHJjBwyaTVQA+NX8I1K+mFPPCA4SEtlmzxtAeQnK9aWh61CZRSwP8jULE7BJfCm5rm8HyRzOQs9tMJUOBiQsyHFucMiZoyM3N/xPJ1SIzVDPWBWpDMEB44aMPexHrKfugo2skVgfiKfcLD+gUavPgohKd2rNNIJszEFdOJAPD8ru2aQjS75NLAVm+kZZ4P2BT+X99wiu+C4htmETpemHXbDvjecEAuuUwdXixEqvFBFJ2ExqhKaq9XM7UksXfdsilvBvYPuB2KYOcAE+uoe00EOsetrmDTeQzxcN/Kb1i0/v/9ck3ZE7WpgqZs46CiRB9on1DBjsyk1pI56nw/tpXRHdKKqUDxhwVtKHGe6ntp+jz64odsdGo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d176672d-377b-4034-ac27-08dc74e4d432
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 13:42:14.2226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UWr7oFR4F9v6J85C8buuROERMTbqArC/hMszrdowqew+Yz0T8EeRuA76au2K1Pb9mIZYqTeZd5KpYQoYXiPowAO2ye7q+HVCf34yk2Fnt00=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6716
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-15_07,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=856
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405150096
X-Proofpoint-ORIG-GUID: dE1evrrNcsL1rhirPaKoqR6nLvzlfRls
X-Proofpoint-GUID: dE1evrrNcsL1rhirPaKoqR6nLvzlfRls


Nathan,

> When building for a 32-bit platform such as ARM or i386, for which
> size_t is unsigned int, there is a warning due to using an unsigned
> long format specifier:

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
