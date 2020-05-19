Return-Path: <SRS0=JQ6K=7B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C65C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 14:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35E5B207FB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 14:42:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="WTWPhjns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgESOmW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 10:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgESOmW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 10:42:22 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4223BC08C5C1
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2020 07:42:22 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id l73so1280879pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2020 07:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=0UgPMqcoNwKDTDlJvIV5xcSA4BF3gP0ryxkw9QQb0/Q=;
        b=WTWPhjns5WgXVGYyVKQvspakjV9ET6HnAV3d8CSVwERDbg4WIXmX9m8toai0U8+TSu
         MqYskrTwMsy8nWm6qbhg8O3jsK33kPVjRqGZXeyySl+gnyakkdYFobdABIH98CUQx2AY
         O4QTRMaRlFy3xRC5ptn7T5B8ArVV64408WuR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0UgPMqcoNwKDTDlJvIV5xcSA4BF3gP0ryxkw9QQb0/Q=;
        b=becpmtnhChc1ngMAjQKZn83iIpfJt9XXOo0ZylvDNsHCpykJsAf05ulJ0xG1OUXBty
         cVnqSoq1eBu077/FJJ2QFXFGPm0yvz6aMKSsJVbvVcohQUuJd/4L8EvnocjsEitmNLt2
         HY0zfsa9rYvEkCqhUeCnDbfTAx7AYd7bJKnriwM7pJKJdl5vxIoKu/DJSSofNgBwjFck
         lKRwkTcbvyBMeHIdFUVFYaQ57HcCGbBoEb0Chl4gqv6oNnTROO9OrS4qtlb+4xUh1JJz
         4njidVUIMHTs7WNpdL06BN3Z4CfwAs6hC3pxZ4iV/7eE/f6PinLVEL/DLTywiK7KyCqW
         MTJQ==
X-Gm-Message-State: AOAM532nz+mHykN9LZpGGTykWkixP3hh9uy2PQZuc22n4eYSsMNc2V6D
        NRwxmtoAMYs6PAPWLzwJL3GXJw==
X-Google-Smtp-Source: ABdhPJwBa0vNktasHNWMphvkiqZE85pcnWPRfH/Lld2diTPLupTTMPGFo0GVy6qdRNBqq1/pZjJU8g==
X-Received: by 2002:a17:902:8509:: with SMTP id bj9mr11525597plb.151.1589899341671;
        Tue, 19 May 2020 07:42:21 -0700 (PDT)
Received: from localhost (2001-44b8-111e-5c00-b5ed-d3ff-25d3-7e68.static.ipv6.internode.on.net. [2001:44b8:111e:5c00:b5ed:d3ff:25d3:7e68])
        by smtp.gmail.com with ESMTPSA id r12sm10044368pgv.59.2020.05.19.07.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 07:42:20 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, Johannes Weiner <hannes@cmpxchg.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [hnaz-linux-mm:master 156/523] include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
In-Reply-To: <202005191736.t1JQZSrV%lkp@intel.com>
References: <202005191736.t1JQZSrV%lkp@intel.com>
Date:   Wed, 20 May 2020 00:42:17 +1000
Message-ID: <87blmkhtpy.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This looks like a SCSI issue that this has just happened to expose?
+ scsi list

kbuild test robot <lkp@intel.com> writes:

> tree:   https://github.com/hnaz/linux-mm master
> head:   2bbf0589bfeb27800c730b76eacf34528eee5418
> commit: 854834b3859d2d80e31750f658bc8e4031422912 [156/523] string.h: fix incompatibility between FORTIFY_SOURCE and KASAN
> config: arm-allyesconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (GCC) 9.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 854834b3859d2d80e31750f658bc8e4031422912
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=arm 
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
>
> drivers/scsi/arcmsr/arcmsr_hba.c: In function 'arcmsr_remap_pciregion':
> drivers/scsi/arcmsr/arcmsr_hba.c:286:30: warning: variable 'flags' set but not used [-Wunused-but-set-variable]
> 286 |   unsigned long addr, range, flags;
> |                              ^~~~~
> drivers/scsi/arcmsr/arcmsr_hba.c: In function 'arcmsr_suspend':
> drivers/scsi/arcmsr/arcmsr_hba.c:1070:11: warning: variable 'intmask_org' set but not used [-Wunused-but-set-variable]
> 1070 |  uint32_t intmask_org;
> |           ^~~~~~~~~~~
> drivers/scsi/arcmsr/arcmsr_hba.c: In function 'arcmsr_done4abort_postqueue':
> drivers/scsi/arcmsr/arcmsr_hba.c:1410:29: warning: variable 'cdb_phy_hipart' set but not used [-Wunused-but-set-variable]
> 1410 |  unsigned long ccb_cdb_phy, cdb_phy_hipart;
> |                             ^~~~~~~~~~~~~~
> drivers/scsi/arcmsr/arcmsr_hba.c: In function 'arcmsr_hbaD_postqueue_isr':
> drivers/scsi/arcmsr/arcmsr_hba.c:2448:36: warning: variable 'cdb_phy_hipart' set but not used [-Wunused-but-set-variable]
> 2448 |  unsigned long flags, ccb_cdb_phy, cdb_phy_hipart;
> |                                    ^~~~~~~~~~~~~~
> drivers/scsi/arcmsr/arcmsr_hba.c: In function 'arcmsr_hbaD_polling_ccbdone':
> drivers/scsi/arcmsr/arcmsr_hba.c:3498:36: warning: variable 'cdb_phy_hipart' set but not used [-Wunused-but-set-variable]
> 3498 |  unsigned long flags, ccb_cdb_phy, cdb_phy_hipart;
> |                                    ^~~~~~~~~~~~~~
> In file included from include/linux/bitmap.h:9,
> from include/linux/nodemask.h:95,
> from include/linux/mmzone.h:17,
> from include/linux/gfp.h:6,
> from include/linux/umh.h:4,
> from include/linux/kmod.h:9,
> from include/linux/module.h:16,
> from drivers/scsi/arcmsr/arcmsr_hba.c:47:
> In function 'strncpy',
> inlined from 'arcmsr_handle_virtual_command' at drivers/scsi/arcmsr/arcmsr_hba.c:3059:3:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 4 bytes from a string of the same length [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> In function 'strncpy',
> inlined from 'arcmsr_handle_virtual_command' at drivers/scsi/arcmsr/arcmsr_hba.c:3057:3:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 16 bytes from a string of the same length [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> In function 'strncpy',
> inlined from 'arcmsr_handle_virtual_command' at drivers/scsi/arcmsr/arcmsr_hba.c:3055:3:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 8 bytes from a string of the same length [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> --
> In file included from include/linux/bitmap.h:9,
> from include/linux/nodemask.h:95,
> from include/linux/mmzone.h:17,
> from include/linux/gfp.h:6,
> from include/linux/slab.h:15,
> from drivers/scsi/pm8001/pm8001_sas.c:41:
> In function 'strncpy',
> inlined from 'pm8001_issue_ssp_tmf' at drivers/scsi/pm8001/pm8001_sas.c:919:2:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' specified bound 8 equals destination size [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> --
> drivers/scsi/ips.c: In function 'ips_init_copperhead':
> drivers/scsi/ips.c:4700:10: warning: variable 'ConfigByte' set but not used [-Wunused-but-set-variable]
> 4700 |  uint8_t ConfigByte[IPS_MAX_CONFIG_BYTES];
> |          ^~~~~~~~~~
> drivers/scsi/ips.c: In function 'ips_init_copperhead_memio':
> drivers/scsi/ips.c:4794:10: warning: variable 'ConfigByte' set but not used [-Wunused-but-set-variable]
> 4794 |  uint8_t ConfigByte[IPS_MAX_CONFIG_BYTES];
> |          ^~~~~~~~~~
> drivers/scsi/ips.c: In function 'ips_init_phase1':
> drivers/scsi/ips.c:6839:10: warning: variable 'func' set but not used [-Wunused-but-set-variable]
> 6839 |  uint8_t func;
> |          ^~~~
> drivers/scsi/ips.c:6838:10: warning: variable 'bus' set but not used [-Wunused-but-set-variable]
> 6838 |  uint8_t bus;
> |          ^~~
> In file included from arch/arm/include/asm/io.h:23,
> from drivers/scsi/ips.c:164:
> In function 'strncpy',
> inlined from 'ips_send_cmd' at drivers/scsi/ips.c:3522:6:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 4 bytes from a string of the same length [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> In function 'strncpy',
> inlined from 'ips_send_cmd' at drivers/scsi/ips.c:3520:6:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 16 bytes from a string of the same length [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> In function 'strncpy',
> inlined from 'ips_send_cmd' at drivers/scsi/ips.c:3518:6:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 8 bytes from a string of the same length [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> In function 'strncpy',
> inlined from 'ips_inquiry' at drivers/scsi/ips.c:4041:2:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 4 bytes from a string of the same length [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> In function 'strncpy',
> inlined from 'ips_inquiry' at drivers/scsi/ips.c:4040:2:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 16 bytes from a string of the same length [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> In function 'strncpy',
> inlined from 'ips_inquiry' at drivers/scsi/ips.c:4039:2:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 8 bytes from a string of the same length [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> In function 'strncpy',
> inlined from 'ips_get_bios_version' at drivers/scsi/ips.c:2242:2:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 8 bytes from a string of the same length [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> In function 'strncpy',
> inlined from 'ips_write_driver_status' at drivers/scsi/ips.c:5626:2:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 4 bytes from a string of the same length [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> In function 'strncpy',
> inlined from 'ips_write_driver_status' at drivers/scsi/ips.c:5625:2:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 4 bytes from a string of the same length [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> In function 'strncpy',
> inlined from 'ips_write_driver_status' at drivers/scsi/ips.c:5627:2,
> inlined from 'ips_hainit' at drivers/scsi/ips.c:2433:7:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output may be truncated copying 4 bytes from a string of length 7 [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> In function 'strncpy',
> inlined from 'ips_write_driver_status' at drivers/scsi/ips.c:5628:2,
> inlined from 'ips_hainit' at drivers/scsi/ips.c:2433:7:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' specified bound 4 equals destination size [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> --
> drivers/scsi/3w-sas.c: In function 'twl_scsiop_execute_scsi':
> drivers/scsi/3w-sas.c:298:22: warning: variable 'sglist' set but not used [-Wunused-but-set-variable]
> 298 |  struct scatterlist *sglist = NULL, *sg;
> |                      ^~~~~~
> drivers/scsi/3w-sas.c: In function 'twl_scsi_biosparam':
> drivers/scsi/3w-sas.c:1411:23: warning: variable 'tw_dev' set but not used [-Wunused-but-set-variable]
> 1411 |  TW_Device_Extension *tw_dev;
> |                       ^~~~~~
> In file included from include/linux/bitmap.h:9,
> from include/linux/nodemask.h:95,
> from include/linux/mmzone.h:17,
> from include/linux/gfp.h:6,
> from include/linux/umh.h:4,
> from include/linux/kmod.h:9,
> from include/linux/module.h:16,
> from drivers/scsi/3w-sas.c:53:
> In function 'strncpy',
> inlined from 'twl_reset_sequence' at drivers/scsi/3w-sas.c:1331:3:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 11 bytes from a string of the same length [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> --
> In file included from include/linux/bitmap.h:9,
> from include/linux/nodemask.h:95,
> from include/linux/mmzone.h:17,
> from include/linux/gfp.h:6,
> from include/linux/slab.h:15,
> from include/linux/crypto.h:19,
> from include/crypto/hash.h:11,
> from include/linux/uio.h:10,
> from include/linux/socket.h:8,
> from include/uapi/linux/if.h:25,
> from include/scsi/libfc.h:12,
> from drivers/scsi/libfc/fc_elsct.c:17:
> In function 'strncpy',
> inlined from 'fc_ct_ms_fill.constprop' at include/scsi/fc_encode.h:263:3:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output may be truncated copying 64 bytes from a string of length 79 [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
> In function 'strncpy',
> inlined from 'fc_ct_ms_fill.constprop' at include/scsi/fc_encode.h:275:3:
> include/linux/string.h:297:30: warning: '__builtin_strncpy' output may be truncated copying 64 bytes from a string of length 79 [-Wstringop-truncation]
> 297 | #define __underlying_strncpy __builtin_strncpy
> |                              ^
>>> include/linux/string.h:307:9: note: in expansion of macro '__underlying_strncpy'
> 307 |  return __underlying_strncpy(p, q, size);
> |         ^~~~~~~~~~~~~~~~~~~~
>
> vim +/__underlying_strncpy +307 include/linux/string.h
>
>    299	
>    300	__FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
>    301	{
>    302		size_t p_size = __builtin_object_size(p, 0);
>    303		if (__builtin_constant_p(size) && p_size < size)
>    304			__write_overflow();
>    305		if (p_size < size)
>    306			fortify_panic(__func__);
>  > 307		return __underlying_strncpy(p, q, size);
>    308	}
>    309	
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
