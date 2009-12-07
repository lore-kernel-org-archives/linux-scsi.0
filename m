From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: libsrp, srp_target_alloc() and srp_target_free()
Date: Tue, 8 Dec 2009 08:35:18 +0900
Message-ID: <20091208083353H.fujita.tomonori@lab.ntt.co.jp>
References: <e2e108260912060218xc8ffe1ftcd3cc4564fbea495@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:54194 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935282AbZLGXfW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Dec 2009 18:35:22 -0500
In-Reply-To: <e2e108260912060218xc8ffe1ftcd3cc4564fbea495@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bart.vanassche@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

On Sun, 6 Dec 2009 11:18:13 +0100
Bart Van Assche <bart.vanassche@gmail.com> wrote:

> There is an asymmetry between the libsrp functions srp_target_alloc()
> and srp_target_free(): the former sets the pointer to driver-private
> data by invoking dev_set_drvdata() while the latter does not clear
> this pointer. So once srp_target_free() finished invoking
> dev_get_drvdata() will return a dangling pointer. Would it be a good
> idea to add the following statement inside srp_target_free() just
> before this function returns ?
> 
> dev_set_drvdata(target->dev, NULL);

It's fine by me but I don't see any point.

For me, it's pretty clear that you can't use a pointer to something
after freeing it.

struct srp_target *target;

target = dev_get_drvdata(&dev->dev);
srp_target_free(target);

Then you want to do something like?

target = dev_get_drvdata(&dev->dev);
