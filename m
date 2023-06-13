Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66CBC7EE29
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 10:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241991AbjFMKmi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 06:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241966AbjFMKmf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 06:42:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098B319F;
        Tue, 13 Jun 2023 03:42:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 29D8221D89;
        Tue, 13 Jun 2023 10:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686652952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fdRjObJW3pDOu1v60Qd7J1KvXFeaeo4NoAyaYtHQWlg=;
        b=uZ/nnln2BbRk87uvgO1WlUiC3ZVQjSNb6di00xZqRFFw+VG5FrvIU+mtJTPQmZlTqnd//W
        ekSg/VqsRcdBWBck3vco/9nrPPa6SVC3lHSRhjOZ4HU7JTIsVW53iko3+4483SFpHy+/3U
        jAIjrYl7yW5khynWnrTHI/KjsLwda50=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C7ED613483;
        Tue, 13 Jun 2023 10:42:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4B6+LhdIiGQMegAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 13 Jun 2023 10:42:31 +0000
Message-ID: <7e05a257cffd09615b03681e0783e51e285ee15b.camel@suse.com>
Subject: Re: [PATCH v5 3/7] scsi: merge scsi_internal_device_block() and
 device_block()
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Date:   Tue, 13 Jun 2023 12:42:30 +0200
In-Reply-To: <31043005-eb42-1a03-676a-1544c3cbbe26@acm.org>
References: <20230612165049.29440-1-mwilck@suse.com>
         <20230612165049.29440-4-mwilck@suse.com>
         <31043005-eb42-1a03-676a-1544c3cbbe26@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-06-12 at 11:00 -0700, Bart Van Assche wrote:
> On 6/12/23 09:50, mwilck@suse.com=A0wrote:
> > -static int scsi_internal_device_block(struct scsi_device *sdev)
> > +static void scsi_device_block(struct scsi_device *sdev, void
> > *data)
> > =A0 {
> > =A0=A0=A0=A0=A0=A0=A0=A0int err;
> > =A0=20
> > @@ -2805,7 +2804,8 @@ static int scsi_internal_device_block(struct
> > scsi_device *sdev)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_stop_queue(sdev, f=
alse);
> > =A0=A0=A0=A0=A0=A0=A0=A0mutex_unlock(&sdev->state_mutex);
> > =A0=20
> > -=A0=A0=A0=A0=A0=A0=A0return err;
> > +=A0=A0=A0=A0=A0=A0=A0WARN_ONCE(err, "__scsi_internal_device_block_nowa=
it(%s)
> > failed: err =3D %d\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_name(&sdev->sdev_=
gendev), err);
> > =A0 }
>=20
> Hmm ... wasn't it your intention to change the reference to the
> __scsi_internal_device_block_nowait() function in this message?

Yes. I did it in a separate patch (as you saw), because I didn't want
to void the Reviewed-by: tags this patch had already received.

Regards,
Martin

