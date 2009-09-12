From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCHv2] qla2xxx: Correct compilation issues when
 CONFIG_MOUDLES=n.
Date: Fri, 11 Sep 2009 23:06:33 -0500
Message-ID: <1252728393.13282.485.camel@mulgrave.site>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
	 <20090907102747.ac6b98ff.randy.dunlap@oracle.com>
	 <20090908182541.GB44157@plap4-2.local> <20090911175341.GH710@plap4-2.local>
	 <1252708951.13282.151.camel@mulgrave.site>
	 <20090912000742.GB12098@plap4-2.local>
	 <20090912001752.GC12098@plap4-2.local>
	 <20090912003808.GD12098@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090912003808.GD12098@plap4-2.local>
Sender: linux-next-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2009-09-11 at 17:38 -0700, Andrew Vasquez wrote:
> Randy Dunlap noted:
> 
>   when CONFIG_MODULES=n:
> 
> 	drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type
> 
>   in
> 
> 	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> 		KOBJ_CHANGE, envp);
> 
> Trigger kobject event on the 'struct device' hanging off the pci_dev.
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
> 
> > On Fri, 11 Sep 2009, Andrew Vasquez wrote:
> > 
> > > The struct device's kobj from pdev->dev?
> > > 
> > > My udev-foo is pathetic, so how exactly would that get multiplexed at
> > > the udev side?
> > > 
> > > 	KERNEL=="???", SUBSYSTEM=="???", ACTION=="change", RUN+="qla2xxx_udev.sh"
> > 
> > Ok, udevadm helps a bit...  Let me see if I can convert this uevent
> > off of:
> > 
> > 	kobject_uevent_env(&(&vha->hw->pdev->dev)->kobj, KOBJ_CHANGE, envp);
> > 
> > to something meaningful:
> > 
> > 	UEVENT[1252714722.263731] change
> > 	/devices/pci0000:17/0000:17:08.0/0000:1e:00.0 (pci)
> > 	ACTION=change
> > 	DEVPATH=/devices/pci0000:17/0000:17:08.0/0000:1e:00.0
> > 	SUBSYSTEM=pci
> > 	FW_DUMP=6
> > 	DRIVER=qla2xxx
> > 	PHYSDEVBUS=pci
> > 	PHYSDEVDRIVER=qla2xxx
> > 	PCI_CLASS=C0400
> > 	PCI_ID=1077:2532
> > 	PCI_SUBSYS_ID=1077:015C
> > 	PCI_SLOT_NAME=0000:1e:00.0
> > 	MODALIAS=pci:v00001077d00002532sv00001077sd0000015Cbc0Csc04i00
> > 	SEQNUM=3574
> 
> Ok, with the kobject_uevent_env() change and the udev-rule modified to:
> 
> 	SUBSYSTEM=="pci", ENV{DRIVER}="qla2xxx", ACTION=="change", RUN+="qla2xxx_udev.sh"
> 
> we're working again.
> 
> This seem reasonable?
> 
> Thanks, AV
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 29396c0..369a270 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2683,8 +2683,7 @@ qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
>  		/* do nothing */
>  		break;
>  	}
> -	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> -	    KOBJ_CHANGE, envp);
> +	kobject_uevent_env(&(&vha->hw->pdev->dev)->kobj, KOBJ_CHANGE, envp);

Much better.  Of course to be perfect, you might like to remember that
(&x)->y is actually x.y

so 

kobject_uevent_env(&vha->hw->pdev->dev.kobj, ...

James
