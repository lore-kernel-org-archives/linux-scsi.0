Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885C5BE6C;
	Sun,  3 Nov 2024 02:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730599947; cv=fail; b=hk+rlQWoGRFchiCbnWqdBjTJZdFPZ4P+GF5GVxgXeoH56vVlQOGJfkft/N41UkbCVZDgeK+yFayN7/jJv9KKnjMXBQGRdSkA+wM8uvAqskzEI6im8leH0gcMdgIQLHGdDdgdHCvw7zVlIIpKlOunBTLP650yKyVXLxsiDgNCmwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730599947; c=relaxed/simple;
	bh=DbZA/rzCv705B3VeAinIzG1z7k+ENo7krMnngnZR8CM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gF1qjn2VGmsOh5HHjdQLtKIljZTm865ylbx1x9bGtszeWrXhj3Al+n6kxzEXNZ8QLf/il4vcRVUaNR82i9M/RGx3BT/smGqC2DhAIkVhizS3Y9OtLw8p5rmTFf1JQ3ExdfbQ7KT9JO8j9Xf1Qqo5jkDe4ETTC9s3t02ZDTFWwco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m67rvL4L; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RiOlUCEe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m67rvL4L";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RiOlUCEe"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A2NUjq1032081;
	Sun, 3 Nov 2024 00:15:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Z+sz1eixFoJt+5OJ4x
	tVt2MiF6S6XXCWSRNOntq5PsM=; b=m67rvL4LsUo7WSYRZ/zacctYDNz8vLvkt7
	hOxseWNdNSR9cqVVup0E2xZ8/ybtrgwukJ+z+wpnWvtFvsHTbB4ADPEiXRtE10ag
	qmlIoRNYa1KhPvefHlwVNg0O8N7tulc6t6GsMWJPA3wcAl+9zwDwzpREM4wFXhG+
	reC/Xq+dvZkcMmlgmvZQRb8dWz3o00lyeQjMACZjunwP/d4HdnYEtnhRm78N3iom
	RQjm4JpOFWX+jt9a2nrKC1QxvaMP8LqS7XeRSd/orntNGtvgrBRfHi1/ib123WHA
	deZUOuxEEltx3DAbAgRM5ZrHmBFPk631C9zP3zKkz9oDkgcptunQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nagc0pgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:15:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A2JRGU9009709;
	Sun, 3 Nov 2024 00:15:27 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2048.outbound.protection.outlook.com [104.47.57.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahasgar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 03 Nov 2024 00:15:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YJErKxvMV0r8DcNt4GWtGa6pBMcJatq8nCHF1ejZRu6g89Mo5nfxwHlu1KznoHa+EC80ZPlyo5xQ9Pglq2ZktzzGEPPjbxHYpmwAQc2vMty3VXSSMR0daxdS6qA/z4v3ugwCKKWauS8Ox3z2TeRU0lZwIVM25Zs1t422Ohz2n4AvqQI8eBvB/nzsNEPxPdsrPO1ck9hElGbvpCbgEd1itZVBg4bS5ljcd5Inc9cFWCJpmX1BtDw3hyC5HMWq5pYapdqrfcwC3fQ4LQxl9lXhqhLI0NvNuTKzBSUV2pm+gBBWuldebqjovnjzz+QXGYxmmMjuIlmN30uzhGw1rp9Ehg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+sz1eixFoJt+5OJ4xtVt2MiF6S6XXCWSRNOntq5PsM=;
 b=l3I3hhm2OH7d/3J9YJP4MOk58nZoXtOnI+xVsG1+/opV+B362+rsjQcDhHwqLrodA6IOh265+fS8YkTHWKEWfWpbqH44BwLyIv2TKeyWUg6t+wMeEHJkZ1WMH4hvC43ZvslxNGrUtFo8i3+9ofStXDEVLZCp4Q9QA20eSG0MuEfUx4iELn/vUUK1nYyLnsfrJ+6qw5i9YdQ0xKwUpyW7ydH61KTGnhPw6l1qENIFNYqNh8sOL94Fp701X5Lep32+1KbGZ73AefrQXrOsNeIdN3LK3JxeIDJu4xrXSJxSjCGwqpCtcPUWgina+iLDuutp4AhKzCsWQUytGLo5+idb6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+sz1eixFoJt+5OJ4xtVt2MiF6S6XXCWSRNOntq5PsM=;
 b=RiOlUCEeNgGah8QFOWGsdiEakvlj++SMts6Q2/SC7TUwy+5QROLTBFzmogS9ZbrjivAlgsV8jemlF0LCyAgytuY8uWiVIUNaE8BVUxzsws1gnzKFMWB2cI3q/q3oPRTsVcD6YfQufi+DGh1Hq5+FX4vf6cFEp2UwhJFlSHd67kA=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by MW6PR10MB7590.namprd10.prod.outlook.com (2603:10b6:303:24c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.26; Sun, 3 Nov
 2024 00:15:24 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8114.015; Sun, 3 Nov 2024
 00:15:23 +0000
To: Salomon Dushimirimana <salomondush@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bhavesh Jashnani <bjashnani@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Use module param to set pcs event log
 severity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241016220944.370539-1-salomondush@google.com> (Salomon
	Dushimirimana's message of "Wed, 16 Oct 2024 22:09:44 +0000")
Organization: Oracle Corporation
Message-ID: <yq11pzt9nqn.fsf@ca-mkp.ca.oracle.com>
References: <20241016220944.370539-1-salomondush@google.com>
Date: Sat, 02 Nov 2024 20:15:22 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::28) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|MW6PR10MB7590:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a187358-4ac5-49be-1a8b-08dcfb9c9c5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1itRomhKXkwI1PF/m0nurp6FQ/QhebYAct1nneqeDt/1fzFV4ijyThubZ2Tm?=
 =?us-ascii?Q?AMHlUp7hO8xS3m159GPun1Wxkfs7yaxJrNbGisxRDJPFNdCNX8gNL3SVIf9y?=
 =?us-ascii?Q?zBwfIKMtJYNmk4MPEOic/t/JPjpsrlkOW1VMkz9baGQS/Aei+GClBZn4G8an?=
 =?us-ascii?Q?KKEDctzaIcMS+oWc1Recv02R6iRu3zwu4l2hx1RqPuRRZvepwHxi8PLNG5/r?=
 =?us-ascii?Q?6uxhXezuVrY9NNxROv7CwPyZDjDh47YdL8UOmKQ9XlUtqGhp81/9HvgYe8M1?=
 =?us-ascii?Q?rp3lL1StWi5tWHoof2osyUUvw/OZ3LjpHP9dR7mDjHblgvUm3WrHOgyu61OR?=
 =?us-ascii?Q?qKUhS+ZcGBYF2p4x/qtPb/kK2BKd5In7wmKELiHKSZyXlf/CsD6uFu1sl5pR?=
 =?us-ascii?Q?7OCD9VnXusivWliJ4ZkQluRT6p+La0a+tiPQpyZ27E8FY9d+BKty1m6EZ7au?=
 =?us-ascii?Q?gB34R8CMzCo4ZQUZ/dZ0l6NaupRdi7US/s3L5D7W43KqnIbGq+VyXKzGqCBN?=
 =?us-ascii?Q?rckNBnD8hoTGSvMdXmhHORy3wVto54DJlV47nfml/lKIPR37KfYSOYEqG5AT?=
 =?us-ascii?Q?ZFwJDeebWhUliSDIZ4wpYGq7Nnbu7KD13VFOTWTzmjuGNbKxK4n8pNQgMLb9?=
 =?us-ascii?Q?YJ6exmpbcPM8hxcVcfDibEFbpA2tjy7O3tQ/y50NCaut4kPYG9lUJOWFak9e?=
 =?us-ascii?Q?ZgoLKZXdsrSXdEM2WQpiWKvewl2OjVNVPLUW7t3Y7NawqmcdmkYq0awqloN+?=
 =?us-ascii?Q?ABfNCWpA63xwFeo8N1jOzWtavpvrz5hxQoIn56LySxkt64EHM6f2p7tX5OHn?=
 =?us-ascii?Q?W5GgYqYa2ZNaX8h5k6enzZ0pq0LwuC19npUn8V/SPEmuihGHvwLHLm0LMAVX?=
 =?us-ascii?Q?M62s5MBavszyz4rlGvE891euYMEKwJRljOW8wMfi4mevLvs3k+XPvd2fq9R9?=
 =?us-ascii?Q?caQn8ihjxR5zdtWj32oQKjMXf9AqfQrZwwW94dkeS/W4AMSA9E+9UDWsme5c?=
 =?us-ascii?Q?rzgfF6S2VntR+z/DGYLDypiJ0lWYZguRo+IABt+jGLR/5hbcs7p/YFWJGWaW?=
 =?us-ascii?Q?58Hl+weo5HjuPmRWOZUWq7ObC4q2K7VAhfXbdMUuc01HpJwFw37Xu2uxYOAH?=
 =?us-ascii?Q?acqDszlmd+FXByXxmBR//+fQ6vWxs4XUePPCTh37cMb/gazZJfC3PB8ay4kY?=
 =?us-ascii?Q?pJLOFthdYa3u+mHlKuJiQG82RiIrJiBedRUL+Sg1sEErzYyNcSYeIZA/bKg3?=
 =?us-ascii?Q?IWRE7xTg5Rp3PewM3GeXPMHYu2LTTVNKnyXQt/Q8u4H4Faj95QSwRdHzdNHK?=
 =?us-ascii?Q?4Wi0pZDGyXrykdifvh5bHfs3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g5UYYu5D10+K0G6eTu9FrzjyKj19ndy2Enp7WxXmzL1/wKhT5LOwTTzkXT5X?=
 =?us-ascii?Q?QqR15xtKhcV/lgB8l6pP8uDmeqIpnBR6vIVi2v5I0jbp7PgnGiSvsFNikeuY?=
 =?us-ascii?Q?Sas7okRsW33clEPWY4GNCUrGOAXFKovCqJmOrUTs5+Ks671/4twjVDcqklHl?=
 =?us-ascii?Q?DQQ6xEdMlwRU+nKHDk88Mibf/oIO+mco41Vb0aChVJs6lFEz5VvEpdq8ZlDn?=
 =?us-ascii?Q?rryYj1S3gh3kQWw7eE5UkMGAhRCsJ2gAi0wmfssQx7zHIlg8iQJefHQ1YVk2?=
 =?us-ascii?Q?KElkj5S+Epzot/NBuIWhx7wkPDZB2x77rzQMj2wbQ7pO4ORmfbgwrQRVXASG?=
 =?us-ascii?Q?r4vNMH/yW3U6K4ktpRw+eAJVwHsTBBI+iHo29V01qt+9J0ALOfkhmFOc9uk2?=
 =?us-ascii?Q?phGFqoERbA2sbnOY2z1vJbjiA/nOt339fL7T3yD9N96tgYWFga9LDpldRAHZ?=
 =?us-ascii?Q?AalFABkiGkV1SHI7amy+i+pTl6xfbLQAWVVbAO9Fjxw+qI3nZePOfto+mBB6?=
 =?us-ascii?Q?IsXUKtKU4VnKTx8prxNBx5H/PkUhpX98lsoModAQ6IABkNCIhAHt9d8e3ySS?=
 =?us-ascii?Q?vNPnNY/BLL8q9vHPtVm3BLIMSuyqiM+eXftAd8pi9lHMQv0bSIgIGg0NBVHe?=
 =?us-ascii?Q?WiLOPViIjVUm5Ugb7dmICaiVVl3gCGezC90StLGEm0eMb8akqljrSYjHmICN?=
 =?us-ascii?Q?ly8En7s+EbFhyIWLKSCfGIeSZpCi5p/avrsubqHUtkIyw1y0EkLWj1GxySYK?=
 =?us-ascii?Q?rMtwu7nZso4l285uQFZ9AEbiCapKxigGzjFTK0f//1cCKf3L9GmXu2GD4tXQ?=
 =?us-ascii?Q?ewIF86IV1wB2sr/vXwyxjhdtmUMZpoUxF1POrPA7NXFedyD8vTPwgfVbvMBh?=
 =?us-ascii?Q?nxvJ58sdPztF5JTMbizDkKamj3RKEAMSy/rGefElh03NX/oYfIIVFm05wUD2?=
 =?us-ascii?Q?tRbg3xKQV69KZRPUZHDN7jVJg6zw7ubjPUkDbKCz7u9i9049Fp6PWlfjSDPn?=
 =?us-ascii?Q?SceCir76nKbx780Eaj8uvyeQzThTgYxVVmA9xbATtm4t3Q+sXCM8QTfdtSrN?=
 =?us-ascii?Q?EsY+hw8tfsRIOaA/gMcuWQViHuNWFBOd0SRBdvQFAg4SZ47a+r3qbBL30Koa?=
 =?us-ascii?Q?OxvWlCF1shgii18fUkqTZ/DdW6/IJRdWkvUdwOKdmO6U9M4Dvyuk4RQk4iwj?=
 =?us-ascii?Q?YC0unsnIOetLXs1B7OtNeS67f7TRg+GG8MR1xdsmPraDortRv1pxV4JwLY40?=
 =?us-ascii?Q?QSGQ7Ey3ItdQFnB7SkMh1SPmnNAW2hM4kK5pY8SW05f1mGmPXcP7Z1WxCY2J?=
 =?us-ascii?Q?6ojjvE4rFdfLV5TJiQj3Z2h6Y9R82N9KKWTB4/4l8EmDhhqeX4zBtJ6sUPTG?=
 =?us-ascii?Q?TZCHC4PJDGn1vAUhVKx/e3rZdhiEmhClPkCxCwTfEbgAfUfOY8W2GGP7JhS9?=
 =?us-ascii?Q?07nQtv7oRdMpKwY+iBLFRXGgr7ecD6NxorPFvLKELybDsI2L3vIsZOjAotaJ?=
 =?us-ascii?Q?b/C3uuiH0c+NSZ5vU7ylQXtSHfcZZGGZVNhUTxG6vqcPdld8U+ouxpF3516M?=
 =?us-ascii?Q?x+od8TCnwjcu69K0MAEGVC+c5r+iXZ63R3gwwU2BkXQ18fL+tn9iR2cQKNsZ?=
 =?us-ascii?Q?kQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WlcjXEtnawHmfhDOcYkJE2YFyaL/9eQDW9+nJDBEqewVLyOjeiHpDK3LQZ9qiJ/PK5J3VzxUPsfI8MVGh8oyD5qimI0DB9i+e3lJGeIc4XZ+jllzO1OOoT5RdUblB5q0oVFe4Gjud6dWiPsF9/qF11i4w42zntnmC0nvTj+dW7LONHsJy66Mk7M27cFvMQ6v8PY7lVuf8MjuJM4D0hMIe9zBjsBB4tB8CooNXS8HQBsx7ER0qdWr8i26uRjbwhUPDGZP/99tW/o4lurd0G2Q6sHUC7RviVXN6NJUvscj2khPMxurgoC3tO8E61jOapA+6Oaap/96oa8XKzsZKFEy6wPaSLlttC8KEzJWxqpYJCE/YyGagw3388tdxpZwVqOOBgjYmKvAKFb9o1ieUYWASPZYEDExEiCyUrXGxMqOsfnzTzXdayfe/LeD1ymjhkEVyBVeww78fTBmF5uFGZm9BYZltlOI6lAdQDZskd42QUQ/BmP5Qyra5epZYQNmNu9hh8Ia05ZxMPgHUHD33i5eFxm8Bs0m7UzHWuZPlH5ddT2gHf2iPnqsX4/zzjQpnVnOq4YWejiP+aXlbgC86I4NMmPO5MTEN/6uRDI14ihAZcY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a187358-4ac5-49be-1a8b-08dcfb9c9c5a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2024 00:15:23.7957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npzkeuaVMmtYPHzduvS26s0aUEvOGyXo8+GsFpG6/n6QYlu5uzciWFC39H7uj6YLf9HCDmXXVTLxNJPPISI4hrgKcodGN9yeuGLaWnYVJB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-02_22,2024-11-01_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411030000
X-Proofpoint-ORIG-GUID: s2QN0OtZhKSEEbUkJ7_Y1Vu_DtrnLXIP
X-Proofpoint-GUID: s2QN0OtZhKSEEbUkJ7_Y1Vu_DtrnLXIP


Salomon,

> The pm8006 driver sets pcs event log threshold very high which causes
> most of the FW logs to not be captured. This adds a module parameter
> to configure pcs event log severity with 3 (medium severity) as the
> default.

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
