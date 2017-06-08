From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 14/23] scsi: hisi_sas: add v3 cq interrupt handler
Date: Thu, 8 Jun 2017 00:34:00 -0700
Message-ID: <20170608073400.GA9292@infradead.org>
References: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
 <1496241195-217678-15-git-send-email-john.garry@huawei.com>
 <20170601054147.GB4743@infradead.org>
 <04821e06-7541-1861-d52b-4df869570ca7@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <04821e06-7541-1861-d52b-4df869570ca7@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

Hi John,

sorry for dropping the ball, but your repost reminded me.

On Thu, Jun 01, 2017 at 11:36:55AM +0100, John Garry wrote:
> In the command completion code we need to check for abnormal completion due
> to underflow, but ignore it when it occurs in some commands, like inquiry.
> This is why we check for rw command - it is equivalent to !inquiry.
> 
> I'll see if we can change the check to explicitly ignore certain commands
> which complete abnormally with underflow.

In general it should be up to the higher level and not the driver
to detect underflow, and that's how most (hopefully all, but I won't
bet on some older ones) of our drivers operate.

> 
> > What about 32-byte CDs or things like Write Same?
> > 
> 
> You're talking about VARIABLE_LENGTH_CMD (opcode 0x7f) for 32-byte CDs,
> right?

Yes.
