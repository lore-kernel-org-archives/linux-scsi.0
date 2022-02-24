Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90F2C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 09:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiBXJBY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 04:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiBXJBX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 04:01:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 283D115B3D9
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 01:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645693253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TmXcQuSsrm+NZgvxKh/c/Y+56HsYbAsoh2iH7I4Nk5A=;
        b=J8BWAjQ1PLznGKD4bwY/J6BN7YXpblo/3cCJgZP4luvw6vjZSUE3MA0rn3dutTfZ7mvRkf
        uAeYSJuk6Dv5X98kfjXV4CJuwOLZT6BvVBzN6+XIJbI2nAofsXlu2c2SemonAVW1N71H4U
        dkbRirGpdYLef1NV0vCsZyMXrt4egbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-yvmukoBqMxihyMhLaco2yQ-1; Thu, 24 Feb 2022 04:00:51 -0500
X-MC-Unique: yvmukoBqMxihyMhLaco2yQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EC461091DA1;
        Thu, 24 Feb 2022 09:00:50 +0000 (UTC)
Received: from raketa (unknown [10.40.193.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7211873DAB;
        Thu, 24 Feb 2022 09:00:49 +0000 (UTC)
Date:   Thu, 24 Feb 2022 10:00:46 +0100
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] target: allow changing dbroot if there are no registered
 devices
Message-ID: <20220224090046.GC650728@raketa>
References: <20220107151054.29734-1-mlombard@redhat.com>
 <e77b17da-f3cd-3a89-c46b-67dadae359ed@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e77b17da-f3cd-3a89-c46b-67dadae359ed@oracle.com>
User-Agent: Mutt/1.14.7 (f34d0909) (2020-08-29)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 22, 2022 at 02:57:30PM -0600, Mike Christie wrote:
> On 1/7/22 9:10 AM, Maurizio Lombardi wrote:
> > The target driver prevents the users from changing
> > the database root directory if a target module like ib_srpt has
> > been registered, this makes it difficult for users to
> > set their preferred database directory if the module
> > gets loaded during the system boot.
> > 
> > Let the users modify dbroot if there are no registered devices
> > 
> > Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> > ---
> >  drivers/target/target_core_configfs.c | 20 ++++++++------------
> >  1 file changed, 8 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> > index 023bd4516a68..cba10829e62f 100644
> > --- a/drivers/target/target_core_configfs.c
> > +++ b/drivers/target/target_core_configfs.c
> > @@ -72,6 +72,8 @@ static struct config_group target_core_hbagroup;
> >  static struct config_group alua_group;
> >  static struct config_group alua_lu_gps_group;
> >  
> > +static unsigned int target_devices;
> > +
> >  static inline struct se_hba *
> >  item_to_hba(struct config_item *item)
> >  {
> > @@ -106,38 +108,32 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
> >  	ssize_t read_bytes;
> >  	struct file *fp;
> >  
> > -	mutex_lock(&g_tf_lock);
> > -	if (!list_empty(&g_tf_list)) {
> > -		mutex_unlock(&g_tf_lock);
> > -		pr_err("db_root: cannot be changed: target drivers registered");
> > +	if (target_devices) {
> > +		pr_err("db_root: cannot be changed because it's in use\n");
> >  		return -EINVAL;
> >  	}
> >  
> 
> How does the locking work for this patch?
> 
> The configfs subsys mutex handles the make and drop callouts below.
> 
> For this part though, it didn't look like we are holding the same mutex,
> so can target_devices increase after we've passed that check? If so, was
> the idea that it's one of those things where if it races then it doesn't
> really matter because it's rare and nothing is really hurt?

Thanks for the review, Mike.

There is, indeed, a small window where a race condition is possible;
when "target_devices" is 0, a module gets loaded by the kernel and at the same time a userspace process
writes to dbroot, before the "target_devices" variable gets incremented to 1.

I guess it's extremely rare but maybe it's better to simply add a "target_devices_lock" mutex
to be safe.

Maurizio

