From: "Martin J. Bligh" <mbligh@aracnet.com>
Subject: Re: feral driver in -mm
Date: Fri, 27 Jun 2003 14:23:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1330000.1056749038@[10.10.2.4]>
References: <20030627132727.024f2bf0.akpm@digeo.com> <1056746053.1825.174.camel@mulgrave> <20030627210621.GD3338@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from franka.aracnet.com ([216.99.193.44]:15522 "EHLO
	franka.aracnet.com") by vger.kernel.org with ESMTP id S264793AbTF0VKE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 17:10:04 -0400
In-Reply-To: <20030627210621.GD3338@beaverton.ibm.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@digeo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Works for me on 73-mm1 with that patch in (didn't try it without)

M.

--Mike Anderson <andmike@us.ibm.com> wrote (on Friday, June 27, 2003 14:06:21 -0700):

> 
> James Bottomley [James.Bottomley@steeleye.com] wrote:
>> On Fri, 2003-06-27 at 15:27, Andrew Morton wrote:
>> > Has anyone actually used the linux-isp driver in -mm lately?  I just tried
>> > it and it didn't seem to be able to locate the HBA.
>> > 
>> > James, if you have an update handy I'd like to grab a copy.  Else I'll drop
>> > it I think.
>> 
>> My latest update in bitkeeper is at
>> 
>> bk://linux-scsi.bkbits.net/scsi-isp-2.5
>> 
>> If you'd prefer, I could email you a diff.  Just let me check to see if
>> Matt Jacob has a later version (he did also still say that he didn't
>> consider this ready for prime time).
> 
> We did run into a issue here the other day that if you build the isp
> driver into the kernel it will not load. The reason is the recent
> changes to init_this_scsi_driver that checks for a release function.
> 
> I have been meaning to send this out but have not. The patch below works
> around the problem, but was very quickly done a final one should come
> from Matt / James.
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
> ===== drivers/scsi/isp/isp_linux.c 1.3 vs edited =====
> --- 1.3/drivers/scsi/isp/isp_linux.c	Wed Jun 18 09:46:23 2003
> +++ edited/drivers/scsi/isp/isp_linux.c	Tue Jun 24 22:38:40 2003
> @@ -145,7 +145,6 @@
>      return (rval);
>  }
>  
> -#ifdef	MODULE
>  /* io_request_lock *not* held here */
>  int
>  isplinux_release(struct Scsi_Host *host)
> @@ -185,7 +184,6 @@
>  	isp_kfree(FCPARAM(isp)->isp_dump_data, amt);
>  	FCPARAM(isp)->isp_dump_data = 0;
>      }
> -#endif
>  #if defined(CONFIG_PROC_FS) && LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
>      /*
>       * Undo any PROCFS stuff
> ===== drivers/scsi/isp/isp_linux.h 1.3 vs edited =====
> --- 1.3/drivers/scsi/isp/isp_linux.h	Wed Jun 18 09:46:23 2003
> +++ edited/drivers/scsi/isp/isp_linux.h	Tue Jun 24 22:37:08 2003
> @@ -775,12 +775,8 @@
>  
>  int isplinux_proc_info(char *, char **, off_t, int, int, int);
>  int isplinux_detect(Scsi_Host_Template *);
> -#ifdef	MODULE
>  int isplinux_release(struct Scsi_Host *);
>  #define	ISPLINUX_RELEASE	isplinux_release
> -#else
> -#define	ISPLINUX_RELEASE	NULL
> -#endif
>  const char *isplinux_info(struct Scsi_Host *);
>  int isplinux_queuecommand(Scsi_Cmnd *, void (* done)(Scsi_Cmnd *));
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
> 
> 


