Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68146C2BA2B
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3345964EE7
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447066AbhCCMrg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843060AbhCCKZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 05:25:09 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA81C0610CE;
        Wed,  3 Mar 2021 00:55:44 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id i9so4480787wml.0;
        Wed, 03 Mar 2021 00:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zdJ5hx+mYbfNreiVWKd99KRYazRIfUe4brAtRfe/xF4=;
        b=K+6wg9BUznm5a/+9b9QJ7i9CChtLVD4n5KpT38ZA7QuZ71i/zpE6c5PwKFC5vlJVh6
         DhhowwzJ76bXSS0tQp4FXcUh1skR513TO5ktNOi0c03sUdRBG73n1d5THMiMZDsmN339
         wRqGWi4Qi7zNv+UkUWrn5CskAi6Jl9sFYGf3Ygjt7vc9S4QLLZD+0NIPewtfRslu3qdJ
         j74C1vM98bGMvHT1RfoU5NMfcNVz/NNzY4vZ8Rr5r9IQ/Yo6sOLTs60QygBWVb19pc1S
         j7KcwVVdncAxdiPLaegbiS4FUQjOedYDq3IzUNFcUw7udfrRHkOQxBeJgtHp53hdwE4c
         xGxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zdJ5hx+mYbfNreiVWKd99KRYazRIfUe4brAtRfe/xF4=;
        b=HtumlKycCgRUz413V+rEfk7u1Nu0iW/jLB9dok6x4ET+cpihUOAVdzYggzQMUailXs
         3JW3Hwy6R0WJu3CCxJbUlGeqTju95Ej7VpCGvN/LntodZjqYNF78wnS7yoWy7ca3E/ge
         G2qzcImkwwKQRsWVvYRLnxkwvf0Mi8wdtOvQ1Uqi4j2rpVrqCM+iFfnTBjM26sYlwM8/
         LxHigQamagS1iBpw8PQYEZfqAR8JRLgQs621I+RSpefyKE/LffHn0TCVAHRj69DmwT2O
         LEPy4dXJesdBUmtw5ObalvP34mIPhGfXW7jQGQrWx1Sbl6OidbH7oNNgXXh8wC0Dlg2V
         0EbQ==
X-Gm-Message-State: AOAM533B3u0z1iL2p70QrPgGBRrqqkdb5pCwybEXAWcSESqJQySRkxwC
        jUf6GC/CVYHe7YHJgsXzUortyFWhiGXWlxSs
X-Google-Smtp-Source: ABdhPJzJvBnty9HzqVrRuMbMGPJYYS2k+vddEpLtCemcM5SBQTqtepuxSPjcO7s0q2vFbZGw/WguyA==
X-Received: by 2002:a1c:8041:: with SMTP id b62mr8441707wmd.0.1614761742701;
        Wed, 03 Mar 2021 00:55:42 -0800 (PST)
Received: from sf (tunnel547699-pt.tunnel.tserv1.lon2.ipv6.he.net. [2001:470:1f1c:3e6::2])
        by smtp.gmail.com with ESMTPSA id n6sm11688949wrt.1.2021.03.03.00.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 00:55:42 -0800 (PST)
Date:   Wed, 3 Mar 2021 08:55:33 +0000
From:   Sergei Trofimovich <slyich@gmail.com>
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Don Brace <don.brace@microchip.com>, storagedev@microchip.com,
        linux-scsi@vger.kernel.org
Cc:     linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Szczypek <jszczype@redhat.com>,
        Scott Benesh <scott.benesh@microchip.com>,
        Scott Teel <scott.teel@microchip.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [bisected] 5.12-rc1 hpsa regression: "scsi: hpsa: Correct dev
 cmds outstanding for retried cmds" breaks hpsa P600
Message-ID: <20210303085533.505b1590@sf>
In-Reply-To: <20210303002236.2f4ec01f@sf>
References: <20210222230519.73f3e239@sf>
        <cc658b61-530e-90bf-3858-36cc60468a24@kernel.dk>
        <8decdd2e-a380-9951-3ebb-2bc3e48aa1c3@physik.fu-berlin.de>
        <20210223083507.43b5a6dd@sf>
        <51cbf584-07ef-1e62-7a3b-81494a04faa6@physik.fu-berlin.de>
        <9441757f-d4bc-a5b5-5fb0-967c9aaca693@physik.fu-berlin.de>
        <20210223192743.0198d4a9@sf>
        <20210302222630.5056f243@sf>
        <25dfced0-88b2-b5b3-f1b6-8b8a9931bf90@physik.fu-berlin.de>
        <20210303002236.2f4ec01f@sf>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 3 Mar 2021 00:22:36 +0000
Sergei Trofimovich <slyich@gmail.com> wrote:

> On Tue, 2 Mar 2021 23:31:32 +0100
> John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de> wrote:
> 
> > Hi Sergei!
> > 
> > On 3/2/21 11:26 PM, Sergei Trofimovich wrote:  
> > > Gave v5.12-rc1 a try today and got a similar boot failure around
> > > hpsa queue initialization, but my failure is later:
> > >     https://dev.gentoo.org/~slyfox/configs/guppy-dmesg-5.12-rc1
> > > Maybe I get different error because I flipped on most debugging
> > > kernel options :)
> > > 
> > > Looks like 'ERROR: Invalid distance value range' while being
> > > very scary are harmless. It's just a new spammy way for kernel
> > > to report lack of NUMA config on the machine (no SRAT and SLIT
> > > ACPI tables).
> > > 
> > > At least I get hpsa detected on PCI bus. But I guess it's discovered
> > > configuration is very wrong as I get unaligned accesses:
> > >     [   19.811570] kernel unaligned access to 0xe000000105dd8295, ip=0xa000000100b874d1
> > > 
> > > Bisecting now.    
> > 
> > Sounds good. I guess we should get Jens' fix for the signal regression
> > merged as well as your two fixes for strace.  
> 
> "bisected" (cheated halfway through) and verified that reverting
> f749d8b7a9896bc6e5ffe104cc64345037e0b152 makes rx3600 boot again.
> 
> CCing authors who might be able to help us here.
> 
> commit f749d8b7a9896bc6e5ffe104cc64345037e0b152
> Author: Don Brace <don.brace@microchip.com>
> Date:   Mon Feb 15 16:26:57 2021 -0600
> 
>     scsi: hpsa: Correct dev cmds outstanding for retried cmds
> 
>     Prevent incrementing device->commands_outstanding for ioaccel command
>     retries that are driver initiated.  If the command goes through the retry
>     path, the device->commands_outstanding counter has already accounted for
>     the number of commands outstanding to the device.  Only commands going
>     through function hpsa_cmd_resolve_events decrement this counter.
> 
>      - ioaccel commands go to either HBA disks or to logical volumes comprised
>        of SSDs.
> 
>     The extra increment is causing device resets to hang.
> 
>      - Resets wait for all device outstanding commands to complete before
>        returning.
> 
>     Replace unused field abort_pending with retry_pending. This is a
>     maintenance driver so these changes have the least impact/risk.
> 
>     Link: https://lore.kernel.org/r/161342801747.29388.13045495968308188518.stgit@brunhilda
>     Tested-by: Joe Szczypek <jszczype@redhat.com>
>     Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
>     Reviewed-by: Scott Teel <scott.teel@microchip.com>
>     Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>     Signed-off-by: Don Brace <don.brace@microchip.com>
>     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> Don, do you happen to know why this patch caused some controller init failure
> for device
>     14:01.0 RAID bus controller: Hewlett-Packard Company Smart Array P600
> ?
> 
> Boot failure: https://dev.gentoo.org/~slyfox/configs/guppy-dmesg-5.12-rc1
> Boot success: https://dev.gentoo.org/~slyfox/configs/guppy-dmesg-5.12-rc1-good
> 
> The difference between the two boots is 
> f749d8b7a9896bc6e5ffe104cc64345037e0b152 reverted on top of 5.12-rc1
> in -good case.
> 
> Looks like hpsa controller fails to initialize in bad case (could be a race?).

Also CCing hpsa maintainer mailing lists.

Looking more into the suspect commit
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f749d8b7a9896bc6e5ffe104cc64345037e0b152
it roughly does the:

@@ -448,7 +448,7 @@ struct CommandList {
 	 */
 	struct hpsa_scsi_dev_t *phys_disk;
 
-	int abort_pending;
+	bool retry_pending;
 	struct hpsa_scsi_dev_t *device;
 	atomic_t refcount; /* Must be last to avoid memset in hpsa_cmd_init() */
 } __aligned(COMMANDLIST_ALIGNMENT);
...
@@ -1151,7 +1151,10 @@ static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
 {
        dial_down_lockup_detection_during_fw_flash(h, c);
        atomic_inc(&h->commands_outstanding);
-       if (c->device)
+       /*
+        * Check to see if the command is being retried.
+        */
+       if (c->device && !c->retry_pending)
                atomic_inc(&c->device->commands_outstanding);

But I don't immediately see anything wrong with it.

-- 

  Sergei
