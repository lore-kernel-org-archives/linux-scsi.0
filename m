From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 19:00:14 +0200
Message-ID: <519CF99E.6010804@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com> <519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org> <519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org> <519C9CBC.3050003@redhat.com> <20130522134134.GA15189@mtj.dyndns.org> <519CD234.40608@redhat.com> <20130522150335.GC2777@thunk.org> <519CE9FE.2030007@redhat.com> <yq1vc6b561q.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394Ab3EVRYH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 13:24:07 -0400
In-Reply-To: <yq1vc6b561q.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Il 22/05/2013 18:32, Martin K. Petersen ha scritto:
>>>>>> "Paolo" == Paolo Bonzini <pbonzini@redhat.com> writes:
> 
> Paolo> First of all, I'll note that SG_IO and block-device-specific
> Paolo> ioctls both have their place.  My usecase for SG_IO is
> Paolo> virtualization, where I need to pass information from the LUN to
> Paolo> the virtual machine with as much fidelity as possible if I choose
> Paolo> to virtualize at the SCSI level.  
> 
> Now there's your problem! Several people told you way back that the SCSI
> virt approach was a really poor choice. The SG_IO permissions problem is
> a classic "Doctor, it hurts when I do this".

Unfortunately, it's not me who does this; I'm the doctor who was told it
hurts.

You have hardware providers selling cloud services that want to run
their own custom backup services from within a VM, which entails having
vendor-specific commands run from within a VM.  Or you have people that
run clusters that are half-physical and half-virtual and want to use the
same /dev/disk/by-id paths in both cases; perhaps, with NPIV, they want
to use one zoning approach for both physical and virtual machines.
Someone else they want to backup to tapes from a VM (for example s390
people who just put everything in a VM, so the distinction of physical
and virtual makes no sense for them).  Some people use virtual machines
as sandboxes, and want to burn the ISOs from the same VMs where they
download the ISOs.  Some people have vendor utilities that only run
under Windows, and want to run them in a VM.

Yes, it hurts when they do this.  But I'm not really in the position to
say "don't do that", especially if the reaction would be to pick another
hypervisor than KVM.

> The kernel's fundamental task is to provide abstraction between
> applications and intricacies of hardware. The right way to solve the
> problem would have been to provide a better device abstraction built on
> top of the block/SCSI infrastructure we already have in place. If you
> need more fidelity, add fidelity to the block layer instead of punching
> a giant hole through it.

That would require implementing:

- a interface to get rich error information

- a bunch of ioctls or syscalls to expose every single command, for
example extended copy or reservations

- a ioctl interface to media changers, similar to /dev/st

- ??? and what to do about vendor specific commands, etc.?

With all this to be done in the kernel, having an implementation of tape
and media changer SCSI targets in the virtual machine monitor ends up
being the easiest part.

Some of these two subtopics have been the subject of proverbially many
LWN.net articles.  The implications on userspace ABI are immense, and so
is the complexity of the task.  There is more than a temptation to take
a shortcut, and it's not by chance IMO that all of VMware, Hyper-V and
Xen did the same (though for Xen it's not upstream) before me.

> I seem to recall that reservations were part of your motivation for
> going the SCSI route in the first place.

Reservations are the main motivation for the possibility to bypass the
whitelist, the other being vendor-specific commands.  UNMAP/WRITE
SAME/COMPARE AND WRITE are the main motivation for per-class whitelists.

> A better approach would have
> been to create a generic reservations mechanism that could be exposed to
> the guest. And then let the baremetal kernel worry about the appropriate
> way to communicate with the physical hardware. Just like we've done with
> reads and writes, discard, write same, etc.

I agree for some cases.  For example, I did mean to send a patch to add
ioctls for BLKPING (test unit ready) and BLKCMPXCHG.  I haven't done yet
also because the huge latency in the review of this series wasn't
exactly encouraging me.

But the kernel is not the right place to provide a C API wrapper for the
whole SCSI standard.

> The fact that burning CDs requires SG_IO in the first place is just a
> symptom that we got that interface totally wrong. cat iso.img > /dev/sr0
> would have been much more in line with how Unix works...

In theory, but how do you do things like formatting, picking one of the
gazillion burning methods or media?  Reality is, you'd have a bunch of
ioctls and a program to use them.  "cat /dev/sg2 > page.jpg" would also
be nice for scanners, but are you going to put SANE into the kernel?

Again, the SG_IO shortcut is a necessity more than a temptation.

Paolo
