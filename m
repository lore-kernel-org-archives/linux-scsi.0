From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: lpfc: fix linking against modular NVMe support
Date: Wed, 22 Mar 2017 09:12:43 +0100
Message-ID: <CAK8P3a1yJZ=N+WpJA_oWhmMzOqo47X2Zpz2Dw92Wwg3nsi+PCA@mail.gmail.com>
References: <20170321131017.2207105-1-arnd@arndb.de> <2d13017a-0342-c22a-5944-991a4b21f053@broadcom.com>
 <79d9052f-c55b-b9a8-d5ae-a66b00c2f8e7@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <79d9052f-c55b-b9a8-d5ae-a66b00c2f8e7@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Finn Thain <fthain@telegraphics.com.au>, Johannes Thumshirn <jthumshirn@suse.de>, James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 22, 2017 at 3:25 AM, James Smart <james.smart@broadcom.com> wrote:
>
> On 3/21/2017 7:23 PM, James Smart wrote:
>>
>> Arnd,
>>
>> All of the build issues, including building as modules, should have been
>> resolved by the following patch:
>> http://www.spinics.net/lists/linux-scsi/msg106102.html
>>
>> Am I missing something ?
>
> Note: the patch I referenced
> (http://www.spinics.net/lists/linux-scsi/msg106102.html) replaced the one I
> think you referenced below
> (http://www.spinics.net/lists/linux-scsi/msg106024.html)

The build error I fixed was on yesterday's linux-next, which has the
http://www.spinics.net/lists/linux-scsi/msg106102.html patch, this is
the one I referenced as 7d7080335f8d ("scsi: lpfc: Finalize Kconfig
options for nvme").

The earlier version from linux-next-20170310 (there was no linux-next
last week) had the same bug but needed a different workaround:

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4bf55b5d78be..52245eb83295 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1256,12 +1256,14 @@ config SCSI_LPFC_DEBUG_FS
 config LPFC_NVME_INITIATOR
  bool "Emulex LightPulse Fibre Channel NVME Initiator Support"
  depends on SCSI_LPFC && NVME_FC
+ depends on SCSI_LPFC=m || NVME_FC=y
  ---help---
   This enables NVME Initiator support in the Emulex lpfc driver.

 config LPFC_NVME_TARGET
  bool "Emulex LightPulse Fibre Channel NVME Initiator Support"
  depends on SCSI_LPFC && NVME_TARGET_FC
+ depends on SCSI_LPFC=m || NVME_TARGET_FC=y
  ---help---
   This enables NVME Target support in the Emulex lpfc driver.
   Target enablement must still be enabled on a per adapter

As a side-note, the patch introduces a slightly unusual construct
using #if (IS_ENABLED(CONFIG_NVME_FC)). This can usually
expressed in a more readable way like this:

--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2190,13 +2192,12 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 void
 lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 {
-#if (IS_ENABLED(CONFIG_NVME_FC))
        struct nvme_fc_local_port *localport;
        struct lpfc_nvme_lport *lport;
        struct lpfc_nvme_rport *rport = NULL, *rport_next = NULL;
        int ret;

-       if (vport->nvmei_support == 0)
+       if (!IS_ENABLED(CONFIG_NVME_FC) || vport->nvmei_support == 0)
                return;

        localport = vport->localport;
@@ -2243,7 +2244,6 @@ lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
                                 "Failed, status x%x\n",
                                 ret);
        }
-#endif
 }

 void


You could also use if(IS_REACHABLE()) here to work around
the link error when CONFIG_NVME_FC=m, but that would make
things a little more confusing for users as it is not immediately
clear why it fails to work at runtime.

      Arnd
