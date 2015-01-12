From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 9/9] scsi_error: do not display kernel pointer in message
 logs
Date: Mon, 12 Jan 2015 14:29:55 +0100
Message-ID: <54B3CC53.6010909@suse.de>
References: <1420699430-9492-1-git-send-email-hare@suse.de>	 <1420699430-9492-10-git-send-email-hare@suse.de> <1421068346.3891.163.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbbALN35 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2015 08:29:57 -0500
In-Reply-To: <1421068346.3891.163.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 01/12/2015 02:12 PM, Ewan Milne wrote:
> On Thu, 2015-01-08 at 07:43 +0100, Hannes Reinecke wrote:
>> It is not good practice to display the kernel pointer
>> in any message logs, and it doesn't display any additional
>> information. And as we know have block-layer assigned tags
>> we can use them to differentiate the messages.
>> So remove any pointer references from the displayed messages.
>>
>=20
> I'd actually be sad to see this go -- I have found it useful
> in the past when debugging crash dumps from customer sites
> to be able to look in the kernel messages and see that a
> particular scsi_cmnd had been aborted just before the crash
> (and then later completed).
>=20
But that's precisely why we've prefixed the scmd messages with the
tag number; with that you'll be able to extract the same information.

And now that hch separated out the block layer tagging from SCSI-2
TCQ we should have the tag number available for any command, not
just those from drivers which use TCQ.

Let me know if that isn't the case; this patch indeed only makes
sense if the tag number is always available.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
