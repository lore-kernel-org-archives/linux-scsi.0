From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla2xxx: Convert to percpu_ida session tag
 pre-allocation
Date: Mon, 02 Jun 2014 15:12:35 -0700
Message-ID: <1401747155.32085.19.camel@haakon3.risingtidesystems.com>
References: <1400892216-9784-1-git-send-email-nab@daterainc.com>
	 <1400898802.6476.25.camel@haakon3.risingtidesystems.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46D0994E@avmb2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <504EB66DAC8D234EB8E8560985C2D7AD46D0994E@avmb2.qlogic.org>
Sender: target-devel-owner@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-05-29 at 20:29 +0000, Quinn Tran wrote:
> On 5/23/14 7:33 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

<SNIP>

> >> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >>b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >> index 68fb66f..34db344 100644
> >> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >> @@ -1482,7 +1482,9 @@ static int tcm_qla2xxx_check_initiator_node_acl(
> >>      }
> >>      se_tpg = &tpg->se_tpg;
> >>
> >> -    se_sess = transport_init_session(TARGET_PROT_NORMAL);
> >> +    se_sess = transport_init_session_tags(TCM_QLA2XXX_DEFAULT_TAGS,
> >> +                                          sizeof(struct qla_tgt_cmd),
> >> +                                          TARGET_PROT_NORMAL);
> >>      if (IS_ERR(se_sess)) {
> >>              pr_err("Unable to initialize struct se_session\n");
> >>              return PTR_ERR(se_sess);
> >> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> >>b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> >> index 33aaac8..b0a3ea5 100644
> >> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> >> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> >> @@ -4,6 +4,8 @@
> >>  #define TCM_QLA2XXX_VERSION "v0.1"
> >>  /* length of ASCII WWPNs including pad */
> >>  #define TCM_QLA2XXX_NAMELEN 32
> >> +/* Number of pre-allocated per-session tags */
> >> +#define TCM_QLA2XXX_DEFAULT_TAGS 512
> >>
> >
> >So a question wrt to the TCM_QLA2XXX_DEFAULT_TAGS value above used to
> >determine the number of qla_tgt_cmd descriptors to pre-allocate at
> >qla_tgt_sess creation time..
> >
> >This value needs to line up with the total number of possible incoming
> >ATIO packets, plus the number of qla_tgt_cmd descriptors that have not
> >been acknowledged with a CTIO packet.  Typically with other fabrics that
> >have been converted to use percpu_ida, we over-allocate the number of
> >per-session tags in order to completely avoid the slow-path where
> >percpu_ida has to steal tags from another CPU.
> >
> >AFAICT, there is no way at the qla_target driver level to enforce
> >per-session queue_depth + reflect the depth at the initiator port, so
> >the number of tags needs to be the worst case number of HW descriptors
> >that a single session can consume + number of unacknowledged
> >descriptors.
> 
> QT> QLA driver & FW currently do not have queue_depth control at a per
> session level. Instead, the descriptor pool (i.e. Exchange pool) is manage
> by FW at the Port level.
> 
> >
> >So the question is, is there already a define somewhere in qla2xxx code
> >that TCM_QLA2XXX_DEFAULT_TAGS can use as a starting point..?  If not,
> >what is the total number of outstanding commands that a single session
> >(or single port..?) can expect to handle at a given time..?
> 
> QT> Typically, the worst case value we see is 2048 for each port.  It's
> currently not #define.  This value can change over time.  A good starting
> default value for TCM_QLA2XXX_DEFAULT_TAGS would be 2048 + %2 pad = 2088.
> 

<nod>, thanks for the extra background.

> Extra size note, the true value should be extracted from
> "ha->fw_xcb_count", if this field is set.  Otherwise, default back to
> TCM_QLA2XXX_DEFAULT_TAGS.
> 

Ok, squashing the following patch into the original to use
ha->fw_xcb_count (if available) for determining the worst-case per
session number of tags.  Note this currently ends up being ~1.7 MB of
pre-allocated descriptors per session.

Also, I assume the pad is required for ha->fw_xcb_count as well..  In
that case, the patch below also adds a extra define for 40 extra tags
following your pad comment above.

--nab

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 34db344..8b7743f 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1465,6 +1465,8 @@ static int tcm_qla2xxx_check_initiator_node_acl(
        struct qla_tgt_sess *sess = qla_tgt_sess;
        unsigned char port_name[36];
        unsigned long flags;
+       int num_tags = (ha->fw_xcb_count) ? ha->fw_xcb_count :
+                      TCM_QLA2XXX_DEFAULT_TAGS;
 
        lport = vha->vha_tgt.target_lport_ptr;
        if (!lport) {
@@ -1482,7 +1484,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
        }
        se_tpg = &tpg->se_tpg;
 
-       se_sess = transport_init_session_tags(TCM_QLA2XXX_DEFAULT_TAGS,
+       se_sess = transport_init_session_tags(num_tags + TCM_QLA2XXX_PAD_TAGS,
                                              sizeof(struct qla_tgt_cmd),
                                              TARGET_PROT_NORMAL);
        if (IS_ERR(se_sess)) {
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index b0a3ea5..04d6728 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -4,8 +4,12 @@
 #define TCM_QLA2XXX_VERSION    "v0.1"
 /* length of ASCII WWPNs including pad */
 #define TCM_QLA2XXX_NAMELEN    32
-/* Number of pre-allocated per-session tags */
-#define TCM_QLA2XXX_DEFAULT_TAGS 512
+/*
+ * Number of pre-allocated per-session tags, based upon the worst-case
+ * per port number of iocbs
+ */
+#define TCM_QLA2XXX_DEFAULT_TAGS 2048
+#define TCM_QLA2XXX_PAD_TAGS   40
 
 #include "qla_target.h"
 
