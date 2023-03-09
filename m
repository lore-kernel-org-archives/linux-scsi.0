Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EC5C6FD1C
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjCIWeT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjCIWeF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:34:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18FBF4010;
        Thu,  9 Mar 2023 14:33:49 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Lwt4U021591;
        Thu, 9 Mar 2023 22:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=bRemT9/AY9I+Ye4JFKI3Em6dmfbYBI59cUNld/i/EVE=;
 b=i+eSbak3FhVGGVD5HGwok71kuWYYyenys8zZ/y7hTaZzPWrw+nSiEU35B+ukR9hImb5K
 k6xLWfUtgj2uVzWqdiWj0k12X0zeM1vpqjjwQj5JX6+cH9yva/I3QKm4h1x3QYdsCEZz
 GZnojKuq+j1WRLr3iWP/0wyE9Pa9EyGZi7agBSZpmyGomTIKiNlF7T+Q5OG4jU78yKA/
 crPYZ8yytfLlvXuin8exZpN4Wn+4AjzgHpSxYp0qzgpbx2hyOKgTrRI6RQjtx7v2l2G4
 /r4dJBTbOze0pwhJ4YUtjLnDUbbB7ltRr/WT8mTgUcKfa49kaQEMjLIMn8kMTVCFeD5l gg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41813uxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329LmFde036440;
        Thu, 9 Mar 2023 22:33:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g47nhaj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncCJYyPcECXwuHr15m5/zrHsRpBJZiN/JVmZyU9yFeWYwJCg5oP8+voLl9yn43dINDXKzNqU8V62iPC4nEXkMxc54hDiANPeOs194HZw6KU+MmxFbcZd8YWB2Mc6t9Ezwdb4Y7i+q5DfKN9i7mNIgzcB/NN2qxIIB6I1zzpjQhAzbzZk1EQCU6dqsiz3KbNWeJYgoPItVgR2lKmyFUATcafWiSQf491pcIdA97Q1vLgsyztFOOkMXTUPJ8NSZE0y6RcRTLWoyBIbCuQOPpqDcV0q1mu6uC9Zo7H9dAP3/C5mRL3lnEUSFPxcSS+ik8UBMSuQLePFf1dJuXljP3Dn3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bRemT9/AY9I+Ye4JFKI3Em6dmfbYBI59cUNld/i/EVE=;
 b=d+82sT0Up+ivyXMxEf2rg/ExYdJo2r/5Y036neBsnEkGMr+sPr5/WekmrJoRpjM05UrtgU1E51E7uTMQQTDSEY5yV+XOXONJpwUppnfe4G6QwaqUm/mhyyO9xhbcEm/DlPOGvK9BHLD1q4+xXC6Ye1US57ckI5sy1yXgRyyvVOo3j+AWzIO8FxXFvbbwAicts6VTQm3qLv3gED4JSBol+U1B1B5XF+aXlVAVuYofbz76Zmx3UCOabj8cGh73k6sAuPwca5ZfgDSqyMrLgSfGvA+7xVFtSQPxEjBrkfkHDKVs6YaZ09UI2ZqHO4etjrSxg/b6xkuoNlfu/FpxhlCG+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRemT9/AY9I+Ye4JFKI3Em6dmfbYBI59cUNld/i/EVE=;
 b=EmQpnd4uaT1WOe7JYFgh3jqTe76GbdEg0AGx7G7GVbbQAUQTe53tU59D90odnpgP0uVmfsZofs7is2cxKmDr39GrwXwfhpVk2yWe8Qz6/EdPLCWmeFpQ7qYZ9Ht0dC4304yyGnhJTJWtDDgWBCoPwMMwMTDdw+arPzywAbFJ0Nw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/18] IB/isert: Fix use after free during conn cleanup
Date:   Thu,  9 Mar 2023 16:33:05 -0600
Message-Id: <20230309223312.94595-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:5:100::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: e94df0cf-3c40-4b21-4612-08db20ee4f1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DxTnQsngryZKUukEZFO/+0bYXhB6CALjy6n293b8dHf0mcORHwVVoLKAbInvZxzUw+ZahOCaATJEuGw5v9J7yUDUNyDR++kM+LVW50uQtMqzJkDBrAhplsSuCn1Vw5Qqj8+FCq18csITYoEbV8fKtskpiZ7czD3wJaai+ZhkXcMXqkswbaddlhxj3DUeff/ETMhtT2UHba5cxl06AZs1pgdsS8RhyfdggLrv4GSKj7kVBSP4knoyNynBLjkPYPMvbhlw0MVW4L1yJXOAlqkngZMvec+AXxqm+9o3G4POW4QmPIxucMELtpEVj+Yprkd+vyR47gGQDCObC2GKRKVRZC8jvETE4hNsx7PCm7d4duR1Hmzh96xPhpHIGbh6Xsr6EqEn5jPymqj38ZKvLSL8Xwc9BUThEtydCtUj10rReQMjEpadTDm4qGnrYSgymuxI6PDDhbKSpkC25KmHD0qiukHB3tXvgv4uaEuvhkGqlF2q9LD6E72qY/bJbc+Vqr4lTyHDKeOhj7IYP42iXsJgjvjjSa6YXWueMbud0zfQ2f+Z6i5O/M96tE7mjWbmhi4tZgwn1W9kH835KmSRnJt7ifJTQVMWGf8qLoDRu/KeDYbkZy2a3EbPwty0gvwWTFV8gQK3aHa/KTVcPRAgZWSxiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?srpHxT6w906atXhoyyUcl0VJa7H7Yh9lBuhmKFF/6MY4WahiylbkuBqMrFz2?=
 =?us-ascii?Q?Gdr24f5JYuJn2+dNVYaRTFqjjq5Jt1kghYIRLL+dVa9Gx/q0AbAAq+W8cZpe?=
 =?us-ascii?Q?PIaKIVQI+pUfi8Ldm6sMUEGVD8sdtOQDJ+NpkT6m+40dqP4SbZIIr5ZJccF0?=
 =?us-ascii?Q?tADjWoYceh/SVy4qaCjprGSVg9yGbbHd4AJCP6/rjbyLchZs+V2179ZcialW?=
 =?us-ascii?Q?tE3v3+M57G+gudmyGVSxRMXgJLK/UJyNyJ5DbZ+hPR0/qNvMkPDecfPosn5g?=
 =?us-ascii?Q?0DZmEadPm3CWpnp5sm7y3jiLKLRj863uGnHYD5syes66BTJ/IOKYVtifQXc2?=
 =?us-ascii?Q?S8zqjzurNj73B+z77QMNBE4Tmy3/LLfH9dysSQXU4/OnSmVXfJ8TIxOyu2NY?=
 =?us-ascii?Q?YNT/s5Tgxgyp7d9ZD3rmi7/KkYJQLt6xsyYVD9nJV2wKVS1aLaEPryYLBg8r?=
 =?us-ascii?Q?yaJTq1ukk4ZrO+aVqOREK7uKUHe+80s1i6vGR3AI53C7bL6Lk10rRq+Y/n7i?=
 =?us-ascii?Q?9ohCac4OkgV+Rcp5T74M4pQF9EsAMCB65Nq02lMR8oYUHfSpojQqM1Advo0l?=
 =?us-ascii?Q?jj5T/IziB1NSVrv+VylCoPhMRuv0qQ/ysG1D4bWGapUBs+1L4VgrNiUAws/E?=
 =?us-ascii?Q?QKOOCwfRs+ODq7gmM46lYzsxMcWijJ4hsBUy6YrcBYDaBKdGrphZbb61gHWJ?=
 =?us-ascii?Q?CC8Sn4LXaf8bvwwjjfTGAdpSpv2n4tiGNjR+UaMo9uZ6RrImdFhkl0a7NAw6?=
 =?us-ascii?Q?KKzqtK0Ke7O0fipCrHGnkPCLrZIpB4MdTwtTrtDV9umNVGeiXqEuxjEr8++n?=
 =?us-ascii?Q?Z5tGFA7daOskbobegUYt07EqmDJ8bHA3ZiM2ZoM55t/uGDdaODi6vYJz8Xrh?=
 =?us-ascii?Q?JeCSne5iVwl75NdvQiCMUa2GK4bIN2z7rJqUcOrlSruazbA/u8nZWKzvaHG/?=
 =?us-ascii?Q?Aj28hdahpQVicI6iy/DA82O82U8dPvilaSoSEvCZdmRtDuQ2xOLphjvtQAZQ?=
 =?us-ascii?Q?U1L617plctGW3ZxTlgK/WL0XqprzxkkbLmxk/wpOVuTXfaI42tEmB1OciOxK?=
 =?us-ascii?Q?14uSw2rYdIFlG71sDvIdodm+HToPaqF39ionnA1v0SjB+1QBa3dOEQq2yC/2?=
 =?us-ascii?Q?3rXo8QNnRO5yxtRFwKHy3Xj4/UXIc10H80FhJrhGpU29oSuj9PeqDLkA6yy1?=
 =?us-ascii?Q?HHuS4DCP/b4nyeFkt3iCVM5/L3D5UWzybIvnRt+i/j2XNtwV1Z+QUsa6Wf6v?=
 =?us-ascii?Q?I6fN8tpYspBu1z62IK84v9HHwK1zPOXS2BH4KrjVBZXY3e6VPFgCqKWOwzwO?=
 =?us-ascii?Q?Xe1GcSsOQJ/wVm6cCOTKcs6ZKxt5yO/1Kh7+1auCSYrt5Ng49/gl3NYuWDvF?=
 =?us-ascii?Q?JC0nDiQqrJsbB5FKb5Miok9qJ1Vhufzr2ee0XTnoe5cbXesIVPqH/jfBMnLY?=
 =?us-ascii?Q?1y8eD5SlxdfJWP/lElUnfsO9fEOzJFzHkjxQAlzX4IoPegXB9hjkyH6zyAO+?=
 =?us-ascii?Q?u2y+JrNDahjESe3dx/rx5TjptIUtjDLukQ4TpN/BoKBbIjsS1SdDVfELtXWM?=
 =?us-ascii?Q?iHwRB/Bk3dBQOsgccjf3EP8dGpXHHN7LZCBLgRVtEbHfjYOnGQCeMRak1xOS?=
 =?us-ascii?Q?Ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: TVL9h/KrXYOOOjGsE14qm1eYxfdHPW2kDgsE9YuDwTES8N8ZU4hX+kJASWFWjVFULael6jCno3lCQLMoqjm0AQmYgbHI1ENuah3qezmS7iM08/q+CD5ik+U6pxz1fmPyt680TEQkNS0lcMtfnnkQpzlkTWA9HPdwOE9CNg/y7MMpRqLU0Tc3d7JCXV7jLQ23j+bbbPZymuo0xCwN5pp1GXi48zT4e/1g4W/sURXXJmf6IBMCwRxrbfUCpjKaV/zRPSybk0GJoXTlYlR4W17XRquHjAtHkOguTPP075/3jSVCR6k2KbtVeShfMz/2L3l/za/LHn8QU2J7OSKDwoiV+r4Yh3yhqsg6mPHTuD/WGCJZgb1dLm33HFpuJ81fhPXT6Jh8HIvOCxHL1wA/IEKzU8sJvJmwH9RzV6KcGjmOrehWntHVsAWCBkZXrg+ne1OfDpQ8pSy/2CVlkbotic58Gj5BdVuPWGAwDjbZkFjduHKkiuY/YlXHOUToIL4nkmf2tixabvrH9S1IXLw+gtBTPhyG5KvwB5GMwFVpJ5y4xM9rycetK2zweYaYslEodGUmp+uS3uBAf+LDqITdIIwXT4aEZycjcM9cK1qs99z7WQEJIcaRAgpScSCnntXzqqEBDyg5T66ngI6fEGXPA2cd2fGhi6KYGuDKaIzCWnEYNRKtkxOlV2gPU/C/WXamp+BzELNk9SXCPC9LYMDuUR6n/e6hzRZq9VMzrIpHVfcDz7bpFK7kl3aXfDKHJJb8QSUHFHhrrarOnBqQC1wHUystBv9erIfAT9JVB6F+KgcEdsTSRYSYz0/AwzRzIzYAdPnGd/A4ECy6R8WxvZ6aH0AxZl4y6Usy5lgZfR0ckdwoSE5bZVHRluDNMKO9gb1XqnIp
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e94df0cf-3c40-4b21-4612-08db20ee4f1b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:30.5956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RqkMEDz+hH1NnDx5yq2l1csDR80GxGal55pufdNO96np4QCtZaiO8mEJbZauk//kPq/4d4XORXP1HDUJ1e1WQRYtf+Zue8VXu//O+rIFxHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-ORIG-GUID: F267OsLxrQv6kv_WYcsGDFAClA2NKu8j
X-Proofpoint-GUID: F267OsLxrQv6kv_WYcsGDFAClA2NKu8j
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We can end up freeing a command too early during conn cleanup by doing:

1. Send iserts N 1MB writes.
2. Pull cable or down the port isert is using.
3. isert_wait_conn's call to isert_put_unsol_pending_cmds races
with a running isert_send_done -> isert_completion_put -> isert_put_cmd
where isert_put_unsol_pending_cmds sees the cmd on the conn_cmd_list
and it does a isert_put_cmd which will free the cmd. Then isert_send_done
is run and will access the freed command while doing it's normal command
completion:
isert_completion_put -> isert_put_cmd -> transport_generic_free_cmd

This patch has us increment write_data_done, so
isert_put_unsol_pending_cmds can correctly detect commands which will we
will not be calling isert_send_done for.

Fixes: 38a2d0d429f1 ("IB/isert: convert to the generic RDMA READ/WRITE API")
[code written and suggested by]
Suggested-by: Sagi Grimberg <sagi@grimberg.me>

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 516fa37494e1..a44da60352f6 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1636,7 +1636,7 @@ isert_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 	if (isert_prot_cmd(isert_conn, se_cmd))
 		ret = isert_check_pi_status(se_cmd, isert_cmd->rw.reg->mr);
 	isert_rdma_rw_ctx_destroy(isert_cmd, isert_conn);
-	cmd->write_data_done = 0;
+	cmd->write_data_done = se_cmd->data_length; /* done fetching data */
 
 	isert_dbg("Cmd: %p RDMA_READ comp calling execute_cmd\n", isert_cmd);
 	spin_lock_bh(&cmd->istate_lock);
-- 
2.31.1

