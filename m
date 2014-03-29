From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 30/55] scsi: Mark functions as static in
 megaraid/megaraid_sas_fp.c
Date: Sat, 29 Mar 2014 23:48:08 +0530
Message-ID: <89d00f872fc1f109e8ae1ca9172c37bb8dc909b4.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark functions as static in megaraid/megaraid_sas_fp.c because they are
not used outside this file.

This eliminates the following warning in megaraid/megaraid_sas_fp.c:
drivers/scsi/megaraid/megaraid_sas_fp.c:80:5: warning: no previous prot=
otype for =E2=80=98mega_mod64=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fp.c:98:5: warning: no previous prot=
otype for =E2=80=98mega_div64_32=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fp.c:206:5: warning: no previous pro=
totype for =E2=80=98MR_GetSpanBlock=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fp.c:341:5: warning: no previous pro=
totype for =E2=80=98mr_spanset_get_span_block=E2=80=99 [-Wmissing-proto=
types]
drivers/scsi/megaraid/megaraid_sas_fp.c:582:4: warning: no previous pro=
totype for =E2=80=98get_arm=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fp.c:705:4: warning: no previous pro=
totype for =E2=80=98MR_GetPhyParams=E2=80=99 [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fp.c:1196:4: warning: no previous pr=
ototype for =E2=80=98megasas_get_best_arm=E2=80=99 [-Wmissing-prototype=
s]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c |   26 ++++++++++++++---------=
---
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/meg=
araid/megaraid_sas_fp.c
index e24b6eb..83d5f74 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -77,7 +77,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_in=
stance *instance, u32 ld,
 static u64 get_row_from_strip(struct megasas_instance *instance, u32 l=
d,
 	u64 strip, struct MR_FW_RAID_MAP_ALL *map);
=20
-u32 mega_mod64(u64 dividend, u32 divisor)
+static u32 mega_mod64(u64 dividend, u32 divisor)
 {
 	u64 d;
 	u32 remainder;
@@ -95,7 +95,7 @@ u32 mega_mod64(u64 dividend, u32 divisor)
  *
  * @return quotient
  **/
-u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
+static u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
 {
 	u32 remainder;
 	u64 d;
@@ -203,7 +203,7 @@ u8 MR_ValidateMapInfo(struct megasas_instance *inst=
ance)
 	return 1;
 }
=20
-u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
+static u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
 		    struct MR_FW_RAID_MAP_ALL *map)
 {
 	struct MR_SPAN_BLOCK_INFO *pSpanBlock =3D MR_LdSpanInfoGet(ld, map);
@@ -338,7 +338,7 @@ static int getSpanInfo(struct MR_FW_RAID_MAP_ALL *m=
ap, PLD_SPAN_INFO ldSpanInfo)
 *    div_error	   - Devide error code.
 */
=20
-u32 mr_spanset_get_span_block(struct megasas_instance *instance,
+static u32 mr_spanset_get_span_block(struct megasas_instance *instance=
,
 		u32 ld, u64 row, u64 *span_blk, struct MR_FW_RAID_MAP_ALL *map)
 {
 	struct fusion_context *fusion =3D instance->ctrl_context;
@@ -579,8 +579,8 @@ static u32 get_arm_from_strip(struct megasas_instan=
ce *instance,
 }
=20
 /* This Function will return Phys arm */
-u8 get_arm(struct megasas_instance *instance, u32 ld, u8 span, u64 str=
ipe,
-		struct MR_FW_RAID_MAP_ALL *map)
+static u8 get_arm(struct megasas_instance *instance, u32 ld, u8 span,
+		  u64 stripe, struct MR_FW_RAID_MAP_ALL *map)
 {
 	struct MR_LD_RAID  *raid =3D MR_LdRaidGet(ld, map);
 	/* Need to check correct default value */
@@ -702,10 +702,11 @@ static u8 mr_spanset_get_phy_params(struct megasa=
s_instance *instance, u32 ld,
 *    span          - Span number
 *    block         - Absolute Block number in the physical disk
 */
-u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stri=
pRow,
-		u16 stripRef, struct IO_REQUEST_INFO *io_info,
-		struct RAID_CONTEXT *pRAID_Context,
-		struct MR_FW_RAID_MAP_ALL *map)
+static u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld,
+			  u64 stripRow, u16 stripRef,
+			  struct IO_REQUEST_INFO *io_info,
+			  struct RAID_CONTEXT *pRAID_Context,
+			  struct MR_FW_RAID_MAP_ALL *map)
 {
 	struct MR_LD_RAID  *raid =3D MR_LdRaidGet(ld, map);
 	u32         pd, arRef;
@@ -1193,8 +1194,9 @@ mr_update_load_balance_params(struct MR_FW_RAID_M=
AP_ALL *map,
 	}
 }
=20
-u8 megasas_get_best_arm(struct LD_LOAD_BALANCE_INFO *lbInfo, u8 arm, u=
64 block,
-			u32 count)
+static u8 megasas_get_best_arm(struct LD_LOAD_BALANCE_INFO *lbInfo, u8=
 arm,
+			       u64 block,
+			       u32 count)
 {
 	u16     pend0, pend1;
 	u64     diff0, diff1;
--=20
1.7.9.5
