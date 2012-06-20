From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/7] Revert "usb/uas: make sure data urb is gone if we
 receive status before that"
Date: Wed, 20 Jun 2012 16:56:26 -0700
Message-ID: <20120620235626.GC31520@kroah.com>
References: <1340092494-18876-1-git-send-email-kraxel@redhat.com>
 <1340092494-18876-2-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40050 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610Ab2FTX43 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jun 2012 19:56:29 -0400
Received: by dady13 with SMTP id y13so54978dad.19
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jun 2012 16:56:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1340092494-18876-2-git-send-email-kraxel@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jun 19, 2012 at 09:54:48AM +0200, Gerd Hoffmann wrote:
> This reverts commit e4d8318a85779b25b880187b1b1c44e797bd7d4b.
> 
> This patch makes uas.c call usb_unlink_urb on data urbs.  The data urbs
> get freed in the completion callback.  This is illegal according to the
> usb_unlink_urb documentation.
> 
> This patch also makes the code expect the data completion callback
> being called before the status completion callback.  This isn't
> guaranteed to be the case, even though the actual data transfer should
> be finished by the time the status is received.
> 
> Background:  The ehci irq handler for example only know that there are
> finished transfers, it then has go check the QHs & TDs to see which
> transfers did actually finish.  It has no way to figure in which order
> the transfers did complete.  The xhci driver can call the callbacks in
> completion order thanks to the event queue.  This does nicely explain
> why the driver is solid on a (usb2) xhci port whereas it goes crazy on
> ehci in my testing.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---

Should this revert also go into 3.4-stable so that the device will work
properly on ehci?

thanks,

greg k-h
