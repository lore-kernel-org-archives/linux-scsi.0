Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28613B8412
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 20:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785442329; cv=none; b=GVnf/XQ5KEF+UIuIBROGYdksUcDqrRKTsxUpdcO/Kfi/m6Jlt25csRTcMc2/pjwgiHiK6EbLE8j5kv2qg0toyzJIWyVupUs7joL5fwz/ZuVgGDY/kxjOW1/pet6RE8eNiF+fQh7DXHsfWSXewgKJODEBXxDs1fTUDOlKHrLrxRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785442329; c=relaxed/simple;
	bh=bN7USBlMfv3aFQzl/pi64PzWEWk+L9ZaYyy77nq1O5c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z3+t7bPiy7KQxKzltOG8jMBJaVAX2rhPXbUPqTJVltiAfq6B+b2a8PKJs/HiVPRmBuEQDhmiPwlxNx3jV46Z1lCyzj7qzRet38i4LsBpyFeyP95+cfFwabFllR5zEyA4R/XnfXXAIYZebti4aYQL1DD/OOZTpsWYDnusfl19SuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ceqraE5n; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ceqraE5n"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84e0688b7e8so308809b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 13:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785442308; x=1786047108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f9pbgJaIBVQa9SMJLF2f8Rk9ickMvrG5SjhPB4DzBUE=;
        b=ceqraE5n2CKnG5arxHFwMtAWNZ812eiN76CYOoTCEC5/CayDPE5Xzt2PU8ZbpMdJp8
         y6NxPl74wHiXvfxyEi3rJAt2j13dw9ElkqQBJ0r0fYaRa9UwsE7Xm8QoT9poxzl60xGF
         PQ93FKgu50dh2b56K3EDUpulg6u9cx+5q6eDKY5zMsMRDiSHOCLWzHoAaFQ2Vyfv5JP9
         8AsMlwhVjCtoezsodMUJRTtIpi+kMTJDwq4jGShitd7OHYu5ZGzU5itdiBlQqlJ04WBS
         wjjc3MVzppMjD9Pl1TD6NlyfFjVmuE8wcFdqPmx1/6aIc9VwACeagIOag0Unwucvo/WO
         nsCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785442308; x=1786047108;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f9pbgJaIBVQa9SMJLF2f8Rk9ickMvrG5SjhPB4DzBUE=;
        b=ZtsyG030LVieMHRyROt8rfeAGBNQlb9e0k1kEdE+Epnvbog5yh4YPI//sT6lsdSwB1
         MUlZv4DLmYU8Z9M/J9ppBdfN3NWAx7JAMj4V7dPzN3z0YOf6wb4P79PK8sBrPiKBikpc
         eZeQDkyIfT1potaZO2v8jV91ifmbgYbHGqh0RBFCexFPt3nI1CN5+goecWMlRDSdaIUW
         J+K8yLe931+ak8EWp/y4Cd8Y3QpjJpnQXRGykFQypn+uUYcE3WRPtzFJFgCof9rVZ5bI
         xQYbW20IOH5aOuohN0Rlz+7nQjyPmHdxEd8MBRPEVho+UlYwfH7JP/4VGChzXGmAjNCf
         hkbA==
X-Forwarded-Encrypted: i=1; AHgh+RqMBFqiaBvbwGjo5qgOZgUbWIDXG19cKtMV/Ww1YLUdgnKdcyDvhmf4KvqFFTkBU51vNcj/HS46Lb3e@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6xDNIJ+Ma5RGmVvqanzyyUK782ch7bHtqY7/dZCPsnZIEhzfD
	GQCr/XzNjU2ACgwrmYZfCTdAhYL78/Tef5vcCb7R35NSaZgWGRHusOJN
X-Gm-Gg: AR+sD11tlPTIqemGTRnP9RMQz8nmJ3x4RNv7FGHB61buzbha3G/BTyJ0e26Y+ydawyh
	lomdY3+1NyL6Pzsx5lmQXG2jvzaytMVDOZP9x+QeJkCAX1nYC1F2mcTrTBsJfRkVLQ+PxjAnxE7
	H45+mp5k9Y87s1uvlLhTCoJ5UZCreHQ4RXqeQsp3WORUinzEiNT7VVPliP8C/wJNBYZBaoHi1hw
	n/DkRUoACEtTgeF6Pq7G7cCrCO9ql7tMStopWqgFePuJa9XDcFBzXepBqAjRXztPCmWwPlfPc96
	VD7bsSl8c4AOfIAM7Jt7FeUCc21djv2iRreBoFXSRqxsXkJB80KfUugcWL1EFTDuJhW+QbV/Rqx
	plf4ViZOm1e029WkH/T5HRJiPjI4Qf461ypb2xxHQM/7FQJ7xfyVWQJZrPnVEiQbsw/nbM2CHLd
	AFaR+dCXRrjlNkybvkdaswGZ82cm79awxDy7VydZncGptPN5C32tRa9DcT6OGMyXtbkLXcaVTwf
	IIgPOXru1UGbENG/zEaT4i5eB6+Vb9xcQ71JWMk8t+TJZnmOauCTeE=
X-Received: by 2002:a05:6a00:92a0:b0:848:2f7a:2e5a with SMTP id d2e1a72fcca58-84ebc4572c2mr3351602b3a.73.1785442307771;
        Thu, 30 Jul 2026 13:11:47 -0700 (PDT)
Received: from localhost.localdomain (c-174-165-208-10.hsd1.wa.comcast.net. [174.165.208.10])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea0055325sm3689108b3a.15.2026.07.30.13.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 13:11:47 -0700 (PDT)
From: Michael Kelley <mhkelley58@gmail.com>
X-Google-Original-From: Michael Kelley <mhklinux@outlook.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	longli@microsoft.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	daniel.lezcano@kernel.org,
	ssengar@linux.microsoft.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	sgarzare@redhat.com,
	horms@kernel.org
Cc: x86@kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [RESEND PATCH 6/6] clocksource: hyper-v: Remove support for stimer interrupts in message mode
Date: Thu, 30 Jul 2026 13:11:23 -0700
Message-Id: <20260730201123.1767-7-mhklinux@outlook.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730201123.1767-1-mhklinux@outlook.com>
References: <20260730201123.1767-1-mhklinux@outlook.com>
Reply-To: mhklinux@outlook.com
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In Hyper-V versions prior to WS2016/Win10, Hyper-V synthetic timers
interrupt the guest by delivering a message that is initially handled
by the Linux VMBus driver. Starting with WS2016/Win10, Hyper-V can
deliver stimer interrupts directly to an assigned interrupt vector
without involving the VMBus driver. This is called "Direct Mode".

With the overall removal of Linux support for running on Hyper-V
hosts earlier than WS2016 and Windows 10, it's no longer necessary
to support the legacy message-based delivery. Remove that delivery
mechanism and always use Direct Mode. If for some reason, the
Hyper-V host does not enumerate Direct Mode, output an error
message but continue to run using the LAPIC timer instead of an
stimer.

With these changes, the VMBus driver no longer calls the stimer
interrupt service routine. This removal has a broader benefit in
unblocking the disentangling of VMBus code and stimer code, as
they should be independent of each other. The final disentangling
will come as a follow-on patch set.

Signed-off-by: Michael Kelley <mhklinux@outlook.com>
---
 arch/x86/hyperv/hv_init.c          |  17 ++--
 arch/x86/kernel/cpu/mshyperv.c     |   4 +-
 drivers/clocksource/hyperv_timer.c | 150 ++++-------------------------
 drivers/hv/hv.c                    |   4 -
 drivers/hv/vmbus_drv.c             |  10 +-
 include/clocksource/hyperv_timer.h |   6 --
 6 files changed, 32 insertions(+), 159 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 55a8b6de2865..0b4a1c0b0b16 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -171,8 +171,7 @@ static int hv_cpu_init(unsigned int cpu)
 	}
 
 	/* Allow Hyper-V stimer vector to be injected from Hypervisor. */
-	if (ms_hyperv.misc_features & HV_STIMER_DIRECT_MODE_AVAILABLE)
-		apic_update_vector(cpu, HYPERV_STIMER0_VECTOR, true);
+	apic_update_vector(cpu, HYPERV_STIMER0_VECTOR, true);
 
 	return hyperv_init_ghcb();
 }
@@ -281,8 +280,7 @@ static int hv_cpu_die(unsigned int cpu)
 		*ghcb_va = NULL;
 	}
 
-	if (ms_hyperv.misc_features & HV_STIMER_DIRECT_MODE_AVAILABLE)
-		apic_update_vector(cpu, HYPERV_STIMER0_VECTOR, false);
+	apic_update_vector(cpu, HYPERV_STIMER0_VECTOR, false);
 
 	hv_common_cpu_die(cpu);
 
@@ -425,15 +423,18 @@ static void (* __initdata old_setup_percpu_clockev)(void);
 
 static void __init hv_stimer_setup_percpu_clockev(void)
 {
+	int ret;
+
 	/*
-	 * Ignore any errors in setting up stimer clockevents
+	 * Continue afters errors in setting up stimer clockevents
 	 * as we can run with the LAPIC timer as a fallback.
 	 */
-	(void)hv_stimer_alloc(false);
+	ret = hv_stimer_alloc(false);
+	if (ret)
+		pr_warn("stimer setup failed with error %d\n", ret);
 
 	/*
-	 * Still register the LAPIC timer, because the direct-mode STIMER is
-	 * not supported by old versions of Hyper-V. This also allows users
+	 * Still register the LAPIC timer to allows users
 	 * to switch to LAPIC timer via /sys, if they want to.
 	 */
 	if (old_setup_percpu_clockev)
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 185d4f677ec0..f62319b73c20 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -716,9 +716,7 @@ static void __init ms_hyperv_init_platform(void)
 	}
 
 	/* Install system interrupt handler for stimer0 */
-	if (ms_hyperv.misc_features & HV_STIMER_DIRECT_MODE_AVAILABLE) {
-		sysvec_install(HYPERV_STIMER0_VECTOR, sysvec_hyperv_stimer0);
-	}
+	sysvec_install(HYPERV_STIMER0_VECTOR, sysvec_hyperv_stimer0);
 
 # ifdef CONFIG_SMP
 	smp_ops.smp_prepare_boot_cpu = hv_smp_prepare_boot_cpu;
diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
index df567795d175..dddfff458ebf 100644
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -31,44 +31,20 @@ static struct clock_event_device __percpu *hv_clock_event;
 /* Note: offset can hold negative values after hibernation. */
 static u64 hv_sched_clock_offset __read_mostly;
 
-/*
- * If false, we're using the old mechanism for stimer0 interrupts
- * where it sends a VMbus message when it expires. The old
- * mechanism is used when running on older versions of Hyper-V
- * that don't support Direct Mode. While Hyper-V provides
- * four stimer's per CPU, Linux uses only stimer0.
- *
- * Because Direct Mode does not require processing a VMbus
- * message, stimer interrupts can be enabled earlier in the
- * process of booting a CPU, and consistent with when timer
- * interrupts are enabled for other clocksource drivers.
- * However, for legacy versions of Hyper-V when Direct Mode
- * is not enabled, setting up stimer interrupts must be
- * delayed until VMbus is initialized and can process the
- * interrupt message.
- */
-static bool direct_mode_enabled;
-
 static int stimer0_irq = -1;
-static int stimer0_message_sint;
 static __maybe_unused DEFINE_PER_CPU(long, stimer0_evt);
 
-/*
- * Common code for stimer0 interrupts coming via Direct Mode or
- * as a VMbus message.
- */
-void hv_stimer0_isr(void)
+static void hv_stimer0_isr(void)
 {
 	struct clock_event_device *ce;
 
 	ce = this_cpu_ptr(hv_clock_event);
 	ce->event_handler(ce);
 }
-EXPORT_SYMBOL_GPL(hv_stimer0_isr);
 
 /*
  * stimer0 interrupt handler for architectures that support
- * per-cpu interrupts, which also implies Direct Mode.
+ * per-cpu interrupts
  */
 static irqreturn_t __maybe_unused hv_stimer0_percpu_isr(int irq, void *dev_id)
 {
@@ -91,7 +67,7 @@ static int hv_ce_shutdown(struct clock_event_device *evt)
 {
 	hv_set_msr(HV_MSR_STIMER0_COUNT, 0);
 	hv_set_msr(HV_MSR_STIMER0_CONFIG, 0);
-	if (direct_mode_enabled && stimer0_irq >= 0)
+	if (stimer0_irq >= 0)
 		disable_percpu_irq(stimer0_irq);
 
 	return 0;
@@ -104,23 +80,16 @@ static int hv_ce_set_oneshot(struct clock_event_device *evt)
 	timer_cfg.as_uint64 = 0;
 	timer_cfg.enable = 1;
 	timer_cfg.auto_enable = 1;
-	if (direct_mode_enabled) {
-		/*
-		 * When it expires, the timer will directly interrupt
-		 * on the specified hardware vector/IRQ.
-		 */
-		timer_cfg.direct_mode = 1;
-		timer_cfg.apic_vector = HYPERV_STIMER0_VECTOR;
-		if (stimer0_irq >= 0)
-			enable_percpu_irq(stimer0_irq, IRQ_TYPE_NONE);
-	} else {
-		/*
-		 * When it expires, the timer will generate a VMbus message,
-		 * to be handled by the normal VMbus interrupt handler.
-		 */
-		timer_cfg.direct_mode = 0;
-		timer_cfg.sintx = stimer0_message_sint;
-	}
+
+	/*
+	 * When it expires, the timer will directly interrupt
+	 * on the specified hardware vector/IRQ.
+	 */
+	timer_cfg.direct_mode = 1;
+	timer_cfg.apic_vector = HYPERV_STIMER0_VECTOR;
+	if (stimer0_irq >= 0)
+		enable_percpu_irq(stimer0_irq, IRQ_TYPE_NONE);
+
 	hv_set_msr(HV_MSR_STIMER0_CONFIG, timer_cfg.as_uint64);
 	return 0;
 }
@@ -175,25 +144,8 @@ int hv_stimer_cleanup(unsigned int cpu)
 	if (!hv_clock_event)
 		return 0;
 
-	/*
-	 * In the legacy case where Direct Mode is not enabled
-	 * (which can only be on x86/64), stimer cleanup happens
-	 * relatively early in the CPU offlining process. We
-	 * must unbind the stimer-based clockevent device so
-	 * that the LAPIC timer can take over until clockevents
-	 * are no longer needed in the offlining process. Note
-	 * that clockevents_unbind_device() eventually calls
-	 * hv_ce_shutdown().
-	 *
-	 * The unbind should not be done when Direct Mode is
-	 * enabled because we may be on an architecture where
-	 * there are no other clockevent devices to fallback to.
-	 */
 	ce = per_cpu_ptr(hv_clock_event, cpu);
-	if (direct_mode_enabled)
-		hv_ce_shutdown(ce);
-	else
-		clockevents_unbind_device(ce, cpu);
+	hv_ce_shutdown(ce);
 
 	return 0;
 }
@@ -268,23 +220,14 @@ int hv_stimer_alloc(bool have_percpu_irqs)
 	 * Hyper-V on x86.  In that case, return as error as Linux will use a
 	 * clockevent based on emulated LAPIC timer hardware.
 	 */
-	if (!(ms_hyperv.features & HV_MSR_SYNTIMER_AVAILABLE))
+	if (!(ms_hyperv.features & HV_MSR_SYNTIMER_AVAILABLE) ||
+	    !(ms_hyperv.misc_features & HV_STIMER_DIRECT_MODE_AVAILABLE))
 		return -EINVAL;
 
 	hv_clock_event = alloc_percpu(struct clock_event_device);
 	if (!hv_clock_event)
 		return -ENOMEM;
 
-	direct_mode_enabled = ms_hyperv.misc_features &
-			HV_STIMER_DIRECT_MODE_AVAILABLE;
-
-	/*
-	 * If Direct Mode isn't enabled, the remainder of the initialization
-	 * is done later by hv_stimer_legacy_init()
-	 */
-	if (!direct_mode_enabled)
-		return 0;
-
 	if (have_percpu_irqs) {
 		ret = hv_setup_stimer0_irq();
 		if (ret)
@@ -293,11 +236,6 @@ int hv_stimer_alloc(bool have_percpu_irqs)
 		hv_setup_stimer0_handler(hv_stimer0_isr);
 	}
 
-	/*
-	 * Since we are in Direct Mode, stimer initialization
-	 * can be done now with a CPUHP value in the same range
-	 * as other clockevent devices.
-	 */
 	ret = cpuhp_setup_state(CPUHP_AP_HYPERV_TIMER_STARTING,
 			"clockevents/hyperv/stimer:starting",
 			hv_stimer_init, hv_stimer_cleanup);
@@ -314,67 +252,19 @@ int hv_stimer_alloc(bool have_percpu_irqs)
 }
 EXPORT_SYMBOL_GPL(hv_stimer_alloc);
 
-/*
- * hv_stimer_legacy_init -- Called from the VMbus driver to handle
- * the case when Direct Mode is not enabled, and the stimer
- * must be initialized late in the CPU onlining process.
- *
- */
-void hv_stimer_legacy_init(unsigned int cpu, int sint)
-{
-	if (direct_mode_enabled)
-		return;
-
-	/*
-	 * This function gets called by each vCPU, so setting the
-	 * global stimer_message_sint value each time is conceptually
-	 * not ideal, but the value passed in is always the same and
-	 * it avoids introducing yet another interface into this
-	 * clocksource driver just to set the sint in the legacy case.
-	 */
-	stimer0_message_sint = sint;
-	(void)hv_stimer_init(cpu);
-}
-EXPORT_SYMBOL_GPL(hv_stimer_legacy_init);
-
-/*
- * hv_stimer_legacy_cleanup -- Called from the VMbus driver to
- * handle the case when Direct Mode is not enabled, and the
- * stimer must be cleaned up early in the CPU offlining
- * process.
- */
-void hv_stimer_legacy_cleanup(unsigned int cpu)
-{
-	if (direct_mode_enabled)
-		return;
-	(void)hv_stimer_cleanup(cpu);
-}
-EXPORT_SYMBOL_GPL(hv_stimer_legacy_cleanup);
-
 /*
  * Do a global cleanup of clockevents for the cases of kexec and
  * vmbus exit
  */
 void hv_stimer_global_cleanup(void)
 {
-	int	cpu;
-
-	/*
-	 * hv_stime_legacy_cleanup() will stop the stimer if Direct
-	 * Mode is not enabled, and fallback to the LAPIC timer.
-	 */
-	for_each_present_cpu(cpu) {
-		hv_stimer_legacy_cleanup(cpu);
-	}
-
 	if (!hv_clock_event)
 		return;
 
-	if (direct_mode_enabled) {
-		cpuhp_remove_state(CPUHP_AP_HYPERV_TIMER_STARTING);
-		hv_remove_stimer0_irq();
-		stimer0_irq = -1;
-	}
+	cpuhp_remove_state(CPUHP_AP_HYPERV_TIMER_STARTING);
+	hv_remove_stimer0_irq();
+	stimer0_irq = -1;
+
 	free_percpu(hv_clock_event);
 	hv_clock_event = NULL;
 
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index ef4b1b03395d..fe50090dcc01 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -399,8 +399,6 @@ int hv_synic_init(unsigned int cpu)
 	else
 		hv_hyp_synic_enable_interrupts();
 
-	hv_stimer_legacy_init(cpu, VMBUS_MESSAGE_SINT);
-
 	return 0;
 }
 
@@ -630,8 +628,6 @@ int hv_synic_cleanup(unsigned int cpu)
 		return -EBUSY;
 
 always_cleanup:
-	hv_stimer_legacy_cleanup(cpu);
-
 	/*
 	 * First, disable the event and message pages
 	 * used for communicating with the host, and then
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 6824bd7cb3c4..e19ec73b0187 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1320,14 +1320,8 @@ static void vmbus_message_sched(struct hv_per_cpu_context *hv_cpu, void *message
 	msg = (struct hv_message *)message_page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Check if there are actual msgs to be processed */
-	if (msg->header.message_type != HVMSG_NONE) {
-		if (msg->header.message_type == HVMSG_TIMER_EXPIRED) {
-			hv_stimer0_isr();
-			vmbus_signal_eom(msg, HVMSG_TIMER_EXPIRED);
-		} else {
-			tasklet_schedule(&hv_cpu->msg_dpc);
-		}
-	}
+	if (msg->header.message_type != HVMSG_NONE)
+		tasklet_schedule(&hv_cpu->msg_dpc);
 }
 
 static void __vmbus_isr(void)
diff --git a/include/clocksource/hyperv_timer.h b/include/clocksource/hyperv_timer.h
index d48dd4176fd3..8d3befb7e667 100644
--- a/include/clocksource/hyperv_timer.h
+++ b/include/clocksource/hyperv_timer.h
@@ -27,10 +27,7 @@
 /* Routines called by the VMbus driver */
 extern int hv_stimer_alloc(bool have_percpu_irqs);
 extern int hv_stimer_cleanup(unsigned int cpu);
-extern void hv_stimer_legacy_init(unsigned int cpu, int sint);
-extern void hv_stimer_legacy_cleanup(unsigned int cpu);
 extern void hv_stimer_global_cleanup(void);
-extern void hv_stimer0_isr(void);
 
 extern void hv_init_clocksource(void);
 extern void hv_remap_tsc_clocksource(void);
@@ -107,10 +104,7 @@ hv_read_tsc_page_tsc(const struct ms_hyperv_tsc_page *tsc_pg, u64 *cur_tsc, u64
 }
 
 static inline int hv_stimer_cleanup(unsigned int cpu) { return 0; }
-static inline void hv_stimer_legacy_init(unsigned int cpu, int sint) {}
-static inline void hv_stimer_legacy_cleanup(unsigned int cpu) {}
 static inline void hv_stimer_global_cleanup(void) {}
-static inline void hv_stimer0_isr(void) {}
 
 #endif /* CONFIG_HYPERV_TIMER */
 
-- 
2.25.1

