From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] cciss 2.6: pci domain info
Date: Fri, 17 Jun 2005 20:35:17 +0100
Message-ID: <20050617193517.GN11655@parcelfarce.linux.theplanet.co.uk>
References: <20050617183124.GA9913@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:15275 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262073AbVFQTeF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2005 15:34:05 -0400
Content-Disposition: inline
In-Reply-To: <20050617183124.GA9913@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com
Cc: akpm@osdl.org, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 17, 2005 at 01:31:24PM -0500, mike.miller@hp.com wrote:
> This patch adds pci domain info to our CCISS_GETPCIINFO ioctl. This
> is to support the next generation of Itanium platforms. We had a couple
> of spare bytes in the structure. Impact to existing apps should be
> minimal. Please consider this patch for inclusion.

>  typedef struct _cciss_pci_info_struct
>  {
> +	unsigned int	domain;
>  	unsigned char 	bus;
>  	unsigned char 	dev_fn;
>  	__u32 		board_id;

Um, what?  There's no way this doesn't break the ABI.  You do have spare
bytes in the struct, but to use them, you have to add an 'unsigned short'
between dev_fn and board_id:

typedef struct _cciss_pci_info_struct
{
	unsigned char   bus;
	unsigned char   dev_fn;
+	unsigned int    domain;
	__u32           board_id;
}

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
