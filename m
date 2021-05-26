Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622E2C47089
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4445A6142D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhEZEJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53540 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhEZEJV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q44YrJ117988;
        Wed, 26 May 2021 04:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Bk3M1sXt+cZEntYz/xTgSzdab5N2JhkCVkobpouY7CU=;
 b=m0ohKYb4IHCXgATZvFW/TeQ1IonQPknRjTRqkV/FqiMWsP7aQ+bwZqM5KGSPQqqL6SNW
 aDX+PQx0PzF7n/94m4JjEkoZzcNpgLcc5KQ2W8Lsdydmmg/P0QHmWk12u4kN9zdi02Uy
 LwSs5UBDL1Z3yyjFuG3VzS5n5KkWQdBzzV9hQmPRXTG3phkI3IyNbkylUcIDC73lvUrt
 LdMI5sNWNcW6i/gBQHrtlY1/IIlS4ssgxvAFlLtrTWzXrECOXbzHqxTC583WaNBrfWXD
 Q2RJgy/fsbaQUFLGpWnQC8PevkMt3Y5pOI6HJFwwSACmOfkBRcTxwDmLoa9VH73Ke0WL 8g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38rne43bd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q46Eqn028010;
        Wed, 26 May 2021 04:07:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 38qbqsvd80-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYodbwCLJmFg3bnyoPruijK4uqXyD9mec7AnmtgjKIuVIRu2veEqcDmbb28CA0Cz+V0vP8MR48+tLQevYRb0R8VOXr/iCtaabXKtdWpgR9jJSTCqXl/b+E3QR5Oz8kob+TPJrE4WxscfzRiGOdSyJZXoZSBAvtkwPGUWH6IOG3Bi9Y69Ir97dEiNF+Fe/zhfJdA+jGRJd1GnEV+RTf12z1WQ+UMi/y/L20JpD/r7f4klgIbmZZA2OhKs334jN/0/luLK+a6OU3VW5QIFKKUIcD4GUB/T0YzTAsYGV137IoN9W2UfSKwn6vQKUqstaULJD11mu+nDd+7vA8sWxYvFlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bk3M1sXt+cZEntYz/xTgSzdab5N2JhkCVkobpouY7CU=;
 b=MvZC7UwZyYO3HRBuBxYOeFay+V3CF5PC5GPY3OEtSL1SXQ7mF/A3gxed++m/cjU/TgOKKbSszQ6YgvdGvrLZRhgn4XQ6OO+Upd7RrW/Ay568v/wnRaRDgd+YZlY5IAG9EwoZvgncbjs4wcrJcBQfWAyZ/wdJp2ysaOgbuxx6RlQ/kUo0tof5FIrF8gRjfBjmn0QJzB23gVQwacsToDaEFwqlSDN+lEjQen4b0D5V30VVGaJCPGuCd1cbrtLfephyXKrC237MAdoop8Tg+rroOzCyPQlJC/qo16n6tb3jHP6/LOaBheUmCyNMY4MOs9AxtjoQRWjPYLgF5Q0cfKprzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bk3M1sXt+cZEntYz/xTgSzdab5N2JhkCVkobpouY7CU=;
 b=LTkI9B5PTnn7goJZ5cyeeZfAF9gL6mrM3K5mmyoXpmO0ifQyPcJh3UD7EPQYITHlzHZ/cTa0uQF/U5oIwjO/jjD6lAXP55M/Z13QEA04v14DzkoIKKcgHxP1N1aeoPlMijBEg0gSDIGqTI77nMGE+W0kpYwV1wG3M7Uck81snEg=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4549.namprd10.prod.outlook.com (2603:10b6:510:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Wed, 26 May
 2021 04:07:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] ufs-exynos: Move definitions from .h to .c
Date:   Wed, 26 May 2021 00:07:16 -0400
Message-Id: <162200196240.11962.13786848783981137112.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210509213817.4348-1-bvanassche@acm.org>
References: <20210509213817.4348-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efc5064c-e3e6-4526-0e06-08d91ffbccad
X-MS-TrafficTypeDiagnostic: PH0PR10MB4549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4549F542BE4F8696938217D98E249@PH0PR10MB4549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dujq7x1uGq0H5puZ59ijC8MiETBe99ZDFQclHRO3S6366K1pF6ikeQihLKKnVe//b5fNj9WiJRB47FV9vqUTbxTXMnghjAU51tUFL5XhxupRBpDNBdYKj6yaQtcOmAHdPcpQeBSeJVXdGViYeJ12iYRhrKjVZZlPNM7DUD3W6f1Lk5xkKAxFINRhGK0FzaVQQYTAlZN3X2V8LaeWEZ5jCHoHuWuz2yqACoSjIETFZbnA5I6xVXgikxPne6xcntATqc7WGg8h6Ftbym+6hZNbk1wYC+KimPL3TIO6X1rBcGZXqOKtgz84addf5p9CDIQRIx/fqEr2gfq2CHNfG/4XvPckO6fRc+zNURNRnfSSDHsX4oLjcDsfuOK/+DWV+8PZkByAdl2QPE6kVY8D/RzXKTIWD9/tjaFOxb5k+gn56iJzDHswgaT7gppuRoVHaCim9gpSvvnapSU1bMtqaS5lzdgR9AKmk0r08EMDp+e/M0e5nK+eRWfUCjka8tFjz6nt0rCTkOaPdW74yFiiCq9FAUWW8TyPMLZ/lhyHAnzpajSB7aXqEbJheFM5U+pJb5/+GpihRsp6L13D+xRRbghopwKiwI1ifPiodZcB6tsM8836ZKFocB231tX2m0bvq6vv72VrbN+mY11e1qxEH09ZOCyNCU+T3So7Pz5rxx7C8U/Bq7ew3zvGGIHIQW8ozh12veFipIIQAAVMFwmNIncbyL3grDn32BN1YIXGZVRp+wHUGV1pNd4+jTW03+VDhwG2jbBIiN8A36v7uBixsqQHmiZtLihYEnvN0SrjH0VTEaFIZEhfUUSBw84iAoaIXVXU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(376002)(136003)(478600001)(66556008)(38350700002)(2616005)(110136005)(38100700002)(86362001)(103116003)(4744005)(52116002)(66476007)(83380400001)(66946007)(54906003)(4326008)(956004)(5660300002)(6666004)(26005)(36756003)(966005)(316002)(7696005)(186003)(2906002)(6486002)(16526019)(8936002)(8676002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UXhaV3ZXSTFCWDgrR0NadXY1enRqa2poNFNRWUtsdFBKVVg4NkE5MmFVOHBL?=
 =?utf-8?B?Ym04eThVVmY0Q2lReTV1Vm9vZ0tadXk1Q2g2Zms4UmVBdldWSkp4dEdaNEt2?=
 =?utf-8?B?TWVyamgzMnorZ0huZE9pbmhEQmJDQThDLzVCbloveEZCZEJRV3hYN2tWbUNl?=
 =?utf-8?B?UWV0bUk1QjJJd3NRWUZ3Njg1WmJ6YVUrcUZMS2FhbkUyYU9kTFhpcUZWajR6?=
 =?utf-8?B?VUE2NjNmWCtVUjdWOGZGL1FkT2xZcTYydDZvMk1rMDRkWXVBYWV1TGYrc1BV?=
 =?utf-8?B?ejhuK0JDS2VIVlFFY3gxQnozWFV2RmRpNzBUendJajlmWHVTQVpOSEZKN1Nn?=
 =?utf-8?B?UVNIWlhpQURWMnBSOUJ6cmVRcXF3ZGF3dS8zajdlVWNIb0ltcHVBb2g0bjVL?=
 =?utf-8?B?VFEwZ0JSa2JkSDl4aUZ1RzR1bWNDbXB4V3IrVkpxV2thY1U4NGVPZ29oNnl5?=
 =?utf-8?B?TUFqMEc2VittM1VJTDQyb0diMWV4NnpmcjRPejVrZmxJUUc1UmlVNURmS0JM?=
 =?utf-8?B?VFVncjhRUDNVUE5TL1FsUUZwS3RWRGFvNTdVMHdHMHJQVmJZVjh4ellEVHht?=
 =?utf-8?B?NUk5Y1ozbHpuVEtFRlFGM2phcjlKeUk4RlNaNVduSzhXODhVaXR1aDBiK1A4?=
 =?utf-8?B?RkdWaFNkUUttOXBhTEdkNmUzSTYzT1luWnRXTHZ2U0IybHNuOXVvNHhvMjJG?=
 =?utf-8?B?clNBeFZCQ2JsKzRCNVJYUGYrNDBtVnBaaDB1SjluQ05LYVc3TytJcldRTnoz?=
 =?utf-8?B?amxtQmF2TlV2RTVkaUtaMFdlc09DTW1nckxBekhHSVkzSm1ENzN3UzdUeDQv?=
 =?utf-8?B?YXNydG1tSStQc210V1lBWGZYdFNFZU5DVWlPbVJ5NHk2QnVsK0g1eHBoNFRm?=
 =?utf-8?B?aHhKOXhyUWdTMmt3YytqV2plQXJpQklLdE5teFJ3eWcxbHNla29CUEdTYlFw?=
 =?utf-8?B?bWNsRHFYWldCMkI2bmdTNzVHQWdPNWNCMisrbXREejlKWStIdk9FNVNBNUNC?=
 =?utf-8?B?RGQwSXQ0SzZYZnpkbkkxTGtJUGFvdVNyeEdNUmtFVUMwcGZIZzEzeGdUUVpO?=
 =?utf-8?B?RGU1WFM0SEs4bi9MRUVrWE5uSGVEUmd4MmFVMDdRaWZhR0RTaE5xblZhRjBP?=
 =?utf-8?B?UE82WFlLdW9ETi95eU1wOEw4ZlR1MnA2OGhwT3lpMU1WVmRjc1pTUzNrSzR0?=
 =?utf-8?B?K0t3L3I1MFVLVTRpSEN6R1hrRmZBeUlsS2FlZjloVDVlOG92NXg2blA0eUlH?=
 =?utf-8?B?M0xXNkxpQXRzUHk0ckxLSGJLNUJFaU9iaFBJZnJoYmNWa25ubTB5bW5KU3lW?=
 =?utf-8?B?WW9XRUNPR0ZEOXcwM3Z3cXVHamhBSUM4cTd6eml2dEZoUkxJRFBmOXdoQk1o?=
 =?utf-8?B?UnBMZ0dQQlpCZ1AySnIvUzBUdkgvQ1N4d2xjM1BsMGpyYUxzQlBDdmdJamZ1?=
 =?utf-8?B?Mmt3eVN3Zlh4dXZlWnBkNDZJNE5EaVMycW9MQ1dJMkVRVXJXNzMzQzFObk00?=
 =?utf-8?B?cnpXR24vWittNXJHMTc2NllieGNtd3VHYU1PNGlHSlQ2azROWHFxcTVoL1NE?=
 =?utf-8?B?d2tMYlg0MlNpY0VOaEhiR3N0NVVZbUxOSnNodVdMbnYzSVZPYkltS014R1ph?=
 =?utf-8?B?N000QzBJbUFoVDBrdW5qQXRVUllZNjNBSTc5V3J6eDRXR20xYy82WFBrcGl1?=
 =?utf-8?B?eHZCZGprMzdOYnNQYVVIOEJKTTJjL01wL1YvcU1QcTd1eTVENlNGNHhDRXdF?=
 =?utf-8?Q?zP1IErp4Zc99GKQl1RPl4paAqpYnCQeNIca4PV2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc5064c-e3e6-4526-0e06-08d91ffbccad
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:38.3260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WfLSgvwu9Ralkk7xjg1aDg6xx8I8M2JvWcUmhquYJKGgHO852Gg4cSj0UAqkAM3HJhjWavnQYciXIh56LceeND+4yunqDJjOLH+nPkzCRsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-ORIG-GUID: DYVDKKmHtrdQ2cEm4eDFNpi1U77tQ6S3
X-Proofpoint-GUID: DYVDKKmHtrdQ2cEm4eDFNpi1U77tQ6S3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 9 May 2021 14:38:17 -0700, Bart Van Assche wrote:

> In the Linux kernel definitions of data structures should occur in .c
> files. Hence move the exynos7_uic_attr definition from a .h into a .c
> file. Additionally, declare exynos_ufs_drvs static. This patch fixes the
> following two sparse warnings:
> 
> drivers/scsi/ufs/ufs-exynos.h:248:28: warning: symbol 'exynos_ufs_drvs' was not declared. Should it be static?
> drivers/scsi/ufs/ufs-exynos.h:250:28: warning: symbol 'exynos7_uic_attr' was not declared. Should it be static?

Applied to 5.14/scsi-queue, thanks!

[1/1] ufs-exynos: Move definitions from .h to .c
      https://git.kernel.org/mkp/scsi/c/b592d66235f5

-- 
Martin K. Petersen	Oracle Linux Engineering
