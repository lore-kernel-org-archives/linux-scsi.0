Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E196FC2D0A8
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 08:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 910022388B
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 08:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIWIXL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 04:23:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:43364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbgIWIXK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Sep 2020 04:23:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6335CAE64;
        Wed, 23 Sep 2020 08:23:46 +0000 (UTC)
Subject: Re: [PATCH 1/1] scsi: scsi_dh_alua: do not set h->sdev to NULL before
 removing the list entry
To:     Brian Bunker <brian@purestorage.com>,
        "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-scsi@vger.kernel.org
References: <8239CB66-1836-444D-A230-83714795D5DC@purestorage.com>
 <3b86ce755e3b0b2b3d9e1a2cdf8c48b742f94265.camel@redhat.com>
 <D047536E-9A0E-430D-BD0C-634DC7594033@purestorage.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <be7e6061-5b10-25a7-e8bb-aa4008c04e22@suse.de>
Date:   Wed, 23 Sep 2020 10:23:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <D047536E-9A0E-430D-BD0C-634DC7594033@purestorage.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/19/20 12:07 AM, Brian Bunker wrote:
> Internally we had discussions about adding a synchronize_rcu here:
> 
> --- a/scsi/drivers/scsi/device_handler/scsi_dh_alua.c   2020-09-10 12:29:03.000000000 -0700
> +++ b/scsi/drivers/scsi/device_handler/scsi_dh_alua.c   2020-09-18 14:59:59.000000000 -0700
> @@ -658,8 +658,6 @@
>                                          rcu_read_lock();
>                                          list_for_each_entry_rcu(h,
>                                                  &tmp_pg->dh_list, node) {
> -                                               /* h->sdev should always be valid */
> -                                               BUG_ON(!h->sdev);
>                                                  h->sdev->access_state = desc[0];
>                                          }
>                                          rcu_read_unlock();
> @@ -705,7 +703,6 @@
>                          pg->expiry = 0;
>                          rcu_read_lock();
>                          list_for_each_entry_rcu(h, &pg->dh_list, node) {
> -                               BUG_ON(!h->sdev);
>                                  h->sdev->access_state =
>                                          (pg->state & SCSI_ACCESS_STATE_MASK);
>                                  if (pg->pref)
> @@ -1147,7 +1144,6 @@
>          spin_lock(&h->pg_lock);
>          pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
>          rcu_assign_pointer(h->pg, NULL);
> -       h->sdev = NULL;
>          spin_unlock(&h->pg_lock);
>          if (pg) {
>                  spin_lock_irq(&pg->lock);
> @@ -1156,6 +1152,7 @@
>                  kref_put(&pg->kref, release_port_group);
>          }
>          sdev->handler_data = NULL;
> +       synchronize_rcu();
>          kfree(h);
>   }
> 
> We were thinking that this would allow any running readers to finish before the object is freed. Would
> that make sense there? From what I can tell the only RCU implementation in this kernel version in
> scsi is here, so I couldn’t find many examples to follow.
>   That actually looks quite viable (if the intendation gets fixed :-)
Initially I was thinking of using 'h->sdev = NULL' as a marker for the 
other code to figure out that the device has about to be deleted; that 
worked, but with rather unintended consequences.

Have you tried with your patch?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
