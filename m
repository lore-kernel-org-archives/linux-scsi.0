From: Laurence Oberman <loberman@redhat.com>
Subject: Re: tcm_qla2xxx Add SCSI command jammer/discard capabilty to the
 tcm_qla2xxx module - revision4
Date: Sat, 2 Apr 2016 12:04:54 -0400 (EDT)
Message-ID: <1615130599.26684873.1459613094650.JavaMail.zimbra@redhat.com>
References: <2025450295.25603731.1459262558755.JavaMail.zimbra@redhat.com> <56FB5E98.9010103@sandisk.com> <1459402453.31390.45.camel@haakon3.risingtidesystems.com> <3F517A19-EDA5-4B16-B103-C3F38242F8D8@qlogic.com> <1049122887.26432420.1459534525185.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:45397 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbcDBQFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2016 12:05:01 -0400
In-Reply-To: <1049122887.26432420.1459534525185.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>

Hello Himanshu

This patch was reworked to only include the jammer code if the paramete=
r TCM_QLA2XXX_DEBUG=3DY is set.
The default is to not provide this functionality at all.
I looked at using attributes but this code is in the fastpath and the o=
verhead or fetching the attribute
each time is not a good idea.=20
Control of this needs to be dynamic and the module parameter allows a s=
imple compare in the fastpath.

Patch notes
------------
I use target LIO for all my storage array test targets and customer pro=
blem resolution here at Red Hat.
This patch resulted from a requirement to mimic behavior of an expensiv=
e hardware jammer for a customer.
I have used this for some time with good success to simulate and reprod=
uce latency and slow drain fabric issues and
for testing and validating error handling behavior  in the Emulex, Qlog=
ic and other F/C drivers.

Works by checking new parameter jam_host if its >=3D 0 and matches vha-=
>host_no , jamming is enabled when jam_host >=3D0
If parameter set to -1 (default) no jamming is enabled.=20

Tested by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>

diff -Nurp linux-4.5/Documentation/scsi/tcm_qla2xxx.txt linux-4.5.new/D=
ocumentation/scsi/tcm_qla2xxx.txt
--- linux-4.5/Documentation/scsi/tcm_qla2xxx.txt	1969-12-31 19:00:00.00=
0000000 -0500
+++ linux-4.5.new/Documentation/scsi/tcm_qla2xxx.txt	2016-04-02 11:36:4=
2.693081232 -0400
@@ -0,0 +1,34 @@
+tcm_qla2xxx jammer parameter usage
+----------------------------------
+There is now a new module parameter added to the tcm_qla2xx module
+parm:           jam_host:Host to jam >=3D0 Enable jammer (int)
+This parameter and accompanying code is only included if the=20
+Kconfig parameter TCM_QLA2XXX_DEBUG is set to Y
+By default this jammer code and functionality is disabled
+
+Use this parameter to control the discarding of SCSI commands to a sel=
ected
+host.
+This may be useful for testing error handling and simulating slow drai=
n
+and other fabric issues.
+
+Any value >=3D0 that matches a fc_host # will discard the commands for=
 that host.
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
+sleep_time=3D120  ### Time to jam for
+echo 6 >  /sys/module/tcm_qla2xxx/parameters/jam_host
+host=3D`cat /sys/module/tcm_qla2xxx/parameters/jam_host`
+echo "We start to discard commands on SCSI host $host"
+logger "Jammer started"
+sleep $sleep_time
+echo -1 >  /sys/module/tcm_qla2xxx/parameters/jam_host
+echo "We stopped the jammer"
+logger "Jammer stopped"
diff -Nurp linux-4.5/drivers/scsi/qla2xxx/Kconfig linux-4.5.new/drivers=
/scsi/qla2xxx/Kconfig
--- linux-4.5/drivers/scsi/qla2xxx/Kconfig	2016-03-14 00:28:54.00000000=
0 -0400
+++ linux-4.5.new/drivers/scsi/qla2xxx/Kconfig	2016-04-02 11:31:15.3025=
16676 -0400
@@ -36,3 +36,13 @@ config TCM_QLA2XXX
 	default n
 	---help---
 	Say Y here to enable the TCM_QLA2XXX fabric module for QLogic 24xx+ s=
eries target mode HBAs
+
+config TCM_QLA2XXX_DEBUG
+	bool "TCM_QLA2XXX fabric module DEBUG mode for QLogic 24xx+ series ta=
rget mode HBAs"
+	depends on SCSI_QLA_FC && TARGET_CORE
+	depends on LIBFC
+	select BTREE
+	default n
+	---help---
+	Say Y here to enable the TCM_QLA2XXX fabric module DEBUG for QLogic 2=
4xx+ series target mode HBAs
+	This will include code to enable the SCSI command jammer
diff -Nurp linux-4.5/drivers/scsi/qla2xxx/tcm_qla2xxx.c linux-4.5.new/d=
rivers/scsi/qla2xxx/tcm_qla2xxx.c
--- linux-4.5/drivers/scsi/qla2xxx/tcm_qla2xxx.c	2016-03-14 00:28:54.00=
0000000 -0400
+++ linux-4.5.new/drivers/scsi/qla2xxx/tcm_qla2xxx.c	2016-04-02 11:32:3=
5.317410249 -0400
@@ -48,6 +48,12 @@
 #include "qla_target.h"
 #include "tcm_qla2xxx.h"
=20
+#ifdef TCM_QLA2XXX_DEBUG
+int jam_host =3D -1;
+module_param(jam_host, int, 0644);
+MODULE_PARM_DESC(jam_host, "Host to jam >=3D0 Enable jammer");
+#endif
+
 static struct workqueue_struct *tcm_qla2xxx_free_wq;
 static struct workqueue_struct *tcm_qla2xxx_cmd_wq;
=20
@@ -477,6 +483,13 @@ static int tcm_qla2xxx_handle_cmd(scsi_q
 		return -EINVAL;
 	}
=20
+#ifdef TCM_QLA2XXX_DEBUG
+	if (unlikely(vha->host_no =3D=3D jam_host)) {
+		/* return, and dont run target_submit_cmd,discarding command */
+		return 0;
+	}
+#endif
+
 	cmd->vha->tgt_counters.qla_core_sbt_cmd++;
 	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
 				cmd->unpacked_lun, data_length, fcp_task_attr,
@@ -1967,6 +1980,9 @@ static void tcm_qla2xxx_deregister_confi
 static int __init tcm_qla2xxx_init(void)
 {
 	int ret;
+#ifdef TCM_QLA2XXX_DEBUG
+	jam_host =3D -1;
+#endif
=20
 	ret =3D tcm_qla2xxx_register_configfs();
 	if (ret < 0)


Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Laurence Oberman" <loberman@redhat.com>
To: "Himanshu Madhani" <himanshu.madhani@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Bart Van Assche" <b=
art.vanassche@sandisk.com>, "linux-scsi" <linux-scsi@vger.kernel.org>, =
"target-devel" <target-devel@vger.kernel.org>, "Quinn Tran" <quinn.tran=
@qlogic.com>
Sent: Friday, April 1, 2016 2:15:25 PM
Subject: Re: tcm_qla2xxx Add SCSI command jammer/discard capabilty to t=
he tcm_qla2xxx module - revision3

Himanshu

I looked at using the attribute for this but because of where I have to=
 discard the command I dont want to have to go fetch the attribute each=
 time in the same code path.
Its significant overhead to have to go fetch the attribute value each t=
ime as I allow for a dynamic on off via the module parameter so I have =
to check it each command.
With the module parameter its a simple compare and by having this as a =
module parameter its globally accessible and imposes virtually no overh=
ead.

Are you OK with me using #ifdef on the CONFIG_TCM_QLA2XXX_DEBUG .config=
 parameter I will add here to include the module parameter and code onl=
y if set to "yes"
The default unless expicitly set will be no change.

Thanks

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Himanshu Madhani" <himanshu.madhani@qlogic.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Bart Van Assche" <b=
art.vanassche@sandisk.com>
Cc: "Laurence Oberman" <loberman@redhat.com>, "linux-scsi" <linux-scsi@=
vger.kernel.org>, "target-devel" <target-devel@vger.kernel.org>, "Quinn=
 Tran" <quinn.tran@qlogic.com>
Sent: Thursday, March 31, 2016 8:20:56 PM
Subject: Re: tcm_qla2xxx Add SCSI command jammer/discard capabilty to t=
he tcm_qla2xxx module - revision3

Hi Nic, Laurence,=20



On 3/30/16, 10:34 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wro=
te:

>(Adding target-devel + Qlogic target folks)
>
>On Tue, 2016-03-29 at 22:05 -0700, Bart Van Assche wrote:
>> On 03/29/16 07:42, Laurence Oberman wrote:
>> > I have been using this jammer functionality to continue testing th=
e SCSI F/C drivers and recovery for over a year now.
>> > Any chance you would agree to ack this so I can get it in now.
>> > I last posted to the list last March and it was not picked up.
>> >
>> > I did look into moving this to upper layers but I find I use it pr=
imarily for fiber channel target testing.
>> > Attempting to add this functionality to upper layers led to comple=
xities and this is very solid.
>> >
>> > This Patch diff against 4.5
>> >
>> > I use target LIO for all my storage array test targets and custome=
r problem resolution here at Red Hat.
>> > This patch resulted from a requirement to mimic behavior of an exp=
ensive hardware jammer for a customer.
>> > I have used this for some time with good success to simulate and r=
eproduce latency and slow drain fabric issues and
>> > for testing and validating error handling behavior
>> >   in the Emulex, Qlogic and other F/C drivers.
>> >
>> > Works by checking new parameter jam_host if its >=3D 0 and matches=
 vha->host_no , jamming is enabled when jam_host >=3D0
>> > If parameter set to -1 (default) no jamming is enabled.
>>=20
>> Hello Laurence,
>>=20
>> Nic Bellinger is the maintainer of LIO so my recommendation is to as=
k=20
>> Nic first about his opinion (I have CC'd Nic). I'm not sure what Nic=
=20
>> thinks about this but in my opinion such functionality belongs in th=
e=20
>> target core instead of in a target driver. But please wait until Nic=
 has=20
>> provided his opinion before spending more time on this. The mailing =
list=20
>> for SCSI target patches is target-devel@vger.kernel.org.
>>=20
>
>So really it's Himanshu's + Quinn's call if they would like to include
>something like this in mainline.
>
>If so, then I'd prefer to do it with a per tcm_qla2xxx_tpg endpoint
>attribute instead a new module parameter, and add a new kernel config
>option (CONFIG_TCM_QLA2XXX_DEBUG) to disable (by default) so end users
>don't inadvertently play with it via targetcli + friends.
>

I agree here with Nic. The patch does provides benefit and is good addi=
tion,
but we don=E2=80=99t want to enable it by default.

Laurence,=20

Would you be kind to rework patch with suggested changes from Nic and p=
ost it.=20

Thanks,=20
Himanshu
N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=BF=
=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=BF=
=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=EF=
=BF=BD=EF=BF=BD"=EF=BF=BD{ay=EF=BF=BD=CA=87=DA=99=EF=BF=BD,j=EF=BF=BD=EF=
=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=BF=BD=
=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDj:+v=EF=
=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=BD=EF=BF=BD=DD=A2=
j"=EF=BF=BD=EF=BF=BD
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
