From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v8 08/13] libsas: libsas.force_hard_reset module parameter
Date: Wed, 29 Feb 2012 17:40:54 -0500
Message-ID: <4F4EA976.4010607@interlog.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>  <20120210084520.25701.83280.stgit@dwillia2-linux.jf.intel.com> <1330552551.8846.24.camel@dabdike>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1330552551.8846.24.camel@dabdike>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jack Wang <jack_wang@usish.com>, Luben Tuikov <ltuikov@yahoo.com>, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

On 12-02-29 04:55 PM, James Bottomley wrote:
> On Fri, 2012-02-10 at 00:45 -0800, Dan Williams wrote:
>> It is possible for a host to get "locked out" from talking to sata
>> devices in the domain if, for example, its sas address changes but the
>> expander topology has existing affiliations with the old address.  If
>> the system is booted userspace can write to
>> /sys/class/sas_phy/<phy-X>/hard_reset to clear the affiliation, however
>> if this condition exists for the root device the module parameter can be
>> used to promote all ata resets to hard resets.

A point of order: SAS has link resets and hard resets. The
hard reset is a superset of link reset. A "link reset sequence
serves as a hard reset for SATA devices" and hence is
sufficient to reset a SATA device. To reset a SAS device
(e.g. a SAS disk) you need a SAS hard reset. Therefore a link
reset is the appropriately sized "gun" to reset a SATA device.

I have a SAS-2 expander that annoyingly powers up with the
programmed maximum physical link rate of its phys at 3 Gbps
even though its hardware maximum rate is 6 Gbps. For expander
phys connected to SAS-2 disks I can up the programmed maximum
value to 6 Gbps on the expander phy then do a link reset on
that phy. So without upsetting Linux (or any other OS) I can
switch that path from 3 Gbps to 6 Gbps. Can't do that with a
SATA disk without the OS finding out.

Also to clear a SATA affiliation you should be using a SMP
PHY CONTROL (phy_op=6) function.

Doug Gilbert
