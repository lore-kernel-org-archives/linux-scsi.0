Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591A3EB64DB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243384AbjFNHVm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243375AbjFNHV0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072682954
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:29 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6kNXe015669;
        Wed, 14 Jun 2023 07:17:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=hRr8wV7tSW9fN/24C29Oe8fLWIXEXjSiXnD6F9fLsGk=;
 b=TJ/uyw5I7KsZ3/Fu8CnyiyDdq/kprIucIuKJD6Hp6O0IoCWHvcUYZ1jGdTUl0L09Nmvh
 AJZzhq9bWRVFE3hrqab1fbJhEjI71QQF1W6ZkvhnRfUfGm6QfS/UYvrXhz4prkTym+Kl
 2iZyRNkwkphqct61q5RFnXy3LcYTejs0ZB6sk0XzV8fXt3cNkIpLh/l4mQubT8oe2vlD
 ktBplm0+mHtXFRLGyM6Kt8OOQGN8Fq2c9nIaMqSjHCgX3KEms1cBX2QmVrixxT7N1UuU
 wEdVTxQKh18L5pijdpAguBCYUf5UGSiiiGNg5VfqOPs4Llpl/ErBppPtndANdUecLvyj IA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h2aput5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6T6Sa016284;
        Wed, 14 Jun 2023 07:17:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56pe2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2LUUmUemQVN6IffhPsyWEb6TccgJf5IxYJ5EnjEnZKlit01n+EY5UL/7m/7o5ixlJ1ePdntV+yLehG4L7uN4ZoyVtKrbqg96ImajqemXZdNKsuPvTdOWMajMJLfG8YKYdcVP/qJtrZMh1liMGzT80e40hNu5dCGmiHvdinBnL/8CG5SLBcYhAb/h+ubX1udnNCA3yGa+g6Ba0rYCqLQgNMpG7LipLRhkuaYA9b3axNj7dQHDK7KD0kaRUHqRprfBm+iktm+f8cjO588IpXy4G8xT7IT0SPd1lNPvaBxLmZmw7PTT10g421wLSp/K5cHJMSbF1QXFCSpP7+nYRIung==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRr8wV7tSW9fN/24C29Oe8fLWIXEXjSiXnD6F9fLsGk=;
 b=Gl5DVgHuNtDH42D94tQ1dmhW0F3odhHkmds3RBdSh6QvPzdb9MlyMMZxPRVFszoMGgdHXSnPDghKT56GzTsqREHV16AcC9w0yWgD4q+AiUCF/B5McJcL8uayADIiFO4d732hH0Ru5fTtABvNX77egup42nSOJrGN6nOEFuxGTJBEm/iPjrLafrvtKMQdM4cb1FDc+thtqulDkKVHsJPshx0kCGzYq1T5791kZVu6kzFljosnw5SRrsDHdXBsCUlDOYaL3GIuaPSlzUKxFpeDf8BD4v0yh4dGket8rpkwFw2ulBwbLUXKNqI0BCTnQoV/KkrmQlr5IxqRBJREv67onQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRr8wV7tSW9fN/24C29Oe8fLWIXEXjSiXnD6F9fLsGk=;
 b=CaXYPFDPrzl+McQpvxqZVLpbLq4qoHcSR0MUmw6+J0tsdioUNr0YStsQguSZSrWd0ohrxqSqs1q83Ps47vlnpmBO+OzpdgsFlBcs8OITXxG5uziREd1xd30Xsnc8sh60m5MGk50LNHgSpfTY28nXr3qsuCB7wD263iMv8roPSME=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:35 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 07/33] scsi: sd: Have scsi-ml retry read_capacity_16 errors
Date:   Wed, 14 Jun 2023 02:16:53 -0500
Message-Id: <20230614071719.6372-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0051.namprd11.prod.outlook.com
 (2603:10b6:5:14c::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 4668072e-05c1-42ac-c8ad-08db6ca76d13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mW2ufaiaY+SHHe/BbcKXdeTID+w3RNEy6KYwnXaXtaktwYmQprQO23+5kp4dSU6X3Ss0qHcWSobuDuTyJ72bGdaWFxQxNu/mYEahus89ae5m4m81Pn+GT1Rbd200XHXj5GA0q4Qdd7StBWdUUrQBXqJg85EHOIwDUyetZOeiTQvyd9PeiyMY20M0cyx7PhdRnQ2vVZvz/0SxPxyJk/50iBMGnuybvYY24OmN4LYDSOTStzbXFAfMmm9w4AcjlD3QATTpPISN04X8ilghaj2s5hOagaseuV+8LInrSMeK9eGAjr+49bfL6BgO056cPeZTrBUJdoTlwG/4/9y8W2YHLfY+AKdR4C0DtLTXgonvHfAEP8MVr18ySuqH7cCFpWJTjea7XO7+RsGtEEJ9S2bsjK0aCZeRWWPcZvVSkqqXXRRnzEQPhHqjcOdSIfai6U23y7vDp3BbRo3vM528/ZE8Iw7MgGYwQ8tFx1H+50gUeewJTOOgpVXvI0N+wvGPyV+cZTzMYRPv5imFLnPbKbYwIpxmZAtLIPyeeSrBQkdoeAJutwA0Aj9gl+MvnWkSe6/S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XnwZMWqZTjU3vHHS2qg9Fkmx0IJABi3TYgnzRVAuWidb+0KVguUqNvKlMJEv?=
 =?us-ascii?Q?QS+qq/cMiiS5p3p0YeaPljeZcKy04l/9QQ2N5/N3eN94fl9tohUHetuddqwt?=
 =?us-ascii?Q?f6Vy5Xsc0URJhi0eqlU8eg4fRfKozwhy9JRfMvU1rUkhfZGLnVueJ+xPOEa+?=
 =?us-ascii?Q?oGSv9h6jG3QnldTrmDC/HAjV7CVjgGjl/ArkToE6jmGmSmA0Cc0IGzpP209+?=
 =?us-ascii?Q?hlq5fqzItQTh3yLMTgnND11wWAyZCIr0jT99JlArVBvfvirrE+7onEWI0xIq?=
 =?us-ascii?Q?QoNbRIbj1IfLd45Xu8QmplTwtgc9xaJfJlf/DEcTSbfsUkqEx39XTyDXIjtL?=
 =?us-ascii?Q?ZIVy+dvxSOUS5iHKyjKpXydmwS5bLJeGrAQJmF5mEd+XVCVKOhN0rIRESxh2?=
 =?us-ascii?Q?ik1uWy5TuPsd6fWYWJkibKEUJoEuS1KnFmkypgwdAL4JtXanDSfSt7fA2jp9?=
 =?us-ascii?Q?99armmtIdZ2mGA3x+FfsVWT/7J2Pxf4AKQZ5dYb/EbbZTdb1fkzRuIwD7O8Z?=
 =?us-ascii?Q?3IxUdDdAPzkqDfi6bmumZouDzZfTnpD71yOUzOeUGHDaji/ADQlexjrPWRM0?=
 =?us-ascii?Q?ARVcrKVFVAQMHyUwgAVzJlw3GYNTPGvCACJ4KgLx8oHWUrpf7tnFu7rmlpdG?=
 =?us-ascii?Q?u8/jati5m2lh71Hrg/C1hV8e/AJlPzONXf+v/SubfhxeIX1O1EjwuuluJlFv?=
 =?us-ascii?Q?PZn2WmjiCiRNy9C1a8CjlHpv9LWQCKrOFl5RkH5Xs0aZJ/dvXBB6ujdJBdwZ?=
 =?us-ascii?Q?y/vvlBNFWetGaIQLhoIgHvPv/WnyaqAVQKYcFfOFV5Y0ph7jkH4HzwZDnqWS?=
 =?us-ascii?Q?peMs4/jnaeUtYETtgQeRVOwtSZYeLxr9gN/i6bTES675s98XWg5tJ/m1SCoy?=
 =?us-ascii?Q?YZ1KKwh0CTdDJx9tn7xq7jyGjlBD0hsD5z0BmIlPvjQ6HCMvqcT8Ut9nxrBl?=
 =?us-ascii?Q?S0P8zNORvfY5RVcP81AeSvLET8wP/cBoUyWF67Xeo//1SpjlPF225O59owt3?=
 =?us-ascii?Q?x3EZ8xFQTcbMhfVZTebdqgQnkJsL5oBmAqaz6fJoEj+RkVdLI2BNTSRD1j52?=
 =?us-ascii?Q?SBB8gWGM4p+pRIPK5sWYRir1AUA3roQd5ZdAP6fRPHHjsp7/BgrD26DFrGBn?=
 =?us-ascii?Q?OC5Hi2ehqKPOXAYVKsGUpzV119lIDUzOEF8/9zfaWYbM+S8drh0K/cgtlJgv?=
 =?us-ascii?Q?ooaC2d4wQ8GsMQeuz64aaArdpMmHDB3KujiRozEeCbODIW7DCc2mA18MkwfD?=
 =?us-ascii?Q?3dcam/C2nyhQGmHj2BA/d1gNA5VRVEHhN4q2H3uJ5Yt8CjUuMaNxwdX3Nufm?=
 =?us-ascii?Q?bzlw/GekBQmrq9HnqL3tJ7Z0HSp516qQDmdmGhLYfwrURiLnBgtOuVSb7XYX?=
 =?us-ascii?Q?cOO+ps42ZzkW1dgQ1My2jUqaaru79jVGphxUtrdIIsgzTYQHnKrow3nODOVA?=
 =?us-ascii?Q?2rSfKPNnno6TFzkGqAq6+yP7+JamWe6LmShCFQd8A1MLoWmUvSBPsrg19c6G?=
 =?us-ascii?Q?8w47+kWqhiLu4yU1uQli3PGNWz//1s3TiuvmRinOrlJaqKxxFFfwW2Sps1CN?=
 =?us-ascii?Q?Ys3I+AJIyrzusjWY6ZTGfXmx3Hvqpi/x8UKHWKSnkLZJw5Xj1saHxqTvcfO8?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zDJZc7Os+52hs+n2S6Mp14jSPg7JOEiXlDmsaMD/91gfvkYEVPmQQvF6gOahlWtn15ZqTiDVn+744fkPWEwyJL/37wSehN/O8qxNK60OLhM6TR8IQ8BNIQm+KihZLYl+cM2kRN8/9Va8drQiwtTsKtonwFjeACw0+hYFFkM4VNuFtwkP5NKqy1FIlrT0DwAzU1GJS9mmK/xbo+skxiYObND/r32BOliQNxl4AEGwnrYqowg1qjVay9vnC+aLU/QvwkIx6IV4NdCkAp11MG2JwWJGUelm0lhqMkiaCk9CSGVZgWIW1Et4jjI9cqf4kLa7tyZk03g5wot5IN+uzQXDGlXT0QAYZ4B8u3UkLBX8AZVSHfrYgZqIpBevGTCyb/63kwDgrgwAJqnBvM5R8sHN2kyn/IH/8sv0YAnY43qpROk2Qg3D2Vgqo8n8LjBGzV6nCZE13/DXLRqlPQixuJa1vt6yrj5dBQ6EfaatCjlO2ZQLdFvRzNxO4mkNPLJDRGhayy7DpC2KbOWsAKtzXr14M8JDnMvldmF72NTEXu6b7aRl0tlE5oI/TUhlWpcFIgQPJy5JKfyS1Ppul63H+RHx0nbF+OuNGK2u1NjpKfkRHHvHVzAoN6YPaHciO6gZV4m+LED2Q3997Fs5J6CylMyrVhgPnJQtP1mt6COLumXrU+bbfaZPoZPbhl7x0W3DSC8RcTX7U0rhTrkcUn7B65r6cm/N+bg/g9Chqz2fhSSpl0yzeVcpRm2IwABMRtqg4adE1eStF/ypknrDomD+7BFzBCt9P/C+wTS4azfV+OgddknmYVAOXnOawkqlogCtV3ARXkEH4RVyE7orXfPhMlFjYSUKdxIKXKN5AkDyZ9MskkjTGdsdvJVbdjbpvLRLqQTI
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4668072e-05c1-42ac-c8ad-08db6ca76d13
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:34.9452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLtHPuiBKp8DcAVRvbhC1gEJK4PgjiJfjT1UEgNs8A2A3v1rcuW3TwEH1qPTnZt69kC4L4QHuq2KaTlLTkCzWnnewyCJEH2A3dPqR5T9tN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: AbtN5yWtm5JatmgRQw8hUh_t6PpxFjdf
X-Proofpoint-GUID: AbtN5yWtm5JatmgRQw8hUh_t6PpxFjdf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_16 have scsi-ml retry errors instead of driving
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
from the loop's retries. Each UA now gets READ_CAPACITY_RETRIES_ON_RESET
reties, and the other errors (not including medium not present) get up
to 3 retries.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 106 ++++++++++++++++++++++++++++++----------------
 1 file changed, 69 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a2daa96e5c87..f2edf1d79cc2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2403,55 +2403,87 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[16] = { SERVICE_ACTION_IN_16, SAI_READ_CAPACITY_16,
+				    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, RC16_LEN };
 	struct scsi_sense_hdr sshdr;
-	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
-	};
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
+	struct scsi_failure failures[] = {
+		/*
+		 * Fail immediately for Invalid Command Operation Code or
+		 * Invalid Field in CDB.
+		 */
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x20,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x24,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
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
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.failures = failures,
+	};
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	do {
-		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN_16;
-		cmd[1] = SAI_READ_CAPACITY_16;
-		cmd[13] = RC16_LEN;
-		memset(buffer, 0, RC16_LEN);
-
-		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
-					      buffer, RC16_LEN, SD_TIMEOUT,
-					      sdkp->max_retries, &exec_args);
-		if (the_result > 0) {
-			if (media_not_present(sdkp, &sshdr))
-				return -ENODEV;
+	memset(buffer, 0, RC16_LEN);
 
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-			    sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code or
-				 * Invalid Field in CDB, just retry
-				 * silently with RC10 */
-				return -EINVAL;
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
+				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
+				      &exec_args);
 
-	} while (the_result && retries);
+	if (the_result > 0) {
+		if (media_not_present(sdkp, &sshdr))
+			return -ENODEV;
+
+		sense_valid = scsi_sense_valid(&sshdr);
+		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
+		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+		     sshdr.ascq == 0x00)
+			/*
+			 * Invalid Command Operation Code or Invalid Field in
+			 * CDB, just retry silently with RC10
+			 */
+			return -EINVAL;
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-- 
2.25.1

