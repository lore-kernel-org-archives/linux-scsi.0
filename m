From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH/RESEND v2 1/2] Hard disk S3 resume time optimization
Date: Mon, 13 Jan 2014 16:05:21 -0800
Message-ID: <CAPcyv4j3TFNd7ues+YbaFfEhTU_W-t30Vi9SEhgW5G-+FDrnow@mail.gmail.com>
References: <20140108005607.GB29556@linux.intel.com>
	<52CED67E.7080706@ubuntu.com>
	<11E08D716F0541429B7042699DD5C1A17073C362@FMSMSX103.amr.corp.intel.com>
	<52D0A8B4.90905@ubuntu.com>
	<CAA9_cmdkNNfE8-b60x4ULw6OA+zxrVZoJhEX3a5XZOQKnsqfHg@mail.gmail.com>
	<20140113200648.GB13900@linux.intel.com>
	<CAA9_cmfPREP=hN_2bjVCdWhbAYSRxM_g4iuUE2sBaQ3nuSY4Qg@mail.gmail.com>
	<20140113235120.GA4127@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140113235120.GA4127@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Phillip Susi <psusi@ubuntu.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 13, 2014 at 3:51 PM, Todd E Brandt
<todd.e.brandt@linux.intel.com> wrote:
> On Mon, Jan 13, 2014 at 12:37:01PM -0800, Dan Williams wrote:
>> On Mon, Jan 13, 2014 at 12:06 PM, Todd E Brandt
>> > Actually there's one other reason. In the ata_port_request_pm function it
>> > checks to see if there's a previous resume operation pending, and if so
>> > it calls ata_port_wait_eh in order to wait for it to complete before
>> > issuing the new suspend. If you just use the (int*)async parameter it
>> > will return immediately and defer to the caller to try again, like is does
>> > with SAS. But in our case we *don't* try again, so it would result in the
>> > resume being skipped. There needs to be a new case where the caller wants
>> > the call to be asynchronous, and it wants ata_port_request_pm to do its
>> > own waiting, but doesn't care about the return value. Thus the additional
>> > parameter.
>>
>> I think that is specifically for the libata case of a suspend request
>> arriving while an async resume is still in flight.  Given libata
>
> Accoring to the comments it's for a previous resume, not a previous suspend.
>
>         /* Previous resume operation might still be in
>          * progress.  Wait for PM_PENDING to clear.
>          */
>         if (ap->pflags & ATA_PFLAG_PM_PENDING) {
>                 if (async) {
>                         *async = -EAGAIN;
>                         return 0;
>                 }
>                 ata_port_wait_eh(ap);
>                 WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
>         }

Right, but that should only happen when ata_port_request_pm() is
called for 'suspend' and 'resume' is in flight.  I think it's a core
device-power-management bug if ->resume() is called twice without an
intervening ->suspend().

> I'm going to assume that it was added for a reason, so I've structured my
> patch in such a way that it doesn't alter the existing logic. Removing that
> particular check would be a completely different discussion and is out of
> the scope of this patch.

You're right that logic should stay, I don't think removing it was
ever proposed?
