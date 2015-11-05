From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/3] ibmvscsi: Allow to configure maximum LUN
Date: Thu, 05 Nov 2015 09:51:37 +0100
Message-ID: <563B1899.6050308@suse.de>
References: <1446632451-22365-1-git-send-email-lvivier@redhat.com> <1446632451-22365-4-git-send-email-lvivier@redhat.com> <5639E904.1070100@suse.de> <5639F020.4010308@redhat.com> <563A01CC.20809@suse.de> <563A8F83.7010601@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010502040501080905080906"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <563A8F83.7010601@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, Laurent Vivier <lvivier@redhat.com>, martin.petersen@oracle.com
Cc: tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010502040501080905080906
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 11/05/2015 12:06 AM, Brian King wrote:
> On 11/04/2015 07:02 AM, Hannes Reinecke wrote:
>> On 11/04/2015 12:46 PM, Laurent Vivier wrote:
>>>
>>>
>>> On 04/11/2015 12:16, Hannes Reinecke wrote:
>>>> On 11/04/2015 11:20 AM, Laurent Vivier wrote:
>>>>> QEMU allows until 32 LUNs.
>>>>>
>>>>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>>>>> ---
>>>>>  drivers/scsi/ibmvscsi/ibmvscsi.c | 5 ++++-
>>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
>>>>> index 04de287..4480d3e 100644
>>>>> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
>>>>> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
>>>>> @@ -84,6 +84,7 @@
>>>>>   */
>>>>>  static int max_id = 64;
>>>>>  static int max_channel = 3;
>>>>> +static int max_lun = 8;
>>>>>  static int init_timeout = 300;
>>>>>  static int login_timeout = 60;
>>>>>  static int info_timeout = 30;
>>>>> @@ -117,6 +118,8 @@ module_param_named(fast_fail, fast_fail, int, S_IRUGO | S_IWUSR);
>>>>>  MODULE_PARM_DESC(fast_fail, "Enable fast fail. [Default=1]");
>>>>>  module_param_named(client_reserve, client_reserve, int, S_IRUGO );
>>>>>  MODULE_PARM_DESC(client_reserve, "Attempt client managed reserve/release");
>>>>> +module_param(max_lun, int, S_IRUGO);
>>>>> +MODULE_PARM_DESC(max_lun, "Maximum LUN value [Default=8]");
>>>>>  
>>>>>  static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
>>>>>  				struct ibmvscsi_host_data *hostdata);
>>>>> @@ -2289,7 +2292,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>>>>>  		goto init_pool_failed;
>>>>>  	}
>>>>>  
>>>>> -	host->max_lun = 8;
>>>>> +	host->max_lun = max_lun;
>>>>>  	host->max_id = max_id;
>>>>>  	host->max_channel = max_channel;
>>>>>  	host->max_cmd_len = 16;
>>>>>
>>>> Please, don't do this.
>>>>
>>>> 'max_lun' should only be set if the HBA / transport has some hard
>>>> limitations on the number of bytes it can use.
>>>> Otherwise the scanning algorithm in scsi_scan.c should do the
>>>> correct thing, independent on the 'max_lun' setting.
>>>
>>> So you are saying we can remove the line ?
>>>
>> Ho-hum. In principle you could, as ibmvscsi is using SRP internally,
>> which does support 64 bit LUNs.
>>
>> However, due to some weird design decisions there is
>> the function 'lun_from_dev()', which mangles the incoming LUN number
>> into something ... else.
>> Which leaves only 4 bits free for the actual LUN number, requiring
>> you to use max_lun = 16.
>>
>> Personally I would just do away with that function and use the
>> incoming LUN numbers as is.
> 
> I pulled out my copy of SAM, what lun_from_dev is doing is translating
> the incoming bus / id / LUN to a LUN in the logical unit addressing format,
> as defined in 4.6.9 of SAM-4.
> 
> --------------------------------------
> |Bit | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
> --------------------------------------
> | n  | (10b) |       Target          |
> --------------------------------------
> | n+1|   Bus     |        LUN        |
> --------------------------------------
> 
> So this means, in the current implementation, we have 6 bits for target (max=63),
> 3 bits for bus (max=7), and 5 bits for LUN (max=31). 
> 
> It might not be a bad idea to enforce these limits on the module parameters. Otherwise
> we'll have a mess when we run through lun_from_dev...
> 
Correct. With the current implementation we need to set max_lun to 31.

> As far as eliminating lun_from_dev and just passing the LUN through, I don't think we
> can do that. The LUN list returned by Report LUNs to a VSCSI disk assumes we are
> doing the translation above.
> 
? How can that be ?
REPORT LUNs will give you a list of available LUNs _from that target_.
As the SCSI stack now moved to handle full 64bit LUNs the values
from REPORT LUNs will be used as-is (well, byte-swapped, but still).

Can you test with the attached patch?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

--------------010502040501080905080906
Content-Type: text/x-patch;
 name="0001-ibmvscsi-Allow-64bit-LUNs.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-ibmvscsi-Allow-64bit-LUNs.patch"

=46rom 42d920e9ff2a4739d4a901e033a93364586c840c Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Thu, 5 Nov 2015 09:50:23 +0100
Subject: [PATCH] ibmvscsi: Allow 64bit LUNs

The SRP protocol allows full 64bit LUNs, so there is no need
to mangle the LUNs in the driver.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibm=
vscsi.c
index 6a41c36..0162b1d 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1019,16 +1019,6 @@ static void handle_cmd_rsp(struct srp_event_struct=
 *evt_struct)
 }
=20
 /**
- * lun_from_dev: - Returns the lun of the scsi device
- * @dev:	struct scsi_device
- *
-*/
-static inline u16 lun_from_dev(struct scsi_device *dev)
-{
-	return (0x2 << 14) | (dev->id << 8) | (dev->channel << 5) | dev->lun;
-}
-
-/**
  * ibmvscsi_queue: - The queuecommand function of the scsi template=20
  * @cmd:	struct scsi_cmnd to be executed
  * @done:	Callback function to be called when cmd is completed
@@ -1040,7 +1030,6 @@ static int ibmvscsi_queuecommand_lck(struct scsi_cm=
nd *cmnd,
 	struct srp_event_struct *evt_struct;
 	struct srp_indirect_buf *indirect;
 	struct ibmvscsi_host_data *hostdata =3D shost_priv(cmnd->device->host);=

-	u16 lun =3D lun_from_dev(cmnd->device);
 	u8 out_fmt, in_fmt;
=20
 	cmnd->result =3D (DID_OK << 16);
@@ -1053,7 +1042,7 @@ static int ibmvscsi_queuecommand_lck(struct scsi_cm=
nd *cmnd,
 	memset(srp_cmd, 0x00, SRP_MAX_IU_LEN);
 	srp_cmd->opcode =3D SRP_CMD;
 	memcpy(srp_cmd->cdb, cmnd->cmnd, sizeof(srp_cmd->cdb));
-	int_to_scsilun(lun, &srp_cmd->lun);
+	int_to_scsilun(cmnd->device->lun, &srp_cmd->lun);
=20
 	if (!map_data_for_srp_cmd(cmnd, evt_struct, srp_cmd, hostdata->dev)) {
 		if (!firmware_has_feature(FW_FEATURE_CMO))
@@ -1489,7 +1478,6 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cm=
nd *cmd)
 	union viosrp_iu srp_rsp;
 	int rsp_rc;
 	unsigned long flags;
-	u16 lun =3D lun_from_dev(cmd->device);
 	unsigned long wait_switch =3D 0;
=20
 	/* First, find this command in our sent list so we can figure
@@ -1529,7 +1517,7 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cm=
nd *cmd)
 		/* Set up an abort SRP command */
 		memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
 		tsk_mgmt->opcode =3D SRP_TSK_MGMT;
-		int_to_scsilun(lun, &tsk_mgmt->lun);
+		int_to_scsilun(cmnd->device->lun, &tsk_mgmt->lun);
 		tsk_mgmt->tsk_mgmt_func =3D SRP_TSK_ABORT_TASK;
 		tsk_mgmt->task_tag =3D (u64) found_evt;
=20
@@ -1556,7 +1544,7 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cm=
nd *cmd)
=20
 	sdev_printk(KERN_INFO, cmd->device,
                     "aborting command. lun 0x%llx, tag 0x%llx\n",
-		    (((u64) lun) << 48), (u64) found_evt);
+		    cmd->device->lun, (u64) found_evt);
=20
 	wait_for_completion(&evt->comp);
=20
@@ -1628,7 +1616,6 @@ static int ibmvscsi_eh_device_reset_handler(struct =
scsi_cmnd *cmd)
 	union viosrp_iu srp_rsp;
 	int rsp_rc;
 	unsigned long flags;
-	u16 lun =3D lun_from_dev(cmd->device);
 	unsigned long wait_switch =3D 0;
=20
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
@@ -1652,7 +1639,7 @@ static int ibmvscsi_eh_device_reset_handler(struct =
scsi_cmnd *cmd)
 		/* Set up a lun reset SRP command */
 		memset(tsk_mgmt, 0x00, sizeof(*tsk_mgmt));
 		tsk_mgmt->opcode =3D SRP_TSK_MGMT;
-		int_to_scsilun(lun, &tsk_mgmt->lun);
+		int_to_scsilun(cmnd->device->lun, &tsk_mgmt->lun);
 		tsk_mgmt->tsk_mgmt_func =3D SRP_TSK_LUN_RESET;
=20
 		evt->sync_srp =3D &srp_rsp;
@@ -1677,7 +1664,7 @@ static int ibmvscsi_eh_device_reset_handler(struct =
scsi_cmnd *cmd)
 	}
=20
 	sdev_printk(KERN_INFO, cmd->device, "resetting device. lun 0x%llx\n",
-		    (((u64) lun) << 48));
+		    cmnd->device->lun);
=20
 	wait_for_completion(&evt->comp);
=20
@@ -2289,7 +2276,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, con=
st struct vio_device_id *id)
 		goto init_pool_failed;
 	}
=20
-	host->max_lun =3D 8;
+	host->max_lun =3D 0xFFFF;
 	host->max_id =3D max_id;
 	host->max_channel =3D max_channel;
 	host->max_cmd_len =3D 16;
--=20
1.8.5.6


--------------010502040501080905080906--
