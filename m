From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [SCSI] bfa: mark symbols static where possible
Date: Wed, 07 Sep 2016 00:48:48 +0200
Message-ID: <6338093.Kb8EpNm1ao@wuerfel>
References: <201609070649.nsmY4rum%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:54966 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934842AbcIFWsw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2016 18:48:52 -0400
In-Reply-To: <201609070649.nsmY4rum%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: Baoyou Xie <baoyou.xie@linaro.org>, kbuild-all@01.org, anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xie.baoyou@zte.com.cn

On Wednesday, September 7, 2016 6:15:34 AM CEST kbuild test robot wrote:
>    drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_iocmd_handler':
> >> drivers/scsi/bfa/bfad_bsg.c:3130: warning: the frame size of 2896 bytes is larger than 2048 bytes

This needs to be investigated, 2896 bytes is clearly too much.
If we mark all functions called by bfad_iocmd_handler as "noinline",
this should go away, but I wonder if there are only a few functions
that each have a lot of stack usage, or if there are tons of functions
that each take a bit of stack with none sticking out in particular.

Building this file prior to the patch with arm-linux-gnueabi-gcc-6.1.1,
I get

$ make drivers/scsi/bfa/bfad_bsg.o EXTRA_CFLAGS=-Wframe-larger-than=50
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_iocmd_ioc_get_info':
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c:116:1: error: the frame size of 384 bytes is larger than 50 bytes [-Werror=frame-larger-than=]
 }
 ^
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_iocmd_port_get_attr':
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c:324:1: error: the frame size of 352 bytes is larger than 50 bytes [-Werror=frame-larger-than=]
 }
 ^
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_iocmd_pcifn_bw':
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c:1286:1: error: the frame size of 56 bytes is larger than 50 bytes [-Werror=frame-larger-than=]
 }
 ^
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_iocmd_cee_attr':
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c:1418:1: error: the frame size of 56 bytes is larger than 50 bytes [-Werror=frame-larger-than=]
 }
 ^
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_iocmd_cee_get_stats':
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c:1455:1: error: the frame size of 56 bytes is larger than 50 bytes [-Werror=frame-larger-than=]
 }
 ^
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_iocmd_diag_fwping':
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c:1709:1: error: the frame size of 56 bytes is larger than 50 bytes [-Werror=frame-larger-than=]
 }
 ^
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_iocmd_qos_get_stats':
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c:2475:1: error: the frame size of 88 bytes is larger than 50 bytes [-Werror=frame-larger-than=]
 }
 ^
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_iocmd_qos_reset_stats':
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c:2506:1: error: the frame size of 88 bytes is larger than 50 bytes [-Werror=frame-larger-than=]
 }
 ^
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c: In function 'bfad_iocmd_handler':
/git/arm-soc/drivers/scsi/bfa/bfad_bsg.c:3130:1: error: the frame size of 96 bytes is larger than 50 bytes [-Werror=frame-larger-than=]


The two functions with the most stack usage have a "struct bfa_port_attr_s" and
"struct bfa_lport_attr_s" on the stack respectively. Those are noticeable but
not huge.

>    drivers/scsi/bfa/bfad_bsg.o: warning: objtool: bfad_fcxp_free_mem()+0xd5: function has unreachable instruction

No idea what happened here.

	Arnd
