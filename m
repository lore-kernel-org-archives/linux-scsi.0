From: Jens Axboe <axboe@suse.de>
Subject: Re: writable mmc profiles actually are writable
Date: Mon, 6 Oct 2003 22:28:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031006202858.GH972@suse.de>
References: <1064271322.4797.9.camel@patehci2> <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2> <20030929164654.GS15415@suse.de> <1064855570.3184.3.camel@patehci2> <1064865746.4262.63.camel@patehci2> <1065460336.10804.1.camel@patehci2> <1065463946.5185.8.camel@patehci2> <20031006182223.GF972@suse.de> <1065471047.5185.48.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:59533 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261680AbTJFU3E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2003 16:29:04 -0400
Content-Disposition: inline
In-Reply-To: <1065471047.5185.48.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Oct 06 2003, Pat LaVarre wrote:
> > > +//   if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
> > > +//           return -EROFS;
> > > +//   if (!cd->device->writeable)
> > > +//           return 0;
> >
> > ... obviously wrong
> 
> May I ask why this patch is obviously wrong?

Allowing write open of a read-only device.

> What actually breaks?

Lots of stuff. As I mentioned, only DVD-RAM "type" media will work with
sending random writes, things like cd-rw require special treatment.

> How do we benefit from having cdrom.ko and sr_mod.ko redundantly refuse
> writes?
> 
> I figure I should try mount of a cd-rom with this patch.  Maybe I get
> mount -w when I wanted mount -r and then life goes downhill from there. 

> Or maybe iso fs doesn't try to write.  Or ...

iso fs doesn't support writing.

-- 
Jens Axboe

