From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] hptiop: HighPoint RocketRAID 3xxx controller driver
Date: Wed, 10 May 2006 01:59:36 +0400
Message-ID: <20060509215936.GD7237@mipter.zuzino.mipt.ru>
References: <200605092128.k49LSQ6R024308@mail.hypersurf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:32334 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751202AbWEIWBE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 May 2006 18:01:04 -0400
Received: by nf-out-0910.google.com with SMTP id b2so1291826nfe
        for <linux-scsi@vger.kernel.org>; Tue, 09 May 2006 15:01:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <200605092128.k49LSQ6R024308@mail.hypersurf.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Allen <amah@highpoint-tech.com>
Cc: linux-scsi@vger.kernel.org, 'Andrew Morton' <akpm@osdl.org>, linux-kernel@vger.kernel.org

On Tue, May 09, 2006 at 02:28:31PM -0700, Allen wrote:
> This is the first time driver submission of HighPoint RocketRAID 3xxx
> controllers.

Please, use sane mailer. Sane means:
* it shouldn't convert tab to space
* it shouldn't wrap long lines

> +static struct class_device_attribute hptiop_attr_ioctl = {
> + .attr = {
> +  .name = "ioctl",
> +  .mode = S_IWUSR,
> + },
> + .store = hptiop_store_ioctl
> +};

No way in hell. ioctls are done by defining ->ioctl method.
struct scsi_host_template has one. struct file_operations has one.
Quick grepping shows some subsystems also exctracted ->ioctl.

That plethora of HPT_IOCTL_* defines, where are you using them? What
arguments are passed in and out?

s/vender/vendor/ somewhere, also

