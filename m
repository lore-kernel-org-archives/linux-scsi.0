From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Fwd: [PATCH 1/1] sd: do not let LBPME bit stop the VPDs speak
Date: Thu, 10 Mar 2016 21:02:14 -0500
Message-ID: <yq1egbhn55l.fsf@sermon.lab.mkp.net>
References: <56df97e0.d08d420a.58e8f.3162@mx.google.com>
	<yq1mvq7qdcy.fsf@sermon.lab.mkp.net>
	<CAGnHSEnHG5i3EvwmcGZU5BXobUCQa7P+j+KKNrUyoS86s7d8Gg@mail.gmail.com>
	<CAGnHSE=X2Yd3p75D85jcgSUScKxKYZsueLdqMMiaJ_uBqb+XMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22301 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259AbcCKCCV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 21:02:21 -0500
In-Reply-To: <CAGnHSE=X2Yd3p75D85jcgSUScKxKYZsueLdqMMiaJ_uBqb+XMw@mail.gmail.com>
	(Tom Yan's message of "Thu, 10 Mar 2016 16:15:34 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom,

Tom> I just couldn't think of a case that the LBPME bit would actually
Tom> indicates that the VPDs should not be used. It's merely bad
Tom> implementation of Read Capacity (16), which doesn't practically
Tom> stops the device from supporting unmap (even if a similar device is
Tom> has broken unmap support, it doesn't mean that the vendor set the
Tom> LBPME bit to 0 because they want to tell you it's broken, it's just
Tom> they have broken unmap support IN ADDITION to a bad Read Capacity
Tom> (16) implementation).

We don't skip the entire VPD page if LBPME=1, just the parts that are
related to the logical block provisioning.

The reason we read those values in the first place is so that we can set
up discard. If the device signals that it does not support discard we
have had no reason to read them or parse them.

Since there are a plethora of USB-SATA devices out there that get this
incredibly wrong (including discarding blocks *outside* of the specified
block range), I am not going to blindly enable this feature.

If you want to tinker with your own setup that's fine. And you are
clearly capable of doing so.

I, however, have to be extremely cautious not to enable something that
might inadvertently cause data corruption for users out there. That's
all I care about.

If the device manufacturer had intended to support discards then they
would presumably have set the LBPME flag per the spec. And if they
intended to support it but messed up setting the single bit flag that
enables the feature, then I would not trust their implementation.

Tom> Also, doesn't the kernel ASSUME that the device support Write Same
Tom> (16) with Unmap bit set when the LBPME bit is 1 even if it has no
Tom> Block Limits and Logical Block Provisioning VPDs?

Yes, because there are many devices out there whose logical block
provisioning support predates the LBP VPD being added to the spec.

Tom> Isn't that even more lenient than what I am proposing?

If we were to entertain enabling discard on your device it would be by
way of quirking it. I am not going to change the heuristics to
accommodate a device that gets trivial things wrong.

-- 
Martin K. Petersen	Oracle Linux Engineering
