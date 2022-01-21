Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BFBC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jan 2022 18:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351201AbiAUSYX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jan 2022 13:24:23 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19610 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235596AbiAUSYW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Jan 2022 13:24:22 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LIMbGK027826;
        Fri, 21 Jan 2022 18:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=cqw9DZCseiUaFlvTsOamv+6m1AWIc1c+N0Ny/4g5AqM=;
 b=evlPfOi9pLbZRCssvjj5VSGpyc/8MM8z8JEjfVg24mTLfjHUp4DpXVTVrm5WZGh+I46D
 KAbp3VHEx/aD6X87PgumXWacK5kgAbbzczv9eNjxIIZJH9xgVb9FZW7QUpnIANhL5fgz
 4Gy4DzbNOSocqETraLHl2cL71tvD4XCGAh+nLOD7ADvQ/5uDDTBhga3ilNb5qCEurh5l
 LOkaqIdgkqBKMw2UqmWuN9anhrbnNVptTMYe3jkXamv1xUAxyPwduqUsWGdT33hnH2uI
 mx33D4IzsyLce4iIBvVKZ85qP8pQz06swhOnhduxH9Jxp9+vG+7zZk4iOJHCb+x5p3aw sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqysn2v2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 18:24:19 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LIOJ48024758;
        Fri, 21 Jan 2022 18:24:19 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqysn2v2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 18:24:19 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LICZ8S015491;
        Fri, 21 Jan 2022 18:24:17 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3dqj1k6tmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 18:24:17 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LIOFrg30212606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 18:24:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F24642057;
        Fri, 21 Jan 2022 18:24:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC4CE42049;
        Fri, 21 Jan 2022 18:24:14 +0000 (GMT)
Received: from [9.145.29.83] (unknown [9.145.29.83])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 18:24:14 +0000 (GMT)
Message-ID: <b4faa458-5f0c-cc19-05f4-22305b4942d1@linux.ibm.com>
Date:   Fri, 21 Jan 2022 19:24:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] scsi: print actual pointer addresses if using scsi debug
 logging
Content-Language: en-US
To:     John Pittman <jpittman@redhat.com>, martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, dgilbert@interlog.com, djeffery@redhat.com,
        loberman@redhat.com, linux-scsi@vger.kernel.org
References: <20220121164938.18190-1-jpittman@redhat.com>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <20220121164938.18190-1-jpittman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MvQi6wYkCIEeGfK7eAP1QTJb2kMobR31
X-Proofpoint-ORIG-GUID: j-pxLOwx4NTkcI06rwoShq-oL-ZwR2Au
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_09,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 phishscore=0 clxscore=1011 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210118
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/21/22 17:49, John Pittman wrote:
> Since commit ad67b74d2469 ("printk: hash addresses printed with
> %p"), any addresses printed with an unadorned %p will be hashed.
> However, when scsi debug logging is enabled, in general, the
> user needs the actual address for use with address tracking or
> vmcore analysis.  Print the actual address for pointers when
> using the SCSI_LOG_* macros.

While scsi_logging_level defaults to 0, i.e. all disabled, and it requires root 
privileges to increase it, I wonder how unconditionally unmodified addresses 
for scsi logging would relate to KASLR.

Why not have the root user use no_hash_pointers with the existing plain 
pointers %p when setting scsi_logging_level?
That way, it would be a clear and deliberate unhashing choice to be done by 
higher powers.
Is it because changing no_hash_pointers does not seem dynamic as opposed to 
changing scsi_logging_level? I could not find such info in the patch description.
Or would you delegate user access control to unmodified addresses in scsi 
logging kernel messages to 
https://www.kernel.org/doc/html/latest/admin-guide/sysctl/kernel.html#dmesg-restrict 
?

While still not being unambiguous, I often try to use the CDB for correlation 
of scsi logs with pending (request) objects in a crash dump. Would that be an 
alternative to pointers? AFAIK, with scsi_cmnd being re-used, the pointers are 
  not unique for a particular request as time progresses.
Enabling SCSI tracepoints on top can also be useful.

References

https://www.kernel.org/doc/html/latest/core-api/printk-formats.html#plain-pointers
"If not possible, and the aim of printing the address is to provide more 
information for debugging, use %p and boot the kernel with the no_hash_pointers 
parameter during debugging, which will print all %p addresses unmodified."

https://www.kernel.org/doc/html/latest/core-api/printk-formats.html#unmodified-addresses
"Before using %px, consider if using %p is sufficient together with enabling 
the no_hash_pointers kernel parameter during debugging sessions"

> 
> Signed-off-by: John Pittman <jpittman@redhat.com>
> Collab-from: David Jeffery <djeffery@redhat.com>
> ---
>   drivers/scsi/scsi.c     | 2 +-
>   drivers/scsi/scsi_lib.c | 2 +-
>   drivers/scsi/sg.c       | 8 ++++----
>   drivers/scsi/sr.c       | 2 +-
>   4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 211aace69c22..0f558135637c 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -106,7 +106,7 @@ void scsi_log_send(struct scsi_cmnd *cmd)
>   				       SCSI_LOG_MLQUEUE_BITS);
>   		if (level > 1) {
>   			scmd_printk(KERN_INFO, cmd,
> -				    "Send: scmd 0x%p\n", cmd);
> +				    "Send: scmd 0x%px\n", cmd);
>   			scsi_print_command(cmd);
>   		}
>   	}
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 35e381f6d371..a25ab894383b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -148,7 +148,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
>   	struct scsi_device *device = cmd->device;
> 
>   	SCSI_LOG_MLQUEUE(1, scmd_printk(KERN_INFO, cmd,
> -		"Inserting command %p into mlqueue\n", cmd));
> +		"Inserting command %px into mlqueue\n", cmd));
> 
>   	scsi_set_blocked(cmd, reason);
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index ad12b3261845..2b11dc84d04b 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1274,7 +1274,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
>   		return -ENXIO;
>   	req_sz = vma->vm_end - vma->vm_start;
>   	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sfp->parentdp,
> -				      "sg_mmap starting, vm_start=%p, len=%d\n",
> +				      "sg_mmap starting, vm_start=%px, len=%d\n",
>   				      (void *) vma->vm_start, (int) req_sz));
>   	if (vma->vm_pgoff)
>   		return -EINVAL;	/* want no offset */
> @@ -1944,7 +1944,7 @@ sg_remove_scat(Sg_fd * sfp, Sg_scatter_hold * schp)
>   			for (k = 0; k < schp->k_use_sg && schp->pages[k]; k++) {
>   				SCSI_LOG_TIMEOUT(5,
>   					sg_printk(KERN_INFO, sfp->parentdp,
> -					"sg_remove_scat: k=%d, pg=0x%p\n",
> +					"sg_remove_scat: k=%d, pg=0x%px\n",
>   					k, schp->pages[k]));
>   				__free_pages(schp->pages[k], schp->page_order);
>   			}
> @@ -2156,7 +2156,7 @@ sg_add_sfp(Sg_device * sdp)
>   	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
>   	write_unlock_irqrestore(&sdp->sfd_lock, iflags);
>   	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
> -				      "sg_add_sfp: sfp=0x%p\n", sfp));
> +				      "sg_add_sfp: sfp=0x%px\n", sfp));
>   	if (unlikely(sg_big_buff != def_reserved_size))
>   		sg_big_buff = def_reserved_size;
> 
> @@ -2200,7 +2200,7 @@ sg_remove_sfp_usercontext(struct work_struct *work)
>   	}
> 
>   	SCSI_LOG_TIMEOUT(6, sg_printk(KERN_INFO, sdp,
> -			"sg_remove_sfp: sfp=0x%p\n", sfp));
> +			"sg_remove_sfp: sfp=0x%px\n", sfp));
>   	kfree(sfp);
> 
>   	scsi_device_put(sdp->device);
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index f925b1f1f9ad..3b942c99a783 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -411,7 +411,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
>   		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
>   			"Finishing %u sectors\n", blk_rq_sectors(rq)));
>   		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
> -			"Retry with 0x%p\n", SCpnt));
> +			"Retry with 0x%px\n", SCpnt));
>   		goto out;
>   	}
> 


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: David Faller, Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
