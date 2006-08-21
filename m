From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI: sanitize INQUIRY strings
Date: Mon, 21 Aug 2006 12:27:45 -0600
Message-ID: <20060821182745.GB24068@parisc-linux.org>
References: <20060821161417.GB4340@parisc-linux.org> <Pine.LNX.4.44L0.0608211248490.8319-100000@iolanthe.rowland.org> <20060821173546.GA24068@parisc-linux.org> <20060821181132.GE29299@vienna.egenera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:7594 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932129AbWHUS1q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 14:27:46 -0400
Content-Disposition: inline
In-Reply-To: <20060821181132.GE29299@vienna.egenera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Aug 21, 2006 at 02:11:32PM -0400, Philip R. Auld wrote:
> As far as I can tell Alan is not trying to "ascertain the intention"
> of the firmware engineer, drug-crazed or otherwise. He is making sure
> that the array of bytes is printable. You, I think, are trying to
> get him to interepret the out-of-spec values. I think that's a
> mistake. It's not a string so NUL byte termination does not 
> apply. It's an array of what should be printable characters 
> of the specified length.

The device is out of spec.  The question is how to handle it.  Alan
thinks that a NUL should be treated as a space.  I think that a NUL
indicates the engineer didn't read the spec and intended the string to
stop there, probably padding with garbage.

Let's take the case of a fictional device that has a vendor string

TJD\0Hje9

I say that should be printed as "TJD     ".  You say that should be
printed as "TJD Hje9".
