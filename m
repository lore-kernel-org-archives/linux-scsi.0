Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9805BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87F062084D
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgG2SZU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:25:20 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58697 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726385AbgG2SZR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 14:25:17 -0400
Received: (qmail 1581829 invoked by uid 1000); 29 Jul 2020 14:25:15 -0400
Date:   Wed, 29 Jul 2020 14:25:15 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200729182515.GB1580638@rowland.harvard.edu>
References: <20200706164135.GE704149@rowland.harvard.edu>
 <d0ed766b-88b0-5ad5-9c10-a4c3b2f994e3@puri.sm>
 <20200728200243.GA1511887@rowland.harvard.edu>
 <f3958758-afce-8add-1692-2a3bbcc49f73@puri.sm>
 <20200729143213.GC1530967@rowland.harvard.edu>
 <1596033995.4356.15.camel@linux.ibm.com>
 <1596034432.4356.19.camel@HansenPartnership.com>
 <d9bb92e9-23fa-306f-c7f2-71a81ab28811@puri.sm>
 <1596037482.4356.37.camel@HansenPartnership.com>
 <A1653792-B7E5-46A9-835B-7FA85FCD0378@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A1653792-B7E5-46A9-835B-7FA85FCD0378@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 29, 2020 at 06:43:48PM +0200, Martin Kepplinger wrote:
> 
> 
> Am 29. Juli 2020 17:44:42 MESZ schrieb James Bottomley <James.Bottomley@HansenPartnership.com>:
> >On Wed, 2020-07-29 at 17:40 +0200, Martin Kepplinger wrote:
> >> On 29.07.20 16:53, James Bottomley wrote:
> >> > On Wed, 2020-07-29 at 07:46 -0700, James Bottomley wrote:
> >> > > On Wed, 2020-07-29 at 10:32 -0400, Alan Stern wrote:
> >[...]
> >> > > > This error report comes from the SCSI layer, not the block
> >> > > > layer.
> >> > > 
> >> > > That sense code means "NOT READY TO READY CHANGE, MEDIUM MAY HAVE
> >> > > CHANGED" so it sounds like it something we should be
> >> > > ignoring.  Usually this signals a problem, like you changed the
> >> > > medium manually (ejected the CD).  But in this case you can tell
> >> > > us to expect this by setting
> >> > > 
> >> > > sdev->expecting_cc_ua
> >> > > 
> >> > > And we'll retry.  I think you need to set this on all resumed
> >> > > devices.
> >> > 
> >> > Actually, it's not quite that easy, we filter out this ASC/ASCQ
> >> > combination from the check because we should never ignore medium
> >> > might have changed events on running devices.  We could ignore it
> >> > if we had a flag to say the power has been yanked (perhaps an
> >> > additional sdev flag you set on resume) but we would still miss the
> >> > case where you really had powered off the drive and then changed
> >> > the media ... if you can regard this as the user's problem, then we
> >> > might have a solution.
> >> > 
> >> > James
> >> >  
> >> 
> >> oh I see what you mean now, thanks for the ellaboration.
> >> 
> >> if I do the following change, things all look normal and runtime pm
> >> works. I'm not 100% sure if just setting expecting_cc_ua in resume()
> >> is "correct" but that looks like it is what you're talking about:
> >> 
> >> (note that this is of course with the one block layer diff applied
> >> that Alan posted a few emails back)
> >> 
> >> 
> >> --- a/drivers/scsi/scsi_error.c
> >> +++ b/drivers/scsi/scsi_error.c
> >> @@ -554,16 +554,8 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
> >>                  * so that we can deal with it there.
> >>                  */
> >>                 if (scmd->device->expecting_cc_ua) {
> >> -                       /*
> >> -                        * Because some device does not queue unit
> >> -                        * attentions correctly, we carefully check
> >> -                        * additional sense code and qualifier so as
> >> -                        * not to squash media change unit attention.
> >> -                        */
> >> -                       if (sshdr.asc != 0x28 || sshdr.ascq != 0x00)
> >> {
> >> -                               scmd->device->expecting_cc_ua = 0;
> >> -                               return NEEDS_RETRY;
> >> -                       }
> >> +                       scmd->device->expecting_cc_ua = 0;
> >> +                       return NEEDS_RETRY;
> >
> >Well, yes, but you can't do this because it would lose us media change
> >events in the non-suspend/resume case which we really don't want. 
> >That's why I was suggesting a new flag.
> >
> >James
> 
> also if I set expecting_cc_ua in resume() only, like I did?

That wouldn't make any difference.  The information sent by your card 
reader has sshdr.asc == 0x28 and sshdr.ascq == 0x00 (you can see it in 
the log).  So because of the code here in scsi_check_sense(), which you 
can't change, the Unit Attention sent by the card reader would not be 
retried even if you do set the flag in resume().

Alan Stern
