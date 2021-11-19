Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD29C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 13:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0BBB61A86
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 13:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbhKSNi2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 08:38:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229457AbhKSNi1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Nov 2021 08:38:27 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJDC2em021650;
        Fri, 19 Nov 2021 13:35:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=FqH2RVvs9JI9AZX6iRxWjscko0WBP7QzMQ8AqMFPxOU=;
 b=U9VGVdwOrpBhiidpgyrC9BRQdNBL+hUzX0H6T0w0CBkXfFsPPIaAIRKbCx8twgxKvWIj
 3Y2/PjysFGTzMyk8KgWsFoR9HcVjDaZb6cdrDmHNACaGGbbzz099Vlx6g+0Zqderjhq/
 sPeaLDAn9P44V81Cyuj6xVPe+6lgtjx8cmGiIkbtkqTQxIqRUtVgABIwqjCztRilqk0z
 HA4QpEdBFYZpvvVxyIu/uPkwL6d4xlEMLtzAR/IvUAnTcoCxxTw7cO771sL+WPFkPHRb
 VwHfQzVs/YSTgsA9w8MZUGqhtSF3dIy1MGLcKNbbk0W3T9FdSGDU0MJOV17ROhhS3PlP Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ceckg8g78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 13:35:11 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AJDHih4015579;
        Fri, 19 Nov 2021 13:35:10 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ceckg8g6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 13:35:10 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AJDRBJw014586;
        Fri, 19 Nov 2021 13:35:10 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 3ca50ej6kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 13:35:10 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AJDZ8jO32637270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 13:35:09 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6AD77806B;
        Fri, 19 Nov 2021 13:35:08 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57BB678076;
        Fri, 19 Nov 2021 13:35:07 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.211.93.152])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 19 Nov 2021 13:35:07 +0000 (GMT)
Message-ID: <b78c655594d3aa5c6ac5540dbf8fb931dce5a78b.camel@linux.ibm.com>
Subject: Re: [PATCH 2/2] scsi: Fix hang when device state is set via sysfs
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Mike Christie <michael.christie@oracle.com>, lduncan@suse.com,
        cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        lijinlin <lijinlin3@huawei.com>, Wu Bo <wubo40@huawei.com>
Date:   Fri, 19 Nov 2021 08:35:06 -0500
In-Reply-To: <20211105221048.6541-3-michael.christie@oracle.com>
References: <20211105221048.6541-1-michael.christie@oracle.com>
         <20211105221048.6541-3-michael.christie@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cMkAYUWb0BiomAGIh0NIpXrP5Q6nODs_
X-Proofpoint-ORIG-GUID: zJz1zQLrvL4bwubp5GtzvlmvF2ITA3q8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_09,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxlogscore=999
 phishscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111190075
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-11-05 at 17:10 -0500, Mike Christie wrote:
> This fixes a regression added with:
> 
> commit f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
> offlinining device")
> 
> The problem is that after iSCSI recovery, iscsid will call into the
> kernel
> to set the dev's state to running, and with that patch we now call
> scsi_rescan_device with the state_mutex held. If the scsi error
> handler
> thread is just starting to test the device in scsi_send_eh_cmnd then
> it's
> going to try to grab the state_mutex.
> 
> We are then stuck, because when scsi_rescan_device tries to send its
> IO
> scsi_queue_rq calls -> scsi_host_queue_ready -> scsi_host_in_recovery
> which will return true (the host state is still in recovery) and IO
> will
> just be requeued. scsi_send_eh_cmnd will then never be able to grab
> the
> state_mutex to finish error handling.
> 
> To prevent the deadlock this moves the rescan related code to after
> we
> drop the state_mutex.
> 
> This also adds a check for if we are already in the running state.
> This
> prevents extra scans and helps the iscsid case where if the transport
> class has already onlined the device during it's recovery process
> then we
> don't need userspace to do it again plus possibly block that daemon.
> 
> Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
> offlinining device")
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: lijinlin <lijinlin3@huawei.com>
> Cc: Wu Bo <wubo40@huawei.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index a35841b34bfd..53e23a7bc0d3 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -797,6 +797,7 @@ store_state_field(struct device *dev, struct
> device_attribute *attr,
>  	int i, ret;
>  	struct scsi_device *sdev = to_scsi_device(dev);
>  	enum scsi_device_state state = 0;
> +	bool rescan_dev = false;
>  
>  	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
>  		const int len = strlen(sdev_states[i].name);
> @@ -815,20 +816,27 @@ store_state_field(struct device *dev, struct
> device_attribute *attr,
>  	}
>  
>  	mutex_lock(&sdev->state_mutex);
> -	ret = scsi_device_set_state(sdev, state);
> -	/*
> -	 * If the device state changes to SDEV_RUNNING, we need to
> -	 * run the queue to avoid I/O hang, and rescan the device
> -	 * to revalidate it. Running the queue first is necessary
> -	 * because another thread may be waiting inside
> -	 * blk_mq_freeze_queue_wait() and because that call may be
> -	 * waiting for pending I/O to finish.
> -	 */
> -	if (ret == 0 && state == SDEV_RUNNING) {
> +	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING)
> {
> +		ret = count;

This looks wrong because of this

[...]
>  	return ret == 0 ? count : -EINVAL;

Don't we now return EINVAL on idempotent set state running because the
count is always non-zero?

I think the first statement should be 'ret = 0;' instead to cause
idempotent state setting to succeed as a nop.

James


