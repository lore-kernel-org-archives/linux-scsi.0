Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794614256;
	b=vw1c1ul/e/MJpZfZyak+d8h5N8sOwtKUWhQVnwATtek+nYUBayzi/k93HFtKe/ofNOz3
	 QL2ogzuYZLgVNr/Wqns4epZxZpRrJ6voZEoUoB1VAeqqhL/8VSIoUfKvfLaqXMXJLOGwt
	 uRImHJPE237RrLlrxLpG/yuJPT7F1cJgxv+ACkINRNJG/Qrk/TEXlF5aWEawKjbAb/4jG
	 CHn3XqIRuXth8QjbYKxY95KqeyF1aEcDKKr3CiruV3FyYIKNP1PFbd11by76mpfzIHWgD
	 x2truoApNqnj/fbl2/YrjSdjwKZNzmppK6pDZfTIhAq7Hy1gu5dXjP9DwQ2Bm32ELzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794614256;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6oOHlstDASuMb8SjlnDSCrd23sJasSQuQL6faxBaS4g=;
	b=Hbma1jaOfET5X0jz/xVmqu1kmORySke891drUGpXDuHCCC7QXZstbTZb68bZumoW145h
	 nXjmRGxCk/s0miOaiNi331SOoqq2I7ncwPXkq1vlenJbdOc/lhGbHX8eJENPh18bB8d/K
	 +3T8HZYgCvE2BrhpUzTqT52ftG4r03TiqCcNNbhzOs9gj2MPsu0aS67614HDJRTS3TBn5
	 ekptyy9QmrDneT4WON2TNCrTzV/NKnUSMNyeSAO3oJBRJy2xCYJYovN5FryJrV4+GC1PX
	 JdkzrpobpWzNa1zL/zsd2Q0OYBQE6ZoQG0RndpZCZBYMEQ4WR3mEjZzXi8cqL8OQp/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BpFsfEQq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F614606A890
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 23:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BpFsfEQq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835691F000C4;
	Fri, 13 Nov 2026 23:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794614255;
	bh=6oOHlstDASuMb8SjlnDSCrd23sJasSQuQL6faxBaS4g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BpFsfEQqSt3Xb8KhXW5DWP//bjRX/MEmeXEJraH6ToCMFcRgn8zSEZeXRcMqH36nX
	 5s1M7u1vOBiuk6GMRy+FiMm5HV0GuJwZy+zeyFUeJXF++toOp6+LWmF30nLCiRnnq0
	 T3rHo+GmKy02bOzP+58fAaQ5FiRnaUZVoY+nPsGk4KgsekNBp1U9pdZi7c4ygnsQ7i
	 4LNVLAHq2K5AvOmHYhuoXdiXt/62CKFTVwtzNAi70TihokGrszBXV4tH2zui2ivJq9
	 bN+5qjBj+T8fNtGw2Q5go1cH6c6IdssqFmQdTQJZQKcanbtSiRdXpXkw79Nlkj3Dmb
	 rtjdbO7XuzsdQ==
Message-ID: <sashiko-outbox-213889@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] scsi: libiscsi: only complete a task that has
 been sent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261113233938.397415-2-yhlee@isslab.korea.ac.kr>
References: <20261113233938.397415-1-yhlee@isslab.korea.ac.kr>
 <20261113233938.397415-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 23:57:35 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] scsi: libiscsi: premature ISCSI_TASK_RUNNING before xmit ref
  acquisition
--

commit 7682c2a848ebe294348224903c5fc89275f307e1
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: libiscsi: only complete a task that has been sent

This commit uses smp_store_release() to mark a task ISCSI_TASK_RUNNING in
iscsi_prep_scsi_cmd_pdu() and iscsi_prep_mgmt_task(), and checks for
ISCSI_TASK_RUNNING with smp_load_acquire() in the RX path before
completing a management or rejected task.

> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 2d04448432a77..83d726043d3e8 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -429,7 +429,8 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task =
*task)
>  	if (session->tt->init_task && session->tt->init_task(task))
>  		return -EIO;
> =20
> -	task->state =3D ISCSI_TASK_RUNNING;
> +	/* Pairs with the acquire in the RX task lookups. */
> +	smp_store_release(&task->state, ISCSI_TASK_RUNNING);
>  	session->cmdsn++;
> =20
>  	conn->scsicmd_pdus_cnt++;
> @@ -702,7 +703,8 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *co=
nn,
>  	if ((hdr->opcode & ISCSI_OPCODE_MASK) =3D=3D ISCSI_OP_LOGOUT)
>  		session->state =3D ISCSI_STATE_LOGGING_OUT;
> =20
> -	task->state =3D ISCSI_TASK_RUNNING;
> +	/* Pairs with the acquire in the RX task lookups. */
> +	smp_store_release(&task->state, ISCSI_TASK_RUNNING);
>  	ISCSI_DBG_SESSION(session, "mgmtpdu [op 0x%x hdr->itt 0x%x "
>  			  "datalen %d]\n", hdr->opcode & ISCSI_OPCODE_MASK,
>  			  hdr->itt, task->data_count);

[Severity: High]
Can the RX path still complete and free task after
smp_store_release(&task->state, ISCSI_TASK_RUNNING) before the transmit
path finishes using it or acquires its reference?

iscsi_data_xmit() runs under session->frwd_lock and calls
iscsi_prep_mgmt_task() (or iscsi_prep_scsi_cmd_pdu()) while task->refcount
is still 1, before iscsi_xmit_task() takes the transmit reference.  Since
__iscsi_complete_pdu() and iscsi_handle_reject() run concurrently under
session->back_lock, an unsolicited response or Reject naming that ITT can
arrive in between:

kworker (CPU0)                    <softirq> (CPU1)
iscsi_data_xmit()
  spin_lock_bh(&session->frwd_lock)
  iscsi_prep_mgmt_task(conn, task)
    smp_store_release(&task->state,
                      ISCSI_TASK_RUNNING)
                                  __iscsi_complete_pdu()
                                    spin_lock(&session->back_lock)
                                    smp_load_acquire(&task->state)
                                      =3D=3D ISCSI_TASK_RUNNING
                                    iscsi_complete_task(task, ...)
                                      __iscsi_put_task(session, task)
                                        iscsi_free_task(task)
    ISCSI_DBG_SESSION(...)
      hdr->opcode                 <-- use-after-free if cleanup_task
                                      freed task->hdr
  iscsi_xmit_task(..., task, false)
    iscsi_get_task(task)          <-- fails (refcount =3D=3D 0),
                                      triggers WARN_ON_ONCE(1)

Even if iscsi_get_task() runs before the RX completion, iscsi_xmit_task()
drops session->frwd_lock around session->tt->xmit_task(task); if RX
completes the task during that window and xmit_task() returns an error
such as -EAGAIN, iscsi_xmit_task() unconditionally calls
iscsi_get_task(task) and saves the completed task in conn->task for
retransmission:

drivers/scsi/libiscsi.c:iscsi_xmit_task() {
    ...
	spin_unlock_bh(&session->frwd_lock);
	rc =3D session->tt->xmit_task(task);
	spin_lock_bh(&session->frwd_lock);
	if (!rc) {
		/* done with this task */
		task->last_xfer =3D jiffies;
	} else {
		/*
		 * get an extra ref that is released next time we access it
		 * as conn->task above.
		 */
		iscsi_get_task(task);
		conn->task =3D task;
	}
    ...
}

In addition, for transports without ihost->workq, iscsi_send_mgmt_task()
and iscsi_queuecommand() call iscsi_prep_mgmt_task() or
iscsi_prep_scsi_cmd_pdu() and invoke session->tt->xmit_task(task) directly
without taking an extra task reference at all, so an RX completion after
ISCSI_TASK_RUNNING is stored frees task while xmit_task() is running (and
if xmit_task() fails, the caller puts task a second time).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113233938.3974=
15-1-yhlee@isslab.korea.ac.kr?part=3D1
