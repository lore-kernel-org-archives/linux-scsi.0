From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 4 Feb 2008 15:45:19 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0802041530150.3034@hp.linux-foundation.org>
References: <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net> <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net> <1202144767.3096.38.camel@localhost.localdomain> <47A7488B.4080000@vlnb.net> <1202145901.3096.49.camel@localhost.localdomain>
 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org> <1202151989.11265.576.camel@haakon2.linux-iscsi.org> <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org> <20080204210121.GF18682@fieldses.org> <alpine.LFD.1.00.0802041317280.3034@hp.linux-foundation.org>
 <47A7986B.1070206@garzik.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36230 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587AbYBDXqB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 18:46:01 -0500
In-Reply-To: <47A7986B.1070206@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>



On Mon, 4 Feb 2008, Jeff Garzik wrote:
> 
> Well, speaking as a complete nutter who just finished the bare bones of an
> NFSv4 userland server[1]...  it depends on your approach.

You definitely are a complete nutter ;)

> If the userland server is the _only_ one accessing the data[2] -- i.e. the
> database server model where ls(1) shows a couple multi-gigabyte files or a raw
> partition -- then it's easy to get all the semantics right, including file
> handles.  You're not racing with local kernel fileserving.

It's not really simple in general even then. The problems come with file 
handles, and two big issues in particular:

 - handling a reboot (of the server) without impacting the client really 
   does need a "look up by file handle" operation (which you can do by 
   logging the pathname to filehandle translation, but it certainly gets 
   problematic).

 - non-Unix-like filesystems don't necessarily have a stable "st_ino" 
   field (ie it may change over a rename or have no meaning what-so-ever, 
   things like that), and that makes trying to generate a filehandle 
   really interesting for them.

I do agree that it's possible - we obviously _did_ have a user-level NFSD 
for a long while, after all - but it's quite painful if you want to handle 
things well. Only allowing access through the NFSD certainly helps a lot, 
but still doesn't make it quite as trivial as you claim ;)

Of course, I think you can make NFSv4 to use volatile filehandles instead 
of the traditional long-lived ones, and that really should avoid almost 
all of the problems with doing a NFSv4 server in user space. However, I'd 
expect there to be clients that don't do the whole volatile thing, or 
support the file handle becoming stale only at certain well-defined points 
(ie after renames, not at random reboot times).

			Linus
