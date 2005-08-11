From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 11:07:55 -0500
Message-ID: <1123776475.5062.22.camel@mulgrave>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684D52@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27044 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932295AbVHKQV3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 12:21:29 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684D52@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Harald Seipp <SEIPP@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-08-11 at 11:51 -0400, Salyzyn, Mark wrote:
> The problem with pushing this policy to the user is that software
> applications have no means to determine that a device is currently
> in-use. For instance, the net result of pulling a device on a mounted
> filesystem is an eventual kernel panic.

The kernel only panics if you told it to with the mount option
errors=panic (or if you have errors=panic set in the superblock flags).

For file systems on removable devices you shouldn't be telling it to
panic on error, you should be telling it to continue or remount-ro.  If
you do this then you can happily yank the undelying device on a mounted
fs, which was one of the design goals of the 2.6 SCSI state model and
refcounting reworks.

James


