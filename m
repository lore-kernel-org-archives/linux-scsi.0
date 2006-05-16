From: Tejun Heo <htejun@gmail.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 01:39:47 +0900
Message-ID: <446A0053.5070203@gmail.com>
References: <4468B596.9090508@garzik.org>	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>	 <4469F2B2.703@garzik.org>	 <1147794708.3505.30.camel@mulgrave.il.steeleye.com>	 <4469F906.7040602@gmail.com> <1147796999.3505.42.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1147796999.3505.42.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2006-05-17 at 01:08 +0900, Tejun Heo wrote:
>> It's handled the same way shost->host_failed is handled.
>> scsi_device_unbusy() wakes it up when the condition is met.
> 
> That's the piece I hadn't spotted, yet ... thanks.  That will do it.
> 
> could you move ata_schedule_scsi_eh to scsi_error (with the appropriate
> API rename).  That way the SCSI state model changes aren't in libata
> (and no-one else who wants to use this has to open code the
> ata_schedule_scsi_eh API).
> 

I certainly can, and it was done that way first time around.  Please
note the following discussion.

http://thread.gmane.org/gmane.linux.scsi/23853/focus=9760

Luben objected the interface made public because SCSI host is not
supposed to know about exception conditions which are not associated
with ITL nor ITLQ nexus.  Thus, I made it a temporary measure only for
libata, which is planned to move out.

So, SCSI contains only the necessary bits required to implement the
feature and libata open-codes the rest.  As it's not an exported
interface, no other SCSI driver is supposed to use it and the SCSI
modifications can be easily removed after libata moves out.

As long as libata can do EH not associated with scmd or device, I'm okay
either way and think it's your call.  So, considering the above
discussion, do you want it to be a generic SCSI interface?

Thanks.

-- 
tejun
