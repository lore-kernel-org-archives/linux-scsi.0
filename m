From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] virtio_scsi: support multi hw queue of blk-mq
Date: Tue, 11 Nov 2014 18:09:17 +0100
Message-ID: <546242BD.5010902@redhat.com>
References: <1415552224-31145-1-git-send-email-ming.lei@canonical.com> <1415552224-31145-3-git-send-email-ming.lei@canonical.com> <54609667.8030702@redhat.com> <20141110133930.GA3115@lst.de> <CACVXFVMdUVfXNoC0FDhmaQtxehCBgG3xnTx-PJ3BmoQaT1LsoQ@mail.gmail.com> <20141110160506.GB15315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbaKKRJa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2014 12:09:30 -0500
In-Reply-To: <20141110160506.GB15315@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Cc: James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Linux SCSI List <linux-scsi@vger.kernel.org>



On 10/11/2014 17:05, Christoph Hellwig wrote:
> 
>  a) there is no multiath support for it, and we simply can't break existing
>     setups that use.
>  b) there is no support for I/O schedulers at all.  This might be okay
>     for virtio-scsi, where in general you have a host scheduler, but for
>     real hardware that still has to deal with more spinning rust than
>     solid state it's a blocker.  Fortuntely Jens is working on that one.

It is sort-of okay for virtio-scsi (and virtio-blk).  Deadline provides
a good speedup over noop for virtual disks, even in the presence of a
host scheduler---though nobody ever benchmarked why.

Paolo
