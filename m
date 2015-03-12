From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH ] tcm_qla2xxx  Add SCSI command jammer/discard capabilty
 to the tcm_qla2xxx module
Date: Thu, 12 Mar 2015 19:55:49 -0400 (EDT)
Message-ID: <2044107702.15900790.1426204549814.JavaMail.zimbra@redhat.com>
References: <588344732.13485469.1425769450275.JavaMail.zimbra@redhat.com> <1069288785.13490592.1425785175883.JavaMail.zimbra@redhat.com> <504EB66DAC8D234EB8E8560985C2D7AD46DBC279@avmb2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:49713 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbCLXz5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2015 19:55:57 -0400
In-Reply-To: <504EB66DAC8D234EB8E8560985C2D7AD46DBC279@avmb2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>
Cc: Andy Grover <agrover@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, nab@daterainc.com, Laurence Oberman <oberman.l@gmail.com>, Bart Van Assche <bart.vanassche@sandisk.com>

Hello Quinn Tran

Thank you for the feedback. There is a revision2 of this patch I sent as a follow on to Bart that is much cleaner but its still exposed to the memory leaks.
The newer version has a single jam_host parameter as suggested by Bart and the messaging removed. Have a look for it.
Bart also suggested moving the discard to a higher layer in his most recent response to allow other transports to benefit as well.

I have used this a lot but and its been extremely useful, but never used it for extended periods and specifically to test servers connected via F/C to to the LIO host.
I was concerned that we had a dangling allocation after discard but never saw the leak show up significantly in my testing. 
Mostly because my test servers are in error recovery and waiting on timeouts.
Where I placed the discard seemed to be the safest pace for my particular use case. 
I did use other options like zeroing the cdb and passing the command on to avoid the dangling allocation, to force lots of underruns on the host during testing.

Let me revisit my most recent version and take care of the memory leak exposure and look into your other suggestions.
I will reply in that latest thread with a new version.

Many Thanks for the consideration

Laurence

Laurence Oberman
Red Hat Global Support Service
SEG Team

----- Original Message -----
From: "Quinn Tran" <quinn.tran@qlogic.com>
To: "Laurence Oberman" <loberman@redhat.com>, "Andy Grover" <agrover@redhat.com>, "linux-scsi" <linux-scsi@vger.kernel.org>, nab@daterainc.com
Cc: "Laurence Oberman" <oberman.l@gmail.com>
Sent: Thursday, March 12, 2015 6:07:08 PM
Subject: Re: [PATCH ] tcm_qla2xxx  Add SCSI command jammer/discard capabilty to the tcm_qla2xxx module

This idea definitely help flush out additional interaction issues between
fabric drivers and TCM.

However, the current spot where the error injection is placed will cause
memory leak.  The error injection tries to drop the command before
submission to TCM.  TCM & QLA drivers will loose track of this command.
The test will be short live if enough memory have been leaked.  May be the
command should be drop before mem allocation.

In addition, it would nice if the other spots can be included such as:
queue_status(), queue_data_in, aborted_task(), queue_tm_rsp() &
target_submit_tmr().

If the intend is to test all adapters, then the error injection need to be
move higher up into TCM driver.


Regards,
Quinn Tran




On 3/7/15, 8:26 PM, "Laurence Oberman" <loberman@redhat.com> wrote:

>Hello
>
>I use target LIO for all my storage array test targets and customer
>problem resolution here at Red Hat.
>This patch resulted from a requirement to mimic behaviour of an expensive
>hardware jammer for a customer.
>I have used this for some time with good success to simulate and
>reproduce latency and slow drain fabric issues and
>for testing and validating error handling behaviour in the Emulex, Qlogic
>and other F/C drivers.
>
>Works by checking jammer_flag==1 and host # and discards SCSI command,
>controlled using echo to sys parameter.
>
>I decided to share the patch, in the hope it may be useful for others but
>I do understand this is a special use case.
>If this is useful and Nab wants to include it I will create a proper
>documentation patch as well.
>
>filename:       
>/lib/modules/3.17.7-200.jammer.fc20.x86_64/kernel/drivers/scsi/qla2xxx/tcm
>_qla2xxx.ko
>license:        GPL
>description:    TCM QLA2XXX series NPIV enabled fabric driver
>depends:        target_core_mod,qla2xxx,scsi_transport_fc
>intree:         Y
>vermagic:       3.17.7-200.jammer.fc20.x86_64 SMP mod_unload
>parm:           jammer_flag:Set to 1: Enable jammer (int)
>parm:           host_flag:host number to match on (int)
>
>
>Enable host 6 to be jammed
>echo 6 > /sys/module/tcm_qla2xxx/parameters/host_flag
>
>Usage example script:
>
>#!/bin/bash
>host=`cat /sys/module/tcm_qla2xxx/parameters/host_flag`
>sleep_time=120  ### Time to jam for
>echo "We start to discard commands on SCSI host $host"
>logger "Jammer started"
>echo 1 >  /sys/module/tcm_qla2xxx/parameters/jammer_flag
>sleep $sleep_time
>echo 0 >  /sys/module/tcm_qla2xxx/parameters/jammer_flag
>echo "We stopped the jammer"
>logger "Jammer stopped"
>
>This Patch diff against 3.19.1
>
>Tested by: Laurence Oberman <loberman@redhat.com>
>Signed-off-by: Laurence Oberman <loberman@redhat.com>
>
>diff -Nurp a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c	2015-03-07 18:35:15.246737589
>-0500
>+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c	2015-03-07 18:35:40.168599630
>-0500
>@@ -50,6 +50,14 @@
> #include "qla_target.h"
> #include "tcm_qla2xxx.h"
> 
>+int message_flag=0;
>+int jammer_flag = 0;
>+module_param(jammer_flag, int,0644);
>+MODULE_PARM_DESC(jammer_flag, "If set to 1: Enable jammer");
>+int host_flag=0;
>+module_param(host_flag, int,0644);
>+MODULE_PARM_DESC(host_flag, "host number to match on");
>+
> static struct workqueue_struct *tcm_qla2xxx_free_wq;
> static struct workqueue_struct *tcm_qla2xxx_cmd_wq;
> 
>@@ -570,6 +578,22 @@ static int tcm_qla2xxx_handle_cmd(scsi_q
> 		pr_err("Unable to locate active struct se_session\n");
> 		return -EINVAL;
> 	}
>+	
>+ 	// Control messaging here
>+	message_flag += jammer_flag;
>+	if(message_flag == 1)
>+		printk("tcm_qla2xx:SCSI Jammer enabled on host %d\n",host_flag);
>+	if((jammer_flag == 0) && (message_flag >=0)) {
>+		printk("tcm_qla2xx:SCSI Jammer stopped, %d SCSI commands discarded for
>host %d\n",message_flag,host_flag);
>+		message_flag=-1;
>+	}
>+		
>+	if ((vha->host_no == host_flag) && (jammer_flag == 1))
>+	{
>+		// return, and don't run target_submit_cmd, effectively discarding
>command
>+		return 0;
>+	}
>+
> 
> 	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
> 				cmd->unpacked_lun, data_length, fcp_task_attr,
>@@ -2165,6 +2189,7 @@ static void tcm_qla2xxx_deregister_confi
> static int __init tcm_qla2xxx_init(void)
> {
> 	int ret;
>+	jammer_flag = 0;
> 
> 	ret = tcm_qla2xxx_register_configfs();
> 	if (ret < 0)
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

