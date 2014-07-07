From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] Use sdev_scsi2lun for SCSI parallel drivers
Date: Mon, 07 Jul 2014 12:05:04 +0200
Message-ID: <53BA70D0.70801@suse.de>
References: <1404474875-109997-1-git-send-email-hare@suse.de> <1404474875-109997-2-git-send-email-hare@suse.de> <20140704134437.GA12345@infradead.org> <53B6B646.5080301@suse.de> <20140705094147.GA18130@infradead.org> <53BA524B.7060400@suse.de> <20140707093746.GA12985@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbaGGKFH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 06:05:07 -0400
In-Reply-To: <20140707093746.GA12985@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 07/07/2014 11:37 AM, Christoph Hellwig wrote:
> On Mon, Jul 07, 2014 at 09:54:51AM +0200, Hannes Reinecke wrote:
>> 1) Isolate from any fallout due to the 64bit LUN changes. By introdu=
cing
>> accessors we are guaranteed that the drivers will only ever see LUN =
numbers
>> they are expecting.
>
> I really don't see the point.  The LUNs have to be passed up from the
> driver anyway, so seeing anything unexpect just doesn't make sense.
> Furthermore if we really are worried about this we should have assert=
s
> that the higher bytes aren't set, and also take care of the even more
> limited LUN size for SCSI-2.
>
>> 2) Using accessors allows us to eventually change the ->lun field to=
 'struct
>> scsi_lun', and call 'scsilun_to_int' only for display purposes. This=
 will
>> address the objection by Bart for
>> ib_srp, but applies to other drivers as well.
>
> So, for any SAM based drivers struct scsi_lun is the wire format anyw=
ay,
> so those are easy.  For SCSI-2 and older we can just use scsilun_to_i=
nt
> and easily get the back the LUN that came over the wire.  Is it worth=
 to
> micro optimize by not looking at the other fields?  I'd say no, but e=
ven
> if it is I'd rather see this as part of the series moving to embeddin=
g
> the scsi_lun.
>
> FYI, I've merged your first set of fixes for the printk specifiers, b=
ut
> I've not merged anything fixing the other warnings that the build but
> sent reports for for now.
>
Ok, so I'll be sending a patchset for fixing up the build warnings
(and keeping the current accesses to ->lun), and prepare a different=20
patchset moving everything onto accessors so that we can use struct=20
scsi_lun directly.
Agreed?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
