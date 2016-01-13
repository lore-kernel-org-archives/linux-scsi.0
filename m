From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] target: Fix LUN_RESET active I/O handling for
	ACK_KREF
Date: Wed, 13 Jan 2016 10:29:25 +0100
Message-ID: <20160113092925.GA14377@lst.de>
References: <1452594245-921-1-git-send-email-nab@daterainc.com> <1452594245-921-2-git-send-email-nab@daterainc.com> <20160112152059.GB2294@lst.de> <56952AB0.1070806@sandisk.com> <20160113083446.GA13330@lst.de> <1452676477.27508.56.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41854 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbcAMJ32 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 04:29:28 -0500
Content-Disposition: inline
In-Reply-To: <1452676477.27508.56.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>

On Wed, Jan 13, 2016 at 01:14:37AM -0800, Nicholas A. Bellinger wrote:
> > Yes, that's what I meant.  I think it shoul be generally feasibly, but
> > would require a careful audit of the !TARGET_SCF_ACK_KREF code path
> > first.
> 
> No, no, no.
> 
> The whole point of TARGET_SCF_ACK_KREF was so the backend driver
> completion path calling check_stop_free() for one ->cmd_kref, and the
> fabric driver patch calling target_put_sess_cmd() for the second
> ->cmd_kref both complete before attempting to free se_cmd memory.
> 
> The hw fabric drivers that have a hard requirement for
> TARGET_SCF_ACK_KREF already use it, but it wouldn't hurt to convert the
> remaining ones to use it.

Oh, I misread what Bart said above - I though he meant to always
take the ref as well.
