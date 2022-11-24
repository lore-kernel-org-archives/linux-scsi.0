Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EF5C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Nov 2022 03:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiKXDpe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 22:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiKXDpa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 22:45:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0DA31ED6
        for <linux-scsi@vger.kernel.org>; Wed, 23 Nov 2022 19:45:28 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AO3fn7N005984;
        Thu, 24 Nov 2022 03:45:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=9/j6Y9QxpP1ViXLk5gWMBQXwSm37NM8V/DDDMnvMBMQ=;
 b=V/Z60Ee5aaIxh5gqLdQtUfwJ2sYCkvjEAnnW2OH/YY5MONvLB+LIhP1ay0xyULmwhugh
 JBTtOfhAA8p/BFUYSUhYpP9BXgUTihAEO8PArdXzfhqW2k5/EkEaEDwwr6We4cFj9qVj
 TPX/qNnnr8mLzWOlwqf22LGtYvQiJbCfG4gBGOxpdP0MFGPBruYle3zlHqWJC8tDzUGj
 HOYeSZkthZEK/H8yx6XfHDHUmJCmRgrL0xE5Fh3B6eGd3El9EVnlfPgCe/gL6VWyxS6F
 EIsQJT2jdbyW76Y8GGbactN6OYgN/X6XYmh2mMOj39h/hzhsyPEEVSr6zELQoGvTKtgl Yg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1xstg8v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 03:45:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AO3WVvK034566;
        Thu, 24 Nov 2022 03:45:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkdfqb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 03:45:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ru4PPhtIJbPDWZEtZGI69jYPKAnm9ZYVZQO1jux2fjO9u2nc/i1xHry5EelnXS4v7QZmPzIE2IHBVWAdA1EjqJUcSmRH//ulkcJ/c0/8GjbstgCuFZaal+ltFrtR/39XpqCw5tFMY9pH1FYqMd8KXl3aQcHk5htQrX6u75VZtUgIVRMZDI+peDle0TTm1t6R6yfS8M8rW+JmlNLTNUNS3/WV2VFsjp3Hrr4HkGLll2FjfgC4KXA5Q9VQ+O3qeK2EN4W0rMr8rsZ4NXoaXSRRh3lHNUbIDk8i85mOJxjV2RLejH/LBj2Wz3Gyry9iPUI/eVedcvNrPprD0WfMwd2K7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/j6Y9QxpP1ViXLk5gWMBQXwSm37NM8V/DDDMnvMBMQ=;
 b=ExGm4a7Q4FjHMwADcuOBDoiyelKNS5v9+uGNPH+0qGe8tdM4sf6NEdMz70PX3Xtz9hjSgnBpn7OG2qcuTlmzLWhqvPtgbAeQWErftmORE20BAyVZxmTkXt7Xdaig+eIPq8WNnIDE3wmrTbSW7JuukB+nf0CChes3DmqbkGN9rq8Wk3jgTJNSUYNv1VgrnetIVMau4vVqK8KH21Wz0HNpS4lcVMHuNLISapAHIUGMwpqPK9nnOTPRburS+snJuRNw8alkZA8qn68fMzQtnVPqK94MmY4d+AhEvG5wZMDguHdCdrGX9TllczpfKbTxoXjLH4WAYZn0jCsPlSrdHM1clw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/j6Y9QxpP1ViXLk5gWMBQXwSm37NM8V/DDDMnvMBMQ=;
 b=A08+mFZchMix+DXsW3rN5E0ZAf26RRdJa6dDW+n87rqt2l4rHNgsbEXg/HHau1JIMDA920EUiGaG8YRbUV/cCdtXmytfAHrNh5IXWAYxVQ6E3btdEdXuEiEj13YBK1zL8v0SMQW0ae/rmrReDrXlxIctohnhYaafPrqQWOjB4Ag=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5235.namprd10.prod.outlook.com (2603:10b6:208:325::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 03:45:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%8]) with mapi id 15.20.5857.019; Thu, 24 Nov 2022
 03:45:12 +0000
To:     Yuan Can <yuancan@huawei.com>
Cc:     <don.brace@microchip.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        <storagedev@microchip.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: hpsa: Fix possible memory leak in hpsa_init_one()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o7sxrp6q.fsf@ca-mkp.ca.oracle.com>
References: <20221122015751.87284-1-yuancan@huawei.com>
Date:   Wed, 23 Nov 2022 22:45:09 -0500
In-Reply-To: <20221122015751.87284-1-yuancan@huawei.com> (Yuan Can's message
        of "Tue, 22 Nov 2022 01:57:51 +0000")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0025.namprd11.prod.outlook.com
 (2603:10b6:208:23b::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB5235:EE_
X-MS-Office365-Filtering-Correlation-Id: 53a92c3a-6865-45bd-e77e-08dacdce4a46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pSpZ78DUUCY+7z9uBz9hGsueBUIk1k0SO2QKYRcr38ic/WdSZKPWiBWEcmHBWxa60DseUtpir/7XbjDaQhPIEs0E6/12z3n/c+tdwbv/qDRhaslAJmc2Y7Y053vU0Wpg5jiK9S3Jzez75aviQjR+icOJEyrBTrgCny+La9+/E4tUh5BhlGDXF83pRkkcD2/VW62f3qVhswIXTjuCP0TiT3qTIRAaqz8sDpTwmi5onUJYtNIzouTDs6bdRfuwWcYZd5DXaD/mgmvyEFn/GfpsFdYTuIiMnlITlEn/w8EmgAAbcrbYt0gafz7Qf59EV2nviHrDE6d6M3S+aKgKnyZptItS+78KsykOqVL6mvT0U0UmTyyljWANsNQwp3hgAyxl4HGzr/QnfOiMxDZbkUFtwu9MG1Ch9QSDA0WB5WDsrmvm6dMeq2UK/p+GVXkYVqGwO7/XD701y34CVNDGefOrt0w3952zxBJwlN8pDBOUeZEA8BStNtCpBbBE4I0qpk6zJ2JyBAFe1YJyl90UGHQjytNOu//zMmnR0aJHugS/jNCXAydZiCZRJcc+5f79DilbZ6ofM0fT+kQoIgUDZGrZNCbGwpnoayp65slBU9+wlnz0FVp/AKX856PIB92vyc3AjJz8T51X4U3wL6olnH+4mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(316002)(54906003)(6916009)(6486002)(6666004)(26005)(6506007)(6512007)(4326008)(66946007)(8676002)(66556008)(478600001)(66476007)(36916002)(5660300002)(4744005)(186003)(8936002)(2906002)(41300700001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MkTgUvi9Z7Sf2ClsbhSBj9oi0pU19v1Y4+j2dnttQYTBHmJarcKH0OKlwk3i?=
 =?us-ascii?Q?CjZ6pGRr8kf5Zy7fUpMppaTpt1ycO2bu2LLjlDmNPbJex+0uG6jt2I04nwUf?=
 =?us-ascii?Q?i2zZWAqVAbqnJpp/qQYPAj6oG79EVq9VR54mF1OK260x3aBKa4DGwGypqSy5?=
 =?us-ascii?Q?q2m6Yhk0W7S059VewQNvckQmJA9Mwmbe2rp0gEgW1wjZvdT03uVm2fsc/XXR?=
 =?us-ascii?Q?i2gzEyPnYHDQHHeArXDAf64vPKgDyPpm7v1Sp/kptBXLgjqYMqNAlYsdX8DH?=
 =?us-ascii?Q?69SqmvjgHbgHCE6m3m5eRxGKEYjvrmPs5Smy5ARup4hF1z5MnXnv3jo9bxGJ?=
 =?us-ascii?Q?rHDohLYZT7DHb+cSrk9fcEKSnp+m/osQnYyypKzxjvEJWZ/yglJUf1aSIajY?=
 =?us-ascii?Q?ZCOIqomYfgEVXDyXjm3jBc6uf/QrCi0WiS4jco4r647pzxl/vqpCSBZ4eH75?=
 =?us-ascii?Q?A5Sx32zkjAWsO4E3RvaKw/xf+z0YVzTrkIWnkoDAx6EhfmXkJtg9iRlnXEOh?=
 =?us-ascii?Q?yJTvZXn2iEj9wgoIe43T30s17t0l99cdGJXmA/XLJyjsjU4BEzinNvabfbg5?=
 =?us-ascii?Q?WZZhnbkaKrKwXlJxspfN2lg86xJSrR/GJz2+Il1sX7MwXvDPoAXrN64eFTJS?=
 =?us-ascii?Q?GxrUCzNDcjdbjr4RgqaFXrVOtsWoSRLzkV6xEp9aCe7F4rF2EMs3NkMlyoOz?=
 =?us-ascii?Q?iFuMwaXU3fDhRPg8WcTGg7Kiw2we61R+ahAChYeLOIzZZgZ5ok3tRA9x+8ZE?=
 =?us-ascii?Q?LZDNcZjzQFOlUlz1epxRaEueLKN+KNSG/0f1+TLFl0um/EbQOD11yEpnrYdr?=
 =?us-ascii?Q?B4Ci5tuQmu2UPP0uLzDyKhPWdsxzI4qEfClxH0dX4QL80slQpYY1gbbBRWLd?=
 =?us-ascii?Q?4FAooJrknPYm5Z4850YjTDPRiiIRM1RdCFY+i997IEo3q4st2iW44auATWog?=
 =?us-ascii?Q?lRATm8f5BjT4LC1uwfGFxPmsZoB+BbLX8Nd/lKg7JddSuswUQfjTgwtVAI7Q?=
 =?us-ascii?Q?ZCedocrrTDaepo8o8ZLFmgW9CbeWoTBPaNXzT/gIYhXc/qTJT4IzS1zk+iXn?=
 =?us-ascii?Q?bRjhUrl/l1x0VN+JaJBKphQ/PO3L/lsoTFgKxYVh1S1lr/MojujjZeV4Cf2A?=
 =?us-ascii?Q?rYfK5xLn52N4l9y+FxKMT5whHGi8Di3VCDls+FxGc54opO6oV9r/ub8E4Tb6?=
 =?us-ascii?Q?Kxz18uBk+aQSTwt6LGs7L0PL/hC/xMNWfmx0v8+LV0wVDkuZ3kN/i7DfPCGp?=
 =?us-ascii?Q?QROcHL+akkBrB50wX52KI5Lp8yuLjoF2JTdQ0Td5A54efcWj06j3iPxc1aVi?=
 =?us-ascii?Q?kSTK7Ta3F7wSm0YbNiHXh5hgwY+t2wLNHSnsLMbzNtI3XFrxjl4BvAGRjldc?=
 =?us-ascii?Q?tkm7cINZb2dSPjoijP+HMRfLLBu9QtaEA531E704PZcHe3nSK4pST/zy1KaC?=
 =?us-ascii?Q?lqXbJRxGqMxcO7G80L1ee4FEN0mXH9PIK6fBmUWDl3osCYWoBx5lXYqVrFGn?=
 =?us-ascii?Q?X+Q2gn1bP9NwQRI5oZbRPcAPcbw6dsAx6FjqAF54/oR3mMIGLEdK9HBTnac+?=
 =?us-ascii?Q?i2IveW67aIBNpfmMmkHreypTWym5emlEYWAKVQeXSbIe8XmpjMT0u36ueJmp?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?/fwHdsFVM71mACMNy7DE5vJltPsisTbD+eDmyVebYpmt2+i3L7q5WWAT8oCx?=
 =?us-ascii?Q?xhVjGxXi78Sl3COCX7SUvuAr1Zg0blMG3HLeSXvM7SUZdOSaWV8FIjkmu8uB?=
 =?us-ascii?Q?cuoITgZRAlSQz/TiSkL0/BawdEWxFvD2otRVaP/jW2Q5gDKcwIG5+Jq68zGv?=
 =?us-ascii?Q?Hx0lghPGRx+bPM6yAANo/AmXx4+hjHnlQg35M5HWmhILUu33Lyoc2Lc+G/PZ?=
 =?us-ascii?Q?WpOwjVv7dYdDFZHdMe1xLXJntBiznF8N9s6I9JfnTJT0joYgML19++qJOK0P?=
 =?us-ascii?Q?LneAJFN7KU1Lh3h8Od7UY7wdgvyMvFI4MTwdcgc7yGH9Q1Wh3yq1vawnnLuW?=
 =?us-ascii?Q?o0x8/sFlJFvjeJoT3HMNLszyKftrsTOhSokH8+NIEIZr25nCOpcCGwqop3vF?=
 =?us-ascii?Q?KVB82OXr8vQvuAAALqOLizYdoZeRh4xVWDeVf2X4Wpd7j0lXl4ELzYRkdUs5?=
 =?us-ascii?Q?2gmryUBYoBkGOQGVqXn4KHFy2EMr/N5S6BhbVim3CtW1sfaA3ydxMT2nY4ax?=
 =?us-ascii?Q?VlDdeNEtvqKEWzSIQuRjlD7Au7HtVjM2i24Rz0p96UktZhU0ZKmlpdqkBLh7?=
 =?us-ascii?Q?Lqz19liADhhFuF/4nlYauJUdLl76CedzUQqBXjVqBbnPIv/94oJAolvyYKUI?=
 =?us-ascii?Q?VAK2IeNVNY8A5y9tB71+lh2mp9tf5RZXJ+qoUD9hEagKTaVnJy1trT3yRV1X?=
 =?us-ascii?Q?Jb9lOqXUA3M7OZbj3NPDj+e5q/EuHD8MFt+2nXQJ/VLe+19GoI0OMp2Boi8c?=
 =?us-ascii?Q?G/aCD4zbHLif8SPtNjNnJkoniTLrCEgZa5T79vzOHI/ltT0HPy+RY6533AXN?=
 =?us-ascii?Q?4HtN/ZcQilkVit3Vbv4KhVb7I9y46sdicpYKtJu2i6l29O2o/owoZ6c4ZNLV?=
 =?us-ascii?Q?1FRBrPoZMYO6TFRx9JJBepKMJ/3Je5EhgT1g5QQGL4KBmg1xqR9NBvIVqO0P?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a92c3a-6865-45bd-e77e-08dacdce4a46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 03:45:12.0714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HLm9GVvwlc6CBXC2eT8WQC0ePoHV8jtG8wwWYm2MdtCZ4ZBKDC4Oh6jou8UdqwV0E8Ku4I34/xr4GGoKXuPNHzKP0W8T5Wlb0hyyMbAAPNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_02,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240027
X-Proofpoint-ORIG-GUID: rWcv3d_paEzg1rRDPXXcyG0p3QaFHxlo
X-Proofpoint-GUID: rWcv3d_paEzg1rRDPXXcyG0p3QaFHxlo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yuan,

> The hpda_alloc_ctlr_info() allocates h and its field reply_map,
> however in hpsa_init_one(), if alloc_percpu() failed, the
> hpsa_init_one() jumps to clean1 directly, which frees h and leaks the
> h->reply_map.  Fix by calling hpda_free_ctlr_info() to release
> h->replay_map and h instead free h directly.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
