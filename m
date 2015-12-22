From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 50/77] ncr5380: Change instance->host_lock to
 hostdata->lock
Date: Tue, 22 Dec 2015 08:46:41 +0100
Message-ID: <5678FFE1.10600@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011751.575811401@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011751.575811401@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> NCR5380.c presently uses the instance->host_lock spin lock. Convert t=
his
> to a new spin lock that protects the NCR5380_hostdata struct.
>
> atari_NCR5380.c previously used local_irq_save/restore() rather than =
a
> spin lock. Convert this to hostdata->lock in irq mode. For SMP platfo=
rms,
> the interrupt handler now also acquires the spin lock.
>
> This brings all locking in the two core drivers into agreement.
>
> Adding this locking also means that a bunch of volatile qualifiers ca=
n be
> removed from the members of the NCR5380_hostdata struct. This is done=
 in
> a subsequent patch.
>
> Proper locking will allow the abort handler to locate a command being
> aborted. This is presently impossible if the abort handler is invoked=
 when
> the command has been moved from a queue to a pointer on the stack. (I=
f
> eh_abort_handler can't determine whether a command has been completed
> or is still being processed then it can't decide whether to return
> success or failure.)
>
> The hostdata spin lock is now held when calling NCR5380_select() and
> NCR5380_information_transfer(). Where possible, the lock is dropped f=
or
> polling and PIO transfers.
>
> Clean up the now-redundant SELECT_ENABLE_REG writes, that used to pro=
vide
> limited mutual exclusion between information_transfer() and reselect(=
).
>
> Accessing hostdata->connected without data races means taking the loc=
k;
> cleanup these accesses.
>
> The new spin lock falls away for m68k and other UP builds, so this sh=
ould
> have little impact there. In the SMP case the new lock should be
> uncontested even when the SCSI bus is contested.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
