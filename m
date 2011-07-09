From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 20/20] target: change alloc_task call to take *cdb, not
 *cmd
Date: Sat, 9 Jul 2011 06:11:05 -0400
Message-ID: <20110709101105.GA26456@infradead.org>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
 <1310174329-22228-21-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42041
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab1GIKLH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jul 2011 06:11:07 -0400
Content-Disposition: inline
In-Reply-To: <1310174329-22228-21-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jul 08, 2011 at 06:18:49PM -0700, Andy Grover wrote:
> The transports really don't need the entire struct se_cmd to allocate
> the memory for the se_task. If it wasn't for pscsi, they wouldn't even
> need the *cdb.
> 
> Modify pscsi to allocate space for cdb at the end of pscsi_plugin_task,
> instead of a separate allocation.

Nice one!  Note that except for pscsi we really don't need se_tasks
to start with.  I'm not sure how easy it is to move the whole task
logic into it, but just allowing the other transports to allocate a
single se_task + se_cmd + private data in one go should avoid one
more memory allocation.

