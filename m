Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AD81EEE8
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969519; cv=fail; b=NQjToHV6ftpaiBhNfxS7hISivWha0OLu+lLpYq9fK0cnT8h++ltoED+8/OQtwFYN5ep0pUsswaYKR5opDMuAnvRGa3maEQ8XcUv8xQgJkFlW64lm68IOf+7GBEAby4ZjDatXr62NCOUEJnDUfMAwqoZ+z4Dd148r1TnBt1gWjcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969519; c=relaxed/simple;
	bh=0AhoGil1xLThSwHuih2wT3EA+ZOiIpmdGXs3M8VJ2kU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tJznLUuzgSZhyo/uQ2uyjXdzxGueQFH2f4y0E/X/ZgPLv4w+tdMv3+x0F5rC9A2KYeQdfCTgbhCwIOwvfhJPTJUDmqBGY8U52WnkGiQhYxZDn6wOSzPG5pRX/oa3gGP4uWEPEkZ4paWhN32/b57dzswiDC4JyXCikLx0Xqt58NY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QFJ7LE85; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U9YAAhr9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QFJ7LE85";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U9YAAhr9"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMooGN019259;
	Tue, 23 Jan 2024 00:22:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=t1XNX1FqK0PGQQFLihun3Pj1zf0u0btsGYH9h3A+4IM=;
 b=QFJ7LE85wquvVF+Uzj0ZRwB3bKVR5sCsFy63ELwKnhHDurtsi3kdqW7T0Fhi+bjSkhYS
 iJK+Fs9GnipUVx2ihmzdEoPYAdpq5GubadkDsxeAwsK7njdOBYa9t/SEMIxz0WEQMhfS
 40zfztwiGQ+ZYwt74Bw9SfsY6R5tfp46pySA+rsaT4GPvw8HLQeUIlWjXuYFH5+L89vW
 IbPSP4o7USZYvs7dZs1j+L62aD7KnQ6/yeR6hXZpd3doniKtWLn43ZRo28xL6RZmBSRs
 47JX34fBvaL/68DPDOpL/MiKzJJZbwn04vtv6W1KhRiMPj3ZVNRtp15cbAZ1EOEkAtmE TQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cun2kk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMeBWN018804;
	Tue, 23 Jan 2024 00:22:47 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs314g7gt-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mwyba8TQn/kP1uChze0qP0amCPp+YKfngafswQVASuOz3AEhY0cyXm0pY6cal+JL1dG83dcBjIORucV6aB/TurFZbe+Fwhn8/nYdo1cFTh1bo7XXmXpXm4z7ri9uKnO22cIhKShgbSwa64mRPX9km7oz+iU1YhEH4iIDDoW60E6K7NKbUljCCgD+sy+0IgEAm4hwudZdEvoViPcx2l9pEWyMCnsRPLOZa1JlOfxrAXtji4kwyzrsL0NNRS5dwo/Q20jotb69B5w9D8kfDXRbtqDIeceEPMSRv/V+oIyi/depnjUBJVzRidmRmid/OlzviM0bLPWk97zrHn8JiohS0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1XNX1FqK0PGQQFLihun3Pj1zf0u0btsGYH9h3A+4IM=;
 b=lM9r1aL7fb5/X1Mv3ULrpfqXq9Q4crvwk5tTzhaUTV92HTvnC6ncy3AdQrr13+QoeprJjj2ZCK+dXqnRYj+b/OeyeaGa6KCHTiKwH+i6ormQHUPBB3Qblmu+hh3XWy4/7Ib+7bJcPtFsGR8GAdE3CmiZix3iGL3VA5tMZMMFjXqBmCZNvMW4hKM9S5+9Nmj1tEBepUou6abRmhB2grmKfT5Q7s+7T+ywNxk6HVN/c6nVI+y3msA8BQdchmokKH9ogbOSCGgmRVgZsZptqRt788dMfA94gZkOjOtMuz1+zqmvJEMUxzCsSNgUeJl4nCf/PBAPZ42z8gK3gP7iVKuJ0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1XNX1FqK0PGQQFLihun3Pj1zf0u0btsGYH9h3A+4IM=;
 b=U9YAAhr9MNIMGPEHEFz3G1n/chP9Vu/JZUZjzjPL+7AXJfOTzIpm5LjcJU6ZsnXMuwowwWWLT45yCUTvy8uMXrhub6CL6VICVmRTXT2aEuzL/jqL8iK8pW4o54y4RMjkhz8CPMF1GSfvXgY8ikYYDaIUcKAHqS+ZibvArj9IrzE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:44 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:44 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 15/19] scsi: sd: Have scsi-ml retry read_capacity_10 errors
Date: Mon, 22 Jan 2024 18:22:16 -0600
Message-Id: <20240123002220.129141-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: 521b9854-b1ad-404e-ec5c-08dc1ba96b75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nxQ2dYeQuMWUyH6M7Hb5uAr++2urRVWbsOxbukDhDlvJVshY0tGfQlShwQmScABhiFtr9y5oPY0dLvz9x82R8oIJJuq4KHMSDFRL5i7CVf5+gsACPDJh6kg6AWkLE6J0KvYrS9RZ2kHgr5tqBbYErDjWNXoKic67xR96Co3W791TiCXwthKfLacgE3iZ9Cbr0yhHij/swH+nQNMmT/+vh9aoA77abGU3Y/J0dtbobB57/aoQv4oq5yDZ3F6t806IuQ1g6mdh1XU/4HOyTC0yI4j2cQ/doegiPDVCiK9CfVuqyXuFRaZvPVmXDllMsf5/5lJMvdj9eVLOS6GHksJgYs+beeRbEZMY+fcsFl3yAKoi4Qf1KfVHHtChRMDNQyqAsxo0W05oD4rA8lO+24Ie/WQs3zhiVL02A0zZ2SvWLXJMwb4kWMyxARfP1+RDiGwCfpsWf5YwRn8GDTpQFRywOqDMCbOJ9YNxjOVC81DgHgT3e74Xu0QHqyfk03qti9SjpeI9qc//h5+KCYOSddKXlSho7Eg50WRk5m6WXlcZxIQGK2aCZaada9zMuJTHrMFB
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?0QqMC500DJEolk5Qt0oqmJOLtfiyoDL4k9gIK+SgumM6dlBkIHxd47rBDx4n?=
 =?us-ascii?Q?Wi8yyAjagnY8FKAsMFnQw/bnBepBIKxxzLAVaCT7ERH7eRqIx5HUpZ6ezWPp?=
 =?us-ascii?Q?TmIAbooN2fXFug1phiuhwB4sq/yDmdpl+wxbJCKeRkSa4UBuQqR7DR7T7jwE?=
 =?us-ascii?Q?GF0ruo5cKuUcA9T1+886y4KWhTSCS2xu4EN31NS67hIAvtHlHkVABgh3rupM?=
 =?us-ascii?Q?dOqol7jPNh15TtwOIWZ8DPDUPN5Q0eLsLGB9dIMOcItH+Lpa5NBCvmK6h32p?=
 =?us-ascii?Q?DuFUfa+YYZrrzVEVu+eLWsHJSk3KocsrmSMriMnfdvy+B0UP8Kv3q5FyRbD6?=
 =?us-ascii?Q?Kf1QUmwSYyYWWUIhh81X0aK3bStM8UxNajqRFD8/kQ00JmEUw0BsQw0o7fsk?=
 =?us-ascii?Q?m5G4lS7qZVs9vLhE1jF+Ify/19kLF8Wwb0ozrwrIOLahKSURegnD0XjlRTjP?=
 =?us-ascii?Q?T7k7luTptIrRQPLYC2s7oPrtfiEjc2QALyNsGP9DXHoX80xhorfD/R85HgB1?=
 =?us-ascii?Q?/Ec4QHWpcT7NpNC27C+KCMq//fpvirkNWJBXB/yEG31UlDVTpg+svKP1ubHf?=
 =?us-ascii?Q?NYL5d7qia72sK8VKwJFWBH2+gUwsRfL2OMHv5tLDP1Q0sKSE0czVjqspWJP4?=
 =?us-ascii?Q?L+0yfJqmNrXqWrVo+EVgV8YjgVXOgzPb8P2qwQc6BrYLR32MK8LhfpWUfdAQ?=
 =?us-ascii?Q?VOQYvyVJaARNxiJUI/3CR3TZ1tsbNPCkmxk8tWBAA22UXqhISCd4vlzm66gj?=
 =?us-ascii?Q?1Nbpj47cDX2gA3jfVCqLQ1ogP/B+XR9oVu14S3mhVKxX0P9ga+2c4TKMRQX6?=
 =?us-ascii?Q?+hW5nPrwub+jC/Wc7aCnRTRrrId2QqfbkVhlKOVbrwxWGOGYOw1wnBIRF7Pu?=
 =?us-ascii?Q?4T+TCCKY6NUNgcS2DltZPQv7MOe0NBGBRF0wcOzseACoPBHtQEbuM9L5RbI9?=
 =?us-ascii?Q?gmuGAceV0c3+ygmq/m7yUkAIETARuRxCNO5GyL8sSRXLvlOUvk3j07KsqYMc?=
 =?us-ascii?Q?DyQiSWPTCcIWJHhiUtdsn1eHxMnH956GLdVgbLt5YmYCgsqk1g1uxLhqhAmJ?=
 =?us-ascii?Q?FMcYpqaKsircGlyEZqaTcB+Be4Ucoseh3MPA+mAHgQ5NLK2anCds1x7cw4ni?=
 =?us-ascii?Q?iTO9q81W9e+aed/eAagxz+6R+BDtP0/eOkgTH+4VBNxtI8Fo5k102ClfwUkd?=
 =?us-ascii?Q?Ge0brOiWyYzKc5Mpt1gU4x3gXYgyzTVH/NpQwKBbxHbuno2kXeC1JxRjzVkd?=
 =?us-ascii?Q?rslPa4BNllkVWll7PJPM3dRwhHWgbbSGMgW5aC/EoXb/vaQxiag26RJvSyEQ?=
 =?us-ascii?Q?YF/5KPlvOYDnWxUfrR10zw3LhwwBZHKC/d1iIQu77g73FhFWsiX9e5e6WtPZ?=
 =?us-ascii?Q?oZ/lwDEUD0kiPYsutsEQYGygm+bxQ4gGo9nzh5RqCBuxCQCjhUTGQ+Cc3HVs?=
 =?us-ascii?Q?E0/hjSXFnm6a24awqgJQxUGrHREicWVj0meqct1NRCi0qj6jsfk1J0JwzAs6?=
 =?us-ascii?Q?wqdcUgwhaA/L2ddXZKsIN/jtKeZefUJ3VlhkRMGRLDuqUCnpXgrVpU4yld80?=
 =?us-ascii?Q?t3BP/4D9FGKTC6lidhuFR0t4DUPYleRI5pEYBP/4WhdC/eNcxcLXWqPWWnPl?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	hz6imTYICjbYLRpIGu050qzXy6oIRCaNCVx8Ftc/ESukraKO0wQpq3Nm8/EFuXI1TQy/9pNALTchNEx2z3r30ykt682Dpxl5TL0a/npxkWVwj7bfGeHCvVxXdO9qjlP25lG4/cO2oIS1EA43ILwhHA8CYAoJsa43400a8/mz4ssoAV/pz3n1YT9X6gOfYZ/iZGUbUPrZ5CAyCvH3Q9OLLSbnrG4VXyqx6NOecwAmB75oTWJV9Op1zcg1iHv7AvE5lHjaEYyIrMMxQGWK2GNL0dFMkGnPb9OG+R0eNZiWTySMSZ7FIQH262PM4ozumNOZRaeDpGaZ/75nv4WXC4yer7NN8YXyezSHJgV5yAZd+nmIlldJUcvagyEMjKW501IQrfY9iHwdyR90bvs3vawVIuDN8/5qLWg89h6c9AeFTi7+9tsvx/OXv0Vc24+RuyYrmrqYdFfgj/a6Qcb7Ci7EwdVMV5o7t5PQP0rjPj6cnRtMEPlcBo4lHg7QYF5Hgyc6kBsPi+LPuJ0Ve90+mPny3wINGAV7hmO63SBmK96nBW5VefNVLRAM3PyoxgiJD6URXaUSRPmehUvEDoz32nUmv2gaBFtkxcl7Yjoh4VVTgNw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 521b9854-b1ad-404e-ec5c-08dc1ba96b75
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:44.7282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ot7hUwDApVkbg5OkRCsVXLO5rmLpWXLh8xtA0/v18gdxYjaQuPXSGsqNsHPZ8T5JX/aT7RbX35BSeKthRtTXzoAQYLp2DJeqvQWa9cDFn90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230001
X-Proofpoint-ORIG-GUID: bOfLnrd-UyyGqmVLMOuFxsi2QvRUvrob
X-Proofpoint-GUID: bOfLnrd-UyyGqmVLMOuFxsi2QvRUvrob

This has read_capacity_10 have scsi-ml retry errors instead of driving
them itself.

There are 2 behavior changes with this patch:
1. There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs since the block layer waits/retries for us. For possible
memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
retrying will probably not help.
2. For the specific UAs we checked for and retried, we would get
READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
from the main loop's retries. Each UA now gets
READ_CAPACITY_RETRIES_ON_RESET reties, and the other errors get up to 3
retries. This is most likely ok, because READ_CAPACITY_RETRIES_ON_RESET
is already 10 and is not based on anything specific like a spec or
device, so the extra 3 we got from the main loop was probably just an
accident and is not going to help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 62 +++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4196f722c3f6..49159dcd638d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2588,42 +2588,58 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[10] = { READ_CAPACITY };
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		/* Do not retry Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		 /* Device reset might occur several times so retry a lot */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry 3 times */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	sector_t lba;
 	unsigned sector_size;
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset(&cmd[1], 0, 9);
-		memset(buffer, 0, 8);
+	memset(buffer, 0, 8);
 
-		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
-					      8, SD_TIMEOUT, sdkp->max_retries,
-					      &exec_args);
+	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+				      8, SD_TIMEOUT, sdkp->max_retries,
+				      &exec_args);
+
+	if (the_result > 0) {
+		sense_valid = scsi_sense_valid(&sshdr);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
-
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
-
-	} while (the_result && retries);
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
-- 
2.34.1

