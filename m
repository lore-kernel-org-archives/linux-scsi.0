Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 832A3C7EE29
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 09:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240113AbjFGJgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 05:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234391AbjFGJgS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 05:36:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EBC19BA;
        Wed,  7 Jun 2023 02:36:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7595C219EB;
        Wed,  7 Jun 2023 09:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686130561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=75sx9YPzzOQ5HunMJHsNhRD8Qrxy7CvSJd0vNzJEQj8=;
        b=E98ITgR8kGY+FemOlwQj66tHipMn/XCRzPDTf4ZHC+3W8ysugIzg01Vr8QRzGelmohGpUg
        0LURyIGQbFd8aA/n0TqhKoJD1DBX9LYzQhirVWKtQOpqQzo/19V5K850IyiuU8n2SnRwvh
        oClp78hrWFIfHmZhwVqwjeHu/s45QOo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 12DFC13776;
        Wed,  7 Jun 2023 09:36:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XgHtAoFPgGRZYwAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 07 Jun 2023 09:36:01 +0000
Message-ID: <e982c95ad7ee29f80e8c0ba88f0cece837e344b9.camel@suse.com>
Subject: Re: [PATCH v2 3/3] scsi: simplify scsi_stop_queue()
From:   Martin Wilck <mwilck@suse.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Date:   Wed, 07 Jun 2023 11:36:00 +0200
In-Reply-To: <c0563161eb613f9500e6a1cccdcff6fc64efffad.camel@suse.com>
References: <20230606193845.9627-1-mwilck@suse.com>
         <20230606193845.9627-4-mwilck@suse.com> <20230607052710.GC20052@lst.de>
         <c0563161eb613f9500e6a1cccdcff6fc64efffad.camel@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-06-07 at 11:26 +0200, Martin Wilck wrote:
> On Wed, 2023-06-07 at 07:27 +0200, Christoph Hellwig wrote:
> >=20
> > =A0 3) remove scsi_stop_queue and open code it in the two callers,
> > one
> > =A0=A0=A0=A0 of which currently wants nowait semantics, and one that
> > doesn't.
> ok

Hm, scsi_stop_queue() pairs with scsi_start_queue(), do we really want
to open-code it?

Martin

