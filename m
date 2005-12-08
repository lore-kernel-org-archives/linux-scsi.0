From: Andrew de Quincey <adq_dvb@lidskialf.net>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Thu, 8 Dec 2005 01:59:10 +0000
Message-ID: <200512080159.10913.adq_dvb@lidskialf.net>
References: <200512072358.15398.adq_dvb@lidskialf.net> <200512080119.48740.adq@lidskialf.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <200512080119.48740.adq@lidskialf.net>
Content-Disposition: inline
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: linux1394-devel@lists.sourceforge.net
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 08 December 2005 01:19, Andrew de Quincey wrote:
> On Wednesday 07 December 2005 23:58, Andrew de Quincey wrote:
> > Reposting to the -devel list since there was no response on -user.
> >
> > Hi, I'm using linux kernel 2.6.14 with an generation 1 ipod connected via
> > ieee1394/sbp2.
> >
> > I can mount/unmount it and use it fine. It even works with HAL now.
> >
> > The problem comes when I want to remove it. If I do:
> >
> > eject /dev/sdb
> >
> > The kernel panics with the following error:
> > Kernel panic - not syncing: PCI-DMA: high address but no IOMMU
> >
> > I'm using an nforce 4 motherboard (Asus A8N-SLI Deluxe). The ipod is
> > attached to the ieee1394 port on a creative labs Audigy2 sound card (uses
> > OHCI-1394).
>
> More info (I'm on an AMD64 in 64 bit mode BTW):
>
> eject sends a CDROMEJECT ioctl first of all. It is this IOCTL that kills my
> system. If I hack/tell it to just use a "SCSI eject", it works and actually
> makes my ipod show that tick thing showing it is safe to remove it.

Yet more info:

eject -s sends the following SCSI packet command to the sbp/ipod device:

1b 00 00 00 02 00 with a direction of DMA_NONE

eject -r results in the same via the CDROMEJECT translator in 
scsi_cmd_ioctl(), but with a direction of DMA_TO_DEVICE. Thats what crashes 
it - looks like its trying to set up a DMA transfer for 0 bytes or something. 
I just added a really horrible hack to the start of sbp2_send_command() to 
check, as follows:

   if (*cmd == 0x1b) {
      SCpnt->sc_data_direction = 3;
   }

Now, eject -r works perfectly. Though thats obviously not a good way to fix 
it :)


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
