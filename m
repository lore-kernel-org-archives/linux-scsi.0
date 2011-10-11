From: NamJae Jeon <linkinjeon@gmail.com>
Subject: Re: [Patch] SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal
 routine fails
Date: Tue, 11 Oct 2011 20:59:21 +0900
Message-ID: <CAKYAXd9sg_ujDZ09FESXFEn+DgKAr4zUan0dMi4jOu3pg-Scdw@mail.gmail.com>
References: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com>
	<4E941D5E.6060101@suse.de>
	<CADDb1s1kDgfRX-5g3xcLrSfRbD=sQ6MecuK40w75bY8brrVBaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDb1s1kDgfRX-5g3xcLrSfRbD=sQ6MecuK40w75bY8brrVBaw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

2011/10/11 Amit Sahrawat <amit.sahrawat83@gmail.com>:
> On Tue, Oct 11, 2011 at 4:11 PM, Hannes Reinecke <hare@suse.de> wrote=
:
>> On 10/11/2011 10:26 AM, Amit Sahrawat wrote:
>>>
>>> SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine fails
>>>
>>> It has been observed that a number of USB HDD's do not respond corr=
ectly
>>> to SCSI mode sense command(retrieve caching pages) which results in=
 their
>>> Write Cache being discarded by queue requests i.e., WCE if left set=
 to
>>> '0'(disabled). So, in order to identify the devices correctly - giv=
e it
>>> a last try using SG_ATA_16 after failure from normal routine.
>>>
>> I'd be _VERY_ cautious when trying something like this.
>>
>> ATA_16 is a rather recent command, and most older drives simply can'=
t cope
>> with this. Instead they just kick the error handler and go offline
>> eventually.
> I tried with a number of USB HDD(around 6 with different
> manufacturer's, 1 USB SSD and pen drives) - they are responding
> correctly with this.
>>
>> Shouldn't we rather use a sensible default, ie assume WCE is enabled=
?
> If WCE is enabled by default - that will mark QUEUE ORDERING to
> QUEUE_ORDERED_DRAIN_FLUSH(Preflush-Postflush)(ie., flushing will occu=
r
> for all the Mass Storage devices - which in turn will keep on calling
> SYNC_CACHE for these devices(which do not have write cache)) - ie., a=
n
> extra overhead for the devices which do not have this routine(Pen
> drives being widely used among these)
> Is there any identification(unique information) for "older drives" ?
> Please share your opinion more.
I think that it is good approach. Have you tested journaling test on XF=
S ?
=46or example, while tiny several files is written, Is there corruption
fail when suddenly unplugging usb HDD ?
And you should check write performance.
If you change a little, It will be better~ let me check more.
>
>>
>> Cheers,
>>
>> Hannes
>> --
>> Dr. Hannes Reinecke =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 zSeries & Storage
>> hare@suse.de =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+49 911 74053 688
>> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
>> GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnb=
erg)
>>
> Regards,
> Amit Sahrawat
>
