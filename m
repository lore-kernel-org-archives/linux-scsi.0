From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [GIT 3.2-rc PATCH 0/8] isci: platform and hardware enabling updates
Date: Sun, 18 Dec 2011 10:46:07 -0800
Message-ID: <CABE8wws_0WJgcgB1=Qtzkwr1nBQt2fLo_6S9oRzMfCOGURcjRA@mail.gmail.com>
References: <20111217004820.14133.19249.stgit@localhost6.localdomain6>
	<1324216168.3091.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:34573 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751939Ab1LRSqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Dec 2011 13:46:08 -0500
Received: by iazz13 with SMTP id z13so5423932iaz.25
        for <linux-scsi@vger.kernel.org>; Sun, 18 Dec 2011 10:46:07 -0800 (PST)
In-Reply-To: <1324216168.3091.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Dec 18, 2011 at 5:49 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2011-12-16 at 16:53 -0800, Dan Williams wrote:
>> These are priority updates, targeted for inclusion in 3.2-final, for=
 the
>> driver to honor the latest definition of oem parameters and support =
the
>> latest revision of silicon. =A0The oem parameter format (phy configu=
ration
>> settings passed along from platform firmware) has been updated to
>> revision 1.3, current driver only supports 1.0. =A0The C1 silicon up=
date
>> involves updates to the per-silicon-revision hard-coded phy tuning
>> recipes.
>
> The -rc tree is for bug fixes only, not whatever you choose to call
> "priority updates". =A0We have long established the position that a d=
river
> update, even to support new hardware, isn't a bug fix ...

These updates are aiming to get ahead of the bug reports that will be
filed as these platform changes get distributed.  Public bugzillas
seem to be the difference compared to some of the platform revision
specific updates that went into -rc6 via the drm tree.

> the
> distributions apply it through their enhancement processes. See below
> for the individual comments
>
>> This also updates the driver version from v1.0 to v1.1 to remove the
>> stale EXPERIMENTAL tag and reflect the C1 level of silicon support.
>>
>> A performance fix and a fix for a crash that can be triggered by
>> enabling a dev_dbg() statement are also included.
>>
>> Please apply, or pull from:
>>
>> =A0 git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git fixe=
s
>>
>> ...to receive:
>>
>> Dan Williams (2):
>> =A0 =A0 =A0 isci: cleanup oem parameter and recipe handling
>
> This isn't a bug fix

Certainly not, but I wanted git blame on the subsequent settings to
point to the commit where the value actually changed before adding
more line wrapped register writes.

>> =A0 =A0 =A0 isci: update version to 1.1

Mainline currently has v1.0+, and this reverts d962480e "[SCSI]
libsas: fix try_test_sas_gpio_gp_bit() build error", because it was
the wrong fix.

>>
>> Dave Jiang (1):
>> =A0 =A0 =A0 isci: oem parameter format v1.1 (ssc select)
>> Jeff Skirvin (3):
>> =A0 =A0 =A0 isci: update afe (analog-front-end) recipe for C1
>> =A0 =A0 =A0 isci: oem parameter format v1.3 (cable select)
>
> New silicon support is an enhancement not a bug fix (last three patch=
es)

I hate being put between a platform definition revision and a -rc windo=
w.

3.2 has an opportunity to ship with support for these settings that
affect link stability and meet signal integrity targets so I felt it
was worth calling these patches out separately from the wider updates
targeted for 3.3.

>> Maciej Trela (1):
>> =A0 =A0 =A0 isci: remove unused 'isci_tmf->device' field
>
> This isn't a bug fix.

Yeah, "kernel crash" made me throw it in the 'fixes' pile, but since
it is hidden behind enabling a dev_dbg() statement it can certainly be
deferred.

>> Marcin Tomczak (1):
>> =A0 =A0 =A0 isci: performance-fix, shorten default "no outbound task=
" timeout
>
> I don't quite see from the description how this is a performance
> enhancement? =A0It does nothing in the single initiator case, right?

This rate limits the link arbitration for how often the hardware
switches to a different remote-node-context.  At higher queue depths
we would see IOPs performance drop off rather than saturate, adjusting
this timeout corrected that condition.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
