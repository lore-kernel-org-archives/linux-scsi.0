From: Hannes Reinecke <hare@suse.de>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Fri, 10 Jun 2016 15:30:55 +0200
Message-ID: <575AC10F.7020504@suse.de>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
 <20160610131901.GA28570@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbcFJNcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2016 09:32:25 -0400
In-Reply-To: <20160610131901.GA28570@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu, "Martin K. Petersen" <martin.petersen@oracle.com>

On 06/10/2016 03:19 PM, Mike Snitzer wrote:
> On Mon, May 30 2016 at  3:24am -0400,
> Hannes Reinecke <hare@suse.de> wrote:
>=20
>> When checking a cloned request there is no need to check
>> the overall request size; this won't have changed even
>> when resubmitting to another queue.
>> Without this patch ppc64le on ibmvfc fails to boot.
>=20
> By simply removing the check aren't you papering over the real proble=
m?
> Looking at Martin's commit f31dc1cd490539 (which introduced the curre=
nt
> variant of the limits check) I'm not convinced it is equivalent to wh=
at
> he replaced.  I'll look closer in a bit.
>=20
The check itself is wrong, as we need (at least) to check the
max_hw_sectors here; the request is already fully assembled, so there i=
s
a really good chance he's going beyond the max_sectors.
But trying the error still was found to be present.
So I decided to rip it out, as the overall value of this check is zero.

> Also you categorized your fix was for "ppc64le on ibmvfc"; whereas Ma=
rk
> has reported this issue (off-list) against x86_64.  By making it seem
> ppc64le specific I didn't take this patch to be generally applicable.
>=20
Well, it has been observed on ppc64. That doesn't mean _only_ ppc64 is
affected. If it were ppc64 only it should've been marked as such, right=
?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
