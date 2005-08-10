From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aacraid probe breaks in scsi-block-2.6.git
Date: Wed, 10 Aug 2005 12:27:16 -0500
Message-ID: <1123694836.5134.14.camel@mulgrave>
References: <1123694406.30596.10.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:41623 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965224AbVHJR1Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 13:27:25 -0400
In-Reply-To: <1123694406.30596.10.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2005-08-10 at 10:20 -0700, Mark Haverkamp wrote:
> While trying out a recent mm kernel I noticed that when I loaded the
> aacraid  driver I saw errors probing the disks:
> 
> sdc : sector size 0 reported, assuming 512.
> SCSI device sdc: 1 512-byte hdwr sectors (0 MB)

Sigh, I guess this is because aacraid is making illegal assumptions
about the format of certain commands it emulates?

We had a similar issue with 3w-xxxx which assumed commands like INQUIRY,
READ_CAPACITY and MODE_SENSE only came from the kernel, so would never
have use_sg != 0.  This is, of course, wrong, since such commands can
and do come from SG_IO.

The fix is probably similar to the 3w-xxxx one.

James


