From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/5] target: Fix multi-session dynamic se_node_acl
 double free OOPs
Date: Wed, 08 Feb 2017 08:14:57 -0800
Message-ID: <1486570497.7066.6.camel@haakon3.risingtidesystems.com>
References: <1486473470-15837-1-git-send-email-nab@linux-iscsi.org>
         <1486473470-15837-5-git-send-email-nab@linux-iscsi.org>
         <20170207230701.GA28123@infradead.org>
         <20170207231224.GA29711@infradead.org>
         <1486525612.13263.18.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486525612.13263.18.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Rob Millner <rlm@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-02-07 at 19:46 -0800, Nicholas A. Bellinger wrote:
> On Tue, 2017-02-07 at 15:12 -0800, Christoph Hellwig wrote:
> > And the real patch after compile fixing it is here of course:
> > 
> 
> Getting rid of the extra se_node_acl->acl_free_comp seems to make sense
> here..
> 
> The only potential issue is if returning from configfs syscall
> rmdir /sys/kernel/config/target/$FABRIC/$WWN/$TPGT/acls/$INITIATOR/
> before se_node_acl memory is released has implications when the
> underlying ../$WWN/$TPGT/ is removed immediately after.
> 
> In any event, I'll verify this patch with the original test case and use
> it instead if everything looks OK.

Ok, I remember why se_node_acl->acl_free_comp is needed now..

The issue is when se_node_acl is being explicitly removed from configfs
while se_sessions associated with se_node_acl are still active.

The se_node_acl->acl_group configfs_group_operations->drop_item()
callback must block until all associated se_sessions have done their
target_put_nacl() and completed se_node_acl->acl_free_comp, otherwise
there is nothing preventing parent config_groups of se_node_acl from
being removed while the se_sessions are still active.

That said, dropping the unnecessary list_del_init() usage, but otherwise
keeping the patch as-is.
