From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/22] g_ncr5380: Remove CONFIG_SCSI_GENERIC_NCR53C400
Date: Mon, 14 Mar 2016 08:21:07 +0100
Message-ID: <56E66663.2030704@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042700.855969695@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160314042700.855969695@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> This change brings a number of improvements: fewer macros, better tes=
t
> coverage, simpler code and sane Kconfig options. The downside is a sm=
all
> chance of incompatibility (which seems unavoidable).
>=20
> CONFIG_SCSI_GENERIC_NCR53C400 exists to enable or inhibit pseudo DMA
> transfers when the driver is used with 53C400-compatible cards. Thank=
s to
> Ondrej Zary's patches, PDMA now works which means it can be enabled
> unconditionally.
>=20
> Due to bad design, CONFIG_SCSI_GENERIC_NCR53C400 ties together unrela=
ted
> functionality as it sets both PSEUDO_DMA and BIOSPARAM macros. This p=
atch
> effectively enables PSEUDO_DMA and disables BIOSPARAM.
>=20
> The defconfigs and the Kconfig default leave CONFIG_SCSI_GENERIC_NCR5=
3C400
> undefined. Red Hat 9 and CentOS 2.1 were the same. This leaves both
> PSEUDO_DMA and BIOSPARAM disabled. The effect of this patch should be
> better performance from enabling PSEUDO_DMA.
>=20
> On the other hand, Debian 4 and SLES 10 had CONFIG_SCSI_GENERIC_NCR53=
C400
> enabled, so both PSEUDO_DMA and BIOSPARAM were enabled. This patch mi=
ght
> affect configurations like this by disabling BIOSPARAM. My best guess=
 is
> that this could be a problem only in the vanishingly rare case that
> 1) the CHS values stored in the boot device partition table are wrong=
 and
> 2) a 5380 card is in use (because PDMA on 53C400 used to be broken).
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

And don't worry about SLES10; we won't backport your fixes to _that_.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
