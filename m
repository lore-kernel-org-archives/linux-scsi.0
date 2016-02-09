From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v4 0/5] Fix LUN_RESET active I/O + TMR handling
Date: Mon, 08 Feb 2016 21:25:05 -0800
Message-ID: <1454995505.10001.153.camel@haakon3.risingtidesystems.com>
References: <1454815082-15380-1-git-send-email-nab@daterainc.com>
	 <D2DE6219.D6C44%himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <D2DE6219.D6C44%himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Himanshu,

On Mon, 2016-02-08 at 23:27 +0000, Himanshu Madhani wrote:
> 
> I am testing this series with with 4.5.0-rc2+ kernel and I am seeing issue
> where trying to trigger
> sg_reset with option of host/device/bus in loop at 120second interval
> causes call stack. At this point
> removing configuration hangs indefinitely. See attached dmesg output from
> my setup. 
> 

Thanks alot for testing this.

So It looks like we're still hitting a indefinite schedule() on
se_cmd->cmd_wait_comp once tcm_qla2xxx session disconnect/reconnect
occurs, after repeated explicit active I/O remote-port sg_resets.

Does this trigger on the first tcm_qla2xxx session reconnect after
explicit remote-port sg_reset..?  Are session reconnects actively being
triggered during the test..?

To verify the latter for iscsi-target, I've been using a small patch to
trigger session reset from TMR kthread context in order to simulate the
I_T disconnects.  Something like that would be useful for verifying with
tcm_qla2xxx too.

That said, I'll be reproducing with tcm_qla2xxx ports this week, and
will enable various debug in a WIP branch for testing.

Thank you,

--nab
