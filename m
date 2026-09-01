Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF43D2EDD40;
	Tue,  1 Sep 2026 10:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259479; cv=none; b=RAlT8yy3KMiR8uUYgFpHe/tL5NlZl9Jy7QXC5VQDgc3iljkSLu1mWgJVv0Vb4YvfxJXTbJco0BTlgs8dsBaOqEu26nCYpNlpkh6aKviqUeDo1VNKL52W7ZMPKK1gMQT54UnCUeyyz5YGV79wz19TPlFwrRDrIdwemfKPEE49MbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259479; c=relaxed/simple;
	bh=TToxpCzl7WWa46GYEkimVN6X6tQAXZ77qq1GS7ZfEEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ku9RRnrNjzdJtw5KdlCqlRiIl1CtE+HosutCjLKVZKhU8wnzJFXehHkey/UkXo9Z9RqdEx3rgWEkTe7HSfLEsajMabxyT01xaGIdfCiLmgZmyppUJNRNdpclrXG965dL/JB7p7WdlvW4qghexfuJw1XiMj6Y+PudyBXOKJgcLYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Tpnu6kfs; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Tpnu6kfs"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681AVbc2831324;
	Tue, 1 Sep 2026 10:44:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=jisS/R
	ElJi2t93Vy7gqR0ZR2Zd2JLMwyqL2Kyk4iD8A=; b=Tpnu6kfsyrUVkXRKblrJyz
	EttYiM/REVewaKFmkKQIppmhOhyXieyxjhMU8XlZlSSzOMLmgLYse7AMTt+51BP3
	0mstO9FJPCNovqyboW2Qj6VtG+X9imivQotce638qxxkXPYHar9wNYaZj6IHpDXa
	mZC1ieMcVZKHqQN/j0k2NXLG5JIY9bRiED/CwSrxS94wCgqpGx67LrNO5ogInW1g
	a7pa6UpFLEE+zWWSv4X+vV0pE+aafWThwwfj0ZGx6VHJH/HfgsjUz/uYN0FGHseA
	0xU9qra3W6EmG9XQD1OL1JXvO6EVkJ7T99DKwpv8BNgjs2Xf+xXBdxKD7E9DbQOQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbmuhq84a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 10:44:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 681AfKpP019737;
	Tue, 1 Sep 2026 10:44:35 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gcark36uk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Sep 2026 10:44:35 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 681AiYq921496556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Sep 2026 10:44:34 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E582E58050;
	Tue,  1 Sep 2026 10:44:33 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE02358045;
	Tue,  1 Sep 2026 10:44:31 +0000 (GMT)
Received: from [9.123.4.58] (unknown [9.123.4.58])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  1 Sep 2026 10:44:31 +0000 (GMT)
Message-ID: <916bade1-37f1-4f04-ae4b-e64d711d8c9f@linux.ibm.com>
Date: Tue, 1 Sep 2026 16:14:30 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: fc_transport: vport and rport cleanup
 synchronization
To: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul.ely@broadcom.com
Cc: thinhtr@linux.ibm.com
References: <e16406ec-d4d6-4783-b79c-5c00263c133c@linux.ibm.com>
Content-Language: en-US
From: Maram Srimannarayana Murthy <msmurthy@linux.ibm.com>
In-Reply-To: <e16406ec-d4d6-4783-b79c-5c00263c133c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -n4bG1YOAQCS5g2RVIGyjtKUE8J0KoFi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5MyBTYWx0ZWRfXzVBcDCLiN9gj
 12Zo+8XOobcG5Dp0kAGMZBgAlYJ/KHGx70HwGdo0Ht8yL5kVlvIYljSHmkQLHdCISVu/vTiPO4y
 xX1mrVNw6i0UWSw5HmLyrC4mg+8seVtgi8SlY+M9DAwYGO0AGKs/EdPmhUX6clpZh74EWxMsTNH
 nf0SWx+33auO0mQMadaIm800TTsj2zrfG59e57mLGRkO1kIxW+YNe/f/LKJF/0I0hjRZpOKL4OR
 Mt3HDIJ2reAges7idYlnAZzbneDFIiByCIKsn7H26EQj+cC4oN9/IGxThloXuhcmyx2/V17DU4W
 La04PUzd0L7/zlJ/Uba/jz/JhAS/R4yYyotG8uuFTEodNJo0Wk8yV9v+kGV84vNOsIrloIYF1J/
 X+W0svXohNCPaaAnUmaeVL1C6QqVZMhdoJWxmOri/0eB8F2d9C/4R1XUL4zkgBJq/2STMs3dpRl
 calYrwmnsioWoD0QLoQ==
X-Authority-Analysis: v=2.4 cv=Osl/DS/t c=1 sm=1 tr=0 ts=6a96ac94 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=hO5a31gzfTtka3imJY8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5MyBTYWx0ZWRfX9p36Wzewfz1e
 10BKyRVhZIfZ/TNk9IKGwY8+itlRDD8Rl47+EYc9D8jh/gGGd5YIl3YiEuJFpivZOwBTAVCVXNU
 BKYlvfqGibbdD0n3OEqD7o+jJEUwPJ0=
X-Proofpoint-ORIG-GUID: -n4bG1YOAQCS5g2RVIGyjtKUE8J0KoFi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010093


On 09/04/26 8:42 pm, Kyle Mahlkuch wrote:
> Imporve synchronization and cleanup logic in the fc_remove_host() and
> fc_rport_final_delete() to prevent use-after-free conditions during
> host removal
>
> Vport cleanup:
>   - Mark all vports with FC_VPORT_DELETING under lock
>   - Cancel all vport work synchronously before removing from the list
>   - Synchronous deletion with fc_vport_terminate()
>
> Rport cleanup, applied to rports and rport_binding
>   - Mark all rport with FC_PORTSTATE_DELETED under lock
>   - Cancel all timers and work synchronously before removing from the 
> list
>   - Call fc_rport_final_delete() synchronously instead of queuing
>
> fc_rport_final_delete():
>   - Calling cancel_delayed_work_sync() for any outstanding delayed work
>   - Clear FC_RPORT_DEVLOSS_PENDING under lock
>   - Flushing all pending work completes before destruction
>
> Signed-off-by: Thinh Tran <thinhtr@linux.ibm.com>
> Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
> ---


Tested-by: Maram Srimannarayana Murthy <msmurthy@linux.ibm.com>

Tested the complete 3-patch series on an IBM Power11 (ppc64le) server 
equipped with an Emulex FC HBA.
The patches applied cleanly, and FC driver parameter validation testing 
was executed continuously for 36 hours.
No crashes, hangs, or functional issues were observed during the test 
period.

Thanks,
Maram Srimannarayana Murthy


>  drivers/scsi/scsi_transport_fc.c | 85 ++++++++++++++++++++++++--------
>  1 file changed, 64 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_fc.c 
> b/drivers/scsi/scsi_transport_fc.c
> index 123b22b52640..0adb9330befc 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -39,6 +39,7 @@ static void fc_li_stats_update(u16 event_type,
>  static void fc_delivery_stats_update(u32 reason_code,
>                       struct fc_fpin_stats *stats);
>  static void fc_cn_stats_update(u16 event_type, struct fc_fpin_stats 
> *stats);
> +static void fc_rport_final_delete(struct work_struct *work);
>
>  /*
>   * Module Parameters
> @@ -2883,31 +2884,71 @@ fc_remove_host(struct Scsi_Host *shost)
>      struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
>      unsigned long flags;
>
> -    spin_lock_irqsave(shost->host_lock, flags);
> -
>      /* Remove any vports */
> +    /* Mark FC_VPORT_DELETING for now */
> +    spin_lock_irqsave(shost->host_lock, flags);
>      list_for_each_entry_safe(vport, next_vport, &fc_host->vports, 
> peers) {
>          vport->flags |= FC_VPORT_DELETING;
> -        fc_queue_work(shost, &vport->vport_delete_work);
> +    }
> +    spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +    /*
> +     * remove all vport works synchronously BEFORE removing from list.
> +     * This prevents use-after-free when timers fire.
> +     */
> +    list_for_each_entry_safe(vport, next_vport, &fc_host->vports, 
> peers) {
> +        /* Cancel any pending work/timers */
> +        cancel_work_sync(&vport->vport_delete_work);
> +        /* Now safe to do synchronous deletion */
> +        fc_vport_terminate(vport);
>      }
>
>      /* Remove any remote ports */
> +    /* Mark rports and rport_bindings with FC_PORTSTATE_DELETED for 
> now */
> +    spin_lock_irqsave(shost->host_lock, flags);
>      list_for_each_entry_safe(rport, next_rport,
>              &fc_host->rports, peers) {
> -        list_del(&rport->peers);
>          rport->port_state = FC_PORTSTATE_DELETED;
> -        fc_queue_work(shost, &rport->rport_delete_work);
>      }
>
>      list_for_each_entry_safe(rport, next_rport,
>              &fc_host->rport_bindings, peers) {
> -        list_del(&rport->peers);
>          rport->port_state = FC_PORTSTATE_DELETED;
> -        fc_queue_work(shost, &rport->rport_delete_work);
>      }
> -
>      spin_unlock_irqrestore(shost->host_lock, flags);
>
> +    list_for_each_entry_safe(rport, next_rport,
> +            &fc_host->rports, peers) {
> +        /* Cancel ALL timers and work before removing from list */
> +        cancel_delayed_work_sync(&rport->fail_io_work);
> +        cancel_delayed_work_sync(&rport->dev_loss_work);
> +        cancel_work_sync(&rport->scan_work);
> +        cancel_work_sync(&rport->stgt_delete_work);
> +
> +        spin_lock_irqsave(shost->host_lock, flags);
> +        list_del(&rport->peers);
> +        spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +        /* Now safe to do final deletion synchronously */
> +        fc_rport_final_delete(&rport->rport_delete_work);
> +    }
> +
> +    list_for_each_entry_safe(rport, next_rport,
> +            &fc_host->rport_bindings, peers) {
> +        /* Cancel ALL timers and work before removing from list */
> +        cancel_delayed_work_sync(&rport->fail_io_work);
> +        cancel_delayed_work_sync(&rport->dev_loss_work);
> +        cancel_work_sync(&rport->scan_work);
> +        cancel_work_sync(&rport->stgt_delete_work);
> +
> +        spin_lock_irqsave(shost->host_lock, flags);
> +        list_del(&rport->peers);
> +        spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +        /* Now safe to do final deletion synchronously */
> +        fc_rport_final_delete(&rport->rport_delete_work);
> +    }
> +
>      /* flush all scan work items */
>      scsi_flush_work(shost);
>
> @@ -2983,21 +3024,22 @@ fc_rport_final_delete(struct work_struct *work)
>          scsi_flush_work(shost);
>
>      /*
> -     * Cancel any outstanding timers. These should really exist
> -     * only when rmmod'ing the LLDD and we're asking for
> -     * immediate termination of the rports
> +     * Cancel any outstanding delayed work synchronously.
> +     * This must be done BEFORE taking spinlock and BEFORE
> +     * any state changes, as cancel_delayed_work_sync() can sleep.
> +     *
> +     * These timers should only exist when rmmod'ing the LLDD
> +     * and we're asking for immediate termination of rports.
> +     */
> +    cancel_delayed_work_sync(&rport->fail_io_work);
> +    cancel_delayed_work_sync(&rport->dev_loss_work);
> +    cancel_work_sync(&rport->scan_work);
> +    /*
> +     * Now safe to clear the flag under spinlock since all
> +     * async work has been cancelled.
>       */
>      spin_lock_irqsave(shost->host_lock, flags);
> -    if (rport->flags & FC_RPORT_DEVLOSS_PENDING) {
> -        spin_unlock_irqrestore(shost->host_lock, flags);
> -        if (!cancel_delayed_work(&rport->fail_io_work))
> -            fc_flush_devloss(shost, rport);
> -        if (!cancel_delayed_work(&rport->dev_loss_work))
> -            fc_flush_devloss(shost, rport);
> -        cancel_work_sync(&rport->scan_work);
> -        spin_lock_irqsave(shost->host_lock, flags);
> -        rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
> -    }
> +    rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
>      spin_unlock_irqrestore(shost->host_lock, flags);
>
>      /* Delete SCSI target and sdevs */
> @@ -3027,6 +3069,7 @@ fc_rport_final_delete(struct work_struct *work)
>      if (rport->devloss_work_q) {
>          work_q = rport->devloss_work_q;
>          rport->devloss_work_q = NULL;
> +        flush_workqueue(work_q);
>          destroy_workqueue(work_q);
>      }
>
