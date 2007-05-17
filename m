From: Peter Jones <pjones@redhat.com>
Subject: Re: Asynchronous scsi scanning
Date: Thu, 17 May 2007 18:24:19 -0400
Message-ID: <464CD613.3090406@redhat.com>
References: <20070513160608.GA29024@redhat.com> <1179072655.3723.42.camel@mulgrave.il.steeleye.com> <1179073116.3723.45.camel@mulgrave.il.steeleye.com> <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com> <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com> <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com> <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com> <1179153096.3703.23.camel@mulgrave.il.steeleye.com> <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com> <17841.simon.1179228389@5ec7c279.invalid> <20070515120228.GI10562@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784AbXEQWYg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2007 18:24:36 -0400
In-Reply-To: <20070515120228.GI10562@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, May 15, 2007 at 12:26:29PM +0100, Simon Arlott wrote:
>> I've already suggested a sysfs attribute - or something equivalent - would
>> be much better. It's just one function that a user might want to run multiple
>> times (e.g. after adding scsi devices?) - why should loading a module be used
>> for this?
> 
> It's easy to suggest a sysfs attribute.  What you've failed to do is
> suggest the pathname of the sysfs attribute, the contents of it, or the
> semantics of it (read-only?  read-write?  write-only?  blocking?)
> 
> My personal favourite would be to add a new verb to /proc/scsi/scsi, but
> James dislikes that idea.
> 
> I'd *really* like to hear from distro people.  What is the most
> convenient way for you to implement "load all the scsi modules, then
> wait until all devices are found"?  James and I had thought that loading
> a new module would be the easiest way for you, but it seems inconvenient
> for you.

Basically we're going to wind up listening for SUBSYSTEM=block hotplug 
events.  What would be helpful is if 
/sys/block/$foo/device/{model,vendor} were populated when we get the 
event (or, since there are good reasons why they're not, if we got 
another event afterwards that said they'd been populated).

Even more helpful if there were also sysfs attributes for serial numbers 
and such from INQUIRY VPD data.  That would make probing for the 
*correct* drive(s) much simpler.

-- 
   Peter
