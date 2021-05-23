Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A18C4707A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83880610A6
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbhEWR72 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhEWR71 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHvk24121447;
        Sun, 23 May 2021 17:57:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=PEmGyu4Pair/n+D0pe7JmUAPL3v3R8BXQ1MFFhlvpW0=;
 b=wBPqZMMnbbC0m75B7Xw+qwqcG9Fpnd7pzr4xCcqgP+JDl6xTA3X6GwhN/vShfnSUse3K
 W3YwMH6m24CqiWltVTcuHekJ9BmuHwHlpczaWwSKEtq2aNV4PTAkfKmTNKubQ6R0CRP0
 X/aHpKWvATsW+5xeWd3N4gZduaVZyLnESwytjSOP6Pi+ZRSU7eDnO9fjSBFO1BvDBScz
 sFws+08NjSdcLP16+TM8G9axqhklne5XVGFlwb7sT6tO2tpC47bUp8JCPsHL4ff56agt
 4rtLzcsiSRSZEPwPdaP/r6GIl12dtqhXFD3uISVWa8zrws+2WRzWIeFFc96al6II7cBF 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38ptkp1erd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHtqYn081804;
        Sun, 23 May 2021 17:57:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3030.oracle.com with ESMTP id 38pr0ah1fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:57:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbutTxSA24R/ESGffjMpBSEwI7u3f+TG89X7TuOlyWWoIsiRdL4kl/5TWgjhNfE/F+KOU8NVnR0pSyOPmBp6C1o4eBVuntpOt6iGN+2Ehb2/b4gdPK63NeA1NCyX9R63MsjQzQH1QfppYVX7gn+ECDHFXo9+cPpR4heydCsqlMK+6eauG0oxmVOs5dqmBJoOlT+H0JrYq2socJtTDe2UhfXs3DA+1BzzL9FPbgOGe8HgYDryrWRDUJkqTVQIGds+NV6GDjc9Lpblx6l3UtQfHhBkyMYKtdTapoGi5XBmWjulteL6tN3b0gXSw2uiffpmRTHkvLg5fPXxnNu1LCUKgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEmGyu4Pair/n+D0pe7JmUAPL3v3R8BXQ1MFFhlvpW0=;
 b=K9tXBdxY/11crxMty+M4y4U65B0odDvobJ5qLg3YNQWm1zeIL/5HKXgOyAmpCUm8SVAc/tP9CwjHGZLVLJWNRsNZ7Jx9KSuwTDKngBkTpclaP1wExtqtyKzQMEgL/v3x8Sf6yBK2hBcUOHOejyzSz2qD/4ngBLK/arej30QhEM797Q3jWb7CGhYK395Mj1hF7jqeSHa81kWHfild02wugmi48zMSal9f02PubzVKlYSS9h5uo1B6BBJ7owKF/hZIEczUXrb7OoplBq4sJlN2/5TzLx7aerPC80X7wxMW/HIwRBJwygjXmx/+mDJ1affO1kz9DubT3HQl7diieiLFLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEmGyu4Pair/n+D0pe7JmUAPL3v3R8BXQ1MFFhlvpW0=;
 b=mDqTAW3ne9axA9QgmRhdha/ZWJ6+A3zA3wxbmopgbFaonKjxSwJaLJS9yHMSNxYRALJptP0tAPgghdTFJ/zbPK9HeSwf3j/ebN+swaQxyI9E9lspu/ZoUXYk62d1kw8Hf+5cRKRmb2A05fUJU69IP27KNCWmKLogPcnvm/aLY80=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:57:49 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:57:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: iscsi error handler fixes
Date:   Sun, 23 May 2021 12:57:11 -0500
Message-Id: <20210523175739.360324-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:57:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9eceb6a2-5c35-4b2e-7b2c-08d91e1446c0
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB400477E114C50D5851AFA1B2F1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZlosStHt/Sxh7PCOnEfvIzTpsJzrhcdSadCB2PJNrIEK7h5MdtW7BWzSEybEBtUWZCx9lsWK+LUVN+pfYdk/JTtYuJVR6M0su+yKuTd61A2aKh5j4MHwUyRJV5vTSJyaWoPN4i7uOj0N+L8t6hO7ponIt/Bjf2WnGj0RpbbOfj/KBTIVPRPJjbKz9crfFluk1+vYoY/xbg63fLH3iIMMeBurYa8m8y7Jn5sKpDDfYQTemb4MoZU/DWWbPRpxAn1hq0Se0nR1lZ1ka/EKJJM5hIah6KNZY2JmRmFnnZ85IRoNKmF7emx8BrBDw6ANFbIv1jDxotGeUtG6ZdunEmK9xGxIyfwz8J0rgpeU9FgG4kNI7cod0I6UO0afG0p0IIC4Agn4i7hxoKuRYqFGNnoXWwBQW3zkRGbiadRNgTRGrYjiAr1sY4ELhRq8NijahM48Y8IeFx347T9/fCl8+tV5nlGmC1pClmhJwsemOuZdfIBgJTGsvaEqgDXMLWR2oHg7WVjfK9ul8VCdWCKDqfMOzXrfeI4ameHAX8wBxpLYIEmDv9oRlAGzuUK9NvrUhCyW0UQATO4HDIslgD1kbVE1WZd6nBQ2vvQ5s+3YhDSxc/PGJqCf+2GrjOMU45/sbsvWvHecvdWbPA9ONXF3i5fTV+1Bcii3aleFaRbcIMhOsCZc18+4OVIWhykyR7ke3HE40nXgYnwcnfyapuhjF9zNF2CvJdxjPmX7oyDBj5sxu+ViXKnZxm2Fo9VvYBNHi23pEK/gpbMF/imXUghi3GNK7L7WJcLHJnn64SEckWEfGhIuSH0GRTZLbfcQxr2S5uxklpnx4H00gHZpzZVwh0hbHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(966005)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(1076003)(8676002)(6512007)(6666004)(3480700007)(8936002)(38100700002)(38350700002)(6506007)(316002)(52116002)(69590400013)(158833001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ATQh7zia7akyTP6S/WTYoBSy0xvLe505TzGIVUVSwVBibBnurV5Z3z/5kGMT?=
 =?us-ascii?Q?ICAequGIJzFvTNKkoZDK+eNHD1nn6COieBmogRPpHSTO1kFvGVe5tsT0CNQP?=
 =?us-ascii?Q?FIsZ3zq7y/Hwn6FuD6sTW2XZwhUDeuEAWbPnHi/Ch4tdMrkqJZLfJyNvTaBc?=
 =?us-ascii?Q?E1GxyqqFBKLkh2PHew1fc4H1gbgzERcKeJYVc9NQKG5cQWLTI7PdrghGNUiP?=
 =?us-ascii?Q?mcSL2kf2X3kRTiAcAfsnx4If49svcf+VNqTBMfdalG04gStv8Y3YNinJ+diZ?=
 =?us-ascii?Q?U+1KVcpG6yI3A9Yf/XAQoYbIyKfH3AQJyuGCqxk3RRFpKYejDIAblVS92i8n?=
 =?us-ascii?Q?AZx4BtZ9ZLPoPCDpJ3GKruWdwL4ErHycfyxdqga68s7e+hualrDdL32+K8OR?=
 =?us-ascii?Q?ov4YhSkTgmJ8mAjxvdeKu084lXaaNv8jwbbjDgwHAfqhhpkTrSJawJJtDQH/?=
 =?us-ascii?Q?0bR32lFW/LkTQwlfxgMCaJL8T3iN6oHypA65dwM6XpaDKKqP92AQs6DV9M4L?=
 =?us-ascii?Q?f+i/eSp4d5NLpDdmSvTYUnf7M8pDp/N4vHfzuzSgoS1XSL68TRZmx9E8cRrq?=
 =?us-ascii?Q?qIyZ0CWMAmD2kYlskq4pciPe4aNToV+YXHsGt9hLSPeZGydAwbyi0qifms/V?=
 =?us-ascii?Q?ZS768SaO9AYITl813jOJfK6nmm99KDRCitKAdgN700Dft1XqOlDhQDv6Z98o?=
 =?us-ascii?Q?jURm9w+1AEJtSd2KjOqnYdsjvsrnp/liX+j1fD13ga4wwAClo0pKD/WSbLve?=
 =?us-ascii?Q?SOUsYOTvWjipmP1XgS9d39FZgwDkIduiZ68UtrWYk9De/bUfuNfrmlGesXLM?=
 =?us-ascii?Q?cAmMIFLNSYORtzbU0p70SuCSKWvmLJkRHYVRVs5wcdOcoOJyXu8tiB61pOGb?=
 =?us-ascii?Q?zT42UyxL6pSwGuryMibtz+4H+AAocGExYV5hLcdLPlXcK/1UDGH7ZsJCkAIo?=
 =?us-ascii?Q?ZbEr+dfx1itBpkQOIwvV5A79WaHG1bE7N79u9W7jD1YISmoItnijxxG5Hp/M?=
 =?us-ascii?Q?DwjmbYwbVUqyGZCRDuXcWgsMa9fOJB9+nw8lnFOmevvuIO2PKH4efyXEnli+?=
 =?us-ascii?Q?2aman0hjH8XSS+Fe1lJnJv03tksuBysBQK9lqBF3KhGopNcKQZ4Js+Vn/qGj?=
 =?us-ascii?Q?y2Nt7TAkHWN2BvusO1MOEALwwLPJouebe+J3/gWI5GoH15EI0nf8CrDwiPMn?=
 =?us-ascii?Q?hXYWEfpC3e/nhhSqipwgYqYEkhkaLjqbt9YETKgB42jUCwUS+4Stff5VcugY?=
 =?us-ascii?Q?lc/ytEMxSBZTuRu2+uhQL1vmfWc2C9S0UN063xiWsELML2HXHS8dpGgLytiz?=
 =?us-ascii?Q?zouyDwJLQcclCJP5h3QQUW05?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eceb6a2-5c35-4b2e-7b2c-08d91e1446c0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:57:48.6823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ibtab2Uzv/HoyfkC3sqyBMtZgk/aX7ah9gcNNrVoSC/CjOb/FE8JZxJCk4RGAJGO9wvbkayUVmMF5AVtOpzXefrH4XTXV26emGkxDGuHdNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
X-Proofpoint-GUID: _d0mWqr_6bnN4Z7AyrmzPz3YjI0VSah_
X-Proofpoint-ORIG-GUID: _d0mWqr_6bnN4Z7AyrmzPz3YjI0VSah_
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1011 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 5.14 branch. They focus on
iscsi and scsi error handler bugs. This set combines the 2 patchsets I've
been posting to hopefully make it easier to backport just the in-kernel
fixes.

in-kernel conn failure handling fixes
-------------------------------------
V4:
- Fix case where we get multiple events for the same root issue, and userspace
and the kernel get out of sync due to multiple stops/cleanups

V3:
- Rebase over
https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/20210424220603.123703-1-michael.christie@oracle.com/T/*t__;Iw!!GqivPVa7Brio!NdLMhOLAuEkbeyD-V8vbq1PDCQp51g1-HKalQU_YRA2dNB9qsEP4DAN8HvS0Dkwpflw-$
- Add fix for if we are doing offload boot and hit a conn failure at the
same time userspace is syncing up it's state and doing a relogin.
- Drop RFC as google has tested.

V2:
- Handle second part of #4 above and fix missing locking
- Include iscsi_tcp kernel sock shutdown patch

libiscsi and qedi TMF fixes
---------------------------
V5:
- Reduce number of error events sent for the same issue and handle
when libiscsi sends error events before we evern have a valid conn
binding.
- Drop tmf state check patch because we already were checking that
and qedi's session blocking was just plain not needed
- Drop cmd wait patch and replace with conn refcount patch
- Fix case where session reset could access a freed conn by grabbing
a ref to conn
- Have libiscsi handle iscsi_task refcounts during aborts for the
drivers

V4:
- Rm unused rtid variable in qedi
- Added a default case in TMF switch just in case people do not like
not having it.

V3:
- Fix u16 initialization and test.
- Fix bool return value use.
- Added patches for cases where EH is running then userspace terminates
the connection without removing the target first.
- Made patch that stops IO during ep_disconnect more driver friendly
by handling if the ep is bound or not.

V2:
- Dropped patch that reverted the in-kernel conn failure handling. I
posted a full patchset to fix that separately.
- Modfied the tmf vs cmd queueing patch. The RFC patch only supported
qedi and offload drivers. iscsi_tcp/cxgbgi do not need it.
- Added patch for another issue found where cmds can still be queued to the
driver while it does ep_disconnect.





