Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9809CC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A31E61184
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237733AbhDPCwL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38898 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbhDPCwJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2o2OA047446;
        Fri, 16 Apr 2021 02:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DlhMR5zmaC4rFjmMVr1rOGzNfp/tzf0nKvCJ/MVD1lg=;
 b=Kgnn5I29ntFoqt4iBAh3U0Qbd4CJpGo+ZUJRzkRKIntVP0vIKkZ2wnBgns9QJp1AHckL
 8DrlpigOmg7z9Ee4szkr68bLt8mVfrlVWT5TYmRIhlLbZ4hJgAQXVAto3m6451YINKns
 8MW043J1ISYZ17p3C0o5x2BHg2wt0DphnDN/xpLFcr3e+tWCx6mqaXbJ2h74Wa1eQJgD
 M4cskvfaQgcKAa0d9c9uQRUEZ9VPF4BbGA/kNglHvxLKJlFFem4/XCv+KSgZ2osvHxWi
 //+6DI19Q2GzNZX/b542/OpPaOAb6k/u4Otd7hCazj33tWcFhQOUV9VvrZlpXEbe9PyA ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37u3ymqpm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2pcrF044945;
        Fri, 16 Apr 2021 02:51:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 37unswhm3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a82SRFca2ZdLkZSf7I3INrttB5Tyy+dUBytSOi1fWma7eNRc1OoUV6RjDuH8fg/Vs9VMUQS2lITcNUCDWBrjBGV00aKoZNvFtdz+4Lf1D6shmIYFoiFBD/cIedFN79C/S8H5ZQbXxzj6iib5PcNCOLvpORhBfApSrScuChtAV7GcZfxd2MRKUStPj5nDPJEU+Cw8p7r7QWszWrxZ+ZdO6VNwRnIf4U8Flg920tqNOeHzDRXCzeS1QezDDHGackQ+GR5K9LYS+ovVxIZTjbZ+t3YBrHC2TJm8nFoVT7WHHVKu3cmVFWngYxPf52yN+zrbD7djYVtMN5W/G6OoLuh78g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlhMR5zmaC4rFjmMVr1rOGzNfp/tzf0nKvCJ/MVD1lg=;
 b=U8hzfrR5khQ9BcZMRpySLfm4KJuNiee72qnh1ejr0J78qPiNsT7RPK/cQED9gFbgmn3ZA+exbyeHHpxz+cNn1HpXf329LE+cuSulJQiCpQf7OaqvxReXhtFNZl5FhKFFVVmqedRxLmYluwrfQMGdGzAwTXhrwTj3ZtMDZET+aCRFbqpe+s3K9smHSrtlUyzR2g/EwmEbDwKOdvEc/BZyWhCNEYYskWkYc64kp7s0wClPMgVQSbKPG+u8puu3dlew6lQmO6tFJiV0kWee8IRlOdSGQmhQztSfQ3RRV6HB+GlF2iAEpVJvndl6PwF7MqYHAJT8ldjwVS6xTeCmR7l4YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlhMR5zmaC4rFjmMVr1rOGzNfp/tzf0nKvCJ/MVD1lg=;
 b=VU3GJu/NF35LX7SZkgTYIgVujkUEn3cUfAZ1PU7YmCElu8amG4y+4DBA0eiXpJNmEwZP3O3vQ84kEJMSTPHAMpB5CRW6R8K+lDoCyIEFEKgJKZw5Ai9lM1nUIl0xaw+FWU8SBElF7XGsNPA3alpvITIXZKcEIfK/+y/2tnv8i1s=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, njavali@marvell.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        GR-QLogic-Storage-Upstream@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Re-use existing error handling path
Date:   Thu, 15 Apr 2021 22:51:05 -0400
Message-Id: <161853823946.16006.16394345804274426689.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <6973844a1532ec2dc8e86f3533362e79d78ed774.1618132821.git.christophe.jaillet@wanadoo.fr>
References: <6973844a1532ec2dc8e86f3533362e79d78ed774.1618132821.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 459b83d8-be47-4723-ef29-08d90082877f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568DBB6A70811815287D64B8E4C9@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BXERNtiFWnqG3tLCHNryyXzqaGygQF3ZmgZQKy1aqFegxiLBfqQXZOvQJkPcGuPTe0XF9NMDTTkf2bCEXiptmaX5zQKp8dW03wG1ykZsaEnLEbURflVbSaumDEe6eawBjp59zgEvjLVUorIiDIfOKQorsJxuZ9OXfrjqKrSbLWmkFAIv6Gb/8xVjjSpsD+wotX/ezNr20viMsCQwEmVFS4HxlGnc5hs3jG43dk/zEOjaSR9ZWTWX0Ez8ZMCU4rBR3TwLzOsofd/ocqOA9A0imdf2uU7NbVKdB4XEdyJv4wXLXlX/oYBXGD3duf9Rk1tBTxjKFLdg1pC4MMrW36sOygkUijrQhwO2wtJc1RFwEEO2dSZKHW7VFi/jUuwgs0hEcjIgGyU8NUyMk0IjxboWSmCAaF/anZEpgsFWFgqEBq18Wr8WMjFvTOSM54iz0VS0ODlcffyORyw3N9zVjjMFGRzq41i+2vzMNk2v5i+p99Nb5poDhbSvgpLeeWroh3iVAVEDC5Lo97+YwmFZEMn6ibRbMISTHqCLqQ6MvDTIciiRBJJ7K3Mqt+WckGQUZbfP6hZHp27oS633/N0Bk+HRhIMLNDBk58q+z7Gub6opc94q6fjd+IPh+wF+H70bCmO9xMfFfL3Q0wUiLl5TQ5sWoOEpzpmZbBF1ddy8r74cl2WZS+BdRHftVF5i4jB4cesXf1FI3s1aWBJZ1Ng5xJ+3qEguoKUIkGtzyp9XP+LQcag=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(316002)(103116003)(6486002)(5660300002)(478600001)(26005)(2616005)(956004)(8936002)(16526019)(66946007)(66556008)(66476007)(86362001)(4326008)(8676002)(186003)(38100700002)(38350700002)(2906002)(36756003)(966005)(7696005)(6666004)(52116002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aVVFcEdTNHRDNE0yWDBwcnN1NE9qRngxZnBUUE1FQ1kwY0xWb08vLzZOT2FN?=
 =?utf-8?B?RnU0dURaQzlKOE5sV05qTjluVmpVckNXT0VTV0ZKUFcrakJyWTNObUJCbGJX?=
 =?utf-8?B?RDNVdXNhenM5QnZmRXJYWC9Lb3FOM1VxaE1mbGVwT2tENE00Uk5mSmQ2SnJ2?=
 =?utf-8?B?S2NIa21Fc3N4aXNMNTJadHRBL1R4a0JMN3FXU1J0cTZ1TmtlbEdLNkNzSmVE?=
 =?utf-8?B?WTAzb0NIYm1BYUhTcVdEQlFBUVZpcjFtL21sOFl2cFV3YUlyVG1UK29qWHZs?=
 =?utf-8?B?RHMwdTJiOXZUdkdDTzdsalp1WjlhSk5IN0Y2aStVcnpiaExVdVFiblR0OXNx?=
 =?utf-8?B?anJ6K0FNWTZOK2ZRdmEzRHVaWHYxcHZ4YndaOFhKUU1CRFF5UkdhWHJtYy9U?=
 =?utf-8?B?NWZHSHptRC9FcFBKQ0ZNczViVkMrWldhNWduWmF0VURrMk40NG9pWEY3Q3Mr?=
 =?utf-8?B?WVR5Zzc0WGVLeDdObFhGcFVkb2lKaHhIdFJzaUdGNTFZcUhoWDk1LzhmNzMx?=
 =?utf-8?B?OVQyRXFkK1JmSEpoRGdaa2FKeld5L3FadFI5RGU0QXVoaVJVd3pveVY0VnFx?=
 =?utf-8?B?eHFJWlBhQ1B5ZXhLMXNxclpnK2JTb1lhZEx2d3BvT29jVXJ1aDhJdnlxM1U1?=
 =?utf-8?B?aU5Eb0xjWHlmTjJtVTVnZ2E3MmVpUW5rdW5HSDhsL0JhMWgvMnpEVFdMUVA2?=
 =?utf-8?B?NWZJOTFmU1FaNG1qZTNtcStGUDFpTFlCUHBxUmJoOHdRMVIvc2F6Mk5UWjNP?=
 =?utf-8?B?N3FOZDBCWXovQy9uYjIxb0NzUUhsOWJyamI1ejNaYTVTS1VadUNROXd2c200?=
 =?utf-8?B?eWhJRDBFWHVvR3c3Y1E5QjJlQnptTkJLL3BzVzVlNWNOdWY2cGMrSWtDTHpu?=
 =?utf-8?B?Zms1RFAxcEd3QmsxOW0zTUQ5NWtqeHRpWDR5ejRyTkVQRkJDYmdlWkZJdk82?=
 =?utf-8?B?aGNUY1lCY2FSK2F2bTdRTTA0YnlSU09lSk1Ed2pSdkpkRFZwTjZ1dW9ybkp1?=
 =?utf-8?B?ZGZ0dWY3SFQrdFR3YkhqaWZ5eHBwUmkwVmR3VklKQWhvenFqSVFXY2x6SXpz?=
 =?utf-8?B?RzFzR2pMN1d6RDFBaE5hSkhOb3ZvZWw0VUF6a2loYXJIb3BKU1F5Wko2LytW?=
 =?utf-8?B?RzlCUGQzb3ZMQkNNalcwRGFqVFVycG1kWFY5SS9BbVNvSGlRYVRIMjJrV1NS?=
 =?utf-8?B?NGg1L2ZXaWY2d0EzVVFLcTBpY0JSUlROeHU1RW1VRUhNVk5jUjhMZ00xbk15?=
 =?utf-8?B?Vy9NL2FkcnFrbWFPa1drVEI2SXgvMXFENUxTbWNYOVRqdlJQT2JaWTJHWWtv?=
 =?utf-8?B?WDBDYytvbjBldXg2T2NqNVV6NVdlSFdSRmJqRnR2UVJoT25RUDRPaFBsWGNB?=
 =?utf-8?B?UXhnNnpSa1B3TCtEamZzVU95c0VFUTRWbmRxd2dsQ3hxdU0rWU1oSjFxSURT?=
 =?utf-8?B?b1dOWTJxUVRqMlo5cndmaXl4WExCR0tKQXRBOXo0RStuRk1sZ0h0clJ3NlpJ?=
 =?utf-8?B?UW50Z1RjQ2xMWXNrM2kzVVJrN3ZaUVI3clJjWTgvSFp3Z0w4UmYzVUVFWHox?=
 =?utf-8?B?YjZDdzRjdzUzb1hxbGtDZ0JoL3d4cTVGdVN4RC9rbnBRRjVEcVZHVFZ4K0xh?=
 =?utf-8?B?VFI0OThKWmVtVEorUUx4UTBHMWlra293RU0zMm02VExDTEZoOUJaZENvb1JT?=
 =?utf-8?B?VkcyeDZOMnE4WXU1MysvdXhtbG81czZ2bEl4NHFLMHdwYktYMHBMck1FRFhv?=
 =?utf-8?Q?5HOJsXcUPiqN7BjMRQwsNQc8lg+AejDA+x/L0RV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 459b83d8-be47-4723-ef29-08d90082877f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:27.0554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8vfCDd0Tmxpy+UfKImTupM9sZy8B6sOKsn7pJvLycUUAxicK0XcS2CuZeqcssNiscjGm+QVog/akUTJ1g3YEt0JAb7pF5eiJoHUyQyxY5eQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=790 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
X-Proofpoint-GUID: A2xc67OTvnNBmR8ULZCfneXhlu2dxYkY
X-Proofpoint-ORIG-GUID: A2xc67OTvnNBmR8ULZCfneXhlu2dxYkY
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=984 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 11 Apr 2021 11:21:40 +0200, Christophe JAILLET wrote:

> There is no need to duplicate some code, use the existing error handling
> path to free some resources.
> This is more future-proof.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Re-use existing error handling path
      https://git.kernel.org/mkp/scsi/c/5dc3468888f8

-- 
Martin K. Petersen	Oracle Linux Engineering
