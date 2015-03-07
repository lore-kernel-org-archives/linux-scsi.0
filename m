From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Sat, 07 Mar 2015 04:41:54 +0200
Message-ID: <54FA6572.5040109@dev.mellanox.co.il>
References: <54B7E70C.8020304@sandisk.com> <20150119092153.GA8666@infradead.org> <54BCD00D.4080603@sandisk.com> <54E7112F.2080901@sandisk.com> <1424476807.1477.52.camel@haakon3.risingtidesystems.com> <54ED8B38.10904@sandisk.com> <1425074315.30923.74.camel@haakon3.risingtidesystems.com> <54F1ADAF.90808@sandisk.com> <1425279574.13530.53.camel@haakon3.risingtidesystems.com> <54F6DD3B.4030207@sandisk.com> <20150305132337.GA32341@infradead.org> <54F87F17.30207@sandisk.com> <54F8A2B0.70202@redhat.com> <54F9565A.2080103@sandisk.com> <54F9FCEB.3080806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54F9FCEB.3080806@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 3/6/2015 9:15 PM, Andy Grover wrote:
> On 03/05/2015 11:25 PM, Bart Van Assche wrote:
>> On 03/05/15 19:39, Andy Grover wrote:
>>> On 03/05/2015 08:06 AM, Bart Van Assche wrote:
>>>> If we would do what Nic proposed - modify SCST such that it uses
>>>> configfs instead of sysfs - then that would result in the removal of at
>>>> least one SCST feature that is important to its users, namely automatic
>>>> population of the configuration filesystem with hardware target port
>>>> information. Apparently Nic does not want to convert LIO from configfs
>>>> to sysfs.
>>>
>>> Clearly configfs is here to stay, but is there anything that says LIO
>>> couldn't have both? Besides the issue at hand, there are some other bits
>>> of useful info in LIO that aren't available because of configfs'
>>> limitations, but that would be possible via sysfs.
>>
>> (resending my reply since apparently my previous e-mail didn't make it
>> to the lists)
>
>> Let's have a look at FC HBAs. Most FC HBAs have a PCIe connector and
>> support NPIV. If an NPIV WWN is configured then that WWN is passed from
>> user space to the kernel. The PCIe specification supports hot-plugging.
>> Although I'm not sure there exist FC HBAs that support hot-plugging,
>> upon hot removal of a PCIe HBA the kernel is notified of this and must
>> remove all NPIV WWNs from the filesystem that is used to configure the
>> SCSI target subsystem. Since it is not allowed to remove configfs
>> directories from inside the kernel I think NPIV is an example of a use
>> case that cannot be handled properly when using configfs for configuring
>> a SCSI target subsystem, even when combined in some way with sysfs.
>
> This isn't a problem, because having a configuration for a device's WWNs
> in configfs does not mean the device must be present. When the device
> shows up then the target config will be used for it, and if the device
> is removed the configuration no longer does anything, but still remains.
>
> What's in configfs reflects only the config, which is why I'm wondering
> if adding sysfs support might also be a good thing. sysfs would let LIO
> create entries to better reflect actual running state, and be less
> limited in reporting status on only "things that have config".
>
> For example, LIO requires an ACL for all initiators but has a setting to
> autogenerate these if per-ACL lun-mapping & auth is not desired. There's
> no way for userspace to get a list of generated ACLs -- maybe userspace
> wants to make it easy to convert generated ACLs to actual ACLs. LIO
> can't create configfs nodes in-kernel and each configfs file is limited
> to PAGE_SIZE so we can't just have a configfs entry that lists all of
> them.  That's what I was getting at above: configfs works great for
> exactly what we're using it for, but there are other things sysfs does
> better so we may want to use both.

That always annoyed me too. But seeing generated ACLs in sysfs while
user configured ACLs lives in configfs is weird isn't it? I'm wander if
having both sysfs/configfs interfaces might be confusing and/or messy.
