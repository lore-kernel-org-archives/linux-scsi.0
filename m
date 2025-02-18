Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8977270ECB
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2025 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739902219; cv=none; b=dHTGoTGTltzuVWDBx+snqIC2MGzbKATq0uo6FLAU9eMoKLnytbM7s+/d+v+R0GLa9hT5iSXlzoVDKsW7yi/insN7JuR79qjk2foxWScvwekSn8ghc7p0PST600cHnXwOUJeU0hntOXASvqEjqXhQBdYODA+ZuAQtyfTx0VUy95o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739902219; c=relaxed/simple;
	bh=9WOQdlNYHB9Pp4e9uTfIt7aKYRgfoeh9IQKyXqr40YM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GxMMJsfcedG0FBboRr12UAeNSaeWlYie4jBxF3eFMvxhsIkMhWK5VZakDkfRo7FZ87ObHKVBfzvSgql8kO12zF3IBsWSULx1oI5i/wyDMNt1wSO6dSPrCNzzLuH6vCJm8kdQM3GGeM+lct5AoVC3LTy0ifM0TgcSQlo8VIWReug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=b4a0Ggii; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="b4a0Ggii"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Yy6xv0FFlzlgTwX;
	Tue, 18 Feb 2025 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739902209; x=1742494210; bh=5W4B9ENosf3TBJozaHI7BNQ1
	e9PQ5LvOG6pv9LVYkOY=; b=b4a0Ggiit7k8d3gS7UizmnKcSI/+N5gsirr70ogR
	YTTfj+Fy8USF7L+bJuLRvQpVAW0WE3JhLfkKqN8lXe8fKovJK1CmxZPjZLd8df/c
	yMxJjM2AeRKhpEFsNUxpt9hqRu1dSveSvzqbVIVza1i6E3r0YIfMrf1SREQhQymu
	F0rMUiYQ3A1loIprYM1gWDVHMoqQKGDLzU4J3ui6KCXIwe5aIM8Cb6TFagvqKk5Q
	GGaHcy9rnfM4wXwL94DxLZjD4Mf7v3i+TBuINgrVlK7DQ27z3OrQDuUoQvOSdhBO
	VjSmcxaLDbdDQC3kVJjnwhn1ZLJxZGBf0/rLTt+eF+7YFw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ak_AU2trct-7; Tue, 18 Feb 2025 18:10:09 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Yy6xr1l4zzlgTvv;
	Tue, 18 Feb 2025 18:10:07 +0000 (UTC)
Message-ID: <3dd1baa8-e236-41f2-810b-e14a28b72ba5@acm.org>
Date: Tue, 18 Feb 2025 10:10:07 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: clear driver private data when retry
 request
To: John Garry <john.g.garry@oracle.com>, yebin <yebin@huaweicloud.com>,
 jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: zhangxiaoxu5@huawei.com
References: <20250217021628.2929248-1-yebin@huaweicloud.com>
 <4fe6b94e-41ae-48b4-aa9d-a0712a4ef16e@oracle.com>
 <67B46DBD.7060805@huaweicloud.com>
 <11a36fb5-2644-405f-b368-e9a23a6e92c7@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <11a36fb5-2644-405f-b368-e9a23a6e92c7@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/18/25 4:13 AM, John Garry wrote:
> TBH, I am not sure on the history here. Maybe Bart or Christoph knows, 
> but my impression is still that the priv data is only cleared once in 
> the lifetime of the request (from 1bad6c4a) - at prep time - and some 
> drivers may rely on that (not be cleared again). Unlikely, though.

I'm not aware of any such drivers.

Driver-private data was introduced together with the scsi-mq code. I'm
not aware of a similar concept in the legacy SCSI core.

Commit d285203cf647 ("scsi: add support for a blk-mq based I/O path")
introduced the following code in kernel v3.17-rc1:

+static int scsi_mq_prep_fn(struct request *req)
+{
[ ... ]
+       memset(cmd, 0, sizeof(struct scsi_cmnd));
[ ... ]
+static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
+{
[ ... ]
+       if (!(req->cmd_flags & REQ_DONTPREP)) {
+               ret = prep_to_mq(scsi_mq_prep_fn(req));
+               if (ret)
+                       goto out_dec_host_busy;
+               req->cmd_flags |= REQ_DONTPREP;
+       }

I think the above memset() call was introduced because of the following
code in the legacy SCSI core (from kernel v3.16):

struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t 
gfp_mask)
{
	struct scsi_cmnd *cmd = scsi_host_alloc_command(shost, gfp_mask);

	if (unlikely(!cmd)) {
		unsigned long flags;

		spin_lock_irqsave(&shost->free_list_lock, flags);
		if (likely(!list_empty(&shost->free_list))) {
			cmd = list_entry(shost->free_list.next,
					 struct scsi_cmnd, list);
			list_del_init(&cmd->list);
		}
		spin_unlock_irqrestore(&shost->free_list_lock, flags);

		if (cmd) {
			void *buf, *prot;

			buf = cmd->sense_buffer;
			prot = cmd->prot_sdb;

			memset(cmd, 0, sizeof(*cmd));

			cmd->sense_buffer = buf;
			cmd->prot_sdb = prot;
		}
	}

	return cmd;
}
EXPORT_SYMBOL_GPL(__scsi_get_command);

If I'm reading the v3.16 block layer and SCSI code correctly,
__scsi_get_command() was called not only when a command was submitted
but also when it got resubmitted. See also the q->prep_rq_fn() call in
blk_peek_request().

Since the historic behavior involved clearing the entire struct
scsi_cmnd during requeuing, I'm fine with restoring this behavior.

Thanks,

Bart.
