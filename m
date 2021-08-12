Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79965C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 02:53:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51C8F61019
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 02:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhHLCx3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Aug 2021 22:53:29 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24516 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233510AbhHLCx2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Aug 2021 22:53:28 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17C2hZa6021069;
        Thu, 12 Aug 2021 02:52:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Wtx6+OE1viq2qKOJ78VHo1loIRG7+iwk1w/PgSpFnaE=;
 b=uVfTslvsMQr1YevXAHrmJB27wH6E+ScGp4nPfi6YiFHZ4mpgWYD2co/lI5ZBDeSmYjl0
 sPXq6btiRZx+GCIlqr3Y1v2BAJIwMo6jDtOK/mEvXwgcpypghM+jvcJXN9cRgOMSWNG7
 EnY+qm/8kz01K+B/iKGyIiQWwHX/tBP6b9havJiqE/VeAhL+FYZq7+GGlob0t8KhZL67
 MvQ4ZAmjXbHHQkHOnBR7IVWgaCzZIRlJrPdu9mpjcMP/Wj+Sr0G4cdeEezWSrpjh2fmh
 PuV78HQeEv644+lDhq5D9hOgN6mcaQRLo1XnbeIA/UzG+lG5ApETrKMr5LS6DjDhpXKG kw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Wtx6+OE1viq2qKOJ78VHo1loIRG7+iwk1w/PgSpFnaE=;
 b=BReRpZ7Kx2XrMWUnByRapUVlL0Tw103qjHESLYKlsX2sJCC/20EF6uRVfbBdGd5GqvqP
 EyYMSYT4w6GucKa5rFR23kj8JdjDOmb8jF18SXfQH+m7gA5Z/WzIOvOnKSFi5d46yFZu
 qQB1wjUH0ulQyaYrp1ygambkgaqLHdijx+so9c940kcbjl11mLTQtFuWDCv+HaulHiWc
 YyvjEjaPPeEHSAmKu5wHyFzwOSmoCnNx5en6WVA/p4Q2WPqGcbhB27ipSayCMP2Y4wwK
 turncKTiduo5+9hbIRU473qk5+v9NTtzRr9lAXMB09wNMcaS3jsa+U32igxq+3gXUapf kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3acb7a25yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 02:52:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17C2oFIa098819;
        Thu, 12 Aug 2021 02:52:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3abjw7mja9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 02:52:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dt7fYMYa7o97zh9qKD0gv9LmAmRyJYFvXZWIY1hb0OdO9w3fH8QpwOfq+pxaMhH+jw2FdwlGr348QL1yezrbqZtAjOY5GkV0XOJW3t+IVHgJJFoKSnDTw/ddnOXZoA6eHCtZH2BljlkKtktsILdgVesSt8Wc/qEoA8suQZdqRy47BHJYfRBYM7gAjyjcxwbv9AS5XKbdnukodenbdrFiZ3o8AMvPByv7Snh9VRIHP4hcemgJ06nnP2akJ8awtMKdTJv6Yos4ooxDk4ubhX078UO3MRH2oO9JnZxGcjq9LkQhmDgVPeVNirIuJtWKyaDsHJW/ITHqTcZdZTvGMo0unw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wtx6+OE1viq2qKOJ78VHo1loIRG7+iwk1w/PgSpFnaE=;
 b=K8e7o922SNBFaEHtb+lInfQRE61ksre43Bs6FQpaPYTzLKMBfMUNbvZv5Zqz0AnqClVapFgEqNQyfiygVN0cP8zByMWITJ0gBviBVA2FVCSoR6u7Rs7WejAf2H0ruG4BKe4pdeqX3orKWmlwOUxw22GmzCJVnNxckoMzcQIe0ZVaJ0+4cIGCDatDw+p0Hz7blnrIhJ4Dft/P8SYcMStuTMG5RjSKeMlnLleKwJzKpti8gz2eYA01on41gKYNAR93GLlrCavJGnEouKaZylOZvFBAfGsw4RnlhPS6sRpDUSPseTSGwiMIHsHZiZR+R73tntY0tQwNNqQ4e+QWGXvENQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wtx6+OE1viq2qKOJ78VHo1loIRG7+iwk1w/PgSpFnaE=;
 b=OWAaMjKq6vBFACVdJxTKB1JsfOpmZAtT/p/w1eUpvus6RGL4j80mZ8UaNY71A0l+SFbOr5jLDGU0GxUfKIgAFYzTafxH5x0TDX4TeZuJUn7pbrF+JnIPL9k+jrNM9NG/GYMqYaYbt1xrS1i+q/urkH23b3TtB4VkCHvsPjb2O3o=
Authentication-Results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.20; Thu, 12 Aug
 2021 02:52:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.026; Thu, 12 Aug 2021
 02:52:46 +0000
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Shai Malin <smalin@marvell.com>, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, malin1024@gmail.com,
        Manish Rangankar <mrangankar@marvell.com>
Subject: Re: [PATCH v2] scsi: qedi: Add support for fastpath doorvell recovery
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18s17tlwe.fsf@ca-mkp.ca.oracle.com>
References: <20210804221412.5048-1-smalin@marvell.com>
        <20210811154725.GA1122984@roeck-us.net>
Date:   Wed, 11 Aug 2021 22:52:43 -0400
In-Reply-To: <20210811154725.GA1122984@roeck-us.net> (Guenter Roeck's message
        of "Wed, 11 Aug 2021 08:47:25 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:806:a7::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR10CA0006.namprd10.prod.outlook.com (2603:10b6:806:a7::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Thu, 12 Aug 2021 02:52:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 011cdc36-3152-4df0-2e89-08d95d3c43c0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB461619D4F547A5719BC6E6038EF99@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A77EaBNrR6Qu52zbmsJvnNiMVF/FA+8yfM81QhUITE5tTWT8wPNKa9ByReohUeIrtZgHESrp4qNE6MnCbvgk6FqI7jFrr+Un3LySpte3aUgfNx1c7ZS1ZAWeMSZ4NytpzpMyz4ueDwmnzBUqF8ffcy/oqrVsnqsql4gQSj4BlyVW4ylxjP0NU8FXuvWJJTnyaR27QSA4h1OAAnRbPkq36ao9twl0QOkrnzmrlNozpMcDvJmWWdd8mIRNRnH96cucsCEB3kukwayPSOyU3MXqcSaPMc1kdRN97PkoIPMLNr+Mff6Wrsn8y2PR9FL4fqpu4Ozu1c7XdAMnmrmYvT3642jZHNCN8VBAb0xIciB7S6VjRZP4mPGEpXuZMIzdYympnpcS/IJAbaoABSDpB+MYGS6PwIEArwo7ikalQCV31suIQIXnUlKIIiRE+jIpDLOXrnzfAS+XN5Bvh3IpHnz2NAdbnef15ZwCrmtIrUlzGzPEtVo+St0ikVbGhTILki6h5S6NjUMyfh1Uoa5u+/a9Cem5cqb5oSS9MPXh+XsSOkEgL1DnebEtcss0Rpr/E/qGFbzzNV0KjOZgVLMCkI27XP66UeFiJ9QnXtl9NxG/ys348hh/5F7vgzYIOr8bUm7ZTBAMQR+cGDIkKKQfDkFQNNSKJAgYSzLSOp2yNOP+6HJwDxKOiFMenYKAOoNB03dqgyroBWXdq9ERrhjuXKw3yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(39860400002)(346002)(366004)(66946007)(7696005)(38100700002)(38350700002)(8676002)(2906002)(66476007)(86362001)(6666004)(26005)(4744005)(8936002)(66556008)(83380400001)(6916009)(186003)(316002)(36916002)(52116002)(5660300002)(55016002)(4326008)(478600001)(54906003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RwQn3UTS1FA0TppVsehDy3lobD5iCVmqXL+5Yf4N4syXCWkkXxSsG9vqXdyR?=
 =?us-ascii?Q?t1oaC6WvjRdqvzQrNhEdrIMuIkI6gGiVBBo9UwTG3TvO0JnkiqzEnJTMbE56?=
 =?us-ascii?Q?Y4UBXUrMvVJZq8KSjEXwfyk8PmMzfsnYfvCmQQumIZz5UHj2aCRoKivOYvBX?=
 =?us-ascii?Q?tP+qzqzwn/ZVHdM7xJooHVZ6k+9PlgWZe/cnI5NJshKsUrUdP3A+FFDhz9oD?=
 =?us-ascii?Q?203on6bU2Kfs0F7EZq/FfNwM4Se1g7PyHdxocfDW8z//+AkIw6Go/h9dqTYW?=
 =?us-ascii?Q?bmSs4t9XkNLx2DeQYxcO1WKmm4r/BlEWabEIMHkvtEOmcVsS2/N3q+lxgMCb?=
 =?us-ascii?Q?bwVB0I94yCEMdjmE3A/MdpO3ireTLLxy/GNaTK/Csw+Z+eIE/YYHWN4s72Bp?=
 =?us-ascii?Q?asgiyWGQDF6/DHBYT5davrHr3ri0oBAUfhcPW7tDmCRt/YYxkFo9IxQzv12c?=
 =?us-ascii?Q?3l2e1Degrk4SbgGfyGlQlmxQ9IYvoiuKZ1y5mykGqRAun5hPXwrMvolACum9?=
 =?us-ascii?Q?Hk6ePsFvyy76MheTsSo2Fr9E7Z9mPlbrxEpS4or+vfyuadeVSpKBTNRPikyW?=
 =?us-ascii?Q?RDpskKr0AOEdEch8gkfS0GpQGgR1HWi8bPDpSzm2K4QsL+bKwHLWPLzexzPX?=
 =?us-ascii?Q?8d7r+CJThj8fgGPcalBFrA3qTwr6lks6gJdMbDQQ2wQum8lAl+wrVnMJb6+j?=
 =?us-ascii?Q?6qrrpLK1i1daQ8KXNG3JKwKKE0tXCmTU+vzFIDMn0GCWYUE1urtSq/tLxrRB?=
 =?us-ascii?Q?jDHvuLx331w/4GeF5NPe4LrtA5kBL7iTK16E/lja3NGWVM5vI8A93ftSZBCy?=
 =?us-ascii?Q?4XGx1zxH98HH+6owLnNWkpMCPnX0x3AmhQeFm0at93Mke4lgN0dQymzpbtkt?=
 =?us-ascii?Q?XLxs4zB9Xz7p9/5xsfDj7up2O1cR1Y61fSoKK03hMjpRX9ugh4mn4RZ9FCUQ?=
 =?us-ascii?Q?fJjE4JpBdwjQefc8gAzp2TDdq0AgTYl/RdNNMaQRrzrSeccDVr9PPuBqI1Fx?=
 =?us-ascii?Q?queEadbIwWPPy6bLKcCUvMMAPbMM1Zaxmr+xGjVjKf5B+utdBWK9db3zn0Uz?=
 =?us-ascii?Q?/fd1LHJ12uyYVIUCa4KZ+u58aSxibLnV4lNnn9cs1ZBr98gkhZKsSsHdH5re?=
 =?us-ascii?Q?skGzP5Cpc3IYEVSijUD5PDSRsojnE5u5T2DOINXuH/ju79fWjwauN8Ik1mWH?=
 =?us-ascii?Q?eyg83vqphnwY6IKwBu8gA3xHBbLzoEyNNYXhxm9D4Y29xNnWXxPNy0O4IapO?=
 =?us-ascii?Q?39JeF16Y9d3mK1zujFKsTaIky0nES5GgzvnntHQHwqBe3Ki9tUNJyrYQmPYi?=
 =?us-ascii?Q?k2uvnYJ4Su7xaXand2FVoNrT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 011cdc36-3152-4df0-2e89-08d95d3c43c0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 02:52:46.8094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwk3p6MPC4myBiXpCXwaxk6hBAqlcFcqvLIuMaoZjCoXorn3B0VWbTblunL7GGXIzVjuGQWETVSz0Qe/27Rz146MwHLjNUVhphBRK4oMSxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10073 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=956
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120016
X-Proofpoint-GUID: pTeC9stnFbOdel_YUholHDynpcMeWLX1
X-Proofpoint-ORIG-GUID: pTeC9stnFbOdel_YUholHDynpcMeWLX1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guenter,

>>  	rval = qedi_ops->offload_conn(qedi->cdev, qedi_ep->handle, conn_info);
>>  	if (rval)
>> +		/* delete doorbell from doorbell recovery mechanism */
>> +		rval = qedi_ops->common->db_recovery_del(qedi->cdev,
>> +							 qedi_ep->p_doorbell,
>> +							 &qedi_ep->db_data);
>> +
>>  		QEDI_ERR(&qedi->dbg_ctx, "offload_conn returned %d, ep=%p\n",
>>  			 rval, qedi_ep);
>
> Due to missing { } this will now always result in QEDI_ERR() execution
> (and possibly a C compiler warning).

Fixed up. Thanks for spotting!

-- 
Martin K. Petersen	Oracle Linux Engineering
