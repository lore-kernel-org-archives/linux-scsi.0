From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Autosense requirement
Date: Mon, 29 Jul 2002 13:48:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D457FF3.C7A02C57@torque.net>
References: <3D453CE8.5A15FCD6@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> 
> How safe am I to assume that SCSI LLDD will return
> autosense for a failed/incomplete command, as per
> SCSI core (mid-layer) error handling requrement?
> (e.g. ide-scsi doesn't return autosense)
> 
> In drafts I'm more and more seeing
> ``targets MUST support and enable autosense.''
> 
> If indeed we put a ``MUST'' requirement on SCSI LLDD
> to support and enable autosense, which will indeed
> streamline things, then this will save me a an _irq_
> spin lock over a simple spin lock...
> 
> What is the future of this requrement?

Luben,
In the lk 2.4 series we have both older "non-eh" lower
level drivers and a few, newer "eh" drivers. In the lk
2.5 series the mid level interface to the older "non-eh"
drivers was dropped.

Hence in the development lk 2.5 series there are many stranded
drivers, including ide-scsi, some of which have been converted "on
the fly". His is an incomplete list of issues to be addressed
in lower level (HBA) driver conversions:
  - "eh" interface [mandatory]
  - io_request_lock displaced by host_lock [mandatory]
  - PCI memory/DMA interface
  - driverfs aware
  - autosense for high performance drivers (perhaps all)

As you point out autosense support (at the device level)
is now mandatory in recent scsi drafts/standards. For
simplicity of queueing logic, the sense buffer should not
be left for the mid level to fetch (with a REQUEST SENSE).

I have attempted the conversion on several HBA drivers
(of which scsi_debug is the only one I maintain). As Ben
LaHaise has pointed out, I have skipped addressing the
"PCI memory/DMA interface" so far.

Until Doug Ledford pointed out recently what lower level 
drivers should do with regard to autosense, I was unaware
what to do. Since that time I have converted scsi_debug
to do autosense properly and submitted a patch for the
drivers/scsi/scsi_mid_low_api.txt documentation file.

Now would someone else like to step up to the plate
(or "wicket" to use the cricket metaphor) and try and
get the ide-scsi driver in lk 2.5 to do autosense?


If kernel people think that a ide-scsi "like" driver is 
going away then perhaps they should consider the new SAS
(SCSI over Serial ATA infrastructure) draft. They have
one mode illustrated in that document where the initiator
is a SCSI host and it talks to multiple serial ATA
disks via an "expander". Could be interesting.

Doug Gilbert

