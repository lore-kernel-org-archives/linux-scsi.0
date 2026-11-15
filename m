Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794714182;
	b=PSQ3RxNrGgZsNciy23t7/3yG+cetxHuQRlAbOsPV/yyHXePAv2jvSiZbBZziKAYFvpaW
	 VeoHZgOzmWZ+FAFVKJMpXg9QxPQfpop+ZVJIAJQGchNUaPFzmpKGILAJfyCWsMLZasvoH
	 Y0HukIJKc8SlxB7NlBwc6DZuzY/d6mlaGc7DcSB1e86cLccsWO6PB5ZaM3SGyUHRBPuFH
	 RSsTZrOvhuXrHBIVK54/ShLh1xdniadtEdxbvi+3ARl/PJwkgUh7EGTfhLmhkGvcUIMRQ
	 P7vUfWK3QrQTG3E4okuMIenfmMuzNF8ECLrpGANf7MYjlBe6PJMD9PAKpLsY4GDJkqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794714182;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DNvG8od8l8ucgv2ueXv6nmuD7jHJoI/YW09hza4lVv8=;
	b=vaLlXNH8NJWmoo+Q/TG0JFQQGJuLR7pwERH8YEWwjJ+ddthsfwKZCO/oOp/H6Q6RHmi4
	 M/djasm2c7/8Fq1NNBoFB6oto2/yjBjyjzx/O7JCuZuQ+G3NZ5phrXXsTL3UJ/+IRX5SM
	 zXA+ylHsDqXdHFeqbKAuhYxY5Uj4VaJ8k8zIcoFPw5ysDXL63tlU6djMRehBsqEj3UK6X
	 CIIqp7Z7C6rTbd/4BSW7pHAYThrMuPg2x7I3k+jRfStsFpOqn7eRtbxkbGpjfrgZAnaJB
	 HP2azcbh72RrPsLet1LNYxQwz+nOB0R3RnXuoVivusw/6q3EXjPU8tLJCTkFsHY/UzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hhmbK3MM;
	arc=none smtp.remote-ip=95.215.58.35
Received: from mta1.migadu.com (out-35.mta1.migadu.com [95.215.58.35])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E1C606A32C
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 03:43:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1E1C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hhmbK3MM
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=K4N/rA5AgSqR8cp+YKlw6pPokjoUqfiwVnOeTRgQuKw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794714178; v=1; x=1795318978;
 b=hhmbK3MMEu+uNNvYXMI46TtUbL626IDtJu5t6Q+/wc6Epkyl21uObDReLVCJidXKFYaUIAvl
 uO9i56LXpK1+I0slOa99ACA/b1iuegT0b7rBeKu13p7IobuzjQdgb9kSbUlC+2NYeRSv+Rd5/t5
 jgwjkVhOBoQjpYpkOW1qMMOc=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id eabace465f84d12f;
	Sun, 15 Nov 2026 03:42:58 +0000
X-Mizu-Trace-ID: eabace465f84d12f
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
To: sashiko-bot@kernel.org
Cc: Qiliang Yuan <qiliang.yuan@linux.dev>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	"Martin K. Petersen" <mkp@kernel.org>,
	Mike Christie <michael.christie@oracle.com>,
	Yu Zhang <yuz08559@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: alua: Free target port groups with kfree_rcu()
Date: Sat, 14 Nov 2026 22:42:52 -0500
Message-ID: <20261115034252.1124649-1-qiliang.yuan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-209114@kernel.org>
References: <20261111-bug-target-alua-free-gp-v1-1-d1e692ae8694@linux.dev> <sashiko-outbox-209114@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

+Cc Martin, Mike and the patch's other recipients, and Yu Zhang, whose
patch fixes this.

On Wed, Nov 11, 2026 at 01:58:54PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Medium] scsi: target: race condition in core_alua_free_tg_pt_gp() [1]
> --
>
> commit cbab3de9aa10ecf910c633ef186a6a1775418e09
> Author: Qiliang Yuan <qiliang.yuan@linux.dev>
>
> scsi: target: alua: Free target port groups with kfree_rcu()
>
> This commit replaces synchronize_rcu() and kmem_cache_free() in
> core_alua_free_tg_pt_gp() with kfree_rcu() to avoid synchronous RCU waits
> when deleting target port groups and backstores.
>
> > diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> > index 140154d93c430..4ef243ae843bb 100644
> > --- a/drivers/target/target_core_alua.c
> > +++ b/drivers/target/target_core_alua.c
> > @@ -1771,8 +1771,7 @@ void core_alua_free_tg_pt_gp(
> >  	}
> >  	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
> >  
> > -	synchronize_rcu();
> > -	kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
> > +	kfree_rcu(tg_pt_gp, rcu_head);
> >  }
>
> [Severity: Medium]
> This problem wasn't introduced by this patch, but can the LUN detachment
> loop right above this race with target_detach_tg_pt_gp() [1] and
> leave a freed struct se_lun on default_tg_pt_gp->tg_pt_gp_lun_list?
>
> drivers/target/target_core_alua.c:core_alua_free_tg_pt_gp() {
>     ...
> 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
> 	list_for_each_entry_safe(lun, next,
> 			&tg_pt_gp->tg_pt_gp_lun_list, lun_tg_pt_gp_link) {
> 		list_del_init(&lun->lun_tg_pt_gp_link);
> 		tg_pt_gp->tg_pt_gp_members--;
>
> 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
> 		...
> 		spin_lock(&lun->lun_tg_pt_gp_lock);
> 		if (tg_pt_gp != dev->t10_alua.default_tg_pt_gp) {
> 			__target_attach_tg_pt_gp(lun,
> 					dev->t10_alua.default_tg_pt_gp);
> 		} else
> 			rcu_assign_pointer(lun->lun_tg_pt_gp, NULL);
> 		spin_unlock(&lun->lun_tg_pt_gp_lock);
>
> 		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
> 	}
> 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
> }
>
> When a non-default target port group is removed through configfs while a
> fabric LUN in that group is being unlinked, core_alua_free_tg_pt_gp()
> drops tg_pt_gp->tg_pt_gp_lock before taking lun->lun_tg_pt_gp_lock while
> lun->lun_tg_pt_gp still points to tg_pt_gp:
>
> CPU0                                   CPU1
> core_alua_free_tg_pt_gp(tg_pt_gp)      target_fabric_port_unlink()
>   spin_lock(&tg_pt_gp->tg_pt_gp_lock)    core_tpg_remove_lun(lun)
>   list_del_init(&lun->lun_tg_pt_gp_link)   target_detach_tg_pt_gp(lun)
>   tg_pt_gp->tg_pt_gp_members--
>   spin_unlock(&tg_pt_gp->tg_pt_gp_lock)
>                                              spin_lock(&lun->lun_tg_pt_gp_lock)
>                                              __target_detach_tg_pt_gp(...)
>                                              rcu_assign_pointer(
>                                                lun->lun_tg_pt_gp, NULL)
>                                              spin_unlock(&lun->lun_tg_pt_gp_lock)
>   spin_lock(&lun->lun_tg_pt_gp_lock)
>   __target_attach_tg_pt_gp(lun,
>     default_tg_pt_gp)
>   spin_unlock(&lun->lun_tg_pt_gp_lock)
>                                        target_fabric_port_release()
>                                          ...
>                                            kfree(lun)
>                                        target_emulate_report_target_port_groups()
>                                          /* walks default_tg_pt_gp list */
>                                          lun->...  <-- use-after-free
>
> Because core_alua_free_tg_pt_gp() does not recheck lun->lun_tg_pt_gp after
> acquiring lun->lun_tg_pt_gp_lock, it re-attaches the detaching LUN to
> default_tg_pt_gp after target_detach_tg_pt_gp() has already cleared it
> (and decremented tg_pt_gp->tg_pt_gp_members a second time).  When port
> teardown subsequently frees the LUN, a dangling entry remains on
> default_tg_pt_gp->tg_pt_gp_lun_list.
>
> [1] https://sashiko.dev/#/bug/linux-8e4ef2cb-206e-4a76-8c9e-458e67913f8b

The race is real, and it is already being fixed. Yu's patch [2] checks
lun->lun_tg_pt_gp again under lun_tg_pt_gp_lock before reattaching the
LUN, which covers target_detach_tg_pt_gp() as well as the concurrent
group change it was written for. This patch doesn't touch that loop.

[2] https://lore.kernel.org/r/20261019033532.73575-1-yuz08559@gmail.com

Thanks,
Qiliang
