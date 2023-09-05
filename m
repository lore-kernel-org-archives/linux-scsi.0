Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23F6CA1001
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 16:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238442AbjIEQGJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354037AbjIEJYU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 05:24:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A82FE9
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 02:24:16 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3853OFXi023629;
        Tue, 5 Sep 2023 09:24:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=NuUNZd0xeb2OA7Y6ZDT9BJjKoHjjazFaHLoO9rBP6AI=;
 b=un4QLKmWhSa66Q/JEHjKMHVAR/bu50KSUxjZ+hkbswJwqOCSFuf2RFBuS0RfblPThCbx
 FABwYcR5jcl6JTi+hR+eOhhmgu3ksGT534r8FoGXZY0H3gW9D2EH7tvnMAWkJM6aANIg
 Tt3kaPO4Js+l3+MqDHmkXk4kt4iIRzwWzsJIEQyRpf+naqjmZfWdBGwM6PdInsvG4NB0
 d4ZHL5k/3Y8HsxziZ9Y/MESCUoz1+KV/4F/V5uB1/PgPUjd61krTwPJ9HSzimMRbsDC8
 FzJEwPPjAE2riRgIgYhKgW00yb1YHnlAGUihW4r6DDBOZoj6h/8xeGWDfFsmUtNj8xhv CQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3suufdmu5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 09:24:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3857E2pB037129;
        Tue, 5 Sep 2023 09:24:14 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugarxb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 09:24:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GntB0Nu6/xXg0LM7Ses2qE2J3lZjFnzWGkC2GFwK8U7SnGc4nDnKntOHyZfwvgg+nLJPqEK6+Ox9JXmVzI3g/4fhr16YfkKK5HXtufcXI6xcIy5TQhgFRdcRpmN3CnDbQumCQ+1acF4pIjH21Y9JXLuRRAs/oj4MyAxBS6nZPRN6YE1kqpwj/SOT+rViuVO8yAwmnDzdniYiou3pWf3ItW+Q5PxfF8PG4OEwzLK/y2wNSAdsWU6ODmqIkjgFBjJGxSsWHfk3EE1SYKQHpZova1Cwy4El5XNfTbxlT2Hq3GU0PQTG/CY1ghJIPUxcRJmpBlBP4hjUysz83ggs2cjgZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NuUNZd0xeb2OA7Y6ZDT9BJjKoHjjazFaHLoO9rBP6AI=;
 b=hNgcDUYwmYPnfINAjwSZqo7QzgNnOi3Wipezk2pw8OdE7/MLYvJKwzMvGWrK5q+FXIZqAySOPj2ioZtdS1HFbxum6LX2zOOHTZTs9eXxgzMxnGEn6wXSeuxqyAsoOMStqoqSKUCcw7R608cZEw6TTFwvwIiIJA1FSJ5LsV6vBd1T1CXi90IzMgTGVFbSxlrS9Izrjem2lNkPpHcl9ir61hNGgo3pCMO0UFNRTQR/93IwaBkidwcNV/UBFQAQhT+if8PE8diLfYd4gcEEoazpl/nCtKENrAQjdpowxqK6udjiBXg+X+dXVc9lm44lcOJRpSkFWICvg6PcDSmG+Lr7Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuUNZd0xeb2OA7Y6ZDT9BJjKoHjjazFaHLoO9rBP6AI=;
 b=T7YkL+j9wq2uf7GU4NguFv2jixTMYl2jq1zfc3ZQ2e8vF5wI1uTRYEQ0VDwUn0QlxZgsPywgUjz35+rcsYc/wysLXgAzMIVb+FvaFu1Y7KEEBLSIevPqFbtevwGWJRUy+P4P8c56XszExZQcw+M2ZNU46y9zRDazexoxo14wg4s=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5176.namprd10.prod.outlook.com (2603:10b6:408:125::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 09:24:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 09:24:11 +0000
To:     Junxiao Bi <junxiao.bi@oracle.com>
Cc:     linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, martin.petersen@oracle.com
Subject: Re: [PATCH] scsi: megaraid_sas: fix deadlock on firmware crashdump
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tts9km6r.fsf@ca-mkp.ca.oracle.com>
References: <20230828221018.19471-1-junxiao.bi@oracle.com>
Date:   Tue, 05 Sep 2023 05:24:09 -0400
In-Reply-To: <20230828221018.19471-1-junxiao.bi@oracle.com> (Junxiao Bi's
        message of "Mon, 28 Aug 2023 15:10:18 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0150.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB5176:EE_
X-MS-Office365-Filtering-Correlation-Id: 2384be51-7211-46e4-c05b-08dbadf1dd30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xMW6M1qpuE15eQZAJtiRDDBDzq2sJVIIJOhzbzA3FlaHOVLostcfjLjh8SYmoVJ5JFw4MjBZbXERUdsVHivaXIznhcmPjAwIm5rN1/SDU5vFQYucSFFHVPUki6DyOBb89NWRfnh+18pJWk5A9a5zzaE1/gQ7lofGbrZkPaWP0Acu473AZpEH9x6xH9Dr3J5LqTqxvYh8lo7NGp3YmFcRMg6LGO/iVkXJ+qE/5lzxyGeMYX7w6e+iCNQ2VVOi5F4wIuBptH6RZU+Ws7BTVENcwrS5fSm/w/zuc6TNxWkcrHnM2nYiH8E9HEpLCjFhccDkaHUJH5lPuyYAZSo1nl9kBOOo2mzo2NsJeoyG+8/bdiqVj7YUQE0e9X1ofOOhF2zgOWC9M0K9vJnFLhca5FEamg8GMf80egdkJV0mO/weYl/zBs3rUqnupSFiLsQzBFR3sCaXv6VoVkhM3O/M5SsL0VVTMhc0OWkWYsYJLEoWeYW4Tdz18lFaMSri7eSFm1FRixuoyww+uc3kCkP954S2ne7/Tub7Dm/+b1Yg2ejt9xOLGjJR50LW+2YP+m2LMiAY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(366004)(396003)(136003)(346002)(186009)(1800799009)(451199024)(86362001)(558084003)(6486002)(36916002)(6506007)(26005)(83380400001)(107886003)(4326008)(6512007)(478600001)(8676002)(6862004)(5660300002)(8936002)(2906002)(66946007)(316002)(66556008)(6636002)(66476007)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dpICZAHcHhoVkuFBDakJzXOXjan7bi9Xp3tz54pm3T1KISrUsPMi2d8ldSV3?=
 =?us-ascii?Q?fp4WX+KY4opbYe15K0O11cb1ZpDVPioGDQjMp8aCeSBM1jvMeIu3Nan0+W1r?=
 =?us-ascii?Q?DA+twUHCR9HrQQ+gKmIMvrEfpuira0369jcOgjPDSMu83sr9xjPFw/TzF3gx?=
 =?us-ascii?Q?XwfCwNFqcNAy9aI12Uj1v1o4EFjrkO4INAW68qJaP5gSW8CEyH6R3sOn9ovI?=
 =?us-ascii?Q?F5tHy9pyXFL56ujhZH+hS+q3wkh4N12GSBBoj7LbsphEJVTTspKJAG3AM/5s?=
 =?us-ascii?Q?iIklWNPAwh8MOp/HL79CrmbkfSDLEQjugAFWIDWuHmcKxv1naVpxhb5EwIy8?=
 =?us-ascii?Q?KUoCmW+Wy+I47J1qwBMAvDDEOb+xr8xX1qRqu5syPdZ7VEva8DwYksV74JiB?=
 =?us-ascii?Q?pD8ZlllGKcXOXPHZ/+7R+sX2ZVg6SDK/xcc88PaY7akZwsQW7LJoarplImbm?=
 =?us-ascii?Q?Rsry9zPz6mUfMIKfI2oAhhz4EdNdGUh7Zx92/x8SLF4XauSaIXsy6j3Jh0uW?=
 =?us-ascii?Q?nIMNVUgGsf0LQUFfA9pS7BPKQqExBVNICteWZD3ji3IaDYDz2LbxGBASDG6/?=
 =?us-ascii?Q?BIn7fuaDSthUuqIIMjVP0mWNkg/uj1ZXPFX9/EMxppuR6xxub/35Kn4pI5Of?=
 =?us-ascii?Q?YhN3qVixvGOEelD8Yq6gP8Kgf0Sgd931EnCiNHslbcjfbJVyb/75/G9ZW4il?=
 =?us-ascii?Q?ywIPfVdInNn2CkxcLhF1n7Gd+wcTSyWBk4SMCwuS6SrraKIAoJ48X7IqCZxz?=
 =?us-ascii?Q?AkUwKuLXjHtp5qBYv6rw8ThMoQK1cMQ5OdYV9NjKEGeEBvDL9rT7x6B0SIKi?=
 =?us-ascii?Q?ChOJxhqEbaGrdZvwr4/MJFUwhJLidP2hEDqTJW44TZQiiEjMuGKNClbVk+gw?=
 =?us-ascii?Q?laZTQRZG0o19nXftR9lv3nZO8npNLfOClmUGlkAQI5DCflZ4eF6pyYim7ztQ?=
 =?us-ascii?Q?2MbP0CuDh0/ARv9mt+lAzqXhhzyMNS/9L4pmjny4NvCGsAf+n3rRrEUA0XCJ?=
 =?us-ascii?Q?voZw2ROFO3uaZIR3BvDPMy9iP4Av6FEes/7OFeSLmSLG3RsCzR+vrovfwFF6?=
 =?us-ascii?Q?XIfMngOmumz669sbQfFX6Rgqu6e7Krcduym2iwZUoLtTLUrt7tTxmq9rZRKe?=
 =?us-ascii?Q?4xNleKJxdf+DQgM6sueAYVcUmnBMMQ8Wi5kn6s4tFSdkOKmmLMEjQS0gptgH?=
 =?us-ascii?Q?QJOHu7j3sfs/gAQkjkXVmFU8kXu7DRBOeYvak5ZulYG7OEO3+J31zI+Fmfe6?=
 =?us-ascii?Q?rPWkp24LWKszD4WxVWVnb8hn2cJKmBqBitk4pzwRFDb2jZK1CtdC1Whwl23a?=
 =?us-ascii?Q?pu0WRESrREttrob6j6ZEvyTQFi2TLdlnYMmmGdhNz0WemLrk2V6FaRyUE5Gg?=
 =?us-ascii?Q?pxcf0B8cRMvpuWOXeFfMyQQSvY88GspMzmoMXZauo4EQkgvwYYRYx12TqjK2?=
 =?us-ascii?Q?voFbLGH2WDkUwhhDsM1qQWr2Rw8LC+ASjEcUW7ffBN45BpL25Rc03zSwUPuD?=
 =?us-ascii?Q?d4umt5iPUyMy2mII1cZga40DZAYrxzvmIpJAtjpFv8EV376RFLhqAOokjIJX?=
 =?us-ascii?Q?9x+4/ct396J7g64B95e2kHxgDjSPxWpSYhxeyjs11IHu7D/CzF2A8OmqgISs?=
 =?us-ascii?Q?lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: aJe3nvQBrl95vzRqzpE7TcbgBpEE6ka8EMvmJhI5KD9KTpKCeZ7EQcGXYg/vgao2NbCybGwbRfl+npdrUsIjZp9KgewTZ33it76KDAEBjYAprKQYN5dmAX8eOJelrTkrbYz0bxfgAif+FpOhqvig0mKFVfTRIKAiZm8fx91ab+V/wSO0UtiE4Pik3ow8CAjcNyK3iQq2e+wscLBNgLqNvpx1m7NibV7pBhzmTQ/FOlKKeoRiwp10Jf6cLA7QG8m9YGpOpnebF7U0CRl85ZBctQn0UWME+kBYYl80YerKft/EmzZFrPw7s/gnPvAEmUqbKgVDqz8LJUsIzN7hr0XIcXrZ6TfBA6vcH5qwgRyAZuYKKW4IxQa+ghkvhw3pyX8WZtaRFrmcgVVrY2cFsHZya69Rz31QGO2LpKGW+fL3uUkb2aV++SZ1jvBSPFecAzNmFOm2HEzxKrXuQvfBwxXQMbnwAU7kBuzFlqNluw3UP4OCIG44oT83AD+nAJtKrowTt/mSBQd30CUpGbJlLJYf9/KUpYNjhrQgK75enzYJDluphyxZZLlDehZrX3Q+cd2FPhsC5PiBx/FYf8aL3UGa3W7YZvZDj6wwJh5zUCUoWIm3ZYxb0hZEePdzZlDUn5f98ZEKhh6lWZKlx8t3ZQpSwveCJv4vQV7Nw//iz4feTtn8hWfOmlL0HhwuVl6ErsKZG2BbVPRWcLNqPNvTPEvJ3nXeST2wKutRk8ZWKQivloQHrEY1AM0dEFmuHyh3JwL4ndnoAl24ZrbbrFpxq/8Wf9uMAswmCquHNdoJtX0eUCg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2384be51-7211-46e4-c05b-08dbadf1dd30
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 09:24:11.3827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5pb7QHJQjBt5RXLfZMsdKiPhfVK98UInTC1fs1C/iWqmGzKLzGtZO/q9GCp9NU5E9Pfzr9zNdd3sCmn2+54Gq1mKNHaho2ANLleyu/E+ijg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5176
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_07,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=868 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050084
X-Proofpoint-ORIG-GUID: ilS8JmK0TjsMipG0e5Vcse29kPWeyqOT
X-Proofpoint-GUID: ilS8JmK0TjsMipG0e5Vcse29kPWeyqOT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Junxiao,

> The following processes run into a deadlock. CPU 41 was waiting for
> CPU 29 to handle a CSD request while holding spinlock
> "crashdump_lock", but CPU 29 was hung by the that spinlock with irq
> disable.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
