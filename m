From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Is the possible cross-talking between unrelated file-descriptors
 on bsg-device by design?
Date: Tue, 19 Sep 2017 14:16:26 -0400
Message-ID: <68979092-baeb-58e7-0cbc-c6c7bc986908@interlog.com>
References: <20170919145632.GB28979@bblock-ThinkPad-W530>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55868 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751370AbdISSQi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Sep 2017 14:16:38 -0400
In-Reply-To: <20170919145632.GB28979@bblock-ThinkPad-W530>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Rob Lester <Robert.Lester@hgst.com>

On 2017-09-19 10:56 AM, Benjamin Block wrote:
> Hello linux-block,
> 
> I wrote some tests recently to test patches against bsg.c and bsg-lib.c,
> and while writing those I noticed something strange:
> 
> When you use the write() and read() call on multiple file-descriptors
> for a single bsg-device (FC or SCSI), it is possible that you get
> cross-talk between those different file-descriptors.
> 
> E.g.: You have two independent processes open a FD on /dev/bsg/fc_host0
> and you send commands via write() in both processes, when they both do
> read() later on - to read the response for the commands they send before
> -, it is possible that process A gets the response (Sense-Data,
> FC-Protocol-Data, ...) for a command that process B wrote and vis-a-vis.
> 
> I noticed this because in my tests I 'tag' each command I send with
> write() via a value I write into the usr_ptr field of sg_io_v4. When I
> later user read() to receive responses I check for this tag in a
> hash-table and so can look up the original command. When I used this and
> spawned multiple processes with the same target bsg-device, I got
> responses for commands I don't have tags for in my hash-table, so they
> were written by an other process. This never happend when I only spawn
> one test-process.
> 
> This seems awfully contra-productive.. so much that I don't see any
> point in allowing users to open more than one FD per bsg-device, because
> that would inevitably lead to very hard to debug 'bugs'. And I wonder if
> this is really by design or some regression that happend over time.
> 
> I looked at the code in bsg.c and yes, it seems this is what is coded
> right now. We have a hash-table which manages all 'struct bsg_device's
> who are indexed by device-minors, so one hash-table entry per
> device-node.
> 
> So eh, long talk short question, is that intended?

Hi,
About once a year I point out that major misfeature in the bsg driver
and no-one seems to care. Most recently I pointed it out in a
discussion about SCSI SG CVE-2017-0794 6 days ago:
   " ... Last time I looked at the bsg driver, a SCSI command
     could be issued on one file descriptor and its data-in block
     and SCSI status delivered to another file descriptor to the
     same block device (potentially in another process). IOW chaos"

It is hard to imagine any sane application relying on this bizarre
behaviour so fixing it should not break any applications. My guess
is that it would require a non-trivial patch set to fix. Would you
like to volunteer?


In the same post I asked (thinking it was cc-ed to this list):
"BTW Is there a NVMe pass-through?"

And the answer is: yes there is in include/uapi/linux/nvme_ioctl.h
which has struct nvme_user_io and struct nvme_passthru_cmd plus
several ioctl constants. See the smartmontool repository for
examples of how to use them. I also discovered there is a SCSI
to NVMe translation layer (SNTL) hiding in some kernels. Hence
commands like this:
    sg_inq /dev/nvme0    ## that's a 'char' device, and ...
    sg_vpd /dev/nvme0n1  ## that's a block device "namespace 1"

work as expected. Ah, I spoke too soon ... in another post I have
been informed that the SNTL has now been removed from the kernel.
Just goes to show the human stupidity is still infinite :-)

Doug Gilbert
