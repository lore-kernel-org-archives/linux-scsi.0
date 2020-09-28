Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5CBC2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 15:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C62221548
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 15:52:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h4W4LjWq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgI1Pw1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 11:52:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726424AbgI1Pw1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Sep 2020 11:52:27 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601308346;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kgXIn4BQsJnN5L6cWcBOBBCKst9r4t6llgxKEXMltS8=;
        b=h4W4LjWqVncoxChqRBMioBMDuPr1LCwcKQnJHujyMAalQTN7RC2xKoxxaBC7PlOoje5uPc
        SgH/D0vZLqt/Hg0iKVRBcgFfda7D3dnu7cE9F2pXvccSaeBJ+lTvLmExgwRlt4DbyRDuJG
        LUUuHBdrcXO7PztnA2LIIhlQWagrVg4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-FSkicAZFOaugcgPTujJ50Q-1; Mon, 28 Sep 2020 11:52:22 -0400
X-MC-Unique: FSkicAZFOaugcgPTujJ50Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 232E5801F9B;
        Mon, 28 Sep 2020 15:52:21 +0000 (UTC)
Received: from [10.10.110.11] (unknown [10.10.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 277EF5D9CC;
        Mon, 28 Sep 2020 15:52:19 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [v5 08/12] Add durable_name_printk
To:     Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-9-tasleson@redhat.com>
 <fbd1b019-04ee-5fda-11c8-95fecf031113@infradead.org>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <0e091001-a260-856c-1e6c-9b6fb7350d26@redhat.com>
Date:   Mon, 28 Sep 2020 10:52:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <fbd1b019-04ee-5fda-11c8-95fecf031113@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/20 6:53 PM, Randy Dunlap wrote:
> I suggest that these 2 new function names should be
> 	printk_durable_name()
> and
> 	printk_durable_name_ratelimited()
> 
> Those names would be closer to the printk* family of
> function names.  Of course, you can find exceptions to this,
> like dev_printk(), but that is in the dev_*() family of
> function names.

durable_name_printk has the same argument signature as dev_printk with
it's intention that in the future it might be a candidate to get changed
to dev_printk.  The reason I'm not using dev_printk is to avoid changing
the content of the message users see.

With this clarification, do you still suggest the rename or maybe
suggest something different?

dev_id_printk
id_printk
...

I'm also thinking that maybe we should add a new function do everything
dev_printk does, but without prepending the device driver name and
device name to the message.  So we can get the metadata adds without
having the content of the message change.

Thanks

