Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FD6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 08:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240157AbiFVIRS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jun 2022 04:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242231AbiFVIQ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2022 04:16:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D7C37BEC
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2022 01:16:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 01DC61F9F9;
        Wed, 22 Jun 2022 08:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655885815; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=59LeELaPTffMej3LhzMmKJquQLmznld84T8hOrCAnqg=;
        b=s6ys7RKP2YvtBFcm/f0ylVl2AsRsrbrygDEfArp7SyedI9l/4SvDxoRcvKbugV4WaMqwT0
        pfMC+tzjoD6ieRByPN7qtVib1oP2N+nKKZ/vm1P7FMMp17T3gcR5HNL84sSxtqK3wX1muk
        fZBABeixtB4PDfEHC9FJYEfCz4POISs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B87B913A5D;
        Wed, 22 Jun 2022 08:16:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Y6RWK/bPsmJCAgAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 22 Jun 2022 08:16:54 +0000
Message-ID: <d409f1856e46c3df951eaac9eed14844c66961fa.camel@suse.com>
Subject: Re: [PATCH 1/2] scsi: add BLIST_RETRY_SCAN to ignore errors during
 scanning
From:   Martin Wilck <mwilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Date:   Wed, 22 Jun 2022 10:16:54 +0200
In-Reply-To: <yq15yktjw77.fsf@ca-mkp.ca.oracle.com>
References: <20220615164149.3092-1-mwilck@suse.com>
         <20220615164149.3092-2-mwilck@suse.com>
         <yq15yktjw77.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2022-06-21 at 22:02 -0400, Martin K. Petersen wrote:
>=20
> Martin,
>=20
> > @@ -1531,9 +1536,10 @@ static int scsi_report_lun_scan(struct
> > scsi_target *starget, blist_flags_t bflag
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 " allowed by the host
> > adapter\n", lun);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0int res;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
list_flags_t bflags =3D BLIST_RETRY_SCAN;
>=20
> I'm not a big fan of using the bflag as carrier of "I was reported
> and
> therefore must exist".
>=20
> Also: Why isn't patch #2 sufficient?

I think it is. I can resubmit just #2 if you prefer and Hannes agrees.

Regards,
Martin


