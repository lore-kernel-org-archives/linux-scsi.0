Return-Path: <SRS0=bR62=4C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDE1C2BA83
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 09:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85CA62086A
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 09:17:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KnXXsezG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgBNJRY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Feb 2020 04:17:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47878 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728783AbgBNJRX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Feb 2020 04:17:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581671842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tYQ2cjdzL+tg5mDuA9/r/Sx50QWKzKgP5Xest4v4Zb0=;
        b=KnXXsezG6VvyAG8HMUWnhb4btoGKKCqt3A+b3GlpKHJTJ5iK3SSpNX+NusDULn0FnqKBX1
        z1HXXeT05qQrzn28goRm3WTJSt7dg5vmq3U66TGrlzFkAlnmJqnchiFlyxYUk+RZUXCvY7
        ehlO1ATWjoktX4+r7eVnLQ+TIW3WEYo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-Ik0arHxfP1W1dlpnHLqREg-1; Fri, 14 Feb 2020 04:17:14 -0500
X-MC-Unique: Ik0arHxfP1W1dlpnHLqREg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21C981857340;
        Fri, 14 Feb 2020 09:17:12 +0000 (UTC)
Received: from ming.t460p (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D1F4519C4F;
        Fri, 14 Feb 2020 09:17:00 +0000 (UTC)
Date:   Fri, 14 Feb 2020 17:16:56 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Omar Sandoval <osandov@fb.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 10/10] scsi: replace sdev->device_busy with sbitmap
Message-ID: <20200214091656.GA777@ming.t460p>
References: <20200211121135.30064-11-ming.lei@redhat.com>
 <202002140428.063yIjwM%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202002140428.063yIjwM%lkp@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 14, 2020 at 04:22:08AM +0800, kbuild test robot wrote:
> Hi Ming,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on scsi/for-next]
> [also build test WARNING on mkp-scsi/for-next block/for-next v5.6-rc1 next-20200213]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Ming-Lei/scsi-tracking-device-queue-depth-via-sbitmap/20200213-215727
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> config: arm-allmodconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (GCC) 7.5.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.5.0 make.cross ARCH=arm 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from drivers/message/fusion/mptbase.h:839:0,
>                     from drivers/message/fusion/mptsas.c:63:
>    drivers/message/fusion/mptsas.c: In function 'mptsas_send_link_status_event':
>    drivers/message/fusion/mptsas.c:3759:26: error: 'struct scsi_device' has no member named 'device_busy'; did you mean 'device_blocked'?
>           atomic_read(&sdev->device_busy)));
>                              ^
>    drivers/message/fusion/mptdebug.h:72:3: note: in definition of macro 'MPT_CHECK_LOGGING'
>       CMD;      \
>       ^~~
>    drivers/message/fusion/mptsas.c:3755:7: note: in expansion of macro 'devtprintk'
>           devtprintk(ioc,
>           ^~~~~~~~~~
>    include/linux/compiler.h:269:22: note: in expansion of macro '__READ_ONCE'
>     #define READ_ONCE(x) __READ_ONCE(x, 1)
>                          ^~~~~~~~~~~
> >> arch/arm/include/asm/atomic.h:27:24: note: in expansion of macro 'READ_ONCE'
>     #define atomic_read(v) READ_ONCE((v)->counter)
>                            ^~~~~~~~~
>    drivers/message/fusion/mptsas.c:3759:7: note: in expansion of macro 'atomic_read'
>           atomic_read(&sdev->device_busy)));
>           ^~~~~~~~~~~
>    drivers/message/fusion/mptsas.c:3759:26: error: 'struct scsi_device' has no member named 'device_busy'; did you mean 'device_blocked'?
>           atomic_read(&sdev->device_busy)));
>                              ^
>    drivers/message/fusion/mptdebug.h:72:3: note: in definition of macro 'MPT_CHECK_LOGGING'
>       CMD;      \
>       ^~~
>    drivers/message/fusion/mptsas.c:3755:7: note: in expansion of macro 'devtprintk'
>           devtprintk(ioc,
>           ^~~~~~~~~~
>    include/linux/compiler.h:269:22: note: in expansion of macro '__READ_ONCE'
>     #define READ_ONCE(x) __READ_ONCE(x, 1)
>                          ^~~~~~~~~~~
> >> arch/arm/include/asm/atomic.h:27:24: note: in expansion of macro 'READ_ONCE'
>     #define atomic_read(v) READ_ONCE((v)->counter)
>                            ^~~~~~~~~
>    drivers/message/fusion/mptsas.c:3759:7: note: in expansion of macro 'atomic_read'
>           atomic_read(&sdev->device_busy)));
>           ^~~~~~~~~~~
>    drivers/message/fusion/mptsas.c:3759:26: error: 'struct scsi_device' has no member named 'device_busy'; did you mean 'device_blocked'?
>           atomic_read(&sdev->device_busy)));
>                              ^
>    drivers/message/fusion/mptdebug.h:72:3: note: in definition of macro 'MPT_CHECK_LOGGING'
>       CMD;      \
>       ^~~
>    drivers/message/fusion/mptsas.c:3755:7: note: in expansion of macro 'devtprintk'
>           devtprintk(ioc,
>           ^~~~~~~~~~
>    include/linux/compiler.h:269:22: note: in expansion of macro '__READ_ONCE'
>     #define READ_ONCE(x) __READ_ONCE(x, 1)
>                          ^~~~~~~~~~~
> >> arch/arm/include/asm/atomic.h:27:24: note: in expansion of macro 'READ_ONCE'
>     #define atomic_read(v) READ_ONCE((v)->counter)
>                            ^~~~~~~~~
>    drivers/message/fusion/mptsas.c:3759:7: note: in expansion of macro 'atomic_read'
>           atomic_read(&sdev->device_busy)));
>           ^~~~~~~~~~~
>    drivers/message/fusion/mptsas.c:3759:26: error: 'struct scsi_device' has no member named 'device_busy'; did you mean 'device_blocked'?
>           atomic_read(&sdev->device_busy)));
>                              ^
>    drivers/message/fusion/mptdebug.h:72:3: note: in definition of macro 'MPT_CHECK_LOGGING'
>       CMD;      \
>       ^~~
>    drivers/message/fusion/mptsas.c:3755:7: note: in expansion of macro 'devtprintk'
>           devtprintk(ioc,
>           ^~~~~~~~~~
>    include/linux/compiler.h:269:22: note: in expansion of macro '__READ_ONCE'
>     #define READ_ONCE(x) __READ_ONCE(x, 1)
>                          ^~~~~~~~~~~
> >> arch/arm/include/asm/atomic.h:27:24: note: in expansion of macro 'READ_ONCE'
>     #define atomic_read(v) READ_ONCE((v)->counter)
>                            ^~~~~~~~~
>    drivers/message/fusion/mptsas.c:3759:7: note: in expansion of macro 'atomic_read'
>           atomic_read(&sdev->device_busy)));
>           ^~~~~~~~~~~
>    drivers/message/fusion/mptsas.c:3759:26: error: 'struct scsi_device' has no member named 'device_busy'; did you mean 'device_blocked'?
>           atomic_read(&sdev->device_busy)));
>                              ^
>    drivers/message/fusion/mptdebug.h:72:3: note: in definition of macro 'MPT_CHECK_LOGGING'
>       CMD;      \
>       ^~~
>    drivers/message/fusion/mptsas.c:3755:7: note: in expansion of macro 'devtprintk'
>           devtprintk(ioc,
>           ^~~~~~~~~~
>    include/linux/compiler.h:269:22: note: in expansion of macro '__READ_ONCE'
>     #define READ_ONCE(x) __READ_ONCE(x, 1)
>                          ^~~~~~~~~~~
> >> arch/arm/include/asm/atomic.h:27:24: note: in expansion of macro 'READ_ONCE'
>     #define atomic_read(v) READ_ONCE((v)->counter)
>                            ^~~~~~~~~
>    drivers/message/fusion/mptsas.c:3759:7: note: in expansion of macro 'atomic_read'
>           atomic_read(&sdev->device_busy)));
>           ^~~~~~~~~~~
> --
>    In file included from drivers/message//fusion/mptbase.h:839:0,
>                     from drivers/message//fusion/mptsas.c:63:
>    drivers/message//fusion/mptsas.c: In function 'mptsas_send_link_status_event':
>    drivers/message//fusion/mptsas.c:3759:26: error: 'struct scsi_device' has no member named 'device_busy'; did you mean 'device_blocked'?
>           atomic_read(&sdev->device_busy)));
>                              ^
>    drivers/message//fusion/mptdebug.h:72:3: note: in definition of macro 'MPT_CHECK_LOGGING'
>       CMD;      \
>       ^~~
>    drivers/message//fusion/mptsas.c:3755:7: note: in expansion of macro 'devtprintk'
>           devtprintk(ioc,
>           ^~~~~~~~~~
>    include/linux/compiler.h:269:22: note: in expansion of macro '__READ_ONCE'
>     #define READ_ONCE(x) __READ_ONCE(x, 1)
>                          ^~~~~~~~~~~
> >> arch/arm/include/asm/atomic.h:27:24: note: in expansion of macro 'READ_ONCE'
>     #define atomic_read(v) READ_ONCE((v)->counter)
>                            ^~~~~~~~~
>    drivers/message//fusion/mptsas.c:3759:7: note: in expansion of macro 'atomic_read'
>           atomic_read(&sdev->device_busy)));
>           ^~~~~~~~~~~
>    drivers/message//fusion/mptsas.c:3759:26: error: 'struct scsi_device' has no member named 'device_busy'; did you mean 'device_blocked'?
>           atomic_read(&sdev->device_busy)));
>                              ^
>    drivers/message//fusion/mptdebug.h:72:3: note: in definition of macro 'MPT_CHECK_LOGGING'
>       CMD;      \
>       ^~~
>    drivers/message//fusion/mptsas.c:3755:7: note: in expansion of macro 'devtprintk'
>           devtprintk(ioc,
>           ^~~~~~~~~~
>    include/linux/compiler.h:269:22: note: in expansion of macro '__READ_ONCE'
>     #define READ_ONCE(x) __READ_ONCE(x, 1)
>                          ^~~~~~~~~~~
> >> arch/arm/include/asm/atomic.h:27:24: note: in expansion of macro 'READ_ONCE'
>     #define atomic_read(v) READ_ONCE((v)->counter)
>                            ^~~~~~~~~
>    drivers/message//fusion/mptsas.c:3759:7: note: in expansion of macro 'atomic_read'
>           atomic_read(&sdev->device_busy)));
>           ^~~~~~~~~~~
>    drivers/message//fusion/mptsas.c:3759:26: error: 'struct scsi_device' has no member named 'device_busy'; did you mean 'device_blocked'?
>           atomic_read(&sdev->device_busy)));
>                              ^
>    drivers/message//fusion/mptdebug.h:72:3: note: in definition of macro 'MPT_CHECK_LOGGING'
>       CMD;      \
>       ^~~
>    drivers/message//fusion/mptsas.c:3755:7: note: in expansion of macro 'devtprintk'
>           devtprintk(ioc,
>           ^~~~~~~~~~
>    include/linux/compiler.h:269:22: note: in expansion of macro '__READ_ONCE'
>     #define READ_ONCE(x) __READ_ONCE(x, 1)
>                          ^~~~~~~~~~~
> >> arch/arm/include/asm/atomic.h:27:24: note: in expansion of macro 'READ_ONCE'
>     #define atomic_read(v) READ_ONCE((v)->counter)
>                            ^~~~~~~~~
>    drivers/message//fusion/mptsas.c:3759:7: note: in expansion of macro 'atomic_read'
>           atomic_read(&sdev->device_busy)));
>           ^~~~~~~~~~~
>    drivers/message//fusion/mptsas.c:3759:26: error: 'struct scsi_device' has no member named 'device_busy'; did you mean 'device_blocked'?
>           atomic_read(&sdev->device_busy)));
>                              ^
>    drivers/message//fusion/mptdebug.h:72:3: note: in definition of macro 'MPT_CHECK_LOGGING'
>       CMD;      \
>       ^~~
>    drivers/message//fusion/mptsas.c:3755:7: note: in expansion of macro 'devtprintk'
>           devtprintk(ioc,
>           ^~~~~~~~~~
>    include/linux/compiler.h:269:22: note: in expansion of macro '__READ_ONCE'
>     #define READ_ONCE(x) __READ_ONCE(x, 1)
>                          ^~~~~~~~~~~
> >> arch/arm/include/asm/atomic.h:27:24: note: in expansion of macro 'READ_ONCE'
>     #define atomic_read(v) READ_ONCE((v)->counter)
>                            ^~~~~~~~~
>    drivers/message//fusion/mptsas.c:3759:7: note: in expansion of macro 'atomic_read'
>           atomic_read(&sdev->device_busy)));
>           ^~~~~~~~~~~
>    drivers/message//fusion/mptsas.c:3759:26: error: 'struct scsi_device' has no member named 'device_busy'; did you mean 'device_blocked'?
>           atomic_read(&sdev->device_busy)));
>                              ^
>    drivers/message//fusion/mptdebug.h:72:3: note: in definition of macro 'MPT_CHECK_LOGGING'
>       CMD;      \
>       ^~~
>    drivers/message//fusion/mptsas.c:3755:7: note: in expansion of macro 'devtprintk'
>           devtprintk(ioc,
>           ^~~~~~~~~~
>    include/linux/compiler.h:269:22: note: in expansion of macro '__READ_ONCE'
>     #define READ_ONCE(x) __READ_ONCE(x, 1)
>                          ^~~~~~~~~~~
> >> arch/arm/include/asm/atomic.h:27:24: note: in expansion of macro 'READ_ONCE'
>     #define atomic_read(v) READ_ONCE((v)->counter)
>                            ^~~~~~~~~
>    drivers/message//fusion/mptsas.c:3759:7: note: in expansion of macro 'atomic_read'
>           atomic_read(&sdev->device_busy)));

Hello,

Thanks for the report.

Looks miss this non-scsi directory, will fix it in V2 after getting
some feedback.


Thank,
Ming

