From: Chris Boot <bootc@bootc.net>
Subject: Re: FireWire/SBP2 Target mode
Date: Mon, 06 Feb 2012 14:51:06 +0000
Message-ID: <4F2FE8DA.70502@bootc.net>
References: <4E4BD560.4010806@bootc.net> <4E4D3B88.30003@ladisch.de> <4F29978A.3010707@redhat.com> <20120201224156.0773ebc6@stein> <4F2A55B9.4040005@panasas.com> <4F2A60DC.9030007@ladisch.de> <4F2FD1F4.9050702@bootc.net> <4F2FE705.3070509@ladisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <4F2FE705.3070509@ladisch.de>
Sender: target-devel-owner@vger.kernel.org
To: Clemens Ladisch <clemens@ladisch.de>
Cc: target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Boaz Harrosh <bharrosh@panasas.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/02/2012 14:43, Clemens Ladisch wrote:
> Chris Boot wrote:
>> You can pull the code from:
>> git://github.com/bootc/Linux-SBP-2-Target.git
>
> The TODO file says:
>> * Update Juju so we can get the speed in the fw_address_handler call=
back
>
> What is the speed needed for?

"The speed at which the block write request to the MANAGEMENT_AGENT=20
register is received shall determine the speed used by the target for=20
all subsequent requests to read the initiator=E2=80=99s configuration R=
OM, fetch=20
ORB=E2=80=99s from initiator memory or store status at the initiator=E2=
=80=99s=20
status_FIFO. Command block ORB=E2=80=99s separately specify the speed f=
or=20
requests addressed to the data buffer or page table."

(T10/1155D Revision 4 page 53/54)

> SBP-2 says:
> | The target shall issue data transfer requests with a speed equal to
> | that specified by the spd field in the ORB.
>
> SBP-3 says:
> | The target shall issue data transfer requests with a speed equal to
> | that specified by the controlling spd field, whether in the ORB or =
in
> | a node selector in an associated page table.

>> Please note that you can't then disable a unit until all the targets
>> are logged-out. For Linux this usually means 'rmmod firewire_sbp2'.
>
> That driver should not, by default, log into targets on its own node.

It still tries to and never appears to give up, so this needs=20
blacklisting on the target system until firewire_sbp2 is changed. It's=20
harmless other than filling up the kernel log with error messages.

What I meant, however, is if you connect to the target from a separate=20
Linux system you will be unable to disable the unit on the target syste=
m=20
until the _initiator_ logs out. You can do this on the initiator by=20
unloading the module, which sends a logout request to the target.

HTH,
Chris

--=20
Chris Boot
bootc@bootc.net
