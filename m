From: Christoph Hellwig <hch@lst.de>
Subject: Re: NVMe over Fabrics target implementation
Date: Wed, 8 Jun 2016 15:46:25 +0200
Message-ID: <20160608134625.GA337@lst.de>
References: <1465248177-17970-1-git-send-email-hch@lst.de> <1465280632.5365.58.camel@haakon3.risingtidesystems.com> <20160607105550.GB17113@lst.de> <1465363301.5365.81.camel@haakon3.risingtidesystems.com> <20160608121932.GA31316@lst.de> <575819BB.7010209@lightbits.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <575819BB.7010209@lightbits.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@lightbits.io>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, axboe@kernel.dk, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, keith.busch@intel.com, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 08, 2016 at 04:12:27PM +0300, Sagi Grimberg wrote:
>> Because it keeps the code simple.  If you had actually participated
>> on our development list you might have seen that until not too long
>> ago we have very fine grainded locks here.  In the end Armen convinced
>> me that it's easier to maintain if we don't bother with fine grained
>> locking outside the fast path, especially as it significantly simplifies
>> the discovery implementation.   If if it ever turns out to be an
>> issue we can change it easily as the implementation is well encapsulated.
>
> We did change that, and Nic is raising a valid point in terms of having
> a global mutex around all the ports. If the requirement of nvme
> subsystems and ports configuration is that it should happen fast enough
> and scale to the numbers that Nic is referring to, we'll need to change
> that back.
>
> Having said that, I'm not sure this is a real hard requirement for RDMA
> and FC in the mid-term, because from what I've seen, the workloads Nic
> is referring to are more typical for iscsi/tcp where connections are
> cheaper and you need more to saturate a high-speed interconnects, so
> we'll probably see this when we have nvme over tcp working.

I'm not really worried about connection establishment - that can be
changed to RCU locking really easily.  I'm a bit more worried about
the case where a driver would block long in ->add_port.  But let's
worry about that if an actual user comes up.  The last thing we need
in a new driver is lots of complexity for hypothetical use cases,
I'm much more interested in having the driver simple, testable and
actually tested than optimizing for something.

That is to say the priorities here are very different from Nic's goals
for the target code.
