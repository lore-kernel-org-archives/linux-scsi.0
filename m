Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F50C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EED236103D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbhJLUiR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:38:17 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3700 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234886AbhJLUiP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:38:15 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CK6C9E013002;
        Tue, 12 Oct 2021 20:35:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8bNfQ7h1KIhLxRvend6KYowKmZwxUXyeCF3SCHfGrJ4=;
 b=nbd5xfOeQcqVKX/MfECJh15YXe9uNifGpVnJCTd2oGtBtXY4D4S3whsoCn8SWtzHCSmO
 78UmMzwNJKtyzm1F5uL0g50mMCyfrx8s7rPyHpDMRHa7BKI/QrF2tgpZn/KSyM3Ali9I
 9206VsUBWPMcf4elRkb8QPyR1vb4IzeM+uXVrgrzN1S/pOHyYSl1gLMHuHtqj92PXtb+
 QqUjlGBwnJQ/fJdhmcifnyIDDrundfT4P9l/AOKjLnqWwMJ6dp9RRo/CFixxY+rIGLbK
 SslQYQcAW7ePrTR71nEt94M1ejTAWBUyk4j1bJQxUWq0eJgJyIFrfBtUjHtca1BCk3O9 Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmpwnb7pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKZ98j018006;
        Tue, 12 Oct 2021 20:35:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3020.oracle.com with ESMTP id 3bkyvau7n2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBEKpL1OtTfWWcNH54hYnwrhbJgau5ysd4PUZnIoWx9fouyAboL2ZgA2BjBt6yDycIso67MJ65njMr/gl0ByrRxls0p58aOin63GsMVWOxgt/8PWT75strLTGe8peHVJyHJm2T6QkHoWH/r735gSKBhnV3NHc8ZjOJWvjPs8orVFqMdyb4t35yMOKFsM++H+H4bduEx2yJRihlF38EGXFoBr5YceXRqmpLhZbUj+58GqIytaq8H3hQd6m5JY0JKw8zLQxai0/mzsn7uBnrEJTtq7ylACOet+UPZrwAH+RPHm8TWjbevYZY8GD1EFail/+flyXKRHstjxlbIhhAxQvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bNfQ7h1KIhLxRvend6KYowKmZwxUXyeCF3SCHfGrJ4=;
 b=PNwwqgAh2Sx1b+cjhFjQQTwixuP/U88ZWacPw3C+L4Tet656lIOobpR020FOG33Hyp72Fb/8t3zaSKTutZo6fFi34U3KkQHvaZmXSqPTG6jbNc+qKQX4+1Tm6s4xdua6PSjd51T9dvQXweShmPLusA6BKn1RrVrkkZCb4wb/6eqgOIxQg0ABqr+Yzc81DltyvJ1EtrjCMA8QGIN2ywdIVsDpI2mIIw369TNS+DqMq1TaRuA1vv+wLAkg3sh/HldWbJeX92ZPTnDPK7qQJgZOcA6W8wJkSO1PbMYyy+D1vBIC/HPUP9a1KO6ayHr4UnLX6sZlD5oVawLR1hvJXreUIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bNfQ7h1KIhLxRvend6KYowKmZwxUXyeCF3SCHfGrJ4=;
 b=HjyMl6inHsyt3u8DHXR8wDrJhSQVhwEMLNzHABxsaH4rcKWDMQNKM3WnKOI+ap5GExg5c9ywtghA8gEnjaWoyc94STh2+PDnx4fR0crsYQuFd0E7rHK+En6BUFwXtJhwF4se0JKFXSYToa2sMBDgSgFpfQXtliDgwBetElNC4Zs=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5697.namprd10.prod.outlook.com (2603:10b6:510:125::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Tue, 12 Oct
 2021 20:35:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>,
        Hannes Reinecke <hare@suse.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi: Fix kernel pointer leak
Date:   Tue, 12 Oct 2021 16:35:16 -0400
Message-Id: <163407081303.28503.11335939480972313307.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210929122538.1158235-1-qtxuning1999@sjtu.edu.cn>
References: <20210929122538.1158235-1-qtxuning1999@sjtu.edu.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 20:35:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 974b5df9-06c3-4599-35ce-08d98dbfd7db
X-MS-TrafficTypeDiagnostic: PH7PR10MB5697:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH7PR10MB569798308879B4BBECABD0738EB69@PH7PR10MB5697.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4TfA/NV4CaweRqQ3S4tXYj2ZAy7SmIw6lbQGd/foH8YEsC4WHuJfVGiqgDwvIp7vvhhWiNsgk+V/TaSb2/1gRY9yk5pXMirsJQQy6Uw040c/mpMDOqa39NPmBayCNscd08kfnKC6XAcDFZ+j/Vx3gkzjChlmbVlJGyIzYb8jTve1SjQJqpa9VWHZEGBvXKveRGHcmPrribfdWKWiyLFjdnR3wDcOhOurgTBkniwH77L7rcvLfJcYPl4E1st3bQrXeQhkUwgW8BiNb7bGH+hyX+YnIZVMCaJNmVzh5NPq2kNqVsTNMNhQ5zr2XphDL630RV5sTy2lmXAz9OyVQnkAUwBjWJc23zOvDXr5erD8qgqTr4ZAMk9XpRJxIAbaPLMvjK34zS8k6PcxmJViLPAhJU7dXFk1E/9H1SdnC0yhyZVeURfLoeNU6gpC14kpbyI4/cC62+p9A+QV34u9l0AT9hjfxID69vtDRfUb4LVmLr1KtJkuYUYcaa56lQ9eJGNSu/bVXDCpHD1kWF6rteITCphilqoRhI5i/l5V3GRK8sY+lNLdN0KH9It1ehtdXn2NNC91rB94KWWtmJ8coPTJmEob/Tb5Ah5vVKafRkfok5nz8jDqdDBcAiySH6l4/whFJ1hZTkUzeX47zkOE7utAONAGoDkE7cTTmSzyW33S6SWJFDn8fFdZhqcFK1SemcyySSmMXzJGQMcvhjjfJOgemajj2qJAVduR0Ao4MumKnGYuIfqLpXaPktyzm8ZfcvZUnpnfAqJtv8tf0nnSZDWRHsRkqkbJSjdmWUtyZ/4sbUQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(6486002)(4744005)(956004)(7696005)(66476007)(52116002)(2906002)(66946007)(508600001)(186003)(316002)(26005)(2616005)(86362001)(110136005)(6666004)(38350700002)(8676002)(66556008)(8936002)(5660300002)(38100700002)(103116003)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGpWRmZsdUxRRGxIR2NRWnN5UGk4L2J5SE9Qd0pnWmpSWFVFMzNPV0R3SXNi?=
 =?utf-8?B?clg3TmNNNXhKL0RmSkg1SEpPYWlkVFlUWFlVdGloSE9iL05SMGNJdWMzMWxx?=
 =?utf-8?B?cDl0aUNjRnNQSW9IOXozK0N5bDhOWm1mRm9pak1KY2JpbTZvL1RSaXVZRThl?=
 =?utf-8?B?RUF2NUM0ejNSSEJ6QWJvUU9iRmkwYXRoZFNhNXl2VFU1WHA2WWN2cnpYN1BB?=
 =?utf-8?B?VjZWTFNVTGlQdXdIMG5ud1pUYk0wUHVkM0orU0RsUXF4dXhXdVNGUS9vd1M0?=
 =?utf-8?B?R2EzYm9IbmtBa3dvUUxpZFhrZmZrOCs3UFRTMXNja0hsUWgwV0xtcmdHSHgw?=
 =?utf-8?B?Y1lDc1JDeW10Z25FSTRqZ0krLzVxWVd0V0lwK1prb2VlRW5VeGFkTkN6RVBq?=
 =?utf-8?B?N1FZeTkzQzNhMmxTemIxUWJ5ekJOSEpLTTBvOXZIcUZhL216VkI3amlRWmEx?=
 =?utf-8?B?MnFVbDZQT25aUC85WkdGbmRSWThoVXpoVlQ3L2J5MzNPeThRZ0V4OGhMUWlE?=
 =?utf-8?B?dzdHaXRWSnA4V3pYUnJXYlRtbXdDaG5vUmR0WmhHNHBGcU9JNWZrNUNoSzR5?=
 =?utf-8?B?NE1DMEZwMXBUbGd3RTJ6YkJmQ21FZFZ2cmwweEdXdnlZWkU4L1FPR2RxMzg1?=
 =?utf-8?B?Y0xhWDRPNjZFNk1kaEUvZGd6eGFGL2hiR2Vua3lGZ3dXY210elJlTUp3aXBH?=
 =?utf-8?B?YSsxdFZzT1RxUXFHVHJweUp2QmpIZWdFK01qenYvSGpzajNkZFR5TGpSYmRu?=
 =?utf-8?B?MzNYVnc5dEg0QU9FYW9xbDNsbHkwWjR1bWx5RkJCeDY5dFdkaHhxd2lmOXdy?=
 =?utf-8?B?cnJtbFJEa1QzcFV5N1lzUjk2ZktnQ0xsZmMxRTJFZ2VoNDhGUEYzNVI4RVJk?=
 =?utf-8?B?TW9XdVV2YjRmTVN2T1NLWGNoZWRBa08vc3J0NjgzRjIvUmZIbTIwOGNOMVBG?=
 =?utf-8?B?TUdWalMvV1JXRm1ORmVocFZOZmE0Q1lRQmsvSTI4cWFDRmczSGwvWHltWW1H?=
 =?utf-8?B?QWNqaFdFTlVQTzN6TjVJMmVObndSS1c4d1FtQ0RUenFoZStOcGNZbUNHRW5m?=
 =?utf-8?B?WERGdjZRbU1PZCs1SjhWdXQrTVRITmZWRGtRMXBZcVl6MVJEY3d3cUVQQnB6?=
 =?utf-8?B?OHB3Z0FjUW9EdDh0MHFKWHlSK2xocFJ5Tzh2bWE5QWJ5RVlQeW1oUWpWcmk1?=
 =?utf-8?B?WmsyaGVxV1ZqU0FXU21MbUZ3azdVQkxGQlZiSXhndUIvallrZDFOV3lCSmZJ?=
 =?utf-8?B?dGtxcC9JZENOcTh5RW11MXRVOVdyQ2dIcG5FM2tqSmxLaEpMQ0tFY05RamFZ?=
 =?utf-8?B?ekRHTHIvUTU2RE5rZUN2d2Yvd3ErOE0raDZBRVNYY0hsMm94TG1nUm9KYWts?=
 =?utf-8?B?L2dWY2xaTlo3eVl3UEFNd2xrd1BGTVF2aEN3K1FRMEg1OEtFNzdkMFB5elho?=
 =?utf-8?B?NnRzSVJFRElqdnJYclptbU9XZGFLSmxtRlNhMXRaejJkVkFWcGlnZWVncUFn?=
 =?utf-8?B?Mzk0M2RuNUlCQStiQ1JhQk9ydWU2TklFSEN2NGZjcCtTR0x1NTN1WVVudTFI?=
 =?utf-8?B?dFVETGYydUxaV1YwVDdCcktnendjaTR2V1EwajRyMlVzL3VnYUJ1ME5lanor?=
 =?utf-8?B?Q2Z3V3JRQzVGMDFCU1JvR01yVnltWEIybUIxV3BmK0ptS0J4ZjBBOHg4R1dY?=
 =?utf-8?B?dy9qU0FhNFYzMHFFZ0JoM0ZDM3JRRS8rc0ZzR3g1dHhQZExsZnFjMVpxblVB?=
 =?utf-8?Q?4SCqrOS4EaR69QItwk7DqQiVzZSqGMRh22Q+SBa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 974b5df9-06c3-4599-35ce-08d98dbfd7db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:35.1115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vprOfdllmXkC1VHOe5OFF4Prik1TgRoFDZi0WrALzNLs0e/clD0twP/P25tJxFNRRcfZDVwY7Tb24hhuW0iRD7nRVLkOCgjeKOeeuQkXMnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5697
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=956
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120109
X-Proofpoint-GUID: JHI-FSTIqDRNRGdqkZeGeuiKuPMY2t-I
X-Proofpoint-ORIG-GUID: JHI-FSTIqDRNRGdqkZeGeuiKuPMY2t-I
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Sep 2021 20:25:37 +0800, Guo Zhi wrote:

> Pointers should be printed with %p or %px rather than cast to
> 'unsigned long' and pinted with %lx
> Change %lx to %p to print the secured pointer.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] drivers/scsi: Fix kernel pointer leak
      https://git.kernel.org/mkp/scsi/c/d4996c6eac4c

-- 
Martin K. Petersen	Oracle Linux Engineering
