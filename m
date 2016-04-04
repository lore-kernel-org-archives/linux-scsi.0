From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: QoS for iSCSI target?
Date: Mon, 4 Apr 2016 09:20:33 -0600
Message-ID: <57028641.5000100@windriver.com>
References: <56E1F419.5070005@windriver.com>	 <20160311073018.GA23379@infradead.org>	 <1457682341.4062.74.camel@haakon3.risingtidesystems.com>	 <56E98E5F.9030107@windriver.com>	 <1459407929.31390.89.camel@haakon3.risingtidesystems.com>	 <56FEBF82.9050909@windriver.com> <1459646152.13184.26.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1459646152.13184.26.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/02/2016 07:15 PM, Nicholas A. Bellinger wrote:
> On Fri, 2016-04-01 at 12:35 -0600, Chris Friesen wrote:

>>>> On a slightly different note, is there any way to throttle or limit the overall
>>>> bandwidth consumed by the iSCSI target in the kernel?  I'd like to ensure that
>>>> the iSCSI traffic doesn't completely swamp the host accesses to the same block
>>>> device.
>>>>
>>>> I suppose I could do networking-based traffic shaping, but are there any
>>>> controls in the block IO subsystem?
>>>>
>>>
>>> On a individual block_device backend basis, block cgroups is the
>>> preferred method for doing this.
>>>
>>> Note that any rate limiting imposed by block cgroups is subject to the
>>> current se_node_acl->queue_depth enforced across all LUNs within a given
>>> iscsi session.
>>
>>
>> How would I use cgroups with the kernel iSCSI target?  Is there a set of kernel
>> threads dedicated to the iSCSI target that I can assign to a particular group?
>>
>
> block cgroups can set I/O throttling (bandwidth + IOPs) limits for any
> normal struct block_device.
>
> These values are configured via blkio.throttle.* resource class, and the
> limits are imposed independently of the block_device's association with
> target_core_mod backend driver export.  Namely:
>
>      blkio.throttle.write_iops_device
>      blkio.throttle.read_iops_device
>      blkio.throttle.write_bps_device
>      blkio.throttle.read_bdp_device
>
> Some examples using these values, plus more blkio.* info is here:
> http://events.linuxfoundation.org/sites/events/files/slides/cgroups_0.pdf.
>

I understand how to set up the cgroups, but don't I need to ensure that the IO 
operations happen in the context of a particular cgroup?  If so, how do I ensure 
that the in-kernel iSCSI target traffic happens in the context of the specified 
group?  Are there a set of kernel threads dedicated to processing iSCSI requests?

Chris
