From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] megasas: Update to version 1.01
Date: Wed, 09 Jun 2010 03:47:12 -0700
Message-ID: <1276080432.18353.51.camel@haakon2.linux-iscsi.org>
References: <20100608141506.DC0A52AC5B@ochil.suse.de>
	 <1276078488.18353.28.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:31843 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753049Ab0FIKrP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2010 06:47:15 -0400
In-Reply-To: <1276078488.18353.28.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2010-06-09 at 03:14 -0700, Nicholas A. Bellinger wrote:
> On Tue, 2010-06-08 at 16:15 +0200, Hannes Reinecke wrote:
> > This patch updates the megasas HBA emulation to version 1.01.
> > It fixes the following issues:
> > 
> > - Remove hand-crafted inquiry command
> > - Remove bounce-buffer for direct commands
> > - Implements qdev properties to set 'max_sge', 'max_cmds'.
> > - Implement JBOD mode
> > - Improve direct command handling
> > - Minor cleanups
> > 
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > 
> 
> Hi Hannes,
> 
> I applied your changes and everything looks good with the exception of
> the new MEGASAS_DEFAULT_SGE=80 setting..
> 
> > diff --git a/hw/megasas.c b/hw/megasas.c
> > index 250c3fb..19569a8 100644
> > --- a/hw/megasas.c
> > +++ b/hw/megasas.c
> > @@ -40,38 +40,17 @@ do { fprintf(stderr, "megasas: error: " fmt , ## __VA_ARGS__);} while (0)
> >  #endif
> >  
> >  /* Static definitions */
> > -#define MEGASAS_MAX_FRAMES 1000
> > -#define MEGASAS_MAX_SGE 8
> 
> <snip>
> 
> > +#define MEGASAS_VERSION "1.01"
> > +#define MEGASAS_MAX_FRAMES 2048		/* Firmware limit at 65535 */
> > +#define MEGASAS_DEFAULT_FRAMES 1000	/* Windows requires this */
> > +#define MEGASAS_MAX_SGE 255		/* Firmware limit */
> > +#define MEGASAS_DEFAULT_SGE 80
> 
> Ok, I have been running some LTP disktest raw bandwith benchmarks with a
> 256K blocksize with megasas -> TCM_Loop -> TCM/RAMDISK_DR LUNs into a
> v2.6.26 x86_64 Linux guest (4 VCPUs and 2048 memory) and I noticed
> something interesting..
> 
> With the new MEGASAS_DEFAULT_SGE 80 setting for fw_sge, read/write tests
> have dropped from the original ~1050 MB/sec to roughly ~400 MB/sec.
> Passing in the new qdev option using the old default of max_sge=8 the
> speed jumps back up to the range that where previously observed w/o this
> patch.  Going a bit further, using max_sge=16 jumps up bandwith up to
> ~1600 MB/sec, and max_sge=24 takes it up to ~2200 MB/sec..!  Using
> max_sge=32 then sharply drops back to ~800 MB/sec, and increasing to
> larger values brings bandwith down lower and lower..
> 
> Taking a look at the megaraid_sas LLD in the KVM guest, the struct
> scsi_host is being registered with sg_tablesize=28 which appears to be
> where the sharp dropoff for max_sge > 28 begins to occur.  I see that
> MFI_DCMD_CTRL_GET_INFO is returning the configured fw_sge to the guest,
> but AFAICT megaraid_sas does not adjust itself to use the larger value
> reported by GET_INFO.
> 

Actually scratch that last part about the megaraid_sas LLD..

drivers/scsi/megaraid/megaraid_sas.c:megasas_io_attach() is setting the
MFI GET_INFO returned fw_sge value to struct scsi_host->sg_tablesize
before calling scsi_add_host(), but there still appears to be an
performance issue somewhere when using max_sge > 28..

Note for TCM_Loop LLD running on KVM host we are currently using a
default of sg_tablesize=256.  Running the same LTP disktest benchmark
with TCM/RAMDISK LUNs as above for a Linux guest on a baremetal KVM host
(5500 series Nehalem) with v2.6.34 I am now seeing ~12900 MB/sec (yes,
100 Gbit/sec) of sustained read/write bandwith into the same single
Linux/SCSI LUN.  So AFAICT the limiting factor with the larger megasas
max_sge mentioned above appears to be outside of any bottlenecks that
may exist in Linux/SCSI or TCM_Loop+SG_IO backstore used with megasas.

Best,

--nab


