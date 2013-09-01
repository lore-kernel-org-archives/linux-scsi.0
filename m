From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] scsi disk: Use its own buffer for the vpd request
Date: Sun, 01 Sep 2013 20:40:51 +0200
Message-ID: <52238A33.7020703@fastmail.fm>
References: <87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm> <87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net> <51F80167.1080004@fastmail.fm> <yq1zjt3h11y.fsf@sermon.lab.mkp.net> <51F94E8D.5040908@fastmail.fm> <51F95A2E.60805@fastmail.fm> <51FA71E2.6010501@fastmail.fm> <871u5b7azv.fsf@spindle.srvr.nix> <20130831015337.GA8164@kroah.com> <87d2ot1w27.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87d2ot1w27.fsf@spindle.srvr.nix>
Sender: linux-kernel-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Greg KH <greg@kroah.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw, stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 08/31/2013 09:48 PM, Nix wrote:
> On 31 Aug 2013, Greg KH said:
>> On Fri, Aug 30, 2013 at 11:01:56AM +0100, Nix wrote:
>>> On 1 Aug 2013, Bernd Schubert said:
>>>
>>>> Once I noticed that scsi_get_vpd_page() works fine from other function
>>>> calls and that it is not 0x89, but already 0x0 that fails fixing it became
>>>> easy.
>>>>
>>>> Nix, any chance you could verify it also works for you?
>>>
>>> As an aside, this commit does indeed fix the bug I reported, but it
>>> doesn't seem to have gone anywhere, not even into -stable.
>>>
>>> Is it held up somehow?
>>>
>>> (stable has
>>>
>>> commit 0ac10bd036f0f3b8ce7ac2390446eab9531c72eb
>>> Author: Martin K. Petersen <martin.petersen@oracle.com>
>>> Date:   Tue Jul 30 22:58:34 2013 -0400
>>>
>>>     SCSI: Don't attempt to send extended INQUIRY command if skip_vpd_pages is set
>>>
>>> which IIRC was eventually found not to be necessary, because this fix
>>> works fine instead?)
>>>
>>> Possibly I'm misremembering the order of month-old events and Martin's
>>> fix was eventually considered better... in which case, sorry for the noise.
>>
>> Is that other patch even needed anymore, now that Martin's patch is in
>> the tree?
> 
> My understanding is that this patch is rather better, since Martin's
> patch prevents sending of the extended INQUIRY command at all: this one
> just uses a reduced buffer size, but can still issue the command. (But I
> may be misunderstanding everything.)

Hmm, I wonder if 7562523e84ddc742fe1f9db8bd76b01acca89f6b (linus tree) /
0ac10bd036f0f3b8ce7ac2390446eab9531c72eb (stable-tree) always works . It
tests if sdev->skip_vpd_pages is set, but
as far as I can see this only gets set for Seagate drives via
BLIST_SKIP_VPD_PAGES.
So if anything else than a Seagate drive is connected to an Areca
controller with older firmware it will still fail.


Cheers,
Bernd
