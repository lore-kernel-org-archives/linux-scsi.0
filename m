Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AB4C2D0E4
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 02:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E687520DD4
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 02:35:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dL2R1+5g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgKRCf2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 21:35:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28090 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725779AbgKRCf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 21:35:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605666927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JFrTcci2wlaeLdIrVz8jfx8+3B+YgQbI/x5TyyUOtds=;
        b=dL2R1+5gXa3h1bfc+IleEAcqLmXanRC8+GaxGWO/zCrJqnwlgMXPMkM0t7i8vd8aHlvvu8
        IItI+OtGg6CZKHvLSpmpnU0ay6c6D01TLNFPEI90fdj6be1dzxW42zbE/areWwkhg7SADW
        9rmPAe2n7WOMvbEfwo6dpomcuF9puu4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-pAusgSNUOHmc7PBXBskx2w-1; Tue, 17 Nov 2020 21:35:23 -0500
X-MC-Unique: pAusgSNUOHmc7PBXBskx2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AF5C10074B1;
        Wed, 18 Nov 2020 02:35:21 +0000 (UTC)
Received: from T590 (ovpn-13-160.pek2.redhat.com [10.72.13.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 12B845B4AB;
        Wed, 18 Nov 2020 02:35:11 +0000 (UTC)
Date:   Wed, 18 Nov 2020 10:35:07 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     kernel test robot <lkp@intel.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com, Omar Sandoval <osandov@fb.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V4 12/12] scsi: replace sdev->device_busy with sbitmap
Message-ID: <20201118023507.GA92339@T590>
References: <20201116090737.50989-13-ming.lei@redhat.com>
 <202011161944.U7XHrbsd-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202011161944.U7XHrbsd-lkp@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Kashyap & Sumanesh,

On Mon, Nov 16, 2020 at 07:49:31PM +0800, kernel test robot wrote:
> Hi Ming,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on block/for-next]
> [also build test ERROR on mkp-scsi/for-next scsi/for-next v5.10-rc4 next-20201116]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Ming-Lei/blk-mq-scsi-tracking-device-queue-depth-via-sbitmap/20201116-171449
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
> config: powerpc64-randconfig-r026-20201116 (attached as .config)
> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project c044709b8fbea2a9a375e4173a6bd735f6866c0c)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install powerpc64 cross compiling tool for clang build
>         # apt-get install binutils-powerpc64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/cc286ae987be50d7b8e152cc80a5ccaa8682e3ff
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Ming-Lei/blk-mq-scsi-tracking-device-queue-depth-via-sbitmap/20201116-171449
>         git checkout cc286ae987be50d7b8e152cc80a5ccaa8682e3ff
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=powerpc64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
> >> drivers/scsi/megaraid/megaraid_sas_fusion.c:365:41: error: no member named 'device_busy' in 'struct scsi_device'
>            sdev_busy = atomic_read(&scmd->device->device_busy);

This new reference to sdev->device_busy is added by recent shared host
tag patch, and according to the comment, you may have planed to convert into
one megaraid internal counter.

        /* TBD - if sml remove device_busy in future, driver
         * should track counter in internal structure.
         */

So can you post one patch? And I am happy to fold it into this series.

Thanks,
Ming

