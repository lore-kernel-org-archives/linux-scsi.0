From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] fix idiocy in asd_init_lseq_mdp()
Date: Sun, 24 Sep 2006 23:52:03 -0700 (PDT)
Message-ID: <20060925065203.8718.qmail@web31809.mail.mud.yahoo.com>
References: <20060925015722.GF29920@ftp.linux.org.uk>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:7057 "HELO
	web31809.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S964820AbWIYGwE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 02:52:04 -0400
In-Reply-To: <20060925015722.GF29920@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

--- Al Viro <viro@ftp.linux.org.uk> wrote:
> To whoever had written that code:
> 
> a) priority of >> is higher than that of &
> b) priority of typecast is higher than that of any binary operator
> c) learn the fscking C

"whoever" would be Bottomley or someone at LTC.

My code in that spot has:
asd_write_reg_dword(asd_ha, LmSEQ_INTEN_SAVE(lseq),
			    (u32) LmM0INTEN_MASK);

> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/scsi/aic94xx/aic94xx_seq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
> index d9b6da5..56e4b3b 100644
> --- a/drivers/scsi/aic94xx/aic94xx_seq.c
> +++ b/drivers/scsi/aic94xx/aic94xx_seq.c
> @@ -764,7 +764,7 @@ static void asd_init_lseq_mdp(struct asd
>  	asd_write_reg_word(asd_ha, LmSEQ_FIRST_INV_SCB_SITE(lseq),
>  			   (u16)last_scb_site_no+1);
>  	asd_write_reg_word(asd_ha, LmSEQ_INTEN_SAVE(lseq),
> -			    (u16) LmM0INTEN_MASK & 0xFFFF0000 >> 16);
> +			    (u16) ((LmM0INTEN_MASK & 0xFFFF0000) >> 16));
>  	asd_write_reg_word(asd_ha, LmSEQ_INTEN_SAVE(lseq) + 2,
>  			    (u16) LmM0INTEN_MASK & 0xFFFF);
>  	asd_write_reg_byte(asd_ha, LmSEQ_LINK_RST_FRM_LEN(lseq), 0);
> -- 
> 1.4.2.GIT
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

