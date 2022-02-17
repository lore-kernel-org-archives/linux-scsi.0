Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0329C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 18:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244163AbiBQSTd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 13:19:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244164AbiBQST0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 13:19:26 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138C61F2274;
        Thu, 17 Feb 2022 10:19:11 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B6C061F37D;
        Thu, 17 Feb 2022 18:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645121949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc;
        bh=itqugMibiyd3tBx9VkQfAYWsW8RO3YMoYfoJtBgbeLU=;
        b=gBi0SkbyjcFIAB25TFVgtZWh5dHXdzgd2GzX8gRmeecJsSlX7a6XUTlHamaWzWTDpEFqxU
        1xn49ey3vMCqeyiObFimeAFcGmVAHd7wCCq5jjdPMMSL8gaa2DSB8dUyGx9NOMZEDltyVU
        dDtTg2nwm8YOrpkE6RP84u8aNhhW3Eg=
Received: from localhost (unknown [10.163.24.18])
        by relay2.suse.de (Postfix) with ESMTP id 829B0A3B83;
        Thu, 17 Feb 2022 18:19:09 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id A2460E9317; Thu, 17 Feb 2022 10:19:07 -0800 (PST)
From:   lduncan@suse.com
To:     lsf-pc@lists.linux-foundation.org
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [LSF/MM/BPF Topic][LSF/MM/BPF Attend] iscsi issue of scale with MNoT
Message-Id: <20220217181907.A2460E9317@localhost>
Date:   Thu, 17 Feb 2022 10:19:07 -0800 (PST)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[RESEND -- apologies if you see this more than once]

The iSCSI protocol continues to be used in Linux, but some of the
users push the system past its normal limits. And using multipath just
exacerbates that problem (usually doubling the number of sessions).

I'd like to gather some numbers for open-iscsi (the standard Linux
iSCSI initiator) and the kernel target code (i.e. LIO/targetcli) on
what happens when there are MNoT -- massive numbers of targets.

"Massive" in my case, will be relative, since I don't have access to
a supercomputer, but I believe it will not be too hard to start
pushing the system too far. For example, a recent user problem found
that even at 2000 sessions using multipath, the system takes about 80
seconds to switch paths. Each switch takes 80ms (and they are
currently serialized), but when you multiply that by 1000 it adds up.

For the initiator, I've long suspected some parts of the code were not
designed for scale, so this might give me a chance to find and
possibly address some of these issues.

--
Lee Duncan
