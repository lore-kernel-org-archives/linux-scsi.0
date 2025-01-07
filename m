Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443B1259499
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 01:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736211766; cv=fail; b=ueYoRF6tI9XvX72/tPWwdg+jWPJ6XvdymvgxpWcsVBk83GJ0Vk0MeOoWybAqzhhmSgR2aO/n6gaG5zPkmctUJ6HbENmRMEIbR1MqjHcSYO6qht9a43ZCygGCc6R9Kev2BA78DWMzf0tFIqaNyXnSj9x/XUzR5wEzEaYFxHHAhhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736211766; c=relaxed/simple;
	bh=l6SSt6MGtkqVkRJgf9ZkDG1gYI2sGHxhxxua31UoxuI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=mX0QtdZz5Su5Eg7RMzNNMDMWmDhxKyO7bQioCyH4YNVR86HIIo/JEbk7KzOvRe1jxWCZZTdqXOCaZ1UxzwsLxO+FDI1PlzD6HZuTgQ5qI5m+/9uXSKmXOquJpLJ7jYYQZv5KJCC7PPSUFBCTMr+pf9hxYja5a/iNH3QR4RIpMd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NWQxdLGT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YTYLx4gc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NWQxdLGT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YTYLx4gc"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 506Lfmfa025498;
	Tue, 7 Jan 2025 01:02:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=kSXS2U7IkUqRQmEq
	a35DkEfRERIE7B3Kx7tVClevqno=; b=NWQxdLGTS+IT0P12CNHGV7cNrEhXbLYc
	vG27vwef9kSNqDSEz/ZmEHfdVK3JseyLsUc5arw1DcL5t/7V5J/zlzgxAhjLVmM9
	F+myObYjrJ7sjN/FIBHM+bYqy4JoPdLfQMC2tdgEop2q6R0OmHfe9X3SIM89Gp5e
	g0lJUD83frZXSvwjbYUdI/0fjpdYchV8mX66Z/c3pAnqVxd/rJE6GpvceKHyrLqz
	Dp9YZHkuPnGNDCkaGInTpo/eWm5zBdu5oe2ZMzP7v9T9bmFxnqJdgNQCHOpqvSnW
	wHdoW9OsXwSyYXc59tVusXxfbQ6/QK9v3063CyTO0drYRYwqoo8fNw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuk03xsp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 01:02:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 506MP4kN011044;
	Tue, 7 Jan 2025 01:02:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xue7q020-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Jan 2025 01:02:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hjx65usiL5XE1hNRjYdPjR+RBKa/CYMp03VBDMvxDvU6+JWUsdyPQGrPPTAsAZFjdGHorX8RNKEwZkZEdUYt65Kkejk+wt75B6j/pFeI3Im9tdeAnPAZ5G8QTfLdnblte7wX8uzi/IAoy0ATFbXABFR1aERELwhI7SuBXRr9fxX1QRPCrgp7HfAiubht+pJABCPO369glRLAooAzvIF9MpcQEeVEgkAycRpsLo5TM+gya5xhRhbc1GXmknitCONTRkfrpTedoFVca+K2BbmaSH/E5omf+9yDlELYblNt4ESXreGi1IQfZGC+7DrHlYDuYxqdu+C0t1i7iLLiNPnZNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kSXS2U7IkUqRQmEqa35DkEfRERIE7B3Kx7tVClevqno=;
 b=nclwbB2yYrcg/HJUU2/kKQLQ4CUyWBDLG8tKzIXYgR0YwpfiLfWDJjCTN/bQDQ6rElRqR+pHqHp0nvITw/ansV4pMmZMMatoy+fzs3+UnCAdIkeW3zJ32K16TSnTYIMCL29G9CwlHDohJHU1aOmWz0j54w8RlGFCl7pzjXy3pkxWFaM7PHzshR8CpbEAXO7pWCNEOCMRVUPJJQjGqVQyJeQrQT9eBzMwe/VqDKfk/Of7RIurbi6PHlFOmmApZkRhVkmvOpltA/l1dm+ArpCmzU+8R+m9nz+j9xcMXP/MkLrxATUB+cZur55mWUXOeUPU44PGQC+RW/XONv52Gdf0+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSXS2U7IkUqRQmEqa35DkEfRERIE7B3Kx7tVClevqno=;
 b=YTYLx4gcR72uqNf1hxrSMapPDcH6wjBpfRKWRUZNG1fsFyZIUNbm5wbH1KjMh6pZn8BKbyUbMSQAFlD9CmGVgX+lUqx1v+0xRADkLbiPfOJ1Mk+TwU8c/g4pE9+D6eIjcWC8GMQSkfJ2Uo1ERXnDNvxghr0697FzhcGlVC+HcQA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB7303.namprd10.prod.outlook.com (2603:10b6:208:40d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Tue, 7 Jan
 2025 01:02:22 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%3]) with mapi id 15.20.8314.015; Tue, 7 Jan 2025
 01:02:22 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>,
        Kris Karas <bugs-a21@moonlit-rail.com>
Subject: [PATCH 1/1] scsi: Fix command pass through retry regression
Date: Mon,  6 Jan 2025 19:02:20 -0600
Message-ID: <20250107010220.7215-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::43) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB7303:EE_
X-MS-Office365-Filtering-Correlation-Id: fefcba48-1307-4553-3932-08dd2eb6f156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BGVZE6zACQOB/hiCiBgyufQsr90LUrGdoVkPuxjh/lrG+IXbjN/59BfHyD0I?=
 =?us-ascii?Q?Hrm+Mnd86rXRtgBPXYpYtj33sd6PdUlyTd7YdtxlP4BwI9marz4pzU/nHNJw?=
 =?us-ascii?Q?hWjVzk3XefF/S2nX6t01fdlQSAxeNrcB1uJJn9bTJqj3G3tIsT0GZ7bT2zD6?=
 =?us-ascii?Q?PQQHb5N54ooWPoXBYO4d+Wv17Gb8Ls3JGIRbY6WiCkb4188RRjRk4zbc/kOR?=
 =?us-ascii?Q?Puh/AQJNYO1x0PWpe6gMKXtP9Rrd5Uz6CXxYcf56GVDh/Vb/puSLP73Ryt8r?=
 =?us-ascii?Q?T94zg6GlrWLu3V+L/fDMuzNA6MTTVyyrxmMp/6L6/rmxzlKVds9XEmmttoQh?=
 =?us-ascii?Q?rQPgF2wRYc7Knlf+DmVvEVHhcutAWeWp4NvuMCHeGMGD3Sv39y32t0tHkqV2?=
 =?us-ascii?Q?x/p5jRhjJkNxNbTna8xgrSZYlOs/ZRaEbGktaAGqrMKEtJJRKEJEG+5y5iR6?=
 =?us-ascii?Q?O8cHxp1GlWsQYQfC9Wxj7KDoSyegDVKVveuMjFDOwgUo+L/GjvWfRvkYRm2F?=
 =?us-ascii?Q?IKpi9wOrAHGB6cxxobuyXpfl5tzaG9rhFWzF3m0vpkXMP7Ixl0epCYc5aTS/?=
 =?us-ascii?Q?F/u1DtdekpdKGSKUsacdp5rlaMMDvnPJB57242WXIOAg00WgGsggRWn++fq7?=
 =?us-ascii?Q?+0mmQwTXj4mmQFMkv6Iw59OX9RWQLiVWObVa0E6iGa+Y6cw7hzTMUK+KrdZy?=
 =?us-ascii?Q?/8/qt9DdVfZ3nSQm5ISdjDwhXjASInANVAC2dkd5ELWCVt6KIirRgHx3TDw1?=
 =?us-ascii?Q?s8YIcEilFmhVJmAaAYBe1JViVHmImlfxfWqzjpylJ79qSS1dZBdAq3ZN0rLN?=
 =?us-ascii?Q?B4K6/laXwGFdQ+Im1amd8nVlmPpuhPtl1n5LDr1akk74Pa8gRIvx1hMTlfTB?=
 =?us-ascii?Q?/V1VQ0hGUye4/8H+Ws+Qm/tL8fPxW+emzUET/aufYfrgZDWZhm8Ty9+mMhXr?=
 =?us-ascii?Q?oy+lh+raX2bXdE1d4yzeSgxcymup7QmdhU3SzPlB5RFdkgAmRM5tD1dsuInB?=
 =?us-ascii?Q?kdEagAcInmIiJFGkjVhbbGLjWwm00yJudwXKDWnO7JgDEgz6gjsbuW2mWjrt?=
 =?us-ascii?Q?2Zfaw/skUTCMyDoCi+k6ThNjqWn0W/nyvIZnEKtndbMo+6ni9m56dzDb68OR?=
 =?us-ascii?Q?r+/RkeWI7AQbdZT/KmPUTTsAR6X7JIjxWvPIPwBXTDPmv4TVTZy0gF52H1Ok?=
 =?us-ascii?Q?qM0r1eUYWyXMo5ZeR0kW6ZwhiwiADD+AHtZ3/gW8COg7o5FVUMDPwrkGh85S?=
 =?us-ascii?Q?iTzeYmXfN2quBnwnIzMVYqdOUKkPFRjNfo3uvGJiR3j5Ltq3f505WI5IOez2?=
 =?us-ascii?Q?Qvyh7QmpfiTlDazcDlT4hN1vTcZpgDDrmWKYxstgM4C59m78vyKdiSem+1ds?=
 =?us-ascii?Q?7LFc1DaGKbH7pIOrKIPj1tnyKQeg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TQzPaRJ/Kt+g73/GDghBY7trQZEdncPeZq4D78HBx0/88E1Q5X3Nr3tbTnDk?=
 =?us-ascii?Q?XxT07fRW+N/E+7fI6PRglbhn4Grd7y/Hyq2HcNwMA/xJfT5C8tff9NSBrRGk?=
 =?us-ascii?Q?leIkNHe+usrucUhcv/owfFJ1BY3ixz0C1fC7lb7hQe0TBEJ13sgvsb8BfIap?=
 =?us-ascii?Q?qmpEC5+VLamt6I+gE2lR8g6TktKkVK4wcwVzWPOBJ/HnBVB+9EtAffJkDPVk?=
 =?us-ascii?Q?k51VK4oZlfBjhBaLT2TkXMCGSpEO8yRbF7Uce6/ChFAWKXRZCeOQ+45sz/ck?=
 =?us-ascii?Q?73lwwZ/uGAmkvS9blur1hdZ8WUsGI1WdIVsQSueXRHvxZ6dj2gX4wy27/7Ou?=
 =?us-ascii?Q?tu/taMp/zwgXElJjXQPGpfAdA6jdwG/go7J7OzDSlDcesx4L+ZYprASrBIqi?=
 =?us-ascii?Q?6cvaWHTLkTh0mIUdMeX9qfIXDFrj5V6JfXqAduynxuzTyqHD1Qzl2LSxPxx5?=
 =?us-ascii?Q?zMz/esUjvKm/b9lpxVcAknPHd0ViQvQEJP9d3Fs9q82WpOzuhzxb6KxJVZht?=
 =?us-ascii?Q?4tvuzeLIlGAioOTWKLEegcyo2UrfEfz/xnq6mPaWRn3MQd3JFy1hsaQqszjL?=
 =?us-ascii?Q?d5ux3m4sexCwrsfXArkI++OG/qxqwgB3Uu9ml2Wb4LLk7CAzIQhQdbJ7B5JP?=
 =?us-ascii?Q?DkQ7V4Xi0PVMXvC8vkNsPXoQapWfuMCui3dWTpB4ui5wjl490vmaxxjLHhIK?=
 =?us-ascii?Q?YIqv9vICS56qurMaVh2yoaCaQF3L/1lTR+OYInM1JVfhTKJgXsUEratiBARM?=
 =?us-ascii?Q?IUBqR291X/J64t3HV3Rw1bws1gdLRKO/qLWPDDb6uOPNR9ai61Sni8fi4lAs?=
 =?us-ascii?Q?N8c7yERLkoVbutmnJZGtvZ8ylpquGE1xzxlq56U/i3eQNah5w1oBz3PsaMli?=
 =?us-ascii?Q?Tvs9ZOsFooQA7lYAuzG1Ork7gEKCspA4NWuLBfNnmy59bILTenMrFhDcaaB8?=
 =?us-ascii?Q?9pQWZ1Ir5DGrunTXMtZqh7KkGWhXOZ5BvwoquSk71PJfox9BRzMGGXm9swYu?=
 =?us-ascii?Q?qk92LEfMrEveKnO4395N0MdEhUHY93N1qclH7yN4vhFeDCgd3aVTfjNTkArH?=
 =?us-ascii?Q?0KLV/+L9RR9tfJC9pJLm//bY84vc6DM29HKbSmHY+8fQDlbm+fucKK5k1gYZ?=
 =?us-ascii?Q?mBbRA0XnT/Z9lmFdCFTpx3pNQcHumWJDnlljNDxX6pAcgufaoGCnOOP/DLGT?=
 =?us-ascii?Q?qVEncTJchY194dzlTf6C3g5+K+/X/kimzarXDOsjySgu1ue9uO610XaZrYEO?=
 =?us-ascii?Q?2ayDuaIYTnFwmIGlbHkeGL1THew1iEj4kDDBrWFtyVw5ADW2JskgCwdU154w?=
 =?us-ascii?Q?AK/XPQhM2hNf7ET4TyV3qcquTKsEybp4yPHn+mRQybwR2Sdceo6etq62Esam?=
 =?us-ascii?Q?PG2IY7IdPaeTkbNZ0eh37ar0i73zGReYwSOsIwDgta6s5MHYqfHPmS91rHMq?=
 =?us-ascii?Q?rCPvvra1HWCvGtL6ihyk3NHSg5sh2n8BkeAffgwv6e5qFIYuz5oueWhy9Ww+?=
 =?us-ascii?Q?EVISGhx9k1gmnM0F1El5piOj/FbM/uByfjmf49rmPbUjh9vPKhzx+ymM6XxY?=
 =?us-ascii?Q?MOuCtQViG9H98J2Hfj26LlkoW0vkvv56MHa7kaaDVMu2w1V4Sn755XDzlGHr?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ad2rWoZ2m/FOfnupFhJ5ytKfDj/osFRdhyxtLT1YNx8GNGwRweW1qzBydmSQ3LnRJ9/ZY9MwjZxeX1vmN+0IwcD3tw7krDhyBZ2VDs8MYV3DlWihshdk+1y1neJLJArcB9sZJMtjh+JwUircRlW5PFcMMRvLCYtBH9l6BeqbFiNHEuuWOp0s4/bgHrzEyH28ChXDjhqVRWFQBiHieaIJXK6MrUyOWCoEGz/nbh5iT70WGa4EaVu+wrWMqKfgTbrIrrXvpNv/otfwHZwuHRQmV0Enr+pgj/bp42HsiBHXYroltZ18k1LIuKdAgWfShInYrxk3zDE/cntXm9iCXwUH0d5+yszmFeplye1xDdXzz9mKAxJ+cQE1LRuOSTEVeOV8YHjP8IBnHL7D8uUftt9afKSNjDXe3tQDWt1BHZOKS/ZOLXGTXMOQos1DLVdzSh3NKWw8oZlLu8ZMHwZsaeyTh3opbRzQoI7wuMY7YiNtn+XXiOGiM2Dsm8hwX2qbBR1Kz09JRlI9pzoOSoCTMcF2goKCPQqOJ5WSi0VVEG8wxYVFpibYrOStwURJ3FLCPKs2g3PQ2SWO40cMUsKXTQkcfwiQrcwZ/o8ovgzFc17hBZg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fefcba48-1307-4553-3932-08dd2eb6f156
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 01:02:22.5989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8x6tsFkJ3rA+wLklFrzRblSsaTKJxvCigREAOMBJghmxMspaikRs3mVB8O4xx9bCJn6uvOB6wRkSKQ3nZ/dBSq5Rn/dqshAdufvjIEFlrZ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7303
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501070005
X-Proofpoint-ORIG-GUID: Dq0ZbswoW1o6bCwDDXTp4oIKw_uqk8Uq
X-Proofpoint-GUID: Dq0ZbswoW1o6bCwDDXTp4oIKw_uqk8Uq

scsi_check_passthrough is always called, but it doesn't check for if a
command completed successfully. As a result, if a command was successful
and the caller used SCMD_FAILURE_RESULT_ANY to indicate what failures it
wanted to retry, we will end up retrying the command. This will cause
delays during device discovery because of the command being sent multiple
times. For some USB devices it can also cause the wrong device size to be
used.

This patch adds a check for if the command was successful. If it is we
return immediately instead of trying to match a failure.

Fixes: 994724e6b3f0 ("scsi: core: Allow passthrough to request midlayer retries")
Reported-by: Kris Karas <bugs-a21@moonlit-rail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219652
Signed-off-by: Mike Christie <michael.christie@oracle.com>

---
 drivers/scsi/scsi_lib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index adee6f60c966..0cc6a0f77b09 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -210,6 +210,9 @@ static int scsi_check_passthrough(struct scsi_cmnd *scmd,
 	struct scsi_sense_hdr sshdr;
 	enum sam_status status;
 
+	if (!scmd->result)
+		return 0;
+
 	if (!failures)
 		return 0;
 
-- 
2.43.0

