Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792653918;
	b=YyZC0aQ7oaIB2xIfa0h066MjJfLKtDVBB73MIxR3C53y5l/YPGoJMkR4G5ru8Is/fdQ2
	 M4SHB1zf19vARtak9rxQ2vy8UWXGvjEwoQFoxiHBnAENDWwAmzk5ntzNgmrB6vDJmIi3H
	 YRUTBVbCwoWFBXmNA5V2eXkNsbHJaHg1dDaA8A+rblvuDP/yPi1W+Vy/GnZo9tvc+QiId
	 YfLgspYRWUhvAkZHYNrXBEYFvTgbKiyiQP5MS5kOIOB3TGE6mUCk8QJOfuZ09KO/bK7bH
	 JWqljLNstdCi857TKvuvlHn/w4dznszvPmX0ai2j9KVwOl/IfJtsBGpKej1gMh6ausQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792653918;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=3+sI12mDcyiWW+7rUXYLDI24xLKvRl6Qlbizw4n1tjU=;
	b=fczCgmWh7i0ptCkg24NVEXktOgWJkGIyHiDQluHRV2xoJp+NQ4i+5g+Eo7aHfRidb82c
	 MVDebz5zWpk/O5yaCu/fb67HfzwybQ/HeNGSO2KpItA0kimbm8hfQJE3mc0GWyo1U0MNJ
	 4J6D9C3y0Gk0cVyZks7wBU5UMCbW+dp7EDnyKNLVRubhWFiZV2B4U9hCG/SHPsJhBTTnb
	 uuBPcLQ1AvywQ+DhLR26MHrt127oGkV+KDEtFn6CztgXhd08+N/YCd2xyigF50KfGcerD
	 JLSdNNY6iZAmabX9UqVEY4eWuYoN5XpQVMzdoXMZgBoM1J96ya37z9PvzZwVjLb4Qag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZrvXmHSJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2694606A33F;
	Thu, 22 Oct 2026 07:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZrvXmHSJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF0D1F000C9;
	Thu, 22 Oct 2026 07:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792653917;
	bh=3+sI12mDcyiWW+7rUXYLDI24xLKvRl6Qlbizw4n1tjU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ZrvXmHSJGSjbI+sMVod0u0OAzSFZQKd0AljLQMqU/sssGFDJtwoe1no2KdWHc40X2
	 1pHfxlJpP8CLLESSRCi/LN6iB8dQYJbuQ1Q8jG3M6vy2rvuxeFc+FXvSmRVdL2/KH3
	 3kBP3Rr77eqeztOwuNWspjKWbixPekqvb/rSNpCJQ/IL7AfrNmJfTm68X96akEzJH+
	 nPwsKlpLlz27gElQuFRE5bMI5r9g5aDQF9VbFCkeA8RTRNqxQTJxhLP5IPg/Q3fmuo
	 TdeKPtsTJOynGWML5JLgqdJmIjLYJCLNHyNv4Ab/Nwq+Dos6RNrv9d7WzOxFQJFKCi
	 I9MIW/6EyOOug==
Subject: Re: [PATCH] libcxgb: use raw_cpu_ptr() in ppm_get_cpu_entries()
From: netdev-bot+sashiko@kernel.org
To: haoranwangsec@gmail.com
Cc: varun@chelsio.com, bigeasy@linutronix.de, clrkwllms@kernel.org,
 rostedt@goodmis.org, linux-rt-devel@lists.linux.dev,
 linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kuba@kernel.org
Date: Thu, 22 Oct 2026 07:25:16 +0000
Message-ID: <179265391648.3135.4737238756305443681@kernel.org>
In-Reply-To: <179241614797.5916.13928836073297916808@whr>
References: <179241614797.5916.13928836073297916808@whr>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch introduces a cpu/pool mismatch race in
  ppm_get_cpu_entries()…
- [Low] The commit is a bug fix for a user-visible 'BUG: sleeping
  function called from invalid context' on PREEMPT_RT.

--

libcxgb: use raw_cpu_ptr() in ppm_get_cpu_entries()

This patch changes ppm_get_cpu_entries(). It drops get_cpu(),
per_cpu_ptr() and put_cpu() and uses raw_smp_processor_id() and
raw_cpu_ptr() instead. The aim is to stop spin_lock_bh() from being taken
with preemption disabled, which triggers a sleeping-in-atomic BUG on
PREEMPT_RT.

> Signed-off-by: Haoran Wang <haoranwangsec@gmail.com>

[Severity: Low]
This fixes a user-visible BUG on PREEMPT_RT, but the commit has no Fixes:
tag. The get_cpu()/per_cpu_ptr()/spin_lock_bh()/put_cpu() sequence has
not changed since it was added in:

Fixes: 47da7e62b391 ("cxgb4: add iSCSI DDP page pod manager")

Should that tag be added, possibly with a Cc: stable?

> diff --git a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
> index 2e3973a32d9d..5f68c5d5766e 100644
> --- a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
> +++ b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
> @@ -125,10 +125,9 @@ static int ppm_get_cpu_entries(struct cxgbi_ppm *ppm, unsigned int count,
>  	if (!ppm->pool)
>  		return -EINVAL;
>  
> -	cpu = get_cpu();
> -	pool = per_cpu_ptr(ppm->pool, cpu);
> +	cpu = raw_smp_processor_id();
> +	pool = raw_cpu_ptr(ppm->pool);

[Severity: High]
Can cpu and pool refer to different CPUs here?

The new code reads the current CPU twice, with preemption and migration
both enabled. Say the task moves from CPU A to CPU B between
raw_smp_processor_id() and raw_cpu_ptr(). The bit is then reserved in CPU
B's bitmap under CPU B's lock, but the returned index is built from the
old cpu value:

drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c:ppm_get_cpu_entries() {
    ...
	i += cpu * ppm->pool_index_max;
	ppm_mark_entries(ppm, i, count, caller_data);
    ...
}

The index and the ppod_data[] entry now point into CPU A's slice, while
bit i in CPU A's bitmap is still clear.

Could a task on CPU A then get the same index, hardware page pod and
ppod_data slot while the first transfer is still in flight?

cxgbi_ppm_ppods_reserve() turns this index into hwidx and the DDP tag.
cxgbit_ddp_reserve() and cxgbi_ddp_reserve() then program that tag into
the adapter. The caller_data in ppod_data[] is also what
cxgbi_parse_pdu_itt() uses later to match responses to tasks.

On release, ppm_unmark_entries() gets the pool back from the index:

	cpu = i / ppm->pool_index_max;
	i %= ppm->pool_index_max;

	pool = per_cpu_ptr(ppm->pool, cpu);
	spin_lock_bh(&pool->lock);
	bitmap_clear(pool->bmap, i, count);

That would clear the bit in CPU A's pool, which may free another
transfer's live entry. The bit that was really set in CPU B's pool would
never be cleared.

One preemptible caller that holds no spinlock is the iSCSI target TX
path:

iscsit_send_r2t()
  cxgbit_get_r2t_ttt()
    cxgbit_ddp_reserve()
      cxgbi_ppm_ppods_reserve()
        ppm_get_cpu_entries()

iscsit_get_r2t_from_list() drops r2t_lock before it returns, so this
whole chain runs unlocked. A remote initiator can drive it simply by
sending WRITE commands to a Chelsio-offloaded target.

The raw_ accessors are not checked by CONFIG_DEBUG_PREEMPT, so nothing
would warn. The race exists on any SMP kernel built with CONFIG_PREEMPT,
PREEMPT_LAZY or PREEMPT_RT.

Given that, do these parts of the commit message still hold?

    The preemption disable exists only to stabilize the per-CPU accessor,
    the pool is serialized by pool->lock, not by preemption.

    ...the defect is PREEMPT_RT-specific.

The returned index encodes cpu, so cpu and pool still have to match even
though pool->lock serializes the bitmap.

Would it work to keep the saved cpu and derive the pool from it? For
example:

	cpu = raw_smp_processor_id();
	pool = per_cpu_ptr(ppm->pool, cpu);

Another option would be to wrap the lookup in
migrate_disable()/migrate_enable().

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/179241614797.5916.13928836073297916808%40whr
