Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2597C48BDF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7828D611CD
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhFSCXr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:23:47 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19536 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229591AbhFSCXq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:23:46 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J2AtpA003330;
        Sat, 19 Jun 2021 02:21:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=BtxtwIn1qIg3wG1SARKJFucvpNzhOC0xfyH2FdwEQzg=;
 b=M6+7ZSwakgI5YuJ30s9ROFURyvDgw0/dGeeVQHXQzbGaIiaYTHzIK95VK7UlTt9nr5mg
 7MJVUKemfGKoD6/95CidHhWzdd9hhm2PVsTfh/AQmC3wlWiuREHtrXs2F1tyik6T2Jep
 yP8fInx6yrB49UGs2XDQQCNgiTZEiOlmvzrTvWzIp99xtOgyDs6TfVu3U1Y2ebSxujo3
 /HAL7KU0XfN76Hp7+xQmAR9+P2pOp53QhznI9YFHsFct92ITS3Ro4VJy5EH2raJ7OysS
 f4vmOLRekCGVfrie03vn36bwjJVj4N7ERqYesia51KXC6UTECw3qePQuvlmyBnb9fo0C /A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39970bg0vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:21:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J2FStn181619;
        Sat, 19 Jun 2021 02:21:30 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by aserp3030.oracle.com with ESMTP id 3996ma1bwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:21:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rpk1F7i1auf/WHasu8U+/BiNypXE1kZUqrrYNXp6ay/Awc+PRk43C0kShH7xKO/ktczyqPCKUt0pdy9uHRimybmqVxlyax1VoywVqpxyRQbvvOPXQyA2JuXBMn/DAMQ4BuofyA4knAQc09XMKMvJCS8LMKTISSUWqZ2O6Rk/P8265yrObS6o464tOX7izLGZAZ/RysX6LqMLX4ayo2M2/PzGiOmSIT0tjP+Q6v7W6smO8p8U5kaMo3l0tlnUmEUJlZAzsE2HGf/LVjqmMRT7c46r5BtMvVj4cXMwwczRsqa5n0wQ4Ao0AaOUBnhlXTbsllLFGqxw/QtJcGr98ogezA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtxtwIn1qIg3wG1SARKJFucvpNzhOC0xfyH2FdwEQzg=;
 b=FGM6+VxEZp9N+VeBszJs4AgGutHuxwQNwBJrQ8/AMGjyiSWDDrnS/PyYjQgn979xZbRufl191qkIIAHZbxnAylXdv5N3p1uxW3zcc4B+zn7VUWW1sgqZKk3TyVfNrSfp8wf6exALLsAZWFO4HjTX011lDE90LTIska5Xi3K5crw3m+fszKvg4OTOa/WkTF+/l00jdCoQ094gi9fi7oR5C0l+XmOBpwTGnSi5tUVs/ISL8UEQoPAvpXXcuo8OqO06WkH8ePIEXO1h4MJntuvemyjW15tS8Ran23fEUdWOU1K3zMRkplqbJCMc2J6m41u+c3hVQ8n4UfR89gbk+WN0aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtxtwIn1qIg3wG1SARKJFucvpNzhOC0xfyH2FdwEQzg=;
 b=nXQq0aGbSU2hcLvyglz8/grAvuxlcd1J2W8J6F/eKyyuOEvhleOLRYFDcbR01JeXycU+fRfCXRqczsaIJybrLa3Gj6JngBy7NG9bqy23yTxMutPv9ecDBAzB6n4WHDThYWkiIK2TARjLb+FIiiGVFcE3v1vkhjd0WONEzyi6iww=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB2000.namprd10.prod.outlook.com (2603:10b6:300:10d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Sat, 19 Jun
 2021 02:21:29 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.021; Sat, 19 Jun 2021
 02:21:29 +0000
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 1/1] scsi: imm: Switch to use module_parport_driver()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r8y1tnj.fsf@ca-mkp.ca.oracle.com>
References: <20210616142429.45373-1-andriy.shevchenko@linux.intel.com>
Date:   Fri, 18 Jun 2021 22:21:25 -0400
In-Reply-To: <20210616142429.45373-1-andriy.shevchenko@linux.intel.com> (Andy
        Shevchenko's message of "Wed, 16 Jun 2021 17:24:29 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0089.namprd13.prod.outlook.com
 (2603:10b6:806:23::34) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0089.namprd13.prod.outlook.com (2603:10b6:806:23::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend Transport; Sat, 19 Jun 2021 02:21:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8d38ae5-d84b-4c23-a9a1-08d932c8f23a
X-MS-TrafficTypeDiagnostic: MWHPR10MB2000:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB200003FC1705E87BC3FFBC188E0C9@MWHPR10MB2000.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FLwPyzfsaCvIuYcYRhRw0ejDyCWGxiY/KTFlUOB9hSqddOT13e71pvJCzvNnweh8WwE+OZMnUMMSjtlG5NVOhiXqPPMwPHzPCZHP+yCoxstr1a9YEDtgijWlFie1YQi4J6fpmBKTXCd0ZICMjZ04vEOWKaGJY2DB/H6Y3JVVnUKSoWV6vk50TLYwkM6Xe4Nwb3gBICOSAycrV9BEVnyt6syPNVnRsRCP6H0JG+fWMRwCzA2FuRT7Ur/qHMQJsUULjOwNfMH4yJoMTAa+PL//4c84myeGakPdZ/1yFDCMyjz7dza+DRZ9nBFnuJB+RbCUkOkpeu9GXvpNzHgMp8tdjQYp83NPyVlzwy2szEOuI5KF36Q1llIwqZqWBnjEIiiAja0OubKZDIUMstxsSYR2txT0dhS7CyNZgnIscNWVYG0Vh5z6ukg6aajSPffWVeA84zP+kA0DoctRprJqsLUcfZ8ASX8q18Mq5DhOMEkD4ooe58B4e6hgZLJfYn2p1n9AAbxu5FVggTU0EYTLHpWoxYpOUn5qc8XWDf4UJks3rlEmF7yDL9QCQFAgCn92UMcOmgCiG6sftDj2VSIpkSVVynnnpeU0qn0QI9Tz3WZ4pbqjlLdD7U9XYLHCM/JsUsf+lwyIhc8ainrGw5cFGh/hIYDtlo2xDM7RTule8nrMDNg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(39860400002)(346002)(396003)(66946007)(86362001)(478600001)(316002)(6916009)(38350700002)(7696005)(8676002)(38100700002)(8936002)(5660300002)(36916002)(107886003)(26005)(2906002)(956004)(54906003)(186003)(16526019)(66476007)(6666004)(558084003)(52116002)(66556008)(55016002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OzAvqZEX3Gcv6nnaFPZgXLOg8zD6V/HlP2HiLhhfaZjzjcqBEeRwJAI5MMaW?=
 =?us-ascii?Q?ej1ZUGyZkiasdqp2aZPVkDqHekEQKWAHnKd7WhkXaKJqKOa4IN8YvC3QE2Cq?=
 =?us-ascii?Q?emarXwg1MGUTz4cE8HGA/8pktTbpNoF1IJkFPSybFWCGhGCpclt+4rqVHfsx?=
 =?us-ascii?Q?Su+ZTS5TijFmTSo1unJ2DkuwkJgWgix8NDzsSjuBac7UAs0rzrVdzJYR30wO?=
 =?us-ascii?Q?vPbdM6MAqxJ3ULTKVG/CLGsvE8HOW/FSfuR6yvyMRtBUwTqXyoi8IBBGmxRJ?=
 =?us-ascii?Q?QUlWDXowQYf+lu4heE38FgTBA4ZJK4OlI34bJry2GyYL1I8L4oxTNrSCD3LL?=
 =?us-ascii?Q?W99xGqWel87WFBnEFdNquOcuCdY5miFxz1OoTlir+G0dUe8Ra18f325WP+e4?=
 =?us-ascii?Q?5UNj6Zy7ecEVLbWsbaSWZZLLF4f2DP+6vREgZdpg1DJmsRX5o0jrd+r7M3sr?=
 =?us-ascii?Q?1A1FJ+108y4aEt3DJC9q6YjGu7yAHrmq4YjKDiEAUbGCxVgonz8wKGYhJKrG?=
 =?us-ascii?Q?TwlyxnT/581YJECQLGyCr/QKJGiYvKVnUq1i7bc51lmuuxq+vQUWI3YVyXF8?=
 =?us-ascii?Q?gSduYR4C5oe7oTxkpTD4aZDHgeEeLiZdixCYynn5z7jDIQS94Lg7clefp/N1?=
 =?us-ascii?Q?iRxJan3KD6yTL6eyfo6TqNMRwhPp2aCn2DgDtXQH7MW3+SvriwtTLRNJjH+m?=
 =?us-ascii?Q?ut5u3fDZt9Tjc8nqG34nxELFLavDfVOhz1bvy/WYbSY5CX0cezk+89YYObdw?=
 =?us-ascii?Q?gYieoAvQmJnzJ8/m5h5xjbSGHqUxky2u9q+U5jz3lJKKLol2kzQWFjjPlKII?=
 =?us-ascii?Q?g4MTFvy6OUcAqEmDMmM58POEghHQfjhyCvByhiSjtVb1qWxBhwkIr6kh/k6N?=
 =?us-ascii?Q?e2eKrlJBL0GP1lCRi2Ma/WB0WwCZFmlQ4JvZ74T+FMl7tVqPMvw7+iXf4eIn?=
 =?us-ascii?Q?J+pfvgzUC+DYEN729vzQeIboVcWuwz8O5Iasqo5KibcAc/zjn7AHFHUYco8Y?=
 =?us-ascii?Q?qGWDdooBzVSrsB1/6kor70EogjOX88KRKdLjg9cwqbgKdWlvkdnhsmxko+sw?=
 =?us-ascii?Q?DtPwHXVuNOu/J61/VVGRwO5gTOrKTJdFD4gu5uI5KkTYUOovHQn/EANuBYkh?=
 =?us-ascii?Q?TZJpSOXqtxMDch6rORLYGfr4HLlLZPri7Ym2CiV/wmS2C41fEO412cl3EKJb?=
 =?us-ascii?Q?Na7Bsa0G82S8sab5NoxD6nEXk/YLMMyW07r4PB30XcmwP/pOYGlUukDvj9jn?=
 =?us-ascii?Q?W/hG8WyD8s5SCwMJdC25ZfbQIc6Zi00WhDAolIpxY1XV46h+AX3vhKn5Tb6N?=
 =?us-ascii?Q?VxVli9FOz15KlE+nfPNCCWjK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d38ae5-d84b-4c23-a9a1-08d932c8f23a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:21:28.9260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HYNLUOaBOUqkXLU0EIeOgBmw5TKq0lftvY4WysCcOal7XDMzKdFZE3wBvnCjd6pEV0MRXGmickfhNqK4v3BrcMprf53YBLprcP9xOTLjhSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2000
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106190010
X-Proofpoint-GUID: Gjdq4tFw4Qep-EjN2gOOlsv2wOGCCloi
X-Proofpoint-ORIG-GUID: Gjdq4tFw4Qep-EjN2gOOlsv2wOGCCloi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Andy,

> Switch to use module_parport_driver() to reduce boilerplate code.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
