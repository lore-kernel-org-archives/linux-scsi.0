Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C33E546
	for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2024 01:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714008689; cv=fail; b=rhcGB8rzFH/7rgLtulJYd8G1Z02T4oi9hvdAhXLVvXIpxTQ8wMx7Jy5IpBh4tPSSFbMkNIfWxnr70AoIuYXc5wJ0ntQohzn5KuXsAN2staP9DEBLGCOb4KNNo0BNb3wtA73oI4m/mklH+lHjarD6UVsFV4gmpuVUSnfEBbacXCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714008689; c=relaxed/simple;
	bh=bPTOnhWOE1//Z3ZPWCnU4ARONzjhoT6tivlYxTOVwuE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=TiSewoQHJ8ZJnBqaRtzl0F48NbcAJF45MmbSBNEmzTrqvDD+OyfOmyzSE5i5PBhADhaxCkHq8gqRz+WS4fI5fEixjk9fKakcqvNFHLXyUuFf3Mtd6Mwc4Eq3WAL0Zc9NCr/gjYccVtgOnHh0mmLmMosDa7FLY0TYWhRpGW8lH40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=esc51GG9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RYKkaApg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="esc51GG9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RYKkaApg"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P0iMRD006340;
	Thu, 25 Apr 2024 01:31:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=46OlxhFZPzFGZSwxfwW/pOvgnqbfQ7b7s+cRfFKhlRc=;
 b=esc51GG9aWoifwYZyXgUvXF7Jund7/g6JkYiGA+Kb5vqdeZnyOvM3gf4t8fVR2k7kmC7
 oTyHO+bGUjKhPXX3ChklnnswPi7JubIwFYXRmXCB1jaGArlVvmFC0uouloucjyWPnWcq
 FMuF77KfCIZMls+bWmF5wxSgE+at0zSVfWZJ6kHtfCNUIe3dLw6BHonu6vnAlYCu/DsM
 o2SS+jFUXSl3tVjB/0jJcYsJpLAogenlxbIpqI7a/FIdLw/aSOGeoMThk5iiEf3wuhkK
 GJDOUHZi7BZ5BgNW42FYrivpupUvaipSGb0pGcKp2fy7ZLy7uEIS2sTUNMk0kRIXOkZD Cw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm4a2j73g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:31:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43ONZf9U035697;
	Thu, 25 Apr 2024 01:31:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xm459nur4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 01:31:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqUjRi/3e1lIL93AqdBB6bGfnVsFS4SfUWsXCje9NXTkcFGUInz297cdYEQ3O4zaZqhIrAdiLOT3fKIZQv9foDYnK9PUNfmwSqULzr7WDHtYLdN9IKzZbBSDB5EQok1bEDQxtGdBPTrRTpNz6RJzQRUMqTEfEOEq9uD5IxfbUzdvyFPtdEhYM0RA9plGIiFrjQhjLjDTaq7ojRXZ8a/jycwKFbOHIW+Ra7ldHdsyDfP7fLY2qxrVcov3y+BfRmoof2CEwq+XpfY8It2rCqUg/Qy2kotB7L2lsFabzcYbcRBnrOlGKcKJMPTswiVO6J97ds17WZZ3dQzgBnIpGXAFnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46OlxhFZPzFGZSwxfwW/pOvgnqbfQ7b7s+cRfFKhlRc=;
 b=I6x9N9Zbz+Y2zs0RMOslorw7B0sCRbwPi1CkLBZkFdwDRhUJvAtj/12CRbM086Yu90LpGEq1v6CDl8mq5Odc50zQZR3AQk6VxaIDMe+VVRIBGD2EW1AmlzRpaKzju/N9WA5S32s0/vddCBb2zD7ETqVXnDzAervX74bo1mSIuPUcbqptvFY7q+iB/Pgmhrnbdlc3np8H81NwUK7SFphIC4VzuMTY0EWWA/kOeNAazW8cxeSd42VH6WDevlDqqf5ozp+KqPk6JYYgg9jOUKUbkSCdpP6MT7gMlhhL4g1MNTL4seQH0UIE/vqeGQH5jHaUF0I+zc0cXLuenlGIc61WRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46OlxhFZPzFGZSwxfwW/pOvgnqbfQ7b7s+cRfFKhlRc=;
 b=RYKkaApgnSLKlPVxNEzANSDEcQ6VbaMmRT3cdBtxBD529S99YJUS6i+iYj9TENITwic+fm48ejw8c3vAi+XzXi7N1Rj0pjc1ruEWGme1QH5su8GiZpvlaX3yJLipFRBjFJloYkXs0fC3DQG+MlGYQEN9PPx7bVUbE6ooL7mkKVE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB6584.namprd10.prod.outlook.com (2603:10b6:303:226::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 01:31:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7472.045; Thu, 25 Apr 2024
 01:31:20 +0000
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Sathya Prakash Veerichetty
 <sathya.prakash@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com
Subject: Re: [PATCH] scsi: mpi3mr: fix some kernel-doc warnings in
 scsi_bsg_mpi3mr.h
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240424055322.1400-1-rdunlap@infradead.org> (Randy Dunlap's
	message of "Tue, 23 Apr 2024 22:53:22 -0700")
Organization: Oracle Corporation
Message-ID: <yq1jzkm6xeq.fsf@ca-mkp.ca.oracle.com>
References: <20240424055322.1400-1-rdunlap@infradead.org>
Date: Wed, 24 Apr 2024 21:31:18 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW4PR10MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: a7ba06d9-67cb-4dea-43d7-08dc64c768f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?GI+F3Pe7sKruma1VmyjrOG5VZEQLu+ZS/7i2Zu6/FWKG0m4H+ypiYxeYRr2X?=
 =?us-ascii?Q?ccgr5m+zAeGCGiCR/pDT5MLRhIJkD3Hwi54guccKNzNukmtA6tsIAyYvXgHh?=
 =?us-ascii?Q?x462ckdrdnIEEhHFuITSKZ5AriKPo5eNdO4cz8EVtP7mmVy3AH+ukxTY2Utc?=
 =?us-ascii?Q?S6t15bGwF/aGT54e8qBri2Db+CkXOmY+XYWyjcgz7aMECMnlw6usZuC7qkpM?=
 =?us-ascii?Q?by+wVVUEayN5Yi5w3xiLrJRXK5wUynM5MPghshjXFQoS8Zin3gaqWqLFU+zO?=
 =?us-ascii?Q?QYj+0fZmyAViK8Pdff2uXlHKlEehe33OF22h/IvrN04Dj9MJydtp40VrZ/E/?=
 =?us-ascii?Q?XImRi1KtvZBaRdCAHMCMX13Tu/702Jszgfey2weZWUhxzbVauJhSj+AXcEAG?=
 =?us-ascii?Q?rvC9/Wyq3xijTGRVBU6BrhwIRkbUYTX0U26CWZb6Iy6prAwMsA4fk35Ww12V?=
 =?us-ascii?Q?m+QL/jbY6oy6ngmxDN66Dr7fpm0zwLc/zWE230CeIFyIsb+IMLyH+KqSyZKX?=
 =?us-ascii?Q?UE8oNMfER74g4yEErc90iKD/w/JP1PcCbprWLRnTV9i13Ky6kVVqAWFiq+U0?=
 =?us-ascii?Q?osO6aT5C3brenFXK9ATJ3ixXtUNvQiw6P8SozVyl6waUgxLxGSzS3RHyrJpu?=
 =?us-ascii?Q?isAl7ANr4TJitenCQP/2V1niOV8U7pzh+5afH5rvD84mxewIycCDfFxntqhE?=
 =?us-ascii?Q?8xMgTAtW55QTYzH0wCntoMisTH4f8maCOi8fbroKUrE+4b5QEGcfFX5h5UGv?=
 =?us-ascii?Q?TC909Vh2o39Juo3RHCxBssKtQ3+Xj7hO0P9+/L9DFJAmZ7Zj9OZsF7LkSesp?=
 =?us-ascii?Q?Y9pVvTEDDSjLkTSgkO8vjLVC8dAvHGhbteo3vuJgFoYnPLsLHVj35fLrh+Gt?=
 =?us-ascii?Q?VaCdXNqD8W/NwdtekzvvohXxP9aFLENCjG6SDojr1vJP32ft86KG8aRZ7wWQ?=
 =?us-ascii?Q?Z67K86+/eeG+5ZOtSWMMqdJWw3e1VrMj74VxvY+/dFBFn0fOkifwQfL+jEQt?=
 =?us-ascii?Q?K0JNe5iPzA8ypUSff46nQ5rZxdgu1xSCU+SzdjNB48j9CL+MdxZvKwrou/HY?=
 =?us-ascii?Q?p/f3jA7HxeXeOL5U9DXz5+EwbrmtjTcol0uZ3yw2s7Qo6keF3kEjFvcLJ9u6?=
 =?us-ascii?Q?MwqAHobkBIHI1jEL+uJLLsA6npexUMVo0ipgf+QDeoXmtRuNlfptW5x8ltdN?=
 =?us-ascii?Q?5FrIp2kCKikYrBLo8zaVo28H5e3W8wy1EnIA9Xo7+3hrFRE0L/ciqKVJOZwh?=
 =?us-ascii?Q?rF2RrZV2zod7B7kCFgfRJo4YZRHrw3MZhC1YHn4aOw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?LC9klFSCJkjFrhLgMGl+F3zJzvn/atV5lB3eRT7ZV+8m2LJwkkBpYYWng9aq?=
 =?us-ascii?Q?pbXFo1T6ka8N4GVI6BtvFhCCJDaysNFcZk9gol/1QFTfKQ5MnVjD+WQZc48u?=
 =?us-ascii?Q?mqGniF/893WjggP4iOd2BTzsyveh2HfHlvmOsxqJynk+/SQtDhtojndI9a+2?=
 =?us-ascii?Q?/ZWBTD9QIRkFwfj0EVpK81Hhjeyt1y+F+Y77WUKpYmYEYHgDuscc/33ZipP5?=
 =?us-ascii?Q?+6Q29hGe72MdmmlF53l5jYVOYCE6LaJc22mxXQubLhH7jlTqLFHXcvbTiKU+?=
 =?us-ascii?Q?Tvp2eNBeRgg1/TcEh6VpVxUSgMXBjhudkIYGJLQa0Qm2zC5/5zsO5bQDTYXo?=
 =?us-ascii?Q?2eEMqXvZfYkG84BImxcnd6en12V2SEoVctHUZcFJAME40749PBsMMoYCtPDb?=
 =?us-ascii?Q?BH5RAM/p2u1Fk+qZpNEX28EXsFFNMTv91h5ENRsCun/XFfL93kQN2OFRPH3I?=
 =?us-ascii?Q?aRcGWAWKv6SOhNaZ7G9VfVvhcsRKT2vO0/X9Y6VkJKZluqhDK2LUZgM4ubgm?=
 =?us-ascii?Q?v+B+HyOxpGSBpQkSGATC/wNsALRT4OGSTrlmJ70CfmrZiT5CIJN0r6OoIJzl?=
 =?us-ascii?Q?wIHBGorsfj4N5BTaEl2nUZmtZ2d8VMb9tqdLG9u4rDBagovLNZwI4DhutBDl?=
 =?us-ascii?Q?hFUuIjBfAgDD9VGK+mxDV/qBFFw9juMUnKCSY6hOlG6qw3lDQ0QwQJlegs4M?=
 =?us-ascii?Q?8qgR9gDccdk4lNust8buS0P7wUGpU+xltfONS/gkHDhU4UUekCKQ18FoikDC?=
 =?us-ascii?Q?SLoMTqY1SgNOrYYDwDRFOgm19qUypY/Z3Ek2IxqZ1+/b+5csZK8QAiKWPpCw?=
 =?us-ascii?Q?6KZpV9egeZfL7PA3WlKEBbuvBzjo5W6bZrSWWBcbKab8e/++AhrqyHhiRbFc?=
 =?us-ascii?Q?EYwpf6Qm2Rgs2aYWHxH2ZnIEcy27GDV3SAOqBwIwHkn9VtTdbWx9VooSblha?=
 =?us-ascii?Q?pJCAdEKo95VqGAnbXY55daB6BrkBnT3FQBkoVnXoyriP3t8PuIBnDlcTTXyR?=
 =?us-ascii?Q?u416YkayN+M18Gu/WobZPWmomtQkoWQkm78SBrfox9kFaQbdev/1azCKUUc+?=
 =?us-ascii?Q?IxNBFEjW5HgOxUegPBnDfgn5K9BUvIK0EWVNhgiTRnWn6VzS9kZozXoZYOpH?=
 =?us-ascii?Q?pCZ57XlRw/RFv8GGGHHX1KJxboK0x9zLOvBIsIlJLaA8L5PloxivdHUvrJz2?=
 =?us-ascii?Q?946AAiHctUHEfVTZx9YQ7HJakJLHYkafVRX4ue7a0b0oraDxRNF7drC9R6/B?=
 =?us-ascii?Q?ArSxemQ5OIP8lClS7B3g1tGuhK8isCMFaeW4nQ04fvFS9GpWSdWZqWyRogtk?=
 =?us-ascii?Q?7ltM6OHuaWWBU8mZJTxraP1xjdzeQUP87AuSDAeQz7jEIrbYRnenWq9FZ+BB?=
 =?us-ascii?Q?xOE9D9fLt6+Hd4NONJR6MSBLBUndw4K6U10oZIqLcAXRkQ7h0xI2Uh9C2hUj?=
 =?us-ascii?Q?9a0l/24EPR9toNeYoILUyokL0iHFSyfP+aWUTGFLIF3O64LSrrfhEtjZhDAN?=
 =?us-ascii?Q?no6G4WWWnaJhNLdcPTOy6Ra5RFKo1OyZhYYeacAb9QmeJQz7LcyJWhOC6DTK?=
 =?us-ascii?Q?TzUZ2t7I/g4PBs2yookXPENXqEG1n1RYG5kU71JsyyKqoEOiEdAWJrk+huYM?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	AOe5FFWY9jtaExI9MMbiyOuaYlLrhiDRZ1BmgK7HaCzMAG5jiQ1wIShocKQtDxS4VoSzTExuiNpzPGuKv6KwDY1L9wt+GWuydWtfHtDFVJ3fqtxomAPJGFfC6hnHS2JhpC2Q9c4/LvsQEvu+rXwaqIoXiyfqD9dOiLsJ4VjnHzPQvHD6SZDYE0h0rqC2erhoYnf9WyfAeUodCc7mMX2Su70Pe7m1YKNZrFC18FovC+U4GvW3d3ACkOHYDOTnShzkH6teBYf+lwecrZbo6xtGJ8bqaheeGnsnhDxPb1o/79qgj9uLrNWrZkz1BAITOB2pRX0aDybETQ5Xj6PkUU7n1Ga9eOZ+w/0fv+3RhPQmRZoNw4QyiTghR9rFtt3DI6AwYQnQOix0dEyaRiYLt+nEBqI2lJt+IwTOxyKW04QlQcrpRcAfcc1rkp428/nhYkUGZ8zV+8MWXxVIv88m5HM3KS+JfhBMbaiK2XiD3Sf7xpLZDGi22dho2+8zJvaFfdgDeP0pEyg0kLqxJe6mkMyYrVEoURX0/dnfdFRu9ddiQ6dZFGF9sSjo5E/Pc5zKxFY6IwkvabNIfV93Iqz8JyoVscq+7ojT3AIyEsKvhxkPp0g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ba06d9-67cb-4dea-43d7-08dc64c768f2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 01:31:20.2574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ODSYfJJtELkJ3KhStkPYEIL924vWAtLB/v+F/OPcxrLi2nm0RhiNHARm1436nDp/W9AJcuceVEaPGxjJwOe5EGQuDbhOgTMupPMYlHwCIro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6584
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_21,2024-04-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=916
 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404250009
X-Proofpoint-GUID: 696mLdusyBQzsDi-xBMKUmehUrprDvJV
X-Proofpoint-ORIG-GUID: 696mLdusyBQzsDi-xBMKUmehUrprDvJV


Randy,

> Correct the name of a struct in kernel-doc to match the actual
> function name. Add kernel-doc comments for 2 reserved fields to match
> comments for other reserved fields. Correct the kernel-doc comments
> for a nested struct to eliminate kernel-doc warnings for them.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
