From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <-> LLDD reentrancy
Date: Mon, 26 Aug 2002 10:17:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020826101748.B6694@eng2.beaverton.ibm.com>
References: <OF80DCCDBC.5B147AD9-ONC1256C21.002BB3EE@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <OF80DCCDBC.5B147AD9-ONC1256C21.002BB3EE@de.ibm.com>; from ARZEH@de.ibm.com on Mon, Aug 26, 2002 at 10:02:47AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Aron Zeh <ARZEH@de.ibm.com>
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Aug 26, 2002 at 10:02:47AM +0200, Aron Zeh wrote:
> 
> 
> 
> > * SAM-3 specifies that a LUN is 64 bit. While there may not
> > be any devices which actually even come close to using this
> > huge space, it provides different _addressing__modes_.
> >
> > This very nicely fits LUN virtualization (iSCSI, LUN masking, etc),
> > and would allow one to do magic for storage devices (IP SANs, etc).
> >
> > A 64 bit LUN could be presented to userspace which may/can then
> > present a nice ``picture'' (GUI or what not) of the underlying
> > physical/virtual (depending on the SCSI port name/id) storage
> > network.
> >
> > (E.g. iSCSI communicates 64 bit LUNs only...)
> 
> To me all of the proposed changes look good. The one above I'd be
> interested in particularly. It would help sorting out a lot of woes we had
> with writing a fibre-channel HBA driver. For fibre-channel LUNs and port
> IDs (WWPN) are 64-bit and depending on configuration, high values can be
> (and in our case are) common.
> 
> Aron

Exactly what high values do have you in the LUN? What kind of storage is it? 

I thought the FC ID was 24 bits (or is it 32), why do you need the WWPN?
Or, is this internal to the adapter? If the code was setup in scsi_scan.c
and an adpater (some functional callout to an iterator), the FC ID could
be stored in the Scsi_Device::id.

If we are to add an 8 byte LUN:

We still need to allow a smaller lun for all of the current open source
adapter drivers (AFAIK all open source drivers except the qlogic drivers
use a one byte lun, and the qlogic uses a two byte lun) - either a field
in Scsi_Device and/or Scsi_Cmnd, or a functional interface to get the
equivalent four byte value (and then it can be assigned to a one or two
byte value as is done today) in addition to any new 8 byte lun field.

The Scsi_Host::max_lun usage would have to remain for the old four byte
Scsi_Device::lun, and perhaps for the 8 byte lun - it would be nice if the
adapter could just return "LUN out of bounds" or such, rather than having
to set (via adapter driver code) and check (in the mid-layer) the max_lun
value. Users of the 8 byte lun might be able to set a flag (or overload
max_lun with 0) such that max_lun is not checked. 

There might need to be some sort of result from the adapter that says
"I can't handle any more LUNs", otherwise any scan/probe (even via
REPORT LUNS) might end up with lots of errors (but that might not be
really bad since it would be a first or one-time occurence when hooking
up a many LUN target). This probably is not hit (ever?) today since the
max_lun values are always set so low - even for the qlogic, 255 (I was
not able to up their max without major problems in the driver some time
ago, I haven't tried this with any of the recent qla beta drivers).

Both an 8 byte LUN capable adapter and storage are needed to implement and
test such changes.

-- Patrick Mansfield
