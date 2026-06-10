Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF323FCB39
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 11:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781089242; cv=none; b=E/5a8IdPM2ATEJ2+FejGn3w7yMWE/GNeIZc26+FLRHGTxS7wYe9kneCGC8UrSqMXK0zw5VQWEefqcVCWf+n7jQGBM1cKpHSlMMqjYLEddREnETsgXFdQDwFW8PEi9TDu3Oeaf4TKJgwGgSaIFEHY/pGMRF2SXeeJbDIrr3+BN64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781089242; c=relaxed/simple;
	bh=GGC1No7WYPzYm9lP88oSEOKjdzY9BKHDXPWylHpXoM0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QG39x8WMo2y6F7wsGTsPWYyZx8kOJknaEtV3xTepvAVRiNMU0uuLrIgdKB72SR8SR0pWPmgAmytT6cRJCx4Dno44WMFWiawLnWpN9Z+Ew7fNELQtNny+t5QNMxNC4ejDDIHWLM89/2v0gTUU2qalsMT4lx3invmva+UzzBx2iZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JWtGUWXp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yjxufWAR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aE82fglj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NNs6cpmY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JWtGUWXp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yjxufWAR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aE82fglj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NNs6cpmY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 88AE77581C;
	Wed, 10 Jun 2026 11:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781089235; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2I4ZEP18hlGuRjluq9/BBT7zqhaGgYRnQahT0UeNjz4=;
	b=JWtGUWXpK9dluLL9S/Q6klcCEIhtNPb1bh536JReWZN/EjhQqQR7s39PtBg6FVii+mYIF1
	IYU7q9S1l7dflNfKmHqgMuTscVAjn0WyXBkn4pDjFxrHI2PSK8iOzxnh474HjLWfI9k4uO
	t2D4X1+oSVfIffgrDIeOodJrBBs04pQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781089235;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2I4ZEP18hlGuRjluq9/BBT7zqhaGgYRnQahT0UeNjz4=;
	b=yjxufWARco5MtuDzsOqN+mhMfQCeTe+jCpWkPhMK2D3VrmMwxwgD67M+RsfJV977+qp/zm
	u7S5QHnKvYbRlYCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781089234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2I4ZEP18hlGuRjluq9/BBT7zqhaGgYRnQahT0UeNjz4=;
	b=aE82fgljuNyCyuyA77EAz3YOpp4tYlVwvJgudAuEBAbTWwL0n8G0YUBEZ2Jq+mGucqUNEx
	b3TZKmpjAEVT5h3PgNZigF0eeO16goWFdZQXUSYlgJes3RLINcB7FQzfXSXbEERSG0/wT5
	vmvzAG0r3IkaEUZ4GFsj3HsVerue06s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781089234;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2I4ZEP18hlGuRjluq9/BBT7zqhaGgYRnQahT0UeNjz4=;
	b=NNs6cpmYM/P7z2M0+atwDpWL/2rbqRApv9fTH4VcD8llM/E/DD81TEBjpUzRHOSTFBcS8m
	N7L1hD49c6dOLzDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3970D779A7;
	Wed, 10 Jun 2026 11:00:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l5WoN85DKWqYFAAAD6G6ig
	(envelope-from <ddiss@suse.de>); Wed, 10 Jun 2026 11:00:30 +0000
Date: Wed, 10 Jun 2026 21:00:25 +1000
From: David Disseldorp <ddiss@suse.de>
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Christie
 <michael.christie@oracle.com>, Maurizio Lombardi <mlombard@redhat.com>,
 John Garry <john.g.garry@oracle.com>, James Bottomley
 <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: target: fix iSCSI ISID use-after-free in
 REGISTER AND MOVE
Message-ID: <20260610210025.35dc7040.ddiss@suse.de>
In-Reply-To: <20260610042245.35473-1-hexlabsecurity@proton.me>
References: <20260610042245.35473-1-hexlabsecurity@proton.me>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -3.30
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid,proton.me:email]
X-Spam-Level: 

On Wed, 10 Jun 2026 04:22:48 +0000, Bryam Vargas wrote:

> core_scsi3_emulate_pro_register_and_move() maps the PERSISTENT RESERVE OUT
> parameter list with transport_kmap_data_sg() and parses the destination
> TransportID with target_parse_pr_out_transport_id(). For an iSCSI
> TransportID (FORMAT CODE 01b), iscsi_parse_pr_out_transport_id() returns
> the ISID in iport_ptr as a raw pointer into that mapped buffer.
> 
> The function then unmaps the buffer with transport_kunmap_data_sg() before
> dereferencing iport_ptr in strcmp(), __core_scsi3_locate_pr_reg() and
> core_scsi3_alloc_registration(). When the parameter list spans more than
> one page (PARAMETER LIST LENGTH > 4096), transport_kmap_data_sg() uses
> vmap() and transport_kunmap_data_sg() does vunmap(), so the kernel virtual
> address backing iport_ptr is torn down and every subsequent dereference is
> a use-after-free read of the unmapped region.
> 
> Keep the parameter list mapped until iport_ptr is no longer needed: drop
> the early transport_kunmap_data_sg() and unmap once on the success path,
> right before returning. The error paths already unmap through the existing
> "if (buf) transport_kunmap_data_sg(cmd)" at the out: label, which now runs
> on every post-map error exit because buf is no longer cleared early. Only
> reads of the mapping happen while spinlocks are held; the map and unmap
> calls remain outside any lock. The sibling caller
> core_scsi3_decode_spec_i_port() already uses the buffer before unmapping it
> and is left unchanged.
> 
> Fixes: 4949314c7283 ("target: Allow control CDBs with data > 1 page")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
> v3 (review of v2 by John Garry and James Bottomley):
>   - Drop the parser-ownership approach. Rather than copy the ISID into an
>     allocation that both callers must kfree() (v2), keep the PR-OUT
>     parameter list mapped across the iport_ptr dereferences and move the
>     single unmap to the success path. No allocation, no kfree, and
>     target_core_fabric_lib.c / core_scsi3_decode_spec_i_port() are
>     unchanged. This is the form John Garry asked for ("keep the mapping in
>     place for longer, until the out: label") and removes the multiple
>     kfree() paths v2 added.
>   - Re: holding the mapping while spinlocks are held (raised on v2): only
>     reads of the mapping occur under dev_reservation_lock; the kmap/kunmap
>     calls are all outside any lock, so there is no sleep-in-atomic concern.
> 
> v2: https://lore.kernel.org/linux-scsi/20260609005858.17504-1-hexlabsecurity@proton.me/
> v1: https://lore.kernel.org/linux-scsi/20260606015359.181724-1-hexlabsecurity@proton.me/
> 
> Class / impact: CWE-416 use-after-free (use-after-vunmap) in the LIO SCSI
> target, reachable by an authenticated iSCSI initiator that is a current
> Persistent Reservation registrant on the LUN. It sends PERSISTENT RESERVE
> OUT / REGISTER AND MOVE with an iSCSI (FORMAT CODE 01b) TransportID and a
> PARAMETER LIST LENGTH > 4096 so the parameter list spans >1 page and is
> mapped with vmap(). After transport_kunmap_data_sg() vunmap()s that region,
> the retained iport_ptr is dereferenced -> kernel read of an unmapped
> vmalloc address (oops / DoS). Primarily a remotely reachable authenticated
> denial of service. Present in all maintained trees since 4949314c7283
> (v3.3, 2012), which introduced the multi-page vmap() path. Verified at
> mainline v7.1-rc6 and stable v6.12.92.
> 
> Reproducer (authenticated iSCSI initiator, current PR reservation holder):
>   1. PERSISTENT RESERVE OUT / REGISTER a key from the iSCSI nexus.
>   2. PERSISTENT RESERVE OUT / REGISTER AND MOVE, FORMAT CODE 01b TransportID
>      (IQN + ",i,0x" + 12-char ISID), RELATIVE TARGET PORT IDENTIFIER of an
>      existing target port, with PARAMETER LIST LENGTH = 8192 (two pages ->
>      vmap()/vunmap()), the inner ADDITIONAL LENGTH set so tid_len + 24 ==
>      data_length, the remainder zero padding.
> 
> A/B verification (CONFIG_KASAN_VMALLOC=y, kasan.fault=report, x86-64,
> 6.12.90; same kernel for every arm; 64-bit and 32-bit initiator):
>   - Without this patch (8192-byte, two-page request):
>       BUG: KASAN: vmalloc-out-of-bounds in strcmp+0xa7/0xb0
>         strcmp
>         core_scsi3_emulate_pro_register_and_move [target_core]
>         ? remove_vm_area
>         target_scsi3_emulate_pr_out [target_core]
>         __target_execute_cmd / iscsit_execute_cmd / iscsi_target_rx_thread
>       followed by "unable to handle page fault" (PTE 0); the command never
>       completes (the iSCSI rx kthread dies).
>   - Control (128-byte, single-page request): no report (kunmap is a no-op
>     on 64-bit !HIGHMEM, no vunmap).
>   - With this patch (same 8192-byte request, 64-bit and 32-bit initiator):
>     no report, the command completes.
> 
>  drivers/target/target_core_pr.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 11790f2c5d80..7c5bb7d67947 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -3293,9 +3293,6 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
>  		goto out;
>  	}
>  
> -	transport_kunmap_data_sg(cmd);
> -	buf = NULL;
> -
>  	pr_debug("SPC-3 PR [%s] Extracted initiator %s identifier: %s"
>  		" %s\n", dest_tf_ops->fabric_name, (iport_ptr != NULL) ?
>  		"port" : "device", initiator_str, (iport_ptr != NULL) ?
> @@ -3532,6 +3529,11 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
>  	core_scsi3_update_and_write_aptpl(cmd->se_dev, aptpl);
>  
>  	core_scsi3_put_pr_reg(dest_pr_reg);
> +	/*
> +	 * iport_ptr aliases the PR-OUT parameter list mapped above, so the
> +	 * buffer is unmapped only here on success (and at out: on error).
> +	 */
> +	transport_kunmap_data_sg(cmd);
>  	return 0;
>  out:
>  	if (buf)

Looks good.
Reviewed-by: David Disseldorp <ddiss@suse.de>
