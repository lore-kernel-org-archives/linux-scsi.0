From: "Mukker, Atul" <Atul.Mukker@lsi.com>
Subject: RE: Recommended HBA management interfaces
Date: Mon, 20 Jul 2009 14:33:54 -0600
Message-ID: <6C678488C5CEE74F813A4D1948FD2DC7A99EFE88@cosmail02.lsi.com>
References: <6C678488C5CEE74F813A4D1948FD2DC7A998698F@cosmail02.lsi.com>
 <4A609A55.9040404@linux.vnet.ibm.com>
 <6C678488C5CEE74F813A4D1948FD2DC7A99EFDC7@cosmail02.lsi.com>
 <4A64A20A.5080908@emulex.com>
 <6C678488C5CEE74F813A4D1948FD2DC7A99EFE16@cosmail02.lsi.com>
 <4A64C0BD.5040503@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:59156 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbZGTUd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2009 16:33:59 -0400
In-Reply-To: <4A64C0BD.5040503@emulex.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Brian King <brking@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The management protocol involves significant amount of binary data transfer involving multiple applications, so sysfs and friends are not useful for this particular application. But I gather from your (and Brian's) email that mid-layer SG extension should be used for this particular purpose.

As for asynchronous notifications, netlink seems to be the de-facto choice (or it's mid-layer extensions). But didn't you mention earlier, vmware would not support this?

Thanks
Atul


> -----Original Message-----
> From: James Smart [mailto:James.Smart@Emulex.Com]
> Sent: Monday, July 20, 2009 3:09 PM
> To: Mukker, Atul
> Cc: Brian King; linux-scsi@vger.kernel.org
> Subject: Re: Recommended HBA management interfaces
> 
> Mukker, Atul wrote:
> > Thanks for restating my original question.
> >
> > 1. What interface should be used by the HBA management applications to
> obtain (non-generic) information from the HBA?
> >
> My opinions:
> 
> sysfs :
>   Pro: Good for singular data items and simple status  (link state, f/w
> rev, etc).
>          Very good for things that really don't need a tool (simplistic
> admin commands):
>              (show state, reset board, etc).
>   Con: Doesn't work well for "transactions" that need multiple data
> elements
>           Lack of insight to process life cycle, thus multi-step and
> concurrent
>              transactions difficult.
>           Doesn't work with binary data, buffers, etc.
>           Difficult to use concurrently by multiple processes.
>           Can't push async info to user.
>           No support for complex things.
>           The list of attributes can get big. Not a big deal, but...
>           Security based on attribute permissions (not always the best
> model)
> 
> configfs:
>   Pro: Basically sysfs but for transactions with multiple data elements
>   Con: (same as sysfs, just minus multiple data element con).
> 
> netlink:
>   Pro: Very good for "multi-cast" operations - pushing async events to
> multiple
>               receivers.
>          Handles requests and responses with multiple data elements easily.
>          Can track per-process life cycles.
>          Socket based so could even support mgmt from a different machine.
>          Security checking easy to build in.
>   Con: Doesn't work well for large payloads.
>          Payloads can't be referenced via data pointer (they need to be
> inline to the pkt).
>          Direct DMA not supported - has to be staged to driver buffer,
> copied in/out
>             of socket.
>          Multi-step transactions doable, but difficult. Maintaining
> relationships per
>             pid difficult.
>          Multiple machines means dealing with endian-ness and data typing.
>          The netlink sockets do have memory-related issues that must be
> watched.
> 
>    Note: to not burn NETLINK id space, and perhaps collide in different
> distro
>         kernels, please use the mid-layers netlink infrastructure, which
> does allow
>         driver-specific messaging.
> 
> bsg:
>   (Specifically the new midlayer sgio support that was recently added
> for ELS passthru)
>   Pro: Support requests and responses with multiple data elements easily
>          Supports separate request and response DMA-able payload buffers
>          Supports big payloads easily
>   Con: Lack of insight to process lifecycle, thus multi-step and
> concurrent
>              transactions difficult.
>           Async response generation (w/o associated request) very
> difficult.
>           It's really a wrappered ioctl, with the midlayer protecting
> the kernel from
>              bad ioctl practice via the way it converts the sgio ioctl
> into a midlayer
>              request. Creates an odd programming interface, as you
> really want to
>              wrapper the ioctl on the user side too.
> 
> Thus, when you look across the pros and cons, its easy to see why the
> transport
> is using different things for different purposes.
> 
> > 2. How should driver notify such applications of asynchronous events
> happening on the HBA?
> >
> This is already there with the midlayer netlink support.  Vendor-unique
> events
> are already supported.
> 
> > Please keep in mind, all the data transfer between the applications and
> the HBA is a private protocol.
> >
> Private or not, the code for the interface use will have to be in the
> driver.  Code will
> be inspected for proper/safe usage of the interfaces.  Coding such that
> things in the
> messaging are black-boxes will always be a point of contention.
> 
> -- james s
> 
> 
> > Thanks
> > Atul Mukker
> >
> >
> >
> >> -----Original Message-----
> >> From: James Smart [mailto:James.Smart@Emulex.Com]
> >> Sent: Monday, July 20, 2009 12:58 PM
> >> To: Mukker, Atul
> >> Cc: Brian King; linux-scsi@vger.kernel.org
> >> Subject: Re: Recommended HBA management interfaces
> >>
> >> FYI - netlink (and sysfs, and I believe debugfs) do not exist with
> >> vmware drivers...   Additionally, with netlink, many of the distros no
> >> longer include libnl by default in their install images.  Even
> >> interfaces that you think exist on vmware, may have very different
> >> semantical behavior (almost all of the transport stuff either doesn't
> >> exist or is only partially implemented).
> >>
> >> One big caveat I'd give you:  It's not so much the interface being used,
> >> but rather, what are you doing over the interface.  One of the goals of
> >> the community is to present a consistent management paradigm for like
> >> things.  Thus, if what you are doing is generic, you should do it in a
> >> generic manner so that all drivers for like hardware can utilize it.
> >> This was the motivation for the protocol transports. Interestingly,
> even
> >> the transports use different interfaces for different things. It all
> >> depends on what it is.
> >>
> >> Lastly, some things are considered bad practice from a kernel safety
> >> point of view. Example: driver-specific ioctls passing around user-
> space
> >> buffer pointers.  In these cases, it doesn't matter what interface you
> >> pick, they'll be rejected.
> >>
> >> -- james s
> >>
> >>
> >> Mukker, Atul wrote:
> >>
> >>> Thanks Brian. Netlink seems to be appropriate for our purpose as well,
> >>>
> >> almost too good :-)
> >>
> >>> That make me think, what's the catch? The SCSI drivers are not heavy
> >>>
> >> usage of this interface for one.
> >>
> >>> Are the other caveats associated with it?
> >>>
> >>> Best regards,
> >>> Atul Mukker
> >>>
> >>>
> >>>
> >>>> -----Original Message-----
> >>>> From: Brian King [mailto:brking@linux.vnet.ibm.com]
> >>>> Sent: Friday, July 17, 2009 11:36 AM
> >>>> To: Mukker, Atul
> >>>> Cc: linux-scsi@vger.kernel.org
> >>>> Subject: Re: Recommended HBA management interfaces
> >>>>
> >>>> Mukker, Atul wrote:
> >>>>
> >>>>
> >>>>> Hi All,
> >>>>>
> >>>>> We would like expert comments on the following questions regarding
> >>>>> management of HBA from applications.
> >>>>>
> >>>>> Traditionally, our drivers create a character device node, whose
> >>>>> file_operations are then used by the management applications to
> >>>>> transfer HBA specific commands. In addition to being quirky, this
> >>>>> interface has a few limitations which we would like to remove, most
> >>>>> important being able to seamlessly handle asynchronous events with
> >>>>> data transfer.
> >>>>>
> >>>>> 1. What is (are) the other standard/recommended interfaces which
> >>>>> applications can use to transfer HBA specific commands and data.
> >>>>>
> >>>>>
> >>>> Depends on what the commands look like. With ipr, the commands that
> >>>> the management application need to send to the HBA look sufficiently
> >>>> like SCSI that I was able to report an sg device node for the adapter
> >>>> and use SG_IO to send these commands.
> >>>>
> >>>> sysfs, debugfs, and configfs are options as well.
> >>>>
> >>>>
> >>>>
> >>>>
> >>>>> 2. How should an LLD implement interfaces to transmit asynchronous
> >>>>> information to the management applications? The requirement is to be
> >>>>> able to transmit data buffer as well as notifications for events.
> >>>>>
> >>>>>
> >>>> I've had good success with netlink. In my use I only send a
> >>>>
> >> notification
> >>
> >>>> to userspace and let the application send some commands to figure out
> >>>> what happened, but netlink does allow to send data as well. It makes
> it
> >>>> very
> >>>> easy to have multiple concurrent readers of the data, which I've
> found
> >>>> very
> >>>> useful.
> >>>>
> >>>>
> >>>>
> >>>>> 3. The interface should be able to work even if no SCSI devices are
> >>>>> exported to the kernel.
> >>>>>
> >>>>>
> >>>> netlink allows this.
> >>>>
> >>>>
> >>>>
> >>>>> 4. Should work seamlessly across vmware and xen kernels.
> >>>>>
> >>>>>
> >>>> netlink should work here too.
> >>>>
> >>>> -Brian
> >>>>
> >>>> --
> >>>> Brian King
> >>>> Linux on Power Virtualization
> >>>> IBM Linux Technology Center
> >>>>
> >>>>
> >>>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>>
> >>>
> >
> >
