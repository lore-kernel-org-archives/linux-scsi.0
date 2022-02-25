Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270B0C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 09:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbiBYJNd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Feb 2022 04:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbiBYJNc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2022 04:13:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40BBB17B0D5
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 01:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645780380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5x1l60kOJzalIbidbr6kbs5D9dFUyUJTKOBS5WSBmqI=;
        b=GkheSXLCi6H2+oJ6+QJsN8tRBH1dCbA3zdHJDXRz3ktIzOSp/J5sL+XT50pSw9HtOlyam2
        49CCbLlwrCVFvR4RwT2JNZWGaXe6o7BmsYKnztSa2Jx4aC4+EldmbQ0szA67Q6sVZQ4sv4
        ACJzXXXpi7NULZIMz9CohGoj+qHf0jc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-TNa3oj-LMGKC9XopOpGK-Q-1; Fri, 25 Feb 2022 04:12:56 -0500
X-MC-Unique: TNa3oj-LMGKC9XopOpGK-Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1E561854E27;
        Fri, 25 Feb 2022 09:12:52 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D26B1006870;
        Fri, 25 Feb 2022 09:12:33 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 21P9CW8f021225;
        Fri, 25 Feb 2022 04:12:32 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 21P9CVVN021221;
        Fri, 25 Feb 2022 04:12:31 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Fri, 25 Feb 2022 04:12:31 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Nitesh Shetty <nj.shetty@samsung.com>
cc:     javier@javigon.com, chaitanyak@nvidia.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        msnitzer@redhat.com, bvanassche@acm.org,
        martin.petersen@oracle.com, roland@purestorage.com, hare@suse.de,
        kbusch@kernel.org, hch@lst.de, Frederick.Knight@netapp.com,
        zach.brown@ni.com, osandov@fb.com,
        lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
        josef@toxicpanda.com, clm@fb.com, dsterba@suse.com, tytso@mit.edu,
        jack@suse.com, joshi.k@samsung.com, arnav.dawn@samsung.com
Subject: Re: [PATCH v2 08/10] dm: Add support for copy offload.
In-Reply-To: <20220224124213.GD9117@test-zns>
Message-ID: <alpine.LRH.2.02.2202250410210.20694@file01.intranet.prod.int.rdu2.redhat.com>
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com> <20220207141348.4235-1-nj.shetty@samsung.com> <CGME20220207141948epcas5p4534f6bdc5a1e2e676d7d09c04f8b4a5b@epcas5p4.samsung.com> <20220207141348.4235-9-nj.shetty@samsung.com>
 <alpine.LRH.2.02.2202160845210.22021@file01.intranet.prod.int.rdu2.redhat.com> <20220224124213.GD9117@test-zns>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On Thu, 24 Feb 2022, Nitesh Shetty wrote:

> On Wed, Feb 16, 2022 at 08:51:08AM -0500, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 7 Feb 2022, Nitesh Shetty wrote:
> > 
> > > Before enabling copy for dm target, check if underlaying devices and
> > > dm target support copy. Avoid split happening inside dm target.
> > > Fail early if the request needs split, currently spliting copy
> > > request is not supported
> > > 
> > > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > 
> > If a dm device is reconfigured, you must invalidate all the copy tokens 
> > that are in flight, otherwise they would copy stale data.
> > 
> > I suggest that you create a global variable "atomic64_t dm_changed".
> > In nvme_setup_copy_read you copy this variable to the token.
> > In nvme_setup_copy_write you compare the variable with the value in the 
> > token and fail if there is mismatch.
> > In dm.c:__bind you increase the variable, so that all the tokens will be 
> > invalidated if a dm table is changed.
> > 
> > Mikulas
> > 
> >
> Yes, you are right about the reconfiguration of dm device. But wouldn't having a
> single global counter(dm_changed), will invalidate for all in-flight copy IO's
> across all dm devices. Is my understanding correct?
> 
> --
> Nitesh Shetty

Yes, changing it will invalidate all the copy IO's.

But invalidating only IO's affected by the table reload would be hard to 
achieve.

Mikulas

