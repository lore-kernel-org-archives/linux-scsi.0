From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] uas: leave can_queue as MAX_CMNDS if device reports
 larger qdepth
Date: Mon, 23 May 2016 10:27:37 -0700
Message-ID: <1464024457.2331.10.camel@HansenPartnership.com>
References: <574329ae.c726620a.60f3.ffffd14b@mx.google.com>
	 <20160523170025.GA3309@kroah.com>
	 <CAGnHSE=Gt3XP9g5KpEyYUWGdw-kwqGDKpBQzd5qagxrjeHsxRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34770 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102AbcEWR1l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2016 13:27:41 -0400
In-Reply-To: <CAGnHSE=Gt3XP9g5KpEyYUWGdw-kwqGDKpBQzd5qagxrjeHsxRA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, hdegoede@redhat.com

On Tue, 2016-05-24 at 01:23 +0800, Tom Yan wrote:
> Nothing wrong. It's just .can_queue = MAX_CMNDS in the host template
> is no longer neceesary, since with his patch, uas will set can_queue
> again later (to devinfo->qdepth - 2).
> 
> Originally I thought .can_queue = MAX_CMNDS can hence be removed; but
> after a second thought, I think it might probably be better if we
> leave it there and make use of it, in case certain device somehow
> inapproriately reports an enormous qdepth (i.e. larger than
> MAX_CMNDS). (According to the commit message of 55ff8cfbc4e1 ("USB:
> uas: Reduce can_queue to MAX_CMNDS"), "The uas driver can never queue
> more then MAX_CMNDS...")

OK, so try this as an exercise: Why would this not be the right thing
to do after the host is prepared:  It has to do with the streams
resources the driver has already created.

James


