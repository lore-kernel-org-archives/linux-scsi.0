Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3E91A23B0;
	Fri, 10 Jan 2025 21:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736545488; cv=fail; b=TuTrzWoNya/LoJZAH28ZjzX4Egil9QZVJsptNsyCx946TcvgjM26g2s79w37L2zFqHiyxypqWGgIUO+KfnXs+MPIP/Bmzj3OXBugy63I6ReIMRio/WmzbJ7AL9FF3e6J70hVW2kKlNHB4RGc8/fExO7ABEWokAhP3IuizsYlReM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736545488; c=relaxed/simple;
	bh=BuTHQmO9MZz1VUFrFkkjmmhkRhoVSmXCUwAr07FnnhY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=kGJ3l2hpT7xiD5l0wSD6a+xqBu9eVJED4IVcdtz+2aSWT1huQFRtQDV5tYNkHIUiJZe2VgQIll4Fe5e1Tzkv8yd1VSfOZVCPRsGzxVuL5QTx7w/Ub+bXPN/cct+Oin1v3Ww7erHwxB2vyjgVZ15NWIKpOa4FB3nV7/oDd/hUaQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n0zrnM6k; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=B0qWGyCz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n0zrnM6k";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="B0qWGyCz"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBocN018752;
	Fri, 10 Jan 2025 21:44:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=m8O7txVUgNMWH5zKhZ
	SLxuVBZk5glvKAymFvtc2XLgs=; b=n0zrnM6kiGAPNJJJOEATXjVYqbo+ZHPkbE
	q2QNKMj9MGGUY7u2FWKVl0pciVlRGyU/pIo2bKLPxk9k5KNZwx8wuHrrpH8QXmsa
	Y74VVtgVGLmGjmaZ/7EtnMT4+0jWg+bXfD1RqfNs4f3ub1uQyOOvFqKvEXCji/ZU
	NQjqqGrp9LTcCQTSYA1kdHurq6yRzIqyxEVOzzOtKwksdfmzW7j4F/p+HGqE84Fl
	m+Wy9T1b/iz2wR52iTpUTjXCLlwmXJSw0EnkOG0309nSBYFkzvCUj3/5qZnjg1cQ
	xf8SBvUJcJ306H+TjaRhTCB4+BWIdb+phWAuYnJLkELD40vk986w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442kcxacgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:44:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AJKJQT010865;
	Fri, 10 Jan 2025 21:44:21 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xuect7ag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:44:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SmEkwK6B1SMLKwdgUB0NHP56kWKjSSi2ezpOqY8xzgkZGX3/bIkeimk8vwluMDx5nz11CzbKVYKk53h9eoGGV0SNl1MlppCZj2RAQ+Oo3qL2gAgYsH41CyGQ6p0opyQaY880+Cqv55f+sYf0Cyu0w2geYzC3C+pWm4H5hw2GsG/EOOPSiVGKjsuhGT6OI2fejK8mi0Z6khEsD3i8pu2ocCtQetuuQhCJSQRn01HOpAldq0bC6+owcDpbZQmQ1bt5EolxM0g4Oq2Hirg0G/jL04O05SeH26i/uF4tolm2pcV+DRdj+NS9OH+ZI98Zb5jXRIlCc4xGwxCrwEZb25dnpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8O7txVUgNMWH5zKhZSLxuVBZk5glvKAymFvtc2XLgs=;
 b=o2DvEXy2ZVf1euqaNUNTEwJBFZ68KFw+vAvqJ4IFSIulupQ02ogAL+6a55kAtvqnljiaNwdunfnAtMtdYV/hYTSogkQRuQwv8rgZPBcvEMhMNB6/mN88xBiiwEblr4MG8sA3QMV/JegutiROXxXt20b1unkAj1uiDRPHXT46QOucMjbTg+gVs9XgKt8Yd9HT/5n6Ygn0Yq+jgqwR9DdAjnEKnmATpX3ozCH7BDZZTYKKGdtWDFH55uBihYbR/gkV+VzIEhfPb5Vs6zBlTQsoBPmWu311bBTFVry0FYejISFqyWklfc8DxIhaCmRYlouMIQ7gvE+cu4QyLyGItBnAjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8O7txVUgNMWH5zKhZSLxuVBZk5glvKAymFvtc2XLgs=;
 b=B0qWGyCzyamlPPbiA2A8h8wnhpbeWRnuQlRZgjIfB4GXT4H/0fw1VHMR8DG4bcr9ODv/omy/Gy/tKSaiW0DuJbiqs6zGcIBlQdb1hUDzysXir1i8lqmLI49UbgHRWf6VeV6lTEdoMqbuZctKc6gPe8mHQ88D9OHuIaSF/CY6H3w=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BN0PR10MB5094.namprd10.prod.outlook.com (2603:10b6:408:129::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.12; Fri, 10 Jan
 2025 21:44:19 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8335.012; Fri, 10 Jan 2025
 21:44:19 +0000
To: Ma Ke <make_ruc2021@163.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, jeff@garzik.org,
        James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] [SCSI] raid class: Fix error handling in
 raid_component_add
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241224074314.3769014-1-make_ruc2021@163.com> (Ma Ke's message
	of "Tue, 24 Dec 2024 15:43:14 +0800")
Organization: Oracle Corporation
Message-ID: <yq1tta65oqt.fsf@ca-mkp.ca.oracle.com>
References: <20241224074314.3769014-1-make_ruc2021@163.com>
Date: Fri, 10 Jan 2025 16:44:16 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::35) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BN0PR10MB5094:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b665d9c-707c-4828-4b74-08dd31bfeff3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qZ6lQ7UZvCWxL+1wdqQQYzcazvPetvOdnQ57QAICCjoZaArg5cV5GWU/WEeZ?=
 =?us-ascii?Q?ip+uAebxyql2qiKfoClu3Y37pWiIDuCe2A6ZWDlHl//kYz0gzy5VlGiE/bny?=
 =?us-ascii?Q?QHRZDOz71nGddURh0QYo/vd7AtUKKnpUEdQ+iB3P3BVI3QPBfilOG2qn+kGD?=
 =?us-ascii?Q?2CPAC1lMhJkrNjTvKftOfWwcK1FYlSQVCHCmwKFcMhuAkfSEGfOsfdrexhuh?=
 =?us-ascii?Q?iSQZLk+NNjJhvT0YBzE81c6mlF5niU2UOEoH/YwkOofpaLDfxi3PcIrmYc08?=
 =?us-ascii?Q?GZQFi/CB0yjrrvDpdkUKMKHjEzvwrif9Nrf5tPylJxLntvdb34gIDu/wV7dj?=
 =?us-ascii?Q?51sM/Oz1/coObbbm0tsoEz3sOonfmoXDR6+EiDswIJFHo2AWqo/uiX/TiVn0?=
 =?us-ascii?Q?O422qACDqbrSPDWcTMICcZXRtYS0VeHyeU+iOmQ/2jw82PT715JgIVnv+Smm?=
 =?us-ascii?Q?s7tEpGer9i5VhzD8uim+oDQFD7qhPV4f94Hubc5UR7FS2VzHXnDZ0f5yCkVK?=
 =?us-ascii?Q?m06Dgj6Po7vPNS5rSMG6hDDTpzuk1GyCQmnpi9cHBlNrZCthP2E74ywd8kK3?=
 =?us-ascii?Q?IL9QNrwQ00JI1K0aZWgP4a9ltX0aAY93jF09vLDyi/XTBDTMXVTf1BFbMLNv?=
 =?us-ascii?Q?2Kabers4ZKMIuUq3XU3Ig7h1as1dWRNRmKt1u4es3FucQ/BRYsvc3+wvxD+Z?=
 =?us-ascii?Q?TcnJuYVmojiV5xK/1BVzWAqAVtGRgnK/DsOmScef3eCAm6eAV+yMuxwns8Zm?=
 =?us-ascii?Q?zynxFDt54CsqDPs2S8NHGLI3cKwnhL2fsySC6ebX2eYGccNwgUnM5hXiSVHk?=
 =?us-ascii?Q?pAYewzD+b6jQgF0clDyFTlBXLRjP6o/3H4CAUfw8/vBAK1fQyqoCgx+B8P0T?=
 =?us-ascii?Q?tJcGvebn6xdmJSSZi1reGeVP9s0fjsR+T7zoi1rcQkM/vwaKBHOXoAkhEiH6?=
 =?us-ascii?Q?C8YuooZHMfeqOWvmzswvb1i2ygXKgPEDDG1WVMu5Ti/aFL636efkZoSUJ6X+?=
 =?us-ascii?Q?vnDnApEHAvs+6ciZ2v5anRFcokq3YzhhRxOhHEpquJSK9bhUQNYCN2/WLnY1?=
 =?us-ascii?Q?BFy4UqJK9G9mQhHrpk02JNN5Odk+EOKBYFxHHcH87C5FZyo4CjCsjQqA7MLO?=
 =?us-ascii?Q?4YAiL6sBAeY4Zcq1fkyi3fcMBItHiLb+4e72Hd5pFB5M1PXgM79Q/4ENHp+L?=
 =?us-ascii?Q?8igS7EQFXtrTigT26xBlhdhNVdr3NOhUhjaylvhodqXp+oOUgEcxY8HF9lC/?=
 =?us-ascii?Q?R825qf+kxHybJf+yWxxR88RWMQw0x9cCz7x5tC6p4eU61BPkkjzY2eCD5PQu?=
 =?us-ascii?Q?FeYh2N1XnAwHBZ7eqWcUfBRBD8TxSQgdrDnYbk5BHP/uRwELwuItmF/C0jur?=
 =?us-ascii?Q?cmkR4bm/dMlOWgHS41Xoo0agdFOi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0Fo6VnkzZI/cJhKhN9Q3Xg83NVMEcIODpEfs3FMpHgUOXVMZRmBnXTI7xkPA?=
 =?us-ascii?Q?NDXN58fOSNuwCDO4gAqXC8mCJxgAlp3SJta1oGPUio3UytnK67qibPx+hoMd?=
 =?us-ascii?Q?uyslTs0FucJFXLclT3Ee0hL/5q10GZZfLdcbZ1sZ9aT2W5sEdL8F5nBu/SSN?=
 =?us-ascii?Q?mgztULijRDdt2F3WYrJSAEwLBK/pRi7k24AZNq8eHKazLBMiu/JO2BVTfejJ?=
 =?us-ascii?Q?J3Ydwsbwpeo8SLuLJDQDkD6ztFdJKO7R0E4J8YjHN6exdmYr71DuQpc0qgoK?=
 =?us-ascii?Q?qzIWBoyLIXUgwio1ZGxKazWx3ErSLn73boyzI9vr7H32LkHHqIbexd1NcGUn?=
 =?us-ascii?Q?hYDL0hvF+/a30MiF5ad2731npmlwOnKnoAvqLWxOtjomR8tmUDMjxO7kljxu?=
 =?us-ascii?Q?uMNBgPqXCUxgW6U8j7VHREY0Du7jSK/e1ByGZmXleQBuT3vXzL3M+GBopDOE?=
 =?us-ascii?Q?WhwK0kjtmOkX16H8tSRWzxr7XsXFoOBWjxlYcIBevjG8wqO1uHck4PekvWz8?=
 =?us-ascii?Q?xhCSGbFMe5r300+kvm2w/EczrFvh8e8kRkaWN65Ka/bm5mL08KBXwq3yv722?=
 =?us-ascii?Q?GEc15SyyJYfP8BxdpKXp9hQXdzau0597YlbEAMYBBLG1/kQRclA/vM7iG1K/?=
 =?us-ascii?Q?JD9A7RgQ/sOJ7WT+gOo/J0wElSGW2AvnSYPT4PR+3tep87O3LMXJ7KIXs3Sr?=
 =?us-ascii?Q?8/Nf6CtA7PTjSp1ad+2Kql/VlLx72o9JF49OqO7i1cmx6c7us1n3K83pT24F?=
 =?us-ascii?Q?WwHxuS1JazYmNuseBtUt8vj1LYuETM3+BHApzBEPmc+0LOWpF8BBDuJxt3L/?=
 =?us-ascii?Q?DgzRW2ilBeDXMCriOSDCvB/Q++zOP96m2GdISxj8lT/wYeE3JFoxbXwJJHW2?=
 =?us-ascii?Q?Zer2yFBmUqznRpTf13N45Hgv85V8uRSJvljUVvg4Xfk1JvcxaIkHW5+Q9zZ3?=
 =?us-ascii?Q?lZi1LqBQhEgsfTd0qj2s8BKa81fTTgMExWlp7MVm4iIC/lmrY0k4a2m2FmQy?=
 =?us-ascii?Q?fkqBQFsneI9g7bg7Irwem+DFLs2pbCft9eEoRQrwv5lwGT4+kCCD4pv0GXLm?=
 =?us-ascii?Q?trY1MZBz9TVi3hAwGL3RmB5DJDF8nLFzhOziSy4hlHCRjHaPTvX8JoB14GHD?=
 =?us-ascii?Q?3ZBHC7u0V3PiOkme7PvkGLmHII14HbHIPeDs/UvmQGye8Y+M2pP+ynq1cEV6?=
 =?us-ascii?Q?jjEDaoRo/1vgPyp32+d5UT688UlH0vrYENp1BXh43ALLRv1owEMsajYou+2A?=
 =?us-ascii?Q?7vkrRgeVgWczEWb2x3hgsFcpiaFgK2PbbVfV+KZXqJTnmh5i/y4wwbWWcQbI?=
 =?us-ascii?Q?jx9CDiu7SYotvCkWPKynBe4GqS7ADBoqQFXGX+dO94qqd3Kd/IpgIkve+9aW?=
 =?us-ascii?Q?E7lEXePapnH7IIvBRg+9oKnj2dluhbYkHjA5xZKkF1NkmlB9Nz3rvFMm12i9?=
 =?us-ascii?Q?/Ss6j6HWT88JNEyLNbNAAW2O+Jf00ObNAiRzJI6ynH0cdWBmHUOpFu/2tWIz?=
 =?us-ascii?Q?0YPLIk2JPxiR5CuDKQmntdY4dzQJX5+Gjpk1/AxsjO9YDbo2W3zSQYCaH3/a?=
 =?us-ascii?Q?Kx5OPlmqVyuuI+dvXh/Iqd6DVCRU1mdqSjgu7iyWJTe4McFC976Epq3Uso5l?=
 =?us-ascii?Q?XQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DoI/mv3dmw67oYcYyFMYfs3m8+xWf13qX5VYASYGP25sG+/7CzYbvZEFui6lPp8K0bt2GuDvn9X/LYgvuwciPzxoKgLTaAkhAstl/tfJaT4ITeXXoRqzlYHwSoIeEmBkb0fIpmfWRBy2/zcZnKRYarpcKL8VNpvq92z5AahOs3484my08Np1sbU9NkOkLP4zDmYs73y8hnGzHZRANeUxihPiFmoXoMBg2C+v4CPaqsaq1JVYKBCQsQipU1tMLlWiAOlwh/wDvGkO1Dpy4fpIJlT0vKoJDcjrUUOMZgEwrUsS6Cv0GG9SPlTqjX8WWHNj8HqMJ/ka+j5Vy8ZxU5fYPhZOpUGIBiZw6sC5MIr5NGmsrwZY5iNfzIlbfDL7A8OtT//peAUYshjob668s/dI25rhsiEY6XY1jDfMOqDESoMwHUIbLFvV45rGiGW3OyIsnFkmUEbKYD6ZwJAhF09ABRjfj4RUTITF/a2f+2d+GPHcSfBeDE5OD7BtESO7vMJjVqX4PStPvbyQOdWrr6fggAWfMvuJIqjNyRzESMOJerpDjEshAK8bzIucsD7WLho9vader8v5c5YWKy2LdzOsD90Ui/66j+f3Ml7P7sp57Tg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b665d9c-707c-4828-4b74-08dd31bfeff3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 21:44:19.1722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hkjOxkAD+mfuIXGYT2i1Lda/2WYX0q2L05nR8lqGebMCZWQsRtH/YztZy5bnbfZ6WZSbf/LucUoshuVtGKVOgozBCEJBsfW16Fy/XztzJFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5094
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=881 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501100168
X-Proofpoint-ORIG-GUID: z1_cyoCHYWcm6EwbHN4CFXZ0pYyx4EIC
X-Proofpoint-GUID: z1_cyoCHYWcm6EwbHN4CFXZ0pYyx4EIC


> The reference count of the device incremented in device_initialize()
> is not decremented when device_add() fails. Add a put_device() call
> before returning from the function to decrement reference count for
> cleanup. Or it could cause memory leak.

60c5fd2e8f3c ("scsi: core: raid_class: Remove raid_component_add()")

-- 
Martin K. Petersen	Oracle Linux Engineering
