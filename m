From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.27 looping on SCSI errors for bad sectors
Date: Thu, 11 Dec 2008 17:02:04 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812111615560.15474-100000@iolanthe.rowland.org>
References: <494179E3.30802@gentoo.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37800 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757417AbYLKWCH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2008 17:02:07 -0500
In-Reply-To: <494179E3.30802@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-scsi@vger.kernel.org

On Thu, 11 Dec 2008, Daniel Drake wrote:

> Hi Alan,
> 
> I'm aware of your work at http://bugzilla.kernel.org/show_bug.cgi?id=11843
> 
> I agree with fixing the unusual_devs file for USB devices that report 
> the wrong capacity, but this SCSI "looping on error" problem reaches 
> further than that. Gentoo has a bug report at 
> https://bugs.gentoo.org/show_bug.cgi?id=248698 where there is a "real" 
> bad sector in the middle of a disk, and this bug is affecting recovery 
> of said disk.
> 
> On the kernel bugzilla you posted some patches that would improve the 
> behaviour of 2.6.27 here. Are those patches candidates for 2.6.27.x, or 
> do you know if it's being fixed another way, or is it a lost cause?
> I understand that 2.6.28 has been fixed through a major rework in that area.

It's a complicated story.

For other readers, here's a summary of the Gentoo bug report.  It has
two parts: One is that 2.6.26 doesn't report a bad block using an
"unknown" controller; the other is that 2.6.27 loops indefinitely when
reading the bad block using the "unknown" controller.  The key aspect
of this controller is that when asked to read 8 sectors (4096 bytes) of
which at least one is bad, it returns 1026 bytes of data with a residue
of 3070, Check Condition status, and no sense (SK = ASC = ASCQ = 0).

The fact that the number of "good" bytes isn't a multiple of the sector
size is suspicious in itself, but let that pass.  The real problem has
to do with the lack of sense data.  When usb-storage sees there's no
sense, it changes the status to SAM_STAT_GOOD and clears the sense
buffer.  But since the number of bytes is less than it should be, the
final result is DID_ERROR with SUGGEST_RETRY.

Now, I don't remember exactly what would happen with 2.6.26 under these 
conditions.  Perhaps the SCSI layer would retry the command a few times 
and then give up, but not realize that the read had failed -- meaning 
that whatever garbage was in the buffer would be returned to the user.  

2.6.27 does retry the read, indefinitely as far as I can tell.  At
least, if there is a means for giving up eventually, I don't know what
it is.  My B'' patch provides such a means, but I doubt it will be
accepted since it would interfere with the operation of some SCSI tape
devices.

2.6.28 is slightly better in this regard.  You might say it has been
fixed; it will retry the command until a timeout expires.  However the
timeout tends to be rather large (30 or 60 seconds multiplied by 6
iterations, typically).  I don't regard this as particularly useful.

It's fair to say that at present, the SCSI core's retry and timeout 
policy is pretty messed up.  However I'm not a good person to ask about 
getting the problem fixed, because I'm not an expert SCSI developer.

In fact, the best thing would be for you to push item 1 from comment
#19 in the Gentoo bug report upstream.  That would focus the attention
of the SCSI developers and give them something concrete to work on and
to test with.  If that's what you do, add me to the CC list.

Alan Stern

