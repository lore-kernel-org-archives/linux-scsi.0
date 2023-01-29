Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8693DC61D97
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbjA2Xpe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235082AbjA2Xp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:26 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A511DB8B;
        Sun, 29 Jan 2023 15:45:23 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TJY8ki016081;
        Sun, 29 Jan 2023 23:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=SqmEcC1sALcRl+cnDmc+wNT8AmjsywVRrvAe56BxxGk=;
 b=lGM70QgmDitn4/miLIL8Mm46YGQbvXcdpiJHz80u7e1bj1C5pqcwExWxUuAIaxMvoYBK
 GvI+Ez6mIu/hfdSNIBuyynUZgvYYko0judVIqtV8+H25biQz/HxFn1A0JploMKjpTwd7
 zs7Rgnj8JxQXYqEtITOkr38F3LiCJ373fvAiKGNuKu81z9lHotVYpcDoCUe1fnH7KjyH
 1se5/OgMHHDp/L6q/ONXRlSxvWydMR6h4Ccy9TUSE1FiC03mpdIY4J6qJngFWH4EoFiv
 XEUukv3x10lEnWHqXL6guCUql0XuZ8rUqobKBmoX99JuBoPipOuU1C+H+s8xqBtNCzK4 Dg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvq9hs4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TNOFmS018641;
        Sun, 29 Jan 2023 23:45:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5anwmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=motduGZ1lAN56znYTm1x3iwVfTFbejH9LayH9t3lYSWggB6Der6iIQi+PaqUhFpoFSXygZvgVdqNPSWGBEdoq62MuNzem0H2F9PHtxDgvoIlnDnlXU5Gaeh3Cf2QyHOFVKoLosGbTtjMGT/2lprAZB0tI9olafHZmpahkwhLLe8hL9RS+F2h1DYdHFOKxnn0VTnSGRLhCPchA7uureVgOgO81X3VyW8ARHgMRdEFdevYjyVr1EQcT+Uq6NoVOgMuLIZyHe5PeGxfHoF9eDC+y6F3Akn/sWaF0khc8D9A6Jy5xf831t5gGJ/4gyFXmPJCjbc2UfU8lUJUzpnu7f/Hng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqmEcC1sALcRl+cnDmc+wNT8AmjsywVRrvAe56BxxGk=;
 b=XKgxLytZzPOtCu3uskflJZ5848X8FPRgCuEnxlH95HAKHxZU3F2AIep7dyl1N5DGWBJPv85L0Zbq8a0WXd+g1O5dhmxuZ5aOSg0C8Kmv4U/f0IxVlCicXDk10kQB3omYLS0bqoBCLb4d4mS9P0Dv6fwOty81UBKpKKqPM4uAjUGs6nBl0zAyxYa/pyr1iywEbc969dUaLmPGAn47AMt/2+94MkgpWwY74J2AlEQyc60ysVeiz4Qa1zFr7ez65GF/c9PDmv1Lctbld6EhNhHAS9d7NkML0S2jfhN04fpFPts4k9/2rmIUkPNXonzqowg4DiAHp+MW/lvZdYF0edp0PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqmEcC1sALcRl+cnDmc+wNT8AmjsywVRrvAe56BxxGk=;
 b=rnkdBmGrSfx4OuxT5RTg/kQ+DzydgWfttcb6m8CMwrqLvU8bPrVHlIT8SEr3Jf6PEg1rSS6Yi8o5iEQNUv9jOkpaHXvbIe+yUShrXEgWLAIZRvg/CLWeGMl+1cO18yqc7Zzj2J1A5lwhrzxyyIFotiyHRdp4KAillENYBsiaEtM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:45:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:45:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 09/14] scsi: target: Treat CMD_T_FABRIC_STOP like CMD_T_STOP
Date:   Sun, 29 Jan 2023 17:44:36 -0600
Message-Id: <20230129234441.116310-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR14CA0064.namprd14.prod.outlook.com
 (2603:10b6:5:18f::41) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: d3fb00ea-05b6-45a7-c3df-08db0252dada
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DlnZljPdtfpS0lXapmNr+S3/zKe+5kUyjN7vvqLviWV2UemvfaaS1Sd+6tVelPEjaI4+gUSk1VCt8EC972rJJ3bcuJgsBflPGM0NNzc/W0o356DBf/Of7vqbGwP3ypFfY0Bg3glzKu9Gv8r1DgW68LUPpRVgAXQF3xC1OGzcVCdO+sLHO84jRJ2QuCs/9Z4H0JXus5KnC1xRsYg+GrIPHdC5uA5SnhrHgEsSPPRCE1yYDr4m1LOH2X8gmwnzjZ5EfjuJaKQgfWrA8rjMik0WFMw97xJwDWzps6SH9p5Isf6WkCuadoHLCIwsvb9keGOG6f5TzSQiM/wOYMUKietrGYIz8XBouP2VnbGTER6ejiN55xbCQK8vPWVDUaRFcwMDJ75aezGh9NLxi/3IVrf/laaIFFBDwkL485XyKQxstgAi8GbrTMp0ylQSMhT1zpjH++MFLj34PO6FcdJ7wzva+TNASHHFpG52qBifTM6EYK0wAM4IZOe87lO8LpHyEVbhGJzow+bnOLgdnL5icMjwOex2/POxDCSA/BCwB1+a0jZPYHF+bZhc0ZXFJQVHvsP2DkZ+kzM/nL3W1HpZ00Fg4qDfQRSFGN3YqlPC7xFyx+RdVj9mJ1OLYcgyTg/dfo3Wndc2u8huFe3agR1fAqYcbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7yHtly7O5oFFCeGJI+aIRLIyGn25lboldz1XjL8069EcCHyRVzVnzD3h7q4z?=
 =?us-ascii?Q?kQ9+V0M8Jg3tnYvTH/vawnhJFyCXq7BXwmq0UzYi5cUYlj3bVg4RWFzqtXCh?=
 =?us-ascii?Q?ACs/6hXcXdgdBoCVVe4e+rPpX8l+UyZrE3HpIFdWv1xwnWnEXLILODlnMfOp?=
 =?us-ascii?Q?GzYcw/L/mqpUPjQ7mOhFP8oFBSwO9QJ2cPpjZEmHvZenxZpmZEfKmYTeznBV?=
 =?us-ascii?Q?Llrda793b8w9fPXaHfR4tjTBD8GFfonje/bQFDfgNvJ1w+OO6M4wyX6dx8OU?=
 =?us-ascii?Q?3jkoiiiNdrz6irRqRX4ROKoPNDNy09xw5oDVVvaKhOaXbWHVXFdIbReZR2HM?=
 =?us-ascii?Q?h4InuudI7TCT7LXtrtC4KXDxFedOWeTscbSldJAsGqeQ2Z4LFxqoRMwpVRlx?=
 =?us-ascii?Q?p4s380yY6MhUYnO27KG6UqedTl8t2Kyyv7RWdi7OXby5a89w0mw+PAJY2CUR?=
 =?us-ascii?Q?msrsoOQveWHpAdbXCaVyYhF5GX8ofg95VOFDDP1kKTW/WURpuVAHtvXGNpbQ?=
 =?us-ascii?Q?F8zqDLnqgj1fFL9C7I7E3YeLqhYSaFi/wUvA/+NwWX7+JYFvgt6bEzTSoHzB?=
 =?us-ascii?Q?LwKPANpiMxUr+YcUzd6F2qfww33GBI5nKmV8J3lhRFZCtjroJf9COdb78Kei?=
 =?us-ascii?Q?EGU95vPKXpbz7xEczWSfiVxhwAfAC9kVXovsuz8H3KjwFJ57VdyelmTTlos8?=
 =?us-ascii?Q?s8u9SFrATr3TeEvt8kPq79b4N9P2GEdmN2WHpZvdSPI1ElKw3Um5JtzxCx5d?=
 =?us-ascii?Q?RTrHMjfusTllTxqur7F1hUWbyGbNsCLRjRGmO31yW/0b6GbrqTSR5hLskRAc?=
 =?us-ascii?Q?l5qwoMPLbySdMXqFckR5++tKyfaALCqjRWMgCR0m0ic7x2Povi0tkjpFpS7i?=
 =?us-ascii?Q?F5BvqRVkqdt0cOZYPmW+0u6Hci8J2TTY24gKLzXB8MvQTzNYnFkFMQpQQKUK?=
 =?us-ascii?Q?9EZdfcnQ/a0/N0lVPRtn9TCsUvCQnFIKGgfzrSk5altwZCEiClrVtrbPzBQM?=
 =?us-ascii?Q?tvsMVX7S6Efk1jLElGqz4rzpmw8cwUh5V1Bvu8GbNJxdLi/mrRDRiFp8iRnW?=
 =?us-ascii?Q?nmA7wjkTEdWeuLswIs58LIieUZuubEEgbpwDyJFXrxxx2ohie7iK3T7pcCwi?=
 =?us-ascii?Q?x7lLBg/feX4XpYvCS3dDUkxt4n3anfO/n0D35F8Q9oPRXGVPaSuzLvfl5Ypg?=
 =?us-ascii?Q?Ww/A8KguqHM1ZE637+7iHMP3qw3BmM+SZ1BwvkX2eFOc9o3zkbATbLwJOUvx?=
 =?us-ascii?Q?kqdueUvFaWtbA49Zd0kszlsjt2ZBaaZ0jRX/0+O/NCEuW+QP0QubwHgcNDn/?=
 =?us-ascii?Q?w1FEKMkary4rCmL1EU5JbO5Z9ovv34E4Dwqbt6/XFaPzw1UJsvq17Iwrjw0n?=
 =?us-ascii?Q?7U3Sh8Na9dEpN7Fw25MDahP/tXlEBPaaM+E4aa/UmnQkJyrkcZLjtDoVmZZN?=
 =?us-ascii?Q?S+wUYY7LhypMO9nsx+ly2/VtcawEwPfFO085RyCljmX1ubvjM5yHtl3s79st?=
 =?us-ascii?Q?8q3L+fUqaksYG1/036o1lQ7YwYaYh6xJSyiVj9spSogwMP+5A3D8lLxvW9ja?=
 =?us-ascii?Q?Z4BBMeVb3tdWC8A/j+8log3Zv59TUgoUT7wFx9xFLMYdbo8MLcAi8k4lbiwc?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vXNsaPeelFqf2T4uRFBZO3ty901nAWrdYbXWrEiUA/Ic+iRcTrvNgLBKm2qifK2SZ4SKlRtc/2FKNellJKFv+iva61Su3CqEp23DOk55LsAGq9GTZoWfA8jWlFR6/Vuwt1MBqXeuXxDRrZv0+fRqqeSwF7jI/OO01sIUMneWlVzLFnJHrRwP9kIbTuUuEgdjhlW38BTwjsAHE3Y/Z8kC9GkCB2kSl9RZJvUDXs+vNJdB9CJa1TLBeXYGGbx23oHe8BRRErbsE12jl3xzVvmLr9Gi1q/ytndTs7Tnhaal5HeaxSDUX0UhpQtD+4P9XwmYnhRjqgwACJUTTS4jzD60Zj8wpI9nb7uxNH3HOlLHivmVGzt4FwMIRpR/qnrMwQUcbELxIiLYibBU4Beg28e/rd220Zx4VA5KJiyt1tBvTLfb284iGHGSNj3MMaoAk8X0KH9vy9oSe/IG/6k86lGJ85lcIgfpSgPr/bdm/lCWCs1bg1ZnedWg5gPeVHq5Y9aja6T6yNy9niD1Ue90f07Bmn+4Gg+GaGDMmjandxvqswGfSPH+HpVD7EqYSVlqlOF6FuM1+Zva77y3DqFcr5G6wKtVK3+fImT3rx4ErBb+mvE/FFder9Pn79azWtp7VxECClMdJeAxf7SpDBJEGuySa7eMD9RgjRniLqBsFqpD6Ah5ilGNvh3HDoBPGrPLEK4+d3xU/UzdVQ0gbnL0sk9u9Z/GpllvEWFEbLuYIeqa+XjtvTTBagdL1MxMw60oZqveN7IJ2JCL9LQKUWhbWYFWeSrVM3JcEHkprxD+ggRVt3fV8yTqTe6jtht9v4138vGkBc747arKuFgWyoBVQQzDeuIyWSli3Lh+G5MQu5kMWWskRmbVWto0ne+bjpgz4SUb
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3fb00ea-05b6-45a7-c3df-08db0252dada
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:45:08.6807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BLr9u2bn1gXaafW1cOnwyQXM9jsffHio0grNN6Pqoa+PSZZ5OwVExwVcG3RHqR4trSVmPxanXFXAb+JI3h3HO1NP/M7f4DBNDmZjOcfW5/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301290235
X-Proofpoint-ORIG-GUID: E97NjmIH0Je2PKe3qr3fl9HP7zzGYnEI
X-Proofpoint-GUID: E97NjmIH0Je2PKe3qr3fl9HP7zzGYnEI
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
target_cmd_interrupted calls so fabric modules can make sure cmds are
never marked both CMD_T_COMPLETE and CMD_T_STOP|CMD_T_FABRIC_STOP.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_sbc.c       |  2 +-
 drivers/target/target_core_transport.c | 27 +++++++++++++++-----------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index c1cf37a1b4ce..ff1ae779543f 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -457,7 +457,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 		 * we don't have to perform the write operation.
 		 */
 		WARN_ON(!(cmd->transport_state &
-			(CMD_T_ABORTED | CMD_T_STOP)));
+			(CMD_T_ABORTED | CMD_T_STOP | CMD_T_FABRIC_STOP)));
 		goto out;
 	}
 	/*
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 86adff2a86ed..1c23079a5d7f 100644
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
2.25.1

