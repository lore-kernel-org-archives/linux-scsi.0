From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.24-rc3
Date: Wed, 09 Jan 2008 12:45:14 -0600
Message-ID: <1199904314.3493.31.camel@localhost.localdomain>
References: <1195989865.3427.16.camel@localhost.localdomain>
	 <20080108111549.GA30832@rain>  <20080108230943U.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47045 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbYAISpW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 13:45:22 -0500
In-Reply-To: <20080108230943U.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: dushistov@mail.ru, akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp


On Tue, 2008-01-08 at 23:07 +0900, FUJITA Tomonori wrote:
> CC'ed Jes,
> 
> On Tue, 8 Jan 2008 14:15:53 +0300
> Evgeniy Dushistov <dushistov@mail.ru> wrote:
> 
> > On Sun, Nov 25, 2007 at 01:24:25PM +0200, James Bottomley wrote:
> > > This is a bit of a rash of bug fixes.  The qla1280 is actually a bug fix
> > > (in spite of the title---it's actually correcting an existing problem
> > > with the qla1280 implementation of accessors that broke the current
> > > driver).
> > > 
> > 
> > Recently I build last Linus's git tree, and got:
> > req_cnt is used uninitialized in this function,
> > and see bellow
> > > The patch is available here:
> > > 
> > > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> > > 
> > > The short changelog is:
> > ...
> > > Jes Sorensen (1):
> > >       qla1280: convert to use the data buffer accessors
> > > 
> > ...
> > >  scsi/qla1280.c         |  387 +++++++++++++++++++++----------------------------
> > ...
> > >  	/* Calculate number of entries and segments required. */
> > > -	req_cnt = 1;
> > > 
> > 
> > Initilization of req_cnt was removed, but in this function
> > there are places like 
> > req_cnt += (seg_cnt - 4) / 7;
> > or
> > req_cnt++;
> > This is should be so?
> 
> req_cnt should not be removed. Jes tested the patch but this critical
> bug appears only with BITS_PER_LONG != 64 && CONFIG_HIGHMEM=n case. So
> he didn't see this, I think.
> 
> qla1280_32bit_start_scsi also gives the following warning:
> 
> drivers/scsi/qla1280.c: In function 'qla1280_32bit_start_scsi':
> drivers/scsi/qla1280.c:3044: warning: unused variable 'dma_handle'
> 
> 
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 146d540..2886407 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -3041,7 +3041,6 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
>  	int cnt;
>  	int req_cnt;
>  	int seg_cnt;
> -	dma_addr_t dma_handle;
>  	u8 dir;
>  
>  	ENTER("qla1280_32bit_start_scsi");
> @@ -3050,6 +3049,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
>  		cmd->cmnd[0]);
>  
>  	/* Calculate number of entries and segments required. */
> +	req_cnt = 1;
>  	seg_cnt = scsi_dma_map(cmd);
>  	if (seg_cnt) {
>  		/*

I tested this on my qla1280 and confirm all else seems well in 32 bit
mode.  I have to say, 32 bit mode was very difficult to enable.
Apparently you not only need a 32 bit non-PAE mode kernel, but also you
need to have HIGHMEM disabled for no readily apparent reason.

James


