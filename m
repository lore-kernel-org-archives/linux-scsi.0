Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90653C43334
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jun 2022 17:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiFFRKu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jun 2022 13:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiFFRJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jun 2022 13:09:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171D613F4C;
        Mon,  6 Jun 2022 09:57:29 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256FTlAH000558;
        Mon, 6 Jun 2022 16:57:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DyZpxyJiWl60MNtcvLhGsKlenY2Y28/+DovaaEhhHZY=;
 b=o1OIrIK3tCpgo/W0izjY4Yn4+Z67viEqXz+P7isMSp8mLxqWgBuKQvclGjcsZxM3vUo4
 Fo9JYjxKq+Kt4oCyiPuunQQxzD2QqeQow+zucHVUgWweW8AN9q4OaFYIdhGcWCfp+Dix
 /sfHQsoseu4mZfH64aj8u+3EHXU6P78tC+pZ9+G4mvICRg3LdlMdIgd6OrFgc7wR4mKk
 HSHnBPThsGbTG2NbGvGC0DM/5xWXvfN3P+U+LdcLNZ2N1UcWERqI5OPuzXg/xpNQ3YXE
 L5u4lm/qALnRL/HYZh4svhzrpVM3+VF2fmtj8Cz1KDV5d/ikbJaNbOe5ZbItY7WGEnXn 5w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfyekbkkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 16:57:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 256GLtra007984;
        Mon, 6 Jun 2022 16:38:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwu1un10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jun 2022 16:38:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZU/s2ClRHroX1d5cy4mWOz/pvq4/ucV2xJq7p/njrNumcZm+4kFS8k3afZaBHkPhOIGINLQjEeU9qoBQUMzUBZpqON9RlPmd13CzLuHuuYqkyzF3+O/9UP2QB7APSQfTbMYG00jSH/1KN6wDxDZhOncZqqULwwwtWkfleM4jM/Wn6qmmea9GFRiXr3SqT9THR7V20O7mUPhdxxJfmsptE2RHn/tKnJxvMP3sbymjtA8+6sS2qkTrZmctZ/6dbsW8exGq9AIdUY73krDaRlMl0DudR0XfxjxxqoAObjL+HKTqxnrxq/J1B/Y6CpoJyeDHzORV1hWUO+X022Wqb2D2fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DyZpxyJiWl60MNtcvLhGsKlenY2Y28/+DovaaEhhHZY=;
 b=NqlAzHkJHM0p0MPzeQiF5hEbcfiOLG0ZakiEWAao45ZcHpeSohwBRrap/OzhH0wlHYRAi3jKsiDC0H0G00zEz5iJue2hZbrHAidjfeB3R74RDO/jjLndDPpTf6FpcLzTIf69rYpfY/0h4VR3suXCG2X1Zf+7GgUgk2SLNQ3evthkWvx4n5n+nBr5YKL+4GZDJUI7A2Nl6G9MJoA6XbmBCFmykZDvm+I+Pal4jzRYcN/Nr1lzNA/098BiUJO9PlJcB/1eUzczrhiewEFWPrXikCLrBzRw3LvazATVnmbORvsX5rEGW8addGEISoFoErQzGn1LVRO4p5gDPGq5yVX3zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DyZpxyJiWl60MNtcvLhGsKlenY2Y28/+DovaaEhhHZY=;
 b=Z4J97tg6/eKxEDdOek/igbRpjaVBP7kFZyBeZWRyguzHKQMuyEL8AE8CVK7ZvozfCOsYCZWd8UlKBbv8UKX8Xv24POtNO4ePujHnnLhPkhn+y0myan0ZQ9RbKeqGoLvjuLbOUyfRSOuL9DVb9yqTqMSmKDZvhbM7bKIuype+TYQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5753.namprd10.prod.outlook.com (2603:10b6:510:146::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Mon, 6 Jun
 2022 16:38:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 16:38:04 +0000
Message-ID: <d7355a7c-9587-5658-44c7-09143abe09a7@oracle.com>
Date:   Mon, 6 Jun 2022 11:38:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [dm-devel] [PATCH 0/8] Use block pr_ops in LIO
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, hch@lst.de,
        axboe@kernel.dk, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <923053d3-adf8-e4b4-9ef3-8e920ae90a79@acm.org>
 <d18d9e19-d184-357c-9921-d024f0b50d1a@oracle.com>
 <09be5981-705a-5c82-a189-dd7f0475d227@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <09be5981-705a-5c82-a189-dd7f0475d227@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM3PR12CA0105.namprd12.prod.outlook.com
 (2603:10b6:0:55::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f81599c-f3ed-4bb1-c5cf-08da47daeda9
X-MS-TrafficTypeDiagnostic: PH0PR10MB5753:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB57539C35C1E5365499BE9D86F1A29@PH0PR10MB5753.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nSlMRIeBRBN51GQ4blwUVDwiZhH8E08tjwsdm/Uk+lGTdFQl40XL3JojK+KPemXU0Vv0eLrAgNGHQWn9B2Ly4dp6SsUxriIiZFva7q4JVJ5btmm8/gErYFEYHdP5PGiif2X1Th2VG1aVgRxemDFjj3g3WtAE+WxsDB08TXqNq0J9y5VFjvvqroLgQhI5ljehpbEVb0zSYx1lmU0GAUggQN1O94hfzOmE3N+Wf8fsPapPPMO7pmm1kN9FxrjOqS5Qs2WtD0sHX2EHOrK3uFUBkDNDAFXP2756cAZyMXgd7Q4IqdvzdHVOcrhhlthnrQOcMkU7BtSV21UFU9o3VO+3LAgA2b0sjQx6sI42V6fZXTio3aRC+0Uj15emXLRNU00wNhOHDEps6xUJhaJYIgt1nxqrLUoMGUtWg1dq76yA4O+3bRi0lPPZEN4yEdjmavWEYOZV5Yee1/uqKKsuB41nceelJC5ZRQMwVHmxrqHQ6G/INSGe1vumdKE8LxBi0UKD1/ffrqYEnJEKkuOMh0XBXEAGDHRtl5zWaYougBbE0d9S8NK3clS6qAitWynvvlk6DlOFJXddFViCCnDMzW/D4a8kBPjK0tNFjuU3Ogpc1JykHm2a4HivSYcsxbRt+MFWO9ei5sPK+BrX7GQK90na15TdBkM+XpI2y22fv09PZIbI479Lqmi8ydkoHSJNhgCTY7zcP2FtN+IMOvTJ7+7Hb2NZ6+qntbqW2pMyv3Hm3CuGyDOIxWLTvvhfPqwellxL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(86362001)(31696002)(508600001)(6486002)(186003)(38100700002)(921005)(26005)(53546011)(6512007)(6506007)(2906002)(5660300002)(4744005)(83380400001)(316002)(36756003)(8676002)(2616005)(31686004)(66476007)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUk5VFNQZEYzV3MybUp5b3FYRnhGRmQyQWZhQmZUL0hhbW5BUWJIeW5HM0sr?=
 =?utf-8?B?ZnJEOHVhTStNcWlsS1lidU4rUFlBNkd2WXhTejBrRStzdm82dDE0MndJY2JE?=
 =?utf-8?B?ajM2eFlLejcyemdKSXFYVU44NHl5STF1bVBnbDNjTWFyOFl2bHlrQ0ViK3M1?=
 =?utf-8?B?Zk9tbWpVOWxxaVpOb1JqWTBkc25CVVJwenRtQWNQUVQxd2lRckxpNVQwRE5X?=
 =?utf-8?B?TW9Mc3g5TVJHbUNjN0dJQlFsZm1uTlkxbHhXci8vdTE0THBhSmVnYUJheVFZ?=
 =?utf-8?B?ejZieE1RRGFnOVRYNlgzM0pxMEI1WXJpbEhoS2lJbkhsOUNzSi9IV3hRdlVM?=
 =?utf-8?B?OFEraC9yNExXZmFHVHI2UUszdEs3VlcvRk1XQndMZk1HMTJDZkg4YnVZcnVs?=
 =?utf-8?B?Q0dOclJSMDZCOTlQY3didG5yNlVpWmVGMSs5a1BDZkhNUzNqVHEvbDlOTEtw?=
 =?utf-8?B?cDFjdi9CK3ZCL2MyNnJWVnRWZnRrNnhCRExoNEgrcFRVRWhxcWJPc1ZBQ0I5?=
 =?utf-8?B?YmxYRXU2Zmo4c0dNVjFydnJOZ29lS3FZbTNOVUFFdWhwc2FMMGFIdU4xd2h5?=
 =?utf-8?B?NjFydFJudWdRODBDQUFRZlVJK01Bd3MxTWEvTTQ0L05OMDh1dUxQNnZiUkNv?=
 =?utf-8?B?V2hnSnZyQlMzQTZhanBRSjcvbUpzc25rSm5aODJybUFJR29CeUJLMTh1dlVH?=
 =?utf-8?B?Y2I1MGozL1JaWXg4Q1Ureml5eHBQN0RlRCtkVmZlTmJOZTdQN2lxTzZWbXhi?=
 =?utf-8?B?U1pNYk9HK0p0ZER0U2t6d3Y3Q3FvNzc0QW9DQnMzQkhNL2NubFY0aGlNVXBz?=
 =?utf-8?B?Z08xcTYzUGtCc0VZQTV2MVJ3WWFZYm50bHJyM2FNY3JZekRLWitsUE1GNWlS?=
 =?utf-8?B?VExZdHNUTjJKRnUwSml5VDVQOEFCc0MvUGV4ejNQWFFVZ3E2UzVTWVp1S0Rt?=
 =?utf-8?B?UGloaElGKzRGR1F0V1BhUkdrdlBpcEJWWDZkQ2FDL1BTbjVUZ3pyRXlKSytm?=
 =?utf-8?B?N2tHU3ptR0VDaVBlTGpQQXR1c3BJRU8zT1FPZFl0ZmtJTmVzMXFFREtXS0RU?=
 =?utf-8?B?VDlqVGtvczQxd0VEM01jb3hBTDZocWJKQTJnYS9UTFpoNVc3V2VnZHMyN21w?=
 =?utf-8?B?cWlLQnMyL2lQdERxaVFvdkNnWk9lQ3R3Zi9vNlMvUlFGYitieWNqeS9kKzZa?=
 =?utf-8?B?MlV3UHNlTFQ1eVowTjVVUnFFb2x2T0ZYVGpwK0pzRlo5SHUvdHVjMHNmdTdB?=
 =?utf-8?B?RnhGMmdIWlZlaUxadTBlT2dIdVZqOWwxYmVmTjlMUGV3YmYweXprQzgyVmJs?=
 =?utf-8?B?RUFsc3RoZmNIdG5pRXFRNXV1T0Z6V1d0K1pBdEI5Z0o5VytpUGtQYXlJMUgz?=
 =?utf-8?B?c2dDaXRpWDAvclUxZmtIYXdaR3JPakJDLzZRZHMwL1pMK2ZrSDdUZUlQTDk0?=
 =?utf-8?B?Nk9uRjNCSERnbnA1a1VsNThwd2hKOTdIdkRZNlFxd091Y1M3N2svTWxDMVh4?=
 =?utf-8?B?Ri9XeVRBcDIyU1d6a2RMa0c5K1ZNQmE1aWR0R00wdDBOdlJsS2xBTGNIRGNC?=
 =?utf-8?B?RDRtMXJBNU9tS3ZIcWttRENUOXM1WkZteUd6UksrakdWQWR6cDA5YzF6OFkz?=
 =?utf-8?B?UTlNUHliSlh3b2xFM3JQZzgrTW1kcW1CNUpYOEUzeEEyYnZ0SkQ0eU03WGw5?=
 =?utf-8?B?dGtxZit2T1NtQUd3N21oMUJPVXJ4NHFkL1VXcmllYjh0TzRZV2JVdDlIdmdZ?=
 =?utf-8?B?cXp0UzNDWStKRGI5VU83MTNWSHNiMTBaZzhsWm1oMkdUNTQzcWNBUTZ5a0ZZ?=
 =?utf-8?B?VFhicnBIRmVBU1FPNzJSQWE1enhrWTVmaXpTZC9tOFd4Z1oxb3NwNmtxRTZE?=
 =?utf-8?B?Yjl0RGtQZ2Y1NWZPTFVsV29BV2VFTmFyY2dvMlR1cjc3Wm9JcVpQWXpFMGxk?=
 =?utf-8?B?SnZVdWpTYWVzaVNIelI0d2dFSzJ6Y0NvMHVGd1ZiNnJBWUpaWDJvS0Qwc09r?=
 =?utf-8?B?cVVGMnJRclNhaXdqMVNidFYvcUZTdXV0WmJvUDIvaDZOT2k2VEpiemc0TEph?=
 =?utf-8?B?Nzh3NWZ4L2tFSkk3TXFoMDlweDNQWDd6Z2wzQUVXODREb2lvcWkxRXoyTjdO?=
 =?utf-8?B?aFVMS1hqdkl2RXR2SWZYa014TTI3ZzhBK0tIUFloemRhQmM2L2NsUGl1QUxC?=
 =?utf-8?B?S3pKMzUzOVhxYnVFamMyWVN0NmlrYTljdHVhQ3R2RjYzekVRMVBMN2s2NGxV?=
 =?utf-8?B?dWdRZUhzTmlvUDgrbERDT3R0MU1zcmI3aWFRRDFtM1FKS0U2RFRxQmFEcDhx?=
 =?utf-8?B?cUc3bTcvenl3U1p1SXluRXR4QW13Y1ZIUlhwUFN2ZmF4UWVBSHF6MWlMcFhX?=
 =?utf-8?Q?yHfzoG9KeWzqhdPo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f81599c-f3ed-4bb1-c5cf-08da47daeda9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 16:38:04.5396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ul+uTNxWh3l3IuHjKexbxECvV90VgYo5tv59GKhWrJyoAqidmN8RqlueGzkm3xkHKTI2Cl5AmEAsHMvGgYUeoKHmkRgXEUBQszMr/7Qo1uI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5753
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_04:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206060072
X-Proofpoint-GUID: npGOz1lv75vJPLW_suEuYXrSdyPo14fc
X-Proofpoint-ORIG-GUID: npGOz1lv75vJPLW_suEuYXrSdyPo14fc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/22 1:15 PM, Bart Van Assche wrote:
> On 6/5/22 09:55, Mike Christie wrote:
>> libiscsi is not suitable for this type of setup.
> I think that this setup can be tested as follows with libiscsi:
> * Configure the backend storage.
> * Configure LIO to use the backend storage on two different servers.
> * On a third server, log in with the iSCSI initiator to both servers.
> * Run the libiscsi iscsi-test-cu test software on the third server and
>   pass the two IQNs that refer to the LIO servers as arguments.
> 
> From the iscsi-test-cu -h output:
> 
>     iscsi-test-cu [OPTIONS] <iscsi-url> [multipath-iscsi-url]
> 

Ah I didn't see that. In the README/man it only describes the multiple
initiator name feature for multiple sessions. They don't have the
multipath arg, so I didn't know you can pass in the second target.

> Did I perhaps overlook or misunderstand something?

It works. Thanks.
