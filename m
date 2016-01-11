From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH-v2 1/4] tcm_fc: Convert acl lookup to modern
 get_initiator_node_acl usage
Date: Mon, 11 Jan 2016 13:05:28 -0800
Message-ID: <56941918.80806@sandisk.com>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com>
 <1452457724-10629-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1452457724-10629-2-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 01/10/2016 12:28 PM, Nicholas A. Bellinger wrote:
> This patch does a simple conversion of tcm_fc code to use
> proper modern core_tpg_get_initiator_node_acl() lookup using
> se_node_acl->acl_kref, and drops the legacy list walk from
> ft_acl_get().
>
> Note the original lookup also took node_name into account,
> but since ft_init_nodeacl() only ever sets port_name for
> se_node_acl->acl_group within configfs, this is purely
> a mechanical change.

Hi Nic,

This patch modifies ft_prli_locked() such that the ACL list lookup only 
happens if FC_SPP_EST_IMG_PAIR has been set by the initiator. That is a 
behavior change and this has not been mentioned in the patch 
description. I think the patch description should mention that behavior 
change and also that it should explain why that behavior change is 
acceptable - if it is acceptable.

Bart.
