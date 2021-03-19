Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB72C43381
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B573E64F30
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbhCSDrw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:47:52 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47212 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbhCSDrT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:47:19 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3WKGN172547;
        Fri, 19 Mar 2021 03:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=HPNoqbNfBLM4iH9zix04cMz/XzVrDaLTmzKL8NJc7to=;
 b=i9sqPeI+YWNV2XvHwRv2BtMexV5v6CuAwzBoji6aJjiarlPNCvippxdHSx/+4guzflk8
 isTcaZbG+ORFG/aM/aBhWTEjmyPWyrM0i1wVHgckrpOGvhXe+SWa/mEE/Ju+2BFmL+BV
 c/PLq1VraYq4bC3Xea9qvO4DLKVRYoCpozdsNwtjJCSCVDWsbmwWrDTBAd60clyO8nLZ
 Trg4e8RRXzjg4cDLMv1JWryI0+FmnNy2CKKJ7Fad8jo/rCHi8ThGnflx8MNLxzFm0gLK
 /Dr7TyWG5jyYIIac6dRSYzQTzcL0EX5xU1FHVL+xeK2k7DpmVZIv60FPzQUyW3vQtc4G Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 378jwbskek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3U8ck175034;
        Fri, 19 Mar 2021 03:47:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3020.oracle.com with ESMTP id 37cf2v0ds7-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThZ6gaquC4X4BQeB4M7f7s5XrJGgAetAxpEJ2xl7o4VlkID6+KDXSVCxn679ddbbLBQ/EKkoVZjfFr6O8B+gn95u5iyHF0l/mfBKPlWmg9bHAEw5jtqZEcn2i7L9FIXL6o2MFPXpyLym1gsj4fOm5PHPe/dgVav58Ki8xaNSoiatAlesuGNNJJqtNXZSR6/9n3zu0+i2BPCq1ImhMrSpP/2e7gNpS7lY+oDY3GKdBmSawiHlNZfd8k9V1hzZVU8c6LrzSJuiScWbWxyBxEijcA4FX9gARgl3JbjG8+mVgfT30sntBghjJEYMdxoM2+9j0Y0Dw33LYa1b3GMYxJuUUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPNoqbNfBLM4iH9zix04cMz/XzVrDaLTmzKL8NJc7to=;
 b=fcV1FC5310tdjTlIrYwKqIRTCRl8oVwO4sOJShAPtmqHymhB8W+lXs7jTZoPljseWRg/TKenTJ97nDXa/ncF8ZDLC5XchyNrYNBbChws5sfgOGOFYlya2KvzqfKuyzsoyr2ZrDNQqpkiaVFsEI1CkX4JgqceLoNAV6T2Vrjm9Du/TkpOimBUTC+PLLAfgiQ3aihTfaeDjZSQcEbv0wsV6t0A7B6fBK7Z+oP8o9okPtXpeK2PtYU1gHr1A7yf743Hx90E83RvfwS8MUdv4jOuR4blwTTBjD1D4EVsbZkx+M8Vsy/oWb+IiYJeD+HJErV2JVmqLKxT1Qn6KXbGDV/ssA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPNoqbNfBLM4iH9zix04cMz/XzVrDaLTmzKL8NJc7to=;
 b=xD5rEiVVvAbOjFbT6gXoE3UZh/ge9+OJQDwaYg25nxJYs5DIv6wvkY1MZIld5OT4M3ttpSTvt5oSmGx6SAC5tQCJEi5SUQ3A7BNTGialnLSXvlbnngahnFD5LOYgDkQTr5sb8Tvjt0CBlzKpZIgCVzxF2zPWTRT9V5cMYtsb8tc=
Authentication-Results: 163.com; dkim=none (message not signed)
 header.d=none;163.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:47:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:47:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     qiumibaozi_1@163.com, James.Bottomley@HansenPartnership.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ganjisheng <ganjisheng@yulong.com>
Subject: Re: [PATCH] Fix spelling typo of conditions
Date:   Thu, 18 Mar 2021 23:46:40 -0400
Message-Id: <161612513555.25210.5857719274776400442.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316025141.824-1-qiumibaozi_1@163.com>
References: <20210316025141.824-1-qiumibaozi_1@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0182.namprd05.prod.outlook.com
 (2603:10b6:a03:330::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 03:47:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb21f3da-79da-4f1f-a0b9-08d8ea89ab77
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4470335D28A0EDE1F0889E9F8E689@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AspazCoWoZWwy1jI5fkShrvW0Gi8/6yHOd4EIL7j57RMWn//vkCG8q8O7UbwXdpx8E6lo/zHH1Q7WU481pQWMVdZEX+ivuah67jJBob/z7jGtE5vp+A3jAb+csu/SG1XO1ddTyLu7WohEIDcXWYmqNC71rOEnKEvKBr0QY6z2ahda7crnecB2D2o/3YYbHMc87h3Y/PufNQB2BYHKM+OgfCb29nRZSBJ1A4UcPsXru1CHtsl/oUfvzSOyizSr8aK7/dYU7COi21Q2lDC9HLU4fRx+cqFKQ/Fhc9XdpBJWwZSe4k5MUoBsOqHtxGW2KerSrxoaRF85hWh7ReUTP2U93GTivQ9UliLhqi4/d0+ob3e64jzbE1ToWx9yzEfeszK7fgNoKXxZnBDP1qhVyPTOPGy5gMMdvMI7lTCbqkLX7bF49CBxnHceQaD9VFk/Rlk0R9SxfmJoN31NqsUOmQlgDqNJGJYMZ9O4HXYZF5+o7jTk1hkJthc19h8tDV6T/hvaAEzlIcSZ79VXNODSvw2dJI0F4BJCFwB0yDUY/sRUpdI1/qBzmumGn0XEUwxovXTaw9r7l6+17zwotO4qozlEQYB54CYsPGXUury+FBOYiNg1dVAzLAB88O+366y5H1Wr+SnOw5Uq+2kW7A0GANaIYwCaSNaneErUvh0rLNQFkWAPl5b+qOzl6U/n6ei156Cj8gjcU8DX+ZO3uR9Cymxv8LlH/XRtH8EDi3u6Jr/Ifk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(376002)(136003)(38100700001)(2906002)(4326008)(956004)(6486002)(5660300002)(8676002)(16526019)(66556008)(186003)(54906003)(6666004)(316002)(8936002)(103116003)(86362001)(966005)(2616005)(26005)(66476007)(66946007)(558084003)(36756003)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bUxVb0t5clZqRTgxejQ5ZENsSmNBZFhiVWdPWVJOaVN6M1ZseHpLZElDSksr?=
 =?utf-8?B?bkN5OWEvVUFPUS8xblRySWJKL2dJa2xFbnRwb2ovQnJMaFhXbURqeEFxUk85?=
 =?utf-8?B?OWZYNmlhNy9QM2NGVGhBaUN5TmpmdlZIcEFHekNFVTV0Qy9Kd2tZcFgzaU9o?=
 =?utf-8?B?SmEzQ3JUTHpNU1NhajRtZVg3WFR4cEFyeVRVOFB1dTVLQWVFQVdWTlVrbEMv?=
 =?utf-8?B?eU9INDZpM2xLdkNycmxqd011d1d6RzJSNjh6aGYzRFlMZEJpeXVDaGhEcndr?=
 =?utf-8?B?S2kxRnp2ZEtHR3FkNHRVK3lYTS9LRzhrWG9tK1FzdXZoY09aSHE2SUhndDh6?=
 =?utf-8?B?Q3l2Q1luOE1ZemFIRnI1Qkw3djZaMWZ5ajg0bExXVXg2VDZIM1luaDREM2pt?=
 =?utf-8?B?d2xCVHMzdGJHaUlzY0lDQjY4WkpqeHF4YkFNOGRNeUhManJYOUdmQVUzNmdM?=
 =?utf-8?B?cHFMdUhsMFJWUThQV3JScVYrR1pURlJDQkpZYlBCYnN3dFlVQ3FWbGVjTm1n?=
 =?utf-8?B?cVA0dUFqa25kZExRRTNheEFlWXoza3pzL2FlSjhlMlRSaTYxbGtZOGE3ZGhm?=
 =?utf-8?B?bGZ4OGVtblJVZkpDV0lFVWxEeVRIODB0czl6cTJSbE5YUFVZV2dLeG15MUdZ?=
 =?utf-8?B?eFVSWWRLM0ZUNmtGdFg1QUFMZ0pCMFdnNTArblFxWURnL2Rka3B2TjBsUW9x?=
 =?utf-8?B?TG1oRWxhQ0Q5ejczemlna1JUSnUzMWlnNFd5UXhrajg2aWI2U1pxTmEwclJV?=
 =?utf-8?B?WG82QllxT3kxQ0phOGFkODVxbUdTVVdpSVRlVVYwZXpvZG9xZi9ubFg4Z3BT?=
 =?utf-8?B?OTNDbnNaSWNETVNXMEFKS1BmTjF5a0FKbmRtUnljUng3NituUjRGRUxweVJJ?=
 =?utf-8?B?NVgvK1NsWlVjcmhISzFWbHVnT0tZUnVubHJBLzBJSVQvb0ozdHcrLzg0VE0z?=
 =?utf-8?B?c2pHUzErUDY0dWV0WnVyMXFDZHFsandSN1BVTjM2czNvYmYycXdTeitjazRo?=
 =?utf-8?B?OTU3R0U1WUx5R0ZPVm1FOURFa3B2ekVLMkFrM1I3bHVEbE5qZWdCSmtwQmQr?=
 =?utf-8?B?OCtqTG5FR0VEdzZUQXRKcmlvaGU3TEN6ZlQ5cHVzUm1MMndyblRvNXBHUkhN?=
 =?utf-8?B?RFFvR1ovM3dKT0doNXJCRUJNRHd2NkdUYjhRaC9Tb3dDZkwyODFFd3I3UE1u?=
 =?utf-8?B?djZJZ3l3RU5FWStySXJLZW5ndFdsMmxsZExxSmNwNE5BdUViQTNzaWdZRVpC?=
 =?utf-8?B?ZC9wLzl4aEdaWWxCYXpWdlpPTmVTLzJoT3ZvK2w0a2o5bHdPWXpxUXFWcHNu?=
 =?utf-8?B?S2xiV1hrRHRjUituNUF5Wi9OcVliRDJQTStUck1BSmtmQzNXNVJGWGNYMmgz?=
 =?utf-8?B?VXQzZkdHbHhzaW9yWUY2bUZ0SkkzMkhqSFU1RUxlaTJad2ZybHk4WkFsa3dG?=
 =?utf-8?B?bHFJYTR6ZFdnQkVqMjBZUmw5OERLRmhMRVZFK200S2pGMlNCT0t1SGZRUUVO?=
 =?utf-8?B?b05QcDZ2ZjdoekR3RGs2R0JvUEZBNEhScGp1eWNKYW05TTJ0Mk1lWDVuaXY5?=
 =?utf-8?B?SWZXNlNrYlJBN2VaV1AwTjFXbmRJWXE3YktlUEFnRW9iZDhNYTJEZ0NJd3Vy?=
 =?utf-8?B?Nk9SMnI3NVdrK0lDSTVmU20zUXQydXFrNS9FM2hzR1duMnRnT3cyQjZMUFI4?=
 =?utf-8?B?eHg5dGxKdlAvcFlVOFZxS3pwcTA1RmloVjBZeFEwdmc0M2tRaytTMU9JR3dF?=
 =?utf-8?Q?TXdUOf0nhsYAutELTIZZ4eKVVKSVmEDD+nrS6Aa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb21f3da-79da-4f1f-a0b9-08d8ea89ab77
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:47:08.2810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jc/R6hrjU7oCH9D/9wJUNYVDaFfI5hN5hKiZK2AJbpguwQW3N6hupSmHkAOibrXE+gK6si67SFd8aqqiTnMiIw4t3HY0/DG2zgGyHc/GxJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 16 Mar 2021 10:51:41 +0800, qiumibaozi_1@163.com wrote:

> 


Applied to 5.13/scsi-queue, thanks!

[1/1] Fix spelling typo of conditions
      https://git.kernel.org/mkp/scsi/c/ac5669bf79d9

-- 
Martin K. Petersen	Oracle Linux Engineering
