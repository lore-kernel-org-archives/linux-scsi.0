Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7470728EF
	for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2024 01:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714007552; cv=fail; b=q/LGgeidG86zrzJcnloKk5Jo/kUJSsU+FiDlUQYrPvQ8yg3MLqyGnL6jmXzcJf1Zm2O6bWUx4ogGv4NXnanTMGf29xgRsl35g6xdvJ7607hQ5Ggsd6GmfAFaHhq0KIYoz8t+OOT/3E2UxHzZK2ZIZGNSxiReeQ0dyBxb1X/BZRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714007552; c=relaxed/simple;
	bh=VlUsJZBdGT421px0bgW00aq8/BLwf2BwbdYzSYlVjro=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lDrHpo8e+beJu18DP0+X8UGDmELvDUhTUUzyEB4M9I71X7WyycCvzHcxyzsYkspbF0eri2XaURpCKMSQDYtom8oO0R2cB3OxgTieyhyHVdL2FoBTPIlkh+TSuXqy77dB8rfPqAg95QFs0uEWXJJxLZnaPk80AqrYkjIIrE1WDCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=moCtk+w2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZsbCkFN3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="moCtk+w2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZsbCkFN3"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P0il35015826;
	Thu, 25 Apr 2024 01:12:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=ptHxOZ+SGr4P3erSHt1pz3BWcJDsqmi3F3nwgfQldN4=;
 b=moCtk+w2omr3ghHcf/LSSW20u8J3JcOXhFH0On0NBW42bd97+Kx/C3AlnTE7DTR2zRYf
 KK87E2flZ/iub2vgk3IznhwrA4Yv1TvkdC4X+ugGmJhEfmbmmKUOlIdtyt/Q7+Oc4+09
 TJgRKWOOHoowwxXio12H1G3mJAjQ35sgwKjmDqB1C2qTsHzjaWe32Uo4fgdfl4QD6Dfi
 azRNUWePS4qY53lrvhwFGwy3X8EFgR5xHq1V36kghSckiLuspZ3+GKX4E5tSa/N6g2eV
 QRl7KOcIF+MXYuFW9S1dsarTlMStkUoMkDfOH29audnU6fwmAhHT4s77TmADYlhCHBJG Ug== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm44f1bp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:12:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43ONTqsd035632;
	Thu, 25 Apr 2024 01:12:25 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xm459nacu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:12:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0aDdfteKVAAUJuQQZbeDdymC4Yjg+yfuKQnAY8L0HajZziKX2593d0LZEJwHEp1n+zRkJDjFw8PHICVbAbiGOEnomD9z89AH94DZGwxBGrJ/OWT3A8EIm5/YF+b2NCg2jmOgiJi+PuCidLFkWuViFWYL6ehUHj5iV1WGIE9eJrlFFB73fFA14GEswSzgRIB6QSVhL3urGG5Pbf+3ui/CzfcSwOYptgi7xLYj1eg/z8730Sz1EXieGtHAm1dqzWe/t4JmvucsKwAqNrV39PE8q7waTWVUMDjh3ktmRMFWJTIwiGnxXeZjBS/WogCGoNs1TYlxZDmFgf6mWShwGZ2ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptHxOZ+SGr4P3erSHt1pz3BWcJDsqmi3F3nwgfQldN4=;
 b=QfCjv+iIlvOk4EkwBNRmFJcxqGPW/DnhxoM744RJ1Q4L8sci4FXd31fmc6UnmZ+CUk9hL9Ve8ruCkb5hXBVh8YeP+Qb3CE/bFd+tsEqpKqlfNc1HnR0AIVFRekTmN3QHxJOtn1/7V396UTvNs5DmYPnJ5m4cB/sjFtKb71XMoJNJzv/+1qQvtrivlRRCsnHMOjawr5TInW+qzYYhoC7lk8bFfRv6MVwosXpZ3fhpgTSnK5erAvxoO9nFGGf3Bbo4TGxgaNaBjj2NDb+jWqa6X2v6TrYpI8401tIKeGnXkfXtse1h3esA9Wv+05ZcOlh+DRAPKjI31WNiGFGQm5iBeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptHxOZ+SGr4P3erSHt1pz3BWcJDsqmi3F3nwgfQldN4=;
 b=ZsbCkFN39BkL5yNr/7uaM/b5wCyMXgpjvPSCX/X6FSCv6OcvlgQXg0I05VSQA7DLCZUKIYuqGXfcvTqndKfNEcNs4RJU97X0AC4hL2bLbRYcSprQ16GlsMYoDLyQQNKdIaxGjJbJL94gymo2vicae4q4Xx4uTT0YuO0/aKI8x7c=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 01:12:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7472.045; Thu, 25 Apr 2024
 01:12:23 +0000
To: Saurav Kashyap <skashyap@marvell.com>
Cc: <martin.petersen@oracle.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] qedf: Fix uninitalize warning from kernel test robot.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240415073654.31859-1-skashyap@marvell.com> (Saurav Kashyap's
	message of "Mon, 15 Apr 2024 13:06:54 +0530")
Organization: Oracle Corporation
Message-ID: <yq1h6fq8cv3.fsf@ca-mkp.ca.oracle.com>
References: <20240415073654.31859-1-skashyap@marvell.com>
Date: Wed, 24 Apr 2024 21:12:21 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH0P220CA0027.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB4835:EE_
X-MS-Office365-Filtering-Correlation-Id: 4111588e-17f2-4e3a-906b-08dc64c4c335
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?T7806gzdqJLC710NySOjVLjW74CgtBtORMOBhdDS2WvY8Y8Y79/XMQOucd77?=
 =?us-ascii?Q?ci489OOtEg6tH9AGn6iLrWBBWn91kOuvhpGq/a+VBNyoyjkuRXdnQbA/MxIr?=
 =?us-ascii?Q?/jrH7Nx3P/DjPC76sM+9x4r80X1gCKWQHmnYp6RJzSflDRZRUWpfgw+DS415?=
 =?us-ascii?Q?43RG1fGM0YKKjd/wgAd5mBOoAtbrzSzm0Dsn4BbPKB1ip0gXQ9mMw8jknqGY?=
 =?us-ascii?Q?MiK67WhDpAX/EyTgRL+wsFUXS7BtuoCnbVDBuYMExIf9qyADiSCTfg6TO0NO?=
 =?us-ascii?Q?9A/RgmPgnzpA/8Aj+EA0Wry2fs/pKKPEe7SbEzO4CECDorw6eezXzqlRD9Ds?=
 =?us-ascii?Q?MELyqzCXaMszoDsG3QfVMxAYuwmqLuoILFoQmYRi2UFyhDBMbYq5vlledACm?=
 =?us-ascii?Q?86cYzvjgeEE/dPEk2tHaJl5Ezq9i5pL/vtDT3VNo6mEUv6EoedPjpdKManq+?=
 =?us-ascii?Q?tJRDQhHHdLZBZADp+WftenjABsvfhYv0Y4zq2G34WtTE885H3DgF3wwcWjmS?=
 =?us-ascii?Q?4DDXrvknuX67w0wFI9CINACkQv6zlhl7X7o0FCG03DPE1m08wdxBpJ8w8Xq4?=
 =?us-ascii?Q?t9nXn4uevhosPKspAwCY4B28OOoMHUYdsBe9BGRyJXO6qTVmlTfKIf3J+D/l?=
 =?us-ascii?Q?ecnWy+TO/VoZ+0chtLepg3P5mT4mJTBK0SeGxCSsKfKoHvIWLgmaUBl5nAhV?=
 =?us-ascii?Q?7765ZGWfbsdS+t8AU4oZKtGN7Hn6Qo2sB+AjiZWBVjDEAyLGXeepNpRC4rSC?=
 =?us-ascii?Q?yTK8dBGknuLj8KTnG1yCrnH4FNseLGhADUpDTo0qfPfpK30bGQDXDTJergJf?=
 =?us-ascii?Q?O8ZjZGLTmH2qA2VED12vab8+5qdTDcFa/xdXWj08eiYUWpCSJlKwUGpBJKk5?=
 =?us-ascii?Q?Tc8FWXcsvqy/931UaTgdQXztBlO3AmDb+ZG5qUMgyWVdjODgZEIUBcm05hOk?=
 =?us-ascii?Q?KS1E0SI4DGL0a1QHRyvGtkakl8obYgYRrUMDETJc4FTfx0Z1QIYnHjqaU5f4?=
 =?us-ascii?Q?h1NLCyo3mKiFvA+9GiIjX9U0TA7U/lKuCnrMv2mJEEzHXLE1QXG4ERvoRHie?=
 =?us-ascii?Q?bTSTNG6yXKSVPYXuHc+6Kx2XXPvTXSaTFYh3RGp727FX4/3IaoJXVmBT11ba?=
 =?us-ascii?Q?74VXsnzYy9qvyAIp4S+/jLpfX2bgiy7D+cZ0ldxTPQDwMKdS0+B+vzcTvqlI?=
 =?us-ascii?Q?sTJVPWixRQ0u/J2YvQJ9bO+KGWM4njwvKVGV6uwawYvK19xcwQKseJdNTutp?=
 =?us-ascii?Q?n1VihCtgnY/D0IwZWi7qyL/sJ/JBfqTPmfj8/B+Whw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Ej1mDYGPTZCnHqMHjKOFNJolAqAfLeHSwHVM95NqnGY7YQe4Q+xZBIqI5C91?=
 =?us-ascii?Q?3CTAXu0NeD0q23VCkILwjrA1qUh/4QHBRzTafDbh8fZimQ9VVT71y4nfoRLH?=
 =?us-ascii?Q?WSYIN9puaZuF+Fq4epXnM3LV5uqqt+jpYT+GpNwsY9Q1rRQto07+GvHOgyZJ?=
 =?us-ascii?Q?pLQvHP3C5UD3u3ZwrAtcxgQNRj97UtXqrycg1wH36zjyenhNUtgR4KDqw8zE?=
 =?us-ascii?Q?7Kdc7y8yL5zhksWgrVu/nXmYawFx0LKJ3Bf3itXW4WWWWen129weMV/Y0ycO?=
 =?us-ascii?Q?pn98Y7aqk2KjjmOkBGFIhZK+D9GsbpoycFQMB8c7hfncfXzVxhSKqwgfmsnW?=
 =?us-ascii?Q?/kk5eDBTC4jj8Wa2lWw31BUigEIvCTVixfcKoL4Lmr5nY39gbvt9MbULx1r5?=
 =?us-ascii?Q?PypI4Ky1B7w+aYZwkbwjxf+GjD8CqV4pNmDQC28P/qJThBsow0E5rwT/11qD?=
 =?us-ascii?Q?IrBVhMK/zzm4yE6LB0xROhYCNOzOZurV+AgKA02rxXRiZ54IZeKPjSfVjxIA?=
 =?us-ascii?Q?c4m3AtD2vewBAipM6DEt1HieIGWONh4qud6AnjuJ9F6Ei+bhpnCWpvgTbzSQ?=
 =?us-ascii?Q?PloSzICsK7PoN2wrDg6gzTkrFCGeEkAabltFPmY6quaFj9mi3rwXOv0bmhHx?=
 =?us-ascii?Q?un7oLPXM1o2Lz2PiLbHXKprpNVC2SQMplRCkNk6SL7OXSVY4RTpqzjLN4s4X?=
 =?us-ascii?Q?wQAV77AnIy3qOix3WI4gDQDEZOmNA3NtY3mArgOlpH+mWqmr9EGdO2wMThG4?=
 =?us-ascii?Q?kQuD3GCoISpu1Tziu5hNqb/HQRg2sCYfNrQHwRiPJOKSJ7r33WlWYCA+v92R?=
 =?us-ascii?Q?YYQvyoiA+r5ZhqdCiu1PNM8FRx26ukz0zV8P35vjA33QQAdKTxBEwMwAk+g2?=
 =?us-ascii?Q?Iq0MOSV9uyMMM3/XKEHeTflO0fpeSOlvWVBRaLgSVZCXFaPvMPtdpR1hfpRp?=
 =?us-ascii?Q?8Fh5F3Oo+7G8ZsWpoxAEUIAw0+5en48mOQ/hzViow30R1EPSEArKzXr4kNVY?=
 =?us-ascii?Q?jvedURhy8U+KyLSVVuL+TSP/QOf1OkGMHMkZzFSR+pmquZ+wdFWokYaXc8E+?=
 =?us-ascii?Q?043OZQTte128JdJZ7roOrr1wSzmh0lsQHJvuY98OFK2xKki/ZB/BQfw5MkkD?=
 =?us-ascii?Q?v8nuMx12SOEx72SzEkEaJDHDJZb+yQc6sJJdCnclKu/ckYRD9LoD2f/EMQcb?=
 =?us-ascii?Q?q8XGmEFNJJR5m8QhMWDkdrU4r0k3Kq2h82ABVqV5TL7eE6DPx2t/ZBxxHIBq?=
 =?us-ascii?Q?f4p4d0n/GdphaY7NlXjTa6PGEn+VfYO7clFE9DfMHu02uIOufOzsMrSOvfKQ?=
 =?us-ascii?Q?fhsjLMnsPZUrytaJaiA0bEm9uDbipBKOc/2YwcZ7Ce41ZZxMYaQ/qGAZd73a?=
 =?us-ascii?Q?izbZRBiAC5MD7TwOdD6nxZ3UfNvP1q/kT78G0MzoZI4E6mOvp0JhLa5KLJGI?=
 =?us-ascii?Q?1LWvkwi3qMkKDOnFqfSMvGgiCU8DA8+3IVS4oALZO7moAA6iGCZ7w26SM+XT?=
 =?us-ascii?Q?SdzgALF9AzsMDuDlR4pP9/Xxraf0xvaFeaI3DZclCINvgrABmG7dJEbSRtVy?=
 =?us-ascii?Q?9X9nvgYr/Oxk3YcZNBYL/1PVms21EXIfwKJmHLYun7XG+3OkGLhi9NhemMnW?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	NJs1FD/5pi+qdlJ8bxgE3ZlHadOAf9VwkZgXowEGewbkvfVPArJIFvz0P93Xl8E1BdvFcWrBCsS5z7MCMtuTOBb/fCAxoPmERvlr/PAciHZ/Xh+irtEm7UrJ20Zs701bMrAqpE/DL2mTw5SFCsqS6KGiO02CVPCURTUPCSxWVK3oUlWJVpj4KhuPXwSUYwcaQLG9VnZuo6NFHHHsz5HhKxV4PyXoJQNGeQaVnPU7Z7N1TWHa6lC/QpvsGpis8Bv8P7iVnecVm3Z3AzuvZI2byGjPnDWOQnXuxctc86zfU2iG3HJU+siBkP1JmslpkuCR7hfSeYSgayevqTzgEsNZQrQ2Sf6cwdTCGtHGTiLSwkqn8iJXr4wMCKHEQX6lxmKv+0k2ZRoQlEARbNU5POnNxQD1vxcgoLksUshsYW5oUZG2G7PLf0MrCIw0WlU6q3TeGEQ2/cAi8E9qgsTyQT/RBibFPRmHolk7C3O7Xy+iZFwXQlKG0+VioyTSArRcpMK2QOtRNCCsAypFHi86614uulGZgyQdfXTj68/bZnj/giCxRmofzBNSDGoZC5i7rg1FJfTJehrots46R4OmXDavznXgUEFTWoPEQAuN61Lowx8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4111588e-17f2-4e3a-906b-08dc64c4c335
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 01:12:23.2737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dvb9iCn+sxN0PPrzSrLnlF9clS4ekIYWDA+G1e78knXDhg2Pxqgp3DhaDqkxgBo6lrX+IT4jXazr2obJmFFsSWMdHDmXHdBdAZrtZWWiPz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4835
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_21,2024-04-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=864
 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404250007
X-Proofpoint-ORIG-GUID: IpQ1F44mPl5B7oFPg4OPnapRmaO-Zo9-
X-Proofpoint-GUID: IpQ1F44mPl5B7oFPg4OPnapRmaO-Zo9-


Saurav,

> Fixes uininitalize qedf warning.

Please send a v2 of the series with this fix applied.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
