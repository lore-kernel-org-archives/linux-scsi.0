From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [patch] scsi: use lock per host instead of per device for shared queue tag host
Date: Wed, 24 Jan 2007 17:02:33 -0800
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC078289A8@AVEXCH1.qlogic.org>
References: <B70A50D07063384EB9BCE3330D18414F02F5AF83@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6325 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965021AbXAYBCe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2007 20:02:34 -0500
Content-class: urn:content-classes:message
In-Reply-To: <B70A50D07063384EB9BCE3330D18414F02F5AF83@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>, Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, Promise_Linux <Promise_Linux@promise.com>, Jens Axboe <axboe@kernel.dk>

> It seems another driver(qla4xxx) is also using shared queue tag.
> It is natural to imagine there might be same symptom in that
> driver. But I don't know the driver and have no hardware so I
> can not say anything certain about it.

qla4xxx implements slightly differently, in the sense we don't have the
equivalent of         
struct st_ccb ccb[MU_MAX_REQUEST]; 
which is in struct st_hba. In other words we don't have a local array
which like stex to keep track of the outstanding commands to the hba.

We had a discussion on this one while implementing block-layer tagging
in qla4xxx and Jens Axboe added the test_and_set_bit() in the following
code in blk_queue_start_tag() to take care of it.
	do {
		tag = find_first_zero_bit(bqt->tag_map, bqt->max_depth);
		if (tag >= bqt->max_depth)
			return 1;
	} while (test_and_set_bit(tag, bqt->tag_map));
Please see the following link for the discussion
http://marc.theaimsgroup.com/?l=linux-scsi&m=115886351206726&w=2

Cheers
David Somayajulu
QLogic Corporation
