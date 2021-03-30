Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCEBC433E9
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BC2661954
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhC3Dzv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60878 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhC3DzW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3j3uZ141725;
        Tue, 30 Mar 2021 03:55:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=fZ3NQlCxrlubYxLykDtT1BkKWP/tekJAt/D0XS6t4nU=;
 b=NXj3Hbym40R5QBZpld0N6pnmxZToHFmfVUFuAWYSwEgVCt9f+mAovs92jY6zhqdhJOZn
 bqkPpS6avPfDcTJCXCY0rENl+/Ma+hoA98spea5TUocqJDOGwWNqtfjGoQBYXebfVkRj
 PjZXROLEh/HYSeST1Y5Q0z/XYFyX885cAmh6Aw152Yx4xLDADnG4RwoR0Ag+mkRnXdWp
 3U4QXYcH8/TwXU2qzueIgLpK9dSFNu3xucNTy93zNCcboczfOop5V0aJIsJFLyQqjLHe
 nZrLG2Nv62fJHfScZ75g6wXBiu51sTIeVsxcbM3u3x54Sx8DzB9s1iAxzH/XfKiuAlLO lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37hv4r5k3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iXhs039516;
        Tue, 30 Mar 2021 03:55:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3020.oracle.com with ESMTP id 37jefrktfj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXtHglZzfUpEs25qcqUjk/j8B/awTIJ+HBCCzB+GIZPPkPZm5/Y9ejJMHUZCjG3TOBxVLGkOayZZvQ7jOpDW2GDOuLQmmVQyFNcr7mSyYWsyyG/1G1ekQ04ZKxnDEg3QpUbEtNHFhKaGVHVanuzLOUih3obNAfqCqGgsojzHdIGIo9LSq1mijsI2fZYX7qhAEXaBDuB/tL6BmmMu98HgSeOoVlU70dM12H3jVtuWCtTs2Vzpjax7Emz+GR71COqO2E7zXzFrYXh82OUXmf9JzpEGQk8CBYxRAXIzeWVjORbxqaVjY4V05NTRpSTdJURk0fJkFcV6uaLqLDRssS5BHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZ3NQlCxrlubYxLykDtT1BkKWP/tekJAt/D0XS6t4nU=;
 b=NyHgsEWeHvn6o3QogD1jRsMpLhaKE6mmWZY9OfICh9NMybA6J6dlJuuUp0jaODGiCvSJuLO+rgrW+EalQ4MqJhOBgtIWfb2hC8T0g/dWCWhSPzhY86gC72265MyzuIz8zBW/G/yqR/15FU7w3kC+541BVt8rzYunZc0XzkIRH/ejXcbpqb6qM2lBn9ZhvxFd7J2YW5seuenmjQK3XOmHdr2P0FUSBf9V0knXUx4HXPKdRw6TdzZNgtJVfo+Ur31d2W6U0dQvce6rbIHvmfAKgXS7ZdsPLkjvFoho5DWvxeZx+ckzKrXbOaw6uHAjB07UVrHy9zrEgpNpIoFflUs/og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZ3NQlCxrlubYxLykDtT1BkKWP/tekJAt/D0XS6t4nU=;
 b=f9vC6KvuXFimNVufyG2tBrvDGjQWSxyGfAoqP3JllAMudKk35VjR/dIjiUZlNDEqEzv9FaSry0TLPQxzArsZ4xPjea44UDNRsKnnjX7mnhmITOTd+QzWx/h5hw6xtG7kOEylcw9HqDRh+qe8UY/MORBYgJImpQO/YBVfG5Al8Ts=
Authentication-Results: vivo.com; dkim=none (message not signed)
 header.d=none;vivo.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4760.namprd10.prod.outlook.com (2603:10b6:510:3b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:15 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Wang Qing <wangqing@vivo.com>, linux-kernel@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] message: fusion: delete the useless casting value returned
Date:   Mon, 29 Mar 2021 23:54:46 -0400
Message-Id: <161707636880.29267.5448905206148438540.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1615515483-777-1-git-send-email-wangqing@vivo.com>
References: <1615515483-777-1-git-send-email-wangqing@vivo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d1abb7e-3ccf-46e7-e76b-08d8f32fa056
X-MS-TrafficTypeDiagnostic: PH0PR10MB4760:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47602F50D096938D81948E1F8E7D9@PH0PR10MB4760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pRJRo+JsszpS3KSZQekiWpBQ3vfb4XaHL4iSDCS/a7gn4bI54SEyiz3na3IysMyw2ID09EdBh9YjbYd8XygzezAeo8SUc/mIZoidi2m2iJL5fQMcDkwXngccDrmDE1c77mL5QTV6fvQR2DGjbyYJKNdYSNdCPULpVOTdh3ShnmRb3LLac7/YgNlEDXHb6xor1/38xdpTcJ9/MRZ6XQKZPK1FzcMwTXAvgBts8Wge3UtBM+T5H4F7FYN1fi+dVQ/PdAFhCmNIpkOTcjJpPRjlkMvQuX30/UVhvQ4Qgn0z305Jz8Vzs8tIgVnHKLIi35uIlsRJBfKT+S0teA/EN6f62fUmWmC+lKWBcGcM7DkPH16wHROgG3LTXL+v2H5sOYFRlsDPhKLyuMnAlBg3TBGkeEhUMo3U652VWBnRqqxRyF8uQE8bwimluqT9O6Ud9CdY6f1Ma+bgE34mHn7L63xWOZ6F2Udkllnxc2NASa2ahG9QbcjYPDc/VdlsNtJmVe53Cs+i23K1LXFWVXGDnysI4BDWbARCMEwQB+H74jhr2syY0Msr8XixokJHmzUaFYup7LSu7J/ouRT/NqV4o0c7l4rvO1kMxWWtKIqSFRWRqlaVBl8hG5C0M4v01MUA5fTX6Kz4YMS+qYzalc82ZLMUJXiISUywXOXDM3qBA11hw3pB8vFKxdUG+biq8r6kUacHmJRiXSqtCtYSKgYzxBtrM0pfNP3L4Xzp4yw9GV25OGM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(83380400001)(66476007)(52116002)(86362001)(4744005)(110136005)(66946007)(66556008)(6486002)(26005)(15650500001)(8676002)(478600001)(7696005)(186003)(36756003)(956004)(316002)(966005)(103116003)(16526019)(107886003)(2906002)(5660300002)(6666004)(2616005)(38100700001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UDZFaGZhTkxYWlg5WnJPZkV3VXZSS3RaNUtLcmFlNjU0NTVHTm5EeE1GYWMy?=
 =?utf-8?B?WmtFUURKT3RQMlYyWnBxeWpFdFE3TXJuTDlRNkRvOE95cWxKWVRYOUEzdWNu?=
 =?utf-8?B?NUZKZHRYOUhFTS9zNVhPZUtzMUJMNCtUSG05RGV2dnJkK29WanVlS3JpR3dj?=
 =?utf-8?B?czBLd3ozMmt0YTV0MHNCNTlta2RHeVpoZFBWZlU3TWhIUDNYNnZJT2NLN2ts?=
 =?utf-8?B?NVZvTWJYVlB5ekgrKzRxdGlMR2FvelpWVHRtYVc5YWdqdXJzWjNjd3VPRVhK?=
 =?utf-8?B?UkhPUitBTXNtVzd0bjVpTExaaERaREhRQ1pyaExvTjdqUWM3MHRqRWJtZXlF?=
 =?utf-8?B?V3NOREQ0VTUyZzREVGhHanRyTVVTRi9nTjRXalB2ZlNOS3NFWDZOcmQyM21r?=
 =?utf-8?B?RVpmenFvcUxGOENNSDhzbkh6RVJjRzBPa3d1K3VrNWVWZG5INUwwbmd6aldy?=
 =?utf-8?B?bkNCQm55R3dvSzdwalc0bElZdDQ1em90Uy9lUG1sR3FSSS9uMjRyenlSTXlp?=
 =?utf-8?B?bWNvNnREakxzTkJiTm1RcVpWTFlrSjFHN1dGck9EWmMxekd1WUdxbDN6ZVV6?=
 =?utf-8?B?SE1HN3hpV05KbGphWmg1cktFaHJDN2dUOHRQMmR6VDIwb3FZRWRXTmpLdGN5?=
 =?utf-8?B?bmhuV0ZWZEFBOStxUWttM2dYYkxvTnFtOTFRdG9jYVRONWE0Y1M4ZVJGdklk?=
 =?utf-8?B?cU9DMkxBWTBmN2srTkM4MGFPcDdYTWUyMDVNa1I2RkpaODJvaDRHZlYrMldF?=
 =?utf-8?B?NC9nSjhxWFJsdDlQWHpIN08vM2ppdkpCcDBpT2RyR1V6SkpsY05ZMjE1cWtr?=
 =?utf-8?B?VWZxa3RmWmlKK3B3TnpPRnFrZmJQcVArTjZGbmgwZEZZbGhCUVJTeW4yS2Rh?=
 =?utf-8?B?Z3JUc1BNVVoxeS95TlhxcFRENVhrT01peFNsZDRQVjZLWVNUSE5kWU85VWo0?=
 =?utf-8?B?eUpWcDBnZmZJRnJmSE5JZGVvbWFJVTlCYUQrVHNOZzVNSEprcmI3LzI4U0tC?=
 =?utf-8?B?c05KQ0F1NmFVckd6eExoelhqdjZkZ0J3V0hVZDUrZlVKNnRGQk5pNTFUV1gw?=
 =?utf-8?B?OXlMUUpPWUhUT2FkQ0txTGM4Tjkyb0VaQjlRcmRoNWR2TStVQWRPZUJPNWor?=
 =?utf-8?B?bTFsTU13T3R1VzJpVnVkeGxVUU1kT2w1WFdLMXAxd01adVd1UmJ4Zzk2OStZ?=
 =?utf-8?B?SUtpL3M1SXEzdytVZlh0dGhaVGxDcHNpRUFaK29lZlYzeFl5RUZJRm03U0RF?=
 =?utf-8?B?THErVUliTkxzR2dERTNaSStvQjBhMnV4ZWpMTDRFVGl2RnN6R0dsUmtYUndi?=
 =?utf-8?B?WDRqQzNIVGwwM1AyTDlLT21acDRrM01oTXJPL1cwUi85aldPVWdsS20vMm5y?=
 =?utf-8?B?QzdveW5mV3F0eDk1Q1VTSkpkKzMzS3hodmxMVU5DcEliYWQrcEY4ZC9PR3BR?=
 =?utf-8?B?VlFGTmxRWis1ZTZoSUc1WHUvMzdwaWJoSnh1ekR1TEhGRUx4RGIzQXIxWTNL?=
 =?utf-8?B?dFFNMnl2dERXdXJqRFlnbEFsOElacnVJZXFTbE4yQWVjenJvdC9MeE1uM0Vr?=
 =?utf-8?B?bUE3c3hMV1JnZHRRVjdJd3hGdHhuVkdjNEdLM1pmWXd1T2NZN2cxRWFsQUFm?=
 =?utf-8?B?TlJaSytROEFPYjhPVWRhclU2ODU5ckEvemFzTXVhWEp3RG9mcjFkaGMrbE1w?=
 =?utf-8?B?ZE84aWFjVUQyc1lPdFZRaGJkNWczK1p2RGVpQTM5OTJsM29SSGdrbTJPNDIv?=
 =?utf-8?Q?ILMn9su+JfekbSHXHtdVNM5jb955txGtyOSaVw4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1abb7e-3ccf-46e7-e76b-08d8f32fa056
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:15.4207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pGQWUWg6edD49d4wBhyLfbSes/gznWrvNaDGV58Gap0ylSlF1di7fJOWC+6HSKAL8NVQHKgnipdmPZ4y9u0R4+a/dH6Lr7WRS+fP3BMIaMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300023
X-Proofpoint-ORIG-GUID: lrjMVMdh8R0pZDJzePI8q8ysk1yGzLjA
X-Proofpoint-GUID: lrjMVMdh8R0pZDJzePI8q8ysk1yGzLjA
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1011 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 12 Mar 2021 10:18:03 +0800, Wang Qing wrote:

> Fix the following coccicheck warning:
> WARNING: casting value returned by memory allocation function is useless.

Applied to 5.13/scsi-queue, thanks!

[1/1] message: fusion: delete the useless casting value returned
      https://git.kernel.org/mkp/scsi/c/690209d5ebef

-- 
Martin K. Petersen	Oracle Linux Engineering
