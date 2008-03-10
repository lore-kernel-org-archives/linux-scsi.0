From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] SCSI: make use of the residue value
Date: Mon, 10 Mar 2008 16:31:07 +0200
Message-ID: <47D5462B.7080305@panasas.com>
References: <Pine.LNX.4.44L0.0803101001340.3493-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:33478 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYCJObV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2008 10:31:21 -0400
In-Reply-To: <Pine.LNX.4.44L0.0803101001340.3493-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Mar 10 2008 at 16:11 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 10 Mar 2008, Boaz Harrosh wrote:
> 
>>> What's the reason for this baroque arrangement?  Why tell the block 
>>> layer that the data was transferred successfully and then use a 
>>> back-door arrangement like req->data_len to let the caller know that 
>>> no, the data wan't really all transferred?
>> Yes this is very ugly and bug-full. We tripped over that a few times
>> in the passed. There was somewhat an agreement at LSF that struct request
>> should have a residue field, just as scsi_cmnd do. and that the scsi_cmnd's
>> field can go away. (Easily done with scsi accessors in place). Current system
>> was an HACK to reuse req->data_len for residue after the request was completed.
>> for sg only at the time. It is on my TODO list, together with some other changes
>> that we agree upon.
> 
> Sounds like a good thing to do.
> 
>>> P.S.: In case you're interested...
>>>
>>> It's not common, even among USB devices, to return a residue without
>>> identifying the bad sector.  The one example where I saw it happen was
>>> explained by the fact that max_sectors was too high.  The device
>>> returned as much data as it could, with the residue set to indicate
>>> that some was missing.  But since it never actually encountered a
>>> sector-read error, it didn't return any sense information.
>> There was a fix submitted to sd.c and separately to sr.c not long ago, I 
>> would say 2.6.25, (haven't checked though). That fixes such a problem. It was 
>> agreed that other ULDs do not really use proper FS commands. What are the 
>> kernels you have reports for? Do you need that I dig up the commits / mailinglist
>> posts?
> 
> No need, the problem you're thinking of in sd has been fixed.  The
> problem was that sd did not check the value of error_sector to make
> sure it was within the range of sectors accessed by the command.  I'm
> not sure if an equivalent fix has been applied to sr, however.

I certainly remember a very nice patch sent following the one to sd.
That revamps the all sr error handling path, including above problem. 
I'm not sure it was submitted upstream though.

> 
>>> Yes, the device _should_ have returned Illegal Request, Invalid 
>>> Field in CDB, or something of the sort.  That would have alerted us to 
>>> the problem.  But it didn't.  And as a result, the midlayer thought the 
>>> missing data was present and correct.  The user reported it as data 
>>> corruption: Files written to the device and then read back did not 
>>> compare equal to the original files.
>>>
>> The way I see it, what you are saying is impossible, since there is a check
>> for max sector in place, and VFS/ULD will not write passed that.
> 
> As I said, max_sectors was too big.  It was set to 120 KB but it 
> should have been 56 KB, or something like that.  Hence the VFS/ULD 
> tried to transfer more data than the device was capable of handling.
> 
>>  If so it's a bug
>> that should be fixed. (Wherever the bug is).
> 
> It has already been fixed; there is now a blacklist entry for that
> particular device specifying a lower value for max_sectors.
> 

OK, I see what you are saying: In case of bad behaving device, that we do
not know about. The residue can be an indication of an actual error that should
not be ignored. Sound's reasonable. In my opinion only a ULD like sd/sr could
really know such things for sure. (Given the knowledge of command submitted)
So a fix should go there. Both your patch and Jame's, touch code that does not
have enough information to be sure.

>> If this was done as a BLOCK_PC via sg then surly the residue was reported back
>> to user mode and the application should be fixed.
> 
> No, it was done by a normal filesystem I/O.
> 
> Alan Stern
> 

Boaz
