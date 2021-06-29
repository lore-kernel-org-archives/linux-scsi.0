Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83BBC11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 19:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9414661DE3
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 19:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbhF2TZr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 15:25:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5202 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233375AbhF2TZq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 15:25:46 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TJ3Y05045813;
        Tue, 29 Jun 2021 15:23:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bTpffz7dOTB4fahdpiXrD+HipafR2SPLu2s7cXp7SbQ=;
 b=Z/Uy6mfRtgXqLShHp/uwU1kA2yKgxOCZjKzA36bOFG81XyUCn6GuKq6hRy1WVhjiAIcc
 AHOJ0zUvbtJUYZvJS0U6d0XrIgCS7iPxx/ip2nvfQS0LPNfynYndKv2kCi1lJ7lqW3N/
 mLVzNa1L5UPiglshC95XxDfzqk/0N017OVBzUgnoTAet9PZjjBVpZKgdY++ww8I2jm3p
 HsqdmJRy4Z/TisAvlfKCsuphSIz/2mKIM4OMfsSLm1XUZOQNbftHW8wfrSFORnFPrmDA
 qUecyRIMiHbPEaUTwulD2jWEp1f6P/vUlP+89htadnniSYVBYQW8azjg04tlYdi84qKJ Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39g8uvh7sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 15:23:09 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15TJ48oG047883;
        Tue, 29 Jun 2021 15:23:09 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39g8uvh7st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 15:23:09 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15TJDPnm007920;
        Tue, 29 Jun 2021 19:23:08 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01dal.us.ibm.com with ESMTP id 39duvd6fx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 19:23:08 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15TJN7pM32112906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 19:23:07 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 019FD6E0A5;
        Tue, 29 Jun 2021 19:23:07 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B28026E054;
        Tue, 29 Jun 2021 19:23:05 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.160.12.64])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 29 Jun 2021 19:23:05 +0000 (GMT)
Subject: Re: [PATCH 1/4] scsi: core: fix error handling of scsi_host_alloc
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
 <20210602133029.2864069-2-ming.lei@redhat.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <57f7bb8a-cd21-e553-8f42-f154b9e232f5@linux.ibm.com>
Date:   Tue, 29 Jun 2021 12:23:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210602133029.2864069-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Xoc_q6jOk_lljInepk-gIr8y_M7kYs2V
X-Proofpoint-GUID: d1MLl9XteiibEFKv1fgQTCkbvuS3sCYe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_11:2021-06-29,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290120
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/2/21 6:30 AM, Ming Lei wrote:
> After device is initialized via device_initialize(), or its name is
> set via dev_set_name(), the device has to be freed via put_device(),
> otherwise device name will be leaked because it is allocated
> dynamically in dev_set_name().
> 
> Fixes the issue by replacing kfree(shost) via put_device(&shost->shost_gendev)
> which can help to free dev_name(&shost->shost_dev) when host state is
> in SHOST_CREATED. Meantime needn't to remove IDA and stop the kthread of
> shost->ehandler in the error handling code.

This statement is incorrect for kthread. If error handler thread failed to spawn
the value of shost->ehandler will be ERR_PTR(-ENOMEM) which will pass the "if
(shost->ehandler)" check in scsi_host_dev_release() resulting in a
kthread_stop() call for a non-existant kthread which triggers a bad pointer
dereference. Here is an example splat:

scsi host11: error handler thread failed to spawn, error = -4
Kernel attempted to read user page (10c) - exploit attempt? (uid: 0)
BUG: Kernel NULL pointer dereference on read at 0x0000010c
Faulting instruction address: 0xc00000000818e9a8
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: ibmvscsi(+) scsi_transport_srp dm_multipath dm_mirror dm_region
 hash dm_log dm_mod fuse overlay squashfs loop
CPU: 12 PID: 274 Comm: systemd-udevd Not tainted 5.13.0-rc7 #1
NIP:  c00000000818e9a8 LR: c0000000089846e8 CTR: 0000000000007ee8
REGS: c000000037d12ea0 TRAP: 0300   Not tainted  (5.13.0-rc7)
MSR:  800000000280b033 &lt;SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE&gt;  CR: 28228228
XER: 20040001
CFAR: c0000000089846e4 DAR: 000000000000010c DSISR: 40000000 IRQMASK: 0
GPR00: c0000000089846e8 c000000037d13140 c000000009cc1100 fffffffffffffffc
GPR04: 0000000000000001 0000000000000000 0000000000000000 c000000037dc0000
GPR08: 0000000000000000 c000000037dc0000 0000000000000001 00000000fffff7ff
GPR12: 0000000000008000 c00000000a049000 c000000037d13d00 000000011134d5a0
GPR16: 0000000000001740 c0080000190d0000 c0080000190d1740 c000000009129288
GPR20: c000000037d13bc0 0000000000000001 c000000037d13bc0 c0080000190b7898
GPR24: c0080000190b7708 0000000000000000 c000000033bb2c48 0000000000000000
GPR28: c000000046b28280 0000000000000000 000000000000010c fffffffffffffffc
NIP [c00000000818e9a8] kthread_stop+0x38/0x230
LR [c0000000089846e8] scsi_host_dev_release+0x98/0x160
Call Trace:
[c000000033bb2c48] 0xc000000033bb2c48 (unreliable)
[c0000000089846e8] scsi_host_dev_release+0x98/0x160
[c00000000891e960] device_release+0x60/0x100
[c0000000087e55c4] kobject_release+0x84/0x210
[c00000000891ec78] put_device+0x28/0x40
[c000000008984ea4] scsi_host_alloc+0x314/0x430
[c0080000190b38bc] ibmvscsi_probe+0x54/0xad0 [ibmvscsi]
[c000000008110104] vio_bus_probe+0xa4/0x4b0
[c00000000892a860] really_probe+0x140/0x680
[c00000000892aefc] driver_probe_device+0x15c/0x200
[c00000000892b63c] device_driver_attach+0xcc/0xe0
[c00000000892b740] __driver_attach+0xf0/0x200
[c000000008926f28] bus_for_each_dev+0xa8/0x130
[c000000008929ce4] driver_attach+0x34/0x50
[c000000008928fc0] bus_add_driver+0x1b0/0x300
[c00000000892c798] driver_register+0x98/0x1a0
[c00000000810eb60] __vio_register_driver+0x80/0xe0
[c0080000190b4a30] ibmvscsi_module_init+0x9c/0xdc [ibmvscsi]
[c0000000080121d0] do_one_initcall+0x60/0x2d0
[c000000008261abc] do_init_module+0x7c/0x320
[c000000008265700] load_module+0x2350/0x25b0
[c000000008265cb4] __do_sys_finit_module+0xd4/0x160
[c000000008031110] system_call_exception+0x150/0x2d0
[c00000000800d35c] system_call_common+0xec/0x278


I'm happy to send a fix, but I see two possible approaches.

1.) Set shost->ehandler = NULL if kthread_run() fails in scsi_host_alloc()

or

2.) Test that (shost->ehandler && !IS_ERR(shost->ehandler)) before calling
kthread_stop in scsi_host_dev_release()

-Tyrel

> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/hosts.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 624e2582c3df..25cf76e73595 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -391,8 +391,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	mutex_init(&shost->scan_mutex);
>  
>  	index = ida_simple_get(&host_index_ida, 0, 0, GFP_KERNEL);
> -	if (index < 0)
> -		goto fail_kfree;
> +	if (index < 0) {
> +		kfree(shost);
> +		return NULL;
> +	}
>  	shost->host_no = index;
>  
>  	shost->dma_channel = 0xff;
> @@ -484,7 +486,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  		shost_printk(KERN_WARNING, shost,
>  			"error handler thread failed to spawn, error = %ld\n",
>  			PTR_ERR(shost->ehandler));
> -		goto fail_index_remove;
> +		goto fail;
>  	}
>  
>  	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
> @@ -493,17 +495,18 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	if (!shost->tmf_work_q) {
>  		shost_printk(KERN_WARNING, shost,
>  			     "failed to create tmf workq\n");
> -		goto fail_kthread;
> +		goto fail;
>  	}
>  	scsi_proc_hostdir_add(shost->hostt);
>  	return shost;
> + fail:
> +	/*
> +	 * host state is still SHOST_CREATED, and it is enough to release
> +	 * ->shost_gendev since scsi_host_dev_release() can help to free
> +	 * dev_name(&shost->shost_dev)
> +	 */
> +	put_device(&shost->shost_gendev);
>  
> - fail_kthread:
> -	kthread_stop(shost->ehandler);
> - fail_index_remove:
> -	ida_simple_remove(&host_index_ida, shost->host_no);
> - fail_kfree:
> -	kfree(shost);
>  	return NULL;
>  }
>  EXPORT_SYMBOL(scsi_host_alloc);
> 

