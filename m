From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 7/21] advansys: Convert to EISA driver model
Date: Fri, 27 Jul 2007 09:50:58 -0400
Message-ID: <46A9F842.6040209@garzik.org>
References: <11854705772-git-send-email-matthew@wil.cx> <46A8F850.3070102@garzik.org> <20070726203748.GR19275@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57842 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbXG0NvA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 09:51:00 -0400
In-Reply-To: <20070726203748.GR19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jul 26, 2007 at 03:38:56PM -0400, Jeff Garzik wrote:
>>> +	ioport = edev->base_addr + 0xc30;
>>> +
>>> +	for (i = 0; i < 2; i++, ioport += 0x20) {
>>> +		if (!AscFindSignature(ioport))
>>> +			continue;
>>> +		inw(ioport + 4);
>> 4) would be nice to have a comment noting what this inw() does.
> 
> Yeah, it would.  I just copied it from the previous code:
> 
>     while (iop_base <= ASC_EISA_MAX_IOP_ADDR) {
>         eisa_product_id = AscGetEisaProductID(iop_base);
>         if ((eisa_product_id == ASC_EISA_ID_740) ||
>             (eisa_product_id == ASC_EISA_ID_750)) {
>             if (AscFindSignature(iop_base)) {
>                 inpw(iop_base + 4);
>                 return (iop_base);
>             }
>         }
> 
> Anyone got a manual and can tell me why we do this?  ;-)
> 
> Would it make sense to put in a comment that says "No idea why we do this"?

IMO, yes.  It should be noticeable at the very least.


>> 5) I would suggest putting a "remove inpw/outpw pointless wrappers" 
>> cleanup patch before patches #2 .. #N.
> 
> Next thing on my todo list is to convert the driver over to ioread8 and
> friends.  Currently, only the wide boards get accessed through PCIMEM,
> but the narrow boards also have PCIMEM BARs.  It would also allow the wide boards to be used on machines where PCIMEM is broken, like the VisWS.

PCIMEM versus PCIMEM... huh?


>>> +static __devexit int advansys_eisa_remove(struct device *dev)
>>> +{
>>> +	int i, ioport;
>>> +	struct eisa_scsi_data *data = dev_get_drvdata(dev);
>>> +
>>> +	for (i = 0; i < 2; i++) {
>>> +		struct Scsi_Host *shost = data->host[i];
>>> +		if (!shost)
>>> +			continue;
>>> +		ioport = shost->io_port;
>>> +		advansys_remove(data->host[i]);
>>> +	}
>>> +
>>> +	return 0;
>> 6) set drvdata to NULL
> 
> Any reason why?

See other email.  Safe object lifetime practice, plus it ensures a nice 
oops if there is a bug.

Setting drvdata to NULL in ->remove() is standard for Linux drivers. 
grep around.

	Jeff


