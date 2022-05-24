Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C6FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 03:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiEXDQx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 23:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiEXDQv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 23:16:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF70674D5
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 20:16:50 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NMi0aa002653;
        Tue, 24 May 2022 03:16:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PsL0Q7Wsur7zx7hCo0TVqp4I/LB+EzD+qJO3zbs17GY=;
 b=EanFkCxBvM9G675eJ68nJLBRAofx4t6p1MpJmQjgYkc2Qqk7MZw+QIbBv/Mf4Eatg/1b
 n3NGlQrX3D+HEmQfy17jwf+1fMGbiNiYNrl8rru+8eVUm4CTi54cOS2trCR2G03BdWgF
 sbV300aXcj8SH/XDawbif1S1APCq7f52N10whGjEl2jfkhH3W9ftxrhkt1ZSeEYS54bj
 02rbizsYWu1S0kOVVRkfLlbkAPxYexBZBsHZiBGXRF1ec41xgHGROduRY5HI8vuSkCBX
 JZikZpsNbsek8rimxPXLqBR81TAFLNQAK2Ts/Pns4jz/Ptl2fsWAaVwYFPdbUkQA2G4v OA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6qya4yg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 03:16:43 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24O3C3nc028204;
        Tue, 24 May 2022 03:16:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g6ph1xt1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 03:16:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8tXtqAPeldQQqfLpRknUlxCBjBQKixa7uFoPdyuY9hw7eAR/URxZjQNdKULfEe7KKWR1uR974PnBi72c0dMeSyDgUME2F64cnvoIbKKW/inP8Hx9chhQ3U+dj1nks3IpM51SR2tZvbM3yyJAZEQa2oXUOB1mNmo9H/k4OFLjpQqrn7aRKxXWdyYyYr2m/3hOTSTQz404AgJq7sllnzAbyIs+0elt+5UE9EtQD13nlXgAmDXMHlEB38N45yxfUZ4Nn/sPBVIM58QzGJgbzEAyJDhoem6yB3HXJauw43E6WzYSdZkJUanuEZSWE3Ld94e7pPoCFNcjtDnUSfqYJOzeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PsL0Q7Wsur7zx7hCo0TVqp4I/LB+EzD+qJO3zbs17GY=;
 b=bSvLYtH+QTlKN7Aum9z8d4T5E+yrCRCx2mybNdWBRgx21HQg9GBwNjI3N/8YSl2H6zUtsDAObJXPQPeSouSEXy6XVC8Xf35LsGG3VQGrdayCqFumNDPHzquLMJTZ0jHoFQsux5+mxbb7njKCM9C7FcLu+jwcB6kANvkOVT9oqdYhYn0wFrs60cmctaJ/yZmEH65n1Mvv/9ON3xy7XSr/yoO63ke/XbNa30gy2QC3mHw5eFlBfTHScbHzosP1ktPtmf32+g4pQlfyR6ti7luSZoUVxDDvITDm0KUqDPc9w/XdwXwvENVYwto7c86k0XeY0VtF89fhvqiq1OJ5rw1axw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PsL0Q7Wsur7zx7hCo0TVqp4I/LB+EzD+qJO3zbs17GY=;
 b=wHN8i66SUojo5H3FarPScBMO3hnCV3wBrwK3lsyn7K5Z8rTPRlh8A29ioAFD8IEFwsLBIwRYlSRyH9cH1keqJs1lcpWYbYfPz0x7mxpeloIR7M7ME6M16YsbdHdjH4Xv4zssgo+mOkGVze5WeeEnGl6nHMBD5kVx89m0fAZkR1s=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM5PR1001MB2156.namprd10.prod.outlook.com (2603:10b6:4:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Tue, 24 May
 2022 03:16:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 03:16:41 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, haowenchao@huawei.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sd: don't call blk_cleanup_disk in sd_probe
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilpvhb73.fsf@ca-mkp.ca.oracle.com>
References: <20220523083813.227935-1-hch@lst.de>
Date:   Mon, 23 May 2022 23:16:39 -0400
In-Reply-To: <20220523083813.227935-1-hch@lst.de> (Christoph Hellwig's message
        of "Mon, 23 May 2022 10:38:13 +0200")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64807694-198d-4fc0-e1d6-08da3d33d264
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2156:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2156A0E682161E7C71BCA5C08ED79@DM5PR1001MB2156.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wcK4LeV07lx1HWtJu5IhjCxuHVC2w9QyNdaOhbypIUBigga2Hsp2dt49FAcquUKiXezXbgJ5KMYCsEwOh0FMl0I+M7NMeaWAaYLux1BSDwNjBd6iXIDgV8aPMMbpmjCwlvF2ub9Mkky3PWlu3dlYmk2UsYQj4a7ka4nYY9/J2OFhQveuGJW5SJ90AcDGfdiCfEoyeHTU8vBxHIZsnDCwqh+Sbjfyi8Cp+sLVDCLz4Xu3TVJBj1wsTu55eYz5SAdwFMs8mU+CvlgGE2gfn3SUAX32UrMDT462+F5A9QxZyuX86jRjm5U3jEH+rV5fyrRa3nWkHVhVcgs6VVZu1KpavbxD6w5S7iPBW3mBtz/ddmD5KqDkKMqDgz871fWFf/wMYLzljKJqWxpzssWvyhsbdwL8hLM8UKzmD3b7sRRu7HSA7s/oaGccAXwwNcMwdW/2LUqPXOSGHiMyahsvdsSvrlD9l+w0NkUSY3Wl2gX91shyhdDiyiVHqhnP430tjirVbu2wgiKzbPlpTMJUJUuhoJkH3NoKuSUxsRej1yPw3/S42LH+Uf/kggXcuOpE0erCgUVV/f71PNndsdeK5E4Ipg6YxcVxWWOjwCOcQn9PC+M91YsIyIy40LrzdxrcKuqUmX7O9xwi/FoX6M9wWU5qICvVUk3yx+P4WCglBRrPZuO9JQpfE8LygRgf2gmXo8Fh4rNmGuQksu00XCM6SkXtDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(8676002)(66946007)(86362001)(38350700002)(66556008)(316002)(38100700002)(4326008)(6486002)(508600001)(6916009)(6506007)(8936002)(2906002)(5660300002)(186003)(558084003)(36916002)(26005)(52116002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vKKAI3h+tvTuxuaofqlNDYlfZgdiLO15AKGSB0FOSs9b7scAjCvCNYrKlbfm?=
 =?us-ascii?Q?/FJwFZRseOtNeWKF3ADf07XIjQ8PetAyNR9eu5lWTCdCkuskClieQwExGjC5?=
 =?us-ascii?Q?zwSaAnHVuGYO7r+qIANEWi5KZ0vRdKuqJW6055+/JNI5JwLCGGSFBw+807vP?=
 =?us-ascii?Q?gkwxlKn+NLMIG1T07HaD9GyYbZdIVk+LHq9p/9aCFP9PtlxtOIh77eL/w6nV?=
 =?us-ascii?Q?4umVmJnbwgDEC7i3YjPFEhcj8sNpyGoqoHlYgxBnPHv+ucFMb2bM+Vr7nkT/?=
 =?us-ascii?Q?83MI4FtZGDJAxWnQu+T6x1yplshGYf3kwztgoGh+lOdDouZOVyAh89OCJAaU?=
 =?us-ascii?Q?F1nyK2QacwlFy9BhrIeiLn5ViyvFoUp728/3gAXs6ouCYDQTW3DoOaTrYrgY?=
 =?us-ascii?Q?NBC0R4mdY0LFdhyhSN6cql+2Gs+LdWza5w2pD9evjZYystO2RYAY8GjoExGh?=
 =?us-ascii?Q?eEldoHmrT1hg9mShpVgHe07dlGGQjP76g6ylr/FsP8+8SRVHlCJ1j5UeTxLs?=
 =?us-ascii?Q?HMd+McARnR4Gz54voGud8dTRdWETLnjYLKHMhd8LP67vx5tUG0VX0yY9/BWk?=
 =?us-ascii?Q?wIUUn74sL33PxpVqP48lJe99orzjvsih7idfy0pyF8i6jHnaizh0yw0nU1Bv?=
 =?us-ascii?Q?j3+SwMHvVORC9Z4TtABmLwH/k2dIEbxAd2X8blBqqX+8vGaiUn8r4YmSKi6R?=
 =?us-ascii?Q?NUUY6cQWVG8bMWHWiuJ20oQfSaJ5cEMyoB1FDU/UMVAqZsMabwIhQGhkMnn7?=
 =?us-ascii?Q?sQsE0mG+CJpE03j0thMVcZnrCdXv2XlC2hWZmKq0rKPz8SmsPTCYMBBWkCzy?=
 =?us-ascii?Q?4vkJkKKEqZ7ahu5wI38+HaXs2xc1sheuB8gkdXi7ax5BoFkoWTyGme3/hjRs?=
 =?us-ascii?Q?jC1KbLQ4fJ1js8+s3OXpkTdrKe3+v25wdIqMN4yxo5ArMiOt3hnG2z9K9lyE?=
 =?us-ascii?Q?+q87rQK+baHtB3qT31TDZWS7TdpNKGGhNYMyKYTB3O/DVb2eFJujZsBSFUZp?=
 =?us-ascii?Q?++6euTeWqtPkzj/BiSdQoQ7WGuoMMk1ULrNFxG9L4vVqbLi9EBYDmEisycLA?=
 =?us-ascii?Q?c7k59zUGtHrA27DIE1R3Q+J78yzydpVL+51q1wya3t5bnflamIP/2gcvMJc3?=
 =?us-ascii?Q?9iDF1wqtJrgzBDS73gdYIp7vng+MI0Qvd6aoxP14n2vIgsVcSNTTbhRR0XhA?=
 =?us-ascii?Q?Qyxl0sJgOq5EWfkPuylCsmMBwWBMGb23yzP9kbIXbe/Jt2qKfyfBUoxvTV8F?=
 =?us-ascii?Q?Zeat91wr/Fq2/Fv7kj5f4LIsW9ZNrQfOj4JzYRdwr7xxoRv/APkaRFFYyfYc?=
 =?us-ascii?Q?JuYeuDRBkXqKOD/wKqVlioKr8lQN/5CbVIPNpG7bbY/RpF/hQAuzclEcl3Xv?=
 =?us-ascii?Q?1fgA+hLMsULzwWhIuoGaWROyWioSs/aRFDYJy/wsL1+0uY1zjGSNxjI3v7Ai?=
 =?us-ascii?Q?gG/wKG9WD8NdJT9Jn9SBi5l55ECZLH+izyWNtq8tB2e7lT/KQdjQaEJbIi1a?=
 =?us-ascii?Q?KRJZ6cBqJcUGOtWr/AusU25IphTixSRwZZ4ceG3meo/7aU2StyRvET0XS5Qu?=
 =?us-ascii?Q?DNGbItYbvnwV4zUwOs1AZIxoIEi0593jpssTUli9L7sWRonZ2mk6pV00juJ6?=
 =?us-ascii?Q?0oRN/qvwalftoMMy+DsBkNIpez4S7FV8CLGz0q56pJAkeHMn0ygcO2meWOfN?=
 =?us-ascii?Q?G4MdWg2CFot3Z0AHDxvIkOv8J++uHezszfXwJjavgIsM3LDA9cqBB1/E1dXa?=
 =?us-ascii?Q?cbeKjKG0eojin9/z7OqM9zrvIzp2EiM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64807694-198d-4fc0-e1d6-08da3d33d264
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 03:16:41.0831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ilbFIDEcBNRBQXWDWdsjD+hKbgitnpARQOvx6hfZlOOAKXG7zCLwkZzIXMT5PpCxGsdlRAcyGJOV7/iQcjbtxGJkFAyirUpjdosnbXww1so=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2156
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-24_01:2022-05-23,2022-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=855 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205240016
X-Proofpoint-GUID: 53L5BKsWaJF04m4fhzOGc2DK4w3LI2JT
X-Proofpoint-ORIG-GUID: 53L5BKsWaJF04m4fhzOGc2DK4w3LI2JT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> In SCSI the midlayer has ownership of the request_queue, so on probe
> failure we must only put the gendisk, but leave the request_queue alone.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
