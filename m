Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7EAEB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jun 2023 19:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjFWTqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jun 2023 15:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjFWTqr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2023 15:46:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB612705
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jun 2023 12:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687549564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S7cXFIATv0cqvFDOdx2Vy9pFsZWT3roW5tnB/9pxEhg=;
        b=f8lfaklo4iZubCG2lE4oRSza2AepzTCjdD6AwSRyl9KfF6aDaT5iT/CukU88Rs+IhO5fZW
        z+vBK3GNCHHqN1dxH1sK0AET4Y+rdKLYlOqFBDUdbgMKVfHupSngOk27WAGsC9tqujUIBG
        luY0mEXkjFyjhc79S2r4JZGb7MYJRxA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-tWsHGO7zMPmi0H68AQg1cg-1; Fri, 23 Jun 2023 15:46:01 -0400
X-MC-Unique: tWsHGO7zMPmi0H68AQg1cg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17FBE29AB435;
        Fri, 23 Jun 2023 19:45:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91DA92166B25;
        Fri, 23 Jun 2023 19:45:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <27fd3750-7b9c-9638-26d8-0df3f0e33b81@oracle.com>
References: <27fd3750-7b9c-9638-26d8-0df3f0e33b81@oracle.com> <20230623114425.2150536-1-dhowells@redhat.com> <20230623114425.2150536-12-dhowells@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Dimitri KRAVTCHUK <dimitri.kravtchuk@oracle.com>
Subject: Re: [PATCH net-next v4 11/15] iscsi: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2611149.1687549556.1@warthog.procyon.org.uk>
Date:   Fri, 23 Jun 2023 20:45:56 +0100
Message-ID: <2611150.1687549556@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Mike Christie <michael.christie@oracle.com> wrote:

> 
> One question on the target part I had is about the TODO above. Is that
> something you were going to do, or is it something you are asking the target
> people to do?

I've got an in-progress patch for that, but it's not the simplest code to
modify.  I'm holding off on completing it till the simpler cleanup is in.  I
might end up having to push the incomplete patch your way to ask for advice on
how to complete it.

David

