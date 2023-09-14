Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 031CFEE0203
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 00:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjINA6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 20:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjINA6p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 20:58:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725A6193
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 17:58:41 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38E07wFa000719;
        Thu, 14 Sep 2023 00:58:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=EGYz4FYUhtBk/TeZYRWl2VpD6HjgBFJ3Vzs0Kl+qwjc=;
 b=mUMjLGXKorHk9kFv5qm/IkaMJDBy6BFBwQqA5X+ZTyNVlpwhB62nGIQJrVV4Bub6bGfr
 Q6u9wDy0x9Vyw1qS0Oac2pwFUTU4JvmE8UvVqbXc4MhcSNShLloTQ1gwqsJkr0HriMYh
 WDRVf6eUMv7amBq2M4wl+coxt4QpI1oEV1EGLvnOfCi9+MOACbSUMfI9nvEG3Ys6ouK3
 70MXMreDPfz1KWp7mU5+C522nSc1KQr6eReyFDsq2ygrE33Fp1uvFles45SnYM9uL44B
 ls2Lw/CgKH3PO9yeOD2JKetC3LEGqjpRBaDYB68P5jF+A9lpHV1ye47x3nl5PDUjKWfA 7A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7hbk7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 00:58:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38E0021P023051;
        Thu, 14 Sep 2023 00:58:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f588gvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 00:58:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CCvoVFEwVBNB2y04RIMQ9BXOPJ2TYlhz5g60Y1/W6BTm+dpXoQfprYgtWrox2c0dFCap66CTDgZh3PZqKd8N7B/7goWlp5D9JWMLAzzKc6j/ARPkMdgHFVhUe47G1AVvgMvGNEtTDW0HWnqtwWIenpC55f6SfAJ4FD66OLjMYbq+/hHRXZ8TdfzJHIwSZ724FuudYLVEaJCvjHbpbgr1D830jgI/4ada0MqXemkKoWKdyDNOccvv1bbW9dXsCmfgfDP8rpckTWznNI7FFNEx6tjYkvN3GWSjL0NEd1zpbQ5MCJ7k6bjTOsSq4qtXu7vgBh9u7oSqlgEJV03ZJsmzTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGYz4FYUhtBk/TeZYRWl2VpD6HjgBFJ3Vzs0Kl+qwjc=;
 b=QSCdcVwimmxvp5/xqr0oLH4tWFBxaHmaF1vk/VZaYY1Tpf87o8NERo7kVfOzeT1L//paMjLF804pTO5zE+0xuxvFI7en4H1vyUSd2xQNiSAYCtd14EfpGDU/FVFhkA87VWs5TRyN4ECHcA5gPx/2ZvLgDCC7jfZawsWosILB5l5BHkG5BJet7VY9Ar1fB8Ka69kBeIW1qqxXeSkDqJjCA9Zbq4WbbnoO4A5ZCu11bmblvpmIsCAmYHtprnD7QbTaP/HVPcdpTKKu7OLQjq+Fnz/f1ijkXxyNm72QOnY3comQBd9pbsy6igTiZCgBkDEPvar6v6zyGZWI8+uFF0sOzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGYz4FYUhtBk/TeZYRWl2VpD6HjgBFJ3Vzs0Kl+qwjc=;
 b=LCx2pvQy0vyurTl899oYHK0qy40eMhsuuJP4JboAO0c4M2wQmUH/2PabKKEz9/kUMwptNc+vvgHtx3kwkTDi7nk5y29JwGiDWi12k0i9/zyvRmcCmPvs+w4HcZLa015YkX4h/RGHtJ//bikv4+irkr26Sb6s/7Rg+jETp+Qt7Hs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB7208.namprd10.prod.outlook.com (2603:10b6:208:404::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Thu, 14 Sep
 2023 00:58:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6792.019; Thu, 14 Sep 2023
 00:58:17 +0000
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH] qla2xxx: correct endianness for rqstlen and rsplen
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pm2lfu6l.fsf@ca-mkp.ca.oracle.com>
References: <20230831112146.32595-1-njavali@marvell.com>
        <ZQGqLUEqQrJ+d11Z@infradead.org>
Date:   Wed, 13 Sep 2023 20:58:14 -0400
In-Reply-To: <ZQGqLUEqQrJ+d11Z@infradead.org> (Christoph Hellwig's message of
        "Wed, 13 Sep 2023 05:25:17 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0030.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB7208:EE_
X-MS-Office365-Filtering-Correlation-Id: 05587fd4-7638-4388-a30f-08dbb4bdae9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DxqcCdJMvT2GAjRoRJa01WzcidXa0UBXGm2aqMpGgcLPdQfx1pVVusQzOl9Nl9rAuV/tdj3x9l7P1dAOavQHYd4krWR1cg7oZAkR47EpvgKlslp1m85nPZNTmAIjG2dIYcVdsU/YzNROCtHJ1g+qsI1q7dmIOxQ6RzzgyY7a7ZvGkFG6qTD2cnKAz4YflC6AprbYQIpqKZy+ce7L8ojH+g7SopXAH38+Rmo+VLnATZoV+alkEbEw1txPSAR+wRrLN8jvVIpylH7sEsOMgac9/OpXrEaSnk78XGGQ9m3NSMwlzUw0z26DPd0oxhnezwLabsI2dUdJoxOj5Dt5CkSu5BiFkNxLXCLmy4vi3+mfNZTqAtneueQSrOC6XCm6xObjzysak/XUdyYvaFQfDa+kvkMAwevXZ/LMQr1LrF4qPm/N+A0f4gSwfwWd74XIbwC+5Ukhkp5GbiAS+TEvyDKX2tZpSMAk6iJHKf/1fewBQtUbOpg+0a4ktNqSRgGqi6oQQE2iOETkm0Q5cxBz2LpGIb/17ZeO2qmjA1ZgQc+eGpRw9ARmn8898HADT+S7ZrEJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(366004)(136003)(396003)(186009)(451199024)(1800799009)(41300700001)(558084003)(66556008)(38100700002)(26005)(6666004)(86362001)(66946007)(2906002)(6512007)(6506007)(8676002)(5660300002)(316002)(36916002)(4326008)(478600001)(8936002)(6486002)(6916009)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P+Ez3/O+penOyTNWSrZA3fAMcxg758x64bOK3X3/Sr9Krk/KS+irD7cWVT30?=
 =?us-ascii?Q?FJi773EERTclpHXTfBcQvtKE0gHpSbuXLCT1Ksh4/IWgs8S5pe2Y5bfkH9OQ?=
 =?us-ascii?Q?zOEmPdh9Y1r8BJ1U7msNb/lhh1GH+i1p1Jz+rut2GVTQGggWTMYh91CbWqqX?=
 =?us-ascii?Q?xpR9WCurXmU8QwNv8AHnqKm7d66xiJF+50wO4E/KS5RPYDoNP36mChWL3uLY?=
 =?us-ascii?Q?6kqMfV9uAMPldp5NTDl/aShB7yz471MfjQvloSdLyJ9/Kgm9Z5OtdOloLq8C?=
 =?us-ascii?Q?vlRc+mngCH6FiWLzi+AvNlGREHbEDz7TCgasHHNgp2Tbiy49ETtIIqgAbNi7?=
 =?us-ascii?Q?te1SSPL/5lYChfz/54PUs43v0wSpsY/SjY92LHMZpRwwXjlAxOysFdugq+Wz?=
 =?us-ascii?Q?Kr08AFfwEDKCzrsxW3E6WEs8JcpC8gvzAJjOJHLGIyYr3e9A3UsJosL4gTeR?=
 =?us-ascii?Q?4B5eFR1E0wrL+Izj8kvSSNhM6JPMsk2m02NVYeaH2qLeXZ/5F/bu+D2LuFax?=
 =?us-ascii?Q?zZQPXN4XftCEI3ZvYF09N6WWlfTHV2yFXRU+GTONWjts9YNWbbZ4M5hN2doL?=
 =?us-ascii?Q?t3KDf/If88Zl0TTGKfdaf37cu68CQuUTmGgpoGluWGJbMRDVYDj3BFly8MQj?=
 =?us-ascii?Q?DsXIkdL2Q/o4BLxQPhAP0mUMhbFmVuNZMG+lOZmrPHk8Yjo9V1r1OnVuv6zV?=
 =?us-ascii?Q?A+3Ca5pCBWAwn1lUED/2G0cEadSwgMfzVH1zvY4koyTv+IIWuIspWJKndq3c?=
 =?us-ascii?Q?eT7q1NcT35GJQHDY1jVDQc0VQWlvFKUJvMK37J51eI75SOMRQ/fD+ly3dewR?=
 =?us-ascii?Q?KP/m0oUDpX18os7kPsNJUf8IwiVbVS3Gx2lo4BEH+GYnXE/RlYXMNO2tHxzM?=
 =?us-ascii?Q?eetix3OfZCeAnctJn1HDmInHW4j4MK3b7JiCNwCDbEXxb8AYmiHBCioxmlW/?=
 =?us-ascii?Q?6optXcq4gYSMLauh3YvaOZLoz8QGpVT51RPOOtEGVZhGZdHQJZroijEqzAys?=
 =?us-ascii?Q?KPOfPM49IHYtvktjsDQNrX+vQNFQSbCnTSsxl60AmQFbkXul+NPffCdL6ftI?=
 =?us-ascii?Q?ZxerNw3NPOEDC6VF5XczRNcho8UXIYsF9+hyeRyh46iWhgCedD3lGLY8770W?=
 =?us-ascii?Q?ElFfCe24x7wUyNHY9ELlsuWKzS0IdwCmsJpM6FSq0ttELnWd4QvCy2v560eb?=
 =?us-ascii?Q?NJlO4RBB3sBdXKBhQTUs18pJV7UcdaUYqAZ7vfwIk3aVMJdHIeqIArzQppsk?=
 =?us-ascii?Q?NQ4QaGFvvhcrGVyCNoPT/VnVoNR38kUhDZWWy6AHY2EEpV9FHDgqeLP7/Jvy?=
 =?us-ascii?Q?+smUWpRbX4gEBCNaVpQC+hMqWtINGNhiPy7A2vZldX0LAgFAOt5EKz8Z648C?=
 =?us-ascii?Q?vldfIpg7KPFJds/BqZDy09YeRJcSjVGyLcFljgQVcu6haJweYgZ4O5i5oM0A?=
 =?us-ascii?Q?jV65JBf4AwBiFZzEvwrtdxWyInctncHzG4SvqYhXJyCnRBJGxdv4VCNpr/xQ?=
 =?us-ascii?Q?yen33BzRokw4lHHLzftIN+CkmPFnACkSNIlXtFW3ZuDlwSziEDhF1IS07kvB?=
 =?us-ascii?Q?7Thu24Ycbm4vv+raD9hUD6X2mA5lLLD+O5KRk22MApr/qEoGgWHixj60pSMK?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HSOaAE+zUlHyOILqNRIXSBTFCGga+tYSqpVit1UKKYZ/ZEj/qAN/H8umwUDR4GQXnCmS/tcGN6/Hw4gXtJuIEGXvt+FcZfxx9z6+4hp9mHv2IOHtqt1YT0TVRWjpiH59hFIQuG6x77qLdwS0xnwwzCzg8A+o0tybesxdH84eoDUKMYi9Za0Q7+6z3qr1sPbfrYLtSZ9zaOhr4aJmzecbXvM+msU0zYzHMeW877G2q3uK1gg7T/54epn3YzOwWiqbhUAYefbb560+i3QoWmKfdH2A4hOmEbUbU4/kHRNltur25z9PEZndS9LajKdUj/0wyZ6eaW8PcFTGjL9hpLYOnX1nl0AEiLH/aXJRIXSZxAetwdjc85ylqRftIMkql9W1uf58ZMWL7ryAw5Feo3ACocaLAD5hbXTwCtETHtKKXMg6/k1b3BhJ2bRgb/N7YrKRp93evdB9t6QNZHPtA1mT1zo3s8HvY4JfuBEfr63BdWrF934/jyn0SvQefpqJj4AW/G70iPgE6x17luxzTQ5e641BTJOwQ9cM8UOm/g8iSWLcO/C8y0hGUUbhHjsghOCOKcNsNix3dM74b+U3OdO3jnA1u17onqrtlVVqjdOMhBrIjv3ISkr9+NxeKGXX/xFFeDsI5Z87g7hVkLE0p/c97MSy4uCWDscBEvdCisWAVDCrcFudIHiFYTdgW4AqmmHAmuoKvMC36PyLVlEV4m4ael8sQyYRQfVtR2AElJvS0EwscgVfsl8lt85ofrM99Zrd0qhuMaOnMFhOzpn+rAc0H0Nh79uUFnE9tIwe1nfblXWmCBJrBbcMOd+KrAMwXGrE++80O9m3digZxo2TgpBJMg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05587fd4-7638-4388-a30f-08dbb4bdae9b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 00:58:17.5790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4SPPVlC2r5pW4DWFQnbnjQ23BpmdhQ+stXrAcRv91hMuP7HJM3Sz90jAPAjzwmwzPPWa/oZe8+EpiHq3kzQoCTVvRwOJCJjLtS5iwvyjd8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=560 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140007
X-Proofpoint-ORIG-GUID: wgEprMl8DhC1ihfuTaVhQhy_RqDmb7um
X-Proofpoint-GUID: wgEprMl8DhC1ihfuTaVhQhy_RqDmb7um
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Christoph!

> Can we please get this to Linus ASAP?

It's been sitting in next the last week and is now in fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
