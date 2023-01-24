Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46AD9C25B4E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 15:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbjAXP0M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 10:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbjAXP0L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 10:26:11 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD02460B9
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 07:26:06 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 63393219C7;
        Tue, 24 Jan 2023 15:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674573965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YPmEoY+DXRez2QZ+mEPqM2VfxUCRHDDrJWbOmYasoKY=;
        b=QhCCfZf3hMMSD5UTMTJpKILJ8tA2ERv34FquONTRUjtzhuvqnmmiAXKjTCxDSOlU+jPlk7
        WSqCDynOAm0mqCr0+DI6goQFCgqqeyutcxF6rvhCKE3lyDyyLhaU3mJN5a3yFFPGNoG2Ad
        y/bE8Nhxc2KuUni9edYSYBreWM4av6Y=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1862C13487;
        Tue, 24 Jan 2023 15:26:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /VFPBI34z2NxJgAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 24 Jan 2023 15:26:05 +0000
Message-ID: <e6828fb381f5a330c1f341d806b3ebfc21f3489b.camel@suse.com>
Subject: Re: [PATCH v2] scsi: add non-sleeping variant of scsi_device_put()
 and use it in alua
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Date:   Tue, 24 Jan 2023 16:26:03 +0100
In-Reply-To: <e84388f4-4e33-d7a7-a121-a02dfd9038a5@acm.org>
References: <20230124143025.3464-1-mwilck@suse.com>
         <e84388f4-4e33-d7a7-a121-a02dfd9038a5@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-01-24 at 07:23 -0800, Bart Van Assche wrote:
> On 1/24/23 06:30, mwilck@suse.com=A0wrote:
> > +/**
> > + * scsi_device_put_nosleep=A0 -=A0 release a reference to a
> > scsi_device
> > + * @sdev:=A0=A0=A0=A0=A0=A0device to release a reference on.
> > + *
> > + * Description: Release a reference to the scsi_device and
> > decrements the use
> > + * count of the underlying LLDD module. This function may only be
> > called from
> > + * a call context where it is certain that the reference dropped
> > is not the
> > + * last one.
> > + */
>=20
> The above comment does not cover the call from scsi_device_put().
> That=20
> could be addressed by adding the following text at the end of the
> above=20
> comment: " or from a context in which it is allowed to sleep".
> However,=20
> if that text would be added the function name=20
> ("scsi_device_put_nosleep()") would become confusing. How about=20
> open-coding scsi_device_put_nosleep() in scsi_device_put() to prevent
> this confusion?

Or simply mentioning that the call from scsi_device_put() is legal?

Martin

