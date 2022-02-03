Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66F6C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 20:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241306AbiBCU6i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 15:58:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232119AbiBCU6h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 15:58:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643921916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AYBprK6Yoe2/EUwuhU7qvIGmdVdAlaSjpJ2H1aJGkRk=;
        b=IZBpOxT3841zYh9eBcygUXQTalr9CyPvuDfTlwVtCfbKIoAvnoMh7UdVsxBsCYHW6+291U
        NtsNNQEi5LyQxkDL9dMLVLIgdZyNfbk57pyNOAm9J12WwiA2hVG2Gk9cXIL+SuUy/FHFM1
        DwbzyfyKx2mmukRIg7Tkv1vSc8WLc/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-P1Eoj9VZNiO8RNAFIWFfjw-1; Thu, 03 Feb 2022 15:58:33 -0500
X-MC-Unique: P1Eoj9VZNiO8RNAFIWFfjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F80F1091DA2;
        Thu,  3 Feb 2022 20:58:30 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E196B61093;
        Thu,  3 Feb 2022 20:57:56 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 213Kvu4n017456;
        Thu, 3 Feb 2022 15:57:56 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 213KvtMP017452;
        Thu, 3 Feb 2022 15:57:55 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 3 Feb 2022 15:57:55 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Luis Chamberlain <mcgrof@kernel.org>
cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Vincent Fu <vincent.fu@samsung.com>,
        =?ISO-8859-15?Q?Javier_Gonz=E1lez?= <javier@javigon.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "martin.petersen@oracle.com >> Martin K. Petersen" 
        <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        Hannes Reinecke <hare@suse.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "josef@toxicpanda.com" <josef@toxicpanda.com>,
        "clm@fb.com" <clm@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
        "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.com" <jack@suse.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [RFC PATCH 3/3] nvme: add the "debug" host driver
In-Reply-To: <YfwuQxS79wl8l/a0@bombadil.infradead.org>
Message-ID: <alpine.LRH.2.02.2202031532410.12071@file01.intranet.prod.int.rdu2.redhat.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com> <20220201102122.4okwj2gipjbvuyux@mpHalley-2> <alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com> <CGME20220201183359uscas1p2d7e48dc4cafed3df60c304a06f2323cd@uscas1p2.samsung.com>
 <alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com> <20220202060154.GA120951@bgt-140510-bm01> <20220203160633.rdwovqoxlbr3nu5u@garbanzo> <20220203161534.GA15366@lst.de> <YfwuQxS79wl8l/a0@bombadil.infradead.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On Thu, 3 Feb 2022, Luis Chamberlain wrote:

> On Thu, Feb 03, 2022 at 05:15:34PM +0100, Christoph Hellwig wrote:
> > On Thu, Feb 03, 2022 at 08:06:33AM -0800, Luis Chamberlain wrote:
> > > On Wed, Feb 02, 2022 at 06:01:13AM +0000, Adam Manzanares wrote:
> > > > BTW I think having the target code be able to implement simple copy without 
> > > > moving data over the fabric would be a great way of showing off the command.
> > > 
> > > Do you mean this should be implemented instead as a fabrics backend
> > > instead because fabrics already instantiates and creates a virtual
> > > nvme device? And so this would mean less code?
> > 
> > It would be a lot less code.  In fact I don't think we need any new code
> > at all.  Just using nvme-loop on top of null_blk or brd should be all
> > that is needed.
> 
> Mikulas,
> 
> That begs the question why add this instead of using null_blk with
> nvme-loop?
> 
>   Luis

I think that nvme-debug (the patch 3) doesn't have to be added to the 
kernel.

Nvme-debug was an old student project that was canceled. I used it because 
it was very easy to add copy offload functionality to it - adding this 
capability took just one function with 43 lines of code (nvme_debug_copy).

I don't know if someone is interested in continuing the development of 
nvme-debug. If yes, I can continue the development, if not, we can just 
drop it.

Mikulas

