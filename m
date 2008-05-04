From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Discussion: soft unbinding
Date: Sun, 04 May 2008 12:53:38 +0200
Message-ID: <481D95B2.2040205@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0805032219160.24318-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:43907 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbYEDKyA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 06:54:00 -0400
In-Reply-To: <Pine.LNX.4.44L0.0805032219160.24318-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Sat, 3 May 2008, James Bottomley wrote:
[...]
>> At the beginning
>> of the hotplug debate it was thought there was value in a wait for
>> unplug event ... some PCI busses have a little button you push and then
>> a light lights up to tell you everything's OK and you can remove the
>> card.
>>
>> After a lot of back and forth, it was decided that the best thing for
>> the latter was for userland to quiesce and unmount the filesystem,
>> application or whatever and then tell the kernel it was gone, so in that
>> scenario, the two paths were identical.  I don't think anything's really
>> changed in that regard.
> 
> I still don't understand.  Let's say the user does unmount the
> filesystem and tell the kernel it is gone.  So the LLD calls
> scsi_unregister_host() and from that point on fails every call to
> queuecommand.  Then how does sd transmit its final FLUSH CACHE command
> to the device?  Are you saying that it doesn't need to, since
> unmounting the filesystem will cause a FLUSH CACHE to be sent anyway?

Before a device can be safely detached, there may be other things that 
need to be done besides what umount implies.  But let's have a look at 
the grander picture.

I see the following levels at which userspace can initiate detachment:

    1. Close block device files/ character device files.  E.g. umount
       filesystems.  Since userspace is multiprocess/ multithreaded,
       it has no way to prevent new open()s though.

       IOW userspace is unable to say which particular close() is the
       final one.  Or am I missing something?

    2. Unbind the command set driver (SCSI ULD) from the logical unit
       representation.

       How does 2 relate to 1?  Obviously, open() is guaranteed to be
       impossible after 2.

       Note, nothing prevents step 2 to be performed before step 1.
       IOW it is possible to unbind the ULD while the corresponding
       device file is still open, e.g. a filesystem still mounted.

       Furthermore, step 2 involves the execution of some request for
       purposes like flush write cache, stop motor, unlock drive door.
       These requests are dependent on device type and should be
       configurable by userspace to some degree (e.g. whether to go
       into a low power state if in single initiator mode).  The
       command set driver can ensure that these finalizing requests are
       executed in the desired order.  The sg driver sticks out here in
       so far as it has no knowledge of the device type, hence does not
       emit finalizing requests.

    3. Unbind the transport layer driver from the target port
       representation.

       How does 3 relate to 2?  Step 3 will cause step 2 be performed.
       But depending on which SCSI low-level API calls are used, the
       ULD may be unable to get the finalizing requests of step 2
       through the SCSI core to the LLD, because a core-internal
       state variable may prevent it.  The API documentation is
       unclear about it, IOW the behavior is basically undefined.

    4. Unbind the interconnect layer driver from what corresponded to
       the initiator port.

       Some drivers don't implement 3 and 4 separately.

For the discussion here it is obviously crucial how we want 2 relate to 
1 and how we want 3 relate to 2.

The relationship between 4 and 3 is an extension of the issue and 
interesting for hotpluggable PCI, CardBus, ExpressCard and the likes. 
But unlike 3/2 and 2/1, LLD authors have full control over this since 
the SCSI core is not in the picture here (if we treat the "transport 
attributes" programs as parts of the LLDs, not part of the SCSI core).

Side note:  There are various reference counters involved in the layers 
and partially across the layers.  There is for example the module 
reference count of the LLD which is usually (among else) manipulated 
when the device files of ULDs are open()ed and close()d.  A side effect 
is that module unloading as a special case of unbinding is prevented by 
upper layers as long as the upper layers have business with the device. 
But for now this is only a side effect while the actual purpose of these 
reference counters is really only to prevent dereferencing invalid pointers.


> Or let's put it the other way around.  Suppose the LLD doesn't start
> failing calls to queuecommand until after scsi_unregister_host() 
> returns.  Then what about the commands that were in flight when 
> scsi_unregister_host() was called?  The LLD thinks it owns them, and 
> the midlayer thinks that _it_ owns them and can unilaterally cancel 
> them.  They can't both be right.

Is there an actual problem?  As soon as a scsi_cmnd reached 
.queuecommand(), it is the sole privilege and responsibility of the LLD 
to tell when the scmd is complete from the transport's point of view. 
The SCSI core can at this point ask the LLD to prematurely complete an 
scmd, e.g. by means of .eh_abort_handler().

In my opinion, the LLD should simply process all scmds which it gets by 
.queuecommand() independently of whether unbinding was initiated.  I.e. 
complete them successfully if possible, complete them with failure if 
something went wrong at the transport protocol level, complete them as 
aborted when .eh_abort_handler() and friends requested it.

The SCSI core's low-level API should have guarantees somewhere that 
.queuecommand() will not be called anymore after certain 
scsi_remove_XYZ() calls returned.

Furthermore, I would like it if the SCSI core would allow step 2 to be 
performed as gracefully as possible (i.e. with successful execution of 
all finalizing requests which the ULDs emit) --- either in case of all 
scsi_remove_XYZ()s, or only in case of some possibly new 
scsi_remove_ABC()s if the necessary change/clarification of semantics of 
existing scsi_remove_XYZ() is too problematic for some existing LLDs.
-- 
Stefan Richter
-=====-==--- -=-= --=--
http://arcgraph.de/sr/
