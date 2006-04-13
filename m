From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/1] megaraid_{mm,mbox}: fix a bug in reset handler
Date: Wed, 12 Apr 2006 22:05:34 -0700
Message-ID: <20060412220534.379702c2.akpm@osdl.org>
References: <890BF3111FB9484E9526987D912B261901BCC2@NAMAIL3.ad.lsil.com>
	<20060412220011.2ddd6f63.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:24760 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S964788AbWDMFFu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 01:05:50 -0400
In-Reply-To: <20060412220011.2ddd6f63.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann.Ju@lsil.com, Seokmann.Ju@engenio.com, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Andrew Morton <akpm@osdl.org> wrote:
>
>  > @@ -2918,12 +2933,12 @@
>  >  	wmb();
>  >  	WRINDOOR(raid_dev, raid_dev->mbox_dma | 0x1);
>  >  
>  > -	for (i = 0; i < 0xFFFFF; i++) {
>  > +	for (i = 0; i < 0xFFFFFF; i++) {
>  >  		if (mbox->numstatus != 0xFF) break;
>  >  		rmb();
>  >  	}
> 
>  Oh my.  That's an awfully long interrupts-off spin.

And if that mbox is in main memory, the duration of this spin will vary by
a factor of many tens across all the different machines on which this
driver must operate.

Careful use of ndelay() or udelay() would fix that.
