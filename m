Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885F2C46467
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 03:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbjALDJw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 22:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236007AbjALDJi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 22:09:38 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C4F4883B;
        Wed, 11 Jan 2023 19:09:04 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C2GNDg014082;
        Thu, 12 Jan 2023 03:08:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=f8bmtVqW3GrJMaLwGXK6QhY8whT1Gy+3lmPvpwY3Uqs=;
 b=quuGv3x+akpAYEpJTfUU3GiECH4IL80Oa759FhGT9cZtj/4Da7MYU+sBfUgbUgtfUquy
 XZgnnaN0oTUPeKPNFQfp87x75kp3aNwbeRr2bHTkXu1s4nKivpJHnqI0/NQ5Uftj4ivS
 uELOzUSLgT4/7vomjOIX7i5PC3thVmF5D2Sllh2VhlpuX1jGhyBUj8Cwhgag2mfOECHW
 u0d9dSL3qp0104qlzCq0uaahtJ9KcLb/8Ye8g2L5e3XcBAebZMKZT/DJaNLsvNz29ncd
 Rbj5UHzCtlYaXqSrGuNFHw2HPxxXeKhHUrMF/rAgQwFvtm+zAzCU+VTsFgEX6sXo0c+9 Tg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0schdjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:57 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C0ZZJX034175;
        Thu, 12 Jan 2023 03:08:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4fuxsg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 03:08:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CeioaIO0fBGoKtJtsoCwd0BRhbLsT2VNujoDHFUygADZaorHvyvkCo0vA4P904RR7ep3WXAYTVL/AW7DDJDNLyZCAMUgPz8snWOpG5H7/kPIv0S0OkjJnPkvV8AaGV+y658yq1t7w2jnt3mUzjo2kr1ypUgQmukDB0sbg1Fcd6tOaJgJk3Q4NnHacettYs1AA26ryYTVfLLMcF2RaF6GxaK8bIqyI6woOuKvNHVQF7orrxlzZSx9FhzyAvfL9L1GvUApk/vUdfgLDMzHTVWlpF4QQrA9Qtgd1pMyJe0nCdJ+l+owwdTN+5xUI+HgAMwGEPpJJ0kuVIvoVVZozKvfnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8bmtVqW3GrJMaLwGXK6QhY8whT1Gy+3lmPvpwY3Uqs=;
 b=ZBC1W5lxgRNsCp3hKyH7BQhGsyWcHFfFtUVLnOcYL7ZK6D98Stt/O0SPCO3NVVxTk+CUvzIi4G49szTaMxi5BFM2k1iMEfO2YrnM/Sww9pVrl4vdRXqJViX0MHufFYT/MvBcbWfrp0G9DZW2ZxP7ud7PX2dWqB6BmGyToY6I4/hMeRGraGIu9uqsuljSR8l55DTuiFNrLMExWh0ZlGBCb+fNTfBvz/j30cL9NNMMEJm02r1U3iU3vdUhbWOkYKWukTNE5HwYgJbwSv+pL68EwGN8/Eas/U4AvPaviYGyYCJSMoWXKme4e6WAGPD+hRiGs9cGBMBg4ttmcINk5sbTkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f8bmtVqW3GrJMaLwGXK6QhY8whT1Gy+3lmPvpwY3Uqs=;
 b=wEOjGIou63qVVx5ssM5B3OenKz3LAJSl/fHP8tAprtPvAfpEVkFL7G4Y2A8za9u8iTXBmxHigXTwo1Ic9FP81J501PSHhhxm67qxLAfkmfb5aQiPVsGQxAoUxcVsOD5jiFlA6OlPFE2T2EJ/U13TVeb7Ze3/FBVbYCN2hEdw2nA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN7PR10MB6595.namprd10.prod.outlook.com (2603:10b6:806:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 03:08:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Thu, 12 Jan 2023
 03:08:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 12/13] scsi: target: iscsit: Cleanup isert commands at conn closure
Date:   Wed, 11 Jan 2023 21:08:31 -0600
Message-Id: <20230112030832.110143-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112030832.110143-1-michael.christie@oracle.com>
References: <20230112030832.110143-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN7PR10MB6595:EE_
X-MS-Office365-Filtering-Correlation-Id: c07d5d7e-eb10-4014-38ed-08daf44a56b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BwESFqZNB5W3vX6XhuDZi4uJZEqG+PYNWe2x8Ls5GwnKnuqYk1tv+WP+HYLkgbif9ZSyw08rCcbwo/gyykNq2cyKO3ozSPsv/SF3U+9xkPuc9Xk1GKaPm89AUxizXWicrgB0sYNt7/cffKhYRwxhQX3wI1lLOnk92rQyGBd4Zel7Dp7lfQooY4AqjYKZcIOXfNfadB6KFVvPUjiGV9oJ8WhWr7pBpUITETAcPtkv++x69Ocm/JBTmKW3r1aYkPkXmjPQH02UFQXiQr/YZw0pmV4Fw8CA7FTCTNfjfOpkaOtS54R5014uU3CMGU+/0XWJYoQw7KimmHzjAK9EB6PY0z4WzcWcI4l2b5skg6xRnlWKCkrbI98QEQibsEpS/a5aOj0TwlgBko8+lBnQ7unKFtvflTk8h2RbaJtaNlolSat6wC6HTR5he44f7KNHALNMXfUyjoBTyYmVHm2ShRO36qBIyDqiObUYuYhw/oeSMa0veVhWZfRrZe0vdXamYQ3gEuU5yAfh6Y/ZwS+Aq6JM/Ny6i9P7ZivGDUWAQ9hhO/7udXTBzdNsKPstzo13/DlZOCnguaaU/mWDDSRdMNtF2vUZ1vnWtEdTS+ny3gVF7llFMrVx0XUC1ZQMNVvFDJ9lQrJY9XUv891o21bLDPwUYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(366004)(376002)(451199015)(83380400001)(38100700002)(86362001)(36756003)(2616005)(1076003)(6486002)(316002)(478600001)(107886003)(6506007)(6666004)(26005)(186003)(5660300002)(8936002)(6512007)(2906002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N9/NPL9f8QTCx2wDnswkzv8nGsykSLZna8RBgOjotwwZdVI2yl8Wj9xfqRat?=
 =?us-ascii?Q?hs0PY6anYUawdA+O0imO3N+1jmWOcPCCV0GyvPjnYy+Es0qqrPY6pzmqot3u?=
 =?us-ascii?Q?tZ4VRBX5Nw6J+GVOqdrLtJFlHleJnJYGDBdv8V8Olg5yIgxXcQH44WBAbNUL?=
 =?us-ascii?Q?kvW1oLA7CF5YiiOzBG+dIKilxUXhJKbBG7Div42FMZpK7d4bTK3CEeaKt1Zj?=
 =?us-ascii?Q?IHAz6GgyOe/0tr/nf0cuXQexmQb1M3fcb4kdk+I+VkRR0g3M+NG5UDz4Jnc5?=
 =?us-ascii?Q?DtIKK20V0qcWF6CxjxSfpW1eQS0XKkA8LaT7nstEErT8foERi8LwP1bFw8v4?=
 =?us-ascii?Q?6ELkOaXrEzLfMs9Roav75K1vpDTEK3K3fEYr4HHFj3JAQi4I3x6pXAqq7wrO?=
 =?us-ascii?Q?qwhpOOyTDi6skZzKZANvYtq44ja41bpHbMdCfBH/wDnK8CsbmDErjhWYV2pz?=
 =?us-ascii?Q?BvLEc4jNDg7SrUzTpoGpkxMn7wyhXBP62fGp5+JRzqxwW5VxIhaKjknwQL/2?=
 =?us-ascii?Q?eVluznVtkHeatvfO+NJbM6pdm8kMxDu1054hHKG/mCob9Rjy4exmltFHPUrp?=
 =?us-ascii?Q?Ec6vj9xTf7ukuaJSDuSpWKlwpjvL7ZtBwwkNDloNUyW+kv1Q74SZVD7osFlY?=
 =?us-ascii?Q?BpjDVnSOPmtKSPMDsd4Ipch4GBeFUQ1QC0HGK6mZQaDC+FM4Lt87EPZlJy7l?=
 =?us-ascii?Q?XlgF/STDYNvWnNf1UxXdFGDsTQYhBfxD5CfW6sfCP7dNVONW5IYX7sNNu+qA?=
 =?us-ascii?Q?Y8UaH4RTEllFCKmXvWAG1qxZlp+noZCcETHAvz2j946byvLdeX69ozNYxrSh?=
 =?us-ascii?Q?HYwnj0as01PIN2uu9sQzMg9mN/w6qN61UeZuhTEPxX4qxju8TIcgE6aZcBwT?=
 =?us-ascii?Q?mGcVOD6NtR6OGvV9P4Rrb7TbPAyjsSY10s7fpGe9tFro4P1EzLtsLVW6aAUu?=
 =?us-ascii?Q?U/usPZE0TyKyK6tsOAef1iYaYztO5MWucAap6z6g7+TuStLr+hsXbBctfEOn?=
 =?us-ascii?Q?IX7auqxJr+q47W4An2KzAOgFThimlL5s0YO/P4hw66OHOd2KeSzxHFU8uNVx?=
 =?us-ascii?Q?6UR0bNtNaq8sfjW3s5wUsUNEgNQDo3EORcCjZHFOZoS/Xf9aDZvu2MSXhIWE?=
 =?us-ascii?Q?t+V9OQK4sZTBGulOsmGHj5UlX69T0w70ACt7H0qtrh09b6peRMC0lhHVh7m0?=
 =?us-ascii?Q?W0E07gKjufqKO92QAPszgxIs7oaDu09emQl6N+sT0Vj+gZvCdagEkZnFVmAZ?=
 =?us-ascii?Q?GzsvQh+CEdYNtaCC+uONGHVmy4gkZSyJgJ7TBRZlI72GynWgdYm+vid2KV6r?=
 =?us-ascii?Q?6jHrXZFoI32PDQ6qtT6pN1Z9Ojn9mUPX2agdEKyVpYhLpNU6v7oEq4yOmhtI?=
 =?us-ascii?Q?Pz/jvgCgXqC/nJxeCPaJKzkGj043mYmXVQhwzeKDMnwmZQXllfbDiYvo8TPx?=
 =?us-ascii?Q?AWibyfGw95hyDsSMfs5p3ePAZ5VC4/VdAjF3wMeN45dOwHpV0OFCoEaTnpuj?=
 =?us-ascii?Q?UtWsOrwuiFSyj5BK7IRVovu57CblchVJrEAyJpudFLHWgFTsdV5a9PPMgbmS?=
 =?us-ascii?Q?kR0Y+HqhUrHCpPjlmU5UIlEYUOqGq54fNJcJ+hL2KMqcKPGAXtKqEAAX4JgX?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: F968XudtofMHqld7ZRt0MrJrlX1yQdW3UUvUwCnlYL0uwrzEBMW9W0+cLxMUuTX+tGgtHuNA5eFGr1h/ZGPCdlq1S/QXjkoaS+0lL0zdvWF9de8dEekYnpyn8cJBVbHzXx1HcVZNHGSO6ruM+p521mEIjmoNd6cODJgUA94o6U+/jwOfdBw8YIQe8/j4z9C+wjQWtDKREDx7+oN9KBIdbi64hjRLkAbsyDF7jw6Sm42WpEqZ1ZZffNPcoE1d90Q3MBPUMEjy9SZ/Bp3YXrwgrCpoEQSrgUeNbjClEPe0bghEJnE+bXlGKHfBcenbZ3ny2RUp6wuw0kDaQJ+sEusQHl0ivdqlrehrmoRsw5i4girzVWFn1urCjfec+rVD8RvE6mNwNuOEN7REgDE7xe2dv4Z5jN5y/aJpQejRGjlysWBi8BjMNcR93KMYoF72Svf1eE8nxRmzQ/VZ5wCA7q7Civ21/0aEs4dSrp0ZDQPQXbkqAe78I3k3Z1LHNtvuNuQdhHboFiOlUCVS3/2/yil68HULTBS5LAsy7DfcfaABqOYLu+m+QUUNSr/FXcTAMzXZuEbbDlPLPpY/Ul+VznxuyjYUSCtqhZ0oUQBYRL7mxtJ17E/w4uzeDqM7CKI+fKPgQuUYKj9Hh7z/MMve0YA9u1YagN+1DpG3eYFavhS1eQ7w0WEAJjn9JZjlmFdoByH3H0I9lU7Nerghzl7irGF0BU0J7xQRTogIiPBfA+cvFUHPjRBAn/kgsM5ifLk4sz/+wxuo0R/aXrJ/zWJIcAYR+e6JBQC18bQL4hzq21nxSvM0IkQUObmwsxbiTER+PcVNIa8GfwA5+Gc3PJjJtl7/iO9Q6oYRoXhS+jhURVOy6i7/Bh7ecBBwHoZS7vub0juP
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07d5d7e-eb10-4014-38ed-08daf44a56b5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 03:08:54.7539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+IGCiKkp5N3G4fBNwvHnNHlV7E5wz7+F5Trb7IYUkDjASxh3myvls3d3q8NXt9ffgg5ivWzdZ0wOX0zd43DtA9DnyBlfnPu4IWrEFhewmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6595
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_10,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120019
X-Proofpoint-GUID: qeHfQc9__YKKe702k5tsbqFbrdhcTyKa
X-Proofpoint-ORIG-GUID: qeHfQc9__YKKe702k5tsbqFbrdhcTyKa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, isert does target_wait_for_cmds before iscsit calls
iscsit_release_commands_from_conn because we can race where LIO core
calls into isert when it wants to cleanup the connection. The wait
prevents isert from freeing the connection while trying to post responses
but it can result in a hang during connection closure if there are se_cmds
on the iscsit response queue, because when isert calls
target_wait_for_cmds the tx thread is stopped or we are running the wait
from it.

For example this is hit when a command times out on the initiator,  the
initiator sends an ABORT, then the connection is closed. When the command
completes it will be placed on the response queue if TAS is set, and the
ABORT response will be placed on the response queue. So at the very
least we will hang waiting on the last put on the ABORT's se_cmd which
will never happen.

This patch adds support to iscsit so it can now handle isert and iscsit
running commands during connection closure so we can have a common place
for the code.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c      | 33 ++++++++++++++++++------
 drivers/target/iscsi/iscsi_target_util.c |  8 +++++-
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2a011afa6dff..a57527beb340 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4231,6 +4231,15 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 				 */
 				list_move_tail(&cmd->i_conn_node,
 					       &conn->conn_cmd_list);
+			} else if (conn->sess->sess_ops->RDMAExtensions &&
+				   (se_cmd->transport_state & CMD_T_COMPLETE) &&
+				   !iscsit_cmd_failed(cmd)) {
+				/*
+				 * isert is still handling these cmds so wait in
+				 * target_wait_for_cmds.
+				 */
+				list_move_tail(&cmd->i_conn_node,
+					       &conn->conn_cmd_list);
 			} else {
 				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
 			}
@@ -4243,19 +4252,27 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 		list_del_init(&cmd->i_conn_node);
 
 		iscsit_increment_maxcmdsn(cmd, sess);
+		/*
+		 * Free cmds that:
+		 * 1. we have not got acks for.
+		 * 2. are (or will be when the backend completes them) stuck
+		 * on the response/immediate queue (failed cmds, TMRs, iscsi
+		 * reqs).
+		 * 3. completed ok on the backend, but hit the CMD_T_FABRIC_STOP
+		 * or CMD_T_STOP checks.
+		 */
 		iscsit_free_cmd(cmd, true);
-
 	}
 
 	/*
-	 * Wait on commands that were cleaned up via the aborted_task path.
-	 * LLDs that implement iscsit_wait_conn will already have waited for
-	 * commands.
+	 * We need to wait:
+	 * 1. for commands that are being cleaned up via the aborted_task path.
+	 * 2. for isert we need to wait for iscsit_queue_status calls
+	 * that posted a response after the ib_drain_qp call returned but
+	 * have not yet called isert_send_done.
 	 */
-	if (!conn->conn_transport->iscsit_wait_conn) {
-		target_stop_cmd_counter(conn->cmd_cnt);
-		target_wait_for_cmds(conn->cmd_cnt);
-	}
+	target_stop_cmd_counter(conn->cmd_cnt);
+	target_wait_for_cmds(conn->cmd_cnt);
 }
 
 static void iscsit_stop_timers_for_cmds(
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 26dc8ed3045b..b0d7d6c73a1c 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -753,7 +753,13 @@ void iscsit_free_cmd(struct iscsit_cmd *cmd, bool shutdown)
 	if (se_cmd) {
 		rc = transport_generic_free_cmd(se_cmd, shutdown);
 		if (!rc && shutdown && se_cmd->se_sess) {
-			__iscsit_free_cmd(cmd, shutdown);
+			struct iscsit_conn *conn = cmd->conn;
+			/*
+			 * The command wasn't aborted via ABORT_TASK but didn't
+			 * reach the driver so allow it to cleanup resources
+			 * now.
+			 */
+			conn->conn_transport->iscsit_aborted_task(conn, cmd);
 			target_put_sess_cmd(se_cmd);
 		}
 	} else {
-- 
2.31.1

