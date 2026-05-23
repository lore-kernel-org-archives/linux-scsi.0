Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460B515B971
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 01:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779499012; cv=fail; b=mi4ocqLi712dPWFqDcrhmQUgpw+bgeMxRjC6Iq75hpFsPGE1HlKktAchsdZpN5bIi+xD9857xaKvzNQJI4CzcPyO6p3rzPZlsRyBy/GqO0pzyTmth1jK8GXj3xT3//CSompqk2Cd2lOzppDZVrtSYsrY2LVwluprXrxB3PwqXIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779499012; c=relaxed/simple;
	bh=f04ny4RppPCHgCM5HWthW/r8jAK7HwVEEqPnEJdZRs4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=dVc20pjf0/w4NuFYsJFr4L9e0d+sru0O8o/OVxZfjZN0ubG416trW7TilmOihj3uDvz5N+ExGIhV4KL6bMDVekjY3pPuBY+AxkP7N4sW7HYjrbd5XFdVcjSbOcDGSPblxdNW8frPQ78JmMM341CryYeTXu2X7GzHh6xOVmqS6cU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q94xyluL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UMLydxgt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q94xyluL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UMLydxgt"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MNF2RJ2009430;
	Sat, 23 May 2026 01:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cMjhWDrbRxnz+1G/te
	fKNi0RMIXab9kqo3BUvq1SDvQ=; b=Q94xyluLtciY8zGdM6QuIl1+s38PXlg1Ls
	QisNgP6+wl95BFPkxzcf+qS6DnZdq6OGRh7VWrXsJropiQtlROSC83fQrFk3R+kD
	LWyX5QTFGewTsZxFkq8EOxQCllUSha5xYzGWy/KHYo3YZuREOzYAU5r8kWoTLCD6
	BDToZukqunvZkXB0wX7Pn8eMsQMAQt2zhOVP9SQpn9UPh9EvWc71QRFqVr6c+QuV
	mpDDEguFq/fNMRj2Bqx7hmDEWsYJ29kKR7DKfW9nzzRG620zY0ez6lkdyHbGWgZs
	Oiqua+1FXrPfnN5A0fHzzq3TRY0Chh6KhrNXEBe6rmF5jH1VDPqQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h874399-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 01:16:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N1EiQr034995;
	Sat, 23 May 2026 01:16:38 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011065.outbound.protection.outlook.com [40.107.208.65])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e6f1fkhg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 01:16:38 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dqwDAcMlCm9QY2Ceht+0z/jCQZjbazeZBH+jmyXl9Qq+m94ThUqjrGy6C8Pqmx1AgYkSDL4JfXLGDTwL0oD8YTEGEKO6VnFh1NyZVVIEjIi74OSTpFz2DOMRJCMzOBJL9e+4I5g7ZkpX2MYbZa+w6XfYK7t5PbVZYVJsiHCVxxKiFwRmyjealgGJ+bKSFwg9O7CNPBCptiv797k9RRstI210TwA87UO7ywsMBmZ+Ro1L3wCokx6PthhtKwUWF7jOPnS9K+b2AGdrtbja4qVG2Q7XVwIZiAS1ztysErMzq9hXiNoPsV1rgwpKrB8T+qj+sbiP/bC+VGVzyORgfefBag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMjhWDrbRxnz+1G/tefKNi0RMIXab9kqo3BUvq1SDvQ=;
 b=TEy9dzj+JxxEq59ovBVt4GzS74lTlo/D0u76Imys8LRghxsSEmrf/5kxaxtxnbspRfI53MhlJna1JIXlI+y2/lmVlMqM+CYT0X7Pbgs/C2KyLyZI9Vvhs73K1O1CHASvKCmkd9DR5ci8OFoduf11rU2X0nYNtk3C1UWHhNBaaYokb+Bb3X61zaPXUGcZHUZEbBCyyqSXHFVbv4FeI52yZ7+2L8LQbZG8yUc+ccRT6aEWYyANsKEv8AYSjycRokD2REHTibVNot9B2lA3yD3RW+gwTGhuIQFxv9ll1Xh3BPtFvRuGGK9/1bKK7WakGT3miPz8QzC5tTwkBBMvxwe/yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMjhWDrbRxnz+1G/tefKNi0RMIXab9kqo3BUvq1SDvQ=;
 b=UMLydxgtz9V91C4HBMejbvgdfJ+ymLf1Vhc9jB1fjpMwSR/MQNhzLTOTZZAhYNfsqDOKLAdXv4wd0CujpWky1yzgvAkWmOuUQKWhYPS17e0OM8XAAzgVkOO1s4Yfxe75k+NHTVNXmPhYpojXpKQKFdK3iCPX8zrIpQ27pPoBC0Q=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ2PR10MB7760.namprd10.prod.outlook.com (2603:10b6:a03:574::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Sat, 23 May
 2026 01:16:36 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0048.016; Sat, 23 May 2026
 01:16:35 +0000
To: Can Guo <can.guo@oss.qualcomm.com>
Cc: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: ufs: Add quirk
 EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260501131641.826258-1-can.guo@oss.qualcomm.com> (Can Guo's
	message of "Fri, 1 May 2026 06:16:39 -0700")
Organization: Oracle Corporation
Message-ID: <yq1mrxrhqmt.fsf@ca-mkp.ca.oracle.com>
References: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
Date: Fri, 22 May 2026 21:16:33 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0291.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::6) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ2PR10MB7760:EE_
X-MS-Office365-Filtering-Correlation-Id: e86c71ff-745c-4deb-c108-08deb868eec2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	8g7+0rNG+aWxTY3j4PKCZZLKl2SsN21xxT1VSSF8sIzuE9SH62dPE7w8hujbrrBMHyTf673+dxpq7M0LajyD1ZivVBJ+60FhvWIEv1tBw+0foRbRWYhgJbB6CQj1MUokcnnvjGO972T1PxzqcAzdRa+kXZRn6Qq+Zf3bUb30nFZr38b3PetOyQj6PpBBVub4/7ow1gAGkrFUcMADekQIN+4+88423N9fCehmo37z8WgI/JJ9G8YoJ441lpPJxeEiUHnsHQZIdNVG7BSVPNF+iuXxT9r2gFQHQhZBbdFIYcgWRGBC9mbWECOdDKEvj4454mK7aWgKTWugRIoTgQE0lUpaafIkMKRpC7IHc8cdOyaU/nmrYDc2OoY3UW6FtAW2oLTG6UcTIUqrylYeUy3diyNJF4s8tqWGGTZrAVb+zwZPN70J9w1/yW5iu50yt9xzH7P2SDpqnr/WdwdJh5eP0TUCXNtlyAtK5paUbkMNkRo6h9VMOMNTT33RbzwA1yYHdGnxOGcKgjJZ/wxpk+R8EHEgWuLt6oUoWwTl072rYwjM7yDjV0R/u33kujnT/WB763XKvzMif9qsVR9JgB0EangStpdIgQc+9MkQbY33T3JYXB6VllIYxfQnfmRrZRcZ3H0dcTi7SOcxypzy4kM2jJ6GAZhtl/R9fk6RTwGhxxF8HR89AsTUZO/HW80zQ7a0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HbLnKWPcCoYbfr/WwsYa7D/Npkwbsuz6s1YSxf68pcJ1JDBJJFMHMq6UehVL?=
 =?us-ascii?Q?8s3rSQc5aSgB0Do2ZbzY7CvZPqOM56zDKLRuVOpsk1KpDBROk5KOuvzC+T95?=
 =?us-ascii?Q?RR6BeCjdtmF/3sobsXiqtuXi6TW1txy8D5l1QWX7dRWd/zYFNEXFMPrAvOVQ?=
 =?us-ascii?Q?D07NHK6xI2OcR6ZzY7oxjP2tlJlvAa5whHzg4hmqLb8v70joQNSaojh04P3O?=
 =?us-ascii?Q?XbwtLCJXIT+g8S/nisWQKdU0N9xhEWilp6DGaFn1yEXGGbkHQYFrcyKNKNVN?=
 =?us-ascii?Q?CdgZoR/IGSBjC5jNWQvyQSdxirZklXsA9mmpONDAD7BbPErILmxqk5sZ6e8V?=
 =?us-ascii?Q?eLXlYsg1lZNJf+BRyEH7ESbMZ9+fDnCQQJdvtVun7BrFq537K1ksiMI1s1PE?=
 =?us-ascii?Q?NsSj3Iot3pOKrDrYRBWffIPagia/jHuHJPYQsqbGXW2XOLz9FZg/4vJKYvPg?=
 =?us-ascii?Q?Bn7/QQFcsvSwd3YEC6eHbK42EzQjodso8VRfjBCmAA96Yu9uOg9WO9I78VE4?=
 =?us-ascii?Q?GVDGEwWc8XOHd6qo2JrhhP81MSQwHqnZjqYw8NLzgeUiwwNZoS+wPe1iESJ7?=
 =?us-ascii?Q?97xoEe7Aj3GFQwrLeN5btK/m6sdD2VCftuZDNWMimY8VOo6QuSD/hI5q7+Zq?=
 =?us-ascii?Q?6IqsSG1yCZi/0JKOwlWgsk/KMySPI+8CXKRjlUb1tNHccKA/45Y2gECMKB5W?=
 =?us-ascii?Q?bLtIIE7EeB6B5D6Q0XJXNHJ+mVJJpACOgMo7Qf+Bd9A0KJXBQ2udCEJS5KYG?=
 =?us-ascii?Q?pT3E1KBsafLW6K9hjZ4epYJ/EPWjsK4YsoJmlo6sRyj0aNyH77JCG23PECjF?=
 =?us-ascii?Q?eia1U+0vtoIy9Ve7XRhGYixVdngvxg9Fg336mDDQgS0k5F83sIWtjlP8O7SS?=
 =?us-ascii?Q?oWYAwp2tpTQrVNqBH880uKM2T9KRfBYHso1YAqOJWMmjRG/6sS6JA8JeHnmM?=
 =?us-ascii?Q?cMMMEiUt+qx+MynjI6/ndo/di/d+XTy705vRQgLyeJ02fHGoFdINgLTm4iJU?=
 =?us-ascii?Q?JKJI4NFoMSPoQDX6gvsJmI2KoNZ33zYd5qdPYOeRoi9P+vpC+x5P8GTsbUNw?=
 =?us-ascii?Q?6wZsn8ALmkkhTObMKjeR5fql+Mlzbj3v96ge5nVNjuOCT80+qREUhGctH4V3?=
 =?us-ascii?Q?Okp5QPGjH35zuz9acG/vSRxCxs7d42vJihPJy866Kq2YqRK4PgrN9PgIDKaR?=
 =?us-ascii?Q?t8MZSMgz5u5XRZ2LQ0OIJObeGWi39Xa/DqZgJOsPG+PN5Ulq4FSOjRb2PDNk?=
 =?us-ascii?Q?hS5icM9ZPi5dlncdheWcS7KuEJglgbuw9AuC5b3UQQkqoEzdNm/kSMxk3z//?=
 =?us-ascii?Q?0+UAY1f+Z9+wJHruljzyjPI80EO0oBkZVahMLYozt8Pg1xvhRRZRZWWo2CKW?=
 =?us-ascii?Q?sVXl31JJw/+5vLJjCU3tqJ1+SSS5gBTtB5JiJITspqZTNFG0oPeqLGv1Cs1E?=
 =?us-ascii?Q?rz4aEFsyl9rqtDUJeHK9c3bxx24M9pmrxjRgImWCO0aLvfWCJldc1NxTqR9H?=
 =?us-ascii?Q?aSjynf6CZrdcjvedZMUAWDDwynxjSl67r1qrJQsQvUiVVQ7D4/vsksUy3DyS?=
 =?us-ascii?Q?RTImmKROo9TFPtY6RcOaRerfZ9i3ghRQaWtOseTc69BqQzUHEjqpq3DRuQdN?=
 =?us-ascii?Q?cqk4G53mejaxMqUrCla1h7oGzk5XE64qIKaf3rEM3ouRkdraLQ9Nx3R0jEs1?=
 =?us-ascii?Q?dFjgKxHhTnrvfCA9YVmuhwdpiwVCgqAbILkVcPB8B8jDu3WUNF+fTotrEAzv?=
 =?us-ascii?Q?uIJ1q4LWzdikYj1Ytc5p273Y3prTDUk=3D?=
X-Exchange-RoutingPolicyChecked:
	Ym/yQCk3p0VqZiMXdmI58rpwxesJgqwcywfFAgf/NcNykVXF/nHhlVLhUQoATkh7qjQHxtFCB435XXXHwQTKRk0nas2qlICNSolkUbHB7oeqSV1b94snELu/X+vHtDG4K+Vjqj2Sz/O3apWLYccW5hd8xjbshPiKpTYSaDrJH6B5G0DR4oP8cUPl0KL1CvYujnurg3c3y4l1/TETc/svaqDS7WZeXCCs03N2DdlRW636LtU9gxY+lKCAgxJaRfYq2cYw2DhJiTlahYe0WiyBMH5ZQ0sWz/tuPjzahlMp7/6BE2o+WKvvyceQS0TBrE1NIliFL9YBAyEUekoRzIOyCA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vk7G8XH/J8E5I2CtknZDJQs7kKNJK1YV0MrU+kUWysJFTEPlDHqP67DzC3qY+JmWsWJLjNG6LFZAJhZoiWGPz9+RE41e53Hkh2FzXNG+R2mdDYssm0gQda7nwPiaB8xQY8EaMfmvPqtUQ6trMokooLX+6hl6q7ytQY7WyyzSd79AaEpesh1LiCoQtcpv+FHrW1b+RqZ5A+DoDvuQoTmtCDS4wDqFEisajRoApWGUBwEhBUtfdQl1vKO/G1peKJZPyDjoSOIhT1JGcW44zFlV6t00nQdZ4uOmi4TTpqzZPqf6Ca+D6z4DSpq843pEbp+eBLv8zplYsUXqNEmuvM0/pPHZ0hMNRtImnyAYLMwhOSPI0MSPJk+RrAc6DGNEikO+8TWMet3Jf3cA6VtaO2N5uqqcXPRx6Tlyit6m6U0UBP5icQfP+kSpwWvwyDsg86/OTq99XhA8ZWnZKH1Sxe9/PIrgFCm01g16GHsM7n6RtjMQSAaSNfMBhvpJCSpwhUs8441iMJ09IVDs2EbTJJg19TyWV2umGqFxHvMW4vPyFzuOjZlhLrB0gxdMYraMNMKLWZ41MATDJ5vvbmqojCL31XDKLckUIhPgSIUHB+Eqw58=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e86c71ff-745c-4deb-c108-08deb868eec2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2026 01:16:35.6551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0Dkab+7aDMwM43YGRG5oS6zUh9Z9C5H3mLM9dsVIUV0qy8PlPYbZrlXnmEw7k1PTxS29Wn7GAKPukzhjAaFPeIbVE/WHt+u3re+rlmHM64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7760
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_06,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 mlxlogscore=862 adultscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605230009
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAwOSBTYWx0ZWRfXzyY14fvTD8eh
 EyW9cQ7kFb6jO36YYZxyx4hHL3mVRLE0aLsVx0jJLDKTy3IT3w5rgcAFKR40b3kjwZaBH6pkrPk
 QaR/HrvmPMnFvB8RZGqB3XcwbTxeS2lzlaXdTXw+SCrMHBQDHqXFZXe1WgelLiiv6XfVLikIE2/
 0SHvPMpEdkXNr7Vvf/cjSVOH6YrZybU/9lCl7ytCoCu/PA5EZSfun6qYenzN53Q6DGHBrk+1Ahx
 T1wtxdVhAdZsrRBcAjFPPcoNQQHiHY8qtRfedXtFk3+P4CkyxyFgCgFetmqMiyQOATWSiABDVta
 xdvyhP+oJ7MrW0RZ5B6CeM1w+tahu8g7snjXw3sEPc0UzRreUXVOllxPzz7EtO804xOiF0birRz
 Aqu+Cq0eU/Z9W/dGQgw7qwixwgbYovkKNh1Iuu1oYxqr4vqk7kxuB4m4tF7M72cnRVFXYQglHKI
 KyDNDAWuIl9qRkazNVA==
X-Proofpoint-GUID: I8cuq9YVvVpENENICJ5GluDscRNE77o4
X-Proofpoint-ORIG-GUID: I8cuq9YVvVpENENICJ5GluDscRNE77o4
X-Authority-Analysis: v=2.4 cv=TLN1jVla c=1 sm=1 tr=0 ts=6a10fff7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=NGcC8JguVDcA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=4ZfPOjgYHlt8hnbY5p0A:9


Can,

> Add a quirk to support TX Equalization Training (EQTR) using Adapt L0L1L2L3
> length which is larger than what is allowed by M-PHY spec ver 6.0.

Applied to 7.2/scsi-staging, thanks!

-- 
Martin K. Petersen
