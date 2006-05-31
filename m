From: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.17-rc5-mm1
Date: Wed, 31 May 2006 12:56:09 +0200
Message-ID: <20060531105609.GA608@elte.hu>
References: <20060530022925.8a67b613.akpm@osdl.org> <6bffcb0e0605301155h3b472d79h65e8403e7fa0b214@mail.gmail.com> <6bffcb0e0605301157o6b7c5f66q3c9f151cbb4537d5@mail.gmail.com> <20060530194259.GB22742@elte.hu> <6bffcb0e0605301457v9ba284bk75b8b6d14384489a@mail.gmail.com> <20060530220931.GA32759@elte.hu> <20060530221850.GA1764@elte.hu> <20060530222608.GA3274@elte.hu> <20060530222954.GA3746@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964947AbWEaKzv@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060530222954.GA3746@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> CONFIG_PROFILE_LIKELY it is, please disable it in your config, along 
> with CONFIG_DEBUG_STACKOVERFLOW:

the tracer fix for PROFILE_LIKELY is below. I have also uploaded an 
updated tracing patch to

  http://redhat.com/~mingo/lockdep-patches/latency-tracing-lockdep.patch

which allows the enabling of PROFILE_LIKELY && LATENCY_TRACING again. 
There's an updated combo patch too:

  http://redhat.com/~mingo/lockdep-patches/lockdep-combo-2.6.17-rc5-mm1.patch

for easy pickup of all current fixes against mm1 baseline.

	Ingo

Index: linux/lib/likely_prof.c
===================================================================
--- linux.orig/lib/likely_prof.c
+++ linux/lib/likely_prof.c
@@ -20,7 +20,7 @@
 
 static struct likeliness *likeliness_head;
 
-int do_check_likely(struct likeliness *likeliness, int ret)
+int notrace do_check_likely(struct likeliness *likeliness, int ret)
 {
 	static unsigned long likely_lock;
 
