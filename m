Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D6BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 19:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8358860F46
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 19:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhJSUA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 16:00:58 -0400
Received: from outbound1g.eu.mailhop.org ([52.28.6.212]:45086 "EHLO
        outbound1g.eu.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbhJSUAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2021 16:00:55 -0400
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2021 16:00:54 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1634670755; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=qkwi+TVL1ScdsKbz9RTS1knEl20R3y2dN6rJT65YhKPD73ZSQrsXzR2xpRviE51YZx/abHiHmGMCO
         seRqPllBbE5hoD1GvoUm7MV6fpagJmeMmOEdePip2uA+ah9frhUEbiCYsFFEz9/kh+X18PSSKIC9aC
         36xF2hyWIgB5x3vgMXwbzOREZHi8q53P44oB4SsnIQXxFXS9jg/D5MXe1Kif2wueTUgHUQDyKsAjlE
         afidM6RPtk5iVQqwbZL8fDC4G/xb5SZkrFok+hG+STod0lTQeC+B7ENo9jWIYBPJ5ALVRYLL6fSKls
         Zmthi4yglUExjq3si80AexDAVfJfGbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         dkim-signature:dkim-signature:from;
        bh=D5R8spyC9KsGHgk5FZG/PXCCde1+//k9ncLumz8lOqA=;
        b=hjnWH0e1EfffsZSVsBqDG+az3FulApZgMdsWTx8qqTkSQJoIR98GZhxLPJsMxZ0/ShWXmdxyTg6Qx
         zzgITcTnnDQzRqVcRa3Ny7HywtZaVg5BIGHDywK88nwVWEKZyB538Sn6S2cmC7bzhaNnNX+4gMuGch
         DctC6HafJhQnavi0486D4/Re3pXSyQEYimCFTJXUMZgxqJaytqE6rr7503fnr0eLQdC84Sh4fElEmQ
         ypWcHo0B6cbPadMqU9s2i07h613MzqP7/AQAx4CTy3WhuNeNmLcvRsryzQnASB1cT+yowR4fevrkqn
         uQiqKKC/D881VAmOOV0DwDU/uTvmbLg==
ARC-Authentication-Results: i=1; outbound3.eu.mailhop.org;
        spf=pass smtp.mailfrom=stackframe.org smtp.remote-ip=91.207.61.48;
        dmarc=none header.from=stackframe.org;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stackframe.org; s=duo-1634547266507-560c42ae;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=D5R8spyC9KsGHgk5FZG/PXCCde1+//k9ncLumz8lOqA=;
        b=I0GsszlKRMGtFO4IIQlyEY2wdVQcjteldsdn25T4nPTZJREbgXNFukxPL/7aoMX6zCb03EBdvG1U6
         ltGwq8nguL8EgqOaVsPy7+yAQYg7unPeraIZnDhprVuC507kkpHp8MWwbbmiZnEsP53a/0yxwpEO5T
         UtnCurl5T2a+eOy8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=D5R8spyC9KsGHgk5FZG/PXCCde1+//k9ncLumz8lOqA=;
        b=RnhgdCuIiZrB3dHWDLWFui3ne+InXsaKzsvmL+TztFsjpDAL8vAKTP2vK337hKfirX41VvdybWYjJ
         LYx7iB6jFSgvCrUbtHDr9MPHYUscVk6oqYThO0Hj/Ny2w2c//K01idGRkFF9Co21vZ/JSAIOQ/bcO8
         VGE03HrtjBf6FQiITVKN8QPTYpJdqbA5rGiyI8gG7DCfmEThWbcxROKnXGacc2f6eEvdaDN9+JopJu
         5Rr1EBrXjCY+UKLP2+kwbh6GebUk7IFTq+C9oJgM2YlwIJykskPjd7AQNrpM5wXcj98Yvxemh32DKG
         4Oz8gOPjQXrfFAmdJMmgDeJCfaC7bHw==
X-Originating-IP: 91.207.61.48
X-MHO-RoutePath: dG9ta2lzdG5lcm51
X-MHO-User: 813bc9e9-3110-11ec-a40e-d17a12b91375
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from mail.duncanthrax.net (propper.duncanthrax.net [91.207.61.48])
        by outbound3.eu.mailhop.org (Halon) with ESMTPSA
        id 813bc9e9-3110-11ec-a40e-d17a12b91375;
        Tue, 19 Oct 2021 19:12:30 +0000 (UTC)
Received: from hsi-kbw-109-193-149-228.hsi7.kabel-badenwuerttemberg.de ([109.193.149.228] helo=x1.stackframe.org)
        by mail.duncanthrax.net with esmtpa (Exim 4.93)
        (envelope-from <svens@stackframe.org>)
        id 1mcuXF-00BhtH-6b; Tue, 19 Oct 2021 22:12:29 +0300
From:   Sven Schnelle <svens@stackframe.org>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [PATCH] mpt3sas: add NULL check in _base_fault_reset_work()
Date:   Tue, 19 Oct 2021 21:12:08 +0200
Message-Id: <20211019191208.6546-1-svens@stackframe.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

My HP C8000 (an PA-RISC based system) crashed with an HPMC. That
triggered the HPMC handler in the kernel, and i got a crash in
_base_fault_reset_work() from mpt3sas. It looks like this function
calls ioc->schedule_dead_ioc_flush_running_cmds() without checking
whether there's actually a function set, so it dereferences a NULL
pointer on that system. The c8000 actually uses the mptspi driver
instead of mpt3sas which doesn't seem to set this handler.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
---
Disclaimer: I have no idea about the inner workings of the MPT Fusion drivers.
So this might be completely wrong.

 drivers/message/fusion/mptbase.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 7f7abc9069f7..38f5aa43b457 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -381,7 +381,8 @@ mpt_fault_reset_work(struct work_struct *work)
 		 * since dead ioc will never return any command back from HW.
 		 */
 		hd = shost_priv(ioc->sh);
-		ioc->schedule_dead_ioc_flush_running_cmds(hd);
+		if (ioc->schedule_dead_ioc_flush_running_cmds)
+			ioc->schedule_dead_ioc_flush_running_cmds(hd);
 
 		/*Remove the Dead Host */
 		p = kthread_run(mpt_remove_dead_ioc_func, ioc,
-- 
2.33.0

