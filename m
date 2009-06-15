From: "Karen Xie" <kxie@chelsio.com>
Subject: RE: [PATCH 1/2 2.6.30-rc] cxgb3i -- add a refcnt to track ddp usage
Date: Mon, 15 Jun 2009 11:10:42 -0700
Message-ID: <8A71B368A89016469F72CD08050AD33405A4160B@maui.asicdesigners.com>
References: <200906132129.n5DLT1l5029019@localhost.localdomain> <1244937189.5323.63.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:26759 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZFOSIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2009 14:08:53 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, michaelc@cs.wisc.edu

Hi, James,

Thanks, I've re-submitted the patches to use kref instead.

Best regards,
Karen

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Saturday, June 13, 2009 4:53 PM
To: Karen Xie
Cc: linux-scsi@vger.kernel.org; open-iscsi@googlegroups.com;
michaelc@cs.wisc.edu
Subject: Re: [PATCH 1/2 2.6.30-rc] cxgb3i -- add a refcnt to track ddp
usage

On Sat, 2009-06-13 at 14:29 -0700, kxie@chelsio.com wrote:
> [PATCH 1/2 2.6.30-rc] cxgb3i -- add a refcnt to track ddp usage
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> The iscsi ddp functionality could be used by multiple iscsi entities,
> add a refcnt to keep track of it, so we would not release it
pre-maturely.

The code is fine as it stands but, I wonder, would you consider using a
kref for this?  The reasons are twofold:

     1. It's a well understood kernel paradigm that works ... this would
        be helpful for the far distant time when chelsio no longer wants
        to maintain this driver.
     2. It includes useful and appropriate warnings for common bugs in
        refcounted code, such as use of a freed reference.

James


