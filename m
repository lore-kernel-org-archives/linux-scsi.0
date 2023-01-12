Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCC0C63797
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjALDJM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbjALDI6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:08:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F6749146;
        Wed, 11 Jan 2023 19:08:57 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C11mlZ003876;
        Thu, 12 Jan 2023 03:08:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=WVqFBgqXCs+lXYN8xWaYWWhoNYHGE8jjtPprz7NqGKY=;
 b=mH8zmmj7njgVbPrpOp8gd/wIEr+REKLjLeVkjUusthtrovrBWv1/uFewJt8EWr5Dzadu
 PI4N4ipZqR+feCWmZGMjy6tfQzUGFNcfdoNIUdj/FgOZBNFmXXBTHMzQQEjJpSH1pCLM
 giGuZw0Q0JMWGFiHmJKbEYPxLVKZJXePhM5stw37weVC74Xcc5MnZWnuo1UH9N1t1hY1
 g+lWVAMo5e7vERwJ3FVRG4AiPgb+mSpFRvZ9VMN6J12sbC5hacdCyqfSbHmi5/QEswpP
 AI9ujPfFrXqbK1g2j3nVQQxhxv2IX20gw2Ip+ePMlb1Mee5OTePItxt3TqE7jimCSsDT WA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0btsd4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:52 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0f0YJ034176;
        Thu, 12 Jan 2023 03:08:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4fuxp5-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZoRDv+psimyCSZYkw7XNpBvLbSWdHT9UMDFL8y+VGcww9sx1WU4UUKC+xdTbMUonEgpseNmp+wNQHCcQl+Nt18S0R398JoydHRdP0KF5+OQdTQUyltssi3wU2gIZJQMDeJbPUVKHhtR57xDYrnNzUQtLNno1gr0OlNLc7Ii9Ym5hG8NHv9OQVgWCxFpargW0f0A7+taXdbW7v4x/c/+xu4K2mxeAhJrUR0MfiRhzGeWgXe3M3ubBqdVaVvTLeDYqQfFkCh9M/mYVslhVyzKt9BR7J17/wkwPW90mID/W8BVES0W733P8LVII1s+hfMSf03zfwgTGJW3A85R30Im1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVqFBgqXCs+lXYN8xWaYWWhoNYHGE8jjtPprz7NqGKY=;
 b=cx4Sw+JcnFMJRFDGYV/WMTW4nzGtHvKqxpVPkSDDxwCNCHr5qzwgZEkOY7072xYEXe0WF6RoLYjYZiZUR0Z8dL8/XsjSiU/cgY1E7LQhwOykFeVK2LP3fFWMH4rP7wZviyuitjguiwFCtJzBISWdB6tJgGcMFcf84WKr0anFihvuRTuSiAFk/UA2MG5+zBv8JdKuPlCYDXore14Ail77iiwliNVA8nyBXTdYNnf+rWVgTENwI5Z1sQvZB0/Eq7gCiqSTbIRVir3bvwAjS5fjdeXyeV3htWJfIzg6ZicIUEfRchfuQR1KokMWoXTB+HIGcifrNdu0llLs+y0FhaZOSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVqFBgqXCs+lXYN8xWaYWWhoNYHGE8jjtPprz7NqGKY=;
 b=vFTizhpyDmGENqieh8y29+1ZECl8Bdjsr4puTpzjX4ttG5XxObIYk6PyzIFqaPL9/oK7DJPArEfwOd9IMKTUMBEfOAVSF1TfjXiE06SClp0gD/vUGjvQhNRDTJCr4QvWqToDcmo80wFtSZWgJNG3Ml7Lh1uw30/Qa1ZKc75p8Sc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 09/13] scsi: target: iscsit: Fix isert disconnect handling during login
Date:   Wed, 11 Jan 2023 21:08:28 -0600
Message-Id: <20230112030832.110143-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:610:59::37) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: f3d5e088-6e90-4762-1d29-08daf44a53bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tb5i5+Tb2Kdqha5GX6+ElgnktL0sDuGmmwaTdZhxe/UaTu9hPmLWGQtP7L6Xxl3P1INrJ5m2r+LPmm6LhSCjqjAKbKvRZuzkAMynpj8IPiMSbvYdXuLN9q6zKFdwy42ySgitmK5BAB64+2vCb8PDzOHQ5UGfM5Vjry3HHaG1uSEcWJgYrpKh49ooskveRhm1IjQZXCC8FRtOJQ0keYrvqU7gOtpGgNafK2bGHLgTJ4Tu0YgU0PVr+OXU/6JCjcjt6tQo8IhduWwmzOgZVc2Um7DngchnJuITLk5pFEydo63390VOvIAbgSHP0enfUuj+s1ExiEHJmym9sfPJBlBPlYhPG+rJu7U3Tzwajx0Rkd87VSrfMdqbr7oFdFTPiUw3uEP5mkQdeeH4E2MgGq1S09cvDH6V7BnI+sQYniRFh0syJRXGI0V7PBZc+Qr8Jm4vOFgEdsFCZc6d4GU6Kzk3sRCvMPXI6iWlFbKQiWoGQS9lJkLi4aOzOc/uqCjt9NInEERNvT/OJf8glLvPE6Qfysfw4N6hxBXe9uJGQesgZvSx8vR30lXVt8rL9pym4aX5FrGmy4m+/r3wed3YLIvetL2UBPT5FkmcvSHOrjZWejLVlwlB4BLo9+I5Oo5Ll1cRkBaRRkjF77VT3csdQs+LMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(107886003)(6506007)(6666004)(26005)(186003)(5660300002)(8936002)(6512007)(2906002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3yv4WPuCoAT1wKGP0v7FM0zoj+EcP7MLZfD2FXibkCgCdsM/cMA6rsexAhDH?=
 =?us-ascii?Q?FkVFISCZ9bxPqnViuMu6zTC18g9lx0AwE1521NN6FTChVMa+WPxJKCrK65cp?=
 =?us-ascii?Q?u0Y70MJDTthtjBE2UBdLmKhfBqtvWC5fZe8afhl5xFtPRXsUxe+SilC7DV0f?=
 =?us-ascii?Q?I34lwWFCOrZtk2/Wn2ZF/C5j0OMP2/zYtVrV/+hU3wgMOKhJSb56lUmUUvqk?=
 =?us-ascii?Q?wD00kIzdiskkQ4OTvc1EMz0JKlertwyckkXYh9uGAn7LJW1kVDH+fe049oed?=
 =?us-ascii?Q?aV5klSQRcK2NuVTVS73mWUh91XtmLisfjqq7FZ+TIVrzax3ZnXU0yA7HRN2B?=
 =?us-ascii?Q?2vDj1H1OknOVIB/ldNN+GYM+adnW99B5vT+uRI+vOOXXr0Kf5br6x6fGLZF1?=
 =?us-ascii?Q?e5h4MKvFoQx7KnzvhBMZf8wHS9ouKcFHBtKTeMLRuev4wctDHz66oZS+rZBe?=
 =?us-ascii?Q?lWIfX+NfEt6kyosCZ/PzlntWd6DgX826s/k7rAx6uj2d4M5tAnxTzphRGEKf?=
 =?us-ascii?Q?BorAWO6ovJTLfGUcgmJyfdx0t3wCr+pM5/XuGOcmZOe5f3x5yz4E7U0OVmkC?=
 =?us-ascii?Q?jE292kvkykmD+Z7W258s7MpxIZ+kPSgFfFxonZ3qeEyobE/FV7FOv18PhFhq?=
 =?us-ascii?Q?KRutS9YJY9xXQf1vqXLnGmhLTPTjnKYxtIcDaA3S0kfzczCOG8ac+ojdRxqk?=
 =?us-ascii?Q?UwQu8mdIVKlRyLL4ZhLVBHNINkC0xBDie3q69yFlkLlPrH+XU4X2NLMniAMr?=
 =?us-ascii?Q?gNbEgtAjP1NQ70tIL6y+fGiSVONciahTaVCudX6Nkop4RYLoreB8/j1eH4IU?=
 =?us-ascii?Q?vLRshTGXeWw/uJVLb+TAJc1y5dOM3d33nsBPKBMusoMxV70bBtce6bIGYFz5?=
 =?us-ascii?Q?F1nzT4RrTdN0ovFf0NLeznSS906I291ehoikaZJUUpeob9AXitkfoIl8qWMD?=
 =?us-ascii?Q?wHOSnMHdAu2p32dtHyvgS2k2ZOGJysGW1CF+OxHvrLhHFgjyQcGx2H83njmn?=
 =?us-ascii?Q?pJV6yVnQVbW8sa0PxnRmBzJzMI3ds3vkB7lDEgy945CF5gv0pvivSANHgo7U?=
 =?us-ascii?Q?W6gNs0xxdmivxvSRpj9C/hwMB+XVxfaWB2JsKMDUbqkGLH0NVDdmCyMF/5ER?=
 =?us-ascii?Q?+A1pBNuSZhQoX7r4smRZBeKSvoiGvIrLQ41nhCKwWmtIsQ5f2RNnySAkbunB?=
 =?us-ascii?Q?tz3CD73Zbm1V9kn3HDu8RBUm+m4BzC3sRb8ojoWdxPbAhJLT9uyFpEZxDaCp?=
 =?us-ascii?Q?vEb2HQWcf+gKt4AJU/GazsGIll9oYu9PrTxgdJPjx5r7WfMSabb534IyXyks?=
 =?us-ascii?Q?AC2LtpGFdyFVOmnlDuwGb+t981Zy+4gMHUE/lQGHGaNNCyfoarJj3Os/xoKX?=
 =?us-ascii?Q?Yav7ze3Yf8fmMBuEkT5Ej/XUr+uTz8YbG5Ak92EnoRbEjm8/JDPSw6c/hLzr?=
 =?us-ascii?Q?pK/iJTV/ZyvZz84fTeK2E7S6Wxhkea+Z/m36v2GAywmo20MXIDl+dIHV9YCp?=
 =?us-ascii?Q?cWQk3MiGhw6s3hhxULNMoQ6X9VB9KN0+vb6txklHyNvzvUYraWAY512xDtcv?=
 =?us-ascii?Q?oQtLarwHV1feHO5ABEw6fgdtz1YXZ6Da6VXVNcSOvX9FqnUOaGzC/jsry+BH?=
 =?us-ascii?Q?5w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +R0d0y3XE+uSWjF+SAfrNl+vuCZEQWgWxh7x3X2t/s6yHjDsbB4huGGd2ciCFS92qf1Dwi+WHoV6SyBsxCd6QOHA+EpjarRIYMU9FNk1sl5ZmBLn6AmxERNFWv/Aw7Be4IGlr73v6O8TsT5I3QtRy3uHsZwUmuR+7zBlp9NV57XCgi+OWZKdtwzTLn3i2gDWOnlJMMh6NcRMR4LKGpys+Xe7iU9o7ki6gaGHWuapFiLB5o+ig0mooGbYxEUaADKviyFr1TiIJ+3GoZbpChMA4tVYJIikQmBg7NSifTR3Ab/2KdCYMvBljQpOOs7DcOGdOjIgY0x5Y0AGx8QadCckF1Y7zDPIHnbKvR9CmWSDGYUjkssPnecNu/LRC5LeXbyrsKz2DPcc+cjRskRNdXdqax8zpX7XHy2/bxvplmiW765VjM5H+Nm2ne70zwM0uqEtxbIjGOTSahYI17r6rwPNqiK8zk0HOURBIg5oWnIAgUrOG+MuuxtOcCWzmI+lLKhZpT/tTzgphLY1JUA8/RI7ivGx8/zrhpn1XH/MFCkZ/HF9GsaroV84yDZtMmaDOX5wsSBy0EPfzhLtNvyHEWvu9j9b1CklmT9ChJw0ubOz8beNOV/xU34u0RJX4izD7th71UTziIZjWoSf0kxYY+fGxqGNDJXqNWugWUKofPLxqEpBMv1Gazhmqpud/2VWSqYzbHZQUv4GvADtd+lNCU/zOjhiGq68fajBoYypZUpM9Ylg1ItqdE9vqYyaf4qePh7BhaRj3Kdmy8nWEz6cyUm95pppK9BdNdl0JEDqk0r/1q0AIVVHo/S1EryDhPN9/U7JYHpdvxkdJdlzQ3G6ZpVw7B+waqwy4/hKATmpc0Anw5l5V5TmNaHTe3bOTglwOE/f
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d5e088-6e90-4762-1d29-08daf44a53bf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:49.7856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PXuJItLb1qzWcSQF8k7BiJz+sqLFfkVPO2kjsRFieOIpdoFIDgehg4W3ciWcEm912FJ3HfUkbFcLy0lstU1bGDNaFyYgb0o+3g9xCLzMmMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120019
X-Proofpoint-GUID: ipSIryJmQINkMgYYdfrLJCRCOzR71Ran
X-Proofpoint-ORIG-GUID: ipSIryJmQINkMgYYdfrLJCRCOzR71Ran
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we get a disconnect event while logging in we can end up in a state
where will never be able to relogin. This happens when:

1. login thread has put us into TARG_CONN_STATE_IN_LOGIN
2. isert then does

isert_disconnected_handler -> iscsit_cause_connection_reinstatement

which sets the conn connection_reinstatement flag. Nothing else happens
because we are only in IN_LOGIN. The tx/rx threads are not running yet
so we can't start recovery from those contexts at this time.

3. The login thread finishes processing the login pdu and thinks login is
done. It sets us into TARG_CONN_STATE_LOGGED_IN/TARG_SESS_STATE_LOGGED_IN.
This starts the rx/tx threads.

4. The initiator thought it disconnected the connection at 2, and has
since sent a new connect which is now handled. This leads us to eventually
run:

iscsi_check_for_session_reinstatement-> iscsit_stop_session ->
iscsit_cause_connection_reinstatement

iscsit_stop_session sees the old conn and does
iscsit_cause_connection_reinstatement which sees connection_reinstatement
is set so it just returns instead of trying to kill the tx/rx threads
which would have caused recovery to start.

5. iscsit_stop_session then waits on session_wait_comp which will never
happen since we didn't kill the tx/rx threads.

This has the iscsit login code check if a fabric driver ran
iscsit_cause_connection_reinstatement during the login process similar
to how we check for the sk state for tcp based iscsit. This will prevent
us from getting into 3 and creating a ghost session.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index ff49c8f3fe24..2dd81752d4c9 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -350,6 +350,16 @@ static int iscsi_target_do_tx_login_io(struct iscsit_conn *conn, struct iscsi_lo
 					    ISCSI_LOGIN_STATUS_NO_RESOURCES);
 			return -1;
 		}
+
+		/*
+		 * isert doesn't know the iscsit state and uses
+		 * iscsit_cause_connection_reinstatement as a generic error
+		 * notification system. It may call it before we are in FFP.
+		 * Handle this now in case it signaled a failure before the
+		 * rx/tx threads were up and could start recovery.
+		 */
+		if (atomic_read(&conn->connection_reinstatement))
+			goto err;
 	}
 
 	if (conn->conn_transport->iscsit_put_login_tx(conn, login,
-- 
2.31.1

