Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D13C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 10:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 531D3233A2
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 10:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbhAMK1U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 05:27:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:54640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbhAMK1T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Jan 2021 05:27:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610533593; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dp0BshasInwzk4y4ncWD9TfPGztNivUz6gsVViSQC/Q=;
        b=mRSEFCyY5khy3FqekFJZ/dxybrDV7SuVOV/AyceV9cvOwdm7YMRbIGrJZet8vypSnLNGPD
        GffXNzVFxrO2vg2j3Nk94VtuZpKSiSE+sz+qLfqgEABL+e+2YapDh6qevgSaMeYEwi2Gzt
        FcAo7vlfXzmmoezFo0oyaZld1EDCt1o=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 04C9FAE6D;
        Wed, 13 Jan 2021 10:26:33 +0000 (UTC)
Message-ID: <466a5c8ff2b7f788bfb222ef8d2d9e72b9c6036c.camel@suse.com>
Subject: Re: [PATCH V3 04/25] smartpqi: add support for raid5 and raid6
 writes
From:   Martin Wilck <mwilck@suse.com>
To:     Don.Brace@microchip.com, Kevin.Barnett@microchip.com,
        Scott.Teel@microchip.com, Justin.Lindley@microchip.com,
        Scott.Benesh@microchip.com, Gerry.Morong@microchip.com,
        Mahesh.Rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Wed, 13 Jan 2021 11:26:31 +0100
In-Reply-To: <SN6PR11MB284831558FB35184B3FE14C5E1AE0@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763248354.26927.303366932249508542.stgit@brunhilda>
         <15d80793c64ffd044da1e40334acfd8ad8988fb9.camel@suse.com>
         <SN6PR11MB284831558FB35184B3FE14C5E1AE0@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-01-08 at 22:56 +0000, Don.Brace@microchip.com wrote:
> 
> > +               }
> > +               if (rmd->blocks_per_row == 0)
> > +                       return PQI_RAID_BYPASS_INELIGIBLE; #if 
> > +BITS_PER_LONG == 32
> > +               tmpdiv = rmd->first_block;
> > +               do_div(tmpdiv, rmd->blocks_per_row);
> > +               rmd->row = tmpdiv;
> > +#else
> > +               rmd->row = rmd->first_block / rmd->blocks_per_row; 
> > +#endif
> 
> Why not always use do_div()?
> 
> Don: I had removed the BITS_PER_LONG check, was an attempt to clean
> up the code, but forgot we still need to support 32bit and I just re-
> added BITS_PER_LONG HUNKS. These HUNKS were there before I refactored
> the code so it predates me. Any chance I can leave this in? It's been
> through a lot of regression testing already...

My suggestion was to rather do the opposite, use the 32bit code (with
do_div()) for both 32bit and 64bit. AFAIK, this would work just fine 
(but not vice-versa). 

You can leave this in. It was just a suggestion how to improve
readability. Perhaps consider cleaning it up sometime later.

Regards,
Martin


