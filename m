Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3462C47094
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 02:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B70661208
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 02:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhFHC31 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 22:29:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58078 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhFHC30 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 22:29:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1582EMd5074861;
        Tue, 8 Jun 2021 02:27:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=kIn1j2gsnwue7SfCrhmQRSF1CUaqqGVpyfRywA+VHVk=;
 b=cPCfiGTCPliL4HPQYbuLWEg6RlXCBOb7FbgccI16Iw228nX0Gae4KEVL3Du4QZrW/1Ux
 aWLv7knAi7JwwyocYWOg0GqC8jUphbQh1jGqIbUWs6GVs3UYVa7MGV4xh0fWewpLVhU6
 d5TwVwpVK/kyFvXTY59EV4S1pTrBVtArWvG9Ze5WKs9Lm/bAlglUzJA90TXnuGMYAY9p
 egoLwQQV2VodLRdS05V7cdIwwiUfP9Q4Lk/FGLn0VxGGHKTwLiN8ZvWMeDEbRKE5vmoI
 rWf86hKegynyGHJr6ce49p1Lh+iTjLwUdAudDKaO3hxAptrTWh4UxxqQm9rZET1mcC1y VA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3900ps4j43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 02:27:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1582Erc6184696;
        Tue, 8 Jun 2021 02:27:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3030.oracle.com with ESMTP id 38yyaahfb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 02:27:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QjYRx6j4s1GvaJmXz6FAcXJtSIeeCknIVq86QFpvKJu6bwImz8F08amahstDY+RfXmb7PFZXdln6DwquQivsyvIVbg4qZPf4bslhjSE3qho2aaZaaF8yfzx824qDyNJTCq4j6qD6Q6ovZilE0d1/jOpkHSaox8BLXpM65ww/BRnT51U7pGDtkYfEx9di2sqA9Oy8wGc+Reub5hg5fFpWCvV2AXiZf9YxEM3u7gT7PSvivVMn9nVLEwJnfOWcFGmTxSD8dijplwS5NJL01szZp3BQ+vOahqgCtIs5KIXcy3G+h7/0XG2aDKGCiCGeh8G1wSWDi1dZBhvFQ0MNmEw7ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIn1j2gsnwue7SfCrhmQRSF1CUaqqGVpyfRywA+VHVk=;
 b=LD1iyCxn782RCGOTOuLPwjlteLOcILuY7eV/EfhQbzwgvxPmkWoG9YAgxg5sxL1gONUEfUfsvqfTTUs8xLkzMvt7v/xi1qO9AvVz+cpWgL90H3Am5GntF6ADvjWR2dnqeh575ihu0XQkH5z0JSycNW9/YzdmQ7yIo6xZdlni7QHOZ4V+tGVLI/ULuLNGspLDjWvpmhkXI1OxE9eoWpXOUsfVegWbmZa8Tkeo40F3rnkjMYUuMDnE4jEc0LYd2ZhNKIN1irI5ZtDn/HdcvmHqmjQJX2ev2EB0uUsMGEIJ0s86airXqt5BYI98PFjUH5I63AyiuRGIDY/nlx9uWfxIIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIn1j2gsnwue7SfCrhmQRSF1CUaqqGVpyfRywA+VHVk=;
 b=Nukjhtx7HWgXDbHkjH2GRKiqph/XJCAkvFVl6SKcNthCaxgAgWm7MJCEegdSg96b0cB33bGE5Oj11t+uTRK+safVkPOA0sTZfslYwTu3W3MHWJ6UijWXk3bgg7DxiXuzBykpOVRRG8KQ0C3dlE5KDGf+GnT/sVnOK6/o8brzw7w=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4437.namprd10.prod.outlook.com (2603:10b6:510:3a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 02:27:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 02:27:23 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Introduce enums for SCSI status codes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eeddjdky.fsf@ca-mkp.ca.oracle.com>
References: <20210524025457.11299-1-bvanassche@acm.org>
Date:   Mon, 07 Jun 2021 22:27:20 -0400
In-Reply-To: <20210524025457.11299-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Sun, 23 May 2021 19:54:54 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0501CA0085.namprd05.prod.outlook.com
 (2603:10b6:803:22::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0085.namprd05.prod.outlook.com (2603:10b6:803:22::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.10 via Frontend Transport; Tue, 8 Jun 2021 02:27:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d58eab3-5f49-4371-c0e1-08d92a24f31a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4437:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB443783423B7128AC42CC34458E379@PH0PR10MB4437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DUMpWOUiSBFmOCuE2hpRps7mGvYzyZ74qjkADfN3XCBkeQt0ajFcsWiWQgq373zoI9ryKM5yFR/ImyiVCp6KKhwO9zlfkWK9hYQQTdZhcGrB7XWR/VWLdc7jHuEuXLFZ79JDZhkhht/rAXcz0oagKYphLyOLPNpgX2fSy4L7FL87T3xheBRh3AGC/6IwicMFr7dZJbyh+Ka2NkC2q0xHPDYnI3dc1jPCBmFlAAMjRH23m8cz+1FBW3zPuwLge2m5wkBF/B3bDS3kkK5MbPS767TFceLbsgX3lCiaKdTTRcgZtX7Ci5/REBn44uhcEM5TAMRFVGKNHNgBDFtd5iOm8l52H8Paoutafmfa1IDE0OqZnUlOd/45tE0fMy+xG6kNdPVU9hUzET7tzw6+oozYgRm+1ggDZlvNm+cFEcnfICd3gAJgWTuegLC0xOUvTSZkoUwqGC+/EvOXgjGtcVCU3nflNJTH0go4zH21MBU2QGYemqBa+ysUcYbTadq8zV8fPJCOG4Y5C740+MzXGfbx4Dd87vjsL3MtbAKE7ULSfdqaJLRTHuz/HUMUXc6RW7yUA7w7xcsiPklBdWewYDh6CkKBGsTj0mmE/cM/uuGvNFkWX3kXwpFm8D7TNvThy7RwpSlbthOVyGwPPqOg0bFhuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(136003)(366004)(396003)(55016002)(36916002)(66946007)(66476007)(66556008)(5660300002)(8676002)(7696005)(38100700002)(83380400001)(38350700002)(54906003)(8936002)(52116002)(86362001)(16526019)(26005)(6916009)(186003)(956004)(4326008)(2906002)(478600001)(558084003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zA2cJZwjgfRKZK2vfNYVVdfb0IOUqpPCNQ5mlUlJnB46jbIcEw9uzTcnJWtk?=
 =?us-ascii?Q?BQTBGMOY+uVqWNUoupeim8+b8G3JLzGuJJK/k6Wl2dF7KEr05iGntf6bAP7V?=
 =?us-ascii?Q?wDiBfccRVagxNQ7RM/Dej9O9r21PuFVQJOirVIuzdDSmkwgxhCUbhT7oRAIF?=
 =?us-ascii?Q?V5hfojJp1XfXmd5p+BAP60HrDL/OtAUPQmZVD8aRmJ7CDABLc1zg1/nthH5A?=
 =?us-ascii?Q?yfw4iz9xvxhUFy7JfHYInSfP+Zp+ewEIabfVqkiqAIp2daSTu81UBSM3hGeL?=
 =?us-ascii?Q?2kU46532TiFfhktisKVwFJVBIfX++osMNfPO39LqRrGPeG59r0MiIxGpMxaU?=
 =?us-ascii?Q?y9W5CDeHqwMyOlW6gKdKcGxXgbSXxbaY/xkTk67s/wpsD5JczY0wqIi4WXLw?=
 =?us-ascii?Q?54vvRoSsC27PRX+XMLA9JyR10Y6mzd1TKtAYXmCwmiBatlDpA14185kuonJ9?=
 =?us-ascii?Q?QrsV6UH0HTfgbst36P7B5+XHcxMa2ZrB9uRSGV5pwjpDVqsbgIFjgyan5KkA?=
 =?us-ascii?Q?SDl1bT2gGotIw2Y6uR3W08OKquwYFvjQps0skZjXbxliAuZpoC4NXdYxuWFs?=
 =?us-ascii?Q?LZxveKkfthkutalArjcEfzpzRBLJxuFoqNR0RGeWxWThnB3zivE8HxSlC5bt?=
 =?us-ascii?Q?pWrixktDl42yL2wm3soO2AxOWrh9ts2701pYFt/Jy7eNnil+BbzcVwlihWSx?=
 =?us-ascii?Q?7PdykCdBrVPAmaLw494E+OiQKsh+y894qfQBg6wCO6V2JUp6FZBF1v0eaffr?=
 =?us-ascii?Q?rSAiwnOM0+yFXgf1hgQpu7Rm/jk7QxXKjQmLXyyeiXwT+zIrPIoRse+gd2mF?=
 =?us-ascii?Q?zKhJJsUJUO8PJwkCJQBhyZ16H62tr6E+u97Gp0vW0e0PzrZR4zLOK8qjnqnm?=
 =?us-ascii?Q?vya8Negg7F8ZDz/3n47gP51tmu6VZTtbJjTAykeI2PSIFiyGWenFjP+qtj0V?=
 =?us-ascii?Q?YFHaVSDmrp5h6A72KO0xYbXxyASi70ZfE6fGaI2yPPGPIMdBMX60K7bAYy+e?=
 =?us-ascii?Q?CJRIMHf9IeDHuOQWEJAEQQV/4Ulw+MOn6u+drf7fUwjwxy9ZICFcIFxGlTY6?=
 =?us-ascii?Q?2SnisLKIPEtMQeaJU7Lbrirk2LRioRhiKM6sMrOb5rzJ65rg7s0UvJlCTXZl?=
 =?us-ascii?Q?RFun968AVatzrj+Vls0bPvJOsT8uuP6WS0u34jTHprTCxAwbsIkqiTpILAdT?=
 =?us-ascii?Q?KndHIV6n+GJivoRTkRMB2I79esQ+7DEhbAnrwOKSZirYE0aamXxr+5VJzJ41?=
 =?us-ascii?Q?PCCTZBI+gCL8Rkl9VwzCwYPYM+IzIEHyYMz5h4ZqOCLzOMmjEpgRS6gi8caR?=
 =?us-ascii?Q?Qm+lDoayeQEkf6RPaM4c6LFt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d58eab3-5f49-4371-c0e1-08d92a24f31a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 02:27:23.7104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7YB/Bm6cF3lu3i5vWMVYMtprqHx10Yy9CUhLI3tv+omLYQeSqNSggUfpDfhGe85lifbJFjGNx3BEMmBIk1whv1VHoR/T2Q6lqGIavpBdRKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4437
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080013
X-Proofpoint-GUID: i-BAOMbnTwNKVNwtzQQN1ApIrSW174yT
X-Proofpoint-ORIG-GUID: i-BAOMbnTwNKVNwtzQQN1ApIrSW174yT
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080013
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series introduces enums for the SAM, message, host and
> driver status codes and hence improves static type checking by the
> compiler.  Please consider this patch series for kernel v5.14.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
