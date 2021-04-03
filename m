Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9FEEC433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F64961360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbhDCXYF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49668 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbhDCXYE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NKbUt160403;
        Sat, 3 Apr 2021 23:23:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=bvrf264pJG6rNbHjYL3hDtaQpUE5pdKdNBL63wLVNZE=;
 b=uTWtULVeDRzOJOCRrN0bo1eNOXtJByq4yjr7JHGF0Z9EIMuWNB83Uwsevg7AYXa7eerw
 QWmwXmzaj9FdJAUaZJ1Iz1ESSAO94QlJhdwjl4QapPBccvKe2yzSSO5nOulfHq73uYvC
 d+47jdbOtrj675QYdgALBcqxZx9XMjO+K7fkctiqy8XYbSbps8rrh7KokAreBhidQ7WA
 KEB61F74Yly+lnXM5zvoNvajpUVZJMQQJiWm0Rt7QMVF3WTzyLzOwYqJVd1d8bjXMN+i
 xVE85XGFX95MDy8GNBQl0J90CefUTR4UuTTNVRKC6oY1VmiXpDjpRJuilFBDf9bu2JRM GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37pgam8rp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NL7lc130247;
        Sat, 3 Apr 2021 23:23:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3020.oracle.com with ESMTP id 37pg61hu6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:23:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hD7G58ZLS1I1GtNeALgiqAB05JP5KFMoEFfmGw/0AvjbmSoFX3HJmnkCXEyYgjmRZusZUWw2dTAx9BsUK4uE9UubECfKJk+mTptqwqJeDB8I55s9uInkrHX9JoTBbaS6JPUon40QVk2sJkHV+hRPebBU/JWhQBxe7K8wrBkU2bsKVcyEn+wCsUvT6HKFjriWLGl7/EMxdlBjzkKpWw7qPSk4urGTK87iE9RTYiOcG51uXuj9f5rYWNHIIkZxMnFTqnBLPB2U0ibn3tqS1beovUabrB182Cf3lEHunME20xq2zq56zCWJWAVzgwhL29YgxbDhaYrYM+3DWMsFPZ8DyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvrf264pJG6rNbHjYL3hDtaQpUE5pdKdNBL63wLVNZE=;
 b=BDikSO6X0axSaCcIP8UeF2s/2Dqn8ieYNOBGVVZtK2UZDP4ehTcK+5zs2aZJvZKJEodtcjRXv6dTklaNbeZOkro5ZlGeNpleiulwgZN2BW/2el18tC8YEHpSv9REZTbvDKDA6hP9KqP7jc3zREFEZhl+R+eYtmeLIkeb2UZ/luL403hPTYW3PGN5qL3RBV1RQJqx3Q8mnMq1D2nYswNVGd0f/BPhwu2lahR/ShMeFu6p3La5brqeRED79vaG20wgtVG6D5wVGnmpa3SYFUkZ6/T5QdJqLsJdBcuF7P/4eANFj/aIpgshPj9zlA9Y5UqaLE9cw5TNsAW585RkAsZV9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvrf264pJG6rNbHjYL3hDtaQpUE5pdKdNBL63wLVNZE=;
 b=U5mgSY+ag+oDLoUlV+2f74CXhgF7rchQkND6WMBVncVe1DiqMe8nvDpt5/Sn05EokRV4EZORyMatiobnq+kKe8tG9wpaaGNB6vONBl4ZF1XLIBCPX19tZjbUgM5Sl5U2QcAw51WBF2VWy41IrNQScUxxkS22k+EmbYXvsfpgbNg=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3368.namprd10.prod.outlook.com (2603:10b6:a03:150::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Sat, 3 Apr
 2021 23:23:44 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:23:44 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: [PATCH 00/40] iscsi lock and refcount fix ups
Date:   Sat,  3 Apr 2021 18:22:53 -0500
Message-Id: <20210403232333.212927-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:23:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07902753-19a0-49a9-a301-08d8f6f785f9
X-MS-TrafficTypeDiagnostic: BYAPR10MB3368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3368A13035BA72B3294CF640F1799@BYAPR10MB3368.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zeiOvCycIlMT1sMGNTcdwe2APVlACtNc7W4DlthmPH0N2EL72bbSjxdO8+JH921g8eK4ZI3c6q9mZuoMvAgkRuqpQ8YaJtV78Fhg5QBr8/z1H9RvSam4WvOBMW18gcMai+47yS82YrdRFA/+RS1xhbn4+dx5g7HopRTPJHTyH1hrftJTHW5qApm8kVglP7k5u9/ZJkXXgrFr2OGYBePgvTF/1DB2U5GatGJhnS+VnS69hm+94nOIfBjGmQMYEsmvjNovz8yfPDIcyJn9qhzTfqqceuoC2ji2R4Drk/AAuYW/NhdpTUTu0WBHEoHxi+Yy5Ulzhwvdd9GK8SpmD3Z3LkNvHxZKpZdx1MO1y6Pnqqvl5c9kz2vD9uyZpeTQQ/PXz4paN1HbVTUEqfDUEHRtUGR+EoTRcQWlc1bUPp8PO6foQbc9EfKYrsiUPOKNchNNw4I3ZvCPyApTEVCHy13rb6denTIqymvWK2RhUTm9Cftlk800LioNCKGXfT5vlNev4UvXhXVYBl/UIqKKzsOJBT912G44KTX1LssHYCI/cQdP8rZEf5kg+9izSA0dEL9Jbpe2C4QVssMFQ6npvKd/AV5WxPc9xqSuDk3aipy/aJPJoBU1agmC+NBkgRAiEMVD09Yqc0tNPRkokbmIEFKsCtfaP9JY76XT2MhrpRvsgjCcGl+bW7fW57If2ceM29sbE9lCEkQqZKJmA/KcfZP8tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(396003)(376002)(956004)(478600001)(6666004)(921005)(66946007)(2616005)(83380400001)(8676002)(26005)(52116002)(8936002)(86362001)(38100700001)(16526019)(316002)(5660300002)(36756003)(186003)(66476007)(6506007)(6512007)(2906002)(6486002)(1076003)(7416002)(69590400012)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ptnMvNCxHocxgAwQpQSgSk0WA2skNctlSemwggHXNacO+7215AZTLaK6zzXQ?=
 =?us-ascii?Q?t56l94D5rj17clY0tJeZ3hsKtRTF1i/h+l8dMaedMmzXJj4GFJsxV+KhAy6k?=
 =?us-ascii?Q?NyiGgLXDQrcFtzeKkVPx1klkEqvyWJkzKUoWrfzNvZ+qT1lQ4eg7i22nEFRm?=
 =?us-ascii?Q?TN8mBiieKIqfGYyHgD7yuMXg1DMXtabrzJ7s2S9VNqKq3dls8OzQZXm/eU9T?=
 =?us-ascii?Q?fDZhDbMoyM2Ei27KyMhoijMrpHAocm365VHC2rfARTlHYffa5JTyD1MLUwYI?=
 =?us-ascii?Q?drDS4IM8VjNYTefCmyJcbzWHcOpmpQsV/eQCpzBg31whFUcAEiPM82v/UAbv?=
 =?us-ascii?Q?jhgT/TWcG9QMRWxrmo4bJM2NEv/wk/alTWy4WBVnvySY0v2uq3PSePb30d3c?=
 =?us-ascii?Q?rfP1hUiqo80Hu6pQhgskLZcrQxLiMa9C3mWG810QbGmDAQk4sh1i3EQskIQ1?=
 =?us-ascii?Q?7B4jLzpIHq2dQ8sdHq5BxuU7gRgzhm9gqe7mOrx8Y0vwkcLzzjysxTcYKDVM?=
 =?us-ascii?Q?hLxXBWF2sjJ9eciIjz7tVr15t8v/uIN2TxgaaEFmrzqidPx4d5JUzBb0UI4a?=
 =?us-ascii?Q?2pwwJ490k2iw3oPCJ2uC0CTps6N3AneQJGZmiARkMJXRQHniYa6zkwSeWE/C?=
 =?us-ascii?Q?qtT6OYZqwH25DwmmnAxCs2BJaNYrJeOdZWz1MxYynvryuTXJnx+SYidbcQgE?=
 =?us-ascii?Q?R4m5sgWciZkoe+lCbLD/U+5eUZDwgOElqgDHMRMrCIBMUhPe9SoFiiqfId2p?=
 =?us-ascii?Q?7J2CK/xUyN/WLgitPk4R+LcgN7WC9C8sD2UTZorWXTxIOFq2ikrk/EofzU10?=
 =?us-ascii?Q?OIgIZLCvU9dXnjGzuX9WpRhWh7DO2tW8GdKCqcP+gapI9FkQXf0IiiReKjbD?=
 =?us-ascii?Q?HWsI32wnUUcQ85wdj5s7zw2pgK5sAW7CFFgWKAbHqbO9tVcGy2/ZpxexMVsW?=
 =?us-ascii?Q?EU5f6WOMmlP/RO12g9IwbHmcqumXGTle9aNpgbp+Pmb6EbCM8/0qw+hyOJ3r?=
 =?us-ascii?Q?4FCWmCyEfRtyOSpPa2OYRGZpmzx0ccOf2MsdMFxj16tMleuufc8SB/nLjv42?=
 =?us-ascii?Q?KXVXcn84oYuEmoO0nktUZCGRq60+1YWYwNttAUFdIp/767hAXh7dAbIZj/PQ?=
 =?us-ascii?Q?d/4kSPyN746wbo1egBXIrLBpHDU5Cay2Fgcx9a3kuJ3BJLWLHHOPukyJFhzo?=
 =?us-ascii?Q?4duwUjY0cKaHrqPq5x+CCdE2HtKKorAM1zfSbi422U7m1nKVOmXedJXGVtHs?=
 =?us-ascii?Q?FHn6MpX28xXJFzauGopUsJB5XT6eCspEneLaQ7IH33ayo/5XxNKL7i1kQe/G?=
 =?us-ascii?Q?IvJZ5ajw/pnR9i6XaIjENkht?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07902753-19a0-49a9-a301-08d8f6f785f9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:23:44.0158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z9hDZwah0hdHUY02+qe1zxMtViX6vctSy5jY+7B7H3D8/3D4p+goqarrSuM+pd3XH1Y9cjY8grS8krUCRIKj4/hQZoLfdLZ8XCR9EC0inp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3368
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-ORIG-GUID: n9UgnWkba61Zc6d8SLq_ItijXZUIb2cZ
X-Proofpoint-GUID: n9UgnWkba61Zc6d8SLq_ItijXZUIb2cZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1011 phishscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches apply over Linus's tree or Martin's staging branch.
They fix up the locking and refcount handling in the iscsi code so for
software iscsi we longer need a lock when going from queuecommand to the
xmit thread and no longer need a common iscsi level lock between the xmit
thread and completion paths.

For simple throughput workloads like

fio --filename=/dev/sdb --direct=1 --rw=randwrite --bs=256k \
--ioengine=libaio --iodepth=128 --numjobs=1 --time_based \
--group_reporting --name=throughput --runtime=120

I'm able to get throughput from 24 Gb/s to 28 where I then hit a
bottleneck on the target side.

IOPs might increase by around 10% in some cases with:

fio --filename=/dev/sdb --direct=1 --rw=randwrite --bs=4k \
--ioengine=libaio --iodepth=128 --numjobs=1 --time_based \
--group_reporting --name=throughput --runtime=120

I'm still debugging some target side issues.

A bigger advantage I'm seeing with the patches is that for setups where
you have software iscsi sharing CPUs with other subsystems like vhost
IOPs can increase by up to 20%.

Notes:
- I've tested iscsi_tcp, ib_iser, be2iscsi and qedi. I don't have cxgbi
or bnx2i hardware, but cxbgi changes were API only.

- Lee, the first 2 patches are new bug fixes. The first half are then
similar to what you saw before. I was not sure how far through them you
were. The second half was the part that removed the back lock and frwd
lock from iscsi_queuecommand are new.




