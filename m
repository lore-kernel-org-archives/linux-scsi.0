From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Mon, 13 Jun 2005 17:59:53 -0500
Message-ID: <1118703593.5079.56.camel@mulgrave>
References: <20050530160147.GD14351@gmail.com>
	 <1117477040.4913.12.camel@mulgrave> <20050530190716.GA9239@gmail.com>
	 <1118081857.5045.49.camel@mulgrave> <20050607085710.GB9230@gmail.com>
	 <1118590709.4967.6.camel@mulgrave> <20050613145000.GA12057@gmail.com>
	 <1118674783.5079.9.camel@mulgrave> <20050613183719.GA8653@gmail.com>
	 <1118695847.5079.41.camel@mulgrave>  <20050613214208.GA7471@janus>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:8843 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261185AbVFMXAX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 19:00:23 -0400
In-Reply-To: <20050613214208.GA7471@janus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: Gr?goire Favre <gregoire.favre@gmail.com>, dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Mon, 2005-06-13 at 23:42 +0200, Frank van Maarseveen wrote:
> kernel:    Vendor: WANGTEK   Model: 5525ES SCSI       Rev: 73F 
> kernel:    Type:   Sequential-Access                  ANSI SCSI
> revision: 02
> kernel:   target0:0:4: Beginning Domain Validation
> kernel:   target0:0:4: Domain Validation skipping write tests
> kernel:  scsi0:0:4:0: Attempting to queue an ABORT message

The aic7xxx error handling is still very unreconstructed and DV takes
the driver through this if there's a mismatch.  My best guess is that
like Gr\'egoir's CD-ROM, your wangtek is claiming to support a speed it
cannot.  We find this out in DV, but not until we've gone through all
the error paths.  The quick fix is simply to set the bios to whatever
the tape eventually configures with (although you'll need the current
patch set to make that work properly).

James


