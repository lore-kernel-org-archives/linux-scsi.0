Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981A7C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 18:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71FD6610FD
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 18:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhHRSrF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 14:47:05 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21220 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231182AbhHRSrD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Aug 2021 14:47:03 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IIYI4J021350;
        Wed, 18 Aug 2021 18:46:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=HcMqHUMn3ilgR7fqxCH3ME1ade1MQA+LGGOfOs/O5aM=;
 b=emOjgjAyB3ht8vM2NyksT0+NBzOsFwHLmZUh4nOWTvLcC7sVENqCpIJ713kxa22bbwo7
 i+I7F88ek7532F0xtf1ftvCD4n48w3eSx10fc2ZBRHOlpSeQyt6m2J+6tbsafUTOSPIy
 pARz9p6OKB+2aKMSQ60zfA1JpFzB2OWaqWU5U/tFkTPyaP3lGrxrMA6IZodrugKWsOqZ
 CRzpJhYmDCOSeJ3sTdW3pyRQwfaPuesXmejWaQB/WTJCZmtRL8vNlCDTbFNmn31h/JlA
 SLwPbaittN0w5mhBA8utwsXfCphW1eLYabWsjg6My+bNcep0aPPniwJVpc1uhtBHBuVi vg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=HcMqHUMn3ilgR7fqxCH3ME1ade1MQA+LGGOfOs/O5aM=;
 b=nH5JeYqc4e5QGnIbO6zNmWjtb+LIuevYWvX7aVIwwUuHsU+Pn9XAqAIpsFSG30azzmqD
 xeQBNxtmRDiVQtrO1OqKD18cTrPMYk09bCURnM14bkrLvBe9DaNCvgfDRbiWx0sYZ/9+
 ekPO2T+4YjATi7wqBM16h8cKlawErcqanx+nbnAJ3w/5Qnxb5N7CnkzUxGev79MCpHv6
 TeevZVsEknmIKu+Mnyay5z2P5zF4p+8IvG/tBVae/rPWJv7PM7vi4twQ1GwnOlsS/Qhi
 w4MM+HmW90MiLVjCQbRM074q5E8nqppczBvpvMQrzg1Pq5jZawTGwD4kFnO6LMfbR/2a WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3age7dbh7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 18:46:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17IIV4Cp107883;
        Wed, 18 Aug 2021 18:46:08 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2048.outbound.protection.outlook.com [104.47.74.48])
        by userp3020.oracle.com with ESMTP id 3aeqkwt9qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 18:46:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLu+pozA79tiaTlNZjqDqmO98Lesy8eRNcXeq3L4RYxC6c7D55elfchFuPdyWpw8+mOjmu6BA7J4vuZLLxXNyqll8oI87E+8Dza5gnPEmM+SzryT38l7cX1yJNvm2o4biSglrFIvpEizK2h/Z+cmTexbCsgaKFKXLW4uxeXSEhmC0+2hw5VazAd9FnP2vvgTDDcztSMe4qFfbruB/beKxLEN8zip8nkLoC6EBXETBpeXetxrf1US9B21YDeDXKkL9zCn2jYkEBO0dWmer2UIR/FMUJem4RHkaYJessiU5CRSnCDxp6jaJTcZL4D0a8dtW1FKCBGl+pAiCLm2jOoQFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcMqHUMn3ilgR7fqxCH3ME1ade1MQA+LGGOfOs/O5aM=;
 b=Rr7cfdcGJILUD2Vp/KSclsvkYq34hWZegQ+w5xW0S8P/H1XF4vNL3lwxPwR2VwgmDOwZvopJ04WkjpAXzpr8xwS6AulO85dNRTaHS5n5Ohg438x0+OKzCInXERFB+oxkJPtyqeSfaqW1AyCqAXhSRmv4sCYvd4H2OBukBk6gl9fJEjZkaD/B0vrVEjXxgMQE6sdooMlTqoz8HFTR/+X2c5Gg25Rqr4S4m5f150pezmux77kb2KHtB1L/uOMvnFsQjsj2WZDOSgQrWc6F6oJthKpa/07aek2gN+zI6wBQvQ/4XPMsKbRgFqgJulTKW0Kr96qiDdaA325tZk7amd2jTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcMqHUMn3ilgR7fqxCH3ME1ade1MQA+LGGOfOs/O5aM=;
 b=O9CEiEiJKJ3MNMdtWDGruqpdp0634ylkWMdWWCGl1h/Yeqa7zl0NLc9zkvVsOlFKKOn64nZFdbIA+En1mg1nP+IZDLdAZqA4EBrxUOg8ReaiAQEJ/vjLQQ2Jpsddvrx46K1F8cE8NkO9r0lHmTCMVnDqOTvLxQ1mdSAaez9SsC8=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4693.namprd10.prod.outlook.com (2603:10b6:510:3c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Wed, 18 Aug
 2021 18:46:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 18:46:05 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hare@suse.de>, <hch@lst.de>,
        <bvanassche@acm.org>
Subject: Re: [PATCH 0/3] Remove scsi_cmnd.tag
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtpelhvl.fsf@ca-mkp.ca.oracle.com>
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
        <yq14kbppa42.fsf@ca-mkp.ca.oracle.com>
        <176ce4f2-42c9-bba6-c8f9-70a08faa21b8@huawei.com>
Date:   Wed, 18 Aug 2021 14:46:02 -0400
In-Reply-To: <176ce4f2-42c9-bba6-c8f9-70a08faa21b8@huawei.com> (John Garry's
        message of "Wed, 18 Aug 2021 19:08:48 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0045.namprd05.prod.outlook.com
 (2603:10b6:803:41::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0045.namprd05.prod.outlook.com (2603:10b6:803:41::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.5 via Frontend Transport; Wed, 18 Aug 2021 18:46:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0714062a-7e3d-46a1-cc00-08d962786f64
X-MS-TrafficTypeDiagnostic: PH0PR10MB4693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46937AFF42E29A961126EC728EFF9@PH0PR10MB4693.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2/QofStD2puQ23PFP3+WzkK4e3SThXGzmbgjSLWWY8EmEoMI1eAaI09AA3rFEPJ6JqIvEjx4KnBzP8Oie124Ywn1uKPsaA0wGXObm+hb2Yz6/JM3lHMCw+ZzMmml/1Eza3oR32yy/I5+EEe4HcxrgWbnIlkK6AIwl4V8dI6aKLgla2U3d9cc1rcf2iZfoIB1lsgCXXNhx7Vy7oXDkzD7Lg4nyiKwS3Sbs3ln+OjQppyVyCwNYZconzgWQzNbc0Eo1/dZqA+jKJg85CabW7f+zcHzha1+YdXKfua6K6Bl/OF2DPAGOsfHSJ9VpAJKVget4UxEcVgf8YZkMGDeojLuaKmFGYdt0o5cclvnL9RQsxamB0pzIpkqfeLl25MbeJx7MzoePL4wwXLv1yXJDferY121dMdq6H+S63jFoY0bgUjh/NY6qjm5qWOdnd7OudLtSV6jLr7bi1YDQ9h/9vhR6GJL6JRvmBdoaG8NY1+nt87Jrd7KS+fxkwo5oStLCh7gUx5Vb6B0YFL6Y06AVLHnbP5WePqC/kHU95DOfAZnMde3rZDGg6rzce/nA9VA/lEHC0h7bxcRL50/ziCqvTVQtFRE3GUvHSxXlFhu7o6D4m9OHfhMjfG026aQicTeiRvWQ5TzJS+Xs6de6ipwI3Sp69pTDaR22NwPiLHEO8uGP6QiCdFi+GR2QnmAZgT1SidFKTBgLHh4P/BXTZG5vGfhvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(346002)(39860400002)(956004)(36916002)(52116002)(186003)(55016002)(5660300002)(4744005)(86362001)(38350700002)(38100700002)(7696005)(66556008)(8936002)(54906003)(2906002)(66946007)(26005)(7416002)(66476007)(4326008)(8676002)(6916009)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cbOyE5X3zvuBeR6AylrtlMcAe8Eoss2b2KCnZtOIEaHMWh8mj44H14YeGNMc?=
 =?us-ascii?Q?5sCBCgiIObAT5b0Th9ACMECLWlmV9o46Q3Rf1a+TrYnhYlhHP1aJgYgzPpJU?=
 =?us-ascii?Q?+EOAcuU8eHdu8eSIG6OfXqtyonW7inAkQZr4idD0NzNg05rpWLy84qm0ZKcl?=
 =?us-ascii?Q?xaq/wltzdJukSUmpbk3tV8ToCjawtmID7FjV0zvDLp18heIEAzTsZb5qw3vD?=
 =?us-ascii?Q?oTAC8CrPaSQkrqlgSuxezaY39JryATRRd32CrNObONlbKE0GGQMpog24seav?=
 =?us-ascii?Q?4CqMFshlenhluitfEuQ50hHGBv8l+BAC4dKvGHzqdtMgGvvBiEqR7xdjdKD8?=
 =?us-ascii?Q?MlNE+GNBqZ3ITFHYXJPz0ibxCwn/zOkGg5lGcQbxoIAZEeVEy3kWeXpuRw8u?=
 =?us-ascii?Q?X4DxjIIUiPchjAgKINqLLyyKymU+FA5ZgDSoDYscakny9L9vzw1YMJsoPub9?=
 =?us-ascii?Q?irMbl0SCfdx87fw3KbuVq0et5ZVgVmsSLzVPEz5O87NbTEbF7kBtN6/gWETd?=
 =?us-ascii?Q?la3N3wHyURJJWbGT7AiIJjvJJWnwYe2oCm/F3CbrNmEkldCKyO7ZyUpNyt88?=
 =?us-ascii?Q?5xaK32+PwNtR90yz/PhmEAlyiV8BVR+WgM008cOmXVKhWyOrlD9yp4Skcxsc?=
 =?us-ascii?Q?/ToqGqK359o00/heU18tw7VMP7yvXITPgzthbVIwuccYrNCwlbpEHQMzDYee?=
 =?us-ascii?Q?zFhwX0GohtOtbcN3EIIHQcWTJ3ph4JPP3ClOtoWShuU0w0OEKfInry4eAGUY?=
 =?us-ascii?Q?fgpda/iySENVFqPiEkpYSVyO0GmvppzBe7GD1lrKjGjtutEOoXnoYGED4g6S?=
 =?us-ascii?Q?CwrYBrduTcl+i8WTMnU8AdsFBcPIp6fmFS2rG78HKo8dzMKyBSHjmOG4M+7s?=
 =?us-ascii?Q?JZoWn8A1/1FN4LCa5TXUT/fodNulxJZt+TdU0I0hykEss00mCLE75rKKrkO+?=
 =?us-ascii?Q?5CLBfS/t9GSTE8sac6aOq3VX8VzDBBIHX7o9RBxZsNdzCvAlsiVVsK02AHSr?=
 =?us-ascii?Q?uz24ojrAm3BuSslyPolbneLPUbE8+Fw4Jkovull/STV/l8dntztxjbA89kCa?=
 =?us-ascii?Q?1sr8lETjAjytsaiaP1Ak+6ppitIAFv1hILUpgLyWi7bYIPgM+vZUQb2ct8Ok?=
 =?us-ascii?Q?55kzH3ihxhhYEV5krsiHtHDSzWLaqdbVWawPH3rK1Nc0lb8bqrjiXDvw8Wiz?=
 =?us-ascii?Q?g6Yjvmw0td6e61DwAHCoeRDrZhAo9hJB4sGga2m4IJ7G7EAICIZgkXFg/t5u?=
 =?us-ascii?Q?Kq+z744WnH5Yglc9qu5jRrSceI98CnVIL5VW7g43M5zHNoB1BBfC/T4zxTF5?=
 =?us-ascii?Q?LDWOklDHq4xMvkkotsS9dvXh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0714062a-7e3d-46a1-cc00-08d962786f64
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 18:46:05.5056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GfSgmmBAbuib+kMMYbQwKjsL970/Xo8Clz2A88qcxa8w8+uKZUSThb1qTGZlaUJD73fXuCT1ySq/4wdkHaH5cxGGYIQSwaHlVeocumYY1hM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4693
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180116
X-Proofpoint-GUID: mJdgB2cGzhaUhxqdgJbwuc-l_9qwMnXp
X-Proofpoint-ORIG-GUID: mJdgB2cGzhaUhxqdgJbwuc-l_9qwMnXp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> As you may have seen, some arm32 build has also broken. My build
> coverage was not good enough, and I don't see a point in me playing
> whack-a-mole with the kernel test robot. So how about revert the final
> patch or even all of them, and I can try get better build coverage and
> then re-post? Or maybe you or Bart have a better idea?

My due diligence involved:

$ git grep -Ei -- "cmn?d->tag" drivers/scsi

But in retrospect that should have been:

$ git grep -Ei -- "(cmn?d|scpnt)->tag" drivers/scsi

I cringe every time I see "SCpnt" so maybe that's why I didn't think of
it.

Anyway. Please fix the drivers/scsi/arm bits up. There is still time.

-- 
Martin K. Petersen	Oracle Linux Engineering
