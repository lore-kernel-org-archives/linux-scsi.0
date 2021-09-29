Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEC5C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7464613DB
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243864AbhI2DPe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 23:15:34 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:40452 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230022AbhI2DPd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 23:15:33 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T1upkc008644;
        Wed, 29 Sep 2021 03:13:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kXX61E2IKE4DhDCtsX/OPAOInTPJA316vE0XaCuGiuA=;
 b=rQ8u6WadtgIyHjj0vkCHPYZ4J/NJOrPTvOv+z6QBnO5amlmM3KTJkdr08+U4AmwCI6Ga
 gn7ycN1YkyB2M/L4xHJAcyoTH9yrOatPdaZxq39lzKSa034Fr5wpXTCe+WTer/TWvtm8
 pP2JCjAWhWA/gvs0kvmLYwmUF11vY6D/pKK6QCDnFClf/K7kWyKYgokz5J+5SNmR0CfH
 0+8bkUMG0j+lSE4VryhOyOnkP+fW08B4xSMtfjpECF0TzfOfyzehlzp3PMBHmC9WEuC1
 gyQda8vxURC45IbpPuApR9VHEQGGiNyZjGyOY1PcAZ9wAO8KUWIvM5++fuWa8UsFFIEE Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbh6nv76p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:13:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T3BcI8153110;
        Wed, 29 Sep 2021 03:13:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by aserp3020.oracle.com with ESMTP id 3bceu4syvn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:13:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QS9eQTJN+ReLD7OX0EcVhEMUhOcp15301SDpt2OTxIhajADaXIFPY2OdzGf40RUo1+ZcApxO7LSUd8kSDHz3Qk/fNqVDe0oHL/em0087C7LRQUSQxez0K3+oJb4Scwe83z96jIpMszr/Szv/01SfiEfdddZWj8VCwMlP6HkkRHzc5k3nOWYSqr4IaeiaNVaqK4wguAaWodo3WeWNycoPBF25IzcZ1OvkKBcIzzCLo2H1whZkTrld/sHfvlDuztN4ZPz8evYO/D1La/3WEn5eE2bxPLxkiwCFUe1PlqlIHYflkQZ8aLbSE8YyWUokhrLGhKCL+DpbZPkUw/GrEvdJlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kXX61E2IKE4DhDCtsX/OPAOInTPJA316vE0XaCuGiuA=;
 b=ShqISaIaBLJ0dAPAbirV1+/Uk0F186FgXkTI1GoYHDv/jWK3tRxuiS4sfTqqH3GXP8ccc8Z8267fsG05+3S+VHT/yawrKeiTQ8sVUoo1VDWLMiC0xF3Rp+YTIYHuzewGkedHFNm9XG+hP4AzTiZzWre02wTjRY+JJa6ncq8kFzatqHAKTK5uJFooHP5lkSna4oQ0J1wfpyvWAtWZqXq/FqSCwvb0yMbc3BhBGnx82ksMiN6F3DXABIE8CbAAgyEYqOgcKLfxMVGKj6yZPhMfOUN+IlEku2oxRj3V6U+DygOgjCX5/tmxidH5OAkAWaGJTj3gyD843ThjTKap6ri5WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kXX61E2IKE4DhDCtsX/OPAOInTPJA316vE0XaCuGiuA=;
 b=QE4btJDdoUs3BoZYMvBUmQveNKAP3L3cglfvySXfImbkm2RZXnSx3oGCkk7b2ZHijM6q3vYyurFDFHtN3/fKZP10Zhi8RAIe/FpgxuLWyzdR6abzYWqFWTbVTtUDFMY5JWRnP2+uNmzHIepYjErL9k1GeJ8ASHCj2sD4jTw3eRc=
Authentication-Results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Wed, 29 Sep
 2021 03:13:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 03:13:03 +0000
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Michael Reed <mdr@sgi.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] scsi: 3w-xxxx: Fix a function name in comments
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmssf51q.fsf@ca-mkp.ca.oracle.com>
References: <20210925125324.1760-1-caihuoqing@baidu.com>
        <20210925125324.1760-2-caihuoqing@baidu.com>
Date:   Tue, 28 Sep 2021 23:13:01 -0400
In-Reply-To: <20210925125324.1760-2-caihuoqing@baidu.com> (Cai Huoqing's
        message of "Sat, 25 Sep 2021 20:53:22 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0166.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.46) by SJ0PR13CA0166.namprd13.prod.outlook.com (2603:10b6:a03:2c7::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.7 via Frontend Transport; Wed, 29 Sep 2021 03:13:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9c9ddcd-04b3-474d-74ca-08d982f70cbd
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4439458199AAD3E377863E0C8EA99@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Gp6RypEgY28ZZgjLn1JT5zuUgIcUOy5bglY6Wuq4+uCwD44NfZPVknM+nR/KO/ZxVpNFoXoyZywKkpO6UmK5vXFCSi870BgwW7eVdBkz6h493KFZ/gp1tNr+f6slw2zUwIluRPOJbGb4Trn0Ld063XtwjvEx1JjALCAF/+2r2O64FcWRsRsxzh8mgrBj/Ei3isANxsiXpQKh8aOpgk01L1q8/vvV/+Bd1NUQN+NXCwbrE7KcZB1uDVLaeCVWZAxRjk/nMs+cfHyzKTfg6CzirE8EtvXK0iBNfH5ZB+pkSNBfSBkfsm5AkeAI/TY6e5DxmUh6PFWTvSiXKpO4+P9KcR0ZFH+5JhkmNP5dvXzchWZqYVhL2Iu7pgxEfzsZC/h4F5cqu+H6A+O8mskyvyfK+L6P4+APeTifsuFmxlv6cf4ahIhpEU0MqW9x+UnNWQvAwKe9s1bSoIWQZ+yACXMW4ZEbEW25brvGywKV2NDR07PoSkakCsHr5dkAQ82ABJBGAavBMFlGUeU653yCGsDQ/ZtOz91UzvUg6yKwaPRBdvhHFrFk8G9MyzzHTpX26HI0QrnOg0wA/PjUppayxI63HRagwvjKW5E8NduYYoeAbsq2Cm6h0FAf8fzpNoO197foYPH2nE/uNBt2huB9ixmpP/EY+kj1F4zvSGpIYHR7ex/gZj1L0UWUQdZEyI9v9fG1WoS240TrA+Dp07wyB+PqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(54906003)(6916009)(26005)(8676002)(38350700002)(38100700002)(8936002)(316002)(4326008)(86362001)(55016002)(5660300002)(66556008)(558084003)(52116002)(66476007)(36916002)(956004)(186003)(508600001)(7696005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yO7uiLYjorUi/Zt0x2LtB6prhX17M4KEromLHrooGnR5uUrWlkjDCQ6qWvZk?=
 =?us-ascii?Q?5vVFBvYVLN/uIRfYCxKWaZPoKuCMcIcGfj3mhx3od3YncYiCYlsLovXfLjfn?=
 =?us-ascii?Q?RhrRKEx/22mlsPCZJtf8qW05RsEWpetk82k2oslmCfP9mc9klSYtsTKH6wvZ?=
 =?us-ascii?Q?rdeJtJDR+My1kkmVk7Tpq/ka0fOj+YHnUISoDnHy0UrZwqFrhaoVlndMZ91S?=
 =?us-ascii?Q?urnw4vkqVfRQY90u9kchS8DwNa5dzYZcZ9DE+Uc39GVmCdq/UhUrAhERRGaF?=
 =?us-ascii?Q?IKbJcShfCbw/RHdOE5OjzRInGUJuwb7RI8z8P/whLMZpRoT/wL4z8YYzufVk?=
 =?us-ascii?Q?achM+w8ZVTeRMu6ygocGvnQpOoWis6DnstuPnznjvEqsjf+CaEMqvOOwtO5v?=
 =?us-ascii?Q?KIteDzvZsYKQ72Ejb0ZDD9PBsOS38TM1MyTTNg884j0Nl1cvzEfR6Ck5UPzJ?=
 =?us-ascii?Q?ujIPYsPv+9VHqiwAjahmk362Cip9T60Ycymm0wMVJ688XztWKv//pUZoMNen?=
 =?us-ascii?Q?mKpGGrf7UewNCf1bdx5JAwsKp1X62jW9nUzEi8wfx7aqiWJYOJSYWOd/pOqB?=
 =?us-ascii?Q?jqvZ9pK+ACVUdZO/78NzztAbC3bXbbj/YyDDqq/0ly5VRw1ET8Aa+fFiGq8a?=
 =?us-ascii?Q?F1kDwbVd0f+t6Jz7h8y+9KVOh0h83W7V3D9G9EqIEsFTdIFtL6UTVDHIayyc?=
 =?us-ascii?Q?0k22sB0kBdpv4W6zOQHaIQhOy1Ca1sYxbATVBR9kGYn40FB1ctlmHLBUh1bp?=
 =?us-ascii?Q?iLNRaO2rzqVwuUADA9gWVZAB2t8tyzilUKZCQmDPmVbBsoKiwZG4VCoXO86K?=
 =?us-ascii?Q?PJWUfdODgKnIWhpH+TYPec0MXZ5UksYQdttXvOKB8s4MDwuehZco5UXYNH1M?=
 =?us-ascii?Q?oQQNHtvMOLIQ8ubA62SuZr+D5qEFtmyhnUAAspzU8M9tPRmMHXbt2WmRJ4n7?=
 =?us-ascii?Q?0YVGAG2qtBoKy03rfBnPEeS46GtPrA4eoB2vWf5sdn2V3T/hjJ6xSzzPzSxP?=
 =?us-ascii?Q?cmy/Onywc4+gu3iEx7252tzCAVQfhcCseIn+vZ8Ipjt9ELcZwQHkZwc8+W7n?=
 =?us-ascii?Q?XlzO7fRiX1qG7Mc07jAbpF5SIOESHS+jursszEwvMbrASnoF8D6PJO3Qvoop?=
 =?us-ascii?Q?5UZnJ/mQ6HICeSX/z+lSBgSocEY/fWyTR5YCf3l2ak+g1e4gw8mQtduMeBj3?=
 =?us-ascii?Q?3YVTCi4eBqibM165B8TzW2Pbi1d5Ykr7kf0zvcmkd6PSDO9NompC+22Lej4O?=
 =?us-ascii?Q?xNQ1D3A/t3fQAUfvA6kRbkBh3trbs/kE0AW4ZFLu3qZpZikUdWwjABxClvvv?=
 =?us-ascii?Q?7iSq/3VdDU1btrfr+SVb5Qk0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9c9ddcd-04b3-474d-74ca-08d982f70cbd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 03:13:03.3026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /QA/Ig3gsiB1c5Yun+i9bWh7C11bnwOIsvxVRTctQi4X/LmAf5E6Fe+mhjFbvAsDMMSjAgtrTkufJr+CUhTsbEOxqbRUxCULed8CwDmteKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=896
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290017
X-Proofpoint-ORIG-GUID: OxnwggUyGnVF5p-06C8ULRuc645Yau6I
X-Proofpoint-GUID: OxnwggUyGnVF5p-06C8ULRuc645Yau6I
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Cai,

> Use dma_map_single() instead of pci_map_single(),
> because only dma_map_single() is called here.

Same comment as the previous patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
