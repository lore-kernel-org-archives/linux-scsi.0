From: Tejun Heo <htejun@gmail.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 02:07:19 +0900
Message-ID: <446A06C7.5050609@gmail.com>
References: <4468B596.9090508@garzik.org>	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>	 <4469F2B2.703@garzik.org>	 <1147794708.3505.30.camel@mulgrave.il.steeleye.com>	 <4469F906.7040602@gmail.com>	 <1147796999.3505.42.camel@mulgrave.il.steeleye.com>	 <446A0053.5070203@gmail.com> <1147798226.3505.56.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1147798226.3505.56.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2006-05-17 at 01:39 +0900, Tejun Heo wrote:
>> I certainly can, and it was done that way first time around.  Please
>> note the following discussion.
>>
>> http://thread.gmane.org/gmane.linux.scsi/23853/focus=9760
>>
>> Luben objected the interface made public because SCSI host is not
>> supposed to know about exception conditions which are not associated
>> with ITL nor ITLQ nexus.  Thus, I made it a temporary measure only for
>> libata, which is planned to move out.
> 
> His objection is still valid.  However, as the balance of evils, I
> think, if you have to do this, it's better to contain it in a way where
> it's obvious what's being done.  Plus you don't want someone to modify
> the host state model and suddenly find libata doesn't work anymore
> because they failed to spot that it needed to change as well ...

I see.

>> So, SCSI contains only the necessary bits required to implement the
>> feature and libata open-codes the rest.  As it's not an exported
>> interface, no other SCSI driver is supposed to use it and the SCSI
>> modifications can be easily removed after libata moves out.
>>
>> As long as libata can do EH not associated with scmd or device, I'm okay
>> either way and think it's your call.  So, considering the above
>> discussion, do you want it to be a generic SCSI interface?
> 
> Yes, but in scsi_priv.h, please ... I can actually think of another use
> for it in terms of getting the SG reset handler to work properly.

Okay, will do in scsi_priv.h

Jeff, it seems that we need to reset #upstream and rebuild it.  Do you
have any other idea than resetting libata-tj#for-jeff and
libata-dev#upstream?

-- 
tejun
