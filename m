Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D011FC4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 18:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B64FB60F5E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 18:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbhHTTAA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 15:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhHTTAA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2021 15:00:00 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC70C061575;
        Fri, 20 Aug 2021 11:59:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so7905190pjl.4;
        Fri, 20 Aug 2021 11:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=UMgLcGCOIGAExCm8sckl+Lt/uavQl14EGAuUCVTCWy8=;
        b=gFDrqAlqryS77RGQGNGE7irxi/q3PsUV+9dkWQmYPCAO6HUxVObyLCbfyXaOVcpBjN
         Q84hh5Q0fsLrreb0F5hmd/rXcaW4CkLBed7+aj2PyWWOAIHyqu6rN7xxf+/s6Kr9mnY/
         vLG/YPDmt/f2Dwjd6S+r/RxbSDYIYruuiQbKIBEjOJAndLbpm0+OfwVgZ++v/6fyEOEN
         qInggiO4IlT3NkE3mnlEQ/I5nh5nVoZ8XOc9KGK+ni2tHC3LlBDeXDVx5JTh2GUhklg9
         2/qMfgGi87l1AqA7mDssiuznvoyADQGpa45YgvB6qrR4MVC8lVbJ46Hl/6gPoW7WHLy3
         l4IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=UMgLcGCOIGAExCm8sckl+Lt/uavQl14EGAuUCVTCWy8=;
        b=qx9g2ZhegwLdT1cmeNHvD8eiIoHM+2CrFEb5Ny8hYVpgEp7AyOLLu+JgA6Fa//kRmJ
         hzJMVIKOBJ5ljWGDZjDmQ6ntr5czqWZiA37ajq1hRkL9cedaloSlDDP2UDZQoGeF47xR
         mWLRxPa27wDT550dXXx1JK0uGLNo8PN02pYaJ5JLdMEfXTFz8iNDGEU/hSFSNr4C+nZ7
         KdvaMw/J9C6VncVfAhnBl0kDZXo0VrzXQvh47LB2ps2Plh89YnE+/volTxQ561FBGqD1
         4cSYwG6oTl4SxZ5q4RrFacqViv8lx9dvfFYA9TPatFFSEVQzaS7S4+mYZKJYGrTYS/nx
         g7fQ==
X-Gm-Message-State: AOAM531TGEZ9p4JdFoMWyTb1/1MKvSMBB67vBIw6mtTJGvOyLD6xbnyA
        uU4uzP/s5WI1cHWTIJpqAFv7z7+uAb6lsWmo3dQ=
X-Google-Smtp-Source: ABdhPJwTArERq85qlE2hbN0lMc2U+2dPkQuwCoivAw9VvQvAlZeJ2MT4yqJWMN78Zl68NR8WKALuJYcuHzPIEYK6lYo=
X-Received: by 2002:a17:90a:4d8d:: with SMTP id m13mr5951574pjh.190.1629485961902;
 Fri, 20 Aug 2021 11:59:21 -0700 (PDT)
MIME-Version: 1.0
From:   Tech Zhou <zhouinamerica@gmail.com>
Date:   Fri, 20 Aug 2021 14:59:11 -0400
Message-ID: <CAJwUSPsYzRpGkCXXHgqPW25w-rSAoNwRPYmUmbGx=VffThWFyA@mail.gmail.com>
Subject: [PATCH] Fix spelling error in arch/powerpc/kernel/traps.c
To:     Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I found a spelling error in arch/powerpc/kernel/traps.c. Please let me
know if you have any concerns / questions. This is my first patch!

Signed-off-by: Changjun Zhou <zhouinamerica@gmail.com>
---
 arch/powerpc/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index d56254f05e17..7355db219269 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1522,7 +1522,7 @@ static void do_program_check(struct pt_regs *regs)
         * SIGILL. The subsequent cases all relate to emulating instructions
         * which we should only do for userspace. We also do not want to enable
         * interrupts for kernel faults because that might lead to further
-        * faults, and loose the context of the original exception.
+        * faults, and lose the context of the original exception.
         */
        if (!user_mode(regs))
                goto sigill;
--
