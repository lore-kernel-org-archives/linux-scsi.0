Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39C4C3F2D1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 22:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 942692465D
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 22:31:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G2AAUNKa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgCBWbD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 17:31:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46647 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726744AbgCBWbD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2020 17:31:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583188261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CJjqNA8tOYmC+7R/XNamwWzSJg06o+3wRLZXtY2DtaU=;
        b=G2AAUNKavEU40F7965vmUc0kVUSxJylMR2T2mCewT5hwiAJTEYqOQTc5AzZlE1CEKZmFJs
        rEfFKSK2cpzaz/vS0oUMMtfslrTZk0nIJ4dnYXjoIFylog84MU36Hp65UK+ZSioNVFyx0c
        OgV4lUGZNYgM2SYqb6iEJBhFwu3eZKU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-gpNEPLfTNZWfZH67bIKExw-1; Mon, 02 Mar 2020 17:30:58 -0500
X-MC-Unique: gpNEPLfTNZWfZH67bIKExw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A08AB100550E;
        Mon,  2 Mar 2020 22:30:56 +0000 (UTC)
Received: from ming.t460p (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DFA3B5C1D6;
        Mon,  2 Mar 2020 22:30:47 +0000 (UTC)
Date:   Tue, 3 Mar 2020 06:30:40 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     John Garry <john.garry@huawei.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH] scsi: avoid to fetch scsi host template instance in IO
 path
Message-ID: <20200302223040.GD13940@ming.t460p>
References: <20200228093346.31213-1-ming.lei@redhat.com>
 <f23daab7-7aa0-1c34-8137-7abead09016c@huawei.com>
 <20200302131541.GA13265@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302131541.GA13265@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 02, 2020 at 02:15:41PM +0100, Christoph Hellwig wrote:
> On Mon, Mar 02, 2020 at 10:58:55AM +0000, John Garry wrote:
> > On 28/02/2020 09:33, Ming Lei wrote:
> >> scsi host template struct is quite big, and the following three
> >> fields are needed in SCSI IO path:
> >>
> >> - queuecommand
> >> - commit_rqs
> >> - cmd_size
> >
> > Would it have been nearly as good to reorganise Scsi host template 
> > structure to ensure that these are adjacent?
> >
> > I say nearly, as it avoids the shost->hostt read.
> 
> That would be worth trying.  Replicating function pointers out of
> read-only data structures generally isn't a very good idea.
>

OK, I will try to re-organize host template and see if it can reach
same performance, but it still introduces one extra fetch in IO path.

BTW, we replicate function pointer in blk-mq too, such as q->mq_ops.

Thanks,
Ming

