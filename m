Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795660546;
	b=qnrgOIroDI10jdq6ScstNzCKgSB80NDVafIoxbJuYQXnMijW8qcr3CyJ4KKHhXxZb92H
	 TfQ307rh9po+D4DxWmiJlSlWnWf1APA3Ig1CXl92IeKdmgY91AREXsA8Zq3qp5gB6i8OQ
	 qjGHSAdWSDl/G/b3s8WcrcJ65rUDLYlRmcgbb/FJibc1bT82oQfphHKitvUstInI9t/MT
	 /n51BjUXUlIMwAIBXO+v9kdWDSGla/LBMQEVLFAq2sKir9yUeFqqIzjuBjB5cJNK/oDx1
	 8qVePt1stuKz+htpqtZa2LI0iwbUgJx+uPaN7syqjeMO3/hZ8OuXcZu4ivA2AePUK1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795660546;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=vnbaaCeQ4iuOjN0aXPIZIsjFxXeCrpxuuDRTSWpiltI=;
	b=PaV/Cu2QExl0PGYQ6uH/SIGb7njYFekL6kVsfo8vsjdTrII7izw2CD7AHtv/+knzqIl4
	 xoAAxLyfMNb5OkRGd7wmB4lmDbuE0kgUYOfzxu5kTfeQjPIBgwT2uFwCckgXfmIoGJajW
	 oxY8RezPc/qEdiSY8WsHrqSOmWkL/4+6NSoMFXcl8jXqsd7bNBuAUc1z6+/BB+qU3t5Er
	 JLY9wqu2TnogIu5dfjyOEfh+VLE5txTWsNxc3zqvSEOMXSaKjgZfDaXMhnSKQu6ThjpIG
	 UsCzOztMNi+BrglKgd+2yO+6d+K14Hw56/oosJd7Ng0sQhYgMVrIRCAbD9PdCXIQyjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--zhenwenliang.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SO9NkoSY;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9FA606A33E
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 02:35:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB9FA606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--zhenwenliang.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SO9NkoSY
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-57289376805so6107674b6e.1
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 18:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795660545; x=1796265345; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vnbaaCeQ4iuOjN0aXPIZIsjFxXeCrpxuuDRTSWpiltI=;
        b=SO9NkoSY76TdZ8L3QNZVqY4TxvBBzlHkUTD++MRIuj14TuIFlBRTuodK7IlCJ1yXNj
         SJ0WES7uC9bJ6u0/sWhk1cIcLJU0zrxB1Qyz83kNZvOquDVVv7BltOY9WxMitCFGtGNi
         ZeQMJ6iMNBKIne1loL8ZFTkQCENtrtdpp3ax+6xfurZH8VGTuFuPR+gFWH5jHx3cc279
         KWzYKy5fctG+/jeUlh0/c2tDP2mQzfTqwZtS+L/fe5NT9pC1XRgH2tqv8KphLjlr2YgO
         XfTUZsx7UGdBWaFuihu1s6gIQSi4S9eBZukI0yYVa242hohC+ybkBYpVlu8BJI0isA7f
         egcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795660545; x=1796265345;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vnbaaCeQ4iuOjN0aXPIZIsjFxXeCrpxuuDRTSWpiltI=;
        b=X3hbcT99X5geB/mJGAUF5+Ee5K7pWnzqUtg3Sv3GFcN1Nsr9lT+RC95K8pxrVyyn0w
         8GdFO8A5phmyf5ZKdlmgrMucxsHzP/gQeETyW3NRyT6S5z5JJhzCHODWPz0OY4a2GnEH
         faILH2nN7aDRnRi2LSvkSn8wwxDUE+BsJIDGatty5aNleGYK1pqB5pM+f7x0HnQp95wX
         ctin8Rv+cPuWaJUSFsOKbMmiO7/i9fhFM0CZII85Z7emFgoPoNae6jeg6ZuO1uwGuOAo
         Zb0uEnC3sfrFwO2mQLmh8oDvRkwV5NDz+EpFXA0L9/3c+HSnCB5iK7C+1dy+U4lknhKq
         /TqA==
X-Gm-Message-State: APuU4Z+1UrVYl0en8ETdfAKt+v1/wBJpkML+egIdhv+BD5oQl1q5MCnT
	is/R+JGNyfoH3uxMN6BsiGWV3xrJ/HBL80s0W2Vwfhk8eYub16II4AbypXwbj7B7NAbfqEOlUu0
	oVk6cpRfpbJv1uLYENFxpw3kVwEFgXQ==
X-Received: from ilef17-n2.prod.google.com ([2002:a05:6e02:6191:20b0:54e:a7dd:848b])
 (user=zhenwenliang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4f29:b0:579:8a9e:1149 with SMTP id 5614622812f47-57a0ba4fbdemr23205010b6e.35.1795660544666;
 Wed, 25 Nov 2026 18:35:44 -0800 (PST)
Date: Thu, 26 Nov 2026 02:35:43 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261126023543.4162289-1-zhenwenliang@google.com>
Subject: scsi: target: core_free_device_list_for_node() walks an RCU hlist it
 is freeing without rcu_read_lock()
From: Zhenwen Liang <zhenwenliang@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

core_free_device_list_for_node()
(drivers/target/target_core_device.c:233-243, mainline ebb7a8dc1e74) is:

    mutex_lock(&nacl->lun_entry_mutex);
    hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link)
            core_disable_device_list_for_node(deve->se_lun, deve,
                                              nacl, tpg);
    mutex_unlock(&nacl->lun_entry_mutex);

The loop body unlinks the current entry with hlist_del_rcu(&orig->link)
and queues its free with call_rcu(&orig->rcu_head,
target_free_dev_entry) (core_disable_device_list_for_node(), :467 and
:479). The iterator then reads deve->link.next of that entry to advance.
lun_entry_mutex serialises the writers but does not hold off the RCU
callback, and there is no rcu_read_lock() around the walk. On a
preemptible-RCU kernel, if the walker is preempted after call_rcu() for
a full grace period, target_free_dev_entry() frees the entry and the
next iterator step reads freed memory.

Since the walk holds the writer-side mutex, hlist_for_each_entry_safe()
(or an rcu_read_lock() around the loop) looks like the natural fix.

Reachability: core_free_device_list_for_node() runs when a node ACL is
removed (configfs rmdir, core_tpg_del_initiator_node_acl()) and on TPG
deregistration; with demo-mode dynamic ACLs (generate_node_acls=1, no
ACL caching) it can also follow an initiator's session teardown. It
needs CONFIG_PREEMPT_RCU and a preemption lasting a grace period inside
the window, so it is narrow. Impact: a use-after-free read of
se_dev_entry (KASAN would report it); with slab reuse, a wild pointer
for the next iteration.

Affected: the loop is unchanged in mainline ebb7a8dc1e74 and
next-20261125. This is not the problem fixed by 6a6e7d7230cd ("Fix
demo-mode dynamic ACL dev-entry UAF vs LUN teardown").

Found by a formal analysis tool we are developing that uses AI
assistance; I have reviewed the analysis and this report. The tool runs
verbatim copies of the kernel functions with stubs for the rest of the
kernel; it found the interleaving above, and the interleaving was
replayed natively on that harness under the tool's schedule. Functions
involved: core_free_device_list_for_node(),
core_disable_device_list_for_node(), target_free_dev_entry(), with an
RCU callback model. It has not been reproduced on a booted kernel.

Thanks,
Zhenwen Liang
