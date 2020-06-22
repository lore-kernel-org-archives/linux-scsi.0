Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E327C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 15:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B03A206D4
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 15:40:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XbuVYj9S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbgFVPkP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 11:40:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47838 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729250AbgFVPkN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2020 11:40:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MFbtfu031362;
        Mon, 22 Jun 2020 15:40:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=c4dmr7gId2py12uyWP0rVSm+TykjfDw082cODL2KrW4=;
 b=XbuVYj9SNnnF+fZtAEQefQ9lMfPXFk8quuE20c7oe1xtHTq0prnTHIaGwsTG/5xAibE5
 mZ0hd62d1G9BCsn1NOOFZXh1bj6f0Y4VoGn0x7k+qrUck00pv+5dvNSBWhyUKMlQKicl
 K2Ml6Djai0x3/6NuA8GXoLGxsvtLk0a5ImknyFouhr3nuXQmg4lCC10sy6o+2jWmwAiI
 7H2u5cwhKm9a2niloINgh/Z3d5Wq2FVwhuOBcndMTbSw17MV6s4MBhC7wshO1gyCDOVq
 sMZJOYeL3xthMnVJJjq/AcjE3sy69uHK1qhxRp4tD2UC652eLyHWqnJS4v8SlTpTbvDs iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31sebbg4ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 22 Jun 2020 15:40:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MFd4VP065013;
        Mon, 22 Jun 2020 15:40:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31svcv8q94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 15:40:06 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05MFe5a8014046;
        Mon, 22 Jun 2020 15:40:05 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Jun 2020 15:40:04 +0000
Subject: Re: [PATCH 2/2] scsi: register sysfs for scsi/iscsi workqueues
To:     Bob Liu <bob.liu@oracle.com>, linux-kernel@vger.kernel.org
Cc:     tj@kernel.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        lduncan@suse.com, lduncan@suse.com, maier@linux.ibm.com,
        bblock@linux.ibm.com
References: <20200611100717.27506-1-bob.liu@oracle.com>
 <20200611100717.27506-2-bob.liu@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <cf9ae940-87b2-c8a1-3dba-4d2b57ebe9dd@oracle.com>
Date:   Mon, 22 Jun 2020 10:40:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200611100717.27506-2-bob.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9659 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9659 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 cotscore=-2147483648 mlxscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 clxscore=1011 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220116
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/11/20 5:07 AM, Bob Liu wrote:
> This patch enable setting cpu affinity through "cpumask" for below
> scsi/iscsi workqueues, so as to get better isolation.
> - scsi_wq_*
> - scsi_tmf_*
> - iscsi_q_xx
> - iscsi_eh
> 
> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>   drivers/scsi/hosts.c                | 4 ++--
>   drivers/scsi/libiscsi.c             | 2 +-
>   drivers/scsi/scsi_transport_iscsi.c | 2 +-
>   3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 1d669e4..4b9f80d 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -272,7 +272,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	if (shost->transportt->create_work_queue) {
>   		snprintf(shost->work_q_name, sizeof(shost->work_q_name),
>   			 "scsi_wq_%d", shost->host_no);
> -		shost->work_q = create_singlethread_workqueue(
> +		shost->work_q = create_singlethread_workqueue_noorder(
>   					shost->work_q_name);
>   		if (!shost->work_q) {
>   			error = -EINVAL;

This patch seems ok for the iscsi, fc, tmf, and non transport class scan 
uses. We are either heavy handed with flushes or did not need ordering.

I don't know about the zfcp use though, so I cc'd  the developers listed 
as maintainers. It looks like for zfcp we can do:

zfcp_scsi_rport_register->fc_remote_port_add->fc_remote_port_create->scsi_queue_work 
to scan the scsi target on the rport.

and then zfcp_scsi_rport_register can call zfcp_unit_queue_scsi_scan->
scsi_queue_work which will scan for a specific lun.

It looks ok if those are not ordered, but I would get their review to 
make sure.
