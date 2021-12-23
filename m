Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D1DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 09:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347322AbhLWJQ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Dec 2021 04:16:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40672 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239245AbhLWJQ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Dec 2021 04:16:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640250985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H3H+Pshbv7wPFLDR7QeUOyCcf8SkUa9Vqv2/m7raWkg=;
        b=CuLRs8Qb9ZM3Zv+Lu+YdutCDQPv8CU1gB6t6XxirBjJxClh59EWqyu/rFL/GXbLW57Fn/3
        nYgOBaJ2dxqJy6LvHk/piyNwNPY9gqdP/GokqqXcyeprQDcw3C2no/WFKQI2xj8fLmodIi
        /XWAqf2c2yp1V7qo5VnPe4ISuCZLCHE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-kvgh8CWROwmND58y_h4EKQ-1; Thu, 23 Dec 2021 04:16:24 -0500
X-MC-Unique: kvgh8CWROwmND58y_h4EKQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA13F1006AA7;
        Thu, 23 Dec 2021 09:16:22 +0000 (UTC)
Received: from localhost (ovpn-13-77.pek2.redhat.com [10.72.13.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0703D67847;
        Thu, 23 Dec 2021 09:16:17 +0000 (UTC)
Date:   Thu, 23 Dec 2021 17:16:15 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] sr: don't use GFP_DMA
Message-ID: <20211223091615.GC10050@MiWiFi-R3L-srv>
References: <20211222090842.920724-1-hch@lst.de>
 <20211222093707.GA23698@MiWiFi-R3L-srv>
 <20211222094216.GA28018@lst.de>
 <20211222104046.GB23698@MiWiFi-R3L-srv>
 <20211223090137.GB7555@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223090137.GB7555@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/23/21 at 10:01am, Christoph Hellwig wrote:
> On Wed, Dec 22, 2021 at 06:40:46PM +0800, Baoquan He wrote:
> > Any thought or plan for those callsites in other places? Possibly we can
> > skip those s390 related drivers since s390 only has DMA zone, no DMA32,
> > it should be OK.
> 
> Yes, this needs a bit of an audit.  A lot of them might be best handled
> by the subsysem maintainers, e.g. for crypto media and sound.

Yes, agree. I can send a mail to subsystem maintainers about this, ask
them for help.

> 
> > And could you please also add me to CC when send out these patches? We
> > have this problem in our RHEL8 which is based on kernel4.18, if finally
> > removing dma-kmalloc(), we need back port these driver fixes too. If
> > not paying attention, these patches may scatter in different
> > sub-components and unnoticable.
> 
> I already sent them out yesterday.  Just look for everything with
> GFP_DMA in the subject line in the current scsi tree for 5.17.

Got, thx.

