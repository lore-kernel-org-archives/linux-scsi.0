Return-Path: <SRS0=Z0Y/=AH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED64C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 13:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 094A520663
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 13:54:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hO8nlTBA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgFZNyU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 09:54:20 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41217 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725864AbgFZNyU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Jun 2020 09:54:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593179659;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAa3Wq/vh65NUIYLyLFHRH17KzUhwrUI7z4a1cwWymE=;
        b=hO8nlTBAkwrWkLGaYHb8Ysi3tLcHMfa7p4fVzhBoDHOeSaXUUzpP0w+vfVY8dL7TFsob2P
        Gnv1uTI27c1HcIkVrBuvqD1daFsuLpPQ106kwGBuGU8CGzU0Gam701ovT7ku8fCsmsufHK
        0lnGTJ6QhHbnqihlkevckK6B4H6PPug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-E2p2rOaZNRKMT0qRNvnU9g-1; Fri, 26 Jun 2020 09:54:15 -0400
X-MC-Unique: E2p2rOaZNRKMT0qRNvnU9g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1CB1BFC8;
        Fri, 26 Jun 2020 13:54:13 +0000 (UTC)
Received: from [10.3.128.20] (unknown [10.3.128.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9FE319C4F;
        Fri, 26 Jun 2020 13:54:12 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [RFC PATCH v3 5/8] ata_dev_printk: Use dev_printk
To:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
References: <20200623191749.115200-1-tasleson@redhat.com>
 <20200623191749.115200-6-tasleson@redhat.com>
 <CGME20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee@eucas1p2.samsung.com>
 <d817c9dd-6852-9233-5f61-1c0bc0f65ca4@samsung.com>
 <33577b4f-6ee1-f054-8853-b61ca800e10a@redhat.com>
 <9e45d126-f1ac-48b9-56c3-ec0686e38503@samsung.com>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <780b9a02-eca6-6e53-638a-a9638425a863@redhat.com>
Date:   Fri, 26 Jun 2020 08:54:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <9e45d126-f1ac-48b9-56c3-ec0686e38503@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/26/20 7:45 AM, Bartlomiej Zolnierkiewicz wrote:
> Of course I agree that having a persistent identifier associated to
> storage related log messages is useful and my previous mail was exactly
> a part of discussion on the best way to achieving it. :-)
> 
> I agree with James that dev_printk() usage is preferred over legacy
> printk_emit() and I've described a way to do it correctly for libata.
> 
> Unfortunately it means additional work for getting the new feature 
> merged so if you don't agree with doing it you need to convince:
> 
> - Jens (libata Maintainer) to accept libata patch as it is
> 
> or
> 
> - James (& other higher level Maintainers) to use printk_emit() instead
> 
> Ultimately they will be the ones merging/long-term supporting proposed
> patches and not me..

Thank you for the helpful response, I appreciate it.  I'll take a look
at the information you've provided and re-work the patch series.  I may
have additional question(s) :-)

-Tony

