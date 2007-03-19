From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: 2.6.20.3: kernel BUG at mm/slab.c:597 try#2
Date: Mon, 19 Mar 2007 19:29:41 -0400
Message-ID: <200703191929.41268.gene.heskett@gmail.com>
References: <45FDDA8E.8030100@domdv.de>
 <200703191747.48826.gene.heskett@gmail.com>
 <1174342017.3512.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vms042pub.verizon.net ([206.46.252.42]:45762 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030732AbXCSXaB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 19:30:01 -0400
In-reply-to: <1174342017.3512.58.camel@mulgrave.il.steeleye.com>
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Christie <michaelc@cs.wisc.edu>, Andreas Steinmetz <ast@domdv.de>, linux-scsi@vger.kernel.org, akpm@linux-foundation.org

On Monday 19 March 2007, James Bottomley wrote:
>On Mon, 2007-03-19 at 17:47 -0400, Gene Heskett wrote:
>> James, could this also be the cause of a tar based backup going crazy
>> and thinking all data is new under any 2.6.21-rc* kernel I've tested
>> so far with amanda, which in my case uses tar?  I've tried the fedora
>> patched tar-1.15-1, and one I hand built right after 1.15-1 came out
>> over a year ago, and they both do it, but only when booted to a
>> 2.6.21-rc* kernel.
>>
>> This obviously will be a show-stopper, either for amanda (and by
>> inference, any app that uses tar), or for the migration of an amanda
>> users machinery to a 2.6.21 kernel.
>
>Er, I don't think so .. that sounds like mtime miscompare, which is
>either a problem with the filesystem or a problem with the way mtime is
>stored in the tar archive.
>
>James

Well, since the times reported by ls -l --full-time are sane
[root@coyote pix]# ls -l --full-time
total 924784
-rw-r--r-- 1 root   root     985324 2002-06-09 18:14:54.000000000 -0400 
0203.jpg
[... the rest of a 100k listing, booted to 2.6.20.3-rdsl-0.31]

And:
[root@coyote pix]# ls -l --full-time
total 924784
-rw-r--r-- 1 root   root     985324 2002-06-09 18:14:54.000000000 -0400 
0203.jpg

booted to 2.6.21-rc4

allthough the fractional second is a string of .000000000, even when 
booted to a tar-unfriendly kernel, then it would tend to point at tar, 
but two differently built versions of tar have been confirmed as 
miss-behaving in the presence of a kernel in the 2.6.21 series so far, 
all of them.

I'm going to reboot twice more tonight, once to verify that the output of 
an ls -l --full-time is as I said above, I'll save this and do that again 
and clip it in after a reboot to 2.6.21-rc4, and once to 2.6.20.4-rc1 to 
see if by chance one of those patches is the guilty party.  I'll leave 
the latter running tonight for the amanda run & see what falls out.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Try to relax and enjoy the crisis.
		-- Ashleigh Brilliant
