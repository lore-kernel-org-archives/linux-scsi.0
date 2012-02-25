From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH v2 0/5] [SCSI] ufshcd: UFS Host Controller Driver
Date: Sat, 25 Feb 2012 17:09:28 +0530
Message-ID: <CAKYAXd-N1bO6ru2Xt91oNi7Dw7SW-G6kcqv7=RKfSLNf5SJweA@mail.gmail.com>
References: <1330067945-9128-1-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1330067945-9128-1-git-send-email-santoshsy@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org, sreekumar.c@samsung.com
List-Id: linux-scsi@vger.kernel.org

Hi. Santosh.

The whole patch-set looks good to me.

Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>

2012/2/24 Santosh Y <santoshsy@gmail.com>:
> From: Santosh Yaraganavi <santoshsy@gmail.com>
>
> UFS:
> Universal Flash Storage is a storage specification for flash devices.
> It is aimed to provide a universal storage interface for both
> embedded and removable flash memory based storage in mobile
> devices such as smart phones and tablet computers. The specification
> is defined by JEDEC Solid State Technology Association. UFS is based
> on MIPI M-PHY physical layer standard. UFS uses MIPI M-PHY as the
> physical layer and MIPI Unipro as the link layer.
>
> The main goals of UFS is to provide,
> =C2=A0- Optimized performance:
> =C2=A0 For UFS version 1.0 and 1.1 the target performance is as follo=
ws,
> =C2=A0 Support for Gear1 is mandatory (rate A: 1248Mbps, rate B: 1457=
=2E6Mbps)
> =C2=A0 Support for Gear2 is optional (rate A: 2496Mbps, rate B: 2915.=
2Mbps)
> =C2=A0 Future version of the standard,
> =C2=A0 Gear3 (rate A: 4992Mbps, rate B: 5830.4Mbps)
> =C2=A0- Low power consumption
> =C2=A0- High random IOPs and low latency
>
> UFS Architecture Overview:
> UFS has a layered communication architecture which is based on SCSI
> SAM-5 architectural model.
>
> UFS communication architecture consists of following layers,
>
> * Application Layer: It is composed of UFS command set layer(UCS),
> =C2=A0Task Manager and Device manager. The UFS interface is designed =
to be
> =C2=A0protocol agnostic, however SCSI has been selected as a baseline
> =C2=A0protocol for versions 1.0 and 1.1 of UFS protocol =C2=A0layer.
> =C2=A0UFS supports subset of SCSI commands defined by SPC-4 and SBC-3=
=2E
> =C2=A0- UCS: It handles SCSI commands supported by UFS specification.
> =C2=A0- Task manager: It handles task management functions defined by=
 the
> =C2=A0 =C2=A0UFS which are meant for command queue control.
> =C2=A0- Device manager: It handles device level operations and device
> =C2=A0 =C2=A0configuration operations. Device level operations mainly=
 involve
> =C2=A0 =C2=A0device power management operations and commands to Inter=
connect
> =C2=A0 =C2=A0layers. Device level configurations involve handling of =
query
> =C2=A0 =C2=A0requests which are used to modify and retrieve configura=
tion
> =C2=A0 =C2=A0information of the device.
>
> * UFS Transport Protocol(UTP) layer: UTP layer provides services for
> =C2=A0the higher layers through Service Access Points. UTP defines 3
> =C2=A0service access points for higher layers.
> =C2=A0- UDM_SAP: Device manager service access point is exposed to de=
vice
> =C2=A0 =C2=A0manager for device level operations. These device level =
operations
> =C2=A0 =C2=A0are done through query requests.
> =C2=A0- UTP_CMD_SAP: Command service access point is exposed to UFS c=
ommand
> =C2=A0 =C2=A0set layer(UCS) to transport commands.
> =C2=A0- UTP_TM_SAP: Task management service access point is exposed t=
o task
> =C2=A0 =C2=A0manager to transport task management functions.
> =C2=A0UTP transports messages through UFS protocol information unit(U=
PIU).
>
> * UFS Interconnect Layer(UIC): This is the lowest layer of UFS layere=
d
> =C2=A0architecture. It handles connection between UFS host and UFS de=
vice.
> =C2=A0UIC consists of MIPI UniPro and MIPI M-PHY. UIC provides 2 serv=
ice
> =C2=A0access points to upper layer,
> =C2=A0- UIC_SAP: To transport UPIU between UFS host and UFS device.
> =C2=A0- UIO_SAP: To issue commands to Unipro layers.
>
> UFSHCD:
> The UFS host controller driver is based on Linux SCSI Framework.
> UFSHCD is a low level device driver which acts as an interface betwee=
n
> SCSI Midlayer and PCIe based UFS host controllers.
>
> The current UFSHCD implementation supports following functionality,
> =C2=A0- UFS controller initialization: The initialization module brin=
gs UFS
> =C2=A0 host controller to active state and prepares the controller to
> =C2=A0 transfer commands/response between UFSHCD and UFS device.
> =C2=A0- UTP Transfer requests: Transfer request handling module of UF=
SHCD
> =C2=A0 receives SCSI commands from SCSI Midlayer, forms UPIUs and iss=
ues
> =C2=A0 the UPIUs to UFS Host controller. Also, the module decodes res=
ponses
> =C2=A0 received from UFS host controller in the form of UPIUs and int=
imates
> =C2=A0 the SCSI Midlayer of the status of the command.
> =C2=A0- UFS error handling: Error handling module handles Host contro=
ller
> =C2=A0 fatal errors, Device fatal errors and UIC interconnect layer r=
elated
> =C2=A0 errors.
> =C2=A0- SCSI Error handling: This is done through UFSHCD SCSI error h=
andling
> =C2=A0 routines registered with SCSI Midlayer. Examples of some of th=
e error
> =C2=A0 handling commands issues by SCSI Midlayer are Abort task, Lun =
reset
> =C2=A0 and host reset. UFSHCD Routines to perform these tasks are reg=
istered
> =C2=A0 with SCSI Midlayer through .eh_abort_handler, .eh_device_reset=
_handler
> =C2=A0 and .eh_host_reset_handler.
>
> In this version of UFSHCD Query requests and power management
> functionality are not implemented.
>
> This patchset is successfully applied on 3.3-rc4
>
> UFS Specifications can be found at,
> UFS - http://www.jedec.org/sites/default/files/docs/JESD220.pdf
> UFSHCI - http://www.jedec.org/sites/default/files/docs/JESD223.pdf
>
> Santosh Yaraganavi (5):
> =C2=A0[SCSI] ufshcd: UFS Host controller driver
> =C2=A0[SCSI] ufshcd: UFS UTP Transfer requests handling
> =C2=A0[SCSI] ufshcd: UFSHCI error handling
> =C2=A0[SCSI] ufshcd: SCSI error handling
> =C2=A0Documentation: UFS Host Controller Driver
>
> =C2=A0Documentation/scsi/00-INDEX | =C2=A0 =C2=A02 +
> =C2=A0Documentation/scsi/ufs.txt =C2=A0| =C2=A0 89 ++
> =C2=A0drivers/scsi/Kconfig =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A0=
1 +
> =C2=A0drivers/scsi/Makefile =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A01 +
> =C2=A0drivers/scsi/ufs/Kconfig =C2=A0 =C2=A0| =C2=A0 49 ++
> =C2=A0drivers/scsi/ufs/Makefile =C2=A0 | =C2=A0 =C2=A02 +
> =C2=A0drivers/scsi/ufs/ufs.h =C2=A0 =C2=A0 =C2=A0| =C2=A0207 +++++
> =C2=A0drivers/scsi/ufs/ufshcd.c =C2=A0 | 1985 +++++++++++++++++++++++=
++++++++++++++++++++
> =C2=A0drivers/scsi/ufs/ufshci.h =C2=A0 | =C2=A0376 ++++++++
> =C2=A09 files changed, 2712 insertions(+), 0 deletions(-)
> =C2=A0create mode 100644 Documentation/scsi/ufs.txt
> =C2=A0create mode 100644 drivers/scsi/ufs/Kconfig
> =C2=A0create mode 100644 drivers/scsi/ufs/Makefile
> =C2=A0create mode 100644 drivers/scsi/ufs/ufs.h
> =C2=A0create mode 100644 drivers/scsi/ufs/ufshcd.c
> =C2=A0create mode 100644 drivers/scsi/ufs/ufshci.h
>
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
