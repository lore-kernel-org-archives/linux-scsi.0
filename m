From: "Aron Zeh" <ARZEH@de.ibm.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <-> LLDD
 reentrancy
Date: Mon, 26 Aug 2002 18:29:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFA9BD559F.ACA1BDCD-ONC1256C21.005981BE@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi <linux-scsi@vger.kernel.org>


> ARZEH@de.ibm.com said:
> > To me all of the proposed changes look good. The one above I'd be
> > interested in particularly. It would help sorting out a lot of woes we
> > had with writing a fibre-channel HBA driver. For fibre-channel LUNs
> > and port IDs (WWPN) are 64-bit and depending on configuration, high
> > values can be (and in our case are) common.
>
> Actually, I'd like to see us moving towards adopting the capabilities of
> driverfs for this.
>
> PUN is to all intents and purposes now an abstraction in the FC realm.
LUNs
> too, as long as they retain the grouping abstraction with PUNs.  The mid
layer
> really doesn't need to know what these are (there are a few pieces of
code
> that populate the LUN field for SCSI-1 devices that would need rework).
All
> the mid layer really needs is the Scsi_Device structure that describes an

> individual LUN (and some knowledge of LUN and PUN grouping for reset
action
> prediction).  It doesn't need to know or care about the current PUN and
LUN
> numbers.
>
> If FC drivers move straight to using driverfs, you can populate the
driverfs
> names with whatever is meaningful to you for PUN (WWN, portid etch) and
LUN
> and thus avoid this problem (and also the mapping code most have to take
these
> to and from the PUN/LUN numbers).  Since driverfs is a tree, the PUN/LUN
> division is done in a directory (and could, theoretically be done on more
than
> just a two level split).
>
> James

James, there are some things that I don't fully understand, yet.

Does the use of driverfs-names mean that the HBA driver somehow comes into
the discovery-loop for devices (e.g. scan_scsis somehow interacts with the
HBA driver to determine which driverfs entry to create.)?
Shouldn't there be some sort of rule for LUN (or unit) naming within at
least the same hardware class? That is for: parallel, iSCSI, FC, etc.
Will the SCSI stack automatically try to discover all devices behind the
HBA (e.g, on the FC SAN)? Or will there be an interface to restrict the
range, etc?
Lastly, how will you keep track of LUNs in the SCSI stack? Will the current
LUN field disappear in favour of a generic character string?

Cheers,
Aron





