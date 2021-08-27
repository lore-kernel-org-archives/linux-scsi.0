Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DA4C432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 18:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B99660E73
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 18:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhH0S4b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 14:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbhH0S4b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 14:56:31 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C44EC061757;
        Fri, 27 Aug 2021 11:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=29EMebI8fVZxvSV7znbN64wsv6+EiNoWIskTvZ79R/I=; b=zlFo3gJSSk9TErlt5pKfkCDZ9R
        AJL9XJkGVu1dNyQjPC6KhYgdRT6BPlnoAQQoC2uDUW9BPjEJslyXyQi0ckfY4xJjyRE+9FAkKRbXi
        vCGwC44tNE5qZaYMt1Hf1DwDBldJXTpxAjfN3w63Lb8tv84kK+6VP46hnZdkJm1vLzdNztgU4lHfJ
        O014zdxZ3PuBrtYH+OHCI/2G6xOc1SM0EYMDUWFHTyp64gLizYxYsSkwtZK2LG4ERPuXbNNPAA7Fo
        Vz+JcjoSbCdh12r2Os8ua9os5AQ2SaVqCICNJim0Cjph8UBOCeIGzn3ZbXDzPxC9aEhm4OhaxEwNl
        5Yg7APZw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJh0U-00CzW8-NG; Fri, 27 Aug 2021 18:55:14 +0000
Date:   Fri, 27 Aug 2021 11:55:14 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com, hare@suse.de, bvanassche@acm.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-mmc@vger.kernel.org,
        dm-devel@redhat.com, nbd@other.debian.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] dm: add add_disk() error handling
Message-ID: <YSk1EhUIr9OjIoVv@bombadil.infradead.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
 <20210823202930.137278-9-mcgrof@kernel.org>
 <YSSP6ujNQttGN2sZ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSSP6ujNQttGN2sZ@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 24, 2021 at 07:21:30AM +0100, Christoph Hellwig wrote:
> On Mon, Aug 23, 2021 at 01:29:28PM -0700, Luis Chamberlain wrote:
> > -	add_disk(md->disk);
> > +	r = add_disk(md->disk);
> > +	if (r)
> > +		goto out_cleanup_disk;
> >  
> >  	r = dm_sysfs_init(md);
> > -	if (r) {
> > -		del_gendisk(md->disk);
> > -		return r;
> > -	}
> > +	if (r)
> > +		goto out_del_gendisk;
> >  	md->type = type;
> >  	return 0;
> > +
> > +out_cleanup_disk:
> > +	blk_cleanup_disk(md->disk);
> > +out_del_gendisk:
> > +	del_gendisk(md->disk);
> > +	return r;
> 
> I think the add_disk should just return r.  If you look at the
> callers they eventualy end up in dm_table_destroy, which does
> this cleanup.

I don't see it. What part of dm_table_destroy() does this?

  Luis
