Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2AD154431
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969373; cv=fail; b=er0QPV9J/6i34KhM3i4ikIe13R6Bb7fle0AJzGEgnb/TKqP2OTVbdoDv/I21DY0AHumMl1kj5HdpRyxChoNVlcS/TO9QNiG+UQwH5X+AoWFcyL4V+QIM1fif0c58uugUd0zotVjieuXWwZVV4iulZ/0fUTkfpBPr8u7a/ovwYbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969373; c=relaxed/simple;
	bh=P/QJ5Y0cq1PpBZz8P2jEUdP5rwolS+u2euVAzzQ+/mg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YYBz5JK8ljYIICw0uDmLvFBNo0iqgyq6ymgpae7fo1XPRycW2Sep5u/XrN0X/Uu06xms92NpcLXHNg/T8WGKo3CAxxRa6AJZAAQCfgv2iHu2vegD7RME2tKmVb+dcxXijl45cuEQd/hgZec+nGescYpe1uKihAjPaQsBHnHl21U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Mk8e7S7s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cMrE6owL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mk8e7S7s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cMrE6owL"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMoh55018199;
	Tue, 23 Jan 2024 00:22:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=qHvYT1SXvi8go1ikgTe/XY5aOw0TjHSt9Nb44D+xC+Y=;
 b=Mk8e7S7sNnByhJQ8KFpNqE4krDZ4Kb/473df9WBt6TPzcACIkdHslkhnXjxQL62je63S
 U4jaiwnziISMTg4kYFqLwXKeEQvNttFfv9vrmdckUBMgB67hcEhv+WCkqLBoUjm+3+Qg
 DDmFepPcrpBVsaFtTmOCkxreZgsgftr+6VBvfnehhlMsAoy7G4CNHQd+lsGcfprih6HR
 +UynFWTGBT4bZL0AdQ+d4efnsOWac/EPHPuQV9UtRrUaVaU4t30rehTnGHBZOo1LVWP+
 t3nuolNLSt+4KuzWdyyMAwKKz3RJAuQ5jlM6qV0IPVFoP5nQSNjpS5Cb5LAkgoGyGvPp QA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7abw1s6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMeBWK018804;
	Tue, 23 Jan 2024 00:22:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs314g7gt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+IGC/u7TT0s59PYUAtmE7zuQQPxZRU4oecRM4bakDcIn0oPQeMBpSUUnb1bV6h7zORCBYkAVdPG3TA0Q73a0wXbgSJIeUzCOoEz2L8y557qAGvqjoGbtA+KDDiKPCrq9/bWCvMnt0vppgFF/bXsQnjo4BLGGa08lzgOIUKvj1IPEmQxWwsJA6w2wuilphd7uN7Mgu30rFpvl2xsnwUX7lSp4Oe4++8aWHlLeIFuukHsuk1UOG2Qs3LwIslFyMTwpWLhd88/L/3VIZi0f70Z21ONsl0wBPZNMp590JIGvpGKZXomabPEC6PhB8B49yb+R8O0nG0JAiF4WP541Uo6eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHvYT1SXvi8go1ikgTe/XY5aOw0TjHSt9Nb44D+xC+Y=;
 b=Z9cImKb5ad3cvWgoztsGM+11+r2OLwAw7Ot6y9gO2jPJZ7YcMRaBTe6TRSeZz2RebSWmbDGoZq0cUvLfNvM8d0G8SSvC4P8u5OtOzihwSmDxnp+DyKJAxHz/TpBakOYmHHPMozTffeRQ5jzcH0HiuKnBOGb7CpKoASBD4a4/bTPBpNe06q4uAxVFxssQMyyGsvhcpFS09TVs5TK7ih3WHRvQVlr4fyGC0FNQhovrHyTDFK801ZhnI4Ah5psJX4Ui8uK0Wc4pqbVc4uEQc4nBWfhG54MiYCCj3A7sMQ8vsKfj8rJceNJx1T6PUZt1tkrZf724HCxnW9XXmyKoil/0wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHvYT1SXvi8go1ikgTe/XY5aOw0TjHSt9Nb44D+xC+Y=;
 b=cMrE6owLxgvV1D4Z0v9PRmS/zKMXUYM3IpvJMjQpSuRpTonVnXb0xl5otjFcgL/SnyLqHSUZW250ksE7c+vrv5bwMiFOmiqe4fmKdongdeO9X1tR3z64Q1yrELyL2WyzIi/Mcc0cL97clXwArNkmvxcoPKArlVT9v8LK3UJk9xM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:41 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:41 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 13/19] scsi: Have scsi-ml retry scsi_report_lun_scan errors
Date: Mon, 22 Jan 2024 18:22:14 -0600
Message-Id: <20240123002220.129141-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:5:335::10) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: d97ce823-1129-4ac0-7e33-08dc1ba969be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	lKHvptCVAp90oAq83gUsqiyuZIccgbr6tEDfNFum+is6AGa2X9lo7SvJ91s+V5OmoU0H12Ov5rh1mje1TQe6szNhTosszQN6Gnw2iz7po5t2uAcO8VobWjgHuT3A9tPvksmxQj7BGa+5iwMEMe71N6rQl0VRer+oZXeJNW7TjHdfFbEu8HYplkBPEBg4Y4HHnhcW7JYRGsGaiDZtBBvNeAQCcDLBW6riHxdF3ZQp/v0hKTv49kht4NT5iMXtDY2xJJlkIK/I/Ml9FeDHtTFBELxlDYhP3myPfUNZC+SKoU1zJmhjKo0RvVv7OCjg5sIw1gqOLjZE7DOMSM+cfEFtMwFRBG9/VSqRS+ap05G7niItley1TIEVnkcLhmBabMECXtRJeJeryxIoQ/MBgPH+kLoXvDmBRBEXYAHpQ/OoVPFbedV9vldpk4WtDWmu9y+rMewr+778Y+wk46UaMuJB2NBVlX3Nfp5KeQWg1jEYIWMf3LRKqZd3N8Dv4nxgO/CN0pIbCbdJSK066cm18IYHW4VweitziXH3LdwWHk+7l06ftqgzlAApSMKR74qd4obo
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Ra+BBJmlCzKP3OMSNfMhguYEK+zsrIxzOdvyP4hCc9sjjigyhACHcGc70P0P?=
 =?us-ascii?Q?kLF1unVqi0EMKPe/iB/5yQLT14Y7iWB/Uj4Qf53mfENaa4DDDeEgdGLiL4nW?=
 =?us-ascii?Q?9/GHx/Pw5gDwerr2DItwG1Toj4nzqqoEdPzIShpbyHM3kNWTo0s3JZ2PYfyS?=
 =?us-ascii?Q?d2P1x7rRgnhC8m9aVAGPpI3Q7HA5xCvJMHeaM//HoDahXk6sEDo+4NZZm/cK?=
 =?us-ascii?Q?6w9WT8FgfUy0w4YAo4H+xsu7jVdzJXCrq8xXUeg4jSgpGyaioW8Qv3rzzjgK?=
 =?us-ascii?Q?4SZl3Y36haiVtuLRFhGzds4Ywcx8x1TrpYIcdv2OAvY45aO0tvfpLpklEqTH?=
 =?us-ascii?Q?wgiWhKl4/YwxB1CwF57pRKLIfBgxRjihfYlEQLKN19q8qeLm0T9sleCsU7sl?=
 =?us-ascii?Q?ZLm46YWLGZW3iwKlMQh1fMYsrAJSMV7bZL3u8J9uyHoi1o03W5YwF/P2DuVy?=
 =?us-ascii?Q?aZH4tUW/Tr97VELEK3Ro+2KGogA27L+vu6EHDYDn+63vX/igFcNMFJ5mdvPq?=
 =?us-ascii?Q?VsjQOkF83B5VkbgRhhD4FFLUyZcsgNc2EhIL6JB3V1P+ZyHpnO3Chq8OlZAs?=
 =?us-ascii?Q?JHVgov5d1gmDMWHez3JyDZhD5Eg/Be/aa3MBotdzbtOzvBxf/fFap3rRjU8G?=
 =?us-ascii?Q?ram4oj8uoNgc9kvDsN2Z38P5+fgxAai9GK4Gg72A3k7taZQgGPPvowyd/ULX?=
 =?us-ascii?Q?3Iz0ecqwaHLT5cvfLKsOMne1m0QuNYSSvKXD6r4SxR03j0nco7873/Qs14x5?=
 =?us-ascii?Q?CZzv7B4kXXeL74IWl3xo1ZY/nzJCJ2OQbw6VR80GlmEitEkvzX7AGDVI9eB/?=
 =?us-ascii?Q?yT+WV54yLnaSG+xQFeW2tdkgH81e2o/IeWAwOXpGr57EUoz5D/GYncVk+ORG?=
 =?us-ascii?Q?ycXyZsitP43/VsORvds570N0ECw462VsSFKGutGHbNMliwQsXJxQl+En8VGI?=
 =?us-ascii?Q?16a7oiyhxSVqelJdHMwbvt1+k0Wb+WcYUipZ2bIM2MR6GTo3Q9wukKrqk+xC?=
 =?us-ascii?Q?cPYdlDQZ5J5j5gjk+XfnNQEkn4yRVIjjcVEB/vDd6OJBNQAbpXNCCW0IvYl2?=
 =?us-ascii?Q?OmOkQnoPI5c4dldaYHHvlN8OEgFZqUZhQsIM2xbcMblIu02FEP9+kctWVtVd?=
 =?us-ascii?Q?+pjRx4LMKPxqIINMavk55PFze9/b1GZOKFrS5J2v4cWgDZMQoe7TXV0e6eId?=
 =?us-ascii?Q?M5JKWZCDMeB0Cwj0yfef4aoMksmYVPpyE3bXoVAIT4rECaI7wVbz7SrhSeLj?=
 =?us-ascii?Q?RzkZruh+Vvyma802piSR++PYWZkJZFj8L1DcIYXCO6pLqpDN0dfxmvjRLbqi?=
 =?us-ascii?Q?LmonwHXf9MjCp4AQHu0v+fIblHk227Qe+RoCUHxFmz3ULSbLQEJ0xWjfNVup?=
 =?us-ascii?Q?iKbpSlzWk9h3ldPGor580x3HYVzbXcRVjSlrfq3NKuwXPfdLxAuvroQJOrkd?=
 =?us-ascii?Q?Z+t5/fGMUKttAjSYqEVp+RO0GaWPPpukkfBqIHPJe5+OvKFbc94IWWo/Dwei?=
 =?us-ascii?Q?SZjfShDTvp0SlKYUsfLMMD9w7xOiT7zAvV96vdgXbInu2+MJPMQA2snnn5TC?=
 =?us-ascii?Q?YFEjBSMa+4x0EySTevDJC2A5mP9C5TEVb2H5r0tlMwBt8ZIjlrQUL/7+opsy?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GLcPlkbx3z32mMs1HbfAaLRtjppE5cnC2OE4eFyZhVbsvX4ghc45KP/kdsF0b857PBsStpjuMA3ofwKzn1i5nZkTyyLGDhyFnhtHu354zixzmO78htLgZqWwsKpPvvSByUvZBOSOUeMdR3H9DTklblCId2i48IE1xZFZJ87UNYyMUoAbLd23gHIHX1Hd1GrC4XKo8zFYhbmTSw0NWIKIidnIyAKSp92iaWZiBbXVwH+bRuuEvUEHpt0G7Rdt3N/YeTZZUTyDHUK2zYrFInEPImIC/ZRr/6Jhejf3A10b2cEAWYfuQeDJtIlSImLD4JgxwGdi8SfwlWsZ2kYhR34GBccvusu5wBBpvZr0ComzjIVl/36786pwaSVMzUw2pjARqGKav2Pc6yI7eI46GxELErO5OimzM4RqMCPCqY0jkim6eUux25xNvmQEOO9zXZIgACm6Ef2DdM+/GNH7uuJh7IRuCx/vDFJZIGZh1jaLppuApfk5dCO6zDxoqPVAxTdXapop01pLzj64OsR//mgDFd3UwSCLr/E3H1mM0YqLT7VOCL2P3bgQNPyfen55jpNvpx2aUn1zB0opK3emXsPkIMR/WlGfVKfM4a9PdNwyZlE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d97ce823-1129-4ac0-7e33-08dc1ba969be
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:41.8874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQcqkH4w5OC5ii08C8LHDl8V8Rbv7RvTcjw6jE3HPwY/t6wGo3os6iGLv36keGCUo+SnNO7vONYUD8Pw+EXMg+1PxpMT5VJuEeZNh9YOwoo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230001
X-Proofpoint-GUID: xn8ddlRcoXtEIekjPfKorkkt9kuhs5gd
X-Proofpoint-ORIG-GUID: xn8ddlRcoXtEIekjPfKorkkt9kuhs5gd

This has scsi_report_lun_scan have scsi-ml retry errors instead of driving
them itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 57 +++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8ded08f37337..70c0319be34c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1416,14 +1416,34 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	unsigned int length;
 	u64 lun;
 	unsigned int num_luns;
-	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail all CCs except the UA above */
+		{
+			.sense = SCMD_FAILURE_SENSE_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Retry any other errors not listed above */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.total_allowed = 3,
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 	int ret = 0;
 
@@ -1494,29 +1514,18 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 * should come through as a check condition, and will not generate
 	 * a retry.
 	 */
-	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: Sending REPORT LUNS to (try %d)\n",
-				retries));
-
-		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN,
-					  lun_data, length,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3,
-					  &exec_args);
+	scsi_failures_reset_retries(&failures);
 
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n",
-				result ?  "failed" : "successful",
-				retries, result));
-		if (result == 0)
-			break;
-		else if (scsi_sense_valid(&sshdr)) {
-			if (sshdr.sense_key != UNIT_ATTENTION)
-				break;
-		}
-	}
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: Sending REPORT LUNS\n"));
+
+	result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, lun_data,
+				  length, SCSI_REPORT_LUNS_TIMEOUT, 3,
+				  &exec_args);
 
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: REPORT LUNS  %s result 0x%x\n",
+			  result ?  "failed" : "successful", result));
 	if (result) {
 		/*
 		 * The device probably does not support a REPORT LUN command
-- 
2.34.1

