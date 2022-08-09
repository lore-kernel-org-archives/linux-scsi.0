Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6ACBC19F2D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 08:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbiHIIvB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 04:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241166AbiHIIux (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 04:50:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3399838B7
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 01:50:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D5A0E1FDE0;
        Tue,  9 Aug 2022 08:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660035050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Wyt5I0YUIk6ZAy+4tn99uTWB4boBz6q6D15YTdEl9g=;
        b=fmlNp9dwFmWP3HiIj4bP60nYMqVhXOK8tM1lWcmQykKZpVCGhlXuBE2l08xsrPKfkfdNSr
        lE1Z2ayqJoPsI6mfqrjbYn9UKD7SHYsotJtpf5gAaopNMo9PQYFslZbe5m0hC6VxyR6PkW
        VC1cayJdJmMQJGTsV6Lx38tIxY5ev/E=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8982D13A9D;
        Tue,  9 Aug 2022 08:50:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id P9zZH+of8mL5IAAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 09 Aug 2022 08:50:50 +0000
Message-ID: <3fa3ad7169546b1c7e9196474a29e96b719ebe67.camel@suse.com>
Subject: Re: [PATCH RESEND] scsi: scan: retry INQUIRY after timeout
From:   Martin Wilck <mwilck@suse.com>
To:     Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Dave Prizer <dave.prizer@hpe.com>
Date:   Tue, 09 Aug 2022 10:50:50 +0200
In-Reply-To: <20220809065247.GA9663@lst.de>
References: <20220808202018.22224-1-mwilck@suse.com>
         <251c6042-5778-5d82-64e3-a2de5e1e2d36@oracle.com>
         <20220809065247.GA9663@lst.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2022-08-09 at 08:52 +0200, Christoph Hellwig wrote:
> >=20
> > An alternative to changing all the callers would be we could make
> > scsi_noretry_cmd
> > detect when it's an internal passthrough command and just retry
> > these types of
> > errors. For SG IO type of passthough we still want to fail right
> > away.
>=20
> Yes, I think one single place to do retries for setup path command
> is much better than growing ad-hoc logic.
>=20
> I just made a similar comment to similar nvme patch from SuSE a few
> days
> ago..

Are you suggesting to re-invent REQ_OP_SCSI_{IN,OUT} to distinguish
SG_IO from kernel-internal passthrough?

Martin

