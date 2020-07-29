Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1715C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D25E820809
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:29:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Tt/Rni/B";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="KQaqvxmT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgG2S3M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:29:12 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37240 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726476AbgG2S3M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 14:29:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 23EF68EE207;
        Wed, 29 Jul 2020 11:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1596047351;
        bh=lmvdWfkNthLcd8tbVLUyvCZWMMouvRKzBjtB4dSh7RQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Tt/Rni/BaejmTjb9XJMsupyz6aNYXpTi/2mGbyUFEg51ToNj8+BQGAD3stCxIEB7b
         HLrYZgn2FCPiFroAUR3BUxHFLRo0sdus/DpxutI1IA4YWu3Z5nljuXONuaNS+NLTth
         c+6O8de4dy2VNNUSLkN8g8Vncgy6FYmR85GQLZaQ=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vzisFoXNQpZm; Wed, 29 Jul 2020 11:29:11 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 9A5418EE100;
        Wed, 29 Jul 2020 11:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1596047350;
        bh=lmvdWfkNthLcd8tbVLUyvCZWMMouvRKzBjtB4dSh7RQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KQaqvxmTrK4SnBb4MZ3BM0XrnUj5aONuulLhAEiX6oO+c1UTiE5S5TN67waHvYGrj
         SlswXRtrgKJliTLza6zJGBaK3E33rlKI2BynIoWydRMAlXGyg1lKavXUuo5AQU9UKr
         ZbkETKoBi6aE3sNRCB/R1w1xFFw+Ip9e5FSib2XA=
Message-ID: <1596047349.4356.84.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Date:   Wed, 29 Jul 2020 11:29:09 -0700
In-Reply-To: <20200729182515.GB1580638@rowland.harvard.edu>
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
         <20200729182515.GB1580638@rowland.harvard.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-07-29 at 14:25 -0400, Alan Stern wrote:
> On Wed, Jul 29, 2020 at 06:43:48PM +0200, Martin Kepplinger wrote:
[...]
> > > > --- a/drivers/scsi/scsi_error.c
> > > > +++ b/drivers/scsi/scsi_error.c
> > > > @@ -554,16 +554,8 @@ int scsi_check_sense(struct scsi_cmnd
> > > > *scmd)
> > > >                  * so that we can deal with it there.
> > > >                  */
> > > >                 if (scmd->device->expecting_cc_ua) {
> > > > -                       /*
> > > > -                        * Because some device does not queue
> > > > unit
> > > > -                        * attentions correctly, we carefully
> > > > check
> > > > -                        * additional sense code and qualifier
> > > > so as
> > > > -                        * not to squash media change unit
> > > > attention.
> > > > -                        */
> > > > -                       if (sshdr.asc != 0x28 || sshdr.ascq !=
> > > > 0x00)
> > > > {
> > > > -                               scmd->device->expecting_cc_ua =
> > > > 0;
> > > > -                               return NEEDS_RETRY;
> > > > -                       }
> > > > +                       scmd->device->expecting_cc_ua = 0;
> > > > +                       return NEEDS_RETRY;
> > > 
> > > Well, yes, but you can't do this because it would lose us media
> > > change events in the non-suspend/resume case which we really
> > > don't want.  That's why I was suggesting a new flag.
> > > 
> > > James
> > 
> > also if I set expecting_cc_ua in resume() only, like I did?
> 
> That wouldn't make any difference.  The information sent by your
> card reader has sshdr.asc == 0x28 and sshdr.ascq == 0x00 (you can see
> it in the log).  So because of the code here in scsi_check_sense(),
> which you can't change, the Unit Attention sent by the card reader
> would not be  retried even if you do set the flag in resume().

But if we had a new flag, like expecting_media_change, you could set
that in resume and we could condition the above test in the code on it
and reset it and do a retry if it gets set.  I'm not saying we have to
do it this way, but it sounds like we have to do something in the
kernel, so I think the flag will become necessary but there might be a
bit of policy based dance around how it gets set in the kernel (to
avoid losing accurate media change events).

James

