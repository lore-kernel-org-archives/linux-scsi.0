From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: + mpt-fusion-dont-oops-if-numphys==0.patch added to -mm tree
Date: Tue, 19 Feb 2008 20:39:11 -0600
Message-ID: <1203475151.3103.40.camel@localhost.localdomain>
References: <200802192335.m1JNZ7MV005426@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59324 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755153AbYBTCjS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 21:39:18 -0500
In-Reply-To: <200802192335.m1JNZ7MV005426@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>
Cc: mm-commits@vger.kernel.org, olel@ans.pl, Eric.Moore@lsi.com, fujita.tomonori@lab.ntt.co.jp, ole@ans.pl, sathya.prakash@lsi.com


On Tue, 2008-02-19 at 15:34 -0800, akpm@linux-foundation.org wrote:
> Subject: mpt fusion: don't oops if NumPhys==0
> From: Krzysztof Oledzki <olel@ans.pl>
> 
> Don't oops if NumPhys==0, instead return -ENODEV.
> This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=9909
> 
> Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Eric Moore <Eric.Moore@lsi.com>
> Cc: Sathya Prakash <sathya.prakash@lsi.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/message/fusion/mptsas.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff -puN drivers/message/fusion/mptsas.c~mpt-fusion-dont-oops-if-numphys==0 drivers/message/fusion/mptsas.c
> --- a/drivers/message/fusion/mptsas.c~mpt-fusion-dont-oops-if-numphys==0
> +++ a/drivers/message/fusion/mptsas.c
> @@ -1701,6 +1701,11 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc
>  	if (error)
>  		goto out_free_consistent;
>  
> +	if (!buffer->NumPhys) {
> +		error = -ENODEV;
> +		goto out_free_consistent;
> +	}
> +
>  	/* save config data */
>  	port_info->num_phys = buffer->NumPhys;
>  	port_info->phy_info = kcalloc(port_info->num_phys,
> _

This is a bit odd ... It looks like a work around for a fusion firmware
problem.  What's the topology this thing is connected to?

James




