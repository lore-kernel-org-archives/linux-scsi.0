From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 04/11] megaraid_sas : Firmware crash dump feature support
Date: Wed, 10 Sep 2014 17:42:49 +0530
Message-ID: <55ba5d7cdee7dbcce18dc1a2bbbefc03@mail.gmail.com>
References: <201409061328.s86DS6lO012975@palmhbs0.lsi.com> <540F22A2.3040906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og116.obsmtp.com ([64.18.2.219]:34885 "EHLO
	exprod7og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaIJMMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 08:12:52 -0400
Received: by mail-qa0-f52.google.com with SMTP id m5so779607qaj.11
        for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2014 05:12:50 -0700 (PDT)
In-Reply-To: <540F22A2.3040906@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>, aradford@gmail.com

>-----Original Message-----
>From: Tomas Henzl [mailto:thenzl@redhat.com]
>Sent: Tuesday, September 09, 2014 9:24 PM
>To: Sumit.Saxena@avagotech.com; linux-scsi@vger.kernel.org
>Cc: martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com;
>aradford@gmail.com
>Subject: Re: [PATCH 04/11] megaraid_sas : Firmware crash dump feature
>support
>
>On 09/06/2014 03:25 PM, Sumit.Saxena@avagotech.com wrote:
>> This feature will provide similar interface as kernel crash dump fea=
ture.
>> When megaraid firmware encounter any crash, driver will collect the
>> firmware raw image and dump it into pre-configured location.
>>
>> Driver will allocate two different segment of memory.
>> #1 Non-DMA able large buffer (will be allocated on demand) to captur=
e
>actual FW crash dump.
>> #2 DMA buffer (persistence allocation) just to do a arbitrator job.
>>
>> Firmware will keep writing Crash dump data in chucks of DMA buffer
>> size into #2, which will be copy back by driver to the host memory a=
s
>described in #1.
>>
>> Driver-Firmware interface:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> A.) Host driver can allocate maximum 512MB Host memory to store cras=
h
>dump data.
>>
>> This memory will be internal to the host and will not be exposed to =
the
>Firmware.
>> Driver may not be able to allocate 512 MB. In that case, driver will
>> do possible memory (available at run time) allocation to store crash=
 dump
>data.
>>
>> Let=E2=80=99s call this buffer as Host Crash Buffer.
>>
>> Host Crash buffer will not be contigious as a whole, but it will hav=
e
>> multiple
>chunk of contigious memory.
>> This will be internal to driver and firmware/application are unaware=
 of
>> it.
>> Partial allocation of Host Crash buffer may have valid information t=
o
>> debug depending upon what was collected in that buffer and depending=
 on
>nature of failure.
>>
>> Complete Crash dump is the best case, but we do want to capture part=
ial
>buffer just to grab something rather than nothing.
>> Host Crash buffer will be allocated only when FW Crash dump data is
>> available, and will be deallocated once application copy Host Crash
>> buffer to
>the file.
>> Host Crash buffer size can be anything between 1MB to 512MB. (It wil=
l
>> be multiple of 1MBs)
>>
>>
>> B.) Irrespective of underlying Firmware capability of crash dump
>> support, driver will allocate DMA buffer at start of the day for eac=
h MR
>controllers.
>> Let=E2=80=99s call this buffer as =E2=80=9CDMA Crash Buffer=E2=80=9D=
=2E
>>
>> For this feature, size of DMA crash buffer will be 1MB.
>> (We will not gain much even if DMA buffer size is increased.)
>>
>> C.) Driver will now read Controller Info sending existing dcmd
>=E2=80=9CMR_DCMD_CTRL_GET_INFO=E2=80=9D.
>> Driver should extract the information from ctrl info provided by
>> firmware and figure out if firmware support crash dump feature or no=
t.
>>
>> Driver will enable crash dump feature only if =E2=80=9CFirmware supp=
ort Crash
>> dump=E2=80=9D + =E2=80=9CDriver was able to create DMA Crash Buffer=E2=
=80=9D.
>>
>> If either one from above is not set, Crash dump feature should be di=
sable
>> in
>driver.
>> Firmware will enable crash dump feature only if =E2=80=9CDriver Send=
 DCMD-
>MR_DCMD_SET_CRASH_BUF_PARA with MR_CRASH_BUF_TURN_ON=E2=80=9D
>>
>> Helper application/script should use sysfs parameter fw_crash_xxx to
>> actually copy data from host memory to the filesystem.
>
>Is it possible to store the crash dump data on filesystem on the same
>controller after the controller has crashed or do you expect that a us=
e of
>another disk/controller?

The location where crash dump is to collected is configurable via confi=
g
file of application collecting dump.
Default config file settings is crash data will be collected on disk, o=
n
which OS is booted up.
If Online controller reset(OCR) is enabled in crashed controller and OS=
 disk
is behind same controller, crash data
Will be collected on same controller's filesystem.
There is one case, where crashed controller has OCR disabled and OS is
behind the crashed controller, crash data needs to collected behind
some other storage, then location of crash data collection needs to be
configured to some other disk.
Reason for the same is: crashed controller will be functional only afte=
r
system reboot and we need to collect data before system reboot,
so crash data needs to be collected behind disk, which is not on crashe=
d
controller.

>With several controllers in a system this may take a lot memory, could=
 you
>also
>in case when a kdump kernel is running lower it, by not using this fea=
ture?
>
Agreed, we will disable this feature for kdump kernel by adding
"reset_devices" global varaiable.
That check is required for only one place, throughout the code, this fe=
ature
will remain disabled.
Code snippet for the same-

        instance->crash_dump_drv_support =3D (!reset_devices) &&
crashdump_enable &&
                                instance->crash_dump_fw_support &&
                                instance->crash_dump_buf);
        if(instance->crash_dump_drv_support) {
                printk(KERN_INFO "megaraid_sas: FW Crash dump is
supported\n");
                megasas_set_crash_dump_params(instance,
MR_CRASH_BUF_TURN_OFF);

        } else {
=2E.
        }

>see other comments inside
>
>>
>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas.h        |  58 +++++-
>>  drivers/scsi/megaraid/megaraid_sas_base.c   | 292
>+++++++++++++++++++++++++++-
>>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 172 +++++++++++++++-
>>  3 files changed, 517 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>> b/drivers/scsi/megaraid/megaraid_sas.h
>> index bc7adcf..e0f03e2 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>> @@ -105,6 +105,9 @@
>>  #define MFI_STATE_READY				0xB0000000
>>  #define MFI_STATE_OPERATIONAL			0xC0000000
>>  #define MFI_STATE_FAULT				0xF0000000
>> +#define MFI_STATE_FORCE_OCR			0x00000080
>> +#define MFI_STATE_DMADONE			0x00000008
>> +#define MFI_STATE_CRASH_DUMP_DONE		0x00000004
>>  #define MFI_RESET_REQUIRED			0x00000001
>>  #define MFI_RESET_ADAPTER			0x00000002
>>  #define MEGAMFI_FRAME_SIZE			64
>> @@ -191,6 +194,9 @@
>>  #define MR_DCMD_CLUSTER_RESET_LD		0x08010200
>>  #define MR_DCMD_PD_LIST_QUERY                   0x02010100
>>
>> +#define MR_DCMD_CTRL_SET_CRASH_DUMP_PARAMS	0x01190100
>> +#define MR_DRIVER_SET_APP_CRASHDUMP_MODE	(0xF0010000 |
>0x0600)
>> +
>>  /*
>>   * Global functions
>>   */
>> @@ -264,6 +270,25 @@ enum MFI_STAT {
>>  };
>>
>>  /*
>> + * Crash dump related defines
>> + */
>> +#define MAX_CRASH_DUMP_SIZE 512
>> +#define CRASH_DMA_BUF_SIZE  (1024 * 1024)
>> +
>> +enum MR_FW_CRASH_DUMP_STATE {
>> +	UNAVAILABLE =3D 0,
>> +	AVAILABLE =3D 1,
>> +	COPYING =3D 2,
>> +	COPIED =3D 3,
>> +	COPY_ERROR =3D 4,
>> +};
>> +
>> +enum _MR_CRASH_BUF_STATUS {
>> +	MR_CRASH_BUF_TURN_OFF =3D 0,
>> +	MR_CRASH_BUF_TURN_ON =3D 1,
>> +};
>> +
>> +/*
>>   * Number of mailbox bytes in DCMD message frame
>>   */
>>  #define MFI_MBOX_SIZE				12
>> @@ -933,7 +958,19 @@ struct megasas_ctrl_info {
>>  		u8  reserved;                   /*0x7E7*/
>>  	} iov;
>>
>> -	u8          pad[0x800-0x7E8];           /*0x7E8 pad to 2k */
>> +	struct {
>> +#if defined(__BIG_ENDIAN_BITFIELD)
>> +		u32     reserved:25;
>> +		u32     supportCrashDump:1;
>> +		u32     reserved1:6;
>> +#else
>> +		u32     reserved1:6;
>> +		u32     supportCrashDump:1;
>> +		u32     reserved:25;
>> +#endif
>> +	} adapterOperations3;
>> +
>> +	u8          pad[0x800-0x7EC];
>>  } __packed;
>>
>>  /*
>> @@ -1559,6 +1596,20 @@ struct megasas_instance {
>>  	u32 *reply_queue;
>>  	dma_addr_t reply_queue_h;
>>
>> +	u32 *crash_dump_buf;
>> +	dma_addr_t crash_dump_h;
>> +	void *crash_buf[MAX_CRASH_DUMP_SIZE];
>> +	u32 crash_buf_pages;
>> +	unsigned int    fw_crash_buffer_size;
>> +	unsigned int    fw_crash_state;
>> +	unsigned int    fw_crash_buffer_offset;
>> +	u32 drv_buf_index;
>> +	u32 drv_buf_alloc;
>> +	u32 crash_dump_fw_support;
>> +	u32 crash_dump_drv_support;
>> +	u32 crash_dump_app_support;
>> +	spinlock_t crashdump_lock;
>> +
>>  	struct megasas_register_set __iomem *reg_set;
>>  	u32 *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
>>  	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
>> @@ -1606,6 +1657,7 @@ struct megasas_instance {
>>  	struct megasas_instance_template *instancet;
>>  	struct tasklet_struct isr_tasklet;
>>  	struct work_struct work_init;
>> +	struct work_struct crash_init;
>>
>>  	u8 flag;
>>  	u8 unload;
>> @@ -1830,4 +1882,8 @@ u16 MR_LdSpanArrayGet(u32 ld, u32 span, struct
>> MR_FW_RAID_MAP_ALL *map);
>>  u16 MR_PdDevHandleGet(u32 pd, struct MR_FW_RAID_MAP_ALL *map);
>>  u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
>>
>> +int megasas_set_crash_dump_params(struct megasas_instance *instance=
,
>> +		u8 crash_buf_state);
>> +void megasas_free_host_crash_buffer(struct megasas_instance
>> +*instance); void megasas_fusion_crash_dump_wq(struct work_struct
>> +*work);
>>  #endif				/*LSI_MEGARAID_SAS_H */
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>> index a894f13..5b58e39d 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>> @@ -2560,6 +2560,152 @@ static int megasas_change_queue_depth(struct
>scsi_device *sdev,
>>  	return queue_depth;
>>  }
>>
>> +static ssize_t
>> +megasas_fw_crash_buffer_store(struct device *cdev,
>> +	struct device_attribute *attr, const char *buf, size_t count) {
>> +	struct Scsi_Host *shost =3D class_to_shost(cdev);
>> +	struct megasas_instance *instance =3D
>> +		(struct megasas_instance *) shost->hostdata;
>> +	int val =3D 0;
>> +	unsigned long flags;
>> +
>> +	if (kstrtoint(buf, 0, &val) !=3D 0)
>> +		return -EINVAL;
>> +
>> +	spin_lock_irqsave(&instance->crashdump_lock, flags);
>> +	instance->fw_crash_buffer_offset =3D val;
>> +	spin_unlock_irqrestore(&instance->crashdump_lock, flags);
>
>The access to fw_crash_buffer_offset is not protected in the function =
below
>why is the spinlock needed here, could it be removed?

While doing some code optimization for this patch, I used local variabl=
e "
buff_offset " to store "instance->fw_crash_buffer_offset",
And missed to put that code spinlock guarded. Inhouse driver does have =
this
issue, since "buff_offset" is not present in that code.
I will move  " buff_offset =3D instance->fw_crash_buffer_offset;" insid=
e
spinlock.

>
>> +	return strlen(buf);
>> +}
>> +
>> +static ssize_t
>> +megasas_fw_crash_buffer_show(struct device *cdev,
>> +	struct device_attribute *attr, char *buf) {
>> +	struct Scsi_Host *shost =3D class_to_shost(cdev);
>> +	struct megasas_instance *instance =3D
>> +		(struct megasas_instance *) shost->hostdata;
>> +	u32 size;
>> +	unsigned long buff_addr;
>> +	unsigned long dmachunk =3D CRASH_DMA_BUF_SIZE;
>> +	unsigned long src_addr;
>> +	unsigned long flags;
>> +	u32 buff_offset;
>> +
>> +	buff_offset =3D instance->fw_crash_buffer_offset;
>> +	spin_lock_irqsave(&instance->crashdump_lock, flags);
>> +	if (!instance->crash_dump_buf &&
>> +		!((instance->fw_crash_state =3D=3D AVAILABLE) ||
>> +		(instance->fw_crash_state =3D=3D COPYING))) {
>> +		dev_err(&instance->pdev->dev,
>> +			"Firmware crash dump is not available\n");
>> +		spin_unlock_irqrestore(&instance->crashdump_lock, flags);
>> +		return -EINVAL;
>> +	}
>> +
>> +	buff_addr =3D (unsigned long) buf;
>> +
>> +	if (buff_offset >
>> +		(instance->fw_crash_buffer_size * dmachunk)) {
>> +		dev_err(&instance->pdev->dev,
>> +			"Firmware crash dump offset is out of range\n");
>> +		spin_unlock_irqrestore(&instance->crashdump_lock, flags);
>> +		return 0;
>> +	}
>> +
>> +	size =3D (instance->fw_crash_buffer_size * dmachunk) - buff_offset=
;
>> +	size =3D (size >=3D PAGE_SIZE) ? (PAGE_SIZE - 1) : size;
>> +
>> +	src_addr =3D (unsigned long)instance->crash_buf[buff_offset /
>dmachunk] +
>> +		(buff_offset % dmachunk);
>> +	memcpy(buf, (void *)src_addr,  size);
>> +	spin_unlock_irqrestore(&instance->crashdump_lock, flags);
>> +
>> +	return size;
>> +}
>> +
>> +static ssize_t
>> +megasas_fw_crash_buffer_size_show(struct device *cdev,
>> +	struct device_attribute *attr, char *buf) {
>> +	struct Scsi_Host *shost =3D class_to_shost(cdev);
>> +	struct megasas_instance *instance =3D
>> +		(struct megasas_instance *) shost->hostdata;
>> +
>> +	return snprintf(buf, PAGE_SIZE, "%ld\n", (unsigned long)
>> +		((instance->fw_crash_buffer_size) * 1024 *
>1024)/PAGE_SIZE); }
>> +
>> +static ssize_t
>> +megasas_fw_crash_state_store(struct device *cdev,
>> +	struct device_attribute *attr, const char *buf, size_t count) {
>> +	struct Scsi_Host *shost =3D class_to_shost(cdev);
>> +	struct megasas_instance *instance =3D
>> +		(struct megasas_instance *) shost->hostdata;
>> +	int val =3D 0;
>> +	unsigned long flags;
>> +
>> +	if (kstrtoint(buf, 0, &val) !=3D 0)
>> +		return -EINVAL;
>> +
>> +	if ((val <=3D AVAILABLE || val > COPY_ERROR)) {
>> +		dev_err(&instance->pdev->dev, "application updates invalid "
>> +			"firmware crash state\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	instance->fw_crash_state =3D val;
>> +
>> +	if ((val =3D=3D COPIED) || (val =3D=3D COPY_ERROR)) {
>> +		spin_lock_irqsave(&instance->crashdump_lock, flags);
>> +		megasas_free_host_crash_buffer(instance);
>> +		spin_unlock_irqrestore(&instance->crashdump_lock, flags);
>> +		if (val =3D=3D COPY_ERROR)
>> +			dev_info(&instance->pdev->dev, "application failed
>to "
>> +				"copy Firmware crash dump\n");
>> +		else
>> +			dev_info(&instance->pdev->dev, "Firmware crash
>dump "
>> +				"copied successfully\n");
>> +	}
>> +	return strlen(buf);
>> +}
>> +
>> +static ssize_t
>> +megasas_fw_crash_state_show(struct device *cdev,
>> +	struct device_attribute *attr, char *buf) {
>> +	struct Scsi_Host *shost =3D class_to_shost(cdev);
>> +	struct megasas_instance *instance =3D
>> +		(struct megasas_instance *) shost->hostdata;
>> +	return snprintf(buf, PAGE_SIZE, "%d\n", instance->fw_crash_state);=
 }
>> +
>> +static ssize_t
>> +megasas_page_size_show(struct device *cdev,
>> +	struct device_attribute *attr, char *buf) {
>> +	return snprintf(buf, PAGE_SIZE, "%ld\n", (unsigned long)PAGE_SIZE =
-
>> +1); }
>> +
>> +static DEVICE_ATTR(fw_crash_buffer, S_IRUGO | S_IWUSR,
>> +	megasas_fw_crash_buffer_show, megasas_fw_crash_buffer_store);
>static
>> +DEVICE_ATTR(fw_crash_buffer_size, S_IRUGO,
>> +	megasas_fw_crash_buffer_size_show, NULL); static
>> +DEVICE_ATTR(fw_crash_state, S_IRUGO | S_IWUSR,
>> +	megasas_fw_crash_state_show, megasas_fw_crash_state_store);
>static
>> +DEVICE_ATTR(page_size, S_IRUGO,
>> +	megasas_page_size_show, NULL);
>> +
>> +struct device_attribute *megaraid_host_attrs[] =3D {
>> +	&dev_attr_fw_crash_buffer_size,
>> +	&dev_attr_fw_crash_buffer,
>> +	&dev_attr_fw_crash_state,
>> +	&dev_attr_page_size,
>> +	NULL,
>> +};
>> +
>>  /*
>>   * Scsi host template for megaraid_sas driver
>>   */
>> @@ -2575,6 +2721,7 @@ static struct scsi_host_template
>megasas_template =3D {
>>  	.eh_bus_reset_handler =3D megasas_reset_bus_host,
>>  	.eh_host_reset_handler =3D megasas_reset_bus_host,
>>  	.eh_timed_out =3D megasas_reset_timer,
>> +	.shost_attrs =3D megaraid_host_attrs,
>>  	.bios_param =3D megasas_bios_param,
>>  	.use_clustering =3D ENABLE_CLUSTERING,
>>  	.change_queue_depth =3D megasas_change_queue_depth, @@ -
>3887,6
>> +4034,59 @@ megasas_get_ctrl_info(struct megasas_instance *instance,
>>  	return ret;
>>  }
>>
>> +/*
>> + * megasas_set_crash_dump_params -	Sends address of crash dump
>DMA buffer
>> + *					to firmware
>> + *
>> + * @instance:				Adapter soft state
>> + * @crash_buf_state		-	tell FW to turn ON/OFF crash
>dump feature
>> +					MR_CRASH_BUF_TURN_OFF =3D 0
>> +					MR_CRASH_BUF_TURN_ON =3D 1
>> + * @return 0 on success non-zero on failure.
>> + * Issues an internal command (DCMD) to set parameters for crash du=
mp
>feature.
>> + * Driver will send address of crash dump DMA buffer and set mbox t=
o
>> +tell FW
>> + * that driver supports crash dump feature. This DCMD will be sent
>> +only if
>> + * crash dump feature is supported by the FW.
>> + *
>> + */
>> +int megasas_set_crash_dump_params(struct megasas_instance *instance=
,
>> +	u8 crash_buf_state)
>> +{
>> +	int ret =3D 0;
>> +	struct megasas_cmd *cmd;
>> +	struct megasas_dcmd_frame *dcmd;
>> +
>> +	cmd =3D megasas_get_cmd(instance);
>> +
>> +	if (!cmd) {
>> +		dev_err(&instance->pdev->dev, "Failed to get a free cmd\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +
>> +	dcmd =3D &cmd->frame->dcmd;
>> +
>> +	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
>> +	dcmd->mbox.b[0] =3D crash_buf_state;
>> +	dcmd->cmd =3D MFI_CMD_DCMD;
>> +	dcmd->cmd_status =3D 0xFF;
>> +	dcmd->sge_count =3D 1;
>> +	dcmd->flags =3D cpu_to_le16(MFI_FRAME_DIR_NONE);
>> +	dcmd->timeout =3D 0;
>> +	dcmd->pad_0 =3D 0;
>> +	dcmd->data_xfer_len =3D cpu_to_le32(CRASH_DMA_BUF_SIZE);
>> +	dcmd->opcode =3D
>cpu_to_le32(MR_DCMD_CTRL_SET_CRASH_DUMP_PARAMS);
>> +	dcmd->sgl.sge32[0].phys_addr =3D cpu_to_le32(instance-
>>crash_dump_h);
>> +	dcmd->sgl.sge32[0].length =3D cpu_to_le32(CRASH_DMA_BUF_SIZE);
>> +
>> +	if (!megasas_issue_polled(instance, cmd))
>> +		ret =3D 0;
>> +	else
>> +		ret =3D -1;
>> +	megasas_return_cmd(instance, cmd);
>> +	return ret;
>> +}
>> +
>>  /**
>>   * megasas_issue_init_mfi -	Initializes the FW
>>   * @instance:		Adapter soft state
>> @@ -4272,6 +4472,27 @@ static int megasas_init_fw(struct
>megasas_instance *instance)
>>  			printk(KERN_WARNING "megaraid_sas: I am VF "
>>  			       "requestorId %d\n", instance->requestorId);
>>  		}
>> +
>> +		le32_to_cpus((u32 *)&ctrl_info->adapterOperations3);
>> +		instance->crash_dump_fw_support =3D
>> +			ctrl_info->adapterOperations3.supportCrashDump;
>> +		instance->crash_dump_drv_support =3D
>> +			(instance->crash_dump_fw_support &&
>> +			instance->crash_dump_buf);
>> +		if (instance->crash_dump_drv_support) {
>> +			dev_info(&instance->pdev->dev, "Firmware Crash
>dump "
>> +				"feature is supported\n");
>> +			megasas_set_crash_dump_params(instance,
>> +				MR_CRASH_BUF_TURN_OFF);
>> +
>> +		} else {
>> +			if (instance->crash_dump_buf)
>> +				pci_free_consistent(instance->pdev,
>> +					CRASH_DMA_BUF_SIZE,
>> +					instance->crash_dump_buf,
>> +					instance->crash_dump_h);
>> +			instance->crash_dump_buf =3D NULL;
>> +		}
>>  	}
>>  	instance->max_sectors_per_req =3D instance->max_num_sge *
>>  						PAGE_SIZE / 512;
>> @@ -4791,6 +5012,21 @@ static int megasas_probe_one(struct pci_dev
>*pdev,
>>  		break;
>>  	}
>>
>> +	/* Crash dump feature related initialisation*/
>> +	instance->drv_buf_index =3D 0;
>> +	instance->drv_buf_alloc =3D 0;
>> +	instance->crash_dump_fw_support =3D 0;
>> +	instance->crash_dump_app_support =3D 0;
>> +	instance->fw_crash_state =3D UNAVAILABLE;
>> +	spin_lock_init(&instance->crashdump_lock);
>> +
>> +	instance->crash_dump_buf =3D pci_alloc_consistent(pdev,
>> +						CRASH_DMA_BUF_SIZE,
>> +						&instance->crash_dump_h);
>> +	if (!instance->crash_dump_buf)
>> +		dev_err(&instance->pdev->dev, "Can't allocate Firmware "
>> +			"crash dump DMA buffer\n");
>> +
>>  	megasas_poll_wait_aen =3D 0;
>>  	instance->flag_ieee =3D 0;
>>  	instance->ev =3D NULL;
>> @@ -4852,9 +5088,10 @@ static int megasas_probe_one(struct pci_dev
>*pdev,
>>  	if ((instance->pdev->device =3D=3D PCI_DEVICE_ID_LSI_FUSION) ||
>>  	    (instance->pdev->device =3D=3D PCI_DEVICE_ID_LSI_PLASMA) ||
>>  	    (instance->pdev->device =3D=3D PCI_DEVICE_ID_LSI_INVADER) ||
>> -	    (instance->pdev->device =3D=3D PCI_DEVICE_ID_LSI_FURY))
>> +	    (instance->pdev->device =3D=3D PCI_DEVICE_ID_LSI_FURY)) {
>>  		INIT_WORK(&instance->work_init, megasas_fusion_ocr_wq);
>> -	else
>> +		INIT_WORK(&instance->crash_init,
>megasas_fusion_crash_dump_wq);
>> +	} else
>>  		INIT_WORK(&instance->work_init,
>process_fw_state_change_wq);
>>
>>  	/*
>> @@ -5342,6 +5579,8 @@ static void megasas_detach_one(struct pci_dev
>*pdev)
>>  	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
>>  		del_timer_sync(&instance->sriov_heartbeat_timer);
>>
>> +	if (instance->fw_crash_state !=3D UNAVAILABLE)
>> +		megasas_free_host_crash_buffer(instance);
>>  	scsi_remove_host(instance->host);
>>  	megasas_flush_cache(instance);
>>  	megasas_shutdown_controller(instance,
>MR_DCMD_CTRL_SHUTDOWN); @@
>> -5432,6 +5671,10 @@ static void megasas_detach_one(struct pci_dev
>*pdev)
>>  				    instance->hb_host_mem,
>>  				    instance->hb_host_mem_h);
>>
>> +	if (instance->crash_dump_buf)
>> +		pci_free_consistent(pdev, CRASH_DMA_BUF_SIZE,
>> +			    instance->crash_dump_buf, instance-
>>crash_dump_h);
>> +
>>  	scsi_host_put(host);
>>
>>  	pci_disable_device(pdev);
>> @@ -5523,6 +5766,45 @@ static unsigned int megasas_mgmt_poll(struct =
file
>*file, poll_table *wait)
>>  	return mask;
>>  }
>>
>> +/*
>> + * megasas_set_crash_dump_params_ioctl:
>> + *		Send CRASH_DUMP_MODE DCMD to all controllers
>> + * @cmd:	MFI command frame
>> + */
>> +
>> +static int megasas_set_crash_dump_params_ioctl(
>> +	struct megasas_cmd *cmd)
>> +{
>> +	struct megasas_instance *local_instance;
>> +	int i, error =3D 0;
>> +	int crash_support;
>> +
>> +	crash_support =3D cmd->frame->dcmd.mbox.w[0];
>> +
>> +	for (i =3D 0; i < megasas_mgmt_info.max_index; i++) {
>> +		local_instance =3D megasas_mgmt_info.instance[i];
>> +		if (local_instance && local_instance-
>>crash_dump_drv_support) {
>> +			if ((local_instance->adprecovery =3D=3D
>> +				MEGASAS_HBA_OPERATIONAL) &&
>> +
>	!megasas_set_crash_dump_params(local_instance,
>> +					crash_support)) {
>> +				local_instance->crash_dump_app_support =3D
>> +					crash_support;
>> +				dev_info(&local_instance->pdev->dev,
>> +					"Application firmware crash "
>> +					"dump mode set success\n");
>> +				error =3D 0;
>> +			} else {
>> +				dev_info(&local_instance->pdev->dev,
>> +					"Application firmware crash "
>> +					"dump mode set failed\n");
>> +				error =3D -1;
>> +			}
>> +		}
>> +	}
>> +	return error;
>> +}
>> +
>>  /**
>>   * megasas_mgmt_fw_ioctl -	Issues management ioctls to FW
>>   * @instance:			Adapter soft state
>> @@ -5569,6 +5851,12 @@ megasas_mgmt_fw_ioctl(struct
>megasas_instance *instance,
>>  					       MFI_FRAME_SGL64 |
>>  					       MFI_FRAME_SENSE64));
>>
>> +	if (cmd->frame->dcmd.opcode =3D=3D
>MR_DRIVER_SET_APP_CRASHDUMP_MODE) {
>> +		error =3D megasas_set_crash_dump_params_ioctl(cmd);
>> +		megasas_return_cmd(instance, cmd);
>> +		return error;
>> +	}
>> +
>>  	/*
>>  	 * The management interface between applications and the fw uses
>>  	 * MFI frames. E.g, RAID configuration changes, LD property change=
s
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> index f30297d..aaba2a7 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> @@ -91,6 +91,8 @@ void megasas_start_timer(struct megasas_instance
>> *instance,  extern struct megasas_mgmt_info megasas_mgmt_info;  exte=
rn
>> int resetwaittime;
>>
>> +
>> +
>>  /**
>>   * megasas_enable_intr_fusion -	Enables interrupts
>>   * @regs:			MFI register set
>> @@ -2057,7 +2059,7 @@ irqreturn_t megasas_isr_fusion(int irq, void
>> *devp)  {
>>  	struct megasas_irq_context *irq_context =3D devp;
>>  	struct megasas_instance *instance =3D irq_context->instance;
>> -	u32 mfiStatus, fw_state;
>> +	u32 mfiStatus, fw_state, dma_state;
>>
>>  	if (instance->mask_interrupts)
>>  		return IRQ_NONE;
>> @@ -2079,7 +2081,16 @@ irqreturn_t megasas_isr_fusion(int irq, void
>*devp)
>>  		/* If we didn't complete any commands, check for FW fault */
>>  		fw_state =3D instance->instancet->read_fw_status_reg(
>>  			instance->reg_set) & MFI_STATE_MASK;
>> -		if (fw_state =3D=3D MFI_STATE_FAULT) {
>> +		dma_state =3D instance->instancet->read_fw_status_reg
>> +			(instance->reg_set) & MFI_STATE_DMADONE;
>> +		if (instance->crash_dump_drv_support &&
>> +			instance->crash_dump_app_support) {
>> +			/* Start collecting crash, if DMA bit is done */
>> +			if ((fw_state =3D=3D MFI_STATE_FAULT) && dma_state)
>> +				schedule_work(&instance->crash_init);
>> +			else if (fw_state =3D=3D MFI_STATE_FAULT)
>> +				schedule_work(&instance->work_init);
>> +		} else if (fw_state =3D=3D MFI_STATE_FAULT) {
>>  			printk(KERN_WARNING "megaraid_sas:
>Iop2SysDoorbellInt"
>>  			       "for scsi%d\n", instance->host->host_no);
>>  			schedule_work(&instance->work_init);
>> @@ -2232,6 +2243,49 @@ megasas_read_fw_status_reg_fusion(struct
>> megasas_register_set __iomem *regs)  }
>>
>>  /**
>> + * megasas_alloc_host_crash_buffer -	Host buffers for Crash dump
>collection from Firmware
>> + * @instance:				Controller's soft instance
>> + * return:			        Number of allocated host crash buffers
>> + */
>> +static void
>> +megasas_alloc_host_crash_buffer(struct megasas_instance *instance) =
{
>> +	unsigned int i;
>> +
>> +	instance->crash_buf_pages =3D get_order(CRASH_DMA_BUF_SIZE);
>> +	for (i =3D 0; i < MAX_CRASH_DUMP_SIZE; i++) {
>> +		instance->crash_buf[i] =3D (void
>	*)__get_free_pages(GFP_KERNEL,
>> +				instance->crash_buf_pages);
>> +		if (!instance->crash_buf[i]) {
>> +			dev_info(&instance->pdev->dev, "Firmware crash
>dump "
>> +				"memory allocation failed at index %d\n", i);
>> +			break;
>> +		}
>> +	}
>> +	instance->drv_buf_alloc =3D i;
>> +}
>> +
>> +/**
>> + * megasas_free_host_crash_buffer -	Host buffers for Crash dump
>collection from Firmware
>> + * @instance:				Controller's soft instance
>> + */
>> +void
>> +megasas_free_host_crash_buffer(struct megasas_instance *instance) {
>> +	unsigned int i
>> +;
>> +	for (i =3D 0; i < MAX_CRASH_DUMP_SIZE; i++) {
>
>I'm not sure, but shouldn't this be changed to ?
>for (i =3D 0; i < instance->drv_buf_alloc; i++) {
>
>
Agreed, not critical from functional point of view,
 will do this change and resubmit the patch.

>> +		if (instance->crash_buf[i])
>> +			free_pages((ulong)instance->crash_buf[i],
>> +					instance->crash_buf_pages);
>> +	}
>> +	instance->drv_buf_index =3D 0;
>> +	instance->drv_buf_alloc =3D 0;
>> +	instance->fw_crash_state =3D UNAVAILABLE;
>> +	instance->fw_crash_buffer_size =3D 0;
>> +}
>> +
>> +/**
>>   * megasas_adp_reset_fusion -	For controller reset
>>   * @regs:				MFI register set
>>   */
>> @@ -2374,6 +2428,7 @@ int megasas_reset_fusion(struct Scsi_Host *sho=
st,
>int iotimeout)
>>  	struct megasas_cmd *cmd_mfi;
>>  	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
>>  	u32 host_diag, abs_state, status_reg, reset_adapter;
>> +	u32 io_timeout_in_crash_mode =3D 0;
>>
>>  	instance =3D (struct megasas_instance *)shost->hostdata;
>>  	fusion =3D instance->ctrl_context;
>> @@ -2387,6 +2442,42 @@ int megasas_reset_fusion(struct Scsi_Host
>*shost, int iotimeout)
>>  		mutex_unlock(&instance->reset_mutex);
>>  		return FAILED;
>>  	}
>> +	status_reg =3D instance->instancet->read_fw_status_reg(instance-
>>reg_set);
>> +	abs_state =3D status_reg & MFI_STATE_MASK;
>> +
>> +	/* IO timeout detected, forcibly put FW in FAULT state */
>> +	if (abs_state !=3D MFI_STATE_FAULT && instance->crash_dump_buf
>&&
>> +		instance->crash_dump_app_support && iotimeout) {
>> +		dev_info(&instance->pdev->dev, "IO timeout is detected, "
>> +			"forcibly FAULT Firmware\n");
>> +		instance->adprecovery =3D MEGASAS_ADPRESET_SM_INFAULT;
>> +		status_reg =3D readl(&instance->reg_set->doorbell);
>> +		writel(status_reg | MFI_STATE_FORCE_OCR,
>> +			&instance->reg_set->doorbell);
>> +		readl(&instance->reg_set->doorbell);
>> +		mutex_unlock(&instance->reset_mutex);
>> +		do {
>> +			ssleep(3);
>> +			io_timeout_in_crash_mode++;
>> +			dev_dbg(&instance->pdev->dev, "waiting for [%d] "
>> +				"seconds for crash dump collection and OCR "
>> +				"to be done\n", (io_timeout_in_crash_mode
>* 3));
>> +		} while ((instance->adprecovery !=3D
>MEGASAS_HBA_OPERATIONAL) &&
>> +			(io_timeout_in_crash_mode < 80));
>> +
>> +		if (instance->adprecovery =3D=3D MEGASAS_HBA_OPERATIONAL)
>{
>> +			dev_info(&instance->pdev->dev, "OCR done for IO "
>> +				"timeout case\n");
>> +			retval =3D SUCCESS;
>> +		} else {
>> +			dev_info(&instance->pdev->dev, "Controller is not "
>> +				"operational after 240 seconds wait for IO "
>> +				"timeout case in FW crash dump mode\n do "
>> +				"OCR/kill adapter\n");
>> +			retval =3D megasas_reset_fusion(shost, 0);
>> +		}
>> +		return retval;
>> +	}
>>
>>  	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
>>  		del_timer_sync(&instance->sriov_heartbeat_timer);
>> @@ -2653,6 +2744,15 @@ int megasas_reset_fusion(struct Scsi_Host
>*shost, int iotimeout)
>>  			printk(KERN_WARNING "megaraid_sas: Reset "
>>  			       "successful for scsi%d.\n",
>>  				instance->host->host_no);
>> +
>> +			if (instance->crash_dump_drv_support) {
>> +				if (instance->crash_dump_app_support)
>> +
>	megasas_set_crash_dump_params(instance,
>> +						MR_CRASH_BUF_TURN_ON);
>> +				else
>> +
>	megasas_set_crash_dump_params(instance,
>> +						MR_CRASH_BUF_TURN_OFF);
>> +			}
>>  			retval =3D SUCCESS;
>>  			goto out;
>>  		}
>> @@ -2681,6 +2781,74 @@ out:
>>  	return retval;
>>  }
>>
>> +/* Fusion Crash dump collection work queue */ void
>> +megasas_fusion_crash_dump_wq(struct work_struct *work) {
>> +	struct megasas_instance *instance =3D
>> +		container_of(work, struct megasas_instance, crash_init);
>> +	u32 status_reg;
>> +	u8 partial_copy =3D 0;
>> +
>> +
>> +	status_reg =3D
>> +instance->instancet->read_fw_status_reg(instance->reg_set);
>> +
>> +	/*
>> +	 * Allocate host crash buffers to copy data from 1 MB DMA crash
>buffer
>> +	 * to host crash buffers
>> +	 */
>> +	if (instance->drv_buf_index =3D=3D 0) {
>> +		/* Buffer is already allocated for old Crash dump.
>> +		 * Do OCR and do not wait for crash dump collection
>> +		 */
>> +		if (instance->drv_buf_alloc) {
>> +			dev_info(&instance->pdev->dev, "earlier crash dump
>is "
>> +				"not yet copied by application, ignoring this "
>> +				"crash dump and initiating OCR\n");
>> +			status_reg |=3D MFI_STATE_CRASH_DUMP_DONE;
>> +			writel(status_reg,
>> +				&instance->reg_set-
>>outbound_scratch_pad);
>> +			readl(&instance->reg_set->outbound_scratch_pad);
>> +			return;
>> +		}
>> +		megasas_alloc_host_crash_buffer(instance);
>> +		dev_info(&instance->pdev->dev, "Number of host crash
>buffers "
>> +			"allocated: %d\n", instance->drv_buf_alloc);
>> +	}
>> +
>> +	/*
>> +	 * Driver has allocated max buffers, which can be allocated
>> +	 * and FW has more crash dump data, then driver will
>> +	 * ignore the data.
>> +	 */
>> +	if (instance->drv_buf_index >=3D (instance->drv_buf_alloc)) {
>> +		dev_info(&instance->pdev->dev, "Driver is done copying "
>> +			"the buffer: %d\n", instance->drv_buf_alloc);
>> +		status_reg |=3D MFI_STATE_CRASH_DUMP_DONE;
>> +		partial_copy =3D 1;
>> +	} else {
>> +		memcpy(instance->crash_buf[instance->drv_buf_index],
>> +			instance->crash_dump_buf, CRASH_DMA_BUF_SIZE);
>> +		instance->drv_buf_index++;
>> +		status_reg &=3D ~MFI_STATE_DMADONE;
>> +	}
>> +
>> +	if (status_reg & MFI_STATE_CRASH_DUMP_DONE) {
>> +		dev_info(&instance->pdev->dev, "Crash Dump is
>available,number "
>> +			"of copied buffers: %d\n", instance->drv_buf_index);
>> +		instance->fw_crash_buffer_size =3D  instance->drv_buf_index;
>> +		instance->fw_crash_state =3D AVAILABLE;
>> +		instance->drv_buf_index =3D 0;
>> +		writel(status_reg, &instance->reg_set-
>>outbound_scratch_pad);
>> +		readl(&instance->reg_set->outbound_scratch_pad);
>> +		if (!partial_copy)
>> +			megasas_reset_fusion(instance->host, 0);
>> +	} else {
>> +		writel(status_reg, &instance->reg_set-
>>outbound_scratch_pad);
>> +		readl(&instance->reg_set->outbound_scratch_pad);
>> +	}
>> +}
>> +
>> +
>>  /* Fusion OCR work queue */
>>  void megasas_fusion_ocr_wq(struct work_struct *work)  {
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
