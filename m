From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [ANNOUNCE] Adaptec SAS/SATA device driver [0/27]
Date: Thu, 17 Feb 2005 14:57:04 -0600
Message-ID: <1108673824.5507.32.camel@mulgrave>
References: <4214D5B1.1060701@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:9625 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262353AbVBQU5H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 15:57:07 -0500
In-Reply-To: <4214D5B1.1060701@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-02-17 at 12:34 -0500, Luben Tuikov wrote:
> Adaptec would like to announce its SAS/SATA Linux device driver
> for inclusion into the Linux kernel.

Well, the initial reaction is yuk.

Just from a brief glance over the files, the code is full of obfuscation
and unnecessary compatibility gunk which needs removing.

It's also full of the same queueing junk that I asked be taken out of
the aic7xxx driver.

Then we get to the architectural stuff, which should really have been
discussed before you wrote the driver, not after

- We need a SAS and a PHY transport class.  Three of your files are to
do domain discover and should actually be part of the SAS transport
class.  In fact, it looks like a large amount of the code should be in
the various transport classes.

- The SATA pieces should use libata instead of trying to reinvent what
already exists.

James


