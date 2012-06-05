From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcm_qla2xxx: Don't insert nacls without sessions into
 the btree
Date: Tue, 05 Jun 2012 15:40:45 -0700
Message-ID: <1338936045.28824.229.camel@haakon2.linux-iscsi.org>
References: <1338878254-4145-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1338878254-4145-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Hey Roland,

On Mon, 2012-06-04 at 23:37 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> When we create an explicit node ACL in tcm_qla2xxx_make_nodeacl(),
> there is a call to tcm_qla2xxx_setup_nacl_from_rport(), which puts the
> node ACL into the lport_fcport_map even though there is no session yet
> for the initiator.  Since the only time we remove entries from this
> map is when we free a session, this means that if we later delete this
> node ACL without the initiator ever creating a session, we'll leave
> the nacl pointer in the btree pointing at freed memory.
> 
> This is especially bad if that initiator later does send us a command
> that would cause us to create a dynamic ACL and session: we'll find
> the stale freed nacl pointer in the btree and end up with use-after-free.
> 
> We could add more code to clear the btree entry when deleting the
> explicit nacl, but the original insertion is pointless: without a
> session attached, we'll just have to update the entry when a session
> appears anyway.  So we can just delete tcm_qla2xxx_setup_nacl_from_rport()
> and the code that calls it.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>

Looking at this patch which removes tcm_qla2xxx_setup_nacl_from_rport()
usage during explicit tcm_qla2xxx_make_nodeacl() creation, how does an
explicit NodeACL get picked up in tcm_qla2xxx_check_initiator_node_acl()
now with this change ?

AFAICT this patch makes every new initiator login attempt result in a
demo-mode se_node_acl being generated with virtual LUN=0 access, and
ignores explicit se_node_acl + MappedLUNs groups + links to TPG_LUN in
individual ../target/qla2xxx/$TARGET_WWPN/tpgt_1/acls/$INITIATOR_WWPN/

Is there something else that I'm missing here..?

> ---
> Hi Nick, Chad,
> 
> Not sure how you guys want to handle merging qla2xxx target patches,
> especially ones that only touch the tcm_qla2xxx code, so I'm just
> sending this to both of you.
> 

Just a heads up that I'm planning to soon deprecate lio-core.git and
start using target-pending.git as the main development tree as
recommended by hch following a branch structure similar to what
virt/kvm/kvm.git has adopted.

To that end, I'm thinking that a target-pending/qla-tgt-queue branch
that's merged into for-next makes the most sense so that Chad + Co. can
pickup the latest qla-tgt development items ASAP for their internal
regression testing.

For tcm_qla2xxx specific patches, I'm fine with having these go via
target-pending through the usual for-next / rc-fixes updates to Linus
with the necessary signoffs.

For qla_target.c items beyond mechanical + minor changes we'll require
an Qlogic review + ACK, and likely end up merging via scsi.git as
necessary if the change effects qla2xxx LLD initiator mode operation.

Chad & Co, do you have any thoughts on your preferred workflow here..?

Thanks,

--nab
