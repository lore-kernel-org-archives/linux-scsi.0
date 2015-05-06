From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/17] scsi_dh_alua: switch to scsi_execute()
Date: Wed, 6 May 2015 11:26:37 +0200
Message-ID: <20150506092637.GA26004@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48173 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbbEFJ0k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 May 2015 05:26:40 -0400
Content-Disposition: inline
In-Reply-To: <1430743343-47174-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, May 04, 2015 at 02:42:15PM +0200, Hannes Reinecke wrote:
> All commands are issued synchronously, so no need to open-code
> scsi_execute anymore.

Currently the alua codes doesn't set REQ_PREEMPT, and uses a GFP_NOIO
allocation.  Please document why changing these is safe/and or desirable.

Also it would be good to a change like this to the other device handlers,
as the code is copy and pasted everywhere, and only hp_sw has an asynchronous
case that can be handled separately.
