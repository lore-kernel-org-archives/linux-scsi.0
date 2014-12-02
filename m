From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH RESEND 2/5] kexec: Export kexec_in_progress
Date: Tue, 02 Dec 2014 16:24:17 -0500
Message-ID: <20141202162417.Horde.AOQbbs2peoZqPuyzTV6YTA1@ltc.linux.ibm.com>
References: <201412021847.sB2Ilfvc002145@d01av04.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:56229 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbaLBVYZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2014 16:24:25 -0500
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Tue, 2 Dec 2014 14:24:25 -0700
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 9D57319D803E
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2014 14:13:01 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sB2LOmJ339256202
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 14:24:48 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sB2LOJ3c030020
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 14:24:20 -0700
In-Reply-To: <201412021847.sB2Ilfvc002145@d01av04.pok.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@hansenpartnership.com, hch@lst.de, linux-scsi@vger.kernel.org, anton@samba.org, ebiederm@xmission.com, kexec@lists.infradead.org


Reviewed-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy

Quoting Brian King <brking@linux.vnet.ibm.com>:

> A kexec boot for some ipr SAS adapters was seen to take ~20 seconds
> just doing ipr adapter initialization. This is due to the fact that
> a kexec invokes the driver's shutdown handler which places the adapter
> into a state that requires a hard reset and resulting firmware initialization
> to be usable again, which takes significant time. By exporting  
> kexec_in_progress,
> this process can be optimized significantly in the driver by essentially
> placing the adapter into a state where this hardware reset and  
> re-initialization
> can be bypassed, eliminating this delay in kexec boot.
>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: kexec <kexec@lists.infradead.org>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>
>  kernel/kexec.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff -puN kernel/kexec.c~kexec_export_in_prog kernel/kexec.c
> --- scsi-queue/kernel/kexec.c~kexec_export_in_prog	2014-12-02  
> 12:13:22.820325731 -0600
> +++ scsi-queue-bjking1/kernel/kexec.c	2014-12-02 12:13:22.825325687 -0600
> @@ -2768,3 +2768,5 @@ int kernel_kexec(void)
>  	mutex_unlock(&kexec_mutex);
>  	return error;
>  }
> +
> +EXPORT_SYMBOL_GPL(kexec_in_progress);
> _


