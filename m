From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 1/6] mpt fusion: fix for previous patch taskmgmt in
	progress should be cleared before return
Date: Sat, 04 Apr 2009 08:17:19 -0500
Message-ID: <1238851039.4083.1.camel@mulgrave.int.hansenpartnership.com>
References: <20090403114943.GB17721@lsi.com>
	 ,<1238780308.3359.58.camel@mulgrave.int.hansenpartnership.com>
	 <0D1E8821739E724A86F4D16902CE275C1410E52A59@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38011 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbZDDNRY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Apr 2009 09:17:24 -0400
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1410E52A59@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Sat, 2009-04-04 at 15:15 +0530, Desai, Kashyap wrote:
> James,
> 
> After creating patch, I usually run check_patch script available in scripts directory of linux source tree.
> Below changes are just to remove warning and error related to coding standards  from generated patch. 

Hmm, then we have an error in checkpatch.pl if it's saying that

x = y
if (x == NULL)

should become

if ((x = y) == NULL)

Can you attach the warning so I can get the checkpatch maintainers to
explain what's going on?

Thanks,

James


> If you suggest, not to have those changes merge with actual logical
> patch then please let me know. I can rework and resubmit.
> 
> 
> Thanks
> Kashyap
> ________________________________________
> From: James Bottomley [James.Bottomley@HansenPartnership.com]
> Sent: Friday, April 03, 2009 1:38 PM
> To: Desai, Kashyap
> Cc: linux-scsi@vger.kernel.org; Moore, Eric; Prakash, Sathya
> Subject: Re: [PATCH 1/6] mpt fusion: fix for previous patch taskmgmt in progress should be cleared before return
> 
> On Fri, 2009-04-03 at 17:19 +0530, Kashyap, Desai wrote:
> > -
> > -       mf = mpt_get_msg_frame(mptsasDeviceResetCtx, ioc);
> > -       if (mf == NULL) {
> > +       if ((mf = mpt_get_msg_frame(mptsasDeviceResetCtx, ioc)) == NULL) {
> >                 dfailprintk(ioc, printk(MYIOC_s_WARN_FMT
> 
> This is making a clear statement (assignment then check) less clear for
> no practical purpose that I can see.
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

