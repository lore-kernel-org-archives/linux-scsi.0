From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: No I/O errors reported after SATA link hard reset
Date: Thu, 17 Aug 2017 16:15:35 +0200
Message-ID: <4debd4d8dea1d534ef555ceae4429435@assyoma.it>
References: <fe5cc200a4cba71cb9e5e6a980699805@assyoma.it>
 <13561110-4e59-303a-8e3d-dd60c1bafba8@fastmail.fm>
 <20170817124821.GA3238792@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:37910 "EHLO
        mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752403AbdHQOPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2017 10:15:43 -0400
In-Reply-To: <20170817124821.GA3238792@devbig577.frc2.facebook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

Hi Tejun,

Il 17-08-2017 14:48 Tejun Heo ha scritto:
> Recovered errors aren't reported as IO errors and at least from link
> state proper there's no way for the driver to tell apart link
> glitches and buffer-erasing power issues.

Ok, so *this* is the root cause of the problem: libata not identifying 
spurious link renegotiations vs brief powerloss/powerup events. Out of 
curiosity: is this a SATA-specific problem (ie: in the SATA 
specification), or even SAS disks are affected?

>> > - why the scsi midlevel does not respond to a power loss event by
>> > immediately offlining the disks?
> 
> Because we don't wanna be ditching disks on temporary link glitches,
> which do happen once in a while.

Any chances to report I/O errors to the upper layers *without* offlining 
the device? In this manner, upper layers (ie: MDRAID) can act in a more 
informate way. For example: single disk device will simple retry the 
failed operation, while MDRAID can take the "badblocks" code path to 
deal with the error.

> So, the right way to deal with the problem probably is making use of
> the SMART counter which indicates power loss events and verify that
> the counter hasn't increased over link issues.  If it changed, the
> device should be detached and re-probed, which will make it come back
> as a different block device.  Unfortunately, I haven't had the chance
> to actually implement that.

This is a very good idea, maybe I can implement it in userspace with a 
simple, fast polling scheme (for example, each 60 seconds). Such a 
polling would not prevent all corruption scenarios, but will at least 
timely inform the user.

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
