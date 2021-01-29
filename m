Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75788C43381
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CBDD64E0C
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhA2TEW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 14:04:22 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43530 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbhA2TDP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 14:03:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIxNG0135127;
        Fri, 29 Jan 2021 19:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=W2SzudSueDqPK1yt7yfuzAeNlwwijNbdW0U5avUI6LI=;
 b=yUiJhRc8/AUR3NcxLqLuPPq7qi3/DPfYWc9c73hahexG3unQcTsCud806AF6aAbyryLV
 jtyLQUAZE3T8dfuJNLYXr1JucI83nR4lf2de/fn6/IO8tp++k/zVIuJoWpS6G+H6jpwC
 V7XlY2jz70un3nvN69vvyoZGPRlVOWdkCJ7+OmTOEpF+b8uy2tAd7FqVn6gwflpJbU5Y
 JD23AjNGeIZ4CaWzaPKrlytLLgHnQfFkN0Fp8QtL91/oxYcUde1YVIqEleoYfSH6Ai2u
 FC+UUJEhlDw0MWLAtWsElhSFUvUWk931wk3VVt+4KAwdqPKnkrqkDsKv8Ih78Tvns1BO 6Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689ab307n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:02:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJ1HK4088894;
        Fri, 29 Jan 2021 19:02:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3030.oracle.com with ESMTP id 368wcsknny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:02:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXfU4ur9OnuysxRRB3AgQ7DMhWkL5RKFMykPAJNx4kCOTWuW3uwkhe9MMsS/L+lsQIXAKXFOcxN/A6DHfa4BCKFgIgz5sWdqnROfDBm8uVZbj5a+WrwYwMggzQlroGpvCjfRB/OuJ/K3ambAHNH/PTw5vbiY1bEyKO7xe9KHYqZywS46w6WzEK8FESeT9BvTtZCIpTy7+0e00pNyMtL/RghqrF03V6bp0WRC4baGYt/5ErmnxrB2pA2W4C1IqjWwgM9uz5T8m9O3Aw9Fe8MQiS+IlL8Bi1zoh7dGRjnUUW9HF3fSyiqHmbkOE56z2Ce9l7kWGy/KouVgCnMtu1rEwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2SzudSueDqPK1yt7yfuzAeNlwwijNbdW0U5avUI6LI=;
 b=Rcswpzyv58/Ro3BJGKRVnvLPMYqCKXiSr7XA+Jeyt23vleSrXpYrAqWdPPBs4cea1TdVezW7Rc5Wlx8nYcC0EIOBtUxIA1YIJ3Ofv/frE5wcKULFuN12vTXewqNJtXsm3pHDy24EZ8TVK6iJOLq8+kuRNxA/EAKhlKoScMhMelw/o7mBBJq9B2W6ZDF0Htk0yshxj40PwmtVxdWCk1db5Q+s9ya9D7T3LCCOMDolrnqR6S5BzPBDFj10dJzX04RLAoHIWAkN99oJtCNQPFL6OQTQjAUuNqK5AlPJjtS6m0nS9/rapb46930+l5oIdnJxHmPUx5Coh2XNJgN136LIoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2SzudSueDqPK1yt7yfuzAeNlwwijNbdW0U5avUI6LI=;
 b=YLKx/+QvrTXJTxuwTRKlxIWa7FIe5VMG8X9S3xfBsQCwHSOthNYLQFSBENIWEAwjSa2HuCnno8fZzhW+wh8K4GvESOPkUEq13Hv6m9Abtwo7bCgwgXSC65WwA9G39IdkN+NqXRpzTBmvAtJrCn/yHDhdp08hX0VhG1EJ5Yt6+U8=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 19:02:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 19:02:06 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: message: fusion: fix 'physical' typos
Date:   Fri, 29 Jan 2021 14:01:51 -0500
Message-Id: <161194526372.12948.7610888897419763446.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126210328.2918631-1-helgaas@kernel.org>
References: <20210126210328.2918631-1-helgaas@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CH2PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:610:4c::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CH2PR10CA0021.namprd10.prod.outlook.com (2603:10b6:610:4c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 19:02:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3abbd3a2-8c9c-48ce-4cb9-08d8c4885f4b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46778C4F6CFFF0C910BECA648EB99@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fTES4OU9Ih3L8TRGvEywMHnWbDi8fiITE++G5sbMN6dPrzVd0TAxqUaQskBsfER2s0Bnzqbk+5shn1Y3SPN63gZfSd1Siy86rjI7i6pfM7i+bUTc/JHAgDXb0Cv5HPnXh7oYRQ7jtcb9fVRMfkugERFhtC4R/4ECEyptrMayGf/V9y08dyCHfyLsbLOfLnw5q9dHMutr1RzZT8A9xqaHl2PZ3HxujiBArSQCG74OiQietu9jS4z/DedvUemrOlyk/tpluTP2zf3DxkO/Xf2t0ic0ape0/13DISBeIf9S09KLItNTpNKNLD5abivSxjixxPrQqmMnhND8ixtl6Y3X48GgONB8kbiEqZd2fDRkBXZQ3HV+On+nDkjokT1Ie9cbXjS2tZPemAfeNfEBwys6RWTfXwtxJyRf9WGy+6TyHfOaHT9COvnYsqhXwSyq1E1XfF5uSA7IDVWwNI9In57ittGZI4dEnYZrPos7v4wPiN+8ehS4Rbh3Ppm1R47S0y8LetCBJlsmr/9GT4IXbFyYadlHLZG5mEuIcriMvStE0GUXdZTMR+RtVe1Zh571ZkJLNfAqSuGIn4O9LgFBktSOI3Lf62o4tmRCNqVPwc7Hdow=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(956004)(66476007)(2616005)(26005)(52116002)(66946007)(558084003)(15650500001)(316002)(103116003)(66556008)(5660300002)(16526019)(186003)(36756003)(83380400001)(7696005)(110136005)(478600001)(86362001)(54906003)(6486002)(2906002)(6666004)(966005)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TFQrN1h3QW5LbEJNUDRUeVZEZTgyZnN4b09GMHV3VS9DU3RkS250YWs3cUxr?=
 =?utf-8?B?WkxKVEJQdUhPdWh1Z09JS055UEZYSTgvWXI4a3pWRUF6eDluR2tVdXpqZFE4?=
 =?utf-8?B?NkNtcXVXTzc2MWdhbVJLeE5oMDBGeVluenBzbjRBaWpESHI3czRuSGR0aklL?=
 =?utf-8?B?VUx1ZlIxMWFscXU2ZEVpelJOblJFQ2s1bTdjOXFMRnI2TmcydVVSenQyZk85?=
 =?utf-8?B?ay9WMzFVYWVxS1E2TE1wNXEyS3pkRi80VXgxOFNSWitYaDNIVW9IdkpGQ2dD?=
 =?utf-8?B?cnQxYTh3djFiQld3UUxZY09wMXV1bGgyNmNESExZWkdNZlk4TTFzWlB1Kzdl?=
 =?utf-8?B?NTQ4TmM1NHVJcjFCaXVnYWR0dlovV2pIRjRmN01SQXdBN2RBb0FiYXhGS0VV?=
 =?utf-8?B?amg3N1A1ekpFZnppRVV5MEdiWkduQ2lnU2V6UEVTUENJM1RXV0lQRGFGSXpw?=
 =?utf-8?B?cUVHZncyZFlvdExuMTRCTlluMTMvZE9NUzhkS1lvMGtkdUpqRk1yY2x6cGJK?=
 =?utf-8?B?QURiMmVHd1c0b1p2WXp2aUIzYmNwMjBKZGdYREhFZVFzN1lpNTJpU01mMWpR?=
 =?utf-8?B?QnlpcHdQM2JNQ0NLd3FjRENLN2FLY09ESU5WTERMV291YVlXUHIzQ3NLQ1No?=
 =?utf-8?B?OXRnMVlLRjBoNVZtazliKzZDTmU1eE5nbVM0d2hJKyt6WVBZUS9wdEJLblJB?=
 =?utf-8?B?Q2R6Tkd4SVRZdDBoZm0xZ2ZORkF0bytwSVN5Q0FOV0g3NEMraW5ZS095SjNC?=
 =?utf-8?B?ZVI0UjIzSWhzNEFKM3JiSGxVYWtNK0pyYkFwZE9DT3VaM3hyTVdNVmFYdmVr?=
 =?utf-8?B?bkZQcHBQNjI4Q1krRWRWRkw3TTIzK2lLVGR5U21VQnZEWGhuWTI3UFZHbzRw?=
 =?utf-8?B?V3haVmIvdGhrakt4cTNiS29HMkUwNEkxSGRaMGtNWDh4UjBNTkkvQ0FPYkRE?=
 =?utf-8?B?K2lEVVZxWWRCNlBuQUMwWTIrYXVHMzJDdEVvZThudkJsMDBHdVJOSGd2bUhK?=
 =?utf-8?B?R2F1ODJrQ3ZIOFlPamZDa2N5TmdGUmd0UCtNVjljd3ZyUlRHUXdiQnp5NWNO?=
 =?utf-8?B?bnh4RGtsSjF2UHJqN21tbVA0ZWR5bWFpTjN0eERpZFFLNUhRWW1NOWlJVEJ0?=
 =?utf-8?B?WmRJMmczSlRGT0hkRWdEVit3NGRha0tEY1FoY2xhamtYZlNHUnNReEZheHQ2?=
 =?utf-8?B?R3crTmhYNFdBS2QwdW5XOGFHYi9GUWJIR2Y1TDkrTVZwTllMV0ZtekJPRjlh?=
 =?utf-8?B?Y1ZmVXJYRm02MzlESWhsQXpQbzUzOTJXVDdOZC9xS2pyeXBTRTZwdEhMeWlI?=
 =?utf-8?B?MllBdkc3TjExWXFLUDJWMG1Pd1lFdTlpbUpqbjJPVDJBcHFDRFFNQXlPS1lN?=
 =?utf-8?B?QWhIaks3OWxjaWNpbndmTTVKRE01MmdITHJPRDJ1REcydWN4dUlXOThzaWh6?=
 =?utf-8?Q?RG78gvXu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3abbd3a2-8c9c-48ce-4cb9-08d8c4885f4b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 19:02:06.9009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lS5bqcjaDs/ZApVpPlzS50aZphDAP4XX8irIPsFTdxHcAxtThnsMdDIsXvgmTpFyyInFTc5F+UIEmFcBFvC/9OzhDe6uSV+lVRBhTPFmQmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290092
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290092
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 26 Jan 2021 15:03:28 -0600, Bjorn Helgaas wrote:

> Fix misspellings of "physical".

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: message: fusion: fix 'physical' typos
      https://git.kernel.org/mkp/scsi/c/a927ec399542

-- 
Martin K. Petersen	Oracle Linux Engineering
