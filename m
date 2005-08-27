From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/16] qla2xxx: Generalize WWN to u64 interger conversions.
Date: Sat, 27 Aug 2005 11:40:53 +0100
Message-ID: <20050827104053.GA21026@infradead.org>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com> <20050827020950.27275.51550.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:34474 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030359AbVH0Kk5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Aug 2005 06:40:57 -0400
Content-Disposition: inline
In-Reply-To: <20050827020950.27275.51550.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Aug 26, 2005 at 07:09:50PM -0700, Andrew Vasquez wrote:
> Generalize WWN to u64 interger conversions.
> 
> On some platforms the hard-casting of the 8 byte node_name
> and port_name arrays to an u64 would cause unaligned-access
> warnings.  Generalize the conversions with consistent
> shifting of WWN bytes.
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
> 
>  drivers/scsi/qla2xxx/qla_attr.c |   27 +++++++++++++++++----------
>  1 files changed, 17 insertions(+), 10 deletions(-)
> 
> c7a5df1dc950e8a1cc04aa9a184619dfc78e5ed6
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -345,6 +345,15 @@ struct class_device_attribute *qla2x00_h
>  
>  /* Host attributes. */
>  
> +static u64
> +wwn_to_u64(uint8_t *wwn)
> +{
> +	return (u64)wwn[0] << 56 | (u64)wwn[1] << 48 |
> +	    (u64)wwn[2] << 40 | (u64)wwn[3] << 32 |
> +	    (u64)wwn[4] << 24 | (u64)wwn[5] << 16 |
> +	    (u64)wwn[6] <<  8 | (u64)wwn[7];
> +}

Shouldn't this go into the transport class?  Could probably be an inline
aswell.

