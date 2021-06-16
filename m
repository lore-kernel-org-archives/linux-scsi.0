Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FE9C48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE9BC61246
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhFPDwT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:52:19 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7154 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230321AbhFPDvq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:46 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3kg5B018303;
        Wed, 16 Jun 2021 03:49:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+KOTyV+8jaqNhj3JCWGoamqbhuyWV8zXbJTCxSImV4M=;
 b=b8YH7aeywRyjt78y+HsJWSO1qEZmNdEgGGSnCcxPStC27saLaA4xanI76zRI0B4J/z4i
 vOFOjlKWMqunEcI2PyZ5psZ84m1k/WxwL8F+rO9pq6HFK9kQ4NjtMpFzSAs1Rs6PRBin
 qaSORKKccM12iC6o1XV84pynRf/99geSBAANJSm2e98JL8EYrxZOqsKata2xHBndeIDx
 igYU3dkxnQ4eE3i2ceqaZ1qFKGe2SnBEXXzjuXjfHhm2ovszVXiI4KR6l6s6yB5s2t1d
 Mh81rqHHPXOuPSC8Yx3m1qogoGQl7o5ZvkQmtWWJ0V4WUVdz0pRZLbSMPWhZlReupwTh sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 395x06ht0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3ir63064725;
        Wed, 16 Jun 2021 03:49:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3030.oracle.com with ESMTP id 396wanat0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yxlk47QIXSm1pBprVd+hUcyNiB0K7Z1w0ejEd+YkwTyzomwuqx7u+OEnnjXVZFBk4Sltkk+NK+1L0OIkt029ZaN8AKb7JwpTvels7nse4dskc7swSb9t+/0adakHXwlMCjKC+Q5H/hcfqpp2KiC6NA52eIPmQBR6V2o1LTrMX8rWBVXsaLHhN2Njk4jymc8F/+VgYmPRNsR8in/tqiCyJ7pHbA8wSZulV6hFComiSC6tjw0KSepEw0ncgy2MmbDt6erQppuS2X6F7DLzvP3fwXOHuhOd4gc0sGyrkSAL6arppVk2wN3COzcvU1o8oabapqyBp8sMIhrr6mv5iiyOPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KOTyV+8jaqNhj3JCWGoamqbhuyWV8zXbJTCxSImV4M=;
 b=Fon9ezrzEuhz2zzGQyGYbsMtyrSo5E45MzlO5UrqIruDAQihcWO0KHk1vHcMvo8EZertANRtBDJ/LTwOMuZMDcdeLvxBxb4heEf8deCofHZLBbs/IVLxuvL8PIpKxLNPtgX7vKcJdlgNpzsRDzrEMF4TTw9IS/YbbhNhXH+RgdQGyX3hD7sr6n9tWwoag4wO3T/cUA+0wpxUxNgHc4iv9mYNtp+mHgYedzg15Q/HiIhhTnVv8IlO6tq4HZ8P1HjPtW9x3MzXUeYQ/iWnOOMKEkAaUX0RZuvmq+IVLSno/S5MG1Yy3oeuKdjtvC/BfSeXbSV4pwBe22mqEjX6Y/rWXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KOTyV+8jaqNhj3JCWGoamqbhuyWV8zXbJTCxSImV4M=;
 b=Rv9ak2VWRz6ypMHOZueRJiQwHBOEioVsnXmn+L/Q0mqckUtXPyUjvkQbkFW3S1mMR7NbgXFWXg16hr/H3JWP0TFfrZcbmFNn5UgRD0ToUHgp3VC081Pr+yBAk2tZz/NvFiEnkfOGQnVdENNJVBp4Pf51bdS+AL37UUch9esJy2Q=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, beanhuo@micron.com, stanley.chu@mediatek.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>, cang@codeaurora.org,
        Keoseong Park <keosung.park@samsung.com>,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        jaegeuk@kernel.org, linux-scsi@vger.kernel.org, avri.altman@wdc.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Remove repeated word
Date:   Tue, 15 Jun 2021 23:49:02 -0400
Message-Id: <162381524895.11966.4351938815853847966.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1891546521.01622777101796.JavaMail.epsvc@epcpadp3>
References: <CGME20210604024038epcms2p2801b5b2e10e93ba4ecf5f6069bf862f1@epcms2p2> <1891546521.01622777101796.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72bb4321-45e0-4e5a-df63-08d93079be2d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB466327F91C5ACDA5D2AA70308E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d47HTZ2TqTGAaFBnBwC6gC9kcn5IycM5KhpPeJj2RYBZSXWF9YK+TOK00/P8afWOZO49DR5GJDt+aBpAMc45fZ29K3brfCzq8g+UEpyiOtL3cKNXTVSiPI7X1YQg3ppamRKI4UVysHx6ndWoywBjftAlg6YvVf2UPSaQbVrT8mU9dPYCrpMCT/bB/ThG933jkCozJcFJ5TFaE+KrCfzk10/7y+sCZ/maLLFgSJodtDqt1jWwSqWXKxiBzSPuAmJGjB/OvCSBeWRNMcZpl2W3OexsQCGVtEQJa3wc3HEr1NzOAkUZpQBwCxtw29aTNQWxj3FAzkDpUEKSOav5Vm60sWRZMTjmWukp/xRFqLQD/BL590o7kYEx0UWixH1OY6Nn2xxr8lfI89/GxZmYGA8xyP84cj1C2INDyC2mXuYiwScNyxOgwmvlcDQOHWHfr19R/kbo5KJPbUBb+cLQXOTDmHHVgZ8I2DYWQYl4E4WHGYI1UVV8UR1OYyWT8vJl2mqN5tE2NqOfNQnKds+EPo5mUViyc2sXy01kgYRbj+5hWh3jDUKqJ267F3gHFy8d7O0fbeUu49pee4PwpHpvp4Cndq+xajeZif6qW4cv5wrKosjZAjeSjdYeA8zCSrh0Gx2k1cCJl2VCMQFKjfhPB/6BBl6umnvzIdZudAqDVW49N5gFduEbGzPjuQTzb3cfD/RdtwReXQwpWEoFNyrXn6zN2aWys9/N3freFM81vRU7dmV3wXFwLrmwF5l5cG+plStB9I46iyVG7XV/f+Vr1MvTEw+I5O6xGoRcC0qzsEzYVtU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(107886003)(7416002)(6666004)(110136005)(5660300002)(8936002)(966005)(316002)(956004)(921005)(2616005)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmtkYVVNcVhUTnpWSHBNU2twdVVoeTJFeWZ0UDB1cjk0cWlrcWs1S0x2czBB?=
 =?utf-8?B?NTdFUTdoYnBWMHc3c2FaSW9vMHNON2IrUXEvYUJoS0ljeU43bmZOZ011QXpG?=
 =?utf-8?B?bHpzbi9IRVd4ZklMRGI3ZXA3QkdYNm40TzZvcHNNUTNuMHJFTm5UdWtpbTdj?=
 =?utf-8?B?Rzg1RHdvRzhuTVFac1VVOGhxcEwydXRRaDRQUVVDOFpOc25rVHF6Ukl3V1JQ?=
 =?utf-8?B?NTFQcFpqSHdZcFJ4MHkzN2V2M21scjFsRFNpZXZ4RVJBMktCTUxwbGZlakx5?=
 =?utf-8?B?amxXdHkra0V0N1htMVlEd2FkelZYZVZYQlI4QmVHekwwZ3NrY09RVm9VaHBh?=
 =?utf-8?B?Q1RuSTVpOXVySkZJM2tsUWxYR2RXT1lhb0Y5N2hmVUhMSXdycGUxL0pJZFps?=
 =?utf-8?B?RDhNUEtlNGVURXFHeGdPS0hiZEJkMWhyUlB0N0JMdFBlRGNzSFBjNU5MRGhX?=
 =?utf-8?B?WFkva25FWGpVdVYyMUJTVVA5c3o1eXVkcnhKajZibWpwbkJTY3p5aXJPTkdV?=
 =?utf-8?B?bmg1NjM5MkVmTkFDMHNQQ21RVmh3d3JDNnN5cUg3WGx1U1l3M3JrRStQT3lC?=
 =?utf-8?B?cTF5WlB6UTFDQUZqNVhDZnNBRVVCZktkVWN6eG1FN0ZWSkJRem5iY2tkYkRT?=
 =?utf-8?B?eG1tbDVrZ0RBdFVvM1k1eFBHM29CMW9NMHp0YzVuR2w5VlZXNHBkUXczQ0tT?=
 =?utf-8?B?R1BKY21rRVhHTVFXL3VLbzFGZjFMZ0JYcjUxdEVWN2VTUmYyUEV6QmpNOUVr?=
 =?utf-8?B?QU15YVEzS2MzcldGOU5RbnBIRDN3eFAreDkrUk52R01DcVRhdzFWUnZ4dTQw?=
 =?utf-8?B?MHhuTVFUMlUxL1dhOHF3ZWNJWXZVUndrQWFOMldhMncyRmp2NlMwQ2M1NWV1?=
 =?utf-8?B?VFhUUXVSSEdMNjlVdGZQR2d3UXY0T0s2bXZyNUlUdTBhUWdRUnhTRXFKYXhV?=
 =?utf-8?B?dWZHVThXQ3NYYVI0NktQaU9na2pyVFRRZkhyMm1QQWduYS9iZzNhK1QzbWYz?=
 =?utf-8?B?SDRwcFRhbkJjS1dJNlE5ckZmTXBYZ0Z6NEdGUGFwanZhcWFiVmZkYkFXNXNQ?=
 =?utf-8?B?ci85UGxKNm0wSzBSOE55a1VGODRmUU1qRHN0SFFsNDJzcjdBekJoWUh4Y1Uy?=
 =?utf-8?B?ck1jTDhMSG11ZFQ4MjVDQ3hJekcweEp1R1pkb0lrNG1VZzdQUVNkWStLOUxI?=
 =?utf-8?B?ZHU1aTU0WHhwUHc3MFVmNFZXUGE3cS9jZTZ2NVVZMW9SSE11NEgxdERKdU1z?=
 =?utf-8?B?Z1pUdERvZ0lUWWMxaHBTbG5EN0Vmc0lLOUkvZkpLUEMvSVA4cjk5aEZCbGFk?=
 =?utf-8?B?MHBSdktYQUhtSHNWZUVSbGI3c0duQTUyNmFUcVJSK1Q5RGo2VVZUVmo4RERt?=
 =?utf-8?B?R1Zqa1QrRG41NEZoaGNOWk9CRnZrclBzcDBjRDhneFowVTI4Qm9sVCtMUndr?=
 =?utf-8?B?dXFtNE1WSi9jdkEzaU9RVTc2VStMOGdjejc1bkxMTmsvck83V1NHOXAxNTZU?=
 =?utf-8?B?NzBENTVsWEgxTG9nQkJiamwxTGUvZ0VsbWJrd0dmWkFhMTA1cFpaYk1FL3lK?=
 =?utf-8?B?NlJGVmlNeFowQU9SR3NwN09weCtQTE1wcno4M0I3Ulk0ODljY1lMSUtDc3Ji?=
 =?utf-8?B?MzUxT1RFWUJneE9OMUwrOVdwYTBuekUwRWVMTnUxcGtPd0czV1JtUzBxWkhx?=
 =?utf-8?B?VjgyYlh1UmtOaXF2ZXFrUTcrNmNNenhwZ3hjbll1VWhiN1VycWF3cG5ucjc2?=
 =?utf-8?Q?iR85dnKT7JKHKR17Cm+7+N3cOCFWKQIgTTKx7iI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72bb4321-45e0-4e5a-df63-08d93079be2d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:29.1540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4hExqsAFt+vRgkWLp+KNa7OlEs8xro8oNh6CmHunghEHNTsCjDHFRUtf0Bi+BvbpKLLF4JGFY1iPzgzvBKeVxI/wWtcrbnlUQRcHup6QIzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: P4H4fjN4WRLE-wQ1DmPpMeV2ZS6iDCHL
X-Proofpoint-GUID: P4H4fjN4WRLE-wQ1DmPpMeV2ZS6iDCHL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 04 Jun 2021 11:40:38 +0900, Keoseong Park wrote:

> Remove repeated word "for" in comments.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: ufs: Remove repeated word
      https://git.kernel.org/mkp/scsi/c/32424902331b

-- 
Martin K. Petersen	Oracle Linux Engineering
