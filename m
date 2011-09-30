From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: BUG in kernel: Wrong Handling of USB =?UTF-8?Q?HDD=E2=80=99s?=
 in scsiglue(slave_configure) and scsi/sd(sd_read_cache_type)
Date: Fri, 30 Sep 2011 07:18:37 -0500
Message-ID: <1317385117.2993.7.camel@dabdike.hansenpartnership.com>
References: <CADDb1s2Qhy1dNmjk+DhU=rf46A4X6kPdQ2rdpwK9zinY4Yv1mw@mail.gmail.com>
	 <CADDb1s3KjMugBGwLmjoPv93hJVBCjkD81o8F0CZxJXXt+-Fk2A@mail.gmail.com>
	 <1317245383.22022.23.camel@dabdike.hansenpartnership.com>
	 <CADDb1s0naC9bKYDuvxMK1R+ey9KB+Sh8e-9KNJXH-EuTNueueQ@mail.gmail.com>
	 <1317320825.3190.70.camel@dabdike.hansenpartnership.com>
	 <1317321077.3190.71.camel@dabdike.hansenpartnership.com>
	 <CADDb1s3CSvmqNGA48sHyOJ-pGpB1ix3WEVd0KV4b+s5yE3abLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDb1s3CSvmqNGA48sHyOJ-pGpB1ix3WEVd0KV4b+s5yE3abLw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-09-30 at 12:26 +0530, Amit Sahrawat wrote:
> Now, for the USB HDD which do have write cache - sginfo is showing
> them to Write Cache Enabled as false.
> Why do the result of hdparm identification and sginfo varies- (I know
> they have different interface to work with and hdparm takes care of
> that by using SG_IO interface from it's code)? hdparm showed me
> correct results - that lead me to digging in the kernel code and
> checking the performance for USB HDD with Write cache enabled/disabled
> - which also showed that QUEUE ordering chosen for USB HDD is not
> correct.

Well, what all this means is the SATL in the USB device is implemented
wrongly.  Since USB devices only preset SCSI interfaces, that's what we
have to believe.

hdparm when used correctly sends an ATA inquiry command wrapped in an
ATA_12 or ATA_16 SCSI command.  A large number of legacy SATLs are known
to crash on these commands.

Are you sure the ATA command is reporting correctly?  A write back cache
is a remarkably silly thing to enable for a USB device because they're
highly likely to be surprise ejected which powers the device down.

> I have a large number of USB HDD's - with different vendors, and for
> all of them - it is showing Write Cache Enabled as false.
> The code works only for the Pen Drives or the USB HDD which do not
> have internal cache.
> 
> Also, for journalling filesystem being used on USB HDD - it does
> becomes a cause of concern.
> 
> Please share your opinion, I guess we need a change for mode sensing
> in the kernel code for USB HDD.

Well that's a nastily complex problem.  It really needs to be
whitelisted in the USB stack, but if every drive is doing it, that's
quite a task.

The question becomes how do we detect in a SCSI fashion that the device
has a write back cache if none of the standard SCSI mechanisms reports
it?

James
