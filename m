From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: QoS for iSCSI target?
Date: Tue, 5 Apr 2016 08:22:59 -0600
Message-ID: <5703CA43.7000608@windriver.com>
References: <56E1F419.5070005@windriver.com>	 <20160311073018.GA23379@infradead.org>	 <1457682341.4062.74.camel@haakon3.risingtidesystems.com>	 <56E98E5F.9030107@windriver.com>	 <1459407929.31390.89.camel@haakon3.risingtidesystems.com>	 <56FEBF82.9050909@windriver.com>	 <1459646152.13184.26.camel@haakon3.risingtidesystems.com>	 <57028641.5000100@windriver.com>	 <1459808966.10124.11.camel@haakon3.risingtidesystems.com>	 <5702F260.5010404@windriver.com> <1459815906.10124.44.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1459815906.10124.44.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/04/2016 06:25 PM, Nicholas A. Bellinger wrote:
> On Mon, 2016-04-04 at 17:01 -0600, Chris Friesen wrote:

>> I'm not trying to globally throttle IO on a particular block device.  I'm trying
>> to control how much IO the iSCSI target in the kernel is allowed to drive on a
>> particular block device.
>>
>> The goal is to ensure that the iSCSI target does not consume all of the
>> available bandwidth for a particular block device.  I want to ensure that some
>> of the bandwidth for that device is available to other processes on the host
>> (for management purposes) rather than being consumed by a greedy iSCSI initiator.
>>
>
> AFAIK, different traffic classes for a single block device is not
> supported by block cgroups.
>
> Also given target_core_iblock claims a given block_device for exclusive
> access, you can't actually use the same block device for a mounted
> filesystem, LVM, MD, etc, once it's been registered for target usage.

The issue we're running into is in the context of OpenStack Cinder.  It layers 
LVM on top of the bare block device, then creates an LVM volume per cinder 
volume, and exports the logical volumes via iSCSI.

The problem we're seeing is that if one or more iSCSI initiators drive heavy 
traffic on a slow disk, it can become very slow to access anything at all on the 
bare block device (/dev/sdb or equivalent).  This can cause the server-side 
management code to time out on operations like making a new volume, checking 
free disk space, etc.

>> In an ideal world I would like a set of rules that say things like:
>> 1) if there is contention, ensure that the host is guaranteed X percent of the
>> available /dev/sdb IOPS
>> 2) if there is contention, do not allow the iSCSI target traffic to consume more
>> than Y percent of /dev/sdb's write traffic
>>
>
> Yeah, that doesn't exist in standlone block groups.
>
> You could probably use network cgroups to limit bandwidth at the socket
> level for iscsi_target_mod, but that's going to be across all LUNs in a
> session, and not at individual LUN level.

Are there a set of dedicated kernel threads being used for the iSCSI target?  Or 
is it handled by generic softirq mechanisms?

Chris
