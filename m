From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] ps3: BD/DVD/CD-ROM Storage Driver
Date: Wed, 18 Jul 2007 16:43:51 -0700
Message-ID: <20070718164351.a92ec032.akpm@linux-foundation.org>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.529280000@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <20070716162206.529280000@pademelon.sonytel.be>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jens Axboe <axboe@kernel.dk>, "James
	E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 16 Jul 2007 18:15:41 +0200
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> 
> Add a BD/DVD/CD-ROM Storage Driver for the PS3:
>   - Implemented as a SCSI device driver
>   - Uses software scatter-gather with a 64 KiB bounce buffer as the hypervisor
>     doesn't support scatter-gather
> 
> --- /dev/null
> +++ b/drivers/scsi/ps3rom.c
> @@ -0,0 +1,538 @@
> +/*
> + * PS3 BD/DVD/CD-ROM Storage Driver
> + *
> + * Copyright (C) 2007 Sony Computer Entertainment Inc.
> + * Copyright 2007 Sony Corp.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published
> + * by the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +#include <linux/cdrom.h>
> +#include <linux/highmem.h>
> +
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_host.h>
> +
> +#include <asm/lv1call.h>
> +#include <asm/ps3stor.h>
> +
> +
> +#define DEVICE_NAME			"ps3rom"
> +
> +#define BOUNCE_SIZE			(64*1024)
> +
> +#define PS3ROM_MAX_SECTORS		(BOUNCE_SIZE / CD_FRAMESIZE)
> +
> +
> +struct ps3rom_private {
> +	struct ps3_storage_device *dev;
> +	struct scsi_cmnd *curr_cmd;
> +};
> +#define ps3rom_priv(dev)	((dev)->sbd.core.driver_data)
> +

Someone should invent a keyboard which delivers an electric shock when the
operator types "#define".   In the meanwhile, I get to do the honours.

Please don't implement in a macro anything which can be implemented in C.

> +
> +#define LV1_STORAGE_SEND_ATAPI_COMMAND	(1)
> +
> +struct lv1_atapi_cmnd_block {
> +	u8	pkt[32];	/* packet command block           */
> +	u32	pktlen;		/* should be 12 for ATAPI 8020    */
> +	u32	blocks;
> +	u32	block_size;
> +	u32	proto;		/* transfer mode                  */
> +	u32	in_out;		/* transfer direction             */
> +	u64	buffer;		/* parameter except command block */
> +	u32	arglen;		/* length above                   */
> +};
> +
> +enum lv1_atapi_proto {
> +	NON_DATA_PROTO     = 0,
> +	PIO_DATA_IN_PROTO  = 1,
> +	PIO_DATA_OUT_PROTO = 2,
> +	DMA_PROTO = 3
> +};
> +
>
> ...
>
> +/*
> + * copy data from device into scatter/gather buffer
> + */
> +static int fill_from_dev_buffer(struct scsi_cmnd *cmd, const void *buf)
> +{
> +	int k, req_len, act_len, len, active;
> +	void *kaddr;
> +	struct scatterlist *sgpnt;
> +	unsigned int buflen;
> +
> +	buflen = cmd->request_bufflen;
> +	if (!buflen)
> +		return 0;
> +
> +	if (!cmd->request_buffer)
> +		return -1;
> +
> +	sgpnt = cmd->request_buffer;
> +	active = 1;
> +	for (k = 0, req_len = 0, act_len = 0; k < cmd->use_sg; ++k, ++sgpnt) {
> +		if (active) {
> +			kaddr = kmap_atomic(sgpnt->page, KM_IRQ0);
> +			if (!kaddr)
> +				return -1;

kmap_atomic() cannot fail.  On i386, at least.  If it can fail on any other
arch then we have a biiiiig problem.  (Multiple instances of this)

> +			len = sgpnt->length;
> +			if ((req_len + len) > buflen) {
> +				active = 0;
> +				len = buflen - req_len;
> +			}
> +			memcpy(kaddr + sgpnt->offset, buf + req_len, len);
> +			flush_kernel_dcache_page(sgpnt->page);
> +			kunmap_atomic(kaddr, KM_IRQ0);
> +			act_len += len;
> +		}
> +		req_len += sgpnt->length;
> +	}
> +	cmd->resid = req_len - act_len;
> +	return 0;
> +}
> +
