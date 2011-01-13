From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC/PATCH] Deferred disk spinup during system resume
Date: Thu, 13 Jan 2011 12:20:00 -0500
Message-ID: <4D2F3440.30701@pobox.com>
References: <1294795457-9006-1-git-send-email-maksim.rayskiy@gmail.com> <20110112112142.GA9610@mtj.dyndns.org> <4D2DF45B.5010101@pobox.com> <20110113153707.GB12596@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34142 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab1AMRUE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jan 2011 12:20:04 -0500
Received: by vws16 with SMTP id 16so681918vws.19
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jan 2011 09:20:04 -0800 (PST)
In-Reply-To: <20110113153707.GB12596@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: maksim.rayskiy@gmail.com, linux-scsi@vger.kernel.org

On 01/13/2011 10:37 AM, Tejun Heo wrote:
> Hey, Jeff.
>
> On Wed, Jan 12, 2011 at 01:35:07PM -0500, Jeff Garzik wrote:
>> The previous patch breaks READ VERIFY translation for all cases
>> -except- this one.
>
> Ooh, right; then, can we just fix that?
>
>> The bottom line is that this patch simply wants to trigger an ATA
>> command, and return immediately, discarding the command results.
>> I'm not even sure a "run this command in background, and discard
>> results" facility requires the EH.
>
> It doens't necessarily require EH but the dependency is rather
> delicate because we still ride on SCSI EH.  For example, we don't have
> any provision for running qc's without the associated scmd.  If the
> command fails, libata EH rides on SCSI EH and the interaction relies
> on the association between qc's and scmd's.  We may be able to add
> privison for this case but we already have working mechanism in EH for
> internal commands so it's just easiser that way.

In this case we -do- have an associated scmd, otherwise he would not be 
able to trigger the READ VERIFY translation code.

So it seems a question of (a) who generates READ VERIFY, and (b) can we 
have them issue the command without waiting for the results?

Which is something I would have thought SG_IO/bsg already provided...

It remains unclear to me why EH must be updated, simply to execute a 
non-data ATA command without waiting.

	Jeff



