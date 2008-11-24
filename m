From: James Smart <James.Smart@Emulex.Com>
Subject: Re: FCoE FIP:  User code or driver module?
Date: Mon, 24 Nov 2008 09:50:12 -0500
Message-ID: <492ABF24.8060805@emulex.com>
References: <49271979.40608@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52485 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYKXOtQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2008 09:49:16 -0500
In-Reply-To: <49271979.40608@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I recommend that FIP stay in kernel.

Main reasons :
- Unless almost all of FCOE is out-of-kernel, including the rest of
   FC discovery, it makes little sense.  Why would you put the initial
   "link" detection, or "link keepalive" in userspace, and not the
   rest of discovery/port state ownership ?
- There will be FCOE adapters, that would prefer the implementation
   be in kernel (don't make them manage/be dependent on a user space
   component).
- If you are booting - it's better if its in-kernel (once again,
   managing an initrd with the component stinks).

But - I'm repeating your justifications, all of which I agree with.

I vote to keep in-kernel.

-- james s


Joe Eykholt wrote:
> Hi all,
> 
> I'm working on one implementation of FIP for FCoE.
> FIP is the FCoE initialization protocol, which is used to discover
> which MAC address to use to get to a Fibre-Channel fabric.  In this
> way it is somewhat like IPv6 neighbor discovery.  It also performs
> keep-alives to detect when connectivity is lost.
> 
> There has been some mention that this should be done in user space
> because the iSCSI equivalent was done that way.  I'd like to know
> your opinions on whether I should go forward with an in-kernel module
> implementation or if that is unlikely to be accepted.
> 
> The protocol is fairly simple, the resulting code adds only 8K
> bytes of text to the FCoE module, and none to the base kernel.
> 
> Here are some rationales for putting this in the FCoE module:
> 
> 1.  It's simpler.  A user-based implementation would have to have
> communication code to talk to the kernel FCoE, to send it
> the parameters learned by discovery.
> 
> 2. It uses less memory. It is required for FCoE and since it
> would be part of the fcoe module it would not
> take kernel memory unless fcoe is in use. It wouldn't need as
> much code space (see 1) or the overhead of a process. A kernel
> implementation should be about 1200 lines or 8K bytes.
> 
> 3.  It is easier to distribute.  In the kernel, it's always in
> sync with the module.  There are no interoperability issues as
> there would be between a user-level implementation and the fcoe
> driver.  Distros would have to take care of more startup issues
> if there were a user-level daemon.
> 
> 4.  It is better for FCoE "HBA"s.  Some FCoE device drivers
> won't have a  netdev interface, so if FIP is user-level,
> they would have to add something to allow them to send and
> receive FIP frames, or add a netlink interface (see point 1).
> 
> 5.  It's easier to keep common between LLDs.
> A user-level implementation may need to be aware of the quirks
> of the various hardware implementations.  The other HBAs coming may be
> forced to do their own implementations in the kernel anyway. or add
> patches to the user-mode implementation, see (3).
> 
> 5.  It simplifies correctness issues.  In the kernel we can hold locks
> so that the state changes decided by FIP and by the upper layers
> can be acted on atomicly.
> 
> 6.  Fewer soft "real-time" issues. FIP involves keep-alives and link-resets,
> which may be critical to system operation.  A user-level process would
> have to address these needs.  The timing isn't too constraining, but
> the process shouldn't be delayed by very much or storage connectivity
> could be lost.  The daemon shouldn't be swapped out, especially
> not to an FCoE drive!
> 
> 7.  The booting story is simpler.  Booting over FCoE would require
> the user-level discovery to be part of initrd, not too hard, but
> something to think about.
> 
> What are the advantages to doing FIP user level?  Simpler development?
> Killable/restartable?  Smaller code size in kernel git trees?
> 
> One point on the user-level side is that if the implementation
> becomes more complex, it simplifies maintenance.
> 
> Here are some references for those who might like to dig into this
> further:
> 
> FIP patch series (now out of date and missing a few bug fixes):
> http://www.open-fcoe.org/pipermail/devel/2008-October/001130.html
> http://www.open-fcoe.org/pipermail/devel/2008-October/001131.html
> http://www.open-fcoe.org/pipermail/devel/2008-October/001132.html
> 
> FCoE doc describing FIP:
> http://www.t11.org/ftp/t11/pub/fc/bb-5/08-569v1.pdf
> 
>         Thanks for your consideration,
>         Joe Eykholt
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
