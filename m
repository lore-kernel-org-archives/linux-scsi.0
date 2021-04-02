Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30CAC433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFB44610F7
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhDBDzc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:55:32 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44988 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbhDBDza (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:55:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323p8YI144802;
        Fri, 2 Apr 2021 03:54:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=irvCYtYwVouF3Pj4Y5c4ohC+K+gi91LvkZJbOcEeQII=;
 b=BDbqXwLzFJhDyeqTlWcnhZul5ECgiXUczw76cKL3+ex+otkoe2gm7/xJay0MXXvbm+0q
 ZGNB9Oj4wOH4bfdx7HaUznxdBIRCTJ6kh21b1P2/ZBGYBZ/rWqneiSG/oAni+jQFcXz1
 BqGsNP/gqmyC23pQbzOo6fdLajV69Qzx+Ps2gW9LY3mYAPAcRcmQwkdr0wH8yaLaaCO3
 /jVAQjFCWm/88fg4Nc0+CdQYbu6zW5gHNfIvtJdLtJXmKgMgvuoSBMBUeUIykkdf1R8I
 30nTn1BFEpq0VGgL4rh3fvZGZW/OkdMmmmFe/23CnDOhRTLBt3DWfmMpcgw20fdR6vEa cQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37n33dumsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323njnZ111728;
        Fri, 2 Apr 2021 03:54:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by aserp3030.oracle.com with ESMTP id 37n2at2ng8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fvaDrbA7W89YlxTSTDBmjCMiS1zbsz+4DegNGT+QxA5Mrz/FQigvfFSZNW+N9LajWNMO4Wka9yZS/HjyfFns2LST9zkbU0M4eyerKTVeZ65srljwjMI+OQKoNUDFT01VIwZZ+L9nSGsndxjAZei7M79NMxPM2iNFW9jBv22Ve11rhwP8Kc8vYDK5PmkPLUXvaKXX0LrkLYtdI+1SVieUyE6Iz0BynZblZ2vL0HvqbmZsRxgGuAhJVerH4nmqipdyZEeoePZMi8CexfQ0l9kFo6SGMDSqUHfLKjAHpvWz22dkSs8FHfasVuQBgIQ9uXK1nkbdjMT+w5vB1QZqNc06Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irvCYtYwVouF3Pj4Y5c4ohC+K+gi91LvkZJbOcEeQII=;
 b=SAYUio1+07ZUJ9UoSHm1+327t23qS7lBa3Fj7bbJ9t7soJnz/Lpyzn3oApdW3Ly4to3+F2z1Hwk+lOh9tsx860ckTWUH6twAAD2ZDCMXAlkNAgVQzovpXOj1NWJ3t+BhqDNSl8p1wlNIL1BpRfs9XLjbudSwaktHOyaCfQugz234CA9RU5SPYmRv4kZqDZuYx0cH7jNfBMAfyXZsuz1mZLZwx38F9loG1Qn527rJD4HE/qS0xzPhdh09ZLQl64ewTRIZ8fNAgQv2TJ/GGTUxbHie/r95Lg9R3iYgK5SYOosEGkUFSU6Qw53xDpPMiaPXn9WNkBlxagxsgEC1olWfQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irvCYtYwVouF3Pj4Y5c4ohC+K+gi91LvkZJbOcEeQII=;
 b=H99PgnMzI2A/JgxsCMIcVypJ4Y4or2m8fq9fP7fST1awfV4c9cqpZlU6cYGRRN0fYpkaslwgq70AVh7S6N/3sfpKxVY7CvYhwfkPALhRiWeKSsXygF1bGxFFYHjyz1d7NzBNas6wpOeirqj5oSK29i6wurqncxaWWAR2KnJNcxg=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4680.namprd10.prod.outlook.com (2603:10b6:510:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 03:54:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 03:54:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Scott Teel <scott.teel@microchip.com>, jszczype@redhat.com,
        storagedev@microchip.com, Don Brace <don.brace@microchip.com>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Arnd Bergmann <arnd@kernel.org>,
        Scott Benesh <scott.benesh@microchip.com>, thenzl@redhat.com,
        linux-ia64@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] hpsa: use __packed on individual structs, not header-wide
Date:   Thu,  1 Apr 2021 23:54:48 -0400
Message-Id: <161733538518.31379.13275738935787597303.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330071958.3788214-1-slyfox@gentoo.org>
References: <yq1wntpgxxr.fsf@ca-mkp.ca.oracle.com> <20210330071958.3788214-1-slyfox@gentoo.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR20CA0001.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR20CA0001.namprd20.prod.outlook.com (2603:10b6:a03:1f4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Fri, 2 Apr 2021 03:54:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 080c6795-2191-42ee-a492-08d8f58b1245
X-MS-TrafficTypeDiagnostic: PH0PR10MB4680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4680FFA9DBD52B5134E093E28E7A9@PH0PR10MB4680.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sqPZOn1YJl5WrIXUQFLqFKbsuHpiqqyYsOe9XXe8H21dpvvU60OGpwkAHpRuF8AhnXOCB4z4aYJ6XStaNFYSVkp8Wo/htNFI9u+789VbG6MpB8Biavn4afDja3EbrvcF4obHdUQWpiLH76SgQ7NsaW7NF/MZCCqtrse3Lzz4IR/Blj3gnp0PknbZq/hTM4VWY1W0mtE0HusdyRmew/Fk/7CP39tCdnvVtWPWK1QAXPA1JOqxB5g/a8XOdBWRjKeyZx/n11vPVBoAPJ10UV78zJUT/00QeIb8lxer1BOehqkL0JwJJOH5by/hXe6ncx765d8FhDOxN5Y6ItZ9cELhe3QdZ664w3ICw1U9WG7E+9/yq2RhmVm1gBEjYI6ZqzMhNn7+bWIM9XKDhIIYBp+v+0mLYbFshcOLsOrTsnoe8H4QDHD0QZ/hg5n1kBZoSNPlldWxwA0jLcYU3vx3LpYwxmr7ctFqsM9pRyGd7IY6iKOekt2v1ThZwJaU1+cPaTEY+2oxW1yV8rRcJa/QnkMVnTTf7EodpEk9VAIC2XEQ3zXOCAdhPCIwo9EUQ/0cRxoBjN2PvxquYGBrys0jHASp9gjwzkShy7zMCPNOMvvvvMukmWU8lnSidV9A1s+elRBo9XBvRyxLDvQZPy0jmu0l7i6AeSWe8x8pxHqyr9PQLw8o/avxKre8NvWUg1e2aPoUSd/ILgc1JjmG61GgbG6dy5vMcFHyquIadKbbr3xirKtUc8vnFZ6PjxgpKV2512DY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(39860400002)(366004)(26005)(2906002)(2616005)(38100700001)(956004)(921005)(16526019)(186003)(8676002)(36756003)(66476007)(66556008)(66946007)(86362001)(52116002)(7696005)(4744005)(103116003)(7416002)(6666004)(966005)(478600001)(4326008)(5660300002)(6486002)(8936002)(316002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZFNwRklrT1JyV1IvVUxLbkoxdE1ORnRIYUVpWnBNY1YyanRTY1U5MUd3MlVF?=
 =?utf-8?B?QkNvYlNKME5CREszRUlVRGxxNERxS3puTFZjSWdvUG50SmU4M2pCR2tFTWpI?=
 =?utf-8?B?MjBsYjZGQWFVclczRTFCdnBpMllvMFExN2FYZW11TDdBVFlqRllCOXk3ZGJr?=
 =?utf-8?B?Y0lScUVkOE5hdlk5a21oNmhnL0lXd1F1QVZ1ZVFKTXJOUkFiUm5ObEg2ZS9O?=
 =?utf-8?B?KzdpU3BacU8rUjY5azEzYmd3OFZ5ek9vUlZ6SnZFVmF3SVNtOVNrV1E2RHdt?=
 =?utf-8?B?dUNSZHd2dHZ6NGRUOFozSXJDd2dCTERnWVB4NzZDRTB4V1orR2JZVEVJWnRz?=
 =?utf-8?B?YzBKMDhqZ2UxazAyUkpRRW5ZUmkyc01YK3IwZ0dnTVQ2K20wb3dCWFJ4K1RU?=
 =?utf-8?B?c0dHU2JxVk5WOTE1ODNpSVpaSEpKUTQ5bjA3Y29FWDBJcUtVUWlVM2poV1dI?=
 =?utf-8?B?ZytMcDhmZmRNTDF4N1dRTGxldzdXcTJZTmtuY1FYL1lTZFpEQ1BicThuOFlz?=
 =?utf-8?B?TDl6bmd2UFVRbjcyemVEVVgvbW90dlI5dDFoU1dtVjkyeGJIaGFLUEM3S3hu?=
 =?utf-8?B?SkNVeUxHb0ttTlEzZjVjQTZYVUlYUTI4dlV2SDV4WExGZEFzTC8vSjFFNmVJ?=
 =?utf-8?B?MFBhNFBTckh2L21rNkFnMnhEWUhjOXhIZFpZYTZwYnh5cmw4QklONlljK2s4?=
 =?utf-8?B?M2g4ZmpaSWgyMDNKclU5ZWhNaDVmTjkya3NaSUFSMTdrZUpRekpxeTRzRVE5?=
 =?utf-8?B?ZXhNNWZJMVBTSzdkNDNHdEJReTBNVjhsRnN4azJHdGFVUVhhUjRqTUNBNHpI?=
 =?utf-8?B?S0hqVlkzejdDMkJNQ3JOVnl2RHUvTXBlRUFHZkU4OUI3Tm93ZVJCbXlBS3kw?=
 =?utf-8?B?bFlIWDFKMHVhclRwNWRGWHg1b1VPVWZDMFI1bFNqNWJsNFpvQmxlcWVhVzRi?=
 =?utf-8?B?UlErZm95L0lXcmVLM1l5UTN4dlNPYWFYM1c5OHlQcG0rMzZKMDhvVXRpTThM?=
 =?utf-8?B?RVNhSElZTERwOUU3engvTm5hVkQ2aGk5T1hWT1RkeEYvQmNtSU45SjBoWnp4?=
 =?utf-8?B?TDdCTmhwZkNUUGFKVzFid2NRa3BtWjVLbERPTElsdVpXSi9JQ2EvNmVTS3kz?=
 =?utf-8?B?ZjJFakxkOU9zeVBwKzRjdkVuRzJMYmdjMW9YT3E4UG5BeUNOQ1M0ZjFtc3k3?=
 =?utf-8?B?c0ZOMkEzeGo5cGpvVU4vRDR4RC9vWmhUSUlPOSt6ck13UHliM0Ewcm5hVVkx?=
 =?utf-8?B?RHJqZEM2Ri9hYkN2NCtETW5RMU80OEk2ZHlSYW0rMlVRd29SRzRGWUZ1N3Vq?=
 =?utf-8?B?bURybkVvYXZOWXBVcHhkOThidFZmdzNTWVh0dWppSXRucXlBQW9kZ2tEMW9P?=
 =?utf-8?B?WkxnRHRNbU4vdUlCN2tSZTNpNjBCK2lkbXJzN3pENENicmsrNmxLaEcyejBj?=
 =?utf-8?B?eVlIY0VUQ1hwVW9kdjRWb3FBMkYwb2VHd2NPUWJQSkdUQVpDbzdwRmRtWTBz?=
 =?utf-8?B?Y1BGSDc2d3VrZVErUjk0aXR5RE1KOUpYbHJGNXhIZFpmdnZzOFFLMnhXRUdS?=
 =?utf-8?B?ZDZNLzM4Vjh0S2IrWlAwMSs1aFp5Nkx4NjAvTUdxOEZBNkpXYjdHMVhDb0tB?=
 =?utf-8?B?bUVvVmRyUW1QaVI0SnQ0MjhmU0V4bitSUCs1NVg0dm16WXhWbnhVZlRlU0VK?=
 =?utf-8?B?aFhFQkdDMk1ZNHlUK29waVJJZHk0MUZaSWw2RGg0Q3NCNkNiOGtRcXBlSmsx?=
 =?utf-8?Q?V2vUwh51y193AnkkWO3Ies1PnZ2wMFpOWc2x/QA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 080c6795-2191-42ee-a492-08d8f58b1245
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 03:54:53.0291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hdFvFyszydFqxr9bi+Yj7hI4FOH9LEzoq9LR14gr3XGsUijxNSlcUktH6347LPLkCKxDvxLKpHpbyG/nyzqiMCs6kiFj3jTA454D/E3Pjnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4680
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=903 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104020026
X-Proofpoint-GUID: wHPQTr31_v_RgD0NZXSoQqFGXcXDRZyW
X-Proofpoint-ORIG-GUID: wHPQTr31_v_RgD0NZXSoQqFGXcXDRZyW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 30 Mar 2021 08:19:56 +0100, Sergei Trofimovich wrote:

> Some of the structs contain `atomic_t` values and are not intended to be
> sent to IO controller as is.
> 
> The change adds __packed to every struct and union in the file.
> Follow-up commits will fix `atomic_t` problems.
> 
> The commit is a no-op at least on ia64:
>     $ diff -u <(objdump -d -r old.o) <(objdump -d -r new.o)

Applied to 5.12/scsi-fixes, thanks!

[1/3] hpsa: use __packed on individual structs, not header-wide
      https://git.kernel.org/mkp/scsi/c/5482a9a1a8fd
[2/3] hpsa: fix boot on ia64 (atomic_t alignment)
      https://git.kernel.org/mkp/scsi/c/02ec144292bc
[3/3] hpsa: add an assert to prevent from __packed reintroduction
      https://git.kernel.org/mkp/scsi/c/e01a00ff62ad

-- 
Martin K. Petersen	Oracle Linux Engineering
