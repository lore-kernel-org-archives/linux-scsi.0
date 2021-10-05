Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAF4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 629C66136F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhJEEfJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:35:09 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:59004 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229934AbhJEEfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:35:08 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1954CFCX004524;
        Tue, 5 Oct 2021 04:33:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=aagvb/wd6YKYV2+ng63lYT4/FxXmglCQZ+e1ToeI09w=;
 b=Nq75e1njGSTdE3lJx0X5s5WJJ0OPAf66PsBYXDwmoMxyB/XtyVKczKv6SuPD/VzU9t0M
 rBvBWTm8Zu9eHaubrloQkjLi44zGLEWAR4/JffSMtot82NqxcUXmV3DB6/CIAF1sJlom
 MZtukcICZGm7bfuIdMsgxkoKv/ME7m6NiL7uvhrnns/qN6pyJJ/2CEyEN4By1F/fUWLX
 0BR9ep9PS6XsZJ0saBnD7BFhqLGnjO25LoxWQNNZiDKMYdb6eNWnzNff3TC5OvyZ0UeE
 QbbN25hAc4rZDU7kLpROd/+VmMlasepPQMT05z+0sQ8fIt8iSp9B1SeRJfdM0714+0/a QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg43dv8fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:33:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UdHr029873;
        Tue, 5 Oct 2021 04:33:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3020.oracle.com with ESMTP id 3bf16se29c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:33:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iz9mzHGhLIhjNQlC6EJL0n2Y9mmtXl69ODbZoWadOgptSZUew7xl/YrycywfyhWVEsHj2OMjqp77eM7gA+Pt+9lOAf6vgwOJb/Qo+JxByUhQIYVm7QIljSvNrHF8eG2BxAdHwTMKQhN8VOvSVoWR1rxuy126HnNiMoFeVSmoZ04IXXGuFO405uUoNFxVdfgdg4E9oMJlpVjV+mAA8X28YCkEJWnkK+SNsmRPsTvGSpkqaBBFqe7ktwVvXBcMuzkhOgdyarKbymRs8UfHUp/06SDvyLu6EGG4n3YhQVjMEVg5xzjUPH6NOH35BCFw0NbMfRQqRKCU95MnWxmdyTbITA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aagvb/wd6YKYV2+ng63lYT4/FxXmglCQZ+e1ToeI09w=;
 b=N+STZznphmvgFhCvYSklgE1uNVlI+60fhPjk49teqKkm04YlFU2Dxfk3zNf8vetdDhLNDqxOMvLnMlaJFkRhFYFdedgApn5qSnNIiI5ytkwXN+1oK3T3eXXpZ1B03IMm4TLuFPYCzo/cVK41zoPH4H2hfsBrcDyMmJO+4a+c4PE7A3sT9LrvMpqvkb83sjsnGCzCePL3jImSSIgak+lUoRzbjfkF0zstD+lor7RzWi/9DnctyUswhK5BChg28mO42xYE3MOAx2GK9kdit+jidQuYfMOyKiFNCG25gwoxtyaRl31DeZLmvVwCdcjw8zrIzGMl6NSnsHlycIyVCfFyXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aagvb/wd6YKYV2+ng63lYT4/FxXmglCQZ+e1ToeI09w=;
 b=oyOF0jRDVpelTL2162ipVFy9UTvWJJheg/GsYfl7DOm8L4G+lYylUTvch01IyqwfG1Q4kGhTYOUXll7QHyvoDAh6ZzK/gC4GsbGaDROyxWJSmqpSUo8XoRId187mPoq6XhbpUnGUEwzKpkUIm/fdFxOuLGk6UpWHo/XmsMZ71fI=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1885.namprd10.prod.outlook.com (2603:10b6:300:10a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 04:33:10 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:33:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <james.smart@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>, target-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: Re: [PATCH] scsi: efct: Delete stray unlock statement
Date:   Tue,  5 Oct 2021 00:33:00 -0400
Message-Id: <163340836501.12017.8636843810888145134.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211004103851.GE25015@kili>
References: <20211004103851.GE25015@kili>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0096.namprd05.prod.outlook.com
 (2603:10b6:803:22::34) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0096.namprd05.prod.outlook.com (2603:10b6:803:22::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Tue, 5 Oct 2021 04:33:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8791c6f6-1d8a-419f-c865-08d987b93c88
X-MS-TrafficTypeDiagnostic: MWHPR10MB1885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1885FB6A4324B19DA108483D8EAF9@MWHPR10MB1885.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B11+23N2rScMIU/bzqBrY9qf0+pYlgBo8TnjFCNJ5mgYP6ph+mvq1PPgOWgCg/MTRW6/o4+aycRPxWAn22MgUfJbeikzaXZhehzv4qBpfqLj/2rXuhXldFOoPEmduKIwvIHPXRohPTPi9Z9EfGEHdqWwUOIwacd0zzVtoEyVyu97xM2Q26FGosPRY2epI04DWOxuhI3QXLvY5OnTmCUBOfn0zcq70OJO/3DqohUGntr1fcjz5f65+WC8aA+PX+XnMIsFdXtCbN9iHuuFHinZ/BUP1/1bjLbdnWkVw00i6Zt9rL96vm8PEQR3ilaVGzd2UqEbDCtiSWhYNvL4uhNvjtTX001IQtyu1xw50Eu9M89piRhi9km8MlO+3lAJLl6ENACrYF0lotuli89EK7Qm+2/ZlQb+wqX4HFzNi8dAsvsvT4YFZ/ZwK03xp0YSUkIUHuTIMn0n+9uokrNN232y6bxu3IutPbYfPYqOVvsxnD0pxITEz+44EVS549KxhMRGFDwV4pH/7ApRRYGc0OoNp0FA6zFnTFCYoZPVpGUUehfCss18ulBpfn9tWyGxOBc+nokr8SMwtA2xXD8dPY5W5J3wew3hNbUKeoM1hDqacD9zjxm8rReT1Gn83oDOOzrn2VdUVAuUyzrYRHbH+0i5r+hB4G9swDLHn63N9Kmxx4fKbIXNuByzdHD5MdHlg1UdAu6ptI5UZB4r1t/YaDl4ZqKW5TKgxHKZjILfiZBVLa9oEUupd8BMii1uvfRyDhN6yEyM/jaS9EMamCkgQOy0tycFvnGM4qDqbDZSOYFMoo4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(956004)(52116002)(7696005)(6636002)(54906003)(6666004)(110136005)(86362001)(2906002)(26005)(36756003)(4326008)(6486002)(4744005)(38350700002)(66476007)(38100700002)(2616005)(66946007)(966005)(66556008)(5660300002)(8936002)(83380400001)(103116003)(316002)(508600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akkvTGxsdUdGekpMc2NuNkxXS0NmdmJCNlJuVi9xMnFuUS9LZWNEV2x1WFJV?=
 =?utf-8?B?bUhVdnlaSjErOXdMeld0MXRsRU53b0Z5STBLejdIZDRranUxT0gxZUhDT0VN?=
 =?utf-8?B?L3gxWlZhZGlYRnpwOGJFeFBWQ2pqdWpoN3J3SXJLZHhRK2JTUnl4dzRpRlVW?=
 =?utf-8?B?Y0dIMlkzcUpqdGpFWko2Ym1VZmNJeTdTbFdSdTdNQm9yY0txdXBxODY5RUpS?=
 =?utf-8?B?RCt1N01PanN5NFYydWNPcUlvTURMaDlJUmNVekxORFJDYTlCRmVNaGswNnhr?=
 =?utf-8?B?emRpU29mcTdzUVJKOUd2a2xCK2NmNVJDWTVpVVZoSExKTDNTa2RpLzY0bGNN?=
 =?utf-8?B?bVpxNk96MlhYMFBMTk1aOHdQZVBWZUkrdVU4c2hEc1hDOVVTUXVMeUordkY0?=
 =?utf-8?B?blF1NDM5bDA2MFNkK2RDRUlKdVB1VjcxOW9IQzZlZ0R3MlIzU3JWNEFCZ2s0?=
 =?utf-8?B?S3lzTmUvVXpzaWZBYkdVT0U0QWZHejMzZDd4NnJra1lXNFVhdkxPY0M0SnAr?=
 =?utf-8?B?UDZXZTdsbTdjUWVWQlNjNUgwZ3d3bDZoWktqSTRtTzBCYmxKU0FvL0pnYTdz?=
 =?utf-8?B?c1BlUytQOWFIbGo4N0oxUCtzVVNiUkpkaDk2SnVXWEtiZXdyOFZPaUtlcndk?=
 =?utf-8?B?MUNHRlA3dVNFSTVFcDZLQzJGSTB2VHA1M1FocnQ5SWM2TVhYZjVCaTgvN1M3?=
 =?utf-8?B?N0dyVnBoOVJ2VXNwei9yaUxDUUYvR0RTbnlFeDRUN21zSXpPaE9hRXppVUY2?=
 =?utf-8?B?Y0EyNG9mMyt6TGcwYU5zKzMyaGlzNjBSOVEwaWduSGJWK0kvTDZLREVjT3ph?=
 =?utf-8?B?S3VMYTFxdUl1U3hlb213VzdnNjVpSlZSK3VsZFJiUnZ5ajUxdThwRkU5NVZD?=
 =?utf-8?B?ZlZJNUNVdlUxbVNpT1BqWEJUV0FMMVJuWlhmRzNCNXNIY3dMeVV3TytLT0F4?=
 =?utf-8?B?ZkJaR3pOQ1J1QUR1MWVuVDlvZk5ONCtyOEFVeFNlQW9haEo3UnBxNURtVHRH?=
 =?utf-8?B?ZjRvWklzZTRvQ1BqZ2NjTlZrN3FTQWFCbTF3YitKeXZVclVpTnkrc1FaSmRT?=
 =?utf-8?B?cXBOamNQNjRSeFZYb2xmTlRwV1lmTGtieWd5YllQWUFrTTlZb1pxdEtaYk4y?=
 =?utf-8?B?b3hycHEySGU5WVlyWStJSkxROURQOWs5bGExWlRHRnQvTjhwNWdVQWJMSHcz?=
 =?utf-8?B?QjJ1QXQ4Uk9DMWJicnl4VDN0ZUNLaE9ha0J6bjEwWm1ISnFLYldzSk1neHRh?=
 =?utf-8?B?NkFvY1dRcWFvWHg4RXlFandqS0xUbHlmMitJSjI5MnB1K0NZMGZPeGNGL29O?=
 =?utf-8?B?Yk8xQkN2enpTZmcwMDROTHo2WG82OTdiM2dDQXZSdzVsL3liNldyQlAyS3dF?=
 =?utf-8?B?NnRHL2c2ZG5PT0dVcllNV3FpaHQ2amt6MzcxVHZlSEREQXgyTnFmUzRId3Zn?=
 =?utf-8?B?S1dYK01DSVdwSWt1eTY1VDBtMDUwOGxZaUo4YmRJY1ZCeVdabkkySjVmek5m?=
 =?utf-8?B?a0Z0Ukh2VjFuaDRTbnFBc3ZzTGRwNkZ3R1pPVDMxQzVQSE9iK2UvdDNPb0M0?=
 =?utf-8?B?anlXQ2dGRHRYUmtrU3NydFdvaytvZ1hzbE4reWRLV0p4QndvbjUraXZMRkhM?=
 =?utf-8?B?SVhLWVh4UXpSb0JEOGZTd2pEZlA4c1V4eVd5UzZyeWU5aFhYWWpvR3A5eHFL?=
 =?utf-8?B?cVZsZWpDSFMxUHA5ekIxY2N2NTdZN3VmSHErTTdTNUw0SHMzYkVyMEVtcTBm?=
 =?utf-8?Q?ramukk7fE1oVZaVb2mQixLZez7MQhLutrCHf3x1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8791c6f6-1d8a-419f-c865-08d987b93c88
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:33:10.6172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBectEcWlxZjT7bFTaTt8Qx8P4h3/+NtLxWrasHNLp9fs9VqP16IH8Ygp5NDS32vnYLl0ROqjv5dsFOlKkzdq5bFW2xnnNVkF8TbPREOmCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1885
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=975 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050025
X-Proofpoint-GUID: nUN4eM1mq__llNdBpHUJYEwDk2wgLSOb
X-Proofpoint-ORIG-GUID: nUN4eM1mq__llNdBpHUJYEwDk2wgLSOb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 4 Oct 2021 13:38:51 +0300, Dan Carpenter wrote:

> It's not holding the lock at this stage and the IRQ "flags" are not
> correct so it would restore something bogus.  Delete the unlock
> statement.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: efct: Delete stray unlock statement
      https://git.kernel.org/mkp/scsi/c/a013c71c6315

-- 
Martin K. Petersen	Oracle Linux Engineering
