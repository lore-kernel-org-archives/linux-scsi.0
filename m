Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07496CA9EBC
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 08:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9FB92166E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 08:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731924AbfJXIxc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 04:53:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:53402 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730294AbfJXIxb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 04:53:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B3B83B642;
        Thu, 24 Oct 2019 08:53:29 +0000 (UTC)
Date:   Thu, 24 Oct 2019 10:53:27 +0200
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
Subject: Re: [PATCH v2 7/8] scsi: sr: workaround VMware ESXi cdrom emulation
 bug
Message-ID: <20191024085327.GH938@kitsune.suse.cz>
References: <cover.1571834862.git.msuchanek@suse.de>
 <abf81ec4f8b6139fffc609df519856ff8dc01d0d.1571834862.git.msuchanek@suse.de>
 <20191024022307.GC11485@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024022307.GC11485@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 23, 2019 at 07:23:07PM -0700, Christoph Hellwig wrote:
> On Wed, Oct 23, 2019 at 02:52:46PM +0200, Michal Suchanek wrote:
> > 
> > The drive claims to have a tray and claims to be able to close it.
> > However, the UI has no notion of a tray - when medium is ejected it is
> > dropped in the floor and the user must select a medium again before the
> > drive can be re-loaded.  On the kernel side the tray_move call to close
> > the tray succeeds but the drive state does not change as a result of the
> > call.
> > 
> > The drive does not in fact emulate the tray state. There are two ways to
> > get the medium state. One is the SCSI status:
> 
> Given that this is a buggy software emulation we should not add more
> than 100 lines of kernel code to work around it.  Ask VMware to fix
> their mess instead.

And never hear back from them. Not to mention the installed base of
already buggy servers.

Thanks

Michal
