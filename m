From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] cdrom: Make device operations read-only
Date: Mon, 13 Feb 2017 16:25:26 -0800
Message-ID: <20170214002526.GA124769@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Tim Waugh <tim@cyberelk.net>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>, linux-doc@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-scsi@vger.kernel.org

Since function tables are a common target for attackers, it's best to keep
them in read-only memory. As such, this makes the CDROM device ops tables
const. This drops additionally n_minors, since it isn't used meaningfully,
and sets the only user of cdrom_dummy_generic_packet explicitly so the
variables can all be const.

Inspired by similar changes in grsecurity/PaX.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/cdrom/cdrom-standard.tex |  9 +-----
 drivers/block/paride/pcd.c             |  2 +-
 drivers/cdrom/cdrom.c                  | 58 ++++++++++++++++------------------
 drivers/cdrom/gdrom.c                  |  4 +--
 drivers/ide/ide-cd.c                   |  2 +-
 drivers/scsi/sr.c                      |  2 +-
 include/linux/cdrom.h                  |  5 +--
 7 files changed, 37 insertions(+), 45 deletions(-)

diff --git a/Documentation/cdrom/cdrom-standard.tex b/Documentation/cdrom/cdrom-standard.tex
index c06233fe52ac..8f85b0e41046 100644
--- a/Documentation/cdrom/cdrom-standard.tex
+++ b/Documentation/cdrom/cdrom-standard.tex
@@ -249,7 +249,6 @@ struct& cdrom_device_ops\ \{ \hidewidth\cr
         unsigned\ long);\cr
 \noalign{\medskip}
   &const\ int& capability;& capability flags \cr
-  &int& n_minors;& number of active minor devices \cr
 \};\cr
 }
 $$
@@ -258,13 +257,7 @@ it should add a function pointer to this $struct$. When a particular
 function is not implemented, however, this $struct$ should contain a
 NULL instead. The $capability$ flags specify the capabilities of the
 \cdrom\ hardware and/or low-level \cdrom\ driver when a \cdrom\ drive
-is registered with the \UCD. The value $n_minors$ should be a positive
-value indicating the number of minor devices that are supported by
-the low-level device driver, normally~1. Although these two variables
-are `informative' rather than `operational,' they are included in
-$cdrom_device_ops$ because they describe the capability of the {\em
-driver\/} rather than the {\em drive}. Nomenclature has always been
-difficult in computer programming.
+is registered with the \UCD.
 
 Note that most functions have fewer parameters than their
 $blkdev_fops$ counterparts. This is because very little of the
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 5fd2d0e25567..10aed84244f5 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -273,7 +273,7 @@ static const struct block_device_operations pcd_bdops = {
 	.check_events	= pcd_block_check_events,
 };
 
-static struct cdrom_device_ops pcd_dops = {
+static const struct cdrom_device_ops pcd_dops = {
 	.open		= pcd_open,
 	.release	= pcd_release,
 	.drive_status	= pcd_drive_status,
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 59cca72647a6..bbbd3caa927c 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -342,8 +342,8 @@ static void cdrom_sysctl_register(void);
 
 static LIST_HEAD(cdrom_list);
 
-static int cdrom_dummy_generic_packet(struct cdrom_device_info *cdi,
-				      struct packet_command *cgc)
+int cdrom_dummy_generic_packet(struct cdrom_device_info *cdi,
+			       struct packet_command *cgc)
 {
 	if (cgc->sense) {
 		cgc->sense->sense_key = 0x05;
@@ -354,6 +354,7 @@ static int cdrom_dummy_generic_packet(struct cdrom_device_info *cdi,
 	cgc->stat = -EIO;
 	return -EIO;
 }
+EXPORT_SYMBOL(cdrom_dummy_generic_packet);
 
 static int cdrom_flush_cache(struct cdrom_device_info *cdi)
 {
@@ -371,7 +372,7 @@ static int cdrom_flush_cache(struct cdrom_device_info *cdi)
 static int cdrom_get_disc_info(struct cdrom_device_info *cdi,
 			       disc_information *di)
 {
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	struct packet_command cgc;
 	int ret, buflen;
 
@@ -586,7 +587,7 @@ static int cdrom_mrw_set_lba_space(struct cdrom_device_info *cdi, int space)
 int register_cdrom(struct cdrom_device_info *cdi)
 {
 	static char banner_printed;
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	int *change_capability = (int *)&cdo->capability; /* hack */
 
 	cd_dbg(CD_OPEN, "entering register_cdrom\n");
@@ -610,7 +611,6 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	ENSURE(reset, CDC_RESET);
 	ENSURE(generic_packet, CDC_GENERIC_PACKET);
 	cdi->mc_flags = 0;
-	cdo->n_minors = 0;
 	cdi->options = CDO_USE_FFLAGS;
 
 	if (autoclose == 1 && CDROM_CAN(CDC_CLOSE_TRAY))
@@ -630,8 +630,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	else
 		cdi->cdda_method = CDDA_OLD;
 
-	if (!cdo->generic_packet)
-		cdo->generic_packet = cdrom_dummy_generic_packet;
+	WARN_ON(!cdo->generic_packet);
 
 	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
 	mutex_lock(&cdrom_mutex);
@@ -652,7 +651,6 @@ void unregister_cdrom(struct cdrom_device_info *cdi)
 	if (cdi->exit)
 		cdi->exit(cdi);
 
-	cdi->ops->n_minors--;
 	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" unregistered\n", cdi->name);
 }
 
@@ -1036,7 +1034,7 @@ static
 int open_for_data(struct cdrom_device_info *cdi)
 {
 	int ret;
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	tracktype tracks;
 	cd_dbg(CD_OPEN, "entering open_for_data\n");
 	/* Check if the driver can report drive status.  If it can, we
@@ -1198,8 +1196,8 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev,
 /* This code is similar to that in open_for_data. The routine is called
    whenever an audio play operation is requested.
 */
-static int check_for_audio_disc(struct cdrom_device_info * cdi,
-				struct cdrom_device_ops * cdo)
+static int check_for_audio_disc(struct cdrom_device_info *cdi,
+				const struct cdrom_device_ops *cdo)
 {
         int ret;
 	tracktype tracks;
@@ -1254,7 +1252,7 @@ static int check_for_audio_disc(struct cdrom_device_info * cdi,
 
 void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
 {
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	int opened_for_data;
 
 	cd_dbg(CD_CLOSE, "entering cdrom_release\n");
@@ -1294,7 +1292,7 @@ static int cdrom_read_mech_status(struct cdrom_device_info *cdi,
 				  struct cdrom_changer_info *buf)
 {
 	struct packet_command cgc;
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	int length;
 
 	/*
@@ -1643,7 +1641,7 @@ static int dvd_do_auth(struct cdrom_device_info *cdi, dvd_authinfo *ai)
 	int ret;
 	u_char buf[20];
 	struct packet_command cgc;
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	rpc_state_t rpc_state;
 
 	memset(buf, 0, sizeof(buf));
@@ -1791,7 +1789,7 @@ static int dvd_read_physical(struct cdrom_device_info *cdi, dvd_struct *s,
 {
 	unsigned char buf[21], *base;
 	struct dvd_layer *layer;
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	int ret, layer_num = s->physical.layer_num;
 
 	if (layer_num >= DVD_LAYERS)
@@ -1842,7 +1840,7 @@ static int dvd_read_copyright(struct cdrom_device_info *cdi, dvd_struct *s,
 {
 	int ret;
 	u_char buf[8];
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 
 	init_cdrom_command(cgc, buf, sizeof(buf), CGC_DATA_READ);
 	cgc->cmd[0] = GPCMD_READ_DVD_STRUCTURE;
@@ -1866,7 +1864,7 @@ static int dvd_read_disckey(struct cdrom_device_info *cdi, dvd_struct *s,
 {
 	int ret, size;
 	u_char *buf;
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 
 	size = sizeof(s->disckey.value) + 4;
 
@@ -1894,7 +1892,7 @@ static int dvd_read_bca(struct cdrom_device_info *cdi, dvd_struct *s,
 {
 	int ret, size = 4 + 188;
 	u_char *buf;
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf)
@@ -1928,7 +1926,7 @@ static int dvd_read_manufact(struct cdrom_device_info *cdi, dvd_struct *s,
 {
 	int ret = 0, size;
 	u_char *buf;
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 
 	size = sizeof(s->manufact.value) + 4;
 
@@ -1995,7 +1993,7 @@ int cdrom_mode_sense(struct cdrom_device_info *cdi,
 		     struct packet_command *cgc,
 		     int page_code, int page_control)
 {
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 
 	memset(cgc->cmd, 0, sizeof(cgc->cmd));
 
@@ -2010,7 +2008,7 @@ int cdrom_mode_sense(struct cdrom_device_info *cdi,
 int cdrom_mode_select(struct cdrom_device_info *cdi,
 		      struct packet_command *cgc)
 {
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 
 	memset(cgc->cmd, 0, sizeof(cgc->cmd));
 	memset(cgc->buffer, 0, 2);
@@ -2025,7 +2023,7 @@ int cdrom_mode_select(struct cdrom_device_info *cdi,
 static int cdrom_read_subchannel(struct cdrom_device_info *cdi,
 				 struct cdrom_subchnl *subchnl, int mcn)
 {
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	struct packet_command cgc;
 	char buffer[32];
 	int ret;
@@ -2073,7 +2071,7 @@ static int cdrom_read_cd(struct cdrom_device_info *cdi,
 			 struct packet_command *cgc, int lba,
 			 int blocksize, int nblocks)
 {
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 
 	memset(&cgc->cmd, 0, sizeof(cgc->cmd));
 	cgc->cmd[0] = GPCMD_READ_10;
@@ -2093,7 +2091,7 @@ static int cdrom_read_block(struct cdrom_device_info *cdi,
 			    struct packet_command *cgc,
 			    int lba, int nblocks, int format, int blksize)
 {
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 
 	memset(&cgc->cmd, 0, sizeof(cgc->cmd));
 	cgc->cmd[0] = GPCMD_READ_CD;
@@ -2764,7 +2762,7 @@ static int cdrom_ioctl_audioctl(struct cdrom_device_info *cdi,
  */
 static int cdrom_switch_blocksize(struct cdrom_device_info *cdi, int size)
 {
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	struct packet_command cgc;
 	struct modesel_head mh;
 
@@ -2790,7 +2788,7 @@ static int cdrom_switch_blocksize(struct cdrom_device_info *cdi, int size)
 static int cdrom_get_track_info(struct cdrom_device_info *cdi,
 				__u16 track, __u8 type, track_information *ti)
 {
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	struct packet_command cgc;
 	int ret, buflen;
 
@@ -3049,7 +3047,7 @@ static noinline int mmc_ioctl_cdrom_play_msf(struct cdrom_device_info *cdi,
 					     void __user *arg,
 					     struct packet_command *cgc)
 {
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	struct cdrom_msf msf;
 	cd_dbg(CD_DO_IOCTL, "entering CDROMPLAYMSF\n");
 	if (copy_from_user(&msf, (struct cdrom_msf __user *)arg, sizeof(msf)))
@@ -3069,7 +3067,7 @@ static noinline int mmc_ioctl_cdrom_play_blk(struct cdrom_device_info *cdi,
 					     void __user *arg,
 					     struct packet_command *cgc)
 {
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	struct cdrom_blk blk;
 	cd_dbg(CD_DO_IOCTL, "entering CDROMPLAYBLK\n");
 	if (copy_from_user(&blk, (struct cdrom_blk __user *)arg, sizeof(blk)))
@@ -3164,7 +3162,7 @@ static noinline int mmc_ioctl_cdrom_start_stop(struct cdrom_device_info *cdi,
 					       struct packet_command *cgc,
 					       int cmd)
 {
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	cd_dbg(CD_DO_IOCTL, "entering CDROMSTART/CDROMSTOP\n");
 	cgc->cmd[0] = GPCMD_START_STOP_UNIT;
 	cgc->cmd[1] = 1;
@@ -3177,7 +3175,7 @@ static noinline int mmc_ioctl_cdrom_pause_resume(struct cdrom_device_info *cdi,
 						 struct packet_command *cgc,
 						 int cmd)
 {
-	struct cdrom_device_ops *cdo = cdi->ops;
+	const struct cdrom_device_ops *cdo = cdi->ops;
 	cd_dbg(CD_DO_IOCTL, "entering CDROMPAUSE/CDROMRESUME\n");
 	cgc->cmd[0] = GPCMD_PAUSE_RESUME;
 	cgc->cmd[8] = (cmd == CDROMRESUME) ? 1 : 0;
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 584bc3126403..f1a6e520ac6e 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -481,7 +481,7 @@ static int gdrom_audio_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
 	return -EINVAL;
 }
 
-static struct cdrom_device_ops gdrom_ops = {
+static const struct cdrom_device_ops gdrom_ops = {
 	.open			= gdrom_open,
 	.release		= gdrom_release,
 	.drive_status		= gdrom_drivestatus,
@@ -489,9 +489,9 @@ static struct cdrom_device_ops gdrom_ops = {
 	.get_last_session	= gdrom_get_last_session,
 	.reset			= gdrom_hardreset,
 	.audio_ioctl		= gdrom_audio_ioctl,
+	.generic_packet		= cdrom_dummy_generic_packet,
 	.capability		= CDC_MULTI_SESSION | CDC_MEDIA_CHANGED |
 				  CDC_RESET | CDC_DRIVE_STATUS | CDC_CD_R,
-	.n_minors		= 1,
 };
 
 static int gdrom_bdops_open(struct block_device *bdev, fmode_t mode)
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 9cbd217bc0c9..ab9232e1e16f 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1166,7 +1166,7 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
 	 CDC_CD_RW | CDC_DVD | CDC_DVD_R | CDC_DVD_RAM | CDC_GENERIC_PACKET | \
 	 CDC_MO_DRIVE | CDC_MRW | CDC_MRW_W | CDC_RAM)
 
-static struct cdrom_device_ops ide_cdrom_dops = {
+static const struct cdrom_device_ops ide_cdrom_dops = {
 	.open			= ide_cdrom_open_real,
 	.release		= ide_cdrom_release_real,
 	.drive_status		= ide_cdrom_drive_status,
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 94352e4df831..013bfe049a48 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -117,7 +117,7 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 				    unsigned int clearing, int slot);
 static int sr_packet(struct cdrom_device_info *, struct packet_command *);
 
-static struct cdrom_device_ops sr_dops = {
+static const struct cdrom_device_ops sr_dops = {
 	.open			= sr_open,
 	.release	 	= sr_release,
 	.drive_status	 	= sr_drive_status,
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 8609d577bb66..6e8f209a6dff 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -36,7 +36,7 @@ struct packet_command
 
 /* Uniform cdrom data structures for cdrom.c */
 struct cdrom_device_info {
-	struct cdrom_device_ops  *ops;  /* link to device_ops */
+	const struct cdrom_device_ops *ops; /* link to device_ops */
 	struct list_head list;		/* linked list of all device_info */
 	struct gendisk *disk;		/* matching block layer disk */
 	void *handle;		        /* driver-dependent data */
@@ -87,7 +87,6 @@ struct cdrom_device_ops {
 
 /* driver specifications */
 	const int capability;   /* capability flags */
-	int n_minors;           /* number of active minor devices */
 	/* handle uniform packets for scsi type devices (scsi,atapi) */
 	int (*generic_packet) (struct cdrom_device_info *,
 			       struct packet_command *);
@@ -123,6 +122,8 @@ extern int cdrom_mode_sense(struct cdrom_device_info *cdi,
 			    int page_code, int page_control);
 extern void init_cdrom_command(struct packet_command *cgc,
 			       void *buffer, int len, int type);
+extern int cdrom_dummy_generic_packet(struct cdrom_device_info *cdi,
+				      struct packet_command *cgc);
 
 /* The SCSI spec says there could be 256 slots. */
 #define CDROM_MAX_SLOTS	256
-- 
2.7.4


-- 
Kees Cook
Pixel Security
