From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: qla2xxx: Correct compilation issues when CONFIG_MOUDLES=n (was:
 Re: linux-next: Tree for September 7 (scsi/qla2x))
Date: Fri, 11 Sep 2009 14:25:48 -0700
Message-ID: <20090911142548.b91cb917.randy.dunlap@oracle.com>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
	<20090907102747.ac6b98ff.randy.dunlap@oracle.com>
	<20090908182541.GB44157@plap4-2.local>
	<20090911175341.GH710@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090911175341.GH710@plap4-2.local>
Sender: linux-next-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 11 Sep 2009 10:53:41 -0700 Andrew Vasquez wrote:

> Randy Dunlap noted:
> 
>   when CONFIG_MODULES=n:
> 
> 	drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type
> 
>   in
> 	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> 		KOBJ_CHANGE, envp);
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> Ok, So any strong objections to just having the functionality present
> when module support is enabled?

Fine with me.  Thanks.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 29396c0..3887adb 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2671,6 +2671,7 @@ qla2x00_post_uevent_work(struct scsi_qla_host *vha, u32 code)
>  static void
>  qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
>  {
> +#ifdef CONFIG_MODULES
>  	char event_string[40];
>  	char *envp[] = { event_string, NULL };
>  
> @@ -2685,6 +2686,7 @@ qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
>  	}
>  	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
>  	    KOBJ_CHANGE, envp);
> +#endif
>  }
>  
>  void
> 


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
