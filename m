From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 7/24] advansys: Convert to EISA driver model
Date: Fri, 27 Jul 2007 10:17:39 -0400
Message-ID: <46A9FE83.4000403@garzik.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437533612-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58072 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759460AbXG0ORx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 10:17:53 -0400
In-Reply-To: <11855437533612-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> +static int __devinit advansys_eisa_probe(struct device *dev)
> +{
> +	int i, ioport;
> +	int err;
> +	struct eisa_device *edev = to_eisa_device(dev);
> +	struct eisa_scsi_data *data;
> +
> +	err = -ENOMEM;
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		goto fail;
> +	ioport = edev->base_addr + 0xc30;
> +
> +	err = -ENODEV;
> +	for (i = 0; i < 2; i++, ioport += 0x20) {
> +		if (!AscFindSignature(ioport))
> +			continue;
> +		inw(ioport + 4);
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

Same nit as with PCI:  recommend keeping the non-error path at the 
lowest indentation level for future-proof-ness and easy review.


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

what is the point of assigning ioport a never-used value?


