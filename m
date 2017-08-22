From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 1/2] scsi: Move scsi_cmd->jiffies_at_alloc
        initialization to allocation time
Date: Tue, 22 Aug 2017 08:51:04 +0200
Message-ID: <20170822065104.GA7054@lst.de>
References: <1502902815.3305.22.camel@abdul.in.ibm.com> <1502904072.2421.3.camel@wdc.com> <2f686064-3e32-df8d-134f-962b5181da9d@linux.vnet.ibm.com> <1502985161.2615.8.camel@wdc.com> <71fb9c1b-9f3f-acdc-8bb5-aa1240aea763@linux.vnet.ibm.com> <1503092473.2622.17.camel@wdc.com> <0f7e2114-eba1-f149-ea80-d32d8b6d212a@linux.vnet.ibm.com> <1503094414.2622.21.camel@wdc.com> <f4ec8576-f4d7-4be3-0f38-c1a9d7ef4251@linux.vnet.ibm.com> <21928108-3a20-577e-99c8-6da05637c158@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <21928108-3a20-577e-99c8-6da05637c158@linux.vnet.ibm.com>
Sender: linux-next-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "sachinp@linux.vnet.ibm.com" <sachinp@linux.vnet.ibm.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 21, 2017 at 05:13:20PM -0500, Brian King wrote:
> Move the initialization of scsi_cmd->jiffies_at_alloc to allocation
> time rather than prep time. Also ensure that jiffies_at_alloc
> is preserved when we go through prep. This lets us send retries
> through prep again and not break the overall retry timer logic
> in scsi_softirq_done.
> 
> Suggested-by: Bart Van Assche <Bart.VanAssche@wdc.com>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

As far as I can tell this will never set jiffies_at_alloc for the
blk-mq path.
