From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [PATCH-v4 0/5] Fix LUN_RESET active I/O + TMR handling
Date: Tue, 9 Feb 2016 18:03:35 +0000
Message-ID: <D2DF69D8.D6DC5%himanshu.madhani@qlogic.com>
References: <1454815082-15380-1-git-send-email-nab@daterainc.com>
 <D2DE6219.D6C44%himanshu.madhani@qlogic.com>
 <1454995505.10001.153.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1454995505.10001.153.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Content-ID: <6E75917FDD1BF844A00E01693ED328F0@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Nic, 


On 2/8/16, 9:25 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>Hi Himanshu,
>
>On Mon, 2016-02-08 at 23:27 +0000, Himanshu Madhani wrote:
>> 
>> I am testing this series with with 4.5.0-rc2+ kernel and I am seeing
>>issue
>> where trying to trigger
>> sg_reset with option of host/device/bus in loop at 120second interval
>> causes call stack. At this point
>> removing configuration hangs indefinitely. See attached dmesg output
>>from
>> my setup. 
>> 
>
>Thanks alot for testing this.
>
>So It looks like we're still hitting a indefinite schedule() on
>se_cmd->cmd_wait_comp once tcm_qla2xxx session disconnect/reconnect
>occurs, after repeated explicit active I/O remote-port sg_resets.
>
>Does this trigger on the first tcm_qla2xxx session reconnect after
>explicit remote-port sg_reset..?  Are session reconnects actively being
>triggered during the test..?
>
>To verify the latter for iscsi-target, I've been using a small patch to
>trigger session reset from TMR kthread context in order to simulate the
>I_T disconnects.  Something like that would be useful for verifying with
>tcm_qla2xxx too.
>
>That said, I'll be reproducing with tcm_qla2xxx ports this week, and
>will enable various debug in a WIP branch for testing.

Let me know if I can help in any way for testing/validating this series.

>
>Thank you,
>
>--nab
>
