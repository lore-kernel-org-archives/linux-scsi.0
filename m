From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to
	RCU hlist
Date: Wed, 13 May 2015 08:35:55 +0200
Message-ID: <20150513063555.GA21770@lst.de>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431422736-29125-2-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

Onemore comments from looking oer the RCU usage with all the patches
applied:

In core_get_se_deve_from_rtpi we dereference lun->lun_sep, so
either struct se_port needs to be switched to kfree_rcu,
or we need to mirror the rtpi value into the se_lun.
