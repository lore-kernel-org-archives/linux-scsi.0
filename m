From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/4] async: introduce 'async_domain' type
Date: Fri, 25 May 2012 01:18:21 -0700
Message-ID: <CABE8wwtfW0FusNuOEmwMxZLVMTVSj0R9HCA5xLWidrgj_7Ax+A@mail.gmail.com>
References: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>
	<20120525075027.21933.75815.stgit@dwillia2-linux.jf.intel.com>
	<1337932267.2932.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:60854 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751423Ab2EYISY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 May 2012 04:18:24 -0400
Received: by bkcjc3 with SMTP id jc3so501878bkc.25
        for <linux-scsi@vger.kernel.org>; Fri, 25 May 2012 01:18:21 -0700 (PDT)
In-Reply-To: <1337932267.2932.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: mroos@linux.ee, linux-scsi@vger.kernel.org, Mark Brown <broonie@opensource.wolfsonmicro.com>, linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>, Liam Girdwood <lrg@ti.com>

On Fri, May 25, 2012 at 12:51 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2012-05-25 at 00:50 -0700, Dan Williams wrote:
>> This is in preparation for teaching async_synchronize_full() to sync=
 all
>> pending async work, and not just on the async_running domain. =A0Thi=
s
>> conversion is functionally equivalent, just embedding the existing l=
ist
>> in a new async_domain type.
>
> This looks good, but I want Arjan and others who invented the async c=
ode
> to speed up boot to comment on all of this. =A0What was the intention=
 of
> async_synchronize_full() and if it wasn't to synchronise all domains,
> should we fix the documentation and add a new primitive to do that,
> since boot clearly assumes the all domains behaviour.
>
> In the mean time, this is probably all a bit much for a merge window,=
 so
> I'll revert
>
> commit a7a20d103994fd760766e6c9d494daa569cbfe06
> Author: Dan Williams <dan.j.williams@intel.com>
> Date: =A0 Thu Mar 22 17:05:11 2012 -0700
>
> =A0 =A0[SCSI] sd: limit the scope of the async probe domain
>
> And we'll put whatever is chosen in early for the next merge window.
>

Makes sense... but could also go ahead with the smaller fix I posted
for 3.5.  Meelis confirms it is working.

Otherwise this leaves the pending libsas suspend/resume support in
limbo, since it will certainly deadlock in the case where any device
fails, or is slow to come back from resume.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
