From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH] scsi_debug: implement IMMED bit
Date: Wed, 31 Jan 2018 09:06:20 -0800
Message-ID: <ed3a63f0-2cbb-8fac-fee7-4f08b1e1e8e2@wdc.com>
References: <20180130055445.20244-1-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:51922 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753324AbeAaRGV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2018 12:06:21 -0500
In-Reply-To: <20180130055445.20244-1-dgilbert@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hare@suse.de

On 01/29/18 21:54, Douglas Gilbert wrote:
> +static const struct opcode_info_t sync_cache_iarr[] = {
> +	{0, 0x91, 0, F_LONG_DELAY | F_M_ACCESS, resp_sync_cache, NULL,
> +	    {16,  0x7, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
                   ^^^
Can you clarify the choice of "0x7" in the above? After having had a 
look at SBC-4 I was expecting 0x2 (the mask for the IMMED bit) since all 
other bits in that command byte are either reserved or obsolete.

> -	return 0;
> +	return (cmd[1] & 0x1) ? SDEG_RES_IMMED_MASK : 0; /* check IMMED bit */

Shouldn't the mask 0x2 be used to check for the IMMED bit?

Thanks,

Bart.
