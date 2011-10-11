From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [Patch] SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal
 routine fails
Date: Tue, 11 Oct 2011 21:30:30 +0530
Message-ID: <CADDb1s1T8_BQA-mV3TGw7UjeuE-qdO_9V35xTNYE2DQcKrp_9A@mail.gmail.com>
References: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com>
	<1318341926.2992.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1318341926.2992.5.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NamJae Jeon <linkinjeon@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 11, 2011 at 7:35 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2011-10-11 at 13:56 +0530, Amit Sahrawat wrote:
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
>
> This is a non-starter, as I've said before. =A0Apart from the layerin=
g
> violation of trying to make sd ATA aware, ATA_16 is known to crash so=
me
> USB devices (the bug reports are mostly about smartctl which can be m=
ade
> to use ATA_16 failing).
I agree that there might devices which crash on this response.
>
> The correct way to implement this is to have a user visible WCE varia=
ble
> that can be written to in the scsi_disk class sysfs files so the user
> can alter the caching type on the fly.
This is OK to add WCE variable, but again this "on the fly" is
confusing. I expect this to be initialized the moment I plug-in the
USB. If the user has to take this decision - then again there has to
be a supporting fact so as to change the "cache type" from sysfs.
Again, the point would be how to get this if the device do not respond
correctly. sd_store_cache_type() - is this main code point which needs
to be thoroughly checked for this? especially the scsi_mode_select()?
Please correct me if I am wrong.
>
> James
>
>
Thanks & Regards,
Amit Sahrawat
