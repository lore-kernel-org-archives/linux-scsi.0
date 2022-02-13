Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 968EDC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Feb 2022 22:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbiBMWOL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 17:14:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbiBMWOK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 17:14:10 -0500
X-Greylist: delayed 77 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 13 Feb 2022 14:14:02 PST
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80408541A5
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 14:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1644790440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bw/rHcMUAvhzI3L9UF/6JToBlUX3Pr5v4GZdjsBgQrQ=;
        b=a1DZqAD+RA4Zu11bPxK0L3TvhqFRN36Sk+Wxhh1HAnuKhnWz++HADTpTGptERo3RjowgjK
        92N8tNdJcz+62SV10XB9gcTUBN625Rq40Q3UUatWNZVY15VVMDjqf34p5xRktz7e8ZIIjH
        HLo2rvBgi8050myFjwxmGM+2G8NpqLQ=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2050.outbound.protection.outlook.com [104.47.2.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-24-vhLkmuNxPUKLPxCCld9IIQ-1; Sun, 13 Feb 2022 23:12:41 +0100
X-MC-Unique: vhLkmuNxPUKLPxCCld9IIQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGuNi7Ipn1bi5AZtZwHIsPCQWpIQHaZlT/QSykd57Dv4wQOgodxvMfcXz/nrogGm7zXN8fpOW2HI5ECfiExg1cd78anaL0O+z2U+w7za5/X3KdO5qsDwtpK3a5dJI5VruwpomwWtyncqK/2DUOOS8RggFhN8+LUBOEwo2Zfb0fhLtYgmW8CNTTMWr4fxvQX8BfJQNbnPKVIgO+h/Mq9pLQ59/jqb2Nd/qkqSb/wY7cR4XeQFQUl0n5QHOApIzSSWumQqnnUHIYSxvsy6zU+MowlEiP6ktQcTaRh1mcnv142SvfD+j6BRteGEAcNB4i2TyWt8KFOIq8rXofCWvU7fAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bw/rHcMUAvhzI3L9UF/6JToBlUX3Pr5v4GZdjsBgQrQ=;
 b=RMWbWqIRqJO3UJRiOxVxC4dK43PENqf91o8b+mCBVp6h3DoO3j/QG3ZCFjJHawO43Gqdxc64ixDdnPsK8PwbCqRnXM/4L4XWY3zylqqgqC/uhF+JcWeg5JHuWc9L23U9VvjXkYnvVd4B5qeJaWa0D4T9AX83LTIH15LYf+gur+/4HN5l9nt8KIyKpKlQRfsVa2+XcajxRTFoTBCZekYBc+Grb1W6GAdEmLzphuDzYoJVHAehBBe9syD4zHikA5lO+pgXDPUFEGVO3/zCbxbzni0eF1PS4Q3/DCJQ687TNRV7uerCL8xcE5XzK4zS/e7kHPS0SsvzszyHS4DTMlNvPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5190.eurprd04.prod.outlook.com (2603:10a6:20b:d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sun, 13 Feb
 2022 22:12:39 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed%6]) with mapi id 15.20.4975.012; Sun, 13 Feb 2022
 22:12:39 +0000
Message-ID: <8a446e94-87d0-c127-348e-2c412e59eb47@suse.com>
Date:   Sun, 13 Feb 2022 14:12:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 26/48] scsi: iscsi: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Chris Leech <cleech@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Karen Xie <kxie@chelsio.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        GR-QLogic-Storage-Upstream@marvell.com
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-27-bvanassche@acm.org>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220211223247.14369-27-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8P250CA0022.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:330::27) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8226d26a-b9c2-47cf-0ca4-08d9ef3df28d
X-MS-TrafficTypeDiagnostic: AM6PR04MB5190:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB51905B81DAC1410628684C22DA329@AM6PR04MB5190.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jf2gU2tpSrYVSGy8YL/0H4wUjuSq0J59H1WGLQM/pxQPYppJe042y5KkD5Q9mMvtU6FgXtOUgUivFsI5ckAsK3iczA6Sp4XeVEHjF3oPpkwhC+9bENzpwlFPTe/NYqpKhLFMQRNSxcrJV0r4fjUsT6Ln1Y4kTPj/RteT95U2QzrdL8aAAmNVZmwzki5BvservflS5bScctqcnXYD5lafipwskjwrSfzhysvCuzj9vgV9n2wWYLfkM1+iXwLJjlVNJ5CcApHtlL44McjBThZYFoS57qh+Bi1D48rdfRcLYxrkspCsDZndPGxQSjNBm8E1xkrhUy4EjjkorfXOjE53uweKVRZLdbhnOYOft1MwWtLliUpbZm2eKNkRa8/kkYaOTYieYq2LxKY4hFin98fPBjsGOSXaUwG0p9bFQsWqLZuN7qJh2v/MoN+XAQ3h+Lt6pfQ+siCHC8DQIA7kcjvJuW6srDxWiUIwpgkH/p5jYiaT5STGLZ451XFCFliuNcYkuRNp8jVchHHsccMzCZ0gax5h1Fx7JshfuX5LO+yrNN+Tmaf11ZmmZfXq5aYU9DKHHCVolgo2iwlBXBmxtjvDrC2mrKpCMeni9P5zNAMUVcGkDzquy60KMAyK0j4wmIQF+u6jIognKFvq/svmfF77hFFSFVxWkAroE4zLBRMO2jOSMcd8OeglEn/ulVZAVzLhUQzVIdDJd9Y3xUpMGlhm2WkanwypXVky1vkC1HZDWv0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(8936002)(508600001)(30864003)(66946007)(66556008)(66476007)(86362001)(8676002)(4326008)(5660300002)(53546011)(6486002)(7416002)(2616005)(186003)(38100700002)(6666004)(2906002)(36756003)(31696002)(110136005)(54906003)(26005)(316002)(6512007)(31686004)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2F6RXRTSWpVQmJBSnVvdVpwOWY5a3AwSjh3QzN4U3JpQlR1dEQ3a0FiYmJj?=
 =?utf-8?B?cHBrNTRWQUZheXExWE1hOFRQTUZGdldSK2dSL2NvODhlWU9tdW9zWkh1amg3?=
 =?utf-8?B?TmtwTlcvNXE0K2ZLazcvMnAzT2xUdFdQVHE5THFDMzNTSEtJaVFadDRMa0hq?=
 =?utf-8?B?U0Jpd3dNdWN5U3lpMVNSNUJJWEdOUUJzS0VyS1hEeDh5RkpTUnA2VzRjYnpy?=
 =?utf-8?B?WWlpdnBicEgxOTVqM2xGbll4SG5pTW9hMEJvbDJPd1pWcTVGcmh6dGZCVGYy?=
 =?utf-8?B?VklVVk1qb0lXeGVtbkN3RVpIWDg1TXU5LzR4Ujc0YmdGVXErTGZrNS9NNXVN?=
 =?utf-8?B?bm5WSURzdTRHRys0ZjZoMERCSXJudDBCUGtHZS80VG9WSzBadlRrNWhUV3dJ?=
 =?utf-8?B?Sjk4M0t0SHd0N0kyNTQ2S2lJQ0FhZ2NVRWtCNnBOMTJZYzVEczN4dGQwZW9F?=
 =?utf-8?B?WExTTEFRQjZ3VDVNNGJHeldUaXZIZDN4bTRjTHdDclhUUUxsZlFvejRhMnBz?=
 =?utf-8?B?VXJyUVZJOVNFK2R5YTMwclNLcVM3bng2TVRLRnVOemVGdTYzYUZwYndBYzBl?=
 =?utf-8?B?VmxXeWhGekJuWm9iYis1czBjZ0F0ZENlMDdDdXNOTEZlLzVtVE9QK2Z5STdJ?=
 =?utf-8?B?bjBPNTZnZkJTNThZNGdIZ1lTNndNMFdyWThCV3VYVFFPN0pLUFdmeWtJVVNn?=
 =?utf-8?B?SHEzNzlBUHhsRG1GcjRyMEdvRzRYT0lPUlY5a1ZNckdpMXovL29ZaVBISFdi?=
 =?utf-8?B?dHlHak5OR3BVQ3ZmUFppc0dzeWIza1VxTHZyc2xCNE5vb1hESkF5Vm5QOE1y?=
 =?utf-8?B?MzFRTjB1SkZleDBwSVE3aVJBQkJRTE01OVBDVHl2MFN6azJ2N3FFOVRhUzFO?=
 =?utf-8?B?bE40cWRzOWZlNHN6L3Q4ZzhkWDBmSFdKK2JiMXdYYUlmdEhPSlYvQVphcVk5?=
 =?utf-8?B?MzBrc1JBazZEeDhVb1I3bjVldFM2TmJLek1VTWlCR01GamJvb2QvWHR2eThr?=
 =?utf-8?B?MUdDblcrd1FRNElvNURtSkxBbkxQelRESDh2eEduT05RaUVvM3M0Y2FHdzVJ?=
 =?utf-8?B?K1BqWjY5K3p6Y2djVmZCNU13TGFnL3BESjdYc3ZjWllhRlZOY2hySXRxMDVt?=
 =?utf-8?B?emphMnppZlFlSzZicSs1ZUZOSGFMZzg0NUp1Y1k1dEhURUJMNStNZCtFVjhs?=
 =?utf-8?B?VVJDbnNLRUtFL0hHQWVTcHZKNXc3NXhoMXFNWjhJQ0UwellzZURsSUowK2Jh?=
 =?utf-8?B?MFpDSUEvN1JEMGRwbC91ajdjSEEzcEtTVzRoNXpad0NxNE9kZGhITVlROFhW?=
 =?utf-8?B?VCtrenR6bi9SZ2s4VDRwc01odEY4bWUwVjQ3dmhFRk90a2dMc0ZDWklyalBC?=
 =?utf-8?B?bXRsTVBMK3VFZmlBdzFWQWkxbW8zSktPVFY2QmdMZXhqSUw3YVNVcGZBNDlD?=
 =?utf-8?B?YkE2bmFzTkxQb1RXL2p1c0Q0YnQ3TkhBRUx5dzU5Y3RCaWFwb2QzWVNneFpj?=
 =?utf-8?B?enhwaGNVVC9tMU43VU9IenJ1VDFLTk9MVlY2UVFERHptNTliT2VkaG05YVY3?=
 =?utf-8?B?R3NwUlNVRFVVcEZWYys4TXNuR0s2OTFodnFxa3RoNGUxSEZQenZTVmEvZ0Ri?=
 =?utf-8?B?SUZMNEZwcGdYaDV6NjdLWVIwaWtubHd1eEgyQ3ZEcTBxL0U3eUc2dlhvbGRm?=
 =?utf-8?B?UUdsSkh5UThOc2R5UnpPaG1McjRpOEsvWWkrdkZxRXY4Y3M0a05xdHdYU2lj?=
 =?utf-8?B?b2c3MC8xMzFvSm9pTGlKbE9wLzRmSFdBbnF6ZzJqejNTankxZUZMbEw0UmQy?=
 =?utf-8?B?UjJmRjRqNlN1VTZPNWVzRTJIMEVBYS8vUnh5Vnh0QTF0S21tb21ocUpiMVZT?=
 =?utf-8?B?Sy8vTWlNVUJ4VksyMUZSZlY3dm9FaWdnaG5kUGx5dWdGNHZnSCtjVEt4cDB2?=
 =?utf-8?B?b0VwOTNvZWZDaktkZXg5Wk95NEVvWUYvTGJZMVdvazV5TWRKSE11VnMwQzhJ?=
 =?utf-8?B?WFF1MjNjbXREOEN6V2l5RTZsV2Y0amUrM3lVeHJ1V0Y0dWxPZXJYYzlYejhP?=
 =?utf-8?B?VXhmU0d0em9QdnhaNjE3Uy8wV0REZjFpRnRtakM5ekVpWG81eDVpN1M3WVFE?=
 =?utf-8?B?VGhHMTNDV0o1UnFqekx6amRHSHR0T3VORlJrdU54L2pOeDhMbG1hS3gxcnVl?=
 =?utf-8?Q?7Opx5foNU6HOBjXJKY6Z1pg=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8226d26a-b9c2-47cf-0ca4-08d9ef3df28d
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2022 22:12:39.3353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jP5wgPBMXdZsomHYi50KmvjFE5t9QqwE0r+JXQUjM4GJ3oEn5SMMJDi27k32McCIj16wQJaNV77kT6rPncXxKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5190
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 14:32, Bart Van Assche wrote:
> Instead of storing the iSCSI task pointer and the session age in the SCSI
> pointer, use command-private variables. This patch prepares for removal of
> the SCSI pointer from struct scsi_cmnd.
> 
> The list of iSCSI drivers has been obtained as follows:
> $ git grep -lw iscsi_host_alloc
> drivers/infiniband/ulp/iser/iscsi_iser.c
> drivers/scsi/be2iscsi/be_main.c
> drivers/scsi/bnx2i/bnx2i_iscsi.c
> drivers/scsi/cxgbi/libcxgbi.c
> drivers/scsi/iscsi_tcp.c
> drivers/scsi/libiscsi.c
> drivers/scsi/qedi/qedi_main.c
> drivers/scsi/qla4xxx/ql4_os.c
> include/scsi/libiscsi.h
> 
> Note: it is not clear to me how the qla4xxx driver can work without this
> patch since it uses the scsi_cmnd::SCp.ptr member for two different
> purposes:
> - The qla4xxx driver uses this member to store a struct srb pointer.
> - libiscsi uses this member to store a struct iscsi_task pointer.
> 
> Cc: Lee Duncan <lduncan@suse.com>
> Cc: Chris Leech <cleech@redhat.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Manish Rangankar <mrangankar@marvell.com>
> Cc: Karen Xie <kxie@chelsio.com>
> Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> iscsi
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
>   drivers/scsi/be2iscsi/be_main.c          |  3 ++-
>   drivers/scsi/bnx2i/bnx2i_iscsi.c         |  1 +
>   drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  1 +
>   drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  1 +
>   drivers/scsi/iscsi_tcp.c                 |  1 +
>   drivers/scsi/libiscsi.c                  | 20 ++++++++++----------
>   drivers/scsi/qedi/qedi_fw.c              |  4 ++--
>   drivers/scsi/qedi/qedi_iscsi.c           |  1 +
>   drivers/scsi/qla4xxx/ql4_def.h           | 16 +++++++++++++---
>   drivers/scsi/qla4xxx/ql4_os.c            | 13 +++++++------
>   include/scsi/libiscsi.h                  | 12 ++++++++++++
>   12 files changed, 52 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 07e47021a71f..f8d0bab4424c 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -971,6 +971,7 @@ static struct scsi_host_template iscsi_iser_sht = {
>   	.proc_name              = "iscsi_iser",
>   	.this_id                = -1,
>   	.track_queue_depth	= 1,
> +	.cmd_size		= sizeof(struct iscsi_cmd),
>   };
>   
>   static struct iscsi_transport iscsi_iser_transport = {
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index ab55681145f8..3bb0adefbe06 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -218,7 +218,7 @@ static char const *cqe_desc[] = {
>   
>   static int beiscsi_eh_abort(struct scsi_cmnd *sc)
>   {
> -	struct iscsi_task *abrt_task = (struct iscsi_task *)sc->SCp.ptr;
> +	struct iscsi_task *abrt_task = iscsi_cmd(sc)->task;
>   	struct iscsi_cls_session *cls_session;
>   	struct beiscsi_io_task *abrt_io_task;
>   	struct beiscsi_conn *beiscsi_conn;
> @@ -403,6 +403,7 @@ static struct scsi_host_template beiscsi_sht = {
>   	.cmd_per_lun = BEISCSI_CMD_PER_LUN,
>   	.vendor_id = SCSI_NL_VID_TYPE_PCI | BE_VENDOR_ID,
>   	.track_queue_depth = 1,
> +	.cmd_size = sizeof(struct iscsi_cmd),
>   };
>   
>   static struct scsi_transport_template *beiscsi_scsi_transport;
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index e21b053b4f3e..fe86fd61a995 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -2268,6 +2268,7 @@ static struct scsi_host_template bnx2i_host_template = {
>   	.sg_tablesize		= ISCSI_MAX_BDS_PER_CMD,
>   	.shost_groups		= bnx2i_dev_groups,
>   	.track_queue_depth	= 1,
> +	.cmd_size		= sizeof(struct iscsi_cmd),
>   };
>   
>   struct iscsi_transport bnx2i_iscsi_transport = {
> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> index f949a4e00783..ff9d4287937a 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> @@ -98,6 +98,7 @@ static struct scsi_host_template cxgb3i_host_template = {
>   	.dma_boundary	= PAGE_SIZE - 1,
>   	.this_id	= -1,
>   	.track_queue_depth = 1,
> +	.cmd_size	= sizeof(struct iscsi_cmd),
>   };
>   
>   static struct iscsi_transport cxgb3i_iscsi_transport = {
> diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> index efb3e2b3398e..53d91bf9c12a 100644
> --- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> +++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> @@ -116,6 +116,7 @@ static struct scsi_host_template cxgb4i_host_template = {
>   	.dma_boundary	= PAGE_SIZE - 1,
>   	.this_id	= -1,
>   	.track_queue_depth = 1,
> +	.cmd_size	= sizeof(struct iscsi_cmd),
>   };
>   
>   static struct iscsi_transport cxgb4i_iscsi_transport = {
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 1bc37593c88f..9fee70d6434a 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -1007,6 +1007,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
>   	.proc_name		= "iscsi_tcp",
>   	.this_id		= -1,
>   	.track_queue_depth	= 1,
> +	.cmd_size		= sizeof(struct iscsi_cmd),
>   };
>   
>   static struct iscsi_transport iscsi_sw_tcp_transport = {
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 059dae8909ee..d69203d19f2c 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -462,7 +462,7 @@ static void iscsi_free_task(struct iscsi_task *task)
>   
>   	if (sc) {
>   		/* SCSI eh reuses commands to verify us */
> -		sc->SCp.ptr = NULL;
> +		iscsi_cmd(sc)->task = NULL;
>   		/*
>   		 * queue command may call this to free the task, so
>   		 * it will decide how to return sc to scsi-ml.
> @@ -1344,10 +1344,10 @@ struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
>   	if (!task || !task->sc)
>   		return NULL;
>   
> -	if (task->sc->SCp.phase != conn->session->age) {
> +	if (iscsi_cmd(task->sc)->age != conn->session->age) {
>   		iscsi_session_printk(KERN_ERR, conn->session,
>   				  "task's session age %d, expected %d\n",
> -				  task->sc->SCp.phase, conn->session->age);
> +				  iscsi_cmd(task->sc)->age, conn->session->age);
>   		return NULL;
>   	}
>   
> @@ -1645,8 +1645,8 @@ static inline struct iscsi_task *iscsi_alloc_task(struct iscsi_conn *conn,
>   			 (void *) &task, sizeof(void *)))
>   		return NULL;
>   
> -	sc->SCp.phase = conn->session->age;
> -	sc->SCp.ptr = (char *) task;
> +	iscsi_cmd(sc)->age = conn->session->age;
> +	iscsi_cmd(sc)->task = task;
>   
>   	refcount_set(&task->refcount, 1);
>   	task->state = ISCSI_TASK_PENDING;
> @@ -1683,7 +1683,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>   	struct iscsi_task *task = NULL;
>   
>   	sc->result = 0;
> -	sc->SCp.ptr = NULL;
> +	iscsi_cmd(sc)->task = NULL;
>   
>   	ihost = shost_priv(host);
>   
> @@ -1997,7 +1997,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>   
>   	spin_lock_bh(&session->frwd_lock);
>   	spin_lock(&session->back_lock);
> -	task = (struct iscsi_task *)sc->SCp.ptr;
> +	task = iscsi_cmd(sc)->task;
>   	if (!task) {
>   		/*
>   		 * Raced with completion. Blk layer has taken ownership
> @@ -2260,7 +2260,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>   	 * if session was ISCSI_STATE_IN_RECOVERY then we may not have
>   	 * got the command.
>   	 */
> -	if (!sc->SCp.ptr) {
> +	if (!iscsi_cmd(sc)->task) {
>   		ISCSI_DBG_EH(session, "sc never reached iscsi layer or "
>   				      "it completed.\n");
>   		spin_unlock_bh(&session->frwd_lock);
> @@ -2273,7 +2273,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>   	 * then let the host reset code handle this
>   	 */
>   	if (!session->leadconn || session->state != ISCSI_STATE_LOGGED_IN ||
> -	    sc->SCp.phase != session->age) {
> +	    iscsi_cmd(sc)->age != session->age) {
>   		spin_unlock_bh(&session->frwd_lock);
>   		mutex_unlock(&session->eh_mutex);
>   		ISCSI_DBG_EH(session, "failing abort due to dropped "
> @@ -2282,7 +2282,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>   	}
>   
>   	spin_lock(&session->back_lock);
> -	task = (struct iscsi_task *)sc->SCp.ptr;
> +	task = iscsi_cmd(sc)->task;
>   	if (!task || !task->sc) {
>   		/* task completed before time out */
>   		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
> index 5916ed7662d5..4e99508ff95d 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -603,9 +603,9 @@ static void qedi_scsi_completion(struct qedi_ctx *qedi,
>   		goto error;
>   	}
>   
> -	if (!sc_cmd->SCp.ptr) {
> +	if (!iscsi_cmd(sc_cmd)->task) {
>   		QEDI_WARN(&qedi->dbg_ctx,
> -			  "SCp.ptr is NULL, returned in another context.\n");
> +			  "NULL task pointer, returned in another context.\n");
>   		goto error;
>   	}
>   
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
> index 282ecb4e39bb..8196f89f404e 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -59,6 +59,7 @@ struct scsi_host_template qedi_host_template = {
>   	.dma_boundary = QEDI_HW_DMA_BOUNDARY,
>   	.cmd_per_lun = 128,
>   	.shost_groups = qedi_shost_groups,
> +	.cmd_size = sizeof(struct iscsi_cmd),
>   };
>   
>   static void qedi_conn_free_login_resources(struct qedi_ctx *qedi,
> diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
> index 69a590546bf9..5f82c8afd5e0 100644
> --- a/drivers/scsi/qla4xxx/ql4_def.h
> +++ b/drivers/scsi/qla4xxx/ql4_def.h
> @@ -216,11 +216,21 @@
>   #define IDC_COMP_TOV			5
>   #define LINK_UP_COMP_TOV		30
>   
> -#define CMD_SP(Cmnd)			((Cmnd)->SCp.ptr)
> +/*
> + * Note: the data structure below does not have a struct iscsi_cmd member since
> + * the qla4xxx driver does not use libiscsi for SCSI I/O.
> + */
> +struct qla4xxx_cmd_priv {
> +	struct srb *srb;
> +};
> +
> +static inline struct qla4xxx_cmd_priv *qla4xxx_cmd_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
>   
>   /*
> - * SCSI Request Block structure	 (srb)	that is placed
> - * on cmd->SCp location of every I/O	 [We have 22 bytes available]
> + * SCSI Request Block structure (srb) that is associated with each scsi_cmnd.
>    */
>   struct srb {
>   	struct list_head list;	/* (8)	 */
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 0ae936d839f1..d64eda961412 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -226,6 +226,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
>   	.name			= DRIVER_NAME,
>   	.proc_name		= DRIVER_NAME,
>   	.queuecommand		= qla4xxx_queuecommand,
> +	.cmd_size		= sizeof(struct qla4xxx_cmd_priv),
>   
>   	.eh_abort_handler	= qla4xxx_eh_abort,
>   	.eh_device_reset_handler = qla4xxx_eh_device_reset,
> @@ -4054,7 +4055,7 @@ static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
>   	srb->ddb = ddb_entry;
>   	srb->cmd = cmd;
>   	srb->flags = 0;
> -	CMD_SP(cmd) = (void *)srb;
> +	qla4xxx_cmd_priv(cmd)->srb = srb;
>   
>   	return srb;
>   }
> @@ -4067,7 +4068,7 @@ static void qla4xxx_srb_free_dma(struct scsi_qla_host *ha, struct srb *srb)
>   		scsi_dma_unmap(cmd);
>   		srb->flags &= ~SRB_DMA_VALID;
>   	}
> -	CMD_SP(cmd) = NULL;
> +	qla4xxx_cmd_priv(cmd)->srb = NULL;
>   }
>   
>   void qla4xxx_srb_compl(struct kref *ref)
> @@ -4640,7 +4641,7 @@ static int qla4xxx_cmd_wait(struct scsi_qla_host *ha)
>   			 * the scsi/block layer is going to prevent
>   			 * the tag from being released.
>   			 */
> -			if (cmd != NULL && CMD_SP(cmd))
> +			if (cmd != NULL && qla4xxx_cmd_priv(cmd)->srb)
>   				break;
>   		}
>   		spin_unlock_irqrestore(&ha->hardware_lock, flags);
> @@ -9079,7 +9080,7 @@ struct srb *qla4xxx_del_from_active_array(struct scsi_qla_host *ha,
>   	if (!cmd)
>   		return srb;
>   
> -	srb = (struct srb *)CMD_SP(cmd);
> +	srb = qla4xxx_cmd_priv(cmd)->srb;
>   	if (!srb)
>   		return srb;
>   
> @@ -9121,7 +9122,7 @@ static int qla4xxx_eh_wait_on_command(struct scsi_qla_host *ha,
>   
>   	do {
>   		/* Checking to see if its returned to OS */
> -		rp = (struct srb *) CMD_SP(cmd);
> +		rp = qla4xxx_cmd_priv(cmd)->srb;
>   		if (rp == NULL) {
>   			done++;
>   			break;
> @@ -9215,7 +9216,7 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
>   	}
>   
>   	spin_lock_irqsave(&ha->hardware_lock, flags);
> -	srb = (struct srb *) CMD_SP(cmd);
> +	srb = qla4xxx_cmd_priv(cmd)->srb;
>   	if (!srb) {
>   		spin_unlock_irqrestore(&ha->hardware_lock, flags);
>   		ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%llu: Specified command has already completed.\n",
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 4ee233e5a6ff..cb805ed9cbf1 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -19,6 +19,7 @@
>   #include <linux/refcount.h>
>   #include <scsi/iscsi_proto.h>
>   #include <scsi/iscsi_if.h>
> +#include <scsi/scsi_cmnd.h>
>   #include <scsi/scsi_transport_iscsi.h>
>   
>   struct scsi_transport_template;
> @@ -152,6 +153,17 @@ static inline bool iscsi_task_is_completed(struct iscsi_task *task)
>   	       task->state == ISCSI_TASK_ABRT_SESS_RECOV;
>   }
>   
> +/* Private data associated with struct scsi_cmnd. */
> +struct iscsi_cmd {
> +	struct iscsi_task	*task;
> +	int			age;
> +};
> +
> +static inline struct iscsi_cmd *iscsi_cmd(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
>   /* Connection's states */
>   enum {
>   	ISCSI_CONN_INITIAL_STAGE,
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

