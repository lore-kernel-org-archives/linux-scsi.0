From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 25/77] ncr5380: Rework disconnect versus poll logic
Date: Tue, 22 Dec 2015 08:21:22 +0100
Message-ID: <5678F9F2.4050609@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011744.835515236@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011744.835515236@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> The atari_NCR5380.c and NCR5380.c core drivers differ in their handli=
ng of
> target disconnection. This is partly because atari_NCR5380.c had all =
of
> the polling and sleeping removed to become entirely interrupt-driven,=
 and
> it is partly because of damage done to NCR5380.c after atari_NCR5380.=
c was
> forked. See commit 37cd23b44929 ("Linux 2.1.105") in history/history.=
git.
>
> The polling changes that were made in v2.1.105 are questionable at be=
st:
> if REQ is not already asserted when NCR5380_transfer_pio() is invoked=
, and
> if the expected phase is DATA IN or DATA OUT, the function will sched=
ule
> main() to execute after USLEEP_SLEEP jiffies and then return. The pro=
blems
> here are the expected REQ timing and the sleep interval*. Avoid this =
issue
> by using NCR5380_poll_politely() instead of scheduling main().
>
> The atari_NCR5380.c core driver requires the use of the chip interrup=
t and
> always permits target disconnection. It sets the cmd->device->disconn=
ect
> flag when a device disconnects, but never tests this flag.
>
> The NCR5380.c core driver permits disconnection only when
> instance->irq !=3D NO_IRQ. It sets the cmd->device->disconnect flag w=
hen
> a device disconnects and it tests this flag in a couple of places:
>
> 1. During NCR5380_information_transfer(), following COMMAND OUT phase=
,
>     if !cmd->device->disconnect, the initiator will take a guess as t=
o
>     whether or not the target will then choose to go to MESSAGE IN ph=
ase
>     and disconnect. If the driver guesses "yes", it will schedule mai=
n()
>     to execute after USLEEP_SLEEP jiffies and then return there.
>
>     Unfortunately the driver may guess "yes" even after it has denied
>     the target the disconnection privilege. When the target does not
>     disconnect, the sleep can be beneficial, assuming the sleep inter=
val
>     is appropriate (mostly it is not*).
>
>     And even if the driver guesses "yes" correctly, and the target wo=
uld
>     then disconnect, the driver still has to go through the MESSAGE I=
N
>     phase in order to get to BUS FREE phase. The main loop can do not=
hing
>     useful until BUS FREE, and sleeping just delays the phase transit=
ion.
>
> 2. If !cmd->device->disconnect and REQ is not already asserted when
>     NCR5380_information_transfer() is invoked, the function polls for=
 REQ
>     for USLEEP_POLL jiffies. If REQ is not asserted, it then schedule=
s
>     main() to execute after USLEEP_SLEEP jiffies and returns.
>
>     The idea is apparently to yeild the CPU while waiting for REQ.
>     This is conditional upon !cmd->device->disconnect, but there seem=
s
>     to be no rhyme or reason for that. For example, the flag may be
>     unset because disconnection privilege was denied because the driv=
er
>     has no IRQ. Or the flag may be unset because the device has never
>     needed to disconnect before. Or if the flag is set, disconnection
>     may have no relevance to the present bus phase.
>
> Another deficiency of the existing algorithm is as follows. When the
> driver has no IRQ, it prevents disconnection, and generally polls and
> sleeps more than it would normally. Now, if the driver is going to po=
ll
> anyway, why not allow the target to disconnect? That way the driver c=
an do
> something useful with the bus instead of polling unproductively!
>
> Avoid this pointless latency, complexity and guesswork by using
> NCR5380_poll_politely() instead of scheduling main().
>
> * For g_NCR5380, the time intervals for USLEEP_SLEEP and USLEEP_POLL =
are
>    200 ms and 10 ms, respectively. They are 20 ms and 200 ms respecti=
vely
>    for the other NCR5380 drivers. There doesn't seem to be any reason=
 for
>    this discrepancy. The timing seems to have no relation to the type=
 of
>    adapter. Bizarrely, the timing in g_NCR5380 seems to relate only t=
o one
>    particular type of target device. This patch attempts to solve the
>    problem for all NCR5380 drivers and all target devices.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |  137 ++-----------------------------=
------------
>   drivers/scsi/NCR5380.h       |   11 ---
>   drivers/scsi/atari_NCR5380.c |   24 ++-----
>   drivers/scsi/g_NCR5380.c     |    4 -
>   4 files changed, 15 insertions(+), 161 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
