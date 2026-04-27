Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653291E1DF0
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 01:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777253608; cv=fail; b=ZKfyO/BOLVtb3LOe1DLEiZN/D/93j7+VM/T9XxWFWf8Z7BgorNZ7cnCJmpxB7HA1mZc1srlxhIIJqLvjtsuHK0lua+M+MEaGCG/OjZmvi/qVAlu13oYevRlV19eFbpFTdFrKsxzvOjKw/aNyOdUXpWagQb7ZFVH5/E3w2vG4uSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777253608; c=relaxed/simple;
	bh=Zk85Br2lFfBxDGnbA4w+cNAgsjtF9UsKmgXHP/73JV0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=rGW0ClRkgXQJ7xLDaNHXoV1+J6TdxCrqoepCcdmOpYFRZvkPe+3l3eHqB59AVlQvUNqcjMjVdozFN7EK21fp0pkA5jwAnE2ovL/xlC9RZ6x7ALzpcO8UB91IeLed3hfx/czaY2YZmVKbLMOKtVvuszXYvjB2jFm3hoHnHl2xSms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oBwUwg6A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AN60kfbi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oBwUwg6A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AN60kfbi"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63R0p5pS3060061;
	Mon, 27 Apr 2026 01:33:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Fe29vc+w591Ijx+Omd
	PkXOhAkCv3bYFNQxSRG7ExfDg=; b=oBwUwg6AHl+tbeI8IZqw0C6pdA8a85IhyN
	C+0DDPlkwx8bMX5PXk8yLUEuWQaw1Lf9JM+hSn7RQAJsXuLeLV3gYj0n8wptVSb8
	WvZk3Ak0Jk2nRon23LYEaC6BYyhuE/NeuuhlViz5x7CC34ys5xNgR0EqVzp9i0c+
	R2SzWP9HWDxqxcnjV97Y/yJ6vhU05EIRdX8vu2ZX5rBRa+14wXosnCr/9oKoj26C
	Vb8qXlERxXuM38LABTGkoHrKhrMBdmgGA+oYEK26BB953mGxiGaNwzzxdoKjTljn
	3c9zdp9XtL/I96eHb7NzvbifQP6hZiaVUwLEoTqgUyYFPZaWfkXA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drm6yta0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 01:33:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63R1VMNb021498;
	Mon, 27 Apr 2026 01:33:17 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4drm29uges-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 01:33:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S+r7mQWRv2W4qE2feA/lZPa6wbZKfM+c+itu9Y8HLK+ebacnoLljJQGLQHei7SZ0sPK2c87JQpEmW2hlb5x853POmKlKKSMG25kL8YCPxEqqXfB9OznmuookRO1lureamrekSr/GUdnMSq9lzLk2vGuWwMJ4876LEGbrTQT3fpdKbr0i66ITUzuL4tseD33wOpE1lsSv6U2pMzuVJVEJFKdHiOG5pTnvUfaMZ95cUUkOuJfHOdke2H8GK8zpGWDefquE4aeYjOfK4TDIGuwdbrO5wmeM4GowF0Bf2R4NRfGWszPAV9wk3ngTSyPpYq9PKI3daxpXFZNDlWg4fzvJRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fe29vc+w591Ijx+OmdPkXOhAkCv3bYFNQxSRG7ExfDg=;
 b=TpsbFFFJevokEi03J9IKR+/dyqA+PCi10YTAYtXcRKtfwaDUT0V9CBX5IyFYbRYrYQ4xBv6uck5VhgtWnlhK0ho2Jy4q+cq3qHVyFaGbNaqAV2eBIjg3afksRMHDlsoqJS+EYN4rSuxNn2XdW61qc76F8dA6xBnWu17/kWLKGauNe0gBFsBB2UmPZqjCfgOw5mimDKoxzfHaBVU+8SNi+dZzfIYkAJFYlF751hYHDjqfTc7iJswoOipimfcQAfQjKR2NjinnvUcLxI7nGSnFtQPSrEd5hq4FiBq1mxIPh3xP1L8rtu6gm2YS0Mw0Z6lqjW49L0U2DI2TcKhSALJmiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fe29vc+w591Ijx+OmdPkXOhAkCv3bYFNQxSRG7ExfDg=;
 b=AN60kfbiQVxDOHUTmz2R1f+frYJeGVRHbB4+lzmcRWNV8AIc+7oLoqZTo0jTUmnysthAJslZ1lU5nG2y5UNZkXZYj9J31oh/0sQbSi9VaRFxgNzzi4HR0MEVIftYvvz7jiBZcWYKO86ouREM68ZbIhl6E8N5sZsm9vNTq6QGNkk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV8PR10MB7824.namprd10.prod.outlook.com (2603:10b6:408:1e7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.24; Mon, 27 Apr
 2026 01:33:14 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9846.025; Mon, 27 Apr 2026
 01:33:14 +0000
To: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>,
        Mike Christie
 <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, virtualization@lists.linux.dev,
        mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com
Subject: Re: [PATCH 3/4] scsi: Support scsi_devices without a device wide limit
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <3c57a174-ce83-43cd-a46b-d0eea752deda@suse.de> (Hannes Reinecke's
	message of "Thu, 23 Apr 2026 12:32:06 +0200")
Organization: Oracle Corporation
Message-ID: <yq1eck1i3wm.fsf@ca-mkp.ca.oracle.com>
References: <20260417230751.117836-1-michael.christie@oracle.com>
	<20260417230751.117836-4-michael.christie@oracle.com>
	<448302b1-3950-4e6d-ae8b-337cad09f3fe@suse.de>
	<65e78d0c-23a5-4702-9946-60b83532a61b@oracle.com>
	<3c57a174-ce83-43cd-a46b-d0eea752deda@suse.de>
Date: Sun, 26 Apr 2026 21:33:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0227.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV8PR10MB7824:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d385cdc-fa59-49c1-ef59-08dea3fcf325
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	lQETQRi7XevOj8RuIElNE3yDYgYwRS7t8PNWf3SPoXsTwQaEZGRLqJc0BDlXAyWRHBtGqew6BNBu3Wmeu74eIq9QYa2nYRHIjCTJuGKAfOv+Peuf6gNCMby5/5mwjkozQLXkdTO2uncZTe7WhGR4VEDjfR5Qgb7+WpBK3odM5oXkqo+QngUk81kLWroxR45qrKeKGEgGmQk18CaxHJ+zRHLuHy+ucoYu+fdzEBFDPH71pDo8afRa43mbtuBY3gJqPtVKgXpK2D83nwc3hOi5yPrHhPgUZaqzBAkHCOUpgUdpKJFcGxlqnfIvs4MgnVunqhyzRx8v2o6yYPgWFgFb28kGBh9h7I1Zsm9d0MtGZWe2/V6YVcGNov7iKfQJM9DnR1P8icvRYBSCMpLNYXZ2wwFzLLF1awpr1jdj17N3YWRUJZ8YLmYRvoDlG0+vD4zYnNyk/tL7+LKgqEXvwoYBLJSVvqtaZngF0b3PfaZRq91X3xwISApNEplyXGOl76S7tcH1Mu6AahJlYvfW7WGp9yOYycAwx0NDmOPc5sg1pz3oqu2qDDTu+JAA0YTjitfY90gzQFsLKLAqtgWdeC0DZzBOIjoOrkke8vA8Lxx56vfs76GBFvXmPUL9J8Xc4zHFg81Jhu6MLWKyGT6lR4rnp7c8yp+aWZlqHb0cGnhSVxMYTuEIsy4QDceKVldIMJcACb/56HawTQZ5axfJkkgMzInVVk9xSeye9MZwQegfkjM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TpVE32ePHWfKgOSFswB9Sqd8nLpykUsNwB4M4pHZAeEuaRMz3vA5zJ5Bz6Oy?=
 =?us-ascii?Q?zxPjGGaSEj4MmuBNNFBlh4hZQE7FOOiQgogqy8tY3YUHjAbud5i63ECHi30h?=
 =?us-ascii?Q?989UP1XdnOtWOb0o4fF+Arxun4D3nzFjtXKkSUve0BjIwcZJe7zm3lccSlpL?=
 =?us-ascii?Q?WKAwqR62m9lJ3YgOcBai/h3oM4H56ZkqSnDQUAs7EFW8b4oFloXuPcqGo3sB?=
 =?us-ascii?Q?euuGBipVjp5RQaieaYwyovkwP18wluhGTZzMwlEACB32obp+A5iZ5URLQq/k?=
 =?us-ascii?Q?F673l+0Gldim9QSJBlwV9dzvJhVH+MKBHR4DR4pvSQaYLIfycm5Pm5pn6/ks?=
 =?us-ascii?Q?5i0bWwqW73pwkHRABtU1K1Dv52i1XmDzVWmQrbTrE6PkRNTo6W8WhIlEUF2e?=
 =?us-ascii?Q?3wyR4HpftfkXsqWG2kPs6v1mjBRY9ZqSkqtgvZh8bnsHFYrGRkUZGPHGKGtW?=
 =?us-ascii?Q?OllaKO8Y4KfSBZ6BroV5Zv/wYik7XDfjDXuzsh342iubnXVB7ipr8XIyApi0?=
 =?us-ascii?Q?8aAnFaaPfigmqRSKNlOawDN02zapJyYGgTImJ9LT2ZeDSpixQSQirt5W2HBS?=
 =?us-ascii?Q?828RSIrpb+RM0ls5zo4qKBQEeW526v0xGiFyiItD2heJH7lDONpLxeGf+S5z?=
 =?us-ascii?Q?40RaKALqJ+jtFcqNW/RR8eFKLVMFBDXsd2FVSZ3AHQ7a6TQwWQtv0Uwm7okz?=
 =?us-ascii?Q?LmjiPdXeAz5sXCRo/G4AzOKcP1P3SRRbyYWz1Pl4mc3v0E+slBchNBxjDja3?=
 =?us-ascii?Q?+lImBAG7plmWcKn6kIyXwksRH5mXadBgFVeD8VCzjvkDIdFupXbaaICSNKt+?=
 =?us-ascii?Q?yROrGEUONYTpQirg/v7Fca7L6kfQ8UWlk5uXrPJ7aK+H+69Dgm6PnHejWMod?=
 =?us-ascii?Q?SQaUypLKqIAl6kKy5HLpIyhZwRW7mfENDIJuh2PJbtcR2f7XLOjf8/w2iDm3?=
 =?us-ascii?Q?Eau3W7x4Lgz2BrSNL09OshHdGoaszzyTHgJe2gQyR1AJbpGwTUrQ2EbduxbU?=
 =?us-ascii?Q?DwwvNWve/DCsUpbEfX9+eRGKn+JXzVI8ETe8cCQ1OoxOKKV2qr3EkOmOgsAU?=
 =?us-ascii?Q?JfMP4a+V4ZIUPUtGTeKIAT/y+AgGMyZaehmOdQOej9TgqGObkj9SSXZxEdJ+?=
 =?us-ascii?Q?zk0EbQ3EFExfSCnyqFQ5VqyZ8wTlclKWfIB6nQlpOt74aZqHdePmlGeochMC?=
 =?us-ascii?Q?3ZKAHp4ZNwkfduoWSUDZuI4u6MgLH4t8cYLszXSdhxnQuMYEM7Q/tUyCiPhT?=
 =?us-ascii?Q?reFOJa4OZWdd6aPcRKXqy9NDMPTTVp27wRie1sk7hrEqywEiii2bhrbF0YO0?=
 =?us-ascii?Q?ejPPDeIjd58BC3NuE3M9LzbxkD1yy+YRtcZ9me9L8i+ryByHOcEWnL/rrvcG?=
 =?us-ascii?Q?lTMcHcVhjhWd/i7bjq7OQF1lhSF3pY/yEkv2PXyhw4feGfkpJg5XmwF83a/4?=
 =?us-ascii?Q?/8HfCC63L1uoXRzToz9DZko1kaoIHWoEpmBfRbx5R9CGUi8mOF+/hylox6gP?=
 =?us-ascii?Q?3Sybcq/4Go9vAKcryC8juTmugtIgK++PF4alvHNMzpy1PHNq6P6IujjCDlrf?=
 =?us-ascii?Q?2FpKFF37I7W+rQqh2shjT8A0WGsYfeZ+xEHOz1Uubpdu370QNjnKwpS3d7yh?=
 =?us-ascii?Q?xIVzffB5TJxv3uzwhNwiq3taXefoIDKRG+XGD5d+I8+63fyy6g2B99Ub1oKO?=
 =?us-ascii?Q?D4+dkCsSelew1XFs3n9H3TYT9pWMfnJdBtLV4CMxstnh0N9AhwsYlTXnuGIL?=
 =?us-ascii?Q?0pXOgdlk87kFvvjO4O6QNx3lGIvcXt0=3D?=
X-Exchange-RoutingPolicyChecked:
	X6IRq+Q0tMxzId63jW9shBR+48fMkQRzd4o55DsquFhUvhorwb9NDfPvsh8QSf8x2PJSbxvk6MwNECeddEXzqxu1lp0IXAijNGD7b3I/uS5u1aKuN7/M7Gr3MhSbXVe3103cpz+DQx4xcDQL4A5pi/GieE4XBna8jE5zLUdMZsnh97P6LuujUUT1jOUG69gmYfPdkBP6Jl1R1RHhnF9olrfDpn1tV3xM0wMkau5QXO8x6ylr4Q6zgEoe8pTwa/vFpM6tzTTy/ZsXTt3kZxzu4gHzZsPK3Par/e9OxDJX3DuiPtSLUWDCU98MEe1mzOiq6i6/J5qgyqxBAyY+lW7k6g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	payDVfc2YedLyaCY7sE6MDNWlwIcT/G6pW3f8T5Jx4uKonqtfpwwC/+QKFPhUTybqIdhz9c6syalcnC7WL5TwNhNc01IoSoytHtMccCR5yD/OyNBepsZGvpwcBIh7G/+pYlsgw+/IaSa1zN1zipNTiKicvayqm/HMXYa77+/6+oUqj6bGimRNjNA+5wdOuw8xCsA/qkdlV6aAxrTQBxbnlyrgcvUQBjwAbrfwvqMy6tTcFfJqWV+9wUoY1oYVFRTRBU0v/3+RgILkhZFXoDW8XmrcMskltU+CHxqbu5vmNX/+lGCH1e+YVX8xWxNhy+xS/3N84GUahoE4bAmEQZ9sXQ3/qBt8VJ8sl5PHHO4RYiyZYfJ5uxgLCMS/SQ0HZWrSOaatWXP6fpZFnweGXSPLMD+hWBTagBiixHBif3pj8PHgfjrUtK823b2TPDGHWKXdyWaxYeDeO+jJ/3/GUSdQi3iNF87RmeuBf73tpEaYtXheVmrTVTg4lI31DvB1IFg4UAA1/5ujSL3j86fssFU68kFB2tHgRFtHXuxeN3o2D12DkvDmUTsLb3W/YLcQXnAK459TRvbK8R5c6pO0KNVLIgH199HGQZYPEZgTphxTPs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d385cdc-fa59-49c1-ef59-08dea3fcf325
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 01:33:14.0815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CS2NKtwQLeZEXC2HQVyEu65E0A7quqN/OAltqeol7nEcq8oxRLsz7L8IA+EYNTfX8ULm4pBwTFHWtCzfXELYgXcfMoYXO63URIGlqBjLafQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7824
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-26_07,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=757 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604270014
X-Proofpoint-GUID: UdUGKs_3lXUJJ_OWaAopquUXuQqNxRTW
X-Proofpoint-ORIG-GUID: UdUGKs_3lXUJJ_OWaAopquUXuQqNxRTW
X-Authority-Analysis: v=2.4 cv=BePoFLt2 c=1 sm=1 tr=0 ts=69eebcde b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=Yz1ikNO2-dtwGAOuGWsA:9 cc=ntf awl=host:12310
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDAxNCBTYWx0ZWRfXxUe35rnLX2dX
 EI1etDcUzEws761KI/zbtrWJvgAD6GfhA107QSyj/gsW1OVc8tsjyDfqzgKrhtK3hvr3QB0dgvF
 Yh1pYr0CoMd2flviI9ChiMcjdZDzRbRoAHmRY+oEGyaMA/3XaDRMdoJslE/t6M4b1Qey7GDOr5r
 wqSBurtjyPZrsOGUTGkMAEUUhSgHyxC8O2uE+tXM7TqV8KHitFwGum2NA1CCIEZbW2xKF8XEFSW
 RSBNcZllEL6EKJqpTPATZGI2p6bRdvx3lhGX8LsrhpaIrGSU3xL0+iVD6RdZpMW9/5jqhun1RsA
 ofRsqkzn+ZFArLiaG6Y9iyDftyGluuCy963td7XkSzoqm0fbWVW461z0q+Z8ZBZbr4oma7JbdMP
 L9sPxREwiWrCszDTidsarwJANPG7CkmKfoLFhu31DBkyGS7wp7yCfdGV2+boejiNI4xm2ZI8SjJ
 gmfWQCAZ4kbuFgpDpK19sAV1gBxr4RtLs0nM9I0c=


Hannes,

> Let's see if we can schedule a session at LSF; I really would like to
> get this one sorted out.

Done.

-- 
Martin K. Petersen
