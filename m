From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC] 2.6.0 EDD enhancements
Date: 19 Dec 2003 16:03:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071867809.1943.39.camel@mulgrave>
References: <Pine.LNX.4.44.0312191254550.2465-100000@humbolt.us.dell.com>
	<20031219130129.B6530@lists.us.dell.com>
	<1071865401.1943.31.camel@mulgrave>
	<20031219143749.A8351@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:28323 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263600AbTLSVD6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2003 16:03:58 -0500
In-Reply-To: <20031219143749.A8351@lists.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@Dell.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-12-19 at 15:37, Matt Domsch wrote:
> Ok, I'll gladly make that change, but I still need a handle on the
> sdev_gendev.kobj in order to make the symlink:

the scsi device does its refcounting through the generic device (and
hence the kobject), so scsi_device_get() does get a handle on the
kobject for you (as well as doing some checks with the SCSI state model
and getting a handle on the underlying module).

> static inline struct device *
> sdev_to_gendev(struct scsi_device *sdev)
> {
>     return &sdev->sdev_gendev;
> }

I'm not too sure about this...exporting such a function might be seen as
encouraging further abuse...

James


