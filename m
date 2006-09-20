From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Multi-Initiator SAS
Date: Wed, 20 Sep 2006 09:38:14 -0400
Message-ID: <45114446.8080505@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:12479 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751299AbWITNiT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Sep 2006 09:38:19 -0400
Received: from ip-182.60.99.216.dsl-cust.ca.inter.net ([216.99.60.182] helo=[192.168.48.80])
	by pentafluge.infradead.org with esmtpsa (Exim 4.62 #1 (Red Hat Linux))
	id 1GQ2HJ-00015G-O5
	for linux-scsi@vger.kernel.org; Wed, 20 Sep 2006 14:38:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

So it seems that the English word beginning with "affil"
caused my posts to be categorized as spam by vger.kernel.org
Still doesn't make a lot of sense because Darrick replied
to one of my posts with that word repeated from my post.

So this is a test that truncates those words.


-------- Original Message --------
Subject: Re: Multi-Initiator SAS
Date: Tue, 19 Sep 2006 19:54:30 -0400
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
To: linux-scsi@vger.kernel.org
CC: Darrick J. Wong <djwong@us.ibm.com>,  Eric.Moore@lsil.com

Hmm, my initial reply to Darrick didn't seem to
make it to the list, but Darrick and Eric saw it.
The original post is forwarded at the bottom of
this post.


I forgot to mention that the SAS address of the expander is
needed. That is because I set environment variables thus:
# export SMP_UTILS_SAS_ADDR=0x500605b000000af0
# export SMP_UTILS_DEVICE=/dev/mptctl,0
on my test system.

Darrick J. Wong wrote:
<snip>
> # smp_discover --sa=0x50001c1716004000 -m /dev/mptctl
> Device <50001c1716004000>, expander:
>   phy   0:T:attached:[0000000000000000:00]
>   phy   1:T:attached:[0000000000000000:00]
>   phy   2:T:attached:[0000000000000000:00]
>   phy   3:T:attached:[0000000000000000:00]
>   phy   4:T:attached:[50001c1716004005:00  t(STP+SATA)]  1.5 Gbps
>   phy   5:T:attached:[0000000000000000:00]
>   phy   6:T:attached:[0000000000000000:00]
>   phy   7:T:attached:[0000000000000000:00]
>   phy   8:S:attached:[0000000000000000:00]
>   phy   9:S:attached:[0000000000000000:00]
>   phy  10:S:attached:[500062b000002fdc:03  i(SSP+STP+SMP)]  3 Gbps
>   phy  11:S:attached:[500062b000002fdc:02  i(SSP+STP+SMP)]  3 Gbps
>   phy  12:D:attached:[50001c171600400d:00  V i(SSP) t(SSP)]  3 Gbps

Judging from the OUI in the SAS address of the
expander, it is made by Vitesse with 12 external
phys and one "virtual" phy (phy_id 12). As Eric
pointed out 'smp_rep_manufacturer' utility should
tell us the manufacturer and the model of the expander.

Notice that the first 8 expander phys are table routed,
the next 4 are subtractive and the virtual (internal) one
has direct routing. When I was having some problems
someone advised me to keep away from the subtractive
routed phys (not sure why).

3 devices are attached to the expander:
  - a SATA disk (phy id 4)
  - a LSI HBA is attached via a two link wide port
    (expander phy ids 10+11)
  - an internal attachment to a SCSI device that can
    be both an initiator and target (interesting)

There is no sign of an adaptec HBA connected to the expander.
[Have a look at the "smp_discover --multiple --brief" output
 on http://www.torque.net/sg/smp_utils.html for comparison.]

> # smp_rep_phy_sata -p4 --sa=0x50001c1716004000 /dev/mptctl
> Report phy SATA response:
>   phy identifier: 4
>   STP I_T nexus loss occurred: 0
>   affil* supported: 1
>   affil* valid: 1
>   STP SAS address: 0x50001c1716004005
>   register device to host FIS:
>     34 00 50 01 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00
>   affil* STP initiator SAS address: 0x500062b000002fdc

This is SATA specific information on phy id 4. So it looks
like the LSI HBA (0x500062b000002fdc) is holding a "long
term" affil* as I have seen with the expander I test
with. Perhaps Eric could remind me whether the mptsas
LLD or firmware calls the CLOSE(CLEAR AFFIL*) link layer
primitive to end a STP tunnelled ATA command. Anyway the fact
the 'affil* valid' is set will lock thet SATA disk
to that HBA. While there is only one STP initiator (on the
LSI HBA) there is no contention to worry about.

>
> 0x500062b000002fdc is the SAS address of the LSI HBA, so it appears that
> we're in agreement.  Unfortunately, all attempts to access the disk
> result in I/O errors:
>
> end_request: I/O error, dev sda, sector 1024

Well I have been able to talk to a SATA (I+II) disks
attached to a LSI SASx12 expander from either a LSI
(1068e based) HBA or an adaptec 48300 HBA. For both HBAs
I used narrow links. So I would try narrowing the port
between the HBA and the expander
(e.g. 'smp_phy_control -p 11 -o dis ...') to see if that
makes any difference.

After that try another expander.

Doug Gilbert


-------- Original Message --------
Subject: Re: Multi-Initiator SAS
Date: Tue, 19 Sep 2006 15:45:08 -0400
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
To: Darrick J. Wong <djwong@us.ibm.com>
CC: linux-scsi@vger.kernel.org,  Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <451041AA.4060702@us.ibm.com>

Darrick J. Wong wrote:
> Hi everybody!
> 
> Alexis and I connected both a Adaptec 9410 and a LSI 1064E SAS initiator
> to an expander.  Both machines saw the disks attached to the expander,
> and both could send I/Os to the disks.  So far, so good.
> 
> We then connected a SATA disk to the expander.  libsas BUGd up in
> sas_ex_discover_end_dev (sas_expander.c:636):
> 
> BUG_ON(sas_port_add(phy->port) != 0);
> 
> mptsas didn't seem to do anything with the SATA device at all, though
> when we disconnected the SATA disk it recognized that a SATA device went
> away.  We'll have a look at the libsas problem in a jiffy.

Darrick,
The latter effect may be a feature of your expander rather
than a problem with libsas.

With the mptsas driver you can use smp_utils to look
at that expander via /dev/mptctl ('modprobe mptctl' first).
To get an overview of what the expander sees, try:
 # smp_discover -mb /dev/mptctl

Now have a closer look at the expander phy connected
to the SATA disk, assuming that is phy id 3 something like:
 # smp_rep_phy_sata -p 3 /dev/mptctl

What I have been seeing is affil* supported and valid,
and the "affil* STP initiator SAS address" as being
the SAS address of the HBA that can see the SATA disk.

My reading of affil* is that they are short term,
just covering the FIS register write then read associated
with one ATA command. I have been told by an authority on
the matter that they can be much longer term than that
which is exactly what my expander seems to be doing.
It seems like first come first serve, IOW whichever HBA
gets there first.

To make it a fair fight between the two HBAs, try to
disconnect that phy, then send a link reset, and see
who wins (and if that HBA continues to win over several
experiments).

  # smp_phy_control -p 3 -o dis /dev/mptctl
  # smp_phy_control -p 3 -o lr /dev/mptctl


When you think about it, do you really want two ATA hosts
on different machines trying to do NCQ at the same time
to the same SATA disk??

There is something that libsas and/or SAS LLDs may offer to
help this "only one initiator gets the SATA disk" feature:
the ability to exclude a SAS address/phy_id (on an expander)
from its attempts to make a device available.

Doug Gilbert



