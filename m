Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB5CC35280
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 22:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11CD0208E4
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 22:00:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vI/53XPm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgEGWAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 18:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgEGWAf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 18:00:35 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D49C05BD43
        for <linux-scsi@vger.kernel.org>; Thu,  7 May 2020 15:00:33 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t9so3281721pjw.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 May 2020 15:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6fT4k86WplkenZajSARoycgD+uv5LCdkOQsyfX/+mVQ=;
        b=vI/53XPmBOEcP8dkq6wG+xGW4HDI34A0Ihdsayx2YLlOTe1au31MTE58/J3A9jRIbQ
         ShX7uVYFgNEbqJCN27n0g7akHvCYCTF575M9eQbZelA3RQt65OWDythiIq/1N8ikI41f
         gnMMdJ2Xx6XbSNsdQtmdsLqcGR6zrh1QmHmIpSrCD4qR04zIVdqmAAsreXQAPmUdo7Pe
         KDBzbWlptoGq1ALFd0RY90N3Bu6Iu9tH9mGtd29/xHWw5Fmz2GHrLwFZpSE+QYyS46CK
         PO62lOqqEtFnbUgsjWPISM8R9EhzUMbARMSCwZ07x5MyEG9bfHcVPF7iRUHbQF/pa5P2
         QCnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6fT4k86WplkenZajSARoycgD+uv5LCdkOQsyfX/+mVQ=;
        b=Uf5eAE65L2eaDTjYaqj3MJwgGlixIS0z4lbKJSBc0V2pqIld8X3Gy2BvWby7XTHxNK
         nDAhPTmHcBJBK0bXRPFdqs8mciZ+ujzA3mPJwchUCDOj9i1zZVgihERFQ+glejDeOrmN
         7YAYiS5xSxaTzkNfTRzQcnqCAa0pOHYQMjiXufX8g3bRuMFPlCQB4M7paxQKyTz/hnXL
         q2/PpISV6HCORNJY+K/lzuuhQip/a1NkNDU0Q19Lk7qy3iEdD0FuT/cQG5/NC5RR+dPb
         qydAj8qj/mI6IVYsb4DLRpKxidBmAF8zcedZydTbP46objR7EcIyIHfIGVdfpgSgYH16
         TcBA==
X-Gm-Message-State: AGi0PuaTfm1kubpDGoloHAq29GFlSvli6hPmnxT51wzIRd35O8x95JqL
        eNQDs6jK0R2dLDV8Wx3+rh9no/HM9geflkGMvVF1HQ==
X-Google-Smtp-Source: APiQypKBAQ7s5H25KO4JTpCr301Fl/qrsgbFYZk6OJZfSGmFDGxl8as5VD3RAMjdyV++MktrPQ/TwI4ZmFZ0YfPiohQ=
X-Received: by 2002:a17:902:ac87:: with SMTP id h7mr14650635plr.119.1588888832973;
 Thu, 07 May 2020 15:00:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200507042835.9135-3-bvanassche@acm.org> <202005080353.y49Uwj18%lkp@intel.com>
In-Reply-To: <202005080353.y49Uwj18%lkp@intel.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 7 May 2020 15:00:21 -0700
Message-ID: <CAKwvOdnuXX2xpsz6fxV-qfvj1AqN3V7qyOwtwtCG4NWq+HzfAw@mail.gmail.com>
Subject: Re: [PATCH v5 02/11] qla2xxx: Suppress two recently introduced
 compiler warnings
To:     kbuild test robot <lkp@intel.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Rajan Shanmugavelu <rajan.shanmugavelu@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 7, 2020 at 12:18 PM kbuild test robot <lkp@intel.com> wrote:
>
> Hi Bart,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on scsi/for-next]
> [also build test ERROR on mkp-scsi/for-next tip/perf/core v5.7-rc4 next-20200507]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
>
> url:    https://github.com/0day-ci/linux/commits/Bart-Van-Assche/Fix-qla2xxx-endianness-annotations/20200507-135245
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> config: x86_64-allyesconfig (attached as .config)
> compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project 54b35c066417d4856e9d53313f7e98b354274584)
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install x86_64 cross compiling tool for clang build
>         # apt-get install binutils-x86-64-linux-gnu
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
> >> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>                                   ^

Hi Bart,
These compiler specific pragma's are not toolchain portable.  You'll
need to wrap them in:
#ifndef __clang__
preprocessor macros, or I think we have a pragma helper in tree that
helps with compiler specific pragmas.  IIRC it uses _Pragma to define
pragmas in macros.

>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
>    In file included from include/trace/events/qla.h:44:
>    In file included from include/trace/define_trace.h:95:
> >> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>                                   ^
>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
>    In file included from include/trace/events/qla.h:44:
>    In file included from include/trace/define_trace.h:102:
>    In file included from include/trace/trace_events.h:155:
> >> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>                                   ^
>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
>    In file included from include/trace/events/qla.h:44:
>    In file included from include/trace/define_trace.h:102:
>    In file included from include/trace/trace_events.h:222:
> >> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>                                   ^
>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
>    In file included from include/trace/events/qla.h:44:
>    In file included from include/trace/define_trace.h:102:
>    In file included from include/trace/trace_events.h:402:
> >> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>                                   ^
>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
>    In file included from include/trace/events/qla.h:44:
>    In file included from include/trace/define_trace.h:102:
>    In file included from include/trace/trace_events.h:453:
> >> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>                                   ^
>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
>    In file included from include/trace/events/qla.h:44:
>    In file included from include/trace/define_trace.h:102:
>    In file included from include/trace/trace_events.h:533:
> >> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>                                   ^
>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
>    In file included from include/trace/events/qla.h:44:
>    In file included from include/trace/define_trace.h:102:
>    In file included from include/trace/trace_events.h:727:
> >> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>                                   ^
>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
>    In file included from include/trace/events/qla.h:44:
>    In file included from include/trace/define_trace.h:102:
>    In file included from include/trace/trace_events.h:792:
> >> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>                                   ^
>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
>    In file included from include/trace/events/qla.h:44:
>    In file included from include/trace/define_trace.h:103:
>    In file included from include/trace/perf.h:90:
> >> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>                                   ^
>    In file included from drivers/scsi/qla2xxx/qla_dbg.c:77:
>    In file included from include/trace/events/qla.h:44:
>    In file included from include/trace/define_trace.h:104:
>    In file included from include/trace/bpf_probe.h:114:
> >> include/trace/events/qla.h:13:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
>    #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>                                   ^
>    11 errors generated.
>
> vim +13 include/trace/events/qla.h
>
>     11
>     12  #pragma GCC diagnostic push
>   > 13  #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
>     14
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/202005080353.y49Uwj18%25lkp%40intel.com.



-- 
Thanks,
~Nick Desaulniers
