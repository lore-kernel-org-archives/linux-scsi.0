From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Thu, 23 May 2002 03:01:37 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E17Ahv7-0003Lb-00@the-village.bc.nu>
References: <20020522185349.D2819@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020522185349.D2819@redhat.com> from "Doug Ledford" at May 22, 2002 06:53:49 PM
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

> to tell it to set queue depths, I think the low level driver should be 
> allowed to call into the mid layer and have the mid layer adjust the queue 
> depth on a device.  This should, of course, be properly locked so that a 
> low level driver can change it's mind about a device's queue depth later 
> if it wishes and call back into the mid layer with a new queue depth 
> value without confusing the mid layer.

One thing I see consistently as a problem in the block layers in 2.4 is
that there is no way to say "thanks for the request you just threw at me
but Im busy right now" and to flag "busy/idle".

The network layer has a clean way to say "Im busy dont feed me",
"Im no longer busy, feed me" and also "thanks but I've just discovered I
am in fact busy have this request back anbd feed it me later"

It massively cleans up the interface handling compared to the wild hoops
things like qlogicisp jump through
