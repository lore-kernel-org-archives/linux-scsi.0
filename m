From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH v6 9/9] snic:Add Makefile, patch Kconfig, MAINTAINERS
Date: Wed, 27 May 2015 10:02:44 +0000
Message-ID: <D18B9001.266AC%nmusini@cisco.com>
References: <1432711182-17530-1-git-send-email-nmusini@cisco.com>
 <1432711182-17530-10-git-send-email-nmusini@cisco.com>
 <55658BAC.5000009@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-8.cisco.com ([173.37.142.95]:9519 "EHLO
	alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbbE0KCq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2015 06:02:46 -0400
In-Reply-To: <55658BAC.5000009@plexistor.com>
Content-Language: en-US
Content-ID: <D9F7401252AA9C4C82504DB8AC9A6C8B@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi Boaz,

Thank you for reviewing patch. Please find responses inline.



On 27/05/15 2:47 pm, "Boaz Harrosh" <boaz@plexistor.com> wrote:

>On 05/27/2015 10:19 AM, Narsimhulu Musini wrote:
>> Kconfig for kbuild
>> Makefile to build snic module
>>=20
>> Updated MAINTAINERS file
>>=20
>> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
>> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
>> ---
>> * v3
>> - Added additional config section (CONFIG_SNIC_DEBUG_FS) for enablin=
g
>>debugging
>>   functionality.
>>=20
>> * v2
>> - Added compile time flags for debugfs dependent functionality.
>>=20
>>  MAINTAINERS                |  7 +++++++
>>  drivers/scsi/Kconfig       | 17 +++++++++++++++++
>>  drivers/scsi/Makefile      |  1 +
>>  drivers/scsi/snic/Makefile | 21 +++++++++++++++++++++
>>  4 files changed, 46 insertions(+)
>>  create mode 100644 drivers/scsi/snic/Makefile
>>=20
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 2a97e05..368fb76 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -2536,6 +2536,13 @@ L:	linux-scsi@vger.kernel.org
>>  S:	Supported
>>  F:	drivers/scsi/fnic/
>> =20
>> +CISCO SCSI HBA DRIVER
>> +M:	Narsimhulu Musini <nmusini@cisco.com>
>> +M:	Sesidhar Baddela <sebaddel@cisco.com>
>> +L:	linux-scsi@vger.kernel.org
>> +S:	Supported
>> +F:	drivers/scsi/snic/
>> +
>>  CMPC ACPI DRIVER
>>  M:	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>>  M:	Daniel Oliveira Nascimento <don@syst.com.br>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 9c92f41..8baab3f 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -634,6 +634,23 @@ config FCOE_FNIC
>>  	  <file:Documentation/scsi/scsi.txt>.
>>  	  The module will be called fnic.
>> =20
>> +config SCSI_SNIC
>> +	tristate "Cisco SNIC Driver"
>> +	depends on PCI && SCSI && X86_64
>> +	help
>> +	  This is support for the Cisco PCI-Express SCSI HBA.
>> +
>> +	  To compile this driver as a module, choose M here and read
>> +	  <file:Documentation/scsi/scsi.txt>.
>> +	  The module will be called snic.
>> +
>> +config SCSI_SNIC_DEBUG_FS
>> +	bool "Cisco SNIC Driver Debugfs Support"
>> +	depends on SCSI_SNIC && DEBUG_FS
>> +	help
>> +	  This enables to list debugging information from SNIC Driver
>> +	  available via debugfs file system
>> +
>>  config SCSI_DMX3191D
>>  	tristate "DMX3191D SCSI support"
>>  	depends on PCI && SCSI
>> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
>> index 58158f1..f643942 100644
>> --- a/drivers/scsi/Makefile
>> +++ b/drivers/scsi/Makefile
>> @@ -39,6 +39,7 @@ obj-$(CONFIG_LIBFC)		+=3D libfc/
>>  obj-$(CONFIG_LIBFCOE)		+=3D fcoe/
>>  obj-$(CONFIG_FCOE)		+=3D fcoe/
>>  obj-$(CONFIG_FCOE_FNIC)		+=3D fnic/
>> +obj-$(CONFIG_SCSI_SNIC)		+=3D snic/
>>  obj-$(CONFIG_SCSI_BNX2X_FCOE)	+=3D libfc/ fcoe/ bnx2fc/
>>  obj-$(CONFIG_ISCSI_TCP) 	+=3D libiscsi.o	libiscsi_tcp.o iscsi_tcp.o
>>  obj-$(CONFIG_INFINIBAND_ISER) 	+=3D libiscsi.o
>> diff --git a/drivers/scsi/snic/Makefile b/drivers/scsi/snic/Makefile
>> new file mode 100644
>> index 0000000..572102a
>> --- /dev/null
>> +++ b/drivers/scsi/snic/Makefile
>> @@ -0,0 +1,21 @@
>> +obj-$(CONFIG_SCSI_SNIC) +=3D snic.o
>> +
>> +snic-y :=3D \
>> +	snic_attrs.o \
>> +	snic_main.o \
>> +	snic_res.o \
>> +	snic_isr.o \
>> +	snic_ctl.o \
>> +	snic_io.o \
>> +	snic_scsi.o \
>> +	snic_disc.o \
>> +	vnic_cq.o \
>> +	vnic_intr.o \
>> +	vnic_dev.o \
>> +	vnic_wq.o
>> +
>> +ifeq ($(CONFIG_SCSI_SNIC_DEBUG_FS), y)
>> +ccflags-y +=3D -DSNIC_DEBUG_FS
>
>Why do you need an extra define here just use
>CONFIG_SCSI_SNIC_DEBUG_FS in source code directly
Agree, I just want to use a shorter macro in the source.
>
>> +snic-y +=3D snic_debugfs.o \
>> +		snic_trc.o
>> +endif
>>=20
>
>snic-$(CONFIG_SCSI_SNIC_DEBUG_FS) +=3D snic_debugfs.o
If CONFIG_SCSI_SNIC_DEBUGFS is not set, then it leaves a build variable
=B3snic-" in build system. ifeq() avoids such thing.
>
>You do not the  ifeq () thing at all
>
>Cheers
>Boaz
>
Thanks
simha
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
