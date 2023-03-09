Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 506F4C64EC4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjCIWdu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjCIWdn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:33:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BB2DF726;
        Thu,  9 Mar 2023 14:33:42 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LwxSw005714;
        Thu, 9 Mar 2023 22:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=aFXKQNdrId13GoG7UREjkr3Tj6ozNjhBWIoR+bux/NE=;
 b=MWUB2t7x6U39tP1mCxO3LnDVkqCPLuvh8CfzPOOWuy0Lh673yzUvstC5z2d2b1rYICfB
 MWuF1izhbJx+F3tkC3jH4vy099GHXBxyA8/VBTS92UkZkYMKvsqiRHN2AtCen5oJ8sgw
 yE+NS67hPrN/tqlIiPhvv2qF4YTbO/Juz/ehTXn7yfbY5jjY9QSA6V+7yBAtxvSQYtOg
 nDpOT7KJKBgWySXuKCuGhhWPiOE/HiFWrV2EcZjZw/JZRp0/q5ULDVVDJocUCZ8DY8+t
 VX2Xx9rmBDRBIRcSTm3e9+8H/mNOS73j6hlBWk2qzc9mB8W0B0N0fORIbFtj9jnaxl/+ fg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41623wu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329LmFdc036440;
        Thu, 9 Mar 2023 22:33:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g47nhaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0nG42FfOux+vDJB2bYZYNgbe8VH0griq8ehIAarAbh+oU5paRsX7kRlVtHgIeFgClQgKh54OHSxhapjWo5JTS7OxDS5DhQkMjqCNf5y/YYJMDFnr4gpE1HlJlArkM+sQmVQvczn83BWYpe1lStrLWU+mdljDPOBkLLULNkjoA6EOVFGgSdDf1J9bK5Z/CfigmV99hVwArHrLLNjv1gKCeZ4CeCxq2v6UhIp70SEjgdGl9jVwPoE03gUgNLDMi71YZ2y3NTCrA8kbGj1wwGnh/klEIBPSkiGtqAxHmtbG3xa/fBPgWDMIbJk0Jz8WuVu3PFNaLRVLpZfbXN+URGaig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aFXKQNdrId13GoG7UREjkr3Tj6ozNjhBWIoR+bux/NE=;
 b=NK2+QXzok8BBA1b1Ze1/G545p+w/Wo/WuANpjSgz+pk0JxwjTFTqe2nWzeHDNhLOfcmLdzo+2WL1itAEYF1cvnLMuGazzGm9jv4Z5GW+rxPEIzLi/AFS+7t6qGXEeTe+mgIl41Nkaz56/S1TspNEbJhqMeljUgj7Jhbve2vOfytubZkr92Pa+dfBYCtYCFgeuvND9BRdonD3dw1AJJ/cq+sv73iDQexktZHOE9NXbHsbaTn2OtoszBcpAONF0KKjWDeIX82KIH74lrhWI75Ekz4GNWXviOiOL1G+0zj1mwWO6Ky4CfpTluHYMkXKfq8m7R8Z9KwoPqCwew2OPRkiwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aFXKQNdrId13GoG7UREjkr3Tj6ozNjhBWIoR+bux/NE=;
 b=scBm1uYfa3cjwaYv2zOOaaOpvU9S1nWoDJ2g/jk7+aoH8ffrg41NMdbjmguUoLTMJiFQfDu3MKM0mD+KYL5iykXeR+ZdwWKAmFF9GsqLuHkidmvzwVG5BK/9Jc9VurpGasiR09H9qER7lnQWuPfaIGEL5XUgKagrdKUjbLij9Jw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6479.namprd10.prod.outlook.com (2603:10b6:510:22d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 22:33:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 10/18] IB/isert: Fix hang in target_wait_for_cmds
Date:   Thu,  9 Mar 2023 16:33:04 -0600
Message-Id: <20230309223312.94595-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:5:100::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 700b11b0-ac75-455a-1712-08db20ee4e66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Flpr89ftPjsfEWC7HeyULcWlnm9T1EJjHgUp0T90qBcaFTMw7GcY5+/AltNtNQyydhQIJbM/Tu9iwjrmtBwzRcCzx9ozzyRSBBdJ6Cuw1luuEuLIABARKEwn36uUkC2Syj547ypDfyyabMq8ok06RQvYCu6zRcv2InNzpXQWkiD8q1NjoY120c3uV8GY0ogo9/sy9P/5DKM32EywIZMNVkngGeTmaPcEfd96bamqM1ljimqzvKap5C99xbCsC6ggAx17GgcTKYlBh9GsCuOjLnT7NlalA67SCbIw1Gj57YcBx6HDM1b9OHQ8DOyk/3Mnu1ci1qV7ho11khxixeuljkzzq8ppwHu3R06KFumrB385ekfhSKpWcOSjpkO4zSI0RJ9vC2iQM9VVnqTCBRLaiH21oip2AFcFxMunTFS953yOjPgurJY9nwK5RwCPEC5MeXrorpCQYZy+Ty5zv7CVx3LhUANgAyBVVp4dLl03oVdr2RTvZrSxRi8Bmpq0AfFgm51JPiX2GYYIp5W2RTV7kOVTmDVreLts3Dyp9J9nuhKVTxded63MLFDbIaJaiMLxyRUO3o8L6mEvb9zTIBf6pySGQ0jMv0TRZV2RECwhqLN3iJGtUj4rb4VWKRiwFZy94opLXSDsD1zNljPFERf6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199018)(2906002)(5660300002)(36756003)(66476007)(26005)(8936002)(4326008)(66556008)(41300700001)(1076003)(8676002)(316002)(86362001)(478600001)(6486002)(66946007)(6666004)(6512007)(107886003)(6506007)(38100700002)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U45La/9jbnRH+cAJTqHhbJeumXUDcGe89G6X0SA56/Ufc3XWoiact+OYXnV7?=
 =?us-ascii?Q?/fiawdX+yLr93pY088dOdexJFHlmlgSfWiw8QuPVnK8fMrntjAqC+RH4Byae?=
 =?us-ascii?Q?90JdbRAaopQFu8eLa8wA6h+z3Ix/DtsDYJeXu6UU2XknUKWgrrSSxRnlmfna?=
 =?us-ascii?Q?P0OUhPzXoYEmxqkrhgGfG6skSQVKZX5iYOD2G3bWgyMNieLabQ5YYFmYoUIr?=
 =?us-ascii?Q?ncIu2aZyBMKDX5pqYDWcS5/C7LtJDwxVEm8lJVty+Lm61vC/QhqjZQmWlujQ?=
 =?us-ascii?Q?VF4V+SO9F5+4hMZvZGiBxN3aY223yTPTVuhz+v2e3bdlQJKYGKvXVUMqso9Y?=
 =?us-ascii?Q?Y3I6bTvpm+1LWpn+gslv5Aidh2fin5m94tavxO+PxrRrsRCw7AbhSVowy4NV?=
 =?us-ascii?Q?lli6O7OOuZiPP4rzTdeBTn963rAC8iVwyv6N6qpH2g90Z9wTlaE/Ul1/0E3Z?=
 =?us-ascii?Q?wZxxyfYGiMXYtTiSG9NFg+S7OwsL9ry2e1WSbarUVbV1ZwcSfCwojeZ33z9r?=
 =?us-ascii?Q?kUw6l388W61AcMGGt5BgDJURuR3z0+dI32oIdrMwRcnwVswYAaKnSM6bcHlw?=
 =?us-ascii?Q?/SaIR9w6olq4dNOESpZI5Nh0b8AHs5JlazB1Eqw2bxqvmROP+nTu6GAatJhu?=
 =?us-ascii?Q?sHUFVe0fDXhCC9+If5XnyEftVkMhE5EQM3f4wu2Osmq+ASfU2H1mbSWN2dVJ?=
 =?us-ascii?Q?9JuRpzW1Q6DV2asGQExrj7Hcn4irL/pdjzfAi5tVpWtlMXb58erYa/O5B0MR?=
 =?us-ascii?Q?rSpD4/xAkeXBmRCEiJRBxGnZXHLO9MCWlGXIGcN9QitIln+08AlA9OpqTpCI?=
 =?us-ascii?Q?iMXfyasHI2LqSMH+TmSPI48izpUz4cqwwL3Rtir757Di6YUD3ty62t39/oTh?=
 =?us-ascii?Q?k4pjsEMpJ/56aE7miCTbbq275RbUhOiphNzORAutzhM1nA94PFI/c/fVALCa?=
 =?us-ascii?Q?FfScTyU3aGDS2FcDomd47qzB/ZhDagT2imBrtkNWvwXBg5YM57gZNnc1XZsx?=
 =?us-ascii?Q?bHqJiOs3Z+HCmOp/IFm5vOmDA/jTN3kiPqv4oWiizczf44oJ/x4tu+NRhWBS?=
 =?us-ascii?Q?My34dvCUWwRTfZGAex1J4CJ3TZSEIO1sij5GYctrsyxxVjNDXacKoOe0/ghR?=
 =?us-ascii?Q?sUd1tOaINxp4Q9hWMx532qsHPtHgfXo9sxLNk6hwL27JQXTWMvzVdIv5f9eE?=
 =?us-ascii?Q?lf4wa29iW+K0T8wPu06Si2uWzhNb8ndHl8Gyxw6LkTtkz35lLLHyh/u6ylSC?=
 =?us-ascii?Q?STehhe32d0Gkzw+Z5EKxLQ7hXlQrBjBanAandvwIoAd0tkPVTMHlTDhc3uOA?=
 =?us-ascii?Q?PKtqX2zedVLzTHmM0Luk3vUcBAnbBx+4bCSwuxzUvI6azJYb+GT6z0785Vj0?=
 =?us-ascii?Q?eQNw22N/6V8yyrl/ZOkZ+jH69PDuBD0F251zuayf2Sk+ASSzEi9wsU2TV0it?=
 =?us-ascii?Q?PoGaJNiRnvjbA9CKdz74weCUNyX+8w0iPf45dFM39StNBh7Mnoj+OS6WTZTv?=
 =?us-ascii?Q?7dAgFC11/U/2k69rvnPFNNFKCzjdPVhdAtMvriNJ38MxjAgz6cV0gz56b243?=
 =?us-ascii?Q?vi9MGLa8n8Fm6f7pD0l48H/9KWRpwukoFW8BKTg1+IHTpb7skA3qJ2QQGCU7?=
 =?us-ascii?Q?hg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wRjA6ErtvaPiYw/P9gx4j67Swagc00dQgD27HYfHWXC3rehFQVDP6Vv7GTEF7v6s7zZIH8LTTLl3OW02sodDh2it0+cOXfFJyDaYvuh1tRaGosAKSCN7ixc/MWAc1xgCd1pKYMFTJ1NvJAHKkuvOqFxJTIpXJoAtP0dvqnjnO6iTGNJiPAUCNxo1so00nQWQOHXOkoZ4ANx65ufrv3efkryAhbUiUgVApcVzC5FAnFjxjlwcGUg1PCUDAVnzI4TVMceHJWO3vuGuViQ5yrlodvcNmZgbYHWseaD+kQRY97y5YNYlLJ7wUF+bcOCjBuU5WhYHnOzOmJcrjZgASfb1Ns6lY4cwUxNQUc24NHKNf7AcHVw68B20RQphIc0loLn1+k5mNZRB4NWeQu+jhG+6wGhqiHoqsbEHksxOWDKXOPU6wBCS5/XwgoXyUkxi7jpzNpGoXRKJrp9pnaDvnk4WkSSlWEL2rODu10C6nRlWMuFao79L5QkaDl5mec11+9JtL4COCEouoVacWNg9I5Fu+A6fk8ni8i+fm8OWngFCLkrBd6zQQOJkZfFF1T/y7HVl9CUGhXLv8S3HWN/GXT6Yg1pdsODYQmElMilCAsEWhPtcUmeBtTr9goCJ1kL7uYGPBI6PfYhh1uPm1IY0uTtAPdyehGlEoelOReqfiFRy4ayWTXuqWy3iJ2XNiiKM/61+7J4ZPUYdqIRX6v+S4r/IG7mo8ofPJHxAl1y6+zK6tuByKq7+oNu/FlhjzotokLBfRAhY57dgeAX8BWpbE+x8zzCNCMVZdLN0+V7JWq+AihS2iZXjOkyaX8J68nJd0ATzoFFAZGyN7ixonQ0SD4GdUc7lm4WUutGAnOITYKeP/8lY7aaEF9d8D82UqXVvX+C/
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 700b11b0-ac75-455a-1712-08db20ee4e66
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:29.4394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sws4/dm1mNstEAH7OskWR3RhvaDv49W9QjMbUs0bn0yzqP2kFy/GwcHxECQyHAV1GMa20b5fQAgoYGYGbxWB7EB4+obgeYutNgBnhZNQJ3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090180
X-Proofpoint-GUID: _NFUM-tS8PJUsonuamFUJEze1Wa-tmh6
X-Proofpoint-ORIG-GUID: _NFUM-tS8PJUsonuamFUJEze1Wa-tmh6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This removes the target_wait_for_cmds call from isert, to fix a hang that
occurs when isert's calls target_wait_for_cmds to wait on running
commands, but also ends up waiting on failed SCSI commands or TMR
responses that are on the iscsit response queue. When isert_wait_conn is
called the tx thread is down, so the response queue will not be
processed and the target_wait_for_cmds call will never wake up.

This is safe because iscsit can now handle cleaning up both iscsit and
isert commands that are running/completing and stuck on the response
queue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index f290cd49698e..516fa37494e1 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2500,17 +2500,6 @@ isert_wait4logout(struct isert_conn *isert_conn)
 	}
 }
 
-static void
-isert_wait4cmds(struct iscsit_conn *conn)
-{
-	isert_info("iscsit_conn %p\n", conn);
-
-	if (conn->sess) {
-		target_stop_cmd_counter(conn->cmd_cnt);
-		target_wait_for_cmds(conn->cmd_cnt);
-	}
-}
-
 /**
  * isert_put_unsol_pending_cmds() - Drop commands waiting for
  *     unsolicitate dataout
@@ -2558,7 +2547,6 @@ static void isert_wait_conn(struct iscsit_conn *conn)
 
 	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
-	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
 
 	queue_work(isert_release_wq, &isert_conn->release_work);
-- 
2.31.1

