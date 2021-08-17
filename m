Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE3DC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07EA760F5C
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhHQDVC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:21:02 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52846 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233637AbhHQDVA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:21:00 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3CQSB025803;
        Tue, 17 Aug 2021 03:20:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qKTgL1edatkbmys2IkH8jhdWy5K7NNW+rBoFUgpKqcg=;
 b=K7p37qtISbiLNJmNFWilGwVfqGW+kDaaqWiwbWTqDBBhkCUcE52wJl+IkMtzAUlXGFxI
 +4vooUW/FsViquFM8+KLzKaU+ojiKDeKSTtzfllV4gmssSZyWaGWPS17D/TKraFDq7F2
 1TkJwSXaPfI/XkqVdpw5ifyJxlrmb62grpeJb25Qz06wFqaCZRTsZ9rQzVsrnskBGb9Q
 jhPo+Bei6y2qeqMQoP6HZjel0lhE5ceOs4OMZmBu60v67pC4IuT3ywoEwzTndZUsZZHK
 Ei3h2RtUKWDl20XSXvDvALq+YhW1u6p2CLAv1lKbh/3vJOd7EEYdqEXuHubG2vk1Xb1D uA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=qKTgL1edatkbmys2IkH8jhdWy5K7NNW+rBoFUgpKqcg=;
 b=A9LjtpZth0rnYw7gserlIfvLh74bfgOyX0LGS8J25Slr9yx0TVzROsq4IO1x9u79TySs
 BNVuHZKCy0KIeG5VTg43NG58tCf/zJag5M9m2uDGbq47bojrCM/TjpOYzbPsxH5uYgF3
 whtz0H4Uxb5p2NvaQ7IjCxnoqYEck6cia8lGwUXmlHoSPDnEc0zpkKA9n0aAGhPB6/39
 oRX0/o4m33BlRusxENQI5joeKP5U9hDbMLlOT7esa40KWoNAT1NqKeGLRJQ2GUMlM+kS
 LMUjOagoprSTr7GCDK42emGWn9ir84hGRB9SaGB9ngZUPuCpdi8C75ccg9tJ1fKTOYrr Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgmban88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:20:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3AxEO092022;
        Tue, 17 Aug 2021 03:20:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3030.oracle.com with ESMTP id 3ae2xyaaa6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:20:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NbogzlCItXvIjoJg26C+2Nse8REppi/QqdZIzc8tkaNpwI7nnlJduuQztjD5cvNc7Fd3QH//gyTtPqLBtP5o8mfjxQLCTFaNnpktJayUnmR/NsIO3DqgRjDNyEa4uK7/BsSmwHFope85QBDRZeTwbUWubHHHhQ+Etfcq+fRmEd+v89JF0xEAPQ/C2MRcCcyxEE9B/c5GulUzF9C3EMUvy3mJl1BQnb+NpU2Kcn7K2B+wCT+eCbtzkEUnU+5euiQfISjApmwX1PjGpAD0VWuSUc/rjOIULiMzgrwwFOFWHRvszkD2hzMVUVIpvc7RSMIUSWiLmtgWUgs80rIBwT6trg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKTgL1edatkbmys2IkH8jhdWy5K7NNW+rBoFUgpKqcg=;
 b=kuBQ3fPcaMfHxQMQ6sxorsu4MNUg+9PrmW/m9Bh5/Lv8utxiM5z0/yKDDRmQtAIxZKbEmzMBu2Yw6I5mRLW7cG9vwW+pSqfHwaz7aylOQp933C3WQKrdKPhzphebEn9hvXSJeH6x2U+gVBx0k0KAG8ixDoAJjIY/aPG+dLai1i9hDwPEh7oCQzgDJnGy3bgfgRXlWxCvCkvzuVQ2Wh77eESxhMvu49PkbGV4k+mRuMuLfRGRA/ZiEobxWwIR/4R4SQn/Vm89mmo0p/Ls79qqki+lEQevdXeMh05GRJT6drAl0BHfhoz3fTm8bNG4acB9KGCq/4O1k7OgS3yTeBuqaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKTgL1edatkbmys2IkH8jhdWy5K7NNW+rBoFUgpKqcg=;
 b=f/VcmpeigupNTqcm/EVlLolO98UDphEJ/UsJCl9n2s0wp1w5OzsQOxLTpWq7/X6IkbsHV553Hq+yHXq48ne5UNbUPH1oLYL7oL71UBxyZITBzA+Xj2qilTiK0BjCmy83nOm9wnBcc9EF1Bnr+Vcsi68UlpanNRDBODhig63+zGc=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 03:20:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:20:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] mpt3sas: Bump driver version to 38.100.00.00
Date:   Mon, 16 Aug 2021 23:20:19 -0400
Message-Id: <162917038628.25399.6776552017550215609.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210803065134.19090-1-sreekanth.reddy@broadcom.com>
References: <20210803065134.19090-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0201CA0015.namprd02.prod.outlook.com
 (2603:10b6:803:2b::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0201CA0015.namprd02.prod.outlook.com (2603:10b6:803:2b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Tue, 17 Aug 2021 03:20:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1702950-0e8d-42a0-4e9f-08d9612df37d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45974619F4DEC81DF654EE788EFE9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PugSOCSdBUP5Wk261sBz94twBMiyxKn4l4h+prPkpNZKLA93veF8mJRxEDJIy0pXQDGBUzL0lAP2k7gYiAom0glRhNS3nUn4aLIRhdzMDt0qBeBZNLtnGcMEWI9JwrJpdUlWWqzRVJlGOpaS5GawjQ/t6HL8+s6xiTD8d6uvjxW7Ibbv2YCd0cU9riG8yhT/o3xdFmXihzCLao2aicM2D2+AAcZdlH1CO/Oz4zkXdZ8yyH+2g/bVZLczl7gBuWuWijC+2p9IWzMfcCYU4P3KNMtlhKFpu4lzycC1N+0tNCevTRxOKcp9bH2fJyoatMi8gmE7Axupa9V3FQ5gCP0ChvyL+fcNxJzXSNYEGqlOp+TcUxw3Psp5nbaQc28ZzfIvVErZMybUBGVVvFt3tvuyV0504dawxOGt52SDSv+Husah9vuqsk+v694rfTbHa/dMh6kVreN4YsQ9+kaC4thCLkgVCUVk0nfR73cT2LthvE8tV4sOWRFDT17/05hBJedufP1RVP/LC/Fk6pHuZfeTq0xUe77pMz0gnhs21unQi7X/oDREBOoooHOpx/68VEIP2lLOkR6MBIgNuV9LsVl16QMU1fjRUbTNJsj7QSO+7zWsa/h54vpsT7c9Aomxf2puEcvsGCZw9+xPTy8j2EU0w3HIsSBefO8xx70keB1oji8ySSE7hm/DwAUieInka4bqgZ1BBuyMcHvUxN8tZHm3iZw+/K55Rg0zZRefi7KJ+mwuNZyr9cSTfaJqbHQCzPdtLxMiHr73Qs5DFU3jYvwoP1SM3YvMe2PLMht3m5gIzeOuI6ASKRJH2eohJUAHkmCa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(107886003)(36756003)(38350700002)(38100700002)(66476007)(558084003)(2616005)(316002)(66946007)(8676002)(956004)(26005)(6666004)(86362001)(6486002)(66556008)(508600001)(4326008)(5660300002)(2906002)(103116003)(966005)(52116002)(186003)(7696005)(8936002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2dFNlR5U2ZxU21LZ0lzN0s0ZGVVelZSZ2M2akZDaWJudlQ3dlJQUjdYaGkz?=
 =?utf-8?B?VnFIdk43Vmdla1hRMU5yekt2MWY3U2dsTXFrQVI0MGdHUE0xbG9Hbkp5K1Fy?=
 =?utf-8?B?N3RoaUlOcWdMS2R3WFpUQVBHMlI2MTlKcFZIRnRtS3NBRHFVV1FXMDIweG41?=
 =?utf-8?B?djZ1US8xYmpvL01TRmVzd0VyVUVkdmhOMG1qVWlFUHdyWUNVOElsTjBMckxG?=
 =?utf-8?B?RHVseWlGcnZWc3pFRjJLemNKWFE5bWhSU2E0RkdzUWovSnZVaUpCbzRzRUMy?=
 =?utf-8?B?eVlCZFdQdzVFRVNCNVVYejc0YTREUUJ5Z3pmK28yd3liQW5MTXFubG41MkJH?=
 =?utf-8?B?Q0pHdk1xYmJJTTdYY2h2VC9VMkZkM0hwUlI4TmpTenpWbE9pdU11ekc2VnlO?=
 =?utf-8?B?bkpsV05hdzBtZVYySFYrdWdYNG9PeHJIQUNiaVRqNmVPT1VuRkxIMW9reUhz?=
 =?utf-8?B?b2VJMHFOZit0N1p3bkprWlRObDJrMmd2V1JBeS90ZnY0cXRQblY5OVd0L1lD?=
 =?utf-8?B?NnFKYXZoUmhCeTRlWWpHbDljcDVLNmoybTRBc0RuMjFyV096Z2JDc2xncmlu?=
 =?utf-8?B?Zm1ML1prVlZrWGtmWEhZZVdSV05OZDB2dzBPdnFxVVFHa1dQSDZ1WTJvRTVY?=
 =?utf-8?B?OERZUXZZL0RPRVVkak04aWExc1dnK1NrVUROMUljZHVGeitScS9LcXUzVGlM?=
 =?utf-8?B?aXRJdnJXdXZYRzFKY0RYb0kxY1h5WWZhVDVIRXNCWXpmbFdDZjVETDVEYU9q?=
 =?utf-8?B?Q0xjcklqSHBsZDZUQVF0RjYrYllET0YwbUtlaW9mMTJxcTJlMXNHamdDUmtX?=
 =?utf-8?B?cGhzRVY4NC9UTmo4dk9NT3h3UzRVMmtHSlpIdXpGY1VxMmRaMUU2eWwrdkJ6?=
 =?utf-8?B?THJSb3g5UnF2dGhJS0Vxb3RrRWI4NW1mRE1Xb1I3SlNyb29FQjZMS2JpSElO?=
 =?utf-8?B?Mm1UTHZ4ek5UMjI3S3FZQkltUVdXdzVSb250MDZ4VWNQNU5wYUo2WXNYdjBH?=
 =?utf-8?B?M0lJMVhrWWlzeEovaDNvZEtzTVVmaWxwN2hGdzBSZ1N6enJ6dUVHbU9xVGV6?=
 =?utf-8?B?RC9zUEZlL09MdEx4QzRMb1pWYVV2UzJBc3YwQ0RSaVhxYWZhMTVhRmhVNHpu?=
 =?utf-8?B?L1ROVm55Zlp6QVFGR0dHaEZHSHN4VS9vV1hRaHFTZ0dabFlWUXZwRGlhV3NS?=
 =?utf-8?B?T2dXQXpjbVNXSExacHA3SitZa3Fwc1diaGx0UW9QN0t3cThRc2d1aElSbDc2?=
 =?utf-8?B?Z1J1TndweG5wMnVyM3F2VG8zbHNEanREUkZma1dKQVpMbVkyQkV2Nk54SXlo?=
 =?utf-8?B?Z1loNEVXV3BuYVE4U1lKd3NobnkyTWJBODd3V0ozMWxLK1dFS1MrSk4zNUcr?=
 =?utf-8?B?RGVGcWlmOUNNNm5rN1JiZytYd1VOV3NVQkdhMloyZGR0Ti8xVVp4VWhjM0V1?=
 =?utf-8?B?SnJNVjd1cFkvOERVMGdLbElsYk9jc1FmdHNza0duZUc5Y0JIOUxmVHFOTmVI?=
 =?utf-8?B?K3kyekR3WlJnQy9OSXFVUkh5TnlhUklwSUJVN1lzLzlYalZFeEJPVDl3N2h1?=
 =?utf-8?B?cWd3eHdDc1c5bVRlQ1RZUFpYeDl6S2REb3pPS2tVcjcrZ2E3Tk1Rb2MzN1ZD?=
 =?utf-8?B?SlNPdTh2a1VjTU93YkpsUEJlOXVhTWFrODBqcUw4TGZnZUtNVVp6Y1NySkdD?=
 =?utf-8?B?bVd4c2xCTVBlLzZrb0FLOWVqUnlnVFVrSUZZWTBQTTMzdTZubXgzNkZMWUpM?=
 =?utf-8?Q?gHdeaKkEfqc2PMgE44eMB80/VuGAYkY8sCezWlO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1702950-0e8d-42a0-4e9f-08d9612df37d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:20:23.8055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3wpbXu0vuzBBRya9CnY6zcQ+X8hjJdW1U6gKgY990sm+0FwvWUAtephdQJ2p6kABNZ237mHz2+/dmQx1V6scPsUtf/NEcaAHkH98X2pPM0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=906 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-ORIG-GUID: s1Gyil4yMCLU8suvlTBgwqAWmDNyXPJV
X-Proofpoint-GUID: s1Gyil4yMCLU8suvlTBgwqAWmDNyXPJV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 3 Aug 2021 12:21:34 +0530, Sreekanth Reddy wrote:

> Bump driver version to 38.100.00.00
> 
> 
> 
> 

Applied to 5.15/scsi-queue, thanks!

[1/1] mpt3sas: Bump driver version to 38.100.00.00
      https://git.kernel.org/mkp/scsi/c/44f88ef3c9f1

-- 
Martin K. Petersen	Oracle Linux Engineering
