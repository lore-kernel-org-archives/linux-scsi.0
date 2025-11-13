Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DB315ADB4
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 13:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041034; cv=fail; b=pXS91vjX929Z9dYFk9BhFd2ngsjcRTEcuRiaSWSt8LeX1mE9LDOIS9bOutDPIXDD3r3ICbPGWYj2AxNEJ+OqyE7y2Ru4DE23UPd0iHrgpNKV5yDrIbT7Dirk9GAd4oAuTbS+FAqS/VTtdZxkoQ6DYp5a+S7Opl+hC2gL5YHc9iE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041034; c=relaxed/simple;
	bh=M/SzisRrR1kCx9Fctd/bb1J9xf4GeJBFHdGwnXAvhiA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=j4OnrAJmmrRiepwMQa2lQQxx8LRcBgfsix8I9a4Mi51hL7kF7hZ7eYYLAcbOBUyGTvDxuQOsQDCPprcuF0uzkXpNyc7mJl6BpMoRecItP/egrbgThayNbaxMyWSZPxT/wU7+L1Hkj6A57fK/FfJmEORUuor1YJpt6pDl9/FAdds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bbm2+0Ht; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ilOwRmc/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bbm2+0Ht";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ilOwRmc/"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADCiOoc004002;
	Thu, 13 Nov 2025 13:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=Rhi+QMPg6l4grBtO
	oqNqOkk8QCW8hjNPAmYy5iKT8Vg=; b=bbm2+0HtkYK+a+fyARS1UDXWdWq6Rzyz
	GQNZlvtMkZqIZGUXyqe3tjcCFofVvF9Y5BOnZDKmixQNo0uSdSiJvKK4LJTBOmB8
	M7mLsFnVHTlPZhkt/sjMzK/pvNhdVZQj7z9cfo1R/oNlXwULL+yUIutUo425LG7W
	YBsO/BvDh+X1DSsEr/kAtS4vH4gACSmldaVvnu6j6wtYyTxCS5dJUXRe9bdUG6/o
	jffpLJn00BpsHW2Ao0u0aDxXU2/WGH4807wGXBwTAZS1dGkOtVfAo8F5vTyM7Fz1
	5c2ypCYr8A3rlQPfN7ATckNqZ8uBs8OFqnl5tTsgJwiD5JgQ4xVa6g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acxwq1t2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:36:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADC0pWm010922;
	Thu, 13 Nov 2025 13:36:57 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012021.outbound.protection.outlook.com [52.101.48.21])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vanwaar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:36:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wgGkrCT7FkGRunaLWa7vteXUm1f0DgGKkerAAJB/3otr22ncByMeOs5gmI39UkFufp1O0B6IG6s1c/NImaso5Q/iolZQCnIN6qLheR5fdQY5u6VAKEatiYcMBh0oh3fKcSeq82EdZ4P9ecIGMHg+4oGrKqYdNWxlcMC+aECeo1Py5GgBfC3HWLahbwlLSvv5OyUmaPMaeql5o+rmV3VJEpMrErPxltTDOKtxOpoGYdXpma0cY98SGYLF7Tn7eXa+GtXwcR+Q7UstzkUfHfVoBOfDu37RyYvGxWnxtl1KEtbzfR3pGxjte+M50+Kwa8OPm8dp/uhxAP9iS2JVWeWPIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rhi+QMPg6l4grBtOoqNqOkk8QCW8hjNPAmYy5iKT8Vg=;
 b=VfpbAkZbKa99rNu8FZPkxGIjQ3NWWuDbjs+n9HAq2E8DdbjZdQqi/9DgLetKj/UhsXxKexOM46c2WSNj/A452259jCHgXdizG4Q6rXha5duoKY+uUgv3/aKzwxWv8wD2KTfKpzBnZNIKdk99C7lrDcaMuz5+oNB7XFenPOL2b1e8sZyj3ko3sJOkTk9OSCLUdKrz85zyp9zB3kcEI5vKWYiTgQHPTq87Dljhq/uv0ovmlsSGG5Vl74Y9DLCymAZhnaIZXUwhGA/dnALjTeA2uGHzP7s6MeVVRv6N+FNG0JX2yVPcOcGx3WtIRL4FaV03mOH0Wm7uAWzJS8TnzraIoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rhi+QMPg6l4grBtOoqNqOkk8QCW8hjNPAmYy5iKT8Vg=;
 b=ilOwRmc/J0nGFKtKxhAR3ka7eITNQVO9Ef5MRKd4hyrlUMGb/3WE6Hn8laS3eXDL3G2o2WPJXo10XDguStpYRsR8cgnRokVvkawrSVXO//srqxOQAe2/fLQiVoVSBpGfpEn+/LLMNgy1aC5vKbwvpfIULvw/rE9lCKVNuaNXfd4=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by BLAPR10MB4948.namprd10.prod.outlook.com (2603:10b6:208:307::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 13:36:52 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Thu, 13 Nov 2025
 13:36:52 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, jiangjianjun3@huawei.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFT 0/6] scsi_debug: fake timeout handling improvements
Date: Thu, 13 Nov 2025 13:36:39 +0000
Message-ID: <20251113133645.2898748-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P220CA0125.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:327::18) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|BLAPR10MB4948:EE_
X-MS-Office365-Filtering-Correlation-Id: 33b2a710-4138-46e2-982c-08de22b9b487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?43jUvp7QxMTqLKj06/jCt0FsUAK7LsW/NYpqp0wwWnePlRPD6Fj2j8dOUcvp?=
 =?us-ascii?Q?mQIpfwiF8TdBVK7mFOAF9rIb3LMEGawYUGv7MIXLUTfTkp2KL3c2Wi6rEn7H?=
 =?us-ascii?Q?DjSpMFzVvmGRgoTQBEmaV0sG5jEbUHpncmjncSD+sxoVHY+mtQ3Xfi7xVwHL?=
 =?us-ascii?Q?+o4CJeXgtmDdfPjSmC+YS9TzTu/o3pwikJ5ObxwYbWtm60jPW1eumAXIk2m8?=
 =?us-ascii?Q?f94JZ6G4EtrUDy1+9HIQW8IEwvAu0PL9Nyny/2bRmzAM5ke6v0atJc601HF4?=
 =?us-ascii?Q?4tkP3Ncp8Y5uoGRwtOoN7/4rr+zrdWzO80kOO6TRrFKItVwW6Ulj9/k0o4XL?=
 =?us-ascii?Q?rLJW2RYfQOl5fzVDprwLu7O+Rerys+WN3jWkgtVf9FW0xGtYqqZn3OC9P54c?=
 =?us-ascii?Q?1VbueGUbaxYZOHFo/l8K9GJCRNfmU0kmj4CHYqHGrGVtBRqEWo3u8AEXjQHy?=
 =?us-ascii?Q?Bo0U+5UgCHHUlQ1QBZ582NGw5tux5SIEZojKV5ICdTy5Hi+/wk9nReQU15XJ?=
 =?us-ascii?Q?nO4zvGfwj9rLAmMvxg0sV3WB/RUpW+2qU66P0RKVaKxZsYCwrmIjs+96e+Vx?=
 =?us-ascii?Q?JycJcWj0nyZBrAR6B1e3xJTILCqZDx41id9zYfUuD1Jioso8lPb0FknQuAMF?=
 =?us-ascii?Q?4rwr4TnkR4o0dyaQ8fkRVauEZvMJv5w8Lw3Xjp8x3QsUG4teooSIT1GXrFJs?=
 =?us-ascii?Q?mQk/D95EvYQHeBmiUr9+oPgj66OA8lTUJppC1SrzoU3IPp/AaRe2kAcODp72?=
 =?us-ascii?Q?7oCWr2WGnhwx21cH/3xO8joHQbHV+PWs9cOEFGVXI5HWeT3UV2wavJd8b1mj?=
 =?us-ascii?Q?OIuBQVfWGPKRhZkU85umseayBr0EW4aaAezhl84PRZiQUpf1kb3pCD+3yieh?=
 =?us-ascii?Q?Glpr+i1sjFmVu2RunUjQ5qqVlur+5w9ZW9Z/st5SYDmyq4jQNTFJaODbSD2v?=
 =?us-ascii?Q?sfvGumNZ2TVrAxIky2bYHBucGYVpB/taRezqxwzsgqRz8tAlmTUdOAF94qwE?=
 =?us-ascii?Q?slTDPnjdixXa4q3LqEhn5R+he0G3tb8wXmiT31d771ar9f23yfCaSeFTTip3?=
 =?us-ascii?Q?k/0lGg1rPoQJuO+RZ30pbQjVlC1dGP9v6kRGzlel/hzLQL+ErO8PTYKGPb2L?=
 =?us-ascii?Q?Jda4kuCLxT/QZ34O9dVFFCCbxjRfxjjL9KZDkpWFFTiP3GQjo2yjPY4NmW/y?=
 =?us-ascii?Q?P4h7y6/AbknjX44dECdClRPNKnrvcHHteAU/2Z81iq6CVUas/ueeQTPM7VOb?=
 =?us-ascii?Q?JbMVTIACtlbUXF0fejk2ZGEUbBWcUp3WvBpc+lamiseKMSmmtGPD9DBSbb0Y?=
 =?us-ascii?Q?s3rpeGKLhVJSZRCHkap9GqwLLeCm49SsMa1yxGOV7Gc6w7NmFYK0D37YfUTL?=
 =?us-ascii?Q?wjV6YuhuJngs3E9CkPcAYve8MAmdYZtJQiAsi2beJQn0HPcaeA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GSllc03mwdza+05Hr5e0Qftc3eiK/95M5Z965n2j1DH7dNrfyDJ4OFL6Sgqo?=
 =?us-ascii?Q?pUeV/ki6YrpdI6vC7eJp+4VcD/8QgCi3IP5qbfIP3Csy+8SlHGIrLwWT3QvD?=
 =?us-ascii?Q?fgothvroBOvHphYSjR4FgldDZZblWiocoFZZwmgwIJZvi6usAo5m2MJjQUD4?=
 =?us-ascii?Q?Iwp5WRN6+R8T7kFYqQgQD9UqMBulWugGmxZo2NKJAkEtgYCS3ysHkhBcXC7H?=
 =?us-ascii?Q?GG6Q7gZZzNDugPTrRi4DdPVvVrvIFQSZNJZ9/4K+fVyBJvfcH8bUao+kSoU/?=
 =?us-ascii?Q?ZIm1q7SWiV3YHWNKIjjQ1VHlvfWvx7ceEq0TstWHO2miZfTJNhiGeavPKNFh?=
 =?us-ascii?Q?SXPLXiE1VVx8JMoNjLTTywxzZ/YhsDVKNuE3TS93jh7ZFvMwwKsVzzwGIY00?=
 =?us-ascii?Q?jeNx4DgiND7CTcdvK/ODt2LaqKKAXQReNKFBsfLpuYyEkw1IfFSmK+2+WGU0?=
 =?us-ascii?Q?AWURaBwUgHwbL7yukUpKa8qH1PmszJW0lw0Wpn4b0XHgtMgB0A2CDTzQS+R7?=
 =?us-ascii?Q?wrl3KM9wySXsn6pLzHXssWjpGMt+xdXVpVfQFuLXTy9yjvS7FNSQZKaG/HpU?=
 =?us-ascii?Q?XuKLANZZtLi/uYWrgykG6uyuAC6K/t3rOAqmP9wVyj04aeT9JJ0BGNjZ7VGk?=
 =?us-ascii?Q?ryPp6BXoNGq9FBdUMhXb0UeyY60VGb8vDBrwQPMQBbEaREPQLLUjwmY8tdCd?=
 =?us-ascii?Q?7OSzVvPIJdM97eid9GDBcwwK5NEfYihhm9gx2og4Mt5Rg29YPRMOVs61OIYw?=
 =?us-ascii?Q?8dk9eGC44i4xFEVi5ePchYK+FhWPv5dvA9TG2AA1SifDQxdg3Hg65ykvSLBX?=
 =?us-ascii?Q?JgFJHz/yOny21VT51CrKifdAuHDCfSoWDd8nrEVPi7hLmYrgOE90g1/aD6fb?=
 =?us-ascii?Q?KaLARBwO7me7QzWDr1fim83KjgWgb+s7H/2MylzNwTQ+zyBAtkSpxDKfkzJg?=
 =?us-ascii?Q?kQZygO2MLTF/dcPtKl2fwYRuamloEIF/2rYmGADwEoMK7RKrqsGe68Hhh5Cy?=
 =?us-ascii?Q?OReJAwdvyzC0Y3HaFVSF/vlOwrFoUwhO06Ona4GpIG3HerXyrlsYz+sd+7gh?=
 =?us-ascii?Q?CxaDROcgzNrRaODqOpdQqoOCZeHiFc6abm3mMp3niMVYU3g4TdG4uR+yNSjv?=
 =?us-ascii?Q?P5Xu6E7POJSCZE5wzfIvXw7JFM4dbYZufxjcnOqwqH8Tcojp09ACV6kM5vav?=
 =?us-ascii?Q?a6AqorL/aoOnvbsiwZg2L9+AkN1x4+NIVqe5cyPupdk324f8qOwAqEYCVHWo?=
 =?us-ascii?Q?YMb8b6dWoUMyXkw5Z447OxneNdQ1ykrdY1OSd9lsmKbWWW0oWJFJt1b6KU5n?=
 =?us-ascii?Q?NKicS/Vc4QhDRmrVfPeTCiBTrp13wUh+dss4pIVkacNhE7nXQB4WIO2ctft/?=
 =?us-ascii?Q?Qq0Q8ds8v2b4h4tTr2wdZyP89vSO5oqhSkuHvsS4v7vBKzql+Jdeokz1iiPZ?=
 =?us-ascii?Q?MC+rN3ZhvRLibn9hbzDx8t2BGAeFGIvHIhsp8EHhdiu5AxldgSNP5JwF+8vj?=
 =?us-ascii?Q?/okQoNzdGAtw6M4uVPChe2i/OYQSpP7RURFvvt9JbIEF1hAT9IDqojSGB2aW?=
 =?us-ascii?Q?fUYfASpcAfwSD5fGG0Rh/r3XoOY0hyZiqX77wBy1nwSn6WrPILEA3nuKyptW?=
 =?us-ascii?Q?ZA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8ZojGhwtqeJJYHPJ7pNdWPWXOFXZGEzt/YWhzwfN5a5IKeAPDFBCAeMAjUzETBCV9k4U/onyVbvp9znasjxUnkGaHAiDN3dHJEShdJYEY2AOROss2TF8MLMOhEAlN7+AxeAwZMh7XWHNW0CmbZvsJFR9pZj8pGJKXzeV9LWGbYI9HjAHma+llZRZxk6l9+K5k/MWrX0HxOJKsfLro5z817/06L6MKd7JtDg0lPk9hp/gFyikrM1gM3wbE3RCPkYqFrxyss/8BhoZd9U9jpA+XKL/pE/LnoVnx83RW/0pewAqzVN9bEyBjSDDSJg+ouveEEXulrsGiSnVjwQANf/Zak0RUBeE0hTIH8i1WExmF7E+EGU78JZpKRE+N3bpLaIKK+bGVvSTzLJ/JAMi83ys2mDnJjBVqShjwGNz+Ycew5HWhBMqyY6Y5b+h6ES1vWfmB/tPXNnu22bDXn6OX13J6jC7rVdqs8h0AJ9vcSHtZDbZ7TTgHOrjna6v/hnTo344fNH1Eexutq3XImdWpGlUyXPofKLdbKT1nIbBzWNO1P9TGm49LM8jluIG0tWobFeueRVHEdlzNIu+lZmxBo2up7kJIEIXx97yA46ILILuwBk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33b2a710-4138-46e2-982c-08de22b9b487
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 13:36:52.8032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TmAduCjueX6xqVECkoBlEdwcj20rF7/8FaufFtz+FO/DtjmutoYmOxOCbC0oy4YE0HII4oyPx2G8BPKcMUTEdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4948
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0MSBTYWx0ZWRfX7iTeHKhOgb2k
 Y8Uq+IL/nsleu9ABM8SB5fI/enqkyW5nFhNim0M7kVQ43zfbmG4y8eaF1H7ImrzYcPuyGIoAzx1
 pAlW6YoWy1mkdnRh0c8KQq2NDH69AhxhWrxO79YGfpwHVuLB5gOoz5lQFipZj4nDM1RCWwv2iti
 EMgvxJ72EaEC/FiTZAMme/5BHti36IU6/vHQorH9GaBPG3eCIWkyoG3IAW22f0V6N5Lre/uvCDd
 khIVWo3SPJgra/+a8mFyWoHDBwGNdKB1owqoqQLORij2lFFVFfubKuTi66tTLoVo5kVqI1J06JF
 niNdK7ivMA5KvYuBPXjlvOM4yhsQex7psliIeaUIIp7hsu7vd3zUPIIpqstVDglXFuByJ0wujuP
 InN9ZEU8PAxWd30LGWRsMrDmhzxxyt7lXYPrz7wPrLuzg1xFSuE=
X-Proofpoint-ORIG-GUID: zuTJd9SgbX5uNkmAo4CThf4_M4qBAjDK
X-Authority-Analysis: v=2.4 cv=RrjI7SmK c=1 sm=1 tr=0 ts=6915defa b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=i0EeH86SAAAA:8 a=Cz9JQUSKQcrkmvWhNEQA:9 cc=ntf awl=host:12100
X-Proofpoint-GUID: zuTJd9SgbX5uNkmAo4CThf4_M4qBAjDK

This series includes improvements to fake timeout handling.

Specifically, when we try to abort a scsi_cmnd which has fake timeout,
we check the deferral type, but this would not be set properly. In
addition, we need special handling for fake timeout in the abort handler
to ensure that we don't get confused with any other deferral type.

I am setting as RTF as I want to test more. I also would like 
JiangJianJun <jiangjianjun3@huawei.com> to see if it can solve the
problem reported at https://lore.kernel.org/linux-scsi/4efb45b3-455a-44e8-83fa-e64ca8b9192a@oracle.com/T/#m2092593f3bc4b5fdde3f77376b65c10ab7bd605c

Finally some tidy-ups are included, which are not RFT.

John Garry (6):
  scsi: scsi_debug: Stop printing extra function name in debug logs
  scsi: scsi_debug: Stop using READ/WRITE_ONCE() when accessing
    sdebug_defer.defer_t
  scsi: scsi_debug: Drop NULL scsi_cmnd check in sdebug_q_cmd_complete()
  scsi: scsi_debug: Call sdebug_q_cmd_complete() from
    sdebug_blk_mq_poll_iter()
  scsi: scsi_debug: Clear sd_dp->defer_t in sdebug_q_cmd_complete()
  scsi: scsi_debug: Add special abort handling for fake timeout

 drivers/scsi/scsi_debug.c | 163 +++++++++++++++++++-------------------
 1 file changed, 83 insertions(+), 80 deletions(-)

-- 
2.43.5

