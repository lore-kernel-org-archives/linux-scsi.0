From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 7/21] advansys: Convert to EISA driver model
Date: Thu, 26 Jul 2007 15:38:56 -0400
Message-ID: <46A8F850.3070102@garzik.org>
References: 20070726171141.GE19275@parisc-linux.org <11854705772-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50937 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762832AbXGZTi6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 15:38:58 -0400
In-Reply-To: <11854705772-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> +static void __devexit advansys_remove(struct Scsi_Host *shost)
> +{
> +	int i;
> +	scsi_remove_host(shost);
> +	advansys_release(shost);
> +
> +	for (i = 0; i < asc_board_count; i++) {
> +		if (asc_host[i] == shost) {
> +			asc_host[i] = NULL;
> +			break;
> +		}
> +	}
> +}

1) IMO this should be in the PCI patch


> +static int __devinit advansys_eisa_probe(struct device *dev)
> +{
> +	int i, ioport;
> +	int err = -ENODEV;
> +	struct eisa_device *edev = to_eisa_device(dev);
> +
> +	struct eisa_scsi_data *data = kzalloc(sizeof(*data), GFP_KERNEL);

nits:

2) check for NULL

3) maybe it's just me, but the mixing initializers and allocation code 
is way too close to C99/C++ code/decl mixing.  I would declare 'data', 
then initialize it on an separate line.  But again, maybe that's just me.


> +	ioport = edev->base_addr + 0xc30;
> +
> +	for (i = 0; i < 2; i++, ioport += 0x20) {
> +		if (!AscFindSignature(ioport))
> +			continue;
> +		inw(ioport + 4);

4) would be nice to have a comment noting what this inw() does.

5) I would suggest putting a "remove inpw/outpw pointless wrappers" 
cleanup patch before patches #2 .. #N.


> +		data->host[i] = advansys_board_found(ioport, dev, ASC_IS_EISA);
> +		if (data->host[i])
> +			err = 0;
> +	}
> +
> +	if (err) {
> +		kfree(data);
> +	} else {
> +		dev_set_drvdata(dev, data);
> +	}
> +
> +	return err;
> +}
> +
> +static __devexit int advansys_eisa_remove(struct device *dev)
> +{
> +	int i, ioport;
> +	struct eisa_scsi_data *data = dev_get_drvdata(dev);
> +
> +	for (i = 0; i < 2; i++) {
> +		struct Scsi_Host *shost = data->host[i];
> +		if (!shost)
> +			continue;
> +		ioport = shost->io_port;
> +		advansys_remove(data->host[i]);
> +	}
> +
> +	return 0;

6) set drvdata to NULL


> +static struct eisa_driver advansys_eisa_driver = {
> +	.id_table = advansys_eisa_table,
> +	.driver = {
> +		.name = "advansys",
> +		.probe = advansys_eisa_probe,
> +		.remove = __devexit_p(advansys_eisa_remove),
> +	}

7) values much more readable when tab-aligned

