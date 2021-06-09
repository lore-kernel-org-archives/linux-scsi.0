Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D029C48BCD
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 604E860FEA
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236529AbhFIDla (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41940 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236451AbhFIDl3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1592fqEF020330
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=AELhd8EezmbyKa/7/lb54+PUyKaSWcHd6i6H1JHoTXQ=;
 b=Q8RhHgnvjMwH/awqdrpbDHrwbb+RWx7e09wFrPeY+6690R0NYDRFivYND34j0xI6MISG
 2G6UtfNyPBiU+Aqfil7F8hbC5KpR1cAcIgel37RDMXrRvV5u2X+3A0tDbgyTUpv4zTKk
 9/bnWSNfMVABQVP822g+o8fPMDz2ECvzdgBquWFEa5QiwQcbws+ljRb4JVHhcjBjc8Mq
 LOKkj8wq2E3oNfXAPDwnRU48GCsDN+QmlrQ+Cxw44yndvsCMMYNjMfrWp3/0XVbniN5P
 aqOLd6RZA4oUEU+jBfnQHeAdFht0WSVHz4KYKcJ7uJCLlfqwhTeR6/wEv6ri31cS34x/ iQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3914qup8u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z3gv082802
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:34 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 390k1rhr0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYF68C2QGxdy+lmnRsO8QYeSrPgQ3646ddWiBrYQkCQVBEH5wGWM36XghrPkSOVOkb1QCZ88y3aCKxFsuxQXOM4KE6wOx6+NOdhoq+yWIcd2TxS7k4Sq1NCTSs1SIPUtu9pzRg0f3ErAkcyutskviarMyO0YF2M442XZieNX8oJVahtBHi+0VGx7aDl16QMmGtLy4LecxP3mUg3pNCBz9iw2q6DOqCBfQwyP6EJdU0V9hd5cYcpKRkX/FhspJxGYF0dQFJBKeGnwvFr5ace0STyl8qAhAcGbgyspo25+MPzyjWDBQk5RyUZLQ8hHZfoWypsLzu4zSDjARcOlV3KJiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AELhd8EezmbyKa/7/lb54+PUyKaSWcHd6i6H1JHoTXQ=;
 b=b92k86iQrf/OlhPbpsGaDfNf1ioMevvfKnKCTg+HhbFNveMGZF2VPbW4Y3lKq8BGd/CHxK77o0B0WcPdqHTmi4a78gvrtcSknVqlJgc2NJx/2QftgPw9CWARWB8FOMg6nohHqWCNZr1dMkNHI9CfRpUMjZjOgW+IgqcJttGrmWiHyd87oIPwj8Pcrq0nj809pBqrj0r6qmAHlcMKzvpdiYeHtYHKT7PTYazdKsWOiDHhOZQ+EsQHGxyBLMQV+I7vYynIfPstPCwEuoRa3DcBdo5Fj5qvqk2jbBWEbWrMXRvFtTN1MLhH27VSCQzjf8FD1W/XgZTyw2zXqmBo1oPEsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AELhd8EezmbyKa/7/lb54+PUyKaSWcHd6i6H1JHoTXQ=;
 b=MvJyVDI2gRGDj9PtlzRJn2DLWQ1GWYVfemIHE8u9tQvzNpEBQMWuPu1SL/KAp1fYNQUYbAD4dfh9di3m4TtqVjwtz/mKpcv/7A0DRGuDYROZzPedPaWHr9wJWEQoHPvOGckonXv4jvn7/WTSTfT2EEt10lSatX8cF+bkaYOPJBs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4422.namprd10.prod.outlook.com (2603:10b6:510:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 00/15] Subject: Protection information and block size cleanup
Date:   Tue,  8 Jun 2021 23:39:14 -0400
Message-Id: <20210609033929.3815-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:806:120::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71d21e97-61ee-499c-f74d-08d92af83193
X-MS-TrafficTypeDiagnostic: PH0PR10MB4422:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44221061BBA6A5C9B1BC1C238E369@PH0PR10MB4422.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tRUqGzFdnd4rqs0ez25negPR0pKMLM2Z/C/SLMa/mxBimyPrX8d5/B4LtCySFKpDayR0+JVlSFVtPgKcVGnUjBBJ91E4MdZaI6GP2agLSbkTUp7uQBLnKupg0r+r1w3ezJMxlE1nnSF0I0H2MORawUeLa9Lw29WnYdqPynQxKqRVqJqBV57VUlUq5cGYGotLbzBYANZAadv6JXjhivkS7kroDrVyQhuRCNKGklXkZbgdAF0yYdq2I9EcRu9raKqZ5YwXz3Q6Ty4ZBqzbRpSoAqmJxpJrSdn/kWYmr98JKGqeiRJo4ucZRhlk5Ai3rFOTiAa0Mg1HcKWdOXMxH6Pn1mOIZXlePfe/kAqWOAIgkI/R0nGCouCiNt0kPsRBTHeybxRLJ4bw33iY9TnBGXZXG8LBZ4UUvNghaH630Tfzz/8S56rvLPN+nAx6kgFxZ+Yne5LuDweW9V4HAwvmV5xSJFW3K6ORAom4JlUFOat65fy9Hd4F38W5jebVhsmgiCjsxBm9adb7W56+rDXbpwAZTGwR40DAG1aMVRoS1Ar2cHxwabARh/pHTnV4k2uCalX4+hbSlvput2u8zBmd7yg1YHvNDpeDToEjdCpxByLC9g9qSnjzVapCyo+60KN4852mL1EoVpmksh2Z3UwjXGDpvi3JhDZrl73sRtaqgWJCHPR6Pr9SahLOzvUQ5BSfth2Wd55wYXZIq9OjbkM8XLpWsRK/i0YZS9Yd6LoQPmAd8qhWa22m/DN2LkBZ7ClwmfmNUHrulxxsmlrA0C3GJGagalnV5Jse1v+TSGKCGE56Y8vvMEz6Lasv7VB2IE6MFZb4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(1076003)(4326008)(6486002)(316002)(8676002)(8936002)(66476007)(186003)(16526019)(107886003)(66946007)(38100700002)(6916009)(26005)(5660300002)(52116002)(478600001)(956004)(2906002)(2616005)(7696005)(83380400001)(966005)(66556008)(6666004)(86362001)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+09GDY/E8Ie40iEgy2nBFJyItYkCJ8JZFmypKgUgFtRbqu3wSYZOBdhHmAtu?=
 =?us-ascii?Q?kk2rb5aAfPg2+zG38pWpXlqE75QAyCYMoj5GtRJlAXZ4SCUI6aOuQSR5xPrZ?=
 =?us-ascii?Q?tMPBnfP89QUlgCQijXuwnUFE72439u40KjDSHgzfwPzin4s2+c7lgjA1GFD3?=
 =?us-ascii?Q?g9hF0v8rLDSsOHja8Uhz+oAcs26ue0bpxiAgw395HCNl0u4EmdeLgVA1OPNK?=
 =?us-ascii?Q?ntVVgDM2Q65zlxJ+9nhqdJXTG4W21bFDZ8CBtYAA/ZY2K5oF3wInul08CBry?=
 =?us-ascii?Q?+iJQ0xHQWczuFrDLbMFzwg4zkSOQ/sXhyVbCUpjw8b9cVgYvAVWxuxj4nfg4?=
 =?us-ascii?Q?BV1IEDQtKj60MISEgLqqd3vlxXvTIiFPVJdLNn7v5xa3gxWTBZrURQfE+m0u?=
 =?us-ascii?Q?B1ALiwEaWVQRtGzRS+q1v18Xeb1EnZTUqBEWC2lw2qHhu687NcoT1rjdckmS?=
 =?us-ascii?Q?wujmd/LJALeKSUUGdQpon4BG+tLnqukuXba8QjDI8j8sa4uAClmezM6NlstK?=
 =?us-ascii?Q?n8disQhxwy1Eq4KhoyX47FupPsACO7Q+9iKyOYazGMdDmF64pjSq+vaEuJNH?=
 =?us-ascii?Q?sHAoks6WcjIDSR9l78q13IKaQoZkjQVvsLdKeahz9CaFWQd+EaXaSgQ2IFv3?=
 =?us-ascii?Q?hGH0zJjz4rRARd5wt9TnJOP/bu+RfZP+84FhJv5eCBa1IDE9q+m14ONQfJZQ?=
 =?us-ascii?Q?fZhoi1S+CRKbZtk9aV68NCj4QGpz8/ad/duuUqNMPvg6/Dui6O9vhwFGw41o?=
 =?us-ascii?Q?iLBD03m6S+aY9y8dUdORmUZpHqpKr0Z+3vNqoSi1lEQ6tp9WT5u3kbrJoqvU?=
 =?us-ascii?Q?BrsOHn6uXryY9UJX3cqT5PAy8gFUCFrVxsqtjsG+hZaeofoGlgPBq/HAi5nZ?=
 =?us-ascii?Q?99JzixPfs1z/nHBb4H1aGkkdTUOUMEgCVJ3OUHmz0ZAUpRn2tnPz+krsZA4F?=
 =?us-ascii?Q?dWfOp9CXBG4hgv7GSUen8bhE27crkSMlGHGOO0X2NHYr0aUcGEgSlg9ROL7E?=
 =?us-ascii?Q?Xc/9n5SHoXCry0T0ePoBNJNe30XQK4A4Rhc4VUy+rALM6IBhL+tw6Chd9Z5H?=
 =?us-ascii?Q?X0yi28T+EDYr9d02RqoAEi5Rcp/S+4RQmcewFTSUYuiVnbiZ1PjcDK0K6MId?=
 =?us-ascii?Q?JKbeO/MGyVSl0gKv71vTStv26UEwtZVOK4PyasQdwnRCm5rtcVy+nTx6gQ68?=
 =?us-ascii?Q?XhzBPspu10p4thqTigfJY9ppP1k8KhfpoJFQ8F65+Lk2ifW/M5bRLBOalCvl?=
 =?us-ascii?Q?LS7A44LduOEp8rHEncK1kdxqzTCU7k1MBHTDkcodFud5gFbylPCN3TCyTHSv?=
 =?us-ascii?Q?L5zwfZ0Ev1wVzaFStjlTDOCM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d21e97-61ee-499c-f74d-08d92af83193
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:32.3295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tqGyfZ3a7g6Be1/E/sPUwKX1fZ4kjbnFZkAR8ZGnRzVHgZRbE13MA1weS1cW14z9Ft1LIHtezYE1mc92noigUu30SA0gC/0BuVlPxVOoawQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4422
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=962 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-ORIG-GUID: kP07YDaCT3UKcEs2LavvRRfSv7Hr6rkb
X-Proofpoint-GUID: kP07YDaCT3UKcEs2LavvRRfSv7Hr6rkb
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series cleans up how low-level device drivers go about handling
protection information. The SCSI midlayer provides a set of flags and
helpers but not all drivers currently use them. This series updates
the drivers to use the proper calls to query things like the
protection interval, reference tag seed value, etc.

In addition scsi_debug is enhanced to validate and store protection
information the same way as a regular PI-capable disk drive or
SSD. With these changes scsi_debug is now able to pass the same PI
qualification tests as physical hardware.

And finally: Bart's recent series [1] attempted to clean up some of
the confusion between logical block addresses and block layer sector
addresses. Part of Bart's work is included in this series as well as
some fixes to the remainder of the scsi_get_lba() call sites.
Sometimes it is appropriate use sectors, in other cases logical blocks
are a better choice. For instance when printing something with a
reference tag given that the latter typically contains the lower 32
bits of the LBA.

The changes done in this series are also meant to facilitate removing
the request pointer from struct scsi_cmnd [2]. By removing several
references to struct request in the various drivers that transition
will now be easier.

[1] https://lore.kernel.org/linux-scsi/20210513223757.3938-1-bvanassche@acm.org/
[2] https://lore.kernel.org/linux-scsi/20210524030856.2824-1-bvanassche@acm.org/

--
Martin K. Petersen	Oracle Linux Engineering

Bart Van Assche (2):
  scsi: core: Introduce scsi_get_sector()
  scsi: iser: Use scsi_get_sector() instead of scsi_get_lba()

Martin K. Petersen (13):
  scsi: core: Add scsi_prot_ref_tag() helper
  scsi: lpfc: Use the proper SCSI midlayer interfaces for PI
  scsi: qla2xxx: Use the proper SCSI midlayer interfaces for PI
  scsi: mpt3sas: Use the proper SCSI midlayer interfaces for PI
  scsi: mpi3mr: Use the proper SCSI midlayer interfaces for PI
  scsi: zfcp: Use the proper SCSI midlayer interfaces for PI
  scsi: isci: Use the proper SCSI midlayer interfaces for PI
  scsi: scsi_debug: Remove dump_sector()
  scsi: scsi_debug: Improve RDPROTECT/WRPROTECT handling
  scsi: core: Make scsi_get_lba() return the LBA
  scsi: core: Add helper to return number of logical blocks in a request
  scsi: lpfc: Switch to scsi_get_block_count()
  scsi: ufs: core: Use scsi_get_lba() to get LBA

 drivers/infiniband/ulp/iser/iser_verbs.c |   2 +-
 drivers/s390/scsi/zfcp_fsf.c             |   4 +-
 drivers/scsi/isci/request.c              |   4 +-
 drivers/scsi/lpfc/lpfc_scsi.c            | 116 +++++++++--------------
 drivers/scsi/mpi3mr/mpi3mr_os.c          |  59 ++++--------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     |  28 ++----
 drivers/scsi/qla2xxx/qla_iocb.c          |  84 +++-------------
 drivers/scsi/scsi_debug.c                | 112 +++++++++++++---------
 drivers/scsi/ufs/ufshcd.c                |   3 +-
 include/scsi/scsi_cmnd.h                 |  25 ++++-
 10 files changed, 182 insertions(+), 255 deletions(-)

-- 
2.31.1

