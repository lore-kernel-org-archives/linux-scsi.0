From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 3/3] scsi: async sd resume
Date: Mon, 10 Mar 2014 21:47:04 -0700
Message-ID: <CAPcyv4gJssEE7hADEDXmi4ao031uSVjMenKk9AFcbTukm1MKNg@mail.gmail.com>
References: <Pine.LNX.4.44L0.1403101658490.5966-100000@netrider.rowland.org>
	<1394511589.2142.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1394511589.2142.5.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Len Brown <len.brown@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Phillip Susi <psusi@ubuntu.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, Todd Brandt <todd.e.brandt@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 10, 2014 at 9:19 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2014-03-10 at 16:59 -0400, Alan Stern wrote:
>> On Mon, 10 Mar 2014, Dan Williams wrote:
>>
>> > > The only thing which is a bit concerning is that this doesn't have any
>> > > throttling mechanism for simultaneous wakeups.  Would this be able to
>> > > blow up the PSU if used on a machine with a lot of spindles?
>> >
>> > Good point.  The primary benefit is completing userspace resume
>> > without needlessly waiting for the disk.  For now I think it would be
>> > enough to have a mutex to maintain one disk at a time.  We can follow
>> > on later with something more complex to enable a max simultaneous
>> > spin-up tunable.
>>
>> Why?  The existing code doesn't have anything like that.
>
> This only becomes a problem if enterprise class systems want to suspend
> and resume.  Last I heard, this wasn't on the cards.
>
> We also don't usually need to bother with in-kernel staggered spin ups
> because if the device can blow the PSU by doing simultaneous spinups,
> staggering is usually hard jumpered in the system.  The main reason for
> this is that there's no way for us to work out the PSU topology to do
> the stagger in kernel, so the enterprise likes to be sure.
>

In that case shouldn't we limit it to a disk at a time?  Enterprise
doesn't care and home brew folks that both put a lot of disks in a
system and suspend/resume them are less likely to burn themselves.
