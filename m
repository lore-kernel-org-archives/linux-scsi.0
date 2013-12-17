From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 5/6] sd: don't start disks on system resume
Date: Tue, 17 Dec 2013 13:30:28 -0500
Message-ID: <52B09844.3090208@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com>		 <1387236657-4852-1-git-send-email-psusi@ubuntu.com>		 <1387236657-4852-6-git-send-email-psusi@ubuntu.com>	 <1387262618.13936.38.camel@dabdike.int.hansenpartnership.com>	 <52B06750.7080903@ubuntu.com> <1387302536.2213.43.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:50998 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3LQSab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2013 13:30:31 -0500
In-Reply-To: <1387302536.2213.43.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/17/2013 12:48 PM, James Bottomley wrote:
> Yes, they say that in sd_resume, if we're managing the disk start
> stop, spin it up.  Removing them spins everything up
> unconditionally.

Ahh, right, I got rid of the manage_start_stop check.  Probably
shouldn't be in this patch, but I do think this flag should be removed
as we shouldn't be putting extra wear and tear on the disk by letting
it take an emergency head retract on power off.

> Good systems engineering practise does not have different
> behaviours for code with and without ifdefs.  You want to be adding
> incremental behaviour not modifying existing.  The reason is
> testing; now you have to build two different kernels to test the
> two behaviours and mostly one path gets selected by every distro
> and the other bitrots.

Unfortunately, the scsi error handling code is terrible so my attempt
to use that was not acceptable, so to do it requires runtime pm.

> Are you confused about the power states?  in SCSI, stand by and
> idle are different from spun down (or stopped).  Right at the
> moment, start stop manages spin down/spin up not the granular power
> states for almost every device.  The only subsystem that actually
> uses power state management is firewire.  Even if you enable power
> state management for ATA, we have to cope with non-ATA devices.

Yes, and ata drives do not have a stopped state.  They always power on
in either active or standby.  The SCSI standards even mention that
SCSI disks may be configured ( but don't say how ) to power on in
active rather than stopped.

> The standards actually say that SCSI devices automatically come out
> of standby power conditions unless the transport protocol says
> something different.

Yes, so when in standby the drive does not require START UNIT, but if
we set the runtime status to suspended, then we will issue one as soon
as a request comes in, causing the drive to spin up.  We don't want to
do that since some commands don't need the media to be spinning.

My goal was for the runtime pm status to reflect the drive status, so
if the drive is in standby, even though it doesn't need started, the
runtime status should show it is suspended.  I suppose that if I
didn't care about that, I could use TEST UNIT READY and only runtime
suspend if it requires the START UNIT command.

> Yes, but they aren't going to be in standby mode apart from
> firewire devices; they're going to be stopped.

No, because again, ata has no stopped state.  ata disks will either be
active, or standby if they have power up in standby enabled.

> What SAT says is irrelevant.  That's about how to translate ATA to
> SCSI, not how SCSI devices should behave.

It is relevant because they wouldn't have said to translate it that
way if they didn't intend REQUEST SENSE to be used that way.  If it
was the way you say, then it would say that the TEST UNIT READY
command should be translated to CHECK POWER, rather than REQUEST
SENSE.  Of course, SPC is the more authoritative source, which also
confirms it.

>> Because we want to let runtime pm start the disk at a later time,
>> once it is accessed, rather than when the system resumes.
> 
> I still don't get why a resume function call is doing suspend 
> operations.

Because runtime pm only resumes it if it is runtime suspended... if we
don't start the drive in the system resume handler, then we need to
block any requests until it is started, which is exactly what being
runtime suspended does.

>> Because we don't want to block the resume path for many seconds
>> and delay user space unfreezing.  I actually need to fix that to 
>> unconditionally queues the work item since right now it is in
>> process context, so it just directly calls the other function.
> 
> Um, then you need to read the code.  execute_in_process_context()
> is a direct function call if we have process context, so it's not
> going to use a work queue.

That's what I just said.

> Please don't do this.  Significant behaviour changes depending on
> what options are selected are not a good idea from the systems
> point of view. Options should control incremental changes (function
> present or not present).

Well, that is what it is doing.  The function of remaining suspended
after system resume is either present or not.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSsJhEAAoJEI5FoCIzSKrwFg0H/3xMLeKAA3ne7dTGfsDJu/E1
MQ9GBNgp+A/b08y8etJF2rDXNbWt0XqPWJnZWNJ/ubirShSVbQrTwIIatJ8qumG5
g6Q3nAmL7LtuqBFKwJJbo9/b6PdlCSXvkD5m4Dz4ZiCMHJQxD91n4m/iEtTXG/Cr
/xxdZwPqd1QQ8fOm573QeSeilIsoqDH51HSdaHx8c+C9bubBSAIiWtXDPRac8zLL
X7fIDJFyLtv/SoygCOrKuyalfjlDsbxl44qGT9mAgLJyi6Dj+StYbXvDwTtRP360
ZIlYpphLt0ybqFr588rluEu6PgI2V+93ukvmrY8YliaoyKiSP1G5c6Q48kk25Nw=
=BE0e
-----END PGP SIGNATURE-----
