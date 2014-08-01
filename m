From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH V2 2/4] Introduce xen-scsifront module
Date: Fri, 01 Aug 2014 15:06:04 +0200
Message-ID: <53DB90BC.8000302@suse.com>
References: <1406288253-13293-1-git-send-email-jgross@suse.com>	<1406288253-13293-3-git-send-email-jgross@suse.com>	<20140729135300.GA20415@infradead.org> <53D7B65C.8030701@suse.com>	<53D87A67.8050005@suse.com> <20140801120847.GB17864@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140801120847.GB17864@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, xen-devel@lists.xen.org
List-Id: linux-scsi@vger.kernel.org

On 08/01/2014 02:08 PM, Christoph Hellwig wrote:
> On Wed, Jul 30, 2014 at 06:53:59AM +0200, Juergen Gross wrote:
>> Hmm, I looked into scsi_add_device(). It seems as if the caller can't
>> distinguish between a new created and an already existing device. Am I
>> missing something?
>
> That's right.  If you need that I still think it's better to add a
> variant of scsi_add_device helping you with that.

I'm open to that solution.

Do you have preferences how to do it (IOW: can you give me a hint)?

>> The race is not existing: scsi_add_device() (and scsi_remove_device()
>> as well) for this scsi_host is called in scsifront_do_lun_hotplug()
>> only, and this function is always called in the same thread (xenbus
>> watch). A comment seems to be a good idea.
>
> Do you disable scanning through procfs and sysfs as well?

No, I don't.

OTOH I don't think I see the problem. What could go wrong? Either
scsi_device_lookup() does find an existing device, then I refuse to add
it again. If I don't find it, it will be added. I can't see how any harm
would be done in either case when the device is added/removed between
the check and the action. What am I missing?

Juergen
