Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB56F2367C9;
	Sat, 12 Apr 2025 01:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744422937; cv=fail; b=rmnT5zCKD0dvg/1YgJJpywcZeDufVw+7LEp0mXllvKu6KGO3na9N5xSRUrs7yPi6N3NUqlBjIf8cx1kea8dFPDHuAjvquSCJA6rCgBU+V8wX9bTLgm18degZUa4woXQOQdHMwhtv5z+qCNFO6Te18ovrYdzIOVY3Y7EOIwfUgmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744422937; c=relaxed/simple;
	bh=/HlBHyR9T679Yh/wYGPkeeOXE1VoFiR8TQAbhoZCbCU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=DjmGEGI6GgZDuxOyrFkpuxkBmARafJT9Bgie3LIdQcmugDA42FI9tzX8p5LrPDJA7Z+5aPIukFJQpyOuhyN7bp5u8c/5deaR76fwHvJ3341heAij/Lb+jH2qAZE+kUh3EEl4tynCPWSRS6SrrDONB4/mNl16C3NNpgZDFXik1PY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NGCNE5hj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jDJYcAJ3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NGCNE5hj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jDJYcAJ3"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53C1XvPQ006818;
	Sat, 12 Apr 2025 01:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=b3AYFfj9ArYtXkZ+iT
	gHbaqoGli6ataAJnc2mZhhIVk=; b=NGCNE5hjJjYPuAcel6dNI5VgQLHCEV/VrX
	POIX+9sXXuIl58rw2NpsPyas95gF6FBO4l+ZXmarspLbpdFARsP19hlneGFwNg9h
	H5l4wszzDlKVcW9dZaIv+zSLYaW3hMfPgbgsCjE2brA9xcfCvMH9DLouIU5TCJZx
	E8mVvSRFPxqSXJitkkWpG+NYd4ohnm94aCQAL+u2Klk50TThrF0GI2nkU4BfTh70
	qCXPZaVv6OcCjywW5sBfYupKNq7YRYElfKU2hiOIXd9I5Xb2ibitOfYTcJazPIBU
	OFlYzXq3qeayJoj7NdhS1IdKc51Znd0SoOv2JK7omKOvq8VPWDwg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45yekt80a5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 01:55:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53C1XPAi009898;
	Sat, 12 Apr 2025 01:55:29 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazlp17010005.outbound.protection.outlook.com [40.93.11.5])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45yem5raa0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 01:55:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sb6/QpsYs3IPugj8hJCO8M3/tFHir90TiDOQ4CqaazFdb/2g0YNqxj7zkMPgAP3T4C5WH+3IyBJOUZRIaALZKtcd9zdlFKHpz8oLACnaCV1tgMtXavp63X3NP1c8EM02GY3qgd91ffsaj4RojtJXrGtFZQkUEdA+SKrlNTmBibPAWDgULIfjmAdQD1ZYoXPsC+IOYhEPwxyNgzw3pDBRJXr5PKLI/nixwZgYomFMx2pNB0/UikcTjQdlJSAMzyJ/NGfWrhVcAZ2OR32gKpbUqrPC+CTGspVlymi9mCEDYq2G+TrWY6Fnmf5fRE25Y+Hn9RS0xunit7p67cKoz04gnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3AYFfj9ArYtXkZ+iTgHbaqoGli6ataAJnc2mZhhIVk=;
 b=C9OyOW6yd+xr7LD0VX5NUwtIA2qOsuXFIeT2/6VcNWT6fSf16ConOrffQCbICPwxHUefg/M9hsmdNwdZsW11PEeuP1DvFFAmUzvIJkK/ulOM1MewqNcH3yHniUQOl+zTmGjnWdrpWA/nGBmFoxc3nLGdzBrHqq7Aqe8niz4X0rjK2W0o6tzAsk7doDeGqg+0aZtOsZ0MRyrKg0xczDMrwnbpcNMfAs/SnjMSA40Y6ToAX17mk5SD9pyeTjihFQvR8sxgDrgkah4NSauJQkdwXC1jjxVqr7PupvDGVjlj1Oh330igiwVvYQm6P2YBpvmj+ujA3Ik+ZjIdtn6U2sY5cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3AYFfj9ArYtXkZ+iTgHbaqoGli6ataAJnc2mZhhIVk=;
 b=jDJYcAJ30Xr02XbVaU6pcV9n6GQ7Cxm34hm7cOs9AzkXizrOHYFAu2fOFIOyldhUpUt7gEGk7D/IKisVe5kJ3+JoaP4Aeu4ilmlf8QV+XUKIvyHgIxy6nXpfempMwmnzAy2FHamQ5UuE0ZnQCGAyV5XJzdny1bfP5qKS6FnU0DY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA4PR10MB8374.namprd10.prod.outlook.com (2603:10b6:208:55c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.27; Sat, 12 Apr
 2025 01:55:27 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%3]) with mapi id 15.20.8632.025; Sat, 12 Apr 2025
 01:55:26 +0000
To: Kees Cook <kees@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jack Wang
 <jinpu.wang@cloud.ionos.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: pm80xx: Add __nonstring annotations for
 unterminated strings
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <202504071136.73E5C22D0B@keescook> (Kees Cook's message of "Mon,
	7 Apr 2025 11:37:54 -0700")
Organization: Oracle Corporation
Message-ID: <yq1lds6i1ol.fsf@ca-mkp.ca.oracle.com>
References: <20250310222553.work.437-kees@kernel.org>
	<98ca3727d65a418e403b03f6b17341dbcb192764.camel@HansenPartnership.com>
	<202504071136.73E5C22D0B@keescook>
Date: Fri, 11 Apr 2025 21:55:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0027.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::40) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA4PR10MB8374:EE_
X-MS-Office365-Filtering-Correlation-Id: ae90eac0-b9d8-4218-47ac-08dd79651880
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vtd/hbaX5HYqqJxoXTELH52v/j/SYJKBZ5elb4WYlI6UZ1zHkbiTZqwAZgXF?=
 =?us-ascii?Q?0s0cuX0V07ymy8JP7JS7qwnz9s9GdqqL+6J4mo9KcsALUpjzeoCwYWcxbHiy?=
 =?us-ascii?Q?i6YrAJGU37yCV2XDxl24avSyEZGULGLThkWAZ62ipjEWcc6uONoKOerqJfRB?=
 =?us-ascii?Q?Jq4Sn9a512UvenD+xzp1rDn6ZtqwTbT9TKVIn+YI+mhXlqK4GBjUG57kL5qK?=
 =?us-ascii?Q?mG8LV9zVnL1gV73Vp9zaK+p3fZyJaGrQDdrRGlV291u1floDRdFX/x9EYs+I?=
 =?us-ascii?Q?ptHF3sweKf7+gK1MhEgX17ya5uJN5VDBa2oZK+nUW3CA2ScUDhQFNUbRSQfu?=
 =?us-ascii?Q?OMyaVCo4vXYuDDUgKvOGO1Z3nBeGMCZzoPIGCCq4zCyXzl+EHwzukF2UnMFY?=
 =?us-ascii?Q?uo6j/yAFqu/SyeGom05H5PAbvUsQxiTrYqxr4zA9aUqoY6cyCtiYcH/GFiMr?=
 =?us-ascii?Q?spF5TLb916QDv92edykWwmmMaWNr1eDn9ZpjVu+B4deXZ6P1sN+aKVW2ATPO?=
 =?us-ascii?Q?1yf4wX58z4obAUY3mBuZIJYtiIjhxkEwhSzQXN8gh4+jy99ohLEz4jh6rzaJ?=
 =?us-ascii?Q?CeTgbfoLCmeWdx+HN7ro9iSxeB/El7qF40I8bGJPxBLJQXyvtl5nU2/UGbMC?=
 =?us-ascii?Q?ewUOvAc4YedecCybGuKDUOhLGKIeKZmEsGKCRG23hmPkSfjDw3sh8jI6MUl7?=
 =?us-ascii?Q?axFmfwgZZys2tru3WhiHAg5Zzp2n/nIBuBJS6UELrHmNDXLy0rPy+umVHkJV?=
 =?us-ascii?Q?Bn/ly3gZfa1mMm4Oqte/jW+H3XxVVyhzQGi/UQA35Qy7fqTF002JEjL9SDTQ?=
 =?us-ascii?Q?9qSd4RucK5RoF6Nw/7ybtplum8Gh3peFacYyDmQ4iJoYem2suniQIDxIa493?=
 =?us-ascii?Q?Jt+G72Cn4RVv1452WjpKTdJjNCAH+qg1aDMNXhArjkaXJpPoFV3VLjCjg5dr?=
 =?us-ascii?Q?ZrdsU2bbiVnk1QeuQl5jfh4aj6tim5hlcIe+aszrQnk5t78WGjo9MhTLbYJI?=
 =?us-ascii?Q?4NHa+feB6AKSrjRCX/nKbn/l2ToUTldTR0VWLlaqUshEOyxbR+1+Xiz6sNLM?=
 =?us-ascii?Q?pIBtEwamGamVPGp+1iaPS40YzgPuOJASo6Lhq/wy1BwxCSrAAxQG/sOEteRO?=
 =?us-ascii?Q?68qbDq8JqSt6nvIru/w+bvgzNmR5uxJ/rFIu7MP3tQH3BN0cICLyRMLzAud5?=
 =?us-ascii?Q?A8EQW3qAyQ79grMPqov9yewQSK62ti5/CLuCsBqCtTF0VS1bal3sdlSfDUic?=
 =?us-ascii?Q?yYEHL+gUC9KkFGdIDGmb8uogeQwKfLL2AGcDU+dbJ4WN6rdN68jnV+XJLwA9?=
 =?us-ascii?Q?dQElhC2P3RExAYFsOlLsb7gMQHYMZWGj9SF9/Q4d4tG5d9MSPt2I/ZldRFF2?=
 =?us-ascii?Q?G1UXYt/P8XrvX/+kxxfaKqC8+OhbH8zcQth3vIXOD2KKtZfmoKutWXiU+I0j?=
 =?us-ascii?Q?nc4nx+w0tQ4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+1a7y5uBmaqCMwbCWmDImDOEvJ0E1KcSWXoUhkSY37NL4r6VUrKkzhQYlzf/?=
 =?us-ascii?Q?bDpOVYCEH7T4egc9YM0Re1bEarWd2K4v0NWC38V8cm+p7PKQs7G8i7STMHLh?=
 =?us-ascii?Q?nXOW/XVVfilvgp7NYZruT9PPHLfvzwWNyct3SOYYW2xGSUwamwW+4BpF/YYi?=
 =?us-ascii?Q?QLVDqPlYfvW17t+AxUn8H75ZQ9hw2N+e9H6AJWw2wC/9qaFA9e8rPPlEdapY?=
 =?us-ascii?Q?7kN5CNpXuaAuU2X1EVP8Wm/aSoGtV3wWalgnh5uIFdTl2V4F3zTyfQYsSLcO?=
 =?us-ascii?Q?O1qae7HlCOYSnxNwB4fsvYVBeg0isll+RKM7zg7PPp8A3ie6sW9lXCOX8gKG?=
 =?us-ascii?Q?QgvvNySpw+8Rtse/hFcr+WgZpZJLK6wOVezsEnX0fumluBLK7Eq3wFVJtu3M?=
 =?us-ascii?Q?3ir9cR47u/78w45d39aWiAY0wSuEKSs7QSh9xaTWdVwGWtXWXVN3y1d1QKz8?=
 =?us-ascii?Q?0X1hzh5UeXCylSHEcrCQVndBIMmdXcWvjo9UDy/yUjhLwQ7RPGb50MaLpS70?=
 =?us-ascii?Q?56OqdjnXW0T7k7XlI8+MP6UA+BOF0qIMC5Yk+13WYb0U6szcSlMNgn2RoGwc?=
 =?us-ascii?Q?eIOIuwoWb0Uh+F5Tu3Dtar3sChi15MuZP+YwCq2mCKtb5+Fr43NkP5NjGWxf?=
 =?us-ascii?Q?X4L2nP49SN87v1jHXDW2wTGRVH/SLNFLwkOoZWctOIbnbV6B7PUL2vMv6+3N?=
 =?us-ascii?Q?PW53Hz4x+8/XY3O0vc9AWSmR+WjHLiwf4XPStf9imRNVpUxxwN+5294JBufD?=
 =?us-ascii?Q?acqQpwyzhskiIWjIMdTTwdG/lW1enKQ+5E7MA7AUhTYH4Yg/hAHc3VpWpiNu?=
 =?us-ascii?Q?zrg/HyJ4ql//TRuRe2EG/kFThmTYb+qI4MOq2hjnpnhnZVxuvpwMJggumf1a?=
 =?us-ascii?Q?th1c05gxobzpdvkOWvXjiE68XEu+rFwJljJbJkRRsI0Qb0F4RDq+Dip5NxVT?=
 =?us-ascii?Q?Gwv02M9o/tWdqpxLdRUxDvall2RA3+yo2tzfoIZHq/gDOiNwpbgkF3lPkj89?=
 =?us-ascii?Q?UALPxHO5/tedOcsz/q5vgenEvmNKP6xfBRXsXXwAkO+2FuYt751kKPkmuraT?=
 =?us-ascii?Q?Oz7NYRIyv4jmNLosyZb6JqmxSvYicoIMLjqHLT3CETC2KfZMSzvYSNKd40tj?=
 =?us-ascii?Q?gR/9Gp4O+6HdhQ5jJ1FSA5q57EG0DuRDNbmdY0NKbsJfC3+LYz28UU+ZzUnU?=
 =?us-ascii?Q?jm3K2qAA7lyWFt6YQZOvR1vDyonfVAqDosSy/DCY3cSSu+BhGjSzg9grwjMf?=
 =?us-ascii?Q?FLyeAnM2gwzbL+VSoaYfiO6VLbr5ty3ayrUDjRQoqn6RkwkpQHcsuf5yCNWv?=
 =?us-ascii?Q?Fqrq8D5vRMb6eAC1YbIiIEny3J5aoNurhLDqik2CrUgNAgqYgmftg02CR+zW?=
 =?us-ascii?Q?+lM8wR0g5zbNqmHt1X0RpLz/RV2lbR03gWQPWw0dOgBiEnm8VaxJhFH3zWUL?=
 =?us-ascii?Q?luOHLEHGnWuB91iNAIRuq37/v7Na9n8hzGemhrRqOFzEgCtLU86YL3jMu84W?=
 =?us-ascii?Q?/tHRMSPzKTzgTo+m3msWZZO2eTLKFVEq/P83hO1ttvhmopu/GvMTPzNhyoMp?=
 =?us-ascii?Q?Wo0ANliduVB/Kv2APDITSZkD5TuYLsSykGMvRxwzXW0hFRFwIP94RgovvW+5?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2f1pSFTTxrW8+7AoDEA/jgO40DO2TCzlm5Cm3rNk5Bu3WzFSSlf8a+7WIGVqYaBdiT+HdqH+LKJqZhYpt80Yt0MuzYwWeh3hI7YLOadypUtM1OXHZ4ge8GUJNoQ0E/+vNYGciTYy1ow2CKTmOprdSRp9SuVehwSPLBUTX5n2wWJuePJ+E0HXfVO5PKmOZiXrOcx8ibHcnLXLY1QDJDpwq7g6I7Ssx3c50zLEGAbRbqS0eCaTosgpgimxAB7K7mZgiKXvn/CWoyRhGhwMSCpynNwd146C0mLivQjqAqWsmcm8wLj5+1ffvu4982HGQYwKs/f6oye2EqdvvzGAeeEhAryRIX3XbHuZn6njrN90UggGMRTvn5DmQX2YYBhez79lC0mEtuyknMpm9xDdmn5oKajq7aDM14jsGj7y/0nJtfPK+tIXR2cjk0Kj9rrL3aqrhjQSUdo3cpXrzoZ8BpzeCqb3wmE3T+qV9EuAOuMnnN4c3Ce7+beksbAuF0anlR2mXz9lsVRoRI48o9iI7v36gjPuA7MElzamGflX/EWH8Nasx9fXioFGFQc1kH0AOMvPM3czOt76woZwBG9Z0Q6BlzrIl1FZpjbM8Is7aJdyCv0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae90eac0-b9d8-4218-47ac-08dd79651880
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2025 01:55:26.7837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqH2cxxvOWSAootixiVbDWmAWaiWQIZcJg4SXeUs5dKhu4X1bob8ceJzAjs+JsWhEJJpzPlI7Rtj0Jea/Ze2QPeSUDhInDCqBnj99dxxU84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-12_01,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxlogscore=656 phishscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504120012
X-Proofpoint-GUID: -81RmWvhtUGC2mnhpCthnJq-ivLn_xo8
X-Proofpoint-ORIG-GUID: -81RmWvhtUGC2mnhpCthnJq-ivLn_xo8


Kees,

>> > When a character array without a terminating NUL character has a
>> > static initializer, GCC 15's -Wunterminated-string-initialization
>> > will only warn if the array lacks the "nonstring" attribute[1].
>> > Mark the arrays with __nonstring to and correctly identify the char
>> > array as "not a C string" and thereby eliminate the warning.

Applied to 6.16/scsi-staging, thanks!

-- 
Martin K. Petersen
