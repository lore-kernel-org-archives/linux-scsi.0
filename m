From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] retry HARDWARE ERROR for IBM ESS (using BLIST)
Date: Fri, 26 Nov 2004 19:27:47 +0000
Message-ID: <20041126192747.GI29035@parcelfarce.linux.theplanet.co.uk>
References: <OF4EF7026A.98AD4B65-ONC1256F58.00451604-C1256F58.005C5C9E@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:47065 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262457AbUKZT1t
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2004 14:27:49 -0500
Content-Disposition: inline
In-Reply-To: <OF4EF7026A.98AD4B65-ONC1256F58.00451604-C1256F58.005C5C9E@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On Fri, Nov 26, 2004 at 05:42:15PM +0100, Martin Peschke3 wrote:
> +     case HARDWARE_ERROR:
> +           if (scsi_get_device_flags(scmd->device,
> +                               scmd->device->vendor,
> +                               scmd->device->model)
> +               & BLIST_RETRY_HWERROR)
> +                 return NEEDS_RETRY;
> +           else
> +                 return SUCCESS;
> +
>       case ILLEGAL_REQUEST:
>       case BLANK_CHECK:
>       case DATA_PROTECT:
> -     case HARDWARE_ERROR:
>       default:
>             return SUCCESS;

You could actually fall through here, rather than having an else.  I don't
know which style we currently prefer (though we should certainly comment
a fall-through).

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
