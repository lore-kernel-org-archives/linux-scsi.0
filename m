From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: softscsi patch
Date: Mon, 01 Jul 2002 16:04:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200207012004.g61K4wn03675@localhost.localdomain>
References: <willy@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id NAA11493
	for <linux-scsi@vger.kernel.org>; Mon, 1 Jul 2002 13:05:06 -0700
In-Reply-To: Message from Matthew Wilcox <willy@debian.org>
   of "Sun, 30 Jun 2002 22:20:43 BST." <20020630222043.B29045@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org, "David S. Miller" <davem@redhat.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

willy@debian.org said:
> This work shows up a hole in the current softirq API -- there's no
> support for unregistering a softirq (close_softirq or similar).  We
> should do this in scsi_exit -- make sure no softirqs are running while
> we unload. This probably isn't a problem in practice, but it'd be nice
> to fix it. 

Actually, there's another problem: open_softirq isn't an exported symbol, so 
the compile won't work when the entire scsi subsystem is a module (the usual 
case for distributions these days).

I'm currently booting the patch (with this change) to see how it works out.

James


