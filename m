From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Mon, 26 Jul 2004 14:53:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040726145319.7cd97290.akpm@osdl.org>
References: <200407141216.i6ECGHxg008332@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:54431 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265521AbUGZVzC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2004 17:55:02 -0400
In-Reply-To: <200407141216.i6ECGHxg008332@harpo.it.uu.se>
List-Id: linux-scsi@vger.kernel.org
To: Mikael Pettersson <mikpe@csd.uu.se>
Cc: dgilbert@interlog.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Mikael Pettersson <mikpe@csd.uu.se> wrote:
>
> gcc-3.4.1 errors out in 2.6.8-rc1-mm1 at drivers/scsi/sg.c:
> 
> drivers/scsi/sg.c: In function `sg_ioctl':
> drivers/scsi/sg.c:209: sorry, unimplemented: inlining failed in call to 'sg_jif_to_ms': function body not available
> drivers/scsi/sg.c:930: sorry, unimplemented: called from here
> make[2]: *** [drivers/scsi/sg.o] Error 1
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2
> 
> sg_jif_to_ms() is marked inline but used defore its function
> body is available. Moving it nearer the top of sg.c (together
> with sg_ms_to_jif() for consistency) fixes the problem.
> 
>...
>  static int
> +sg_ms_to_jif(unsigned int msecs)
> +{
> +	if ((UINT_MAX / 2U) < msecs)
> +		return INT_MAX;	/* special case, set largest possible */
> +	else
> +		return ((int) msecs <
> +			(INT_MAX / 1000)) ? (((int) msecs * HZ) / 1000)
> +		    : (((int) msecs / 1000) * HZ);
> +}
> +
> +static inline unsigned
> +sg_jif_to_ms(int jifs)
> +{
> +	if (jifs <= 0)
> +		return 0U;
> +	else {
> +		unsigned int j = (unsigned int) jifs;
> +		return (j <
> +			(UINT_MAX / 1000)) ? ((j * 1000) / HZ) : ((j / HZ) *
> +								  1000);
> +	}
> +}
> +


We have standard jiffies_to_msecs() and msecs_to_jiffies() functions in
include/linux/time.h.  Can we please make these sg-private versions go away
altogether?

