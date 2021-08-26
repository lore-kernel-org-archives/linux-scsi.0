Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 073BBC432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 03:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2C2B6108E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 03:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbhHZDoB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Aug 2021 23:44:01 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:35782 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231720AbhHZDoA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Aug 2021 23:44:00 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17PMHXSd006322;
        Thu, 26 Aug 2021 03:43:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=EXxSxk76woJ5lXv3Avr/4cKaAGBqLnmSlDwpwCVcTrc=;
 b=zWTG4Wor7N1ZDn3YLLMQlmoy43kOb577DSpyhu0IEmvHR422RykzuKcRbWg4foNmiix8
 zZejMrqc1hrSUpKdYRc1AAm4NMeIntBRa4YcVqQ3HKp978aj7hM/NryVNY+ZNTNKC/Lp
 9YwMCKjFHjSPSv7HMSyxET6IMp6sNjXBYxwFxtQ/cVb1swHQ3aDXZ5BGvNXWekE+hhhn
 uU7B/5cpkGILe4BnjFSZ3aUzKcj/kMawN1cg8CR0UCCK4qDlKSQD3lSR5OXgQaqqJaEL
 L9JmksmhbwaiX/cHKo4l5kAYdys1a/FRfWkV++he5qZUvbf/VOwNh1j/jTpWfvbQgtJG gg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=EXxSxk76woJ5lXv3Avr/4cKaAGBqLnmSlDwpwCVcTrc=;
 b=VGMjJH6nJK9j3xj7TWREEueNCQH5YFDNCXTYmHXQwGsYr/B/YHbB02ozggl98eiUK9DX
 hgYMni6BjoGOTHqK/MpA3e9VTXEJbi3DHUnnN9ksME7xPX9eIbiUN7oS5k732EGy8tkL
 BdmyJQmgLqZXc53IfxHuhe609XnsuRyexqfqhUkjJGa27dF/nJ5aSFXA9kCDBLwOehnI
 LAABvavaXZEDBUMnSRmjpChn5anzZ24Y6Cep6oEHyuGtI5wAFP40pWKTQ56X+NKxyN5L
 GACevBGfehqeBBt5Y+ygatoTqPA5D4ot36fv9pCeR+cR88cTtsKukFIV7Ag7jX8+RyWj JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amwmvd5de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Aug 2021 03:43:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17Q3Zf3H048776;
        Thu, 26 Aug 2021 03:43:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3030.oracle.com with ESMTP id 3ajpm1rqht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Aug 2021 03:43:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKOKiGuTgtrdqDqxVlvDDSu/kshftb0xejPy5dROUjvlSwcMapE+Fwd3JXfE1FVX9rH5FiDjM8FN2XsFEhnnCX00rb+Xyr7W7aYTrT9kCwUj7pwoQ2X+zheTdC8dxZK6JKO7b28CuR8XVDbgtbrL/PrmKZsMkMxkk9YzUnNaR85GF5nTQX1AGWFem2l1E9eTrYgCc4jF0ucx70cIQgWmEi7in4F+aqcH13lxt8zPdwp1C7QSs8TKW0RhTpvs21SEmvYfqOA+Yh8nVkc6DAyJIKqcJGQqO4vbxkheXYn3Jm4JJezggKRJvUo9a9e+weiNcz2ReZWRzSdvIXzQ1zbWfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EXxSxk76woJ5lXv3Avr/4cKaAGBqLnmSlDwpwCVcTrc=;
 b=C3eXxikrGZfTJQKWZsxMp2TKuq1sDSkpsGqjqqXOJRQKxgjNOdMg+NiJNxpVBRXVIVauH8LgNVVq1IGcmiKonzpYw4LjIPKPpVKJdhVzyGV4JfsgQP0vapFHKN1QM03QbSNeFrSqFeAEbvqI1RzFCXogM4O1K4CMqOJtl3QFOmuVqfWLnrvvaec8SmcjjEgNdpYl9OykxJSDpLX8A8Iit4c8jQowE/jjLreKDIGgxk3umA1E2D8vwq2T4zp+89nSd4IEUknx5UhTMrMZwKawB3ug21PpWGWeI9I7dMJAW1BuqxB2UrwHWCXeo5f4RUTTPjORO7zji+IUWhuWrp/VPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EXxSxk76woJ5lXv3Avr/4cKaAGBqLnmSlDwpwCVcTrc=;
 b=cnPy+NPfwoDLwtgB9o7gnE6OIOw9YPVi0OjYt3t4m2RD4mcUlULPWiUP56rmQILHM5lWbmfO69+fSGhEnG30NwF2tnXJnXpTWQ88cQIPaj24P4issgMWAog/TgR69k0HhULF0dqW4giyzhwrQkLlJNtRuh1oKohLz66YjGBjLSc=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5642.namprd10.prod.outlook.com (2603:10b6:510:f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 26 Aug
 2021 03:43:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 03:43:08 +0000
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilzsannu.fsf@ca-mkp.ca.oracle.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
        <DM6PR04MB7081E6B85744B1F86AC5E7CBE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
        <yq1tujd9bwg.fsf@ca-mkp.ca.oracle.com>
        <DM6PR04MB70818AEAA6539E3834519E9AE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
Date:   Wed, 25 Aug 2021 23:43:05 -0400
In-Reply-To: <DM6PR04MB70818AEAA6539E3834519E9AE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Thu, 26 Aug 2021 03:09:11 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0016.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 03:43:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f87cc39f-558c-4e90-c200-08d968439eae
X-MS-TrafficTypeDiagnostic: PH0PR10MB5642:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5642BED227127841C11CC84F8EC79@PH0PR10MB5642.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BEmYa7ynrqpIbYQWartERMZs/jAR1Qi0ni8jbJjVqCq2ur7wDy/vlOROsXIZVZAjsY6szPIf67ZRbJcDDq+tRflmm+eMDX6HZDaKhh/9s/JjtytTfNvSvh/hs/FtPx8bGVdopc1e24PBwSRMPGAXHn/gFJvrFHpL2NcjpCC51mm10Xd2XigQz5GD+5OuNvA8955nDDrfhykhilyi0q9NylUqIHwE6BbZpnaTRnsWMx176mZOqz5Q3CKR7xPlmCVtNfg2R0cs+ta5HmK/1kmZ427y6+F0otIWoHg1jRumtBrO5L03pxnak72VNM1g+giDwZUV2jegb8vLRbwkfQbrVdkFZGYzLKihW9sc6oNDvYHKx2NLb16PtVYCdTxRrEI5N68GL5XdBQsECByUC0JPSDUMU/fwK8TbY2TOXgukf97xEPq+jfnWTnKbWkomzSAa266Qn31eCVDHn62HA/0YG7SvwEtcnj59Vu074YLvD90P+gwkdS4trzis7nvFpuiyrzMdl+bxfXhrSXzCaHO66nRXcKV4YLGpVV/Miad4OwLD13JuGub4GnacHwlWW9WzEA/5bJw406oyobff/5mEJ5ZPVdYD8/XL6VdprTI96ETorJvyLka0X6DxcugppqEzLvti/Oe5BetZS8DdDhP4uAmQu3Vr3eLPP1LvFWydBt/9+DEoKXtsFeW+R+uMw5aAiWjNCRYnillUkq4TyBkB7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(346002)(366004)(136003)(66556008)(38350700002)(66946007)(66476007)(38100700002)(54906003)(86362001)(5660300002)(26005)(4326008)(316002)(186003)(478600001)(52116002)(36916002)(956004)(6916009)(8936002)(83380400001)(7696005)(55016002)(4744005)(2906002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pj7zUHuT460JNpdLu+0Vc8pGD9+IHc8msfKtquAqlsy60RFSm1YHUXJYUmk+?=
 =?us-ascii?Q?hFewa6QEFo3lKbKrHNX+Y5hoWEpxJ+omacB8P453vEBeRRTiKBDNqA6aJYsE?=
 =?us-ascii?Q?gIbZGaKoX0WqWxJuZjWpg9WzpbEgHpUVFTkBmVeZTO+gnou6f1eH9GBQRlRw?=
 =?us-ascii?Q?V7jghjANFSxopO024DDG+y0lrVQsQ0H8/uMRrRKxuVqnxFeoPLz5v+qytTqh?=
 =?us-ascii?Q?oLz9oPTpqWXGol4CTuQ3kyjgsscsjjwt+bPeXq8fbLeWDEmUenzSRRhJiZin?=
 =?us-ascii?Q?dj7rver4K2mxEk1Jzcv66MJLjJVbjhIaq2LxHwZRK6FMXD4/tNVKBKV5PCVg?=
 =?us-ascii?Q?WZBbxcbtyM4zZUXSz8T2smpA6MENQe5iUu5HJ6758DBLhgi7aozEVtosQJmn?=
 =?us-ascii?Q?a31OWGQLru1WV3LWFW0yK6MOOPm0lzYc/lrQEA/o9j5wIsGl9zyyJinFmBSw?=
 =?us-ascii?Q?JKkquMDagXsP4kbNr4c4Qm4BqBDS6/kHqGpxdcUZ+1Rv0dRnJ/litdPSJB5g?=
 =?us-ascii?Q?WqC+o1E/QqC+bT4yoH6Pj5nso/IAPUGIeHmon/15we0raMG+Q22ci7wn52q+?=
 =?us-ascii?Q?85TJbJimef5lNoWIquMkWUXw5+Mb6mrOPauYIwn6Qb2WZPJkPGFf0pqNcJBT?=
 =?us-ascii?Q?xBgsbFXYki/WjZ9zeXhuatSBnAtAUFgMuKsla4F8M15nLFc+LdCtXWDTqq9m?=
 =?us-ascii?Q?bESKQ0Esb1QAQ2Pa99VWD/eMOmptNU7uT4KNN3iqMGRwayTnTmL88+EphwVJ?=
 =?us-ascii?Q?l80E0suEIGnH7hljrr1GoIZ1Dp404IFG/rgECrym38z47+CAbbJ3jWLI00oG?=
 =?us-ascii?Q?FKt6lXWmdnF2HaW4cGXUPYyKW/0J2I6Bgp2h3bS/5mPy0cX9F49or8JWBYfe?=
 =?us-ascii?Q?ZjOElgriVEq0ltV24xdknPQoJDgAW2dqkz/sw4DqbC/r5bM7dgIYHPV/6hgW?=
 =?us-ascii?Q?krpYCgrPqHuoPsThWBQ05tXE76bp7SJWvzFBuXfearDiqPpRxsZtDkvEkxzm?=
 =?us-ascii?Q?AOsynWJyqx75wJR5BcfoFuMpinJwhQC1BnDgyRcuvEv6d32yFMCkigdIabG4?=
 =?us-ascii?Q?+y3RxQzn8nZb8cMimvC/voHDYL59EVNDw4eU0C1uDy3uirab3wcprDguytHm?=
 =?us-ascii?Q?wIoXkCpN/lWach3n9pD8YSHC+QdaCGY1pRVt3MKgL7DVVdSSyB4yEhDkUt6u?=
 =?us-ascii?Q?PKfMYGczEY3/jVRVhjIfVFr3uJHlxQAKsaX52h9OvnJm2Io/LJ4e46KGpoou?=
 =?us-ascii?Q?GD4aHZv+JDm1lx2KwtGKugd1iOcPb2LTXMoWwnAe3WOX7/l6H/B+fX4s6Y7d?=
 =?us-ascii?Q?glbyN7AgyvMiwdZydJiGnIrj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f87cc39f-558c-4e90-c200-08d968439eae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 03:43:08.5350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ejkALxXZMujWeO7DARCCwWKu6i3dYrzsNoi4ck6+oSce1wyuAMTCQHlUek2zEXJ+Ik0aK6f+3zHPRbA+UZhJeEhqugt7MPoQvttIvbE2H/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5642
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108260019
X-Proofpoint-GUID: s_5fplXl_bvCB-omFQalIIa1Pg1vGahl
X-Proofpoint-ORIG-GUID: s_5fplXl_bvCB-omFQalIIa1Pg1vGahl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> I am not super happy with the name either. I used this one as the
> least worst of possibilities I thought of.  seek_range/srange ? ->
> that is very HDD centric and as we can reuse this for things like
> dm-linear on top of SSDs, that does not really work.  I would prefer
> something that convey the idea of "parallel command execution", since
> this is the main point of the interface. prange ? cdm_range ?
> req_range ?

How about independent_access_range? That doesn't imply head positioning
and can also be used to describe a fault domain. And it is less
disk-centric than concurrent_positioning_range.

I concur that those names are a bit unwieldy but at least they are
somewhat descriptive.

I consulted the thesaurus and didn't really like the other options
(discrete, disjoint, separate, etc.). I think 'independent' is more
accurate for this and better than 'concurrent' and 'parallel'.

-- 
Martin K. Petersen	Oracle Linux Engineering
