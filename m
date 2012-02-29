From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH v3 0/5] [SCSI] ufshcd: UFS Host Controller Driver
Date: Wed, 29 Feb 2012 12:11:49 +0530
Message-ID: <1330497714-26504-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:65340 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2B2Gn5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Feb 2012 01:43:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org, saugata.das@linaro.org, dsaxena@linaro.org, stephen.doel@linaro.org, venkat@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, girish.shivananjappa@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, sreekumar.c@samsung.com, vinholikatti@gmail.com, linkinjeon@gmail.com, michaelc@cs.wisc.edu, Santosh Yaraganavi <santoshsy@gmail.com>

From: Santosh Yaraganavi <santoshsy@gmail.com>

UFS:
Universal Flash Storage is a storage specification for flash devices.
It is aimed to provide a universal storage interface for both
embedded and removable flash memory based storage in mobile
devices such as smart phones and tablet computers. The specification
is defined by JEDEC Solid State Technology Association. UFS is based
on MIPI M-PHY physical layer standard. UFS uses MIPI M-PHY as the
physical layer and MIPI Unipro as the link layer.

The main goals of UFS is to provide,
 - Optimized performance:
   For UFS version 1.0 and 1.1 the target performance is as follows,
   Support for Gear1 is mandatory (rate A: 1248Mbps, rate B: 1457.6Mbps)
   Support for Gear2 is optional (rate A: 2496Mbps, rate B: 2915.2Mbps)
   Future version of the standard,
   Gear3 (rate A: 4992Mbps, rate B: 5830.4Mbps)
 - Low power consumption
 - High random IOPs and low latency

UFS Architecture Overview:
UFS has a layered communication architecture which is based on SCSI
SAM-5 architectural model.

UFS communication architecture consists of following layers,

* Application Layer: It is composed of UFS command set layer(UCS),
  Task Manager and Device manager. The UFS interface is designed to be
  protocol agnostic, however SCSI has been selected as a baseline
  protocol for versions 1.0 and 1.1 of UFS protocol  layer.
  UFS supports subset of SCSI commands defined by SPC-4 and SBC-3.
  - UCS: It handles SCSI commands supported by UFS specification.
  - Task manager: It handles task management functions defined by the
    UFS which are meant for command queue control.
  - Device manager: It handles device level operations and device
    configuration operations. Device level operations mainly involve
    device power management operations and commands to Interconnect
    layers. Device level configurations involve handling of query
    requests which are used to modify and retrieve configuration
    information of the device.

* UFS Transport Protocol(UTP) layer: UTP layer provides services for
  the higher layers through Service Access Points. UTP defines 3
  service access points for higher layers.
  - UDM_SAP: Device manager service access point is exposed to device
    manager for device level operations. These device level operations
    are done through query requests.
  - UTP_CMD_SAP: Command service access point is exposed to UFS command
    set layer(UCS) to transport commands.
  - UTP_TM_SAP: Task management service access point is exposed to task
    manager to transport task management functions.
  UTP transports messages through UFS protocol information unit(UPIU).

* UFS Interconnect Layer(UIC): This is the lowest layer of UFS layered
  architecture. It handles connection between UFS host and UFS device.
  UIC consists of MIPI UniPro and MIPI M-PHY. UIC provides 2 service
  access points to upper layer,
  - UIC_SAP: To transport UPIU between UFS host and UFS device.
  - UIO_SAP: To issue commands to Unipro layers.

UFSHCD:
The UFS host controller driver is based on Linux SCSI Framework.
UFSHCD is a low level device driver which acts as an interface between
SCSI Midlayer and PCIe based UFS host controllers.

The current UFSHCD implementation supports following functionality,
 - UFS controller initialization: The initialization module brings UFS
   host controller to active state and prepares the controller to
   transfer commands/response between UFSHCD and UFS device.
 - UTP Transfer requests: Transfer request handling module of UFSHCD
   receives SCSI commands from SCSI Midlayer, forms UPIUs and issues
   the UPIUs to UFS Host controller. Also, the module decodes responses
   received from UFS host controller in the form of UPIUs and intimates
   the SCSI Midlayer of the status of the command.
 - UFS error handling: Error handling module handles Host controller
   fatal errors, Device fatal errors and UIC interconnect layer related
   errors.
 - SCSI Error handling: This is done through UFSHCD SCSI error handling
   routines registered with SCSI Midlayer. Examples of some of the error
   handling commands issues by SCSI Midlayer are Abort task, Lun reset
   and host reset. UFSHCD Routines to perform these tasks are registered
   with SCSI Midlayer through .eh_abort_handler, .eh_device_reset_handler
   and .eh_host_reset_handler.

In this version of UFSHCD Query requests and power management
functionality are not implemented.

This patchset is successfully applied on 3.3-rc5

UFS Specifications can be found at,
UFS - http://www.jedec.org/sites/default/files/docs/JESD220.pdf
UFSHCI - http://www.jedec.org/sites/default/files/docs/JESD223.pdf

Santosh Yaraganavi (5):
  [SCSI] ufshcd: UFS Host controller driver
  [SCSI] ufshcd: UFS UTP Transfer requests handling
  [SCSI] ufshcd: UFSHCI error handling
  [SCSI] ufshcd: SCSI error handling
  Documentation: UFS Host Controller Driver

 Documentation/scsi/00-INDEX |    2 +
 Documentation/scsi/ufs.txt  |  133 +++
 drivers/scsi/Kconfig        |    1 +
 drivers/scsi/Makefile       |    1 +
 drivers/scsi/ufs/Kconfig    |   49 ++
 drivers/scsi/ufs/Makefile   |    2 +
 drivers/scsi/ufs/ufs.h      |  207 +++++
 drivers/scsi/ufs/ufshcd.c   | 1978 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshci.h   |  376 ++++++++
 9 files changed, 2749 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/scsi/ufs.txt
 create mode 100644 drivers/scsi/ufs/Kconfig
 create mode 100644 drivers/scsi/ufs/Makefile
 create mode 100644 drivers/scsi/ufs/ufs.h
 create mode 100644 drivers/scsi/ufs/ufshcd.c
 create mode 100644 drivers/scsi/ufs/ufshci.h

-- 
1.7.5.4

