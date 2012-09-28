From: Dan Williams <djbw@fb.com>
Subject: Re: [SCSI PATCH] sd: max-retries becomes configurable
Date: Fri, 28 Sep 2012 11:39:34 -0700
Message-ID: <CAA9_cmcB1UrvcEM+VQ57nmi2JgUQgXB4+Jj7=Je-5ZKp7k0t1w@mail.gmail.com>
References: <20120924210049.GA18527@havoc.gtf.org>
	<1348546019.2457.3.camel@dabdike>
	<yq1y5jw9pfd.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50864 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758488Ab2I1Sjf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2012 14:39:35 -0400
In-Reply-To: <yq1y5jw9pfd.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "dave.jiang" <dave.jiang@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>

On Wed, Sep 26, 2012 at 7:20 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
>
> James> On Mon, 2012-09-24 at 17:00 -0400, Jeff Garzik wrote:
>>>
>>> drivers/scsi/sd.c | 4 ++++ drivers/scsi/sd.h | 2 +- 2 files changed,
>>> 5 insertions(+), 1 deletion(-)
>
> James> I'm not opposed in principle to doing this (except that it should
> James> be a sysfs parameter like all our other controls),
>
> Now that we're in that department. I never got any feedback on the
> following patch.
>
> Hannes told me in person that he felt the eh_timeout belonged in
> scsi_device and not in the request queue. Whereas I favored making it a
> block layer tunable despite currently only being used by SCSI. Any
> opinions?
>

I think request_queue since tuning these parameters would be useful
for libata/libsas usage and libata is still on track to move out from
under scsi ;-).

Hm, how to extend this for the ata eh case?  I had a global hack to
make libata give up quicker [1], but I it would be better to have it
be per queue.  What about another tunable to limit how deep into the
recovery escalation to go?  For pure scsi it short circuits escalation
and for ata it limits tries ata_eh_reset(), and then the value of
eh_timeout_secs in the non-default case overrides those in
ata_eh_reset_timeouts..

--
Dan

[1]: "libata: reset once" http://marc.info/?l=linux-ide&m=134189240724489&w=2
...Dave found this does not work as advertised for libsas since we
don't end up applying force parameters to sas-ata links.  My test case
apparently fell out of eh early for another reason.
