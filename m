Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABBA8C4743D
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Jun 2021 23:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88179613B4
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Jun 2021 23:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhFEXz6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Jun 2021 19:55:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47304 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhFEXz6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jun 2021 19:55:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 155Ns5PH097134;
        Sat, 5 Jun 2021 23:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tF3493mO0IfVOZj48r4o9zB7f//KSObg2jiKuIGijjQ=;
 b=ahCEUR9R/rCiqMOaaplTMJP8SWa7NJBfroB2qx0HXsb8YP1FO5gcblA3aPrmH77FH433
 I8TmOprT/YCaioF0z8MFpghIB98jlDvkkcRKtaQUV2cmrC2sP2Skk4JnSVfd3JoypxJR
 hQI9pdaG/gdEZ+v8fnl0KRveD87X1iBJ3dKl2p7ENQYVr1BSE9OhIagPnqa7PcU7WWjs
 8Rr7W14fB19n4I5GpdFvBfkKpPGM0Dh2J/5Jxove6uFBaxVt3GY2JeIdNJFOLgF9nJF3
 ySYVMDCN6i9MrsdSORCew5lietEq6s2C3ZVNIryE0MREhgsM9P/8PgpUx0L2fVY9tPX1 OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 39017n8q9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Jun 2021 23:54:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 155NoBEE130172;
        Sat, 5 Jun 2021 23:54:04 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3030.oracle.com with ESMTP id 38yxcsv77y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Jun 2021 23:54:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n34nHvzLKeGokXDP78whzBn7xf5FScCuqo3W0mGx/gOmJoN2szKqLoAOpYgeQmdoSLQnCXlwsIgK3FNdirdcwaZCzsUYvPAuXZEp6M8aGg7WFvbIDeJDzenOTOno4tcB5WszLKp1zS05ftKjPOSO741ltdxMqwyr0DVeM7eUNgmS3/vvaCZxmBHQsKfblDrNDs/YSri01n1Md6ArmTTqr9GqibbcyvLDE1vnvxtKw66cAMLtfLwec4S4OqGwioe/Sg3wzdKWn/FL3oTwZyFJJxBg9PXFmR32fQLJ+a0qCdNkeCyWCyLd2RarjFDSvT/bNgkggni5GblZ66VYQSzpVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tF3493mO0IfVOZj48r4o9zB7f//KSObg2jiKuIGijjQ=;
 b=RY2P6U6MZXXuuZjZ7z9ejVXGSST9+P1A6jMwPFjH62Ur7U+elFKd4AZJ2RxyWsOFOFZjjs7ggQ7CXvH53uRIMWgt+6JaXkQMCjjOCm5jHiI0OyWd6xMzTL32wZZ4QRuPwdQgG/dyY9Nb0mb5VzYa3M4BynFJxzVYFjLdYsJPKdI4I+boR8C1+wCmXt1z4+cRe3K9UohXOQN5LLD3EfJrtEaZaXOHGmbfOtPOf+r4OXN7B/vOCpY8hnS+qtz7HF1TLxhk3HAbTiQgDvvfGd6oZtXu7ThXw9VR6hT/f1/LszWXNUxjVQ8cUinDwv/dyN0Zlth9I2UG+DmQtYD0uwD+3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tF3493mO0IfVOZj48r4o9zB7f//KSObg2jiKuIGijjQ=;
 b=vu5+nKjH9ZJHOvrXEmZTxCrdtymtFJ23GJOY0Bt/Xp7HxzNoBmkeQd8a4SpttwrR/opXPB4sS7rADPWMcUC+tNjYTIiNPHdQAcXooH6d2XX/8+M76RLCANjjmmnK/sQ3JAVO7ijrOGopp+VQo8ZvhSz6jpf0BhWw3QwYv6MHt54=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3285.namprd10.prod.outlook.com (2603:10b6:a03:159::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Sat, 5 Jun
 2021 23:54:01 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.030; Sat, 5 Jun 2021
 23:54:01 +0000
Subject: Re: [PATCH 7/9] vhost: allow userspace to create workers
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
References: <20210525180600.6349-1-michael.christie@oracle.com>
 <20210525180600.6349-8-michael.christie@oracle.com>
 <YLjnk5GpFaCCOqCU@stefanha-x1.localdomain>
From:   michael.christie@oracle.com
Message-ID: <0c1aef53-4850-8c46-0706-9b7276716e68@oracle.com>
Date:   Sat, 5 Jun 2021 18:53:58 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <YLjnk5GpFaCCOqCU@stefanha-x1.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR19CA0013.namprd19.prod.outlook.com
 (2603:10b6:3:151::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by DM5PR19CA0013.namprd19.prod.outlook.com (2603:10b6:3:151::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Sat, 5 Jun 2021 23:54:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60ceb576-d062-423f-0e71-08d9287d3107
X-MS-TrafficTypeDiagnostic: BYAPR10MB3285:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3285D7242B6487FFF82524DBF13A9@BYAPR10MB3285.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86qtMKSrnGRnoVuCfgOPs1DE/RaFp4sQw5YoafpHx1hHjNuegvLKvDrildirsaWpi7/ww1VCXrYStMP5Yxv3hmNLE01lpthgNfi4EflmpGlzznP2ZTg1j6UANVZzTuzhHZRHnb4yRM44RZYadDdnLolLfshy4ICzAZc0K7Ob3KVWP76ug5EKTMK5L1VLw/9KGG8/kuUWBemkqQ4Y/pPzFqaadmWoh1i14HqnQ+REyvPKPt0EztPb5VWOpiV2V3uAIatm+AmC03bxpPzh2IPerj3Upb0lPrRomaHRB5U/tcieXdTx67uG4N/JeJTvjZEHNcbK1lyQ+iMwmXP6CVsRZUxaZbOjfl6H3l5L9QEBkGvQBHsl3kT5wb7CurDuHzOnaoJa/dHwHqN0orGmUrG2CsXgWGedFBn8OD9sMI9vIHAkFSA7mR5rxaRLdKQPhWSvnOfevnqlnZCXZbMPidzEdg7JenBGZ7xWsbZ368nEoX/f9xS72/29Hgw5ifitF/jxzTAPekZV+9zLXGO5Q4/P4LLonmjhc0AA1LQchGS5dA6C66+VeZc4px3ISpefHc60iA/IkaKnkvpQKPa0dcI8NoQsfzNjLEk0EBqE3XJ/PKaseXsCZpO3vOWEko4VUIa27R3MY0rhH+Ttj8xouPi6EcsRabe1PAMxUoK6V6Z4/BamEZWtSIWnfpzYDGZ/BStI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(376002)(39860400002)(396003)(6916009)(6706004)(8676002)(6486002)(36756003)(38100700002)(9686003)(16576012)(31696002)(86362001)(478600001)(31686004)(2906002)(8936002)(316002)(4326008)(66556008)(66946007)(83380400001)(956004)(2616005)(26005)(186003)(53546011)(5660300002)(16526019)(66476007)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?pkwqSDfaSwpgrUFV6lHnXX62ZmE24XseAl0W+eLkiJ13BeSRDf2h48BJ?=
 =?Windows-1252?Q?CnirbL9sP0IiNwlD1ddZL2BEdRHh8t6oJdv/Xohy08elp9APOXHjSNyy?=
 =?Windows-1252?Q?SRN/Qb034tIKo5942lBNGW21qtw+haMqVb8OiIdssy3PrffdRghk0Hyi?=
 =?Windows-1252?Q?RPzCW10maVROy1+zvB1uiYfhJNHIfumlhNmeAJEm6oQ51vlK2PfwhA05?=
 =?Windows-1252?Q?BBlCSo47Q+87JPlpPs6dUb0jDClg9gWrRaxwJlyaDImzux6gVb2VW9Sp?=
 =?Windows-1252?Q?lK0UpuLpWnB6UWHZikBln5NKPrMQedjmYz00WyFEL9fBdlgqkm8JzR7S?=
 =?Windows-1252?Q?AHaNcQQGZskmZjpozV0R1HfsG4ZUlULyB2MtKGBBa1V+vTXsbTGtVicG?=
 =?Windows-1252?Q?vCUqIXJeN1doG9Nw+vOMM6iKiUc9PSxNHpmCqCMIlmdIy/qwF399vJth?=
 =?Windows-1252?Q?2Mo4/4Awx+3ch5/2b+irU9proMM3CEqARZWXnvlw4oCraSiyUURXXxdt?=
 =?Windows-1252?Q?pCfLOz+UCARJp3zuYX4LjEIg2LmZs+7LrgljEc2/GLqcPt3+gVapSGMD?=
 =?Windows-1252?Q?xBCh0oBI7gUBhoWb2g2y32dqUZW8G6qVeXXekayG+7z4jwN94TdvYiaB?=
 =?Windows-1252?Q?FktJHUrGFEDArs4aEiG4AQVp7pEy8EZwoW+EW+KDVTab0cXWZvM4zA2M?=
 =?Windows-1252?Q?mcyrXRecBs1R+9wYstJYkvE1lZBnenn2VVNquNsEqBCXU2NRweaFn4H0?=
 =?Windows-1252?Q?4whvgYboOEgU+KlUrpwxnZnJ/YZEWqlkgvNnItqb4chGGoSzmijauxlf?=
 =?Windows-1252?Q?6ypGyd4goMWP6D8blHc3IKQDbSdSIDgLT0YS9dDZf9g84h6bxW+wmVBI?=
 =?Windows-1252?Q?vAGAeLMIQfC4GAh6lbiXiJ/vtZwMNTTRcmDi7df2uozfgc0Aa3yfqqHR?=
 =?Windows-1252?Q?FDI9rjvidf9hv/VBt14WRYngKjJS7xoes+XrwVC8ULkziGGcl4NAO0s5?=
 =?Windows-1252?Q?mtpVHchcqxIuP1c9pjTCSbl1mjeU3KphITQ3vhByAN+W5uabtmq8zDsE?=
 =?Windows-1252?Q?07/YYH9w/jG/XgLz/K7UYo80d9nJ5HYG6SmfyqfMNbxaqH/B4vLxbKdf?=
 =?Windows-1252?Q?ub99dMU4xzOBXSN3d0tnecI46xY2Ka+/FUOBrWGpMEAPZr9Vy2oUlcfh?=
 =?Windows-1252?Q?PuUEore6wI5HcVhaWwnQ8lg3HDAOzMmE3TDEa3NLph/MWUkdJKD2qTT7?=
 =?Windows-1252?Q?qRSOMH+D+VnP1YYKxuTXjkMwbDSiwuPQy4QcnicJz4eAfFft3lzmWSo/?=
 =?Windows-1252?Q?nEQEjA6gBCoT4PYtJ+Y/Oy7fipnEdEmG8ZBuODOuLklfc/e2YiIPZcfl?=
 =?Windows-1252?Q?OSTpfxlowuHmT9XnfUG3e3QcvSi/M7xkQxbrq8h9jbVkrSlgTIUAa52B?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ceb576-d062-423f-0e71-08d9287d3107
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2021 23:54:01.0553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L5utPixWzw2Ugi7c6MTLhWeVLIx0+dJg0z+LHw5nj/9+mMRakuquuSHF+OsPisulkCMtX59B6SYJ3ypqz1uWKwEJwK+LaAbJRdlyMnzGgPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3285
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10006 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106050173
X-Proofpoint-GUID: c0TfCGAObkKKS_40HgzeQqHxbPfHMm-X
X-Proofpoint-ORIG-GUID: c0TfCGAObkKKS_40HgzeQqHxbPfHMm-X
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10006 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106050174
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/21 9:30 AM, Stefan Hajnoczi wrote:
>> +	if (info->pid == VHOST_VRING_NEW_WORKER) {
>> +		worker = vhost_worker_create(dev);
> 
> The maximum number of kthreads created is limited by
> vhost_dev_init(nvqs)? For example VHOST_SCSI_MAX_VQ 128.
> 
> IIUC kthread_create is not limited by or accounted against the current
> task, so I'm a little worried that a process can create a lot of
> kthreads.
> 
> I haven't investigated other kthread_create() users reachable from
> userspace applications to see how they bound the number of threads
> effectively.

Do we want something like io_uring's copy_process use? It's what fork uses,
so we get checks like RLIMIT_NPROC and max_threads.

I know I didn't look at everything, but it looks like for some software
drivers we just allow the user to run wild. For example for nbd, when we
create the device to do alloc_workqueue and use the default max_active
value (256). We then don't have a limit on connections, so we could end
up with 256 workqueue threads per device. And then there is no limit on
devices a user can make.


> 
> Any thoughts?
>

Is the concern a bad VM could create N devs each with 128 vqs/threads
and it would slow down other VMs? How do we handle the case where
some VM makes M * N devs and that is equal to N * 128 so we would end
up with the same number of threads either way? Is there a limit to the
number of vhost devices a VM can make and can I just stick in a similar
check for workers?

For vhost-scsi specifically, the 128 limit does not make a lot of sense.
I think we want the max to be the number of vCPUs the VM has so we can
add checks for that. Then we would assume someone making a VM with lots of
CPUs is going to have the resources to support them.

Note: It does make sense from the point of view that we don't know the
number of vCPUs when vhost-scsi calls vhost_dev_init, so I get we had to
select an initial limit.



>> +		if (!dev->workers) {
>> +			vhost_worker_put(worker);
>> +			return -ENOMEM;
>> +		}
>> +	}
>> +
>> +	vq->worker = worker;
>> +
>> +	dev->workers[dev->num_workers] = worker;
>> +	dev->num_workers++;
> 
> Hmm...should we really append to workers[] in the vhost_worker_find()
> case?


As it's coded now, yes. Every successful vhost_worker_find call does a
get on the worker's refcount. Later when we delete the device, we loop
over the workers array and for every entry we do a put.

I can add in some code to first check if the worker is already in the
dev's worker list. If so then skip the refcount and skip adding to the
workers array. If not in the dev's worker list then do a vhost_worker_find.

I thought it might be nicer how it is now with the single path. It's less
code at least. Later if we add support to change a vq's worker then we also
don't have to worry about refcounts as much. We just always drop the count
taken from when it was added.
