From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 0/3] scsi: ufs & ums-*: fix module reference counting
Date: Thu, 8 Jan 2015 23:00:08 +0900
Message-ID: <CAC5umyj7=e9OxssjTMJ_QszY5y09j7puwDUnCn9wPbcEYob28w@mail.gmail.com>
References: <20150107142830.GA659@lst.de>
	<Pine.LNX.4.44L0.1501071004310.1374-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:39944 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbbAHOAK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2015 09:00:10 -0500
In-Reply-To: <Pine.LNX.4.44L0.1501071004310.1374-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

2015-01-08 0:09 GMT+09:00 Alan Stern <stern@rowland.harvard.edu>:
> On Wed, 7 Jan 2015, Christoph Hellwig wrote:
>
>> On Wed, Jan 07, 2015 at 11:02:59PM +0900, Akinobu Mita wrote:
>> > While accessing a scsi_device, the use count of the underlying LLDD module
>> > is incremented.  The module reference is retrieved through .module field of
>> > struct scsi_host_template.
>> >
>> > This mapping between scsi_device and underlying LLDD module works well
>> > except some scsi drivers (ufs and unusual usb storage drivers).  These
>> > drivers consist with core driver and actual LLDDs, and scsi_host_template
>> > is defined in the core driver.  So the actual LLDDs can be unloaded even if
>> > the scsi_device is being accessed.
>>
>> Why don't ufs and usb-storage define the host templates in the sub drivers?
>> That's what libata or the mpt fusion driver do.
>
> Originally the subdrivers were all part of usb-storage.  When they were
> split out into separate modules, there didn't seem to be any need to
> copy the host template into each one.  (Especially since some of the
> method pointers in the host template refer to routines in usb-storage
> itself, not in the subdrivers.)  The fact that the .module member was
> no longer adequate escaped our notice at the time.

For ufs, the reason why a host template is shared by sub drivers is similar
to usb-storage.  Originally there was only a single pci driver for ufs.
When platform driver for ufs was introduced, it was split into core driver
(ufshcd) and sub drivers (ufshcd-pci and ufshcd-pltfrm).  They require
exactly the same host template.

Is there any other preferable way to fix this problem?  The first time I
found this in ufs driver, I was trying to fix it by merging core and sub
drivers into a single compound module.  But I realized that usm-* drivers
have the same problem, then I decided to propose what this patch series do
instead.
