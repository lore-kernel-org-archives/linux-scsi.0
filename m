From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Re: [RFC] Separating out libata out of SCSI (finally)
Date: Tue, 24 Jun 2008 10:58:36 -0400
Message-ID: <87f94c370806240758i2013804cob120daffc94c5ae2@mail.gmail.com>
References: <485B2CC6.6070201@kernel.org>
	 <1213993737.3443.35.camel@localhost.localdomain>
	 <485C31FE.8050408@garzik.org>
	 <87f94c370806231404t13586777x7f7bee24ebe25ffc@mail.gmail.com>
	 <1214255460.3310.27.camel@localhost.localdomain>
	 <4860B099.2030305@panasas.com>
	 <1214318550.3299.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1214318550.3299.7.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, brking@linux.vnet.ibm.com, Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 24, 2008 at 10:42 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2008-06-24 at 11:30 +0300, Boaz Harrosh wrote:
>> James Bottomley wrote:
>> > On Mon, 2008-06-23 at 17:04 -0400, Greg Freemyer wrote:
>> >> I've seen a lot of end user complaints about libata only supporting
>> >> 15(14?) partitions.  Will that limit be moved back to the traditional
>> >> drivers/ide limit as part of this?
>> >
>> > Number of partitions is directly related to number of minors, so it
>> > can't be changed without a change in the allocation of major/minor space
>> > in sd ... that could only be done compatibly by permuting the space.
>> > The only other way to do it is incompatibly by changing major (again).
>> >
>> Could we do both? I mean use the legacy, up to 15, with the old major,
>> then use the new major for bigger then 15. Since user mode that knows
>> about more then 15 partitions is new, it'll know it needs to jump a major.
>
> Not simultaneously, which is the problem; you can't have two separate
> block devices for the same physical device unless you want aliasing
> issues in the page cache.
>
> It might be possible to add an extra device to give access to the
> missing partitions, but that would require a bit of re-engineering in
> gendisk (which is the in-kernel code to manage the partitions).
>
> What might be far more feasible is to set up udev to use kpartx to
> provide the missing partitions if it detects a partition table that has
> them ... of course, that requires a udev setup and most of the
> complaints about the lost partitions seem to come from non-udev systems.
>
> But .... if everyone (particularly the people with these problems) had
> udev, we could simply migrate to a new major with more partitions, get
> udev to fix it all up for us and everyone would be happy because no-one
> would even notice that we'd moved majors ...
>
> James

>From my limited perspective, every complaint I've seen was related to
OpenSUSE which I believe is a udev based distro, so addressing this
for the udev based distros would address that contingent of users.

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
