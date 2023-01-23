Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FFAC25B50
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbjAWWOW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbjAWWN6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:13:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEB138B63
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:13:31 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLiMNL020042;
        Mon, 23 Jan 2023 22:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=QR1NNSR7VWGSWxL8QqC2iLGpQ5QjflEeZHp24yggcTI=;
 b=Pq3TG4AYxh5byoTzjXJtawSBeGMre9YstUJO5FB7PQzIZdf3zJlzN822YL//euWuNFOh
 jOjPdVP6CxnPbwSOd9MnXUIuQ6LnNh+9GkH5MRpxFaAvKgTDuwd/wc+p0BbEGsPUfE9j
 +VnJOqfREX3rfYaAavb0885j0ZlUSvhii5IcPpsWnIIjuaoA0D7mmbLu540jTljfYz6u
 CjwWACl8AO0jtXeb5SsKHIEsUeI+0i4nhlTWxkQ/rbKyTw6Q8EgUJyo4f+uhWaVOMNPz
 Onm6xlx71JcAxSM+QlbN1rsSFgtJUWxnmNSh5X468Dgy+HLWE2LuEDRnVZ7HrbG4/CA8 2w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86n0v3qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NKuAZe039685;
        Mon, 23 Jan 2023 22:11:20 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gaxk2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxONMxE0kY3tKl03Vx++xOyne6EXFIgcPqDoIsIbgQce+WL7pC3R5N7XbC+J61T/hnpOC/L0E61XzPp/sTpIWRMRlkQyXfADWpHz2w44PxoYZ8uhn6Pa8DAh+EPwEsevX8KoodGBuq9fy204dTclbAMieQKSRgvA6FfjrQzpH56mKwzQxIxlgqQ6+hquhd6LMha8tyCaV/rtdvN5KhpoCCeXeF6LFitoYvzEY8WrQDpEnFhg8J2yw1/7KY9RWxwwMvq8DIdFSIHkw7H5Pi98VF9JuFe6JHs4sgOSWQvEPwL7Yvv8ZtpSTo6YiboPmDJA0481ERU7YApOrTWAfbymZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QR1NNSR7VWGSWxL8QqC2iLGpQ5QjflEeZHp24yggcTI=;
 b=FKK6K8NGvLezclh70BHxjCFz23D5+GcoqDh8ZsV1QdO13y3RwDh3H6kfY9bq7KDRgcDlTmzZbiYp2rzNjjLMgxO08c34GvfuUNqo34ZzmdsmWqg3p8uktSmw8moy8IivOoDlY0UZS3mHsiAsdVTFocTZ9cOpILgYDf9dubfTCXl5MT+1uJ7kTZ7So0Od1YqdRhIDvoIkzkPPw21QwndGizxEdlrH2SFgBUA9m5AfepGtGzvd9mvztbGpRJkdzCFsG5ucpCuGQWi+25y7wOiTjV3/QMSYMipE+jlyq+pq5lJWhNnGbhckbOttFprBIYH4IMunwDTPCMgj/82HzGYuiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QR1NNSR7VWGSWxL8QqC2iLGpQ5QjflEeZHp24yggcTI=;
 b=hfv3zUcZqjSDKGU7d2zedz3wbWNatyzksBdB7u+qiMdIdG/EtQhbsSfslQF9NOHOIlJv5R742FX6GvvjQ7yQARqGgIKyo+bOKazCX6xmFkAQDEBiH9XN2ml5R9kFH2tPrdeXKhdR+tnYtrM68z0OOsiqb/JmyxdNeuAcpXAXI10=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:18 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 18/22] scsi: sd: Have scsi-ml retry read_capacity_10 errors
Date:   Mon, 23 Jan 2023 16:10:42 -0600
Message-Id: <20230123221046.125483-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0006.namprd21.prod.outlook.com
 (2603:10b6:5:174::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: 99b27daa-eaea-4247-6eaf-08dafd8ec064
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nsiqb65PiCsSSKxXW3YlIOrC/rwUDuCZ2CP8OXE4hoGclNaOFrmVWZRx33vhr9vVdvLSotvbsOktXLGEu3b3I+YxUkRc5kewe4DrVoRUKn79SAd9rxV8n1TOOpP9ifArwVp7jiZ69qAu9LNq1+iQJU6HcW2R/k18iIon1wWEOe3iTzyjjpJJwRS6yMBSN+JACxr6XpfC/pbhAju2UaiLj1MrymykiiB34gj8+5Z1+3JIiAJvVka33ieeHxS6Lr9b8Ec9y3ntmgZXDtF7XoGHYUaRxX7fUzmVkVML5E6Q3xd3EfGHv/THq14kqTo1W9nPhOm6TCby4hdPF2qg1HPzudqoN95CmsPI1q7pmiQWZu+Z+D8gjVtA4prHxhiCCHgtDIINleubH3MsssyUKBzpa8CTMjCq84i3J4F+qh3fhSNqhdj9wzhB4r8aOeR9UPrsBZXxEd+Om4qHMq1Tx+hInJ+PzTaUnJ7q1FhjaJfBpI4oVoQpjI2bCOm0hxyzY7BO3F9d7BZbQpD4MSwSEKhWpa7kiq2YFK6Anqwl1WgIzoqa85qfuiAiiCjp8kks+h4nlzWg/gAxlZ7sjnScWPOYaprksQVLXrOHkpwUTka+XIuP1vhk0OEW4kNuy7V4HKHNeQ+zwifhTWc/OyFSXGgUaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AnD3DzA0m1nDBR3rT76OIRhVZf9PU73nFjAAEmDaZhAng2czVVa4HiT4+0bH?=
 =?us-ascii?Q?3fYKWA45/Em7+GZIXcHSlb6cTamx8dxA+r8kkSJVTH2Rbm7SgnTzZCUf7/tO?=
 =?us-ascii?Q?O6UbbVJ2zlTH3L5saz4qi9Knww8kmHkyjaDgeXtXZN7EunVrpZpNiMb/DGMK?=
 =?us-ascii?Q?ZZInmYOXWtFTbaUXlUT5d/MGq7hba2c6QBkc+4WWDT+ltjTLafc/VXQyrJSb?=
 =?us-ascii?Q?nqFN67Ns7YvZVo9kQp/n4vVH3Ack7WZIpX/mv38UKX+uSqqCFy6N+zwPGfFw?=
 =?us-ascii?Q?NPKZA2vPAfpB08UN7NuY2iK2/Dxf1AZBrvoghSZfmKKGbsvwIcBCGToqdTzf?=
 =?us-ascii?Q?bXnq2F1NvPu73Z5UvLmHVB0lDxZk+95sfdorh8nqY5Nz9bkJYZAMB0TGznU8?=
 =?us-ascii?Q?iXf/OKWSfaCbpW/IW1aNkj2uvXPwsZLZPgyIAGeeXIdvnsNXrMAljS2booW2?=
 =?us-ascii?Q?NCxMOj0adfUEoGt4RucittdaHhdHdzkvIdKTTtuvHJiyUv1XlVYj35FK0dCl?=
 =?us-ascii?Q?Agi9cQjaEfqleuUs9K0LIMStOCkKhRav9P9wmSIjI3Mu8kkzZ7OKS3sUzo6O?=
 =?us-ascii?Q?VrO0zfNB9OaKZh2PN3XAntlmI1CpAWqnh4nfl0eDVSjQ/pE+FtC7Aixp2ESd?=
 =?us-ascii?Q?UC7D/gBdaE/ehpwlrKYeaQgFygZdxZjHomLzg4HNkC6LGO85ODQLA1HzadGI?=
 =?us-ascii?Q?q8AsZ2G+kp+4Y8YmcJd80jJKET+3He/ZBB0H8ptw/wAWcsxL6UTAM6+Rs9L8?=
 =?us-ascii?Q?K0J8ty2Ufl+xisI/7Xwa28h/Utyjfq0HogvuQeWXsxN027rLcJHWqh8dNagC?=
 =?us-ascii?Q?L/HsadrHSQaEy+YXHjK/RWRIFQoFOykTyvmtL5cuRnp0rbpkwHAbOB7G2hGv?=
 =?us-ascii?Q?J/KTIOCci1eOYhLJOCi8LsGdsslg/g4HlkIpaJfRPO5cxbvXaYsc+Fe3t9Xd?=
 =?us-ascii?Q?78k6Fej3snhbPjOuXbFHYmQxRKVHL5BMf4p4HcYbUo75VFFDa9E/0lLPLIu2?=
 =?us-ascii?Q?3AgBYYeIGpRt4BBsaylFquxoi6f5+KMTxjew6bPM8ghLLvxuDJ4u5KrQrg6S?=
 =?us-ascii?Q?alEzlkC8x7FkI5XO4xQbUx/Ti7kAiMWOtYQAvbkf1jCYH5uPcpYZOCfzANIU?=
 =?us-ascii?Q?ebMTtHUNCdVWzkVX7gW6NwDFVd/ibf/mp/OZHCOzYKQuDG8m5e9O4fswRTJg?=
 =?us-ascii?Q?50pQchEg+ZL00giWFDiMZmtmPo5hmCt+sHCGJJmz7nFRl7SywtADL2laPE2m?=
 =?us-ascii?Q?qDAphDC5FjzfD10BeBC9j7ISjxcEXHAVnVzIrmGWCDF+cilL9tYOVybv/HhQ?=
 =?us-ascii?Q?ts71V8ZFEyZctOMM5c8qx47nrh5kUSBeTpqQUltMKjV4bKINP/OFXaygw7kE?=
 =?us-ascii?Q?xRKFkpoIfVcVFNKfg33RzCuiThptncRiAIpDfjyq2ehE8Rl4EdZo3Zqq+XCx?=
 =?us-ascii?Q?Ja/9TmUqRik06TU3B0ts+Ow2O/f+iAPui2jlnTlHgtUZo8p05vikNFbzmSRD?=
 =?us-ascii?Q?33OPpC2FhbWikA8U5di8wVnRTEQ4EaIaQTIcaDI1WWcZtlQREo+CPGNMuZIs?=
 =?us-ascii?Q?v8tCpfLQAB9sOgzEPuYDLwWo2yo5epRvabFm5MnD3oPJoiidxoh//GOplX+l?=
 =?us-ascii?Q?nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 482ycx6ocYIdY85JryGxukQeWNA9LmxWGBWHuHbjUOthVTvEmP6cnVYXY45js2W7CbpIurFmPVjBI+d17Gt2h1HID68CYrIh/0n/71zodmaiJ00Z0tmUzKXgTwUK2nHvchajSs2khtYCY2Fc73C2RyTnpPPoHpmx9FJikPSQcee175qDVcJ6JBmzYfSX/5AZZ/Y0g/f57M7ihcHHXmQUCKOMHaMhQOJMnaB+ZcfjW3CDObMdafoESb5+fKUzTOrmAsN9OYfr0r1Z04uv0IUT+do9SVagyXw7Y5mUd6w9oswkeCekumcLZHTYYjvo1D472uol7nGe79dhYgKf0OzC3CXwI+0nQHx5QCjVEMi9lKlmmGTo9aGXfp54eWFFZLA9IMU1JvWWUn6WJQrvCQB5OJ1pbgvgBkEBME7LrQ+JgVkhrXW+lAy4DYPPPI76FZMQ/KFl0II/KMzBuAj5bZX4WELrct+w08FlL7VvH3oS6Eead8tsJeBtcb5hV5x8cOiYIEiC0b8eBV4DdeHVAeDJ1I3Tb+/+r3RuYb5xyBn3fDw8AMqEqhC8cppd81tEYZjsGV+G/UOIbZYSXCHZUifTmTQHjbr+BA3kRWcLB6NHblu9vx0UNG0qy85P9xjlDmrCCPJbLFFNb++0NqsdIahBit8881y5xQsz5tBJqdmoBisvz6oTBwFXzzSkzkgXVR7mQ4AoGI6eRbVDi+RwTSDaV9NAccwv+MtsrShsdf+h/9MIqxEt8Io5BHnhvV3neHbUExmItCrfi1U977on1dFY4U+wkfrXRST7R25FV/TwZplI8dvp6XH2qM1GV+itjI6IDE1nyCRy0dXrJIM02NLRy0u4qs2j4tTZjLL6IfQZiOFcxx9XjRu59i5Gfv81mULv
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b27daa-eaea-4247-6eaf-08dafd8ec064
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:18.2587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vQV2II3oQVSfzA+1ouAVqKcYXALlbaEXIKKushpcZaozjKluHuUXMv0exw3e8QSlJcNkG7OTDvwuZZAJawddZbobDzBAHGr+iPbWUZYfSe4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301230210
X-Proofpoint-GUID: rEJ6OxIWbk2EhJBjk0KYgF7Gi1Z4xMlM
X-Proofpoint-ORIG-GUID: rEJ6OxIWbk2EhJBjk0KYgF7Gi1Z4xMlM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_10 have scsi-ml retry errors instead of driving
them itself.

There are two behavior changes:
1. We no longer retry when scsi_execute_cmd returns < 0, but we should be
ok. We don't need to retry for failures like the queue being removed, and
for the case where there are no tags/reqs the block layer waits/retries
for us. For possible memory allocation failures from blk_rq_map_kern we
use GFP_NOIO, so retrying will probably not help.
2. For device reset UAs, we would retry READ_CAPACITY_RETRIES_ON_RESET
times, then once those are used up we would hit the main do loops retry
counter and get 3 more retries. We now only get
READ_CAPACITY_RETRIES_ON_RESET retries.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 64 +++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ba1970283966..8fe97a9f8a4f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2447,42 +2447,56 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[10] = { READ_CAPACITY };
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
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
-
-		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
-					      8, SD_TIMEOUT, sdkp->max_retries,
-					      &exec_args);
+	memset(buffer, 0, 8);
 
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
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
+	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+				      8, SD_TIMEOUT, sdkp->max_retries,
+				      &exec_args);
 
-	} while (the_result && retries);
+	if (media_not_present(sdkp, &sshdr))
+		return -ENODEV;
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
-- 
2.25.1

