From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI RAM driver ported to 3.3 kernel for file system and I/O
 testing
Date: Wed, 16 May 2012 17:41:12 +0000
Message-ID: <4FB3E6B8.7050909@acm.org>
References: <1337188023.3796.130.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:46325 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab2EPRlS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2012 13:41:18 -0400
In-Reply-To: <1337188023.3796.130.camel@schen9-DESK>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Andi Kleen <ak@linux.intel.com>

On 05/16/12 17:07, Tim Chen wrote:

> +/*
> + * SCSI requires quantities to be written MSB.  They're frequently misaligned,
> + * so don't mess about with cpu_to_beN, just access it byte-wise
> + */
> +static void scsi_ram_put_u32(unsigned char *addr, unsigned int data)
> +{
> +	addr[0] = data >> 24;
> +	addr[1] = data >> 16;
> +	addr[2] = data >> 8;
> +	addr[3] = data;
> +}
> +
> +static unsigned int scsi_ram_get_u16(unsigned char *addr)
> +{
> +	unsigned int data;
> +	data = addr[0] << 8;
> +	data |= addr[1];
> +
> +	return data;
> +}
> +
> +static unsigned int scsi_ram_get_u24(unsigned char *addr)
> +{
> +	unsigned int data;
> +	data = addr[0] << 16;
> +	data |= addr[1] << 8;
> +	data |= addr[2];
> +
> +	return data;
> +}
> +
> +static unsigned int scsi_ram_get_u32(unsigned char *addr)
> +{
> +	unsigned int data;
> +	data = addr[0] << 24;
> +	data |= addr[1] << 16;
> +	data |= addr[2] << 8;
> +	data |= addr[3];
> +
> +	return data;
> +}


Please drop these functions and use get/put_unaligned_be*() instead.
Maybe it's a good idea to add get/put_unaligned_be24() helper functions
in the appropriate <linux/unaligned/...> header file - there is more
SCSI code that stores and retrieves 24-bit numbers.

Thanks,

Bart.
