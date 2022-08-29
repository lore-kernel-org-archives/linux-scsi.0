Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581A8C0502A
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 01:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiH2BSo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Aug 2022 21:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiH2BSn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Aug 2022 21:18:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653C8240BD
        for <linux-scsi@vger.kernel.org>; Sun, 28 Aug 2022 18:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661735921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SILNoysU57nRIgu7CwBNk87+lVs7jacUj3SkNj8ld20=;
        b=aOdevCbCADGQTg7DeMgnNYE1nW3J77rRQfVVdn+P0aP+ecSzBfXOWa24ODEzEzD1T/G6GG
        g3h/BmRcIlmwpONxC9oZ9bBF6FU4jLvdQXjO4Z3R1Uwi/kOptCbMyMjDPpZNLEm/rIce+F
        LnegTiJn+nVTm1X29T7R16hfM1oW8II=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-wJwpEAkUOT-oAtLWUx2L5w-1; Sun, 28 Aug 2022 21:18:38 -0400
X-MC-Unique: wJwpEAkUOT-oAtLWUx2L5w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65586380670E;
        Mon, 29 Aug 2022 01:18:37 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F26DC945D0;
        Mon, 29 Aug 2022 01:18:31 +0000 (UTC)
Date:   Mon, 29 Aug 2022 09:18:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Li Zhijian <lizhijian@fujitsu.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: Fix a use-after-free
Message-ID: <YwwT5BC+s0VHT5UK@T590>
References: <20220826002635.919423-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826002635.919423-1-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 25, 2022 at 05:26:34PM -0700, Bart Van Assche wrote:
> There are two .exit_cmd_priv implementations. Both implementations use
> resources associated with the SCSI host. Make sure that these resources are
> still available when .exit_cmd_priv is called by waiting inside
> scsi_remove_host() until the tag set has been freed.
> 
> This patch fixes the following use-after-free:
> 
> ==================================================================
> BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
> Read of size 8 at addr ffff888100337000 by task multipathd/16727
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x34/0x44
>  print_report.cold+0x5e/0x5db
>  kasan_report+0xab/0x120
>  srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
>  scsi_mq_exit_request+0x4d/0x70
>  blk_mq_free_rqs+0x143/0x410
>  __blk_mq_free_map_and_rqs+0x6e/0x100
>  blk_mq_free_tag_set+0x2b/0x160
>  scsi_host_dev_release+0xf3/0x1a0

The trace must be triggered on old kernel, cause this issue is fixed by
upstream since commit f323896fe6fa ("scsi: core: Call blk_mq_free_tag_set() earlier")
from you, :-)


Thanks,
Ming

