Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9B6C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 00:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiI3ASS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 20:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiI3ASQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 20:18:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE46132FE2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 17:18:15 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TMihHM005144;
        Fri, 30 Sep 2022 00:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=BCmxbiVY3g7vl1ZbsKdFbHqZwpYQz6ka8zPR2i+QoMM=;
 b=Ojayk7On3CfYVp/eHjY5ip3W4C2wHoeCMKpdKoez1Am4nrJwLbE03kmVgC1oKpu50oA3
 LcbAMx2o6s1rEFK45BIxTv1HtRs0exQQsntLf+Zj0/t+souyWZZxjnEjYVj2qZN7EpQZ
 JJkgb/Y1Gl5UdIS7N1/etopodG8CJBxiZsOwRmh/vm75QK75CavMmJxCv7eH7YEeoKgT
 rhsEg4wuSqc10b1K/yPkHXrpGD1reiNm1cdhFoy5bc4u3e4H5OTTPVa0ZjdJ1o2CMjYx
 dVr10v8vP9g4lVSoo7fvXPnl10SlDFjWhpkb+vt9fFI0xcmOwrjQ8uhi0UI8VB3gke3g CA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstet6vnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 00:17:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28TKsVpi033545;
        Fri, 30 Sep 2022 00:17:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpv3dnj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 00:17:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XowxmziI/fX6QCqPQgyWzoCTxm+GCW+/U/xm0fZKA3T7aPwXr8ow4FbMcARBYmQ/lCkXUQAfV86kemR3u5zFj+PiiBADxxse02ss9RmFAhDZzR+MnFr7io6BpDNOebEqUVAKpgrcMNAtN2GzbrqBzuDzL51GKN56PU+BXnzITUngWRd2Oemtp5jPQmq//ORRsseh6ZHInDQFl/QPp/t57Uja7fOIqeU7gWwP9iPBW1ptl4sPXXswZZJNw7ZGcaDw3TIhxAWVPM0dKs43hdkJLffYUITOKqdtkaFzAyIwJxNJORR5a5eTetAsWpfH3SA8F0YqNOFCSy0L3s7f0jy8lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCmxbiVY3g7vl1ZbsKdFbHqZwpYQz6ka8zPR2i+QoMM=;
 b=ZNN6eLWoT2P1QTn55hWcK21CmJBN5mrPVKarvTgA2z1WdNGoK9A9LXi7HaTomx49pQa7abVNi8HXdNYPDbuhZfn0wdmbwUNkLDcw9Hohe9q7X9JbNKIet4NDzHT3chZcW2wi1kJkJiP8gTeqm/9+BEBvE3AIP8m/+kijCFMxyeW2BhZ7KzA0CD/N5gXLGtrclxIoOU55aY5cuVwUIOzm2DcAn9O5LWEwOj4DLdsmd5N0w7bphNntd/wR5U/Dy270QYjr6WcuQZUM6UdHU4H3EpotXtxqFOwdRdDUlp3xkovDndC/Th1UNC3VmWrLaihvhwtrm1j+BdfNmYQvOcY+ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCmxbiVY3g7vl1ZbsKdFbHqZwpYQz6ka8zPR2i+QoMM=;
 b=YX7aMloXC4Pk6mfKjim8/VCNpuQ9o57TdrkjzX2Ah1a2v3mnanIn6STP8RfTGgLtO+E1rgzT9OFE7r14x07/Gwrv8gZemcfwMU1GF/SKI9NWCyKxIRNyEYm5EykT6ObxxkwLdaj5DLdMRNrDa8j3VQ7RQ+1P6v6i4YjA3Y1+T6c=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5094.namprd10.prod.outlook.com (2603:10b6:408:129::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Fri, 30 Sep 2022 00:17:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 00:17:48 +0000
Message-ID: <8d123a46-42c0-35b7-92d6-bbbbd3abab35@oracle.com>
Date:   Thu, 29 Sep 2022 19:17:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 1/8] scsi: core: Fix a race between scsi_done() and
 scsi_timeout()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
References: <20220929220021.247097-1-bvanassche@acm.org>
 <20220929220021.247097-2-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220929220021.247097-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:610:b0::8) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5094:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d2788e2-2e08-4566-4f69-08daa279345b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DhrYhPr1uBYZlFOPin8/xUiXrmOq4FEKd8HJoBmhbb/Ix+Oy9i6j8AOdTmwt82NNsTljLvE2SmYUU7OUTlVuptxRZTjF0dQjvjUSCqkVwe8LXtByB5qlKEME+9yUWEzaAzVXUjyM44qnIGt0IlyBSaIgdhGiuxgPmdVpyYEXu6276IvFSnVewGDkOKDdV1SZGb/5Ek4JHUohRHsNny7Nkcy/yye+AqjOIIPegPuAruCceA1GfpYa8VqeQkl/QTtKKcKJYch0o9xOBzcqMXzSTfhZMmtyBnubImCX982tgymP5Uw7zxysa9n6TouMI8HQwUPicEGBTfS/xl7q94OzyFQo2qcIstm04tiN2zU8t0GkBQyXR7cA+n4ynOT6QIIk/XZsmGPGawy4hWHDDavFPlovB73eUeboNRefk8CPradXftM7VegF+Vwk+wh3L7hbwcHdpUsgN3BK8nE6Ko2mv8JGF+S1DfFFFgiwtgyuqF8vaa8sWWRS3HCbKlnOJhY0wcZkaCCG4hEf+itadXXtjD1H/mBE1J4I04KI8FevQq+VlFCg0MK5bMGwTNyPkuULdBAiVg5+YQ0Ig8xmZle3uo0rJ2HH80nnrPMBiTXdsIuTJj4GsaBlIWsQ0jMGrMnaRGI1nHrKNIIs3w7XQTKOkdUAzGgqIebNg/xGfC9UFrJOXpgHB577qakijDlJUnwlK1sofMcvZuKdXHER8K8BzW6wXfriyF45n4mH+kkEq2I6+y6QSWN4/njxug0WgJBRYj/cfaUFud2C89OwdJLRfjqAO3SSFSTT8391dB3ubcE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(396003)(136003)(39860400002)(451199015)(38100700002)(86362001)(31696002)(36756003)(7416002)(41300700001)(4326008)(5660300002)(6506007)(8676002)(6512007)(66556008)(8936002)(66476007)(110136005)(6486002)(53546011)(478600001)(26005)(54906003)(6636002)(66946007)(316002)(83380400001)(2616005)(2906002)(186003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlI1THRkeHNtQUQ2Q0xHR2NMdnFpTHQwR2VwbEtMQlV0bG9SdmhMWDhPeFlw?=
 =?utf-8?B?MnBsM1JXZEhiNE5PQTRrYVFhYkZHeDVzTHVGWVF1UkIxWFVHV3NwY2lTS28z?=
 =?utf-8?B?UXoyVSt0VGhZNWZuKzRmMko0YWhkMFIvV2lIY3FSUmppei93bWlrbVBQMHE5?=
 =?utf-8?B?Wmx0emF1UkxjK3UyaUtPdnl1VEwxQyt0SldDdkp2d3NYOS9WWnM2L3dOQis1?=
 =?utf-8?B?b3RkNlhJNFErRlFHb24ybXZuQkErZkIxcm1iczlFMWxKbzg0dHk0eXJaZmtx?=
 =?utf-8?B?cHcrSU9ESTVSdlpCa2RMTkZiQk5qSkJyQitKZ2pPVHpJZEFZeWxzVDh0V2NG?=
 =?utf-8?B?Yjd1cHBjVGN0TXA4cm9qa0hFVWxiWkI0cTlvUXM1WWZSTVM5N2h0VmtGdzlq?=
 =?utf-8?B?a250WEJHOFM1TmxlS25RZDlmeDdZK1ZBbTk0dXpubkhUandEdEtNUC92L0lK?=
 =?utf-8?B?OGdEZWRrWUFzTEw5K2l1ZXZyaldHU3pMYWdybkVYTCsyZVZSWWZuY3FsdUQ3?=
 =?utf-8?B?ZGpwSmhaRlpkQTRLbVpxb2dURy8vNk9lTTdMUUxrbEFWL0Z4OEYwRGZBb0xU?=
 =?utf-8?B?OVBRMWtpSzI2aEpKOG54Q0N4R3U4dGJOK2ZEL2VWWGh5c2xGZDdncWhINUNa?=
 =?utf-8?B?R3c4dk1vay9iQ2lEcG9tSmcwdWtXM3JtWEFvWnpTcERsaWY4Vmk0eEhhcEsz?=
 =?utf-8?B?OGZha08vaVdmYjlaRTBoWWc3UXIwT3U5T1ZhbDBpNGtrQ0tGaVpwM0puUUNz?=
 =?utf-8?B?STNKWFNMY0NSeWZmSjdZTXF1cHhhdlZXNkV2cjBqNWE5NlVKbXU3bG15RkVK?=
 =?utf-8?B?R2VKVmdYaHloV3Q4ZitOSVo5ZlF0SzhsQlRFMUZGbTlNSWpBNUFwZCt2dGZm?=
 =?utf-8?B?Q2Z4b1RtbEMwUjVFZGoySFk5VHRhazZRNkZGTGgxdFRpOEFsa3lwTTZQeVdr?=
 =?utf-8?B?WWJLVk9wWCtSS3I0Y20xcUZ5K1VBNGtYWlNmTFZUYzFmVHQxdlkrQ1p4ZjZq?=
 =?utf-8?B?dGtUSjU0bHAzckwwVUV4eTlzU2U1SG41SmthSXBSSERyRE11dGZKbEdqRXQ2?=
 =?utf-8?B?bjBXWVRSVGNPUEhLUDd3ZWxTQmwxeWRkSm9rKzBjRC96MDJqbkNMWXF5Zldi?=
 =?utf-8?B?K0hxeDZzdTRpTW5HOSsxSGR0ODhkVmxmS2pnTlNuY29lcmJnaWhaT1pxZ2N6?=
 =?utf-8?B?N3k3MVVoZDdVci9PLy8ydXpSSlFTL21PMUV0VWR0dmpiU2RzWTFDQldmdWtk?=
 =?utf-8?B?REZVcldTS0hCeno2VFRONnV5SWRPd2x1TVRqdk55YTl2ZkhHZjBndVVGUGkr?=
 =?utf-8?B?K1gxWmw5eXU2K3dtOHhSeHFick80TjhRMGd4UkYwMU4vYlFKa3dXYkRVaUw1?=
 =?utf-8?B?ZE5XVEVXeEZ5Z2t1RmxlSDVQdHlyN3M2eWdxVkJmVjRmNllpSzJDaUQvKzNm?=
 =?utf-8?B?Y2VUUGwyTTVQZS83Nmo3aVZEKzVXeVdHTlVFckFZYTNUdWFnMVhCUlFpRmUv?=
 =?utf-8?B?VWd3TFRHNmtpemNGbTF4VEEwY1FjQ1NNZlE3N0dvbHM1azc3cG5nbE9zQ0R1?=
 =?utf-8?B?dmVjU00ycDlZVStUOTlYK0tuSUE0TUR4TVA3dU0yYmkzM1d0Ym5yaGM2aTRB?=
 =?utf-8?B?T2MzR3Y2Y0RtSjF0ZTJ3R3hxOE01alhjQXhERTJiQnlXRXo3aTRtdEswZ05V?=
 =?utf-8?B?VnY4NUtUbHVHaldNK0psOGVLak1kZzdtMXVhNFpabGxYUFNFYlg0aFozcTN3?=
 =?utf-8?B?Q1NuVGxXWUUyUHp6V0ErbDl0MGZpelc0QUljUmhYSkR0M3hjS3BIQlM0aXhn?=
 =?utf-8?B?U1NMdU1obnl6U2JtV1Z3RDltYk5PdndVNk5LOHBHOVNVRnN1K0V2Mi9IdmZw?=
 =?utf-8?B?WnpoUDR5K0ZERVhBZkd0NUFpYnNXSFV6U1hLOG04N28xbGIrNXU0cGFlVitR?=
 =?utf-8?B?SjQwc1JSMHB1Vzg0S2sxMGRHT011d1FSYUt3bndaWE1OVy9zY0tEQmRuVzZx?=
 =?utf-8?B?ckpuOENTRUN5c01qNUZQT3VNSmlSN1NVU3VHTVNUUW9TdWI1aXFvajdPZDZu?=
 =?utf-8?B?NlE4VEVlb0JETDEyOGgzQnFrTjZaUG50cXpXKzdjZ3pQWUl2cUpxN0hjUDhw?=
 =?utf-8?B?S0pLWFZLdE4rMDkydlhHTHlidEp4RDFURG5EVms4V2d1WXFCcWdlajZMVy9L?=
 =?utf-8?B?VHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d2788e2-2e08-4566-4f69-08daa279345b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 00:17:48.0738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pQA+lHkxJ6uXF4RnnzlkmnQNWPy5V3avt4p1wpqnqEETl35MXXmJVNE+UA1SYI0UfbPwKE0fh3O1xrGlugH+Nm6xHjfaG0G5lqzDqPxa56s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5094
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_13,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209300000
X-Proofpoint-GUID: 8K9NwFEJhiUSLNpBwCRxcNd88mltHhUy
X-Proofpoint-ORIG-GUID: 8K9NwFEJhiUSLNpBwCRxcNd88mltHhUy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 5:00 PM, Bart Van Assche wrote:
> If there is a race between scsi_done() and scsi_timeout() and if
> scsi_timeout() loses the race, scsi_timeout() should not reset the
> request timer. Hence change the return value for this case from
> BLK_EH_RESET_TIMER into BLK_EH_DONE.
> 
> Although the block layer holds a reference on a request (req->ref) while
> calling a timeout handler, restarting the timer (blk_add_timer()) while
> a request is being completed is racy.
> 
> Cc: Keith Busch <kbusch@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Reported-by: Adrian Hunter <adrian.hunter@intel.com>
> Fixes: 065990bd198e ("scsi: set timed out out mq requests to complete")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 16bd0adc2339..d1b07ff64a96 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -343,19 +343,11 @@ enum blk_eh_timer_return scsi_timeout(struct request *req)
>  
>  	if (rtn == BLK_EH_DONE) {
>  		/*
> -		 * Set the command to complete first in order to prevent a real
> -		 * completion from releasing the command while error handling
> -		 * is using it. If the command was already completed, then the
> -		 * lower level driver beat the timeout handler, and it is safe
> -		 * to return without escalating error recovery.
> -		 *
> -		 * If timeout handling lost the race to a real completion, the
> -		 * block layer may ignore that due to a fake timeout injection,
> -		 * so return RESET_TIMER to allow error handling another shot

I've been wondering about this code too.

I think the patch is correct for the normal cases, but I didn't understand the
old fake timeout comment case. From the comment it seemed like that was the reason
we did the RESET_TIMER. Does that not exist anymore or was it just bogus?

The commit you referenced actually was returning BLK_EH_DONE like we want. This
commit:

commit f1342709d18af97b0e71449d5696b8873d1a456c
Author: Keith Busch <keith.busch@intel.com>
Date:   Mon Nov 26 09:54:29 2018 -0700

    scsi: Do not rely on blk-mq for double completions


changed it to BLK_EH_RESET_TIMER and changed the above comment to mention
the fake timeout case. However, the commit message mentioned the patch was done
because we didn't want scsi digging the block layer.

If the fake injection thingy is bogus, then it seems ok to me.

Reviewed-by: Mike Christie <michael.christie@oracle.com>


> -		 * at this command.
> +		 * If scsi_done() has already set SCMD_STATE_COMPLETE, do not
> +		 * modify *scmd.
>  		 */
>  		if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
> -			return BLK_EH_RESET_TIMER;
> +			return BLK_EH_DONE;
>  		if (scsi_abort_command(scmd) != SUCCESS) {
>  			set_host_byte(scmd, DID_TIME_OUT);
>  			scsi_eh_scmd_add(scmd);

