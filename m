From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH ] tcm_qla2xxx  Add SCSI command jammer/discard capabilty
 to the tcm_qla2xxx module
Date: Sun, 08 Mar 2015 09:10:34 +0100
Message-ID: <54FC03FA.6000005@sandisk.com>
References: <1069288785.13490592.1425785175883.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:34480 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbbCHIKx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Mar 2015 04:10:53 -0400
In-Reply-To: <1069288785.13490592.1425785175883.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>, Andy Grover <agrover@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, nab@daterainc.com
Cc: Laurence Oberman <oberman.l@gmail.com>


On 03/08/2015 04:26 AM, Laurence Oberman wrote:
> Hello
>
> I use target LIO for all my storage array test targets and customer problem resolution here at Red Hat.
> This patch resulted from a requirement to mimic behaviour of an expensive hardware jammer for a customer.
> I have used this for some time with good success to simulate and reproduce latency and slow drain fabric issues and
> for testing and validating error handling behaviour in the Emulex, Qlogic and other F/C drivers.
>
> Works by checking jammer_flag==1 and host # and discards SCSI command, controlled using echo to sys parameter.
>
> I decided to share the patch, in the hope it may be useful for others but I do understand this is a special use case.
> If this is useful and Nab wants to include it I will create a proper documentation patch as well.
>
> filename:       /lib/modules/3.17.7-200.jammer.fc20.x86_64/kernel/drivers/scsi/qla2xxx/tcm_qla2xxx.ko
> license:        GPL
> description:    TCM QLA2XXX series NPIV enabled fabric driver
> depends:        target_core_mod,qla2xxx,scsi_transport_fc
> intree:         Y
> vermagic:       3.17.7-200.jammer.fc20.x86_64 SMP mod_unload
> parm:           jammer_flag:Set to 1: Enable jammer (int)
> parm:           host_flag:host number to match on (int)
>
>
> Enable host 6 to be jammed
> echo 6 > /sys/module/tcm_qla2xxx/parameters/host_flag
>
> Usage example script:
>
> #!/bin/bash
> host=`cat /sys/module/tcm_qla2xxx/parameters/host_flag`
> sleep_time=120  ### Time to jam for
> echo "We start to discard commands on SCSI host $host"
> logger "Jammer started"
> echo 1 >  /sys/module/tcm_qla2xxx/parameters/jammer_flag
> sleep $sleep_time
> echo 0 >  /sys/module/tcm_qla2xxx/parameters/jammer_flag
> echo "We stopped the jammer"
> logger "Jammer stopped"
>
> This Patch diff against 3.19.1
>
> Tested by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
>
> diff -Nurp a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c	2015-03-07 18:35:15.246737589 -0500
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c	2015-03-07 18:35:40.168599630 -0500
> @@ -50,6 +50,14 @@
>   #include "qla_target.h"
>   #include "tcm_qla2xxx.h"
>
> +int message_flag=0;
> +int jammer_flag = 0;
> +module_param(jammer_flag, int,0644);
> +MODULE_PARM_DESC(jammer_flag, "If set to 1: Enable jammer");
> +int host_flag=0;
> +module_param(host_flag, int,0644);
> +MODULE_PARM_DESC(host_flag, "host number to match on");
> +
>   static struct workqueue_struct *tcm_qla2xxx_free_wq;
>   static struct workqueue_struct *tcm_qla2xxx_cmd_wq;
>
> @@ -570,6 +578,22 @@ static int tcm_qla2xxx_handle_cmd(scsi_q
>   		pr_err("Unable to locate active struct se_session\n");
>   		return -EINVAL;
>   	}
> +	
> + 	// Control messaging here
> +	message_flag += jammer_flag;
> +	if(message_flag == 1)
> +		printk("tcm_qla2xx:SCSI Jammer enabled on host %d\n",host_flag);
> +	if((jammer_flag == 0) && (message_flag >=0)) {
> +		printk("tcm_qla2xx:SCSI Jammer stopped, %d SCSI commands discarded for host %d\n",message_flag,host_flag);
> +		message_flag=-1;
> +	}
> +		
> +	if ((vha->host_no == host_flag) && (jammer_flag == 1))
> +	{
> +		// return, and don't run target_submit_cmd, effectively discarding command
> +		return 0;
> +	}
> +
>
>   	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
>   				cmd->unpacked_lun, data_length, fcp_task_attr,
> @@ -2165,6 +2189,7 @@ static void tcm_qla2xxx_deregister_confi
>   static int __init tcm_qla2xxx_init(void)
>   {
>   	int ret;
> +	jammer_flag = 0;
>
>   	ret = tcm_qla2xxx_register_configfs();
>   	if (ret < 0)

The above code is added in the hot path so it's worth to optimize that 
code. Had you already considered to combine the jammer_flag and 
host_flag kernel module parameters into a single parameter, e.g. 
"jam_host" ? The value "-1" could be used to represent "jamming 
disabled" and values >= 0 to represent a host number.

Additionally, please add unlikely() around the test that verifies 
whether jamming is enabled. Please also verify your patches with 
checkpatch before submission. The above patch does not follow the Linux 
kernel coding style completely.

Bart.
