From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] scsi: advansys needs ISA dma api for ISA support
Date: Fri, 16 Oct 2015 14:16:06 +0200
Message-ID: <5620EA86.1090100@suse.de>
References: <4351271.eUtUWpTn54@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4351271.eUtUWpTn54@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/16/2015 02:13 PM, Arnd Bergmann wrote:
> The advansys drvier uses the request_dma function that is used on ISA
> machines for the internal DMA controller, which causes build errors
> on platforms that have ISA slots but do not provide the ISA DMA API:
>=20
> drivers/scsi/advansys.c: In function 'advansys_board_found':
> drivers/scsi/advansys.c:11300:10: error: implicit declaration of func=
tion 'request_dma' [-Werror=3Dimplicit-function-declaration]
>=20
> The problem now showed up in ARM randconfig builds after commit
> 6571fb3f8b7f ("advansys: Update to version 3.5 and remove compilation
> warning") made it possible to build on platforms that have neither
> VIRT_TO_BUS nor ISA_DMA_API but that do have ISA.
>=20
> This adds a dependency to only build the driver on ISA based machines
> if they also support ISA_DMA_API, or if they EISA or PCI are also
> enabled.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
