Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E146C77B71
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 04:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjDREia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 00:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjDREi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 00:38:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5D21FDB
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 21:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681792662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fHKQLrUOv4YDcHSkBRCqb5MnMkCw69N+ASl7/Tq5a2g=;
        b=hOknPr1fxyShR9oQVPaAg6VB8Juc2Y7ptcsHgpWSK/XfAxX9+/dgN559HMzuPe5jNeHdVc
        fq761pApjG69Mrmf4uiB/y6hBusmSZS+zIodw6dq6dhOpcewYZOjINBmzVqSIEcm6hB9GC
        OmI/uM8tb0r8+k+IKruoqiQ3IcFzKaM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-RONNxtoUMgufmBzdspPAsg-1; Tue, 18 Apr 2023 00:37:39 -0400
X-MC-Unique: RONNxtoUMgufmBzdspPAsg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C163785A5A3;
        Tue, 18 Apr 2023 04:37:38 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B57B2C15BA0;
        Tue, 18 Apr 2023 04:37:31 +0000 (UTC)
Date:   Tue, 18 Apr 2023 12:37:26 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>, ming.lei@redhat.com
Subject: Re: [PATCH v2 1/4] scsi: sd: Let sd_shutdown() fail future I/O
Message-ID: <ZD4ehvYdkxmESFNB@ovpn-8-16.pek2.redhat.com>
References: <20230417230656.523826-1-bvanassche@acm.org>
 <20230417230656.523826-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417230656.523826-2-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 17, 2023 at 04:06:53PM -0700, Bart Van Assche wrote:
> System shutdown happens as follows (see e.g. the systemd source file
> src/shutdown/shutdown.c):
> * sync() is called.
> * reboot(RB_AUTOBOOT/RB_HALT_SYSTEM/RB_POWER_OFF) is called.
> * If the reboot() system call returns, log an error message.
> 
> The reboot() system call causes the kernel to call kernel_restart(),
> kernel_halt() or kernel_power_off(). Each of these functions calls
> device_shutdown(). device_shutdown() calls sd_shutdown(). After
> sd_shutdown() has been called the .shutdown() callback of the LLD
> will be called. Hence, I/O submitted after sd_shutdown() will hang or
> may even cause a kernel crash.
> 
> Let sd_shutdown() fail future I/O such that LLD .shutdown() callbacks
> can be simplified.

Hi Bart,

Last time you mentioned the current way may have kernel panic risk, but
you never explain the panic, can you document the panic in commit log?


Thanks,
Ming

