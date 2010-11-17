From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] target: simplify cmd transformation
Date: Wed, 17 Nov 2010 17:32:07 -0500
Message-ID: <20101117223207.GC26760@infradead.org>
References: <20101117213847.GA26557@infradead.org>
 <1290032519.31890.56.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49033 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935471Ab0KQWcI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 17:32:08 -0500
Content-Disposition: inline
In-Reply-To: <1290032519.31890.56.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Wed, Nov 17, 2010 at 02:21:59PM -0800, Nicholas A. Bellinger wrote:
> On Wed, 2010-11-17 at 16:38 -0500, Christoph Hellwig wrote:
> > There is no need for the transport_cdb_transform function pointer,
> > we can simply call the right code based on the cmd flags.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> 
> Hmmm, it is really less expensive to drop cmd->transport_cdb_transport()
> and change transport_generic_new_cmd() to require 4 bitwise AND instructions
> for each bulk SCF_SCSI_DATA_SG_IO_CDB cmd..?

The pointer bloats every single command in flight, and CPU time is
getting really cheap these days.  Either way this will get much simpler
after a few more patches.  See the next one for a first preview.

