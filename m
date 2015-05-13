From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/12] target: Convert REPORT_LUN + MODE_SENSE to RCU
	reader
Date: Wed, 13 May 2015 07:47:54 +0200
Message-ID: <20150513054754.GB20825@lst.de>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431422736-29125-3-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 12, 2015 at 09:25:26AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts SPC emulation for REPORT_LUN + MODE_SENSE to use
> RCU read locks for se_node_acl->lun_entry_hlist access.
> 
> Also convert the MODE_SENSE special case in pscsi_transport_complete()

Can you add something like my patch here:

http://git.infradead.org/users/hch/scsi.git/commitdiff/e9a71bda1a120e0488c5c4e4b2f17f14333e2dc6

to the beginning of the series so that we don't need to open code these
intricate details in places that shouldn't know about it?
