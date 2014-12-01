From: jazz-jYkeLfz6glqHXe+LvDLADg@public.gmane.org
Subject: Re: iSCSI request keep rejected by microsoft iSCSI target because
 of write_same check
Date: Sun, 30 Nov 2014 23:25:00 -0800 (PST)
Message-ID: <a90377a8-3ef9-4fc2-a3e9-bfff23560674@googlegroups.com>
References: <52CE77FB.8020100@oracle.com> <52CEEC97.8050108@cs.wisc.edu> <52CF8F0C.3040304@oracle.com> <52CFA440.7030104@cs.wisc.edu> <52CFAA9F.5010706@oracle.com> <52D056E9.8080008@cs.wisc.edu>
 <52D09CE6.80200@oracle.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_9952_1036267493.1417418700531"
Return-path: <open-iscsi+bncBCA6H5EN3MARBIEQ6ORQKGQEZ3HGBGA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <52D09CE6.80200-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vaughan.cao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

------=_Part_9952_1036267493.1417418700531
Content-Type: multipart/alternative;
	boundary="----=_Part_9953_455377681.1417418700531"

------=_Part_9953_455377681.1417418700531
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I has some sproblem and only one ISCSI target - Microsoft SWT
I disable write_same for iscsi by patching kernel (3.17.0)=20

Patch is simple add .no_write_same =3D 1 param, into scsi_host_template=20
struct.

file drivers/scsi/iscsi_tcp.c :

 static struct scsi_host_template iscsi_sw_tcp_sht =3D {
  .module =3D THIS_MODULE,
  .name =3D "iSCSI Initiator over TCP/IP",
  .queuecommand           =3D iscsi_queuecommand,
  .change_queue_depth =3D iscsi_change_queue_depth,
  .can_queue =3D ISCSI_DEF_XMIT_CMDS_MAX - 1,
  .sg_tablesize =3D 4096,
  .max_sectors =3D 0xFFFF,
  .cmd_per_lun =3D ISCSI_DEF_CMD_PER_LUN,
  .eh_abort_handler       =3D iscsi_eh_abort,
  .eh_device_reset_handler=3D iscsi_eh_device_reset,
  .eh_target_reset_handler =3D iscsi_eh_recover_target,
  .use_clustering         =3D DISABLE_CLUSTERING,
+ .no_write_same =3D 1,
  .slave_alloc            =3D iscsi_sw_tcp_slave_alloc,
  .slave_configure        =3D iscsi_sw_tcp_slave_configure,
  .target_alloc =3D iscsi_target_alloc,
  .proc_name =3D "iscsi_tcp",
  .this_id =3D -1,
  };


=D1=81=D1=83=D0=B1=D0=B1=D0=BE=D1=82=D0=B0, 11 =D1=8F=D0=BD=D0=B2=D0=B0=D1=
=80=D1=8F 2014 =D0=B3., 6:22:46 UTC+5 =D0=BF=D0=BE=D0=BB=D1=8C=D0=B7=D0=BE=
=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Vaughan Cao =D0=BD=D0=B0=D0=BF=D0=B8=
=D1=81=D0=B0=D0=BB:
>
>
> On 2014=E5=B9=B401=E6=9C=8811=E6=97=A5 04:24, Mike Christie wrote:=20
> > On 01/10/2014 02:09 AM, vaughan wrote:=20
> >> On 01/10/2014 03:41 PM, Mike Christie wrote:=20
> >>> On 1/10/14 12:11 AM, vaughan wrote:=20
> >>>> I haven't figure out why it's rejected with "bookmark invalid"(9)=20
> >>>> reason, rather than "command not supported". IMO "bookmark invalid"=
=20
> is=20
> >>>> used when minor protocol conflict such as final flag not set with=20
> >>>> non-write command. However, I haven't find error of this kind in=20
> >>>> report_opcode, so I guess it's not supported on the target.=20
> >>>>=20
> >>> Is it possible to get a wireshark/tcpdump trace? It does not have to=
=20
> >>> be during boot. We just need to see what commands are sent and the=20
> >>> response the target is returning.=20
> >>>=20
> >>> I forgot we know some microsoft iscsi target people. We can just emai=
l=20
> >>> them with the trace to confirm what is going on with the target. The=
=20
> >>> trace seems to be easier for them than them interpreting linux kernel=
=20
> >>> logs.=20
> >> I enabled debug_iscsi_tcp, here is a more detailed log in normal=20
> connection.=20
> >> Does "conn error (1020)" mean it's target peer who disconnect the=20
> >> connection at the same time of reject report_opcode?=20
> > Yes.=20
> >=20
> >> If it is, I think iSCSI boot failure can't be avoided without disable=
=20
> >> write_same check on OEL.=20
> > Yes, you are right. Due to how more distros do boot, iscsid will not be=
=20
> > up and you will hang. If are talking about disablement though I think i=
t=20
> > should not be done at the iscsi layer. It should be some sort of=20
> > white/black list at the scsi device layer or something like that.=20
> >=20
> > However, I will ping Microsoft and cc you and we can see what is up for=
=20
> > sure. Maybe we will get lucky and they will have a release with a fix o=
n=20
> > their side.=20
>
> Target:=20
>    Windows Server 2008 R2 DataCenter=20
>    Microsoft iSCSI Software Target: 3.3.16563.=20
> Initiator:=20
>    kernel with write_same check in sd, such as Kernel=20
> 3.11.10-200.fc19.x86_64 =20
>

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.

------=_Part_9953_455377681.1417418700531
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I has some sproblem and only one ISCSI target - Micro=
soft SWT</div>I disable write_same for iscsi by patching kernel (3.17.0)&nb=
sp;<div><br></div><div>Patch is simple add .no_write_same&nbsp;=3D 1 param,=
 into scsi_host_template struct.</div><div><br></div><div>file drivers/scsi=
/iscsi_tcp.c :</div><div><br></div><div><div>&nbsp;static struct scsi_host_=
template iscsi_sw_tcp_sht =3D {</div><div>&nbsp; <span class=3D"Apple-tab-s=
pan" style=3D"white-space:pre">	</span>.module<span class=3D"Apple-tab-span=
" style=3D"white-space:pre">			</span>=3D THIS_MODULE,</div><div>&nbsp; <sp=
an class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>.name<span cl=
ass=3D"Apple-tab-span" style=3D"white-space:pre">			</span>=3D "iSCSI Initi=
ator over TCP/IP",</div><div>&nbsp; <span class=3D"Apple-tab-span" style=3D=
"white-space:pre">	</span>.queuecommand &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
=3D iscsi_queuecommand,</div><div>&nbsp; <span class=3D"Apple-tab-span" sty=
le=3D"white-space:pre">	</span>.change_queue_depth<span class=3D"Apple-tab-=
span" style=3D"white-space:pre">	</span>=3D iscsi_change_queue_depth,</div>=
<div>&nbsp; <span class=3D"Apple-tab-span" style=3D"white-space:pre">	</spa=
n>.can_queue<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</sp=
an>=3D ISCSI_DEF_XMIT_CMDS_MAX - 1,</div><div>&nbsp; <span class=3D"Apple-t=
ab-span" style=3D"white-space:pre">	</span>.sg_tablesize<span class=3D"Appl=
e-tab-span" style=3D"white-space:pre">		</span>=3D 4096,</div><div>&nbsp; <=
span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>.max_sector=
s<span class=3D"Apple-tab-span" style=3D"white-space:pre">		</span>=3D 0xFF=
FF,</div><div>&nbsp; <span class=3D"Apple-tab-span" style=3D"white-space:pr=
e">	</span>.cmd_per_lun<span class=3D"Apple-tab-span" style=3D"white-space:=
pre">		</span>=3D ISCSI_DEF_CMD_PER_LUN,</div><div>&nbsp; <span class=3D"Ap=
ple-tab-span" style=3D"white-space:pre">	</span>.eh_abort_handler &nbsp; &n=
bsp; &nbsp; =3D iscsi_eh_abort,</div><div>&nbsp; <span class=3D"Apple-tab-s=
pan" style=3D"white-space:pre">	</span>.eh_device_reset_handler=3D iscsi_eh=
_device_reset,</div><div>&nbsp; <span class=3D"Apple-tab-span" style=3D"whi=
te-space:pre">	</span>.eh_target_reset_handler =3D iscsi_eh_recover_target,=
</div><div>&nbsp; <span class=3D"Apple-tab-span" style=3D"white-space:pre">=
	</span>.use_clustering &nbsp; &nbsp; &nbsp; &nbsp; =3D DISABLE_CLUSTERING,=
</div><div>+ <span class=3D"Apple-tab-span" style=3D"white-space:pre">	</sp=
an>.no_write_same<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
	</span>=3D 1,</div><div>&nbsp; <span class=3D"Apple-tab-span" style=3D"whi=
te-space:pre">	</span>.slave_alloc &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
;=3D iscsi_sw_tcp_slave_alloc,</div><div>&nbsp; <span class=3D"Apple-tab-sp=
an" style=3D"white-space:pre">	</span>.slave_configure &nbsp; &nbsp; &nbsp;=
 &nbsp;=3D iscsi_sw_tcp_slave_configure,</div><div>&nbsp; <span class=3D"Ap=
ple-tab-span" style=3D"white-space:pre">	</span>.target_alloc<span class=3D=
"Apple-tab-span" style=3D"white-space:pre">		</span>=3D iscsi_target_alloc,=
</div><div>&nbsp; <span class=3D"Apple-tab-span" style=3D"white-space:pre">=
	</span>.proc_name<span class=3D"Apple-tab-span" style=3D"white-space:pre">=
		</span>=3D "iscsi_tcp",</div><div>&nbsp; <span class=3D"Apple-tab-span" s=
tyle=3D"white-space:pre">	</span>.this_id<span class=3D"Apple-tab-span" sty=
le=3D"white-space:pre">		</span>=3D -1,</div><div>&nbsp; };</div></div><div=
><br><br>=D1=81=D1=83=D0=B1=D0=B1=D0=BE=D1=82=D0=B0, 11 =D1=8F=D0=BD=D0=B2=
=D0=B0=D1=80=D1=8F 2014&nbsp;=D0=B3., 6:22:46 UTC+5 =D0=BF=D0=BE=D0=BB=D1=
=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Vaughan Cao =D0=BD=D0=
=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:<blockquote class=3D"gmail_quote" style=
=3D"margin: 0;margin-left: 0.8ex;border-left: 1px #ccc solid;padding-left: =
1ex;">
<br>On 2014=E5=B9=B401=E6=9C=8811=E6=97=A5 04:24, Mike Christie wrote:
<br>&gt; On 01/10/2014 02:09 AM, vaughan wrote:
<br>&gt;&gt; On 01/10/2014 03:41 PM, Mike Christie wrote:
<br>&gt;&gt;&gt; On 1/10/14 12:11 AM, vaughan wrote:
<br>&gt;&gt;&gt;&gt; I haven't figure out why it's rejected with "bookmark =
invalid"(9)
<br>&gt;&gt;&gt;&gt; reason, rather than "command not supported". IMO "book=
mark invalid" is
<br>&gt;&gt;&gt;&gt; used when minor protocol conflict such as final flag n=
ot set with
<br>&gt;&gt;&gt;&gt; non-write command. However, I haven't find error of th=
is kind in
<br>&gt;&gt;&gt;&gt; report_opcode, so I guess it's not supported on the ta=
rget.
<br>&gt;&gt;&gt;&gt;
<br>&gt;&gt;&gt; Is it possible to get a wireshark/tcpdump trace? It does n=
ot have to
<br>&gt;&gt;&gt; be during boot. We just need to see what commands are sent=
 and the
<br>&gt;&gt;&gt; response the target is returning.
<br>&gt;&gt;&gt;
<br>&gt;&gt;&gt; I forgot we know some microsoft iscsi target people. We ca=
n just email
<br>&gt;&gt;&gt; them with the trace to confirm what is going on with the t=
arget. The
<br>&gt;&gt;&gt; trace seems to be easier for them than them interpreting l=
inux kernel
<br>&gt;&gt;&gt; logs.
<br>&gt;&gt; I enabled debug_iscsi_tcp, here is a more detailed log in norm=
al connection.
<br>&gt;&gt; Does "conn error (1020)" mean it's target peer who disconnect =
the
<br>&gt;&gt; connection at the same time of reject report_opcode?
<br>&gt; Yes.
<br>&gt;
<br>&gt;&gt; If it is, I think iSCSI boot failure can't be avoided without =
disable
<br>&gt;&gt; write_same check on OEL.
<br>&gt; Yes, you are right. Due to how more distros do boot, iscsid will n=
ot be
<br>&gt; up and you will hang. If are talking about disablement though I th=
ink it
<br>&gt; should not be done at the iscsi layer. It should be some sort of
<br>&gt; white/black list at the scsi device layer or something like that.
<br>&gt;
<br>&gt; However, I will ping Microsoft and cc you and we can see what is u=
p for
<br>&gt; sure. Maybe we will get lucky and they will have a release with a =
fix on
<br>&gt; their side.
<br>
<br>Target:
<br>&nbsp; &nbsp;Windows Server 2008 R2 DataCenter
<br>&nbsp; &nbsp;Microsoft iSCSI Software Target: 3.3.16563.
<br>Initiator:
<br>&nbsp; &nbsp;kernel with write_same check in sd, such as Kernel 3.11.10=
-200.fc19.x86_64 &nbsp;<br></blockquote></div></div>

<p></p>

-- <br />
You received this message because you are subscribed to the Google Groups &=
quot;open-iscsi&quot; group.<br />
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to <a href=3D"mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org">open-isc=
si+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</a>.<br />
To post to this group, send email to <a href=3D"mailto:open-iscsi@googlegro=
ups.com">open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</a>.<br />
Visit this group at <a href=3D"http://groups.google.com/group/open-iscsi">h=
ttp://groups.google.com/group/open-iscsi</a>.<br />
For more options, visit <a href=3D"https://groups.google.com/d/optout">http=
s://groups.google.com/d/optout</a>.<br />

------=_Part_9953_455377681.1417418700531--

------=_Part_9952_1036267493.1417418700531--
