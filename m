From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Sun, 18 May 2003 12:35:55 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.52.0305181220320.6614@kai.makisara.local>
References: <20030516182039.A7369@lst.de> <20030516235718.GA3260@beaverton.ibm.com>
 <Pine.LNX.4.52.0305171248460.4436@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:28633 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262000AbTERJXH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 May 2003 05:23:07 -0400
In-Reply-To: <Pine.LNX.4.52.0305171248460.4436@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Sat, 17 May 2003, Kai Makisara wrote:

...
> I don't mind removal of the mt* files. I tested in 2.5.69-bk11 a
> modification to st that was essentially what Christoph has just
> posted. No problems there (i.e., tape found and works ok, sysfs shows
> the tape as SCSI device).
>
> However, when I add to this Christoph's patch to change probing, I don't
> find any tapes any more. What I did was to first modprobe aic7xxx.
...
> Modprobing st did not result in any messages (each attached tape causes
> one line to be printed). The tape device does not exist:
>
I have done more experiments that may be useful. I used both a SCSI disk
(sd) and a SCSI tape (st) to see if the problems are related to the high
level driver. The behaviour with sd and st was similar, i.e., this problem
is not related to st specifically.

The result from the experiments was that nothing will be recognised
properly after the sg driver is initialised. I had it in the kernel in the
first experiment. The same applies to using sg as a module. If I load
first sd and/or st, the devices will be recognised. If I load sg and then
sd and/or st, the devices will not be recognised. They are not properly
visible as sg devices either. It does not seem to matter if the HBA driver
is in kernel or a module or loaded before or after the high-level driver.

To some extent these results are expected. Your said that only one
high-level driver can be attached to one device. What is not explainable
is why they don't show as sg devices or in the sysfs /bus/scsi/devices
directory.

I think it should be possible to attach several high-level drivers to one
device. It is useful in some cases.

-- 
Kai
