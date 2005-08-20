From: James.Smart@Emulex.Com
Subject: RE: [PATCH] minimal SAS transport class
Date: Sat, 20 Aug 2005 00:15:41 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A40@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41163 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030205AbVHTEQV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Aug 2005 00:16:21 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: luben_tuikov@adaptec.com
Cc: hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

> > This is a heck of a statement... The customers don't see it 
> as SAS vs FC
> > vs SPI, they just see it as SCSI, and there's a lot of 
> expectations on
> > consistent behavior. We take a lot of heat defending the community's
> > position, even from companies that you would have thought 
> had signed on
> > to the 2.6 behaviors.
> 
> I tried to understand this paragraph in the light of the very 
> few past days,
> but I couldn't.  What is it actually saying?
> 
> > I understand the need to push folks to the new 2.6 models, 
> but I fully
> > expect the same complaints to come from the users of SAS 
> and iSCSI as well.
> 
> What kind of complaints?
> 
> I ask because I'm a "user of SAS and iSCSI".

Ok, so I guess I owe you a response. I hesitate, as this discussion
always becomes larger than it should.

There are 2 key points:
- the target id is logical for everything but SPI
- following old SPI behavior, users expect the same devices to
  be enumerated at the same target ids, regardless of whether
  that enumeration is at the next link event, driver load/unload,
  or system reboot. The corollary for this is that the device's
  name should have remained the same as well.

For FC, target ids are typically assigned to devices on a
1st-seen-1st-assigned basis. For several reasons, there can be
changes in port discovery order after link events (cable pulls,
etc). For 2.4 kernels, the driver typically maintained a mapping
within the driver to ensure the same device showed up at the same
target id, even if it disappeared for some amount of time. If FC
was the boot device, wacky methods were used to ensure the mapping
persisted boot-to-boot.

For 2.6 kernels, the desire is to move away from relying on the
physical addressing. The recommendation is to use udev (preferred)
or filesystem labels (ok in some circumstances) to find the right
devices. By moving to lun/device-level id's, issues such as name
shift are better solved (note: name-shift still existed under 2.4).

We have found users having difficulty with the udev transition, as:
- From 2.4 history, old scsi behavior, and other unix's behavior
  (which functions much like 2.4), they are accustomed to not
  needing external tools or admin steps for device nameing.
  Things had just worked for the most part.
- Most view 2.6 as an upgrade and didn't expect something this
  basic to change.
- Many really don't know about or understand udev, hotplug,
  disk identifiers, and so on. Thus, there's a large education
  effort. It has to be dealt with in yet more documentation,
  help lines, etc.
- There are some real challenges in supporting a udev-named boot
  device. For the most part, it's a distro issue, which is becoming
  better. PS: for $10, name a 2.6 distro that uses udev out
  of the box for disk names and its installation. For $10 more, 
  can it install/boot from one?
- For better or worse, tools and api's exist that interacted with
  the old 2.4-style behavior. Now they must wait for the tools to
  be updated, suffer their non-functionality, and/or craft their
  own tools.
- Some of these vendors come from large disk farms, and in several
  cases, the disk farms change frequently. Thus, they must flush
  and regenerate their udev configurations on each change. Not a
  fun process.
- Most could care less about, or don't understand, the technical
  justifications for the new 2.6 behaviors. Thus, they push their
  vendors for same-style behaviors as 2.4 regardless of the 2.6
  stance.

Now - back to Christoph's point....

For iSCSI, (correct me if I'm wrong) as the scsi_host is mapped 1:1
with the session, there really is no such thing as multiple targets,
so it works. Even if it isn't 1:1, it is controlled via user space
so it's likely managable. Note: instead of target id shifting, there
may now be scsi_host number shifting.

For SAS, looking at Christoph's code - 
The target id comes from the LLDD. So either the LLDD maintains a
map of SAS port addresses to target ids, or the mapping could change,
same as FC. Christoph's argument is that FC's issue was historical.
SAS is sufficiently new that folks are now smart enough to use udev.
My contention is that people will expect the same behavior out of
SAS as they did w/ FC. To them its all "just SCSI".

I'm winded. Hope this helps.

-- james s
