From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Host Channel TargetId LUN enumeration and scope
Date: Mon, 16 Feb 2009 11:13:03 -0500
Message-ID: <4999908F.6070007@emulex.com>
References: <677131e90902160009r7b1b43f3t53b11c032be28b72@mail.gmail.com>	 <677131e90902160011u5613c7fibf29bb16f68a86a7@mail.gmail.com> <677131e90902160015g2e63a29byb020a98bf7369686@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34214 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbZBPQNJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Feb 2009 11:13:09 -0500
In-Reply-To: <677131e90902160015g2e63a29byb020a98bf7369686@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dheeraj Sangamkar <dheerajrs@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



Dheeraj Sangamkar wrote:
> Hi,
> I am exploring the 2.6.27 linux scsi mid layer and I have a few
> questions. I have code access and can browse reasonably, so you can
> refer to functions and files.
> I would like to know how each of the Host Channel TargetId and LUN are
> enumerated and assigned to each SCSI device.

TargetId is completely logical (up to driver or transport, not 
consistent boot-to-boot, attachment-to-attachment) - excepting on older 
Parallel SCSI adapters.

Lun is whatever the device gives us - but of course, it's munged within 
the midlayer from the SAM 64 bit range into a compressed 32bit range. 
So, the LUN as exported out of the midlayer into the os, etc is also 
somewhat arbitrary, though in general, it will be consistent.  But then 
again, the device names associated with that H:C:T:L is again completely 
arbitrary unless things like udev are used.

> In case, the scsi device is on a storage array, can the TargetId and
> LUN values change for a LUN?

TargetId - on most everything other than Parallel-scsi - yes it can chang.

LUN - even on some storage arrays, the storage entity addressed by LUN 
value Y can change. Some arrays vary the LUN value for the storage 
entity based on the input port they are being accessed by.

> Specifically, during path failures to an FC array, is it possible to
> get a different value of TargetId and LUN id for a SCSI device when it
> reappears when the paths recover?

Absolutely - Especially via 2 separate adapters/paths. There's no such 
thing as believing 2 adapters will derive the same TgtID (usually 
won't), nor that the lun number has to match (usually will).

> Some code reading has led me to believe that the each remote port is
> being viewed as a separate (Target) ID. Why is this so? Dont we
> recognize multiported target SCSI devices?

Sure - but the transport only deals with the explicit transport 
endpoint-to-endpoint connection (e.g. a path, I_T nexus, N_Port_ID to 
N_Port_ID). It's up to other layers (DM) to associate the set of 
connections/paths for things that are multi-ported.

> I have also seen that during remote port time out(possibly due to path
> failures or fabric problems), the remote port related data is not
> discarded. When the remote port is detected by the LLDD,
> scsi_transport_fc compares it with the list of ports it has and
> re-assigns the same state/structure to the newly discovered port. Why
> was this required? Is it to prevent target ID changes across loss of
> connectivity to the (fibre channel) target device?

It was to provide some compatibility for older utilities, that got used 
to the parallel-scsi persistence property of once a target id was seen, 
it could use the same H:C:T:L tuple to talk to it later, even if it went 
away for a while. It's not a guarantee, but mostly works.

> If HBAs are hotpluggable/hot swappable, will the 'host' part of the
> [H,C,I,L] tuple change for a new identical HBA plugged into the same
> slot?

Yes.  And if PCI probe order changes, or new adapter inserted prior to 
next boot, can also change it.  Persistence of H:C:T:L is never 
guaranteed boot-to-boot, or across driver unload/load - and is only 
somewhat given even while the driver stays loaded and attached (it 
becomes a property of the driver and/or transport).

> How are LUN Ids enumerated? Does the order in which the response
> REPORT_LUN command gives LUNs, determine the LUN ID assignment for a
> SCSI disk discovered on a remote target on an array connected via FC?

See the midlayer scan functions - there's sequential look ups or 
ReportLuns use that all depends on scsi-levels reported, and device 
overrides.

Order of response in ReportLuns doesn't really change things relative to 
H:C:T:L, but it may change the device name assignment seen within the 
filesystem.

> Can this order of LUN presentation change and is valid?

I don't think there's any requirement in SAM that says its invalid.

> If REPORT LUNs is not supported and the scsi_transport_fc has to scan
> all possible LU ids, the order is fixed(1 - 2^16). Is this why the LUN
> id does not change for a particular LUN being presented to a host
> across rescans/path-failure-recovery cycles?

No - it's simply a "better" property that based on the storage not 
changing lun to storage entity relationships, and the lun number munging 
into the same value each time (by properties of the LUN value and the 
algorithm), and coupled with same discovery order giving same arbitrary 
device name assignment - things appear consistent.

PS: and please don't make me scan 2^16 (or more) singularly. Support 
SCSI-3 and ReportLUN's.

-- james s

> Thanks in advance,
> Dheeraj
> --
> Simplicity of character is the natural result of profound thought.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
