From: "Yum Rayan" <yum.rayan@gmail.com>
Subject: Re:[PATCH] hptiop: HighPoint RocketRAID 3xxx controller driver
Date: Tue, 9 May 2006 16:29:47 -0700
Message-ID: <df35dfeb0605091629y6f2390f3lad8f99c7aad62c4f@mail.gmail.com>
References: <464B3C0C5BFD894FADEFDD94B6D734E488181E@taus-ies1.dom1.taus.us.thales>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:42262 "EHLO
	wr-out-0506.google.com") by vger.kernel.org with ESMTP
	id S932097AbWEIX3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 May 2006 19:29:48 -0400
Received: by wr-out-0506.google.com with SMTP id i12so25537wra
        for <linux-scsi@vger.kernel.org>; Tue, 09 May 2006 16:29:47 -0700 (PDT)
In-Reply-To: <464B3C0C5BFD894FADEFDD94B6D734E488181E@taus-ies1.dom1.taus.us.thales>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: amah@highpoint-tech.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@osdl.org

> +static ssize_t hptiop_show_devicelist(struct class_device *class_dev,
> char
> *buf)

There is a one value per sysfs attribute rule. Seems like you are
returning quite some info here.

> + /* map buffer to kernel. */
> + if (ioctl_k.inbuf_size) {
> +  ioctl_k.inbuf = kmalloc(ioctl_k.inbuf_size, GFP_KERNEL);
> +  if (!ioctl_k.inbuf) {
> +   dprintk("scsi%d: fail to alloc inbuf\n",
> +     hba->host->host_no);
> +   err = -ENOMEM;
> +   goto err_exit;
> +  }
> +
> +  if (copy_from_user(ioctl_k.inbuf,
> +    ioctl_u->inbuf, ioctl_k.inbuf_size)) {
> +   goto err_exit;
> +  }

You are essentially wrapping ioctl with sysfs and passing user space
buffers....

> + .proc_name                  = driver_name,

I believe this is going away.

> + printk(KERN_INFO "%s %s\n", driver_name_long, driver_ver);
> +
> + return pci_module_init(&hptiop_pci_driver);
> +}
> +

pci_register_driver? pci.h indicates that pci_module_init is being obsoleted...
