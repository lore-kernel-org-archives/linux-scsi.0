Return-Path: <SRS0=PYL1=IE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF48C433DB
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Mar 2021 22:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84BD36509D
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Mar 2021 22:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhCFWXs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Mar 2021 17:23:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36818 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhCFWX3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Mar 2021 17:23:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 126MNNO3098313;
        Sat, 6 Mar 2021 22:23:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=zOeXCNykzh3700M6zCFhjsbWqA0jZesW5Dk8bMb2Wic=;
 b=MiWU2Yzl5n+qKukotpKQ+vAuM2UXBv5XeTbOBxt5zUKk4VRLO+5v+5URhY0j1wZ2sE7D
 yJ7FeTZa2l5bFCQs0QRfPsDMNhjdxrTz4TafvaFoBtwK0cRUoe0JmAnrADj+volIBGXd
 qO5ygVfiAqA0tPct7sz+6WImTmoIcZ8qkUQTuP3l7P/5bd1+MOSpuiNypZ10bfTt8Nce
 Va4NcKAPVTGmT/hkcNghrLCgSm89eGRZGSeWN4HE9H8+VrfQP+93Rr1HuHDUdTBJyuvs
 TXAPVSnPQB2OZQp7LKvlCWwHRWQrOW/fPGU4Bh12fWrQnDaKaS/tz7xdGew3QpXbfxXL Fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3741pm8vuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Mar 2021 22:23:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 126MLEkn010141;
        Sat, 6 Mar 2021 22:23:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by userp3030.oracle.com with ESMTP id 373xuu74w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Mar 2021 22:23:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kh1HhcJFRa08Zr1NloO5MZV3b9gryBlr2PGdar6S28wnFdMo7WMccXS2T0PNs/Rvsn9ML5PcfXHM+B3WoRbVx3PCjdUxwB2usMv+g5r355WuZ+oPx6yHInG1+5xxFiuOuOpjLK2JQzMhV2FRZzU/c/W19qk/YJgm9rU2n+7Td5f3przFw9co3GtgcV7c/EVinbw+kkPNW5iYijLJwqSxwhcHnOYwoIsCeimpHAgXrgNQjvjMSKoBAwaItcfggTcDgv4QHZxyjs1sQwiqvcIPdBbREh3JA91USw7qw6byDDR20js4E2VHW3S1c5mc0HfzeYOUdXFrQt8ejyaA0/HjIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOeXCNykzh3700M6zCFhjsbWqA0jZesW5Dk8bMb2Wic=;
 b=BsfrjpdKubgwB9FCNRbQhLSlDhYsmNbPxlG0IREKvNQf3EIZ9lDREQdoTGJa1WUf3VyrDfG/uLCJl2vAmcEMECGbvWWb8zHnVT1mxCTkRAyWi/SDmhalo37ZuXmuUdbC2UrJTl/IDIT6igBakE38Qn0KqGXYH3fqe1zl2o5GrkRjHRhb6Phl94WtAhqgyaSYBxIQitJb4p3HhEOwbcA3uiWOmBaCA5N7j7xBarkvsFklgl0G+Q5BCLHiimMg/d+WiZAHL99dBp8mGnY2/kbsvQS5I2ndGQ54S8o/GeT+ZCWstVxpEcOuB0zToT29SV3IarJx0mopII+vWWSGRRlYTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOeXCNykzh3700M6zCFhjsbWqA0jZesW5Dk8bMb2Wic=;
 b=LdRYBVWt8hybVSl3kSAVKzdKYn9RUD7JlPqkZoJpN7ZuvWOXc95RAM+eueg43i1QRuz1Vaz1KXtKhaedny6CZ9wCxvG2r4dzi6s3QMejMADQsigiNwx79wcw1FDnJc+4UwrT61d+rwSGsCUEcaElKE/uC4tnhlhQd8UvwUp9oJQ=
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN7PR10MB2626.namprd10.prod.outlook.com (2603:10b6:406:c0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Sat, 6 Mar
 2021 22:23:20 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3868.041; Sat, 6 Mar 2021
 22:23:20 +0000
Subject: Re: [PATCH] scsi: target: tcmu: Use GFP_NOIO while handling cmds or
 holding cmdr_lock
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20210305190009.32242-1-bostroesser@gmail.com>
From:   michael.christie@oracle.com
Message-ID: <acf98823-b61b-6ffa-3ca6-2ce59921e586@oracle.com>
Date:   Sat, 6 Mar 2021 16:23:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <20210305190009.32242-1-bostroesser@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [138.3.200.49]
X-ClientProxiedBy: SA0PR11CA0160.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::15) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.100.49] (138.3.200.49) by SA0PR11CA0160.namprd11.prod.outlook.com (2603:10b6:806:1bb::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Sat, 6 Mar 2021 22:23:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eba85f1f-55a2-453a-13bc-08d8e0ee7248
X-MS-TrafficTypeDiagnostic: BN7PR10MB2626:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN7PR10MB262624C343CD36E58E2EF8D4F1959@BN7PR10MB2626.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H+pK8QNgLSPCwyhoczfJIAB89SYOe0sc26/TZoHeYxFWCybs5Yvz+fYY+XXrm4XQ+0idHLqc2jUiN8X6rDY2Xuba1arRXqGW+GXSab33RAsuQhPrvbIuUy1R/+QXYD8qYl454ZCGZz8VJ4kn3JP9Lblhk+EsSDr3XOSjkCTlbanU8DBab3ECmwfTEU5cfCQdIg8oPP9P4zeuhNX1MpDk19JsQMxgifu6ZR6Ydmgsv/i/5ksHXYn89at5dENSV9+T90zzuHuslmp4m32jk8hjwbfJQBY94bZ+ZTx0Y1RcUpg8uKSPFc45Kdv/YnXBas+uJqLJitW7UEJh12Wn2S9Z5NVFwSbX8acKJPNfv57Qp6NpFfyIuGBgIHN21mDj69N2JoRoiuIBESaV0aKDbu/a5ftSasLDxHwha+ttnZDi3SgPKOoBImi9EBjDhD+h/RyjyFmu+FGuAI785ssQ7RHpNlMSUPZAxVoMxQcxdRE4vDCWpEIq8ruE2V01GDzrkk47+wHfUglNkzMF3K6qWdMFLpuI5tJEaY1xExWbe7srhUNWAiX1RFyf26yIXb2LG50BUAlahdpx30LAHJBGMxUlVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(136003)(39860400002)(26005)(316002)(36756003)(6486002)(16526019)(31696002)(8676002)(86362001)(186003)(66476007)(53546011)(6666004)(66946007)(956004)(83380400001)(66556008)(31686004)(110136005)(4744005)(9686003)(16576012)(2906002)(2616005)(8936002)(5660300002)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VStTeGJ1V1hlZENWRmw2ZEZIR2tuRzFkVnBmbGRFWTVZNyt6RzNkNmwzTytM?=
 =?utf-8?B?UjllditCUmd3VDhiYVdQODU4WDl1d3Q4UEtJUjErb0NFeEZKelRtSm5XRHV2?=
 =?utf-8?B?YURNS3ZBZmpSdXhacGI1V3J6dHN5Q2k0WjcyYjRnbzBjTWhNZkZNUm9qTkh6?=
 =?utf-8?B?R0xEVWV3YzdkY1V5L05QdEkrM3NXcTdCcVJpcExnaEd0THp6cEtBZ1VPRTda?=
 =?utf-8?B?Mmh6Slh0djhncjhpcHhFQ3MzSmhpbnRXV2c2ZjQ3a01GY0VXeHdVTzJJZk04?=
 =?utf-8?B?bmVEVXVlTklORWJuQlRKTEh5cUoxZnlGek96c1ZjaW8rRGFzL0dsV1BEYmlC?=
 =?utf-8?B?TUVNQlkxRlBHYk5UbXZvaytpUHJCNkVNSjVQTmlmcnpRZUVKRHNqenpZYXE2?=
 =?utf-8?B?enZNRjg2WjBZQjZwaGdWdEZ5T2EyVFRrRWlkT3Rtdk1HQUFMSXQxeUlXVDk1?=
 =?utf-8?B?UzhyQjlDZ0ptUzlXV1lDTGJhYndlUGl6d0llTTdReVpBcXdXWDdmbm1ObHA3?=
 =?utf-8?B?NzloQ3pKWmJuU3R1aWZzVU1MMXpxNGg4dHlFQXhBaWh2QmdOcDI1TFJtNFpZ?=
 =?utf-8?B?c2Nwb3RjdHREY3NUNE9IdHAwQi82aHk4MEFVb2hRdytLTi91b3lGWkFKNUZm?=
 =?utf-8?B?YTViUnh6bnY4K0NmTVNka21GVFgrLzhGME54dFlMcHVEbG0vUDVWanJBdnh0?=
 =?utf-8?B?cktuRUxRclZZczArTldrbEZjeHlPam9ReGthUFFqTE1tdjJ4MmhVVE8vYlF6?=
 =?utf-8?B?cXhDVkZzVTlnN1NpTmFoeFpmRmNXbHVMamxMZGpmazB3TGFxSitoZVlZaXN2?=
 =?utf-8?B?MzhYQkRwM21abFh0ODQyeFhaTXh4aUtid3JUVE1RVHpZS05XL1VjV3EybFk2?=
 =?utf-8?B?UnFZQXVCNDlZR3VRZENqUy9sTUNSakx2VUtrRFMwcjB2b3NJTVU2UmgxcW5Y?=
 =?utf-8?B?a1pjZ1hqNFNINWhEOFJFQ1VtSmJoQXNTNWN3Y3FtcVB5SCtSRVF3UzcrRnUz?=
 =?utf-8?B?S1VLQWs0dWpVTGRkVER6d21hajJDY0E2RGc4Zk1xVDFxK0hqM3pzb1pIMVBk?=
 =?utf-8?B?WnJTR2ZodENuVkdJT1BYY1lxQVEyd2lDeXVjMWFsVS83UUhlcE5yN0Z4UUJY?=
 =?utf-8?B?WjNSK2JQenluM2tvVnZJSlAzUEhCZS9IbU1HekFWUTVwVGVkaXlJYjlsNUo2?=
 =?utf-8?B?Mk5rU2dYbXJ6MkNzRlB5ak5zZzFXMXVPWGg0cmhTdnI3VVA1UzJnQmVwVWJ5?=
 =?utf-8?B?ek9xWnEwMmtCZzdlSjhuMTJTU1hWQjB0NWorbUd5ZGtyYTdnN0p5dXRINWJQ?=
 =?utf-8?B?dkVwSnNQc01DRm1wNHBiOUVGYVJnN3haZEJwYUtsNXlpTnhJNUp0eU9iWEtS?=
 =?utf-8?B?QUdiaFZPRTYrTDd5NU5zdzd5bnorQm1WRExUcVV0TEw2K1AwZkRTSXgyUjR6?=
 =?utf-8?B?c1VieUVvVWxxNThqZm9LOUJjWUIrKzNaRkZtQzNmS2l3R2pjd2JzV095MjU2?=
 =?utf-8?B?ZWlrRUEyQXpEZUhSRE05U3FPQ0hXK0FIVmtTZUJPS04xYkNtUXhERDlBMDhN?=
 =?utf-8?B?VCtlbVlpNHh2ZldTRW1vSFhkNTl5dkIxZ1NhcWtzTzZhTloyTGFiQS95dHNR?=
 =?utf-8?B?NlpTdTFacGdySWEzUzZ2cUZiTlZndS9BQk52ODExYjVzOVVDQ2xwRGZkZzBB?=
 =?utf-8?B?dlZiZG13QVQ4VHp4c2NzVHo5VlJrSTRwOUs5Y04yb0NQQlptRE15WjN0S3VS?=
 =?utf-8?Q?h1upM9KliP6KBjbgIa7Q8DYd9PzwW2Fh5mZhSlA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eba85f1f-55a2-453a-13bc-08d8e0ee7248
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2021 22:23:20.1637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UkWErqK196FIq8GyT7QyPb5T2AKzxLMnVWnBlQj1Z6nxRk61f5EyM650a+c7B+6cbWugVzWIPVjU+DJsGcSlVNOYe/XSSzSluO3tpZ4Ifks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2626
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9915 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103060140
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9915 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103060140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/5/21 1:00 PM, Bodo Stroesser wrote:
> Especially when using tcmu with tcm_loop, memory allocations with
> GFP_KERNEL for a LUN can cause write back to the same LUN.
> 
> So we have to use GFP_NOIO when allocation is done while handling
> commands or while holding cmdr_lock.
> 
> Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>
