From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 3/3] scsi: async sd resume
Date: Mon, 10 Mar 2014 14:06:10 -0700
Message-ID: <CAPcyv4gpxxPMHJo7+iH-e+S1KVaJJH62bEBdq8_NQbeU7jTS4A@mail.gmail.com>
References: <CAPcyv4ik5GhaqZsBCA+LJ5WN=bCBPqjHgWwud1PrrKB4LarBOA@mail.gmail.com>
	<Pine.LNX.4.44L0.1403101658490.5966-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1403101658490.5966-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>, Len Brown <len.brown@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Phillip Susi <psusi@ubuntu.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, Todd Brandt <todd.e.brandt@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 10, 2014 at 1:59 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 10 Mar 2014, Dan Williams wrote:
>
>> > The only thing which is a bit concerning is that this doesn't have any
>> > throttling mechanism for simultaneous wakeups.  Would this be able to
>> > blow up the PSU if used on a machine with a lot of spindles?
>>
>> Good point.  The primary benefit is completing userspace resume
>> without needlessly waiting for the disk.  For now I think it would be
>> enough to have a mutex to maintain one disk at a time.  We can follow
>> on later with something more complex to enable a max simultaneous
>> spin-up tunable.
>
> Why?  The existing code doesn't have anything like that.
>

Why follow up later, or why maintain one disk at a time?

I know at least the SCSI driver I maintained had this as a
per-low-level driver tunable.  Seems to be a good candidate for
attempting a unified platform-level tunable.  Mind you I would not be
looking to implement it anytime soon.
