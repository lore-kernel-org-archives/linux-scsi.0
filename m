From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Linux tape drivers
Date: Wed, 04 Apr 2007 15:50:46 -0400
Message-ID: <46140196.4020702@torque.net>
References: <200704031508.37222.kern@sibbald.com> <20070403133904.0029ccd2.akpm@linux-foundation.org> <Pine.LNX.4.64.0704042029430.8139@kai.makisara.local>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50518 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766906AbXDDTx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 15:53:57 -0400
In-Reply-To: <Pine.LNX.4.64.0704042029430.8139@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kern Sibbald <kern@sibbald.com>, linux-scsi@vger.kernel.org, Willem Riede <wrlk@riede.org>

Kai Makisara wrote:
> On Tue, 3 Apr 2007, Andrew Morton wrote:
> 
>> (cc's added, with permission)
>>
>> On Tue, 3 Apr 2007 15:08:37 +0200
>> Kern Sibbald <kern@sibbald.com> wrote:
>>
>>> Hello,
>>>
>>> I am the project manager for Bacula, an Open Source network backup program 
>>> that runs on all popular OSes.  After your presentation at FOSDEM in Febrary, 
>>> we briefly talked about Linux tape driver problems I am encountering, and you 
>>> offered to put me in touch with the appropriate kernel developers.
>>>
>>> I would much appreciate any help in this.  Since the problems concern all tape 
>>> drivers, I provide a very brief outline of what my would like to discuss.  
>>> First, I must mention that the Linux SCSI driver works perfectly fine with 
>>> Bacula, it is simply a question of possible improvements, under item 2 below.
>>>
>>> Issues for discussion:
>>>
>>> 1. Bugs:
>>>    a. Other than the OSST driver, apparently no IDE/SATA tape driver works
>>>        with Bacula. I don't have such a drive (working on it), but from user
>>>        reports, it appears to me that there are problems of permitting 
>>>        variable length blocks, and more serious, when writing to the end of
>>>        the tape, either the logical end of tape indicator is ignored, or when
>>>        it is encountered, all further I/O is prohibited -- including a WEOF. 
>>>        This makes reliable writing of multiple reel tapes impossible.
>>>
>>>        By the way, these IDE/SATA drives work with Bacula using the same
>>>        source code cross-compiled with GNU C++ on Linux, then run on Windows
>>>        machines, so it is most likely a driver issue rather than anything in
>>>        Bacula or the hardware.
>>>
> 
> Others have already answered this and I agree with their view. All of the 
> tape drives seem to use the SSC command set or something close to that. 
> One high-level driver should be enough to implement the user semantics.
>  
> Libata should be able to drive the SATA/IDE drives using and the drives 
> are visible as SCSI devices in Linux. In future there should be no real 
> need for ide-scsi. Probably very few people have tried libata with tapes 
> and there may be some problems to fix. Someone should test this with 
> real devices and report the problems back to libata maintainers.
> 
>>> 2. Usability of the current tape driver API (not bugs)
>>>   a. With the new O_NONBLOCK flag introduced in kernel 2.5.x, opening
>>>       a tape drive and finding out if a volume is mounted is much more 
>>>       complicated.  It is really inconvenient and required a lot more code
>>>       in prior kernels.  This should be an item for discussion.
> 
> The reasons for the change were:
> 1. To be compatible with the Unix standards, and
> 2. To be compatible with other Unix tape driver semantics.
> 
> Because of these reasons the changes should probably not be reversed but 
> there may be something to improve in the implementation. Suggestions?

Kai,
Perhaps an ignore_nonblock sysfs attribute or driver option
could be added for the old semantics.
As I have found in the past, programs the scan for devices
by opening device nodes don't play well with drivers
that hang on open.

>>>   b. There is no simple way to determine if a tape is in a drive -- it is 
>>>       at least 20 or 30 lines of C code to do it right.
> 
> Why not use GMT_ONLINE() with MTIOCGET? The definition from the st man 
> page is:
> 
> GMT_ONLINE(x): The last open() found the drive with a tape in place and 
> ready for operation.
> 
> If it does not work correctly, it can be fixed. (Of course, if you want to 
> see if a tape is in a drive but not loaded, it is more difficult.)

Sound like a TEST UNIT READY is all that is needed.
They could call out to a utility like sg_turs or
sdparm and check the exit status. They could also
build with sg3_utils-libs and call
sg_ll_test_unit_ready(). [All sg3_utils code is C++
friendly.]

Doug Gilbert
