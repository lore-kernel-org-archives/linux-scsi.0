Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E18C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 927452070C
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 04:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbhA0EWd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:22:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44262 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbhA0DK2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 22:10:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R38wtr062670;
        Wed, 27 Jan 2021 03:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=YQ0J/RJXSm4tVqxdzJWOF58HATLV7ovwr4gcvkSizNQ=;
 b=noW2KIeM1arj1244p0cDO3NHUE9A+R8PfrO/iV0uFehrqumRWZT7AxVo+HJxeWfQvam5
 9zTs/naEXyd7zoX3rJs8TEVqEXgmORmpqiwSgJ4tW8s4tBtZqmoo423IqgAM4l8DRePv
 4RjbZC2KXykcJXEKIsTA3sQASUFe+DLF+OB/7TRtulDX9avPiGRcYvKB3m/RQBARA3SJ
 mpGzZ4Y0ZhwQn3TgslWNVIfdUEUubLrfB34tTXLez1yAjQWBHn2dwP3bTROSSb84wt26
 D7wgDzPJsvkf5b9jtLcksWWLSQsiG1NMvWQuQ95pynnQJeRaNSEGsLJhDM9BRryf5B5D Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 368brkmx1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 03:09:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R35eQZ138664;
        Wed, 27 Jan 2021 03:09:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 368wjryv9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 03:09:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6n1XsYbT3Wu2Ub8cVBeQtpmCk/b6OafUJUl6zPfyuZhx+o1o7FRIAi+qISK5ugmutz9Pp5lqIySHxysoxdrCueYNjE50QTkxkJRD2kYjVQMiRRt4gZGsxikkWDcW7rtEHcPI5h9+o/NFOgTKjB0l2jfcTjS5BI30cmX2eiyZ3RH2wGfruQGtJI4jaDPBKl45HnXu4Y2SL0o4eCNG9N0uN1Xxex05js63/KWpTmTumTkCljYRyoej0V9cfEa2EuA1a1a2n54VwVhYMIriPhQCZLVabCj487EECbQIKUGqP+OkQLneagMzrISwjeWvmzFFjkPtN28VyRIDPvypBBspg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQ0J/RJXSm4tVqxdzJWOF58HATLV7ovwr4gcvkSizNQ=;
 b=A4V12+0lBvOkxO4yiGdlKhyo6oZ7vudN2K7P+r4JjRQR982BtY0UVza3a9t06SxQIhigfje0+EUD8TJbeuZKMXVQEOi5k+l4NyRispb0KSJHOjwoxCDBoqai9PuBPz4IWVNRBesB7mYoxOWkNeoRbPnIUm0cT9mJv7fAEYoDfxonT8v/QR6qsxdiRRmWEdrjyXD2JZbo4cjf9RZ+79b9023hgP6KJZKuF2aFN+1RgzwFxDoYDPWTDTKLPNTqAIoX0SnIpRwhk7VtfWZ4g84v7xyrLPgXXpQTwRc4yu1TGlHu4Sqt16wG4kWbRGSzFoq4sxNyCJSIKb+PKZvkBmuKhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQ0J/RJXSm4tVqxdzJWOF58HATLV7ovwr4gcvkSizNQ=;
 b=xdaD35EdKmSvsQWenoE915YuFxbeHDS+peZwT7T95upUqrdRzb593FDYHQU1ucT5pb83wIv7LDBcm8NFcRcB2OgYiqAtS0XY5/drouCy0X+iQo+315ktecQr2I4/j9OJX8PmL+DCBwnheSm7thG+tG3pjp7lwpe4P2FJfPob81E=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4423.namprd10.prod.outlook.com (2603:10b6:510:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Wed, 27 Jan
 2021 03:09:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 03:09:14 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@steeleye.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Fix ancient double free
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bldbxei9.fsf@ca-mkp.ca.oracle.com>
References: <YA6E8rO51hE56SVw@mwanda>
Date:   Tue, 26 Jan 2021 22:09:10 -0500
In-Reply-To: <YA6E8rO51hE56SVw@mwanda> (Dan Carpenter's message of "Mon, 25
        Jan 2021 11:44:34 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR16CA0029.namprd16.prod.outlook.com
 (2603:10b6:610:50::39) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR16CA0029.namprd16.prod.outlook.com (2603:10b6:610:50::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 03:09:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b9e1634-c644-4998-6d76-08d8c270ed00
X-MS-TrafficTypeDiagnostic: PH0PR10MB4423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44238F4081FE0002F3F7EF458EBB9@PH0PR10MB4423.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yTU4pZDJ2/q8OqfYEYe+sr7rz9uuPmnMYFnVMFld7DT1E57Q6+G7jtnN/IhtQJ72XDY47ERfVWqQAESm8JWbVgM00ul4nGJFoBJe8ES/PpOOGS8OifyairrSSURICC/hjBJ6USMfsGc1VMXphDqyY9KAav68WVbi94ePE3U1m2usxRbpyDK3Ig66TRea+SYJjiv4vNz3kS02uyS1fvgOvXd5NH2aE4hgvEBAHC5F3SEQNYL7Su47hynfup/R4oPBylndO21kD3PezxwZAkOEVzde0BnMyxK27VucgyqNYDd2Dc2du2S/k72Q9v+muooWPVSW3lGSYV2tvyjKQHtXuhnEAKaqp9GeqgI66szyPyVessTrWAtLllYRAmwt2z5ldDfH0lPob2zW/A+DNGBeelPsvXhLKRXOZtSVUHlmB/EBA2/3HXmWkvoJcakZVaHtssO5XBU2ROtmxMXST4pmLDKrMUrzai38WdFEMio+t9YpW6V+saJd6lKKjevFzVKxQz+hFux5WjX1UJaROXVx4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(346002)(136003)(396003)(52116002)(558084003)(5660300002)(2906002)(7696005)(6636002)(6862004)(8936002)(36916002)(478600001)(66946007)(16526019)(956004)(4326008)(66476007)(66556008)(26005)(54906003)(8676002)(186003)(86362001)(55016002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TWoluLT2ranW5GQNf1gkNzHBqIU9CwfHLd71Ozq+Y9mGtwCKhf3rIHtN5yKf?=
 =?us-ascii?Q?pa1yDdmi5uGw24r03PAHi9aJQe6TdY3qtr30XORN3SXSEjWpt8qGKpslyE9F?=
 =?us-ascii?Q?TRW4p6hs6aV9iqNgUHbGsYWV4bCdA+YuC+LZkY88MhZlP85NacopTMZnHGGw?=
 =?us-ascii?Q?luEIHZhO0rjz2cG7dOnP6daJGOS58BNTwH7tgfAidCc4R4CRAPEGmgkxDj8q?=
 =?us-ascii?Q?dY3xwizM5PhW3NI1Pf5W1kBIVvsw/AWPHP3hJcxZBmK9bLATNAUHMVVQh6Pb?=
 =?us-ascii?Q?R5lBHKJW9t8Q9pD6GZbx61VTzj72ZnaTzvKpM5fkOZUxNcMZxfL5qto0/fdD?=
 =?us-ascii?Q?PieFmysa9/Ox68Mt0BHwJM/G6mJKOeWBj32yfdxnmZCTeDhaf+6ziI1LqLQF?=
 =?us-ascii?Q?wInc1F3WnvKsXRYyQOZkg0nzWtFU+SA3tsUlZB6mdWTfuI7AE5lO6WDfm/aZ?=
 =?us-ascii?Q?bZn9pzgVRFVjZccm8zuDpsyL6EbkR8CRor5QVgYgm+4JI2vXPX4UtFq4d2dR?=
 =?us-ascii?Q?eNFCNS+rBPoQTbUaJ4Ny/4avGjQLB2P1DZMZL+7xSlb+F1COL+BxMaYrUBCn?=
 =?us-ascii?Q?QOq5OnE7A3/pFr5pRV1OLxQwbbPZDe4dnIYW6WUbBYgcSZhHovoEAd/gv1JU?=
 =?us-ascii?Q?WTDGzKm59xY6msiKlY4x+wZlelFRVpulhR04/fe0M7uC9HuTkN8vBg9KZDCQ?=
 =?us-ascii?Q?LYfVCFfmPPO3eOJQNel+Pt0x8CmVicspu7z5hz7WBVe41xq/S2PBwF6v3VJN?=
 =?us-ascii?Q?+dMO5yxkwISVpYD9VKaEpn+vCGiSPp66/+ALJSp//g5MT2X5ObeVsqZgWbNS?=
 =?us-ascii?Q?ucrqIUj8hpcjCt9vxSXOXrm4NvQoPmJ2CnpO16XFCzc+HP+MVNKGkCmCE5tP?=
 =?us-ascii?Q?3RH7GAlTju8W7FxyqjsmHjXkGXQEMHyFVHXD5HQiR78cNjgLzFM7F+eB2aoz?=
 =?us-ascii?Q?1gavmfDi1rY49uAVnjmOvtHWJhCLJVz06Ag1ogaW0+tTcNZfhXSqW+VBgG69?=
 =?us-ascii?Q?M7o9M++S8K2FtGsNTEeXCM0rE2Zxl0b8OjwVU8jlneArZpG4TGWyJMktzFEw?=
 =?us-ascii?Q?jl/15xLs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9e1634-c644-4998-6d76-08d8c270ed00
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 03:09:14.2175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uSk76RcoLl5mwkRD2VCZjHhBIuWYqsMN80AQkNE3JX65xO+kF45SCGKB1q3qcdcXHLSEi1b0z6PW2FYhHtvvzNM8pyp3ELri965jFSKtxpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4423
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=835
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> The "pmb" pointer is freed at the start of the function and then freed
> again in the error handling code.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
