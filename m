Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554D4C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Feb 2022 03:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356760AbiBDDQT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 22:16:19 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:33686 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231451AbiBDDQT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 22:16:19 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2141eKkj028755;
        Fri, 4 Feb 2022 03:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=bpBuNR9Ng0es4/zpFWXEvN0VbAPE2OcacEm2XEtBp/8=;
 b=F4oLRnQxc/a29ph7oRL0tNc72HuuEDsbv5vXI2kQDljmCqSuBJswGt5Dp+B3LcKoLI4t
 sgKPYgkazqWDOr+ATaA+xR8EQVQYd8ol6p4EkdxmLDZa+3M9RXr/prRK9wy1qWjwGc/o
 Zl+Jf3z7D0N1yk64jEAV+++Mtz3KTmAk7WkrYfw08pemkp4nwWqXN+D/CDLhjnDOyKks
 h+IK1RxaRMtfc2Fn36r79RCGFX/cXGy4xkvlqm/3ME+YEBwpZ9kfo72KRE5NooUiEUd7
 cSN0UNtGD5SyOzbVwAgtgaNcHadk+pZtoEo6I2YEsML8SwEful76ezVAk3lkkCgiyB24 BQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e0het9haj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Feb 2022 03:16:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2143Bope110528;
        Fri, 4 Feb 2022 03:16:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by aserp3030.oracle.com with ESMTP id 3dvummrray-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Feb 2022 03:16:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JakuPWi8i8dWR+C13gurfGCmwfkG41/ivNnI+4B3L48G0/6aHkBf856BCQ9/y99tL1xCQVWQritXHQL+KNZ05jR6nXcYDHIeYme/FP6b02U9jx2Xyv8Yo2O9Szxhz6cqwlqXL5het0EEPMRi4nJbuueln9yeXLedg+OA6srJf7IM3S8K4CnbMDh5kmFOZoBpBHJMH4vjQ5RiU3JsiOz47RxBtAUbHJbolbEzr1RwdJVIgWBQMeXB0f5S5c8eWuMdas32PYTP6Rc1q2pgRAfDu+XhUDA6VMhoz7K9ZmVAFR4T1pD7mL+HGFqA+kSbi/g3TwXvwPhq0MArXxRFrFAj8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bpBuNR9Ng0es4/zpFWXEvN0VbAPE2OcacEm2XEtBp/8=;
 b=jrNknvyZQg6huny/dOc64fNJQxMMcsSgzY+Uez0WXl2IoqEOi1ciFouXRciEYOVFLkysju1y1LIj+9P+JWZXvDdES2Nl1aXawFnCZCtRBM3UnzilGgOaunv05PdVRTckW9h8Sb3gFg/Uwu+dMGiAZY9WaZ8uKZK73sv31b6ZuFspdnlNlSmpcp2NGinoUJZ+8NWrLFHq7voImb+EJlKruPE2uFlhjmFEiTXTKUkrGaIPni1yRNpnu2MHe4uiyjpadGBlAapu6Edmv0Yg8KNseY62IQ8Z9ofx8GL6EayALDvsHFZHxxpGkf7EUrl+k9PBPhi7/2J2/Tu983hf+FLB/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpBuNR9Ng0es4/zpFWXEvN0VbAPE2OcacEm2XEtBp/8=;
 b=a78a7rl2bta9jZI+Nw8IuLRP8tPZmWPSbxtTpjheE6IoFaCsy5x+5+kZjitn4tLbSxcluOak1NeRoxwa+zHIACBIpmpckXDZBKYX+PgMMtdNyODojSzhgAS8Hfi74U9QmlghV+tJf9pvRk9ra1Csm9VSCgrQsC+7qiyQzPBouGs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN6PR10MB1729.namprd10.prod.outlook.com (2603:10b6:405:a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Fri, 4 Feb
 2022 03:16:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2d45:d1bd:ebb9:48d1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::2d45:d1bd:ebb9:48d1%4]) with mapi id 15.20.4951.014; Fri, 4 Feb 2022
 03:16:05 +0000
To:     Song Liu <song@kernel.org>
Cc:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <kernel-team@fb.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <axboe@kernel.dk>, <hare@suse.de>
Subject: Re: [PATCH v2 0/3] block: scsi: introduce and use BLK_STS_OFFLINE
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgn7z5ij.fsf@ca-mkp.ca.oracle.com>
References: <20220203192827.1370270-1-song@kernel.org>
Date:   Thu, 03 Feb 2022 22:16:03 -0500
In-Reply-To: <20220203192827.1370270-1-song@kernel.org> (Song Liu's message of
        "Thu, 3 Feb 2022 11:28:24 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR18CA0008.namprd18.prod.outlook.com
 (2603:10b6:806:f3::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b418943a-c086-47f1-cc99-08d9e78cae0c
X-MS-TrafficTypeDiagnostic: BN6PR10MB1729:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB172981D0D62A40CF60E718CF8E299@BN6PR10MB1729.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p7U0AIcubYnhiOXrRCA28iOpmejsYHy8Z1YyATf9/4hZs9vGnqSpoJPNAwcyIM1HAmrUPvPHPRHrO5vmjjbc8TQ9hOlKjCAi8foRIKFSzSZgX57B1TepaZPa3VnnkaP6mqiXcZGzuXzNwrdnllNPzuEVVD41m4BN8Q0/IOp9XS8g2URUBhDt6PPlTCnvOu/0/V8J0CevB8VO/g2zZkz7tOsH7Xg/wjUi1BF74K0lv4tSYM4ce+Xt3XCvJr28QGdO0n2aU2juCHwCj83ZnA7n2dYDqqKsKgdGeueyV6joKlReK09JTjhH+eY4YgfNrPu+l7Kk7DTC+dawjv87Pem8vtu5Y2ymNSV1H/unKaJAKKSMU3lJVA5Sn3pMWcuSbHhAkXDKwp8pHHLHCjj9UyGKbn4NhGynsBOT/tmkdeLs4S0jov0uhcd9PFnZE14rSVIyTyQuKSj4lNS6ZRai0gtBVtOgbzFbA1KI96s32JcO3MJdJh8w1dfLKor230Wwqgec+Sy3A6fTs9MPr7HxtVa8QDBkNqwdmtsf368CR8Pw8QXUFNiQOFccHEC8ddaS+Kf5Jc3RlEyacPnUvnqGrfYLxQfR3Es4GfLNE/HgUfwnKZmpxN2I/9XkiMLGfoqLR2+yBY2u5RYk0Ir49gmsm/N8I4qH4BmfZRsbRLsaX6FWlbmFHH2hVFx4WDwSVbSt3Ls5ySVsBXuzclQlDBZ6VGPUMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(8936002)(8676002)(4326008)(6486002)(66946007)(83380400001)(38100700002)(38350700002)(66556008)(6512007)(36916002)(6506007)(316002)(52116002)(6916009)(54906003)(66476007)(2906002)(26005)(186003)(4744005)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xd7djltG25EPvnK4/dhWk34eiQnAI+IXKZP10PR5BCl6SycOTUIyy/i8uCwj?=
 =?us-ascii?Q?OuLDxDBfiu0+tjDTeJaVnxjffbpJKj4nG77VLOyAUetvVSdJnFwaypYiHhB2?=
 =?us-ascii?Q?e6eJu+l/53TDR75rMFqXvKkd0knWvGQi3xCVyaIWC2x4NKqtFjzMpofrHdAw?=
 =?us-ascii?Q?31CV5tBNsCz0TVzLOZ+zZ9zSA35cKWoNlIp6Z01Dkj9v4tFlCoEB92zrkqGB?=
 =?us-ascii?Q?Fs2746ALDoCGc0nPy03rNvvj68VSq6bk/lpVJtYf6vg5CI8RxTvTGoIyB7W2?=
 =?us-ascii?Q?nK87Pml44FFnca1kWr2kF1DRYR6fJTrlqB4kCw1wROjJlwTZ0L/3WDg8BSwW?=
 =?us-ascii?Q?+g87WH2yyD7jA0UD+7AEPeZwfr0O0HxniRmnBxLeouMdzhr7uAUnWeCOjUTg?=
 =?us-ascii?Q?2t1na/PpfC7eB85yw4wyUaWlLL7gLJnBn14wEYuIAqPipc2wjHC0+Rjj1anJ?=
 =?us-ascii?Q?g4Kam4sBsVFAMv+ZXCAv2Gbw5JdwkNejyYmT2EDKb76vOVX/8ax8ZcwyopCp?=
 =?us-ascii?Q?PZbocaQSkY/SD3JCchDZfVg2qLEboZ3CnlulQlHr6XSmF6rANHzNXsInrkKi?=
 =?us-ascii?Q?n3fzZq2ja8nWZZTIF5fxruhp768O64Tpyf8mHvkzNP7v7+m0frmSduV91CCC?=
 =?us-ascii?Q?iiV09CWo0ulpCCzdkSlCYLzjlOlcoAOTz5Z6VHvqoBdJMbSuwRZ/GBnVz77S?=
 =?us-ascii?Q?vkVrTpck3wRp5cjgzpFWm+MGvtFtn+d81XOdWxH/Av/BFYLW1zPpwpWlxBll?=
 =?us-ascii?Q?iOo6BSYa/ftE+wB/8HVRvisQYhnBBH07Z/VPfv9/UlsVa4bgRDcDIsR4AFcX?=
 =?us-ascii?Q?oysVvY0pW2y94UEGDCoS16hsr7OnXHFrZzDj+ZAfbYKU25wXUoR0Y8zWlIxF?=
 =?us-ascii?Q?uTB8c/MhxtV5iFWKhGX3PCFRXvYmYfhRfD9KXtQheKlSXErrzmkSXjJiskAG?=
 =?us-ascii?Q?cIj3nYlbYJgCekUybpb9LlaitzvNHwVEjd56Y6DqqT2Z3DlMzcl0FH6UQcMe?=
 =?us-ascii?Q?Iv+4lMp1M+sIP5Yz4jbz8Hy1ZOAj5PhMFV4Rbc9dCA0Ksje1MkWnI2Gp5/cW?=
 =?us-ascii?Q?Mn/WIPOzKsQaUTI1XH+c3b49n42ji+Nq3EWKth6IK212iFzEhdiB0OUfyCOI?=
 =?us-ascii?Q?fCG2ZOKuCZODRDGnQOgnXMRAbo4vG118XarIJGK5gyjrdYyCM9E73k4MCNnd?=
 =?us-ascii?Q?vWC/60NX+bMhgEoBxyEF+9yJw1+lkQcaZjMtzSZ5/rsn0z7i6MGRCBfjCSy6?=
 =?us-ascii?Q?PM+Jep1nFod/omV6oGqk5P0hNkAXF363xJylVv4rW2o43w+y0tDB+6IA43fU?=
 =?us-ascii?Q?XTP/CGKkhcjVMr/PFNY9OC8hfe7hkcFgryoYgoV9elFMBFt/etS5HDI8/r1v?=
 =?us-ascii?Q?Yp9LgX0dQ69l5ogvaZHX224S5NQNKQoQhl1jTgLmgm+BdGz+yqo11RDjDMyO?=
 =?us-ascii?Q?1Q4oW5lzHqg/5baldF17HXOf/qzzIyAPbUaNJ6yukWk7jiTVJzIM0/dxGq3D?=
 =?us-ascii?Q?20VZBpCeFbJ4tlBVD/B8aYzPJ+KzUnGhQvjo/qO9v23udYZqAAYBJLP3KaTt?=
 =?us-ascii?Q?HTkkY84dDcKodQS7UqsX/eaGL1PzAV0v7Im0wtqEzgDGoTvB+jUP92li80WV?=
 =?us-ascii?Q?VjqwekU2NFTbU/wqKmABocMXWur0cCEeBwCFaGA0bM0fBH9QmJ3uokMDvZNV?=
 =?us-ascii?Q?kh+57g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b418943a-c086-47f1-cc99-08d9e78cae0c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 03:16:05.2241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ukM+prfPtKMDsiiMnAC75AevQHCcsLcwWQjQXBGGNeVyIXEy0gVWeE1WfQMWZTYXb9kSS4MXYmLNtEIweDOvzDxCDNgEMNCVqugNodUjZII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1729
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10247 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202040014
X-Proofpoint-ORIG-GUID: rtNbomY72UqEcTzrsc4LVN5fwQk0XR7r
X-Proofpoint-GUID: rtNbomY72UqEcTzrsc4LVN5fwQk0XR7r
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Song,

> We have a use case where HDDs are regularly power on/off to perserve power.
> When a drive is being removed, we often see errors like
>
>    [  172.803279] I/O error, dev sda, sector 3137184
>
> These messages are confusing for automations that grep dmesg, as they look
> very similar to real HDD error.
>
> Solve this issue with a new block state BLK_STS_OFFLINE. After the change,
> the error message looks like
>
>    [  172.803279] device offline error, dev sda, sector 3137184
>
> so that the automations won't confuse them with real I/O error.

Looks OK to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
