Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45192C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2778F61507
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhJEEhZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:37:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18288 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231740AbhJEEhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:37:22 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1952UGtA029448;
        Tue, 5 Oct 2021 04:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jJCCTcotrZhRE1wqXWRroGjDxvzD8OVSEr2lnP1eC5A=;
 b=vkmhA/frw88VIrZNyWnE4v2xkgzBoqyx09iiNlhsOYP52nQjWDzbLjdioX1MiROWgj1U
 QoNg8QPoWk5EyQyOIXbyyp9b2gzII1dslPW1DOkqsf3Tvk7qVqoHX7xeMa2mK6umQ44o
 tZ3U4qo3VKw/s6QV9LgH/eUWmB3FlcPFISyiLZf0srui/6xrf+ToR1zNMKeMz6KA2+gg
 1BkzgPIlveVlDN1Ie+ylMz7MM3H690q/bmiYFM9vEzWmWM9Z+q5D4wr4m5gx8uPQZm7w
 xxFYgfXlqllhhCDNfv1JiH6TgFabRucUZYpQeB+uPyXrid1cTZ/MRA5jaS/yzyeOMGSL PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg42kmmq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:35:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UJMg054346;
        Tue, 5 Oct 2021 04:35:00 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 3bev8w4hvq-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlX80YRdfmCXzu60z+0mkq6EApyYRYvU7bQLZ3nQSuCyBGef3+MODZpcXSolPQbjwrZKGE6wfPTCd0msyID72wSBtap1grDBvMnrI3MesWGUpzwYfLBLfgscNXXn8GhuySyf0ZevIoSr31mltTWOMiWZ0r7ZsuFKtI2WRWFtcgkFZLTyUXjL3Jh+4jvaWS4Jen5XWC0x6XN2iPznL6iLq5Qg/E2UCs5gXrec6VWnNh6OerxGQUt4jfaMOCkkwRlRIn0a2xvouWFbuw45pq26dLRyEqSyxlqzrft+Zwi9SWKcn0S0M+moM5TzuL2cNSel9DdOZp32A3dNxejc+TdFPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJCCTcotrZhRE1wqXWRroGjDxvzD8OVSEr2lnP1eC5A=;
 b=bT/lWwnsJLR/gSMIJpL1N/Ra4DLlpOpNJD8hjgpJIVSpCWP1CqcHBwWIQ9RhLYALBUWKB8/EUd6e/GVjWw4OIlzIYygeSZk+1DxzsMQp+YcGtAItmei4C3KiFK2itElJ3U0t7zMRoxTm/raSoFiTB7wUzN8O/VmXRrPEizxx6qTMXFjtBkPZ+/d+/5r2Ytlr4hTPH7Vb+L68B5JDlIAQwAqp5sQrm2YEhzB+FWXPd1T5jmsKq2dHxdUjXxX0Ds8XYOPGmGy+bbIUXXKCcKZNmcxbD/cymrckQkpN2DAchyyrl0ty1xjFy7QE0Xd8TCGu4zRwftW5YQ63GDD5u7XLmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJCCTcotrZhRE1wqXWRroGjDxvzD8OVSEr2lnP1eC5A=;
 b=nDK83Vr8rGbHCBVA//rdbiAwI5ZOVedmbSUPQbgXR96sOI5eZPzaXx45KBogmAyXqhO125CFiIY5EU8CdeCfzzKbCJX/JCumsYyD9I0kZ+isbnyAmRkI9sKV7v8m2O+X+R4rDF4PMF9HXX37guHmiGFrH2NvlpCdIBywm7p4rv0=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1950.namprd10.prod.outlook.com (2603:10b6:300:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20; Tue, 5 Oct
 2021 04:34:57 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:34:57 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Len Baker <len.baker@gmx.com>, Hannes Reinecke <hare@suse.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: advansys: Prefer struct_size over open coded arithmetic
Date:   Tue,  5 Oct 2021 00:34:38 -0400
Message-Id: <163340840528.12126.5824818012998288019.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210925114205.11377-1-len.baker@gmx.com>
References: <20210925114205.11377-1-len.baker@gmx.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:6e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 04:34:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b2518ce-b60a-494b-bdf3-08d987b97c0c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1950D637A627B62519E0E0F08EAF9@MWHPR10MB1950.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 34mzEVsN07aOn08Fz+Nk7znJDxxPtLASozodxvh8mz5TNTRmkETEHZraq8ODLEFExhDR3SVA6QhLvs6wgeWaoPqHiTxV6nYT25LKArlXwodQ76BH4rXNG55oykyqPwlqaSPZZipcOdOOVo/42DRnYPWJNsDuNOY24O8krFvpdGqnhZn0FrPoFc90zW2NZC0yNfW4Y410Z+E0G+FoWwfnttHWI5l//SJIuSxg/lDrPal0L/AJWDBUJKwdp/yeibjWBnm6Cjq5TbJUbHcaXnqHJInzlq2scnqM4sLK8J3/YhAAHozkbEsPRVNeF+FoZVz64iFK43uwhIPfzhAgeEUx2jNWYYPNzyfFWDl8M0d7TQqEKJ3ZuHTchjUKkGyS+Gx+Pxd/ZlbHXMn/9SNnS52XOUfg6lxeKKtZbOMiSchNz34hZHXHXPhPXegD59EljYiZ++m5XN+XGxtkw62fY0cU5PU3KPF5M5CVSiELf7/5wSOP6Ock6qq+4u7vORZwpbt3EhXCxbE2vOLZcO3zBtpxV9+KzlqZgt1O5GU9pq8h4uk+ggFJYPdkGbjrYKlxprU5//SpARmX/X++u7lvT0GqPpqlhRz84vh+vUC0qYuZ40fTNIQ41I3Ylqo3zPsRTBphIc6SVgd79JTx1+whATAeE9Y0A7ZQzKyYcNdp7r7Ys8NFc9QYSmXeqdVhGBQHZbR/vfWuQ9ZzojW7VB8l/wrya6Jwa3owYioJUPWqV6arYcS4pORgzkSMFKrvFXql8dpKkbFaa54dNnOAVGlHuQJ8JtnpCV6bPGtQgh8TI1vvgGg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38100700002)(6666004)(956004)(5660300002)(6486002)(36756003)(4744005)(38350700002)(186003)(83380400001)(26005)(8936002)(8676002)(66556008)(66476007)(103116003)(316002)(110136005)(54906003)(7696005)(86362001)(4326008)(2906002)(966005)(508600001)(66946007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3ZFM3dwRmpVcUtqeHR0UlUxa3dUWEE2TmQyaHBSZGRNZWhnL1kxaVhweVd6?=
 =?utf-8?B?Z29hdUFjRSs0R1pPaXNPZXYxT09BLzU1Vi9TN1cvRTZ2UC9tcm50UGx0S25z?=
 =?utf-8?B?cDFUWmQ4aWR3SWJ6Y29zSTlLV3JZbVNaVkh6M21FbmtLaEhtWG4xS24xSE5N?=
 =?utf-8?B?N2RET2N6cm82QlV6WmxZbHlibklZNE1ZdEF3cklzanMvV3J4dWV4dEYxY1h5?=
 =?utf-8?B?RkVIQm9yNTVVeG9KS0dtbG1KeFEwMENvYVl5RDI0L3poUWw0WEJGajJIdnBS?=
 =?utf-8?B?UG9uSjNaSEhPOE9vMEd6QzhrT0R5MlNPQTQ0NXEyZ0hZTkdlUlZralh2b0Y0?=
 =?utf-8?B?Qnk4S2svZnhTcERqZUtteVppbHJWa1pOa21mSFMyeUZhbk1zR1ZVLzhtKzZY?=
 =?utf-8?B?eWhTY09pUVU5bWVPdDE4S0kydVN3ZEtOaWZuOE5nZGhmQTR3S0VxNStNeEh0?=
 =?utf-8?B?QjdKZElHRFJRUHJ1QmNrZEc5eE44c3hEM1FpMzQ2ZjZOZ2pCMnowWUpCTVc2?=
 =?utf-8?B?dXZVMjJtR3NSNzVqazMvelpOTFBDczV6NjZwR2YzY0xMNkFYdGlCeklRUzcr?=
 =?utf-8?B?aTRGZE40d3NZZnVKUXQwV01lbWM2UmRRNTRwK2UvelRXa2EyeHB6enZ6UXda?=
 =?utf-8?B?amdocTJ1aHc0a21kNjlYOVYwdWhUeFZXaElDZzZJQjJoTTNXeDQrNXB4Uzlp?=
 =?utf-8?B?M3prejdQT0hxdlc1T0syeGk5eUNCL0w1RkRETjBJZERrNGRZZmUzdkZRLy9Q?=
 =?utf-8?B?TUhUUjZYUmlibXN2MVpYQmdSaExyU2QrM2lyUzlDWlBnSDRMUHZmckNLdlJ6?=
 =?utf-8?B?NlNJa29Fc2t5eWdoQzZnZXM5QVNIWERmWWNHQzQ2dUZUb2RVVUtxem95Ynor?=
 =?utf-8?B?bFlJejVCTzhUSklnRHZaWmVqbXpJUjYwc3IxalIvZjdud0RLME55RUR5ZTVZ?=
 =?utf-8?B?QklJd2xHRDNtSktoZjVjYS96SVZGNm9YWDk0TTVlYVROQlVmTlZUQW5TVDJ6?=
 =?utf-8?B?WU9YaFR4V1g0ZmNkRkRZWWN0N0RLQlpKRHZsMXhpRFdoMzVBSHlqaFV1dHJM?=
 =?utf-8?B?V1g5TzNkeXRadG1FYWkyb1VuRytZTncyeU96dEtvYkV3d1NGdUZtVG1yTUcy?=
 =?utf-8?B?dUNqZE40dzBSVE1QWW1hUllZUlBxdm1PSkpJUG5FKzlsNXNHamgvOWMzemZ2?=
 =?utf-8?B?aEFKLzZ2VXM4Ukd4ajlZVjdIbEtiVERaL0JkN2FKeWxqZjFFZjFxWnVHUE9U?=
 =?utf-8?B?aU5lWXBFZ0VGQWtXL2FPdk0vZGhLSzBoME1FTVRsako0cW9jQVJhRG5oZGg1?=
 =?utf-8?B?MVpwOW5DZDhSSmNLVk9vUDdaVHcxYW40bTZVYmtJcW1KS0VDWnluTXdyaWtn?=
 =?utf-8?B?OGNnbEM3SEhxc2twanpKcHlRSXZ4M3FOaDRLQlNyMm54K3lJN21MYzMzMjlS?=
 =?utf-8?B?S2RBeUJ0OC9yVy9RWVN5ZWQ1ZkhXaGVNUVdqUmFMdEY3a1FJNW1UTFJHeGtP?=
 =?utf-8?B?RG53Z3FoZ2dnRHZtRVJoaE9pZGxneTFxZHlOb1NFbDBjaVA1VEFuR0VJbWV2?=
 =?utf-8?B?eXVxU0JwSE90UVpid1YxMnAySjlmWEhrY09OUWNoVlVkdmZCUml1TTNTNzRn?=
 =?utf-8?B?UjhXV0xXelFubUZZSDU1OVhWVk9EZkJiemtiZTg1RXdZWmJvMnpxbkVlenZC?=
 =?utf-8?B?QVAzNjdiWkRvcDM4U0hIZTlodGQ4ZFgvSW9xMld3a1RYMHNmQVhDNUNjVTFY?=
 =?utf-8?Q?apaX63YsrxE7k1ilHKSXFAW0JlyL8oIRs5uEI4G?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2518ce-b60a-494b-bdf3-08d987b97c0c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:34:57.2093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bDQ09lga+VOAHaVnNvd+txMf7T0//jPofP9bIEiFC5Ce3lDOUM/8CJ7j8wRhC/sNHJ6v7tP/RSBd4/IDBk+30tNjywompmTu40P06M/8JII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1950
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=865 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050025
X-Proofpoint-GUID: kCu6UeHI-Hf1xUQ5Ok3sg1PtTnu1hOo8
X-Proofpoint-ORIG-GUID: kCu6UeHI-Hf1xUQ5Ok3sg1PtTnu1hOo8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 25 Sep 2021 13:42:05 +0200, Len Baker wrote:

> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or similar)
> function arguments due to the risk of them overflowing. This could lead
> to values wrapping around and a smaller allocation being made than the
> caller was expecting. Using those allocations could lead to linear
> overflows of heap memory and other misbehaviors.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: advansys: Prefer struct_size over open coded arithmetic
      https://git.kernel.org/mkp/scsi/c/568778f5572a

-- 
Martin K. Petersen	Oracle Linux Engineering
