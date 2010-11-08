From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [USB] UAS: eliminate infinite loop; add debug print
Date: Mon, 8 Nov 2010 09:57:48 -0800 (PST)
Message-ID: <513136.91622.qm@web31804.mail.mud.yahoo.com>
References: <20101108173808.GA13326@kroah.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:35680 "HELO
	web31804.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753313Ab0KHR5v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Nov 2010 12:57:51 -0500
In-Reply-To: <20101108173808.GA13326@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

--- On Mon, 11/8/10, Greg KH <greg@kroah.com> wrote:
> On Mon, Nov 08, 2010 at 09:27:22AM
> -0800, Luben Tuikov wrote:
> > --- On Mon, 11/8/10, Matthew Wilcox <willy@linux.intel.com>
> wrote:
> > > -0700, Luben Tuikov wrote:
> > > > Eliminate an infinite loop whereby the SCSI
> layer
> > > > would reissue a command (which would be
> failed by
> > > > the driver) ad infinitum. (Invariably due to
> the
> > > > driver's profuse use of the
> > > > SCSI_MLQUEUE_DEVICE_BUSY returned result in
> its
> > > > queuecommand() method.)
> > > >=20
> > > > Also add a debug option and a few debug
> prints.
> > >=20
> > > Why have you added your own debug scheme instead
> of using
> > > dev_dbg?
> >=20
> > Because, this debug "scheme" produces copious and
> otherwise
> > unnecessary volume of debug information in a working
> driver. And
> > because you can turn it on/off just for this driver.
> It is intended to
> > be used only for debugging this driver and the UAS
> device(s) to which
> > the driver communicates. 99.9% of the time, this
> setting will be a 'N'
> > out there.=A0 And this is what the Kconfig help
> entry says: "If unsure,
> > say 'N'."
>=20
> dev_dbg() is able to be turned on and off dynamically when
> the kernel is
> running without rebuilding anything, which is what you
> really want to
> have happen for a driver being used by normal users.
>=20
> It also produces the output in a standard manner that we
> have all agreed
> to follow.

I'll modify the code in my tree and resubmit what I have now using dev_=
dbg. I'll also integrate the hint from Michal.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
