From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/71] ncr5380: Remove NCR5380_local_declare and
 NCR5380_setup macros
Date: Thu, 19 Nov 2015 08:41:11 +0100
Message-ID: <564D7D17.8060900@suse.de>
References: <20151118083455.331768508@telegraphics.com.au>
 <20151118083456.611699008@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151118083456.611699008@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 11/18/2015 09:35 AM, Finn Thain wrote:
> The NCR5380_local_declare and NCR5380_setup macros exist to define an=
d
> initialize a particular local variable, to provide the address of the
> chip registers needed for the driver's implementation of its
> NCR5380_read/write register access macros.
>
> In cumana_1 and macscsi, these macros generate pointless code like th=
is,
> 	struct Scsi_Host *_instance;
> 	_instance =3D instance;
>
> In pas16, the use of NCR5380_read/write in pas16_hw_detect() requires=
 that
> the io_port local variable has been defined and initialized, but the
> NCR5380_local_declare and NCR5380_setup macros can't be used for that
> purpose because the Scsi_Host struct has not yet been instantiated.
>
> Moreover, these macros were removed from atari_NCR5380.c long ago and
> now they constitute yet another discrepancy between the two core driv=
er
> forks.
>
> Remove these "optimizations".
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
