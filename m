Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6774C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 02:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242558AbiDZCid (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 22:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242552AbiDZCi2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 22:38:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD4CE6C5B
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 19:35:21 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PME2ic027767;
        Tue, 26 Apr 2022 02:35:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=p+Dw8F1uq7JTyO9+A7YlWbCa9hGVeCvmRayL8cKugBA=;
 b=uo8LgfqJDvH0hO/sy2aWJ5zQUrKeRB3mP0FD2pNmhPlG/uQ43PqklMMm3h8A806+xRjf
 C4tUF7YLAUxyA7u7D35gJiSPjOtZ98eH7a/mp156FHvAZ0Fzqmk5FFplTYhxrPn6iIat
 NpyunY6k+IxRZ5xmEOpFv1f5yaZuHh6+eu7nUt1SDaBRFXQVSzNyOCezaY05Frmk0aUo
 ZNb1l14qiVUBiKaGgnacrMUwpT1cBn0g4fL4w4ET3z3AMvqkm5Ud+0gjEB0Jo7Twggc1
 vIWmrR2iuIXAK2ER/O1BA1y/dRmjwy33FXtRpRrWjnyfe7id4ACK8r/GAGu1MhQ5xutn 9Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9amsrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 02:35:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23Q2UOqY036662;
        Tue, 26 Apr 2022 02:35:11 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fm7w2aeve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 02:35:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qi+StHhUxI68FT7J1tl7kRJdP3H/6tcAzQAWINs5aERjwO0XG/4iy7sx/HM2WOQuGg7xvNomHGeZbu+63Ety3LNmHZ9pHyUraFhvaHITtVbdKS/XzCVRAbHDZ6WlL3mzqj6Y6db/8Bu9XCAaJRqdEjbPcgAE4DEVBTCpsN1eV4MsFJKb827FYfOQKoDF3Hpbr89+k1USqoEMQO3k9GiH7UGUYdoLO/24qyc9TSMuoShVJPfS5PMaVxGVOd8bqHtUtm4uZyJum7miSUY/1JcHJigTbe90X0gSKqyHVyfiZpyXEcnhz7uoZ7wIzSm9g0P4AOyuIdewA2gCjS7OdDjbVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p+Dw8F1uq7JTyO9+A7YlWbCa9hGVeCvmRayL8cKugBA=;
 b=SCVld6o99qZbnZkPSkhKvGRIluTsNN23ntjVRWZYte2N5rSEG8eyU+sjZOCk91Ybks4R9/CV7S8IDk9vTvoMMexlF/Cz3fv2Q88dMoWU4Pi7hk5RpCeMlFYXAk86JyQPB42fdw+Jq7GsQr+6YQ77I5Qbh5TwYG36N1EbEyaCltvb2zToWYRAXoybn3M8/nUG0tLax2urayumnDsM+JsIebQh+k7EX+WqRUsm+JH9B/jymytlPRI7qe0J8Pczyn/f/I3lTXHYExuxvI5jGnEqaSrHh9/Bw1fW0fe5HGlr8QpzPh5NiAaP8Jv7kV4ZHYQHP0pZ4I+/fDf1uliuvigbMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+Dw8F1uq7JTyO9+A7YlWbCa9hGVeCvmRayL8cKugBA=;
 b=byC5knKCdFSz7TvDP82xs5Y2wOdR2C5XbSMLgehjwOqCzmD8vp/CTRZuA5UhbVihrl81uqSckUjpXhQridTpENOZsJyYJLO2zsLjg5jo8xRVWD5I6w5Qme023Q9W0f6N+5OfYqLMMsVMIux2+6t3ys8CNHt23JkbRGbQxSZ14wg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4789.namprd10.prod.outlook.com (2603:10b6:510:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 02:35:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 02:35:08 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Konstantin Vyshetsky <vkon@google.com>
Subject: Re: [PATCH] scsi: ufs: Increase fDeviceInit poll frequency
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnfcwp0x.fsf@ca-mkp.ca.oracle.com>
References: <20220421002429.3136933-1-bvanassche@acm.org>
Date:   Mon, 25 Apr 2022 22:35:06 -0400
In-Reply-To: <20220421002429.3136933-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 20 Apr 2022 17:24:29 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0187.namprd04.prod.outlook.com
 (2603:10b6:806:126::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7df5df33-19d1-4a36-5da4-08da272d6104
X-MS-TrafficTypeDiagnostic: PH0PR10MB4789:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB47898A4E629BE2F435780D998EFB9@PH0PR10MB4789.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fl9ytcxQdVhvLouF0t9EaS3O9QG0dzwtNNOla6jJAV7Msc1zlRo4teCBE4zrRWzRWiLWNeJbsr0WTF2LmB1nmK4ZSLdkA2KxzqE/1St7x5A+UM274AC1L4DFGa9kKRJywMx8HrQ9TyxaE/yAQJ8Gn547GfJL8xHn44efZ7u90W4v+eGOmaB/TATt4isylqy4yQB2Grxq9CgNS7qEGmHrqiXVGPJfmC16WA6DEhnaLEWKZZozwFfl25lTjeJiXWCiO5Wyx2gyWCzjkDbs7ZOlpW9rsikcRu68E2PIfsF93GJ6/dSQuOHI9EnhAXIF+CeIFpjdUcIy+YzF+RhEzgrqewrHqspqoisoLjCzX08lRhd+S6McrzsLa39ht8Y7wL93FOmW0sVT2pjj8H4xhxVmSe8QPejVs7DHl+sibPTP5/wLDBx9M8WKiX/8qYD2jcWMUjdMX5kOtEGp2W6zFqkyWxrQsdALUXqNwhrrwVKmJyvwDfljCNS2BO3fBEjh47A/fYdN82Lm0oVKNCVihzwQWGN1FL66Nv0Ut3ypBul7Ly5P4PT0ZbzMprvowO1zWTosGzqKvboDwlzkpINp4GbIiV8uzkvjUz2cjhai4iRefNlo4rwec6RQCzwub1OPI8diAE1yGmkVptcy5JNfm6K4OraJEbKSxgWGYAlAKEusDHKmjYaagUoYd70huRAvp3Qf/e1OsXiEM242R7kT+TmZ0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(26005)(8936002)(86362001)(5660300002)(316002)(36916002)(52116002)(186003)(6506007)(54906003)(4744005)(38100700002)(2906002)(6916009)(508600001)(6486002)(38350700002)(8676002)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hWtY3XW+NpTgT5Oeb6rVIPH7K2TFoyR3H02FViaBU4uT+emkdvjwXNaa1ws2?=
 =?us-ascii?Q?t4lyKptjG1T8wgAQysu+DA3TqJpsCgfVvun2SjT+QfLE4F2o6Jyp8/K6pl00?=
 =?us-ascii?Q?Qx90X1j62zsshMYIEwosnNYP6CKYOaO72esBcWtntAnpgKb5FsvBV26+X867?=
 =?us-ascii?Q?qVv1qtZB8YtqSwCkx36BEDitar7RMMfIq2asyoXb6zJC/PQ6re9GEYabPwGt?=
 =?us-ascii?Q?3AvDt8MohXy5ZvgmO69+fGvMKNS+TpSdq0mm7ZEzP8IgN1sQeu/Bax6szuKM?=
 =?us-ascii?Q?XT0oholF44NJi3Uotz0RJ5Kbnsm309XxlNc0L1NcPfPcxf6dtJKAAPIrJ1Sm?=
 =?us-ascii?Q?2k6zuFY+GTP/3h+vpn+Pcn0QXBsH7cf1trvsHGlmRfxxpX8NT2pfCRJF3VW9?=
 =?us-ascii?Q?/BhoaIJ9BTbxLNXWEaVe9i7nyYOy75jKX+CVyGNgdZzRjqQxUM4oZ/8Xi7iS?=
 =?us-ascii?Q?2PJo88uBQhRNNrmU+CzlX56j2ZqEynfUr4VwOE5TIRG0gUL4FEhL0HMQK53E?=
 =?us-ascii?Q?DQH1+uA1AjVnakwnb5zK34Mj66/+3Dmjx0MjSDu++lYURH4z/7yMYhIB7F/d?=
 =?us-ascii?Q?lx48oW/iSyHtyA1vWpKRHAwWvy9ipVRcvismPvJZIZSMVOaX0QvvDSrQ2sXo?=
 =?us-ascii?Q?Gfn92KM7G+ksSfUqGC4d48QU06kIF1VCO/6tRyeufvBrGC95VwcBClJyslRn?=
 =?us-ascii?Q?yTAGP1YYYIvppf1Rjm75KaKZCSgbGU5WMIXhXYzEoz2Hz7xPkqYYaV/qCC++?=
 =?us-ascii?Q?a0CTuuNUuU4njzrZsSuTFzakpyXCbXcRHLwr6SNAhiAjhJombKrPxVmqhgbu?=
 =?us-ascii?Q?R91aHR1SEof1XLAeifRCHndgxb4CEcGHmcwu74V7mayA4omBDs3hZV2ob4Zr?=
 =?us-ascii?Q?pek/cXBAfHWCTBD07tMWnKGy4SqB293VdsyZ4chCA7SH9DAcdgjAUzB6AjqD?=
 =?us-ascii?Q?oT17AzONLSxhIUqtfHStFJ6z8nukW6rVaFEQCUnODb3yqn4Eeg3FGRQn4qMK?=
 =?us-ascii?Q?dvbalK2VAFecdaflYhYzPbAjAtsw9Q3UpLQLHcmvF0tpvw1xedVbkx7Drunx?=
 =?us-ascii?Q?GCFTSf2nSro9lEwPhaAVHU/A2znejub1afJZjJagVv7AD3j6kd8iuPv5dhtI?=
 =?us-ascii?Q?WiVCe65oZuFMaqmwPDodqaSbWGGF/pQkoVQGAReRbcFoUWDinzMo8cvgk3F2?=
 =?us-ascii?Q?qmkXXpsR0J0AGLjv9EFvrvchtyq3nT0R8w+ensoMs8iDZddi4ZAWPNrE5clg?=
 =?us-ascii?Q?HDcuvu8ns2/D/Jl7ULSPyhKfHWNn4q/om45trbtyFzcds61VIedhan/VIDIB?=
 =?us-ascii?Q?WmKXhkiZjH6sTJnJ3cf3QrbVAU/iAqHRWVny4EjG7xu7DM66fENLaWto32u5?=
 =?us-ascii?Q?PT+g/FrEx9Okh38p1jW8vMoAGJqCqIGTgOlabNEkounkmOH/8OHq1QQqV0BY?=
 =?us-ascii?Q?SZ7rgEBcv3wHfsbkDag9bJCuy5yFhyvz/IMcphj+qDm4jpJBGMkfvkf0o609?=
 =?us-ascii?Q?83j91se4tziaslzXUj31laLYVgWlTyCPMOPS0FUsjMJLsuTVbETE+N/qWxuh?=
 =?us-ascii?Q?66Rca39Jf09aFFqRC7aYxiABJHc5D3cO7osHxsU/eIKg56UqgK8iyIl6QUER?=
 =?us-ascii?Q?GrXW0UwnNXIBw2wRYTCg+o4At0RqlpTQxPDd1ICeMb7cUv2jZiApnba616ll?=
 =?us-ascii?Q?iXeJoVZZzxIso6bo25iWUP3ImjpyrXdV9/+xpZCmEeuUWHdsTpoekCyVNTfM?=
 =?us-ascii?Q?Sderzo6W3Twr+//l2JfVZklFeW81FMI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7df5df33-19d1-4a36-5da4-08da272d6104
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 02:35:08.2596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mFf1JschqDGzBTKxpa+bytJixyT9xT/lR2wCz87/UkEWaWpYE96FpLT7ztYBW9VJ4tIfAUp4hJGuKdjBt/dlBrUxMp8yQwwntJ9aZWkwwiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-25_08:2022-04-25,2022-04-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0 mlxlogscore=732
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260014
X-Proofpoint-ORIG-GUID: TErXjBZNahVui6FdE90qN7vPX9OYuSGG
X-Proofpoint-GUID: TErXjBZNahVui6FdE90qN7vPX9OYuSGG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> UFS devices are expected to clear fDeviceInit flag in single digit
> milliseconds. Current values of 5 to 10 millisecond sleep add to
> increased latency during the initialization and resume path. This CL
> lowers the sleep range to 500 to 1000 microseconds.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
