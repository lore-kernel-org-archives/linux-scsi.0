From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 11/11] pm80xx : gpio feature support for motherboard controllers
Date: Mon, 11 Nov 2013 09:58:11 +0100
Message-ID: <52809C23.507@gmail.com>
References: <1382444455-3168-1-git-send-email-Viswas.G@pmcs.com> <526F8B95.8010900@gmail.com> <DB8BCD22E410A84DA91083F3479A3DB31C67F7A2@BBYEXM01.pmc-sierra.internal> <52777740.8070509@gmail.com> <DB8BCD22E410A84DA91083F3479A3DB31C680618@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:38913 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3KKI6P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2013 03:58:15 -0500
Received: by mail-bk0-f51.google.com with SMTP id my12so1587541bkb.10
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2013 00:58:13 -0800 (PST)
In-Reply-To: <DB8BCD22E410A84DA91083F3479A3DB31C680618@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@pmcs.com>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>, Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>, Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>, Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

Hi James,

About this gpio feature, do you think it's OK to implement with IOCTL or
we can use exist bsg interface in libsas and add another function call?

Regards,
Jack

On 11/11/2013 06:57 AM, Viswas G wrote:
> Hi Jack,
> 
> The GPIO feature we implemented here is for controlling and configuring the GPIO pins present in the HBA and it is not related to the GPIO registers present in the SGPIO. Following is one of the GPIO operations we do from application.
> 
> When application wants to know the insertion/removal of a SAS cable in any of the port, it configures the GPIO for corresponding port to generate event for SAS cable insertion or removal using the IOCTL to the HBA driver and waits by calling poll function. When driver receives the GPIO event for the SAS cable insertion or removal then it intimates the application.
> 
> We are using IOCTL instead of sysfs interface since we have to pass structures between user space and kernel space. Again, in the kernel space, we have to parse user buffer from application and convert it to the corresponding data structure. We wanted to avoid the parsing complexity by using ioctl interface.
> 
> Regards,
> Viswas G
> 
> 
> -----Original Message-----
> From: Jack Wang [mailto:xjtuwjp@gmail.com] 
> Sent: Monday, November 04, 2013 4:00 PM
> To: Viswas G
> Cc: linux-scsi@vger.kernel.org; Sangeetha Gnanasekaran; Nikith Ganigarakoppal; Anand Kumar Santhanam; Suresh Thiagarajan
> Subject: Re: [PATCH 11/11] pm80xx : gpio feature support for motherboard controllers
> 
> On 11/04/2013 11:13 AM, Viswas G wrote:
>> Hi Jack,
>>
>> We wanted to control the GPIO in the HBA only. Bsg interface gets created only for enclosure or expander. 
>>
>> For our HBA, bsg interface will not be created since it does not have an enclosure target inside. That's why we wanted to use IOCTL. Please advise.
>>
>> Best Regards,
>> Viswas G
>>
> Hi Viswas,
> 
> No, bsg interface also support HBA.
> Here is two example output from LSI mpt2sas:
> 
> smp_rep_manufacturer /dev/bsg/sas_host0
> Report manufacturer response:
>   SAS-1.1 format: 0
>   vendor identification: LSI
>   product identification: Virtual SMP Port
>   product revision level:
> smp_read_gpio /dev/bsg/sas_host0
> Read GPIO register response:
>   GPIO_CFG[0]:
>     version: 0
>     GPIO enable: 1
>     cfg register count: 2
>     gp register count: 1
>     supported drive count: 16
> 
> Regards,
> Jack
> 
>> -----Original Message-----
>> From: Jack Wang [mailto:xjtuwjp@gmail.com] 
>> Sent: Tuesday, October 29, 2013 3:49 PM
>> To: Viswas G
>> Cc: linux-scsi@vger.kernel.org; Sangeetha Gnanasekaran; Nikith Ganigarakoppal; Anand Kumar Santhanam
>> Subject: Re: [PATCH 11/11] pm80xx : gpio feature support for motherboard controllers
>>
>> Hi Viswas,
>>
>> As ioctl interface is not welcome for new feature, that's why we removed ioctl interface when pm8001 accepted into mainline.
>>
>> I suggest you use bsg interface for this, see sas_host_smp.c for details.
>>
>> Regards,
>> Jack
>>
>> On 10/22/2013 02:20 PM, Viswas G wrote:
>>>
>>> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
>>> ---
>>>  drivers/scsi/pm8001/pm8001_ctl.c  |  248
>>> ++++++++++++++++++++++++++++++++++++-
>>>  drivers/scsi/pm8001/pm8001_ctl.h  |   55 ++++++++
>>>  drivers/scsi/pm8001/pm8001_init.c |   37 ++++++
>>>  drivers/scsi/pm8001/pm8001_sas.h  |   30 +++++
>>>  drivers/scsi/pm8001/pm80xx_hwi.c  |  106 ++++++++++++++++
>>>  drivers/scsi/pm8001/pm80xx_hwi.h  |   49 +++++++
>>>  6 files changed, 524 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c
>>> b/drivers/scsi/pm8001/pm8001_ctl.c
>>> index 247cb1c..3c9ca21 100644
>>> --- a/drivers/scsi/pm8001/pm8001_ctl.c
>>> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
>>> @@ -40,7 +40,8 @@
>>>  #include <linux/firmware.h>
>>>  #include <linux/slab.h>
>>>  #include "pm8001_sas.h"
>>> -#include "pm8001_ctl.h"
>>> +
>>> +int pm8001_major = -1;
>>>
>>>  /* scsi host attributes */
>>>
>>> @@ -759,3 +760,248 @@ struct device_attribute *pm8001_host_attrs[] = {
>>>         NULL,
>>>  };
>>>
>>> +/**
>>> + * pm8001_open - open the configuration file
>>> + * @inode: inode being opened
>>> + * @file: file handle attached
>>> + *
>>> + * Called when the configuration device is opened. Does the needed
>>> + * set up on the handle and then returns
>>> + *
>>> + */
>>> +static int pm8001_open(struct inode *inode, struct file *file) {
>>> +       struct pm8001_hba_info *pm8001_ha;
>>> +       unsigned minor_number = iminor(inode);
>>> +       int err = -ENODEV;
>>> +
>>> +       list_for_each_entry(pm8001_ha, &hba_list, list) {
>>> +               if (pm8001_ha->id == minor_number) {
>>> +                       file->private_data = pm8001_ha;
>>> +                       err = 0;
>>> +                       break;
>>> +               }
>>> +       }
>>> +
>>> +       return err;
>>> +}
>>> +
>>> +/**
>>> + * pm8001_close - close the configuration file
>>> + * @inode: inode being opened
>>> + * @file: file handle attached
>>> + *
>>> + * Called when the configuration device is closed. Does the needed
>>> + * set up on the handle and then returns
>>> + *
>>> + */
>>> +static int pm8001_close(struct inode *inode, struct file *file) {
>>> +       return 0;
>>> +}
>>> +
>>> +static long pm8001_info_ioctl(struct pm8001_hba_info *pm8001_ha,
>>> +                             unsigned long arg) {
>>> +       u32 ret = 0;
>>> +       struct ioctl_info_buffer info_buf;
>>> +       union main_cfg_table main_tbl =  pm8001_ha->main_cfg_tbl;
>>> +
>>> +       strcpy(info_buf.information.sz_name, DRV_NAME);
>>> +
>>> +       info_buf.information.usmajor_revision = DRV_MAJOR;
>>> +       info_buf.information.usminor_revision = DRV_MINOR;
>>> +       info_buf.information.usbuild_revision = DRV_BUILD;
>>> +       if (pm8001_ha->chip_id == chip_8001) {
>>> +               info_buf.information.maxoutstandingIO =
>>> +                       main_tbl.pm8001_tbl.max_out_io;
>>> +               info_buf.information.maxdevices =
>>> +                       (main_tbl.pm8001_tbl.max_sgl >> 16) & 0xFFFF;
>>> +       } else {
>>> +               info_buf.information.maxoutstandingIO =
>>> +                       main_tbl.pm80xx_tbl.max_out_io;
>>> +               info_buf.information.maxdevices =
>>> +                       (main_tbl.pm80xx_tbl.max_sgl >> 16) & 0xFFFF;
>>> +       }
>>> +       info_buf.header.return_code = ADPT_IOCTL_CALL_SUCCESS;
>>> +
>>> +       if (copy_to_user((void *)arg, (void *)&info_buf,
>>> +                        sizeof(struct ioctl_info_buffer))) {
>>> +               ret = ADPT_IOCTL_CALL_FAILED;
>>> +       }
>>> +
>>> +       return ret;
>>> +}
>>> +
>>> +static long pm8001_gpio_ioctl(struct pm8001_hba_info *pm8001_ha,
>>> +                             unsigned long arg) {
>>> +       struct gpio_buffer buffer;
>>> +       struct pm8001_gpio *payload;
>>> +       struct gpio_ioctl_resp *gpio_resp;
>>> +       DECLARE_COMPLETION_ONSTACK(completion);
>>> +       unsigned long timeout;
>>> +       u32 ret = 0, operation;
>>> +
>>> +       mutex_lock(&pm8001_ha->ioctl_mutex);
>>> +
>>> +       if (copy_from_user(&buffer, (struct gpio_buffer *)arg,
>>> +               sizeof(struct gpio_buffer))) {
>>> +               ret = ADPT_IOCTL_CALL_FAILED;
>>> +               goto exit;
>>> +       }
>>> +
>>> +       pm8001_ha->ioctl_completion = &completion;
>>> +       payload = &buffer.gpio_payload;
>>> +       operation = payload->operation;
>>> +       ret = PM8001_CHIP_DISP->gpio_req(pm8001_ha, payload);
>>> +       if (ret != 0) {
>>> +               ret = ADPT_IOCTL_CALL_FAILED;
>>> +               goto exit;
>>> +       }
>>> +
>>> +       timeout = (unsigned long)buffer.header.timeout * 1000;
>>> +
>>> +       mod_timer(&pm8001_ha->ioctl_timer, jiffies +
>>> msecs_to_jiffies(timeout));
>>> +
>>> +       wait_for_completion(&completion);
>>> +
>>> +       if (pm8001_ha->ioctl_timer_expired) {
>>> +               ret = ADPT_IOCTL_CALL_TIMEOUT;
>>> +               goto exit;
>>> +       }
>>> +       gpio_resp = &pm8001_ha->gpio_resp;
>>> +
>>> +       buffer.header.return_code = ADPT_IOCTL_CALL_SUCCESS;
>>> +
>>> +       if (operation == GPIO_READ) {
>>> +               payload->rd_wr_val              = gpio_resp->gpio_rd_val;
>>> +               payload->input_enable           =
>>> gpio_resp->gpio_in_enabled;
>>> +               payload->pinsetup1              = gpio_resp->gpio_pinsetup1;
>>> +               payload->pinsetup2              = gpio_resp->gpio_pinsetup2;
>>> +               payload->event_level            =
>>> gpio_resp->gpio_evt_change;
>>> +               payload->event_rising_edge      = gpio_resp->gpio_evt_rise;
>>> +               payload->event_falling_edge     = gpio_resp->gpio_evt_fall;
>>> +
>>> +               if (copy_to_user((void *)arg, (void *)&buffer,
>>> +                                sizeof(struct gpio_buffer))) {
>>> +                       ret = ADPT_IOCTL_CALL_FAILED;
>>> +               }
>>> +       } else {
>>> +               if (copy_to_user((void *)arg, (void *)&buffer.header,
>>> +                                sizeof(struct ioctl_header))) {
>>> +                       ret = ADPT_IOCTL_CALL_FAILED;
>>> +               }
>>> +       }
>>> +exit:
>>> +       pm8001_ha->ioctl_timer_expired = 0;
>>> +       mutex_unlock(&pm8001_ha->ioctl_mutex);
>>> +       return ret;
>>> +}
>>> +
>>> +/**
>>> + * pm8001_ioctl - pm8001 configuration request
>>> + * @inode: inode of device
>>> + * @file: file handle
>>> + * @cmd: ioctl command code
>>> + * @arg: argument
>>> + *
>>> + * Handles a configuration ioctl.
>>> + *
>>> + */
>>> +static long pm8001_ioctl(struct file *file,
>>> +                        unsigned int cmd, unsigned long arg) {
>>> +       u32 ret = -EACCES;
>>> +       struct pm8001_hba_info *pm8001_ha;
>>> +       struct ioctl_header header;
>>> +
>>> +       pm8001_ha = file->private_data;
>>> +
>>> +       switch (cmd) {
>>> +
>>> +       case ADPT_IOCTL_GPIO:
>>> +               ret = pm8001_gpio_ioctl(pm8001_ha, arg);
>>> +               break;
>>> +       case ADPT_IOCTL_INFO:
>>> +               ret = pm8001_info_ioctl(pm8001_ha, arg);
>>> +               break;
>>> +       default:
>>> +               ret = ADPT_IOCTL_CALL_INVALID_CODE;
>>> +       }
>>> +       if (ret == 0)
>>> +               return ret;
>>> +       header.return_code = ret;
>>> +       ret = -EACCES;
>>> +       if (copy_to_user((void *)arg, (void *)&header,
>>> +                       sizeof(struct ioctl_header))) {
>>> +               return -EFAULT;
>>> +       }
>>> +       PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("IOCTL failed\n"));
>>> +       return ret;
>>> +}
>>> +
>>> +/**
>>> + * pm8001_poll - pm8001 poll request function
>>> + * @file: file handle
>>> + * @wait: poll table to wait
>>> + *
>>> + * Handles a poll request.
>>> + *
>>> + */
>>> +unsigned int pm8001_poll(struct file *file, poll_table *wait) {
>>> +       struct pm8001_hba_info *pm8001_ha;
>>> +       unsigned int mask = 0;
>>> +
>>> +       pm8001_ha = file->private_data;
>>> +
>>> +       poll_wait(file, &pm8001_ha->pollq, wait);
>>> +
>>> +       if (pm8001_ha->gpio_event_occured == 1) {
>>> +               pm8001_ha->gpio_event_occured = 0;
>>> +               mask |= POLLIN | POLLRDNORM;
>>> +       }
>>> +
>>> +       return mask;
>>> +}
>>> +
>>> +static const struct file_operations pm8001_fops = {
>>> +       .owner          = THIS_MODULE,
>>> +       .open           = pm8001_open,
>>> +       .release        = pm8001_close,
>>> +       .unlocked_ioctl = pm8001_ioctl,
>>> +       .poll           = pm8001_poll,
>>> +};
>>> +
>>> +/**
>>> + * pm8001_setup_chrdev - registers a char device
>>> + *
>>> + * Return value
>>> + *     0 in case of success, otherwise non-zero
>>> + */
>>> +int pm8001_setup_chrdev(void)
>>> +{
>>> +       pm8001_major = register_chrdev(0, DRV_NAME, &pm8001_fops);
>>> +       if (pm8001_major < 0) {
>>> +               pr_warn("pm8001 : unable to register \"%s\" device\n",
>>> +                               DRV_NAME);
>>> +               return pm8001_major;
>>> +       }
>>> +       return 0;
>>> +}
>>> +
>>> +/**
>>> + * pm8001_release_chrdev - unregisters per-adapter management 
>>> +interface
>>> + *
>>> + * Return value
>>> + *     none
>>> + */
>>> +void pm8001_release_chrdev(void)
>>> +{
>>> +       if (pm8001_major > -1) {
>>> +               unregister_chrdev(pm8001_major, DRV_NAME);
>>> +               pm8001_major = -1;
>>> +       }
>>> +}
>>> +
>>> diff --git a/drivers/scsi/pm8001/pm8001_ctl.h
>>> b/drivers/scsi/pm8001/pm8001_ctl.h
>>> index d0d43a2..0064dd3 100644
>>> --- a/drivers/scsi/pm8001/pm8001_ctl.h
>>> +++ b/drivers/scsi/pm8001/pm8001_ctl.h
>>> @@ -55,6 +55,61 @@
>>>  #define FAIL_OUT_MEMORY                 0x000c00
>>>  #define FLASH_IN_PROGRESS               0x001000
>>>
>>> +#define ADPT_IOCTL_CALL_SUCCESS                0x00
>>> +#define ADPT_IOCTL_CALL_FAILED         0x01
>>> +#define ADPT_IOCTL_CALL_INVALID_CODE   0x03
>>> +#define ADPT_IOCTL_CALL_INVALID_DEVICE 0x04
>>> +#define ADPT_IOCTL_CALL_TIMEOUT                0x08
>>> +
>>> +#define GPIO_READ      0
>>> +#define GPIO_WRITE     1
>>> +#define GPIO_PINSETUP  2
>>> +#define GPIO_EVENTSETUP        3
>>> +
>>> +struct ioctl_header {
>>> +       u32 io_controller_num;
>>> +       u32 length;
>>> +       u32 return_code;
>>> +       u32 timeout;
>>> +       u32 direction;
>>> +};
>>> +
>>> +struct ioctl_drv_info {
>>> +       u8      sz_name[64];
>>> +       u16     usmajor_revision;
>>> +       u16     usminor_revision;
>>> +       u16     usbuild_revision;
>>> +       u16     reserved0;
>>> +       u32     maxdevices;
>>> +       u32     maxoutstandingIO;
>>> +       u32     reserved[16];
>>> +};
>>> +
>>> +struct pm8001_gpio {
>>> +       u32 operation;
>>> +       u32 mask;
>>> +       u32 rd_wr_val;
>>> +       u32 input_enable;
>>> +       u32 pinsetup1;
>>> +       u32 pinsetup2;
>>> +       u32 event_level;
>>> +       u32 event_rising_edge;
>>> +       u32 event_falling_edge;
>>> +};
>>> +
>>> +struct ioctl_info_buffer {
>>> +       struct ioctl_header     header;
>>> +       struct ioctl_drv_info   information;
>>> +};
>>> +
>>> +struct gpio_buffer {
>>> +       struct ioctl_header     header;
>>> +       struct pm8001_gpio      gpio_payload;
>>> +};
>>> +
>>> +#define ADPT_IOCTL_INFO                _IOR(0, 0, struct
>>> ioctl_info_buffer *)
>>> +#define ADPT_IOCTL_GPIO                _IOWR(0, 1, struct  gpio_buffer *)
>>> +
>>>  #define IB_OB_READ_TIMES                256
>>>  #define SYSFS_OFFSET                    1024
>>>  #define PM80XX_IB_OB_QUEUE_SIZE         (32 * 1024)
>>> diff --git a/drivers/scsi/pm8001/pm8001_init.c
>>> b/drivers/scsi/pm8001/pm8001_init.c
>>> index 662bf13..ba2e659 100644
>>> --- a/drivers/scsi/pm8001/pm8001_init.c
>>> +++ b/drivers/scsi/pm8001/pm8001_init.c
>>> @@ -148,6 +148,8 @@ static void pm8001_free(struct pm8001_hba_info
>>> *pm8001_ha)
>>>         if (!pm8001_ha)
>>>                 return;
>>>
>>> +       del_timer(&pm8001_ha->ioctl_timer);
>>> +
>>>         for (i = 0; i < USI_MAX_MEMCNT; i++) {
>>>                 if (pm8001_ha->memoryMap.region[i].virt_ptr != NULL) {
>>>                         pci_free_consistent(pm8001_ha->pdev,
>>> @@ -444,6 +446,24 @@ static int pm8001_ioremap(struct pm8001_hba_info
>>> *pm8001_ha)
>>>         return 0;
>>>  }
>>>
>>> +void pm8001_ioctl_timer_callback(unsigned long data) {
>>> +       struct pm8001_hba_info *pm8001_ha = (struct pm8001_hba_info 
>>> +*)data;
>>> +
>>> +       PM8001_FAIL_DBG(pm8001_ha,
>>> +               pm8001_printk("Timer expired for GPIO response\n"));
>>> +
>>> +       spin_lock(&pm8001_ha->ioctl_lock);
>>> +
>>> +       if (pm8001_ha->ioctl_completion != NULL) {
>>> +               pm8001_ha->ioctl_timer_expired = 1;
>>> +               complete(pm8001_ha->ioctl_completion);
>>> +               pm8001_ha->ioctl_completion = NULL;
>>> +       }
>>> +
>>> +       spin_unlock(&pm8001_ha->ioctl_lock);
>>> +}
>>> +
>>>  /**
>>>   * pm8001_pci_alloc - initialize our ha card structure
>>>   * @pdev: pci device.
>>> @@ -479,6 +499,15 @@ static struct pm8001_hba_info 
>>> *pm8001_pci_alloc(struct pci_dev *pdev,
>>>         else
>>>                 pm8001_ha->iomb_size = IOMB_SIZE_SPC;
>>>
>>> +       mutex_init(&pm8001_ha->ioctl_mutex);
>>> +       pm8001_ha->ioctl_completion = NULL;
>>> +       init_waitqueue_head(&pm8001_ha->pollq);
>>> +       pm8001_ha->gpio_event_occured = 0;
>>> +       spin_lock_init(&pm8001_ha->ioctl_lock);
>>> +       setup_timer(&pm8001_ha->ioctl_timer, pm8001_ioctl_timer_callback,
>>> +                    (unsigned long)pm8001_ha);
>>> +
>>> +
>>>  #ifdef PM8001_USE_TASKLET
>>>         /**
>>>         * default tasklet for non msi-x interrupt handler/first msi-x 
>>> @@ -1147,8 +1176,15 @@ static int __init pm8001_init(void)
>>>         rc = pci_register_driver(&pm8001_pci_driver);
>>>         if (rc)
>>>                 goto err_tp;
>>> +
>>> +       rc = pm8001_setup_chrdev();
>>> +       if (rc)
>>> +               goto err_ctl;
>>> +
>>>         return 0;
>>>
>>> +err_ctl:
>>> +       pci_unregister_driver(&pm8001_pci_driver);
>>>  err_tp:
>>>         sas_release_transport(pm8001_stt);
>>>  err_wq:
>>> @@ -1162,6 +1198,7 @@ static void __exit pm8001_exit(void)
>>>         pci_unregister_driver(&pm8001_pci_driver);
>>>         sas_release_transport(pm8001_stt);
>>>         destroy_workqueue(pm8001_wq);
>>> +       pm8001_release_chrdev();
>>>  }
>>>
>>>  module_init(pm8001_init);
>>> diff --git a/drivers/scsi/pm8001/pm8001_sas.h
>>> b/drivers/scsi/pm8001/pm8001_sas.h
>>> index 9241c04..9171f0a 100644
>>> --- a/drivers/scsi/pm8001/pm8001_sas.h
>>> +++ b/drivers/scsi/pm8001/pm8001_sas.h
>>> @@ -51,14 +51,21 @@
>>>  #include <linux/pci.h>
>>>  #include <linux/interrupt.h>
>>>  #include <linux/workqueue.h>
>>> +#include <linux/poll.h>
>>> +#include <linux/poll.h>
>>> +#include <linux/timer.h>
>>>  #include <scsi/libsas.h>
>>>  #include <scsi/scsi_tcq.h>
>>>  #include <scsi/sas_ata.h>
>>>  #include <linux/atomic.h>
>>>  #include "pm8001_defs.h"
>>> +#include "pm8001_ctl.h"
>>>
>>>  #define DRV_NAME               "pm80xx"
>>>  #define DRV_VERSION            "0.1.37"
>>> +#define DRV_MAJOR              1
>>> +#define DRV_MINOR              0
>>> +#define DRV_BUILD              15
>>>  #define PM8001_FAIL_LOGGING    0x01 /* Error message logging */
>>>  #define PM8001_INIT_LOGGING    0x02 /* driver init logging */
>>>  #define PM8001_DISC_LOGGING    0x04 /* discovery layer logging */
>>> @@ -132,6 +139,17 @@ struct pm8001_ioctl_payload {
>>>         u8      *func_specific;
>>>  };
>>>
>>> +struct gpio_ioctl_resp {
>>> +       u32 tag;
>>> +       u32 gpio_rd_val;
>>> +       u32 gpio_in_enabled;
>>> +       u32 gpio_pinsetup1;
>>> +       u32 gpio_pinsetup2;
>>> +       u32 gpio_evt_change;
>>> +       u32 gpio_evt_rise;
>>> +       u32 gpio_evt_fall;
>>> +};
>>> +
>>>  #define MPI_FATAL_ERROR_TABLE_OFFSET_MASK 0xFFFFFF  #define 
>>> MPI_FATAL_ERROR_TABLE_SIZE(value) ((0xFF000000 & value) >> SHIFT24)
>>>  #define MPI_FATAL_EDUMP_TABLE_LO_OFFSET            0x00     /* HNFBUFL */
>>> @@ -229,6 +247,8 @@ struct pm8001_dispatch {
>>>         int (*sas_diag_execute_req)(struct pm8001_hba_info *pm8001_ha,
>>>                 u32 state);
>>>         int (*sas_re_init_req)(struct pm8001_hba_info *pm8001_ha);
>>> +       int (*gpio_req)(struct pm8001_hba_info *pm8001_ha,
>>> +               struct pm8001_gpio *gpio_payload);
>>>  };
>>>
>>>  struct pm8001_chip_info {
>>> @@ -527,6 +547,14 @@ struct pm8001_hba_info {
>>>         u32                     int_vector;
>>>         const struct firmware   *fw_image;
>>>         u8                      outq[PM8001_MAX_MSIX_VEC];
>>> +       struct completion       *ioctl_completion;
>>> +       struct mutex            ioctl_mutex;
>>> +       spinlock_t              ioctl_lock;
>>> +       u32                     gpio_event_occured;
>>> +       u32                     ioctl_timer_expired;
>>> +       struct timer_list       ioctl_timer;
>>> +       struct gpio_ioctl_resp  gpio_resp;
>>> +       wait_queue_head_t       pollq;
>>>  };
>>>
>>>  struct pm8001_work {
>>> @@ -705,5 +733,7 @@ ssize_t pm8001_get_gsm_dump(struct device *cdev, 
>>> u32, char *buf);
>>>  /* ctl shared API */
>>>  extern struct device_attribute *pm8001_host_attrs[];
>>>
>>> +int pm8001_setup_chrdev(void);
>>> +void pm8001_release_chrdev(void);
>>>  #endif
>>>
>>> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c
>>> b/drivers/scsi/pm8001/pm80xx_hwi.c
>>> index 4ebc79b..5423844 100644
>>> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
>>> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
>>> @@ -3481,6 +3481,54 @@ static int ssp_coalesced_comp_resp(struct 
>>> pm8001_hba_info *pm8001_ha,
>>>         return 0;
>>>  }
>>>
>>> +static int mpi_gpio_resp(struct pm8001_hba_info *pm8001_ha, void 
>>> +*piomb) {
>>> +       int ret;
>>> +       struct gpio_ioctl_resp *pgpio_resp;
>>> +       struct gpio_resp *ppayload = (struct gpio_resp *)(piomb + 4);
>>> +
>>> +       spin_lock(&pm8001_ha->ioctl_lock);
>>> +       if (pm8001_ha->ioctl_completion != NULL) {
>>> +               ret = del_timer(&pm8001_ha->ioctl_timer);
>>> +               if (ret)
>>> +                       PM8001_MSG_DBG(pm8001_ha,
>>> +                               pm8001_printk("The timer was still in
>>> use.\n"));
>>> +               pm8001_ha->ioctl_timer_expired = 0;
>>> +               pgpio_resp = &pm8001_ha->gpio_resp;
>>> +               pgpio_resp->gpio_rd_val =
>>> le32_to_cpu(ppayload->gpio_rd_val);
>>> +               pgpio_resp->gpio_in_enabled =
>>> +                       le32_to_cpu(ppayload->gpio_in_enabled);
>>> +               pgpio_resp->gpio_pinsetup1 =
>>> +                       le32_to_cpu(ppayload->gpio_pinsetup1);
>>> +               pgpio_resp->gpio_pinsetup2 =
>>> +                       le32_to_cpu(ppayload->gpio_pinsetup2);
>>> +               pgpio_resp->gpio_evt_change =
>>> +                       le32_to_cpu(ppayload->gpio_evt_change);
>>> +               pgpio_resp->gpio_evt_rise =
>>> +                       le32_to_cpu(ppayload->gpio_evt_rise);
>>> +               pgpio_resp->gpio_evt_fall =
>>> +                       le32_to_cpu(ppayload->gpio_evt_fall);
>>> +
>>> +               complete(pm8001_ha->ioctl_completion);
>>> +               pm8001_ha->ioctl_completion = NULL;
>>> +       }
>>> +       spin_unlock(&pm8001_ha->ioctl_lock);
>>> +       return 0;
>>> +}
>>> +
>>> +static int mpi_gpio_event(struct pm8001_hba_info *pm8001_ha, void 
>>> +*piomb) {
>>> +
>>> +       u32 gpio_event = 0;
>>> +       struct gpio_event *ppayload = (struct gpio_event *)(piomb + 4);
>>> +       gpio_event = le32_to_cpu(ppayload->gpio_event);
>>> +       PM8001_MSG_DBG(pm8001_ha,
>>> +                      pm8001_printk("GPIO event: 0x%X\n", gpio_event));
>>> +       pm8001_ha->gpio_event_occured = 1;
>>> +       wake_up_interruptible(&pm8001_ha->pollq);
>>> +       return 0;
>>> +}
>>> +
>>>  /**
>>>   * process_one_iomb - process one outbound Queue memory block
>>>   * @pm8001_ha: our hba card information @@ -3567,10 +3615,12 @@ 
>>> static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void 
>>> *piomb)
>>>         case OPC_OUB_GPIO_RESPONSE:
>>>                 PM8001_MSG_DBG(pm8001_ha,
>>>                         pm8001_printk("OPC_OUB_GPIO_RESPONSE\n"));
>>> +               mpi_gpio_resp(pm8001_ha, piomb);
>>>                 break;
>>>         case OPC_OUB_GPIO_EVENT:
>>>                 PM8001_MSG_DBG(pm8001_ha,
>>>                         pm8001_printk("OPC_OUB_GPIO_EVENT\n"));
>>> +               mpi_gpio_event(pm8001_ha, piomb);
>>>                 break;
>>>         case OPC_OUB_GENERAL_EVENT:
>>>                 PM8001_MSG_DBG(pm8001_ha, @@ -4510,6 +4560,61 @@ 
>>> static u32 pm80xx_chip_is_our_interupt(struct
>>> pm8001_hba_info *pm8001_ha)
>>>  }
>>>
>>>  /**
>>> + * pm80xx_chip_gpio_req - support for GPIO operation
>>> + * @pm8001_ha: our hba card information.
>>> + * @ioctl_payload: the payload for the GPIO operation */
>>> +
>>> +int pm80xx_chip_gpio_req(struct pm8001_hba_info *pm8001_ha,
>>> +                               struct pm8001_gpio *gpio_payload) {
>>> +       struct gpio_req payload;
>>> +       struct inbound_queue_table *circularQ;
>>> +       int ret;
>>> +       u32 tag;
>>> +       u32 opc = OPC_INB_GPIO;
>>> +
>>> +       if (pm8001_ha->pdev->subsystem_vendor == PCI_VENDOR_ID_ADAPTEC2)
>>> +               return ADPT_IOCTL_CALL_INVALID_DEVICE;
>>> +
>>> +       ret = pm8001_tag_alloc(pm8001_ha, &tag);
>>> +       if (ret)
>>> +               return -1;
>>> +
>>> +       memset(&payload, 0, sizeof(payload));
>>> +       circularQ = &pm8001_ha->inbnd_q_tbl[0];
>>> +       payload.tag = cpu_to_le32(tag);
>>> +       switch (gpio_payload->operation) {
>>> +       case GPIO_READ:
>>> +               payload.eobid_ge_gs_gr_gw = cpu_to_le32(GPIO_GR_BIT);
>>> +               break;
>>> +       case GPIO_WRITE:
>>> +               payload.eobid_ge_gs_gr_gw = cpu_to_le32(GPIO_GW_BIT);
>>> +               payload.gpio_wr_msk = cpu_to_le32(gpio_payload->mask);
>>> +               payload.gpio_wr_val = cpu_to_le32(gpio_payload->rd_wr_val);
>>> +               break;
>>> +       case GPIO_PINSETUP:
>>> +               payload.eobid_ge_gs_gr_gw = cpu_to_le32(GPIO_GS_BIT);
>>> +               payload.gpio_in_enabled =
>>> +                       cpu_to_le32(gpio_payload->input_enable);
>>> +               payload.gpio_pinsetup1 =
>>> cpu_to_le32(gpio_payload->pinsetup1);
>>> +               payload.gpio_pinsetup2 =
>>> cpu_to_le32(gpio_payload->pinsetup2);
>>> +               break;
>>> +       case GPIO_EVENTSETUP:
>>> +               payload.eobid_ge_gs_gr_gw = cpu_to_le32(GPIO_GE_BIT);
>>> +               payload.gpio_evt_change =
>>> +                       cpu_to_le32(gpio_payload->event_level);
>>> +               payload.gpio_evt_rise =
>>> +                       cpu_to_le32(gpio_payload->event_rising_edge);
>>> +               payload.gpio_evt_fall =
>>> +                       cpu_to_le32(gpio_payload->event_falling_edge);
>>> +               break;
>>> +       }
>>> +       ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
>>> +       return ret;
>>> +}
>>> +
>>> +/**
>>>   * pm8001_chip_isr - PM8001 isr handler.
>>>   * @pm8001_ha: our hba card information.
>>>   * @irq: irq number.
>>> @@ -4589,4 +4694,5 @@ const struct pm8001_dispatch pm8001_80xx_dispatch = {
>>>         .set_nvmd_req           = pm8001_chip_set_nvmd_req,
>>>         .fw_flash_update_req    = pm8001_chip_fw_flash_update_req,
>>>         .set_dev_state_req      = pm8001_chip_set_dev_state_req,
>>> +       .gpio_req               = pm80xx_chip_gpio_req,
>>>  };
>>> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h
>>> b/drivers/scsi/pm8001/pm80xx_hwi.h
>>> index c86816b..671940a 100644
>>> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
>>> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
>>> @@ -422,6 +422,55 @@ struct hw_event_ack_req {  } 
>>> __attribute__((packed, aligned(4)));
>>>
>>>  /*
>>> + * brief the data structure of GPIO Commannd
>>> + * use to control MPI GPIOs (64 bytes)  */ struct gpio_req {
>>> +       __le32  tag;
>>> +       __le32  eobid_ge_gs_gr_gw;
>>> +       __le32  gpio_wr_msk;
>>> +       __le32  gpio_wr_val;
>>> +       __le32  gpio_in_enabled;
>>> +       __le32  gpio_pinsetup1;
>>> +       __le32  gpio_pinsetup2;
>>> +       __le32  gpio_evt_change;
>>> +       __le32  gpio_evt_rise;
>>> +       __le32  gpio_evt_fall;
>>> +       u32     reserved[5];
>>> +} __attribute__((packed, aligned(4)));
>>> +
>>> +#define GPIO_GW_BIT 0x1
>>> +#define GPIO_GR_BIT 0x2
>>> +#define GPIO_GS_BIT 0x4
>>> +#define GPIO_GE_BIT 0x8
>>> +
>>> +/*
>>> + * brief the data structure of GPIO Response
>>> + * indicates the completion of GPIO command (64 bytes)  */ struct 
>>> +gpio_resp {
>>> +       __le32  tag;
>>> +       u32     reserved[2];
>>> +       __le32  gpio_rd_val;
>>> +       __le32  gpio_in_enabled;
>>> +       __le32  gpio_pinsetup1;
>>> +       __le32  gpio_pinsetup2;
>>> +       __le32  gpio_evt_change;
>>> +       __le32  gpio_evt_rise;
>>> +       __le32  gpio_evt_fall;
>>> +       u32     reserved1[5];
>>> +} __attribute__((packed, aligned(4)));
>>> +
>>> +/*
>>> + * brief the data structure of GPIO Event
>>> + * indicates the generation of GPIO event (64 bytes)  */ struct 
>>> +gpio_event {
>>> +       __le32  gpio_event;
>>> +       u32     reserved[14];
>>> +} __attribute__((packed, aligned(4)));
>>> +
>>> +/*
>>>   * brief the data structure of PHY_START Response Command
>>>   * indicates the completion of PHY_START command (64 bytes)
>>>   */
>>> --
>>> 1.7.1
>>>
>>
> 

