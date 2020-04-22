Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B8DC2BA19
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 01:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EA442070B
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 01:04:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hVPS2ujs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDVBEB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 21:04:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39662 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726055AbgDVBEA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 21:04:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587517438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=neoNO/lAbBJQ6VnOBxXRvj3nh9UxKhbN/pnaBOuFds4=;
        b=hVPS2ujsLfeYYiTGvUjXRhs9ga1/039mofhHdw6DOqsYqhKkmWZaQbATOYKFICgXq5eaw5
        devk7eh4rgLKiL3LDuxLjmhUsN8sPyL1DnD5SI7lbIUmc6msJNRxHBXnyCyu/PLxnnemJY
        7uEy/t4dDi4g7P/a+uq7Wo20nDzPGZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-u6QiRpBCNzG1JNIuwfz6eg-1; Tue, 21 Apr 2020 21:03:54 -0400
X-MC-Unique: u6QiRpBCNzG1JNIuwfz6eg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55BF28018A4;
        Wed, 22 Apr 2020 01:03:53 +0000 (UTC)
Received: from T590 (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E15D19757;
        Wed, 22 Apr 2020 01:03:44 +0000 (UTC)
Date:   Wed, 22 Apr 2020 09:03:38 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: put hot fields of scsi_host_template into one
 cacheline
Message-ID: <20200422010338.GA299948@T590>
References: <20200421124952.297448-1-ming.lei@redhat.com>
 <367d58f7-722d-16db-3e90-50dc9fd4e078@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <367d58f7-722d-16db-3e90-50dc9fd4e078@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 21, 2020 at 04:16:52PM +0100, John Garry wrote:
> On 21/04/2020 13:49, Ming Lei wrote:
> > The following three fields of scsi_host_template are referenced in
> > scsi IO submission path, so put them together into one cacheline:
> > 
> > - cmd_size
> > - queuecommand
> > - commit_rqs
> > 
> > Cc: Bart Van Assche <bvanassche@acm.org>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: John Garry <john.garry@huawei.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   include/scsi/scsi_host.h | 67 +++++++++++++++++++++-------------------
> >   1 file changed, 35 insertions(+), 32 deletions(-)
> > 
> > diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> > index 822e8cda8d9b..959dc5160f72 100644
> > --- a/include/scsi/scsi_host.h
> > +++ b/include/scsi/scsi_host.h
> > @@ -33,37 +33,12 @@ struct scsi_host_template {
> >   	struct module *module;
> >   	const char *name;
> > -	/*
> > -	 * The info function will return whatever useful information the
> > -	 * developer sees fit.  If not provided, then the name field will
> > -	 * be used instead.
> > -	 *
> > -	 * Status: OPTIONAL
> > -	 */
> > -	const char *(* info)(struct Scsi_Host *);
> > +	/* Put hot fields together in same cacheline */
> >   	/*
> > -	 * Ioctl interface
> > -	 *
> > -	 * Status: OPTIONAL
> > -	 */
> > -	int (*ioctl)(struct scsi_device *dev, unsigned int cmd,
> > -		     void __user *arg);
> > -
> > -
> > -#ifdef CONFIG_COMPAT
> > -	/*
> > -	 * Compat handler. Handle 32bit ABI.
> > -	 * When unknown ioctl is passed return -ENOIOCTLCMD.
> > -	 *
> > -	 * Status: OPTIONAL
> > +	 * Additional per-command data allocated for the driver.
> >   	 */
> > -	int (*compat_ioctl)(struct scsi_device *dev, unsigned int cmd,
> > -			    void __user *arg);
> > -#endif
> > -
> > -	int (*init_cmd_priv)(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
> > -	int (*exit_cmd_priv)(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
> 
> Should new member .init_cmd_priv be included also in the "hot" group? Even
> if NULL generally, we still have to load that from memory to know it (is
> NULL) in scsi_mq_init_request() and scsi_init_command() [which are fastpath,
> right?]

scsi_mq_init_request() is called via ->init_request(), which is oneshot
initialization.

scsi_init_command() is in fast path, but it is called from
scsi_mq_prep_fn() directly, so it isn't related with ->init_request().


Thanks, 
Ming

