From: Christoph Hellwig <hch@lst.de>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
	kmem_cache_create+0x1a9/0x330()
Date: Wed, 30 Jul 2014 19:59:58 +0200
Message-ID: <20140730175958.GA30976@lst.de>
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com> <20140718132104.GK27940@esperanza> <20140718141747.GA23272@lst.de> <53C97D34.5040707@gmail.com> <1405714046.30262.10.camel@dabdike.int.hansenpartnership.com> <20140719164454.GA24530@lst.de> <53CCDFC3.5010802@gmail.com> <20140726162102.GA7126@lst.de> <53D929C3.3040709@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48272 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbaG3SAE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 14:00:04 -0400
Content-Disposition: inline
In-Reply-To: <53D929C3.3040709@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: poma <pomidorabelisima@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vladimir Davydov <vdavydov@parallels.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>, Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org

On Wed, Jul 30, 2014 at 12:22:11PM -0500, Mike Christie wrote:
> Some drivers like qla2xxx do not set proc_name. I think if 2 drivers
> like that are loaded then you will hit some other warns/bugs in the kmem
> cache setup code right?

Drivers have to opt into using their own caches by setting .cmd_size
in the host template.  We could enforce they set ->proc_name for them,
but I'd rather keep the amount of sanity checks low unless there's a real
need.
