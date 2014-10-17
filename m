From: David Miller <davem@davemloft.net>
Subject: Re: Sparc ESP problem with blk-mq
Date: Fri, 17 Oct 2014 15:56:12 -0400 (EDT)
Message-ID: <20141017.155612.266274322805506383.davem@davemloft.net>
References: <20141015133551.GA15539@infradead.org>
	<20141015.165324.1768019967735260346.davem@davemloft.net>
	<alpine.LRH.2.11.1410160942150.13273@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1410160942150.13273@adalberg.ut.ee>
Sender: sparclinux-owner@vger.kernel.org
To: mroos@linux.ee
Cc: hch@infradead.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: mroos@linux.ee
Date: Thu, 16 Oct 2014 09:43:34 +0300 (EEST)

> [  158.730919] ESP: tgt[6] lun[0] scsi_cmd [ 12 00 00 00 24 00 ]
> [  158.799397] ESP: intr sreg[87] seqreg[00] sreg2[00] ireg[18]

Target 6 responds, Bus Service + Function Done interrupt.

Status register 1 indicates interrupt pending, phase is MESSAGE IN.

> [  158.866964] ESP: intr sreg[87] seqreg[02] sreg2[00] ireg[08]

Another interrupt, just plain Function Done, we're getting the
message-in byte.  Phase is unchanged.

> [  158.934651] ESP: Got msgin byte 7

Receive MESSAGE_REJECT (0x7).

> [  158.974329] ESP: intr sreg[86] seqreg[02] sreg2[00] ireg[10]

Bus Service interrupt, we've moved to Message Out phase.

> [  159.041950] ESP: Sending message [ 06 ]

Sending ABORT_TASK_SET message.

> [  159.087894] ESP: intr sreg[80] seqreg[02] sreg2[00] ireg[20]

Disconnect interrupt.

> [  159.155522] ESP: start data addr[c01f1100] len[36] write(0)
> [  159.222248] ESP: intr sreg[80] seqreg[02] sreg2[00] ireg[40]
> [  159.289891] ESP: unexpected IREG 40

We attempt some kind of data transfer (maybe for the status block)
and the device gives us an illegal-command interrupt.

More details in the event log that gets dumped:

[  161.208873] esp: esp0: ent[31] EVENT val[0d] sreg[87] seqreg[02] sreg2[00] ireg[18] ss[00] event[0c]

Check Phase

[  161.318255] esp: esp0: ent[0] EVENT val[06] sreg[87] seqreg[02] sreg2[00] ireg[18] ss[00] event[0d]

Message In

[  161.426599] esp: esp0: ent[1] CMD val[01] sreg[87] seqreg[02] sreg2[00] ireg[18] ss[00] event[06]

Give FIFO flush ESP command

[  161.532860] esp: esp0: ent[2] CMD val[10] sreg[87] seqreg[02] sreg2[00] ireg[18] ss[00] event[06]

Give "transfer information" ESP command.

[  161.639125] esp: esp0: ent[3] CMD val[1a] sreg[87] seqreg[02] sreg2[00] ireg[08] ss[00] event[06]

Give "Set ATN" command to move to message-out to give the chip the
ABORT message.

[  161.745386] esp: esp0: ent[4] CMD val[12] sreg[87] seqreg[02] sreg2[00] ireg[08] ss[00] event[06]

Give "Message OK" command to ACK the message-in from the device.

[  161.851643] esp: esp0: ent[5] EVENT val[0d] sreg[87] seqreg[02] sreg2[00] ireg[08] ss[00] event[06]

Check Phase.

[  161.959990] esp: esp0: ent[6] EVENT val[09] sreg[86] seqreg[02] sreg2[00] ireg[10] ss[00] event[0d]

Message Out.

[  162.068332] esp: esp0: ent[7] CMD val[01] sreg[86] seqreg[02] sreg2[00] ireg[10] ss[00] event[09]

Flush FIFO

[  162.174593] esp: esp0: ent[8] CMD val[10] sreg[86] seqreg[02] sreg2[00] ireg[10] ss[00] event[09]

Transfer Information

[  162.280854] esp: esp0: ent[9] EVENT val[0a] sreg[86] seqreg[02] sreg2[00] ireg[10] ss[00] event[09]

Message Out done.

[  162.389204] esp: esp0: ent[10] EVENT val[0d] sreg[80] seqreg[02] sreg2[00] ireg[20] ss[00] event[0a]

Check Phase.

[  162.498588] esp: esp0: ent[11] EVENT val[04] sreg[80] seqreg[02] sreg2[00] ireg[20] ss[00] event[0d]

Data Out.

[  162.607977] esp: esp0: ent[12] CMD val[90] sreg[80] seqreg[02] sreg2[00] ireg[20] ss[00] event[04]

Perform DMA based Transfer Information

[  162.715275] esp: esp0: ent[13] EVENT val[05] sreg[80] seqreg[02] sreg2[00] ireg[20] ss[00] event[04]

Data done.

What's really weird is that we disconnected as per the next-to-last interrupt in the top-level
trace, but then we try to send the device data.  I wonder why we don't pick up on this :-/
It seems the interrupt processing only picks up cleanly if we have not selected successfully
yet, and this code path things we have (via esp->select_state).

I'll try to see if there is anything about the blk-mq code paths that
might shed some more light on this.
