Return-Path: <SRS0=SrIF=DD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E85C4741F
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 16:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55A222080A
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 16:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="IvR1YD+w";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="XDmM+lLW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbgIZQFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Sep 2020 12:05:32 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60234 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728017AbgIZQFc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 26 Sep 2020 12:05:32 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Sep 2020 12:05:32 EDT
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 2864B8EE1D2;
        Sat, 26 Sep 2020 08:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1601135867;
        bh=rD4REDTiuYYtn4sZscXqF7OKu/aHoA0CpXICd7Rlb+8=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=IvR1YD+wbRSM9AxOBwZgdL8vB6t+sc9f0GVP4GCk0rWy2KPWj6C0jGfSX7EJVtyuw
         rNywjatu34vyvt7AbK9xrDLOn16qngm61c6C0YnVVaqJdepxttcs5YQ0aa7viUg4F1
         plhBugB/Uswftur0cObBix3gB02Tf2G0ZFFHVehA=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id L2978SdLCTSe; Sat, 26 Sep 2020 08:57:46 -0700 (PDT)
Received: from jarvis (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3619A8EE1C0;
        Sat, 26 Sep 2020 08:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1601135865;
        bh=rD4REDTiuYYtn4sZscXqF7OKu/aHoA0CpXICd7Rlb+8=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=XDmM+lLWAyILBACvf/HBLkipxECuaKl04XFVID7G4ihpyHkemqlklEg54CBQW58xM
         s9QYgif0KmEXoX/cVQN6rIhw6M/zfAOt3aHi8FvYAQWuO7pSmDNO2ElA5VnldRw35w
         bt41ZCraxtqvJh6vkIoojZ9/n/7PiU1VGcjahdI8=
Message-ID: <eb1216d26b3baaf1bea2562ae772f968c36f52ba.camel@HansenPartnership.com>
Subject: Re: [v5 07/12] libata: Make ata_scsi_durable_name static
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     tasleson@redhat.com, Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
Date:   Sat, 26 Sep 2020 08:57:42 -0700
In-Reply-To: <b95e0b6f-dcc1-8032-ebcd-29ae594fcbaf@redhat.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
         <20200925161929.1136806-8-tasleson@redhat.com>
         <ec0479bf-e5ac-58f1-248a-2d4c29ae3efa@gmail.com>
         <b95e0b6f-dcc1-8032-ebcd-29ae594fcbaf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-09-26 at 09:17 -0500, Tony Asleson wrote:
> On 9/26/20 3:40 AM, Sergei Shtylyov wrote:
> > Hello!
> > 
> > On 25.09.2020 19:19, Tony Asleson wrote:
> > 
> > > Signed-off-by: Tony Asleson <tasleson@redhat.com>
> > > Signed-off-by: kernel test robot <lkp@intel.com>
> > > ---
> > >   drivers/ata/libata-scsi.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-
> > > scsi.c
> > > index 194dac7dbdca..13a58ed7184c 100644
> > > --- a/drivers/ata/libata-scsi.c
> > > +++ b/drivers/ata/libata-scsi.c
> > > @@ -1086,7 +1086,7 @@ int ata_scsi_dev_config(struct scsi_device
> > > *sdev, struct ata_device *dev)
> > >       return 0;
> > >   }
> > >   -int ata_scsi_durable_name(const struct device *dev, char *buf,
> > > size_t len)
> > > +static int ata_scsi_durable_name(const struct device *dev, char
> > > *buf,
> > > size_t len)
> > 
> >    Why not do it in patch #6 -- when introducing the function?
> 
> This issue was found by the intel kernel test robot in v4 patch
> series. I thought it was better to have a separate commit with the
> correction that matched it's signed off.  Maybe that's not the
> correct approach?

No ... while a patch is being reviewed the purpose of review is to make
it better by folding in all the comments.  It then gets a changelog put
below the 

---

v5: made X function static

So people can follow how it has evolved.  This is all actually
described in Documentation/submitting-patches.

James


