Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CDEC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiJPUAI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiJPUAH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:00:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBABF1EEEE
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:01 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJ231b011591;
        Sun, 16 Oct 2022 19:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=VUGW1LUPRLeGSf92ZKv/V2VLWmasJZ8CV94kmomI6kQ=;
 b=K2yqGU9L39Tv7fCQqAD3y41wcLJDN/KZCKz9CW9CSi0Dv2hHTXzx/dyzeqrPRcRRKiYq
 O7x7FX7MkbIcNQXWGwEpYXIJxwMYsxE8Y6S/SW3RZmfhFGDPUhqpgeGKGzpxhgsXIOSx
 RcbCeYFze5ThZfvz1WDFMBPwXj1gJ0L6uzGKZzEZr0A7s9jlJ5Bbga6datg3pJjcJuCE
 lCvTWNJJVZaRQLQ/hK8/IAsB9KXyYBc5/Qh4NRH2p0blW5GVRWGYNqf9bGc3lIsOwyFq
 E9+n6XYHZOsUKe/wdVNSkQG6SZBlpMqnrFbH8xvK74Ag4JjrMnMBiswFJBO5S3R9XBve kA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw39ycx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 19:59:52 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCHcUk034356;
        Sun, 16 Oct 2022 19:59:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hu54c3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 19:59:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7aTBE1faPyUI0NJrZpMErBygpsyXbjngFg94S9QpShAJhB8axRKOJjIasP4NYHcWXtFDEGR1BKGzJMFz5jyGrdk+TiY//UYpiRhzsLZH40XGOHyV1agK6r76yTia+UvW9v2Zqt7iHaQa3bqZsPRyh3UjL5rIEWdl2eK0vviTMcS2p6lGxdxQIsWdJqcvif12RzmhDOAktx9mkBrIRYP4L51NYiPptXiFrdMRMhqLlRWcZ6cbm4DVTNy/nfmljiZbE9Jeen+dqVvKit7M5ouon4J5VZ+ga7Rx2/plj3JMwT32c1qmgjmdjtFTv0/m/FcZIyEUYftvGyvrMsNcib9vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VUGW1LUPRLeGSf92ZKv/V2VLWmasJZ8CV94kmomI6kQ=;
 b=ESskZg5yGyzIQV2M8x5LoNG3tF9o4C7SLepMXIrcHyhZQN0tgaKlW6y0v5BuOaq7dennEWPjg3QyjC152XI3Dlv+mw8q+MRsz+7WaJs96lIiNmNIq6WwxrzAqfur8xM4nU8Uwe+dgkBgJWFweuhxp0qSZg3WsqySw0+dqLdR2Iufza+P2YL0g1uMYfHVL+zhzfzixoJZxt5DWDNx3URwTWAwzXjjBE1cmUaAJRL1+I88jdz13pD/fvZ4ZaVqn3exwoWuvJX0kfTbRgRsZVirI0PprVXT1hmhorb5e41qMzPuMFj33e+yvBiY1Fks2TJVqbHxIw8bsOOVv8BKo5+yNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUGW1LUPRLeGSf92ZKv/V2VLWmasJZ8CV94kmomI6kQ=;
 b=YoAhylVyjtjdyw3zADwhJg/NwZ8lleK9WBNWfJ4lxcWfN9FI3CbsQN+US1SXktSiLWac8F2LK1qRJNkSu9F/vxJXLRuPFjUjYPBGZanRWzyuZRUKzrbpy+PFljtNPt2JERZTFyiABrsq/p0o/2CVs/UY8C3lYZdY5c6dJxmUHng=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN0PR10MB5909.namprd10.prod.outlook.com (2603:10b6:208:3cf::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.32; Sun, 16 Oct 2022 19:59:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 19:59:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v4 00/36] Allow scsi_execute users to control retries
Date:   Sun, 16 Oct 2022 14:59:10 -0500
Message-Id: <20221016195946.7613-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR08CA0003.namprd08.prod.outlook.com
 (2603:10b6:610:33::8) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN0PR10MB5909:EE_
X-MS-Office365-Filtering-Correlation-Id: 520e3c95-7636-42a4-7037-08daafb0fb2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kak29SmyCUzWpEh65Rg7NAVVOstKKgMIeX0sE4QgQvIuKosppOTiaZr9TMxfifo/YbwVWZHBTV4Eu95mWMbjeHazXekC2LiNVdG9FE6bemQy4GIvG3EuvJzaVW2QFuXRIynT1bzxYgmeaXiU4+YEdvOF4S+8vKJNzzoTXp4Cn/Br7lvZ7Yel9rll3evKUekrcXaEpbZBh4vSnXeHV9PHvp+WiCDNdOfYEMIBUdpk3i5aQ9szRn1H+mHpTW9pFRks8B5KVzJADCkZKt8Ge9iwSCiqwTtVVnrpSzbFxS40EM4yDow/MO2Iqk8UtnPx1OxN4/cHIEIuk2esjB2mj0YgCTWJH0goA2tDU4bZvxidCzj8/gVK1f5EDWsjYsYed/P29UfjRfivft3ykkT3mv25nJsYORiD3HxRHqTLE/2Hwg7zZKmbS5QNsD85eyf7/rnk49Qj+aNRdlTPYnIbBmtYiwcVf3dPA8NEjY5zAybMXqRQ8IH9Euiec45C1v6r5YMStTn/bPs4T2Irc1paHvIri/lGVnX0Yugd6+5+gXHPRKKrZuXZGB6jPHgbDKt+vE8CO1DEQiKN9blPR2sDw3qjHoxJsTscwFiS+Pr6mDifR0AsgVlQt68rbLwxe8myFoS3FG/8TQh9HotV/aL6LSNmK0JF32+0s2o3413V9YRYWKVas1ztA9bsErDftZPAr1+Utf8RE1Q9dKscNST/QQUHPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199015)(6486002)(316002)(6666004)(478600001)(66556008)(66476007)(6512007)(5660300002)(1076003)(186003)(2906002)(8676002)(66946007)(6506007)(2616005)(8936002)(41300700001)(26005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jW5GjwkroZTBCq41SH4QLRcSkRzDVhv8KP5vKJsLZj0tpJj08QPGiZpi7Rtu?=
 =?us-ascii?Q?TZaF6zrR5lySiP+i/nkHBA/cFeVFg/wQze9DxD9tbq3A6thmpOc+cIuehZlo?=
 =?us-ascii?Q?l8FRKvu6GBc2mOPUkY+3CkjFp2kuTjA29ckxglpPYyLKgRa8lL7YwoUwwPkr?=
 =?us-ascii?Q?mObk3t6a057QXqlk2grBBpA7O/SNajoBUUmw0e499iECRHa4R7SDluqmy7OH?=
 =?us-ascii?Q?LF0QNAuZhQumc//+C4518GM4bOPceOYVX50FriisfzYjC9hTtH4sHJLZgkgJ?=
 =?us-ascii?Q?FYBeb5v9DTPdlCDSYa8dPjaVPMgZEFk0L9qrZRcmlykdRzl32oLm09oGtZM5?=
 =?us-ascii?Q?ZXxFpKHHEuTIxIHDnaPP6B3OJVZSXXBRf3s/SNtf2ESd4hfFYRIPRnMWLPh7?=
 =?us-ascii?Q?PN9LeNlVlK2NJ95d+7ezoNEFB+HhTnHmDFBG9WpRZtdzeYlvD5I7Ag3efb/d?=
 =?us-ascii?Q?R85aZ9um3cyOD2RhxbhjXdey39MqHV/jt5JmBIVYhgVGPEgqKJgP0i8DPc6x?=
 =?us-ascii?Q?ogtgGG72M+pvCC0drzLWYVr3w6jlwm8l2jmMO0fx5EoT0U9K/LFt8kROLW42?=
 =?us-ascii?Q?fTyT8YKSKH57RZS7TUZbF4JHD/pSXufXK/ofnf9UEaChfhaEHTow67VcxeDb?=
 =?us-ascii?Q?+sEB6wO4tOAR01twHniBaRasUWvMmGi9/j0MpK0iS0tEAhrwqyO/NxlsbbPT?=
 =?us-ascii?Q?FafngFQourf7IeOqp53GFiY21t7nx75QaP7O6Sa7xh/xEbQFCEf+bh0vtCAd?=
 =?us-ascii?Q?Ym8c9EBtAD0wDQ5qr2nG5Z5JaSSQ4BLyPpMsD86F4wPwDLtVMFJ5gCx+AYDL?=
 =?us-ascii?Q?w8Ek3pGTGI+8Mg8E0XBYYhBCiFcZrAKgeBAur8zeUCM7OfptT+gsWmJsEXW/?=
 =?us-ascii?Q?U82aGX6/XLkKNZN8l+VrdOxRP98uXYV7/MvIfuKcOLKCj6kAPnsCgUbEo6IC?=
 =?us-ascii?Q?zhw+Q519ng2t3/cR5CtkMjCkEZ20yx2WVjUlknRg/a2/x4eZ6k8rquedgvLN?=
 =?us-ascii?Q?FAXy08uiY/fgJTGh8/G7la4pptAgc50vf2LSrsUXOr9bjY6BwKF0xPTS/6KK?=
 =?us-ascii?Q?GzU13HliPV9TtopI8G0bHpwRvPpUItDZv35XQlg6WLPRUFNzuptCr3Bi33kK?=
 =?us-ascii?Q?jnh3seB4fc08GCBSslBu/zAIo3yiOrUxgGa1MZFCsoxuHVXnIO5WFAQ6UIu6?=
 =?us-ascii?Q?9AwS2vPbX4aaadVaOj/d2nx0LPS48j1yZEc7vUQ+b6waexz48iv2Ob/Y+CEN?=
 =?us-ascii?Q?FvYZaDxISygWn6+ZQRvlCCuNgf7ChtBNj9oLJ8r5aVA6hQxx18NGyxxkGqCS?=
 =?us-ascii?Q?2HcMq9DqtYB5SkuTRLGIIUyu5qC69XwxOyyaZ+E6xgvtzCHVgl+twZfcAaqt?=
 =?us-ascii?Q?PGLvdusaGuHvxcnXge1L2OKUjehoa3G00qGieZlPTdOlc1cRhoYf9PpW4S6Z?=
 =?us-ascii?Q?PQZ2oS1X/l+njW1JLPg94KCLeVAbnsxkg+58orh0qcvzjpKX8JXDH9sQ/Cci?=
 =?us-ascii?Q?1+w97cn2sAa0Ayf9Gu9CAJubq/nxXNiZouHAsjxfJH/QkHcDjlf5P/0aXCYy?=
 =?us-ascii?Q?BvWnuW1eBUme/MLWtH/IGdBasyml5Ha9bgmMCqfMKSmKg4T+Tfi9dCicdS7+?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 520e3c95-7636-42a4-7037-08daafb0fb2e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 19:59:49.1607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivjeAVHFb7ebuQAwbotyc6M6YNofVc+EBmVp8xILrttEwJEzqTqERczFo5GsShM2I0qBu7AI7vzLiPG2ptlzP2trYCAfc9f/Sd+1nUfPar8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5909
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: zikZESRCzg-tk1ls-9oSnkQdAeC6I2Q_
X-Proofpoint-GUID: zikZESRCzg-tk1ls-9oSnkQdAeC6I2Q_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches, made over Linus's tree because Martin's tree is
missing some patches, allow scsi_execute* users to control exactly which
errors are retried, so we can reduce the sense/sshd handling they have to
do.

The patches allow scsi_execute* users to pass in an array of failures
which they want retried and also specify how many times they want them
retried. If we hit an error that the user did not specify then we drop
down to the default behavior. This allows us to remove almost all the
retry logic from scsi_execute* users.

v4:
- Redefine cmd definitions if the cmd is touched.
- Fix up coding style issues.
- Use sam_status enum.
- Move failures initialization to scsi_initialize_rq
(also fixes KASAN error).
- Add kunit test.
- Add function comments.

v3:
- Use a for loop in scsi_check_passthrough
- Fix result handling/testing.
- Fix scsi_status_is_good handling.
- make __scsi_exec_req take a const arg
- Fix formatting in patch 24

v2:
- Rename scsi_prep_sense
- Change scsi_check_passthrough's loop and added some fixes
- Modified scsi_execute* so it uses a struct to pass in args 


