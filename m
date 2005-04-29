From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [Question] Does the kernel ignore errors writng to disk?
Date: Fri, 29 Apr 2005 12:11:24 -0700
Message-ID: <OF48BA3721.BD4798AD-ON88256FF2.00680E7E-88256FF2.0069814F@us.ibm.com>
References: <Pine.LNX.4.60.0504290824280.28101@hermes-1.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262891AbVD2TOS@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.60.0504290824280.28101@hermes-1.csi.cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: aia21@hermes.cam.ac.uk, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, mike.miller@hp.com
List-Id: linux-scsi@vger.kernel.org

>On Thu, 28 Apr 2005, Bryan Henderson wrote:
>> >O_SYNC doesn't work completely on several file systems and only on the
>> >latest kernels with some of the common ones.
>> 
>> Hmmm.  You didn't mention such a restriction when you suggested fsync() 

>> before.  Does fsync() work completely on these kernels where O_SYNC 
>> doesn't?  Considering that a simple implementation of O_SYNC just does 
the 
>> equivalent of an fsync() inside every write(), that would be hard to 
>> understand.
>
>Some file systems implement their fsync() function as "return 0;" so no, 
>you cannot rely on it at all.

It's pretty clear Alan isn't talking about those cases.  I don't think he 
would have suggested fsync() to address the delayed write error problem in 
a case where fsync() is "return 0;".

But let's talk about the no-op fsync() cases:  fsync() is supposed to 
cause data to be written to stable storage.  "stable" is a relative 
concept that the individual filesystem type or driver has to define for 
itself.  In an ordinary disk-based filesystem, we usually expect it to 
mean the data has gone onto the oxide.  But that's not really stable -- 
the disk drive could break and the data would be gone.  For some, just 
getting into the buffers of the disk drive is stable enough, since then 
rebooting Linux wouldn't cause the data to be lost.  For ramfs, the Linux 
page cache is as stable as you can hope for.

So I view it as correct even if fsync() does nothing on a disk-based 
filesystem because the programmer was lazy (or because the user wants to 
defeat the performance-busting behavior of some paranoid application). But 
when Alan speaks of a "not completely correct" version of synchronization, 
which makes me think of something that doesn't implement any consistent 
form of "stable," I want to hear more.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems
