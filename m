From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Wed, 25 Aug 2004 12:58:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040825115819.GE16196@parcelfarce.linux.theplanet.co.uk>
References: <1093113450.1732.334.camel@mulgrave> <20040824132936.GA25263@suse.de> <20040824203914.GA25755@us.ibm.com> <20040824205126.GA10105@suse.de> <20040825065747.GA2275@us.ibm.com> <20040825092541.GA15466@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:2986 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266914AbUHYL6V
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 07:58:21 -0400
Content-Disposition: inline
In-Reply-To: <20040825092541.GA15466@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, willy@debian.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Anton Blanchard <anton@samba.org>

On Wed, Aug 25, 2004 at 11:25:41AM +0200, Olaf Hering wrote:
> This broken chip seems to be so popular on PPC64 that the arch maintainers
> want a PPC64 specific default. Oh well ...
> 
> +/* Some AChip ARC765 based DVD-ROM's take 15 or more seconds
> + * to reset.  A scan will fail if made right after a reset.
> + * It's completely broken device behaviour: SCSI specification
> + * says devices need to be able to respond to INQUIRY always
> + * (after a selection timeout ... of 250ms).
> + */
> +#ifdef __powerpc64__
> +static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+25;
> +#else
>  static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+3;
> +#endif
>  
>  module_param_named(inq_timeout, scsi_inq_timeout, int, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(inq_timeout, 

How about hacking the ppc64 bootloader to always pass inq_timeout=30 instead?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
