From: "Aron Zeh" <ARZEH@de.ibm.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <-> LLDD
 reentrancy
Date: Mon, 26 Aug 2002 19:01:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF7CB8B7A6.7888F8DC-ONC1256C21.005CA55A@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>, Luben Tuikov <luben@splentec.com>, linux-scsi <linux-scsi@vger.kernel.org>



> ARZEH@de.ibm.com said:
> > Does the use of driverfs-names mean that the HBA driver somehow comes
> > into the discovery-loop for devices (e.g. scan_scsis somehow interacts
> > with the HBA driver to determine which driverfs entry to create.)?
>
> Well, scanning is really only for legacy.  Way into the future, I'd like
to
> see hotplug notification for device attach events, so no fibre controller
ever
> need be troubled by the scan.  All they'd do is send a device attach
> notification into SCSI when they detect one.  (SCSI would probably then
turn
> around and ask for a REPORT_LUNS).

Blimey, that was a quick response. Only to spurn some more questions from
me though. Sorry.

If you say scanning is legacy only does that mean you expect it to be gone
by kernel 2.6?
I currently don't know of a way that SCSI devices (LUNs) generate hotplug
notifications by. (FC sends RSCNs and other nasty stuff for ports, which
are one level higher up. I don't think reconfiguring the LUNs behind a port
would generate any message, would it?)
Even of messages are generated, they'd probably differ according to the
underlying hardware. Would HBA drivers have to catch them and use more
generic callbacks to tell the SCSI stack?

Cheers,
Aron

