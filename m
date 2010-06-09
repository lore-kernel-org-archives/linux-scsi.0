From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] megasas: Update to version 1.01
Date: Wed, 09 Jun 2010 04:11:15 -0700
Message-ID: <1276081875.18353.72.camel@haakon2.linux-iscsi.org>
References: <20100608141506.DC0A52AC5B@ochil.suse.de>
	 <1276078488.18353.28.camel@haakon2.linux-iscsi.org>
	 <4C0F6DAE.6080503@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.gq1.yahoo.com ([67.195.14.39]:29207 "HELO
	smtp109.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757332Ab0FILLS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2010 07:11:18 -0400
In-Reply-To: <4C0F6DAE.6080503@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>

On Wed, 2010-06-09 at 12:32 +0200, Hannes Reinecke wrote:
> Nicholas A. Bellinger wrote:
> > Hi Hannes,
> > 
> > I applied your changes and everything looks good with the exception of
> > the new MEGASAS_DEFAULT_SGE=80 setting..
> > 
> >> diff --git a/hw/megasas.c b/hw/megasas.c
> >> index 250c3fb..19569a8 100644
> >> --- a/hw/megasas.c
> >> +++ b/hw/megasas.c
> >> @@ -40,38 +40,17 @@ do { fprintf(stderr, "megasas: error: " fmt , ## __VA_ARGS__);} while (0)
> >>  #endif
> >>  
> >>  /* Static definitions */
> >> -#define MEGASAS_MAX_FRAMES 1000
> >> -#define MEGASAS_MAX_SGE 8
> > 
> > <snip>
> > 
> >> +#define MEGASAS_VERSION "1.01"
> >> +#define MEGASAS_MAX_FRAMES 2048		/* Firmware limit at 65535 */
> >> +#define MEGASAS_DEFAULT_FRAMES 1000	/* Windows requires this */
> >> +#define MEGASAS_MAX_SGE 255		/* Firmware limit */
> >> +#define MEGASAS_DEFAULT_SGE 80
> > 
> > Ok, I have been running some LTP disktest raw bandwith benchmarks with a
> > 256K blocksize with megasas -> TCM_Loop -> TCM/RAMDISK_DR LUNs into a
> > v2.6.26 x86_64 Linux guest (4 VCPUs and 2048 memory) and I noticed
> > something interesting..
> > 
> > With the new MEGASAS_DEFAULT_SGE 80 setting for fw_sge, read/write tests
> > have dropped from the original ~1050 MB/sec to roughly ~400 MB/sec.
> > Passing in the new qdev option using the old default of max_sge=8 the
> > speed jumps back up to the range that where previously observed w/o this
> > patch.  Going a bit further, using max_sge=16 jumps up bandwith up to
> > ~1600 MB/sec, and max_sge=24 takes it up to ~2200 MB/sec..!  Using
> > max_sge=32 then sharply drops back to ~800 MB/sec, and increasing to
> > larger values brings bandwith down lower and lower..
> > 
> > Taking a look at the megaraid_sas LLD in the KVM guest, the struct
> > scsi_host is being registered with sg_tablesize=28 which appears to be
> > where the sharp dropoff for max_sge > 28 begins to occur.  I see that
> > MFI_DCMD_CTRL_GET_INFO is returning the configured fw_sge to the guest,
> > but AFAICT megaraid_sas does not adjust itself to use the larger value
> > reported by GET_INFO.
> > 
> Thanks for confirmation. You just confirmed _why_ I made
> the SGE setting configurable.
> 
> The SGE default setting as found on 'real' HBAs is in fact 80,
> hence this value.
> However, I always suspected that we will have problems with
> direct SGL mapping if the settings from the underlying hardware
> and the emulation don't match.
> Which was the reason for the LSF discussion topic, if you remember :-)
> So thanks for the confirmation here.

Indeed, I was looking at best case large block bandwith with
TCM/RAMDISK_DR and zero-copy struct scatterlist mapping with the
can_queue and max_sectors using 1024.   Having a TCM IBLOCK/FILEIO/pSCSI
backstore for a real backend struct block_device is going to have a
certain overhead compared to raw struct page ramdisk, but I think the
RAMDISK_DR subsystem plugin gives us a good idea of where we are at with
TCM_Loop struct scsi_devices..  ;)

> 
> Hence I made the SGE setting configurable, so that it can be
> adjusted (manually for starters) to the underlying hardware.
> If you do a:
> 
> -device megasas,id=megasas,max_sge=28,mode=jbod
> 
> you have the desired behaviour.

Perfect.. I will check out mode=jbod as well..

> 
> Currently we cannot do this tuning automatically; we just have
> _one_ setting for the entire HBA emulation whereas the underlying
> disks connected to the megasas might have different settings.
> 
> Again, the proper handling here should be discussed on the LSF.
> 

<nod>

> > So that said, I think we want to use MEGASAS_DEFAULT_SGE 28 to match
> > what the Linux driver is using.  I have not checked what the equivlient
> > sg_tablesize for the MSFT LLD is doing, but it appears we need to error
> > on the conserative side here.  What do you think..?
> > 
> As said, this is _not_ what linux is using. This is what you particular
> HBA is using. On one of my machines I have:
> 
> cat /sys/class/scsi_host/host?/sg_tablesize 
> 128
> 128
> 128
> 64
> 64
> 128
> 128
> 
> So maybe you should consider updating your HBA ...
> 

Yes, my mistake.  megaraid_sas is actually querying for it's struct
scsi_host->sg_tablesize..

> I would advocate setting it to the real HBA setting of
> 80 (which works just find for file-based backends)
> and have it adjusted manually if an sg-based backend
> is used.
> 

Hmm, then it appears that there is a known bottleneck somewhere in the
v2.6.26 Linux guest stack or perhaps somewhere else or something with
SG_IO..?

I am still using include/scsi/sg.h:SG_MAX_QUEUE 128, but I am not sure
if this would be effectted by the larger max_sge too..?  I am also
wondering if the conversion to use BSG here will have an effect with the
larger max_sge values..?

Best,

--nab

