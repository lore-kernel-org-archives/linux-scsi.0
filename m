From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] target: simplify cmd to task mapping
Date: Wed, 17 Nov 2010 17:51:24 -0500
Message-ID: <20101117225124.GA7073@infradead.org>
References: <20101117213857.GB26557@infradead.org>
 <1290033607.31890.71.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34755 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935593Ab0KQWvZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 17:51:25 -0500
Content-Disposition: inline
In-Reply-To: <1290033607.31890.71.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Wed, Nov 17, 2010 at 02:40:07PM -0800, Nicholas A. Bellinger wrote:
> On Wed, 2010-11-17 at 16:38 -0500, Christoph Hellwig wrote:
> > The cmd to task mapping is almost the same for all control CDBs,
> > except for calling different backend methods to do the backed-specific
> > mapping.  Merge the code performing the mapping into a single
> > new transport_map_control_cmd_to_task helper, and kill the
> > transport_map_task callback by simplify calling the backend methods
> > directly for the single task for a control CDB, and hardcoding
> > ->map_task_SG for data CDBs.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This one looks very reasonable as the extra set of bitwise AND
> instructions is limited to control path code.
> 
> As for the first one, I don't really have a strong preference either
> way, as long as the difference for extra 4 AND instructions for the bulk
> 'fast past' case is really a wash on modern x86_64 silicon..

This one modifies the code touched by the first.  There's one if else
for data vs control path CDBs and then we switch the different types
of control CDBs.
