Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D010148318;
	Thu,  2 Jan 2025 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735840525; cv=fail; b=Rxjv2oVkQy4552evb4+tQRyCyefqXF66UwKfpHBPT7YgSk6ySGfVLpPpz3mPbQalqV3pX5ynB2xuXi4Ad2H2oxDDyXD2aHTPATKEjeIMIitB1e+Yp64Mf/KMUd2d2/j09pOTysxFE1qKaDBO1umRa4aeWYo9qrivbkrn3sVg71w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735840525; c=relaxed/simple;
	bh=24wjQDauXytUE+W0rGM92SJBJVe8q63ZD+jbts1EbaI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=QrU7hlA93lRJUjBHLaDj63rvFZ2WxlHcDTQ8zi8qhQzi1jtzBJktU5Oj1ppkiWN3mlFotgNdBpoz+1cFZMVkHd3/7cjq4U2GH4ZYZd7xElQSyH5b1sjmPushCmcYtJsBKh7Gts/XlXdyGC+LFISlBhtsOG6Wee5nZIogsiXC85E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GzA6/YFV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=InaBHw/c; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GzA6/YFV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="InaBHw/c"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502HXoj5023831;
	Thu, 2 Jan 2025 17:55:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=M4nIDbpyiiUJbCBLk+
	58hgjopAZQnkXJT3fRAv3ozo4=; b=GzA6/YFVbfct8eapo7/idHQi7AL6XuLRcL
	Q004EZTS/FwkAGvr5CQ7lvsRjXMmK4SrsW+IHz4aEWMAzlduxWpzvKVfkdZy7CNt
	eSOmWAyCM5thFYcq82VZADUTtIntbKNQVE2p9XChYmhQhgimgwWBNcaCgIn/3MgC
	aoyRIOa90VUzf9H83YQ3OrDwe7VDvUmVVlyp+G0I9txwMHkNp2RCQaj2ekSMDPHH
	ifsrGslBf28UCTGGhY2ympwP4kb6w/+uJzj1qiDJ+D14ylYOumOQWp10Q1VordWZ
	/37YuI2qTYikUSKqZC3VcWV26yU4lHOsT4EXSAw9ibKbXx+ArRsQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t9che77d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 17:55:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502GqvfZ027775;
	Thu, 2 Jan 2025 17:55:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43vry1vte1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 17:55:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eT22ER2u4UgnAwxIfrVa4JHBiIudpUrkWK71qGcbbErBy7Nuule8MBYZCCh+EcUrVBbx9zI5S+ugjX2n9mmwszYocst/0nCi4tltbtfz80iR1589mOpFKNkKBF9ayVdXJwY8yUIt//bgVVV+9svAbTjk+ZhstKxZxFMUHjMt2nCwsdQSQCQGQ1RN01WDYKelKXoMasZ1u7W9cTSEIwDywWqvMGhRYuic/3U3U+UGjKY7B/oGWQXfG2L8CEodMj7PuEcNKYsi646lxAp8aT5p8IJaq2uPky5RsGlomVjGZ/xAjYMUI9o9p63h5+uifRx+hdMkW3O8mrmqVyGZ3LULJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M4nIDbpyiiUJbCBLk+58hgjopAZQnkXJT3fRAv3ozo4=;
 b=HHDXbVnF55NUCg+SHeXGx1lH87B3jdwJCuuIaa20wCTCE3KvTRv5WXHpBJ4+uMo/qJN5RKQ3EPR4SDQcraB6uZptJcfk7YBqBOvAH8mnzvBfTjoQKh/M5ciHTGXp5wu8J/1BJw1i39NmQEbAtlAlk5HWMD39gDHrxbTZpdkpRxG86heEX8Od+9Wmzb1xoO/+McZccKrz4/rhWPJ+5gLFxv5Z0Yz6ZVfwrGuvdOIzQCwqFUybnuNo/vvRTRNCEcxQYLYpNOgwQ/XkYsMiZkHc90iSTomXrNxcN3w09Ug18t6iyn9xTEBuvmE4idclI2btpTAHRpHM9OtnMTSfOF2rYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4nIDbpyiiUJbCBLk+58hgjopAZQnkXJT3fRAv3ozo4=;
 b=InaBHw/c8Y2lf2fwfeMuDsCLXDqYK+TiCHwr6Yky5O2sh53joI5a9/958LlNHk1U9aNdMY+YsRBMISJhAFe+r6qyff8OvjIf5Rj3pcead78FLNC5jOTaSjfl/EB1iJLm/cdTj2jqS8uXwPenqI94yX7+xbSVOBA6phuUuOuaKm8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BN0PR10MB5111.namprd10.prod.outlook.com (2603:10b6:408:123::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Thu, 2 Jan
 2025 17:55:02 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8314.013; Thu, 2 Jan 2025
 17:55:02 +0000
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Saurav Kashyap
 <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 03/19] scsi: bnx2fc: Use kthread_create_on_cpu()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241211154035.75565-4-frederic@kernel.org> (Frederic
	Weisbecker's message of "Wed, 11 Dec 2024 16:40:16 +0100")
Organization: Oracle Corporation
Message-ID: <yq11pxlhzis.fsf@ca-mkp.ca.oracle.com>
References: <20241211154035.75565-1-frederic@kernel.org>
	<20241211154035.75565-4-frederic@kernel.org>
Date: Thu, 02 Jan 2025 12:54:59 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BN0PR10MB5111:EE_
X-MS-Office365-Filtering-Correlation-Id: f54060e7-620a-48c5-5e0c-08dd2b5694f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mYcqUflwc3mKZLnRaOMnbD/pAW0m6+slVRSkOg5INCfBGNpfCafzCaZg2Qm8?=
 =?us-ascii?Q?BytpNbFg2pyKqc+CjQRIi3tERNCeeh66YBpn5kKKqlgTOYOzG4DFw3QL4pQE?=
 =?us-ascii?Q?rJ7rb6isvG1mslNiuVKoRfmyNLtz3rMM+eDAT9K+GevVzjSKOPWlr6rmZeCA?=
 =?us-ascii?Q?EuamGX0CM4V7IEgAqjx1d+bpXrIwh/hI1T6eLDa8ahYvm/3QF4XmGUXyD8IX?=
 =?us-ascii?Q?I72RkvetIRvFy8pybr0VMdcLkpRSw0VB1eVGRGLtuDgfPm+rLBeBUf9Aauri?=
 =?us-ascii?Q?bdNpEO6wpmeXQVVtZWb5wwAK3U8S4I7gdTAwc0XDfzlEIp9tiq407ba+jP5/?=
 =?us-ascii?Q?zGCZ83NRod7V8lN81+L1XBqngItJ+NmwpJrV+eXjV8P5ETcvPiylejYZFml3?=
 =?us-ascii?Q?JKtbgrVstwmUPWPQvc0bpKljOPBIt8dEAHUHCjtQgHJxgEcLD9mnubDHMVnO?=
 =?us-ascii?Q?RaLID8sfgLCU84TgOjAAQs3wS+rSyqXpoo5CI03H1yF4Sx/8PKLMJfFwGjJs?=
 =?us-ascii?Q?FbpuGvfIXli2VMsJh0/fSqNL0wlp1HD6KdRodneZsyF5Ug/im+Bk9H5vyuIy?=
 =?us-ascii?Q?2Re38Rkn5VcYVC5cJIE4mRvyhyR3MD6925Ojl9t+1jA3fmc/JrbA5U/ocEP9?=
 =?us-ascii?Q?oGGe1Oqap6es4U6uVtKn1YXTr0FTRztKufqT5puPjUx7DGNKa3FZE3jfIzxH?=
 =?us-ascii?Q?UQWou68uwwmV3Qwe3+2hGbF4nPf8LMScJwQZdayuBKroPlYZQDmgbuPcuRwn?=
 =?us-ascii?Q?RfzZfnJ01AGX5vVNT73jIyoOxL/6Bq/+aMTZg9DUjQ/zgvKuurXupNVZgZh4?=
 =?us-ascii?Q?vSUqQ//os9NmbyPSjcVo584bQjPHFY69cX0DGWQRpZVPN4F1LDrU77FjZHpg?=
 =?us-ascii?Q?D4laB6J4dKEGvZZdWAfMQFCJZwl7tHYRoSApMzNcVvQkyz588BF9gafbG2uH?=
 =?us-ascii?Q?8wR5f5VTJHZ5JTaPWI2VDYOBIHC7Zi00TzJLzcGlLtjbofFGbq2agFqOHCxT?=
 =?us-ascii?Q?7GgU+yjRaVDKvv6oEQYATXjoku8wxJCtDEKbahI7oZdOP0/jkh+sP0UFHYs/?=
 =?us-ascii?Q?/SFDnHTxKg9Nn30KGQKLyEkrARkfcQlWe1B2gy+7VSgUVNrQQSBoYWGTe+KL?=
 =?us-ascii?Q?zyS4BG2hiJ3oWUHHAzvq0jNalzii63RfQTT8E/YwtTm95qtNAUrNK4BF1tm2?=
 =?us-ascii?Q?bMnPgMENp6BhnDCledcDDhRaOIrAeRLp+IiERlMSaqVGakT2RNZSGqptxZhG?=
 =?us-ascii?Q?OIB+u7pSk7omLnj37ElLAgCkMDxGutRTEtroYx1cTOVp7eAKlK297RncSJpE?=
 =?us-ascii?Q?b9BQout/cN6aln/+xzWg0ny2FJPTJ8RM9yRPFPEYGDKQDGs4baVJejRsdKNI?=
 =?us-ascii?Q?us0eL95L6KzQI0i5NqwANH666DF/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RH+tMhR9YysJOUlcLuonxlccTZmnO4tofay1QYWqfFLz7dWO6TCnFwHoeinR?=
 =?us-ascii?Q?4rjEK5Gxdu/D+W4LyUiGYn1rViVV+xN+wq78kqIh6VjZd77ibaGoVQzjFabM?=
 =?us-ascii?Q?xCiICuRWExiE2/ETl93y/c7cw4NuIciRADAOxbYRpgVnZlvDKXzqS+tQN7KB?=
 =?us-ascii?Q?sC4YqOYo/X/bJgojG/jFcUumYIgOA5DcDnD2a02dowD6l9FsF0XH21otDvqd?=
 =?us-ascii?Q?ulVU7s7L7f3+1fIKmXxGovRsapxqZ/sC/CyGzgm27hfrroHm1EZN4SMNfhb5?=
 =?us-ascii?Q?NTBY86NjgdyiPh9FDoGK+5nCg7Bj+vMA6XrX7Gg8hC/IW55bRhqs/ZinxXvQ?=
 =?us-ascii?Q?9+PuAW1VX62FA8OAnP6eBMKqMngtIaO2/NMlD1wKxjAWjopMKKPV8ANI6iAs?=
 =?us-ascii?Q?ZL11E76tTcGoMvmR5WxukfR5+xvrOjAoh5zDpt1eISb8rs2fM0V7X6e93yI7?=
 =?us-ascii?Q?hccSMIsDl2/J7ctuilT5dsxitwJfdHMUAhS8vNQ52TVgCaZGswCU0oespHg6?=
 =?us-ascii?Q?KEYwOwiDAHsQUN7B//ZGb+8tt2HXmZdx3AB7nO+JcRlHzW2raPBfDkDYJi6f?=
 =?us-ascii?Q?Strz+xzvFXE3pMyeGfx1LA6vb8lyzwlsIzdkTKuoFH0GAOBZs/kdRXIyAxKX?=
 =?us-ascii?Q?av9xPBhTsNUAHHm3ppSnd5NCxRfT9hNwVzSyDlAOTQ++mXxkBW3ce4rFqmqL?=
 =?us-ascii?Q?eiZm7HOofdHjv4YEUmDZ1ogLbAO2aEHhMzmllRYI4/dKshembtzBFe0qm/Gw?=
 =?us-ascii?Q?6tQcba9al8fiPpDIP0JSAZnPQPmpeR2V9fpxD2uysop4WJp1gJRKTy+Xvxuz?=
 =?us-ascii?Q?PfM+WuRp4nQVtqiG1ZJfNlF8Cjn2PTXyoMRpWWWPU/80QNJs7p9mr4eNt1uJ?=
 =?us-ascii?Q?bmo2CEmYJWb8+Qb3SgsR7MLTA1kS8KVekyvApw/1WR+PVgQQ7g2I3afemFaY?=
 =?us-ascii?Q?AFuWY88DaNcm0zYFApxHH7gwKEQmjQv03xL0dSY5JnyfWQrfbdZ5SA10rUCu?=
 =?us-ascii?Q?Rgi9KEPepkc3p9UvUGjOwRIUXZ6Rt1x2VL7YIaI+PFwZ9vboWlvLxS20Xva5?=
 =?us-ascii?Q?anCvfVthedM68BZHn9xpXOsfUsqSCpSD8zLaT/M0MUkWClyA1veUgzeKVxxo?=
 =?us-ascii?Q?mLDax4sZsXNAJG64/GShCXhtFj7+cQYBeIIPwZ+w35Ub4E7TW4QT3MACc3rD?=
 =?us-ascii?Q?qSgjmYeocwmqpFDmXh4hubM49zRM8NUY6nZjEBCyrbRdcvCMO+obhDQNtt/M?=
 =?us-ascii?Q?jkUZlWXgOEo2sZv3RlFqgk88+N8FKNVXomVgDciFTFqyKk5NOIzW9/Rs1bgH?=
 =?us-ascii?Q?LIsm9qyFcI4lI5QbSuxeFZYFAN1cjr//6Ira8M4eBwLyxrzXP7QmlNrKqAz5?=
 =?us-ascii?Q?BGW4qaYjsOv38r4CrScARw+GJjGoZ+lt1QRdT1DmiSjTt4jzXYIWc9W1uetn?=
 =?us-ascii?Q?yXvFnfV77WCFg2H7ICUMlmf2ewVdWQLNDhYBMUWPQPdmZEDIZxDK13Xencwm?=
 =?us-ascii?Q?09rIZnryyMB39FXe3NWKmpK22JP7RO+M/Z1Nh08XyDX0OLk4SKTKhzQ/ZHT/?=
 =?us-ascii?Q?VBmdex0/Vmt8ifSJScSxDYnvBkmld3LF/tFuL9w+2vTCxEdqKs49z3vn6tcM?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Dsvo6j9OivsudeEw/4rGgR/s/QeuYy2MW2ItCKz3rHS315EXvmJxGSRWru+/FP2LKNuyCmN7zZE7l779ePK3mkDN9fSfd2MWp4wFVaDEuWHY56NlLEwNQliusJxr2Sbj3kGVK3a3EJ+e3IQ5k66R4xcLyCzbM6VCwLPdenYSNQnB95VHw5iYKd1EPp2KxJMzQ3ZBlrVD4RhsaIJHfsanZVUAJLpyBOwSN/7NOsYWRx1nJMfluYMGwrR97Q5unEXDTYPAidC5/8wvRKWYK8FqGBHp8z/eeaqfJN3CPq5vSoLf5zDKOL2xUBNR8ZBGohKDM4kyIcaYWenMPGOQNE8OoAc6L3F2KJx6hB70P2iJztkwaJpBIWKhbtiiytHRroG+kq5JIcOK6tQwpjjJLCpfVwNNkrx42sLI1/0pDFxvWkK6uBAdsNKrNcEtlkq9QLXTGQwNXrH6Tsdo+uDowFI0iRjuYg5o0mlRBfeJBRCLkv9RjRZHNSLHFqsbplcDSpj+DnKbqDSnOsI/JECbUR4bsgGpmBXyIHoCa3o/R6zyRVkZh7W45UJf/t1PwyDag7B/MZ5LwynpGbDMGlXVuLUo3xrtk87FK4lKv/xhmPLYI30=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f54060e7-620a-48c5-5e0c-08dd2b5694f3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 17:55:02.4090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w57dQWvpH4TPcfKSrwaBZLBhHC/hY57ztg+87ZKQD0S2DfabhVVWLMlSeR+eW3WfdrNDozJI20ZHugE82/10T7kG7a56hLGiLq2n5O9bD9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5111
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 mlxlogscore=538 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020157
X-Proofpoint-GUID: 0MllILcKf5sIwbi9cu9szAGW_t4VWBRp
X-Proofpoint-ORIG-GUID: 0MllILcKf5sIwbi9cu9szAGW_t4VWBRp


Frederic,

> Use the proper API instead of open coding it.
>
> However it looks like bnx2fc_percpu_io_thread() kthread could be
> replaced by the use of a high prio workqueue instead.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
