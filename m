Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75329C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4142B6144A
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbhEODEX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 23:04:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54432 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbhEODEX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 23:04:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F31ssK062264;
        Sat, 15 May 2021 03:03:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=GAl7mObnIHGR8EXf2+agKXNaDXZmyWM+r/VEFUTwlo4=;
 b=H7i+YR8naXO16XMRlP+0WJWV0WpR/e2Fgm3xL/aXTzQCLwBopHm3+f7dtUnsfwfn4sc2
 ctXGa7SnJDUo6clTnP8HUYpji2t4k/1A4aNZri//MdvfVKwUYONRm4TtFUFI+8/CkuEW
 CiQynTgk+iF2qshGIWwFOlzdCSpRt0j/cEF/6lPgU2nrtMFu/jf4Gobxgve3X7YQ2wEw
 BVNzEN4+EkODeozlFtX0hCtccGSZcFwDuUs2HYsw0EYPTTcJ07h1lOEL6kXL1EsD1dkD
 6fCOsu9pci7vWtphElqdYoH25rA6/Ae3x8Kt6hjCC3OmlQXtW3Se5vcFDvuObUrq9Ty2 Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38gpnunm2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:03:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F2xnaQ068166;
        Sat, 15 May 2021 03:03:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3030.oracle.com with ESMTP id 38j3dratsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:03:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G21NU2/FDvgDZO5zhJt5ycm/LkST5o8tKGZ2nKmaAgXm6Vi7BvNCAQh2d8OqwR8BMz+HXOTQKGB/hIf2DWf1SsgFNPiyTc2orzPv/o/xw9pHOaiyEDiiu5hIt/8h/zCTQQXdpkTa+GHOWCHoSUraUY3oSGu8qMOj1053kJD7ycUFgGNQ75Y++D+DkoJCskfBns6fcGUwx6Z0Bu1vljVmTaehakrra39eiLE+kj1Eib8zdRT22muxtlCLcJrunK1ciIghHm3W6Lc5zMzvHWg/I1Wl7PcGTu4KckV74av195zT9AQrvIUs8cxgfBposm/t3ZemndVyLzSiA226dg3LMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GAl7mObnIHGR8EXf2+agKXNaDXZmyWM+r/VEFUTwlo4=;
 b=Z/CRJw09SZAJLEk6UWqPZb9O5nIMoYd8K02faVcvYE7tKdVFxNYZAQaHlS3j/KvVHIXoS+F1ryA9JtHD/mCUE22x6Tf0vfML+RkMBAwTuhrE2DI1APIrwNdj4AQ80+YVpRl3wUT6CnTraVjwOcE7ONbGIShmcDpWQ8XDcX3QG9O7ESXd83ftdczer+flfF8OVAI/QcQmfIwXYPqOdGJqF2hj4ZIx1oHNwui1883/7qsNZ/5TyJZQtzGxKN1Xh9npCK2Wqw2SMhq3uO6Pt/F12HKy+Whoc4nMsfnKFCdNSs4t8U/7dCVLuDrTTNnII4SFMIHYS484bd3BemC3ggaE/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GAl7mObnIHGR8EXf2+agKXNaDXZmyWM+r/VEFUTwlo4=;
 b=0KbonWrKO9fguHVKR/hSUt/dkwS1BbLXYSLr5BSl2KRL5qFw9/KR7djPPNiVi91YH+FXnl2HEW9n2s6X3kG4KsHtdVtmeeR0+PMGTG6YdMPf/vnocfLQW5cNWA/3V00Bd6/IxPk8IDr5Bfgm94egi/BB3L4F6ac0rhX1dISovRE=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4773.namprd10.prod.outlook.com (2603:10b6:510:3e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Sat, 15 May
 2021 03:03:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 03:03:00 +0000
To:     Brian King <brking@linux.vnet.ibm.com>
Cc:     james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, tyreld@linux.ibm.com
Subject: Re: [PATCH 0/3] ibmvfc: Move login error handling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eee8aecn.fsf@ca-mkp.ca.oracle.com>
References: <1620756740-7045-1-git-send-email-brking@linux.vnet.ibm.com>
Date:   Fri, 14 May 2021 23:02:57 -0400
In-Reply-To: <1620756740-7045-1-git-send-email-brking@linux.vnet.ibm.com>
        (Brian King's message of "Tue, 11 May 2021 13:12:17 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Sat, 15 May 2021 03:02:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f575bd8f-f511-4435-425b-08d9174df29b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4773:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4773AB145F6CC602A3812CC08E2F9@PH0PR10MB4773.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u9Q/2c2AHWZhj/8rbRYM3Y7Oh4g3c+5DsgUUaWk4GhY/zO9p6mp+2JkmITepiNhiS6TPMpfe6c2wxTEQd8uPIRcpKr8Awldvfm0VGrhfgz8AM9JbA7dyCeKTDRXeN32dVORV0bkDCbim3UHomhfa662TpI5Qah7vwq4asrEFJMpD4YB5fpaPC6P3TfFjyt7XjpYS8njDU1dwwWXyzaLF+v2BmWsMCSMEsmRlh3vYzKlYbGpoQxNLgChOiJpV9SrKoYoSx/YSX7E5yDtwv84kFLLzuwd7y50wXZh2udBXYpKSW47rqga3nL6umwpnSJ0PWvGD8hJT88DZEjUvelXP0lZDVvpEk1LZ2UkOGRIP0Nq/gxhZqvbt0pCk3bzSeBB3XTPL/JrhYUkMVJHdZjsM0haqiDp5Nlz4wueHiFWykKVTe2vQiS/2KpTmxUIBthZ+fqniMkdlKKqMb8hP/KHoyXHnF/+XBAH8NkXqZRcFGP/q5n6AXHlmxUgOaAN0+ismm5wqE2P6h2TGxxKDNbOjAdMGKIGzagKLb4GigD2/58X9cQDeogx7Ywolk88mc74/d41rkOKSxKlrbbq4JRAs39/uapszdw/798utX0+NsTRaBXdBhskf9Zibffa5CioeJ/Bjt+AKKBgLQL/NwqzwzqtR8xM3EvdNVX6Frf04F5U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(136003)(366004)(346002)(83380400001)(7696005)(36916002)(66476007)(478600001)(8676002)(52116002)(8936002)(26005)(4326008)(5660300002)(316002)(38100700002)(38350700002)(55016002)(86362001)(558084003)(956004)(16526019)(2906002)(186003)(66556008)(6916009)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BuiuvHwPKKqI8M5cLEFzBVe1TfyOJiov7oFCf2VuipE07lYtAuHUE0GnLecl?=
 =?us-ascii?Q?jU/Whxrz4+GTTQ1gurXtFyKIJ6NN4ixe54oa5Sx0jfY4/c6ZuTHmzqgQrbdj?=
 =?us-ascii?Q?FObIKJywhFx6o/lM4V/JUpG1Q/bDtxZ1/P7DHXhgjVIeTltZc+Cade5Oj+Bt?=
 =?us-ascii?Q?cD9FV7NZXjJwPaBXHyYaV3h+zliUevVotal5W1yGZMQQrF+BUx1V4h+UU7Mz?=
 =?us-ascii?Q?TebhtbKpN3zyfyd+izzpR05yCeNYeiraqFu5dIy5fMiBeY6tZS2sRVufcWQg?=
 =?us-ascii?Q?IgQPBYGk4DG2ZrP8Yvrg0cTOiNlV8I4s1yQD+jd3YfCY5kfAUhSkREKeeOi+?=
 =?us-ascii?Q?BpuNVVe8UaNKBQ5C3PTaMTLLc9sUWuzToh7sopk3pb3cS7jNIUBIaQfh58d1?=
 =?us-ascii?Q?CqnSx847ve20MywhWcEzx+M+XkTx2riaIZDb73I4ulE3TQDqOR5in69BBbnw?=
 =?us-ascii?Q?AhbWhTIZvWoMFdvtjGXMLaytZzPWUNpypvJQ9pdfgsqZ60p11xqR9C7vKxMy?=
 =?us-ascii?Q?tn4aDT9a1lsQpmm8FIFiEgTuValCGlaODMd6UsKHf4km5DcV73xlx8XycDWt?=
 =?us-ascii?Q?79Dg2Vfsn9TW8MidYkhK4tkMr6ZH36F34/6TK9/UXJnDriWRyxZjuxbsoUCy?=
 =?us-ascii?Q?dHwclvbR0fDpro4ODkmigoO6mOHR7/CfgeCxcfd9NeKZlk8s5Rwz+ekJccac?=
 =?us-ascii?Q?WL+ttWx7FnQHlvUybCoViF+1zTE8aQSpe1L6nqoZWCEQPrNdKaHD1pwFm40B?=
 =?us-ascii?Q?ZA6g68Y845/vIpjY+zZXM9XSZnVPPIJSIVT2P6tq3SFan4Y3oZyFocqZX4NY?=
 =?us-ascii?Q?dfEfNvnAKHY5muZ3ZvqYOjjbJvIMicUoTyQu6ELAqFH+qe7JJIQTAh1NGmTd?=
 =?us-ascii?Q?uTvGWnkeEPNJdVrdFjiylXTH7+xK5nECtJOdNuvMSHOZUiO7SYHg/Ih5MAj0?=
 =?us-ascii?Q?tv8ARwMCpapaUb0PpLKdUuObDaYJkrkXnimIwe0wGzXZPptVTcRHBhDwW0lz?=
 =?us-ascii?Q?mg7DvEoduE0KIAW+vLe4P1caL9WR4n8Nm4X5EbR4UODnMhoovxaLDrmYR/65?=
 =?us-ascii?Q?alwUo0GuAoy5t1phTG0hVUKmTWlwM2SAVQ7OK2s/xnzh19s92ilOj/7Pb8Z/?=
 =?us-ascii?Q?ANwAeb/zV75d/d2tC0JO33EJ3o+vHlgA4wGpcH6OiqCM1j0u+3i7ghEDsJTY?=
 =?us-ascii?Q?NvXuhWsNpVXPf2HnCOIHxETIujvif0pJ0Wcdn6AFRCvIKnGyRRGEHQZ72wjB?=
 =?us-ascii?Q?+8yhJQM8VsCCbzz5rBwxujFqqp0pQwb9Sx3UiX9FM9etpGlSA3onr60qd2h7?=
 =?us-ascii?Q?KD1OOPPgvdwme3/dI4TkZmzu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f575bd8f-f511-4435-425b-08d9174df29b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 03:03:00.0992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qwua3R+iMNFbemcEZIVJGpBA7SJ4X2a3OAbWGd6JCs4apz9m0vJLtuBdUXv2sCgcEjg/O/ryUI46qz/yvPeu6zDk0DHtIR2nJwRs7nu5Neg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4773
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150020
X-Proofpoint-ORIG-GUID: 7jjSovoogW0sAuIubuepQuNFQUpdM1o_
X-Proofpoint-GUID: 7jjSovoogW0sAuIubuepQuNFQUpdM1o_
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 adultscore=0 spamscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Brian,

> This set of patches makes the move login handling in the ibmvfc driver
> more robust and resolves some issues seen in our SAN interop testing.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
