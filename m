From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [patch 13/17] scsi: remove private implementation of
 get_unaligned_be32
Date: Wed, 29 Oct 2008 15:29:28 -0700
Message-ID: <1225319368.5496.3.camel@brick>
References: <200810292124.m9TLOjl1021276@imap1.linux-foundation.org>
	 <1225316894.3257.19.camel@localhost.localdomain>
	 <20081029150702.1a20310a.akpm@linux-foundation.org>
	 <1225318393.3257.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:31273 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbYJ2W3b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2008 18:29:31 -0400
Received: by yw-out-2324.google.com with SMTP id 9so98254ywe.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 15:29:30 -0700 (PDT)
In-Reply-To: <1225318393.3257.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Wed, 2008-10-29 at 17:13 -0500, James Bottomley wrote:
> > > No ... as I've said several times now, there's a debate going on about
> > > what we're supposed to be doing with all of this (either putting it in
> > > SCSI, pulling it out or just using the inline notation.
> > 
> > If I knew what the terrible word "it" is replacing, I'd know what the
> > above sentence means.
> 
> It being the correct way to handle multibyte SCSI problems.
> 
> > I'm kinda struggling to imagine why there's controversy, really.  scsi
> > has a private implementation of something which core kernel provides. 
> > Zap!
> 
> The main problems with the above are that a lot of people don't
> necessarily think Big Endian when they see SCSI (even though it's a BE
> bus), so the get_unaligned_beXX looks strange, and secondly most of the
> arrays we operate on are simple u8 ones, so sparse gets annoyed about
> sending a non BE quantity through a BE conversion ... I bet it even does
> this for the above patch.

It does not, the get_unaligned_* family is not typesafe (takes a void *)
as lots of people have u8 arrays or similar.  Even though it probably
should be.

> 
> > >  I'm not putting
> > > a patch like this in until we at least get some consensus.
> > 
> > I'll hang onto it, so there's nowhere to hide...
> 
> OK.
> 

Did you ever have some time to think about my suggestion regarding
defining some common packed structs for the different command formats
taht could be endian-annotated, then use the unaligned helpers against
pointers to these structs...so sparse would actually spot endian
mixups in scsi thereafter?

Harvey

