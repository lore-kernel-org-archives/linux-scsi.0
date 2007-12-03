From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: aic94xx or libsas crash on X7DB3 supermicro with enclosure and
	sata drives
Date: Mon, 3 Dec 2007 11:36:53 -0800
Message-ID: <20071203193652.GB7066@tree.beaverton.ibm.com>
References: <200711301022.08001.kb@sysmikro.com.pl> <20071130213313.GA7066@tree.beaverton.ibm.com> <200712031709.54168.kb@sysmikro.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:38195 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbXLCThk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2007 14:37:40 -0500
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB3JbYVp023795
	for <linux-scsi@vger.kernel.org>; Mon, 3 Dec 2007 14:37:34 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB3JbQrG119150
	for <linux-scsi@vger.kernel.org>; Mon, 3 Dec 2007 12:37:28 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB3JbHeG004856
	for <linux-scsi@vger.kernel.org>; Mon, 3 Dec 2007 12:37:17 -0700
Content-Disposition: inline
In-Reply-To: <200712031709.54168.kb@sysmikro.com.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof B??aszkowski <kb@sysmikro.com.pl>
Cc: linux-scsi@vger.kernel.org, vst@vlnb.net, Alexis Bruemmer <alexisb@us.ibm.com>

On Mon, Dec 03, 2007 at 05:09:54PM +0100, Krzysztof B??aszkowski wrote:
> 
> I noticed also another failure when i removed a drive. The event was not 
> notified by anything (ie the block device and corresponding sg were 
> registered) so i run dd on this truly "virtual" drive.
> 
> dd reached D state (as well as scsi_wq) . i think it shouldn't happen no 
> matter it was AIC failure or LSI expander failure.

"It's wireless!" ;)

Seriously, though, it's a good idea to tell the kernel that you're
about to unplug a disk before actually doing it:

echo 1 > /sys/block/sdX/device/delete

This way, the kernel can tell the disk to flush its caches long before
power actually gets removed.  Otherwise, the device removal code can
get hung up just like you observed, and whatever's in the write cache
may or may not actually get written to the media.

--D
