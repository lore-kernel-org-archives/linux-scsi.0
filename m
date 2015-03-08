From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH ] tcm_qla2xxx  Add SCSI command jammer/discard capabilty
 to the tcm_qla2xxx module - revision2
Date: Sun, 8 Mar 2015 11:38:15 -0400 (EDT)
Message-ID: <629323685.13531146.1425829095558.JavaMail.zimbra@redhat.com>
References: <1069288785.13490592.1425785175883.JavaMail.zimbra@redhat.com> <54FC03FA.6000005@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:38432 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbbCHPiX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2015 11:38:23 -0400
In-Reply-To: <54FC03FA.6000005@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org, nab@daterainc.com, Laurence Oberman <oberman.l@gmail.com>

Hello Bart,
Thanks

Here is revision2

I added unlikely and removed messaging control as it not necessary and adds overhead.

I use target LIO for all my storage array test targets and customer problem resolution here at Red Hat.
This patch resulted from a requirement to mimic behaviour of an expensive hardware jammer for a customer.
I have used this for some time with good success to simulate and reproduce latency and slow drain fabric issues and
for testing and validating error handling behaviour in the Emulex, Qlogic and other F/C drivers.

Works by checking new parameter jam_host if its >= 0 and matches vha->host_no , jamming is enabled when jam_host >=0
If parameter set to -1 (default) no jamming is enabled. 
I decided to share the patch, in the hope it may be useful for others but I do understand this is a special use case.


This Patch diff against 3.19.1

$ linux-3.19.1/scripts/checkpatch.pl latest-upstream-jammer-path 
total: 0 errors, 0 warnings, 60 lines checked

latest-upstream-jammer-path has no obvious style problems and is ready for submission.

Tested by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>

diff -Nurp a/Documentation/scsi/tcm_qla2xxx.txt b/Documentation/scsi/tcm_qla2xxx.txt
--- a/Documentation/scsi/tcm_qla2xxx.txt	1969-12-31 19:00:00.000000000 -0500
+++ b/Documentation/scsi/tcm_qla2xxx.txt	2015-03-08 11:32:42.262181821 -0400
@@ -0,0 +1,30 @@
+tcm_qla2xxx jammer parameter usage
+----------------------------------
+There is now a new module parameter added to the tcm_qla2xx module
+parm:           jam_host:Host to jam >=0 Enable jammer (int)
+
+Use this parameter to control the discarding of SCSI commands to a selected host.
+This may be useful for testing error handling and simulating slow drain and other
+fabric issues.
+
+Any value >=0 that matches a fc_host # will discard the commands for that host.
+Reset back to -1 to stop the jamming.
+
+Enable host 6 to be jammed
+echo 6 > /sys/module/tcm_qla2xxx/parameters/jam_host
+
+Disable jamming on host 6
+echo -1 > /sys/module/tcm_qla2xxx/parameters/jam_host
+
+Usage example script:
+
+#!/bin/bash
+sleep_time=120  ### Time to jam for
+echo 6 >  /sys/module/tcm_qla2xxx/parameters/jam_host
+host=`cat /sys/module/tcm_qla2xxx/parameters/jam_host`
+echo "We start to discard commands on SCSI host $host"
+logger "Jammer started"
+sleep $sleep_time
+echo -1 >  /sys/module/tcm_qla2xxx/parameters/jam_host
+echo "We stopped the jammer"
+logger "Jammer stopped"
diff -Nurp a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c	2015-03-08 10:13:31.798400426 -0400
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c	2015-03-08 11:00:53.002419568 -0400
@@ -50,6 +50,10 @@
 #include "qla_target.h"
 #include "tcm_qla2xxx.h"
 
+int jam_host = -1;
+module_param(jam_host, int, 0644);
+MODULE_PARM_DESC(jam_host, "Host to jam >=0 Enable jammer");
+
 static struct workqueue_struct *tcm_qla2xxx_free_wq;
 static struct workqueue_struct *tcm_qla2xxx_cmd_wq;
 
@@ -571,6 +575,13 @@ static int tcm_qla2xxx_handle_cmd(scsi_q
 		return -EINVAL;
 	}
 
+	if (unlikely(vha->host_no == jam_host)) {
+		/*
+		return, and dont run target_submit_cmd, discarding command
+		*/
+		return 0;
+	}
+
 	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
 				cmd->unpacked_lun, data_length, fcp_task_attr,
 				data_dir, flags);
@@ -2165,6 +2176,7 @@ static void tcm_qla2xxx_deregister_confi
 static int __init tcm_qla2xxx_init(void)
 {
 	int ret;
+	jam_host = -1;
 
 	ret = tcm_qla2xxx_register_configfs();
 	if (ret < 0)





Thanks you for the consideration

Laurence Oberman
Red Hat Global Support Service
SEG Team

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche@sandisk.com>
To: "Laurence Oberman" <loberman@redhat.com>, "Andy Grover" <agrover@redhat.com>, linux-scsi@vger.kernel.org, nab@daterainc.com
Cc: "Laurence Oberman" <oberman.l@gmail.com>
Sent: Sunday, March 8, 2015 4:10:34 AM
Subject: Re: [PATCH ] tcm_qla2xxx  Add SCSI command jammer/discard capabilty to the tcm_qla2xxx module


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
