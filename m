Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0738C46467
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbjALDJs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbjALDJE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:09:04 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB68749152;
        Wed, 11 Jan 2023 19:09:00 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30BNl4fN022693;
        Thu, 12 Jan 2023 03:08:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7thZjMwxCJl9nGbKjWxJ9UcfRNDxh1hpW+g5TgzOWoc=;
 b=MicdUemSyahOKY1MOaxVvPDTsh156WbhFz9MAbQQmfV0lEhZVryty1ao9+tVjTjSuhkQ
 IdybazOT9v7WQN054KFqgazudPK3AYvHg+cRV94HuypEvIISpAAkECbcong+6z1u4LxF
 OwcMvzzRRR95LCLfHU9kaCrHu7XGdqDIiI1d1ht4QL4MbLWp/susQ1NH9glKT0DawJxo
 TXuJlWx4JypFgv3rm2i35pOajEsE/x/1YzjkOqtHydBU1x6RsnBW3KMGWzxwMOcmeNMx
 f1aEREbKH2Mw0KVW3LYp0x4to1L/yXQJgZDHwx0EVGREYUUcESdvvgDL2W89TBvm7Dco +g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n1y1nhhq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0ZZJW034175;
        Thu, 12 Jan 2023 03:08:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4fuxsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQsGXAMgyLkYC2t6vXF0CSZsoM0JVCOli3r5hSweJPurgJFCuMZt7sw/O/gNO88YtO2Ps/dvpwYa3oIPeqT5/cOIOmVC1UMItag+G+nM2yoQVl6MMdSFH1fY2cb4MNN4NXu9IWG5mnfcu07Wli9rwRG7v1zyzmFJjPdbfHiu7eypnKvToqYRIsTMwc0HNdFBhWObOqNk847ew8+BPHiwADmmiVECkLUDXAEZxg88PiVk5UObSqDoHeatqaVM0aQQDcY7cF1tcTMQREkU/WpZbYk0V/6k6piuYFoFt8/4IiSA1uBigXJSlOtHAvNpjH6Cdcf8L0yeKraGMsIfr9sC+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7thZjMwxCJl9nGbKjWxJ9UcfRNDxh1hpW+g5TgzOWoc=;
 b=im7D+jDm4pRnQd8lUKQL4O6iy7tKMxW9GaLaHHIByDhhS+gfu50RvDh4O1TOTByjrcSKOmUayQHGOlbOazaxnaRbi0/Lhw9DiB+3m34+WDA8p1bD/auPQEViBMZWNypS1ZUnenaGqHVgDWrFKQXCJiqD4MwduIwN+FNx93QNmLofNEgePFxHgY3ya3P4SUns1dV954IKb6KXMf0eOxnw2dUdTHzx5ckQMl4I5Cllh9Z/fgJB6y9qb1QnAfzWFiKUzhcYqpjoIGfZ4wrpoC/qkDsFaslkauzpHrsDI4HWRoQqdpP1XuZIL0Ayu9uA2vV1HlFHr9s/IJeB69riQ6ZoeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7thZjMwxCJl9nGbKjWxJ9UcfRNDxh1hpW+g5TgzOWoc=;
 b=FcgvknSQvHg2Wa00C26JtkeakxRkXXVfv1z7HTJXxCJ4ybBCiu1WXja9iRXSUEk9oyPxDsyHcyc7nhCJRvmWRVldy4O4x/n0WTGIJjBh6Dcrc2ghwpTpeq/RDOAMAkdTbG7Do2PKuRAEVN0WZrJan/Tis7uK6/0u2FAQO7yVbX4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 11/13] scsi: target: Treat CMD_T_FABRIC_STOP like CMD_T_STOP
Date:   Wed, 11 Jan 2023 21:08:30 -0600
Message-Id: <20230112030832.110143-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: 40d5802b-464f-4154-0e47-08daf44a55c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q0M12QTFhXcUGhpt9iN3KuA6uZiP3scajIUuf2lKuB78K35GfvgjVPzT0Pq41sS3mEbtj0tYY3OrJHBWrJb5YN20Q9GAARaBAfeuNokV7Ch/UpVdFWXwIFrHcmYx2PaIMQ6y7xigrYBQnO2IZ0siBXTXL2ThrteqWN6q05P23DiwoQuibavFHJBL1gWkNiY4xaE+iqVctF6gXryTAABZm7gHNp+JJizwBEtT29Y6eo/OazAvAwmP/tJl4SZ4t6lnWlzNe+HEWMZhV3A8hyE2pk4n5c1OgfvAsZv1OWoFufn3iMCRW3w9V+iqUINJIv6+Ssf04Nc2rqq/k3xd+axV0MHrXyWZ2eaylJ34UV44hsDkzhxub6HGaC81drGM++0QR3hRy/RdImM2+SxnXhBGBzc5bs/kIdgHLwR4LipwLJrHzetv3W9uubbofICHHDsAPVxN60uTzBAdF0PEnI/OIoc3Rv4Dpl73YkGN5sGh/dTsS2MqGAhoCH77HO/JbWwzsaxK5+irh8B6vdAntndJyHvyUQJQN7FGpMBXnlz4GcMLb7dPjKsZo00ux9PIpoT6h9xFlt7OMuwsM5S65JhFb3VBKH9IeFUZaNk7GfpVy0I8yAEA7vg74dEQK3O4kMmUti3p+TFkDcMU10+/n8k2zQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(107886003)(6506007)(6666004)(26005)(186003)(5660300002)(8936002)(6512007)(2906002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NdhS1z/bu2ZCqEWd/OP8/2S3+W9MHHF9KdAp3Oc7dOg9t3dBOK9tIExOPFro?=
 =?us-ascii?Q?U7V0cCqR61N32TTpGC1D6eHbVxDNsFK7vvzNeoI8nN/xh6T4nRVIb5OoCp6n?=
 =?us-ascii?Q?h/OW8r9cYggyh/rm1pq3uMRhF/XYlDbqoHH/vK3/ET1YZj4c8CZHn6sQinGp?=
 =?us-ascii?Q?yAw5opHI1JsNSfkRcLCbrXuxxhUsYamFdJ8IhXugCCc9VfN8jV86ftdEDN2K?=
 =?us-ascii?Q?I7er/Y6n5yDyDYfvRF+EBlAVXNaq5CdizgC2sT+valBnPP35SI+oq46BRmfa?=
 =?us-ascii?Q?YC/jDpoLr3+O+448hrkTcaQ8HUToSrfIn4mGv0ichjiwUENR2srCyJmYblLQ?=
 =?us-ascii?Q?AqASsHeptL66jUFv8HV3eUAv8wxaoBoQlSHXB/l2WNEVHLEYyWoLFk8DUq8f?=
 =?us-ascii?Q?mIhxj+eeUAEgA+crMebQR05yQwIne+qKmdh89TLFZv82R0sB0BQgNFyng3Tz?=
 =?us-ascii?Q?1wbA5/DFphkbN5BCr14m79uGQKCFPI5lrypz4WbuxMs21rGVueemMt/QZcWB?=
 =?us-ascii?Q?76r6+QzfJM0tElilCwTNON+wbsDVX2RF4gTbjW7zdLlM8zHJQ2NCO09m1Kpb?=
 =?us-ascii?Q?V3vdAFOGcxP1HQ9qHmkXxXNCLVlJ+nipKKJgj0r6MGCNjPRhY7SjKEOF1oyG?=
 =?us-ascii?Q?jfsZDxJ9IOeNBZ3z5IzlxP28cjiIUCyElV5Xj9rmgx3Gvx3cuMktAtFRbVo1?=
 =?us-ascii?Q?d+E3yNiJVQ8mEOJ45JfT7s887oM05dUT8nTaYsaux7IUtD4tl+xlLIJZbX26?=
 =?us-ascii?Q?+W3e12IRokyGvbVxNQJVqgCwajkddVg17MY3TEMoSpiZy5LTtlIEgRSDrgZP?=
 =?us-ascii?Q?BSO45wZ3hRWw/Lm7BLdHUSSTohOEHLaoM9YQZeUM4SSSSibMXJUP92xpXUOh?=
 =?us-ascii?Q?WiZtVr+wD6Q55TzAlpCXon4TJrxh+BVfZP4yEpaf4sruMU24RA6e8dzFMEdo?=
 =?us-ascii?Q?0/MTRe55Z9irCRR582PkOxb46G694ADlxWIP5B1yig6Z77eWZ4DnN9/mvdWK?=
 =?us-ascii?Q?MzOE9DY/eSNacawTxw8HcmUj4v5KtAZsL2eSX4tLW0N84X7asz1Lndr675S9?=
 =?us-ascii?Q?dTjZhBNtxd2BBoTLXrAWnsadBFbFwkls2Qevzp5QbFV2Pn7DqHZco70RpCvv?=
 =?us-ascii?Q?apn840HW9yw4hi6rnbksFfgTTWA+nF1nV1bJm6kBCy2PU1+mBfQ6WFsg73bi?=
 =?us-ascii?Q?sn1gpv5VQVQX5ITDaJvw0hvPQkvS/Zt45NXxc9XmR8eIkFP3F2fNnRKCYORK?=
 =?us-ascii?Q?ALBL5ZAJp/BG6b7jUIxQtngmZuHOtwWVXi+kmivbpPqt1jHjILmgOh4bUBLC?=
 =?us-ascii?Q?gyBINgYrJ0/qsTb5/Rj7r62CS/KHaZitMBeScEiKdMykTmkZeQsgcbVqb0oM?=
 =?us-ascii?Q?SbFc84J6kJtCMrw/NrWZG3DT3KIRHRb2I1kSFskbXNoC1ElEkJyUX4zrkIQM?=
 =?us-ascii?Q?EsB5pXiJzfhJAbzoubbj3y+yS1fZVeH5NaVtJnqAxeUSBL9QlK06D/ZplbFc?=
 =?us-ascii?Q?SsRzx+G7w2Ucl+FBPuUaZv4D4dF9n3+F2fYetLp0YLQtuRqObFQni9xpYRJ0?=
 =?us-ascii?Q?uwixpC/Mz8dpmqRZ4RdAt1pOjk35Cmc+onr5X6g/Q60N9BfrEpSOiyHswD13?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4jJ/MUktgENflCX8oZaOlyHORuWxYfPA6LJomE1Yt+PvoPOuyG2Bfj06PJ7GW8nWPyRq7ecFwt3kjqWqL459xec1Xoq7+ueg2MJupVEnp+RPqUwD0xh29EkLrF2lB4DmJiw+N/YaOHl6DALxbYkuXHpab0oDojnMt84XLYSu3ZxN/kHUbgdrTgc1K527RDgjqx0GjzSgWcN2sNYT71fYg+P0rWtzm8k5RAb+NLta+Ulx4v3BxsUwW/bXW62snqt/qgNnzhOT+6j39yti1s5lnCjF1rFR+uaTpa2dh0WXdOe2x4CV8mQnimvLfN825p0Q10MLu/b8KiwFYgfv1+PGq2nvFnsKN3CRzOf0RPMs4jt8q8DjuH2HUx/LbTNu+MikFytxBVC4xG4KyyAZxuw5ZGfXHFk/vNFqCRlzXSOtLYalDj+0Zex72XHGDDvyYDJ39zf1rEOpRbELF9xdLW2vIqrcLnmu1IvWIk/afCE37gmM0CFrM+EPZxEE+JDYDBeqY8+YEiDYyJ9AYNYD1jSnYqIYRGDa7kQgyreQc6PEX3kscOUAcBKq/GS+rIbBZV+Ba/IOlvLHf9lwWgDEwhhNgLY3tcmOfYypPPKuedFllV/TWUtBVdUmDSu/eS28bqkSaeIY2Cor3lYc9S9dBvJdE+1QYfZPAUpUYtm89YBXTxbZ/h4tsR0BOD+aFVS0XSmCKWVD8zYio9E/+Gp3Vq8XiaZB6Uya6jDUuRsVAvQbLWEc+71O54p5g/lwaXhOZNn+DgPO2JLNjxYpwfe/JhRhhxrG6wJtMk8YfD+NbgFWO9VIcxtMseJCoWS8BcdtivThqJo/q96mEgzmTJkZV+eL+7djGrBfZyRYugeUjwRH36fbM5ryYZ2IgavzoVILrHFh
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d5802b-464f-4154-0e47-08daf44a55c2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:53.1759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gFM1B/0jwD8QDQNRF+dB3lLss+4uZahkE16mdbHdJhhbYAMm5z20W7WQ4gK6IWc7OQG5sM1BrOHcymseY/7leLcFAgSKoOUih7c3GmO3rcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120019
X-Proofpoint-GUID: IhJfbuVqvXb8hExDyyufFbEGr1KuTnTA
X-Proofpoint-ORIG-GUID: IhJfbuVqvXb8hExDyyufFbEGr1KuTnTA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iscsit will set CMD_T_FABRIC_STOP on running commands when its transport
connection is down and it can't send/recv IO (tx/rx threads are killed
or the cleanup thread is run from the one thats up). It will then loop
over running commands and wait for LIO core to complete them or clean
them up if they were on an internal queue waiting to be sent or ackd.

Currently, CMD_T_FABRIC_STOP only stops TMRs from operating on the
command but for isert we need to prevent LIO core from calling into
iscsit callouts when the connection is being brought down. If LIO core
queues commands to iscsit and it ends up adding to an internal queue
instead of passing back to the driver then we can end up hanging waiting
on command completion that never occurs because it's stuck on the internal
list (the tx thread is stopped at this time, so it will never loop over
the response list and call into isert). We also want to sync up on a
point where we no longer call into isert so it can cleanup it's structs.

This has LIO core treat CMD_T_FABRIC_STOP like CMD_T_STOP during
command execution and also fixes the locking around the
target_cmd_interrupted calls so we don't have a case where a command
is marked CMD_T_COMPLETE and CMD_T_STOP|CMD_T_FABRIC_STOP at the same
time.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_sbc.c       |  2 +-
 drivers/target/target_core_transport.c | 27 +++++++++++++++-----------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 7536ca797606..56136613767f 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -459,7 +459,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 		 * we don't have to perform the write operation.
 		 */
 		WARN_ON(!(cmd->transport_state &
-			(CMD_T_ABORTED | CMD_T_STOP)));
+			(CMD_T_ABORTED | CMD_T_STOP | CMD_T_FABRIC_STOP)));
 		goto out;
 	}
 	/*
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index cb3fdc81ba3b..02a9476945dc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -737,8 +737,8 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 	 * Determine if frontend context caller is requesting the stopping of
 	 * this command for frontend exceptions.
 	 */
-	if (cmd->transport_state & CMD_T_STOP) {
-		pr_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n",
+	if (cmd->transport_state & (CMD_T_STOP | CMD_T_FABRIC_STOP)) {
+		pr_debug("%s:%d CMD_T_STOP|CMD_T_FABRIC_STOP for ITT: 0x%08llx\n",
 			__func__, __LINE__, cmd->tag);
 
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
@@ -889,7 +889,7 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 		INIT_WORK(&cmd->work, target_abort_work);
 		queue_work(target_completion_wq, &cmd->work);
 		return true;
-	} else if (cmd->transport_state & CMD_T_STOP) {
+	} else if (cmd->transport_state & (CMD_T_STOP | CMD_T_FABRIC_STOP)) {
 		if (cmd->transport_complete_callback)
 			cmd->transport_complete_callback(cmd, false, &post_ret);
 		complete_all(&cmd->t_transport_stop_comp);
@@ -907,13 +907,15 @@ void target_complete_cmd_with_sense(struct se_cmd *cmd, u8 scsi_status,
 	int success, cpu;
 	unsigned long flags;
 
-	if (target_cmd_interrupted(cmd))
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (target_cmd_interrupted(cmd)) {
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
+	}
 
 	cmd->scsi_status = scsi_status;
 	cmd->sense_reason = sense_reason;
 
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	switch (cmd->scsi_status) {
 	case SAM_STAT_CHECK_CONDITION:
 		if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE)
@@ -2277,10 +2279,12 @@ void target_execute_cmd(struct se_cmd *cmd)
 	 *
 	 * If the received CDB has already been aborted stop processing it here.
 	 */
-	if (target_cmd_interrupted(cmd))
+	spin_lock_irq(&cmd->t_state_lock);
+	if (target_cmd_interrupted(cmd)) {
+		spin_unlock_irq(&cmd->t_state_lock);
 		return;
+	}
 
-	spin_lock_irq(&cmd->t_state_lock);
 	cmd->t_state = TRANSPORT_PROCESSING;
 	cmd->transport_state |= CMD_T_ACTIVE | CMD_T_SENT;
 	spin_unlock_irq(&cmd->t_state_lock);
@@ -2847,9 +2851,9 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	 * Determine if frontend context caller is requesting the stopping of
 	 * this command for frontend exceptions.
 	 */
-	if (cmd->transport_state & CMD_T_STOP &&
+	if (cmd->transport_state & (CMD_T_STOP | CMD_T_FABRIC_STOP) &&
 	    !cmd->se_tfo->write_pending_must_be_called) {
-		pr_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n",
+		pr_debug("%s:%d CMD_T_STOP|CMD_T_FABRIC_STOPfor ITT: 0x%08llx\n",
 			 __func__, __LINE__, cmd->tag);
 
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
@@ -2880,11 +2884,12 @@ static void transport_write_pending_qf(struct se_cmd *cmd)
 	bool stop;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	stop = (cmd->transport_state & (CMD_T_STOP | CMD_T_ABORTED));
+	stop = (cmd->transport_state &
+		(CMD_T_STOP | CMD_T_FABRIC_STOP | CMD_T_ABORTED));
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	if (stop) {
-		pr_debug("%s:%d CMD_T_STOP|CMD_T_ABORTED for ITT: 0x%08llx\n",
+		pr_debug("%s:%d CMD_T_STOP|CMD_T_FABRIC_STOP|CMD_T_ABORTED for ITT: 0x%08llx\n",
 			__func__, __LINE__, cmd->tag);
 		complete_all(&cmd->t_transport_stop_comp);
 		return;
-- 
2.31.1

