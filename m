Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930D6C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79098610A2
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbhJLUho (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:37:44 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61096 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233019AbhJLUho (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:37:44 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CJj2AM002214;
        Tue, 12 Oct 2021 20:35:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+aSIH4Kpr64n0/0jwAsJP3MHxZ4YIeC/RY4w97+SQxI=;
 b=fo6lYogh02sCcaySAcC9tvUjAyqpiQlzjR64JzjcYWNwlKS+2BVyMxUUFm5rUPO4kLD0
 tHIOAJG5QYgzYgT07oarEhcDk97M/vPiroZveDl/z9z+BUZ1+6rD0xus+9ek2reW+jGy
 8pTVDj2i+FNvAjDDgBjlRrifo1lI5pLaNzrWiAhcizs7iBcAKJjvJLJpZDRCBRz0m7iG
 tRjO10kChRBHKzEegnfIaIy8y+J2Qnv5tywzgvQR+gJmawlWkUZ1ofIE7c3OiAm/YKBZ
 A3gFY5/nGzQ+lTEP2j2dPSrhoj7L+gFac/TC1kYlQ6FioeD/ot+3J0CK1vwkL4Q2Jkv2 aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmv41ru6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKZ7M4009545;
        Tue, 12 Oct 2021 20:35:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3bkyv9jq2n-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5q/koHbiZNP+u4/N9Y5UhHPdLJ+OMTZzqedbjC468GnDelUarJw2V54tYJLD8ZV6K/Q1UvKFrgDlk4FHVaGlFxwQJjmP20Bqv/n4Sopb7cxru8VrcwjIvPu9V8q7mAFDwixcFCzCAm2gqnLZTpq8aPEnlxRvksEgX9RR7fNTbum8qznH1pXsML9JVVFyAwF7SKEt1dhzscUVfYjzFEuVrdquBPQmxPH+tWKx/eANXJiJ4B8le8RRqmXQae0zIZHU85JmsW33b5ucZ72TtJKoJAmRYj2jcXsadpS7npcLy5mVUBO5q8u7J4dAkG5W7v0L9J+s7g1H/EJEnVgkpIwwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+aSIH4Kpr64n0/0jwAsJP3MHxZ4YIeC/RY4w97+SQxI=;
 b=cc7vUStyyf/yG6qQjAQIwZ05NUtKIHW3c+MPpRKrSNqoIasILYiL3wlFOfGytURkZhnqI6X4QePl0JsivrBVQq6q5G9PuSeG5RoPwptx6Szpe/HL5VHh4tJIKxGr8RXlsWXmWTDspOkESpGUXaeckBM7ICnYLOON+XzXvZhfQSncaAPzlapOzCVU62fX2OjZRpSgLxZwCbk8FnuqJ1JocmKkiwy1pZNSXlTmYc52FMmah81Za5JXt5GRQ1vyHdrWL+uThkMDqxS3udhOOJ89JhZ6fji/5LBAtNMX4DOxP4JKjLjlqphcqbsu2mMhx25idT/PAt2nW1Y14hPPn505tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+aSIH4Kpr64n0/0jwAsJP3MHxZ4YIeC/RY4w97+SQxI=;
 b=H6bahyLA8Jbejza5RSYsY5cKtaDnwaSxWb/lfvHvoHIDLlwCzHRaml/NcyIhOBuQpd1ATWc+C1isjXndHrmleE6mnfI/LeVTBHvWDFbtRNE+ov95J4N19RH3D3Qz+1JyurA3WfMnRpIHTj6BXQPc9BzHjwvGRb/m1QMB3W/A3os=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5514.namprd10.prod.outlook.com (2603:10b6:510:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 20:35:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:28 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, fengli@smartx.com, jejb@linux.ibm.com,
        gulam.mohamed@oracle.com,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: iscsi: Fix set_param handling
Date:   Tue, 12 Oct 2021 16:35:24 -0400
Message-Id: <163407065460.24401.12164858865662341458.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010161904.60471-1-michael.christie@oracle.com>
References: <20211010161904.60471-1-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR04CA0095.namprd04.prod.outlook.com
 (2603:10b6:805:f2::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR04CA0095.namprd04.prod.outlook.com (2603:10b6:805:f2::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 20:35:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e365e185-bc57-4cc1-0a92-08d98dbfd40c
X-MS-TrafficTypeDiagnostic: PH0PR10MB5514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB551454B9B81D3CFDBE1136338EB69@PH0PR10MB5514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CeiCb5p+/yFHC5Tc+NBAqSNsL+j4XVz0UlU29v2VDJw+jpoenyGO/3yH0z6Rn1K862Z6/neOUDQt+JuSbu12f4nki245P5YhI8/RBkAlwJBTdw+n1azVPsi/7Zr3VqVbIFgJnIXqx49NuG4Aw/z7D4zyoQa+6rQ9k4d0julNgajMNx9W0wz9jGueVfpAq4gJDvF+KE0AQonaGqotIKo++0w/NAPYo7n/SzghmnRBueuu/7OnzeO53Ebju3KeFsUSDNNx2SjdV2yqIFsohV325+zVRyAu6oDGenDZgmalS8BKng5EPmLWqHF/Y5sg0nlWRE4RIHmsMJJEEiamguPC863oct9kfhDWFCDUDUXE0JK7nbvt3F3yMNrgvFzfBCTMPHmskc9OVFnNOkl9DnkV2nVpZTEKBCCdKWQG2bewr3/BVKV2ZgedLei0j17aGJZuOjdaNW5P/fPRxIFBSeSSnYKhxn5RZNY0ExSJGQhc8eDWW9/91X9l/zjrohbqBmWIZzY2oJ+NTjNbI8CAq/lyJ/kvJ8jMwD3KlOREFLIluSpwsbl4wMzdvsi7PfJyxoDUMNjzHN1IZbXRVccw/jMmygBagV4voJm8NkGxd5uru/5tml0CEcZ3X48lMGUNT/kJLcze4z5BYA0SAky/FlTl9H7E+bs9pgidugMaj2MdiMe7ItMCwe3kqS6r0f7iNuN4Qri20OCkXSPUNk5X6TyHO5NopXbaWJuZaw45GnNXXbD2Im0B/ZBXsK6V1/NFD2HUKYbrRBrSLH9vE0FwsHNlYga25wOG5M6FxzwoIpIQ6Yk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(37006003)(5660300002)(6862004)(6636002)(8676002)(2906002)(52116002)(66476007)(66556008)(7696005)(6666004)(956004)(107886003)(66946007)(6486002)(38100700002)(8936002)(4326008)(83380400001)(36756003)(186003)(103116003)(4744005)(508600001)(26005)(2616005)(38350700002)(966005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2R1ZEx5R1F0MS84WEl6R2p5bndiK3lRM0FaSk9mZERMb3U4Nkw5aGNCSWYw?=
 =?utf-8?B?a3dja01OaHZWYVBJWHQwZFBnNDhBbkVJUmQ5UDBhajVpczk2S2FhRXUrOTdW?=
 =?utf-8?B?UDdhSDBqZVJiU3p3bzhIMUtIWnBjUlduQ1JaQ0F0aFVjK052cFE4QjlRREtr?=
 =?utf-8?B?NjcvRzlqRitlS211TTZYR0FnK2MxTXFCZWtBeXV1RFhkRWFHMnBRZTZUVUxt?=
 =?utf-8?B?Ti9TRjVSU0dlUHZxUXZpRE13a2haM3lmZ3lkSDNFdUJ6TUhBWWRHbTdaT1FC?=
 =?utf-8?B?ejlXbDZ0Zmc3R0FiQ2VrU2ZVUVdpdFhIUkMrRkZlcEV6aWtPNGM0K1BUNk5s?=
 =?utf-8?B?R2JwMTM3REVtcjlKUVgyM0w1K1B0QWpnaWl4bjZrRSt5UzN0bmlkaU1YQ2lN?=
 =?utf-8?B?UnBNL0p6UENSQ000b25zNDFRZG54aWZ0SFU1cnE5bjNUcHp0b2IycnBWUHgr?=
 =?utf-8?B?ZEVzdG4vUk1RVmtXOW1rc2JWWkRuS1hneEg1NkVDbm1lMy80elVTM2hUWll1?=
 =?utf-8?B?NENBbDk3V0tPbnhpQkI4WDkrNXBRbGxVWThVNzBwN3pqVU1iTVpQNHdNb3p6?=
 =?utf-8?B?azZnVDhsdTd2RjJQT3ZCUkVXVW5JbW9QNkpLYmorSHNkU2tFd216eHB3SXE0?=
 =?utf-8?B?UC85eVJDQ1N1eVg4Vkl0SHYyQmhsUUN5T3Q5clIvY2hMSmZabzBuK3YrVzFy?=
 =?utf-8?B?L3Y4cnc1S3FPYi9ueWhCaHBkZys4T0Y3TlByMXBrRjBDUTVzSFIxSWlwTDNk?=
 =?utf-8?B?UG5BVjY5ZVliLzRPOEZuLzZVRU96S2Q1RGU5MXVaMzRGbmZZWHA5VkZOcklM?=
 =?utf-8?B?UllnK1VndlBuYzJlbnFZSWNvam5TUGNqVnhzbFFaYnNnSVdBak5Dckx3YlZl?=
 =?utf-8?B?NmFpRXFkRmhGVU1HVWRxSlZQWTBoS1NoMlY2VmlYTkh5S3JDRnZzajlGZnpR?=
 =?utf-8?B?bkFrcVEvQkZhN3FZSzJIeS9VbWJzWWxsUGVRV0FUWGRqclFjVXlyTWdLWWhN?=
 =?utf-8?B?TVVWTnBCNVZmeEtsbWRXS1ZsblUxYlRWN0VYVytvOWhkREhCR3M2THRZUEFW?=
 =?utf-8?B?aHczN3A4UXNqYXBWNlJaRnlQekNsNEt6RzdQRzEzVnFkSjB1TEY0c2p2SUp6?=
 =?utf-8?B?dW5lNmtjNHZndUJpSzZkVU1yQzdpanpzZkxUVXl0VzZJSnozNG1TeXlIODFD?=
 =?utf-8?B?V0Y1RXp0SWF2ZUdRcXFvZWY4SkJQRHVNWm5qTjJoQ0V0MGl3SUY5VTlMOUJV?=
 =?utf-8?B?K0ZCeTNBYWRpc3VOK2J2QkNyZmNJdjByMmdRVlY3VDh6M3dMY0grWEN2T0ZI?=
 =?utf-8?B?RWkxRXpSV1dpdkZ6OXA0SEdTSi9MN1ZwREw5SDdqSjB2Rk92WENlanJDbVVD?=
 =?utf-8?B?NFpsRWVlNitIVVhuUmhWTUp3RWt2NmZBZVpuUWZHSUxNdjMvMEZwdjVHRTVk?=
 =?utf-8?B?WEp3U0RXdFhGanlRSFdydzdiQ3hIanVqWVh2K2dHQmc3Q3VRYnhObStjS3Zv?=
 =?utf-8?B?d2ZtcVA0V1NqcTNaM0FnWGVhbm1CbmljdjJzZ1plK1B0b0FwRjNnaVgycXdn?=
 =?utf-8?B?VnlBcngwL3pqTnNGRks1TVBueGFyQ21WVFZ4NnFPODhma3RBb1FNRmxUdFE2?=
 =?utf-8?B?RlRxVnBXMEV0S2pjNVZXd1hOaXJocGhjZWp3R29OWGJsMUpNVmRwa0VzMWxj?=
 =?utf-8?B?VWtQT05ZbHpqWndZejdqVTIvak5xei9KZ0w0M1V6bnJnSzRibzl5NzNZT1Vu?=
 =?utf-8?Q?b2BD0tO1z9dI1Ox50+IBckN5Zddr3nO76+3ns06?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e365e185-bc57-4cc1-0a92-08d98dbfd40c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:28.7595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D+RujbZSbZVASXWzcivZH7Pk5f+sFAikFy1wssz/O8GqyLAngS821rZhPbBxMUrkH8Sh/oOv5Yoiosso3vQqoFi2Sr7o3iiqfi8quXn+F6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120109
X-Proofpoint-ORIG-GUID: Mj-mBaacckscpeK6FnYvYPF62AeuORbh
X-Proofpoint-GUID: Mj-mBaacckscpeK6FnYvYPF62AeuORbh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 10 Oct 2021 11:19:04 -0500, Mike Christie wrote:

> In:
> 
> commit 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and
> sync thread")
> 
> we meant to add a check where before we call set_param we make sure the
> iscsi_cls_connection is bound. The problem is that between versions 4 and
> 5 of the patch the deletion of the unchecked set_param call was dropped
> so we ended up with 2 calls. As a result we can still hit a crash where
> we access the unbound connection on the first call.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: iscsi: Fix set_param handling
      https://git.kernel.org/mkp/scsi/c/187a580c9e78

-- 
Martin K. Petersen	Oracle Linux Engineering
