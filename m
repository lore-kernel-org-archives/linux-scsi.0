From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: UAS crash with Apricorn USB3 SATA bridge
Date: Wed, 10 Dec 2014 01:04:58 -0800
Message-ID: <20141210090458.GA21955@birch.djwong.org>
References: <20141209193116.GA25163@birch.djwong.org>
 <548801F8.8080207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22689 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaLJJFL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2014 04:05:11 -0500
Content-Disposition: inline
In-Reply-To: <548801F8.8080207@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Wed, Dec 10, 2014 at 09:19:04AM +0100, Hans de Goede wrote:
> Hi,
> 
> On 09-12-14 20:31, Darrick J. Wong wrote:
> >Hi,
> >
> >I have an Apricorn USB 3 disk dongle thing that claims to support UAS.
> >However, the kernel crashes when I plug it in[1].
> 
> Yes there are some known issues with uas error handling which are fixed
> in 3.18, can you try with a 3.18 kernel please ?

The crash pic was from 3.18.0, blk_mq disabled.  I'll work on getting a fuller
dmesg output.  Looking at the code, it looks like we end up in
queue_bulk_sg_tx() with a sg list that is shorter than num_sgs, so we fall off
the end.

(Alas it's now 1am here, so I'm going to bed. :/ )

--D

> 
> Note that the device will likely still not work, but it should no
> longer crash things. When running 3.18 please collect the output of
> "dmesg" after plugging in the drive and send that to me, then we'll see
> if we can get it to work from there.
> 
> Regards,
> 
> Hans
