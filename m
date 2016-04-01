From: Laurence Oberman <loberman@redhat.com>
Subject: Re: tcm_qla2xxx Add SCSI command jammer/discard capabilty to the
 tcm_qla2xxx module - revision3
Date: Fri, 1 Apr 2016 14:15:25 -0400 (EDT)
Message-ID: <1049122887.26432420.1459534525185.JavaMail.zimbra@redhat.com>
References: <2025450295.25603731.1459262558755.JavaMail.zimbra@redhat.com> <56FB5E98.9010103@sandisk.com> <1459402453.31390.45.camel@haakon3.risingtidesystems.com> <3F517A19-EDA5-4B16-B103-C3F38242F8D8@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <3F517A19-EDA5-4B16-B103-C3F38242F8D8@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

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
