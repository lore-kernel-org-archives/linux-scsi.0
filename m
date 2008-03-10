From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] SCSI: make use of the residue value
Date: Mon, 10 Mar 2008 15:42:28 +0200
Message-ID: <47D53AC4.8030407@panasas.com>
References: <Pine.LNX.4.44L0.0803091617480.16105-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:53502 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYCJNmt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2008 09:42:49 -0400
In-Reply-To: <Pine.LNX.4.44L0.0803091617480.16105-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, Mar 09 2008 at 23:50 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sun, 9 Mar 2008, James Bottomley wrote:
> 
>>> But the comment talks about identifying a bad sector.  That makes no 
>>> sense if the command isn't sector-oriented to begin with.
>> At the moment we have two (well, a lot more if you include the token
>> based PM commands, but SCSI doesn't really do those) command types:
>> BLOCK_PC and FS.  The latter go through this clause and *are* sector
>> based.
> 
> And we really don't have to worry about the other types?  Okay...
> 
>>> Yes.  And if residue > good_bytes then you end up taking the larger
>>> instead of the smaller: Since good_bytes is unsigned, subtracting a
>>> larger quantity from it yields a very large positive result.
>> For that to happen the driver would have to have returned a larger
>> residue than it was given bytes to write or read, which should be an
>> impossible condition given that they count down from the bytes to write.
>> If any driver is doing this, it needs catching and shooting.
> 
> In short, you're trusting the low-level drivers to catch this
> impossible condition.  (usb-storage does check for it, incidentally.)  
> That's fine with me, as long as it's explicit.
> 
>>> 	It doesn't use the residue at all for BLOCK_PC requests.
>> The residue for these is returned in a different way.
>>
>>> BTW, you never answered my question: How does the SCSI midlayer tell
>>> callers that a command returned less data than requested because the
>>> device claims the remainder doesn't exist?
>> For BLOCK_PC that's returned in req->data_len, which is placed in resid
>> (sgv3) or din/dout_resid (sgv4) for the user.
> 
> I see.  Although oddly enough, the scsi_execute() routine throws this 
> information away.  Don't its callers need to know?
> 
> All right, your version of the patch seems okay.  But there still is an
> unanswered question:
> 
> What's the reason for this baroque arrangement?  Why tell the block 
> layer that the data was transferred successfully and then use a 
> back-door arrangement like req->data_len to let the caller know that 
> no, the data wan't really all transferred?

Yes this is very ugly and bug-full. We tripped over that a few times
in the passed. There was somewhat an agreement at LSF that struct request
should have a residue field, just as scsi_cmnd do. and that the scsi_cmnd's
field can go away. (Easily done with scsi accessors in place). Current system
was an HACK to reuse req->data_len for residue after the request was completed.
for sg only at the time. It is on my TODO list, together with some other changes
that we agree upon.

> 
> Alan Stern
> 
> P.S.: In case you're interested...
> 
> It's not common, even among USB devices, to return a residue without
> identifying the bad sector.  The one example where I saw it happen was
> explained by the fact that max_sectors was too high.  The device
> returned as much data as it could, with the residue set to indicate
> that some was missing.  But since it never actually encountered a
> sector-read error, it didn't return any sense information.

There was a fix submitted to sd.c and separately to sr.c not long ago, I 
would say 2.6.25, (haven't checked though). That fixes such a problem. It was 
agreed that other ULDs do not really use proper FS commands. What are the 
kernels you have reports for? Do you need that I dig up the commits / mailinglist
posts?

> 
> Yes, the device _should_ have returned Illegal Request, Invalid 
> Field in CDB, or something of the sort.  That would have alerted us to 
> the problem.  But it didn't.  And as a result, the midlayer thought the 
> missing data was present and correct.  The user reported it as data 
> corruption: Files written to the device and then read back did not 
> compare equal to the original files.
> 

The way I see it, what you are saying is impossible, since there is a check
for max sector in place, and VFS/ULD will not write passed that. If so it's a bug
that should be fixed. (Wherever the bug is).
If this was done as a BLOCK_PC via sg then surly the residue was reported back
to user mode and the application should be fixed.

Boaz
