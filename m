From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/3] Add EVPD page 0x83 to sysfs
Date: Sun, 02 Mar 2014 09:34:32 +0100
Message-ID: <5312ED18.8080905@acm.org>
References: <1392287281-75002-1-git-send-email-hare@suse.de> <1392287281-75002-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.6]:53994 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaCBIej (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Mar 2014 03:34:39 -0500
In-Reply-To: <1392287281-75002-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On 02/13/14 11:28, Hannes Reinecke wrote:
>  static ssize_t
> -show_iostat_counterbits(struct device *dev, struct device_attribute *attr, 				char *buf)
> +show_vpd_pg(const unsigned char *pg_buf, int pg_len, char *buf)
> +{
> +	int len = 0, i;
> +
> +	if (!pg_buf)
> +		return -EINVAL;
> +
> +	len = 0;
> +	for (i = 0; i < pg_len; i += 16) {
> +		hex_dump_to_buffer(pg_buf + i, pg_len, 16, 1,
> +				   buf + len, PAGE_SIZE, false);
> +		strcat(buf + len, "\n");
> +		len += strlen(buf + len);
> +	}
> +	return len;
> +}

It might be a good idea to add the output buffer length as an argument
in show_vpd_pg() and to check explicitly whether or not there is
sufficient space left in the output buffer.

Bart.
