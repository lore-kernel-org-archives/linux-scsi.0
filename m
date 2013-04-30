From: Florian Westphal <fw@strlen.de>
Subject: Re: "WRITE SAME failed. Manually zeroing" with 3w-xxxx driver
Date: Tue, 30 Apr 2013 09:36:44 +0200
Message-ID: <20130430073644.GI32324@breakpoint.cc>
References: <20130429152639.GG32324@breakpoint.cc>
 <yq1obcxpb76.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1obcxpb76.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Florian Westphal <fw@strlen.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, adam radford <aradford@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen <martin.petersen@oracle.com> wrote:
> >>>>> "Florian" == Florian Westphal <fw@strlen.de> writes:
> 
> Florian> After update to 3.8 dmesg is spammed with: kernel: [
> Florian> 280.272094] 3w-xxxx: scsi8: Unknown scsi opcode: 0x41 kernel: [
> Florian> 280.272107] sd 8:0:0:0: [sda] Unhandled error code kernel: 
> 
> Could you please test the patch below?

Works. Only one WRITE_SAME error at boot, max_write_same_blocks in sysfs
is 0, which wasn't the case before.

> The second question is what it is that's issuing these zeroouts at boot?
> Which filesystem are you using? What's your DM/MD config?

ext4, no DM/MD is used.  I guess the zeroouts are from postgres, but i'm
not sure.

> 3w-xxxx: Create sense buffer for unsupported commands
> 
> Make the driver return appropriate sense data when an unsupported
> operation is queued. This will cause the SCSI layer to stop issuing the
> offending command.
> 
> Reported-by: Florian Westphal <fw@strlen.de>
> CC: adam radford <aradford@gmail.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Tested-by: Florian Westphal <fw@strlen.de>

Thanks again.
