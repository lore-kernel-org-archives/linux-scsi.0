From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/2] target_core_spc: bounds check for
 spc_emulate_inquiry()
Date: Thu, 19 Dec 2013 14:11:27 -0800
Message-ID: <1387491087.5567.62.camel@haakon3.risingtidesystems.com>
References: <1387460172-27396-1-git-send-email-hare@suse.de>
	 <1387460172-27396-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1387460172-27396-3-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-12-19 at 14:36 +0100, Hannes Reinecke wrote:
> Instead of using a static buffer for inquiry data we should
> rather use the command-provided buffer and implement proper
> bounds checking when writing to it.
> Inquiry is by no means time-critical ...
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_spc.c     | 391 +++++++++++++++++++++--------------
>  include/target/target_core_backend.h |   2 +-
>  2 files changed, 235 insertions(+), 158 deletions(-)
> 

Mmmmm, so this used to be the case once upon a time, and was changed to
the current local buffer copy + possible truncate for simplicities sake.

I still favor the copy to an oversized local buffer vs. adding explicit
size checks to every possible assignment..

How about changing the local buffer to heap memory instead, and bumping
SE_INQUIRY_BUF to 1024 bytes..?

--nab

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index f9889fd..279d260 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -697,11 +697,15 @@ spc_emulate_inquiry(struct se_cmd *cmd)
        struct se_portal_group *tpg = cmd->se_lun->lun_sep->sep_tpg;
        unsigned char *rbuf;
        unsigned char *cdb = cmd->t_task_cdb;
-       unsigned char buf[SE_INQUIRY_BUF];
+       unsigned char *buf;
        sense_reason_t ret;
        int p;
 
-       memset(buf, 0, SE_INQUIRY_BUF);
+       buf = kzalloc(SE_INQUIRY_BUF, GFP_KERNEL);
+       if (!buf) {
+               pr_err("Unable to allocate response buffer for INQUIRY\n");
+               return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+       }
 
        if (dev == tpg->tpg_virt_lun0.lun_se_dev)
                buf[0] = 0x3f; /* Not connected */
@@ -734,9 +738,10 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 out:
        rbuf = transport_kmap_data_sg(cmd);
        if (rbuf) {
-               memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
+               memcpy(rbuf, buf, min_t(u32, SE_INQUIRY_BUF, cmd->data_length));
                transport_kunmap_data_sg(cmd);
        }
+       kfree(buf);
 
        if (!ret)
                target_complete_cmd(cmd, GOOD);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 1ba19a4..dd87ab4 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -112,7 +112,7 @@
 /* Queue Algorithm Modifier default for restricted reordering in control mode page */
 #define DA_EMULATE_REST_REORD                  0
 
-#define SE_INQUIRY_BUF                         768
+#define SE_INQUIRY_BUF                         1024
 #define SE_MODE_PAGE_BUF                       512
 #define SE_SENSE_BUF                           96
