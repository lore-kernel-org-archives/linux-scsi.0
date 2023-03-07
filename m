Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FBAC64EC4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 01:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjCGBkZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 20:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjCGBkX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 20:40:23 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3366B584AB
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 17:40:23 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326NwnT6006034;
        Tue, 7 Mar 2023 01:40:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=IP+EG6LV/MTSIB1rfJPcFp9d+ws94ENFh8XRjYlRMd8=;
 b=mlJMKPt9B737CKjSxGILsIaBcBhx1iBXnKLS5uMkx8i8rzj7LPHNcRv8qk+jVwdJGTGQ
 Q2NKPFrucPkAg+S92p2f4azuN5/x4ONL/3VAck9Nfc2m/zLoFtb8nLw6JrFUa9xzzHSz
 2G+BTVzl4CjqGWKbjqgqp0qvWIQedzeJqRAlTZL51ZfqJ1oj8507S0qFVToo0DNC9unI
 uxtwMm5XVOcSuJ7LxByhImdxhwcFZXuDftGU7u9qeZOgZzwZbMe0kupB+csXJU1TSZm7
 t+CbTMjHkFd3P/U/je8TVvyfUoEcJDrGCmHuLN/+jELfemngHvWxNk03tdutPmgaGKbs Hw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4168mdr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 01:40:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 326NGmi0008747;
        Tue, 7 Mar 2023 01:40:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u2h3ax5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 01:40:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQHOv2ay96R29TKlKo/uxL5TxljGqzH1xaba+4UrzYU1zcXh6bICFh99OPE7bl4OQtkbTUJfo32Z8F/WVQe8p/Vbkjccy4LD+uGfqeRf6ESlCUIO+nikKoOg5Dj40BcsBVqVnVh+gUy9y3Pr4H+vYQPDtjDZbErVEE9vQvFHN0bJYjRpuaDGiHNRDeFLsQIMRQUTD+JU3WURfYCO22pDxYy395OcxohhBff6sMQ7kGtCyfsaixHiyq0ZbMz9q51BJ5wzUmY9p1Z2Zr5jYpOlslwjWxv4JDC0SbkEsfW8mR608wVWql+f1VL73ksQBz4/r70r7aZyOuKcpc0xp8sdlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IP+EG6LV/MTSIB1rfJPcFp9d+ws94ENFh8XRjYlRMd8=;
 b=jGpuD+24dqvac0pFenBTJ8bDiyWMtnsk9pedgwLwoDSn0Jun3pbmP4QpeKTS3/XXpCRMJvW7d5AYeOa4FXMigT0ZRulntWg5l87WBnyEt458kl9uDS6XZMAtEbM65Sa5xFVae2fnU3YDbsgchj0x3Xy9fskVtFC6/xarr05z5D3qDfYJq1SFd9r7QJWNbv9PmlmWSHCMPaz8+OLb7dOatzLQTkUrinKT3328VHCGuhRdKfZAeT3SXhw0xaye0Ez7YxO/Mb7knuEdy/aDjellNS/G4D/T6yo1CuoDyxYX3mArU8sEcn5tSZS6aokynHKXqURnlB/YsG43d8z1IllD8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IP+EG6LV/MTSIB1rfJPcFp9d+ws94ENFh8XRjYlRMd8=;
 b=G6hlHlUff3Tem1VXEe4EVcHiel7BCYyZLbjKtFhcVei0GQ+QiZBvhReZeeeyt8c4ml6UjVmleXSVdoWhuMnR8M+ZdDI54QzAKb5/KmdRVh8nT4cs/uQgdLX1jg+BuVu5Qjuo4zf/1Uv8U583eN7QIN8/aUfFKGk3UU7SlQDcaQI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM8PR10MB5398.namprd10.prod.outlook.com (2603:10b6:8:38::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Tue, 7 Mar 2023 01:40:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 01:40:02 +0000
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [PATCH 1/1] mpt3sas: Remove usage of dma_get_required_mask api
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfehmjnb.fsf@ca-mkp.ca.oracle.com>
References: <20221028091655.17741-1-sreekanth.reddy@broadcom.com>
        <20221028091655.17741-2-sreekanth.reddy@broadcom.com>
        <Y15lk+CPsjJ801iY@infradead.org>
        <181536c494aa39ca78b190396a97072448739411.camel@suse.com>
        <yq1tu192iur.fsf@ca-mkp.ca.oracle.com>
        <Y8+m0w4Og2CLFImY@lorien.valinor.li> <Y/ZGe8c1XyqSuCSk@eldamar.lan>
        <9aa5e89f-6579-15e5-cc51-d226b5d4bea3@leemhuis.info>
Date:   Mon, 06 Mar 2023 20:39:55 -0500
In-Reply-To: <9aa5e89f-6579-15e5-cc51-d226b5d4bea3@leemhuis.info> (Thorsten
        Leemhuis's message of "Mon, 27 Feb 2023 15:07:45 +0100")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0215.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM8PR10MB5398:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c71b3a5-ee80-4cbc-454d-08db1eacde7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oUSIk6AWwUpLVeFguhLTXdK2oi66ZWB216tfwnf8vSBZ06tmaf2I0nGugEeehEJPGpTYbgaFTF3K31AUx9fKhKdgKwbph2I9E8h6JgvCQFRhhYWNdOI0z7EJqKwxdjSv6V4FcBBlQFD7e8AEzF7HpV/R+Paj7KqGiUEPCZepuOOoJ1ESsZ6I3pUz5yd/lxJ73Ub+Y/f99iL3AzpDQ3L0JzdJCfweE8B4vlu9u7QmavAqQkjTDrbumN/oFJ9BsAuWyaYUJoo5yggBKRJdUsrE8HyAU/JfB1EiQEUUC7148J3uBHQbpJpGTSGMNpeUNV+jKCLzecUseDAo6FiUPDA2I69KFUKyE8F8aNBGTgjzTA86LtoQ9VmyNJoN0V8GUrS7maLLLuvjiZsGIxceFR2Gqz+uZFyXimz0Myg8L6SgN0V8Y+4uXaumT6Vp9vA8zr6OA2Z6XSGS2DGCT645EzCbQw6SksAZ1wJNSnBPD7lniHvDp7ovXRWMywOmkalizadl0mRsCoSSEwMB5Ybk5rbhDNpx/bHxIbGcNSinGYw0nnY0LyvspdUeiOxELmeKBh9mIywT9SEJOXoRm5uKxdspAvdpS/anK1+cAUPSfqXJikdWrDMOhMSacpX4bIs9rqkiXL8zpbLCur73n/lD+wFUuJGdxuWYMPRLNyyeNGNv0QdK/frWf3jkWpF0gV4dWmv4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199018)(4326008)(66946007)(66556008)(6916009)(41300700001)(66476007)(8676002)(8936002)(2906002)(5660300002)(86362001)(38100700002)(6666004)(36916002)(6486002)(478600001)(54906003)(316002)(83380400001)(6506007)(186003)(26005)(6512007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5QkUMrrkTQXbXEVGg8d+ZDUQE3DyMXoWDMxRREki3BUniInhRPkpg/HtGzpc?=
 =?us-ascii?Q?NlTVnHcqd8pLNxaYkIUPfvDHLrYol89OCgAysS4PwNdo6tRRv3gi8K+0R49z?=
 =?us-ascii?Q?95rhPAnBWQf9Hiw2CPNL4MGXCsLacKxs9dvh9zWYpQZaw1nvJOEt49fUhgcz?=
 =?us-ascii?Q?3+3kucnNckZ9wvUmYzHUHtyFWaOOL2Bm+4TnuIJO/F5Wu4+eW9+WQvgmTC66?=
 =?us-ascii?Q?i8go733vpXAIKIHV0h4hZsJNpGpmq/2cVGkIpyiB0ZXasdJPUlRuaUjbYxP2?=
 =?us-ascii?Q?YLIimvudCPu6uMd1HFq7XtZlK4DHktBNL267kRwcTb2BR0fyuEpD0YFp8J/A?=
 =?us-ascii?Q?xQbEzjOzO0LAcqJENOGRGRh6+AC959vG0SoaMhvwabMuc3ltp+8X06okJ80g?=
 =?us-ascii?Q?EhEeZ71NFPK7JL8z/wMA4ty7CDe16MzyHTFQv4/71Lmvug/TRI7/Zu2ERXTe?=
 =?us-ascii?Q?XixnvrehCNfatJritZBw+o/PXqzgvp20PAg1SRl8gmB3/pQ/mV4nZ4FdG4D4?=
 =?us-ascii?Q?DEloiMwMTPhxXWzhX9iGErMIEEYct6QsSqw43W1K/9gpKR5ftyZ4c+oq3Edf?=
 =?us-ascii?Q?FmaRtMYc2fpdqiLNJvl3guTdg0DmHKbeSVvBNzA/ehhsdOpPmTEGMasGYKvY?=
 =?us-ascii?Q?qOGQxzLmaf4Eda6Z9MU2wn25v1vYRhz2UpMHyA8NuNu9YqXtyHJ1GvwWp6Zu?=
 =?us-ascii?Q?Pj6UFvRbLvnHaNr0PqCt7WwXNHZhxsYpOkmBp2NQds+1UUHtELpb+vxSat4V?=
 =?us-ascii?Q?qKe9UKZNXS9OmlKsbBpV6wBxf6SsKP54O2qKYEXp37mI3rW3vXLvDgKrib6e?=
 =?us-ascii?Q?AVT01BVFalHl2sml9BuDXFQdaHWYBxid/vQ7vlau0cwITY5f6XbIqGQAPclU?=
 =?us-ascii?Q?282GRJgStyx1uM8H63+susvwrkVIfBtZJH7P7C5gw0rg0vWZzWgGMc4QKJD1?=
 =?us-ascii?Q?/JCiu5T36xtdO9rr5HKzfC2KEY4hDHpES1UR2sQ6/xptoH8opET27QX0D+/M?=
 =?us-ascii?Q?xwimKs+meDqlusGZWxrKVH8h+ujoYVWKmfx3PFS5N8HTzjF3B/HB2Ir4cdrm?=
 =?us-ascii?Q?rRzUbgL9XJty51hk0khqtn0+V9zTzgZN1qr4n/tpP9CbziEkRiIux5va6biN?=
 =?us-ascii?Q?FDhNQNfVo43/+ycTA/zzNibJiQU6p1S5UHB5E9lwHVbWADjbdKTOENyJzjaF?=
 =?us-ascii?Q?w/mDnV5NwhU+TtoxruVHSEkoqCcZ9nSFf4CVIFUZiP74u5BFtNRFKiuCBgjy?=
 =?us-ascii?Q?YFbUy14k+BrWiHMbrftBc/91Oth1xRETnYIkGe82WWZCEzA7F0r0JBnsA627?=
 =?us-ascii?Q?H3XkvN+JP+ioCh3uJv0x47CYqPi/saS1gVPyy25SuBmhzMl8ROWvR78yFoxC?=
 =?us-ascii?Q?gDIvWsSPPTzCNxlCRaqG2bqWYvjq7/lNuBkkpy6uiuxKdj6VTRl7UhRx2uU2?=
 =?us-ascii?Q?XjmSVQP1keIHPND2/F+KkypBTdhmChxoY3erNqby/Q6R22VUN6AQDqqXVVcC?=
 =?us-ascii?Q?xd352QiA8wHDlAwBW9HOErCWreCBO0IWeY5R+Fl/GfwVRbt5hI1CAXXtbeyW?=
 =?us-ascii?Q?EtV1YOhqDWPUfLEp8F+myqtAb+adQMbzJTOcf0icjSXoohmYPJs9Dc7CINgD?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?QasZwU+8Zmatak2WR/wegMOZLLYS9ARE7DqB+rSInP91Cmm9KViByx/CN0lq?=
 =?us-ascii?Q?XOHUVuJEo6/U5j6YZSUhgy0PGtVzex3q1EUgqRPUMlaw5FXyqLd11kMUtBKG?=
 =?us-ascii?Q?F6t9yiyi5BnZBRiw6LfF700edTZ8+OFZ4lxxWqsYln2b2bLfAeFnAtwl4IZN?=
 =?us-ascii?Q?POK4Or6fwTARlG837CXuwgwrG7xkVfeI68vBd53Ut9YDCm5e2f4hlirB0vb+?=
 =?us-ascii?Q?QkFEsU6TLJQax1XiX3TWOq/87BkmYrJ7xR+wxA/wIGq0nQg+BIUQIgE1X9Ot?=
 =?us-ascii?Q?wpPFoeyxMMlkcxtN/od8ixn9hZh4Jf4t+IiE9SynEEOULEQHtfp5M/4ilEMz?=
 =?us-ascii?Q?B7YY+6en4Rv824WDwUH7D1K+S/h+J5ua+33eYakJ8O0Im+8m2ht6siRJvpiG?=
 =?us-ascii?Q?I4fT7/g9z8ayNfxf7utlukuI+kokDeIkYnMLCfHaV8FIfitSsYuHutw68f3k?=
 =?us-ascii?Q?BmZpzxZy6JfWRW+zuxgW8IYOn7sHlNigS6P5ndze6fTz3hVd7r+O0HT16gpU?=
 =?us-ascii?Q?FFt9R+oFTOFLtZa+wobzzjHvQXmVlXU79W+xbEqertOLXvaD7B92RKkywGWg?=
 =?us-ascii?Q?fib/C8Q+MhzTZOzTvW7PwhlPP3XIBgwz94sV2MeINgyHF4eyvNjtJCRSWZ3y?=
 =?us-ascii?Q?budGk6/1OmXBmjmLGyamS/J4CaZlzt1Ej5BBrr78+ecccjQBZofWMSUaO3Mj?=
 =?us-ascii?Q?vtRspo1dD71xVa4DjvPBKSwVWDrDvCr5wFhrxuFKoH2c7Y0ywn9/wtjIaVK4?=
 =?us-ascii?Q?avpmfkhBrYqJtBcY/kgCJB8KkzeQ4NLuDxnKqaTuIvx7ogrblYBqLg6hXd23?=
 =?us-ascii?Q?gj+eDucCkl/OLyfzoFCyew3C8XJcFtElOyBsy1lBKuP2X+cDnuud/nsIO6DR?=
 =?us-ascii?Q?0eCLUwoR/DJcEc3MtemqHrXyvbmqxDZay0Dq8PnA2x3VcVxFKZpGewEZkmaT?=
 =?us-ascii?Q?NXE8N5tiax9833kp5DtdoQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c71b3a5-ee80-4cbc-454d-08db1eacde7c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 01:40:02.0044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lvg98epieZmUz215xANyLPlnipcVAb3fPY3S4/ZH2Ac1kfOCjEnIECUXyRNXf5fzG6/KIWf3HTejjykMlKCOTieJ6p/RVmz3rcblOKBSr+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070014
X-Proofpoint-GUID: 6kj4pjZQnbDiprtkuvCXTEcxLifPeSDu
X-Proofpoint-ORIG-GUID: 6kj4pjZQnbDiprtkuvCXTEcxLifPeSDu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Thorsten,

> This afaics is a reasonable request for 6.1, as this seems to be
> (Salvatore, please correct me if I'm wrong) a regression caused by
> 0e0747de0ea3 ("scsi: mpt3sas: Fix return value check of
> dma_get_required_mask()"), which was merged for 6.0-rc7. Hence allow
> me to ask:

This had me confused, the above SHA is incorrect. It's:

e0e0747de0ea ("scsi: mpt3sas: Fix return value check of dma_get_required_mask()")

> Sreekanth and Martin, is there a reason why this request (and the
> earlier one a month ago) was apparently met with silence? Or was
> progress made in between and I just missed it?

There are three recent commit in this area. e0e0747de0ea was
accidentally reverted by Linus during a merge and reinstated as
1a2dcbdde82e. So unless I'm missing something, the appropriate thing
would be to backport these three commits:

9df650963bf6 ("scsi: mpt3sas: Don't change DMA mask while reallocating pools")
1a2dcbdde82e ("scsi: mpt3sas: re-do lost mpt3sas DMA mask fix")
06e472acf964 ("scsi: mpt3sas: Remove usage of dma_get_required_mask() API")

-- 
Martin K. Petersen	Oracle Linux Engineering
