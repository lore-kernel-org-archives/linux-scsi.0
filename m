From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [scsi:misc 46/59] drivers/scsi/qla2xxx/qla_mr.c:3007:7:
 warning: large integer implicitly truncated to unsigned type
Date: Fri, 12 Apr 2013 18:06:54 +0000
Message-ID: <1365790013.1934.34.camel@dabdike>
References: <516764a0.CxAUmlQBEvv7Rtte%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:54796 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab3DLSG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Apr 2013 14:06:58 -0400
In-Reply-To: <516764a0.CxAUmlQBEvv7Rtte%fengguang.wu@intel.com>
Content-Language: en-US
Content-ID: <9A89C62532358041B71165EC29CF9E25@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Armen Baloyan <armen.baloyan@qlogic.com>, Andrew Vazquez <andrew.vasquez@qlogic.com>, "kbuild-all@01.org" <kbuild-all@01.org>, linux-scsi <linux-scsi@vger.kernel.org>

[linux-scsi cc added]
On Fri, 2013-04-12 at 09:34 +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git misc
> head:   9e45dd73234af9a59613dc2989dcc2df2dab847f
> commit: 8ae6d9c7eb1004bc134813287010d57a863ba13b [46/59] [SCSI] qla2xxx: Enhancements to support ISPFx00.
> config: make ARCH=powerpc allmodconfig
> 
> All warnings:
> 
>    drivers/scsi/qla2xxx/qla_mr.c: In function 'qlafx00_build_scsi_iocbs':
> >> drivers/scsi/qla2xxx/qla_mr.c:3007:7: warning: large integer implicitly truncated to unsigned type [-Woverflow]
> >> drivers/scsi/qla2xxx/qla_mr.c:3011:7: warning: large integer implicitly truncated to unsigned type [-Woverflow]
> 
> vim +3007 drivers/scsi/qla2xxx/qla_mr.c
> 
>   3001			return;
>   3002		}
>   3003	
>   3004		/* Set transfer direction */
>   3005		if (cmd->sc_data_direction == DMA_TO_DEVICE) {
>   3006			lcmd_pkt->cntrl_flags =
> > 3007			    __constant_cpu_to_le16(TMF_WRITE_DATA);
>   3008			vha->qla_stats.output_bytes += scsi_bufflen(cmd);
>   3009		} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
>   3010			lcmd_pkt->cntrl_flags =
> > 3011			    __constant_cpu_to_le16(TMF_READ_DATA);
>   3012			vha->qla_stats.input_bytes += scsi_bufflen(cmd);
>   3013		}
>   3014	

This is because of this definition in qla_mr.h:

struct cmd_type_7_fx00 {
...
	uint8_t cntrl_flags;

Which means that the assignment produces zero on a BE platform.  That
doesn't look right.  Please fix.

James

