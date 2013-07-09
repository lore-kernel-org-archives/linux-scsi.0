From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [scsi:misc 34/37] include/uapi/linux/swab.h:106:23: warning:
 'csum' may be used uninitialized in this function
Date: Tue, 9 Jul 2013 11:01:41 +0000
Message-ID: <1373367700.18560.2.camel@dabdike>
References: <51dbda2f.fifurtmyJFmeHzKZ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:39046 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GILBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jul 2013 07:01:45 -0400
In-Reply-To: <51dbda2f.fifurtmyJFmeHzKZ%fengguang.wu@intel.com>
Content-Language: en-US
Content-ID: <5E19B25B8FCE5E44A1D690C87CAE61D5@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "kbuild-all@01.org" <kbuild-all@01.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2013-07-09 at 17:38 +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
> head:   06ba9fa7f8cec5b9c04e511bfe21c5aa7cc3044c
> commit: eb7b211bac8e0aad45c2349a853be13cef20048a [34/37] [SCSI] scsi_debug: reduce duplication between prot_verify_read and prot_verify_write
> config: x86_64-randconfig-x027-0707 (attached as .config)
> 
> Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
> http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings
> 
> All warnings:
> 
>    In file included from include/linux/swab.h:4:0,
>                     from include/uapi/linux/byteorder/little_endian.h:12,
>                     from include/linux/byteorder/little_endian.h:4,
>                     from arch/x86/include/uapi/asm/byteorder.h:4,
>                     from include/asm-generic/bitops/le.h:5,
>                     from arch/x86/include/asm/bitops.h:516,
>                     from include/linux/bitops.h:22,
>                     from include/linux/kernel.h:10,
>                     from include/linux/cache.h:4,
>                     from include/linux/time.h:4,
>                     from include/linux/stat.h:18,
>                     from include/linux/module.h:10,
>                     from drivers/scsi/scsi_debug.c:28:
>    drivers/scsi/scsi_debug.c: In function 'dif_verify':
> >> include/uapi/linux/swab.h:106:23: warning: 'csum' may be used uninitialized in this function [-Wmaybe-uninitialized]
>      (__builtin_constant_p((__u16)(x)) ? \
>                           ^
>    drivers/scsi/scsi_debug.c:1715:6: note: 'csum' was declared here
>      u16 csum;
>          ^

This is probably because the randconfig has CONFIG_BUG=n, so the default
case is a nop.  The original had an initialiser in there, so the fix is
either to drop the impossible default case or add the initialiser.

James

