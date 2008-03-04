From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [patch (for 2.6.25?) 1/2] mpt fusion: don't oops if NumPhys==0
Date: Tue, 4 Mar 2008 16:14:57 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70D555E6@NAMAIL4.ad.lsil.com>
References: <200803042256.m24MuO5G001341@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40886 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934913AbYCDXQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 18:16:03 -0500
Content-class: urn:content-classes:message
In-Reply-To: <200803042256.m24MuO5G001341@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, olel@ans.pl, fujita.tomonori@lab.ntt.co.jp, ole@ans.pl, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Tuesday, March 04, 2008 3:56 PM, Andrew Morton wrote: 
> 
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
> diff -puN 
> drivers/message/fusion/mptsas.c~mpt-fusion-dont-oops-if-numphy
> s==0 drivers/message/fusion/mptsas.c
> --- 
> a/drivers/message/fusion/mptsas.c~mpt-fusion-dont-oops-if-numphys==0
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
>

This patch seems fine, and we already have this patch in our internal
sources.  The reason your getting a zero phy count, that is you've got
an expander that is zoned to initator A, and initiator B doesn't not
have access to those phys hence why its receiving a zero phy count.
Ulitmately I have an solution in my next generation driver, in that is I
keep the sas address of the expander at a higher level above the phys
struct.  For this driver, what I propose is we create a phy[0] which
really isn't there, and its merely storing the sas_address, but doing
this, the expander can be added to the sas transport layer.  The driver
already has assumptoins that phy 0 will always be there.  With only the
patch above, the expander doesn't get added.  

Eric
 
