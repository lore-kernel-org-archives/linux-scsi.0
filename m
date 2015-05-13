From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to
	RCU hlist
Date: Wed, 13 May 2015 07:32:33 +0200
Message-ID: <20150513053233.GA20663@lst.de>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-2-git-send-email-nab@daterainc.com> <5552696F.8080904@redhat.com> <1431493731.26897.35.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48217 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbbEMFcg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2015 01:32:36 -0400
Content-Disposition: inline
In-Reply-To: <1431493731.26897.35.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>

On Tue, May 12, 2015 at 10:08:51PM -0700, Nicholas A. Bellinger wrote:
> The series is bisectable.  With patch #1 in place ->device_list[] is
> still kzalloc()'ed, but new RCU pointer assignments are made into
> lun_entry_hlist[].
> 
> Squashing the RCU reader paths (#2-6) for merge is OK, but it's still
> nice to break up reader / updater changes into separate patches.

Having the full data structure switch over in one patch really makes
reviewing and understning the change a lot easier.  But changes to
say move to a mutex should indeed stay separate.  So patches 1-6
really should be mostly one.
