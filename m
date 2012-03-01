From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v8 08/13] libsas: libsas.force_hard_reset module parameter
Date: Wed, 29 Feb 2012 19:23:02 -0500
Message-ID: <4F4EC166.4010101@interlog.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com> <20120210084520.25701.83280.stgit@dwillia2-linux.jf.intel.com> <1330552551.8846.24.camel@dabdike> <4F4EA976.4010607@interlog.com> <CABE8wwsQdhg-LhEN=sLoZAsNpOmfMVzHCpvaW5E3A1LuXzTKkw@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CABE8wwsQdhg-LhEN=sLoZAsNpOmfMVzHCpvaW5E3A1LuXzTKkw@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jack Wang <jack_wang@usish.com>, Luben Tuikov <ltuikov@yahoo.com>, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

On 12-02-29 06:27 PM, Dan Williams wrote:
> On Wed, Feb 29, 2012 at 2:40 PM, Douglas Gilbert<dgilbert@interlog.com>  wrote:
>> On 12-02-29 04:55 PM, James Bottomley wrote:
>>>
>>> On Fri, 2012-02-10 at 00:45 -0800, Dan Williams wrote:
>>>>
>>>> It is possible for a host to get "locked out" from talking to sata
>>>> devices in the domain if, for example, its sas address changes but the
>>>> expander topology has existing affiliations with the old address.  If
>>>> the system is booted userspace can write to
>>>> /sys/class/sas_phy/<phy-X>/hard_reset to clear the affiliation, however
>>>> if this condition exists for the root device the module parameter can be
>>>> used to promote all ata resets to hard resets.
>>
>>
>> A point of order: SAS has link resets and hard resets. The
>> hard reset is a superset of link reset. A "link reset sequence
>> serves as a hard reset for SATA devices" and hence is
>> sufficient to reset a SATA device. To reset a SAS device
>> (e.g. a SAS disk) you need a SAS hard reset. Therefore a link
>> reset is the appropriately sized "gun" to reset a SATA device.
>>
>> I have a SAS-2 expander that annoyingly powers up with the
>> programmed maximum physical link rate of its phys at 3 Gbps
>> even though its hardware maximum rate is 6 Gbps. For expander
>> phys connected to SAS-2 disks I can up the programmed maximum
>> value to 6 Gbps on the expander phy then do a link reset on
>> that phy. So without upsetting Linux (or any other OS) I can
>> switch that path from 3 Gbps to 6 Gbps. Can't do that with a
>> SATA disk without the OS finding out.
>
> At least now (with these pending patches) if you trigger a link-reset
> via the sysfs interface libsas will manage the link recovery like any
> other error-recovery initiated reset.

I can think of 4 cases for link reset. The other end
of the link is:
   a) a SAS target: not error recovery situation
   b) a SAS expander phy: not error recovery situation
   c) a SATA device: error recovery situation
   d) a SAS initiator: not sure, probably not

Doug Gilbert
