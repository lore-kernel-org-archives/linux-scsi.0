Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3E2C433E9
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BDF423B55
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbhAWEXP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 23:23:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41524 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbhAWEXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 23:23:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4Dhio162013;
        Sat, 23 Jan 2021 04:22:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=o7Wk72NvxzWFawP0JQYeHm2PLf/4Ebbsj4mP2HrhYUY=;
 b=LlVoNulTlidYaAslLkDJzW+b1YU9yTggWpooqcPLuzyHdQGnULNq+3y2fzkKJY0cnTNY
 pZdR5fj3OlFz1ql85sCNu5RinaKbszSAKALh4IriuQzfy1y7k/88KheDI3TSv61KwvQI
 ilqp44ueQOqvieavkbtlvNwXkM35Zrbn5OivYLGkz5eFLA5FyDe3mdvTayO48t1JkgVJ
 7i/YT9g9wrwQnqgDgPYdEwtfZ3jZ/uAGdynkMe/M+CcjfMCEcIxg32QUxvD9/DEQ8INu
 xnR61dFuOFxY3kxaSImkpkbb6DAVLP8ZNUPgbxATFSf5n66NxO2e6vX7ZInZB8Ipu5UO Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 368b7qg4vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:22:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4KngS078352;
        Sat, 23 Jan 2021 04:22:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3030.oracle.com with ESMTP id 3689u8v0nc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:22:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+qaAQ7f7ZesLIYz3tAAFQmYoonUK85ruhoA0sajGztGSe227M3/W8Dly0qj5Uqq4/y8w5ZC/Mm2NbwrSd2XxSyqEOpeUjFL2SZ19F4SwnwUDv1ziJwjWfSiImcKR6VDqq349ptxJmlX75KTwZ++usAOHP4vu4Slz7WstkSIPuhiCz86kTU1dg+IYRjHJlWA2IrJU8l5ETSDn2XhXDZ340lWFJ5IUVymM9MqaH1+aCpf5P4eXz8d6FsDq5tS57o1C/pJ+reNcf9lFIL5mE9cfxKoQr8RTXTmSnk5uSf+CHsbsbhzgIvRQkKMaw+4P5k70ibk2puqB1PWNESPHk0Zgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7Wk72NvxzWFawP0JQYeHm2PLf/4Ebbsj4mP2HrhYUY=;
 b=X+rnnIKLju4m9CpAoQ7O7HcNO4Q2GClUNdaJ9CgqefE9mZ+uHxBOWKzhD/uodALkeUcDX1oePGBlsz6qDmxkvJKLIOwDhJizc9W4VuwS/vmnBGL5+W91LYlMajG9uGooaCzFCgvfsUiwN6zvk6Xl27PhbNtT6nWI4IK8w7wjcSS1cvtlGcJYiDIPismWtVz//ZfPi6zHZzfUMdWPaJ/fwh3hY1ZVCJkdl9Xf5WRiklC5uR5p+sa5MMCfOwtAqbJlhCfZIaos/2BEetD4OimOHO7fh2mVOfY3UUA16h0bdYKCypOqfP4AfCN8OVHMxsi0spFDlVxwrKEp2OROsR1FWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7Wk72NvxzWFawP0JQYeHm2PLf/4Ebbsj4mP2HrhYUY=;
 b=ScaSRnbxxWKE/kzf2Lpd1bKnxd4+FeghaKmajygx5oEr/ftXoxACbUIkU2POY6moPJh+xrMW0u3gA0Y66ia1PY/kzUjtxXK2FKfJGeH/qoAt08/qOWOeaQF75bx7/PA806aYchaloczeHBddlICX6OBUnFfYedZBq+9jE2RtDHg=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 04:22:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 04:22:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Colin King <colin.king@canonical.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][next] scsi: pm80xx: clean up indentation of a code block
Date:   Fri, 22 Jan 2021 23:22:06 -0500
Message-Id: <161136635065.28733.14242971487719093075.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210115095824.9170-1-colin.king@canonical.com>
References: <20210115095824.9170-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Sat, 23 Jan 2021 04:22:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc0a0d9a-da7a-4e80-4ff9-08d8bf567a93
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44396044D0771906FEF893F38EBF9@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:586;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3L35u+cek29OiqE46wq4WUwcI3FcUFeFBWv0qb15q3+ORul7Cn6Zb6XhTBuRIGmymlVXpKDZQA2hL14ZEcuvedrY++p87Hx3/WhixikgPBMXC5nYIjE0O14A1qGjVVWL0gM4H+yebRYzJQ3rPQqaCBDmYtH5GX0faCDiAeNhBzJ4BQ8sEJhEHbPdY4ghC4RQXYWZ31oy7rDFu04zkazBE3bztS+/QG4NOLVwmVILvTHFegbL2+2LOXi1UptWvnNc2HoWMPMZnrTrsiQ/pkWRN8HZXuLqSBSZ8LblJ1nXGgDUQb8O8U72JDgwIQVbIkoezCx2S22XMeoiUBa/Tiy2BYmx9CAXTlTzPMNC0GYkmFe6LalHie2JRJncSEbG74VuDi1EYnCY2fqm0e2zui2lnb7jJiNFEQsLalFDUAYzVEWYy7OgSPbUaBmR6XB+z4mew9mFFg1h0JHA5RrULwahjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(376002)(346002)(52116002)(6486002)(110136005)(7696005)(2616005)(186003)(316002)(4326008)(5660300002)(8676002)(478600001)(956004)(16526019)(4744005)(86362001)(103116003)(966005)(83380400001)(66946007)(2906002)(66556008)(26005)(8936002)(66476007)(36756003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZGNHV3BpSFFRM1o3THpWYUpHWVdmYVh3TmRTeFRFZEg2dWFna1BvUkxraTd0?=
 =?utf-8?B?dTdlYjhCSyszT0dLd1lHMklBSnFFMWFEWThDQUhBbFZYMWFtbzR0cVdqK200?=
 =?utf-8?B?d2xVWnFPZm5JQnJXVjZJYXlWWVErbzJCMC9rRHRzQ1V6cmNQZTJtczZTamNv?=
 =?utf-8?B?cDhJamtkUDZ0a05aVEFIOUQzUlBSalJ3VWxzZjBXc0NtSzFQNDF3d1EyMUNs?=
 =?utf-8?B?WUtPSktVUFJGMjZFUUFnZkRHMmtnUUxYRGZ6Q0hVK2RudkZZWTFXTEVZV1VK?=
 =?utf-8?B?NUVlTGtTbmI4VWRtdmRkLzN1N01zcXliSDhKcmFIU0RRem1STDB0MFRkMGl1?=
 =?utf-8?B?VHQ3R0c4Z1BiMDNPaVBRanVrQXo3Sm5KUnF6MnZGRFJEQUdGNElRSVJPNGNq?=
 =?utf-8?B?ZGZnV3NBSUZ6aktFYkhPbEJ6cFZ2OU9xa0t6cmNuRkxSa3V4TjBRdEpWWEV1?=
 =?utf-8?B?bVB6TEtsUThHbTdqbGlLR2NuNVZ5SXB4UWNjNGF1TGg2dmZzYzAxcTVIN1dG?=
 =?utf-8?B?T3JOSmp3U3pPZHh1WlNmVHFCOGxUSE5WcGljUjFnQnk1SjVkOFJybTdUQmJH?=
 =?utf-8?B?NGFFbnhjT3lZVzhXaFRhYXJod2RRS2RFTXRObWFXam9RalZxaEJ5eC81cmVK?=
 =?utf-8?B?NTQzTDNUNmpBSTlrWHZyclJkaHVrWWIranBEUlhtaE1md3pRU2JyM0IrcHhV?=
 =?utf-8?B?UmtqWURlclJMcjJ1VHI2RXFRU09JZ3l1STc2TzZtdEw3ZzBleFp5T3JHQkpS?=
 =?utf-8?B?UUdCd3RLRW9wai9mb3dFdnlWbEx0WmUyWUpwUy90MldzK3VUblF5a3dGL3o2?=
 =?utf-8?B?Sk5DTnJHc2hsNWZyUjEwOVBiVDMvQVk4RG9MY0VQbzVWRmxKWG9IdWpjWjhQ?=
 =?utf-8?B?aGdyeExmZ0c2VUZGRWp6MWc4L3RZZUloNEZqUWMwcG1DejIwcml0N2VDMldI?=
 =?utf-8?B?UXExWVlBNmZxZEkvYUoyRnFYZFY0V3lJcFhlcnFzWEVJazVnVVZWeDVJaXNv?=
 =?utf-8?B?ODJlMUhzQzRCNEJTS25SV0VTZHNOZ2p4Zys4OExkMkRaYzljYkN0NXJCbFpz?=
 =?utf-8?B?VmoxdmN4RDhLaE1EbmgvaTdUb0NHa3dxd1A5M1BzdWo1VEVieU1odXk2M2Za?=
 =?utf-8?B?OWZzUW5Mdzd2cGJXZjNHVTFBd3FkaEN6OUZXMlV1ZXVoeE9sV2lDZVNRNC9P?=
 =?utf-8?B?WDdiZklrYmtFSHAxNjloV2VSVVV0MHMwYTZTZFFOT3RKR2hjL2FFZEtISWxC?=
 =?utf-8?B?S2Uvci9rN2NyM0NObmk5TVBSNGsrRUxURGxQY2EwR3dpOFM2TzJVYlV2SWVt?=
 =?utf-8?B?RmNSVEpOaDdqeXZUUHgvc0s3YzlKNDJWREVrSUxpVERnbjVuZUlZd1ZMblpD?=
 =?utf-8?B?K3J0MnpvZ1VGU0pNY3lJRE9RWnZGbUJyVHVmdGdvNW9MYzl6cXRBYnpjZUwx?=
 =?utf-8?Q?Yx+btubB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc0a0d9a-da7a-4e80-4ff9-08d8bf567a93
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 04:22:21.9911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6GvyD+hh2/LQJGpUsmIOFC2UDyYmYVryIFW+ISyFAzq1SHhaojNvXqszrPojaYDfKqY8zstYPNIASZINWbdiv82ItlYds4IQOCjDSh02I7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 15 Jan 2021 09:58:24 +0000, Colin King wrote:

> A block of code is indented one level too deeply, clean this
> up.

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: pm80xx: clean up indentation of a code block
      https://git.kernel.org/mkp/scsi/c/7b382122d276

-- 
Martin K. Petersen	Oracle Linux Engineering
