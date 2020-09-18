Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9DAEC43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 18:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F313221EC
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 18:41:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QbpKicIQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgIRSlg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 14:41:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726152AbgIRSlg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Sep 2020 14:41:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600454495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I9p+JtuXsQ23wypNujclCplF7cCM4hzfI3iL0PTxMAY=;
        b=QbpKicIQUdG72LNHCvBnVfSDQ6T3fZdHm/jiUH940IXp0F7R5KRxi83y6OYkRY+UXTVEGN
        I/9B+9Gcx6BUfTSGQ6Iy4h3cHzU871wj79TY0dtt1cdhob74LsyysH15q7Ip/Dul2XHqvu
        iqoZHAgCvKAsOJogXShMQJyWOseDrI8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-zY7y-42UP_uZ8dGDg5pdLQ-1; Fri, 18 Sep 2020 14:41:33 -0400
X-MC-Unique: zY7y-42UP_uZ8dGDg5pdLQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51E191007499;
        Fri, 18 Sep 2020 18:41:32 +0000 (UTC)
Received: from ovpn-114-103.phx2.redhat.com (ovpn-114-103.phx2.redhat.com [10.3.114.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0260B68D63;
        Fri, 18 Sep 2020 18:41:31 +0000 (UTC)
Message-ID: <3b86ce755e3b0b2b3d9e1a2cdf8c48b742f94265.camel@redhat.com>
Subject: Re: [PATCH 1/1] scsi: scsi_dh_alua: do not set h->sdev to NULL
 before removing the list entry
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Date:   Fri, 18 Sep 2020 14:41:31 -0400
In-Reply-To: <8239CB66-1836-444D-A230-83714795D5DC@purestorage.com>
References: <8239CB66-1836-444D-A230-83714795D5DC@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-09-11 at 09:21 -0700, Brian Bunker wrote:
> A race exists where the BUG_ON(!h->sdev) will fire if the detach
> device handler
> from one thread runs removing a list entry while another thread is
> trying to
> evaluate the target portal group state.
> 
> Do not set the h->sdev to NULL in the detach device handler. It is
> freed at the
> end of the function any way. Also remove the BUG_ON since the
> condition
> that causes them to fire has been removed.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> ___
> --- a/scsi/drivers/scsi/device_handler/scsi_dh_alua.c   2020-09-10
> 12:29:03.000000000 -0700
> +++ b/scsi/drivers/scsi/device_handler/scsi_dh_alua.c   2020-09-11
> 09:14:15.000000000 -0700
> @@ -658,8 +658,6 @@
>                                         rcu_read_lock();
>                                         list_for_each_entry_rcu(h,
>                                                 &tmp_pg->dh_list,
> node) {
> -                                               /* h->sdev should
> always be valid */
> -                                               BUG_ON(!h->sdev);
>                                                 h->sdev->access_state 
> = desc[0];
>                                         }
>                                         rcu_read_unlock();
> @@ -705,7 +703,6 @@
>                         pg->expiry = 0;
>                         rcu_read_lock();
>                         list_for_each_entry_rcu(h, &pg->dh_list,
> node) {
> -                               BUG_ON(!h->sdev);
>                                 h->sdev->access_state =
>                                         (pg->state &
> SCSI_ACCESS_STATE_MASK);
>                                 if (pg->pref)
> @@ -1147,7 +1144,6 @@
>         spin_lock(&h->pg_lock);
>         pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h-
> >pg_lock));
>         rcu_assign_pointer(h->pg, NULL);
> -       h->sdev = NULL;
>         spin_unlock(&h->pg_lock);
>         if (pg) {
>                 spin_lock_irq(&pg->lock);
> 

We ran this change through fault insertion regression testing and
did not see any new problems.  (Our tests didn't hit the original
bug being fixed here though.)

-Ewan


