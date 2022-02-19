Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271B6C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Feb 2022 22:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237811AbiBSWqn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 17:46:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiBSWqm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 17:46:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108633AA62
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 14:46:22 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21JCZmfq006714;
        Sat, 19 Feb 2022 22:46:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kdVcp3bENnCProuKVoPzabUVvbjg3fbKXAWSQndE24Q=;
 b=muX5LDvaKUIma59Kg+gpldCxvUNX9w5DIZOBjyYwf2EE5GnO+tefSLib9uH0Y350OHBQ
 0tcZkVKmMiT3iH/+YbGhepgG9yHaCo+/VSDD4MyjctuFOZjac3brvQDeA3avj0K6bV3A
 SgVo3oC6NQp3ZqF/rg+S8edltgYyOq3WL6RmoJG4iHpv50Jd8aQpbwQ2iGW0b3zATiqa
 aT6rusNVJHguwUcq0dHQR8oxJ3b4V+MaWMuH5q4Almlh3HiQoQZXlX1TQ7ntYZcGmvno
 rn5NgXGi1kgNGw4Tnk4dLsWPLjU2jO2gLxafkdP2LFHOjhFLUrI7zWO+QcAelHDG8oCv SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eas3v0yfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 22:46:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21JMfrvW184435;
        Sat, 19 Feb 2022 22:46:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by userp3030.oracle.com with ESMTP id 3eanns1ukb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 22:46:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yc/NIgcIj05a/LHtV3o99qB97zukJqQWnezPhTT0NqJEuCS6r+JqBYmT6XZ5EviLWLXj56spWCBkREuQcWYAMWiAGuh3JBCiSkK+/b2rDvu4g3qHdel1yinDZPDnnQ0NTl1/b4aTYk9Cl9imchtcNhrBaV51cwVv/sCJSGvjtkv3p/uh7SzV4ht+U8RNWlzgPomWbX1+JBDIk8HYj3YQkYgel69oxjhDLabPN4qRgv5mVshT7wp0EEAeE6gcZyn6hRGz6VzJzFue1f6jfsEMhZXrgBp8RsGj3hkoNmYlXdoMVo5y/MZvvxrRM+Jxs4luyzBxHWnJF3ls2SAP+tFqfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdVcp3bENnCProuKVoPzabUVvbjg3fbKXAWSQndE24Q=;
 b=TjEKMDoeuqI7MthHxZ6gtpOJhv8EGiTeeBPKMKNK6CbmH31sxmITjIYr1kQbiD9Gbkrzg9RugvUEIeJRps7WDx8/5E92uy9xYUk6UBaDpge0aiLslm60nlXPKk4F8CyS6LOJ5VYwN/jlxGll8P+ziNCIm+3a8lM9HdulLE4KbY8ma54ooCb3lKVZP9uP4FfAZyXG92ydGLLXnkU79QBk/muRvoFK7Zj41CngFhTOEnsQWqDucFNiFCQsn6YzGNdfpKjdbn7BYTq009AXLRYY2YN5iYmpb8sVFHeeyLit6BnTyVXs5qDvVA3F4uKERFuiVvlvYlat6VcMk2q+/ej/kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdVcp3bENnCProuKVoPzabUVvbjg3fbKXAWSQndE24Q=;
 b=ACuO9mywQylvz4fW7Kf5C9GO/9M16TTfODGnwNWW2nWaQ0OgF99uClAbZsMqDPXWd/Ffi8XGaJnWOQWdqZ9uQZlUJKhOLNHKqTSraueFn+T9kG6s//uHhytQQ9Hr2fLiWwydnYHdPiv5q/576JuHOQoBYefmYttqwQ3hWULCrIE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB3486.namprd10.prod.outlook.com (2603:10b6:208:10d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Sat, 19 Feb
 2022 22:46:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593%5]) with mapi id 15.20.4995.026; Sat, 19 Feb 2022
 22:46:16 +0000
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: sd: Unaligned partial completion
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qzyh4zj.fsf@ca-mkp.ca.oracle.com>
References: <ae40bef0-702f-04c4-9219-47502c37d977@interlog.com>
Date:   Sat, 19 Feb 2022 17:46:13 -0500
In-Reply-To: <ae40bef0-702f-04c4-9219-47502c37d977@interlog.com> (Douglas
        Gilbert's message of "Wed, 16 Feb 2022 01:35:33 -0500")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0040.namprd11.prod.outlook.com
 (2603:10b6:a03:80::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e135d1c-cae8-4007-1793-08d9f3f9a336
X-MS-TrafficTypeDiagnostic: MN2PR10MB3486:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3486288C4550448E4B235CD08E389@MN2PR10MB3486.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TO/GKZrvC8zavEEQ1pTyBzbsL4dlqLa04wnKn5jzVJjCOTGV0XVDMZrQWytf7IeP0jRJIv/BLIyHOoV/GxbySPEpwtTy8NDMiMa2pFuwMvRDaJuFHW2FUebY7jydnAQMuUDF07bhGJO4tQ7AXAAxb6hPWFDADjAu3UPn0s2dhHDphjzO4ZwCC8qlEd6fuLR5xPV04dabFJ8bMe54cWjT0kep+cSvXceJljp5E1mEFpyDCtZ/PoEGoicKmFR8JTIX3b7hvVtJpjfaNQYzLshviiOvSopdB7KCT3btW0bcec6vs3j0YoOxM7zXgOdBImJVmWb4k8uyIdZDNtDmwkQz3kWTHad1Th1b71WtH5nnOcFGob1GSkKHpZmJKN/y2VoUPaQrllUBgsDjtmtJ9McIJ3ZoxykDgtTfPmzz3JoZLoqu8ixY9/SZ0UBmfGzw8w3046MfSUAJPqnQthi2zu1z3WrHjkpWHt/801sKIOlP79SU/S4e6p1uo5apbnd6GjLtZgXX8Z4/xlfScm2liM9EPm+WaZhrCrxAVWER+FP4p499vnwfdNDXiSQF9DOo0ER53Rtj87rtpRd9ZEd2zNcjL8zpzNmh+EgwSnunaxRdMv7toqixr8Up7CyoMFBdnFwrT0HyF6AgGbTx51THctlURZbZsMcm9yypGGS/Hgz/Ay4L/+hMHVnhyD69XteBWHHLv9NKL5wgjaACj3KcrgwWAv2+dLOt7Rpp9MYi6BTL3lo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36916002)(6506007)(2906002)(52116002)(6512007)(316002)(86362001)(6916009)(6666004)(5660300002)(8936002)(186003)(26005)(4326008)(38350700002)(38100700002)(66946007)(6486002)(66476007)(66556008)(83380400001)(508600001)(8676002)(505234007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?55mFPCcoRPB7emNGtkOQQBOM2/ZlNxA/k/BETKT2gOyCmar8Y/aW4lvJfI8t?=
 =?us-ascii?Q?PQMLbTdGxMCWa7OxNisOfg/XtDWZ74EdRa3LEVt79SQaDiC2t+1qDs3/cPD+?=
 =?us-ascii?Q?xepZUuvNyPQNYhdi6FarWCBV8tOtl/H44+745N/Uvb2ErB1W4YcLs0APKk1T?=
 =?us-ascii?Q?jtPtu5QgNNjiKWg19sl39xZTFiQFYhEfhyIHyVoRNIentxx6ONk1d50d/1l9?=
 =?us-ascii?Q?l3JcQy4++XlpsL6hUWGhwRQEWPPtSf4WxnAA5CfB2rlyxkDV4uVgkbq3FZhF?=
 =?us-ascii?Q?BURzibsoJYfsfcv7JLwBko/dv0SF/jHZyOkfjmFPK62/OET8/tjUg7/ePqMv?=
 =?us-ascii?Q?6LgopsYPvbRH20LLm1ZB36zdydQb1bk8cfnf5CKO1H+fHC623bPacZQyT5NM?=
 =?us-ascii?Q?uQAxFI6cBkDrRospAiFLMiW9IG3ax8LTZVE+y8YTFXNC8RlcIU5doeObu/Di?=
 =?us-ascii?Q?EsVgBFjkZzwoDqdOQ6+IkYdMPXUWfB6zhZSKpmTsRj99+0+KdCaeN5dAtSNQ?=
 =?us-ascii?Q?78U67g3Zkd3rH8ctQqMdzIWFkc9aIF9BFhnczQsv9d31Af6aTWlnFunthNd9?=
 =?us-ascii?Q?dTtRR0rzFje0HRnEhyZYgSCw0kx5XZtRoD6H4mr3VrDow6oWNHbV2V6Cktjm?=
 =?us-ascii?Q?XtFGGy7b7/LShetrDCbJ+Tu9FBMKLtGmFQYIHJhCRgJK+ZjS+uyjdQA2nrTf?=
 =?us-ascii?Q?h+hQ2+zm81OSRHNZR3jI+RU+fMisz07afW0LyIMN5xE54EWZXOwVm++hRyXg?=
 =?us-ascii?Q?YYyl2OgsuxGILo52k4nAdPpNG4EFRi0rAykRu3gmwSGdOymo6VDbIVqDYYZY?=
 =?us-ascii?Q?hjWAcS9K8i07FkusFkKIGybhcM5R9BTbhcevmatc4whOkazPRFt1biKrLlWU?=
 =?us-ascii?Q?qOHBI22dOSey4YhW8txSM4nsyyP5UZ2/SJOWiwe4PXjhJQaklEQUNlXZ0VUN?=
 =?us-ascii?Q?ufnDus9l6JmwbsLl9MXzIvUHQIumFXZ2hBsOOkwz74GGEa1UCt7hcS8fjEeX?=
 =?us-ascii?Q?8Fl2gVazwYzV0YlbWtIcjfuk6advaQI3Rjv73Zc/v9ogLQS2QuVlbkO0x0fa?=
 =?us-ascii?Q?OqkEaP9nbtSA629J57bzCuCoB1evpAQ4WrUHc9mDTDic5zCEEnMpaNJhc+sx?=
 =?us-ascii?Q?aeBl22qrJK3/4xe8MsO0MzdrPXdUDQj1NQFqtsy0qgzlMEbrFr55aoxBS/sD?=
 =?us-ascii?Q?o3P+uuJ4MbvO4BvWyv++hFy/0goJ3ehjPGwPdgklSIVwXM+j9f7G/4ucHE8W?=
 =?us-ascii?Q?w+7ej3r8WcEv5uwKk4qt/qS8gS0Vgm79HwwrghJ5yOSnMFY8HyWYkExJ1H7j?=
 =?us-ascii?Q?AeGfmsGA9vtOpfEai52ChGOC0bdVLpvcBCDC5E+LNgZFW4TD0YIcpMnByem+?=
 =?us-ascii?Q?mbo2jiN/U63GC/ESfJWmQaNdRx6R01xnmEw4e8Ib7QTtCatRsQVJ8VlkbL1D?=
 =?us-ascii?Q?1QGTciQezbJL2NR3elc8AZr/ZOWOb/xU+wpqS8N9Rbw8IGAXeKQzOZe2XkI7?=
 =?us-ascii?Q?Byv0BABPabyW/iaCmUeMu8SMPwi95LWjz5GlGTuxua5sN2sY2D11Uz/Z7Yjk?=
 =?us-ascii?Q?TYS09RfFpBnVVfEmiDCU4sYSy4jG56CmGKxv4TU8K9c3ZXrlIW78QAn9zfBo?=
 =?us-ascii?Q?5gTqj5bV0z45iPH/5SQg+xIdaQ8KPfVkBM7jTerg8ntKlOfOtxzwNKjFC3V2?=
 =?us-ascii?Q?YhFH+g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e135d1c-cae8-4007-1793-08d9f3f9a336
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 22:46:16.1990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1uE7vKMWx51fqcRXyjPaCTgz7Wn0mqZx9dgBw6ajSjTR36SuIcdelFY3WSVCkO94ryC9EnEMkRGGo4mTX8N4mp9Shivb3BGXkzg6/RCJ/xE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3486
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10263 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202190147
X-Proofpoint-GUID: 8BafnkQ3fqVkURvdPtN_VOeyrKD-o2We
X-Proofpoint-ORIG-GUID: 8BafnkQ3fqVkURvdPtN_VOeyrKD-o2We
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Douglas,

> What should the sd driver do when it gets the error in the subject
> line? Try again, and again, and again, and again ...?
>
> sd 2:0:1:0: [sdb] Unaligned partial completion (resid=3584, sector_sz=4096)
> sd 2:0:1:0: [sdb] tag#407 CDB: Read(16) 88 00 00 00 00 00 00 00 00 00 00 00 00 01 00
>
> Not very productive, IMO. Perhaps, after say 3 retries getting the
> _same_ resid, it might rescan that disk. There is a big hint in the
> logged data shown above: trying to READ 1 block (sector_sz=4096) and
> getting a resid of 3584. So it got back 512 bytes (again and again
> ...). The disk isn't mounted so perhaps it is being prepared. And
> maybe that preparation involved a MODE SELECT which changed the LB
> size in its block descriptor, prior to a FORMAT UNIT.

The kernel doesn't inspect passthrough commands to track whether an
application is doing MODE SELECT or FORMAT UNIT. The burden is generally
on the application to do the right thing.

I'm assuming we're trying to read the partition table. Did the device
somehow get closed between the MODE SELECT and the FORMAT UNIT?

> Another issue with that error message: what does "unaligned" mean in
> this context? Surely it is superfluous and "Partial completion" is
> more accurate (unless the resid is negative).

The "unaligned" term comes from ZBC.

-- 
Martin K. Petersen	Oracle Linux Engineering
