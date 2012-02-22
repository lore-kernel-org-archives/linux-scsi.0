From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH][SCSI] enclosure & ses: modernize and add target power
 management (take 2)
Date: Wed, 22 Feb 2012 15:12:26 -0500
Message-ID: <4F454C2A.7050806@interlog.com>
References: <CAA9_cmcgqQx4WZaWoSM=mgBAHNNZ6Y1RgZ5OwjW11qrspOcR1A@mail.gmail.com> <1321028069.21400.24.camel@nebulus.xyus.xyratex.com> <4EBD948E.9000104@interlog.com> <FC1F9E38C0703341A1A750524E2525A9018F9648@XYUS-EX22.xyus.xyratex.com> <3789993A-8AA9-4FBF-BBC0-3DD1CF1898D0@xyratex.com> <48CA4310-FA29-4F54-9841-F25F12569FC6@xyratex.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49317 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab2BVUMd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2012 15:12:33 -0500
In-Reply-To: <48CA4310-FA29-4F54-9841-F25F12569FC6@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 12-02-22 02:09 PM, Mark Salyzyn wrote:
> Coincident repair of enclosure and ses device support. Fix problems with setting enclosure values careful to preserve other settings. Corrected fault setting as well. Modernize code. Add support for Device Power Management via a new r/w device_power node in sysfs and some internal interfaces to permit them to be called in the future by error recovery escalation. Enclosures that do not support individual power management will always return a status that the device has power.

Mark,
One problem I found with the existing kernel SES/enclosure
support is that it assumes there is a well-formed
Element Descriptor diagnostic page. By well-formed I mean that
the page exists and there is a unique, sensible entry for each
element. By sensible I mean _not_ like this:
   "TP=9C;SN=PMW82562000C39A;F1=0311;VR=03;VC=6B58AD13;PN=0082562-11;"

I have a SAS-2 expander with an associated SES device that breaks
all those tidy assumptions (i.e. I did not make up that string).
I assume that your patches do not change the reliance on a
well-formed Element Descriptor diagnostic page. Is the peculiar
SES device I have (and most SES-1 devices which don't have
Element Descriptor diagnostic pages) worth worrying about?

Doug Gilbert



