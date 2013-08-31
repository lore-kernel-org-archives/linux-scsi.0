From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH] scsi disk: Use its own buffer for the vpd request
Date: Sat, 31 Aug 2013 20:48:00 +0100
Message-ID: <87d2ot1w27.fsf@spindle.srvr.nix>
References: <87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net>
	<51F80167.1080004@fastmail.fm> <yq1zjt3h11y.fsf@sermon.lab.mkp.net>
	<51F94E8D.5040908@fastmail.fm> <51F95A2E.60805@fastmail.fm>
	<51FA71E2.6010501@fastmail.fm> <871u5b7azv.fsf@spindle.srvr.nix>
	<20130831015337.GA8164@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130831015337.GA8164@kroah.com> (Greg KH's message of "Fri, 30
	Aug 2013 18:53:37 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw, stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 31 Aug 2013, Greg KH said:
> On Fri, Aug 30, 2013 at 11:01:56AM +0100, Nix wrote:
>> On 1 Aug 2013, Bernd Schubert said:
>> 
>> > Once I noticed that scsi_get_vpd_page() works fine from other function
>> > calls and that it is not 0x89, but already 0x0 that fails fixing it became
>> > easy.
>> >
>> > Nix, any chance you could verify it also works for you?
>> 
>> As an aside, this commit does indeed fix the bug I reported, but it
>> doesn't seem to have gone anywhere, not even into -stable.
>> 
>> Is it held up somehow?
>> 
>> (stable has
>> 
>> commit 0ac10bd036f0f3b8ce7ac2390446eab9531c72eb
>> Author: Martin K. Petersen <martin.petersen@oracle.com>
>> Date:   Tue Jul 30 22:58:34 2013 -0400
>> 
>>     SCSI: Don't attempt to send extended INQUIRY command if skip_vpd_pages is set
>> 
>> which IIRC was eventually found not to be necessary, because this fix
>> works fine instead?)
>> 
>> Possibly I'm misremembering the order of month-old events and Martin's
>> fix was eventually considered better... in which case, sorry for the noise.
>
> Is that other patch even needed anymore, now that Martin's patch is in
> the tree?

My understanding is that this patch is rather better, since Martin's
patch prevents sending of the extended INQUIRY command at all: this one
just uses a reduced buffer size, but can still issue the command. (But I
may be misunderstanding everything.)

-- 
NULL && (void)
