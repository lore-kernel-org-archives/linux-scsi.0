From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] tcm_qla2xxx: Don't insert nacls without sessions into the btree
Date: Tue, 5 Jun 2012 16:41:13 -0700
Message-ID: <CAG4TOxOk4E-CCqf9sPMsBR3khSjNfE+DE5Tux7zNFS9=_1HG-g@mail.gmail.com>
References: <1338878254-4145-1-git-send-email-roland@kernel.org> <1338936045.28824.229.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1338936045.28824.229.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

> Looking at this patch which removes tcm_qla2xxx_setup_nacl_from_rport()
> usage during explicit tcm_qla2xxx_make_nodeacl() creation, how does an
> explicit NodeACL get picked up in tcm_qla2xxx_check_initiator_node_acl()
> now with this change ?
>
> AFAICT this patch makes every new initiator login attempt result in a
> demo-mode se_node_acl being generated with virtual LUN=0 access, and
> ignores explicit se_node_acl + MappedLUNs groups + links to TPG_LUN in
> individual ../target/qla2xxx/$TARGET_WWPN/tpgt_1/acls/$INITIATOR_WWPN/
>
> Is there something else that I'm missing here..?

[Reply to all this time]

We still insert the nacl into the tpg->acl_node_list so we'll find it when we
do the check when the session actually shows up.

Inserting the nacl into the btree doesn't do anything, since it would have no
session pointer and so tcm_qla2xxx_find_sess_by_s_id() will return NULL
whether or not we insert the nacl in tcm_qla2xxx_setup_nacl_from_rport().
(And that's the only place that does a btree lookup)

 - R.
