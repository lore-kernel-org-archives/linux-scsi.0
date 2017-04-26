From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/3] scsi: ufs: Delete an error message for a failed
 memory allocation in ufshcd_memory_alloc()
Date: Wed, 26 Apr 2017 11:27:22 -0700
Message-ID: <1493231242.18659.28.camel@perches.com>
References: <75622f45-f46c-e52f-2b9e-6ff5ce32184a@users.sourceforge.net>
         <3d355c13-159a-2570-9ead-af93ad95c210@users.sourceforge.net>
         <019b6365c15b0764c156d6453648f7a2@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <019b6365c15b0764c156d6453648f7a2@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>, SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-04-26 at 10:57 -0700, Subhash Jadavani wrote:
> PS: ufshcd_memory_alloc() also does some DMA coherent memory allocation 
> (via dmam_alloc_coherent() APIs) and tries to print out the message on 
> allocation failure. Although i don't know "out of memory" messages will 
> be printed out by dmam_alloc_coherent() APIs or not. If it does print it 
> out then we might want to remove our local memory allocation failure log 
> messages.

Basically most everything that has a gfp_t argument does a
dump_stack() on OOM unless __GFP_NOWARN is specified by that gfp_t.
