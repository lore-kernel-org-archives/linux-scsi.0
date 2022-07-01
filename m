Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4548C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 16:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiGAQ0U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 12:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiGAQ0T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 12:26:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7830140E63
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 09:26:18 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 261G3OJS021262;
        Fri, 1 Jul 2022 16:25:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=sKHs4a5UyXl+xoZJ2gPAkDUdjjKU2zQLKg1FYPM2kPc=;
 b=A9tTTVo3MaehYP5aQe44iEeE9LFjWEXOtMN8dt0o9BQOwUQ5aFbxY88yLfYmzgW11Sj8
 rqwZrQ9qqy6g1HXQuV55uvIlwDj6BJHYCY5o0Hn2QXAnfn04l+zX2/LisZqtkwNTWski
 HoWc6uGMYijklw3uudiV+0n/EPg+bCzuLJaDKS4AFfYLEx70QYqW/x1EEHEnDkn0J5si
 xhnfZNd5iBEswrZZ6zhYzG4A6XYTHY5PAJSYSHBt1bqgjEEtTqN1iT48Xkv4HSiETDhY
 xxNLpQa0i6MZSWhY6CJf/Ya9YxRrvdMCLBlrAGANVSnLcbVgffpdZEHfqtntnjw91Z8M 0A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwtwufscc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Jul 2022 16:25:59 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 261G5D6O027884;
        Fri, 1 Jul 2022 16:25:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrtath7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Jul 2022 16:25:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEGSpsT0zeOllsFiq0FntdfmCI1+HzDJ28dUhlxyD3oKYfPo6kU2kkYsCAbvYE6+VWiyouBcrqbA4B+JuDlcq5L1TOtAR3ApM7aSG28Dk20pUElaOcNE3dqjH5QfMnbso8mE1sBE484RwzpSJ3MFWGpES/p/CJg/PoSgAQTG4gQvUp1Lp7ogNvaf//TLBUkoJ6WOE166SWzYrav1fWXwxrdJb6QkgMrAOlRA4FlpYJ3+0TPWq7pzihFi21xd/fNIyl0/DPGsiRa2aJHYTjURpC/jVg1qxi3tUwaLJXfU/owN8P1SA1IYy+xw8a4xiFaTJYLBzX7GW0GCiWaLIGG/4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sKHs4a5UyXl+xoZJ2gPAkDUdjjKU2zQLKg1FYPM2kPc=;
 b=clpopkUZR1NK5WWVqznbLK12+53BmyBrEWlezhpR9ny4S082/cmvBqCNAabuIWlnJzzzFyfuczIBAfxz3IJ23zt1YwDqEZPPYFqfPamFyyLdohk2ciSQ+V0MwIyIiCibr4AhSBEDlqjNZ9fH+HhjArZKArps8Xwc8GlorGVd5p5bEUJVv05XcDisnigElT2VmbmbJ8/z0ZLDAORQv3pw/SKszxH+CpdEcv3wsO9183DtYptHE2C2aTOjqvVgVfTscRvg0z3OUVlWDDdnN2QgoSTK/a6TPkW8m3wSltNdEUAIyGemInaulr6Dk0f84ed+rZ1eZtxKZm0eeJRwmVPn5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKHs4a5UyXl+xoZJ2gPAkDUdjjKU2zQLKg1FYPM2kPc=;
 b=EKnnnqPgoI2TeySNLl3ci5DNbTzEQCmaVm+ogabLAYgl4MLSBegpAWMCAT1J/d5y8PJjefrjUfr5vn0yv/uUxwiFq6V9MspcYOln4aWAO6z7qW7Mb5ADBxKe/zF7M93PQgFElxv2sBxjgc8ompyGb1GQj6k5h5sJQpcUDeaJFfs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4378.namprd10.prod.outlook.com (2603:10b6:5:211::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.14; Fri, 1 Jul 2022 16:25:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5395.017; Fri, 1 Jul 2022
 16:25:55 +0000
Message-ID: <af96e766-69bd-4aab-812b-59de10286d9e@oracle.com>
Date:   Fri, 1 Jul 2022 11:25:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH v2 2/3] scsi: Make scsi_forget_host() wait for request
 queue removal
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
References: <20220630213733.17689-1-bvanassche@acm.org>
 <20220630213733.17689-3-bvanassche@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220630213733.17689-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0192.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e54b7acc-418a-4f79-c29d-08da5b7e5f97
X-MS-TrafficTypeDiagnostic: DM6PR10MB4378:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: samaHdeaJwkOzGrEItVOwfXjFTc1qZAhzNGhE+qbvP10YvXLvFn8MafI4wxv1RYnOKnrJcJQlIePjlgxMjFPPdUjbFv3mkF5CL9IHrdhFyCQVBz/N7jpojIQ7KwlRXqgzioKtBR3/otwaoJ5Odrc6AuTkOIEJJH2lRXFosLlRxQkTfsLxyZfbP2rKdMKI2BybFy5ah+O9chArSEwJ6MtEMEUlQCL6tQ3A057GShblTeJoYiJEiu+1otTg+uS9cZQporFOMm4apZ9yPEPjLZ0kIIJ0OZ56I2tyjCZwasW369TjySMhDHGq6KpfkLGDM8SNvolBKLYi4LW+zp7ud5GZcI6wcXmtShCgt2Bwzll9+i9ajTUY3qnO6buhJV0jM2o3tQhc9kMVmKLBBfH1FKKZu0qbGvSPZ6Mi/D3vC+dxvi4koZ+SlNZWYk9BzCaI0BXopzSFTwmxODfERMdrJVLJeIfmytO4YposdLSN+uWoJp35/Ri42tmh7oSxpWleo7aVzY5IjD/wDPqHb9Pu6EO3nhmtbDi97W01Vpt1bVsspW6EHWRBkbZqbDcazz+Vu0ZoI18OawbxWfywSmOm7y4uYULRaPPPCV+1gt6+N/KcbaCZMkZ141w3a/S9jjVJVUGyaqTy3VVtNYR573kqWSuZmXjdMDVNNVJmFUdFTsdLPUG3In1/VhwP48ue+v8jNiFvh2bkSCLIJo6BssQFPM7HlDsF7PbvsZf5KVM0ukgg79gjwc8U96MG9AFwkiGhOQPDT7h2xX9to2qgKK2uwXxrFRRdbkLQgkmXm300c/57blfYpGNE1Oa2ieIjWUc1rwvsE8H+jeFp5s2YVeJ+68vAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(376002)(39860400002)(396003)(2616005)(83380400001)(38100700002)(86362001)(31696002)(186003)(5660300002)(26005)(110136005)(8936002)(31686004)(36756003)(54906003)(8676002)(66946007)(66556008)(66476007)(316002)(4326008)(6506007)(41300700001)(53546011)(6512007)(2906002)(478600001)(6486002)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3Rod2c5UEVBZVNNU0ZIRmhoK0g2aEZYWjlKZmJja1E1RGcxcFVUdGJZdGFa?=
 =?utf-8?B?NjhSVWcvcEkwR0pHUVNWY3grNkx1eHlRYnpSQ3dmV2t0dXRQYjhZYTBWVFND?=
 =?utf-8?B?V2dKTTJZU1JJYThweDl2WFdQNnR6L0JzZGNhOXBCNUc1NTVHWjE5Skw4SVhF?=
 =?utf-8?B?M3YwcHFhUkFjY2d6UmRZVDlVcEdKTFJJekp1OThvMUlqN1hLQkVHYmNndzlr?=
 =?utf-8?B?MWw5RlRXY1R3eGhLK2R4Vm5xUFFRRU9Zak96VWhhZGZLYkp0M3M3cTYwKzJL?=
 =?utf-8?B?cnlNcnJlSGdybkhaYkRKMEFGN1d0QXBkVnY3TWQ2S0E1WGZxYSs4c2NKMEcv?=
 =?utf-8?B?bDg1MUdWaDk1SWpWQnJzUWlxR3JkTVFtSTBWMnpYNm5hbU1UV0M4MHBNcG95?=
 =?utf-8?B?Q2dxSmVTN01PYmdXZnNsMWNwSGNONmdzaEhuL1o4eWE3RlZrRVB2S1UzU21s?=
 =?utf-8?B?U2RDWGNZbkk1L3dBYU8veGNkSXc2Um9JZmh4WlhHMU1oRWlvOHZtckxBUXBT?=
 =?utf-8?B?endSY3ZFZTlVN2I1KzNtMVhWaVJ3N2lRNTBiWGdLQlVwZkFkZUtoY2t2R2ZN?=
 =?utf-8?B?RXdCWElaZVp1VGNwMnhPQzkrNFJnc2JqK1IxMWpSVWd5TTkwcHFPbkNaYWFD?=
 =?utf-8?B?QXZ4emVFR3VLVjhSMlRtUnZITDhkbCtFRHZKeDhJY3hZMzZQa0FVbnFrVG1p?=
 =?utf-8?B?WUdXckYwY244MU55RkVRWk9MZEFsTDY5cG91OUh3WGltSmxZazhuMG1INGFG?=
 =?utf-8?B?TTNiUjlERUw5NDlRbEVtTzlxRkU5SGNURmZxM3dPMElaZUZqZXltaUpacGZV?=
 =?utf-8?B?S1NXaVRWVExtYkV4OVc0SndoMkplckxONiszUG9rclhQUVRqNDVFQzhGaVBj?=
 =?utf-8?B?TVJFYnJjZTVkb3ZXRk5FQjdPTnNrVmJtVzMvTVEvbDNXekkvcTZ0VEluN3VX?=
 =?utf-8?B?c1JQdFBIMTFYODErNDlCUDc1VFJZS2ZpOEg1UktpVGxNVFRtL2JSejRZbDAv?=
 =?utf-8?B?M05WS3lieWtZSU1MaEdlR0dPV2ZvL1RsODZBY3B1ODZ2RTR2VTFBNys0ei8y?=
 =?utf-8?B?ZjJiaDNiVVJOUmxjZ3QvdDRhaXk0WG5SV2lhcFFiL1BpQXFQREpQcjFPb2RG?=
 =?utf-8?B?T0tJSWE0VTdCUzQ4OVlXZzZra1NHb0Y2UEM1eVczb3VhcCtuL1ErUnVTR05L?=
 =?utf-8?B?a1lES25UZmo2a21KKzR3STNzOStjQkJwRThjdWpiU3RvNjBJUHJNTGg0RThZ?=
 =?utf-8?B?WFJXUW9tQVRZL2RlWnh3Qk5tNmFKWGtyZ3kvV0FFd1VHKzZSUi9MWEt2UTI0?=
 =?utf-8?B?b0dXc2taODFZVFBaQzRoRHluaTFaZXJyUDBQajVnVnVZaTFNcTJza1AxK3lL?=
 =?utf-8?B?ampkWFF3cGF3OXBYdS9pb0c3RlVzNGl0aXViZUlwTGJ2U0M2WlpMSzhodzgv?=
 =?utf-8?B?clBaNVp3ZTNZWFZkbU80RGpFTFJnSUJVV0hCNmxOT1VnMGwvOE9velI0RmNr?=
 =?utf-8?B?dTg4K2VRVllKQ21ybWUvclRiTngyWUNXSWVQdUkxSHRTTkhvWHMwK0tEbXRV?=
 =?utf-8?B?UDhWNHRqZDIyUmVXU1NGZWhSTW11aHprNHcvL3VxSkRJWlVhbUVKci9CSmhq?=
 =?utf-8?B?YW0xZ1I4NjRzZEFQZ3NXUXdhc2lrcVNXNWZaeXc1UGg4U3BDeGVRL1R3aWhE?=
 =?utf-8?B?SkZxQlVVNlNNT2hqUWtwbjdOdXJUQUc1TGZ1MkV6L1ROUCtoQjAwelFGQXNU?=
 =?utf-8?B?SnFsb0U4ekErMmxTWGhpeUF6Mm85Um9jUk12c1ZEb1NmNFpHMG5wYjhhdWVm?=
 =?utf-8?B?QUc3bmQxUWZwMmV6ZHFrYXhvcFJENk1jWStlVDJORldheFkraFJLSGRNRW11?=
 =?utf-8?B?eElkYkFzbGZ1akVwZGU0TlYyMEVxenBML2x3L0xLcGU1VEs4cUxlS2N3TnZN?=
 =?utf-8?B?eW0zUG9VQ2ZQZmhaNGJGUDMyZUR4YTVybXgvTDRSN1piR3lvTDd3QmxQNWgw?=
 =?utf-8?B?RkFLYWVrN3BBQ2tKeDZkc0l5MUFpbWVhRzRLdkZnaUl2S3BVcElJVitoTURq?=
 =?utf-8?B?WjMvaWYxdUVueTFQZVl2c2NqSmQrVFc1T1p3Yi94UHlHQWh3QlB6QTl2STg2?=
 =?utf-8?B?SENtSDJsWmM3WDJzL255bzM4Tnh4SGovWHFUUGg4N09VMk9BWjRKUEwyeTJM?=
 =?utf-8?B?aVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e54b7acc-418a-4f79-c29d-08da5b7e5f97
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 16:25:55.6322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O7yGcyflAUmb39IENBnwQQ2umM9R2AFGIIrxDfyMh8LH09Pvt/n5tpvttWJ8TJCMGu3tF/zyDiNQPkwFXWfJGXCW4jvIK0xlm0B4GqWcqr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4378
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-01_08:2022-06-28,2022-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207010064
X-Proofpoint-ORIG-GUID: 4bXJ-ohS3SYV65nsCMxDjOPDxIoFkT2i
X-Proofpoint-GUID: 4bXJ-ohS3SYV65nsCMxDjOPDxIoFkT2i
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/30/22 4:37 PM, Bart Van Assche wrote:
>  	struct scsi_device *sdev;
> @@ -1970,8 +1980,21 @@ void scsi_forget_host(struct Scsi_Host *shost)
>   restart:
>  	spin_lock_irq(shost->host_lock);
>  	list_for_each_entry(sdev, &shost->__devices, siblings) {
> -		if (sdev->sdev_state == SDEV_DEL)
> +		if (sdev->sdev_state == SDEV_DEL &&
> +		    blk_queue_dead(sdev->request_queue)) {
>  			continue;
> +		}
> +		if (sdev->sdev_state == SDEV_DEL) {
> +			get_device(&sdev->sdev_gendev);
> +			spin_unlock_irq(shost->host_lock);
> +
> +			while (!blk_queue_dead(sdev->request_queue))
> +				msleep(10);
> +
> +			spin_lock_irq(shost->host_lock);
> +			put_device(&sdev->sdev_gendev);
> +			goto restart;
> +		}
>  		spin_unlock_irq(shost->host_lock);
>  		__scsi_remove_device(sdev);
>  		goto restart;

Are there 2 ways to hit your issue?

1. Normal case. srp_remove_one frees srp_device. Then all refs
to host are dropped and we call srp_exit_cmd_priv which accesses
the freed srp_device?

You don't need the above patch for this case right.

2. Are you hitting a race? Something did a scsi_remove_device. It
set the device state to SDEV_DEL. It's stuck in blk_cleanup_queue
blk_freeze_queue. Now we do the above code. Without your patch
we just move on by that device. Commands could still be accessed.
With your patch we wait for for that other thread to complete the
device destruction.


Could you also solve both issues by adding a scsi_host_template
scsi_host release function that's called from scsi_host_dev_release. A
new srp_host_release would free structs like the srp device from there.
Or would we still have an issue for #2 where we just don't know how
far blk_freeze_queue has got so commands could still be hitting our
queue_rq function when we are doing scsi_host_dev_release?

I like how your patch makes it so we know after scsi_remove_host
has returned that the device is really gone. Could we have a similar
race as in #2 with someone doing a scsi_remove_device and transport
doing scsi_remove_target?

We would not hit the same use after free from the tag set exit_cmd_priv
being called. But, for example, if we wanted to free some transport level
resources that running commands reference after scsi_target_remove could
we hit a use after free? If so maybe we want to move this wait/check to
__scsi_remove_device?

