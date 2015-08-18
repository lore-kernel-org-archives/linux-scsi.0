From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH] lpfc: Fix possible use-after-free and double free in
 lpfc_mbx_cmpl_rdp_page_a2()
Date: Wed, 19 Aug 2015 00:27:51 +0200
Message-ID: <20150819002751.00000f06@localhost>
References: <1439809382-32419-1-git-send-email-jthumshirn@suse.de>
	<20150817232634.00006d80@localhost>
	<mqdfv3h5cia.fsf@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54687 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbbHRW2U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2015 18:28:20 -0400
In-Reply-To: <mqdfv3h5cia.fsf@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Colin King <colin.king@canonical.com>, Sebastian Herbszt <herbszt@gmx.de>

Johannes Thumshirn wrote:
> Sebastian Herbszt <herbszt@gmx.de> writes:
> 
> > Johannes Thumshirn wrote:
> >> If the bf_get() call in lpfc_mbx_cmpl_rdp_page_a2() does succeeds, execution
> >> continues normally and mp gets kfree()d.
> >> 
> >> If the subsequent call to lpfc_sli_issue_mbox() fails execution jumps to the
> >> error label where lpfc_mbuf_free() is called with mp->virt and mp->phys as
> >> function arguments. This is the use after free. Following the use after free mp
> >> gets kfree()d again which is a double free.
> >
> > A similar patch was posted by Colin Ian King on 2015-07-31 [1].
> >
> > [1] http://marc.info/?l=linux-scsi&m=143835937206204&w=2
> 
> OK,
> 
> Is it already in James' tree (haven't checked)? The problematic code was
> merged for 4.2-rc1 so if the fix (Collin's or mine I don't care) could go
> in while we're still in the rc phase, we could avoid all that stable
> circus.
> 
> Thanks for digging this out.
> 
> Byte,
>         Johannes

It is not yet in scsi.git.

James S., Dick, which patch do you prefer?

Sebastian
