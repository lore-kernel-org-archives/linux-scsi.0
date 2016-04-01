From: Laurence Oberman <loberman@redhat.com>
Subject: Re: tcm_qla2xxx Add SCSI command jammer/discard capabilty to the
 tcm_qla2xxx module - revision3
Date: Thu, 31 Mar 2016 20:55:22 -0400 (EDT)
Message-ID: <1409144622.26265222.1459472122250.JavaMail.zimbra@redhat.com>
References: <2025450295.25603731.1459262558755.JavaMail.zimbra@redhat.com> <56FB5E98.9010103@sandisk.com> <1459402453.31390.45.camel@haakon3.risingtidesystems.com> <3F517A19-EDA5-4B16-B103-C3F38242F8D8@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:37278 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480AbcDAAz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 20:55:27 -0400
In-Reply-To: <3F517A19-EDA5-4B16-B103-C3F38242F8D8@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>

Hello Himanshu

Thanks, I will rework and post back to the thread.

Thank you

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
