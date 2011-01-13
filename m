From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC/PATCH] Deferred disk spinup during system resume
Date: Thu, 13 Jan 2011 18:24:32 +0100
Message-ID: <20110113172432.GF14096@htj.dyndns.org>
References: <1294795457-9006-1-git-send-email-maksim.rayskiy@gmail.com>
 <20110112112142.GA9610@mtj.dyndns.org>
 <4D2DF45B.5010101@pobox.com>
 <20110113153707.GB12596@htj.dyndns.org>
 <4D2F3440.30701@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55711 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053Ab1AMRYh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jan 2011 12:24:37 -0500
Received: by bwz15 with SMTP id 15so1736700bwz.19
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jan 2011 09:24:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4D2F3440.30701@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: maksim.rayskiy@gmail.com, linux-scsi@vger.kernel.org

On Thu, Jan 13, 2011 at 12:20:00PM -0500, Jeff Garzik wrote:
> In this case we -do- have an associated scmd, otherwise he would not
> be able to trigger the READ VERIFY translation code.

Yeah, we have on issue but we don't if we decide to execute it
asynchronously.  It would be best if SCSI can handle the
asynchronousity but I can't see how at this point.

> So it seems a question of (a) who generates READ VERIFY, and (b) can
> we have them issue the command without waiting for the results?
> 
> Which is something I would have thought SG_IO/bsg already provided...
> 
> It remains unclear to me why EH must be updated, simply to execute a
> non-data ATA command without waiting.

It's just there to use the internal qc.  Nothing else.  If
asynchronousity can be handled, it would be the best.

Thanks.

-- 
tejun
