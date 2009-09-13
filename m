From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCHv3] qla2xxx: Correct compilation issues when
 CONFIG_MODULES=n.
Date: Sun, 13 Sep 2009 14:02:05 -0700
Message-ID: <20090913140205.3a684f7c.randy.dunlap@oracle.com>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
	<20090907102747.ac6b98ff.randy.dunlap@oracle.com>
	<20090908182541.GB44157@plap4-2.local>
	<20090911175341.GH710@plap4-2.local>
	<1252708951.13282.151.camel@mulgrave.site>
	<20090912000742.GB12098@plap4-2.local>
	<20090912001752.GC12098@plap4-2.local>
	<20090912003808.GD12098@plap4-2.local>
	<1252728393.13282.485.camel@mulgrave.site>
	<20090912164356.GA19451@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:37101 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZIMVCQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2009 17:02:16 -0400
In-Reply-To: <20090912164356.GA19451@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>

On Sat, 12 Sep 2009 09:43:56 -0700 Andrew Vasquez wrote:

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

That works.  Thanks for your persistence.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
> 
> 	On Fri, 11 Sep 2009, James Bottomley wrote:
> 
> 	> > diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> 	> > index 29396c0..369a270 100644
> 	> > --- a/drivers/scsi/qla2xxx/qla_os.c
> 	> > +++ b/drivers/scsi/qla2xxx/qla_os.c
> 	> > @@ -2683,8 +2683,7 @@ qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
> 	> >  		/* do nothing */
> 	> >  		break;
> 	> >  	}
> 	> > -	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> 	> > -	    KOBJ_CHANGE, envp);
> 	> > +	kobject_uevent_env(&(&vha->hw->pdev->dev)->kobj, KOBJ_CHANGE, envp);
> 	> 
> 	> Much better.  Of course to be perfect, you might like to remember that
> 	> (&x)->y is actually x.y
> 	> 
> 	> so 
> 	> 
> 	> kobject_uevent_env(&vha->hw->pdev->dev.kobj, ...
> 
> 	Ahh, of course...  Perfection...the enemy of progress...
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 29396c0..86f337f 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2683,8 +2683,7 @@ qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
>  		/* do nothing */
>  		break;
>  	}
> -	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> -	    KOBJ_CHANGE, envp);
> +	kobject_uevent_env(&vha->hw->pdev->dev.kobj, KOBJ_CHANGE, envp);
>  }
>  
>  void


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
