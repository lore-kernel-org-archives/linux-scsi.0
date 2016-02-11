From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v4 0/5] Fix LUN_RESET active I/O + TMR handling
Date: Thu, 11 Feb 2016 15:47:48 -0800
Message-ID: <1455234468.30845.8.camel@haakon3.risingtidesystems.com>
References: <1454815082-15380-1-git-send-email-nab@daterainc.com>
	 <D2DE6219.D6C44%himanshu.madhani@qlogic.com>
	 <1454995505.10001.153.camel@haakon3.risingtidesystems.com>
	 <D2DF69D8.D6DC5%himanshu.madhani@qlogic.com>
	 <1455173594.27060.49.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47270 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbcBKXr7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2016 18:47:59 -0500
In-Reply-To: <1455173594.27060.49.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>

On Wed, 2016-02-10 at 22:53 -0800, Nicholas A. Bellinger wrote:
> On Tue, 2016-02-09 at 18:03 +0000, Himanshu Madhani wrote:
> > On 2/8/16, 9:25 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > >On Mon, 2016-02-08 at 23:27 +0000, Himanshu Madhani wrote:
> > >> 
> > >> I am testing this series with with 4.5.0-rc2+ kernel and I am seeing
> > >>issue
> > >> where trying to trigger
> > >> sg_reset with option of host/device/bus in loop at 120second interval
> > >> causes call stack. At this point
> > >> removing configuration hangs indefinitely. See attached dmesg output
> > >>from
> > >> my setup. 
> > >> 
> > >
> > >Thanks alot for testing this.
> > >
> > >So It looks like we're still hitting a indefinite schedule() on
> > >se_cmd->cmd_wait_comp once tcm_qla2xxx session disconnect/reconnect
> > >occurs, after repeated explicit active I/O remote-port sg_resets.
> > >
> > >Does this trigger on the first tcm_qla2xxx session reconnect after
> > >explicit remote-port sg_reset..?  Are session reconnects actively being
> > >triggered during the test..?
> > >
> > >To verify the latter for iscsi-target, I've been using a small patch to
> > >trigger session reset from TMR kthread context in order to simulate the
> > >I_T disconnects.  Something like that would be useful for verifying with
> > >tcm_qla2xxx too.
> > >
> > >That said, I'll be reproducing with tcm_qla2xxx ports this week, and
> > >will enable various debug in a WIP branch for testing.
> 
> Following up here..
> 
> So far using my test setup with ISP2532 ports in P2P + RAMDISK_MCP and
> v4.5-rc1, repeated remote-port active I/O LUN_RESET (sg_reset -d) has
> been functioning as expected with a blocksize_range=4k-256k + iodepth=32
> fio write-verify style workload.
> 
> No ->cmd_kref -1 OOPsen or qla2xxx initiator generated ABORT_TASKs from
> outstanding target TAS responses, nor fio write-verify failures to
> report after 800x remote-port active I/O LUN_RESETS.
> 
> Next step will be to verify explicit tcm_qla2xxx port + module shutdown
> after 1K test iterations, and then IBLOCK async completions <-> NVMe
> backends with the same case.
> 

After letting this test run over-night up to 7k active I/O remote-port
LUN_RESETs, things are still functioning as expected.

Also, /etc/init.d/target stop was able to successfully shutdown all
active sessions and unload tcm_qla2xxx after the test run.

So AFAICT, the active I/O remote-port LUN_RESET changes are stable with
tcm_qla2xxx ports, separate from concurrent session disconnect hung task
you reported earlier.

That said, I'll likely push this series as-is for -rc4, given that Dan
has also been able to verify the non conncurrent session disconnect case
on his setup generating constant ABORT_TASKs, and it's still surviving
both cases for iscsi-target ports.

Please give the debug patch from last night a shot, and see if we can
determine the se_cmd states when you hit the hung task.

Thank you,

-nab

