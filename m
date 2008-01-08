From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC] Common header file for FC definitions
Date: Tue, 8 Jan 2008 17:53:41 +0100
Message-ID: <20080108165341.GA13926@schmichrtp.de.ibm.com>
References: <20080108080924.GA6993@schmichrtp.de.ibm.com> <20080108131403.GA9643@infradead.org> <47839AEB.3090003@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:19466 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988AbYAHQxs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 11:53:48 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate2.uk.ibm.com (8.13.8/8.13.8) with ESMTP id m08Grlt7029506
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jan 2008 16:53:47 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m08GrjMc4788360
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jan 2008 16:53:47 GMT
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m08Grcpm003958
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jan 2008 16:53:39 GMT
Content-Disposition: inline
In-Reply-To: <47839AEB.3090003@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, robert.w.love@intel.com

On Tue, Jan 08, 2008 at 10:46:51AM -0500, James Smart wrote:
> Christoph Hellwig wrote:
> >On Tue, Jan 08, 2008 at 09:09:36AM +0100, Christof Schmitt wrote:
> >>zfcp has a couple of definitions to describe the FC protocol. Grepping
> >>through the complete source tree shows that e.g. the lpfc module makes
> >>similar private definitions. It think that it would make sense to
> >>introduce a global header file for FC related definitions that each FC
> >>driver can use.
> >>
> >>The attached patch contains some definitons that i found in zfcp and
> >>could be reused by other drivers.
> >>
> >>What do others think? Would this be useful?
> >
> >This is a very good idea.  It might make more sense to have the more or
> >less complete defintions for the fc protocol in the header.  Robert &
> >folks have been working on a software fc stack part as the fcoe header
> >so they might have one to contribute.
> 
> I Agree - A common header for standard FC definitions would be a good thing.
> 
> That said, we have to be a little lenient on when drivers convert over to
> the standard headers as there's likely code change required.

For zfcp, i would like to move the FC specific definitions out of the
zfcp_def.h header file. My idea would be to introduce a simple header
file like proposed and to adapt zfcp to use these.  I don't intend to
write header files for the full FC protocol, since zfcp only uses a
small part. When other drivers use more definitions, then the
definitions can be added to the existing file.

When other drivers want to use the global definitions, they can
include the global file, but they don't have to.

Would others also be interested in having structs in the global header
file for FC commands like this?

struct zfcp_ls_adisc {
	u8		code;
	u8		field[3];
	u32		hard_nport_id;
	u64		wwpn;
	u64		wwnn;
	u32		nport_id;
} __attribute__ ((packed));

This could be renamed to fc_ls_adisc and also be part of the global
header file. But probably it makes more sense to start simple now and
think about the common structs later.

Thanks for the comments.

Christof
