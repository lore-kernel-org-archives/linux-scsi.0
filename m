From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2 2.6.30-rc] cxgb3i -- add a refcnt to track ddp usage
Date: Sat, 13 Jun 2009 18:53:09 -0500
Message-ID: <1244937189.5323.63.camel@mulgrave.site>
References: <200906132129.n5DLT1l5029019@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42284 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556AbZFMXxM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Jun 2009 19:53:12 -0400
In-Reply-To: <200906132129.n5DLT1l5029019@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kxie@chelsio.com
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, michaelc@cs.wisc.edu

On Sat, 2009-06-13 at 14:29 -0700, kxie@chelsio.com wrote:
> [PATCH 1/2 2.6.30-rc] cxgb3i -- add a refcnt to track ddp usage
> 
> From: Karen Xie <kxie@chelsio.com>
> 
> The iscsi ddp functionality could be used by multiple iscsi entities,
> add a refcnt to keep track of it, so we would not release it pre-maturely.

The code is fine as it stands but, I wonder, would you consider using a
kref for this?  The reasons are twofold:

     1. It's a well understood kernel paradigm that works ... this would
        be helpful for the far distant time when chelsio no longer wants
        to maintain this driver.
     2. It includes useful and appropriate warnings for common bugs in
        refcounted code, such as use of a freed reference.

James


