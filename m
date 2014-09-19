From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 20/22] scsi: align logging messages
Date: Fri, 19 Sep 2014 08:26:29 +0200
Message-ID: <541BCC95.1010901@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <1409247216-76074-21-git-send-email-hare@suse.de> <20140831222556.GL16432@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958C2F65E@G9W0745.americas.hpqcorp.net> <20140906003403.GB18426@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958C8BDA3@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627AbaISG0d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Sep 2014 02:26:33 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C8BDA3@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On 09/19/2014 01:58 AM, Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: Christoph Hellwig [mailto:hch@infradead.org]
> ...
>>> scmd ties the messages together so you can tell which command
>>> has gotten to which state.  grep works.
>>
>> Can we just print the tag instead, that would be a much more human
>> readable number normally.
>
> I made a local patch to add the tag (scmd->request->tag), and it does
> look good.  I endorse dropping scmd %p in favor of just the tag,
> and trying to include the tag in all the lines (here, the Done,
> Result, CDB, Sense Key, and Add. Sense lines do not)
>
I would rather use 'scmd->tag', as this should be a straight copy
of scmd->request->tag, but we wouldn't need to reference the request
when doing so.

But yeah, I was planning on doing the same, only I'd rather include
it right a the start like

sd 2:0:0:3 [sdv] tag#1: abort scheduled

and print out a mapping when I/O is submitted

sd 2:0:0:3 [sdv] tag#1: scmd 0xffff880420891470

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
