From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove target parent limitiation
Date: Fri, 13 Jan 2006 20:37:42 +0100
Message-ID: <20060113193742.GA5668@lst.de>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA5F3@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:28897 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1422858AbWAMThv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 14:37:51 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA5F3@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Fri, Jan 13, 2006 at 12:01:53PM -0700, Moore, Eric wrote:
> On Friday, January 13, 2006 11:04 AM, Christoph Hellwig wrote:
> 
> > When James Smart fixed the issue of the userspace scan atributes
> > crashing the system with the FC transport class he added a patch to
> > let the transport class check if the parent is valid for a given
> > transport class.
> > 
> > When adding support for the integrated raid of fusion sas devices
> > we ran into a problem with that, as it didn't allow adding virtual
> > raid volumes without the transport class knowing about it.
> > 
> > So this patch adds a user_scan attribute instead, that takes over from
> > scsi_scan_host_selected if the transport class sets it and thus lets
> > the transport class control the user-initiated scanning.  As this
> > plugs the hole about user-initiated scanning the target_parent hook
> > goes away and we rely on callers of the scanning routines to do
> > something sensible.
> > 
> > For SAS this meant I had to switch from a spinlock to a mutex to
> > synchronize the topology linked lists, in FC they were completely
> > unsynchronized which seems wrong.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> 
> I noticed that rebasing the James git tree this morning, and 
> applying this patch, the following was missing.  This patch
> submitted earlier by Christoph solves the panic that occurs when
> unloading the mptsas modules, and reloading.  Please apply.

James put this in alraedy.

