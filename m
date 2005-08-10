From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid probe breaks in scsi-block-2.6.git
Date: Wed, 10 Aug 2005 13:28:48 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684A0A@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:52866 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965233AbVHJRa7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 13:30:59 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Yup, James hit the nail on the head... :-(

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
Sent: Wednesday, August 10, 2005 1:27 PM
To: Mark Haverkamp
Cc: linux-scsi
Subject: Re: aacraid probe breaks in scsi-block-2.6.git

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


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
