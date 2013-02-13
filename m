From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: Fix endianess in partition table
Date: Wed, 13 Feb 2013 15:08:46 -0500
Message-ID: <511BF2CE.7040408@interlog.com>
References: <1360604094.24863.1.camel@br8ggx07.de.ibm.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44089 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599Ab3BMUJA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2013 15:09:00 -0500
In-Reply-To: <1360604094.24863.1.camel@br8ggx07.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 13-02-11 12:34 PM, Martin Peschke wrote:
> Both start_sect and nr_sects in struct partition are __le32 and
> require cpu_to_le32() on assignment.
>
> Without this fix tools like fdisk show an invalid partition table
> for SCSI devices emulated by scsi_debug on big-endian architectures,
> like s390x. Besides a kernel message like this was emitted:
>
> sda: p1 start 536870912 is beyond EOD, enabling native capacity
> sda: p1 start 536870912 is beyond EOD, truncated
>
> For verification 'xxd -l 512 /dev/sda' has been used to make sure
> that this fix makes scsi_debug generated partition tables on s390x
> look like the ones generated on my laptop.
>
> Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
> Reviewed-by: Steffen Maier <maier@linux.vnet.ibm.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

