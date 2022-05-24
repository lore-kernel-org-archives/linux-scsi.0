Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63462C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 03:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbiEXDRd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 23:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiEXDRb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 23:17:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DFA87203
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 20:17:30 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NMi4wQ032519;
        Tue, 24 May 2022 03:17:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=7vStz37xPcJ4Xm2d7DRdoum3/bc0MbyziLXi76xu0+w=;
 b=MM94HGpzkabKBySSrAX+LLLpAspDNfyAWRdiGHER6JRHxb25x4x94biAA5gtiBuegHaA
 sZrF/Tbw/fN2I+Yxujlp6NXkZdNKGa3zDFlXLGhPELQv9TufHx6Ayp7e7J7/oFuiSYUi
 /xoXDBPDL7kYXuH6P3kdp7AxgXpr8yEvUvbNw8WwHTmoMt/nwYya+CsHCbGVno3ZhO78
 WUIUw1ptXfKgw7rzK3T3qDcQVp01mrEsnptMvpAxLtmQtGIALd7Ouf1pu4gFRTz7QbRx
 XNVPk36fdBDqYDoykmzPLSPw90K8kmHKI4iMQRaZKsaqT8EG6T4bikvzy8HEt5d7hjO0 Zw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6rmtw23h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 03:17:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24O3AJbX003574;
        Tue, 24 May 2022 03:17:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph26887-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 03:17:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xj/zQzYvElfEYGfuKyWo2HE0naTHrgNvW7y7z5EUGOgkKbSZ3vsNRtJiUYsJCvewN1Ku/fl844Ho41zHZswqCj9kO6+y/hiVfwccajH+fazyKIIlzcANiCuNXu5IP1/UMYLEBzcceRWGI1koWe6xDbLp8zgIbprbcWqXjHcAuXnkY8yJ7CnmsYct4bdpgyAEM73p+g5DXkzSOAYHr3MVwwiekyVEuku0Enak5MCGEcjogV50IgY2+NR05xYUzdEq/4aEYyf7WRjRkJGRnqkKYI9VY1Tg7FLyu5JQFBJXB/3tQ/FQj0eSRjee0J3/teE0wAI0VxpQjuWpLLabLXc5TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vStz37xPcJ4Xm2d7DRdoum3/bc0MbyziLXi76xu0+w=;
 b=V2s0dfoLwFj0qWgHBsP9x2XeDB+SMenmb+rjtRvAuHRa9vqaP2/7rAHoPINL3kdG2XlgJaIcueZflIn6VzVjaV1kdJ1ZGqBE4jof/7dy8D4cvfTQc9RxfrxSKQILecXNYG5rW82lYXP5z0RqWo6cw06l9jMdWg9RuAevHtC8JZishqYhdbpfkfdFksKQxVyfOydQYtHsTAnfSgza7qJ40wqtYBycGbT2bpv9/hNGTlS0jfhsRW7VUn66g2uOm393FKByiZY2GDPJa/P7jKNvSLCiokYCbANgHPhK77zZYH4113Wo54qlbajU0mUMTZSMv53hvj/bsz+CL1AzODfVzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vStz37xPcJ4Xm2d7DRdoum3/bc0MbyziLXi76xu0+w=;
 b=AAoCgZ6tFJundyJ0eK4m7+YarxZIpMTJ6gcgwCbmXkx1W2rZzhHOJg1+KRSf3VKN5dpKssGZzHRD2svJr9/mULt0vCM5gFt5DPFqdetIW2R/yVsdqxtoEC6QUkPYJHcLX8ioHHRUS73Zwr/RB8Lcp8jOoJkQUucWij2OclSDkM0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM5PR1001MB2156.namprd10.prod.outlook.com (2603:10b6:4:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Tue, 24 May
 2022 03:17:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 03:17:25 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: unexport scsi_bus_type
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czg3hb5v.fsf@ca-mkp.ca.oracle.com>
References: <20220523083838.227987-1-hch@lst.de>
Date:   Mon, 23 May 2022 23:17:23 -0400
In-Reply-To: <20220523083838.227987-1-hch@lst.de> (Christoph Hellwig's message
        of "Mon, 23 May 2022 10:38:38 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0027.prod.exchangelabs.com (2603:10b6:a02:80::40)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d79e8bf3-2604-4fa4-7ea2-08da3d33ed0c
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2156:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2156A8BFC243036C4B04964C8ED79@DM5PR1001MB2156.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2zIPWRPqCt1XYtcM+t1bForTezsXiRviMWhzK1Pn6Nd9S6/+z0KNwnWWuCUi3DDr00HEX2+/Rw3CmjSUuFcZ21QVWK15BQRcRJQghXH4IoKtEF57nA0RiW8+jpwjx5/oIyqhDMeFkVxxDII3MrQZ1cWqaQVg5b6FYqMw1nnfO1iPm72x2/7zKxBPFLK9R57WI9P9vsYLm/eaDiqwvegfW3AjAmf4/bkMB8/DxnFbBog5r2y840D9RXo0WHHfwl5gfsjKjREAODAMSZqmfrRyOC+6OYn+OnKrL45jPDqdUSoPiK+6rOIbwDIYGPKtYdva9N7L0hQoEMOA1BiFkYdfW6nojX6RCgfk0ju2I5jtprDKK2N7EZnYikiRjuwE6dKmNSBj9A1KhV+2mysLi/uVUxoP+VoUfX64sQsqBC8USQM0NFay68FEE5oHB4Y/zA318UN83vo55avhBLdPAOvlee7KdCJKqo/NFZKFF+68vXkudC5TQLudQlOIhhILrDhqvSQoCx91zzsZSj6Bu5XW7dgYaeaW27TjALzNAfOLcYp5Qzzh+o8dH9P7dk6hGyfTNqDxzjSvgtt8CDb8c7+Sqz26PSxdV5rmHYCLd+EjdJF8cBb/QCtby+Ue3T0QU5txlgwpXZlawXGymMCD41aMWH6orxcdEg5KcsNuQZu+LbJptcj3QFX8aQjaahvYPsBWlazAFk3aHDKmoEdQBDwoKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(8676002)(66946007)(86362001)(38350700002)(66556008)(316002)(38100700002)(4326008)(6486002)(508600001)(6916009)(6506007)(8936002)(2906002)(5660300002)(186003)(558084003)(36916002)(26005)(52116002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G4p6GNAb22QtFlYekmGaw6Hi+ZPPqTmlOSZFIrcU7Uxp8HaDVDWBtdp7TGoF?=
 =?us-ascii?Q?LRTh91HMCZskBMg6fzfJgJQsvEBvpcj0idKID4HOErAdpxRt3FQT8quBvA/7?=
 =?us-ascii?Q?xzowPc9ASOfl4Lvxk6bqS07aaGld3vCq2b0livLKmiMDzmyd0OagPHToF98+?=
 =?us-ascii?Q?RSiHAmd5GC9cFE+p5aIAi2pg0j5Hub/SW57/Q5s1CzFe4UPAyAAZjjwAtdyk?=
 =?us-ascii?Q?qD2JU9aEMMXyFgs7lxytuMbh3eIqhK1/D71o4OwHfgNNfEzYM6Rcwy4ZYbfq?=
 =?us-ascii?Q?i43oqjGQ96+TdGOSWt/blOXmPuBHgEmNnLbkWx2FXL9DBHPJvNTV0xgZ0BDW?=
 =?us-ascii?Q?wGwzX/IxJpBbvDlAMxNxrFOYJ9682xe9Lweeq/kCQf7/17AsZfirmRVtxTbX?=
 =?us-ascii?Q?CbIsQFN0bjdWXBrbvCxGiJLZkvvVaCHU6mjIQBbMehICYEvn8RW3aADvOVmn?=
 =?us-ascii?Q?YRvQarCHBZPvcBDlVkIPb7sNNRSEpmjpKq7nHidZkti9n2+9WHk8dfX3Z7B7?=
 =?us-ascii?Q?YPMoFlhBNhSjtyl7m6ymvdaw0M+El8nMBK5qutjS03XQzYELH+S6BJLbDuc+?=
 =?us-ascii?Q?XvT49VYINJ5m1SnXbChzaMQ5nVmPV8ykxMDPrx6sDLh0DDBw3lMfOAIjU/y6?=
 =?us-ascii?Q?VBoGDQb8a2Uys69CagB8URWid2XGsemaGJlk/PCuFBxj1OdzS7ovnjQ/Ot/o?=
 =?us-ascii?Q?kfBQvJMI1hS91ep1pZCYhGIYG04tg/ekjPxgqR4MRB03FFH+xXoDV+0beiIa?=
 =?us-ascii?Q?jgnzUs7wpyJ8xinW+lJvTUuf5VQIURV14OA2Sqid127m28cDo7pkwJkIX7Ac?=
 =?us-ascii?Q?nBmjWGqPrMvNyYw82qO8ISrDdcbPRR3OAd0/RcUH8YK53mXxJQyc56+nWSlw?=
 =?us-ascii?Q?ylK+qgV9YH9sls96bkmFfbY5AJUhqMV8AoUHMntoFJEATrAj9DKFz7icwb+8?=
 =?us-ascii?Q?L4shBweDsb7OmWhS6RRR4bqn6PSE1E3nQgFD4EzQvv+5MMyz2YnRGQpaXus2?=
 =?us-ascii?Q?ZxctwxOAlpvpRjwsZNzYM/ZL9o81cY9KeUmJi0aN+gRkLvYIC0a9j15h8Ck0?=
 =?us-ascii?Q?6o7oQetU+NxpMDEupfohdSs6CVrgPwZLDLWuddiUh576hwTcCP5Z3mLTCLG1?=
 =?us-ascii?Q?kaZ9RI+qUNZ5q+bbdDd+yHRxGlRO65V7E8kT+Kxfcz2GCaLs83P8yJhBjQTI?=
 =?us-ascii?Q?nzdVfG4tSUeBNcOX/oYKpCl7Qjv4728l7+imY47L8+LEc93moEP51qiEapB9?=
 =?us-ascii?Q?VPsyhPsbBxBc/5wgNmw1Y8JPV5T6k3yT2wF5SOFXOIsu+145+afts3U7AN6a?=
 =?us-ascii?Q?rMDteKqJ0T5x35esAtG/To04cQQAR0eXlMfV71A3J0/RlA/BYysDxXOQS0gx?=
 =?us-ascii?Q?z/8S9Bm/Gz2aD6pTuALx+2B2O1ORui7Ig6hxhmX6wwT344AT7w15/hp3aYD3?=
 =?us-ascii?Q?/tUFFAvlYFnAhGej1utjYR+pAfufvpF6kpvQjouMiKJB1wQ0VfDF2iLP5HYS?=
 =?us-ascii?Q?FUJ4l2NfXYxB38JvdcIVG3kUiuq8i2BVGpEzi0c98Py055BugA/ilvJMGCOa?=
 =?us-ascii?Q?kE2Q1k+1CxLxk+YoQeLNuBaJY5qJGOsefTuFV7myT9BS+dQUory4vq1tZw9A?=
 =?us-ascii?Q?i2V+u9fUnPUsLQoPHLNx1mII/IEGNJf61qNPHJf+XJZfyKUmf8EH9rYDDzRf?=
 =?us-ascii?Q?HiE0SVsZVunYuS5iVnybvi73bNy/TGDhXU+QxzG2QiroKDbcywPKSZWy9r6J?=
 =?us-ascii?Q?MNGP5Fl5XJKm4dr3ktB9R1NMNgj1zsg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d79e8bf3-2604-4fa4-7ea2-08da3d33ed0c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 03:17:25.8491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U8CBAK+CRFso+E0FCcCQEtsZao88TyPbg3YX2QkIXiSI9RkxMoE1B+ZEFS1LEU9zVAHsVoCdIkwXl9LzyAtwBqYT64KAdJHfKlKTvRGs4mE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2156
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-24_01:2022-05-23,2022-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 mlxlogscore=727 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205240016
X-Proofpoint-GUID: bKa1cQv-xnELk0md18uaeoYQquC7s66F
X-Proofpoint-ORIG-GUID: bKa1cQv-xnELk0md18uaeoYQquC7s66F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> scsi_bus_type is not used by any code outside of scsi_mod.ko.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
