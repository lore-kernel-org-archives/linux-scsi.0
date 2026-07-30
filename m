Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267684756C9
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453427; cv=none; b=gzdFBZA9rM1A7i5CgokxhcP08fqOyW+sJ0KCq7DyV6onzkH8Fx4AnqCGRDWjqyw5JmQxIW24/LXbAyrO1Bc9kjyNv6ZnLzDVgkvOCq3bj58LNZYnoqw4fgQmBFo7WIkLzkatIADhQc5sIjLyL8/csgyHPAVFZRbaWFJeYQMwDy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453427; c=relaxed/simple;
	bh=Kh4SAy1J8FcBU/yXS6AIURm1DGIU7zyXvqjqt+lR3wU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J5eMJowKTIdYrnwqok4WCJqeZhEycIx7pgqE/T6VLSeUPXDiOMwQWta1kCB1S310MxaRcuEnz4yzN8osm6/Szo8PtJyyeOzX9t3L5de8ddAsB1o+USpHgtB5f+tFBsR87G5Q5cgNxodCLH+z8URs+5IhUTgSJXFJE/AklIcqxDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJhMjmzt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJhMjmzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5939C1F000E9;
	Thu, 30 Jul 2026 23:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453424;
	bh=Hl9OyQBstCxAzAXQkIGWMxofXPJoj56SyKWGnUrmS4Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bJhMjmztTFsyQUAXv/SmqrfqBMfGfPa6UBhWtdagSLajJXJJUOu2ZtajzewlZV6Bp
	 baWGkey0fMAZOGYjP9bqe+8y59tz3bowHBEkG7JT5iu51Sf63KfqMSSNGOpmrNYEvM
	 ST987f9Y8jvfjm+MtPhCI+wKBGo/W6bXcaQOt37H2gBLgr3H7oISb93iH7rrg7doeB
	 f/rpW28FMMxCzFm6LrAbt01QU3XEBZ3wZYiil9Epj9VJ3hlHWq6A0VgVn0Iw2bKXIU
	 Movu+m3jz5zsfFbVcCQyj9ixkBKCpopea4L/LcWkEdFaJNhvgurQOeI9ey9fnLA5xx
	 ozRQ5qQW5a2lQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 35/57] scsi: libiscsi: Prepare for enabling lock
 context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <1af31b1ec29305661d2254a81c1839a4948bcd38.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <1af31b1ec29305661d2254a81c1839a4948bcd38.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:17:03 +0000
Message-Id: <20260730231704.5939C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Low] Missing __must_hold() annotations for core locking functions.
- [Low] Missing __must_hold annotation on __iscsi_complete_pdu() definition.

Pre-existing issues:
- [High] Deadlock due to `iscsi_complete_pdu()` acquiring `session->frwd_lo=
ck` without disabling softirqs.
- [High] Hard deadlock due to `qla4xxx` acquiring `session->back_lock` in a=
 hardware interrupt context while `libiscsi` core leaves hardirqs enabled.
--

--- Patch [35]: [PATCH v3 35/57] scsi: libiscsi: Prepare for enabling lock =
context analysis ---
commit 052b7ed83fc5a572597a78bb52886b250ac80aa2
Author: Bart Van Assche <bvanassche@acm.org>

scsi: libiscsi: Prepare for enabling lock context analysis
   =20
This commit prepares libiscsi for lock context analysis by documenting
locking requirements using __must_hold().

> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
[ ... ]
> @@ -1962,6 +1965,7 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_con=
n *conn,
>   * Fail commands. session frwd lock held and xmit thread flushed.
>   */
>  static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
> +	__must_hold(&conn->session->frwd_lock)
>  {

[Severity: Low]
Should we also add these annotations to the core locking functions like
fail_scsi_task(), __fail_scsi_task(), and iscsi_send_nopout()?

Functions like __fail_scsi_task() manipulate sequence numbers and queues
that explicitly require both back_lock and frwd_lock to be held. Similarly,
iscsi_send_nopout() requires frwd_lock. Leaving these unannotated leaves
portions of the subsystem's logic unanalyzed by the context checker.

[ ... ]
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -474,8 +474,9 @@ extern int iscsi_conn_send_pdu(struct iscsi_cls_conn =
*, struct iscsi_hdr *,
>  				char *, uint32_t);
>  extern int iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
>  			      char *, int);
> -extern int __iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
> -				char *, int);
> +extern int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hd=
r *,
> +				char *, int)
> +		__must_hold(&conn->session->back_lock);

[Severity: Low]
Does the function definition in drivers/scsi/libiscsi.c also need this
annotation?

The __must_hold() attribute was added to the declaration here in the header,
but it seems omitted from the definition:

int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
                         char *data, int datalen)
{
    ...

While some static analyzers inherit attributes from the header, ensuring
locking annotations on declarations mirror their definitions provides
local consistency across translation units.

[Severity: High]
This isn't a bug introduced by this patch, but is there a potential softirq
deadlock when acquiring frwd_lock during pdu completion?

The generic API iscsi_complete_pdu() uses spin_lock() to acquire the
back_lock, which leaves softirqs enabled. Inside __iscsi_complete_pdu(),
processing an ISCSI_OP_NOOP_IN temporarily drops back_lock and acquires
frwd_lock using spin_lock():

__iscsi_complete_pdu()
    spin_unlock(&session->back_lock);
    spin_lock(&session->frwd_lock);
    iscsi_send_nopout(conn, (struct iscsi_nopin*)hdr);

When called from a process context, such as a workqueue handler, softirqs
remain enabled:

qla4xxx_task_work()
  -> iscsi_complete_pdu()
     spin_lock(&conn->session->back_lock);

If a timer softirq interrupts this process and attempts to acquire frwd_loc=
k,
it could spin forever waiting for the interrupted process to release it.

[Severity: High]
This is a pre-existing issue, but could this back_lock usage lead to a
hardirq deadlock with the qla4xxx driver?

The libiscsi core routinely acquires back_lock using spin_lock_bh() or
spin_lock() in functions like fail_scsi_tasks(), leaving hardware interrupts
enabled:

fail_scsi_tasks()
    spin_lock_bh(&session->back_lock);

However, the qla4xxx driver acquires back_lock from a hardware interrupt
context:

qla4_83xx_interrupt_service_routine()
  -> qla4xxx_process_response_queue()
    -> qla4xxx_passthru_status_entry()
       spin_lock(&conn->session->back_lock);

If a hardware interrupt fires on a CPU currently executing a libiscsi core
function that is holding back_lock, the interrupt handler will attempt to
acquire the lock and cause a hard deadlock.

>  extern int iscsi_verify_itt(struct iscsi_conn *, itt_t);
>  extern struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *, itt_t);
>  extern struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *, itt_t);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D35
