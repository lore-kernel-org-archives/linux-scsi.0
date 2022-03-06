Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8DFC433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 03:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiCFDmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Mar 2022 22:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiCFDmW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2022 22:42:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7837E2AE37
        for <linux-scsi@vger.kernel.org>; Sat,  5 Mar 2022 19:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646538090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XXlGSXVmynJV+V8oFLfC1k+jVEqFHszdBNk7MqMn16I=;
        b=cLY5tgEBYyQ2Mp1dU5JeMzWI7hLG9E9sU4btop1a6mEuSGA7G+/JXoKfniTcL8satbSE8U
        Xb47s65nrQJapClanld8Ldg6BOfIQ+WtVXjOcyyZILfMrXV5R0BZM+atXKsynV6FlxpmHH
        mfRqYjTjTt9kR0R72hBkJgJWZapQwxQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-esWYfbCmPYiRbFk23JLU7g-1; Sat, 05 Mar 2022 22:41:27 -0500
X-MC-Unique: esWYfbCmPYiRbFk23JLU7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B0881800D50;
        Sun,  6 Mar 2022 03:41:26 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 427FA6A4B7;
        Sun,  6 Mar 2022 03:41:10 +0000 (UTC)
Date:   Sun, 6 Mar 2022 11:41:05 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 06/14] sd: delay calling free_opal_dev
Message-ID: <YiQtUYIRH6Y2auOD@T590>
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304160331.399757-7-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 04, 2022 at 05:03:23PM +0100, Christoph Hellwig wrote:
> Call free_opal_dev from scsi_disk_release as the opal_dev field is access
> from the ioctl handler, which isn't synchronized vs sd_release and thus
> can be accesses during or after sd_release was called.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

