From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH ] tcm_qla2xxx  Add SCSI command jammer/discard capabilty
 to the tcm_qla2xxx module
Date: Thu, 12 Mar 2015 22:07:08 +0000
Message-ID: <504EB66DAC8D234EB8E8560985C2D7AD46DBC279@avmb2.qlogic.org>
References: <588344732.13485469.1425769450275.JavaMail.zimbra@redhat.com>
 <1069288785.13490592.1425785175883.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_504EB66DAC8D234EB8E8560985C2D7AD46DBC279avmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avcashub2.qlogic.com ([198.70.193.116]:63030 "EHLO
	avcashub1.qlogic.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752645AbbCLWMP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2015 18:12:15 -0400
In-Reply-To: <1069288785.13490592.1425785175883.JavaMail.zimbra@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>, Andy Grover <agrover@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, "nab@daterainc.com" <nab@daterainc.com>
Cc: Laurence Oberman <oberman.l@gmail.com>

--_000_504EB66DAC8D234EB8E8560985C2D7AD46DBC279avmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D7D9579022C4AC4D861DD6C19DD5BE9B@qlogic.com>
Content-Transfer-Encoding: quoted-printable

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
>Works by checking jammer_flag=3D=3D1 and host # and discards SCSI command,
>controlled using echo to sys parameter.
>
>I decided to share the patch, in the hope it may be useful for others but
>I do understand this is a special use case.
>If this is useful and Nab wants to include it I will create a proper
>documentation patch as well.
>
>filename:      =20
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
>host=3D`cat /sys/module/tcm_qla2xxx/parameters/host_flag`
>sleep_time=3D120  ### Time to jam for
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
>=20
>+int message_flag=3D0;
>+int jammer_flag =3D 0;
>+module_param(jammer_flag, int,0644);
>+MODULE_PARM_DESC(jammer_flag, "If set to 1: Enable jammer");
>+int host_flag=3D0;
>+module_param(host_flag, int,0644);
>+MODULE_PARM_DESC(host_flag, "host number to match on");
>+
> static struct workqueue_struct *tcm_qla2xxx_free_wq;
> static struct workqueue_struct *tcm_qla2xxx_cmd_wq;
>=20
>@@ -570,6 +578,22 @@ static int tcm_qla2xxx_handle_cmd(scsi_q
> 		pr_err("Unable to locate active struct se_session\n");
> 		return -EINVAL;
> 	}
>+=09
>+ 	// Control messaging here
>+	message_flag +=3D jammer_flag;
>+	if(message_flag =3D=3D 1)
>+		printk("tcm_qla2xx:SCSI Jammer enabled on host %d\n",host_flag);
>+	if((jammer_flag =3D=3D 0) && (message_flag >=3D0)) {
>+		printk("tcm_qla2xx:SCSI Jammer stopped, %d SCSI commands discarded for
>host %d\n",message_flag,host_flag);
>+		message_flag=3D-1;
>+	}
>+	=09
>+	if ((vha->host_no =3D=3D host_flag) && (jammer_flag =3D=3D 1))
>+	{
>+		// return, and don't run target_submit_cmd, effectively discarding
>command
>+		return 0;
>+	}
>+
>=20
> 	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
> 				cmd->unpacked_lun, data_length, fcp_task_attr,
>@@ -2165,6 +2189,7 @@ static void tcm_qla2xxx_deregister_confi
> static int __init tcm_qla2xxx_init(void)
> {
> 	int ret;
>+	jammer_flag =3D 0;
>=20
> 	ret =3D tcm_qla2xxx_register_configfs();
> 	if (ret < 0)
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


--_000_504EB66DAC8D234EB8E8560985C2D7AD46DBC279avmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+IgJFAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAAEQ4N0I4RUVB
MzQzMEQ2NDhCREVGMTMwQUU0OThCOTQ3AF4HAQ2ABAACAAAAAgACAAEFgAMADgAAAN8HAwAMABYA
BwAIAAQAHgEBIIADAA4AAADfBwMADAAWAAcACAAEAB4BAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAF4AAABSZTogW1BBVENIIF0gdGNtX3FsYTJ4eHggIEFkZCBTQ1NJIGNv
bW1hbmQgamFtbWVyL2Rpc2NhcmQgY2FwYWJpbHR5IHRvIHRoZSB0Y21fcWxhMnh4eCBtb2R1bGUA
sSABA5AGALQYAAA2AAAAAgF/AAEAAAA8AAAAPDUwNEVCNjZEQUM4RDIzNEVCOEU4NTYwOTg1QzJE
N0FENDZEQkMyNzlAYXZtYjIucWxvZ2ljLm9yZz4ACwAfDgEAAAACAQkQAQAAAIYLAACCCwAA4xYA
AExaRnW3CshFYQAKZmJpZAQAAGNjwHBnMTI1MgD+A0PwdGV4dAH3AqQD4wIABGNoCsBzZXQwIO8H
bQKDAFARTTIKgAa0AoCWfQqACMg7CWIxOQ7AvwnDFnIKMhZxAoAVYioJsHMJ8ASQYXQFsg5QA2Bz
om8BgCBFeBHBbhgwXQZSdgSQF7YCEHIAwHR9CFBuGjEQIAXABaAbZGSaIANSIBAiF7JcdgiQ5Hdr
C4BkNR1TBPAHQA0XcDAKcRfyYmttawZzAZAAICBCTV9C4EVHSU59CvwB8QvxFRJAaAQAIA3QZWEg
CwEBC4BpECBseSBojSKwcBxwCkBzaCAIYMkFQGFkDeB0aQIgB0D3IeACMBhhYyQiIeAEEApQlQQg
YhIQdwnhXGwLgNplCoBmAaAFEGMiMAUQDxoxBCAAcBxgVENNLrMmNSY1SG8l8BoxLBzAHyLwG9AI
cAlwAjAgc3D6bwVAdyLwCXApcwSQA2BbBcALgGoFkCUFIAtRY7scUQPwbAMgHlAjYGUmNRsHgARg
ciLQHnBhay7+ICGRKx8cwAiBBCAYkCcB/m8jICmDA3ADgRxgJcAa4fMtZiVwYm0EAS/DMHAn0gMu
oSfgICYgUUxBvycHLNMJABkQKtEk0WsjkP5mKXEhwTElKAYuwhAgH2D3LMQlwCowaAkRLkAnMSHg
9zXwCfAIYGcjgC3lEdA44Z8lwAnwLkMJgC6RTWEi0J84MSmBJjUxJjhhdWwxgt8whDGkOaIj0Czw
bx5QJCL9KA1JA6Aj5ilgIpAqgD0D/wMALJA5AimCKmAqoSozNkF3A5E4MQuAYwpAAQA8wXXTEcAj
0HM6JjVxClAKUMpfH2F0I2AoKSlgROTyZBiAYV8LgClgAaAJESUJgF8BkHNrRah0bfpfEfBwRaAz
4CY1H3EYMN50RTAygkmQSDByRaA/Lv9B1CSSJ6EhwTBhN5M+gSPR/mEFMCdRKWMv4S7fA6AYUO8c
UTBhJcAtdm844SGwOYD9G7F1IyAkkTMzJwUoDSY1OFJlZwsRTaAmNVF1ewuAA6BUGHAmJlVPKElP
gQOgMy83LzE1KWCAODoyNiBQTSlg3CJMLTAp8UGRTyXAGwGwbiIgPAkAWWRACXHpEdB0LjEhPiqA
A2AQIPNEZiY1PkgisAkAXBZcFg5JUSA1UklTIExJT3cccAWxTPJtItAfYAWwYf8Z0QrAGHAi0DeT
SUQndCnA61+hB4ByXBZwA2ACYD5R/wlwGSAKQCUDKqMYgAfwHFHeSFrBXBYhowqwdEQRYxHfPRAc
RyIgCXBE4GkJcAeA/yoRMGEyoDKgJvAlwDohJDDvCHA10gOREDBwCfAAkBowM1wWEdFkdwrAGeBq
Yf8xQBuxXvNhh2S3XeA6Iy1B/0+RIbJe8hkgB4AcwAdxLMH5KYAgZzUwQ9MskAQRMGH9AJBtPRAY
gGABHcBcFglw/WKRZEQAGeBwQkNwItA8o/8JAAfgJxALcRxwJrQlVXCZ117yN5ILgGcng3YHQA3Q
7z7RdXErNBmhZCZBdYBoSLtzISmCRXAhEDApYFEJAB5nDlBcFieSQjRGL0P3JwZkt1wWVwWwH1Al
sCLQ3xHABZAdoXWAauRfI0Bf4Lg9PTEngzhwN7EjJ4PPDeEeUFPxBgBDU13gMSX9VCY+G+EwAAbw
HnAcYCNg73ZTEcBMgW/heWVyGHAHgP8boXtPXeAFgSHxT5MjcGqi/ymCZZNAwU4EOHBpYEDSAMD7
O3MtQWY9EF7jQjMloSOw+4QpMHB1HcAnUQGQJ6E2E/8hwSIgKkCE0SRhXgIeUBIA32w4NfUhwYfl
J5JOAaAqgP8AcELBMGFDZUDSXeAs1Alw/3BTLFAwoWH4idApwGdiPtP/ZYVEQCqAXKGDnyJgHnAk
UF0HgDouoJTzXBYvJkBiBi8EYXixcy8zLjGQNy43LQHQMC5q5AYuEbAB0C54ODZfuDY0LzrwBKAi
sC8nFSYvBPAAkC9xC2AyeFWaEC9lsG1cFl+Z1S4+a1zXJkAskACAlNcgR/xQTJEnB5AFAyQxlOMz
snk0ETJYn2AqMAZxB5JQ/ElWOTEBoIGiJqudaGlhv1QAnKdJRQWhRSAEYSyZ1f4smYJHQFURKkEA
IH3QeWfnJJEJ0ZynIFlcFhoxAMCfeUGU5pa/l8oGAE1QOaB9BHBfigAJACPgYhcKwG23pqguoH15
OgZgZ5MxlODWRaBzatYoJJEpq5+U9fd+oq10fqNukdBZYWejZaP/JSGvW4OurnV+o1hQT7Nq1P9w
t4JDWFBbIJlwgtCWJZpCPZsGL4MHlpCxJ4OuVXP/X+IQMGrwC1A4QQUDRGZdV2gjIS8NwG698ERA
aPNp136xPWA+wbe/uM+52e5gXBZyoAngcEdAB3F+MP8hcX7gw/ASQzBSauFe4ra7/CJXOEEfczBi
f2QxFgQg1yUhf+N+oyR+oiKbt3kw8xgwBcAiSmr0H2MJgMj3/4JDfkBbIL+fwK+WkH15wnv/yJDC
+La7EjDL78z/zg/FT/8wsGlgbWJqxsj/ygfVs9a3/WTLUGWjDeABICPQU9ALgPs3sajROajg2L83
oRxRfLDflOBYzlnfWuNcFlNQ0BhQ5GQtGTBmLd0P3h/fLrORJ9pyLU4IcCMgYZj/f5oGmwd5Z5YQ
5U/mX1wWLd/qoOUf6O/nMgGRIAHQV+BoLTAz7bA3rjBYIDMENTpX4C4yNDY3IDM3NTg56icwNfse
oFwWK/CQJbDq/+wP7R8F7iQ0qWAxNjg1OZg5NjPwB+/LQEDksNXv4CxYUCv2wTGqkPaAd1wWfuCP
FiKZ0UdBSWIu/mjWt/gp6Vr5ifAXJJE5oXcEEF/hfdQwFiD8Wn15IK490UD9+JY0X4MDKH15kYZi
dCwwmGA0Kf34AE1PRFVMRV9QZEFSH9BERX/gASwi/0thEgGuD9aCAon80rEn/dq/AGuxJwHvAv8E
AgnpIrHPv7LUBsr5p0VCJuEfYHJEAO9A8nxwROYQ4yrSaX3QFsH4X3dx/fcQTxFfEmmaYBdHMBNq
9gs39tQ3OCz8MjL3cRQW/NISWnbzRSD1FuEopLNxF1jzIfMTYpDiXysxKCJVroQwYT6j/5CBJPE4
4RSVLVBFMG+RJDH8XFwO+hy4WoBFcJiw5LDARUlOVkFMILz8MB59Dzgc0vAmI1QvLyD+Q4FE/QV1
YiqiI9v9C/cA3/+QfXkPKfMi5IAoKAt+IP8FsK+XJFQdFFFhR4D6ya3A33/yygWgZmOSfrIltqAg
cb4ssScPGiplASorkjBIoVYmr0AoCz790ClIoFz+eyv/LQ8uHdWVTbAwAH/b/5/wxsVmUsUIL7r9
GjBvNUv5/RstMTEdI74keipVr0CUKHZasC2+819uxdD/K6E8iDNTMk0r0CvsNM8lVe8h5E2wfxOz
ECdM0BXATgH7o0RmEGJn4KOBFvBNsI2w9mZO8qGAbHJAxsV1YYC4/4BTRq8h1v3pP+/7ziNUIeU/
SV8bwBtzhmAfxYZgY2R6YoZgJhbhQsAfwJxxX8OJAEqRclswXYCnHLe/HMdUg4oACYB9ELaQX2NQ
70hBdiH48JSBZ27QhmCp8PPDMYwga1+SkCXwgKf2groy9KA19uJbEO8gLO4AuRmIdm92EBpbiiFl
qCA/3LF9wIExlGATnvzSX1//+ECPkRJaYBJCgFyxr5dGef8jVPzSIeExHf7fUC8hlv+BwxJaXdxn
ZnMoIK1CM/1nIjwzIbOf6jfZN4niScH/vGKHsRMQgECKpHcwxjCU4D9U0dX0hDLF4G16dzF1eLot
mYIiGhH5poayYtIA34eQ4JCQkf0VsnRqdsCJ0LnR8EB2ybGbgJijLnbA/bp3TaOxc8gaEYhQkJAH
oPMm0FoQcDolkHR9liBz5sYtdtL5cHRtbPml+aUMfX338HsgAAAfAEIAAQAAABYAAABRAHUAaQBu
AG4AIABUAHIAYQBuAAAAAAAfAGUAAQAAACwAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8A
ZwBpAGMALgBjAG8AbQAAAB8AZAABAAAACgAAAFMATQBUAFAAAAAAAAIBQQABAAAAZAAAAAAAAACB
Kx+kvqMQGZ1uAN0BD1QCAAAAgFEAdQBpAG4AbgAgAFQAcgBhAG4AAABTAE0AVABQAAAAcQB1AGkA
bgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAJdAQAAACwAAABxAHUAaQBu
AG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A5V8BAAAANAAAAHMAaQBwADoA
cQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfABoMAQAAABYAAABR
AHUAaQBuAG4AIABUAHIAYQBuAAAAAAAfAB8MAQAAACwAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAA
cQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAAAAIBGQwBAAAAZAAA
AAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFEAdQBpAG4AbgAgAFQAcgBhAG4AAABTAE0AVABQAAAA
cQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAFdAQAAACwAAABx
AHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A+D8BAAAAFgAAAFEA
dQBpAG4AbgAgAFQAcgBhAG4AAAAAAB8AI0ABAAAALAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABx
AGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAABkAAAA
AAAAAIErH6S+oxAZnW4A3QEPVAIAAACAUQB1AGkAbgBuACAAVAByAGEAbgAAAFMATQBUAFAAAABx
AHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8ACV0BAAAALAAAAHEA
dQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAxQAEAAAACAAAAAAAA
AAsAQDoBAAAAHwAwQAEAAAACAAAAAAAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAA
AwDxPwkEAAALAEA6AQAAAAMA/T/kBAAAAgELMAEAAAAQAAAA2HuO6jQw1ki97xMK5Ji5RwMAFwAB
AAAAQAA5AACOoOEQXdABQAAIMDF3BOIQXdABCwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAFIUAAAEA
AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBl
AAAAAAABAAAADAAAAGUAbgAtAFUAUwAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAA
HwA3AAEAAAC8AAAAUgBlADoAIABbAFAAQQBUAEMASAAgAF0AIAB0AGMAbQBfAHEAbABhADIAeAB4
AHgAIAAgAEEAZABkACAAUwBDAFMASQAgAGMAbwBtAG0AYQBuAGQAIABqAGEAbQBtAGUAcgAvAGQA
aQBzAGMAYQByAGQAIABjAGEAcABhAGIAaQBsAHQAeQAgAHQAbwAgAHQAaABlACAAdABjAG0AXwBx
AGwAYQAyAHgAeAB4ACAAbQBvAGQAdQBsAGUAAAAfAD0AAQAAAAoAAABSAGUAOgAgAAAAAAADADYA
AAAAAB8AQhABAAAAfgAAADwAMQAwADYAOQAyADgAOAA3ADgANQAuADEAMwA0ADkAMAA1ADkAMgAu
ADEANAAyADUANwA4ADUAMQA3ADUAOAA4ADMALgBKAGEAdgBhAE0AYQBpAGwALgB6AGkAbQBiAHIA
YQBAAHIAZQBkAGgAYQB0AC4AYwBvAG0APgAAAAAAAgFxAAEAAAAbAAAAptnwmQhefqctPto65k31
h2cqiZhbIezY774AAB8AcAABAAAAtAAAAFsAUABBAFQAQwBIACAAXQAgAHQAYwBtAF8AcQBsAGEA
MgB4AHgAeAAgACAAQQBkAGQAIABTAEMAUwBJACAAYwBvAG0AbQBhAG4AZAAgAGoAYQBtAG0AZQBy
AC8AZABpAHMAYwBhAHIAZAAgAGMAYQBwAGEAYgBpAGwAdAB5ACAAdABvACAAdABoAGUAIAB0AGMA
bQBfAHEAbABhADIAeAB4AHgAIABtAG8AZAB1AGwAZQAAAB8ANRABAAAAeAAAADwANQAwADQARQBC
ADYANgBEAEEAQwA4AEQAMgAzADQARQBCADgARQA4ADUANgAwADkAOAA1AEMAMgBEADcAQQBEADQA
NgBEAEIAQwAyADcAOQBAAGEAdgBtAGIAMgAuAHEAbABvAGcAaQBjAC4AbwByAGcAPgAAAB8AORAB
AAAA+gAAADwANQA4ADgAMwA0ADQANwAzADIALgAxADMANAA4ADUANAA2ADkALgAxADQAMgA1ADcA
NgA5ADQANQAwADIANwA1AC4ASgBhAHYAYQBNAGEAaQBsAC4AegBpAG0AYgByAGEAQAByAGUAZABo
AGEAdAAuAGMAbwBtAD4AIAA8ADEAMAA2ADkAMgA4ADgANwA4ADUALgAxADMANAA5ADAANQA5ADIA
LgAxADQAMgA1ADcAOAA1ADEANwA1ADgAOAAzAC4ASgBhAHYAYQBNAGEAaQBsAC4AegBpAG0AYgBy
AGEAQAByAGUAZABoAGEAdAAuAGMAbwBtAD4AAAAAAAMA3j+fTgAAQAAHMKnx+uEQXdABAwAmAAAA
AAACAUcAAQAAAC4AAABjPVVTO2E9IDtwPVFMb2dpYztsPUFWTUIyLTE1MDMxMjIyMDcwOFotNjQx
MDcAAAAfABUQAQAAAFgAAABEADcARAA5ADUANwA5ADAAMgAyAEMANABBAEMANABEADgANgAxAEQA
RAA2AEMAMQA5AEQARAA1AEIARQA5AEIAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAgEUMAEAAAAM
AAAAzgEAAJAkxuhUAAAAHwD6PwEAAAAWAAAAUQB1AGkAbgBuACAAVAByAGEAbgAAAAAAHwAAgIYD
AgAAAAAAwAAAAAAAAEYBAAAAFgAAAHUAcwBlAHIALQBhAGcAZQBuAHQAAAAAAAEAAABGAAAATQBp
AGMAcgBvAHMAbwBmAHQALQBNAGEAYwBPAHUAdABsAG8AbwBrAC8AMQA0AC4ANAAuADcALgAxADQA
MQAxADEANwAAAAAAHwAAgB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0
AGkAbwBuAEkAbgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAAFABAABJAEkAPQAwADEA
MAAxAEQAMAA1AEQAMQAwAEUAMQA2ADkANgBEADgAOAAzAEYAQgBEADAANwA5ADcANABBAEIANAA3
ADIAQwBFADMANgAwADYAMQAzADQAQQBFADIAOwBTAEIATQBJAEQAPQAxADEAOwBTADEAPQA8ADEA
MAA2ADkAMgA4ADgANwA4ADUALgAxADMANAA5ADAANQA5ADIALgAxADQAMgA1ADcAOAA1ADEANwA1
ADgAOAAzAC4ASgBhAHYAYQBNAGEAaQBsAC4AegBpAG0AYgByAGEAQAByAGUAZABoAGEAdAAuAGMA
bwBtAD4AOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8AbgAgADEANAAuADIAIAAoAEIAdQBp
AGwAZAAgADMAOAA3AC4AMAApACwAIABTAHQAYQBnAGUAPQBIADIAAAADAA00/T8AAB8AAICGAwIA
AAAAAMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBhAHQAdABhAGMAaAAAAAEAAAAC
AAAAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIAAAB4AC0AbwByAGkAZwBpAG4AYQB0AGkA
bgBnAC0AaQBwAAAAAAABAAAAGAAAAFsAMQAwAC4AMQAuADQALgAxADAAXQAAAB8AAICGAwIAAAAA
AMAAAAAAAABGAQAAABYAAABkAGkAcwBjAGwAYQBpAG0AZQByAAAAAAABAAAADgAAAGIAeQBwAGEA
cwBzAAAAAADhkw==

--_000_504EB66DAC8D234EB8E8560985C2D7AD46DBC279avmb2qlogicorg_--
