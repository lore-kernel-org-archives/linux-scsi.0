From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH, RFC] isci: simplify dma coherent allocation
Date: Wed, 13 Apr 2011 12:44:10 -0700
Message-ID: <BANLkTi=-9kf1ddmC_weQ0H_wRAi-wa6TZA@mail.gmail.com>
References: <20110408235518.GD18265@aontest.lm.intel.com>
	<1302676349.30034.36.camel@dwillia2-linux>
	<20110413164425.GA4279@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63415 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab1DMToL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2011 15:44:11 -0400
Received: by fxm17 with SMTP id 17so691482fxm.19
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2011 12:44:10 -0700 (PDT)
In-Reply-To: <20110413164425.GA4279@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "Nadolski, Edmund" <edmund.nadolski@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Wojcik, Artur" <artur.wojcik@intel.com>

On Wed, Apr 13, 2011 at 9:44 AM, hch@infradead.org <hch@infradead.org> =
wrote:
> On Tue, Apr 12, 2011 at 11:32:29PM -0700, Dan Williams wrote:
>> Thanks. =A0We can do this a bit simpler and just move ram initializa=
tion
>> completely out of the start path, where it does not really belong.
>>
>> I'll fold the fix below into the patch.
>
> That looks much better than the initial version. =A0I'm still not sur=
e
> there actually is much of a point of doing a lot of work in the
> start state handler. =A0Is there any fundamental reason for delaying =
work
> from the normal init path?
>

Probably everything above "/* Start all of the ports on this
controller */" can be moved to the normal init path.  "Start" should
just be "turn on the phys".

However, we'll need to revisit this allocation code when adding
power-management support (post 2.6.39) since the allocation is tied to
the register re-initialization.  Probably just add a devres group to
handle all the dma host memory areas for the controller, rather than
track the allocations individually.  But the simple patch is
sufficient for now.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
