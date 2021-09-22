Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62629C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46E6E61156
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhIVErg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48556 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231972AbhIVErT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:47:19 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M4avbu021091;
        Wed, 22 Sep 2021 04:45:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xhfgUZYz2N8VCdX8opUEvwlVESVwia74mEiF6bYL6oY=;
 b=oz+FUMrp1q4X/rnUDfAZMah4T93GQmJP5wI7k7fBHkvAUZvRfFqp65NSXw1Wisqh9gtO
 IPvwYpepEXeST+S9vtlfsH6TGjTUzfQ0BiJuP6TDcGaSIq48kzwURWkBOQT8Jt/70pyh
 EBQFaLHCi/JtHm6RFD+qrFhVP4GzsnhQcE95oxtynaGpkob3piJB8eDRrF3pID1f8uS0
 USySNMhRc99DO3ObYVIepKfYtTAT1x1CPkkpakQm0xr7BYoPivTgra1a1t8zQ4b5acPx
 4PafUM4q2V0tQeS58Xy6GA91byaWeLOGzm/H+1nA8NPFcwn0yMqVVRgNzIMQQvKXt6Gk Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4p1c1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4jZs4178811;
        Wed, 22 Sep 2021 04:45:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3b7q5mc7nu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVm9yxFZTJhfMvEerIxTbvv0xT+gVM7TTYEReNTWAfcHo1+/Xi6tD58DWeFBBAk2fz05KPBAU0ZuLD4u0pp7cNY3ML1hnUiMuLm54ufl1aBnXmWxrX63F0LctLOyStX6M1ct+xNOJJqgmIoYxA8kC0qCRO4h9wjRdcXCqRfPPL9+840jShYwsrVcVAtuFZ8Gm/hG15agITQRRL63xF7TZiS67i5GlzZsI99/4mPorlXx2yQopEtdi36hpiwRw+QN3drqLbCGxwOc/4pPEb6YBBkvMHTM0SPwQFSZLd0Yh0CBzSsQTU5MrQRgbMtdMxUBdiwYd0vf3e3jThft+fIY+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xhfgUZYz2N8VCdX8opUEvwlVESVwia74mEiF6bYL6oY=;
 b=cegaUxKiiK8g0GCjxgz1qDvzYji3wG6o1E8oNVygDprLFOsex3SNVHoBKIfqnuree8UIgxttQbyJhTZNJ4N3g6xBTQ9dNbKk4wP8bgAq++1gXqyhd8iXTMzS9Jsiffs4wLiEycgatVUqAPWptH75Ta6eUFZ3X1ySKfOT29LZdcyINkWkHS2qQf9jcZ7k17aYOEU0faVlHGRCRH3bzksXjZlKSKJq+LdL4kQpJR7sySDhfr1F51j3lQFM0Sv1hOdccDQziue/PgXRBniFjLNTNIXcQmIsbUgQhkW7D6WZo1IluYNHqSJx+nZc+0LFNDSxbvK7c4rZ8GItPta5oobo/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhfgUZYz2N8VCdX8opUEvwlVESVwia74mEiF6bYL6oY=;
 b=rk6FVruBFvZIuaw6TfdOQws4rP6qaVwy+7h4MM5ykrgsur1dMOdAB4hrNXmXyWJKEeneZcs59m4jCP8m2ET1H0R26ipwFKiEkEzqdtSmqV6iBLo3I3Atmze06bahwi0trkFqbhuED9Jn0tt0KtRQMXMgwdOwFv4WbaAFknsTh0o=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 04:45:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     michael.christie@oracle.com, lduncan@suse.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ding Hui <dinghui@sangfor.com.cn>, jejb@linux.ibm.com,
        open-iscsi@googlegroups.com, cleech@redhat.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: libiscsi: move init ehwait to iscsi_session_setup()
Date:   Wed, 22 Sep 2021 00:45:16 -0400
Message-Id: <163228527477.25516.7622823180692115909.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210911135159.20543-1-dinghui@sangfor.com.cn>
References: <20210911135159.20543-1-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 04:45:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6671952-573a-4e8c-20e8-08d97d83cef8
X-MS-TrafficTypeDiagnostic: PH0PR10MB4456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4456CF04CBB63D683100A38C8EA29@PH0PR10MB4456.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i9r+XbkywgLKwZdcui0kWm6RBre0xMeZIHYM5dQzLaTRR4QnRC8RVZy/oJ2Id22nZGo0kFWOUBCpC2ZQuQCTzhD6Mi10iLWLgfghzGR7bdGts/Dt8yZR3rNcwQc5EdflbjgI4cv/4d39Okvwx9SehnQDpzCvbwVTN9POUbmUWC66O3Kz1r+pcI22mq/J0kttCVVm5pq2EVV34nGTdZNpceeG6T+2lGzP6Rnbq+7RpPTTr1O/blNWo/cbNhSFQx2uu3iNDWuUDXiVAPjTs1Kfk7snWEPIcDfYsbqffhxMrx1hKX0G0yuZ0avg/hds0i0oGPMC3nTsbLVkuDmw1VT9SgFbTgeJ0PiYsKnQ1/0V7XdFZQs/Na05Nim4hfX116XRW066Z1guNERA2oFenlC4MtoRgf2x5nB/l9PjBlyFOtwHE3uOk2X27Q+Z2aZtnu79nU+IPNQiWKJCbug3J/+i2nTi3Sq6eEGgiSRIulSU+DFVKsl2Ji0GvvNIQ1sM9zRsFOO+c8QEaGVxpNMCOxJ0dC/ZmdcNCFNoOPNzdayqeducdnXn4UtZyjlsayv9pLKqxtg2c9bzaTF++j+AL7Avdu6OBkHTnINuAMXYMB6ABqJtnprBG0U7uZGs3od9dP5LOej8FjJz17oMEKb7Ncsr+FQWaLtNhhOU94177d8KeoC99he3TVERybloSVTHQeHmZCq5bFPXGaXswZXmrOaRf/OoCcxRgpxMaizStFhiZUFf+DIqqe0P+K0juu/NdeGN0+cF5uO0JNbqiR5o/YftkiDVsXFwut8BG+Fmq/+Un+s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(36756003)(86362001)(2616005)(4326008)(508600001)(2906002)(8676002)(6666004)(66476007)(38100700002)(26005)(52116002)(103116003)(66556008)(5660300002)(66946007)(7696005)(6486002)(4744005)(186003)(38350700002)(8936002)(107886003)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nmt6RXB6RDB0NHpiNkd1c1VHQjU4Vzh1MldhL0pxeXk2MlBTT1pmSmRUMU1i?=
 =?utf-8?B?OXliNVN6S2JtWUFvTjhtUzF0dDhabndrNjBlVzd5TzAzY2dYU2lKZ3cva2lh?=
 =?utf-8?B?d3hxb2hUOWp5MUM3cXZQTWp4K0N5UVpXVmlnRld4bnNLcUxsTTFCQm9xSGda?=
 =?utf-8?B?R29jNllaVExqZGx2T2NrRGRDdm5JWUdDMjl1aWE4OW1GbTdyc25RdzNqZjVI?=
 =?utf-8?B?bWFUTHBzb3drMG1Rc1diWWJseEQrUXdXOEdiWHpNYk1ESGd2Z3VNa01Bdy9t?=
 =?utf-8?B?K1R4ZHBxc2ZoUGhDdHMzQVZKbTgrbzFpV2NQd2RXeldsK0k4Nk54d0dBSW9N?=
 =?utf-8?B?UlBvVmZ6bUtDb29MWXJoK2grYXhpanh0OWo5S2p0aDVrckdKdjhiSmQvNE8y?=
 =?utf-8?B?d0k2cXJISU5NUXJmYUNnWVNzL3AvU0p2T3Vrc0lOaHF5czRFMUhWWXdyTmxZ?=
 =?utf-8?B?ZWMrdnpRdHRCRkdzTlhwWG9MblpGaFU3eGl3dk50emVUOFdQNFk1WGJkOXBB?=
 =?utf-8?B?Y1R6eUUvWkhKRzJLOE5DK1M5MG91aFdHSlY2NTVYYU40WUdOakZiVWhXL21J?=
 =?utf-8?B?SUxFN000d2s5bmE0ajUxeDlmTlp3cW5ZRkxLMWtnQXZsUThVNnhjTGR1SW8w?=
 =?utf-8?B?WTlXSzR5VEtBUkdtRTJHRU0yUUJURjhSOUZNc3JHTC9BSVJ6N1gzc3ZqUml5?=
 =?utf-8?B?ZTJUTWtvMm1hU3ZKNVFNNVBtTTA1SEdBZkNLOERHREFZLy81bFVSaVIwN2pR?=
 =?utf-8?B?VWZuYXorWlhUTklqd2hEbzBlU2lob2ZwYXFob3FyenlmcGo5YmpwbkNHcllo?=
 =?utf-8?B?VmRkb0JyelVHVks2U2VMa28wdHFQY3lpVXIvMkNzby9zcDU2dW8reVhrMVp0?=
 =?utf-8?B?VkxZSXVvTVlwbkNCN0p1bXlmaUpNc0hLajA0NDNiTEM3NWVISERacVdsVWZW?=
 =?utf-8?B?dlNtTitLVEdYWkJ0Y1NVWStaTm1XLzNFRDFuTG1KeFkvakxQSThpY2JWckU2?=
 =?utf-8?B?Z0VyV3o4Wlhpelp4c3NtbUJpWFJYL0dOUVdOL2pXS3VocjUreDRxUEplazdT?=
 =?utf-8?B?czVZNmxvR291NmRXcHM3cVIwM1FUYWxRNGxnWlJrM2lEZ2ZTbHl2TW1SNWxn?=
 =?utf-8?B?Uko1SEJOZVZ4SkpxcUY3a2d1K1ErczZPckQ1cmI3Y3pHZkZoOC9mR0ErNndr?=
 =?utf-8?B?V2dESFpvREVVakhjNlc3QTVaRERwa3lVK0pNVDdhYWFBMHN4SGg4cTE1b0Vq?=
 =?utf-8?B?MUJ6RXpLTUtXNFBlZm51SGMycy9EOENrbmx3ZWlyd2RrRlJld0lCYnhrdmpv?=
 =?utf-8?B?eG9GMkY3cW01L3JFTVFrUzlGU1l6R1B1THZWRXNDa051WDFLYmQyNTdrRmZG?=
 =?utf-8?B?eGdFcWd6cTkrVUtyNGhnN1FiZ3hZOEF1cmhjNVRSZHFJNlV6TXA2UFdMV3Ri?=
 =?utf-8?B?VjFKT2RMREpRQ2VINEdMSEEwWWhLZFVXMEowT0ttMDFwVHl1SkxUOTE2by9D?=
 =?utf-8?B?V0Y5ZmcvamEzamVYVzdrcWp2Z1kycnJobFFHaXVGcFRuREsxOEdObDVQS2tl?=
 =?utf-8?B?bWdhb1pRYnd0YzVKWTRYQy9lZnZSVEdMZ2NJNVlOL29UQWFTbVREVnE5QTJ3?=
 =?utf-8?B?QTJoK2d6d25pc1RhemR2YzJER3ZqNVordUpvM25aZXQzWmxYNnpYcHBlbmww?=
 =?utf-8?B?RWtzYjI5aUJ6QzhoOENXNHZkSEdLRjBxeVhTS2JGaEdROVBobXFHNkZwK1dl?=
 =?utf-8?Q?ax4jLFxCamK6YNt0TtRRgkgb44SGqV6HRc/W9Jo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6671952-573a-4e8c-20e8-08d97d83cef8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:32.0831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5KYxnPouf8HThtyVePGJL+QMs3cqKYV+BpdXI3BrXq+T3IaQS/9dO1YK4cPO2B6Y3jXTf1sqwCN3E0i81DFSNKjomOiPh0ZjDGIOgoZpJlc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-GUID: XqUki1mhjEZaTSubAMjBbZmVMNbDPLVf
X-Proofpoint-ORIG-GUID: XqUki1mhjEZaTSubAMjBbZmVMNbDPLVf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 11 Sep 2021 21:51:59 +0800, Ding Hui wrote:

> The commit ec29d0ac29be ("scsi: iscsi: Fix conn use after free during
> resets") move member ehwait from conn to session, but left init ehwait
> in iscsi_conn_setup().
> 
> Although a session can only have 1 conn currently, it is better to
> do init ehwait in iscsi_session_setup() to prevent reinit by mistake,
> also in case we can handle multiple conns in the future.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: libiscsi: move init ehwait to iscsi_session_setup()
      https://git.kernel.org/mkp/scsi/c/e018f03d6ccb

-- 
Martin K. Petersen	Oracle Linux Engineering
