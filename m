From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Date: Wed, 9 May 2012 14:19:56 +0800
Message-ID: <20120509061956.GA12329@gmail.com>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
 <4FAA02DA.3000201@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FAA02DA.3000201@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Zheng Liu <wenqing.lz@taobao.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 08, 2012 at 11:38:34PM -0600, Robert Hancock wrote:
> On 05/07/2012 09:24 PM, Zheng Liu wrote:
> >From: Zheng Liu<wenqing.lz@taobao.com>
> >
> >Currently, SATA disk fua detection is disabled on default because most of
> >devices don't support this feature at that time.  With the development of
> >technology, more and more SATA disks support this feature.  So now we can enable
> >this detection on default.
> >
> >Although fua detection is defined as a kernel module parameter, it is too hard
> >to set its value because it must be loaded and set before system starts up.
> >That needs to modify initrd file.  So it is inconvenient for administrator who
> >needs to manage a huge number of servers.
> >
> >CC: Jeff Garzik<jeff@garzik.org>
> >Signed-off-by: Zheng Liu<wenqing.lz@taobao.com>
> >---
> >  drivers/ata/libata-core.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> >index 23763a1..3627251 100644
> >--- a/drivers/ata/libata-core.c
> >+++ b/drivers/ata/libata-core.c
> >@@ -133,9 +133,9 @@ int atapi_passthru16 = 1;
> >  module_param(atapi_passthru16, int, 0444);
> >  MODULE_PARM_DESC(atapi_passthru16, "Enable ATA_16 passthru for ATAPI devices (0=off, 1=on [default])");
> >
> >-int libata_fua = 0;
> >+int libata_fua = 1;
> >  module_param_named(fua, libata_fua, int, 0444);
> >-MODULE_PARM_DESC(fua, "FUA support (0=off [default], 1=on)");
> >+MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on [default])");
> >
> >  static int ata_ignore_hpa;
> >  module_param_named(ignore_hpa, ata_ignore_hpa, int, 0644);
> 
> I don't see that this is very likely to cause issues, but the FUA
> implementation also seems a bit incomplete. FUA will only get
> enabled if the drive claims support for the FUA-specific commands
> like WRITE_DMA_FUA_EXT. But theoretically any drive that supports
> NCQ should be able to do FUA since there's a FUA bit provided in
> those commands. Of course this makes things a bit more complicated
> (for example, if NCQ gets disabled by user request or due to too
> many errors, and the drive doesn't support the separate FUA
> commands, then FUA needs to be disabled too.)

Hi Reboert,

Thanks for your reply.  Actually, we met a problem in our product
system.  We have thousands of database servers that run on Linux.
These servers have a lot of SATA disks that support FUA feature.
However, it displays that the disk doesn't support FUA in dmesg.  I
digged this problem and found that libata_fua variable is set to 0 to
disable FUA detection for SATA disk.  If FUA feature can be used, we
could disable io_barrier to improve the performance.  Now one solution
is that we set libata_fua to 1 when this kernel module is loaded.  But
it needs to modify initrd file, and it is too complicated for
administrator who needs to modify every server manually.  So that
enabling FUA detection is another solution.  Have you any other idea
to solve this problem?  Thank you.

Regards,
Zheng
