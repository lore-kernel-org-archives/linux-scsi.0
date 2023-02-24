Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300D5C7EE23
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 17:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjBXRsN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBXRr6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 12:47:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6408F1981;
        Fri, 24 Feb 2023 09:47:49 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OHiefq003747;
        Fri, 24 Feb 2023 17:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=gT8347jA5KdvGQ7I7vMBDYh3M0ax0K8JKbyzwbeexOU=;
 b=ZjSYcqx2nEwg23FJy7esPQwezAkQ4S+QYUMF8xltuJIZkTzYmtlC5/XR9lfz6g40G8oY
 muj/l0a8qqUyoYUcuPHJ03x+cbzHS/PxaamTZKwlNFHhsLOD982K8G+SSU0jR5cNQucY
 CCSRIyRbrOwJlQjWnR6iDh0BHbtX9ICGsVOknlOGHTB94viW5xRcgY3OMbJobUHIqtTJ
 m8yupicK7g1894GU/+3rg+vboZFCIQi6OrVp61p8WpT9irOJhQFlibVnxPWH2+b7qBXI
 mn4ZZSxieIwO6Ut2IiaWWBOal+6LepHPSa/lVPoHr1ke3fRnWxAfimbVDdzUl6Px5tGl og== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntn90wq33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31OGY1aU000677;
        Fri, 24 Feb 2023 17:45:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nxsb4kud4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTJIpNeUjgA49KneWWzEpxDxqBc3oqIlTKIp49jFXslkDZVUi2TmtXDV9Vw9KP0orOyVwXmwoms460HAFbBs21a2Lizu5gcjXqm5TjyaIJnHZ3gOPT3D7VLn3b8NjsCInCj8p5VyKxhzqLadG8U3q6pEYOrqC+TOGvlOC7CfOlWTLZweE4RzhtEXmP1/+7Gnk6CNUgdaDvBtTnDbiMMUf1nStdikVGAet/AL2+d3s0cOipDBEsnHgpbxPbZqj30UdWH/3SfbiUrIbbloxFjWvhuvqsG/Cso7T+bKYHjqHad92tbhOPvraqwJmfCWWURpDJAEqePHa1r5CXwt03CRCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gT8347jA5KdvGQ7I7vMBDYh3M0ax0K8JKbyzwbeexOU=;
 b=jk3xNKYmrGV2lPCSuPctYu89tNTpRzkX4U7smMPgtX9+Zsh9U/LDEYiNgbQ1wM+butyjVCx1BxFhKF9QEmYKZlBE3w/o4fCGq/3sH3o/hL+c77iWlJHbWuq6QEMV+uuphPywatoCGWZKBCcI6hAaZbNbiDGdPHVRtVKqw1eSP+RoyPOAQpZqLr0nbVOi8aAlS14mU4E07mPVus4ZH7p3JJtD3III9c63TFHj9poQd64A67u7jOR/WcHepH6SFx/6y4RlChDu0fniW3yXKFr8iEHoo2iJSss4MIGlPtqEZTuFrjS6I27LCS8N0hnt8i0VQV3gcpsUZUbQ6OvEo7nTQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gT8347jA5KdvGQ7I7vMBDYh3M0ax0K8JKbyzwbeexOU=;
 b=ML8lYvCCKXizVpOPwuHR5iYlWmx3FhMkySITlCfE2dToWV7x+kWW57bgO85dhCC2R1oSVWwPUjkaWLXWpGYZed6ETS2ugLLi3hX859DBweqBBwPT6ZHO5MY4Z6aeu35p0NCx2CZWs6em42au6Tu5JHcEl8mceNs3w3Gn1bbftZI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 15/18] scsi: target: Allow backends to hook into PR handling
Date:   Fri, 24 Feb 2023 11:44:59 -0600
Message-Id: <20230224174502.321490-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:8:2f::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 285362d2-2404-48b8-e245-08db168eea0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oVgdryvOEQXlk3E+F2lSP/t1zLjB8+QOVJ9qCunX9YY+ZRU2AFzFS/wi6ZzhgIoZsD55RpU8O9640acgJgfitBvDSetqNY1Owg9Bijx6RkRDV4kq6nd5xW2gbJKJ5UPd8slgSWDvQZPJN1aIlaeJRw+4CgyubhbnzY122En5MgnMPG8pNdWSwJ8/rj658jH0lzZg87LQIe+JFxCl/gPj1Z+Lcb4EtwBns/0+CEtfGFHWc/deoZrI7OKFrerdFoMOdknm+KF5sz8FHTSmlooMj6xHiXGqA5sBm5LI/xdf2Fisi6MtUyEGRaScWz0aYZOp1HvLEbrnOvE6nhGPQpBpEzjS+Ay026taY/NXuZsIE5FEUzzRza2dyUqcrm+Tu6FLUnfW7jH0HRDer4nfTBA9+tjOVwl9jMPtpKtsj55EDN+5X2s7EksMSyddKdgS94dS9Wy9zqBBDjj0wW8lmcDEf5vlBE8w2ty01dKkU245r064wL2inp+2EmfaAaregZc0ZSK5I+fkI24za5tUHsd/KULsb4XtzuCNxJStwBHCDwBMOSuAk7zPwoQgE2DhFKyZYtEs95Jrsrwq2wnGN+SfwwgH29C/HlKNFmYFNyGOhRVZtGI8w8n8GcLNX2CMTIqYvFKsRlf20dfzHGCQ9j2a5h4tZMW7iXoFtOjoJNcMHJtW6cAKjDUdLg8fgpJote6v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J22mbhDHVbf0grECr3l2Bkennp2Fg1ONRhEmefLGX4dypTp6mYQx18GytEak?=
 =?us-ascii?Q?+zZCOdElvMG60n6MI2axD8L6ETwbng/jsw1D1LIDG8I78mP0DHqjLyG2y32q?=
 =?us-ascii?Q?+89V1Tag0HpDHf1gSOJu44TC5TpUJLV9GK5AV+4lh6Z5oO3ee/poOy6QHUYg?=
 =?us-ascii?Q?IzvYsJnXKcWM/CUo78OKO2dzW4OWPQIJmg/z9E1+yibuqFM9ZjRq4MKz1pTd?=
 =?us-ascii?Q?YzFYFNDgjt0QLQLzsL0pn8fuufBumMV/HH8jaJw3LwrtSbujF/urPhqpmXwZ?=
 =?us-ascii?Q?6mLBq3tM/kiG12tT7dlqElTJhxZcnFvzC37jDBhUpq2gkHWmiXZdNyq4MbxQ?=
 =?us-ascii?Q?Dph31SF9zaZpqcslLNPBUF6DIOGBiFvcZSn0/aj2J97OSH2o5Jr9hP/Ru6YD?=
 =?us-ascii?Q?xuuekNzOmEytCGotrtx02uTKMtubEoOASzb/l5SQ223+3Cv+xWqcSJuOOXvV?=
 =?us-ascii?Q?rt1XJ1HzQGNEMV6hDE5FnOf5gZCM8csb7thw5IIi+dYkXaROqhmdnaNJzGGu?=
 =?us-ascii?Q?PDSDOdbsTI1ehDpw76hJhUcuf1HtyauTzOvd4xF6bkurcIlSl8XnRMAzmufu?=
 =?us-ascii?Q?iBak7sCgLA+9z8Dy6BjrHa9aAMl0yrYeNh5ppVcFaZWLfDL3m6dg+pFXgdFU?=
 =?us-ascii?Q?5JGNbz4udKj5I7yoShZC1NxEua5exnmrcX/L+onM0jBl6A6+mwjiW7nvJ5cW?=
 =?us-ascii?Q?5Igan+1twugzSy/cNSlJE90bZYZOx537882Pm55teh3F+wnxmuTZYYtRcSX9?=
 =?us-ascii?Q?HeePlT7QGgOR1P3sYXiB2C5VLHvWRiOSe2FnS6d4V6fbx9foLPT9VgsjZhNP?=
 =?us-ascii?Q?Sy0Ns0Af5pDI202r3Fwedb0JLKMqY+gxYXG5DCjmlYPoqUctBHX5XRc073x8?=
 =?us-ascii?Q?ZH1Q6OKK79qSD+LY19VyfT7FofBCs3FnoTXnZmwNWEyFvWHhEo70T2RF1tbb?=
 =?us-ascii?Q?Zav9Cp4aLcZATqlw7Duw/OoYSlCF96A/QGc+onQ9SrmJ+5ZkYbtCkEYOTKrU?=
 =?us-ascii?Q?QiipAHgt4S1ZGTrdyd/GmF+a+eUptSXMkD8ObnZCUWjmD0n6eWaFGPbRjmqR?=
 =?us-ascii?Q?pfBu+P4lPsgGYXxiiJfHxYtrab5b7GTYiLb/Bh2+1sW3xFOrofkL00pnjJEJ?=
 =?us-ascii?Q?T+9Qa3abI6uK2/wWurWi3wUYTillgERmdHiyiuxdTLIuaEaP2XmU/PxlOIgO?=
 =?us-ascii?Q?OpKguZnMfPOqnJjnZFiuGmbzFVU8wt5ebfvS0900QUPut3ooitfcphJMEBJW?=
 =?us-ascii?Q?su7UbR0L058/RrkgY70tSbwizGJKOMzKkDK7Y6B1wp8ipW+FV27S5cm/ugDE?=
 =?us-ascii?Q?qQOiPZThukoiHPZIsuBsQh1P4YhGKHJN6HBHyn/NuFscwvSubVbb3Laccrj6?=
 =?us-ascii?Q?CN5XENgK3Ejv2fShPFdPxAQj61qeMfWj6s6Ui24bfV7YNOGRMPPNRwAMhXNO?=
 =?us-ascii?Q?ZXI1OupIiMuznMmbX7YqCNwxZwToA6Ljtz7F7nQWS9Vfm5vy3KLKRY28ekp6?=
 =?us-ascii?Q?5Qdo05z7C4OoxeIUMINLz96wojP3ztY07pGnTHmPX1Yw/jG2xDTIM8VfNSRN?=
 =?us-ascii?Q?NexT/g3upAxiVxzsiYaT2gYLa8LiKJ/i98SK2rBWRmnl9u6617sFJXV2JnmX?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?9KjtbR8JWDsTlWKCasyjy+83cGiunRNmTwV3jgN20eWHZWZzFFT1SKgmgBww?=
 =?us-ascii?Q?y2/cIYF/39fXgfopAtkK2NoTUJYNkKkDXnbWKuptxQg6unvvPZa2uLtbzTEh?=
 =?us-ascii?Q?5KkASyqrqXV/u2U1pt2jcZpPNLJu4P2c96Se/s+EAJnSveHVkp/jSNIvKXw/?=
 =?us-ascii?Q?RF0+w5WC+eUz2XRI6qCFV8Xg3eWSl7piHW21AUC0DxS/I8gwf8nJ+tXSUGZK?=
 =?us-ascii?Q?OJ7lPdEEYO0q+ECE1j6B8Z4rLexIWZ+A5KEjkV7Udwc319Kt2eYm3w7y0kqu?=
 =?us-ascii?Q?ECppurpna/H1MqSHjulNThahGoKdLjiNGHf6t6At6BE2apPq9xwO0jQJ6Cuf?=
 =?us-ascii?Q?X7m456nAfAtL0URgjRfGIVP1qLv8J9XLO+SOTY8XU1dB8ynoaqrCHxPzEMed?=
 =?us-ascii?Q?mN+SiEdaCFlKEdB/bXb7pPvzTrat3hPjilIjkxy7tmWiZlgxmUiyjZYYnpY+?=
 =?us-ascii?Q?mwnHnia8dyffnKZbemGVGACA36Lw3na3vNtM1M+ez9HomufsOmgtqIWPtBC7?=
 =?us-ascii?Q?ogeh14oIjHY4HUQuemAoerDcuI4N0YiEzdGvqnUDEkbec8o72DeeL0JkB1n0?=
 =?us-ascii?Q?9hv8oR1Ew9DceEhsCm9a6a5LvP1Fl+DWd4rdwbP12RO0CAusLazyIKR1GaGy?=
 =?us-ascii?Q?BL5Je6LItpk1eSV4wS2C1WBlCoT1ZfTwgvPKK+pkHSkUx8u9qxcSPUcxTTEg?=
 =?us-ascii?Q?rp9whjAyNZej/yLK6h2x8GO/NYK+u2JZ8uUXJnkcWqhFaHOhuKz9FQGDq6eG?=
 =?us-ascii?Q?1WG55855/0Q4+fWmuwZrOG177Pu3alngCNp7x8NduBXreTkcca77Nmz6QXk1?=
 =?us-ascii?Q?+lhB763KeTlqChFzJi6EoG9FJaMyF1L6FuaPgZfoaiuvxzcBvL8QFnf82HGd?=
 =?us-ascii?Q?LzvCld8T7D3zqVai9NcqZJfeIApE+IQxPp7uuvI1dGrbhwNB+oKv+iSlW9Z2?=
 =?us-ascii?Q?zqYxYSW9ZDTcdTMff3SQf+vbVjPa4IbXrTim4uKlflae7INaYwyilxZaHPTQ?=
 =?us-ascii?Q?5JwkaCpR2NnIH8z8F0uk5Wc1oA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285362d2-2404-48b8-e245-08db168eea0c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:27.2343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zl2NCOXCrbWaVVP+i1htnu1n5rISXN0JKLb9RPUqwXEnSh2VnvuQkP1l3td4kh4xu0EShLp0KR/4VCJtZaF+ekAzze3EdCatHnfn3BaBmoQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-ORIG-GUID: 38P5-lKG-6sON0AgWk2VisCtPxgpEdP9
X-Proofpoint-GUID: 38P5-lKG-6sON0AgWk2VisCtPxgpEdP9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For the cases where you want to export a device to a VM via a single
I_T nexus and want to passthrough the PR handling to the physical/real
device you have to use pscsi or tcmu. Both are good for specific uses
however for the case where you want good performance, and are not using
SCSI devices directly (using DM/MD RAID or multipath devices) then we are
out of luck.

The following patches allow iblock to mimimally hook into the LIO PR code
and then pass the PR handling to the physical device. Note that like with
the tcmu an pscsi cases it's only supported when you export the device via
one I_T nexus.

This patch adds the initial LIO callouts. The next patch will modify
iblock.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_pr.c      | 62 +++++++++++++++++++++++++++-
 include/target/target_core_backend.h |  4 ++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 1493b1d01194..e16ef7d676af 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3538,6 +3538,25 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	return ret;
 }
 
+static sense_reason_t
+target_try_pr_out_pt(struct se_cmd *cmd, u8 sa, u64 res_key, u64 sa_res_key,
+		     u8 type, bool aptpl, bool all_tg_pt, bool spec_i_pt)
+{
+	struct exec_cmd_ops *ops = cmd->protocol_data;
+
+	if (!cmd->se_sess || !cmd->se_lun) {
+		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	if (!ops->execute_pr_out) {
+		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	return ops->execute_pr_out(cmd, sa, res_key, sa_res_key, type, aptpl);
+}
+
 /*
  * See spc4r17 section 6.14 Table 170
  */
@@ -3641,6 +3660,12 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR) {
+		ret = target_try_pr_out_pt(cmd, sa, res_key, sa_res_key, type,
+					   aptpl, all_tg_pt, spec_i_pt);
+		goto done;
+	}
+
 	/*
 	 * (core_scsi3_emulate_pro_* function parameters
 	 * are defined by spc4r17 Table 174:
@@ -3682,6 +3707,7 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+done:
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
@@ -4039,9 +4065,37 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	return 0;
 }
 
+static sense_reason_t target_try_pr_in_pt(struct se_cmd *cmd, u8 sa)
+{
+	struct exec_cmd_ops *ops = cmd->protocol_data;
+	unsigned char *buf;
+	sense_reason_t ret;
+
+	if (cmd->data_length < 8) {
+		pr_err("PRIN SA SCSI Data Length: %u too small\n",
+		       cmd->data_length);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
+	if (!ops->execute_pr_in) {
+		pr_err("SPC-3 PR: Device has been configured for PR passthrough but it's not supported by the backend.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	buf = transport_kmap_data_sg(cmd);
+	if (!buf)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	ret = ops->execute_pr_in(cmd, sa, buf);
+
+	transport_kunmap_data_sg(cmd);
+	return ret;
+}
+
 sense_reason_t
 target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 {
+	u8 sa = cmd->t_task_cdb[1] & 0x1f;
 	sense_reason_t ret;
 
 	/*
@@ -4060,7 +4114,12 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		return TCM_RESERVATION_CONFLICT;
 	}
 
-	switch (cmd->t_task_cdb[1] & 0x1f) {
+	if (cmd->se_dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR) {
+		ret = target_try_pr_in_pt(cmd, sa);
+		goto done;
+	}
+
+	switch (sa) {
 	case PRI_READ_KEYS:
 		ret = core_scsi3_pri_read_keys(cmd);
 		break;
@@ -4079,6 +4138,7 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+done:
 	if (!ret)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return ret;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index c5df78959532..739df993aa5e 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -69,6 +69,10 @@ struct exec_cmd_ops {
 	sense_reason_t (*execute_write_same)(struct se_cmd *cmd);
 	sense_reason_t (*execute_unmap)(struct se_cmd *cmd,
 				sector_t lba, sector_t nolb);
+	sense_reason_t (*execute_pr_out)(struct se_cmd *cmd, u8 sa, u64 key,
+					 u64 sa_key, u8 type, bool aptpl);
+	sense_reason_t (*execute_pr_in)(struct se_cmd *cmd, u8 sa,
+					unsigned char *param_data);
 };
 
 int	transport_backend_register(const struct target_backend_ops *);
-- 
2.25.1

