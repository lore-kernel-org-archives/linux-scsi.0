Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9430C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 15:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9498207E8
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 15:44:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="L/xA8fPm";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="HWYHAw9U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgG2Por (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 11:44:47 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34838 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726502AbgG2Poq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 11:44:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 445AA8EE207;
        Wed, 29 Jul 2020 08:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1596037485;
        bh=3mOIs2ifi3nTeb9BjuImOqvUaL8Iv8D1+iiZHrYapUU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=L/xA8fPmwryXUcwkoKaOIQykeQbgLmTup47RtrHu81/zNaG3Gzl3YCEKFJKIWgMPU
         plCnLaFu9XP/zUHUXkDMaiP0II3pfZwrFrNwNXzIaaY5ZzCw/ukXTmdzifYIknFJAU
         dfjlMLRzlnLURsr4OgwvkEjo3cvteL/jM5M8JGgQ=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cEySqEXtdr8Z; Wed, 29 Jul 2020 08:44:45 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4208A8EE100;
        Wed, 29 Jul 2020 08:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1596037484;
        bh=3mOIs2ifi3nTeb9BjuImOqvUaL8Iv8D1+iiZHrYapUU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HWYHAw9UfcsTXYRSYP02AUyh84X9B2lk92U19rYJJcvEukkbWDiL1zNgeWI9opm/l
         ST5q3a++TE8UqtAMoABHEitYaniGY/dHm6bFSDC0p19sMiu/FG2uQA3XR4azFz/fhq
         fMIthf9k1Vz8hb4UNcO/mZIayMq9nR8IG7dKj38Q=
Message-ID: <1596037482.4356.37.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>,
        Alan Stern <stern@rowland.harvard.edu>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Date:   Wed, 29 Jul 2020 08:44:42 -0700
In-Reply-To: <d9bb92e9-23fa-306f-c7f2-71a81ab28811@puri.sm>
References: <20200706164135.GE704149@rowland.harvard.edu>
         <d0ed766b-88b0-5ad5-9c10-a4c3b2f994e3@puri.sm>
         <20200728200243.GA1511887@rowland.harvard.edu>
         <f3958758-afce-8add-1692-2a3bbcc49f73@puri.sm>
         <20200729143213.GC1530967@rowland.harvard.edu>
         <1596033995.4356.15.camel@linux.ibm.com>
         <1596034432.4356.19.camel@HansenPartnership.com>
         <d9bb92e9-23fa-306f-c7f2-71a81ab28811@puri.sm>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-07-29 at 17:40 +0200, Martin Kepplinger wrote:
> On 29.07.20 16:53, James Bottomley wrote:
> > On Wed, 2020-07-29 at 07:46 -0700, James Bottomley wrote:
> > > On Wed, 2020-07-29 at 10:32 -0400, Alan Stern wrote:
[...]
> > > > This error report comes from the SCSI layer, not the block
> > > > layer.
> > > 
> > > That sense code means "NOT READY TO READY CHANGE, MEDIUM MAY HAVE
> > > CHANGED" so it sounds like it something we should be
> > > ignoring.  Usually this signals a problem, like you changed the
> > > medium manually (ejected the CD).  But in this case you can tell
> > > us to expect this by setting
> > > 
> > > sdev->expecting_cc_ua
> > > 
> > > And we'll retry.  I think you need to set this on all resumed
> > > devices.
> > 
> > Actually, it's not quite that easy, we filter out this ASC/ASCQ
> > combination from the check because we should never ignore medium
> > might have changed events on running devices.  We could ignore it
> > if we had a flag to say the power has been yanked (perhaps an
> > additional sdev flag you set on resume) but we would still miss the
> > case where you really had powered off the drive and then changed
> > the media ... if you can regard this as the user's problem, then we
> > might have a solution.
> > 
> > James
> >  
> 
> oh I see what you mean now, thanks for the ellaboration.
> 
> if I do the following change, things all look normal and runtime pm
> works. I'm not 100% sure if just setting expecting_cc_ua in resume()
> is "correct" but that looks like it is what you're talking about:
> 
> (note that this is of course with the one block layer diff applied
> that Alan posted a few emails back)
> 
> 
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -554,16 +554,8 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
>                  * so that we can deal with it there.
>                  */
>                 if (scmd->device->expecting_cc_ua) {
> -                       /*
> -                        * Because some device does not queue unit
> -                        * attentions correctly, we carefully check
> -                        * additional sense code and qualifier so as
> -                        * not to squash media change unit attention.
> -                        */
> -                       if (sshdr.asc != 0x28 || sshdr.ascq != 0x00)
> {
> -                               scmd->device->expecting_cc_ua = 0;
> -                               return NEEDS_RETRY;
> -                       }
> +                       scmd->device->expecting_cc_ua = 0;
> +                       return NEEDS_RETRY;

Well, yes, but you can't do this because it would lose us media change
events in the non-suspend/resume case which we really don't want. 
That's why I was suggesting a new flag.

James

