From: Dan Lane <dracodan@gmail.com>
Subject: Re: [PATCH-v4 0/5] Fix LUN_RESET active I/O + TMR handling
Date: Fri, 26 Feb 2016 21:43:16 -0500
Message-ID: <CACDVny730gQirxmbRD2ZrdmsOMKz9+HBY=JrDVEzbmb49u3TGg@mail.gmail.com>
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
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36847 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbcB0CnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2016 21:43:18 -0500
In-Reply-To: <D2E2AA30.D71E4%himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>

On Fri, Feb 12, 2016 at 12:30 AM, Himanshu Madhani
<himanshu.madhani@qlogic.com> wrote:
> Hi Nic,
>
>
>
> On 2/11/16, 3:47 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wr=
ote:
>
>>On Wed, 2016-02-10 at 22:53 -0800, Nicholas A. Bellinger wrote:
>>> On Tue, 2016-02-09 at 18:03 +0000, Himanshu Madhani wrote:
>>> > On 2/8/16, 9:25 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
>>>wrote:
>>> > >On Mon, 2016-02-08 at 23:27 +0000, Himanshu Madhani wrote:
>>> > >>
>>> > >> I am testing this series with with 4.5.0-rc2+ kernel and I am
>>>seeing
>>> > >>issue
>>> > >> where trying to trigger
>>> > >> sg_reset with option of host/device/bus in loop at 120second
>>>interval
>>> > >> causes call stack. At this point
>>> > >> removing configuration hangs indefinitely. See attached dmesg
>>>output
>>> > >>from
>>> > >> my setup.
>>> > >>
>>> > >
>>> > >Thanks alot for testing this.
>>> > >
>>> > >So It looks like we're still hitting a indefinite schedule() on
>>> > >se_cmd->cmd_wait_comp once tcm_qla2xxx session disconnect/reconn=
ect
>>> > >occurs, after repeated explicit active I/O remote-port sg_resets=
=2E
>>> > >
>>> > >Does this trigger on the first tcm_qla2xxx session reconnect aft=
er
>>> > >explicit remote-port sg_reset..?  Are session reconnects activel=
y
>>>being
>>> > >triggered during the test..?
>>> > >
>>> > >To verify the latter for iscsi-target, I've been using a small p=
atch
>>>to
>>> > >trigger session reset from TMR kthread context in order to simul=
ate
>>>the
>>> > >I_T disconnects.  Something like that would be useful for verify=
ing
>>>with
>>> > >tcm_qla2xxx too.
>>> > >
>>> > >That said, I'll be reproducing with tcm_qla2xxx ports this week,=
 and
>>> > >will enable various debug in a WIP branch for testing.
>>>
>>> Following up here..
>>>
>>> So far using my test setup with ISP2532 ports in P2P + RAMDISK_MCP =
and
>>> v4.5-rc1, repeated remote-port active I/O LUN_RESET (sg_reset -d) h=
as
>>> been functioning as expected with a blocksize_range=3D4k-256k + iod=
epth=3D32
>>> fio write-verify style workload.
>>>
>>> No ->cmd_kref -1 OOPsen or qla2xxx initiator generated ABORT_TASKs =
from
>>> outstanding target TAS responses, nor fio write-verify failures to
>>> report after 800x remote-port active I/O LUN_RESETS.
>>>
>>> Next step will be to verify explicit tcm_qla2xxx port + module shut=
down
>>> after 1K test iterations, and then IBLOCK async completions <-> NVM=
e
>>> backends with the same case.
>>>
>>
>>After letting this test run over-night up to 7k active I/O remote-por=
t
>>LUN_RESETs, things are still functioning as expected.
>>
>>Also, /etc/init.d/target stop was able to successfully shutdown all
>>active sessions and unload tcm_qla2xxx after the test run.
>>
>>So AFAICT, the active I/O remote-port LUN_RESET changes are stable wi=
th
>>tcm_qla2xxx ports, separate from concurrent session disconnect hung t=
ask
>>you reported earlier.
>>
>>That said, I'll likely push this series as-is for -rc4, given that Da=
n
>>has also been able to verify the non conncurrent session disconnect c=
ase
>>on his setup generating constant ABORT_TASKs, and it's still survivin=
g
>>both cases for iscsi-target ports.
>>
>>Please give the debug patch from last night a shot, and see if we can
>>determine the se_cmd states when you hit the hung task.
>
> I=C2=B9ll give your latest debug patch try in a little while
>
> From the testing that I have done, what is seen is that active IO has
> already been completed and qla2xxx driver is waiting for commands to =
be
> Completed and it=C2=B9s waiting indefinitely for cmd_wait_comp.
> So it looks like there is a missing complete call from target_core. I=
=C2=B9ve
> attached our analysis from crash debug on a live system after the iss=
ues
> happens.
>
>
> I can recreate this issue at will within 5 minute of triggering sg_re=
set
> with following steps
>
> 1. Export 4 RAM disk LUNs on each of 2 port adapter. Initiator will s=
ee 8
> RAM disk targets
> 2. Start IO with 4K block size and 8 threads with 80% write 20% read =
and
> 100% dandom.
> (I am using vdbench for generating IO. I can provide setup/config scr=
ipt
> if needed)
> 3. Start sg_reset for each LUNs with first device, bus and host with =
120s
> delay. (I=C2=B9ve attached
> My script that I am using for triggering sg_reset)
>
>>
>>Thank you,
>>
>>-nab
>>
>

Has there been any update to this?

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
