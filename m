From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 27/32] scsi_data_buffer
Date: Thu, 18 Oct 2007 08:40:08 +0900
Message-ID: <20071018084008Z.fujita.tomonori@lab.ntt.co.jp>
References: <47164306.6090702@panasas.com>
	<4716529B.7020107@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:47822 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbXJQXn6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 19:43:58 -0400
In-Reply-To: <4716529B.7020107@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, tomof@acm.org, matthew@wil.cx, mdharm-scsi@one-eyed-alien.net, rmk@arm.linux.org.uk, stern@rowland.harvard.edu, davem@davemloft.net, hch@infradead.org, linux-scsi@vger.kernel.org, bhalevy@panasas.com, pw@osc.edu

On Wed, 17 Oct 2007 20:21:15 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
>   In preparation for bidi we abstract all IO members of scsi_cmnd,
>   that will need to duplicate, into a substructure.
> 
>   - Group all IO members of scsi_cmnd into a scsi_data_buffer
>     structure.
>   - Adjust accessors to new members.
>   - scsi_{alloc,free}_sgtable receive a scsi_data_buffer instead of
>     scsi_cmnd. And work on it.
>   - Adjust scsi_init_io() and  scsi_release_buffers() for above
>     change.
>   - Fix other parts of scsi_lib/scsi.c to members migration. Use
>     accessors where appropriate.
> 
>   - Old I/O members are kept for backward compatibility, since
>     not all of scsi-ml/ul is converted yet. Once done they will
>     be removed in a closing patch. (Other wise the patchset will
>     not be bisectable)

(snip)

> @@ -114,6 +112,22 @@ struct scsi_cmnd {
>  	int result;		/* Status code from lower level driver */
>  
>  	unsigned char tag;	/* SCSI-II queued command tag */
> +
> +	union {
> +		struct scsi_data_buffer sdb;
> +		/*
> +		 * FIXME: Here for compatibility with unconverted drivers.
> +		 *        Must be kept in sync with exact type and order
> +		 *        of struct scsi_data_buffer members.
> +		 */
> +		struct {
> +			unsigned __deprecated request_bufflen;
> +			int __deprecated resid;
> +			unsigned short __deprecated use_sg;
> +			unsigned short __deprecated place_holder_sg_alloc;
> +			void __deprecated *request_buffer;
> +		};
> +	};
>  };

If we add something like this, why couldn't we merge the
scsi_data_buffer patchset when I submitted last month?

I thought that I wait you to fix all the old LLDs, then will send a
clean scsi_data_buffer patchset.
