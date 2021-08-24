Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD11C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D2E9600D0
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 03:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbhHXDIa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 23:08:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47510 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235480AbhHXDGX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Aug 2021 23:06:23 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0x9qE013531;
        Tue, 24 Aug 2021 03:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=IrfjSrdrVN7frFHQAweyB68UTkm04rMvQVr9zoFbopw=;
 b=y/GCCL+g35IWROGOLl7cV1mQkM63/cY/XhNV6YJ2LWjK7FTRa7gx7YoVXh51vpZewPAd
 olxqh3CKMNeHE41UmRGkDf8OKN8j13W9CgiJzGi5bfsa6/cjb+1g0+S4eIeJb4mE4W+w
 3TP+AOKbg9MiI989w9vwypjIF2FgYl5ecfK1uA84hYUfM/g63pKf0RYkitjxwaKj8eNf
 ft7awlZ16Hvi1aaBoOavNnyUnsgLN+CFDBvX7kKc8gEiVQQ9JKkLBfn9L7E42+gUNJBm
 CksyOVLi8XZ/PEK+/nS5DxqTPVHclrqS42B4TCgZDZmd71rxRx8BDLgdKUli26Kwe87M wQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=IrfjSrdrVN7frFHQAweyB68UTkm04rMvQVr9zoFbopw=;
 b=Uvt8xzLdLnc5n3xKgtWJuqL7rV4KTKpyOZ4+xiGg68gr4Ubxm0ML5Ir7UGY+IcWukxVB
 R52YZC24Sz3WCS65KCXQZNWyHp7qE+DixHBz1pzcZd0t5MPVyJGenkp0hbUBVBqDt2Fn
 gaQhOQhyjFrEbwp1hJNFWYsFcJ08lONnyDwm2DB+/urUPf81/r6Zxz3ZN1AnEkldCQ7C
 pF58/YCV4bXXVLmnYMKe6k3p5GHUrl9Upso6sKvc7AtCTnE6iFhOD74gP0TcEmpYXGDQ
 I0Uzf2gtvn9GJATcK35u+efxNfa2Y4pGVXxixPOycpCM0q+2UykKFLkG81q1pRDd4giH VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akxreb107-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:05:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O35QDY130509;
        Tue, 24 Aug 2021 03:05:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3020.oracle.com with ESMTP id 3akb8tvy8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 03:05:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEYYUBNPiMU6UpkBuLq3KHDecP8phbTT3YNtBi/CZhHP//rtgvntyxDY2kYxPPqAHSxc31OouKn6bmcDlK38bl5tDuA54EOPI6u9e6B9h38XjAGsXIxVlOFxbCfis2Wm5aO6ouq9Pj3ijek5pYT3ngx/9JjGFGIBfE5U+mVuArnYlwh4PNY+jPOZKYd2Ygzcg9QVaWYTCscMJ33oLhohu8T29TC5abhD/oHdm/Nm9Ee3VRiCX+ZN4cQzYux594lDsm6Q+WiVr2hgkHRx90k2fLdOn7NyLErJwEuqyWNPwGbEqiItWVtw4gjfLZOF+9xBHiIWjfwxBUc9RutnshQykA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrfjSrdrVN7frFHQAweyB68UTkm04rMvQVr9zoFbopw=;
 b=XuThMu8+Z+8bae+bU7SpZ8pLrdskg24DPJBY4+VpujpFLSSB5ORab+2PoiO6x67epyfgxyFQWfzniXzYdtP2Zw/O6DXP4K2GeR3r6LpRFGpJCvDaD261DxFo/eEb5Wv/FrQ5kvMfM/VIf7ghAFjBpxboOs3LgKItVWOPsGHbrNG1GemuBTAS9S0dyF+FDEjP9Qq/IPXXzipReQAUOpreO/z3DkzLkxsDOmjaX3RMwk0KyNwZywKQ7cAn+6aKec4BvxlJ1KshMTmsvF+wll3xq8K54ajaxZG1A/C5jBjx+DfrPPemdiPFdIDjLoDihvobnSeIQGnllALU6uFfJJJavQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrfjSrdrVN7frFHQAweyB68UTkm04rMvQVr9zoFbopw=;
 b=gq5JtZSRefeOS/VhqvAt/JM8tA9+wnSXTXnE0peBlry0EDkHTMa3S2gEjjGg/spl2qV883JIFKxNcRVZXQ7q74sYzG3tANqy2zGiWLFEIhxt6uMG0P9HAYxuLUv50vxcQKfdSuqoExaXoH8hYQZ3otX9ii/q1bGvpzn9YbITvOg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 24 Aug
 2021 03:05:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 03:05:18 +0000
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix missing FORCE for scsi_devinfo_tbl.c build rule
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r6jh7a7.fsf@ca-mkp.ca.oracle.com>
References: <20210819012339.709409-1-masahiroy@kernel.org>
Date:   Mon, 23 Aug 2021 23:05:14 -0400
In-Reply-To: <20210819012339.709409-1-masahiroy@kernel.org> (Masahiro Yamada's
        message of "Thu, 19 Aug 2021 10:23:39 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0070.namprd12.prod.outlook.com
 (2603:10b6:802:20::41) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN1PR12CA0070.namprd12.prod.outlook.com (2603:10b6:802:20::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 03:05:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1005d01d-8b85-4b1a-999c-08d966ac00d6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46642B64E4B3CDED843E62B58EC59@PH0PR10MB4664.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zzl1MicIYSPn5MxllXKZUuyLOpKrFOxeR5NsSDv7CHZU7fS2nbxQqW9XHdGuucZdTkMj+k9YxrY95zhWdE5DwrYjM1n2D+OVrW6rUbVt8iVQvWAVJ8fpIUDiGlZzfeJn7PHCOqpwErAKDK0HL1zj21OjQ27Q9PSMsDs8C3kYPFSTrRbGoiTkrgzeX0gjhPI1v/IUKSo6PEPlyQYA4nXjHPqAYiWpisYsW7mWSqFT64nFyTFWnQRhWPEbdX62siACPbMOQqQThrgU8WJwp4uZaqtsjzDEbZwsjODp9j8xZdsGGNH1VN5gWGlPXmpmK3SoCrwOCKOhe09rp29e3EAn8s4PznFCqAPUy4dalXMnVpwimSKLjvny34la90+kdJxfLQbIFPTlWA8X7UuL//Ga8qZMg9GpDa+t6MXSjRImfUB0uZ65cWv4rpjBwQvm8bOve3Fp/zOvn0dNswx/I4E6MDLLvx93LJE+OIlzJNBh4EWVWmwf7ePSjpiw2eedQfamyDyXKFHFLVdL8jSFEug0PVpborIG7tjCFV745+junRkpK6w9SAcjbpAYtKRW8j4Rb35R3lwSER7TqYDPmHUAAyIKwQnqE8XFez9yqvykpEz1WXBpbDC22ARmvXeUA6eYMLmp4eIN43Fp/gE4Jzy0A41fP23LHcOSym0guBUDu9zRUlWdYQjXqSr4RxgqpUJNnnhwnsLUQaS8jhjDRbMSOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(8676002)(26005)(7696005)(52116002)(956004)(36916002)(86362001)(66946007)(558084003)(4326008)(6666004)(5660300002)(508600001)(316002)(2906002)(83380400001)(186003)(66476007)(8936002)(66556008)(55016002)(54906003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mvtMnzjklMetncLGOQzwwUEmAsNdxD9/7oRHwrvk92uhi8EcbTKkl1JIVTzr?=
 =?us-ascii?Q?8XXNVpCZpyTpMsoqcI5Aj66JncA2Uqd58B+0W1EcE7UVYHmpJv3tlnfmFs3B?=
 =?us-ascii?Q?1iq3ki+Y9CkoZXdg2aH91sbZiI6MdC+L7/MingE3wNkWpU+jgSaVp7EIotPT?=
 =?us-ascii?Q?d7oLAM/tqZJl6Jn9lRTZHZzw512+1Fx1Az492iiOCuZLcdBJH9nPtra9ZJqt?=
 =?us-ascii?Q?lNwyMUyeLbredadoZUNKb0Cr0jWnyU5+OFUrDVMulZ44Rz6eMUfE7As3v7bV?=
 =?us-ascii?Q?ztntqcFbddWgh1M1DV6T1x38EQsT8JqdCoaYJhqkNRSQb+PKFskiscQoXRLB?=
 =?us-ascii?Q?p0smjBtWkD3zYJYF2sltUR1Q6jPXGLpnpfC0dYrWA99I83k61h4jFlgKLiwA?=
 =?us-ascii?Q?0BjSnONqean8t1+eu1cEpM9esXHRlLS8r8ua9cmPZU+lq5XRlqg5Ydrv5BD1?=
 =?us-ascii?Q?2YxKDgNJeSlXtxVo3s/ZpqAbsRji7AVLrRW0kOr1E/56WQ5mDYtAbqtEq7EJ?=
 =?us-ascii?Q?IL5aZLCmt8I0Q6JFhct1QkNdQXyaZYgE0t8fipMfGkgKLhdOK3YUZujvHA2p?=
 =?us-ascii?Q?c7b8Uf2lPa/6PjMh7zkJxgUT5wra4Tl+UPvwXwTI5tZd9JPylevYIVC04O0Y?=
 =?us-ascii?Q?kSMa9t9H5p6jkXgNcprq+VfFm7D9oHHK2C3FfjCK7XWlSMSsRaII8Ck0QDp3?=
 =?us-ascii?Q?54Pp/Ylcy5g8dkxl5JaULhBOFoDif/kD9ArB8FQtaG/KhV9QfpOmiGcv1j1R?=
 =?us-ascii?Q?LdfLVFnigH/jz64bRFe6/Ql9bT9ZqrvC6MlBpfiIQUOMN8njIG7dG2RTxhdQ?=
 =?us-ascii?Q?ly2EkK+UmDx1B3WCv6kLCmkTcnIqujC2qIYGy1+M1mFCfcN7XmCOfmAxB2/Q?=
 =?us-ascii?Q?4/Bh/xz9QrLDor8QaLJHTRiLXW3MbGjirodc7IoVLex+AEmQpEXJ1Nbx+8GU?=
 =?us-ascii?Q?gLUgX+7/v7PLRcrZLXO7pM9HO/D44OR5RH7RXwj+eZWNFzGxO5E9pNVLh70x?=
 =?us-ascii?Q?Y7gY2lqruc0M3hqQbmFCI+MM8pWA4R2nN3niZbqZ8WYOjlY8UUS6YzKSf6z2?=
 =?us-ascii?Q?KSu34IlHykwmZ/55QjmoskJTLn6G80dc3oUIXzbJCk+nVKciQb5w8qrQAejd?=
 =?us-ascii?Q?lRljArKnT8MVvrIspXXN3TrRuhqvH6fPjHF4/kVCcfEft3ipcv539Qswg6Nv?=
 =?us-ascii?Q?rZgDsKQ9tvbhPf4SyTJQij90IfOCc82s+lga/6h2+39J8zha76sATiy+VuG6?=
 =?us-ascii?Q?QKtzUG3NmRl5pg3aFzGTWPpOYt37rRDW0lD3azWWwYXNX/iXvJclpE93nKMs?=
 =?us-ascii?Q?vt41I264B3ZpBQyUqKp+qDpj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1005d01d-8b85-4b1a-999c-08d966ac00d6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 03:05:18.5103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yyCiobJP7/MOlKzcbTfGVjMBKIM1tgxGt/78Zu3NtiWBi0oUs2B2DVLa8p8f9SKx95Ft5td2W4c6KjwNY4+VwWUbmlz/mUfTOUv7lpCFDDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4664
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240018
X-Proofpoint-ORIG-GUID: W55tRevQ2mEusIrx9aVat1fTs-eEUoQ2
X-Proofpoint-GUID: W55tRevQ2mEusIrx9aVat1fTs-eEUoQ2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Masahiro,

> Add FORCE so that if_changed can detect the command line change.
> scsi_devinfo_tbl.c must be added to 'targets' too.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
