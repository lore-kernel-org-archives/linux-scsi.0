Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47DA0C001B0
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jun 2023 16:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjFWQLo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jun 2023 12:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjFWQLn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2023 12:11:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFC4B7;
        Fri, 23 Jun 2023 09:11:42 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35NCfuNC021070;
        Fri, 23 Jun 2023 16:11:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=zMij9vqeCkXuiHfazJSM3kYsfKQ/d2mrYR2Da8bVUEg=;
 b=MvJ+m5V9VsquNR6DwRS4h6Usp3karYS2UltursSJ+sBG5251XqbTGQ5C2aAzYPJhGLjy
 0a5Akm57h/tb3I86gYJT7Vxv9az7I/b129umFBOuQHZymgCgpYDX115IZMqYWw+MCRml
 MdEbUQJm9Xf4ekQ+locIqCOpHaNXHml4HaEM6eE8YvPM7WjAmhd8D1l/XLcvXy1YBiFN
 0ilWgKIh9J1vKMbnARowcwj+NgIfUDU3q4M6VzU0jw2mU5aOUwFq701Cdq2dUNQX7g8L
 66e7aeBJgIUIfIKPpDOxPD3wY+vOV5GN4fvZg5P7dxjSLqBqXhkkEFQHompfy7ZciJjM YQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r95cu4ddd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jun 2023 16:11:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35NFk8T3008353;
        Fri, 23 Jun 2023 16:11:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r9399jxs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jun 2023 16:11:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+ksz2GwnoHF5edtR1+8dXvydS8dso8TGd4/6aGGLnLkUEgC0a0wtkETCZzjU0eROCLJlv3iaU0oANfkLKZWkDvKCf6CSAz3JJMRhn8MfZeYs3guyA8h3yjcbIPrwlkAEZzJok5lp/3IC5gdizSiSbeIAwA6gu8sHNDzYOGENMspD+jSy1mXClN2imfpLsS/uT5+1h0VXwvqn/TQN2Hom8cSxgesp5PEcyNXAE32aIXpMVCIjtlmZFQhBUhoT5HUpSeP4gVZ2Gp8IsDRLidd9zS8EvDuKrsj/eR9VXeNQY1m/3+3q1IQTNvbJAJslb0cE+Xdv3S7CZcU7ceSBYsEsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zMij9vqeCkXuiHfazJSM3kYsfKQ/d2mrYR2Da8bVUEg=;
 b=NR4EE6O18igaxECS9MQHq2IQQyAUHIIoHBffRNm1ki2lI0Hgd1w9f/zpV8AEy6LUjH8y87ma66gez6GvmIOuKpWSw8TESp+v7JD1t5XB3c8C+CVRZwxl4gDEcFjpdECtBArwen/m/7QP4LD6WeES999MUV1jyRUaD+JzT1pOiPCz4T/LGb5HbkAtkWiO3p5HUigxcUyKdXDa9Aqsb23ZE6GvbIx2NFo9EitzjVRGq316Xd6QaS0d2uHrGWscAtFwp8XmWfC6mY2T+fuvJ4aP4T2GPTqAOXKyVkRCLeJO5Z73MtocIxOzBlCtgA2LmO48WtpXrvwOLyLLG00h/ivsAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMij9vqeCkXuiHfazJSM3kYsfKQ/d2mrYR2Da8bVUEg=;
 b=wasioMkyL8oo3cKFtBh7mzo3Gvg0K4gfSpOaKgIXU+gXFM9vPQ6+HuYWKfwXJuE3P2Fs563NXHakEvrV5qFvjhvvVsR/j3j3e3OKuMc6S8VrGGO+R+p6aSPlsR9VkvnueNjxpDQ86UaLbdr5C3Rux6Ecii4p4hR24eWyDJdCWPI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB6450.namprd10.prod.outlook.com (2603:10b6:806:2a1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 23 Jun
 2023 16:11:38 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6521.026; Fri, 23 Jun 2023
 16:11:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 1/1] scsi: target: Quiet bool conversion warning with pr_preempt use
Date:   Fri, 23 Jun 2023 11:11:36 -0500
Message-Id: <20230623161136.6270-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR10CA0012.namprd10.prod.outlook.com
 (2603:10b6:5:60::25) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB6450:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d0e4d43-cd2a-4929-5240-08db74048629
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lhXLz3LApUT5cKRn9RVvk+d3ZcqNKkEwzi5OeqwRdkGKapdK3dOnJdMvEwKMUzZ7pcABsQg6JvdEAWFl597Q5wU8EZNJCZMw7MePgkZFzx10visaiTgZaWgtS6Ai0NmTLpQ6MMmmayFSq1DiFsO8yHRT3357PSiC0g/AGQjBi/VmsEux6IXFua62SSy+Z5q3BhYiSVIqcdOeHy8lICOUG2aLWAWwOBCCqC15chN136O1EbBH2cbQEEPZvEa3dVLLGLsJw768h9sKfQOnVbbh7wPrWFfYcRlWBYfSflcCOjUH9jXi4f9w3Y91Az7moBPpQJF+xUg78vscZj9+JElUlgzHRftWJt8Hb0J0z6jBA6cipR8hoAOLDC8vF/QjOLBgneY9+Ud+NH9mAQsbDkqx3u+SqOMAxwUe2A4mZ5IWB2igERfW9skUwVUqqck7wVTjAA11nV9vsuF5aUT2cE8xlIoeHpmHZDqn6M9R4iKHe/rGsRwjiFoOuCK4W3H0ME8u01Y5HUzsRrbidZpbm0t2z65sKhNW0zY2/xj9fjkHhls=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199021)(2616005)(8936002)(38100700002)(6486002)(2906002)(54906003)(66946007)(66556008)(66476007)(86362001)(4326008)(316002)(966005)(83380400001)(36756003)(8676002)(41300700001)(4744005)(186003)(5660300002)(6512007)(1076003)(26005)(478600001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gr4wtsE9YNyoNuZL7a4ddbnvjHYr5zHt05y8mhVc34ovs+gKxCIcNv/fwh8S?=
 =?us-ascii?Q?c3LxFKtMkz8LHB7NTG+J5nINRfWoPr8xXj6+/8hVsAu7bJFsC8POkd15Tm5q?=
 =?us-ascii?Q?ixIn74mK3nE/yyPmqM1l7aR75RqWwU2AUZqnTJsFGHcB5rvozM+AEdOV0UxZ?=
 =?us-ascii?Q?ZPVi5oem4D7Rjwn7+UpMVY+pAdaJZhMa3Lx6p6i4fbd5nzKwjMPJ/j7gp8tt?=
 =?us-ascii?Q?iBygWyGT+Gnug7xXn0bQNMldNnMxfF9v/Y6CMW8xn0o0k3CFwovfYL4QlVlI?=
 =?us-ascii?Q?9Z9AGqiUMZ2n99Hmj2ZB6MLrqTocd/1VBdgiZlU215FJtrpNVCzgvn5DMleQ?=
 =?us-ascii?Q?1om3bUDaw45J3WDVp4gtFooBeJBCHTTkJ1Z/FJTpcFrlPQiXSKVPu75EB+Qx?=
 =?us-ascii?Q?bguHjJVocw2X0r4G6Jj9vwhBCvlU95xTz2oTVaCCjlorDfdx5esEyFywWJNj?=
 =?us-ascii?Q?S5+jV4vnBYYH7vSrZNwZpfeGgic+gNudXbLalkTwZCJs76ZCzqmzYRQ2Azg4?=
 =?us-ascii?Q?oSpIgpsBhTjC0CqJmnS/W00/+ybKh2LF3uF1OPOfMujOmG31aHgpfIiyq+C8?=
 =?us-ascii?Q?8/R8XfzWFkjFLcAB+ZaZaKs8Tj8vbb+zkNlsVoPmZ4hwZ4ee/LWrEl2ZIcAU?=
 =?us-ascii?Q?cF7nInvE4wdn7edrEUbAs2sVRL7VZTYS91cl23aVAh2i3H3G8VwcesZfFAc5?=
 =?us-ascii?Q?sjcTE5SmdOBflgMIAALdZhHIHLe4Ulej418d8V2I6t46Qc/RrhjZ81y4Zsyv?=
 =?us-ascii?Q?G7cRuwR+u71sbntcHtq5/OP8zkBSZsiCCHGIB7F7AYx/xCSfKj/4BFn9InRy?=
 =?us-ascii?Q?pzweMbVqgZd2d3gisO54PVhCMw3NslSHQHAhJkPqw8L56YcVq63dEwy+BdE2?=
 =?us-ascii?Q?UwEg6I1YHMn4xOa77/WLWJc4FBVMVbUc63o6kmCnEjHEmI+/SBuUClrMXqy0?=
 =?us-ascii?Q?j7F4vqOrBpeN4sEjoBHzpnu1u26XJfwvcSbYpFtR53sw41wadnq8m/KiAMPD?=
 =?us-ascii?Q?mbGBNiaxBqRgeRoXOmQHiyKJNKAfsLJ1Jrjwt9EMPg0vhYJ0cLrx+nS8xVKF?=
 =?us-ascii?Q?gqbnEA8HPOGv4aLMgO+EKO3AahpJeB4BtR9pl/sqh/H512pYRP6WuTyk05eX?=
 =?us-ascii?Q?dKZvGD7DCqbP7OyUfkN/99hNaX7jhdedYMYpz8JCM6xtW6RMwmVLkWHKhqTB?=
 =?us-ascii?Q?rGNCgc6xsxzG2enZIqp2OFwFkmDcsUoi6qX+OUesOBGMha8pX4L2JEC0XesP?=
 =?us-ascii?Q?LxgvonbOFU2JNpuQYgaPV0CTkBshLAG4w+xSCJAtN+hAIa5jIG0PmO+ucnFs?=
 =?us-ascii?Q?H+J4P0bY3ra1CtlFSd1hvDK8VqHnxoMT5i++3FB2cT6ZEAGGhzHwhl7VkYqT?=
 =?us-ascii?Q?T56ecV4ZP+VgbPk8k1U5yZpjrweOzyOWpuSJFEPelUgUWufCVs0WXaAIXtJy?=
 =?us-ascii?Q?/l/3Gfz+2iJm1CXhG0HjKWOFHbWf5MdbG+TZ6m6JoOMROYcQa8JJ4lzMB4xP?=
 =?us-ascii?Q?KkJ77YiUSM/eRTm8uUxWplJha2WrofUsyCi+Ea4GIuPde4t3NerY+H7JW7bw?=
 =?us-ascii?Q?5n2B+9VLM2N5VnruQVRpjQWCMKb/0PSY6hhsC4G41HaFtnMWkJxrxQIen8/O?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yc4RAGOyzJcK65G4qPXZAHFKBYqQy/3D/wweYGWnaSUz1sRlOEW8dZcppNMS9sfZ+Ui0RvcnTbu7dhSa0wn8UYxGC8yJdF/HN4l8E4BQUZ/4/KyAHaDeNbEbroQ0qXdSdlEoBo0xkZwWY4iEY+Z6cY8zeGxT5PhgNaKfiXRK6OtWA4clBtJ7x/k7Mqg2mnToHQNa540oVCC3+J3H+GPuuEw0XbfNaofNR81Tuy53rJ5S4LsoKjfreSw90bNpsHDeomKA6g7515026Ur7HhyjcbcLsZccjzDmd5kTpoiuZcYKPgHXdBATc+8th/WuvLm4dSVwist0PsJPTeAoZA1beNLquu9Zf4WmEMMR3dKxcDoShGWr5fUNudt1RDFpLACPxQDOIflQFJX5IlSc19mDcWLIFX+mdRMn05KP66lcc8KA+lrDEi5C0NMv6KCCVXECh4ambv982tLzTr0H68ttKsHF2nloUNvEpdD8t/eMMX9a2QGOmLGRUnRozpBoeKIPN6e0URbFgU314DxKwq1iBRftwyeCa7t4hGP4qLc3JtQP9hqbshWHLpvedsF7OgpZh+kd+IhT/okV/rjcJYkWbnE+GYWM94l+dC+pNS/Kr4oec9RxupVfQk4iXdW8BtWg+zYBgFk/C1mZgOil4KSyMbpHOhOjLm2w3Mguk+TpKPbx+/rPOW9p+HSDiaNymsWGSWYUh80BrSoKd0Y8Rrf6MWaLdoDMnIr6idT7zXk2wHT+QtWJOFPdB+YhQru1axZqqV05MaZ+cuC6qbXsKJvOCjtTEQgLMwks4VZkk4rO26o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0e4d43-cd2a-4929-5240-08db74048629
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 16:11:38.3242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qkhcrESNn15LGiqoDKz4/PYemxnLNby/7bLuEwWVhlFIiIGOjuE5mgedBogvbRWkYrRstVEO/0fTdpzyAZvAmU2VGDMcmv3fcMfef92pu/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-23_08,2023-06-22_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306230144
X-Proofpoint-GUID: wMqDrsXDsAYePMyfCuj-JCl-CrRzZZB5
X-Proofpoint-ORIG-GUID: wMqDrsXDsAYePMyfCuj-JCl-CrRzZZB5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We want to pass in true for pr_preempt's argument if we are doing a
PRO_PREEMPT_AND_ABORT, so just test sa against PRO_PREEMPT_AND_ABORT, and
pass the result directly to pr_preempt.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306221655.Kwtqi1gI-lkp@intel.com/
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_iblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index a3c5f3558a33..3d1b511ea284 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -888,7 +888,7 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 
 		ret = ops->pr_preempt(bdev, key, sa_key,
 				      scsi_pr_type_to_block(type),
-				      sa == PRO_PREEMPT ? false : true);
+				      sa == PRO_PREEMPT_AND_ABORT);
 		break;
 	case PRO_RELEASE:
 		if (!ops->pr_clear) {
-- 
2.25.1

