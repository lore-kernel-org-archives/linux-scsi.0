Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C4EDC43217
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 00:36:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiKZAgz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 19:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiKZAgx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 19:36:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22DD528A0
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 16:36:52 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APMiQwr001270;
        Sat, 26 Nov 2022 00:36:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=pmY5u9vi93xyGGmf9EgJLb5V4kaeMpdIJqUES6ix/Ak=;
 b=mvBvLqhUacOVlwJzZBK7uHoa0+p4QqQn9/aGRr9/i/jOV/R3mikHZrLD0R0tDg+6LfIC
 u9cOTctffh2qYjFnmYQTmZZX3SjNoRum70yYmbnSGhFJX4Q1IFoxXm5+WC2uZa5Eu/93
 51qVdtHpPL2BixroHFGpeZpOu8MtnPLFjlWCD2ac+N1TaM7tTjIjpvrm+ndJc3h1cNi1
 7KndkEQy10fwR4YrkmpukgAgCOD5zFlXx1PPnq6K9DqC7mBWlD1jRsdQ61h3WJYHx1m6
 4DOKYhzeMBfxDFjFfInTE0RQJyFKHRVByT3Vl+0VfzuN72FlgFdVq3SGp9dRhBY4/YbW xw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1nd8dh7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:36:48 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2APKxdH2015929;
        Sat, 26 Nov 2022 00:36:47 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnka1wc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:36:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kf2IOsew5LqSxanDQifrxqqdcOitYELP1RuqIwJby7CXqZpeKQvJiEQUcIbv970KiVT5cJMsxijqR5yGzG+uxK/Xzup/nEi8f7QvaYa40SaGsgOomTFHa40Wvu8l1PBsctsNBhfdV0+PzVot55qs1HY2k1TUx5wSK0PSk839HGdo7hHc8wBLVkO1/5HZEyLdnHJtjS3l03mAtPNGhBmTuDmfrthTGYA0MQuPRcLnSi+lTtaxNrDAmxxOjwYAWa7gbzz234luWdAhgeZPHDJJX5vHS6UM6Rqry0P0Dd/1o4cawAo+URqmwrUB8XJiC7JDZHvsq5B0WDl/wBLA7EC9/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pmY5u9vi93xyGGmf9EgJLb5V4kaeMpdIJqUES6ix/Ak=;
 b=I/6/ERBhxlx5SkgnEXw5UjDB1mHBxEhTvid0LTR9Q/U8UQspSS8k8MPQCQUVJBghPAgv68Uyt0yS1Y3RsPyBStTCP7diApF/huFH4pehkRMttkWr7Yc3xe+neZhMUJSOCEqea94+fFGugl/QdZXq7+reRsv3XSoUSYFhN3cwdAgV3gI6ychmctHgzEFqKyogv9z7IX5p37aOgB5jLS6NYzJUOXz/lPLkG7OSmYwgi5lLkhEUn12ILb8vWjHbTkGfIzyO1QaGIBoprEKQEEU/0DvSOGThm7yOSakGzg8lfYVuQp1BZEs4mlkYLL9jvyZNGtXgA0QFopjiDJZ79gSe1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pmY5u9vi93xyGGmf9EgJLb5V4kaeMpdIJqUES6ix/Ak=;
 b=yiENrAHxw2dvzVmOmkwVP/zVZGpmxDs+xu400u3Nc0aquZD/CSkGJrOb1KL0fXZmQ3QwHezjAbMxPwlSd1lKWduoXvoRfAQBLKCVLwNoQl/Snvaqu0ElAtDICsCF92tnINWM74BTHceA59YSHayhDR6yys63SLFZNXG4DAN5MVY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL3PR10MB6116.namprd10.prod.outlook.com (2603:10b6:208:3bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Sat, 26 Nov
 2022 00:36:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 00:36:46 +0000
To:     Gleb Chesnokov <gleb.chesnokov@scst.dev>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] qla2xxx: Remove duplicate of vha->iocb_work
 initialization
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14jumpn57.fsf@ca-mkp.ca.oracle.com>
References: <822b3823-f344-67d6-30f1-16e31cf68eed@scst.dev>
Date:   Fri, 25 Nov 2022 19:36:42 -0500
In-Reply-To: <822b3823-f344-67d6-30f1-16e31cf68eed@scst.dev> (Gleb Chesnokov's
        message of "Tue, 15 Nov 2022 12:38:05 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0033.namprd08.prod.outlook.com
 (2603:10b6:a03:100::46) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BL3PR10MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: deb9948b-6e1d-4485-08cb-08dacf464c1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oBWUfBeaDsYp1hR3aNN/WPvtMkzdwL4QauwcXWnMWYn+OP/hC9zOkAclaWnIELJ4/JdOwQ87peQQEqVEw/9Lp2tk8QJvQODUHekY9gqSBYUkXjeRhQuzaSYnro9/B887WjEPGdvaTeuF4CaYe6i1cQiRsyGxOcc7bqg9a/yHXrgV8LVAMQtB3zPlM55vPaCrMv79nY88lWGoR49nf4qo8uSdA9hcFC+q2eVXEOZDBhkxEgpkcsA14fz0mSCBqKl3eFNxGMj98w2VNnP/G0jPn0Sx/UZNSBjz1uzdWnQqdVDhbl1nmTRFUOZ071GYJYYMP1WdZXcwhwfesuchivSZ+iXt4bC3nlvRSOJp2vFk+lgsNlV91N+9VGQzLmvIOTTnbdS1WYbWkYycSF6vUjcVj0VC3t13uNPWKTfjwvukY1LspMcuT8CvDSJaEoC5A14RWWEr6haPtY4v5GX3icmOxMCWhMEYNcRVyQ2VxMn1MEy6ZxyQhUj7AXJYoYahbZb/ftFYQrYhJJF1gomeiiGDwQlYx4or16ekIcR5sDSVslUi6ee6CA1xpALiIaVcqrMZXiJn9Ifz19f4oG7sdm+Rh0bdRxcMtYMo7G0/GtndUXbbi8hpDg5TaP6g5h7rQILJFaczVsbC/a2uiMW7UpTQoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(376002)(39860400002)(346002)(451199015)(8676002)(2906002)(86362001)(558084003)(66946007)(66556008)(41300700001)(66476007)(38100700002)(6512007)(8936002)(5660300002)(4326008)(26005)(6916009)(6506007)(6666004)(316002)(6486002)(186003)(478600001)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tc9nG0gaAPMzdOoCBqwgVo+fq47ZbDLNGbQPB18wHS107DHh2vwIfZVM/0jz?=
 =?us-ascii?Q?KdS0VBmwJmFK3b5jptuINarQFjbYZGvLjlZBgLFAROyvM7AAyF2vuYfR0/87?=
 =?us-ascii?Q?edtzBVucJsXMputsza8kSFA4fXhQX2BrfbRJkfG9RogYlHnZLDogA0f07YsT?=
 =?us-ascii?Q?oc49Wkl4YT/+bM0xKOxhZn7Uc1ePJGgnfCgigf1VWQoxxZQgG2yBlza6iRf/?=
 =?us-ascii?Q?AAujfhWytPw300L+fEM2Y95KyMz/o6FGDqp3xjUg980tNGYjzQyDITzvp/fI?=
 =?us-ascii?Q?sWW6wUHW3dhAbEPZgMeCniqncfw+S4lzpnpzf522ER6TZa+4k6ni8kzlnIK7?=
 =?us-ascii?Q?XmZNf+a10TD7mkYmWA2nzctjyXeJaIif4aAXHNCZXdCjmEcdLRpqEzVl39CU?=
 =?us-ascii?Q?OgwMOjy9S5NhhTIw2vLASCNZ/8qODK++/EQFw5ZM2G55fRlFfJlufmEl26L3?=
 =?us-ascii?Q?fxPF3kE9owT6N97e6QvVRZWZHb+y2uzKAOzDKvOO5spoMKcmLXoEwey8ES18?=
 =?us-ascii?Q?KyczTvpuadj/qbjMR1hR0te0HAaHW8Kg1dibfB1wglZ42i5APVh1Ue9aKjJH?=
 =?us-ascii?Q?5v+zra/D+w4xp1u0lqepjH4K09xWLojvatmZjo3ZyIyYUG94+iWEQzpWDELV?=
 =?us-ascii?Q?zKq3U7TmwCbOiig0DhjS76geGHgXLIHXCEIUMslduBzYkqC1dmp93FGtazon?=
 =?us-ascii?Q?7WnsjHsf2JMzhd0LsHAIUoZWkYj1Ueky0G0ofIbF79jLneYswyACA7tPiTjw?=
 =?us-ascii?Q?OcP8n/Ye8QNAQ+sJmwJ+UWtNfgr6CM/HlQ1h+TEL3fhgT/pWzunayA1G8zsP?=
 =?us-ascii?Q?06WMJGQGZFWBwwjrP+uSSLVQ9dMYgobhPDEOpg9fxTV3o65+1Wng4kzmk5UF?=
 =?us-ascii?Q?o6P/fUmrTHK87FdsbHyhXPeJSKmAm+wZSwto0qp43boEPNzysxuCBhQrrHRD?=
 =?us-ascii?Q?BVT/gGRSPv/OHPewLYFFZ1AAPc37udRLXBX8aoM8n+pOqqNJNqTXvuzjs/UK?=
 =?us-ascii?Q?i+cPNiFYRqvSlzrkSuFppv2eY7XPNcDvysaWgMzLXVZl9eHfjfc1SkYI2jmZ?=
 =?us-ascii?Q?2lyVmy+DvIbHQ+lGhBXYRP3YvVBdobYHiEGIZ2TL5d8Gv1RTNbBSCq7n01nF?=
 =?us-ascii?Q?Q5JibkPfeN1Ta0JRalv0O926DZv1rfUjb0AkewkiRaGW8M3e4s3YJ7Y9vUeD?=
 =?us-ascii?Q?KFSA91lyYJySkxJChtI3eL5I+GirIeknV+vFQvznTwaa4GQG3V3ZHJNyhps0?=
 =?us-ascii?Q?TyuOIJtdV61yMCazTREe27fpVSgdk+ckVze4YhMKIz/n2H7wpF1wDWroIn50?=
 =?us-ascii?Q?zO/nCEqbdB9jsEWvmcfWkUrk8BOLDCPvUDQehoTp5WLo9S3n0V7DDm02dKOf?=
 =?us-ascii?Q?v5utdkHpE3IEcZ1dEsNNQQGoBECvwnC53NvpMS5g6EmjQrRmSVZ5AMIiWYvv?=
 =?us-ascii?Q?UqFsVOmph7Y2LJc+nd/TX88bBXvrrzthnt6FlNuN5mLDMNsKOWDtNIxYGzYh?=
 =?us-ascii?Q?Dfm9wfa7REwf29h8X4jWjdhtoPQeUa0/u+Am7Yls22+JWG36Pk4cCqzTUGP0?=
 =?us-ascii?Q?8i3J8z2agAaCVDdp4airG7z6MneKrQJIW95zxtDlDO5oNIlkjT30c7KPicAc?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OFBzj7FO92LLRyB2ME9azEQyJ8YSJfD9FSWJrU80Uri79xd8er56+OSZJiYmlYU6ZW79ywzFTGMQpbJ0h7vNMnKOD1D5AYvk7JguGpAYnpGtWZzPNALniVCPhAacKRN65TNPpM9MUTQFNBQepM+Oi798sQRxXU4g5xZaGBEf1jGfx24LlH5JQwnOAzKSwxGXW85LjLVQXIncCsEW690aKWMiQH8/9OgRjkx3ZD10ZVW1DbWnx4PBGCwUa5z9ovDGQOQklkMabdoL6uWqF+hVAfnEJGMR0ruSsbKu7fzR7VgolRfNKx7HiyrlryG5RqXoPzgi+bNAs1NNs/q6ZWfxBMdub8DZvrKe/t5STeELmdQHm2cJA0c2pMDDfNa9CsM46dth98ecs3Af7yQV0Sb80CM+8w/Ujd0USqr23CV3bhBoD+7ePLjHOnf1QeQ7j7fgu3y+eHKKqHT/dDL4d+Z5Eb+SYQPtIN5n6PDmVoRd1GST9jnkNcFB2ndp9e/cb+Jz6CDeVPk0V/gPOlx+9YPw58E6p2+GF6K7qk7ozcO8lKc/tws5Z8/oAaCTip3A0TNsliEBLqdHtyipbTMvDElHAtQ0zfY2QSCsEPMiBl0lrJ8I0yScZXNhe2t7wJh0PkZOYAxjfeCaesP7IM9IMvzkQ9Peylgk403vsF3PjON889RsIvIZc1oLOLP05TrHJhePVc30Yotwxb1Hjo3UE17H8aiZLbPiVB8cJBoYHqYZ8wAmok+PoHv+Cs2ejNIuIUY6G79iv1jv0sPoTR+9S70jJvKybXyMQNc7wjecggZQgu8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deb9948b-6e1d-4485-08cb-08dacf464c1d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 00:36:45.9383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bf4qyc5hxZpWeqwqnQWKW4wIeC59nQXxNoryY39NuGup3nr6+Pn7NAKHJi8MK6UbVkHFFAprT4rKl13n+6Plt9iJuAQYvlB+TCkSKaAJR8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_12,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260001
X-Proofpoint-GUID: Gd5V_b8OsKGiXGEc5h5Zf6vMsdmjIzRL
X-Proofpoint-ORIG-GUID: Gd5V_b8OsKGiXGEc5h5Zf6vMsdmjIzRL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gleb,

> Commit 9b3e0f4d4147 ("scsi: qla2xxx: Move work element processing out
> of DPC thread") introduced the initialization of vha->iocb_work in
> qla2x00_create_host() function.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
