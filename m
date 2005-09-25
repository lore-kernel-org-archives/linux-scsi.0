From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: SATA Drive Information (vs hdparm -i)?
Date: Sun, 25 Sep 2005 07:56:05 -0700 (PDT)
Message-ID: <20050925145605.27822.qmail@web31804.mail.mud.yahoo.com>
References: <4334C56F.8010208@torque.net>
Reply-To: luben_tuikov@adaptec.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4334C56F.8010208@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: dougg@torque.net, Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Richard Bollinger <rabollinger@gmail.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--- Douglas Gilbert <dougg@torque.net> wrote:
> Luben,
> The folks at HP, Intel and WDC seemingly driving the
> SAT draft write in the overview [in sat-r06 section 5.1]
> of the SAT layer (SATL):
> 
> "Examples of SATL implemented in accordance to this
> standard include:
>    a) a SATL contained within a SCSI target ...
>    b) An ATA/ATAPI Host Bus Adapter (HBA) directly
>       connected to ATA/ATAPI devices ...
>    c) A SAS STP initiator port to connect ATA/ATAPI
>       devices ...
> "

Hi Doug,

c) which you quoted: "STP _initiator_ port".
a) refers to FC (very relevant).
In b) you have directly attached ATA devices (to an HBA).

> There are figures (diagrams) of these three later in
> the draft: figure 7 (page 81), figure 5 (page 79) and
> figure 6 (page 80) respectively.

Yes, and figure 6 clearly shows SATL _at_ the _initiator_
port _before_ the STP link.

Figure 7 does indeed point to SATL at the Target port
but the transport is pointed out to be _FC_.

> For point a) they give as examples FCP, SPI and SBP-3
> (but not SAS). One reason for putting a SAT layer in
> a SAS target is multi-initiator and mult-port command
> queuing support (sat-r05 section 6.2.4). Converting
> port multipliers to luns may also be useful

Yes, this is true. (In general I cannot see how we'd
disagree if we read the same document(s).)

_But_, from a _business_ point of view it would be cheaper
to just use STP, as opposed to implement SATL at the
target _and_ use SAS as a transport.(*)

In case of multi-initiator access, one can use Affiliations.
(Issued, of course, at the transaction layer (filesystem).)

(*) Well, that's not necessarily true, since you can
market a SATA+SATL device as SAS device... Not sure
about the margin profit, but there ought to
be a law against that. ;-)

> [Perhaps
> you could confirm this: a 1.5 GB SATA disk chews up
> 3 GB of SAS bandwidth when doing STP data transfers
> (thanks to ALIGNs inserted every other word).]

Over an expander to which you have a G2 connection, yes.

> A RAID
> of SATA disks in a SAS target (enclosure) would be
> another candidate for a SAT layer (with luns > 0 to
> access the individual disks (e.g. for SMART diagnostics)).

_RAID_devices_, not ATA devices.

Yes, in general RAID have so much more freedom like
wide ports, etc, so they'd be expected to do tricks
like this.  Everything behind a RAID device would be
highly vendor specific (and "magical" :-) ).

> Some folks have reported beta testing disks that, via
> firmware download, can change between having a SATA and
> a SAS interface. So I think that what you say is
> basically true, but intelligence is being distributed

Would you buy a SAS hard disk which you know that
firmware can make it SATA?  Would you buy a SATA
hard disk which you know firmware can make it SAS?
How much would you pay for the latter? :-)

    Luben

