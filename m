Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B95C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7584613BB
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238374AbhDPCwY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53180 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238255AbhDPCwQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2p4aC165380;
        Fri, 16 Apr 2021 02:51:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=HhbXkJWxfdvqIhbC0rcI7ms9zTs5pxlAebQoKaRYAo4=;
 b=ka3nVf6eAh6p4MQyaKQP3cXDeS8XKiXXjV5wLJ2ulsViOwcrNRqTRbeJcJ6y+FY/1FM4
 zkFKVE3CBEZed56rtksenmLPODzDAgAv/2A+fNFb8wa4Cq+Pin0CoLuRsoZNITae34d1
 R7eToiLgj3zvprfPCqxgVnBmm1SPlBGq8dvWXKfJe+tDZ6oFaomdkP/DPT279PqrS2nE
 ovSJToO/3tipMIDPdzpn0VVI6RQe7kRKDQ6/9ZRwecwZH18snb+xaqC5dzRETrbpyJUD
 LZrbrWLmAeRKGGtjNLiVKTt1ZYYVQgpesrTwldH5Mj1X4sxwiHSbUCizRTlSh4Rw71dV Tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37u3erqr1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2oWJP160451;
        Fri, 16 Apr 2021 02:51:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 37uny1xe80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0/+9J7PJ6Tp5BxAU6NeIj8ggjdcmkRJ0WGbfCsNP1SDlke9AccLedHy5qE4dZZ83z9e5oDMCatO4xJ+4Q7umfwxmfTJT0qgomnwNfOcvbQ/mDi4T2LWVNxTGA3M7NoRV75mvSCeX26dN3tOJNNj8IQtnHnkCzZm+8FCR1P24VUHbRYoYDDI8NzfLV5uGd+lbDqwKRTTzq9Kn/jh+sxKCAaEzBoDirgK08OvE7fJplSOR+6c1ai6G6l1f7QyWflayj1tf/2DqAoh/6ybjRP65Ew3ciC4NGJbH43zgUIapUhlsQchSLJckqlL2v77Kox3FpzsC0WRPHXVdzWM19a4UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhbXkJWxfdvqIhbC0rcI7ms9zTs5pxlAebQoKaRYAo4=;
 b=JkYVmxLl8pBTsXC+dLJzO2zOMDMO1H5N25ApTZs3zO4DWuc4YblBkz1G/HZqHwEa3DWDag9ACWNnNzdFs1Fx5WXHflUCweAZI4IYlZKEXJG6gK0GzH+kZysIs7xrQDadZXHDOIh7NrawcO9N5pq2MGdT5m0boOweu0ptjyUBtMGL6yy4UPKXuXUmu+KJQd6Swi12nZVSxjcuW7VDIUt6FmWFHr/AAdZn14GuHQesGbatbC+XwJ+6ScgtuTX/rukUGx+hGHlk7Jb6/aUfAgLkrRorrKsu0DxXAXnFUXvWLL+DAJ5s4wNzg2j7UEAlAYiQ3gShuJd8OiWI0mhr8bd3gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhbXkJWxfdvqIhbC0rcI7ms9zTs5pxlAebQoKaRYAo4=;
 b=uOPxE7mJC/LOx8j1lKrK7cYjO+Y1ymhfJhAhy52v3Uh1+lbDGgP8Q36uDip0fDGogJgvGzvAN2ZIKxvRa2foRpX+DMaXX2QimprDYN0hthK/gRG6H/By/S8d7cmSkZicZyIGSDvmK7ffQBU+9pYywXJy503PQQZuEooraeBf0/s=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     John Garry <john.garry@huawei.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hisi_sas: fix IRQ checks
Date:   Thu, 15 Apr 2021 22:51:17 -0400
Message-Id: <161853823945.16006.7492738835348046567.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <810f26d3-908b-1d6b-dc5c-40019726baca@omprussia.ru>
References: <810f26d3-908b-1d6b-dc5c-40019726baca@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 245903d8-1033-45fd-6e2a-08d900828edb
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB546617865F59D8B754D93C5B8E4C9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CFhp16LUL8hEIEEpNNcQwII9mcmRa7sdhz06h+RX3vZVHiqLF14RcT7I8cduUxcExGirvxzF7vrKJaXLbs5nFAZIbf6BE3gVOE4OLFvw4uAjwjqf7QuEQBKcQPyjLY8BUjay+f9C34M5h6K6Z3G0SEVhc4cYacayCZaH7sz6ToqxRry05yoRqyeQiemfMKGXQieakq2cmRdSgHtkTH3SWFX4AVwJSenWBZ00vJQh189btjiFHWuywiQi+H/Krpqq9t8vOebsQ/NdHfLZChXHkm4K3+ZaG6jRK7HggivbDjXRP+KZCdoBRWpk2JsLSlTQmAG2R0cr5NUbERJ1T/Gz/Y1GUNfTKwK58r54djh7sxSbTKJRj648NekUSeWh0yMeB2Rg9P/wBxmNz/nxKyhivdrgB5+gG4fjuZnmprpoMtW6YNp+18nM/O+oRUqCgERyVioYR3K8WN8p8pVGf8ip1hrGTUCW2IT0Jp2D2tkMQaJhEhJ7lCdky/mWNc199r7hpHRxp5wRuQgT7M9WiHOO4mWPCn+ejqD3twVPoDXje6i9qbjBD2jv/5CgdYs5EOsQM2vl1DcOrEBZnBefLkZckUNPNeIAbVhVgKgerLJW9c46kxpzq/8UMlyH6BXsAT1x3KKDpQe9JTVnzwalq3hLSILJE4graYL5wJ58S7ja05LUeG6nq5LZWEb6rPf3OORWUnhzfu0LcVPFyL5iwBteU3WXZhjItKl0DP8Q0WvLGNI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(346002)(136003)(7696005)(2906002)(36756003)(956004)(4326008)(6486002)(6666004)(5660300002)(2616005)(103116003)(52116002)(966005)(508600001)(107886003)(316002)(83380400001)(66476007)(186003)(110136005)(16526019)(66946007)(4744005)(66556008)(8936002)(38100700002)(8676002)(86362001)(26005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eUU3Tm5FVFFIdFU4akNndTFXVzlsSEFHcFpJSEJlUndJb0dxdm9RY1EwaEUr?=
 =?utf-8?B?alpIRDBaUjF0bEhQTDJKNldJMzNGSlBQdkhHVGUybnVVWTEraWhIaHZaL2Z6?=
 =?utf-8?B?MDZOTGdwYkRWM283SklPTzVGNktsaDdDTjN2RGRhV3FWampPSVRLbkx6MDhx?=
 =?utf-8?B?WllHWEFSekNtUi9vaUF0MitTa0cyZDc5N0lZS2F5bGZNUSt2ZHVIMUw3eXE1?=
 =?utf-8?B?NW1LWklpTDVWbXJoQmZxWTBYSVU5cTFENVRvQW5zQTZYOXFwWEJBSGswRllI?=
 =?utf-8?B?M1NjYnBvNWh5UVZRWGplRklTU2l3cHBqc1M2bHlGR1hBTVA0ZnBuVEFFSlht?=
 =?utf-8?B?U01jVTRiTlFUdjNXR1lYUmg4ZDh3SEFCcFkxa2NzZ1ZNU2d1ZHpVVnBzaEUz?=
 =?utf-8?B?ejNIczRNNTRnMm5vQVFNajN4aEVEYjh0UTlReEtmNjZDZEVhTWpURGVyUHJD?=
 =?utf-8?B?MjdhZExBeGNsVEFXNU5HRnNRSmtscDNRSUs2NFdCTndzaUkyV1F1bzIyTnd6?=
 =?utf-8?B?cHBXQXluY0MyaGdubEtzSnp0N0I0QTNqTy9SeXRxZEtUSkVwQUhrallGMGJi?=
 =?utf-8?B?TFg5QXlqNWNSMksrVFRHdEdNblFLTEdYMTJyTzVIRy9scXJWc2JEMmF0by95?=
 =?utf-8?B?b0pac0d2bzVtWkFoUTNBY3g0ajArVjU0bWFwSjR6MmtKRDV2aStCRUt4MGVF?=
 =?utf-8?B?b1hUeEJvVzFLQm9qMGIyTEhuYVhCVk5SSjlOV2llZFBSSGI3S1RQSnI3R3ZV?=
 =?utf-8?B?ZTBUUklOTThUUTZyMkxVeGJmUm1QU1p0aVBFMWFibWdsYm90Wjg0MS85b3g4?=
 =?utf-8?B?UnZjalFqejRpeGl2TzIwWlVoU1NyV2pJQ2F2OXJqQU9BUFJYV3ozeTNVMit2?=
 =?utf-8?B?WXV5ci9FS2ZzbHhmQjluVFJTc3RlV2FIbTdDK3pQTjhCeE5mSkhoVEl5OXJR?=
 =?utf-8?B?VkxHSVlialBvWDh4YldNczh4UnRWL3gwUElXV1JHcEhxd3FVZFFRMVV1Ni82?=
 =?utf-8?B?K04rSzdiTEZrYzF2Njh6U3drMm1zOVdXeFRiZ24vbWR6bkNVK1hUYW1mVE01?=
 =?utf-8?B?MDhVbi9PeFJwdGwxRG14YWhqOWFmRTRtR2tWSDk4RG5QYmltWmtKOWRHRVd2?=
 =?utf-8?B?TCtKSnVKR3VyTmg4Vk9QZ0lVeGd5SlhTV2syVm9IaWs0STk0TmVhNWEzVnVh?=
 =?utf-8?B?QjM2OERlVWdiOEhoeGdRekpsZkpPZ0VmMmkrbFB2OFNiSkFqZVZ5QnlNdGMy?=
 =?utf-8?B?RzZBbXNEVkZ0Yjh3QklKN1I0ZHovcDVzMTJlNTJpSUIveDMremNEMVhramE3?=
 =?utf-8?B?QXVBNWM3NFlDMUd2a1hEZTJXVlVEV0szeGJnVE1SUGRoQ1pMMkdFcDhlOTRp?=
 =?utf-8?B?cW5xa0pJTW12UTY2b3JMV0FGelJlb0h5YTE3UEdKbmIxQWs2czYzUGd0eHd6?=
 =?utf-8?B?dU1Db0E2VWlEQjhkcU5aV25sSE1XM0tTSm8yOWphLzNvZno2dy9rYVl5aHBz?=
 =?utf-8?B?Ukp4WkFFVnhmL2o0NmxmaC90cndsclBNcUZmQmFEdndXck51Ty9GcUt0Tmhj?=
 =?utf-8?B?b1M5UlB1aiswa3o5RVl2RkxRTGZzekZpeVJlYlZjRHk4bEZJU1NEQ3BRenly?=
 =?utf-8?B?Yks3dGxiV1ppVXRTaEExTXZHRFJHdjc1b0NiT3kybkxXYmhnSWcxQy9nWUpx?=
 =?utf-8?B?RHZ1aW5hcFI4T3lsVFpSUHh2UzByUzdXVU1KK2FWM2hML0NWMTRrb3ZkRGlL?=
 =?utf-8?Q?kbNedeSi4X/XFI1IgNZzZlHFMRfNEmCSqLShlp0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 245903d8-1033-45fd-6e2a-08d900828edb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:39.3891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhqydzVHw+zGtr2jZREn6qqyLGs00WAeljBduAkBlcLVAku2eF4HQBZasnifYwKO6/QiAuIxlcgt3wkqIoi798wBTr4sVjXiyuIduZfjCNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
X-Proofpoint-ORIG-GUID: UfqaaGjQUCEZo3HjsqeIjMovsBIL92Bf
X-Proofpoint-GUID: UfqaaGjQUCEZo3HjsqeIjMovsBIL92Bf
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1011
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 3 Apr 2021 23:43:55 +0300, Sergey Shtylyov wrote:

> Commit df2d8213d9e3 ("hisi_sas: use platform_get_irq()") failed to take
> into account that irq_of_parse_and_map() and platform_get_irq() have a
> different way of indicating an error: the former returns 0 and the latter
> returns a negative error code. Fix up the IRQ checks!

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: hisi_sas: fix IRQ checks
      https://git.kernel.org/mkp/scsi/c/6c11dc060427

-- 
Martin K. Petersen	Oracle Linux Engineering
