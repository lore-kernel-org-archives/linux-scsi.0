Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF2DC3DA78
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 21:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjAQV0G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 16:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjAQVRo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 16:17:44 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A903A442C5
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 11:39:53 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HGScqR010515;
        Tue, 17 Jan 2023 19:39:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=a6uteaSc3TyT30rJ0amhovoHrd6Hq6CGVadGUAMrQ0E=;
 b=1ZJ9bwhJEYFv/Vi0AMw5PmF1YqEl8S0Rp9tkvJZy6EnLM+gHwk0UQR9roRTlAGF0mfeH
 Q/V+0/UTSScoh9W2chl/28ESQJsV2tvAB81efxgL9A6AkVTYiIYq8Ubqp8vxcEEpWsYx
 /vicqO1aLqbSUiB4f/ognVv2xvJX1q0/hanrPo4uiSxDHrmfBQ8TqXnQd5A85CQ7yQEv
 cpgQNLiuqhJQaoiRcuUIlHnQt5ZBRqUTFifvQkTGET6/5dD1XWVh40xotu2+z71MWj8X
 GxRkGCO7Le7UYZ19HZedvlEV3ZURZzN6kT0uJpHgTXhMfo5VZMuhRrRAipIqkAzq0fpA UA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3m0tnr0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 19:39:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30HJbWCr015239;
        Tue, 17 Jan 2023 19:39:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n4rq4shda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Jan 2023 19:39:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FovVKPBrYk+rJMHLjvIjlqOjJ4gslAjCNTvCCA7Ti2fcWWLU4TtKAOdwAuGje5MjjoRrCcxVhQY7qtzBaW6IlYnbSqzFU5Av13N7VOuBsQO1rG2nOIKf1p2y0++NiWDZDHIkHOKmfRV7Zw/4y8Io8Z4q/rWu+Y4hG1obev3eLF5/rM5ywOcRAXsMe7VIuRCxjlO57gVdgKhcZQ6eKF8wondG9h9xDRHho99l67HmDOeI6Z5fc8Kbi6enZCaVqQSRKfCigjd4iUqTdB4kVSK1Vwd+rpZfHQc2kpnWUtwOAyEmUNWzCHo1eyXh7JcZitxUPqrlM1S9qw8chFNdSPKxeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6uteaSc3TyT30rJ0amhovoHrd6Hq6CGVadGUAMrQ0E=;
 b=UNcPk5SRljpifeav0USS++tqgUvdMjrnMHk0thnAN7Y9BMB5STFGqrO2nIVBOcuPLPmXNX1ZUWNTC+UtpmKruFlULvrBI8Rw6A6UailXSCCqDLDiER6qHtciBNL9yG5o0XGTSwX+VKGUa4haQ73DWCe7fqb47lDt0Y90Bt0b+3/yDGX1Rj5DZ/qfoAVOCmAksInXhZaZFk84S09gCqyRnSpE9ggE9M0f0zgvsppu82Ju7D+0/EVlD1fhH9UP4ywO7NYHMOQRJOeST9yDWPlQOjezPjypIv2yFIGl1/I8q6/4bF/XkoKabXzOT0bUh/gkVA8P9wLmNRSOsiajFtpeuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6uteaSc3TyT30rJ0amhovoHrd6Hq6CGVadGUAMrQ0E=;
 b=seTeIB+yKvtYTmpbw1q6rgP7n5pjgHQNanl1NfVJZk9gsVD7ZdMawQHTLYd7yu2gVceedRaZv8KlFqR+w1fiKLsT3/0cPN4Jz3xbUdbvGtXj5Usv1KFiDrvwLX1DLHZgF+kH3Yi+5iTyT4j6SfKPM07Vd77zKAgSBQrxrDQYr1w=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB7222.namprd10.prod.outlook.com (2603:10b6:8:f2::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.11; Tue, 17 Jan 2023 19:39:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Tue, 17 Jan 2023
 19:39:39 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     dinghui@sangfor.com.cn, haowenchao22@gmail.com, lduncan@suse.com,
        cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH v2 0/2] scsi: iscsi: host ipaddress UAF fixes 
Date:   Tue, 17 Jan 2023 13:39:35 -0600
Message-Id: <20230117193937.21244-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0082.namprd07.prod.outlook.com
 (2603:10b6:5:337::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB7222:EE_
X-MS-Office365-Filtering-Correlation-Id: 32b96f5f-2473-4801-0b4d-08daf8c2928a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 75xafXG4KIXQiCWR6Yzoqpl80HQuJrqpNm6FbNcQD5kZllMRwNHpL4FTzXIjZaej8CRz0EWb9pFKeC8gcykSbU66etLWpUsgbJqu1sfyXBAgdOzh0HnLqxpAuH7iVTzHOKXm+T8XVsyG1vEt/hQs7CImgmosOFqwtjPOZlA2E9PfY3os4tvH+NKlKhPWXx61D4s4DS4uwjmIQ13lfDJplwl1w+vQNFg22btXykZy8FfIBF6FxHRz2vvKdBqg9soY7Xi0s+MyUoxYc/+vd1kpkOYr5qt11A36KU+pazF2tzg2FdvvUBI73YknSmOl+z11oj4y5tRlb/VHAK3Kl66ntpO46EGxbBV0N0ts38aCDKD5omtulNI+3OYav8wTIyBYGSb/9jdviorieKeACwW08WIPx0SRklu+GBpwtFUNJgROtPxjKEpRH8cHf5b2QA7/s8KfTIvWIRmYTYy4mvW/YJblRdQgNoF5QT5WkXnn8YXdDix16VmZJ6IQoaNxUOddXJjOOyco0Kf6H51Mrs49TOYlzLD8RIxWkAGk0JDqIbiayqY/WXX/pScp0FGkOSrIUTHp5ZPoKE174g5Kvb8Tz2BWgOO6GDFwjD0Hh+JvCM2OdcReb1xqDZywtcATS9ZTPE+PWRd9D2gBqkUk3L4jtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(36756003)(83380400001)(6506007)(6666004)(4743002)(5660300002)(6512007)(186003)(2616005)(2906002)(1076003)(86362001)(26005)(38100700002)(4744005)(316002)(41300700001)(66946007)(8676002)(66556008)(478600001)(8936002)(66476007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qrUKPYVffSaOfnta+PRwqHHRQ15EGeZiAubqu3qgpfZ4TuBRIJJilwY0iE2C?=
 =?us-ascii?Q?3jwSd7LISsp2cq1KDFoT9qtDKK/XSxmOLR0eO2/gYr7FDdZh5zwqabaQB4rY?=
 =?us-ascii?Q?hBaCjJnx/ew/vV32aU/OnbGoso/N0p6DDlq4hNp0lFJaQNvCWKm/uDGHzJpj?=
 =?us-ascii?Q?noipG48d+/updvL1oBMzjZstZqf1ryhFCppyuqpjJEWdFH03qjcSz/1wRHYg?=
 =?us-ascii?Q?mn3irKtd/ks/tnJPy2mZFYvWt1b1lMYhSWsmbjbmERBNPpgFOsuU/o86QfLO?=
 =?us-ascii?Q?23HSrpZNR9VwU7hJ/AnFsd78EkGP0Jbx3kpJeISbyk76vQnA7DCMxlCn5b4a?=
 =?us-ascii?Q?k+tNx8uOEQhlJCRPPvRSZ6BeHZCcOOXaBQVN6TFmQixWWT8xplU+p1hTxoi6?=
 =?us-ascii?Q?MniVIBKwtAoC4MYiL8PSXmPJuCyKdTOxNFZK3nTNoZt1FpSnbnmWeRAqoFCQ?=
 =?us-ascii?Q?1+zhroMnzST0rrQ9qTKsBN2TPHNgGx9zHjs5lVUyH+kToGvOjtrF0BM0QOog?=
 =?us-ascii?Q?X0PTDIdlihQk2tIg8WMOqd3yiyiPGTVLJ88fJbaSH4+22sAuPy5YhbypAjii?=
 =?us-ascii?Q?F3nFeEig8dDjfCZDeG4C+o81FKa1vWjEpWVWvHPZ8C8kaMBJ8pPvP/0JO4Gh?=
 =?us-ascii?Q?3DFJkgynCBkKAA6BwJBT8CblPuwuD4muK6/2tAEL3He9ONuA4Jru1ZG7tJ0l?=
 =?us-ascii?Q?fWlr6bgbX/QZlK0zE939dg4VIuqsk1WuZGs4JO/HUf2ujF03z71KaWNitPUf?=
 =?us-ascii?Q?/X2YjGcBpvJAwx7tl2VclLTjuK0TGfPm7iVflL0yGzgUypiShn9bxzcXxEjl?=
 =?us-ascii?Q?Z3FBMkendhQ1czEVFUQNAyH7DzWMlQwHHReVGwiNs1zd98GQLerLQbGMLPN+?=
 =?us-ascii?Q?ChdSDNvVdFnIHnvn83CISYWM9BhEZW6xOVm1cTOFTDcOP21FSdI38yeo3GEy?=
 =?us-ascii?Q?Jmj3t6bVlsa81Rik5U8BqB1uGRyZFaM+COYWUYLi27KkTER/fnP3wU0SNkPP?=
 =?us-ascii?Q?ugI76ysEDpKDyzASmRzmvXdSrJ8al19qtGGXCgktJDR2t779AD2NUum8SbiI?=
 =?us-ascii?Q?RKb+1ujvYXjPEfedmpRBX6giHMw+PoEATotFrqSThs9X5v9qQXAnSaXQhx+j?=
 =?us-ascii?Q?9eHBYHCWkZIQGVYBbI9Rb2ESMZQ85pbN0biIvAZMP2WqLrYumnMngYePYCpg?=
 =?us-ascii?Q?RIJSYDztqpGqgKaVOESb3wh/SOYSgQ7woyr1HapXAC3DrIJ0D1gGNVl9q0qM?=
 =?us-ascii?Q?J4isfBzuSdoQngEAPF1JEmVBoW32/cJ/dyzC9hMAlM+asqyCe6dLTIroSfdt?=
 =?us-ascii?Q?zDWdo5JV2cHegfvM2QpFnftJwPWSJ3DZEZ4s9i6ZrvZaghubpKm9nR2JjSaF?=
 =?us-ascii?Q?15d4skby4u8SBwIXzzdPW44qdGx9DIZXhzXcWsM/23hsHwOpAHrUOOXVl6aV?=
 =?us-ascii?Q?dHgZAZzSiWbCwaapx3l0ejbJqttDU2Ju2d6gZ6Gi1DD+OmqF1NT4lgdarU3T?=
 =?us-ascii?Q?2VyOCNx4CSuEZsS7sP42nppIdBmB3uCZ6TgLjv35l+313Zui2GbRho3ZM9z9?=
 =?us-ascii?Q?cS72xolEDbFq2WszaA5VRMVDlC1+swpliNfBncYa980gkBLe1yRvustLDluz?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AY9TY+Y8rEyXmOwW3MoCBftil4KhZ7FD97DMXvt7v2DfnbaFWlgiKSQPsfpo4gA8TCJgJL3fCMBa/B8NVxBWlRGfqCoEZdDOiNrf0Az7dfU+yVVEu/WBEWuRjqAOy9tpFdY+UYlwqZapFiCHFNU72zBIFa2FNgabEUTXiU3RXEnTk3Ni3pi5ibQ/8qyYSHEcZGbKriBjdYMvIQtJt+5mcmg0dR2fC48UvD6hnuOdVIIb5YcPueJehF4Z6EAPuepESCjT6X6YOXDijE6E6lx0OuDGE30eWpURYn8HhxzdHjHX3nHTtsM5sQf8GHp8AImqQuoTKOi/q54dieQMV9NDz0ukQ0niYznLj8CEmZI+ufGtyiwvQZWTu5hAq1/NASUMT96Y5mc/YhItQ4uYM8CjLO5tZn6ZbF+5t8qZXlPuFTdInU7fbQOZiOGGwxGJETfSPZ9iehRuC+ZY3RznDkX/Fa+advMlUUvOf7EH7y5HyATC0zOgA/zLZZFvxrJhCjGlq0s1WhsSaxXEzBnRQaRHh9As0ATaLmC1Q2PxEmUoPDufPY2onJtaZIyrUknsSxRhdGIbz25jOne6n4LwboCrw4tZjW+tho9p9qYyOzHobZFFfgHwm5XqGphH170bhMK/iYtPovdfj1pFz4kZwW1i9xonzU9ofYNq2rDelV17DusxDePtO89zi+YX0FcAZvW8hYxVPh8bvVk8jK+R0aosF2fp4ETOndZQAYQW0MID8cxejrUtaU5aOLbT9yMIIdYxzuRIAuWOn61C0JwV67Of7d0wxlEilQEHQ5K2ygM8BnODYd1HuwQ6wR9JmOCPWFYn+Q3h59VhjCpbqhWpVzUFHhfQJUqS/Su/+dr9a99mq/Vz9hQG9swkIVln8AFH4x9N1gP/Nkf9k/s6FBda8W7b5NImSdMTnTqONbEfExpwKkA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32b96f5f-2473-4801-0b4d-08daf8c2928a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 19:39:39.3929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TV0eGoyY3LF3D2oDAzdOt/OJ48SrlGUKujYmkJ3wD+MzA3TTS5HyNRqlY15/Ha/PPKL5YDsdJWP8ulRT6ArZPDzqAgJL+loylQDHhQIK6so=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_10,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=947 spamscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301170157
X-Proofpoint-GUID: 7Ol6rj6G48Hio7ZjnEtzgnv5EYYhUnx3
X-Proofpoint-ORIG-GUID: 7Ol6rj6G48Hio7ZjnEtzgnv5EYYhUnx3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made apply over Martin's or Linus's trees. They
fix 2 use after free bugs caused by iscsi_tcp using the session's socket
to export the local IP address on the iscsi host to emulate the host's
local IP address.

Note that the naming is not great because the libiscsi session removal
and freeing functions are close to the iSCSI class's names. That will be
fixed in a separate patch for the 6.3 or 6.4 kernel (depending on when
this is merged) because it was a pretty big change fix up all the naming.

v2:
- Fix bug reproducer example in git commit message.



