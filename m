From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: memcpy_toio/memcpy_fromio 64 bit safe?
Date: Wed, 16 Mar 2005 20:18:02 +0000
Message-ID: <20050316201802.GR21986@parcelfarce.linux.theplanet.co.uk>
References: <60807403EABEB443939A5A7AA8A7458BED2483@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:58774 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261374AbVCPUSD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 15:18:03 -0500
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BED2483@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Mar 16, 2005 at 03:08:13PM -0500, Salyzyn, Mark wrote:
> The dpt_i2o driver uses the function memcpy_toio to copy the message
> frame to the adapter. Under arch/x86_64/lib/io.c, it's helper function
> is defined as:
> 
> void __memcpy_toio(unsigned long dst,const void*src,unsigned len)
> {
>         __inline_memcpy((void *) dst,src,len);
> }
> 
> The first argument should be 'volatile void __iomem * dst' I would have
> expected. As such, the 64 bit virtual address representing the adapter
> address passed in gets truncated (please correct me if I am wrong).

Why would you think that 'void *' is smaller than 'volatile void __iomem *'?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
