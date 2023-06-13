Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44142C7EE29
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 10:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240821AbjFMK5q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 06:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239739AbjFMK5o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 06:57:44 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EA3E52;
        Tue, 13 Jun 2023 03:57:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4CD18222BC;
        Tue, 13 Jun 2023 10:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686653862; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xiSWyWrFP9qYR7wfGwciATRVSUzaesp72LT0V5+P0PU=;
        b=YIaIeek96SdjGhHgJ2jqsVGbeSmAh2nRj0jq9fFim6pXzdADcErJkFmhW03jyY47S1F0mw
        JME0+dmBmwMYIX3r4kM5izQnXttcoGBjMBqdPtwDK4BPDV4VsXr8eLK6MG3Toik6egz9hw
        r8H9ahvaIDOQIMcrpAcYWDgG330tuG4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EB39913483;
        Tue, 13 Jun 2023 10:57:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0HB8N6VLiGQJAwAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 13 Jun 2023 10:57:41 +0000
Message-ID: <44762b9e1626ad7d77daf93bfa764e5d18256901.camel@suse.com>
Subject: Re: [PATCH v5 4/7] scsi: don't wait for quiesce in scsi_stop_queue()
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Date:   Tue, 13 Jun 2023 12:57:41 +0200
In-Reply-To: <9887b6c0-04ef-a2c7-94be-d8558cdc44df@acm.org>
References: <20230612165049.29440-1-mwilck@suse.com>
         <20230612165049.29440-5-mwilck@suse.com>
         <9887b6c0-04ef-a2c7-94be-d8558cdc44df@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-06-12 at 11:02 -0700, Bart Van Assche wrote:
> On 6/12/23 09:50, mwilck@suse.com=A0wrote:
> > @@ -2800,9 +2792,17 @@ static void scsi_device_block(struct
> > scsi_device *sdev, void *data)
> > =A0=20
> > =A0=A0=A0=A0=A0=A0=A0=A0mutex_lock(&sdev->state_mutex);
> > =A0=A0=A0=A0=A0=A0=A0=A0err =3D __scsi_internal_device_block_nowait(sde=
v);
> > -=A0=A0=A0=A0=A0=A0=A0if (err =3D=3D 0)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_stop_queue(sdev, fal=
se);
> > -=A0=A0=A0=A0=A0=A0=A0mutex_unlock(&sdev->state_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0if (err =3D=3D 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * scsi_stop_queue() must=
 be called with the
> > state_mutex
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * held. Otherwise a simu=
ltaneous
> > scsi_start_queue() call
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * might unquiesce the qu=
eue before we quiesce it.
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_stop_queue(sdev);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mutex_unlock(&sdev->state=
_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0blk_mq_wait_quiesce_done(=
sdev->request_queue-
> > >tag_set);
> > +=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mutex_unlock(&sdev->state=
_mutex);
> > =A0=20
> > =A0=A0=A0=A0=A0=A0=A0=A0WARN_ONCE(err, "__scsi_internal_device_block_no=
wait(%s)
> > failed: err =3D %d\n",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_name(&sdev->sde=
v_gendev), err);
>=20
> Has it been considered to modify the above code such that there is a
> single mutex_unlock() call instead of two? I wouldn't mind if
> blk_mq_wait_quiesce_done() would be called if err !=3D 0 since
> performance
> is not that important if this function fails.

This code is just an intermediate stage. The double mutex_unlock() is
converted back to a single one in the subsequent patch. As Christoph
has already ack'd it, unless it's really important to you, I'd like to
keep this patch as-is.

Thanks,
Martin

