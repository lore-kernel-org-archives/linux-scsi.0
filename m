From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] arcmsr: buffer overflow in arcmsr_iop_message_xfer()
Date: Thu, 15 Sep 2016 16:43:56 +0300
Message-ID: <20160915134356.GG26713@mwanda>
References: <20160915120142.GA2349@mwanda>
 <ff1f18b9-8e5b-93d8-1292-c74529676066@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45310 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753383AbcIONob (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2016 09:44:31 -0400
Content-Disposition: inline
In-Reply-To: <ff1f18b9-8e5b-93d8-1292-c74529676066@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Marco Grassi <marco.gra@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ching Huang <ching2048@areca.com.tw>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinicke <hare@suse.de>, linux-scsi@vger.kernel.org, security@kernel.org

On Thu, Sep 15, 2016 at 03:19:12PM +0200, Tomas Henzl wrote:
> > @@ -2397,6 +2398,10 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
> >  		}
> >  		ptmpuserbuffer = ver_addr;
> >  		user_len = pcmdmessagefld->cmdmessage.Length;
> > +		if (user_len > ARCMSR_API_DATA_BUFLEN) {
> > +			retvalue = ARCMSR_MESSAGE_FAIL;
> 
> Hi,
> I think that a 'kfree(ver_addr);' should be added here.
> With that you may add my reviewed-by.

Oops...  Thanks for catching that.  I should have been more careful.

v2 on the way.

regards,
dan carpenter

