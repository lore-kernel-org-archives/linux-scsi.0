From: michaelc@cs.wisc.edu
Subject: [PATCH] 2.6.29-rc libiscsi: Fix scsi command timeout oops in iscsi_eh_timed_out
Date: Fri,  6 Feb 2009 12:06:20 -0600
Message-ID: <12339435803622-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34693 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbZBFSG0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:06:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

=46rom: Mike Christie <michaelc@cs.wisc.edu>

This patch is for 2.6.29.

Yanling Qi from LSI found the root cause of the panic, below is his
analysis:

Problem description: the open iscsi driver installs eh_timed_out handle=
r
to the
blank_transport_template of the scsi middle level that causes panic of
timed
out command of other host

Here are the details

Iscsi Session creation

During iscsi session creation time, the iscsi_tcp_session_create() of
iscsi_tpc.c will create a scsi-host for the session. See the statement
marked
with the label A. The statement B replaces the shost->transportt point
with a
local struct variable.

static struct iscsi_cls_session *
iscsi_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
                         uint16_t qdepth, uint32_t initial_cmdsn,
                         uint32_t *hostno)
{
        struct iscsi_cls_session *cls_session;
        struct iscsi_session *session;
        struct Scsi_Host *shost;
        int cmd_i;
        if (ep) {
                printk(KERN_ERR "iscsi_tcp: invalid ep %p.\n", ep);
                return NULL;
        }

A        shost =3D iscsi_host_alloc(&iscsi_sht, 0, qdepth);

        if (!shost)

                return NULL;

B         shost->transportt =3D iscsi_tcp_scsi_transport;

        shost->max_lun =3D iscsi_max_lun;

Please note the scsi host is allocated by invoking isccsi_host_alloc()
in
libiscsi.c

Polluting the middle level blank_transport_template in
iscsi_host_alloc() of
libiscsi.c

The iscsi_host_alloc() invokes the middle level function
scsi_host_alloc() in
hosts.c for allocating a scsi_host. Then the statement marked with C
assigns
the iscsi_eh_cmd_timed_out handler to the eh_timed_out callback
function.

struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,

                                   int dd_data_size, uint16_t qdepth)

{
        struct Scsi_Host *shost;
        struct iscsi_host *ihost;
        shost =3D scsi_host_alloc(sht, sizeof(struct iscsi_host) +
dd_data_size);
        if (!shost)
                return NULL;

 C      shost->transportt->eh_timed_out =3D iscsi_eh_cmd_timed_out;

Please note the shost->transport is the middle level
blank_transport_template
as shown in the code segment below. We see two problems here. 1.
iscsi_eh_cmd_timed_out is installed to the blank_transport_template tha=
t
will
cause some body else problem. 2. iscsi_eh_cmd_timed_out will never be
invoked
when iscsi command gets timeout because the statement B resets the
pointer.

Middle level blank_transport_template

In the middle level function scsi_host_alloc() of hosts.c, the middle
level
assigns a blank_transport_template for those hosts not implementing its
transport layer. All HBAs without supporting a specific scsi_transport
will
share the middle level blank_transport_template. Please see the
statement D

struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int
privsize)

{
        struct Scsi_Host *shost;
        gfp_t gfp_mask =3D GFP_KERNEL;
        int rval;
        if (sht->unchecked_isa_dma && privsize)
                gfp_mask |=3D __GFP_DMA;

         shost =3D kzalloc(sizeof(struct Scsi_Host) + privsize, gfp_mas=
k);
        if (!shost)
                return NULL;

        shost->host_lock =3D &shost->default_lock;

        spin_lock_init(shost->host_lock);

        shost->shost_state =3D SHOST_CREATED;

        INIT_LIST_HEAD(&shost->__devices);

        INIT_LIST_HEAD(&shost->__targets);

        INIT_LIST_HEAD(&shost->eh_cmd_q);

        INIT_LIST_HEAD(&shost->starved_list);

        init_waitqueue_head(&shost->host_wait);

        mutex_init(&shost->scan_mutex);

        shost->host_no =3D scsi_host_next_hn++; /* XXX(hch): still racy=
 */

        shost->dma_channel =3D 0xff;

        /* These three are default values which can be overridden */

        shost->max_channel =3D 0;

        shost->max_id =3D 8;

        shost->max_lun =3D 8;

        /* Give each shost a default transportt */

 D       shost->transportt =3D &blank_transport_template;

Why we see panic at iscsi_eh_cmd_timed_out()

The mpp virtual HBA doesn=E2=80=99t have a specific scsi_transport. The=
refore,
the
blank_transport_template will be assigned to the virtual host of the MP=
P
virtual HBA by SCSI middle level. Please note that the statement C has
assigned
iscsi-transport eh_timedout handler to the blank_transport_template.
When a mpp
virtual command gets timedout, the iscsi_eh_cmd_timed_out() will be
invoked to
handle mpp virtual command timeout from the middle level
scsi_times_out()
function of the scsi_error.c.

enum blk_eh_timer_return scsi_times_out(struct request *req)

{

        struct scsi_cmnd *scmd =3D req->special;

        enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);

        enum blk_eh_timer_return rtn =3D BLK_EH_NOT_HANDLED;

        scsi_log_completion(scmd, TIMEOUT_ERROR);

        if (scmd->device->host->transportt->eh_timed_out)

 E               eh_timed_out =3D
scmd->device->host->transportt->eh_timed_out;

        else if (scmd->device->host->hostt->eh_timed_out)

                eh_timed_out =3D scmd->device->host->hostt->eh_timed_ou=
t;

        else

                eh_timed_out =3D NULL;

        if (eh_timed_out) {

                rtn =3D eh_timed_out(scmd);

It is very easy to understand why we get panic in the
iscsi_eh_cmd_timed_out().
A scsi_cmnd from a no-iscsi device definitely can not resolve out a
session and
session->lock. The panic can be happed anywhere during the differencing=
=2E

static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd
*scmd)

{

        struct iscsi_cls_session *cls_session;

        struct iscsi_session *session;

        struct iscsi_conn *conn;

        enum blk_eh_timer_return rc =3D BLK_EH_NOT_HANDLED;

        cls_session =3D starget_to_session(scsi_target(scmd->device));

        session =3D cls_session->dd_data;

        debug_scsi("scsi cmd %p timedout\n", scmd);

        spin_lock(&session->lock);

Patch from Mike Christie:

This patch fixes the problem by moving the setting of the
iscsi_eh_cmd_timed_out to iscsi_add_host, which is after the LLDs
have set their transport template to shost->transportt.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 257c241..809d32d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1998,6 +1998,8 @@ int iscsi_host_add(struct Scsi_Host *shost, struc=
t device *pdev)
 	if (!shost->can_queue)
 		shost->can_queue =3D ISCSI_DEF_XMIT_CMDS_MAX;
=20
+	if (!shost->transportt->eh_timed_out)
+		shost->transportt->eh_timed_out =3D iscsi_eh_cmd_timed_out;
 	return scsi_add_host(shost, pdev);
 }
 EXPORT_SYMBOL_GPL(iscsi_host_add);
@@ -2020,7 +2022,6 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_ho=
st_template *sht,
 	shost =3D scsi_host_alloc(sht, sizeof(struct iscsi_host) + dd_data_si=
ze);
 	if (!shost)
 		return NULL;
-	shost->transportt->eh_timed_out =3D iscsi_eh_cmd_timed_out;
=20
 	if (qdepth > ISCSI_MAX_CMD_PER_LUN || qdepth < 1) {
 		if (qdepth !=3D 0)
--=20
1.6.0.6

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
