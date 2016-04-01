From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: QoS for iSCSI target?
Date: Fri, 1 Apr 2016 12:35:46 -0600
Message-ID: <56FEBF82.9050909@windriver.com>
References: <56E1F419.5070005@windriver.com>	 <20160311073018.GA23379@infradead.org>	 <1457682341.4062.74.camel@haakon3.risingtidesystems.com>	 <56E98E5F.9030107@windriver.com> <1459407929.31390.89.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1459407929.31390.89.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/31/2016 01:05 AM, Nicholas A. Bellinger wrote:
> On Wed, 2016-03-16 at 10:48 -0600, Chris Friesen wrote:
>> On 03/11/2016 01:45 AM, Nicholas A. Bellinger wrote:
>>> On Thu, 2016-03-10 at 23:30 -0800, Christoph Hellwig wrote:
>>>> On Thu, Mar 10, 2016 at 04:24:25PM -0600, Chris Friesen wrote:
>>>>> Hi,
>>>>>
>>>>> I'm looking for information on whether the iSCSI target in the kernel offers
>>>>> any way to do QoS between traffic driven by different initiators.
>>>>>
>>>>> I'm trying to make sure that one initiator can't do a denial-of-service
>>>>> attack against others.
>>>>>
>>>>> Does the kernel target have this sort of thing built-in, or do I need to
>>>>> look at network traffic-shaping to achieve this?
>>>>
>>>> It doesn't right now, but it shouldn't be hard to integrate it with
>>>> blk cgroups.
>>>
>>> For iscsi-target application QoS, the per session command sequence
>>> number window depth (CmdSN) exists to enforce per InitiatorName limits
>>> via TPG default_cmdsn_depth + se_node_acl->queue_depth configfs
>>> attributes.
>>>
>>> Note these values can be changed on the fly for iscsi-target using
>>> explicit se_node_acl->acl_group, but currently require a se_session
>>> reinstatement event for updated ExpCmdSN + MaxCmdSN to take effect.
>>
>> On a slightly different note, is there any way to throttle or limit the overall
>> bandwidth consumed by the iSCSI target in the kernel?  I'd like to ensure that
>> the iSCSI traffic doesn't completely swamp the host accesses to the same block
>> device.
>>
>> I suppose I could do networking-based traffic shaping, but are there any
>> controls in the block IO subsystem?
>>
>
> On a individual block_device backend basis, block cgroups is the
> preferred method for doing this.
>
> Note that any rate limiting imposed by block cgroups is subject to the
> current se_node_acl->queue_depth enforced across all LUNs within a given
> iscsi session.


How would I use cgroups with the kernel iSCSI target?  Is there a set of kernel 
threads dedicated to the iSCSI target that I can assign to a particular group?

Chris
