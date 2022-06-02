Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7212C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 02:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbiFBClx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 22:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbiFBClv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 22:41:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232E113E2A
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jun 2022 19:41:49 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251NXuKh021216;
        Thu, 2 Jun 2022 02:41:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=9HnnHPiPOnGQEFi28afUWyM9GCl+5R02k/KvHmz2g/k=;
 b=Ywn6oRsv9+59Y/Vky85W6g0jkzkPiK1kYYSsPtTsbBYDZD+n2+My1ObHhVhHbh3MgPAj
 n75MEBwZXJXN70H0/5F2/SxBkkAS7tiN1twlyozjtrgloYmQbBUfI/+FQ9j5lUs3Bkjh
 k4DUl2EYg/hDC3KmrLDBt8y6BtEtgYubWZ0G+LCPvKqxZtvjqs9DBd6eoRUKCtecmkCX
 /Kpezt5gWokrfS5X79iF84cSQ3lPfEnD3Qn0VXc7zHSOX7qs1JE0+J24kCaIPPAgr5hU
 aOaTfucnagzZ6VyzLW+uvLuMrtQrQejbu2hPbhRGywhhynwcMfReE6PtHxSxd3DwB/eJ AA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbgwm8v8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 02:41:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2522dxND010921;
        Thu, 2 Jun 2022 02:41:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8hunq5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 02:41:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0mOCfwyna5JC1m3KP47sHJgLe+NlwprGv+98Jo2HJXk0SP2oZTLVCynXYDBbWrdymp+m/f66wiY/C3J+iHU07ruwwvK1yMU04598s2NlBwIHmnndnjm56iJppPLXKvJPWP3EI7UBFwH8bzUkiVxCMrhk/CB2lJJ4wC2fLfT0SPcLKJ4fZz1zzEkOhvXIfTajsGSW25MoLL1Vtd0Rbiih9NJE2N2EcdSP4o1qlLi6xU7FhfaEiwwn154uIe/Yd00Nagw08dTT0dnKi0w80Pqf+W7RhQxbfxYt/MYDDn6vFKOT2nvPdqqEB34QpFj/TmBlhbj2/oMprWlHD3mIZkblQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HnnHPiPOnGQEFi28afUWyM9GCl+5R02k/KvHmz2g/k=;
 b=a77RcCVA8FyI13q8W0rE88orPpVwoNzQpdooKg1z3fGmvfL8Bo7gjFIFuzHuTV071ifWQUkSmcwZKV7p54YYOOpaZFLaY4z2J2Vt5NILD/0P4RwT2hEkeurQ3xiXRB4SBxUTyUXbJ2B19LogH2CO86TqhJN3CKfaiDNn3hMiFKNO8iTDTWwQdrRTVDLdv3RWXSmAsfQwHVCb4GEOUlfcPXi7gnYSURLa75p+I8S7N331mboNoNs0DHRuLrtPmfccjQwl8ayLNVS4HE7lRwTWmr9TksExa2gwCydXsEAARhxWmCQAn23cHec+rzjawImKV/Zmp81Ca30NeFSK0SBLFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HnnHPiPOnGQEFi28afUWyM9GCl+5R02k/KvHmz2g/k=;
 b=NsnfIpMUMEbKv+RhRcqEAAQNOAXUSj69Wxx1miziJYEQu1NR1GBG6cNwcWOOortivMVz/7lral8zH1QcYttktZEcqOmnNfGJUSCZsT3TxUgNE0A7LYpuXAVz+Yyb6LL4RJY4hlSnELQI+bUL8dDs9Gxwoxon4P/6sqs2u4j0gc0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB6158.namprd10.prod.outlook.com (2603:10b6:8:b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 02:41:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 02:41:38 +0000
To:     Bradley Grove <bradley.grove@gmail.com>
Cc:     linux-scsi@vger.kernel.org, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Bradley Grove <bgrove@attotech.com>,
        Jason Seba <jseba@attotech.com>
Subject: Re: [PATCH REPOST] scsi: lpfc: Add support for ATTO Fibre Channel
 devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135gn6b3b.fsf@ca-mkp.ca.oracle.com>
References: <20220524125621.47102-1-bgrove@attotech.com>
Date:   Wed, 01 Jun 2022 22:41:36 -0400
In-Reply-To: <20220524125621.47102-1-bgrove@attotech.com> (Bradley Grove's
        message of "Tue, 24 May 2022 08:56:21 -0400")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0022.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2dd4b41-ccec-4b86-8765-08da44416b12
X-MS-TrafficTypeDiagnostic: DM4PR10MB6158:EE_
X-Microsoft-Antispam-PRVS: <DM4PR10MB61584BBBC04D98DCCAEE50958EDE9@DM4PR10MB6158.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5cra3pkqNbmUsobbFaxuzu5WHOKBD2W8pFB5zOpBbzOP587wDj5LKVdxu3TDr4pHJR5X7FLcHaKTkJFB73HI/XzTYy4TrkZkvJrE43fWjtuA/rhN6pGS/JQJhLR3Wc85P5aQYVAhmcXTWmh2HTXAIkg9DFR5dMxMUyAmG2Rd75FpC37HZ0iMzIb1ryxX+CQQyEkvgmV/xRmd4YXw5AU/BhaD1VIK/ho9tU3IOyNPbsZ9uIbEYtrH20CFzB6PLvxLwL5egRhNMab+m5fvj9wJHl/5TdMVAkesmtJf7dB1Ngeazrn5Oal8Z7qEodsi+AuwGQD84p3L5rDSqNTri2FaOYjGmbaDkIYw3hW2/HcpdQbX38O4Y588Me0Nl9G3025yiXn70eHnN4zn5i8qkHWosL4kaiZApkf7IQIXuLR7zc52Q7AgnEyGT8DVygH0K5adttXGhwujKnQbRGZDNSrBtmW9VHGans+RY6eklqAANUXkyYJeKKoKBDX4Wn49WexcdiW6g2mkVT4lGo8KTw5dNfummgUttGOEvIjVVh6BAwL9UPfOt1NsqlyT16qeXoo4ixpQpqPptiY0AHfL0jpIdAshgdQFEBk5HuFQe+S2qMcZ/x11kx/i9VSg7t0OHMC5ctebIt28Dc/598SkrX5Hfj8/9SV2pjzg7CZavMalbUhSNKv3vKdrXNA+ahWtmEGmr26H6R1vbVsO/Kziflxxgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36916002)(83380400001)(6486002)(316002)(2906002)(52116002)(186003)(4326008)(8936002)(86362001)(6512007)(6916009)(5660300002)(54906003)(66946007)(558084003)(38350700002)(66556008)(26005)(8676002)(38100700002)(66476007)(6506007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G50rerxGhaT5ID9SzyNFOhHVN7KYFLuwLvwOf675/Uim12iSw8jV4EWsJI5m?=
 =?us-ascii?Q?hBlidf6aTMlxYZebMpd838B36fZno0oCYgZPjfKQjOUS6qZrJI0L5YmKdtod?=
 =?us-ascii?Q?UVTKdznQCt4MD05TJGr0Ya5+/wYFkyobCQ8DbRLSjSI781FX7UfBOa3FT7hz?=
 =?us-ascii?Q?qK6RyZlxVcKYWrOKE5Nu2fjGXIwl1ZjSuAsBJreD9rACmBDR8MyxlQUfsJeH?=
 =?us-ascii?Q?5R5Rv91gAip69tvt7bbyyNsSzfzJQwcppVkC50B3/Cm+uJYV6vFljX4PtA+v?=
 =?us-ascii?Q?3Iq5IU4c5LTptdTibhRtnRFGICZh+MI+1b8SFq3/5GxDUKdRc/NAGVt9gs9r?=
 =?us-ascii?Q?Jtf4SWknhH8gdUrQQR/pykPPSC8Dt8mdGmn+zTwCgrbhL8lHXD/VpDIyCR7B?=
 =?us-ascii?Q?6HtfoKH1qH/ZySZfOqXQCFyZccKCiJPQCvXIHkzm4wZYmcUVr5jGUXctiTky?=
 =?us-ascii?Q?AbpXzqoxip6J42J29osA/oF5XwDesVPo9gzUAFCdjn5NRjwuym2sBeVVK6mJ?=
 =?us-ascii?Q?zSVcmX/wnLEviSwHIIl8bX0pgJpOXrb194VcO81+Fn8DAlBYVBrydzjc5KJ+?=
 =?us-ascii?Q?1ZU7jBf3tQFBj5ktHAdTb2SU+f0nPovbQST08rfk8Cdrs6ky6kmg5UYvZ1SI?=
 =?us-ascii?Q?BmaLonzeAnaseZdfwfQmZQhgGtcHPGR4k3fO4Lhg8OJI8OOt2tKX1M01N2KD?=
 =?us-ascii?Q?gxHo8O9pK2EiUBZY5oHryVATYyXHaByjNd43cNNR1Hbs8T9pGDfBhEbVDafy?=
 =?us-ascii?Q?DXv1y3YCMnionLJfv5lqRzFHSP5jxUt/fBrz+ewVbAlPJiEtttTJOLVMFy2M?=
 =?us-ascii?Q?kwqJlqrOCsmxUu6RqG4Ub8dmUu4QidYPlXAoWhqjuuOq+Rcxt9F32/pXNWHC?=
 =?us-ascii?Q?gc2qtrnnj+JHsObkcvfa+cr0W77QWEY0vleiUL+utM53S79Rc6pP/uS/pVBI?=
 =?us-ascii?Q?wj/0LD4clrev8qq2RA+xprYgvUE3xRTj5F8CqekzxGrpHfe/pcRYuOtSj1V4?=
 =?us-ascii?Q?wv/Ic/cssOwJSxlXqdc7HAr8PfRDMzqRL6yZQ+NDxWD6TFLBmUrz9u65dUMi?=
 =?us-ascii?Q?k2pQEkaFlIM8+pTxx9OTxN+2Ey9nljBIIJ2E0XM30ZIFy1H46yY63LNHlSez?=
 =?us-ascii?Q?rODZozaxBSKcz1zPNcJjP9k6i71ldmsHNopyDkNVJBGBYfTdg3dk/b9B8696?=
 =?us-ascii?Q?90Hx3nCgmocx1WjQ2IPizjoz2uaVo8MPORf5x1HELDkkwupCGWrePd9gpzso?=
 =?us-ascii?Q?/5DrSKqsrTNz5gln/Y8evLYpohsXujxUjO+pZpWdsGvffaEE276dlIZVYq65?=
 =?us-ascii?Q?tiE+xlvcc0FfGUdJEep75+uEC7g5c2ODKTfzxMGJvqcM/FtJ6X+ANvWKS1Y3?=
 =?us-ascii?Q?1XWC13VhwNCjknJxiOlbN1gvDeCgfpC+kFKpUJGz16+5u7Nlyr7CB6F8ygzN?=
 =?us-ascii?Q?BH0M/RtlA1YREQO+/ieMwV2rcujWm8n+5MjWqBRarg7PHNJJ2AacW5+5LwYH?=
 =?us-ascii?Q?4KF1AqVZ0fzQMgJsACi3wvIDcFG+47BIwtrrgcYHwgZQba+6Sz5h97DuzTia?=
 =?us-ascii?Q?vGCRzbSNnFwQbmVwj5yfK6eb289IZaVzMyxEW9ZObfLoe5NbsKyvMeLXQv4y?=
 =?us-ascii?Q?2exSyvKo8Jqs2xLeJQT2pdC+UtJQMwnEowdzZQOyBD5CKnDe8dUQYSmY1jA8?=
 =?us-ascii?Q?FnRIVhy1f8JoEFIVmBTw+UgqYD7yMockE+99fYndVcRs+gQ296crc54QueKb?=
 =?us-ascii?Q?LqzPbGLZZlvk8qgfZ9dcUp3gPzMlESw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2dd4b41-ccec-4b86-8765-08da44416b12
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 02:41:38.8473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ea+y5m++endB3lLT7j6Nkzqj4w5D51N8Z4CfqWuqlZZ/oh9MR1eiLGI4rXYrQOCTmiRpiqManFr8g5aAHtXF7ap63gp4g5ldU0aT1m/Zqvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6158
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-01_09:2022-06-01,2022-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=945 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020011
X-Proofpoint-GUID: jgsyIEfG_rbFT8e0kUloHWMZZT7BBZEk
X-Proofpoint-ORIG-GUID: jgsyIEfG_rbFT8e0kUloHWMZZT7BBZEk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bradley,

> Update pci_device_id table and generate reporting strings for ATTO
> Celerity and ThunderLink Fibre Channel devices.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
