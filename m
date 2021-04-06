Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79F8C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B71D613C2
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243645AbhDFExn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:53:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53266 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhDFExm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 00:53:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364oFFQ076024;
        Tue, 6 Apr 2021 04:53:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ClloQs/0c0SwLGCYxrjk75qr3MJ9xstE05v1s9rWZqg=;
 b=nrRW+RT22TB88bEOJKeKm3C4nwt86wu5Uej1MH/8m2FrS6AtHmG5sapWWPAHARfQOo1a
 jYGMzDQom4B4r5aiaUqrEwzSAVy1h3nqYDZ5YLzkU0rHkLfRzpBt2Vvuy31zD5Muu+7g
 dGtaD3EToJB4XNHkqgJ3gdFlq6Pk9+qDYLlocmyyLOf/q3CfhDv9Dv3Rxi76qMMDojq3
 sMsuaAhJsLS5Gw6UvtI4YuWMir5H4n0i/cpeXeRmt+JYyQNfZedMr1nBw9tk5OG0qeUn
 IZ0HdasnuCp9MZ3mWkXwdBn3QlCyKTc8eRZbUu5801XaS4oVHbChIP+5ZyMbIjnF9j70 kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37qfuxbbu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:53:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364ox0Y070460;
        Tue, 6 Apr 2021 04:53:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 37q2ptrhk3-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:53:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FSHrvYML2GBczuA5v+FWl9k03/5gplkIR509z8LnqKbBMcYTADRNNNrRMqOhjJSt2502e5eaRWgZV8WZWM0O/cvZZQV2Mcfbx+UHaKGd5e8Xga5vb4/TIChjBS9NXT4ISNj6lEVh48lxhyCN0SuR0VTthrfhJLY0K2WFvM5xHZik9Hs8bzSPr8mCOHQz6Frz1Z4fwi/a9hSILTEOOBqMAcugmVJFNS9wuE0Q6sefjGM2T0iBJdemd8sTZIzQarlnlk+QOCMWJmW3wWZDQDSTiWdHmcUIhjCb8o3aGEECE+jmkjLoKa0ZEcz7UjifLlzeyhOxsvUTXY7OZ4bSxZ5Tzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClloQs/0c0SwLGCYxrjk75qr3MJ9xstE05v1s9rWZqg=;
 b=gVKOkVeU4K+z0c5TAW8YIs6z0Z+BzYlYpEZjTuTG17Zi/UqXiafkLF2sSuMdLrdmvSC04BggAoCYFq00OpV4Q+iLpovKtvtXAtQSfN1CUbptuFxX4BLQFz915RIn+h+sKJtar0COQFinL/xc6buo830zz3/EoMrmbWwOSQmWbTrgShw0PhSTZ5i6qxZBlKwEIvXegUqF+Y+ZtUN93MbVLRqP0MebNobmp7LFlUzJmN6fwWJh8iBZ95bQUdLe6SWUKlU2ZyQkgvE5GLwgcZpAV/O4AXQXTCR3PwbxsG6MWk0cOTVwShRDpIaE18EWHC7shEeWyyrSC3qvHhAI2Ej2Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClloQs/0c0SwLGCYxrjk75qr3MJ9xstE05v1s9rWZqg=;
 b=HL2gmOaT59g6Hb1XnizigQTF/IY9xwYb9d/pALR1Gw4bg3FCLmFFnjeXwDKQ/lRmU+4o3WzLpIpSMiaZKk/6tQ2WfBqRDBli0jmOoY+b6r7j0EtslhUt6pt/zLIaqW3KZ71szDtq01C7rrbl11iS+9NCTm+AjWTvgEFUAD9rJ6U=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 04:53:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 04:53:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH][next] SCSI: fusion: mpi_ioc.h: Replace one-element array with flexible-array member
Date:   Tue,  6 Apr 2021 00:53:21 -0400
Message-Id: <161768454092.32082.885980620938932876.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324230036.GA67851@embeddedor>
References: <20210324230036.GA67851@embeddedor>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0193.namprd04.prod.outlook.com
 (2603:10b6:806:126::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0193.namprd04.prod.outlook.com (2603:10b6:806:126::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Tue, 6 Apr 2021 04:53:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b27fdf0-dd28-4a1b-dbfb-08d8f8b7ecd8
X-MS-TrafficTypeDiagnostic: PH0PR10MB4407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4407D979EDA36C0F1141209A8E769@PH0PR10MB4407.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9DyssQTe0X0VynkkUOV7ptXsidoQPxZyQf/RSSVzeibV/lqysrRh4X1C7IK7hbEoA2lCewQD8vneqFY9NqZKJ72+rJO1ZlR6uR6I734ab3Si38CQW/gYfwLUmXdOsSw2C0Ut9h396LUslN3DZRwqruPTGWGzQdB07LUlcAn6VnjnFY5ChZ9mFgqaA2EU6+48f6lbFLwXIJqdmAFVbhN7Tpo+OABBSq2K+T40QN/Eo6U9LxnlJIrfuwTCwKrCduSyGX+IewaJ9GxGWKcl76m+lnKbeYhYuwqKd9zvsN1/Cl7e/X9/iuG+UM3SjBZUsMqiPMM2mVrjmYx6yF7a28wYDyV06jkXjXhekIpNe4A4kLrZuQMr/lfv/tcz263HeS5Esz+KIoHz6rR1/Su0DY3PHSEhLxTZ6cNpNVuDo7v7YA6wQ7JLcDfUGtZZBA6IehdMJ/91smuo+t/WsyJx2Q9bpFRhBMaYfUMGMuRXNDIh5P9yObWmO2/XXfVam/Z37Zaay/39lrQ/7H9QJGELLtVZJAVMhMb4lrMhHeBd4nPi0pdu0+gZW+lipxebXcpALQkys6+ixwBFkAsM5QGnl7/aMFZpqtukYQzoZBVlu1m7GVy1TSV99fAmzyaYnJB6iKbDDMYNhkaGPDLcniuKXZYGQ/YbmKJ5SXVncl/TF1Op3wn1tGLRuIxeZ3QZ/KXMwD9eTyyI2CThNJy2RGIZoQKEA0oy90b425YOHT4Wp2UDYS6PjRBgJ0Z7a01aWxWT8bg/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(52116002)(8936002)(6486002)(7696005)(66946007)(66476007)(186003)(478600001)(86362001)(966005)(8676002)(4326008)(66556008)(956004)(2616005)(6666004)(26005)(16526019)(4744005)(36756003)(110136005)(316002)(2906002)(38100700001)(103116003)(5660300002)(83380400001)(38350700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YTlKNGhqUEViNW1sZlRHMlFlbHRuSmtnZ25WRERHNTNYSWZGNENtek9CMWxS?=
 =?utf-8?B?SmMxQVdjN2NDWUNYeVl4SjZyMlhHU25KQm1SNWRnQWVpZ2thVnk2V2h4bW5M?=
 =?utf-8?B?NUFnMzBTOWV2RlBjOEMvbGNzNlFiV2t3SndCNHRWRXZCc2FLbnRkSTlIaVI0?=
 =?utf-8?B?UFNJSEhiaG5VS0VKNGI4MzQ5VkExcEJQTHdzbXRPZUhuVHBCZDVHd25yWUVy?=
 =?utf-8?B?R3dObldUa1ZDMFRlT0tDalIxMFNmWkM2K3BTT0lTUC9OK0FRSEI2YjVuNGYr?=
 =?utf-8?B?c3g1a21EeUlPd1lOOVZESkU0UWdBUVBLdTZEWUtFekdSRmwxWnR1WWo0SWxi?=
 =?utf-8?B?VG1rV0Z0QXE3Z05oVlIwUW5vUW5CRHQ0dkx0Yk1JMXc5NFZOMlZYaExqSTQ1?=
 =?utf-8?B?bkszUUxNUlQ0R042R2lhZkcydkJ4cnZsY2FPM20wTmtqQW9wdy9rWjZ0UkZY?=
 =?utf-8?B?SytmL0diZWQyMTN6YjBMVEtXMjUxSWlzV1crdzB1Q1FHVlVQZk9LMFhqdjBv?=
 =?utf-8?B?dkZSVnhPTFZMcEhOYW5qbitST3lNU1hxSzZITmVUcmtWcDc5UHNSQUpsRDBQ?=
 =?utf-8?B?SVBRaXdTa2JqU0JNQ0wrVXIrWjBDSTlPRVJPUnk3YTBHVk16MHZoQ1UycWxo?=
 =?utf-8?B?QzFtdFJDWEVZb21JcGEvR2lXQVRGMDdMci9Ea3lYb3hiQndoUWdRSDZMeC83?=
 =?utf-8?B?dGNGR0N0S095NEY4QXZGcHFRSExzZG1DUFJBVnliVlBMUGpwMmZqK2hFZldQ?=
 =?utf-8?B?S2NvdnhsaWZJaWNwTVNicWV0M1lkRUxwOHpXMkY2UGNpTFpzeWdDTVRrSXdG?=
 =?utf-8?B?c1VrZTFFUm5VRGlYcHM1dEdoblNHbFM0Q2xMako3OStUY2JNVUFtandNUVNF?=
 =?utf-8?B?ZzY5Mk9lWGxxMkliN09hT2RsR3BEWStNUURYMGF5ZmZDUlBvZnF0TGJFVE5P?=
 =?utf-8?B?clVXcmJnNFd1R0ZsTno1Q3NQTFBOMUpmdGw1Q1EyVTZidGhlV1JTMmF2NXFz?=
 =?utf-8?B?OTc4SWFsS0JtYVliTmZwMmJhb1I1ZksvUGVJcFR2QUQwUUJRczMxa3J6Qmla?=
 =?utf-8?B?VjhIYWtpTVJBNGpDWGtyR0JiakpibDg0R0FUcTNZVi9LZmlJRnlURktGWWdx?=
 =?utf-8?B?YUF0Q2tCTkdEb0VOYiticldPdTF6elEvR0toaWlMOCs1eDYzS3RCYmdCQ3FB?=
 =?utf-8?B?ZXJWWTkxcC9aUTlLNzBNYm9ITzMzcVpmd0dkSnpsYmlxWEQvZEJZRy92QWp2?=
 =?utf-8?B?dmRNc2ozVmlPYmYwcHJKM25WUU5ONTYxR3dmUEtiS2lCc3ZoeHA5MmF3V1FI?=
 =?utf-8?B?UnE2dlRaTXBiaXppajdMcS92OFNkQ2Nkb1diQmFtZ3F6Y0Z6UFBsVTVCMVlS?=
 =?utf-8?B?S21jMDBPaXdsR2lnSTE2Nk5NOENXNEtweTdCY3p4NEZ6WThjZk5jalhoOU1S?=
 =?utf-8?B?RHN6a095OHZoNk5CMG1JZHFoTUlHUXJndXF2VTVpWUJwSjdra1ZPYy9OQ0RQ?=
 =?utf-8?B?aGowcDR6MXlOMDNTTDN6NHdzMmVScFZGS25ILy9yU2JVTTBodGttUHhwOTBH?=
 =?utf-8?B?U0N2VGV5ZHFlZ25iUzkrWEFIVlAxQVJhTGM3Q1BkNW1aU3h2U0NJRkFDbVEw?=
 =?utf-8?B?UWNTTnJ1WWFBS1hHSStzQ0I5cys2K3FVUTZGa1FRb0NiS1FUYTVzSlFBVFVu?=
 =?utf-8?B?aGNqWFN4Q0ZKZnYyOTFhK2RVVGtmSUtXbnN5YUN1ZEtXM2JGMC9pTTA2MWh2?=
 =?utf-8?Q?1cmM1tM9p7SAFHDf3hs3awJqUWqbLpFAlBHhAyC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b27fdf0-dd28-4a1b-dbfb-08d8f8b7ecd8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 04:53:31.1115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TsIZrG3bUKpmGDkgAa5XOlDQzNrzoKVQmXcff0ILLlkQaN5EtCYT51n6LJy27i6a1BaQOLqOuKkwGpawMIsVMVa1es+WPtGp4MHKRHZlyHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=954 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
X-Proofpoint-GUID: BH9X05sjU2xcdiIWgcBUoOwZYjoTH1YF
X-Proofpoint-ORIG-GUID: BH9X05sjU2xcdiIWgcBUoOwZYjoTH1YF
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 malwarescore=0
 suspectscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 24 Mar 2021 18:00:36 -0500, Gustavo A. R. Silva wrote:

> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Also, this helps with the ongoing efforts to enable -Warray-bounds by
> fixing the following warning:
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/1] SCSI: fusion: mpi_ioc.h: Replace one-element array with flexible-array member
      https://git.kernel.org/mkp/scsi/c/ed46ccc7fe76

-- 
Martin K. Petersen	Oracle Linux Engineering
