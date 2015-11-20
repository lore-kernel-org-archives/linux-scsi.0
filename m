From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/18] ALUA device handler update, part 1
Date: Fri, 20 Nov 2015 12:02:09 +0100
Message-ID: <564EFDB1.9000408@suse.de>
References: <1447081703-110552-1-git-send-email-hare@suse.de> <20151120104710.GA24871@lst.de> <564EFB65.6050603@suse.de> <20151120105433.GA25084@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759590AbbKTLCL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 06:02:11 -0500
In-Reply-To: <20151120105433.GA25084@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>

On 11/20/2015 11:54 AM, Christoph Hellwig wrote:
> On Fri, Nov 20, 2015 at 11:52:21AM +0100, Hannes Reinecke wrote:
>> One thing, though: I don't really agree with Barts objection that
>> moving to a workqueue would tie in too many resources.
>> Thing is, I'm not convinces that using a work queue is allocating
>> too many resources (we're speaking of 460 vs 240 bytes here).
>> Also we have to retry commands for quite some time (cite the
>> infamous NetApp takeover/giveback, which can take minutes).
>> If we were to handle that without workqueue we'd have to initiate
>> the retry from the end_io callback, causing a quite deep stack
>> recursion. Which I'm not really fond of.
>>
>> But if anyone has a better idea on how to handle retries without the
>> need for workqueues I'm all ears :-)
>=20
> I tend to agree with you, but you better warm up that discussion agai=
n
> on the old thread that actually has Bart on Cc.  Or just resend once
> Martin has merged this patch, and have discussion around that version=
=2E
>=20
=46ully agree. So I'm waiting for Martin to pick up the patches first.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
