Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19DFC47420
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 20:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 832EC239D1
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 20:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WcXKUonk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgIYUR2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 16:17:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbgIYUP2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 16:15:28 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601064926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kEmnlmchPR9vS1orvoNm0OXoq6QCMFirGMz7PpRHNOE=;
        b=WcXKUonkMaXc+dgKBP7kzoSikhAngVqio6cDmIjbg1pbAeQcLBodW+4xWJZxrjKVkiLotF
        jzYJAMeN6rI9QjY1REZWTjw7ntt5dvlFv+GOgwndHtyIWZbyBZqq2CnRZ7M3GCLdL7exi+
        yqKnR0g1DRHZUoGss5NPkiECQy/Sk88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-GAvbEu2YM96RiYpkhr_MNw-1; Fri, 25 Sep 2020 16:15:22 -0400
X-MC-Unique: GAvbEu2YM96RiYpkhr_MNw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EDDBAD503;
        Fri, 25 Sep 2020 20:15:20 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 446D95C1BB;
        Fri, 25 Sep 2020 20:15:13 +0000 (UTC)
Date:   Fri, 25 Sep 2020 16:15:12 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "ssudhakarp@gmail.com" <ssudhakarp@gmail.com>,
        "dm-crypt@saout.de" <dm-crypt@saout.de>,
        Eric Biggers <ebiggers@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Shirley Ma <shirley.ma@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        Milan Broz <gmazyland@gmail.com>,
        "agk@redhat.com" <agk@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, mst@redhat.com
Subject: Re: [RFC PATCH 0/2] dm crypt: Allow unaligned buffer lengths for
 skcipher devices
Message-ID: <20200925201512.GA6025@redhat.com>
References: <20200924012732.GA10766@redhat.com>
 <20200924051419.GA16103@sol.localdomain>
 <252587bb-c0b7-47c9-a97b-91422f8f9c47@default>
 <alpine.LRH.2.02.2009241314280.28814@file01.intranet.prod.int.rdu2.redhat.com>
 <7b6fdfd5-0160-4bcf-b7ed-d0e51553c678@default>
 <alpine.LRH.2.02.2009241345370.4229@file01.intranet.prod.int.rdu2.redhat.com>
 <fd512a7d-c064-4812-a794-5274c10687db@default>
 <alpine.LRH.2.02.2009241421170.8544@file01.intranet.prod.int.rdu2.redhat.com>
 <eb43742e-bdfe-4567-8240-1d8e083d76a2@default>
 <MWHPR04MB37588DF8C3FFF4BD0C3CD543E7360@MWHPR04MB3758.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR04MB37588DF8C3FFF4BD0C3CD543E7360@MWHPR04MB3758.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 24 2020 at  9:09pm -0400,
Damien Le Moal <Damien.LeMoal@wdc.com> wrote:

> On 2020/09/25 4:14, Sudhakar Panneerselvam wrote:
> >>
> >> On Thu, 24 Sep 2020, Sudhakar Panneerselvam wrote:
> >>
> >>>> By copying it to a temporary aligned buffer and issuing I/O on this
> >>>> buffer.
> >>>
> >>> I don't like this idea. Because, you need to allocate additional pages
> >>> for the entire I/O size(for the misaligned case, if you think through
> >>
> >> You can break the I/O to smaller pieces. You can use mempool for
> >> pre-allocation of the pages.
> > 
> > Assuming we do this, how is this code simpler(based on your
> > comment below) than the fix in dm-crypt? In fact, this approach 
> > would make the code change look bad in vhost, at the same time
> > having performance penalty. By doing this, we are just moving the 
> > responsibility to other unrelated component.
> 
> Because vhost is at the top of the block-io food chain. Fixing the unaligned
> segments there will ensure that it does not matter what device is under it. It
> will work.

Right, I agree. This should be addressed in vhost-scsi.  And vhost-scsi
probably needs to be interfacing through block core to submit IO that
respects the limits of its underlying block device.

So please lift your proposed dm-crypt changes to vhost-scsi:
https://patchwork.kernel.org/patch/11781207/
https://patchwork.kernel.org/patch/11781053/

Maybe work with vhost-scsi maintainers to see about making the code
reusable in block core; so that any future unaligned application IO is
dealt in other drivers using the same common code.

But I'm not interested in taking these changes into dm-crypt:

NAK

> I am still baffled that the unaligned segments go through in the first place...
> Do we have something missing in the BIO code ?

Cc'ing linux-block, could be.

Thanks,
Mike

