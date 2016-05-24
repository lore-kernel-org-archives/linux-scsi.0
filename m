From: Bryant G Ly <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Tue, 24 May 2016 16:00:47 -0400
Message-ID: <20160524160047.Horde.M1bK0S-HUnY41nXa9ZoJ6w1@ltc.linux.ibm.com>
References: <1464097978-88457-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <3303bc98-ade7-62f0-71c7-11e7ef42b42d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <3303bc98-ade7-62f0-71c7-11e7ef42b42d@sandisk.com>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, tyreld@linux.vnet.ibm.com, akpm@linux-foundation.org, kvalo@codeaurora.org, davem@davemloft.net, gregkh@linuxfoundation.org, mchehab@osg.samsung.com, jslaby@suse.com, joe@perches.com, bp@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bgly <bgly@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org


Quoting Bart Van Assche <bart.vanassche@sandisk.com>:

> On 05/24/2016 06:52 AM, Bryant G. Ly wrote:
>> +config SCSI_IBMVSCSIS
>> +  	tristate "IBM Virtual SCSI Server support"
>> +  	depends on PPC_PSERIES && SCSI_SRP && TARGET_CORE
>> +  	help
>> +  	  This is the IBM POWER Virtual SCSI Target Server
>> +
>> +          The userspace component needed to initialize the driver and
>> +  	  documentation can be found:
>> +
>> +          https://github.com/powervm/ibmvscsis
>> +
>> +          To compile this driver as a module, choose M here: the
>> +  	  module will be called ibmvstgt.
>> +
>
> This driver has confused Linux users before. Most people know SRP as  
> a SCSI transport layer that is used for communication between  
> servers. This driver however uses the SRP protocol for communication  
> between guests and/or the host that run on the same server. Please  
> add this information to the above help text, together with a  
> reference to the VIO protocol documentation in the POWER  
> architecture manual.
>

Done

>> +#include <generated/utsrelease.h>
>
> Every Linux user can query the kernel version by running the uname  
> command. Is it really useful to print the kernel version  
> (UTS_RELEASE) when this driver is loaded?
>

Done

>> +#include "ibmvscsi.h"
>
> The above include directive indirectly includes a whole bunch of  
> SCSI initiator driver header files. We do not want that initiator  
> header files are included in the source code of a target driver. If  
> it is necessary to share definitions of symbolic constants between  
> the initiator and the target driver please move these into a new  
> header file.
>

Done

>> +static inline long h_send_crq(struct ibmvscsis_adapter *adapter,
>> +			u64 word1, u64 word2)
>> +{
>> +	long rc;
>> +	struct vio_dev *vdev = adapter->dma_dev;
>> +
>> +	pr_debug("ibmvscsis: ibmvscsis_send_crq(0x%x, 0x%016llx, 0x%016llx)\n",
>> +			vdev->unit_address, word1, word2);
>> +
>
> As Joe Perches already asked, please define pr_fmt() instead of  
> including the kernel module name in every pr_debug() statement.
>

Done

>> +static char system_id[64] = "";
>> +static char partition_name[97] = "UNKNOWN";
>
> Where do these magic constants come from and what is their meaning?  
> Please consider to introduce symbolic names for these constants.
>

Done

>> +static ssize_t ibmvscsis_tpg_enable_show(struct config_item *item,
>> +				char *page)
>> +{
>> +	struct se_portal_group *se_tpg = to_tpg(item);
>> +	struct ibmvscsis_tport *tport = container_of(se_tpg,
>> +						struct ibmvscsis_tport, se_tpg);
>> +
>> +	return snprintf(page, PAGE_SIZE, "%d\n", (tport->enabled) ? 1 : 0);
>> +}
>
> Have you considered to use MODULE_VERSION() instead of introducing a  
> sysfs attribute to export the module version? An advantage of  
> MODULE_VERSION() is that it allows to query the module version  
> without having to load a kernel module.
>

Done

>> +static void ibmvscsis_modify_std_inquiry(struct se_cmd *se_cmd)
>> +{
>> +	struct se_device *dev = se_cmd->se_dev;
>> +	unsigned char *buf = NULL;
>> +	u32 cmd_len = se_cmd->data_length;
>> +
>> +	if (cmd_len <= INQ_DATA_OFFSET)
>> +		return;
>> +
>> +	buf = transport_kmap_data_sg(se_cmd);
>> +	if (buf) {
>> +		memcpy(&buf[8], "IBM	     ", 8);
>> +		if (dev->transport->get_device_type(dev) == TYPE_ROM)
>> +			memcpy(&buf[16], "VOPTA           ", 16);
>> +		else
>> +			memcpy(&buf[16], "3303      NVDISK", 16);
>> +		memcpy(&buf[32], "0001", 4);
>> +		transport_kunmap_data_sg(se_cmd);
>> +	}
>> +}
>
> Shouldn't a sense code be returned to the initiator if this function fails?
>

This function never fails? Also this is a temporary function that will go away
soon. It's to address AIX not recognizing target emulation of inquiry, but
we have already discussed internally to add these ODM entries into AIX.

>> +	default:
>> +		pr_err("ibmvscsis: unknown task mgmt func %d\n",
>> +						srp_tsk->tsk_mgmt_func);
>> +		cmd->se_cmd.se_tmr_req->response =
>> +					TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
>> +		rc = -1;
>> +		break;
>> +	}
>> +
>> +	if (!rc) {
>
> Please consider changing the above "break" into "goto fail" such  
> that the if (!rc) can be left out and such that the indentation of  
> the code below if (!rc) can be reduced.
>

Done

>> +static int ibmvscsis_queuecommand(struct ibmvscsis_adapter *adapter,
>> +				  struct iu_entry *iue)
>> +{
>> +	struct srp_cmd *cmd = iue->sbuf->buf;
>> +	struct scsi_cmnd *sc;
>> +	struct ibmvscsis_cmnd *vsc;
>> +	int ret;
>> +
>> +	pr_debug("ibmvscsis: ibmvscsis_queuecommand\n");
>> +
>> +	vsc = kzalloc(sizeof(*vsc), GFP_KERNEL);
>
> Allocating memory in the command processing path in a SCSI driver  
> usually causes suboptimal performance. Other LIO target drivers  
> preallocate such buffers before I/O starts.
>

We have a version of this driver that uses preallocation of the buffers.
It's not currently being pushed up for review because it was written by
referencing the internal VIOS VSCSI driver. Once our lawyers have approved
the open-sourcing of the internal driver we will push up patches to address
this issue and add a lot more features.

>> +static uint64_t ibmvscsis_unpack_lun(const uint8_t *lun, int len)
>> +{
>> +	uint64_t res = NO_SUCH_LUN;
>> +	int addressing_method;
>> +
>> +	if (unlikely(len < 2)) {
>> +		pr_err("Illegal LUN length %d, expected 2 bytes or more\n",
>> +			len);
>> +		goto out;
>> +	}
>> +
>> +	switch (len) {
>> +	case 8:
>> +		if ((*((__be64 *)lun) & cpu_to_be64(0x0000FFFFFFFFFFFFLL)) != 0)
>> +			goto out_err;
>> +		break;
>> +	case 4:
>> +		if (*((__be16 *)&lun[2]) != 0)
>> +			goto out_err;
>> +		break;
>> +	case 6:
>> +		if (*((__be32 *)&lun[2]) != 0)
>> +			goto out_err;
>> +		break;
>> +	case 2:
>> +		break;
>> +	default:
>> +		goto out_err;
>> +	}
>> +
>> +	addressing_method = (*lun) >> 6; /* highest two bits of byte 0 */
>> +	switch (addressing_method) {
>> +	case SCSI_LUN_ADDR_METHOD_PERIPHERAL:
>> +	case SCSI_LUN_ADDR_METHOD_FLAT:
>> +	case SCSI_LUN_ADDR_METHOD_LUN:
>> +		res = *(lun + 1) | (((*lun) & 0x3f) << 8);
>> +		break;
>> +
>> +	case SCSI_LUN_ADDR_METHOD_EXTENDED_LUN:
>> +	default:
>> +		pr_err("Unimplemented LUN addressing method %u\n",
>> +			addressing_method);
>> +		break;
>> +	}
>> +
>> +out:
>> +	return res;
>> +out_err:
>> +	pr_err("Support for multi-level LUNs has not yet been implemented\n");
>> +	goto out;
>> +}
>
> In the above function there is nothing that is specific to the VIO  
> mechanism. Please consider to merge this function with  
> scsilun_to_int(), e.g. by introducing a new function that accepts a  
> SCSI LUN and the addressing method as arguments and by making  
> scsilun_to_int() call that function with  
> SCSI_LUN_ADDR_METHOD_PERIPHERAL as one of its arguments.
>

We are going to keep this here atm, until we can make sure canonical  
can pick up
these changes, since we have a deliverable for a 3rd party vendor who  
is going to
fully utilize this driver. Once they can pick it up in 4.4 kernel I  
will make the
change you recommended / move the scsi_lun_addr_method addressed  
below. I will also
address the changes that ib_srpt needs to utilize this new function too.

>> +struct inquiry_data {
>> +	u8 qual_type;
>> +	u8 rmb_reserve;
>> +	u8 version;
>> +	u8 aerc_naca_hisup_format;
>> +	u8 addl_len;
>> +	u8 sccs_reserved;
>> +	u8 bque_encserv_vs_multip_mchngr_reserved;
>> +	u8 reladr_reserved_linked_cmdqueue_vs;
>> +	char vendor[8];
>> +	char product[16];
>> +	char revision[4];
>> +	char vendor_specific[20];
>> +	char reserved1[2];
>> +	char version_descriptor[16];
>> +	char reserved2[22];
>> +	char unique[158];
>> +};
>
> Is this the inquiry data response format from SPC? If so, this is a  
> structure definition that is useful for the SCSI initiator core and  
> also for other LIO target drivers. There might be a more appropriate  
> header file for this definition.
>

It is from the SPC, but it was already defined. So I removed this and
my driver wasn't using it atm anyways.

>> +enum scsi_lun_addr_method {
>> +	SCSI_LUN_ADDR_METHOD_PERIPHERAL   = 0,
>> +	SCSI_LUN_ADDR_METHOD_FLAT         = 1,
>> +	SCSI_LUN_ADDR_METHOD_LUN          = 2,
>> +	SCSI_LUN_ADDR_METHOD_EXTENDED_LUN = 3,
>> +};
>
> Same comment here.
>
Comment from above.

>> diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
>> new file mode 100644
>> index 0000000..0e32abd
>> --- /dev/null
>> +++ b/drivers/scsi/libsrp.c
>> @@ -0,0 +1,387 @@
>> +/*******************************************************************************
>> + * SCSI RDMA Protocol lib functions
>
> My understanding of the VIO mechanism is that the invocation of  
> H_COPY_RDMA is synchronous. This means that this operation only  
> finishes after the data has been transferred. If I interpret the  
> code in libsrp.c and libsrp.h correctly then this code can only be  
> used by SRP drivers use synchronous data transfers and not by SRP  
> drivers that use asynchronous data transfers. This means that this  
> code is not useful for any of the SRP drivers that are already  
> upstream (ib_srp and ib_srpt). Hence my proposal to move the  
> libsrp.c and libsrp.h source files from drivers/scsi and  
> include/scsi to the same directory as the ibmvscsis driver.
>
Done

Thanks for the reviews thus far, I apologize for some of the styling  
problems that
Joe had pointed out. I didn't run --strict against the patch and had  
missed a lot of
stuff. It's also my first time working with the Linux community, so I  
apologize.

-Bryant
