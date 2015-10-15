From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: advansys needs ISA dma api for ISA support
Date: Thu, 15 Oct 2015 14:09:31 +0200
Message-ID: <561F977B.1030009@suse.de>
References: <5081546.QjQ32dGX2L@wuerfel> <561F96B7.4050300@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <561F96B7.4050300@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, JBottomley@odin.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/15/2015 02:06 PM, Hannes Reinecke wrote:
> On 10/12/2015 05:10 PM, Arnd Bergmann wrote:
>> The advansys drvier uses the request_dma function that is used on IS=
A
>> machines for the internal DMA controller, which causes build errors
>> on platforms that have ISA slots but do not provide the ISA DMA API:
>>
>> drivers/scsi/advansys.c: In function 'advansys_board_found':
>> drivers/scsi/advansys.c:11300:10: error: implicit declaration of fun=
ction 'request_dma' [-Werror=3Dimplicit-function-declaration]
>>
>> The problem now showed up in ARM randconfig builds after commit
>> 6571fb3f8b7f ("advansys: Update to version 3.5 and remove compilatio=
n
>> warning") made it possible to build on platforms that have neither
>> VIRT_TO_BUS nor ISA_DMA_API but that do have ISA.
>>
>> This adds the missing dependency.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index d2f480b04a52..d4aa6a1a806c 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -499,6 +499,7 @@ config SCSI_ADVANSYS
>>  	tristate "AdvanSys SCSI support"
>>  	depends on SCSI
>>  	depends on ISA || EISA || PCI
>> +	depends on ISA_DMA_API || !ISA
>>  	help
>>  	  This is a driver for all SCSI host adapters manufactured by
>>  	  AdvanSys. It is documented in the kernel source in
>>
> Sorry to chime in again, but wouldn't this allow to build on platform=
s
> which have neither ISA_DMA_API nor ISA, like oldish sparc systems wit=
h
> proprietary S-BUS?
>=20
> Why not ISA_DMA_API || EISA || PCI ?
>=20
Gnaa. Ignore this.

Mailer got confused about which mails are more recent than others :-(

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
