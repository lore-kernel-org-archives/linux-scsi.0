From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Fri, 16 May 2003 22:25:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030517022507.GA1480@linnie.riede.org>
References: <20030516182039.A7369@lst.de> <20030516235718.GA3260@beaverton.ibm.com>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcp02781107pcs.eatntn01.nj.comcast.net ([68.85.61.149]:5359
	"EHLO linnie.riede.org") by vger.kernel.org with ESMTP
	id S264649AbTEQCKD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 22:10:03 -0400
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.12.8/8.12.8) with ESMTP id h4H2P7Y8002289
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2003 22:25:07 -0400
Content-Disposition: inline
In-Reply-To: <20030516235718.GA3260@beaverton.ibm.com>; from andmike@us.ibm.com on Fri, May 16, 2003 at 19:57:18 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2003.05.16 19:57, Mike Anderson wrote:
> 
> I ran your patch and I dead locked on st_probe. This is due to the code
> in st_probe and osst_probe that do device registers on the
> sdev_driverfs_dev.bus which is the bus that the probe is being called
> from already. I had an old patch that removed these before due the driver
> model requirement that objects on the device list must be of one type.
> At the time I did not have a place to move these attributes.
> 
> We now have /bus/scsi/drivers/{uld} for driver attributes. We also could
> create a class for other attributes if needed. We can also use udev for
> the creation of special nodes.
> 
> ftp://ftp.kernel.org/pub/linux/utils/kernel/hotplug/
> 
> In the short term is the st and osst maintainers are ok with it we could
> remove them and then create them in there proper home.

As the osst maintainer I concur. I am going to need a class, I believe, as
I want to export some info from the tape header, i.e. per device (very
useful for me for support purposes). So some re-arrangement is going to
happen anyway.

Thanks, Willem Riede.
