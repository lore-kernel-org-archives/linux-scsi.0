From: =?ISO-8859-1?Q?Kai_M=E4kisara?= <kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] st: remove unused st_buffer.in_use
Date: Wed, 28 Jun 2006 23:02:49 +0300
Message-ID: <44A2E069.2040507@kolumbus.fi>
References: <20060628144036.GC31139@palantir8>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep17-1.kolumbus.fi ([193.229.5.117]:11750 "EHLO
	fep17-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751156AbWF1UCs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 16:02:48 -0400
In-Reply-To: <20060628144036.GC31139@palantir8>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Habets <errandir_news@mph.eclipse.co.uk>
Cc: linux-scsi@vger.kernel.org

Martin Habets wrote:
> Hi,
>
> I noticed that in_use in st_buffer is not used. The patch below
> against 2.6.17-rc3 removes it, assuming there is no future use for it.
> It was tested in a sparc SS20 with a DLT4000.
>
>   
This is a remainder from the times when the buffers were shared if the 
number of drives was large. Thanks for noticing this dead code.
> Please CC me as I'm not subscribed to the list.
>
> Thanks,
> Martin
>
> 	Signed-off-by: Martin Habets <errandir_news@mph.eclipse.co.uk>
>   
Acked-by: kai.makisara@kolumbus.fi
> ---
> --- 2.6.17-rc3/drivers/scsi/st.h.orig	2006-05-01 10:30:53.000000000 +0100
> +++ 2.6.17-rc3/drivers/scsi/st.h	2006-06-28 15:17:11.000000000 +0100
> @@ -31,7 +31,6 @@
>  
>  /* The tape buffer descriptor. */
>  struct st_buffer {
> -	unsigned char in_use;
>  	unsigned char dma;	/* DMA-able buffer */
>  	unsigned char do_dio;   /* direct i/o set up? */
>  	int buffer_size;
> --- 2.6.17-rc3/drivers/scsi/st.c.orig	2006-05-01 11:04:24.000000000 +0100
> +++ 2.6.17-rc3/drivers/scsi/st.c	2006-06-28 15:17:57.000000000 +0100
> @@ -3599,7 +3599,6 @@
>  	tb->use_sg = max_sg;
>  	tb->frp = (struct st_buf_fragment *)(&(tb->sg[0]) + max_sg);
>  
> -	tb->in_use = 1;
>  	tb->dma = need_dma;
>  	tb->buffer_size = got;
>  
>   
