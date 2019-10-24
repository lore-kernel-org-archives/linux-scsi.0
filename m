Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA63CA9EBB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 08:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2184621872
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 08:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438414AbfJXIvk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 04:51:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:52510 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730621AbfJXIvk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 04:51:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 571B6B6A6;
        Thu, 24 Oct 2019 08:51:38 +0000 (UTC)
Date:   Thu, 24 Oct 2019 10:51:36 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] scsi: sr: wait for the medium to become ready
Message-ID: <20191024085136.GG938@kitsune.suse.cz>
References: <cover.1571834862.git.msuchanek@suse.de>
 <94dc98dc67b1d183d04c338c7978efa0556db6ac.1571834862.git.msuchanek@suse.de>
 <20191024022406.GD11485@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024022406.GD11485@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 23, 2019 at 07:24:06PM -0700, Christoph Hellwig wrote:
> On Wed, Oct 23, 2019 at 02:52:47PM +0200, Michal Suchanek wrote:
> > +static int sr_block_open_finish(struct block_device *bdev, fmode_t mode,
> > +				int ret)
> > +{
> > +	struct scsi_cd *cd = scsi_cd(bdev->bd_disk);
> > +
> > +	/* wait for drive to get ready */
> > +	if ((ret == -ENOMEDIUM) && !(mode & FMODE_NDELAY)) {
> > +		struct scsi_device *sdev = cd->device;
> > +		/*
> > +		 * Cannot use sr_block_ioctl because it locks sr_mutex blocking
> > +		 * out any processes trying to access the drive
> > +		 */
> > +		scsi_autopm_get_device(sdev);
> > +		cdrom_ioctl(&cd->cdi, bdev, mode, CDROM_AUTOCLOSE, 0);
> > +		ret = __sr_block_open(bdev, mode);
> > +		scsi_autopm_put_device(sdev);
> 
> Ioctls should never be used from kernel space.  We have a few leftovers,
> but we need to get rid of that and not add more.

What is the alternative?

Thanks

Michal
