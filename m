Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947EBC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7178B60ED8
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbhHJDYA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 23:24:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20412 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232741AbhHJDX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 23:23:59 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A3Crut017993;
        Tue, 10 Aug 2021 03:23:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=32Ie+AwCF+tuY2xAtV0nrOO1rOwXny3RdIzP9WjqzqQ=;
 b=jkiqxsAR9Pc1mH+erOaK3D5LhU2A7WPMCFpjYRSuk4iBtV5h7Mf2Js+TKTWXm9w5ZVDT
 0rOzsEQ3lvbI/t8E8Yw3+ZKG+SdwkSWlld1UCmnN1Cvc87MvcPata9uiTNVi28nvHNd7
 X9EXxFAqgjY9BG64mnpsOYwjzC2iPs9iBA+6cXY4SK0lkdisD14Am9d9mHvRjW6eSsBm
 /Ji05D1QFzjX/jvKPym3jzv4IUUxmSdlMEM/oqRza3yMaAt2cFfq6XAsm9TuGKRBAyry
 8YEJPnVutZR8tb1dTzHyC20J5sox6tNrM6tdhG1vp/8IJ5xDbGKXhQJFdruLy0arq+jC JQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=32Ie+AwCF+tuY2xAtV0nrOO1rOwXny3RdIzP9WjqzqQ=;
 b=NN+A25cVLjl7Ui880wGXwsXgziSFu3ZsrFozU0MGkg0BqtELzR/vRF5f86FBHzt79AIY
 +fj4Dn+Sj2j/47yr4W++xGeNIl0K9s+pB4WPL8zdxxXeI9YywTeT6MzZzturjZQsMlrb
 amV2+t04QBTp9pf5hdc2LHmOo9LVGPIEcQRCsrO1pvwiFf+iikgVVLWStT/a7GUDXzdW
 5KXhSY6tG8EZhnABcoQzksw9qyVt8qKpwfVPQW1eGyvL8JfVD27HGEJRf/dtLfTkU08Q
 bqXbRB1yzZEalwMcGjXwsUyQ0ZWfZtS09wy5SyQtwyTsUwjnxhrwyRuEpG2ko9ntIgQT FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ab01rabsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:23:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A3A80j085198;
        Tue, 10 Aug 2021 03:23:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3030.oracle.com with ESMTP id 3a9f9w369b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:23:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpGj64kSx0XWfZ8p4we+UG9BJJRWMKzng4EL9khsF5RlrhxkGj1xUgRmeJLNn7M1IHYwixo98g7Stm5LeGZi2HxSt6xGMoxmYCk8WpM9jqE8r7xl6ttc04wEQ8wdosoEQxECtf3khS9NcQmI+ZiWq4UnLU5lnqRljTbg7G4XBNEgpfufqz6wwXAMLHZTAK+DY2TBFTPaS/hjEY+Fu4yjlDxMKP5oT1Kdj6kxfV+R09fnvYzL3acSQHZBFpHW/y+EElWgxkNnn+FXzdPQHmKk0WiEZcepWSsDwylKqpV7rS15CUG4HWRjhGqErwBDDKcLotYh8QQvgIhbPRR6M+ZHSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32Ie+AwCF+tuY2xAtV0nrOO1rOwXny3RdIzP9WjqzqQ=;
 b=QZ3zWKtQdYAdydQT0GRUuLGJcP0CTeTIHScw5+JItmcWeCIqvWgn6orFMYWl5jgN7OLPfzm0TkF7IS+jb+DCcSfQCuhYk4YOoQVfi/9B6JQum+AhwMdhGxamEYm7IL6ARGBOtQB7SRgewS2t0H13zGCho3SvrWL+Fn0AtVN1BcCjqtQhVOPFcr4yI+Jj5JuYV9oqAVXnaOki1hI3fH3MCer+nlFkvKDt0+pt8Q2knTGWOLK8UVT6dLaMM26ROef5CkbfmTFWwA0pCUsIIaU07slHwy7X4pqa8F1FG9c27TAN9NhxNwP1hkNztWukD4E9aUE8owh5c65HS0X4SUx/Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32Ie+AwCF+tuY2xAtV0nrOO1rOwXny3RdIzP9WjqzqQ=;
 b=bCkfesEVj5YwfVNYp0Z4ab+h19hjGKHGITNpo02Zp9XkHfa/q9CbF1WC/Yjv0bzasZvAsnn/H5cR3EJLG7TFG5VQWikBWMDYE28Y4hr1cqnrcwSqZ0CR+qhIirKIY2OvWbzEAiMR6YJECT6AFrKz3/gEfTDBn+apZ0JGn+bAoTk=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4471.namprd10.prod.outlook.com (2603:10b6:510:38::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 03:23:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 03:23:26 +0000
To:     mwilck@suse.com
Cc:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] ibmvfc: do not wait for initial device scan
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0kuvvbn.fsf@ca-mkp.ca.oracle.com>
References: <20210809094929.3987-1-mwilck@suse.com>
Date:   Mon, 09 Aug 2021 23:23:23 -0400
In-Reply-To: <20210809094929.3987-1-mwilck@suse.com> (mwilck@suse.com's
        message of "Mon, 9 Aug 2021 11:49:29 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR05CA0053.namprd05.prod.outlook.com (2603:10b6:a03:39b::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.6 via Frontend Transport; Tue, 10 Aug 2021 03:23:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8011fb22-48ee-4bfa-78f6-08d95bae379e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4471:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4471DEDC982DBDBD0D7E9D3F8EF79@PH0PR10MB4471.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FhURIUhF+IeYpl7/kge0nr2Hs3MFyrAr1O5J2y6fuVdjAWaWqHy6QHeQCPqV2XB1olzugxvEBvXD8SNV9+RVaJacRzec4nDSISGOCspCSBpQfxVbPV3Tc1vLkgq40/xmPDB+bzA1I6bzTK+ntO8IvtoqonjErBhMChvTkmaUwAYdipzhQc6emrNB2wEnsfZOP8kUyS4bjDnFi4U6JUOpcaPfkDwbvcIxplDPF6X7BP5+rkPAnv/IPzIyptKg3BxHwBSblgDRrHCMiQcUlnx4tGGzrh80heIyMSgEYs8TOutCNDJH0A8aLR1hPW70BiOm3aUGKTYgaY5IfQR4buKTsdNwnq6zORgkwdycu3apx8V7s1DZvImcnLZ9q5v1mb/kTH5qpfAo6df+Xp8Z8s8h1EZxVLavjKL9iPwryE8oCVnBBBqdexnRoQUDawuAH2P9+Pj3DOzeDyaK7kJYHWuNj0VZoSnWZTD8Kk9aGxPqJ9zDEn8D5p8T/Z/9KP9HDNhRB5Ma6w4AMzf7az1b/mwSJKHEqFidhxISmVFt3pgU+77TMiCRNpbFLwK1GkkT5NKZrK4n8ue+hAnBWhbvBHjS6iEplOSTmrFdCQSTvJgeQRJncIyCmhihcLkRK2+5XjKzRpXYet1zgvY/wnqrlQcRbWYmqqRpGL0pUiJeJJzX9G8ETWZJlmIwqnKNrvAm523THGHAXoFZodccZKODIzpsgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(396003)(136003)(186003)(86362001)(6916009)(6666004)(54906003)(66946007)(8936002)(26005)(66556008)(8676002)(66476007)(38350700002)(2906002)(478600001)(956004)(316002)(55016002)(38100700002)(4326008)(7696005)(4744005)(36916002)(5660300002)(52116002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KpSD5CJVKFEwWkEXRRoWApVEVs+rvzzk8AAcEezPS+yazd1Drv6lm8iOLRFm?=
 =?us-ascii?Q?AROpw7zhPRwVqgeSb7EfVHaH2mLXpzMlTZ5tbIQV7fshOl/KDE0yWJj7MAjr?=
 =?us-ascii?Q?Bzioyx/HVad4pCIIw6rXVQ7fyhvHjqlCdrQq4Q4oFSx7n9dmNs3FGyGVxTlC?=
 =?us-ascii?Q?kbRhfS4hdz5VbVoYMew637ixCo9HzBrYMOnUtXqkL2lFPU88h4ZmSbQKXF23?=
 =?us-ascii?Q?0Z/a2tJN/EczF6mEAbf0kTsLgMFWIsy4oFH+aGBugDPrupWwwgKptqCRHR0v?=
 =?us-ascii?Q?/5X2NHg/GkAEeYwvvqB2uSqVlZIPMLJVdXoE0W5GLu8jASRwnQc9N45lAaJy?=
 =?us-ascii?Q?imNdzyxExrAOcpyDAEMy5WvAGD8+vBG729JJm2uRsxe2MvVTfSCPdJH+iB0M?=
 =?us-ascii?Q?2AGp9Vhza3OBVRQ6if1D1hOLTFhF0G/G2ePVwKGpbg4hjkxfvIIw5iIf3Jpb?=
 =?us-ascii?Q?JoedBcx3o0eWtaqRhFjPf70hj20gRQya75f6wNeGWJ661t4VhKsiVbPdoosK?=
 =?us-ascii?Q?+P4LKvniScMAZrQGWp3ByflJVZgYCtizQ3mJK7lId4WcWUil+PNts2nm3HwN?=
 =?us-ascii?Q?K7JPsiuUWfCJETPJmVs1y+z+/snSjCgwcRmKpmp1bh5xaflJ7zAWZySNk4oE?=
 =?us-ascii?Q?jhRnspyoAQxqwihxA+1iUJ5AUn3JWA511/SbY+IDUjGhe4bI0vTfY/zXDWlo?=
 =?us-ascii?Q?preM/9+MlU6/LEo0TrJHLNgspWeOmPd39yfPsOPvvmqwcN7AONlLHT4TW9/8?=
 =?us-ascii?Q?fVf1akAd1Ux92DciFEVxUDBM/i8Bft2+1gi7BBYfelqWRiStS/2CHL2QQynx?=
 =?us-ascii?Q?167AScGm2/yuchn6v4ZVm2cvT6dlbEiLkCZv+E1AxzAtE/YT68L6k1sUJ7yH?=
 =?us-ascii?Q?4+gPJLwxiI6kHOpEc/0HrH3oyciAVIQlsk6nLI09uVNV+CtCtApFz+SsR/sH?=
 =?us-ascii?Q?hhQBzityyG3rtZ2AyjtfmZnneTxesdU5qTy2Z7E5/XpWQ5Vr37shBXhwWZ7Y?=
 =?us-ascii?Q?U6SHfNy4En+POyrBfODGNYGPi7zmMJcz/hykw4+6yhz7DGP5475PQ5GOZpze?=
 =?us-ascii?Q?AzZu+Qo38YJ553CQSwcnzzaTs75r7gfp6JI3Chc83ga5w5D4DRKwSpWo3FA7?=
 =?us-ascii?Q?oQrHSL8oylV+cTgJ/40iYzjk3UwlRY4sYWGU2gB7OGqj48l7jrVj5AfkqJUX?=
 =?us-ascii?Q?uwNLJPu1MJwe3aaLSqOmryp+nyrUDP1dKgqbnIzY2L6RXG1dcifNk6A8aIec?=
 =?us-ascii?Q?R9QkM2GbArP8hFTGxV2ylLwtTiBCajXYVYw7oJmQgCb5tt522CkAP1xsrcsh?=
 =?us-ascii?Q?zUJW7vabqrqURmNmeGoP/7mH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8011fb22-48ee-4bfa-78f6-08d95bae379e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 03:23:26.6211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q336GepBLXxIXFc3xiZYkdkH62jtjU927kC2e654owrXlOClOTXUg5dktn6/wk6SQ+IIcOi10vVRzneQDN4dIZf/Pg+EkilEFSDZmpERWsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4471
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100019
X-Proofpoint-ORIG-GUID: -l8jmptlTJ6y0fCEfycyW54fcf-rC45P
X-Proofpoint-GUID: -l8jmptlTJ6y0fCEfycyW54fcf-rC45P
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> From: Hannes Reinecke <hare@suse.de>
>
> The initial device scan might take some time, and there really is
> no need to wait for it during probe().
> So return immediately from scsi_scan_host() during probe() and avoid
> any udev stalls during booting.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>

I'll let Tyrel review the functional changes.

However, your submission needs a Signed-off-by: tag.

-- 
Martin K. Petersen	Oracle Linux Engineering
