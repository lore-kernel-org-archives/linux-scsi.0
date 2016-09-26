From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [patch v2] arcmsr: buffer overflow in arcmsr_iop_message_xfer()
Date: Mon, 26 Sep 2016 13:58:40 +0200
Message-ID: <20160926115840.3av7dht23gcn3d3a@linux-x5ow.site>
References: <20160915134456.GA30277@mwanda>
 <yq17fadz2l6.fsf@sermon.lab.mkp.net>
 <20160923112226.rteir5ivjou64ffh@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54946 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030341AbcIZL6r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Sep 2016 07:58:47 -0400
Content-Disposition: inline
In-Reply-To: <20160923112226.rteir5ivjou64ffh@pd.tnic>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Ching Huang <ching2048@areca.com.tw>, Hannes Reinicke <hare@suse.de>, Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org, security@kernel.org

On Fri, Sep 23, 2016 at 01:22:26PM +0200, Borislav Petkov wrote:
> On Thu, Sep 15, 2016 at 09:59:01AM -0400, Martin K. Petersen wrote:
> > >>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:
> > 
> > Dan> We need to put an upper bound on "user_len" so the memcpy() doesn't
> > Dan> overflow.
> > 
> > Applied to 4.9/scsi-queue.
> 
> Yap, Tomas said the kfree was missing on the error path but can we
> simplify this further by doing the user_len check first so that the
> kfree() is not even needed?
> 
> Patch ontop:
> 
> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Fri, 23 Sep 2016 13:04:51 +0200
> Subject: [PATCH] scsi: arcmsr: Simplify user_len checking
> 
> Do the user_len check first and then the ver_addr allocation so that
> we can save us the kfree() on the error path when user_len is >
> ARCMSR_API_DATA_BUFLEN.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Marco Grassi <marco.gra@gmail.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Tomas Henzl <thenzl@redhat.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> ---

Looks good to me,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
