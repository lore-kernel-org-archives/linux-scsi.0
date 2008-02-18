From: Keith Hopkins <vger@hopnet.net>
Subject: Re: aic94xx: failing on high load (another data point)
Date: Mon, 18 Feb 2008 22:26:18 +0800
Message-ID: <47B9958A.8080104@hopnet.net>
References: <479FB3ED.3080401@hopnet.net>	<20080130091403.GA14887@alaris.suse.cz> <47A05896.40900@hopnet.net>	<20080130192947.GA21785@tree.beaverton.ibm.com>	<47B4682C.4020505@hopnet.net> <1203089323.3058.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [221.218.196.247] ([221.218.196.247]:45176 "EHLO
	mail.hopnet.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbYBROYK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Feb 2008 09:24:10 -0500
In-Reply-To: <1203089323.3058.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Jan Sembera <jsembera@suse.cz>, linux-scsi@vger.kernel.org

On 02/15/2008 11:28 PM, James Bottomley wrote:
> On Fri, 2008-02-15 at 00:11 +0800, Keith Hopkins wrote:
>> On 01/31/2008 03:29 AM, Darrick J. Wong wrote:
>>> On Wed, Jan 30, 2008 at 06:59:34PM +0800, Keith Hopkins wrote:
>>>> V28.  My controller functions well with a single drive (low-medium load).  Unfortunately, all attempts to get the mirrors in sync fail and usually hang the whole box.
>>> Adaptec posted a V30 sequencer on their website; does that fix the
>>> problems?
>>>
>>> http://www.adaptec.com/en-US/speed/scsi/linux/aic94xx-seq-30-1_tar_gz.htm
>>>
>> I lost connectivity to the drive again, and had to reboot to recover
>> the drive, so it seemed a good time to try out the V30 firmware.
>> Unfortunately, it didn't work any better.  Details are in the
>> attachment.
> 
> Well, I can offer some hope.  The errors you report:
> 
>> aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
>> aic94xx: escb_tasklet_complete: Can't find task (tc=6) to abort!
> 
> Are requests by the sequencer to abort a task because of a protocol
> error.  IBM did some extensive testing with seagate drives and found
> that the protocol errors were genuine and the result of drive firmware
> problems.  IBM released a version of seagate firmware (BA17) to correct
> these.  Unfortunately, your drive identifies its firmware as S513 which
> is likely OEM firmware from another vendor ... however, that vendor may
> have an update which corrects the problem.
> 
> Of course, the other issue is this:
> 
>> aic94xx: escb_tasklet_complete: Can't find task (tc=6) to abort!
> 
> This is a bug in the driver.  It's not finding the task in the
> outstanding list.  The problem seems to be that it's taking the task
> from the escb which, by definition, is always NULL.  It should be taking
> the task from the ascb it finds by looping over the pending queue.
> 
> If you're willing, could you try this patch which may correct the
> problem?  It's sort of like falling off a cliff: if you never go near
> the edge (i.e. you upgrade the drive fw) you never fall off;
> alternatively, it would be nice if you could help me put up guard rails
> just in case.
> 

Well, that made life interesting....
  but didn't seem to fix anything.

The behavior is about the same as before, but with more verbose errors.  I failed one member of the raid and had it rebuild as a test...which hangs for a while and the drive falls off-line.

Please grab the dmesg output in all its gory glory from here: http://wiki.hopnet.net/dokuwiki/lib/exe/fetch.php?media=myit:sas:dmesg-20080218-wpatch-fail.txt.gz

The drive is a Dell OEM drive, but it's not in a Dell system.  There is at least one firmware (S527) upgrade for it, but the Dell loader refuses to load it (because it isn't in a Dell system...)
Does anyone know a generic way to load a new firmware onto a SAS drive?

--Keith
