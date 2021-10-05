Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09333C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6EDD6136F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhJEEhy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:37:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47714 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231393AbhJEEhw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:37:52 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1952rAM0029426;
        Tue, 5 Oct 2021 04:34:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Zxb1Fp5Ja0sRozGGe2yz8EdEztBgi3PFjU0atvp0FT8=;
 b=ySG4nEAHjsGoKjIHi/Ieobjv0J2nQ3KxbQv61CR07TMbrlsuZbaJYzZ2lFGqUr7f51/a
 vzhfwsDuBo1/vtz+lemfxS/kMbooGI8MOadJBu/jj0feJ1/GslsDE6nAcynLqxJHy0nP
 sFIwtQbWDChZyxX8NvGQZWPC3v+6y+uELl0SCVfcYGFFGl96f//4uDV3/aLZcM+FaiWt
 1tFjB6TgXCTkHhaaPUAuR90GwqIPla6+++lhkTiOBUqSb8QnbYcOedsZIA8oQGvBD0ZP
 lfd3gfqRLRfNPiLMzXs6mxsPHk5IgtFikgGnMiEkKJhSRDeILUkNC+0AgB3b559mRevt JA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg42kmmpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UJMY054346;
        Tue, 5 Oct 2021 04:34:49 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 3bev8w4hvq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gk1uW2P1jm1drjlVPZWI8P1S680bYG2hKw36SKnzh0pmpwm4jxhKvwByQ5eVH0acuCuOXlPhuX41irroWg6UwOyVPSu0agfCabaKMOXyXwtbrZXCvbf28eflHxIp3IA5dH2ipJGssI1zdtuctCtrMdMFtQRaU9zU0NyVOJpl4sFS+Cl2GMKWPY7+ud5nraDrp/+wjAiCWsNMF0RwDZdq06iJXmP/ePbw+YBwp7L8/WtJY9EvcH5saJcxp0CUu72udoHB/zlRLNdhNZ5ATM7E+fn3qTtyK1zdb9beB3bztF9PdV1SxdD90qxMBSP4VfaPm/7uFawDYOTIvNKomXTd4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zxb1Fp5Ja0sRozGGe2yz8EdEztBgi3PFjU0atvp0FT8=;
 b=PVM0XbQJblp3e/P5vMAbLrdYc3dC9kiky4/3BeSobxIF6LwgSaTaou9HJbqkabbb9NchGUfx+lbdLrNLH1tRkEHhrDC1ZPFWyIA6m59eM6RJFy6F20A2xO9gcG0SZbf4q9qeINwU88NG3miZns8gZKwkQisy/KYb9hmhNQT98yycZH4GVlyouU7AZGN1I+L6X9NNRi+PSnQE5QDBk9ygcXAcSjnThRd5eSDRKa1jwXupiWVc55/f1rPcGI+bxzsRm7tIq3qfMd4u/dulaBMCN8g1KNB/eSLFu7QRqqbotj6Wi4T06CnSyE/f+Yl+mabpp/oULw821GfuG3n8g0jHiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zxb1Fp5Ja0sRozGGe2yz8EdEztBgi3PFjU0atvp0FT8=;
 b=mVyy7A5y1KZjsO3WGo5uof1z8JBXqyUfEvGm9CdzHakjsug4feYTrZfWX0JDcu3MgU2mYPkXnulpemwkq8O1qUc6Q6r4tSrvxSaMuI/Vd59NDwJ88nslPGOtTPCzDzSrOwuFGTojj/3xurhOYuwOzjZZRc4tHHawQzu9N806/XY=
Authentication-Results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1950.namprd10.prod.outlook.com (2603:10b6:300:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20; Tue, 5 Oct
 2021 04:34:46 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:34:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: aic7xxx: Fix a function name in comments
Date:   Tue,  5 Oct 2021 00:34:31 -0400
Message-Id: <163340840529.12126.1327873803115688163.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210925132931.95-1-caihuoqing@baidu.com>
References: <20210925132931.95-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:6e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 04:34:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 254cd6af-8ac1-4450-3937-08d987b97599
X-MS-TrafficTypeDiagnostic: MWHPR10MB1950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1950A01D065AF8D4CD8603198EAF9@MWHPR10MB1950.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K3IHc50Sb+wWSLXYA1gG5jkw18vDGSCF/ec4rn/mdI1rKToWFL5K2JwpDdk6/8DyQe15YLerZZ+aGxRjInhrOOBfG4vgx2jJCr9t9KWWDmUmf2liXXTZnfubCN8ggYgwqEj2fzbRaqGENd7zFj+fuq0b/3+f61YKbs6/ciSrskzuVKt5CBjl8A5h/y2srwr767nsClZ3c6/DZxsGoe/aQ7zPVss4XMkRor5SeIrJaG7mlVSk+zVlVKe5t+fMo2H8KG8BOfOwXVm2Fb57Kk0v/DQdWzSIbHrOU1g20bsVgOGGAwddRaAcCAXKl4zZKE1EFENs6IQ9fbANP3rnz9z2kF6Gu8dwJywADWvbMnISBzHjZe95BHFXc/AK/uhN3JAsssMW3Z5qEjOPc3iMBr9QFk7S7zcHQ390jl6V7+EhhddjxHxmMEY/ixxElZZ+7vM7K2mwkS/BlL/GPmvITtp/htA9f9AisxsTi+Y5KzVJB3T122spEmAT8YWV5CFGcwNNH+mpcTDymf1ibhA28oGrTQwQTsjXIZx7BR3GE99zGShoCRYxbORnDh2mEjMco/btLS6AJnJKWRWY0WnmTLqP6HJwyTY1sEOtqPUmMbhVSrIh8YSBC8IwbpEV3/zu400e64jd/CSszLQANUNGwVVB05dn1r8zvUp2I/5gMar2dqJrgQW+n44LnnX9AAscDJk+FOCSgvaqavb9M/8kH059HwaI+fot0uf9esB9gui68DKI5182BFwfjmRLDjIWWVylkjn4ckWhDjXpAbVBeqKST43Xiedslz45VrkSaiG+HXk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38100700002)(6666004)(956004)(5660300002)(6486002)(36756003)(4744005)(38350700002)(186003)(26005)(8936002)(8676002)(66556008)(66476007)(103116003)(316002)(54906003)(7696005)(86362001)(4326008)(2906002)(966005)(508600001)(6916009)(66946007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3I2V09DcXpoc1JlT200R3JmRXBlSW9wSnNkdGJCd2tVd3pqR3cwVWtVWnc4?=
 =?utf-8?B?NW5KY1NtN05WbkhOdGxHWXRYUjVjRHRTbGQvYVRtNjdYOXNaQ0JXWThsVXJ3?=
 =?utf-8?B?NWJkNEp1ck5ITkxvUVo1c3lzN3lOVWc5NVVkdUwzR1NOVWF4TmxmRk5rWjBn?=
 =?utf-8?B?dW9qM1dYY3ZyYnQ0SE9pSzlnWHFpQzkrQ3NTb28wdFpxd0pzMk83UStyaGh2?=
 =?utf-8?B?OFBIVGRJODBiYy81WFJ1Y0YzU1loS2ZMTEFnVFdjYWVHWHhBc3duQmw5VzdF?=
 =?utf-8?B?YXNLd3VwNUdqR0Z4YVYxWXJWRW5uR0JQU3ZianhNQmVHSDllVU1yZFY1bmVM?=
 =?utf-8?B?MnFlWm55ZzgrUHU5eVc2YklUWjNUWkNLRnJ0VW1xdGxaMWdtclVuS1dMT0ZV?=
 =?utf-8?B?SC9RbzVCMXVnRFhtVVZxYUFYVEZQRHRPVk1za1EzL1VzOVVuWTlVYXVObnox?=
 =?utf-8?B?UDdUTFR4YlJTSDVoUFpjc1E5VVkrL2FCUlA1a0lZTHdXcFUrK1BPV2RSczZ3?=
 =?utf-8?B?bER6YkhveS95bE5zaUhwZmkyZExNeUlvUWdRSGRlZklMWFRvb0ZlYVZaaGJs?=
 =?utf-8?B?MWJxUm4xTHNRL3lmcFFLaVBobVpQM0FMU2tibURNTkxXdkMyWTFDV2wvTlhM?=
 =?utf-8?B?RnpBUlMvcUVTcUxlZWs5K3J5Q2hoN1RHWTFXbEk2c3FDYS9qV0g0TlJpbmlS?=
 =?utf-8?B?QUN3Vk9JblNhQ1ZQcHRMVzEyb0ErbVJ1VldNYktSZE1XSWtrY0szbDh1bjds?=
 =?utf-8?B?cnFRelB1Zi9HY20vV29xOGl2QTlHcWc1Njk5WWtJY3hhVkpiZm9DT1c0N3lP?=
 =?utf-8?B?c2dNanA4VWx0cXk2OUtpM1FxVjYxMTZNODFDdUtxRkI4TDZlQk82ZWpVQmNL?=
 =?utf-8?B?VDZkYjRoNjFqaGRZMkZBdzhXSXBhODBOaU56V0ZOT3hTNzhSQ0l3TUNSMzQ3?=
 =?utf-8?B?MVR1VHQxTWx4NEI2L1EyUGdsellrMVd3WWhjb0hrZHd4TlhiVmN2ZjAzM1Ns?=
 =?utf-8?B?eGhWalFkTTEyNHdLQzdEUnhtTVNRQVZ4em1jYnNKOXV5Z1ZGbFA0RDNRSmox?=
 =?utf-8?B?VDdQUmlobEFoMUhyR1prSFlUZ2xMSmNJRU8rR2xjbVQ0cHRlamd5SHZYc3JV?=
 =?utf-8?B?K2ducjNrZkxCRjdUWmFIZUtOanM4cnZ5aUp2aFVwM0FwcWExL0ZOcE1zUTB6?=
 =?utf-8?B?UFB1cmp2bmNrTzJEVnBwY0dNcjRiVnJ2bExsMEZ0bWswTTIrTldXcmVVa0J3?=
 =?utf-8?B?L2srb0t3aVNsK2hnR3ZpLzBQMFNwYi9mNCtkQWFCWjhCVGtyMVdLaEJsNzZN?=
 =?utf-8?B?eHRRemgvTGIreDZyV1B4b2F5RWNXRGhKUjRFYXhUU01ORlo5QWpsWnVZdEJk?=
 =?utf-8?B?aE8xTi81NDcvOWpiejFMQlp4R0YzTlNPQW1KTlp2QW5Ga1FWT1JBWjUrN01U?=
 =?utf-8?B?a3JmS0ZxbGJ4aEk4dTMyZTZqZ3RxKzZkZ3QxN0JIWklUSVlTTks2d0d1bzBO?=
 =?utf-8?B?V2tCa0FEMXZncWdnbTB5Y3N2STRQekltdTZRVG5SMFJuVkxNSVZEL2JraGFv?=
 =?utf-8?B?V3hsbFdLZkdtc1BDNVZYZk5CY0xGbzUvT0pvZUVlRWpNQTNOOE1WUHJLUFJ1?=
 =?utf-8?B?V0tzbVpabGRGTVJ0SFlTcExlZ3dORCtWOFIwWnp0Skg3WklyeVdGUmhRakho?=
 =?utf-8?B?Y0RGWU0xbnROazJHTEowQjd0T3R2TFIyblRHS1RhM1hqMXViTUlZQjFYdlZO?=
 =?utf-8?Q?uxgAiqBUC0to5p8kLZGRmgX29hSGK3vTvw3rOaJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 254cd6af-8ac1-4450-3937-08d987b97599
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:34:46.3601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RlE/itq1fibCt1jGiibAZQUgErevmfxjLqCBl+Zoa3KZ6kWo2E8Tlj3qnMJSlFnmKLwcRLRSVCrqJcwM5MadsGawdXmv3HEZVLRYGHpuYnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1950
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=956 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050025
X-Proofpoint-GUID: 5uRwIexnR9h-iPp3ejNFTWrvbKQAMVM1
X-Proofpoint-ORIG-GUID: 5uRwIexnR9h-iPp3ejNFTWrvbKQAMVM1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 25 Sep 2021 21:29:30 +0800, Cai Huoqing wrote:

> Use dma_alloc_coherent() instead of pci_alloc_consistent(),
> because only dma_alloc_coherent() is called here.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: aic7xxx: Fix a function name in comments
      https://git.kernel.org/mkp/scsi/c/9f80eca441a9

-- 
Martin K. Petersen	Oracle Linux Engineering
