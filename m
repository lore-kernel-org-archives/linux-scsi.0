From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v4 0/5] Fix LUN_RESET active I/O + TMR handling
Date: Fri, 12 Feb 2016 00:48:15 -0800
Message-ID: <1455266895.10977.15.camel@haakon3.risingtidesystems.com>
References: <1454815082-15380-1-git-send-email-nab@daterainc.com>
	 <D2DE6219.D6C44%himanshu.madhani@qlogic.com>
	 <1454995505.10001.153.camel@haakon3.risingtidesystems.com>
	 <D2DF69D8.D6DC5%himanshu.madhani@qlogic.com>
	 <1455173594.27060.49.camel@haakon3.risingtidesystems.com>
	 <1455234468.30845.8.camel@haakon3.risingtidesystems.com>
	 <D2E2AA30.D71E4%himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <D2E2AA30.D71E4%himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-02-12 at 05:30 +0000, Himanshu Madhani wrote:
> Hi Nic,=20
>=20
>=20
>=20
> On 2/11/16, 3:47 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wr=
ote:
>=20
> >On Wed, 2016-02-10 at 22:53 -0800, Nicholas A. Bellinger wrote:
> >> On Tue, 2016-02-09 at 18:03 +0000, Himanshu Madhani wrote:
> >> > On 2/8/16, 9:25 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org=
>
> >>wrote:
> >> > >On Mon, 2016-02-08 at 23:27 +0000, Himanshu Madhani wrote:
> >> > >>=20
> >> > >> I am testing this series with with 4.5.0-rc2+ kernel and I am
> >>seeing
> >> > >>issue
> >> > >> where trying to trigger
> >> > >> sg_reset with option of host/device/bus in loop at 120second
> >>interval
> >> > >> causes call stack. At this point
> >> > >> removing configuration hangs indefinitely. See attached dmesg
> >>output
> >> > >>from
> >> > >> my setup.=20
> >> > >>=20
> >> > >
> >> > >Thanks alot for testing this.
> >> > >
> >> > >So It looks like we're still hitting a indefinite schedule() on
> >> > >se_cmd->cmd_wait_comp once tcm_qla2xxx session disconnect/recon=
nect
> >> > >occurs, after repeated explicit active I/O remote-port sg_reset=
s.
> >> > >
> >> > >Does this trigger on the first tcm_qla2xxx session reconnect af=
ter
> >> > >explicit remote-port sg_reset..?  Are session reconnects active=
ly
> >>being
> >> > >triggered during the test..?
> >> > >
> >> > >To verify the latter for iscsi-target, I've been using a small =
patch
> >>to
> >> > >trigger session reset from TMR kthread context in order to simu=
late
> >>the
> >> > >I_T disconnects.  Something like that would be useful for verif=
ying
> >>with
> >> > >tcm_qla2xxx too.
> >> > >
> >> > >That said, I'll be reproducing with tcm_qla2xxx ports this week=
, and
> >> > >will enable various debug in a WIP branch for testing.
> >>=20
> >> Following up here..
> >>=20
> >> So far using my test setup with ISP2532 ports in P2P + RAMDISK_MCP=
 and
> >> v4.5-rc1, repeated remote-port active I/O LUN_RESET (sg_reset -d) =
has
> >> been functioning as expected with a blocksize_range=3D4k-256k + io=
depth=3D32
> >> fio write-verify style workload.
> >>=20
> >> No ->cmd_kref -1 OOPsen or qla2xxx initiator generated ABORT_TASKs=
 from
> >> outstanding target TAS responses, nor fio write-verify failures to
> >> report after 800x remote-port active I/O LUN_RESETS.
> >>=20
> >> Next step will be to verify explicit tcm_qla2xxx port + module shu=
tdown
> >> after 1K test iterations, and then IBLOCK async completions <-> NV=
Me
> >> backends with the same case.
> >>=20
> >
> >After letting this test run over-night up to 7k active I/O remote-po=
rt
> >LUN_RESETs, things are still functioning as expected.
> >
> >Also, /etc/init.d/target stop was able to successfully shutdown all
> >active sessions and unload tcm_qla2xxx after the test run.
> >
> >So AFAICT, the active I/O remote-port LUN_RESET changes are stable w=
ith
> >tcm_qla2xxx ports, separate from concurrent session disconnect hung =
task
> >you reported earlier.
> >
> >That said, I'll likely push this series as-is for -rc4, given that D=
an
> >has also been able to verify the non conncurrent session disconnect =
case
> >on his setup generating constant ABORT_TASKs, and it's still survivi=
ng
> >both cases for iscsi-target ports.
> >
> >Please give the debug patch from last night a shot, and see if we ca=
n
> >determine the se_cmd states when you hit the hung task.
>=20
> I=C2=B9ll give your latest debug patch try in a little while
>=20
> From the testing that I have done, what is seen is that active IO has
> already been completed and qla2xxx driver is waiting for commands to =
be
> Completed and it=C2=B9s waiting indefinitely for cmd_wait_comp.
> So it looks like there is a missing complete call from target_core. I=
=C2=B9ve
> attached our analysis from crash debug on a live system after the iss=
ues
> happens.
>=20
>=20

Thanks for the crash dump output.

So it's a t_state =3D TRANSPORT_WRITE_PENDING descriptor with
SAM_STAT_CHECK_CONDITION + cmd_kref.refcount =3D 0:

struct qla_tgt_cmd {
  se_cmd =3D {
    scsi_status =3D 0x2
    se_cmd_flags =3D 0x80090d,

    <SNIP>

    cmd_kref =3D {
      refcount =3D {
        counter =3D 0x0
      }
    },=20
}

The se_cmd_flags=3D0x80090d translation to enum se_cmd_flags_table:

- SCF_TRANSPORT_TASK_SENSE
- SCF_EMULATED_TASK_SENSE
- SCF_SCSI_DATA_CDB
- SCF_SE_LUN_CMD
- SCF_SENT_CHECK_CONDITION
- SCF_USE_CPUID

Also, ->cmd_wait_comp has a zero rlock counter + dead magic:

cmd_wait_comp =3D {
      done =3D 0x0,=20
      wait =3D {
        lock =3D {
          {
            rlock =3D {
              raw_lock =3D {
                val =3D {
                  counter =3D 0x0
                }
              },=20
              magic =3D 0xdead4ead,=20
              owner_cpu =3D 0xffffffff,=20
              owner =3D 0xffffffffffffffff,=20

> I can recreate this issue at will within 5 minute of triggering sg_re=
set
> with following steps
>=20
> 1. Export 4 RAM disk LUNs on each of 2 port adapter. Initiator will s=
ee 8
> RAM disk targets
> 2. Start IO with 4K block size and 8 threads with 80% write 20% read =
and
> 100% dandom.=20
> (I am using vdbench for generating IO. I can provide setup/config scr=
ipt
> if needed)
> 3. Start sg_reset for each LUNs with first device, bus and host with =
120s
> delay. (I=C2=B9ve attached
> My script that I am using for triggering sg_reset)
>=20

Thanks, will keep looking and try to reproduce with your script.
