Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF39DC001B0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 21:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjGJVpE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 17:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjGJVoz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 17:44:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA5911B;
        Mon, 10 Jul 2023 14:44:53 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36AJFoUW022897;
        Mon, 10 Jul 2023 21:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=phfv+F1fGAVDfZsBq2qq4pCE73sAAAiuvnOIvupp9bU=;
 b=GeHHrQ+idnU0R7kr00ZA2liXHK/PieVlgsaPWRVDzz3urFbdQ1ulNqukwjvn0kolJgqE
 6MirKHXCJU/YzB/xBh5z77qVU9YAVZ4brQOlOweB54RAe6kiAUHyOZF/+zDGgCuq1cu+
 bcTBz7HEXZlK3d3WYU0k1PckjLxbLXs+I2Pu91UVyNZgBRb2gzOR8FokmX35BzXBoeig
 ACvAXUoLkcWpQb/WLZTJ/xzKRSOIxbxMnc8iayok+tYupcukm4ngf8ARg3XWL7pPlwPA
 Zi3BArCyOzyIJa/+4c8L2l1NEU+raMBolMLe/kiGWYB3XgmRPVY9892ltk9/AeI1GQTT Zw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpyud3npm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 21:44:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36ALJZIg022812;
        Mon, 10 Jul 2023 21:44:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx841rqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 21:44:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTbRohyr5lsn49W0ej3s77O6+TRD9odmLP7nl5+TcKvJX0UxmuB6vCLxKoQroTSTYIKxQWlm7VbVQLqATT739V+jJ8fcKGEZzBGCtWntX8lBe40jb22ePGuA6I5D7+nqs3t4LyDqk0Ff8aI1Y0mQtVb5qn5idT8Dm1JFWTeUpa1dOMtBTZdGu2nKtlbwYWUxPn/z4nbaxN5KL6s8f/OMG0PW29/ENV2fFxOBpU/L+3Gy38N6gAGehfVPjWclCxjjjJ18dzOtag/UFp39S7gDXtW1S8QdsijvYIlpCqtmymvgNDV2vXqbZ+fv0Z/H6qFrrow5YqF02LYvvhiTHKdfOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phfv+F1fGAVDfZsBq2qq4pCE73sAAAiuvnOIvupp9bU=;
 b=KOik2JObK/qiGHYZmoN+mLD9qAtmNJMPHKOVrHjWsToSSyTOK5u/JxB/UQAZEaiBIEOx0lrb+OHmpnQxCBLVCI+G8Mbk2HqrAHHsQO6Ai4GF4zqk2GDgg4DdhoMyBDXFVnR5XYTbAYSFuOcCiQc+crxxb2Syicp5aDpcj14++HOt/gWHuo9se1K+Dd6fO1QWSY3N0QEqVjzPtpT6K4TV4Zq86bbAefklJO4QjvLFJzx695OVbi/wxcmBckwUBSHWG7+OcjRC20i/1gediBmNylTUBDZS54x5deS7I1tI8kqLthTKjKo1eu1Mgmuhb+y97e+iOFEP3sIFmyibZEocKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phfv+F1fGAVDfZsBq2qq4pCE73sAAAiuvnOIvupp9bU=;
 b=WeA2lICvQasJyo90RbUVZa/nXCEIvh7hg8eqtHbFSJux8rZUUhV1Ce1AiafdQYE/0CVrpqsD7LtV0BZ+jI7+KZ3diI/Cy1dp35ZdfIH3o+RgxYbEC14bBkqFjDtDH0/4wF2aBIJTM6o7f+eZ1RCsgIh/EP6L7n/QwQ/5EId8dvs=
Received: from IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10)
 by BN0PR10MB5080.namprd10.prod.outlook.com (2603:10b6:408:114::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Mon, 10 Jul
 2023 21:44:49 +0000
Received: from IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::e2b1:1376:2375:ef71]) by IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::e2b1:1376:2375:ef71%6]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 21:44:49 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/5] scsi: target: Have drivers report if they support direct submissions
Date:   Mon, 10 Jul 2023 16:44:39 -0500
Message-Id: <20230710214442.6718-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230710214442.6718-1-michael.christie@oracle.com>
References: <20230710214442.6718-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:610:cc::28) To IA0PR10MB7255.namprd10.prod.outlook.com
 (2603:10b6:208:40c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7255:EE_|BN0PR10MB5080:EE_
X-MS-Office365-Filtering-Correlation-Id: 59cbb6b8-98ef-4a5b-17ea-08db818ee29a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P5FIxXRO3U+QAXfz6GRFE9tdUTIrNn0sh0BeEwe+QwNhwMXKgFuV6hc8skU24Tyii5lJpVt/f10WsATtZZaO3OQT7v3jm51tAOEOP5TGae7cBtggRUPTTJYFT3fv4q9NPTr28XZEx5fO7pJcass5r9uCbB5ZBS/4j41KsjnO67eeViUHvcaGjYKvNvamXSlnMdVnWKnkjG6SQgco5AJhpdFyONS71+P227kvrGhlUyJ1B4GUanfVO8SyzzOqXpIX/N1TNP3zT0S808Qz7ISP0Rthc7Xdl0eUhphtm+1jd15Mi4jJhcyOkQiJwbMCWIMIINvWuExiGN9vuoMDisF342HC2teptx7zYflEldbPt1c679kqBx5oaBAfNmUGzRF//kja2G12Sv+PZPUJsOImf1Jew4friVNytF0zUmCAB2Kn3vfdbK9Xief9A/DgkeOByecBwEUWtNSN8yPNM41oj5LD4PwHo7zsXZVnw12pYAIW+5PY/VD3PGFrNQBy9m0eWjbjVBOVETtPYi+noakVA7YAEQ2VSnKShy5QIfdPakJBF+AeqnZaam4AMN88qMRl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7255.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199021)(478600001)(6666004)(6486002)(8936002)(83380400001)(8676002)(41300700001)(2906002)(316002)(38100700002)(6512007)(5660300002)(26005)(186003)(86362001)(36756003)(107886003)(2616005)(1076003)(6506007)(66946007)(4326008)(66556008)(66476007)(450100002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pItZc5R+oznUOO1FSj4EXnZq6QEZMB9HMLazx/QjwWOmJ7Ze495SBxTwl6si?=
 =?us-ascii?Q?iulOroo8Rb1MZ1k2JeJHGruWUkbkzX2zxlW5jc4jzaCg1T1bY6PW4w3nX2eL?=
 =?us-ascii?Q?9x2kmiWMpECFt98z6cCj1NI8h74UVAm0OHSrDT9O9f+bjTIvHbd1YOb27er3?=
 =?us-ascii?Q?2QUAZ4U56WcN9U2+U6Ea07H9ZBbUTbgipCofHTSCcs3k0egDXMp+vKfZ9J8r?=
 =?us-ascii?Q?Djs5uhVrsi8jNhTzwXL9J7jobK0yEfrR502a2bYi9AIViH4K5fxZe0euz4eD?=
 =?us-ascii?Q?uhNCdOYf0mrJKSE6rVNTFwrt9fqqZYVlKUlj0cclQZavafCoO+5xy37RBgxL?=
 =?us-ascii?Q?HNY0fuv7lS7CY0vwV5Hbre2Lns06Q9NxfYc3/UyoqRrNUKUHg6zCd68E+nR4?=
 =?us-ascii?Q?HkVtd4Ep+J5ZOlsZnB/0bzv5pw+cZajDSehdNZ21J5vQ9TmfPV31V/hl+ozj?=
 =?us-ascii?Q?CsmCSaX5Z+HbJOXdpeEU3XzMth++JHmTDmwlabWhMUWB1kQ/W7lSg2eNCqIq?=
 =?us-ascii?Q?8/xF+BXOctPhx5pqBPpWDnes43h6Rso/qPDoPq5dHrOBRUDyuGM95buguEqG?=
 =?us-ascii?Q?MYTwshvIy9BZQ8gM8DvUiQo6Gx1lpne/9qKLdHUJOYPR9fIUjUChm6dZWiRS?=
 =?us-ascii?Q?h4sf1BQUHe42HugCvN00SQ3yu3EckEuLhfXFR5Gbbafr3/tUwNNbMlQeJszV?=
 =?us-ascii?Q?EXrw5/CT6VdnRrGOI/nATqigofHm8eevRxHLJdyESrIsdReF9ERp9ipg0Qy6?=
 =?us-ascii?Q?QYREGGYgkR6EDhwA88LQfJaO2DU2jI0A9UdqR8jYrXmKENuI7eFxFEdMsDmY?=
 =?us-ascii?Q?ywn9KJV/Sn/FB/dn5VJZYlHYln1n7rCRktnG+5vGwo+IjiBiQRcikErlQcmv?=
 =?us-ascii?Q?VRe5xdX1KohRkv98Xh6rw5SKNrFguq5r7GTLDVqQi8s8laKF44+r55E9zsCP?=
 =?us-ascii?Q?IOGq2CTgLV45bMAHiMDi6tOirvGOwnAMXD76cJPbUvF1UKj2YPygunXJaEp+?=
 =?us-ascii?Q?h7PvKNWFoL253y+RaGo/PHFISd5sxspXRZb/c0XyOPNwwSJqZ+hIvgBnUqeR?=
 =?us-ascii?Q?Z9uj+OtTznpo1Kb6oYIcvEFAeR9LtzPPkEmjHzWrsvFqgMtHrj0OTl7KI4M0?=
 =?us-ascii?Q?/wPhZZN56vsRKCxPImVaYa4kDep8uwDXrfmcXDlqNPfTG9ZD8bHsKT1Ggqwc?=
 =?us-ascii?Q?x1QyxVDa3mLAEfI73+d6XW7e85aw9qZ9+BnVHBHnrmyQYwWkp1qT+JJvxpRd?=
 =?us-ascii?Q?yBVDwPSitMZW/bUf7hx4OLL90a0KoTmNCZKO5NI7NcKQ9WSV0m7WGKGgjo4I?=
 =?us-ascii?Q?H2u7ECBu537rBC42+5xD7aufOZiH+PEImJhpy0++HOoqdofE0R5w1EpJB82l?=
 =?us-ascii?Q?Wbt9wC7LdC6GYWGWt4LT6PwBkeduFIU3XSvu4/fUiEYXaTIegNUbgV6N3Lz2?=
 =?us-ascii?Q?BEV1z+9IG3U81ottEu2fzY+2yybH7PygfE3IhdHLkVyuYli2ESAiWB3sn6WJ?=
 =?us-ascii?Q?Wj6SQ2t2VB37B0ww5tik5WzBqTyZyRPQ5HcYCGsYndDxwhLc2QufWD55WTdS?=
 =?us-ascii?Q?QfMvIz+/WIikjPZOn4wBq/mAHVXfKYePanSOtKHUOFQRN1VuMIWm+eb21arC?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hVk8l9MIrcWjZCdBKvhwF+HmXSuKKCglCRulWRYt6jnwa9BksFQ/7TTSq4Nnnj/mJUmDFRaNEtcs959jkZgkreOA7+QUu7MHr0cEisldxX79Y7mq+KVrnkXeLmXXXKUSg9p5dOsem2kIHZjwQN5fTilFcvKDn2anCUjYygpB5nm2adBzNlk5wOt+tSYTkXA9WcgFfLy5NAbArBns1svWefJkFfaL4ym4QLkc+AmMuNn3/4iCoe4KLrA0t4SlHJE4KGnzB1iTJm+sDtM8xXzQ+CfR2fPCSVcUlQjNPFW0Ze68HApikKY/0PcHxqEhnK2WqMD5XvDXHxmlPIAUoYIlxppl58wOYJrB3Hn5w7DVaLcEVi2aRfgc64ZfufqYjh7tXLIb0QrynhtY5hhG32NuUWA6n1rDjpaHAalRA5PUo1eI7bi5REJmtwIdLh6UvGC6yF/AkrBv0yVBnqZcTsLttg6U5H0FFc73wIvE1zJKySXZ3yCspmA6kqKyNQOB3SNA3wNvmbNXiL5UZ9YhC/w9i7PDo6F3XMjQuVnZy82pVcEjqfq9eiYRQbph/wiP30x9LZg8agj877v3MtC7173EClXJXnSRs0i8PRogw6DrDBhhQrDGGVXBFKmJaDJR1KqMMef69MmEKigAa7El7BzJicvc95KGHcj/1eUleP/EUO26zbdQxHs09ItGJQM6bD3qwN9S/nvY3xpZX+qAYH+VVLcwF/VX27zSIlZqsaUhmdn8Wf3fUqoxPCnbjDX64o1yq4Nb5isvUGRWqJuluZ6L8A==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59cbb6b8-98ef-4a5b-17ea-08db818ee29a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7255.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 21:44:49.1918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ydC3sMDdzkdV5jKIrbivb7Mk54H6bkP80K4cxVJdj+dbqyPf4qLXUC1XIovcQX4VTEixvUcT7de3sOcS1yo5luER02kCvFs0G6P/frSkRtU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5080
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_16,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307100198
X-Proofpoint-ORIG-GUID: u80hIwsO33cW8o7IgzqMXCsUxSV8kSQP
X-Proofpoint-GUID: u80hIwsO33cW8o7IgzqMXCsUxSV8kSQP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In some cases, like with multiple LUN targets, it can be better to defer
the cmd submission to a helper thread, because if the backend driver
blocks on something like request/tag allocation it can block the entire
submission path for all LUNs. In other cases like single LUN targets
with fast storage that can support all the commands that the target can
queue, then it's best to submit the cmd to the backend from the target's
cmd recv context.

The next patch will allow the user to config what they prefer, but
drivers like loop can't directly submit because they can be called from a
context that can't sleep. And, drivers like vhost-scsi can support direct
submission, but need to keep their default behavior of deferring
execution to avoid perf regressions for the multiple LUN case.

This patch has the drivers tell LIO core if they support direct
submissions and their current default, so in the next patch we can
prevent users from misconfiguring the system and initialize devices
correctly.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c    |  3 +++
 drivers/scsi/elx/efct/efct_lio.c         |  5 +++++
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c |  3 +++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c       |  6 ++++++
 drivers/target/loopback/tcm_loop.c       |  1 +
 drivers/target/sbp/sbp_target.c          |  3 +++
 drivers/target/tcm_fc/tfc_conf.c         |  3 +++
 drivers/usb/gadget/function/f_tcm.c      |  3 +++
 drivers/vhost/scsi.c                     |  3 +++
 drivers/xen/xen-scsiback.c               |  3 +++
 include/target/target_core_fabric.h      | 10 ++++++++++
 11 files changed, 43 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c12005eab14c..a7e21d0cca0f 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3867,6 +3867,9 @@ static const struct target_core_fabric_ops srpt_template = {
 	.tfc_discovery_attrs		= srpt_da_attrs,
 	.tfc_wwn_attrs			= srpt_wwn_attrs,
 	.tfc_tpg_attrib_attrs		= srpt_tpg_attrib_attrs,
+
+	.default_direct_submit		= 1,
+	.direct_submit_supp		= 1,
 };
 
 /**
diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index a982b9cf9870..b7df6fadae9c 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -1611,6 +1611,8 @@ static const struct target_core_fabric_ops efct_lio_ops = {
 	.sess_get_initiator_sid		= NULL,
 	.tfc_tpg_base_attrs		= efct_lio_tpg_attrs,
 	.tfc_tpg_attrib_attrs           = efct_lio_tpg_attrib_attrs,
+	.default_direct_submit		= 1,
+	.direct_submit_supp		= 1,
 };
 
 static const struct target_core_fabric_ops efct_lio_npiv_ops = {
@@ -1646,6 +1648,9 @@ static const struct target_core_fabric_ops efct_lio_npiv_ops = {
 	.sess_get_initiator_sid		= NULL,
 	.tfc_tpg_base_attrs		= efct_lio_npiv_tpg_attrs,
 	.tfc_tpg_attrib_attrs		= efct_lio_npiv_tpg_attrib_attrs,
+
+	.default_direct_submit		= 1,
+	.direct_submit_supp		= 1,
 };
 
 int efct_scsi_tgt_driver_init(void)
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 385f812b8793..d345cf14196e 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3975,6 +3975,9 @@ static const struct target_core_fabric_ops ibmvscsis_ops = {
 	.fabric_drop_tpg		= ibmvscsis_drop_tpg,
 
 	.tfc_wwn_attrs			= ibmvscsis_wwn_attrs,
+
+	.default_direct_submit		= 1,
+	.direct_submit_supp		= 1,
 };
 
 static void ibmvscsis_dev_release(struct device *dev) {};
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 3b5ba4b47b3b..a005eb4e347a 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1822,6 +1822,9 @@ static const struct target_core_fabric_ops tcm_qla2xxx_ops = {
 	.tfc_wwn_attrs			= tcm_qla2xxx_wwn_attrs,
 	.tfc_tpg_base_attrs		= tcm_qla2xxx_tpg_attrs,
 	.tfc_tpg_attrib_attrs		= tcm_qla2xxx_tpg_attrib_attrs,
+
+	.default_direct_submit		= 1,
+	.direct_submit_supp		= 1,
 };
 
 static const struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
@@ -1859,6 +1862,9 @@ static const struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
 	.fabric_init_nodeacl		= tcm_qla2xxx_init_nodeacl,
 
 	.tfc_wwn_attrs			= tcm_qla2xxx_wwn_attrs,
+
+	.default_direct_submit		= 1,
+	.direct_submit_supp		= 1,
 };
 
 static int tcm_qla2xxx_register_configfs(void)
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 4ec99a55ac30..75804303b175 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1102,6 +1102,7 @@ static const struct target_core_fabric_ops loop_ops = {
 	.tfc_wwn_attrs			= tcm_loop_wwn_attrs,
 	.tfc_tpg_base_attrs		= tcm_loop_tpg_attrs,
 	.tfc_tpg_attrib_attrs		= tcm_loop_tpg_attrib_attrs,
+	.direct_submit_supp		= 0,
 };
 
 static int __init tcm_loop_fabric_init(void)
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 2a761bc09193..1cac139af3e3 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2278,6 +2278,9 @@ static const struct target_core_fabric_ops sbp_ops = {
 	.tfc_wwn_attrs			= sbp_wwn_attrs,
 	.tfc_tpg_base_attrs		= sbp_tpg_base_attrs,
 	.tfc_tpg_attrib_attrs		= sbp_tpg_attrib_attrs,
+
+	.default_direct_submit		= 1,
+	.direct_submit_supp		= 1,
 };
 
 static int __init sbp_init(void)
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 6ac3fc1a7d39..e66fd7131da5 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -432,6 +432,9 @@ static const struct target_core_fabric_ops ft_fabric_ops = {
 
 	.tfc_wwn_attrs			= ft_wwn_attrs,
 	.tfc_tpg_nacl_base_attrs	= ft_nacl_base_attrs,
+
+	.default_direct_submit		= 1,
+	.direct_submit_supp		= 1,
 };
 
 static struct notifier_block ft_notifier = {
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 79ed2e6e576a..eb618ff72165 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1687,6 +1687,9 @@ static const struct target_core_fabric_ops usbg_ops = {
 
 	.tfc_wwn_attrs			= usbg_wwn_attrs,
 	.tfc_tpg_base_attrs		= usbg_base_attrs,
+
+	.default_direct_submit		= 1,
+	.direct_submit_supp		= 1,
 };
 
 /* Start gadget.c code */
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c83f7f043470..ed6cc84c0b85 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2461,6 +2461,9 @@ static const struct target_core_fabric_ops vhost_scsi_ops = {
 	.tfc_wwn_attrs			= vhost_scsi_wwn_attrs,
 	.tfc_tpg_base_attrs		= vhost_scsi_tpg_attrs,
 	.tfc_tpg_attrib_attrs		= vhost_scsi_tpg_attrib_attrs,
+
+	.default_direct_submit		= 0,
+	.direct_submit_supp		= 1,
 };
 
 static int __init vhost_scsi_init(void)
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 8b77e4c06e43..fc41f936b84b 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1832,6 +1832,9 @@ static const struct target_core_fabric_ops scsiback_ops = {
 	.tfc_wwn_attrs			= scsiback_wwn_attrs,
 	.tfc_tpg_base_attrs		= scsiback_tpg_attrs,
 	.tfc_tpg_param_attrs		= scsiback_param_attrs,
+
+	.default_direct_submit		= 1,
+	.direct_submit_supp		= 1,
 };
 
 static const struct xenbus_device_id scsiback_ids[] = {
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 2a6c4c935666..5b2367c0839e 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -118,6 +118,16 @@ struct target_core_fabric_ops {
 	 * its entirety before a command is aborted.
 	 */
 	unsigned int write_pending_must_be_called:1;
+	/*
+	 * Set this if the driver supports submitting commands to the backend
+	 * from target_submit/target_submit_cmd.
+	 */
+	unsigned int direct_submit_supp:1;
+	/*
+	 * Set this if the driver wants to default to directly submitting
+	 * commands.
+	 */
+	unsigned int default_direct_submit:1;
 };
 
 int target_register_template(const struct target_core_fabric_ops *fo);
-- 
2.34.1

