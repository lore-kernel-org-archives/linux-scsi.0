From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] sd: fix lbprz discard granularity as expected
Date: Thu, 10 Mar 2016 21:16:20 -0500
Message-ID: <yq11t7hn4i3.fsf@sermon.lab.mkp.net>
References: <56e12d57.4b43620a.4c8c0.ffff9bc5@mx.google.com>
	<CAGnHSEkGybgU0KXGYg_RLvgbnKvAth4dyHuxMPsKzF7cQs7qgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26347 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933447AbcCKCQ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 21:16:27 -0500
In-Reply-To: <CAGnHSEkGybgU0KXGYg_RLvgbnKvAth4dyHuxMPsKzF7cQs7qgQ@mail.gmail.com>
	(Tom Yan's message of "Thu, 10 Mar 2016 17:15:12 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom> Nevertheless, I don't really quite get the sense of the original
Tom> commit anyway.  Isn't discard granularity the minimum size we can
Tom> discard? In that case why would it have anything to do with "read
Tom> zeroes"?

On devices that guarantee returning zeroes after discard we use the
feature to clear block ranges (for filesystem metadata, etc.).

A filesystem that clears a block range obviously needs every logical
block to be properly zeroed. And not just the portion that are a certain
size and aligned to a certain boundary.

Tom> Suppose we are handling a device reports a discard granularity of
Tom> 4096 bytes, while logical block size and physical block size are
Tom> both 512 bytes. For such a device, a single 512-byte discard
Tom> request should simply be rejected because it's not allowed by the
Tom> device.

Discard is advisory, the command will not get rejected.

Tom> When it's rejected, it doesn't mean that "the 512-byte block does
Tom> not read zeroes after being discarded"; instead, it's just "we did
Tom> not discard the 512-byte block as per requested because it's not
Tom> allowed".

We only honor discard_zeroes_data for devices that support WRITE SAME w/
UNMAP. And WRITE SAME will manually write any block that it can not
deprovision so you are guaranteed reliable results.

-- 
Martin K. Petersen	Oracle Linux Engineering
