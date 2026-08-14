Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D23A339872;
	Fri, 14 Aug 2026 17:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786728438; cv=none; b=kaxmuiSq7CEEefbHIj1rmAJE53VrJghIYQTB31DGtL7f11EVxpdyrRroAESmp6Z92lBRm/T+dxdDZW7+5Oe+xjXAuv40g4X6SLouahG1LLSRERM3EJDm7At0N3tgnADHxq9t7nfYsbqA65gciLbbfipCUtCjoLdf8/WLPVSI6GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786728438; c=relaxed/simple;
	bh=M7BVIQ/+SbYKJZZoZt34Xw8W12snXEQ7XHuSQD5+WtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mLusDDhIRxQCre10YCFSM84guqNUZ5PWZziujpVNxIMUjrs/Kw/1NzLozfXBxDwN2yrUJzOOLfyOgBXwEjl7MiZ7iKeX5tFGdCfJTRHV6U4Aw84056EqGERNLYqqX4Bgv/sgYNf6COcE+VIbowQwkyPICHc6TOLVdx3reCclV9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=t5HPnnZu; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="t5HPnnZu"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hM8LC6cQkz1XLyhh;
	Fri, 14 Aug 2026 17:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786728431; x=1789320432; bh=thp8cFGbRG7io6Id2x7m/1rp
	1dPV40UDC8tQ1E+pZL4=; b=t5HPnnZuI4/O0XplbOjwetLGAuXQTuu6UEHGrAkX
	t434Q5ygl19D0dC+PCDvb82O+lIN0PcCM7ngCpX84vdSpWpxL5twUseoc1qfhWNy
	5DiYW56RcwVbMLG97ylIAREmy+K0ZemfbikiZMZy5Btp1v1hcZoaE4as/aUUXFhY
	BdZ0fm1394gwFr+MQ9ZKU54U8JAlkWj3WgSZA2jAfIJ6YEox73PzN2r92XngJyQV
	bw70UqNPsOjecbtTGNkP4UGcTy12+O2eTvB/VTjIvTYk5C1XI7Hpw/6FYVi8clIg
	cxJBfZUCPcVDaGf+gbh7HIpl+mMnyQUVjwLFVdDLITl7Fg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6qw0VPSav8dT; Fri, 14 Aug 2026 17:27:11 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hM8L62KWNz1XLyhb;
	Fri, 14 Aug 2026 17:27:10 +0000 (UTC)
Message-ID: <414a2b55-ee58-4975-a76a-49202b9c0302@acm.org>
Date: Fri, 14 Aug 2026 10:27:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: check that the tag map is still there in
 scsi_host_find_tag()
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260814010423.205976-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260814010423.205976-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/26 6:04 PM, Yehyeong Lee wrote:
> diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
> index ea7848e74d257..d62bae05d4e7d 100644
> --- a/include/scsi/scsi_tcq.h
> +++ b/include/scsi/scsi_tcq.h
> @@ -29,7 +29,8 @@ static inline struct scsi_cmnd *scsi_host_find_tag(struct Scsi_Host *shost,
>   		return NULL;
>   
>   	hwq = blk_mq_unique_tag_to_hwq(tag);
> -	if (hwq < shost->tag_set.nr_hw_queues) {
> +	if (hwq < shost->tag_set.nr_hw_queues && shost->tag_set.tags &&
> +	    shost->tag_set.tags[hwq]) {
>   		req = blk_mq_tag_to_rq(shost->tag_set.tags[hwq],
>   					blk_mq_unique_tag_to_tag(tag));
>   	}

Thanks for the detailed report but I think this is the wrong way to fix
the reported crash. Please help with testing this patch:


From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 14 Aug 2026 17:00:55 +0000
Subject: [PATCH] RDMA/srp: Fix srp_remove_target()

Remove all logical units before disconnecting the transport because one or
more SCSI commands may be submitted while removing logical units. Remove
the SCSI host after the transport has been disconnected because the code
that disconnects the transport needs resources that are freed by the code
that removes the SCSI host (SCSI host tag set). Remove the srp_rport_get()
and srp_rport_put() calls because the purpose of these calls was to keep
the rport until tl_err_work is cancelled. This patch fixes the following
crash:

Oops: general protection fault, probably for non-canonical address 
0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:srp_recv_done+0x618/0x1aa0
  __ib_process_cq+0xe1/0x390
  ib_poll_handler+0x6e/0x200
  irq_poll_softirq+0x1df/0x480
  do_softirq+0x3b/0x60
  </IRQ>

Reported-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/infiniband/ulp/srp/ib_srp.c | 14 ++++++++++----
  1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c 
b/drivers/infiniband/ulp/srp/ib_srp.c
index acbd787de265..0b296b5715a8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1038,15 +1038,20 @@ static void srp_del_scsi_host_attr(struct 
Scsi_Host *shost)

  static void srp_remove_target(struct srp_target_port *target)
  {
+	struct scsi_device *sdev;
  	struct srp_rdma_ch *ch;
  	int i;

  	WARN_ON_ONCE(target->state != SRP_TARGET_REMOVED);

  	srp_del_scsi_host_attr(target->scsi_host);
-	srp_rport_get(target->rport);
-	srp_remove_host(target->scsi_host);
-	scsi_remove_host(target->scsi_host);
+	/*
+	 * Remove all logical units. This must happen before the
+	 * srp_disconnect_target() call because scsi_remove_device() may trigger
+	 * submission of SCSI commands. See also sd_shutdown().
+	 */
+	shost_for_each_device(sdev, target->scsi_host)
+		scsi_remove_device(sdev);
  	srp_stop_rport_timers(target->rport);
  	srp_disconnect_target(target);
  	kobj_ns_drop(KOBJ_NS_TYPE_NET, to_ns_common(target->net));
@@ -1055,7 +1060,8 @@ static void srp_remove_target(struct 
srp_target_port *target)
  		srp_free_ch_ib(target, ch);
  	}
  	cancel_work_sync(&target->tl_err_work);
-	srp_rport_put(target->rport);
+	srp_remove_host(target->scsi_host);
+	scsi_remove_host(target->scsi_host);
  	kfree(target->ch);
  	target->ch = NULL;


