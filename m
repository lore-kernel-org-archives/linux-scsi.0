Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E31DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 14:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDBCD64E7C
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 14:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhBJO05 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Feb 2021 09:26:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231626AbhBJO0z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Feb 2021 09:26:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612967128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AjqdGl9gBCtzXZ4MgSNybS3a2eF3BdoT/sWONctal1Y=;
        b=YFGsYSSA0+aGtmx2ulVzpOvQAifiel20lS9tOs5r/KZYHJFTcumnABX1nTDrlJiYeRwmS5
        2VSMN5GyUH2PDrGDUdW1wWoue6HSH38kVLi70hRxBQWXIHny4FJ4fSX4YDIWsFpJ/H+V96
        Eq+QF7lDir1cJXuq3m2aYDsFqB7f4QQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-sSPm8nNONQuxBKqIdo5gyA-1; Wed, 10 Feb 2021 09:25:26 -0500
X-MC-Unique: sSPm8nNONQuxBKqIdo5gyA-1
Received: by mail-qv1-f72.google.com with SMTP id p30so1440268qva.13
        for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2021 06:25:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AjqdGl9gBCtzXZ4MgSNybS3a2eF3BdoT/sWONctal1Y=;
        b=N7RojWKNCotxmEZQV4YM1352mpFu6VyF7nH747C4oe7k9uJxp4QkWllZgvZGBdqHH0
         1QXJ95Ej58yuPhUeucmfay7OXBxhaY8ZQpQNEZ4Fiods0BSJ6jXYexa3QVAfmy6K7pIQ
         J3cUcBXkSO5hsRw4HMv4gcQxZpMeKgxI9/+hkGe5lhU3ot+xEiz+1zSA8kUGoXBgqxkW
         2rNKAcOe+L3/nQ5IEHvl1oEGkRt0kWYH1MDSVZj80/WRt1TGAvhsLD4lqMQ5Qv6wd6LF
         pugOS6G65yhoAjvGVeY6+YMe+rL9mQ8t+ZgVnwSOCZXnQAgY8ybn9X7+DQENfgiDg48H
         flAw==
X-Gm-Message-State: AOAM5310QmP9eJH0v7HwwWjr1pUW0nlUyG1D0+wVc3p6JKekCH9HYW+W
        qFAQLHDQnb+Ch9n1npbE+fgDyuIB8hd1JPypM0WPns3akWgQCDiKqFl8lcNu/vt2u28y8hUcdVE
        Qws8I11fje7V2NPcRnjrdIA==
X-Received: by 2002:a05:620a:9cf:: with SMTP id y15mr3510300qky.44.1612967126191;
        Wed, 10 Feb 2021 06:25:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7JkAwZ6eyRiwDMr8CAX5LfuNBYjtuaKgz+zlOU/JKZLXd+KP3cqaHVb8JoNaeNXiG07pxJw==
X-Received: by 2002:a05:620a:9cf:: with SMTP id y15mr3510272qky.44.1612967125918;
        Wed, 10 Feb 2021 06:25:25 -0800 (PST)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id p188sm1520751qkf.89.2021.02.10.06.25.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Feb 2021 06:25:25 -0800 (PST)
Message-ID: <f11dbbf675281cacd80044cb8600bd3ba6684dc2.camel@redhat.com>
Subject: Re: [PATCH 13/13] target: flush submission work during TMR
 processing
From:   Laurence Oberman <loberman@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya.Kulkarni@wdc.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Date:   Wed, 10 Feb 2021 09:25:23 -0500
In-Reply-To: <679c61cf1dad2848edac6f7d6490ad6587f0ada3.camel@redhat.com>
References: <20210209123845.4856-1-michael.christie@oracle.com>
         <20210209123845.4856-14-michael.christie@oracle.com>
         <679c61cf1dad2848edac6f7d6490ad6587f0ada3.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-02-09 at 09:31 -0500, Laurence Oberman wrote:
> On Tue, 2021-02-09 at 06:38 -0600, Mike Christie wrote:
> > If a cmd is on the submission workqueue then the TMR code will
> > miss it, and end up returning task not found or success for
> > lun resets. The fabric driver might then tell the initiator that
> > the running cmds have been handled when they are about to run.
> > 
> > This adds a cancel when we are processing TMRs.
> > 
> > Signed-off-by: Mike Christie <michael.christie@oracle.com>
> > ---
> >  drivers/target/target_core_tmr.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/target/target_core_tmr.c
> > b/drivers/target/target_core_tmr.c
> > index 7347285471fa..9b7f159f9341 100644
> > --- a/drivers/target/target_core_tmr.c
> > +++ b/drivers/target/target_core_tmr.c
> > @@ -124,6 +124,8 @@ void core_tmr_abort_task(
> >  	int i;
> >  
> >  	for (i = 0; i < dev->queue_cnt; i++) {
> > +		cancel_work_sync(&dev->queues[i].sq.work);
> > +
> >  		spin_lock_irqsave(&dev->queues[i].lock, flags);
> >  		list_for_each_entry_safe(se_cmd, next, &dev-
> > > queues[i].state_list,
> > 
> >  					 state_list) {
> > @@ -302,6 +304,8 @@ static void core_tmr_drain_state_list(
> >  	 * in the Control Mode Page.
> >  	 */
> >  	for (i = 0; i < dev->queue_cnt; i++) {
> > +		cancel_work_sync(&dev->queues[i].sq.work);
> > +
> >  		spin_lock_irqsave(&dev->queues[i].lock, flags);
> >  		list_for_each_entry_safe(cmd, next, &dev-
> > > queues[i].state_list,
> > 
> >  	
> 
> 
> > 				 state_list) {
> 
> Hello Mike
> Thanks for these
> This one in particular is the one that I think will help our case. I
> will pull all of these and test later this week as a bundle.
> 
> Many Thanks
> Laurence Oberman
> 

I pulled v2 and built a test kernel to start the testing but I see
Christoph has also suggested changes as well to your v3 submission.

I will wait until we are finalized and then do a full test.

Thanks
Laurence

