From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Signal when device is disconnected
Date: Wed, 13 May 2009 22:08:24 +0200
Message-ID: <4A0B28B8.6040705@interlog.com>
References: <1242236945846@dmwebmail.dmwebmail.chezphil.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46934 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZEMUI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2009 16:08:29 -0400
In-Reply-To: <1242236945846@dmwebmail.dmwebmail.chezphil.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phil Endecott <phil_joqdm_endecott@chezphil.org>
Cc: linux-scsi@vger.kernel.org

Phil Endecott wrote:
> Dear Experts,
> 
> The proc/bus/usb API has an ioctl that can arrange for the application 
> to receive a signal when the device is disconnected.  Is there anything 
> similar for the SCSI generic (or other SCSI) APIs?
> 
> Assuming that there isn't, I think I need to either poll the device to 
> see if it's still there, or listen on a netlink socket for a removal 
> uevent, or I need to find the USB device corresponding to the sg device 
> that I'm using and use its signal-on-removal ioctl.  In the latter case, 
> is there a way to traverse from an sg device's /sys directory to the 
> corresponding usb device's /sys directory?  /sys seems to be full of 
> symlinks but I can't find the one that I need in this case.
> 
> Basically I have a fairly simple user-space driver for a USB SCSI device 
> that uses the SCSI-generic API, and I want it to terminate tidily when 
> the device is detached.

Phil,
If you are using the lk 2.6 series (from around 2.6.15) then
you could use the inotify mechanism (look at 'man inotify'
to start with). For example, you could monitor the deletion of
/sys/class/scsi_generic/sg1/dev or the corresponsing device
node: /dev/sg1 .

Doug Gilbert
