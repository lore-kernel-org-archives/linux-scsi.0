From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 20/22] scsi: align logging messages
Date: Fri, 19 Sep 2014 13:56:24 +0200
Message-ID: <541C19E8.1050105@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <1409247216-76074-21-git-send-email-hare@suse.de> <20140831222556.GL16432@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958C2F65E@G9W0745.americas.hpqcorp.net> <20140906003403.GB18426@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958C8BDA3@G9W0745.americas.hpqcorp.net> <541BCC95.1010901@suse.de> <20140919113500.GA29869@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbaISL42 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Sep 2014 07:56:28 -0400
In-Reply-To: <20140919113500.GA29869@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On 09/19/2014 01:35 PM, Christoph Hellwig wrote:
> On Fri, Sep 19, 2014 at 08:26:29AM +0200, Hannes Reinecke wrote:
>> I would rather use 'scmd->tag', as this should be a straight copy
>> of scmd->request->tag, but we wouldn't need to reference the request
>> when doing so.
>
> Yes, for now scmd->tag is correct as drivers might not be using the
> block level tagging.  Once we get rid of the legacy request path I
> plan to entirely remove scmd->tag, though.
>
>> But yeah, I was planning on doing the same, only I'd rather include
>> it right a the start like
>>
>> sd 2:0:0:3 [sdv] tag#1: abort scheduled
>
> Sounds fine.
>
>> and print out a mapping when I/O is submitted
>>
>> sd 2:0:0:3 [sdv] tag#1: scmd 0xffff880420891470
>
> I don't really see a need for that.
>
That's mainly for debugging; it gives you a nice starting point
for debugging crash dumps.
Otherwise it's really hard to get to the actual commands.

Unless you have a better idea ...

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
