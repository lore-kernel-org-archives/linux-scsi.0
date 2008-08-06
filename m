From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH][SCS] sd: Read Capacity if (16) fails
Date: Wed, 6 Aug 2008 08:25:21 -0600
Message-ID: <20080806142521.GK2055@parisc-linux.org>
References: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37872 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbYHFOZh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 10:25:37 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808061500450.1109@blonde.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 03:06:21PM +0100, Hugh Dickins wrote:
> Commit e0597d70012c82e16ee152270a55d89d8bf66693 (sd: Identify DIF protection
> type and application tag ownership) says that if a disk is formatted with
> Inquiry bit PROTECT=1, it is required to support Read Capacity(16).  But my
> SD cards, accessed by builtin cardreader and generic USB storage, disagree.
> 
> Therefore fall back to the familiar Read Capacity if Read Capacity(16) fails:
> without even showing the "failed" message since I expect this will be common.

How about we flip it around?  Unconditionally try READ CAPACITY 16 first,
then if that fails, try READ CAPACITY?  I suppose there's always the
possibility that a drive will go tits-up if it receives the RC16
command, so maybe we'll need a blacklist.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
