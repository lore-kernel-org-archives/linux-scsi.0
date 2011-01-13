From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC/PATCH] Deferred disk spinup during system resume
Date: Thu, 13 Jan 2011 16:37:07 +0100
Message-ID: <20110113153707.GB12596@htj.dyndns.org>
References: <1294795457-9006-1-git-send-email-maksim.rayskiy@gmail.com>
 <20110112112142.GA9610@mtj.dyndns.org>
 <4D2DF45B.5010101@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43409 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab1AMPhZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jan 2011 10:37:25 -0500
Received: by bwz15 with SMTP id 15so1632030bwz.19
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jan 2011 07:37:16 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4D2DF45B.5010101@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: maksim.rayskiy@gmail.com, linux-scsi@vger.kernel.org

Hey, Jeff.

On Wed, Jan 12, 2011 at 01:35:07PM -0500, Jeff Garzik wrote:
> The previous patch breaks READ VERIFY translation for all cases
> -except- this one.

Ooh, right; then, can we just fix that?

> The bottom line is that this patch simply wants to trigger an ATA
> command, and return immediately, discarding the command results.
> I'm not even sure a "run this command in background, and discard
> results" facility requires the EH.

It doens't necessarily require EH but the dependency is rather
delicate because we still ride on SCSI EH.  For example, we don't have
any provision for running qc's without the associated scmd.  If the
command fails, libata EH rides on SCSI EH and the interaction relies
on the association between qc's and scmd's.  We may be able to add
privison for this case but we already have working mechanism in EH for
internal commands so it's just easiser that way.

Well, actually, the _really_ right(eous) thing to do here would be
just not doing it as it's an ugly hack no matter which way we spin it,
but this has a quite significant impact on resume from STR latency
so...

Thanks.

-- 
tejun
