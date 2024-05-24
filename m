Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96551129A6A;
	Fri, 24 May 2024 08:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716540539; cv=fail; b=uS0k5JpNot0DtGtDz6og3v2BHFzjFZ9oMRZMjqm9oM4V4fkAuAhqJo5ZVSJfPBAQ2G0vgvwMQykVhbBZCbzd6u8pQ4Tn++PVcdTENm6M3mJOU2R5nsp4iNlvi8WFGQXySYMlhERgRthDRlf4bak6uMq7lEM7XPXQpiI6HKNc9SE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716540539; c=relaxed/simple;
	bh=INwNfQHfX2pIh2poyZ+VCP6END1TzhVzaCyXzs3/7LQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=PiCFqj4iCscv+KqZUq7OSDMX6kpGgcJt9tHmKGzFvQLudHehXwG+I5xhVy1xao4pGkoLJi5jjM0WmDhGJ64whTASHJ9JWcgYraaYmfqC6Hegb2SCr/6guj0hV5NVZcyUfiSL5qKMPhFOhMgDHPITQuOedTUpEo+a202b6iWp3Vg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nOQ67Ijj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=faOIEql1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nOQ67Ijj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="faOIEql1"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44O8i9kR012541;
	Fri, 24 May 2024 08:48:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=AbhIAwQsjY4uxbuen0FsVNqRTns8+sSofjvaUpkCwAI=;
 b=nOQ67Ijj0OulFljEYuSXAWq4mxR6mTt+vas351T4HG1vNFVw9fPKAvCZu74qyHidPQ+z
 MELc8nhawxXdUjQSrGMBiOTUqKTYMkmNQRC+2duqB2ZKsVLyCBJuEtbyO0VU3jLRZzlF
 NKiYo7MN4J/0frzKDdZnDRaJzRfVe8737FGyR3NkpE4eti25v9VyiFZyirOg5LWaTB55
 ToXodd8FsvWUgUus3PPidbxX6GAWS7NT08ozcdmrWtu08v7tvX12j119Xwb3CeROvaAr
 72QUZo/ZSomc0E5HlR1J+l16mYmEQGbtwISkHrM7U67xBf+sJjDRgLF7MQugQLRoAFoj Lg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6jx2kwjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 08:48:51 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44O84Yiq002592;
	Fri, 24 May 2024 08:48:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsbmrrq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 May 2024 08:48:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hr/m0XSNeacQB256Of6aQMd7gREZX3F8lGz9vj0dKZAyNg4LI2FsXYbkG0NIMqB56SxqLJiQqbqoPUuZt9x9qv09pPdrm8/5emGbwH61l6vcXQEkwuqDkS49Q81WNVLG1cUYn3f5xNWo3xbPO1XBcJmBcx3iwYkraTzi0EegU7NSzadvcVKaM9qhr8vyF4BrCxHwpC6rKlXzRNetoo1Mfn5WHSH/eiYEdb99HfTOZuXmLW1zVz0TW2OZLMBkqEHGTPtXk2LRvMlJMvY0cQqfn9FuqAZ+CSgUjTeA3Fk3ihp2zXiYd2hGqkeaYF1IfGK4OGkVv7L78CI7hHQbLPhMfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AbhIAwQsjY4uxbuen0FsVNqRTns8+sSofjvaUpkCwAI=;
 b=EB/bB2q0AX41so4FrSh2KyMOO8rfTG3ttv6sAp31gAjLsHWqSWJQ/lQDbxCMosP2YIUHSx5c/kkau+PT/5o+FLVwyjm8BojCu3rVdaO31dB3XsyEv+aD2bX7BcVQD9R02Bh2ABFdBAgk304Gq8SS04Pbd8X4nvx6FTYGt7+CX4Mkov3JLUr/kmbG/hw1i8xhPe2Vx/r1sZeEojH2xG8Fq/zlqi6NCFAsjMRAJ8izsSBMXmSpEudKRA6ew3I+pHmsFLH9PMvP9o7LLnFDHhBOUmq+/5XFpizsowvyC23LQZbms5dLzg6yhzFg8XO0XeA4OCe81t2WygLVtuzdgzWgQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbhIAwQsjY4uxbuen0FsVNqRTns8+sSofjvaUpkCwAI=;
 b=faOIEql1irLF2fV7UXZb9RAqrpGEp+epdEWVMsIXc7fWy6YM3eApaWXLH3DgZ98/wZUxTDibA8E/DBTvX8kEt+qiWHXbddhtavg0EN12d4PqEfuAAmU5zw+E0B9uVreOxQyPuGN1cjhtV5hUALGRzM3QjI2PwN9ZkXZ2SfxNrSc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4357.namprd10.prod.outlook.com (2603:10b6:610:a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 24 May
 2024 08:48:48 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 08:48:48 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, martin.petersen@oracle.com,
        James.Bottomley@HansenPartnership.com, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        himanshu.madhani@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/2] block, scsi: Small improvements for blk_mq_alloc_queue() usage
Date: Fri, 24 May 2024 08:48:27 +0000
Message-Id: <20240524084829.2132555-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::34) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4357:EE_
X-MS-Office365-Filtering-Correlation-Id: 28db69e5-01f3-43fe-edc7-08dc7bce5424
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?3dYCTv4P810QQas140+5M0bSIk8BlkcgQVKfXNwFiL62mZhh6J96f2FUiKhY?=
 =?us-ascii?Q?DvmxFs9hJSfhUp1qdxFiQAXhc6od5aTQ+zw/SBB9srdUmjp4v2SNxDrkWILD?=
 =?us-ascii?Q?79FVdbwxC0PjzzDr+HIiZFOtSYrMGsVKC1T1aJ4nNIE/CXNfy8sHVaoJhggl?=
 =?us-ascii?Q?uwDrBbmas418z25i6LYUCGAVUtMZYEuEMHLliI3NzthQcxSjhNClxOgB7RNA?=
 =?us-ascii?Q?/UPCj1eGjKCMXIiVHDgDGR2tJQJgytge3BSW/RKqux5LazpTmrywfcKlL54A?=
 =?us-ascii?Q?zG2BnE7bM06cG6P9X+GkHpikRH7+IFpJ+heE1LuU9v9/l4bMAQksGDRwPkUl?=
 =?us-ascii?Q?BCZv8WScT0r1+eBU8qUYxKaewIjuBjA7T3I6lpC3X+xG/v++qKG9V8p2iyoH?=
 =?us-ascii?Q?gsyQj+izGdEzSyqq7IfK0Ug7VYfxacD9StYUOMTb9/smrT2uFHiLLzZP7nHK?=
 =?us-ascii?Q?oUmFUfTom7wB0hktLPcxhXDFyu5eIrrzcTo/obrfX914k2iOogCvVs6xvjM8?=
 =?us-ascii?Q?TkA6llrZne/bYvPHWRxEQ3ajH+bfNtOJ2TAlYc8za2WLiWWwONhtUieKPnAP?=
 =?us-ascii?Q?/kqmy+rVa7mIqnFicJ2pCD0cRwbm3nrN8MiyUqfjREyRw7oH1aZ2J5U+uP8q?=
 =?us-ascii?Q?2dx2WoK1lzUNFvs4bw4PCIwA+68YDR1D2O2lewodCQD3Y72SlL36qJakf5iW?=
 =?us-ascii?Q?zNvKRwksatdmr2hGbJ8ilLtViAs9s0WW/Bg4LFc+MQP76tBp7NhKlR9E592G?=
 =?us-ascii?Q?eESo059JAcXTjHA5Xyx9q8htARRytaPcC7X1Tw4EP/tRerfr4s/60ENnnOF6?=
 =?us-ascii?Q?RXtHLi207flBCcgloH9C/yisQJ0Uu3c4bCZ+C97eRcQvwIG03d3qZqqgWY7o?=
 =?us-ascii?Q?xfl+p/PVlynDISy5JJzf3gUbUiOuXad0zUEkKqzDI2yd/COLOaHZtx6nfdrq?=
 =?us-ascii?Q?Aqq3Sx/q9i+H8htG4D0h3LfODiCF0gXrvceNzJAlpWrlr+l3NEF6yaFVXAUs?=
 =?us-ascii?Q?N/PZkpq5X3rGbKGYEbjiFTTwkAcnzki6WOR1zvtHUxWnkHMOxRaO0ZXLBYkv?=
 =?us-ascii?Q?5MVRlnqCFKMUHP6nv5auKyXfu0tdNgktr++cRlRFvsEN9VzSSoV3Rkpek1lW?=
 =?us-ascii?Q?4x7CYaX4btQ9NX8Q7hmEKXsjSI82orPvWmvcUbScDdTl9dqH03ApVniBOwNY?=
 =?us-ascii?Q?q9qTpSKsgq9PbaY/XaSDhHoAdIQ8tA0yxy+MWzSWcgC2f7u1f2X1etR8+rRu?=
 =?us-ascii?Q?wj0zah3GHWICwU6Apw4P?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?+G9VrgK/j/kLWz9q2iJ79QgSvpA+UrNQljcArYl7bjQaxUfe3gkjuC+eTf2U?=
 =?us-ascii?Q?JR+2/33O++qr3Io6aD05Hu9w1AANWczqWDgLf7e5qhCzVXsKXUd7yJbjI1PZ?=
 =?us-ascii?Q?L0MDNKjqEWa6otbzDHMSTKlAe/5uf+ZbQBq4QVqeZecYEHMZ7VKGzMhQOktV?=
 =?us-ascii?Q?Wfmt260m7hmvB9WBfjnPuJr7WtIdUUo/0PC+lv5fz6DWvOjHHkxXy+NDPpbI?=
 =?us-ascii?Q?+/xVUSxQRrRlsc6+RFVqqb0461FpElBoM60FJufVyybNvaIqb5mZbIqQh9Vd?=
 =?us-ascii?Q?bbgnkFZnG3sf0v56AAZWqy5dmiRN7hZcAfgQ501ebjxow/tnCgXFjo5xfbSW?=
 =?us-ascii?Q?UNNDMkrTVHLPcMvgDXSmTGZN6rpeixd8ggvOx+jRxpFSpMnHuFByEc9jxiQ5?=
 =?us-ascii?Q?tenDo1jQU8ArDXcJ69E6vnKqhcidrd2ebGzF8XKOLkobPduJz/FeGnOfWDb8?=
 =?us-ascii?Q?4dYNhj/pGHVvTOWLIj+j9bAImjSyVHmL/pNXcO/u/rGAAE+Zd3nnexn8NNdJ?=
 =?us-ascii?Q?Wio13n9J5LWLZgwUjB3g1S+u6H/sN0uEd7kM4y75qUiwy09+OLFfiMo6nlot?=
 =?us-ascii?Q?nBP6jeiy/picMYQPo1M3KM/F377OnGEdx98E7Bsurz2ZymkpoWyVqO2zBhnP?=
 =?us-ascii?Q?qQvlkfUvDuu57J4ieDJ6IX971hku6H/GpG44EaltU8V67f+N+H+5VpqzljLN?=
 =?us-ascii?Q?fYpO5MMccJya4I8PBnwEOHxwjTTXCKgJ50abRhoX3ixbelQ2crX72uWhagjI?=
 =?us-ascii?Q?2iekO7MQU21q4lqlHpOGVa9VNKbfKJrXRLS6NuguSC42pS72C0F+Cipfj4Nq?=
 =?us-ascii?Q?qjQrP5FJs/mMeZ+cvO3sUiv+qZccM6JG0if4WrErjNVX3OsHazISN+R1Pg56?=
 =?us-ascii?Q?u23+lKEPK0DBoL4WiqnRGVsgqXg60ycPAUuHlCDmtdFur/qAq4t/rlX/vIr3?=
 =?us-ascii?Q?weuVadYBW78ntPnAKduXO2qze9Alhycdlqg26T26pMuPixdgWwrLgAXLet8b?=
 =?us-ascii?Q?11S2V7HtQ2/pyMWQrPNRoLZ54Aq/A6O0+04hsXxGV8z/kC15PBmpjealjO8f?=
 =?us-ascii?Q?x+z1gpsmdjnnfAORqMqli2+JeMj9BdOzbrJpOTSfu38uTS4Ay/0MWSdO3HeX?=
 =?us-ascii?Q?uqNDsyYrnbQH7E3yf1MX8c8kTsP+Sj3KmgKxST1Kglf0smYf84ByGtiYU82k?=
 =?us-ascii?Q?aPwS1SDb+gNbTvMYHq2qC4VOsJ/aLVMX+23EWzXEpJn/IhE2Tnoli6KWjT6P?=
 =?us-ascii?Q?/5Zi9+he0u3DdfZGwQvLgPtXsYxuBF/hz57n5H4Zmgz5Gn7wfKen3i8NGlDx?=
 =?us-ascii?Q?JqqtIHZMEU13dwbJpiFqmUBjSRX6G84vJCF7HdXRnO99Iv2pxHGaRc74r5Ub?=
 =?us-ascii?Q?DsYYUC7ByffeCjkln2BY5OiFbn8uD/Q63Aw3uMqL7/z4E/LdvNr3SA4LgnMB?=
 =?us-ascii?Q?vmC+OKjjwnJDI4/mDYEXAXazkCcsst39y53Q3WXq7IlMwY3mq1C2Bek3QOw6?=
 =?us-ascii?Q?TnQmObPYBcBfQx5p0NRsyc/QPiqQKgkZwBB51rHuvAk64mB0WwgrMqkA8JTr?=
 =?us-ascii?Q?uJ+LyW/ARCFB/pZ3Zr95qetdtf85jhENjhBKiyZlfXapBQlvZnmACfvLIi5S?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	m3mhfGa0o3yOYHXiAxeCA8zU+oCrnSi4H2WxYBGN0rwOdzYv4gW0yZec8hDEZhOPbm97ZYdnbx0tn0fqn6tcl3iaRfrd605BRLPWvr5/JUCibwprUAop9epdtpHI0fpCPy+4gmYzyKYDcV6QOMcCfzCW6kIx6eRN40SBL2i2K8FAa60oqtOETt2n1LeP3D2E1HxlmaDMc3BAhNyYEzTzmX1zxNHEh9YEN0MyoO6+jPSl6wnUcZ0G0c7ABE6MkgDFOawn69+lK33dDZ8rrlyCSFC3fVHhVkb2mb2UZibrtyexKVC2olOWdGIPd8XSQxegZEyugDgC0lnYiYcFPWg/PmzPYZmNYlzzsvdqeSUFbeQ+Id6dnroq6pDvu6/X9nuk40T+jlpNs+/tYqcLLmEtq7dkDi9Fd+VKGmveJH5dF1sx+XGs5oYePHt4W3FLfA+ZvdjqH+VzcAJenLUZ6oVvLzF+BGJdqScB74kuO8SFGH7JLxHGGFXfX2BVowsiFFZQqd5ZHup+4iK0EPQkef+dTUm/qbO6eZVMrFZQ4VLZ9KSTFv9Sb1WUlK3coW1nVpsdy6D1c+BYHat97qjYHg/DpGwvkz+/h8m0NApxDy5iwJU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28db69e5-01f3-43fe-edc7-08dc7bce5424
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 08:48:48.5874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /dfMQvw7YubKiZocxOj3BJ4BVJkIlw6rBQKLCXY0hi9ejgakeBsYFyTFqy4FL/hScYBgC0YLahMImst+dLQapg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4357
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-24_02,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405240060
X-Proofpoint-GUID: 8xtxbZ-oG8Hw5ff5JyovUIR_6TrPZrcn
X-Proofpoint-ORIG-GUID: 8xtxbZ-oG8Hw5ff5JyovUIR_6TrPZrcn

A couple of small improvements to not manually set q->queuedata.

I asked Himanshu (cc'ed) to test the bsg-lib.c change as I have no setup
to test.

Based on mkp-scsi 6.10 staging queue at e4f5f8298cf6.

John Garry (2):
  scsi: core: Pass sdev to blk_mq_alloc_queue()
  scsi: bsg: Pass dev to blk_mq_alloc_queue()

 block/bsg-lib.c          | 3 +--
 drivers/scsi/scsi_scan.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

-- 
2.31.1

