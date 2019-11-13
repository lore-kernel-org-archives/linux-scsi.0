Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A1BC43141
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 22:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A36D206EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 22:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfKMWYm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 17:24:42 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33596 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfKMWYm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 17:24:42 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 1B7992925B;
        Wed, 13 Nov 2019 17:24:38 -0500 (EST)
Date:   Thu, 14 Nov 2019 09:24:37 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Kars de Jong <jongk@linux-m68k.org>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        linux-m68k@vger.kernel.org, schmitzmic@gmail.com
Subject: Re: [PATCH 2/2] esp_scsi: Add support for FSC chip
In-Reply-To: <CACz-3rhP9pfg4tVe5GikX-7MWC2sGtE0AsoPeuUBR-a07YxQFA@mail.gmail.com>
Message-ID: <alpine.LNX.2.21.1.1911140903490.21@nippy.intranet>
References: <20191029220503.7553-1-jongk@linux-m68k.org> <20191112185710.23988-1-jongk@linux-m68k.org> <20191112185710.23988-3-jongk@linux-m68k.org> <alpine.LNX.2.21.1.1911131007110.13@nippy.intranet>
 <CACz-3rhP9pfg4tVe5GikX-7MWC2sGtE0AsoPeuUBR-a07YxQFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Nov 2019, Kars de Jong wrote:

> Op wo 13 nov. 2019 om 00:18 schreef Finn Thain <fthain@telegraphics.com.au>:
> >
> > On Tue, 12 Nov 2019, Kars de Jong wrote:
> > > +#define ESP_UID_REV           0x07     /* ESP revision bitmask */
> >
> > This is unused.
> 
> Yes, but it was already there, I just moved it.
> 

Sure, but if you move dead code, it creates churn which can lead to merge 
conflicts. And such changes still require code review.

Also, you'd lose an opportunity to delete the dead code, which is a pity, 
since that would then require a separate patch.

> I prefer to leave it in, since it describes the register layout.
> 

Well, the driver can't be understood from the code alone. The datasheet 
will always be required reading.

> > > +#define ESP_UID_FAM           0xf8     /* ESP family bitmask */
> > > +
> > > +#define ESP_FAMILY(uid) (((uid) & ESP_UID_FAM) >> 3)
> > > +
> >
> > The ESP_UID_FAM symbol only appears here. I don't think it adds value.
> 
> OK, I can just change the macro to:
> 
> #define ESP_FAMILY(uid) (((uid) & 0xf8) >> 3)
> 

Now that I understand the relationship between UID and Family, I see why 
you did this.

> > > +/* Values for the ESP family */
> >
> > I would omit that comment.
> 
> I will change it to "Values for the ESP family bits" as you suggested
> in the next mail.
> 

Great.

> > >  #define ESP_UID_F100A         0x00     /* ESP FAS100A  */
> > >  #define ESP_UID_F236          0x02     /* ESP FAS236   */
> > > -#define ESP_UID_REV           0x07     /* ESP revision */
> > > -#define ESP_UID_FAM           0xf8     /* ESP family   */
> > > +#define ESP_UID_HME           0x0a     /* FAS HME      */
> > > +#define ESP_UID_FSC           0x14     /* NCR/Symbios Logic FSC */
> > >
> >
> > Is there a distinction between the chip's uid and the chip's family?
> 
> Yes, the complete UID also includes the revision. The old driver had 
> cases where the family code was the same but the revision was different.
> 

Makes sense. Thanks for the explanation.

-- 

> Kind regards,
> 
> Kars.
> 
