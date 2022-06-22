Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024A9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 12:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357491AbiFVMFs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jun 2022 08:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357436AbiFVMFq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2022 08:05:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1CF3DDD2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2022 05:05:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D847321C18;
        Wed, 22 Jun 2022 12:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655899543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gGCYuDrNqd+RFhvQ6k3RexeYzlIcdG3ahRubp15pdrg=;
        b=KRKNWtkjhT7+ZMaVESXAWOosXs+ZUxMKXr/W7KoQVEayATHmrMqewxszLjL0pNyxA36YzF
        OJWYhEi0n9wMmKonZ7Jud6qMF1LXaSK0FHvfw3ERdj2p5TOy7nY8vtdpk+YuvRAdOkLmpZ
        vcVcEG0+wSaHVD/eYzGmk1pw0FfpEZ0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9CD0F13A5D;
        Wed, 22 Jun 2022 12:05:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gGWWJJcFs2IjAwAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 22 Jun 2022 12:05:43 +0000
Message-ID: <dd3db03318e366d76cdf1bd9386e506cbf31c213.camel@suse.com>
Subject: Re: [PATCH 1/2] scsi: add BLIST_RETRY_SCAN to ignore errors during
 scanning
From:   Martin Wilck <mwilck@suse.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Date:   Wed, 22 Jun 2022 14:05:43 +0200
In-Reply-To: <aabbe36e-1791-78b1-ec1e-8a95fbd29895@suse.de>
References: <20220615164149.3092-1-mwilck@suse.com>
         <20220615164149.3092-2-mwilck@suse.com>
         <yq15yktjw77.fsf@ca-mkp.ca.oracle.com>
         <d409f1856e46c3df951eaac9eed14844c66961fa.camel@suse.com>
         <aabbe36e-1791-78b1-ec1e-8a95fbd29895@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-06-22 at 12:49 +0200, Hannes Reinecke wrote:
> On 6/22/22 10:16, Martin Wilck wrote:
> > On Tue, 2022-06-21 at 22:02 -0400, Martin K. Petersen wrote:
> > >=20
> > > Martin,
> > >=20
> > > > @@ -1531,9 +1536,10 @@ static int scsi_report_lun_scan(struct
> > > > scsi_target *starget, blist_flags_t bflag
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 " allowed by the host
> > > > adapter\n", lun);
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0int res;
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0blist_flags_t bflags =3D
> > > > BLIST_RETRY_SCAN;
> > >=20
> > > I'm not a big fan of using the bflag as carrier of "I was
> > > reported
> > > and
> > > therefore must exist".
> > >=20
> > > Also: Why isn't patch #2 sufficient?
> >=20
> > I think it is. I can resubmit just #2 if you prefer and Hannes
> > agrees.
> >=20
> I'm fine with just adding #2; #1 is really just there to provide the=20
> original behaviour. Device probing is one of the most arcane areas
> in the SCSI stack due to all the various quirks etc and I didn't want
> to change anything here.
>=20
> But if it's okay, it's okay :-)

Alright. To be certain, I'll ask our partner for another test.

Martin

