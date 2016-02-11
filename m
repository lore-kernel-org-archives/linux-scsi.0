From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v4 0/5] Fix LUN_RESET active I/O + TMR handling
Date: Wed, 10 Feb 2016 22:53:14 -0800
Message-ID: <1455173594.27060.49.camel@haakon3.risingtidesystems.com>
References: <1454815082-15380-1-git-send-email-nab@daterainc.com>
	 <D2DE6219.D6C44%himanshu.madhani@qlogic.com>
	 <1454995505.10001.153.camel@haakon3.risingtidesystems.com>
	 <D2DF69D8.D6DC5%himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <D2DF69D8.D6DC5%himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Himanshu & Co,

On Tue, 2016-02-09 at 18:03 +0000, Himanshu Madhani wrote:
> Hi Nic, 
> 
> 
> On 2/8/16, 9:25 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> >Hi Himanshu,
> >
> >On Mon, 2016-02-08 at 23:27 +0000, Himanshu Madhani wrote:
> >> 
> >> I am testing this series with with 4.5.0-rc2+ kernel and I am seeing
> >>issue
> >> where trying to trigger
> >> sg_reset with option of host/device/bus in loop at 120second interval
> >> causes call stack. At this point
> >> removing configuration hangs indefinitely. See attached dmesg output
> >>from
> >> my setup. 
> >> 
> >
> >Thanks alot for testing this.
> >
> >So It looks like we're still hitting a indefinite schedule() on
> >se_cmd->cmd_wait_comp once tcm_qla2xxx session disconnect/reconnect
> >occurs, after repeated explicit active I/O remote-port sg_resets.
> >
> >Does this trigger on the first tcm_qla2xxx session reconnect after
> >explicit remote-port sg_reset..?  Are session reconnects actively being
> >triggered during the test..?
> >
> >To verify the latter for iscsi-target, I've been using a small patch to
> >trigger session reset from TMR kthread context in order to simulate the
> >I_T disconnects.  Something like that would be useful for verifying with
> >tcm_qla2xxx too.
> >
> >That said, I'll be reproducing with tcm_qla2xxx ports this week, and
> >will enable various debug in a WIP branch for testing.

Following up here..

So far using my test setup with ISP2532 ports in P2P + RAMDISK_MCP and
v4.5-rc1, repeated remote-port active I/O LUN_RESET (sg_reset -d) has
been functioning as expected with a blocksize_range=4k-256k + iodepth=32
fio write-verify style workload.

No ->cmd_kref -1 OOPsen or qla2xxx initiator generated ABORT_TASKs from
outstanding target TAS responses, nor fio write-verify failures to
report after 800x remote-port active I/O LUN_RESETS.

Next step will be to verify explicit tcm_qla2xxx port + module shutdown
after 1K test iterations, and then IBLOCK async completions <-> NVMe
backends with the same case.

> Let me know if I can help in any way for testing/validating this series.
> 

Thanks.  :)

So based on your original log, it's still unclear clear if the session
reset resulting in se_cmd->cmd_wait_comp indefinite sleep + ->cmd_kref
leak is happen concurrently with repeated remote port LUN_RESET, or the
session reset -> target_wait_for_sess_cmds() occurs after active I/O has
already completed..?  Please confirm.

To that end, target-pending/debug-for-himanshu has been pushed to enable
extra debug for test, please update.

Also, you'll want to enable microsecond ring buffer timestamps in your
kernel build too, as it's very useful for type this debugging.

Thank you,

--nab
