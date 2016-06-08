From: Sagi Grimberg <sagi@lightbits.io>
Subject: Re: NVMe over Fabrics target implementation
Date: Wed, 8 Jun 2016 16:12:27 +0300
Message-ID: <575819BB.7010209@lightbits.io>
References: <1465248177-17970-1-git-send-email-hch@lst.de>
 <1465280632.5365.58.camel@haakon3.risingtidesystems.com>
 <20160607105550.GB17113@lst.de>
 <1465363301.5365.81.camel@haakon3.risingtidesystems.com>
 <20160608121932.GA31316@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160608121932.GA31316@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, keith.busch@intel.com, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


>> *) Extensible to multiple types of backend drivers.
>>
>> nvme-target needs a way to absorb new backend drivers, that
>> does not effect existing configfs group layout or attributes.
>>
>> Looking at the nvmet/configfs layout as-is, there are no multiple
>> backend types defined, nor a way to control backend feature bits
>> exposed to nvme namespaces at runtime.

Hey Nic,

As for different type of backends, I still don't see a big justification
for adding the LIO backends pscsi (as it doesn't make sense),
ramdisk (we have brd), or file (losetup).

What kind of feature bits would you want to expose at runtime?

> And that's very much intentional.  We have a very well working block
> layer which we're going to use, no need to reivent it.  The block
> layer supports NVMe pass through just fine in case we'll need it,
> as I spent the last year preparing it for that.
>
>> Why does it ever make sense for $SUBSYSTEM_NQN_0 with $PORT_DRIVER_FOO
>> to block operation of $SUBSYSTEM_NQN_1 with $PORT_DRIVER_BAR..?
>
> Because it keeps the code simple.  If you had actually participated
> on our development list you might have seen that until not too long
> ago we have very fine grainded locks here.  In the end Armen convinced
> me that it's easier to maintain if we don't bother with fine grained
> locking outside the fast path, especially as it significantly simplifies
> the discovery implementation.   If if it ever turns out to be an
> issue we can change it easily as the implementation is well encapsulated.

We did change that, and Nic is raising a valid point in terms of having
a global mutex around all the ports. If the requirement of nvme
subsystems and ports configuration is that it should happen fast enough
and scale to the numbers that Nic is referring to, we'll need to change
that back.

Having said that, I'm not sure this is a real hard requirement for RDMA
and FC in the mid-term, because from what I've seen, the workloads Nic
is referring to are more typical for iscsi/tcp where connections are
cheaper and you need more to saturate a high-speed interconnects, so
we'll probably see this when we have nvme over tcp working.
