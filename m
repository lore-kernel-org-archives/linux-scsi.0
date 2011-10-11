From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [Patch] SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal
 routine fails
Date: Tue, 11 Oct 2011 16:25:24 +0530
Message-ID: <CADDb1s1kDgfRX-5g3xcLrSfRbD=sQ6MecuK40w75bY8brrVBaw@mail.gmail.com>
References: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com>
	<4E941D5E.6060101@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E941D5E.6060101@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NamJae Jeon <linkinjeon@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 11, 2011 at 4:11 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 10/11/2011 10:26 AM, Amit Sahrawat wrote:
>>
>> SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine fails
>>
>> It has been observed that a number of USB HDD's do not respond corre=
ctly
>> to SCSI mode sense command(retrieve caching pages) which results in =
their
>> Write Cache being discarded by queue requests i.e., WCE if left set =
to
>> '0'(disabled). So, in order to identify the devices correctly - give=
 it
>> a last try using SG_ATA_16 after failure from normal routine.
>>
> I'd be _VERY_ cautious when trying something like this.
>
> ATA_16 is a rather recent command, and most older drives simply can't=
 cope
> with this. Instead they just kick the error handler and go offline
> eventually.
I tried with a number of USB HDD(around 6 with different
manufacturer's, 1 USB SSD and pen drives) - they are responding
correctly with this.
>
> Shouldn't we rather use a sensible default, ie assume WCE is enabled?
If WCE is enabled by default - that will mark QUEUE ORDERING to
QUEUE_ORDERED_DRAIN_FLUSH(Preflush-Postflush)(ie., flushing will occur
for all the Mass Storage devices - which in turn will keep on calling
SYNC_CACHE for these devices(which do not have write cache)) - ie., an
extra overhead for the devices which do not have this routine(Pen
drives being widely used among these)
Is there any identification(unique information) for "older drives" ?
Please share your opinion more.

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zSeries & Sto=
rage
> hare@suse.de =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+49 9=
11 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
>
Regards,
Amit Sahrawat
