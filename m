From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 12/14] xen-scsiback: Convert to TARGET_SCF_ACK_KREF
 I/O krefs
Date: Tue, 02 Feb 2016 21:03:14 -0800
Message-ID: <1454475794.10512.3.camel@haakon3.risingtidesystems.com>
References: <1454137558-30396-1-git-send-email-nab@daterainc.com>
	 <1454137558-30396-13-git-send-email-nab@daterainc.com>
	 <56B0D9DB.90901@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56B0D9DB.90901@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, David Vrabel <david.vrabel@citrix.com>
List-Id: linux-scsi@vger.kernel.org

Hi Juergen,

On Tue, 2016-02-02 at 17:31 +0100, Juergen Gross wrote:
> On 30/01/16 08:05, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Cc: Juergen Gross <jgross@suse.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: David Vrabel <david.vrabel@citrix.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Sorry, with your patches applied xen-scsiback isn't working any more.
> I've tried multiple times with and without your patches. Without the
> patches everything is fine, while with the patches applied I get the
> warnings shown in the attached log. I just passed through a DVD drive
> and did "eject" in the domain.
> 

Thanks for testing.  :)

So it looks like a left-over memset of pending_req->se_cmd memory in
scsiback_cmd_exec() was clobbering the saved percpu_ida map_tag from
scsiback_get_pend_req(), resulting in a use-after-free.

Please verify with the following:

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index eaf9e21..c3f55a2 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -400,10 +400,6 @@ static void scsiback_cmd_exec(struct vscsibk_pend *pending_req)
        struct se_session *sess = pending_req->v2p->tpg->tpg_nexus->tvn_se_sess;
        int rc;
 
-       memset(pending_req->sense_buffer, 0, VSCSIIF_SENSE_BUFFERSIZE);
-
-       memset(se_cmd, 0, sizeof(*se_cmd));
-
        scsiback_get(pending_req->info);
        se_cmd->tag = pending_req->rqid;
        rc = target_submit_cmd_map_sgls(se_cmd, sess, pending_req->cmnd,
