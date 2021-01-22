Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F644C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 02:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3C6F2388E
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 02:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbhAVCkA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 21:40:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24988 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726757AbhAVCj6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 21:39:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611283111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ynBiPQyFtjxmGrlqsgxzUnk3SZ6Vu8Uj0TI8ZD9tXiQ=;
        b=UA/sMYrLBigHVFIfJ6HgJAMjoUEKEqbSOvIWdWPyXR6/oRJwa6CQhgZp+8nkeoeW6fRaaR
        V+5yifH9iy7mpjxQMiSWw10PbW9kqwKCABtj0YjBPX5pXBJayuB5R56BaElMS/txVFZwuL
        dfdSQrrf596ITylfCnVkMO0mpwH+BxQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-02K8jM1kN6uoVTJZJwDeCw-1; Thu, 21 Jan 2021 21:38:27 -0500
X-MC-Unique: 02K8jM1kN6uoVTJZJwDeCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F4051922960;
        Fri, 22 Jan 2021 02:38:25 +0000 (UTC)
Received: from T590 (ovpn-13-11.pek2.redhat.com [10.72.13.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C11B65C8A7;
        Fri, 22 Jan 2021 02:38:14 +0000 (UTC)
Date:   Fri, 22 Jan 2021 10:38:10 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V6 02/13] sbitmap: maintain allocation round_robin in
 sbitmap
Message-ID: <20210122023810.GA509982@T590>
References: <20210118004921.202545-3-ming.lei@redhat.com>
 <202101181225.2uTanVzh-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202101181225.2uTanVzh-lkp@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 18, 2021 at 12:42:07PM +0800, kernel test robot wrote:
> Hi Ming,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on mkp-scsi/for-next]
> [also build test ERROR on scsi/for-next block/for-next v5.11-rc4 next-20210115]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Ming-Lei/blk-mq-scsi-tracking-device-queue-depth-via-sbitmap/20210118-085444
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
> config: powerpc-randconfig-r001-20210118 (attached as .config)
> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 95d146182fdf2315e74943b93fb3bb0cbafc5d89)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install powerpc cross compiling tool for clang build
>         # apt-get install binutils-powerpc-linux-gnu
>         # https://github.com/0day-ci/linux/commit/16943bc0fa2683fd8d8554745fffe62394a42ec9
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Ming-Lei/blk-mq-scsi-tracking-device-queue-depth-via-sbitmap/20210118-085444
>         git checkout 16943bc0fa2683fd8d8554745fffe62394a42ec9
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=powerpc 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/vhost/scsi.c:617:40: error: too many arguments to function call, expected 2, have 3
>            tag = sbitmap_get(&svq->scsi_tags, 0, false);
>                  ~~~~~~~~~~~                     ^~~~~
>    include/linux/sbitmap.h:185:5: note: 'sbitmap_get' declared here
>    int sbitmap_get(struct sbitmap *sb, unsigned int alloc_hint);
>        ^
> >> drivers/vhost/scsi.c:1515:22: error: too few arguments to function call, expected 6, have 5
>                                  NUMA_NO_NODE))
>                                              ^
>    include/linux/sbitmap.h:153:5: note: 'sbitmap_init_node' declared here
>    int sbitmap_init_node(struct sbitmap *sb, unsigned int depth, int shift,
>        ^
>    2 errors generated.
> 

Thanks for the report, and this failure has been fixed in V7.



-- 
Ming

