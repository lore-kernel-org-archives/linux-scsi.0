From: Lukas Herbolt <lherbolt@redhat.com>
Subject: Re: [PATCH] scsi_debug: Add OPTIMAL TRANSFER LENGTH GRANULARITY option.
Date: Tue, 24 Jan 2017 12:41:17 +0100
Message-ID: <CAM4Jq_7m9MGkLFBRUs_3ywarhVuP1NOt1DLM78ukba0LtNZj2g@mail.gmail.com>
References: <lherbolt@redhat.com> <1483779027-10052-1-git-send-email-lherbolt@redhat.com>
 <yq1pojhgszr.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:33098 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750767AbdAXLlT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2017 06:41:19 -0500
Received: by mail-wm0-f51.google.com with SMTP id d140so42045710wmd.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2017 03:41:19 -0800 (PST)
In-Reply-To: <yq1pojhgszr.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

Sounds ok to me.


---
drivers/scsi/scsi_debug.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cf04a36..a4456ca 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -125,6 +125,7 @@ static const char *sdebug_version_date = "20160430";
 #define DEF_OPTS   0
 #define DEF_OPT_BLKS 1024
 #define DEF_PHYSBLK_EXP 0
+#define DEF_OPT_XFERLEN_EXP 0
 #define DEF_PTYPE   TYPE_DISK
 #define DEF_REMOVABLE false
 #define DEF_SCSI_LEVEL   7    /* INQUIRY, byte2 [6->SPC-4; 7->SPC-5] */
@@ -590,6 +591,7 @@ static int sdebug_num_tgts = DEF_NUM_TGTS; /*
targets per host */
 static int sdebug_opt_blks = DEF_OPT_BLKS;
 static int sdebug_opts = DEF_OPTS;
 static int sdebug_physblk_exp = DEF_PHYSBLK_EXP;
+static int sdebug_opt_xferlen_exp = DEF_OPT_XFERLEN_EXP;
 static int sdebug_ptype = DEF_PTYPE; /* SCSI peripheral device type */
 static int sdebug_scsi_level = DEF_SCSI_LEVEL;
 static int sdebug_sector_size = DEF_SECTOR_SIZE;
@@ -1205,7 +1207,10 @@ static int inquiry_vpd_b0(unsigned char *arr)
  memcpy(arr, vpdb0_data, sizeof(vpdb0_data));

  /* Optimal transfer length granularity */
- gran = 1 << sdebug_physblk_exp;
+ if (sdebug_opt_xferlen_exp != 0 && sdebug_physblk_exp <
sdebug_opt_xferlen_exp)
+ gran = 1 <<  sdebug_opt_xferlen_exp;
+ else
+ gran = 1 << sdebug_physblk_exp;
  put_unaligned_be16(gran, arr + 2);

  /* Maximum Transfer Length */
@@ -4161,6 +4166,7 @@ module_param_named(num_tgts, sdebug_num_tgts,
int, S_IRUGO | S_IWUSR);
 module_param_named(opt_blks, sdebug_opt_blks, int, S_IRUGO);
 module_param_named(opts, sdebug_opts, int, S_IRUGO | S_IWUSR);
 module_param_named(physblk_exp, sdebug_physblk_exp, int, S_IRUGO);
+module_param_named(opt_xferlen_exp, sdebug_opt_xferlen_exp, int, S_IRUGO);
 module_param_named(ptype, sdebug_ptype, int, S_IRUGO | S_IWUSR);
 module_param_named(removable, sdebug_removable, bool, S_IRUGO | S_IWUSR);
 module_param_named(scsi_level, sdebug_scsi_level, int, S_IRUGO);
@@ -4212,6 +4218,7 @@ MODULE_PARM_DESC(num_tgts, "number of targets
per host to simulate(def=1)");
 MODULE_PARM_DESC(opt_blks, "optimal transfer length in blocks (def=1024)");
 MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout,
8->recovered_err... (def=0)");
 MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
+MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length
granularity exponent (def=physblk_exp)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
 MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=7[SPC-5])");
-- 
2.7.4

On Sat, Jan 21, 2017 at 1:24 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Lukas" == Lukas Herbolt <lherbolt@redhat.com> writes:
>
> Lukas,
>
> Lukas> I have been playing with scsi_debug and found that there is no
> Lukas> way how to change the minimum_io_size (OPTIMAL TRANSFER LENGTH
> Lukas> GRANULARITY reported by VPD 0xb0).
>
> Lukas> The current module has minimum_io_size always set to
> Lukas> physical_block_size.  So here comes a small patch which add a new
> Lukas> option to this module to be able to set it independently to the
> Lukas> physical_block_size. Default behavior is to keep the
> Lukas> minimum_io_size equal to the physical_block_size.
>
> No objection to the functionality but I don't really like the naming
> scheme. There are many granularities in SBC so "gran" isn't particularly
> descriptive.
>
> How about opt_xferlen_exp or something like that?
>
> --
> Martin K. Petersen      Oracle Linux Engineering
