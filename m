From: Jens Axboe <axboe@suse.de>
Subject: Re: writable mmc profiles actually are writable
Date: Tue, 7 Oct 2003 07:38:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007053858.GL972@suse.de>
References: <1064865746.4262.63.camel@patehci2> <1065460336.10804.1.camel@patehci2> <1065463946.5185.8.camel@patehci2> <20031006182223.GF972@suse.de> <20031006182510.GG972@suse.de> <1065469831.5185.44.camel@patehci2> <20031006203816.GJ972@suse.de> <1065473899.6835.41.camel@patehci2> <1065478448.2361.1.camel@patehci2> <1065484607.2899.7.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:49362 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261802AbTJGFjD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2003 01:39:03 -0400
Content-Disposition: inline
In-Reply-To: <1065484607.2899.7.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Oct 06 2003, Pat LaVarre wrote:
> Yep, still happy, same in -test6 as in -test5 e.g.
> 
> $ dmesg | grep ^sr
> sr0: scsi3-mmc drive: 125x/125x caddy
> sr0: scsi3-mmc maybe not writeable
> sr0: scsi3-mmc writable profile: 0x0002
> $
> $ grep MMC /proc/sys/dev/cdrom/info
> Can write other MMC-RW: 1 ...

I don't quite agree with this patch. Please add the GET_CONFIGURATION
stuff to cdrom.c instead so it works with ide-cd as well (ide-scsi is
basically dead, and the number of scsi drives out there isn't exactly
big and increasing). GPCMD_GET_CONFIGURATION already exists. Also, make
DVD-RAM drives set CDC_MMC_RW as well and only check for that at open.

-- 
Jens Axboe

