From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] SD driver question
Date: Thu, 05 Jul 2007 15:37:46 -0500
Message-ID: <1183667866.3448.61.camel@localhost.localdomain>
References: <468BCE5C.6000707@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58336 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759809AbXGEUhs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 16:37:48 -0400
In-Reply-To: <468BCE5C.6000707@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed, 2007-07-04 at 18:44 +0200, Gabriel C wrote: 
> Is there any reason why sd is printing the driver informations for each 
> disk twice in dmesg ?

Yes, it's because of the genhd revalidate rework done by Al Viro in the
block device revalidation path.  The problem is that we need to run a
disk revalidate early on in sd bringup to get all the necessary
information ... the gendisk code then does a disk revalidate to read the
partition table, resulting in the two identical sets of messages being
printed.  The best fix anyone could suggest was to try to suppress the
messages of the first one using some sort of per scsi_disk flag ...
however, no-one's very keen on this approach.

James


