From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Thu, 20 Apr 2006 11:07:11 +0900
Message-ID: <4446ECCF.7080000@gmail.com>
References: <20060419184916.22608.qmail@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0102.google.com ([64.233.162.205]:49719 "EHLO
	nz-out-0102.google.com") by vger.kernel.org with ESMTP
	id S1750722AbWDTCHa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 22:07:30 -0400
Received: by nz-out-0102.google.com with SMTP id o37so45505nzf
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2006 19:07:29 -0700 (PDT)
In-Reply-To: <20060419184916.22608.qmail@web31809.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Patrick Mansfield <patmans@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> Hi Tejun,
> 
> --- Tejun Heo <htejun@gmail.com> wrote:
>> So, what's your suggestion here?  Do you think libata should do such 
>> things with its own mechanism?
> 
> Your instinct is correct.  Anything between I and T, as in I_T, is SDS
> domain.  That is, SAM doesn't have a _context_ for anything between the I and T.
> (In SATA's case I_T_L, of course.)
> 
> So this is why you shouldn't call SCSI's ER without context, as in "Hey,
> neither command, nor device is broken, but do some ER for me."  Such work belongs
> in your SATA Layer, unless either a device or command is involved, as we discussed.
> 
> Handle protocol ER in your SATA layer.  Note however that most of your ER could
> be done on behalf of a command or device, since of course, a device or command(s)
> end up being affected.  Basically "do as little as possible but no less" technique.
> 

Hello, Luben.

I see your point regarding SAM.  If this is the consensus among SCSI 
developers, I guess eh_schedule_host() shouldn't be added.

Hmmm.. libata isn't SCSI.  It's just hitch-hiking on the back of SCSI at 
the moment.  And, being able to invoke EH on the host directly makes 
things a lot simpler for libata.  So, what do you think about just 
adding shost->host_eh_scheduled, adding a condition to 
scsi_error_handler() and export scsi_eh_wakeup()?  The changes will be 
like three lines.  And, also, ->host_eh_scheduled can be marked as hack 
for libata.  libata can handle the rest.

This may not be the most graceful thing to do but...

1. SCSI change is minimal

2. it's a temporary measure (moving libata out of SCSI is one of the 
items on my agenda and if no one else does it I'm gonna give a shot at 
it in not-so-distant future.  Once libata is gone of SCSI, the three 
lines can be removed.)

3. It will take a lot more work to achieve the same thing in libata 
proper without the three line change.

Luben, what do you think?

James and Jeff, any opinion on this matter?

Thanks.

-- 
tejun
