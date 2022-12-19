Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BE1C4167B
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 18:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiLSSta (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 13:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiLSSt3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 13:49:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B420655B;
        Mon, 19 Dec 2022 10:49:28 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJIkpiN016857;
        Mon, 19 Dec 2022 18:49:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=DYDcYHZVdUsfdVjMSezGYdt3+UoKWS0EtpmFcTgzg0Y=;
 b=njKUl200wIut9zBWCEPqWkJhLjRmY8scw47xia94dksRlLohLTXkEjjdo1yKgQJ5yXt9
 DK2/Y1x0ToW0bUIP737d+FIEKEj9doR+jOHdWup8greR090Dbw+VpG2Fqd9VsNwmASgc
 mlU6yUAULQz3Fq57MSuUBz+E6toorr7jYzoqpegrtMdzxwX6lpcv4govT6/xntnSIm6e
 IqJ7siSaJrsNxB7jEcHsgU6TnACb/FGcOv2nI7fmTrJQpP4pTkC1L69cwxsEThN6Cs0D
 jXtA64oV/7XRPinCwmI1wBoxceslvTk5eX1Q0ruNjCsBlUrHp7P76IxIumCKo7v+OafP aQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tp3mjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 18:49:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BJHtD8T004683;
        Mon, 19 Dec 2022 18:49:14 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh47a77c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 18:49:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ga2DRSMXl/E+4/WrL9dDgzL6mlmlE3jCMYwZwoVzyZnH7R8dw/ipSOz40ZI1uDvo/cyw3MKpXmT9mxJGBwG5dg7sR76+OrJ8ac0VkpxZirEwkdRw9PTjmaj/KuvaK88JraCeOuIcYiMKN0YZAtzvnz+3xe1rfxH3VocJoK3o63XaHQJvcP5OXTbgRvwEP1SJhQ1KfWhaTIAFZyLQNXgZDxrGe6IBx50a6CIRjGP9EXLtoGHKCzR9zCvqd3Nj1RSjCFhgM/TfuxF6BCIF/1iZ328IphkuJ0fambuzAkyOyVdK6pPkryK7qy31F5qsDIa1YBHRgG+8TCn1FXLfDF5tEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DYDcYHZVdUsfdVjMSezGYdt3+UoKWS0EtpmFcTgzg0Y=;
 b=OoarlT26AsLdyUDCQwGSKk65bLdsgK891E9WfSdcxQXH2pUWX+D0lPzOMB/DWGnC6qV0aFywIrmGCn8PppLNTN+P1NBnVQ0JzRyCxdGnmeSkqtQpNQ5+BRdRiS+qdka5QbYcBSUgJ4u0v+3HFakctZc43Ax1sDr8Kzsxqd1ljtNdl80hqY66ZHOwUMD2VKJ3hYbyPgY1m/WC2ayX/ZnwnB7cKosujtYZ/3UdRXpavlP0We09kP+En8bTIY2WC9NnT4E9I+TQmrfOGLsZHP5xXeXkn5mAhmTV0eJKlTqdS0Fl8seEEDo/UGIL+JD+2mnF1RNppOxNyMrsM85trF19rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYDcYHZVdUsfdVjMSezGYdt3+UoKWS0EtpmFcTgzg0Y=;
 b=pLfyO9KfWR1ZbhiFY/uL4tCQRrZkqQA0KbMgbWgXqq8v/QMp2ir1iWv3WZkoW9YojYHbzZYn3v4oo9MmCYR+X5ZEppcKDAjB5XdOXjNX03PVjKlTjpK+QIgSYPAUy7RGT2QgRr4yhdVnArPuSNv1hss0runiGnZ1cMa4z1BKxRk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4779.namprd10.prod.outlook.com (2603:10b6:806:11f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 18:49:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 18:49:10 +0000
Message-ID: <6ae8a2b8-9720-8e60-4431-072218e57e28@oracle.com>
Date:   Mon, 19 Dec 2022 12:49:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] tcm_loop: Increase maximum request size
To:     Nikos Tsironis <ntsironis@arrikto.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20220929115504.23806-1-ntsironis@arrikto.com>
 <ed3e5f22-dd2c-2952-dc7e-c47bccf66611@oracle.com>
 <Y5Dc66mOzBfBhUGY@infradead.org>
 <da4f53f3-4e13-1259-b0a6-cc28160be23b@arrikto.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <da4f53f3-4e13-1259-b0a6-cc28160be23b@arrikto.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0440.namprd03.prod.outlook.com
 (2603:10b6:610:10e::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4779:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a89d9bd-0258-4939-332a-08dae1f1b753
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FeYfCDOQLU5r0NWyTtHBXPUnENF1NWMnOafuKfDoVvY3wTGf5Aeraj0YKfef4FSyh0jojXPo02eFTAca3nLimmV7zUiDcmVfHxR/DHy8FCjtogyoVH0u/1kF0qHLKTV9BArnagu+Stk6gogHZhFglD88894q/RrjTa4WM+p1dZTOrH+oiMcEENSUDrhJqFJQENaHeooTlySEFShB8YCK8BZ9rqLPQPM3TW83NaKRt9RfZe5QRCiXEIKJ+GviJiIWx0iUbSbKGKIaKMSLvoy4ByXQ0NBwf1eAj8gEFeoEi7pawcWBxn/MU+kKZhmkzQIwpZDvPLNhepXEjIfc1Kg3D/HZ0Vb6dD3wfEslmzX4zJi6ThCV59Dv21ugc8C4UMt3EflyAo7+KQEYKlLpg6QCJ4y5UzppVsowQWb88Ij6l4bAl2sFJLlEH2DL0V6CTNRd9hicRYwguqXcmNip6fso189xkzwuG/wp5CaPQNRCEdssWMP9BcM07OzbEliAzawgkwYau3FfAK+8VdRafF+O+dxrOdm/pC8iwr4OUs6MrWK+g57rAI2T7k4hDsMFw0v6s45CqlLwE/tdrqVN35aH2bpB07S+5x/8m2ethsCDOMIUG+p/q7/nRG+2SxQEXVIEsDlz4vvxtGfcd0Pp6g/97AKBOrrci4YOvd6KVpigsgJ2eTPbMJHDEPfW97sqEmBhX2vmZxFKwgBVbCrJIs83jiXbY57fsqFoVCf8gQlA6oNXp3WVl5mazNWSfy9HoStc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199015)(8936002)(38100700002)(5660300002)(53546011)(186003)(6486002)(8676002)(66946007)(4326008)(6512007)(41300700001)(26005)(36756003)(66476007)(66556008)(83380400001)(86362001)(2616005)(31686004)(2906002)(316002)(478600001)(6506007)(31696002)(110136005)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHBnMEJuMGRkL2RLQklOSXdoOHUxRldTaCtENnlYSWNXSlUrK21veVFCSm4z?=
 =?utf-8?B?THptWjFXcnNUbnNWazFoZGZJdXVtb1hKTFhtaS82YlEvdEhoanMxbmJyZnJn?=
 =?utf-8?B?VU15STk4T21PcTZDU0xIa0psU01iV2xUNUtES210S0xDWkRRVHRGODBVYm1S?=
 =?utf-8?B?SUFBNDRnem9vU1hSRC9KNDk4dmpoanhMODVsYTlxU0srMkk4eGwvZFZHc1Rv?=
 =?utf-8?B?UUxsQ05zRzZ5TTNLU0YyZ3h0VmJIM010bTdjZDk1ajI2YkFxNE9yRStFNHJr?=
 =?utf-8?B?aytzdE9SeGgyR0FFNUxxY28vVFJuNWdBVlZCdkRXYk5yTitWVlF6VzFaK25I?=
 =?utf-8?B?dDlvUWRBOHBLbFpNcGdFTlVzQ2ZmakdaTUdZbHB4eTNVS0pobjNUM0lLb3VC?=
 =?utf-8?B?clZpQkJoaHFxanNtNnBrU3RaNzI1QThYZ2c4UEhiQVI5VnBrTDBXYmxLanE5?=
 =?utf-8?B?S00wNHJJcFRELzZLT2FiMlIxY1FJbHJ5ZUdBbFU4b0txbmV4ZWh1WUxaVllQ?=
 =?utf-8?B?a2V5YWY1TmR6azlybUl1UmxIcDRGOTNFc2c4dXF5bUxTK0lTNUppeTA1eDFz?=
 =?utf-8?B?cTVUUklXOUtBV3dDdU1HRFdCZjgwUGFYL1N5UUoveTlSWDlFeXM0bTZTWnlC?=
 =?utf-8?B?REo2ZDQyc1huTjJLL2lJYUdGNEdVM09ZeEVWM3ZramlPN1Q4QlN3V3V5bTMz?=
 =?utf-8?B?UDdlYVVlNWs5MWRHVjd2ZnJ6RHZZSnpRUW9XMld0eE9FVTlTampIT2tWZzhl?=
 =?utf-8?B?QXRZT0NrQi9CaEFrVGJPTmlzKzNWZm1USVRIL1RtSVE5QUl6M2VBcEticnVO?=
 =?utf-8?B?SkNneUgyMDI0dDkwSmVFZ0I5TXI0ZXpsZU9qRHI4ZnpsYlNzM2U2Mzd2b2dw?=
 =?utf-8?B?aHNaYjdqVGs0SDhvK3lxRjhOSCt6SVBwM0I3REVTSDYvZzk5aHljaWZaTXV6?=
 =?utf-8?B?WmY5ZXQ3UjA0V3grUFptS2tKRDJ6d1ZEcjF2UzFlaUdCTy9TMjdMSm5SRUF1?=
 =?utf-8?B?b2t6ckw4VE52S0V5UXFzcUZZQk1FaUR0WkJpdWg1NVR3UFMwenY0VUVydUlV?=
 =?utf-8?B?OHZoSUFGYnFjR3FIa2kvMnFybWlJSHdFbDhISXg2VThuckEwOVRrTlBDdExN?=
 =?utf-8?B?TVpJcWdER3V5L3BUQk90bFhwcGd2eWw4VTBrVEd3ejZuVm1NQmw4RGNVOFc0?=
 =?utf-8?B?UkdZNmR2VlFhbmhZYTN5L3B6UFQweHJ5ZDZ5UWRTa2VBMzdlVlJobkF6aUtO?=
 =?utf-8?B?cDlNcDlkckpqNEdhYkxUSUNsMlpPejUvUGdKSDZUUDdHZ2RpYjdaTWl0VVRr?=
 =?utf-8?B?dXBxOGNHeUxVbDcwV0d3d2dHV0s0dTBMZXM5Ymt1enVUL0hpQ2xhU2Y2V0Y0?=
 =?utf-8?B?dXcrTUU5aHlJRkpMcFVRcWVINXVxdWR0a2ZDaXc3UVhGWklqMVh2QjBDRDF3?=
 =?utf-8?B?UlFydnphZER1ZE9VakpVSWRmQ3U1ekVWazA1dHB6a0NubFJQYkV5VlpqY3Vm?=
 =?utf-8?B?RncyYmlkaGplNGc1cU5GWXNXa3U5QlhYaExiZVRDM245SERycDNqRWJVTjRt?=
 =?utf-8?B?Rk9RbDg1NG9jQy9SNWlRa2lialM1SDRvZ1RsMlc0NjhvbGE5a1VDbnppRmZn?=
 =?utf-8?B?THZLNTZOQ0VicUUxYjFiSDlSZUFDNEhrZDk5cGJJcG00cHJIMHpGQlhDWmJC?=
 =?utf-8?B?blFJWDZnc3VML1Bla0dxV0pVdllKUDgydlU5NGw0WllvMDhiZnJvU2R1Y2pF?=
 =?utf-8?B?ZlpwRkZwVHUvL0QzTjNSUHd3djR2YUtiTncyZk5tYkVLQStzVG01enFCUXVY?=
 =?utf-8?B?OGJIRnp5Z1lKbXkweFdkV3pOTU1BQ3I5SlFYb29oZUpESzlGb3U0c3V6WndO?=
 =?utf-8?B?cnNRWEd0TnZ5T1B3dVlBT3A1T1JxU09nYk9LeU10ZWg0TUFGSGZlaTV5WGRh?=
 =?utf-8?B?cUQ0dEJMdEVhWjA3VTB0cTlMNVZaMTFtOHRBQlZzaE9ab1BEeFBSaDlCbGxz?=
 =?utf-8?B?YWZUOEFFY1Y0dFhIM0pnRHBPZEtFR3ZBZEpSZVFpeGFLZXVXczBYZVlpQ01w?=
 =?utf-8?B?MjZ1WllYb1E2akZ2K0gyVC9wbXBTeVJMbHM5aHN3RlVNSmtkMEFycVc2K1FF?=
 =?utf-8?B?YlZTUG9QYVl6MUV2ZUpuMzBWYlFGTkRNM1FuT1FNMDRpRnJQZEVuc3d3RUJX?=
 =?utf-8?B?ZGc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a89d9bd-0258-4939-332a-08dae1f1b753
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 18:49:10.6959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TUoi3OpE2zGNzW30InSDI72YcDQcdDDRVWTRbEIK0BtpuStvK20KvMjkC5yvD3dDcGDm/xwryTUFu6nh2IUdG+9iI5ykz5t/fEfbj9LExCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190167
X-Proofpoint-GUID: wqQEUn0xGUJpRWclP5xX76HZkjWGy4b_
X-Proofpoint-ORIG-GUID: wqQEUn0xGUJpRWclP5xX76HZkjWGy4b_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/19/22 8:39 AM, Nikos Tsironis wrote:
> On 12/7/22 20:35, Christoph Hellwig wrote:
>> On Wed, Dec 07, 2022 at 12:29:56PM -0600, Mike Christie wrote:
>>> I think you need to make this configurable.
>>>
>>> If you use loop with pscsi, then the sgl that loop now gets might be too
>>> big for the backend device so we now fail in:
>>>
>>> pscsi_map_sg -> blk_rq_append_bio -> ll_back_merge_fn
>>>
>>> So some users might be relying on the smaller limit.
>>
>> Note that this could happen even now, you just need sufficiently
>> horrible hardware to pass through for it.  But yes, for pscsi
>> this needs to look at the underlying device, and increasing the
>> limit might be a good point to do that.  I'm not sure it's worth
>> to add user configuration, though.
> 
> Thanks for the feedback.
> 
> What should I do? Change pscsi to look at the underlying device limits?

Yes. I think there might be 2 things to do here:

1. SCSI VPD values.

I think we would do something similar to iblock_configure_device
where when we setup the device we look at the underlying device's limits
and then set the se_device's limits. Those values then get reported to
the initiator in the VPD info, so that would be useful for normal drivers
like iscsi and FC.

For the max segments there's not a SCSI VPD value, but we have this code:

        /*
         * Set MAXIMUM TRANSFER LENGTH
         *
         * XXX: Currently assumes single PAGE_SIZE per scatterlist for fabrics
         * enforcing maximum HW scatter-gather-list entry limit
         */
        if (cmd->se_tfo->max_data_sg_nents) {
                mtl = (cmd->se_tfo->max_data_sg_nents * PAGE_SIZE) /
                       dev->dev_attrib.block_size;
        }
        put_unaligned_be32(min_not_zero(mtl, dev->dev_attrib.hw_max_sectors), &buf[8]);

which would limit the IO size. max_data_sg_nents is only currently a fabric
driver (front end drivers like iscsi, fc, etc) limit, so we would need to make
that more generic so backends like pscsi can set it.


2. For loop we have the sg_tablesize setting like you saw, but the problem is
that it's host level and we don't know the devices when we add the host.

I think we would have to modify tcm_loop_port_link so if adds the device
successfully, we call blk_queue_max_segments.

Christoph is that what you were thinking?







