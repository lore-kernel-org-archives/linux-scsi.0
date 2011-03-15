From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 00/10] isci: core
Date: Tue, 15 Mar 2011 13:13:53 -0700
Message-ID: <AANLkTim2E+_cYQczRZrK_Kej=4HtuT=un9j-HdaWAquC@mail.gmail.com>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
	<4D7FA620.10004@garzik.org>
	<20110315175533.GA8291@infradead.org>
	<4D7FAB3A.9060903@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61354 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab1COUNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2011 16:13:54 -0400
Received: by fxm17 with SMTP id 17so980379fxm.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2011 13:13:53 -0700 (PDT)
In-Reply-To: <4D7FAB3A.9060903@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Tue, Mar 15, 2011 at 11:08 AM, Jeff Garzik <jeff@garzik.org> wrote:
> On 03/15/2011 01:55 PM, Christoph Hellwig wrote:
>>
>> On Tue, Mar 15, 2011 at 01:47:12PM -0400, Jeff Garzik wrote:
>>>
>>> Let's get this driver into staging for 2.6.39, if it isn't going to
>>> hit the merge window for 2.6.39.
>>>
>>> It would lame for such [presumably] high volume hardware to be in
>>> neither the main kernel, nor staging, at 2.6.39 release time.
>>
>> What's the point of staging? =A0That just causes tons of poinless ch=
urn.
>> Linus has made it clear that normal high volume hardware drivers can=
 go
>> in after the merge window. =A0So let's just polish it for another fe=
w
>> weeks and then put it in where it belongs.
>
> That's fine... if that really happens.
>
> It seemed like this was turning into another driver that would get he=
ld
> outside the kernel until it's "perfect." =A0If that is the case, Linu=
s has
> also made it clear we should get drivers for high volume, shipping ha=
rdware
> into the kernel, even if its staging, if the alternative is to deny u=
sers
> the driver.
>

Whether it is drivers/staging/ or drivers/scsi/ having a few more
weeks to at least allow for a SCSI focused review (and the resulting
cleanups / fixes) before merging is the important point.

Staging does not seem to be the location for high volume cleanups
after the merge window closes:
$ git diff --stat -M v2.6.38-rc1..v2.6.38 drivers/staging/
50 files changed, 832 insertions(+), 476 deletions(-)

=2E..though there is a precedent for taking large staging drivers post
merge window (commit 9d200153: Staging: add MSM framebuffer driver).

This looks like a way forward.  Barring objections I would also go
ahead and get the current git tree into -next just to flush out any
build / integration issues.  If we (community) end up deciding the
driver should still go to staging I can just do a late "git mv
drivers/scsi/isci drivers/staging/" prior to sending the pull request
to Greg.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
