From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 7/21] advansys: Convert to EISA driver model
Date: Thu, 26 Jul 2007 14:37:48 -0600
Message-ID: <20070726203748.GR19275@parisc-linux.org>
References: <11854705772-git-send-email-matthew@wil.cx> <46A8F850.3070102@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58844 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763125AbXGZUht (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 16:37:49 -0400
Content-Disposition: inline
In-Reply-To: <46A8F850.3070102@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Jul 26, 2007 at 03:38:56PM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >+static void __devexit advansys_remove(struct Scsi_Host *shost)
> >+{
> >+	int i;
> >+	scsi_remove_host(shost);
> >+	advansys_release(shost);
> >+
> >+	for (i = 0; i < asc_board_count; i++) {
> >+		if (asc_host[i] == shost) {
> >+			asc_host[i] = NULL;
> >+			break;
> >+		}
> >+	}
> >+}
> 
> 1) IMO this should be in the PCI patch

I suppose so.

> >+static int __devinit advansys_eisa_probe(struct device *dev)
> >+{
> >+	int i, ioport;
> >+	int err = -ENODEV;
> >+	struct eisa_device *edev = to_eisa_device(dev);
> >+
> >+	struct eisa_scsi_data *data = kzalloc(sizeof(*data), GFP_KERNEL);
> 
> nits:
> 
> 2) check for NULL

OK.  I don't think an 8-byte allocation can actually fail, but it's good
style.

> >+	ioport = edev->base_addr + 0xc30;
> >+
> >+	for (i = 0; i < 2; i++, ioport += 0x20) {
> >+		if (!AscFindSignature(ioport))
> >+			continue;
> >+		inw(ioport + 4);
> 
> 4) would be nice to have a comment noting what this inw() does.

Yeah, it would.  I just copied it from the previous code:

    while (iop_base <= ASC_EISA_MAX_IOP_ADDR) {
        eisa_product_id = AscGetEisaProductID(iop_base);
        if ((eisa_product_id == ASC_EISA_ID_740) ||
            (eisa_product_id == ASC_EISA_ID_750)) {
            if (AscFindSignature(iop_base)) {
                inpw(iop_base + 4);
                return (iop_base);
            }
        }

Anyone got a manual and can tell me why we do this?  ;-)

Would it make sense to put in a comment that says "No idea why we do this"?

> 5) I would suggest putting a "remove inpw/outpw pointless wrappers" 
> cleanup patch before patches #2 .. #N.

Next thing on my todo list is to convert the driver over to ioread8 and
friends.  Currently, only the wide boards get accessed through PCIMEM,
but the narrow boards also have PCIMEM BARs.  It would also allow the wide boards to be used on machines where PCIMEM is broken, like the VisWS.

> >+static __devexit int advansys_eisa_remove(struct device *dev)
> >+{
> >+	int i, ioport;
> >+	struct eisa_scsi_data *data = dev_get_drvdata(dev);
> >+
> >+	for (i = 0; i < 2; i++) {
> >+		struct Scsi_Host *shost = data->host[i];
> >+		if (!shost)
> >+			continue;
> >+		ioport = shost->io_port;
> >+		advansys_remove(data->host[i]);
> >+	}
> >+
> >+	return 0;
> 
> 6) set drvdata to NULL

Any reason why?

Oh, I seem to have forgotten the kfree() here too.  I'll fix that.

> 7) values much more readable when tab-aligned

ok.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
