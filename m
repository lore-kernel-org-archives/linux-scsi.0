Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1092EC10F27
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 06:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC4E82146E
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 06:22:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lWwM3q+w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgCKGWp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 02:22:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49002 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgCKGWo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 02:22:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pf947Sz8KajuMchFemWX1Gjf7sTMlNiajIDEANCcWHc=; b=lWwM3q+wSWfi640WOScA7e/8Ff
        bzpTUf1/fPZx31bOeQW126dE72TeZqb7YX3wbzSYKbh/h51bj9HZiTPzFsemYAGr5daIQMGtzB558
        bBD3oFuz3vrYx1G3GkQ1Bzs/w+3/dUQwnJu6fo/6RbAUcFFIGlSviUGWHH8WWNAWZAoxYA+ubqBdM
        0FNsqU3cBEZ1b+nOigEMUE5KXNeSgwISnCQKu0QqLGxSRvUK+6Dw0N3vRYruheqYFDwjQZnh52qHF
        mE7APR5cTlxmp/a80cO1ifELTyeq//ECkDOMnj/ezFRFhz8S4WGKI7dFyQvA7KMVWnersGOqE5odO
        HYyvXOZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBulA-0001TU-6S; Wed, 11 Mar 2020 06:22:28 +0000
Date:   Tue, 10 Mar 2020 23:22:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     John Garry <john.garry@huawei.com>
Cc:     Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com, hare@suse.de,
        ming.lei@redhat.com, bvanassche@acm.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v2 02/24] scsi: allocate separate queue for reserved
 commands
Message-ID: <20200311062228.GA13522@infradead.org>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
 <1583857550-12049-3-git-send-email-john.garry@huawei.com>
 <20200310183243.GA14549@infradead.org>
 <79cf4341-f2a2-dcc9-be0d-2efc6e83028a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79cf4341-f2a2-dcc9-be0d-2efc6e83028a@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 10, 2020 at 09:08:56PM +0000, John Garry wrote:
> On 10/03/2020 18:32, Christoph Hellwig wrote:
> > On Wed, Mar 11, 2020 at 12:25:28AM +0800, John Garry wrote:
> > > From: Hannes Reinecke <hare@suse.com>
> > > 
> > > Allocate a separate 'reserved_cmd_q' for sending reserved commands.
> > 
> > Why?  Reserved command specifically are not in any way tied to queues.
> > .
> > 
> 
> So the v1 series used a combination of the sdev queue and the per-host
> reserved_cmd_q. Back then you questioned using the sdev queue for virtio
> scsi, and the unconfirmed conclusion was to use a common per-host q. This is
> the best link I can find now:
> 
> https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg83177.html

That was just a question on why virtio uses the per-device tags, which
didn't look like it made any sense.  What I'm worried about here is
mixing up the concept of reserved tags in the tagset, and queues to use
them.  Note that we already have the scsi_get_host_dev to allocate
a scsi_device and thus a request_queue for the host itself.  That seems
like the better interface to use a tag for a host wide command vs
introducing a parallel path.
