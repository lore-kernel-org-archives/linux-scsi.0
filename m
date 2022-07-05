Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB032C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jul 2022 02:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbiGECk6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 22:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiGECk5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 22:40:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B402D12777
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jul 2022 19:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656988855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BnElx8bgyO5j9beFN9Jv8oMNQgtkuvVuSTj8uQN6AKU=;
        b=Hl7yyCD44pAhpwM738HVAw11eG6sG2uea4QjTsMOCfx+5NGXG2BPY3skHh5NFYXZY2QZw1
        VNZrhGZGKoV0ve2IylA2A3OuKgctuGvW/3yy7v6yjlaAZKtiZ//YCN5XnCvp6XebatohCo
        9NbLLgH7IiESU46dWC+1nd7yOCBaZWM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-h3oIwTOJN9uosovAqqqcpA-1; Mon, 04 Jul 2022 22:40:52 -0400
X-MC-Unique: h3oIwTOJN9uosovAqqqcpA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F8D18727BC;
        Tue,  5 Jul 2022 02:40:52 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA78B40CF8EB;
        Tue,  5 Jul 2022 02:40:47 +0000 (UTC)
Date:   Tue, 5 Jul 2022 10:40:42 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 1/3] scsi: Simplify scsi_forget_host()
Message-ID: <YsOkqu8nuQ311eNm@T590>
References: <20220630213733.17689-1-bvanassche@acm.org>
 <20220630213733.17689-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630213733.17689-2-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 30, 2022 at 02:37:31PM -0700, Bart Van Assche wrote:
> scsi_forget_host() has only one caller, namely scsi_remove_host(). That
> function may sleep. Additionally, scsi_forget_host() calls a function
> that may sleep (__scsi_remove_device()). Simplify scsi_forget_host() by
> removing support for saving and restoring the interrupt state.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming

