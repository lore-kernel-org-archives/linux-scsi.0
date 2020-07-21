Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9554C433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 12:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B3A922BEF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 12:56:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H886DmZS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgGUM4D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 08:56:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23611 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727106AbgGUM4C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 08:56:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595336160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gcyS8fcxtufsTHCFEHHMYCv8/G/j17I02uFKGiQeviM=;
        b=H886DmZS/NkxE6VFBLjlX5V8P4jQESCAlcFSwZlz39fVN/Pn7iItzPb5DN9FihvBSPSHvq
        7MV2DdqDWQAyKjrMI4plMOvYq01Byw+k+WoeppgmEQ4p6we9N0CyQ2nCtRLBe5WvLU1vXT
        5Mr6hC1gXE2a4dOqLq2rjJeO7vcBnow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-MY6qAbUXO7O16qVB19jUxQ-1; Tue, 21 Jul 2020 08:55:56 -0400
X-MC-Unique: MY6qAbUXO7O16qVB19jUxQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACA018014D7;
        Tue, 21 Jul 2020 12:55:53 +0000 (UTC)
Received: from fedora-32-enviroment (unknown [10.35.206.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78F657B400;
        Tue, 21 Jul 2020 12:55:38 +0000 (UTC)
Message-ID: <155668af6420a6516ded0e9101e0a47401a928d9.camel@redhat.com>
Subject: Re: [PATCH 09/10] block: scsi: sd: use
 blk_is_valid_logical_block_size
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Keith Busch <kbusch@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        "open list:BLOCK LAYER" <linux-block@vger.kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        "open list:SCSI CDROM DRIVER" <linux-scsi@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ajay Joshi <Ajay.Joshi@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "open list:SONY MEMORYSTICK SUBSYSTEM" <linux-mmc@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Satya Tangirala <satyat@google.com>,
        "open list:NETWORK BLOCK DEVICE (NBD)" <nbd@other.debian.org>,
        Hou Tao <houtao1@huawei.com>, Jens Axboe <axboe@fb.com>,
        "open list:VIRTIO CORE AND NET DRIVERS" 
        <virtualization@lists.linux-foundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alex Dubov <oakad@yahoo.com>
Date:   Tue, 21 Jul 2020 15:55:37 +0300
In-Reply-To: <CY4PR04MB375113B7D781BF2949FE5B33E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
         <20200721105239.8270-10-mlevitsk@redhat.com>
         <CY4PR04MB375113B7D781BF2949FE5B33E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-07-21 at 11:25 +0000, Damien Le Moal wrote:
> On 2020/07/21 19:55, Maxim Levitsky wrote:
> > Use blk_is_valid_logical_block_size instead of hardcoded list
> 
> s/hardcoded list/hardcoded checks./
Done, thanks!

Best regards,
	Maxim Levitsky
> 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  drivers/scsi/sd.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> > 
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index d90fefffe31b7..f012e7397b058 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -2520,10 +2520,7 @@ sd_read_capacity(struct scsi_disk *sdkp,
> > unsigned char *buffer)
> >  			  "assuming 512.\n");
> >  	}
> >  
> > -	if (sector_size != 512 &&
> > -	    sector_size != 1024 &&
> > -	    sector_size != 2048 &&
> > -	    sector_size != 4096) {
> > +	if (!blk_is_valid_logical_block_size(sector_size)) {
> >  		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size
> > %d.\n",
> >  			  sector_size);
> >  		/*
> > 
> 
> With the commit message fixed, looks OK.
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> 

