From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [linux-iscsi-devel] [question] deferred sense
Date: Wed, 5 Jan 2005 12:47:10 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B9B94AF@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:61408 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262288AbVAERrN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2005 12:47:13 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j05HlCr31871
	for <linux-scsi@vger.kernel.org>; Wed, 5 Jan 2005 09:47:12 -0800
Received: from otce2k01.adaptec.com (otce2k01.adaptec.com [10.12.1.83])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j05HlCx02566
	for <linux-scsi@vger.kernel.org>; Wed, 5 Jan 2005 09:47:12 -0800
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

James Bottomley sez:
> The most common case for deferred sense is using a writeback cache.
> Here the device takes the write into its cache and returns GOOD.
Later
> trying to write it to the device it gets a medium error and now tries
to
> send deferred sense saying "you remember that write I told you worked,
> well actually..."  by this time, we've already acknowledged the write
to
> the block layer and any JFS will proceed on the assumption that it
> completed.  There's no way we can go back in time and apply this error
> to an already completed transaction.  However, the device has violated
> the journalling assumptions, and the FS will be corrupt.
> 
> So does anyone have any better suggestions for handling deferred
sense?

Change the assumptions in Journalling filesystems and make it work in a
deferred sense environment.

Don't delete the Journal until a safe point of time when the writeback
is confirmed either by underlying knowledge, time (flush interval
passed), amount of data (dirty cache is forced flushed), or a read-back
(resulting from the deferred error investigation). RAID cards and
external enclosures do this all the time, but to be fair with usually
more knowledge of all the cache handling.

Sincerely -- Mark Salyzyn
