Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F66C25B0C
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244547AbiHIAEx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244454AbiHIAEu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:04:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835DD16590;
        Mon,  8 Aug 2022 17:04:49 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NxYdO022486;
        Tue, 9 Aug 2022 00:04:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=jbOfQPGPYOQ95aTCJMXkDd/52sUJY1YUoXcwCZo2Nks=;
 b=lax5s7UDU5jOFxtGjCIROz7V/kbO12cMP2e7Vw9+KDPPvHowTlUHdKCX9yWxLi9Cnzqg
 Fkm04xTZZjqLhsff9L1JSPObmA3gee9RPZvGoMsQGVYL0PAKUbEAwE5B1Bi2yUnkXT78
 XFYs1Jap1aRTTgmQSH2VgDp5bB8UGatu3mqYmt25ZPqcakdKFGSGVfOZv9ibau8utuXE
 F45uE/UEi4O6xZDZXOthp5z6YmMaYwiMUITTW3E15L88+Bzzc21QCWQp6Bh46jBmc1Hm
 fVnKRY/Q82J/h/Bbh0HxT+F9c4uzf+vCwwZxb7Sh2wnecoHSZH5ZCLJ2ilUO+/GJV11t SQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsgut539t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0hsa032829;
        Tue, 9 Aug 2022 00:04:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hser2cbnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kX63CxNmUyHgS1NFw2oRvu6qMI9ZhfXiXyDICcClndaeYMWbzySbJ7VtRjLX2ou2kahqLE7GvIsXjXIN6/tQOguV7xrne0/F6/b7mQGOs51PnARqBsnFD76786lLxtEIeEp6KWetaYX6LJu3CX2ryawmzDEE1F0FCbhlSHgK7sOEL0yFaROIKJdebec9bB570d5bSoH/EgDXDnfw5mEFarbMuxwhlplLHrUW+hLq/TeYqX4D4jCAW6JVvDXizrZv+LtH7PE6M6bKd3iVSmGYmvU7kOJVll8XDWQ6U84Uy2O+yBmRYUp/0bIG2vUnhtXWbLcsoQOjb0bLpnSbHM71yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jbOfQPGPYOQ95aTCJMXkDd/52sUJY1YUoXcwCZo2Nks=;
 b=B6WoQd/PuiksjJpSKXeGAlFfjnQxUEsVRmhlZNJUU0bGLn4oLvroO+8Ym4yUEZD/541CWe9udqrEQSX4vmR3LP6AIU6d5newNM53yv4D9OsEEGcw0/gpcJ0ZmWuLMGIoqhKP2H/rIaDNVVCrT1jR1DQHJSVYwcsCJC7ilU3jGVrUKhGjeZmZx1PBymM9ZXzaRJac5MQaR4EetRcbhIZLovjvYyq+/uopMypF6HAOa3+T5bnRusHAecG2hsnd+vQ1gbLIeelBaBrKE6PcF5Zi3iXYP0sAcIUND2WncIYBxXIJgluPPlnpswD4XZBoDRq/Vc4jEtkZtGKw2VTX9qizvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbOfQPGPYOQ95aTCJMXkDd/52sUJY1YUoXcwCZo2Nks=;
 b=Xrs7WVRZDofPlhFxNzaLm3z5J1V03C4nFUYzr8dWiHRUwRNpDXPcph0Pzs3bOYj/A6rAiZfLWjm7H8ShbW0VCGRaLpT/gm16N8L2AQTM/o7wzTpsXo2wjcXJM/AOWjwf/u6N07TRH1J+IZo4Y3UjYZBDaRdPzlyX7wWucI/TsHk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN6PR10MB2590.namprd10.prod.outlook.com (2603:10b6:805:45::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 0/20] Use block pr_ops in LIO
Date:   Mon,  8 Aug 2022 19:03:59 -0500
Message-Id: <20220809000419.10674-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:610:38::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5435acad-91f4-4b54-6e6d-08da799ab645
X-MS-TrafficTypeDiagnostic: SN6PR10MB2590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lUvID1YkbdlnkZ16T3pqcWgIiodC21rej33i/xKh0OvkyAjoNNzPu9EqLKFhuQjIBI/EjbI39VzeO+a9VP76AHIy8DZiKRmiwuzkH2RZj8ao0NG8fBEPwZoi402WjVGN/Uq4T4XfAiB4lROPo54bRlo65RlF9ODGMXTWmlxpujj3w593fEzD6ilgcIX+rEc4IxfOIgAy4OrtQ7iZ7tJnqi3ldWAbgnl/mBf2OVGxmeAEJ6eCjdtrvIJNk0Plf3PKZ+z2x6/zgnZ/pDYYyRVIXKtT+jTpUOpHCiIX/cku9/kcV5Sfe5Upr1jumusKVlPkPePhpYfJUaRN2rXnUqhlWotFEaWUMQlo+9nEon67oDqCKjaVgSy3HviwhcQeS86ebAw5m2uN9mKa+8G3jJTuSOG/QDXAjwQHkQ0gQlpyj/zFH4iNK5ihlfhmRoa22B9FrBbT3NlHl4UTi8fEVilQOkWSiJZZiVhTccuQFZ6cmn7RAT9E+yN06VEVobwzKtaOFVO9ogTZBswPULqXb9vpBd78qAFf65EW/MPzTPP40f8I1dhaiF6GcBzzKgcVA5WpKT7y+ohhweINZATbCxRXVZNimyKXCtXyTxQe8seMQe0btOJnCSSyB5K61SNYCOi4NvVl5EkxkqYQRhy7giQv+PRgKvnVMD3llgDl7Ppc3MTP/+ruuo1EHL0MOk8WYAepPV067m+wFZMobETHPIjpw4GMw4JLwrPYkOfE1G0Nmep+EU2wmMrwq+ZOXgnY9RfJTsgbd7b7zil7c9Z9tESL0QLPqe4u3qJh7AW0DyRttlpjR8K43tkwW50sv+yyZx7Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(366004)(136003)(376002)(2906002)(83380400001)(6512007)(26005)(6506007)(186003)(1076003)(2616005)(36756003)(38100700002)(86362001)(921005)(66476007)(6486002)(316002)(6666004)(8936002)(66556008)(66946007)(966005)(8676002)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JkhC5saGA0kSg9m9fngaJEctmcT3LhMzDHpBrpkMrB2R6gPPvcI+l7XLiAav?=
 =?us-ascii?Q?/nNFUWfpq+Yxa1qa9CmGkXZd9aW+V2nkCIpQ6U9XV4qYbNum6DBUXpcL2Fjm?=
 =?us-ascii?Q?QHwdsjdgw3kC+Iu/rh72bRkIYMB2XVCNkiiu1JrkEQvFc7Z7OVqHtfIeKTLN?=
 =?us-ascii?Q?KqVjYnXnsA7fp2hEqcHbEBpGcKbsXpuopVxmDq1IQUHDhFAw/moVxnzbcCJi?=
 =?us-ascii?Q?enAET+kbljM/vB5kRiZC0o9S20nyAMHAWBMoy4pLWerDIRuCP8B0TF8Axq9z?=
 =?us-ascii?Q?uXquWFBmobb4c3nCiKGW1iTB7rWTYsUDPAx+/YYpqnL6j3NNbEDEWdOBrFwW?=
 =?us-ascii?Q?S94gf5Olsr9/TkRPWGzSoPj9CT+ubnui4ntK3NbRPlfg8iS4IBO4ZI5q2+9E?=
 =?us-ascii?Q?TyJzzvgQyJQrtzY8whY89i0I/F/tHnPTgXEwSpBSyINz4kfBuOx8K1ytuWDD?=
 =?us-ascii?Q?/tRcuaoMhakdGW/fgmh+hZ62QJLRkAeHIhsYXb65+9T9MvkqwI+5FLU0msjO?=
 =?us-ascii?Q?MyIkBuJGqRyiDdU2RiJOdQvJ/fJUy2BRD7xJu1KpsV250OUbvXhpuRFi1mbT?=
 =?us-ascii?Q?PxWWxjEfasbIP0k7i2GujZ2fSRV0v2Mj7QOf9z+deV4XZ3aOzsiGlxKvmk00?=
 =?us-ascii?Q?xRE8Rbassl0m0xpVM1jvb9mduQ7oOKWHjs2eGm156s5XEVDw/klWRR0ipFsS?=
 =?us-ascii?Q?KePMEtimIUbWd281PgREB7HZazidjY9cxIUMFVH6fN6alKbagCSLrA35b4P+?=
 =?us-ascii?Q?eloxKOP0lnyGSy857YNP83FePHIf4DxU0eE0XUhsLK7HFrTfm1FOPAmYq7V0?=
 =?us-ascii?Q?Z6MybA4+o4uBWkzbK7tRrLBW6Bzn1NpjUiGoC6zEiQYJuv6nI/COpnHs4TZY?=
 =?us-ascii?Q?SNS9LlO4VNxuXA6UcteTiYW580JhS8R3MCtIoFSgEcGPuZ2pMMy6g9k148no?=
 =?us-ascii?Q?FoqP8ggagO5aFbwXX/TjS6W2DG6bn/vuWd/c+NQ4JtJ0Q8ga0oz92ZMFe8TA?=
 =?us-ascii?Q?uPno/zD1ASWanSHl+rFFOOfE6gtW7+8MAngUtPAyNzTL6KEKwRfyqL8zuisp?=
 =?us-ascii?Q?UiaAiwfE8ybFIsCan9bmfamOA7uXVlD/YvgmJsDojNhzBhusxd0VRDkaobBW?=
 =?us-ascii?Q?9uiO8/ZRvVYHiaJKn3272BqkP2fxhdKezxqEP0oNuti19sW6dj9reez0XpSl?=
 =?us-ascii?Q?CC18uiWVMLOAFR0M9fYdLCvDzzXcyBdBwkOZfo9NeSq16EQVJ9NTT8fY5th5?=
 =?us-ascii?Q?WQNAJZ73IghwkuE0s0ClU/8i/vF64uSoW7YxsDx8eZRTWmEF2dSqzp0M5rmy?=
 =?us-ascii?Q?94nTaTm17fp3EwOspLK5z4DEqRPoqsZItzdFmNhuH0AQVDiEcj0NilOm7Cvg?=
 =?us-ascii?Q?QW106Ve/dpFrWP00nb0rQmy9By988tpkDWK83AVAYgFZBxGTDIXtVrAW33yq?=
 =?us-ascii?Q?L7SXCJ951Z3rVfiNaBugoc648d+/aYwwCIWtzOOmSt/Q+0/HaoG2a0uiHzc1?=
 =?us-ascii?Q?axtq3NVE+Ql4lLok79Hu6qEu+ZX6DcFNr+5P6u3b610bIwwEWkDyMPJgPDay?=
 =?us-ascii?Q?kJakLGB0na7wlg+Zv81abTxOJwUQI8t4ydUpWGDw0DQzq0od58RnELAelISB?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5435acad-91f4-4b54-6e6d-08da799ab645
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:21.7836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xomLeixkpEsYK9MrW40mAydYJVJRWtRGuF3fRMiJxBtt1Fj7zx40joN0Y+R7GWwNe7Tt7JFHBiZGcm+KT2xbfUIWYHHi6asnOw8Xhu8GiDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: HJnIaBugrCwzavCggX1AiBnPqjhiiiHo
X-Proofpoint-GUID: HJnIaBugrCwzavCggX1AiBnPqjhiiiHo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were built over Linus's tree and this patchset
which fixes some scsi error handling issues:

https://lore.kernel.org/linux-scsi/1136e369-49b0-c3ef-340a-ab337f514fc5@oracle.com/T/#meebd5040bc360f8c86532b792b48dbe3efe88619

The patches allow us to use the block pr_ops with LIO's target_core_iblock
module to support cluster applications in VMs. Currently, to use windows
clustering or linux clustering (pacemaker + cluster labs scsi fence agents)
in VMs with LIO and vhost-scsi, you have to use tcmu or pscsi or use a
cluster aware FS/framework for the LIO pr file. Setting up a cluster
FS/framework is pain and waste when your real backend device is already a
distributed device, and pscsi and tcmu are nice for specific use cases,
but iblock gives you the best performance and allows you to use stacked
devices like dm-multipath. So these patches allow iblock to work like
pscsi/tcmu where they can pass a PR command to the backend module. And
then iblock will use the pr_ops to pass the PR command to the real devices
similar to what we do for unmap today.

The patches are separated in the following groups:

patches 1 - 11
- Add callouts to read a reservation and it's keys.

patches 12 - 16
- Have pr_ops return a blk_status_t.

patches 17 - 20
- Support for target_core_iblock to bypass the emulate PR code and call
the pr_ops.

This patchset has been tested with the libiscsi PGR ops and with window's
failover cluster verification test.

v2:
- Drop BLK_STS_NEXUS rename changes. Will do separately.
- Add NVMe support. 
- Fixed bug in target_core_iblock where a variable was not initialized
mentioned by Christoph.
- Fixed sd pr_ops UA handling issue found when running libiscsi PGR tests.
- Added patches to allow pr_ops to pass up a BLK_STS so we could return
a RESERVATION_CONFLICT status when a pr_ops callout fails.



