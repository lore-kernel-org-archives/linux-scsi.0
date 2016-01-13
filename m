From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/1] scsi: add Synology to 1024 sector blacklist
Date: Wed, 13 Jan 2016 01:56:17 -0800
Message-ID: <1452678977.27508.82.camel@haakon3.risingtidesystems.com>
References: <1452206045-18332-1-git-send-email-mchristi@redhat.com>
	 <56953DEF.1050306@redhat.com>
	 <1452677624.27508.70.camel@haakon3.risingtidesystems.com>
	 <56961BC0.6090101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59107 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbcAMJ4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2016 04:56:20 -0500
In-Reply-To: <56961BC0.6090101@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: mchristi@redhat.com, linux-scsi@vger.kernel.org

On Wed, 2016-01-13 at 10:41 +0100, Paolo Bonzini wrote:
> 
> On 13/01/2016 10:33, Nicholas A. Bellinger wrote:
> >>> This results in IO errors when
> >>> handling large IOs. This patch just has us use the old 1024 default
> >>> sectors for this target by adding it to the scsi blacklist. We do
> >>> not have good contacs with this vendors, so I have not been able to
> >>> try and fix on their side.
> >>
> >> IIRC I saw similar problems a
> >> couple years ago with LIO because iscsit_map_iovec maps everything a
> >> page at a time and produced too large an iovec for the underlying
> >> storage.  I'm afraid you're going to get this for pretty much every user
> >> of LIO.
> > 
> > Two points here.
> > 
> > We've been exposing backend dev->dev_attrib.hw_max_sectors settings for
> > block limits EVPD for FILEIO based on iov limits, and IBLOCK based on
> > queue_max_hw_sectors() for some time now.
> > 
> > So initiators that honor block limits EVPD will work as expected.
> 
> What I was describing is more like the backend request_queue's
> queue_max_segments influencing the backend's hw_max_sectors.  Is that
> covered as well?

Nope, or at least not in iblock_configure_device() code.

The MAXIMUM TRANSFER LENGTH in block limits EVPD for IBLOCK is
queue_max_hw_sectors() * bdev_logical_block_size, and
queue_max_segments() is not considered atm.

Is there a case where MTL needs to be the smaller of the two..?

