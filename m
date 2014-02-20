From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH v2] target_core_alua: silence GCC warning
Date: Thu, 20 Feb 2014 09:07:52 +0100
Message-ID: <1392883672.5070.21.camel@x220>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
	 <1392803546.27558.16.camel@x220>
	 <CAMuHMdXZrw7oU=n60+PNNQftU6Su=mBf2V75TCO8Ws1pS5z+6Q@mail.gmail.com>
	 <1392804347.27558.20.camel@x220>
	 <1392850749.22195.1.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392850749.22195.1.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Building target_core_alua.o triggers a GCC warning:
    drivers/target/target_core_alua.c: In function =E2=80=98target_alua=
_state_check=E2=80=99:
    drivers/target/target_core_alua.c:773:18: warning: =E2=80=98alua_as=
cq=E2=80=99 may be used uninitialized in this function [-Wmaybe-uniniti=
alized]
       cmd->scsi_ascq =3D alua_ascq;
                      ^

This is a false positive. A little trial and error shows it is
apparently caused by core_alua_state_lba_dependent(). It must be hard
for GCC to track the branches of a switch statement, inside a
list_for_each_entry loop, inside a while loop.

But if we add a small (inline) helper function we can reorganize the
code a bit. That also allows to drop alua_ascq which, obviously, gets
rid of this warning.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
v2: Make core_alua_state_nonoptimized() return void, as Geert
suggested.=20

Also keep core_alua_state_lba_dependent() inline. Setting that function
noinline was just a leftover from the trial and error fase, and isn't
needed to make the warning go away. Ie, I was sloppy in v1!

Still compile tested only.

 drivers/target/target_core_alua.c | 95 ++++++++++++++++++-------------=
--------
 1 file changed, 44 insertions(+), 51 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_=
core_alua.c
index c3d9df6..fcbe612 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -455,11 +455,26 @@ out:
 	return rc;
 }
=20
-static inline int core_alua_state_nonoptimized(
+static inline void set_ascq(struct se_cmd *cmd, u8 alua_ascq)
+{
+	/*
+	 * Set SCSI additional sense code (ASC) to 'LUN Not Accessible';
+	 * The ALUA additional sense code qualifier (ASCQ) is determined
+	 * by the ALUA primary or secondary access state..
+	 */
+	pr_debug("[%s]: ALUA TG Port not available, "
+		"SenseKey: NOT_READY, ASC/ASCQ: "
+		"0x04/0x%02x\n",
+		cmd->se_tfo->get_fabric_name(), alua_ascq);
+
+	cmd->scsi_asc =3D 0x04;
+	cmd->scsi_ascq =3D alua_ascq;
+}
+
+static inline void core_alua_state_nonoptimized(
 	struct se_cmd *cmd,
 	unsigned char *cdb,
-	int nonop_delay_msecs,
-	u8 *alua_ascq)
+	int nonop_delay_msecs)
 {
 	/*
 	 * Set SCF_ALUA_NON_OPTIMIZED here, this value will be checked
@@ -468,13 +483,11 @@ static inline int core_alua_state_nonoptimized(
 	 */
 	cmd->se_cmd_flags |=3D SCF_ALUA_NON_OPTIMIZED;
 	cmd->alua_nonop_delay =3D nonop_delay_msecs;
-	return 0;
 }
=20
 static inline int core_alua_state_lba_dependent(
 	struct se_cmd *cmd,
-	struct t10_alua_tg_pt_gp *tg_pt_gp,
-	u8 *alua_ascq)
+	struct t10_alua_tg_pt_gp *tg_pt_gp)
 {
 	struct se_device *dev =3D cmd->se_dev;
 	u64 segment_size, segment_mult, sectors, lba;
@@ -520,7 +533,7 @@ static inline int core_alua_state_lba_dependent(
 		}
 		if (!cur_map) {
 			spin_unlock(&dev->t10_alua.lba_map_lock);
-			*alua_ascq =3D ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
 			return 1;
 		}
 		list_for_each_entry(map_mem, &cur_map->lba_map_mem_list,
@@ -531,11 +544,11 @@ static inline int core_alua_state_lba_dependent(
 			switch(map_mem->lba_map_mem_alua_state) {
 			case ALUA_ACCESS_STATE_STANDBY:
 				spin_unlock(&dev->t10_alua.lba_map_lock);
-				*alua_ascq =3D ASCQ_04H_ALUA_TG_PT_STANDBY;
+				set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
 				return 1;
 			case ALUA_ACCESS_STATE_UNAVAILABLE:
 				spin_unlock(&dev->t10_alua.lba_map_lock);
-				*alua_ascq =3D ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+				set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
 				return 1;
 			default:
 				break;
@@ -548,8 +561,7 @@ static inline int core_alua_state_lba_dependent(
=20
 static inline int core_alua_state_standby(
 	struct se_cmd *cmd,
-	unsigned char *cdb,
-	u8 *alua_ascq)
+	unsigned char *cdb)
 {
 	/*
 	 * Allowed CDBs for ALUA_ACCESS_STATE_STANDBY as defined by
@@ -570,7 +582,7 @@ static inline int core_alua_state_standby(
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
-			*alua_ascq =3D ASCQ_04H_ALUA_TG_PT_STANDBY;
+			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
 			return 1;
 		}
 	case MAINTENANCE_OUT:
@@ -578,7 +590,7 @@ static inline int core_alua_state_standby(
 		case MO_SET_TARGET_PGS:
 			return 0;
 		default:
-			*alua_ascq =3D ASCQ_04H_ALUA_TG_PT_STANDBY;
+			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
 			return 1;
 		}
 	case REQUEST_SENSE:
@@ -588,7 +600,7 @@ static inline int core_alua_state_standby(
 	case WRITE_BUFFER:
 		return 0;
 	default:
-		*alua_ascq =3D ASCQ_04H_ALUA_TG_PT_STANDBY;
+		set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
 		return 1;
 	}
=20
@@ -597,8 +609,7 @@ static inline int core_alua_state_standby(
=20
 static inline int core_alua_state_unavailable(
 	struct se_cmd *cmd,
-	unsigned char *cdb,
-	u8 *alua_ascq)
+	unsigned char *cdb)
 {
 	/*
 	 * Allowed CDBs for ALUA_ACCESS_STATE_UNAVAILABLE as defined by
@@ -613,7 +624,7 @@ static inline int core_alua_state_unavailable(
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
-			*alua_ascq =3D ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
 			return 1;
 		}
 	case MAINTENANCE_OUT:
@@ -621,7 +632,7 @@ static inline int core_alua_state_unavailable(
 		case MO_SET_TARGET_PGS:
 			return 0;
 		default:
-			*alua_ascq =3D ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
 			return 1;
 		}
 	case REQUEST_SENSE:
@@ -629,7 +640,7 @@ static inline int core_alua_state_unavailable(
 	case WRITE_BUFFER:
 		return 0;
 	default:
-		*alua_ascq =3D ASCQ_04H_ALUA_TG_PT_UNAVAILABLE;
+		set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_UNAVAILABLE);
 		return 1;
 	}
=20
@@ -638,8 +649,7 @@ static inline int core_alua_state_unavailable(
=20
 static inline int core_alua_state_transition(
 	struct se_cmd *cmd,
-	unsigned char *cdb,
-	u8 *alua_ascq)
+	unsigned char *cdb)
 {
 	/*
 	 * Allowed CDBs for ALUA_ACCESS_STATE_TRANSITION as defined by
@@ -654,7 +664,7 @@ static inline int core_alua_state_transition(
 		case MI_REPORT_TARGET_PGS:
 			return 0;
 		default:
-			*alua_ascq =3D ASCQ_04H_ALUA_STATE_TRANSITION;
+			set_ascq(cmd, ASCQ_04H_ALUA_STATE_TRANSITION);
 			return 1;
 		}
 	case REQUEST_SENSE:
@@ -662,7 +672,7 @@ static inline int core_alua_state_transition(
 	case WRITE_BUFFER:
 		return 0;
 	default:
-		*alua_ascq =3D ASCQ_04H_ALUA_STATE_TRANSITION;
+		set_ascq(cmd, ASCQ_04H_ALUA_STATE_TRANSITION);
 		return 1;
 	}
=20
@@ -684,8 +694,6 @@ target_alua_state_check(struct se_cmd *cmd)
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	int out_alua_state, nonop_delay_msecs;
-	u8 alua_ascq;
-	int ret;
=20
 	if (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)
 		return 0;
@@ -701,9 +709,8 @@ target_alua_state_check(struct se_cmd *cmd)
 	if (atomic_read(&port->sep_tg_pt_secondary_offline)) {
 		pr_debug("ALUA: Got secondary offline status for local"
 				" target port\n");
-		alua_ascq =3D ASCQ_04H_ALUA_OFFLINE;
-		ret =3D 1;
-		goto out;
+		set_ascq(cmd, ASCQ_04H_ALUA_OFFLINE);
+		return TCM_CHECK_CONDITION_NOT_READY;
 	}
 	 /*
 	 * Second, obtain the struct t10_alua_tg_pt_gp_member pointer to the
@@ -731,20 +738,23 @@ target_alua_state_check(struct se_cmd *cmd)
=20
 	switch (out_alua_state) {
 	case ALUA_ACCESS_STATE_ACTIVE_NON_OPTIMIZED:
-		ret =3D core_alua_state_nonoptimized(cmd, cdb,
-					nonop_delay_msecs, &alua_ascq);
+		core_alua_state_nonoptimized(cmd, cdb, nonop_delay_msecs);
 		break;
 	case ALUA_ACCESS_STATE_STANDBY:
-		ret =3D core_alua_state_standby(cmd, cdb, &alua_ascq);
+		if (core_alua_state_standby(cmd, cdb))
+			return TCM_CHECK_CONDITION_NOT_READY;
 		break;
 	case ALUA_ACCESS_STATE_UNAVAILABLE:
-		ret =3D core_alua_state_unavailable(cmd, cdb, &alua_ascq);
+		if (core_alua_state_unavailable(cmd, cdb))
+			return TCM_CHECK_CONDITION_NOT_READY;
 		break;
 	case ALUA_ACCESS_STATE_TRANSITION:
-		ret =3D core_alua_state_transition(cmd, cdb, &alua_ascq);
+		if (core_alua_state_transition(cmd, cdb))
+			return TCM_CHECK_CONDITION_NOT_READY;
 		break;
 	case ALUA_ACCESS_STATE_LBA_DEPENDENT:
-		ret =3D core_alua_state_lba_dependent(cmd, tg_pt_gp, &alua_ascq);
+		if (core_alua_state_lba_dependent(cmd, tg_pt_gp))
+			return TCM_CHECK_CONDITION_NOT_READY;
 		break;
 	/*
 	 * OFFLINE is a secondary ALUA target port group access state, that i=
s
@@ -757,23 +767,6 @@ target_alua_state_check(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
=20
-out:
-	if (ret > 0) {
-		/*
-		 * Set SCSI additional sense code (ASC) to 'LUN Not Accessible';
-		 * The ALUA additional sense code qualifier (ASCQ) is determined
-		 * by the ALUA primary or secondary access state..
-		 */
-		pr_debug("[%s]: ALUA TG Port not available, "
-			"SenseKey: NOT_READY, ASC/ASCQ: "
-			"0x04/0x%02x\n",
-			cmd->se_tfo->get_fabric_name(), alua_ascq);
-
-		cmd->scsi_asc =3D 0x04;
-		cmd->scsi_ascq =3D alua_ascq;
-		return TCM_CHECK_CONDITION_NOT_READY;
-	}
-
 	return 0;
 }
=20
--=20
1.8.5.3
