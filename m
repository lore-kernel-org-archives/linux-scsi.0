Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3497C4321E
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 02:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiKZCTH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 21:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiKZCTF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 21:19:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57A0391FC
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 18:19:02 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ1cJB9010405;
        Sat, 26 Nov 2022 02:18:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=+WZ1ocWAXZjWErdBS+DohX3zCZvgNDpQIQksVzefwOg=;
 b=vurw4kF+Rhsfd0Ub+ECctobH1gQMyOBrKJNWYrDfVpLqPLGgAtgjIuH+y+GckTyGC+qT
 2fq1aj7gHzieG5WG6tFSWD0ObPJcPoExaip58Qea7b1PNlGAhS9AzGaeahr7w7SLye5A
 sulOtyYOonU6nPMlQP5T6nSDhstXMWRqPsG2HNXsBYhbAizBE5sKpNLS4JlWYvbj6Jk2
 3Tx7UyBz6cG4ABR2JqZrH3sa2t8/ZPHtrrtEE+dleT/xQ+F0ZRAbKrVpWmleuJY07N/8
 U2wO1Jzs1nB3rny/PStseyYYopaOG9ZEy/PMpK5jpFTpoNsxqP5Ozy9t5SnzxgAPteFG ag== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxrfb9hu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 02:18:54 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AQ1X5Rd005371;
        Sat, 26 Nov 2022 02:18:53 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398215x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 02:18:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5mzOsC/1ek3kHbXLwnHwX8FtUfMSrf0RifB9cXEte8j985OF9O8LeYAXLfsUC6lM4w5kNkyZ1rVqY5KvOzDqBI2L9xB4sKoIMvlkXfwCK+u9kNtzahWzk64TUmPW8R+W1dvi6Zsaw/Lc9tmyPeVtxKog/fx0x3AmJGQ4SzTxi4m1/lo7tJR/qxIQIPe9B0cGvDWtmKJ2rid4h1ed4Fqokr888pUjbyEAjUpkqPQ0qNSqI95RDMbalDdRXQUny5dSejbfKcrtZ9EzNAR3oSXTg82pCKF7su0KHpPffy0bpvErDSxyrRtgYLHpgY6aUGJY4FcXzGGzKZOy7IpEdvajQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+WZ1ocWAXZjWErdBS+DohX3zCZvgNDpQIQksVzefwOg=;
 b=Nb4eBrhfk+88mD+KnRXFbWZnOQoaAqz94DHnpDMsodsGqnRpMK7lAwF9LuAkfUG5pEBokVh9IiXI5kfs3O0xX5b3Dree3/6Xx4zc+vQhl2hTnP59+FRVyroylLSd0Y/GzmXUTBWx6h5ZeSfjHsJlz1P/STAvGohQ9iujvtu1EKJiIasP3fobxC3sbVu42gUjBFgK9YVNYLkOuSwf3Ou+a+dXJrXbDsgB2jd2QKB/xjN7S+YkWuytfqWX99/+goySQlm8hCpfXYvXbUcTyO557KpTszpliJWvLf4bts5QGBVxCaBixD0n+xZIo0+lGNcbMX0D0FxblH3NO7G+Nxspsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WZ1ocWAXZjWErdBS+DohX3zCZvgNDpQIQksVzefwOg=;
 b=RZ+RxXotN2I9QGU0+YiYY4POA8OeY2f2ITVG24TwoH/rrSNcoFRdVJn9n5gas3C4Qhh0o1RKOAB2/9i4pbo21SjG+WGQdTdX2CFyu1afbRQYWK5MNJvnCkGSPUjjIdl+ufKXLdm5qRr/5W0ro5QvX1k4AYgfny+mgQxUR/JiLuY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BY5PR10MB4114.namprd10.prod.outlook.com (2603:10b6:a03:211::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Sat, 26 Nov
 2022 02:18:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 02:18:51 +0000
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     kernel test robot <lkp@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] scsi: sd_zbc: trace zone append emulation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h6ymo3wp.fsf@ca-mkp.ca.oracle.com>
References: <6a21e78a188e5a0d630acd771afee11c7d45d183.1668427228.git.johannes.thumshirn@wdc.com>
        <202211151344.VGP4HoGU-lkp@intel.com>
        <7c758dc6-692c-3aeb-a0de-05e4134f839f@wdc.com>
Date:   Fri, 25 Nov 2022 21:18:48 -0500
In-Reply-To: <7c758dc6-692c-3aeb-a0de-05e4134f839f@wdc.com> (Johannes
        Thumshirn's message of "Fri, 18 Nov 2022 08:31:26 +0000")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0031.namprd13.prod.outlook.com
 (2603:10b6:a03:180::44) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BY5PR10MB4114:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bb85f14-173c-414e-f09c-08dacf548f34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UksRGbyj49bbfgOEbVTT+lNreORuCsyk50DY6Ytne9EuDoWgIOs0GQMahdyl7BcM7JD+6nRrXmjsPuX0njyOVMjrNIn3QwvjlfN67WAszknILJQPMhJ81w48FbuvuOgzFw9VXGT9xz8/kXYBDAokjVZ6M0iuWmYRwLyHv4UQvbeH/7oxHnsgmp+X0qy6lVSboWuKVnS5o1Hd+5WzD/HOqzEND3RZgOIgkAbeOL4VWwHeli3R20zvWMMSMMq6KpXdXX4FrlmMR2GnlXtQ0NU2/GSp4gLg8n9eC4oYQm+DGJxEY19MvbUC6WdpKFNN8oZZ4KyKfXMa4EiBiiYDRnLheLJdCKGcVJMeNV5AalITGiQ/zP3A114BlurFCmeTCLgAHUriedl92yLTwBbL0APMcbKQ8Z1iKdu+nnzo2txcmiH3YcsecU8vz2hKocyKn8hAizDZ8uzGfwaVfXOJQ56DnhMDp7ZLPssgJDoXfEmjGdLoG4YGOJsmzjbnVbpb6sasfBPmZ6iQA6UvGgRJE9U3sk5UwaCiUQ0zRbSGipkCyWxNRt5OvJFfcgT5H4wD2WcpEX67vIdV1/2ZhpauKo0Pli3pUWV+DuTPSiZ/U4xwzoINnZUYOxa7rPgfq2yQtIpAh+bgx95Aab9g1XuZ4P4rrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(38100700002)(2906002)(41300700001)(4744005)(86362001)(83380400001)(66476007)(66946007)(6916009)(316002)(66556008)(6486002)(54906003)(8676002)(186003)(478600001)(36916002)(5660300002)(8936002)(26005)(6666004)(6512007)(6506007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YWFsGO+ab3gyXNp4i/gSblu53o5UDveX70cUStMA4w9IyqF02rIaFyowcXWX?=
 =?us-ascii?Q?FT7+eBZBA1IV/XtojeUt9MgJqNoLHUiVYhaJnNBd7oPdM/zD83e6KAmrofYB?=
 =?us-ascii?Q?8/jxzeTFhPA6z3FxtRCszgdNP3WCS64u7JkL5/RHn6FLNu71xQZ2cdyZX3S9?=
 =?us-ascii?Q?bFkCV6a2sThGIYIcvg/Vq/wRQXZKuvjlPP1J5W8ZJfjpeHEDt5JMUEKZoy/n?=
 =?us-ascii?Q?WKQ6tyVwXZx4PqaNUvv0AP/a70JrKEhPpg5x3eiVDb12VUICYj/gY3nHVe5d?=
 =?us-ascii?Q?Y17QcMONxAnHolz6sWmBQjrRoAocqIBk7VO9NPdN+LBazbzquOTOeRkCtknj?=
 =?us-ascii?Q?+u8s7HGJTDkpsNHrLA3RDYeYbshAFHuSmUtk3q7Cz+bm7/1E4nuMHYzxExcd?=
 =?us-ascii?Q?fG35XFC94qdKwBoSy/6XwXcLOH3sy/72N9ethkBQSK11fu2yV7mTWgtzBnxu?=
 =?us-ascii?Q?vd58XEssR4XITWiYmtbLAiLoFu9w/tqkbyOZKt/xiDfhjXMhdilRSv+Ap3jF?=
 =?us-ascii?Q?0YJzNZQlvTXVc/Zv4ucK2ccEvXitSfmjtwn6B70wKUL2hYFF4yy7j+KMrV6k?=
 =?us-ascii?Q?FX1TVz6OxUo/GnTriBILackE3iAfw4jqvDZCA3la70wftsnthyEGU64Nvd31?=
 =?us-ascii?Q?MO87qr57pEjrIEt3mTlvhCpNTsm3WY8us+xXRdjxS1mNNSwJMje/5J1Kjgax?=
 =?us-ascii?Q?k1JKtuD9HvQpeNOxaZUFzqYDPJLB6M44co76yqKC1gKNZK3PUblpPJuNxRUU?=
 =?us-ascii?Q?IBgxbj/S9LAecUYAS/Lp5RGmImrrqDpBwFGm6FMIM0CHV22/hxIXxcgTFRna?=
 =?us-ascii?Q?05EnHQZhw5/09/ovWhOaGk04/NoAbQNUbbEauv9K/vCAf1EX3zMIyy7Uy8+2?=
 =?us-ascii?Q?tH7rH+l55FiwJCb788IRYH5brKiHXLU3ndX9cDzrgjE8HlBQ8FMIaiqdqKYr?=
 =?us-ascii?Q?rrgbFFkTVlIe9AdlJ0boRK0oELCKZlt3lDi6MePx0/2tTbj04Drhr1JfrbQd?=
 =?us-ascii?Q?el+lxfJKsLIAQB+qQDlfMQW8ObUhjz9S2PUtN5DsrGrAnKA83T4393E6jMx6?=
 =?us-ascii?Q?ZBr76q5A+VU7/8wqAmh1hbY3zgXinSXwtLp/l5bMEu2uHMAOU8Vh9WiA75jg?=
 =?us-ascii?Q?GvlVTWgJkPR93vexq9hhBPrEXG8afztGHzbFXNnEVqf/zyevC/58aBT7ZPw+?=
 =?us-ascii?Q?oFQk3MlyrFsPbDALz9KOgx6ZIWqLpqnQL0vB49vxHyFNu2YGGDr/KNSxkjap?=
 =?us-ascii?Q?66NoTqMapDvptLDaytSVFkt/diOBxCTRh9ge/RzqKbBpDfmsj7DxAzOKW5Sl?=
 =?us-ascii?Q?7KlSvkSBqpcUgTARFyn7QTXzf9jKO+nuHoXKwMPJOE+0oKJdptIwToUU9Lgr?=
 =?us-ascii?Q?mJPmqARvqpF5UaY1+OoUopHpOikxwvJ+MMFUq+PCXSdsZMODpb0wSUTeN6Ag?=
 =?us-ascii?Q?qEpbvmxdBsqkeqMS4XeuTGsWWTj0BS0ATIt/Pi7nXRjm4AxX0tcOb7eyv9+J?=
 =?us-ascii?Q?sOJadFr/fA4pWgnDzrj8pmTRnvdt52quV8ZvS4LWZdlWfbfZDv86T4K2Dzwt?=
 =?us-ascii?Q?PL3MmeYGCzkFDjanixuTXlxA5QRQcu66F/EWz7CYOv/gyG19W8XPBrFL82rd?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bQhmU+VvOD9VUP9lRvCKsMnkOnUHLx4x+1J8gadCyT7eRUeQdr+LVzx2EaPNU1a1ajpW6tTs4ASm06xs/ArJmVAzc4/2LdDU4HC4ua/nnyAHoR8nYVeegEX5VlJdHbNopYJW9AmMMBd2Tq/JK70CLKjzybrchNGWxQcFQ5OsaJi0darE+EnZruvDtpA84XSaabIZvcY7FugmimK2fj1rC/QQr+7Xm/3Wj/oJfZuAuBCYwiMjbuJnpt5Y72DGyo3+9kWrn8jBaLDpqmlSXx3Q5WbL4H1DTuryIweCT9+IORABIbKIIL+tfHjzjAEJIPVyFXnng45CAnvP+BGkSv74wMcsubCsEPOXYXEEy7B4LZ/MCeaWZ86hWMUoMpYpd5tWl+2UEGWWXJ7GBDXmwFQ01ir3qZZvnJ867pUCS1YPfTZjufgqai6Dh5iiYRJeJVSnjh0FA77Sp5mhLJx+bWZ+APFfTdDZUiPXrXZBmivxQDIb90OZPtqHMjsXvkwrWHxDYc1Sh95Xi1bZsecVMgfiEyil6L5E9O7tlVzFAtQPwLMDP6Zd7/L0IJthlz9iTc8rkwEplwveuDM7VtENDZr0coBnuLRTtS8AgzJs8k2kFmLgRuTHL2YsgLrpCzTrSnSz3hCm7ob7WomxvuTWVPBB/tY/pW+RC6pBo/+TlBL0e5xT76NwJbFyCr9jGZeLAqcsN2XShJXvBSQ7JYoDy6R4Jnektlrfh68Iy0bdbp5ZBA/rKroQeUyidbt/KOK++UMxQIf3IMMjFXYRwKJVkFvfabiiTIzNp0iEHxVIFpvNjwY/JBmD4TCtmX5Z7omV2mZ4ObF0qGPh325EKW4C9qfryxRktMfjMh/RiemfDWGWohisSCFcn3SI1uelKzCIrtpQEatXzvM2lVxKiaWOEiB0k83IJoQ9RqFk1BPafAUqwI8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb85f14-173c-414e-f09c-08dacf548f34
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 02:18:51.4566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MRZuz/NDMVdGqWX1zvWk/pnFOEezBRJo9xuzpciQ48AAQ3TEOKzMx5ylZF0hLq/4ZkOSF9az/c8IJJUji07l2YDxmkqq/+KwFBtbfm6Oebk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4114
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-26_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=716
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260015
X-Proofpoint-GUID: i69I2RpABghQzJp2FNaRErRp1YElKNC3
X-Proofpoint-ORIG-GUID: i69I2RpABghQzJp2FNaRErRp1YElKNC3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Johannes,

>>>> ERROR: modpost: "__tracepoint_scsi_prepare_zone_append" [drivers/scsi/sd_mod.ko] undefined!
>>>> ERROR: modpost: "__SCK__tp_func_scsi_prepare_zone_append" [drivers/scsi/sd_mod.ko] undefined!
>>>> ERROR: modpost: "__SCK__tp_func_scsi_zone_wp_update" [drivers/scsi/sd_mod.ko] undefined!
>>>> ERROR: modpost: "__SCT__tp_func_scsi_zone_wp_update" [drivers/scsi/sd_mod.ko] undefined!
>>>> ERROR: modpost: "__tracepoint_scsi_zone_wp_update" [drivers/scsi/sd_mod.ko] undefined!
>>>> ERROR: modpost: "__SCT__tp_func_scsi_prepare_zone_append" [drivers/scsi/sd_mod.ko] undefined!
>> 
>
> I have no clue what modpost is trying to tell me here. These tracepoints aren't
> in any way different to the other tracepoints in SCSI.

Haven't investigated. But I get the same errors building scsi-staging
with your patch applied. Builds fine without it. gcc 12.1.

-- 
Martin K. Petersen	Oracle Linux Engineering
