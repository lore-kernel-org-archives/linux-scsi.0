From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/6] target: use 'se_dev_entry' when allocating UAs
Date: Tue, 16 Jun 2015 23:06:04 -0700
Message-ID: <1434521164.7916.182.camel@haakon3.risingtidesystems.com>
References: <1434009689-112909-1-git-send-email-hare@suse.de>
	 <1434009689-112909-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1434009689-112909-4-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hey Hannes,

Apologies for the delayed follow-up on these, one comment below.

On Thu, 2015-06-11 at 10:01 +0200, Hannes Reinecke wrote:
> We need to use 'se_dev_entry' as argument when allocating
> UAs, otherwise we'll never see any UAs for an implicit
> ALUA state transition triggered from userspace.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_alua.c      | 27 ++++++++++++++++++---------
>  drivers/target/target_core_pr.c        | 31 +++++++++++++++++++++++++------
>  drivers/target/target_core_transport.c | 18 ++++++++++++------
>  drivers/target/target_core_ua.c        | 23 +++--------------------
>  drivers/target/target_core_ua.h        |  2 +-
>  5 files changed, 59 insertions(+), 42 deletions(-)
> 

<SNIP>

> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 436e30b..bb28a97 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -125,6 +125,25 @@ static struct t10_pr_registration *core_scsi3_locate_pr_reg(struct se_device *,
>  					struct se_node_acl *, struct se_session *);
>  static void core_scsi3_put_pr_reg(struct t10_pr_registration *);
>  
> +static void core_scsi3_pr_ua_allocate(struct se_node_acl *nacl,
> +				      u32 unpacked_lun, u8 asc, u8 ascq)
> +{
> +	struct se_dev_entry *deve;
> +
> +	if (!nacl)
> +		return;
> +
> +	rcu_read_lock();
> +	deve = target_nacl_find_deve(nacl, unpacked_lun);
> +	if (!deve) {
> +		rcu_read_unlock();
> +		return;
> +	}
> +
> +	core_scsi3_ua_allocate(deve, asc, ascq);
> +	rcu_read_unlock();
> +}
> +

This should be common for TCM_RESERVATION_CONFLICT case outside of PR
code too.

Any objections for squashing the following into your original patch..?

Thank you,

--nab

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index bb28a97..0bb3292 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -125,25 +125,6 @@ static struct t10_pr_registration *core_scsi3_locate_pr_reg(struct se_device *,
 					struct se_node_acl *, struct se_session *);
 static void core_scsi3_put_pr_reg(struct t10_pr_registration *);
 
-static void core_scsi3_pr_ua_allocate(struct se_node_acl *nacl,
-				      u32 unpacked_lun, u8 asc, u8 ascq)
-{
-	struct se_dev_entry *deve;
-
-	if (!nacl)
-		return;
-
-	rcu_read_lock();
-	deve = target_nacl_find_deve(nacl, unpacked_lun);
-	if (!deve) {
-		rcu_read_unlock();
-		return;
-	}
-
-	core_scsi3_ua_allocate(deve, asc, ascq);
-	rcu_read_unlock();
-}
-
 static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd)
 {
 	struct se_session *se_sess = cmd->se_sess;
@@ -2216,7 +2197,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 					&pr_tmpl->registration_list,
 					pr_reg_list) {
 
-				core_scsi3_pr_ua_allocate(
+				target_ua_allocate_lun(
 					pr_reg_p->pr_reg_nacl,
 					pr_reg_p->pr_res_mapped_lun,
 					0x2A,
@@ -2643,7 +2624,7 @@ core_scsi3_emulate_pro_release(struct se_cmd *cmd, int type, int scope,
 		if (pr_reg_p == pr_reg)
 			continue;
 
-		core_scsi3_pr_ua_allocate(pr_reg_p->pr_reg_nacl,
+		target_ua_allocate_lun(pr_reg_p->pr_reg_nacl,
 				pr_reg_p->pr_res_mapped_lun,
 				0x2A, ASCQ_2AH_RESERVATIONS_RELEASED);
 	}
@@ -2728,7 +2709,7 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 		 *    additional sense code set to RESERVATIONS PREEMPTED.
 		 */
 		if (!calling_it_nexus)
-			core_scsi3_pr_ua_allocate(pr_reg_nacl, pr_res_mapped_lun,
+			target_ua_allocate_lun(pr_reg_nacl, pr_res_mapped_lun,
 				0x2A, ASCQ_2AH_RESERVATIONS_PREEMPTED);
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
@@ -2937,7 +2918,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 						NULL, 0);
 			}
 			if (!calling_it_nexus)
-				core_scsi3_pr_ua_allocate(pr_reg_nacl,
+				target_ua_allocate_lun(pr_reg_nacl,
 					pr_res_mapped_lun, 0x2A,
 					ASCQ_2AH_REGISTRATIONS_PREEMPTED);
 		}
@@ -3043,7 +3024,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 		 *    persistent reservation and/or registration, with the
 		 *    additional sense code set to REGISTRATIONS PREEMPTED;
 		 */
-		core_scsi3_pr_ua_allocate(pr_reg_nacl, pr_res_mapped_lun, 0x2A,
+		target_ua_allocate_lun(pr_reg_nacl, pr_res_mapped_lun, 0x2A,
 				ASCQ_2AH_REGISTRATIONS_PREEMPTED);
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
@@ -3076,7 +3057,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 			if (calling_it_nexus)
 				continue;
 
-			core_scsi3_pr_ua_allocate(pr_reg->pr_reg_nacl,
+			target_ua_allocate_lun(pr_reg->pr_reg_nacl,
 					pr_reg->pr_res_mapped_lun, 0x2A,
 					ASCQ_2AH_RESERVATIONS_RELEASED);
 		}
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index bd63254..201c33c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1678,15 +1678,9 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 		 */
 		if (cmd->se_sess &&
 		    cmd->se_dev->dev_attrib.emulate_ua_intlck_ctrl == 2) {
-			struct se_dev_entry *deve;
-
-			rcu_read_lock();
-			deve = target_nacl_find_deve(cmd->se_sess->se_node_acl,
-						     cmd->orig_fe_lun);
-			if (deve)
-				core_scsi3_ua_allocate(deve, 0x2C,
+			target_ua_allocate_lun(cmd->se_sess->se_node_acl,
+					       cmd->orig_fe_lun, 0x2C,
 					ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS);
-			rcu_read_unlock();
 		}
 		trace_target_cmd_complete(cmd);
 		ret = cmd->se_tfo->queue_status(cmd);
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index e97a708..fc095ae 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -169,6 +169,25 @@ int core_scsi3_ua_allocate(
 	return 0;
 }
 
+void target_ua_allocate_lun(struct se_node_acl *nacl,
+			    u32 unpacked_lun, u8 asc, u8 ascq)
+{
+	struct se_dev_entry *deve;
+
+	if (!nacl)
+		return;
+
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, unpacked_lun);
+	if (!deve) {
+		rcu_read_unlock();
+		return;
+	}
+
+	core_scsi3_ua_allocate(deve, asc, ascq);
+	rcu_read_unlock();
+}
+
 void core_scsi3_ua_release_all(
 	struct se_dev_entry *deve)
 {
diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
index 45e3b6d..bd6e78b 100644
--- a/drivers/target/target_core_ua.h
+++ b/drivers/target/target_core_ua.h
@@ -32,6 +32,7 @@ extern struct kmem_cache *se_ua_cache;
 
 extern sense_reason_t target_scsi3_ua_check(struct se_cmd *);
 extern int core_scsi3_ua_allocate(struct se_dev_entry *, u8, u8);
+extern void target_ua_allocate_lun(struct se_node_acl *, u32, u8, u8);
 extern void core_scsi3_ua_release_all(struct se_dev_entry *);
 extern void core_scsi3_ua_for_check_condition(struct se_cmd *, u8 *, u8 *);
 extern int core_scsi3_ua_clear_for_request_sense(struct se_cmd *,
