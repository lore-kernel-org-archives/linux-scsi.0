Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC48EE49A5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 21:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjHUVO3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 17:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjHUVO3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 17:14:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE27D9
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 14:14:27 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxUoT003623;
        Mon, 21 Aug 2023 21:14:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=RFxwODvXxh+uOX2ULs5dHrF4Xa3r9JsJUebrsNfGSAI=;
 b=iPm2xWTXxT8RDk6UftKeK8GPHCT9ULpchfgLDmZHcdTBzJ5j7qu9I/CzoIAnySQicJrj
 Nhs37MM1XTHnanxGBjlPz7lc2e0dmQAWRhGF3H03Zxz5OQkLa5e9iBGiXPcP0vHtuEAs
 jpRRyBxqNJN8SA+5RKX0D6V9w7Vz+JlWjYFBCu/YPaZM7mn4Mo1g7Rzm/d7IxfGrC5Ry
 /ms7Go1A1D1VQAQglps6iiO2recuBpk8RDn3N4NqRRY9H2Zpn/8y9RVI6lGg9gjzDlsp
 R7z93gPjm4FKfhwVVqLicqBYpgX9cODcCoRguRRKLNJ8Fl2LSxEp/RCY4ILvQYVnGXuZ 3A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjmnc3wdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 21:14:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LKFqMm029854;
        Mon, 21 Aug 2023 21:14:19 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm6ag4ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 21:14:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOtDTXgNkGxdRQCvAQXK3pqbytI4hrG/Cp26/x6Pi1ZbQP+k0dd3Jh/bI5dNDM2znoO04e+MmJ/0mwjMTECh6m2zSDI/XjTouwHAgmFvoBgYg1QRW4PiMiOVezTUZx8y53O00Gcru8wox3PVhxPXB/gc2+BwNCxYWbsvwNceG2FZeES6JUyOAIvOvoyxLp/h9Lv2d2nsLRuIn5nIFs0pWD25gGeNErWEW9cZNyXthUUmTr3C8BAZngN4nS5cGMGzrIZIepyMxdCkeHOFxoZwlH1FFQBY9rXIMuzh8V3wEW8oPJVxDY0mHbxS75RYXHI2I/Y+bwLOAUIal/JgoHy3Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFxwODvXxh+uOX2ULs5dHrF4Xa3r9JsJUebrsNfGSAI=;
 b=ggZ8dfDvqe7+2CZsnBVyaLxaKWFoF+c2KvkI6hJqrgMimMvvEvGJuq7+uIVlL7jEqvpAO/CRDhYl2L22JtpTE+6XvncKOLib+Tk5+Q36KGurJu8gxC9lcC+4f3nlPzDDdLyzZ2oVPnm4KNNcQIAsi+7wfbcRkfC1/8MZrcFkwhdb++BDY2FsTZSi4WcOJUhUU0ZcWrnq2KHvdWl7GlxOmBcA62kjmFSKvJWtXfgIG63BFc3jlFTiIZsOK4RNs+aH4qijXjtTQdkz1g2eIWTXcpusZ8EI2R6wAwxWf+OgRwPJN9fKs2gmpSQ+i8eBaCm4AgRupZbUKiOjNiEgeuZFhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFxwODvXxh+uOX2ULs5dHrF4Xa3r9JsJUebrsNfGSAI=;
 b=aoWu6+R/9old4nP5DOLoJHH1Tc0/EyF0YfLingnhlC5YJcak6NBJTtz2lxvbRPnoQBXkez31GVmQh8nEMQXYr+x9++eB5JhNNEgPqryPj8HyIucxv/RzwioI7ksZ/TNAufSy5ULGx68IXNJ0PmFmNrq6vmpFIPNoftJT0cqCw2Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB6446.namprd10.prod.outlook.com (2603:10b6:806:29f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20; Mon, 21 Aug
 2023 21:14:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 21:14:17 +0000
To:     Zheng Zengkai <zhengzengkai@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <wangxiongfeng2@huawei.com>
Subject: Re: [PATCH -next] scsi: pmcraid: Use pci_dev_id() to simplify the code
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zg2k5c9r.fsf@ca-mkp.ca.oracle.com>
References: <20230811111310.32364-1-zhengzengkai@huawei.com>
Date:   Mon, 21 Aug 2023 17:14:15 -0400
In-Reply-To: <20230811111310.32364-1-zhengzengkai@huawei.com> (Zheng Zengkai's
        message of "Fri, 11 Aug 2023 19:13:10 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA1PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB6446:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e05dcdd-e16e-4704-f86d-08dba28b9434
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qr7E52B0jzw4g6ul3giKJx0cOAgmeOlZTJdnezoCQNbWK7pW25yJM4XXl7NY/b1eAM5+VTidnZHbNLjEpAeOcxrIr/5SeySyHO7hfgi1LgYLjMo63N8f+KRlQxwZ9X9HkMLnwXoCjsiIsaiDGYZjVIBgIXNIc+R/ZR1dtzYCqc0TCzPbMAWo2BRlVSmwlQGcdtqUmEsEuXzaIA2JIihfPOvJArJm6EFKABX8U4PjXOaSWEusFIS082P31eLKJD++sa9QD/sMZCpF1hpvAGnq7sLKCA/XJ2aFsPxyupVtUpvWo4yatsYZO6AlDIFo0Dru0NGhdKBdGM8WecQOZB4To1fRP1MtPnAhKos5MAeyGl4vInn1PD1+ACLMFeHCJM//JSrnIhh4fn/WA8PUD2lp2XjsEtcHIodz3lNnwgYPhyLp3Cv9VQ76LewQY6tzwMXqn3+JQLV29qUC5ArG/elbXbKLRGFa7juaNoVYIunh09GKOEmEm2JZ87SZd0KJHCvF7KQM+YbEgim+3mD1CUknhUuxijKb/u5ntcNSFS4Yj4JtCuS/hhyQVTquwkN4QBYG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(136003)(376002)(396003)(451199024)(1800799009)(186009)(2906002)(38100700002)(36916002)(6486002)(6506007)(558084003)(5660300002)(26005)(86362001)(8676002)(8936002)(4326008)(316002)(6512007)(66946007)(6916009)(54906003)(66556008)(66476007)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Z9SKqjhy+TO1W+2+mtS+XAAljxNrgubeLhuz1iikpWLZ0huaiw06Su3M/S9?=
 =?us-ascii?Q?FfmJvOVOlSxxzXUgo5AdH/LEQrfndjIZ7Vf1z5/QWXujJPMM56OKH39Dte97?=
 =?us-ascii?Q?N3cq/LDMK83INghm/XPDN3HNTI30RKio1cBS8vPYMxt1FvIFnqflJPJ02PqR?=
 =?us-ascii?Q?esl4PVrlY5jB91bM3rhjfnAearWu7WUB2dLJO7+PuyhtLi6gSS/U7D5qoJTl?=
 =?us-ascii?Q?F1Vpjc6EYWef//bYwmYs2C258HCYku/VpvmIOH7J87zPk6C64ZKZFFS6lqAm?=
 =?us-ascii?Q?nUMUKM5VDP9aC6PR/sckWpi0pg2d8O9I0yHbGihXNBYWTOIEamfFVXd9OQBj?=
 =?us-ascii?Q?ihKxVp+yJUbQ3YW17R3NUCuESn4owKswuhA49izdzycOUbFaNuJgGkQ6UuZH?=
 =?us-ascii?Q?FtEHPE3IT0alrmvjDQu5sodMCDOUjoENJyYOvlECL0CJmhlpWNDzj382mLBB?=
 =?us-ascii?Q?B151Zg1BlMsQMfxu4fHl30dtcBokaSBsr9d7R0JSOQixxwPtld7nlDKHGCcs?=
 =?us-ascii?Q?CU9YsiiBGmDFlNSrMbq6X300Lt+woEwC0T0XQUGc9TXyrv6lSW+lkk1RFIqr?=
 =?us-ascii?Q?aIOoUgHSjV8X/X7PVCpKma3jwk7/dZ6GtSPCLroqRiOxVFy4o7SrTa90vWHj?=
 =?us-ascii?Q?U7EWT/AGz1ZWLQhjj3G8XRWFNywbIMW2D/eOy6Bde1NqOSiUDumAjepHaqh7?=
 =?us-ascii?Q?5KomVeMM/OGb4lXVDI9Uxdgmegc6dsL8/nIbXdhLA6LwoNscO6GR/cw0/1GR?=
 =?us-ascii?Q?HmSPfHozQGzzi1AyIk7pJDSjTuvBrh2LtELrD50GZMAKgkvMi1VBEjHjLe5H?=
 =?us-ascii?Q?G3Ew5zPWZ0hWXKmRv4ire0m/BSzGJyOtbjmYEmgjw+yUCS247necKfg8dIpO?=
 =?us-ascii?Q?DnWfLuY0TBjpdDPHzRr+AEAfWwunJ+FlKhgy5UlxYid4oz5fKmPlDOzI7xE6?=
 =?us-ascii?Q?dAl/3iH7fXZ816kjzvtxLEPQeIvFnhuoh8sKg1M/1e/JZ/bXfJCi3awMwqJG?=
 =?us-ascii?Q?w/Pzz2EmCBVv8+k7ZflzDWPJk3jzuWPjy1OIDGDdDgmjHpOvRVWU0v37Vrgz?=
 =?us-ascii?Q?nf3j3ZJMRooO5BB8HqiAnSJ03CWprMBaRZDkgmqIQ07t4GCsFmrqefbUzTmV?=
 =?us-ascii?Q?eS+wiyzjPAqMVrVhEe/MqNFvYcbxFjc0tDI6oAbtOiyutO6MHSEgSgIEEg27?=
 =?us-ascii?Q?A3rj1xTqnWIFJCa5ZgZHeTnl3HSFtVCCliZ8vzEdLl95+TRYfQO8eh/SQSwe?=
 =?us-ascii?Q?Pq/edX0zFBcpUzrJq6bhMbUbg6aCgLpR/IuHb6/8/BVqqG04DnoUtQApJJYj?=
 =?us-ascii?Q?Xw2vWfwI4X+XhqSyJ1CGdJpgpw2CZ7djm2GTVaQwKp/YZ7w7zQ8j8XQePPkd?=
 =?us-ascii?Q?lKDxoo+G9Zw7hXuIFSCDvPH5PFdOPx5JNlUNM9zLacA9DzCJIcs17EvXEufM?=
 =?us-ascii?Q?O47H7ftrJyiQ77NXROkX3PE3xx6+NttNFu92W4icHjp9eM3xvoKjdnlJdZW4?=
 =?us-ascii?Q?ZdkKvla/u14vPqRnNlJLszsePdIR10Qge2Foz6ysmMy6RIFml0YhzCGcM70A?=
 =?us-ascii?Q?pyItZ5/P9g3rKgOXR7jbXEVmzRf5hlmTpZS+FHx30E4WjJ5pX6CGUxpjhSLX?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bgOAw04ncrlnbGEOcrur5QvAjIbJ24Lc4qqMgBb9YFkfb1iq6t+rx+OURnbx9qdz2lY25YKAngcbS2BRqcAZWer5ejCZhEoIY8HeLDH1t2OAVIBz05t/0PqPggX+fW0Dk27YvZ53UL8kO9FI24pm6jEb+eVBS9HmIrCQc86frEMZvZtD7QeIDv5ZdMcqvQTFEF7m77rPou+TwPrQwjBOuqqQmc/nscDMAY5KfUfTWpFOxgbvczGS5uGnbhdsTQ9WWm47xBk0MsukXqpx4e1r44P1KQp7Oekca0x6H+7B28ruLX7No4SyJRsTI/ZnBivMtm3herd8tgMFvthctMHuJt3RSzyqJ9y9wK+fxeZpmaB4unA31nbn9kpiHRMMV0TxXMbWx3c4L8glMhB0FnVIj44VmQbhtL3r7Vs8YWPbmaZmfFZI3dEY4e5fdUt0E02FaBZArA2/8Kv5HAedUH4ksUQqfRq65cJDW3JpQbq+c/YWpuGLF2Ckroksne9Ck1bZ6Q8c4eF+1AdCAyw6pHX9dUjTy4P9SuNUyAWgQNlbzk6glRwrW2JpeFA6btnpqFbO5KnqOdu+Ao02VUJFDileIHUcR52SK9cHQHLY1BLh0eorwEuFay6PmuOZNiSpu76GLuGbpg+c2w0WMrTSNRw2Iw9p6oWQAv5glaCWnK4JpY2qXGr4OSV29nIIZfkPHU2IHr2T8FOXSz55gk/kZEpfQ6Zv7+BAn0X/VFdLVAfCj7dky695kzB/j2XvQIf4CCvK+BtudKj0GUEqmTyaOll7Ef57uWkCZp5iWwTygol+/sKxfRItHZjZqg+KhYE+hDtpgjLGdST/P1EAxE+et9QrbQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e05dcdd-e16e-4704-f86d-08dba28b9434
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 21:14:17.5042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hTwEGypaJH3UWBx9HThcGJ5DxfVM/63j7z7rz2g+mhmZ+k9F6J7JQixrnmWl0cN4OBaDy9SMUKuhlM5HBz6wlFbV8VCFidD7Y1V6IvQ0mRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6446
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=855
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308210197
X-Proofpoint-GUID: LhdznT29UdyvUBJmZHghiFRkoad67H-j
X-Proofpoint-ORIG-GUID: LhdznT29UdyvUBJmZHghiFRkoad67H-j
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Zheng,

> PCI core API pci_dev_id() can be used to get the BDF number for a pci
> device. We don't need to compose it manually. Use pci_dev_id() to
> simplify the code a little bit.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
