Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94BC0C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 01:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbiBYB1K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 20:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiBYB1J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 20:27:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58C812A242
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 17:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645752396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vCrSy1F8FHE6O560DwWYvCoiDmwrzZEbs3aTWefJIqw=;
        b=HeQC+sJsPPeOdMm36fsplLPZYD6H8vJRdjnggWWwWMqln6Wq7n4VNU9B/BDzhowlqFANaf
        ZljxvraWxgwzDqxZCd8JpMaddatn0udLjihQOdhnN7EBpsoTUDnYspENfLhIJujW9TVcuo
        FufY0QkvFXtQLGeVkzoO3RAYTU/jBl4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-F4IA_XPaM12b0pXzURznOQ-1; Thu, 24 Feb 2022 20:26:35 -0500
X-MC-Unique: F4IA_XPaM12b0pXzURznOQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A72F800425;
        Fri, 25 Feb 2022 01:26:34 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E69B18038;
        Fri, 25 Feb 2022 01:26:18 +0000 (UTC)
Date:   Fri, 25 Feb 2022 09:26:13 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 10/12] block: move blk_exit_queue into disk_release
Message-ID: <YhgwNQINruckF71D@T590>
References: <20220222141450.591193-1-hch@lst.de>
 <20220222141450.591193-11-hch@lst.de>
 <4b9a4121-7f37-9bd3-036a-51892a456eef@acm.org>
 <YhXapc7fuhb8mlwW@T590>
 <d2cbbf56-6984-fc54-9eb4-2142a69c379a@acm.org>
 <20220224072524.GA21228@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224072524.GA21228@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 24, 2022 at 08:25:24AM +0100, Christoph Hellwig wrote:
> On Wed, Feb 23, 2022 at 12:04:03PM -0800, Bart Van Assche wrote:
> > On 2/22/22 22:56, Ming Lei wrote:
> >> But I admit here the name of blk_mq_release_queue() is very misleading,
> >> maybe blk_mq_release_io_queue() is better?
> >
> > I'm not sure what the best name for that function would be. Anyway, thanks 
> > for having clarified that disk structures are removed before the request 
> > queue is cleaned up. That's something I was missing.
> 
> Maybe disk_release_mq?

disk_release_mq() looks much better.

Thanks,
Ming

