From: vaughan <vaughan.cao-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: iSCSI request keep rejected by microsoft iSCSI target because
 of write_same check
Date: Mon, 01 Dec 2014 17:01:01 +0800
Message-ID: <547C2E4D.1030802@oracle.com>
References: <52CE77FB.8020100@oracle.com> <52CEEC97.8050108@cs.wisc.edu> <52CF8F0C.3040304@oracle.com> <52CFA440.7030104@cs.wisc.edu> <52CFAA9F.5010706@oracle.com> <52D056E9.8080008@cs.wisc.edu> <52D09CE6.80200@oracle.com> <a90377a8-3ef9-4fc2-a3e9-bfff23560674@googlegroups.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBDCN5SUNYEERBG646CRQKGQESWXHHCQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <a90377a8-3ef9-4fc2-a3e9-bfff23560674-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: jazz-jYkeLfz6glqHXe+LvDLADg@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 12/01/2014 03:25 PM, jazz-jYkeLfz6glqHXe+LvDLADg@public.gmane.org wrote:
> I has some sproblem and only one ISCSI target - Microsoft SWT
> I disable write_same for iscsi by patching kernel (3.17.0)
This method is not good.  Below is the answer from Mike when I asked if
we can disable write_same in the template before.

"If you wanted to disable commands you would want to do it per device or
target at the scsi layer, because there are or will be iscsi targets
that support it."

Also Martin suggests the target should return a check condition of
ILLEGAL REQUEST if it doesn't support a specific command.
It's a bug that only happens with Microsoft target, not others like tgtd.


>
> Patch is simple add .no_write_same =3D 1 param, into scsi_host_template
> struct.
>
> file drivers/scsi/iscsi_tcp.c :
>
>  static struct scsi_host_template iscsi_sw_tcp_sht =3D {
>   .module=3D THIS_MODULE,
>   .name=3D "iSCSI Initiator over TCP/IP",
>   .queuecommand           =3D iscsi_queuecommand,
>   .change_queue_depth=3D iscsi_change_queue_depth,
>   .can_queue=3D ISCSI_DEF_XMIT_CMDS_MAX - 1,
>   .sg_tablesize=3D 4096,
>   .max_sectors=3D 0xFFFF,
>   .cmd_per_lun=3D ISCSI_DEF_CMD_PER_LUN,
>   .eh_abort_handler       =3D iscsi_eh_abort,
>   .eh_device_reset_handler=3D iscsi_eh_device_reset,
>   .eh_target_reset_handler =3D iscsi_eh_recover_target,
>   .use_clustering         =3D DISABLE_CLUSTERING,
> + .no_write_same=3D 1,
>   .slave_alloc            =3D iscsi_sw_tcp_slave_alloc,
>   .slave_configure        =3D iscsi_sw_tcp_slave_configure,
>   .target_alloc=3D iscsi_target_alloc,
>   .proc_name=3D "iscsi_tcp",
>   .this_id=3D -1,
>   };
>
>
> =D1=81=D1=83=D0=B1=D0=B1=D0=BE=D1=82=D0=B0, 11 =D1=8F=D0=BD=D0=B2=D0=B0=
=D1=80=D1=8F 2014 =D0=B3., 6:22:46 UTC+5 =D0=BF=D0=BE=D0=BB=D1=8C=D0=B7=D0=
=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Vaughan Cao
> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
>
>
>     On 2014=E5=B9=B401=E6=9C=8811=E6=97=A5 04:24, Mike Christie wrote:
>     > On 01/10/2014 02:09 AM, vaughan wrote:
>     >> On 01/10/2014 03:41 PM, Mike Christie wrote:
>     >>> On 1/10/14 12:11 AM, vaughan wrote:
>     >>>> I haven't figure out why it's rejected with "bookmark
>     invalid"(9)
>     >>>> reason, rather than "command not supported". IMO "bookmark
>     invalid" is
>     >>>> used when minor protocol conflict such as final flag not set
>     with
>     >>>> non-write command. However, I haven't find error of this kind in
>     >>>> report_opcode, so I guess it's not supported on the target.
>     >>>>
>     >>> Is it possible to get a wireshark/tcpdump trace? It does not
>     have to
>     >>> be during boot. We just need to see what commands are sent and
>     the
>     >>> response the target is returning.
>     >>>
>     >>> I forgot we know some microsoft iscsi target people. We can
>     just email
>     >>> them with the trace to confirm what is going on with the
>     target. The
>     >>> trace seems to be easier for them than them interpreting linux
>     kernel
>     >>> logs.
>     >> I enabled debug_iscsi_tcp, here is a more detailed log in
>     normal connection.
>     >> Does "conn error (1020)" mean it's target peer who disconnect the
>     >> connection at the same time of reject report_opcode?
>     > Yes.
>     >
>     >> If it is, I think iSCSI boot failure can't be avoided without
>     disable
>     >> write_same check on OEL.
>     > Yes, you are right. Due to how more distros do boot, iscsid will
>     not be
>     > up and you will hang. If are talking about disablement though I
>     think it
>     > should not be done at the iscsi layer. It should be some sort of
>     > white/black list at the scsi device layer or something like that.
>     >
>     > However, I will ping Microsoft and cc you and we can see what is
>     up for
>     > sure. Maybe we will get lucky and they will have a release with
>     a fix on
>     > their side.
>
>     Target:
>        Windows Server 2008 R2 DataCenter
>        Microsoft iSCSI Software Target: 3.3.16563.
>     Initiator:
>        kernel with write_same check in sd, such as Kernel
>     3.11.10-200.fc19.x86_64 =20
>

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
