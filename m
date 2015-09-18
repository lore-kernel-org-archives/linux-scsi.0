From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 12/30] cxlflash: Refine host/device attributes
Date: Fri, 18 Sep 2015 16:34:41 -0500
Message-ID: <55FC8371.5010900@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1442438954-49663-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:35527 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbbIRVes (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2015 17:34:48 -0400
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 18 Sep 2015 15:34:47 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 3B9ED19D803F
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 15:25:39 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8ILYjWh1376616
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 14:34:45 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8ILYhmi022803
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 15:34:44 -0600
In-Reply-To: <1442438954-49663-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Shane Seymour <shane.seymour@hp.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 09/16/2015 04:29 PM, Matthew R. Ochs wrote:
> Implement the following suggestions and add two new attributes
> to allow for debugging the port LUN table.
> 
>  - use scnprintf() instead of snprintf()
>  - use DEVICE_ATTR_RO and DEVICE_ATTR_RW
> 
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Suggested-by: Shane Seymour <shane.seymour@hp.com>
> ---
>  drivers/scsi/cxlflash/main.c | 180 +++++++++++++++++++++++++++++++++----------
>  1 file changed, 138 insertions(+), 42 deletions(-)
> 

>  /**
> - * cxlflash_show_dev_mode() - presents the current mode of the device
> + * cxlflash_show_port_lun_table() - queries and presents the port LUN table
> + * @port:	Desired port for status reporting.
> + * @afu:	AFU owning the specified port.
> + * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
> + *
> + * Return: The size of the ASCII string returned in @buf.
> + */
> +static ssize_t cxlflash_show_port_lun_table(u32 port,
> +					    struct afu *afu,
> +					    char *buf)
> +{
> +	int i;
> +	ssize_t bytes = 0;
> +	__be64 __iomem *fc_port;
> +
> +	if (port >= NUM_FC_PORTS)
> +		return 0;
> +
> +	fc_port = &afu->afu_map->global.fc_port[port][0];
> +
> +	for (i = 0; i < CXLFLASH_NUM_VLUNS; i++, buf += 22)

Rather than this bug prone hard coded 22, how about never incrementing buf and do something
similar to this:

> +		bytes += scnprintf(buf, PAGE_SIZE, "%03d: %016llX\n",
> +				   i, readq_be(&fc_port[i]));

		bytes += scnprintf(&buf[bytes], PAGE_SIZE, "%03d: %016llX\n",
				   i, readq_be(&fc_port[i]));

> +	return bytes;
> +}
> +



-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

