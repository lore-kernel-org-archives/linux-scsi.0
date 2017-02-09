From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [lkp-robot] [scsi, block] 0dba1314d4:
 WARNING:at_fs/sysfs/dir.c:#sysfs_warn_dup
Date: Wed, 08 Feb 2017 16:08:18 -0800
Message-ID: <1486598898.2484.46.camel@HansenPartnership.com>
References: <20170204070936.GE12121@yexl-desktop>
         <CAPcyv4j0syAsinM-KbeefKysJhM9zt6kvrX=0c2HrtPV_tRAHQ@mail.gmail.com>
         <CAPcyv4gBQDuj65KRmFvP2q4Qt3d3xycM8L_TypAzYkvhmUSh6A@mail.gmail.com>
         <20170205091314.GA3042@lst.de>
         <CAPcyv4gE0+3pZQV=V75wxddFVhWeAz1abfJ=q8D1Zi+8Oi17rA@mail.gmail.com>
         <1486426467.2474.122.camel@HansenPartnership.com>
         <01c338e2-2a30-610d-b7fa-00cb3ce2cf86@fb.com>
         <CAPcyv4jkak-gX3gQaBJiEk1G79skdN2F9WL-sK2DjPwFhA8rdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4jkak-gX3gQaBJiEk1G79skdN2F9WL-sK2DjPwFhA8rdg@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, kernel test robot <xiaolong.ye@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jan Kara <jack@suse.cz>, Omar Sandoval <osandov@osandov.com>, Omar Sandoval <osandov@fb.com>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, LKP <lkp@01.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-02-06 at 21:42 -0800, Dan Williams wrote:
> On Mon, Feb 6, 2017 at 8:09 PM, Jens Axboe <axboe@fb.com> wrote:
> > On 02/06/2017 05:14 PM, James Bottomley wrote:
> > > On Sun, 2017-02-05 at 21:13 -0800, Dan Williams wrote:
> > > > On Sun, Feb 5, 2017 at 1:13 AM, Christoph Hellwig <hch@lst.de>
> > > > wrote:
> > > > > Dan,
> > > > > 
> > > > > can you please quote your emails?  I can't find any content
> > > > > inbetween all these quotes.
> > > > 
> > > > Sorry, I'm using gmail, but I'll switch to attaching the logs.
> > > > 
> > > > So with help from Xiaolong I was able to reproduce this, and it
> > > > does
> > > > not appear to be a regression. We simply change the failure
> > > > output of
> > > > an existing bug. Attached is a log of the same test on v4.10
> > > > -rc7
> > > > (i.e. without the recent block/scsi fixes), and it shows sda
> > > > being
> > > > registered twice.
> > > > 
> > > > "[    6.647077] kobject (d5078ca4): tried to init an
> > > > initialized
> > > > object, something is seriously wrong."
> > > > 
> > > > The change that "scsi, block: fix duplicate bdi name
> > > > registration
> > > > crashes" makes is to properly try to register sdb since the sda
> > > > devt
> > > > is still alive. However that's not a fix because we've managed
> > > > to
> > > > call blk_register_queue() twice on the same queue.
> > > 
> > > OK, time to involve others: linux-scsi and linux-block cc'd and
> > > I've
> > > inserted the log below.
> > > 
> > > James
> > > 
> > > ---
> > > 
> > > [    5.969672] scsi host0: scsi_debug: version 1.86 [20160430]
> > > [    5.969672]   dev_size_mb=8, opts=0x0, submit_queues=1,
> > > statistics=0
> > > [    5.971895] scsi 0:0:0:0: Direct-Access     Linux   
> > >  scsi_debug       0186 PQ: 0 ANSI: 7
> > > [    6.006983] sd 0:0:0:0: [sda] 16384 512-byte logical blocks:
> > > (8.39 MB/8.00 MiB)
> > > [    6.026965] sd 0:0:0:0: [sda] Write Protect is off
> > > [    6.027870] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
> > > [    6.066962] sd 0:0:0:0: [sda] Write cache: enabled, read
> > > cache: enabled, supports DPO and FUA
> > > [    6.486962] sd 0:0:0:0: [sda] Attached SCSI disk
> > > [    6.488377] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> > > [    6.489455] sd 0:0:0:0: Attached scsi generic sg0 type 0
> > > [    6.526982] sd 0:0:0:0: [sda] 16384 512-byte logical blocks:
> > > (8.39 MB/8.00 MiB)
> > > [    6.546964] sd 0:0:0:0: [sda] Write Protect is off
> > > [    6.547873] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
> > > [    6.586963] sd 0:0:0:0: [sda] Write cache: enabled, read
> > > cache: enabled, supports DPO and FUA
> > > [    6.647077] kobject (d5078ca4): tried to init an initialized
> > > object, something is seriously wrong.
> > 
> > So sda is probed twice, and hilarity ensues when we try to register
> > it
> > twice.  I can't reproduce this, using scsi_debug and with
> > scsi_async
> > enabled.
> > 
> > This is running linux-next? What's your .config?
> > 
> 
> The original failure report is here:
> 
> http://marc.info/?l=linux-kernel&m=148619222300774&w=2
> 
> ...but it reproduces on current mainline with the same config. I
> haven't spotted what makes scsi_debug behave like this.

Looking at the config, it's a static debug with report luns enabled. 
 Is it as simple as the fact that we probe lun 0 manually to see if the
target exists, but then we don't account for the fact that we already
did this, so if it turns up again in the report lun scan, we'll probe
it again leading to a double add.  If that theory is correct, this may
be the fix (compile tested only).

James

---

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6f7128f..ba4be08 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1441,6 +1441,10 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	for (lunp = &lun_data[1]; lunp <= &lun_data[num_luns]; lunp++) {
 		lun = scsilun_to_int(lunp);
 
+		if (lun == 0)
+			/* already scanned LUN 0 */
+			continue;
+
 		if (lun > sdev->host->max_lun) {
 			sdev_printk(KERN_WARNING, sdev,
 				    "lun%llu has a LUN larger than"
