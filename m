From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT 3.2-rc PATCH 0/8] isci: platform and hardware enabling updates
Date: Wed, 21 Dec 2011 14:17:52 -0800
Message-ID: <CABE8wwusiqWOXmGqS1-0hpwg9m1PM=wy_odc0NQRoKcb2m1crg@mail.gmail.com>
References: <20111217004820.14133.19249.stgit@localhost6.localdomain6>
	<1324216168.3091.7.camel@dabdike.int.hansenpartnership.com>
	<CABE8wws_0WJgcgB1=Qtzkwr1nBQt2fLo_6S9oRzMfCOGURcjRA@mail.gmail.com>
	<1324501526.17423.13.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20192 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab1LUWR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2011 17:17:57 -0500
Received: by ggnq1 with SMTP id q1so5680697ggn.25
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2011 14:17:52 -0800 (PST)
In-Reply-To: <1324501526.17423.13.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 21, 2011 at 1:05 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>> >> Dan Williams (2):
>> >> =A0 =A0 =A0 isci: cleanup oem parameter and recipe handling
>> >
>> > This isn't a bug fix
>>
>> Certainly not, but I wanted git blame on the subsequent settings to
>> point to the commit where the value actually changed before adding
>> more line wrapped register writes.
>
> Anyone who uses git blame knows how to cope with that. =A0If we adopt=
ed
> that principle; we'd have tons of whitespace and code motion type
> changes in the stable trees, which isn't a good precedent.

Ok, I would not have submitted a cleanup like this to -stable... and
that's the litmus test I should use for queuing (or not as it were)
late -rc changes.

>> >> Dave Jiang (1):
>> >> =A0 =A0 =A0 isci: oem parameter format v1.1 (ssc select)
>> >> Jeff Skirvin (3):
>> >> =A0 =A0 =A0 isci: update afe (analog-front-end) recipe for C1
>> >> =A0 =A0 =A0 isci: oem parameter format v1.3 (cable select)
>> >
>> > New silicon support is an enhancement not a bug fix (last three pa=
tches)
>>
>> I hate being put between a platform definition revision and a -rc wi=
ndow.
>>
>> 3.2 has an opportunity to ship with support for these settings that
>> affect link stability and meet signal integrity targets so I felt it
>> was worth calling these patches out separately from the wider update=
s
>> targeted for 3.3.
>
> The process for updates is that they go into the next merge window (i=
=2Ee.
> for the 3.3 kernel). =A0If there's a case for adding this to 3.2 or
> earlier kernels, then the distros will do it.

3.3 material it is.

>> >> Maciej Trela (1):
>> >> =A0 =A0 =A0 isci: remove unused 'isci_tmf->device' field
>> >
>> > This isn't a bug fix.
>>
>> Yeah, "kernel crash" made me throw it in the 'fixes' pile, but since
>> it is hidden behind enabling a dev_dbg() statement it can certainly =
be
>> deferred.
>
> What kernel crash? =A0The changelog doesn't mention anything about it=
=2E

NULL de-reference of ->device.

"As the field was never set, isci_print_tmf() using 'isci_tmf->device'
sometimes causes a kernel crash if the dev_dbg() statement is
enabled."

>> >> Marcin Tomczak (1):
>> >> =A0 =A0 =A0 isci: performance-fix, shorten default "no outbound t=
ask" timeout
>> >
>> > I don't quite see from the description how this is a performance
>> > enhancement? =A0It does nothing in the single initiator case, righ=
t?
>>
>> This rate limits the link arbitration for how often the hardware
>> switches to a different remote-node-context. =A0At higher queue dept=
hs
>> we would see IOPs performance drop off rather than saturate, adjusti=
ng
>> this timeout corrected that condition.
>
> I think I still don't understand what this is. =A0All outbound links =
have
> to switch context rapidly in a multi-target environment with switches=
 on
> the order of microseconds ... where exactly is this 10s timeout you
> reduce to 2s triggered?

Not sure what gave the 1s unit impression, but now that I look the
units of the module parameter are wrong.  This value is in 256ns
increments (not 1us) so we are changing the target context switch rate
from 5us to 512ns.  This value is put to the phy's link layer control
register in sci_phy_link_layer_initialization().

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
