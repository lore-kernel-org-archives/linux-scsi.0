From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH/RFC v3] allow userspace to modify scsi command filter
 on per device basis
Date: Wed, 18 Jun 2008 01:01:38 +0200
Message-ID: <48584252.5030901@interlog.com>
References: <6cf6b73e0806152249r19cb405ct9d5a33960e619348@mail.gmail.com>	<20080616151328Q.fujita.tomonori@lab.ntt.co.jp>	<6cf6b73e0806160222g19d7229dl6a650e13ab36c03b@mail.gmail.com> <20080618051447L.fujita.tomonori@lab.ntt.co.jp> <48583074.8010909@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:56588 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762465AbYFQXJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jun 2008 19:09:38 -0400
In-Reply-To: <48583074.8010909@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

Peter Jones wrote:
> FUJITA Tomonori wrote:
> 
>> Well, this changes sg behaviour since sg's allow_ops filter has a
>> access permission different from blk_verify_command filter's.
>  >
>> I guess that the first thing you need to do is that figuring out a
>> proper access permission for each command, which sg maintainer, etc
>> can agree. It's pretty hard and that's the reason why this patch has
>> not been merged for years, I think.
> 
> I don't think this logic is sound.

That depends on your viewpoint.

IMO all command filtering should be dropped **. We now have
ATA commands tunnelled through SCSI commands (e.g. via SAT)
and will soon have encrypted SCSI commands. Are per device
command filters being proposed? If not, why should we have
the same SCSI command filter for a USB BD drive and a SCSI
enclosure services (SES) device controlling a FC array, just
because they are on the same system?

Why do linux kernel developers have such a hangup about
command filtering? If the user has sufficient permissions
on the pass-through device, let them send commands, simple.
Let udev probe the device, and set its permissions according
to udev's policies. Let the target device do command filtering!

Would any sensible user accept Linux if the kernel developers
decided what could and could not be written to a file?

As far as I can see Microsoft only filters one SCSI command
in their SCSI pass-though, that is the EXTENDED COPY command.
That might give security folks a warm feeling inside but
not someone who needs to use that command via that OS.
Faced with that limitation I would ask the SCSI device
supplier to define a vendor specific SCSI command that did
the same as EXTENDED COPY.


We have situations where the device is smart enough to
decide what SCSI commands should be allowed. For example
a RAID presents its logical volume as a /dev/sd* device
and exposes its physical disks as /dev/sg* devices. In that
situation I think that it is sensible for RAID controller
to disallow WRITE (FORMAT, etc) commands that will corrupt
the state of the volume. Meanwhile smartmontools can be used
to monitor the health of the physical drives via /dev/sg*
(or bsg) devices.

> The patch makes it so distros (and individuals, if they're so inclined) 
> can configure the filter correctly for whatever hardware is present, 
> regardless of the kernel's ideas of which commands are correct.  It 
> leaves intact the defaults from the current list used by SG_IO and bsg 
> (and maybe some other interfaces?), which most programs have been using 
> for quite some time.
> 
> If anything, sg is overdue with converting to using the same command 
> filter as other direct-scsi-command mechanisms.  sg_allow_access() is 
> really not something we should be keeping.
> 
> I don't think this is a reason not to merge the patch; in fact, quite 
> the opposite.  This is another case where we've got a specific filter in 
> one code path that doesn't match any of the others.  Fixing it is 
> something that needs to be done.  Making it configurable from the 
> userland at the same time effectively aleviates the pain that could 
> result from doing so.

Sounds like I'm wasting my time.


** So I think sg's command filtering goes too far and the
    block layer's filtering just compounds the silliness (and
    tilts it in the direction of older MMC commands).


Doug Gilbert

