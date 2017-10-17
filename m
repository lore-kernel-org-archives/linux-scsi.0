From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: sd: Implement blacklist option for WRITE SAME w/
 UNMAP
Date: Tue, 17 Oct 2017 10:43:51 -0400
Message-ID: <1508251431.6492.4.camel@redhat.com>
References: <1506529677.4100.452.camel@localhost.localdomain>
         <20170928013512.1058-1-martin.petersen@oracle.com>
         <1506679376.11960.1.camel@redhat.com> <yq1lgkx63o3.fsf@oracle.com>
         <1506693712.28112.1.camel@redhat.com> <1508250370.6492.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:45306 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932493AbdJQOnx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 10:43:53 -0400
Received: by mail-qt0-f177.google.com with SMTP id p1so4029905qtg.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2017 07:43:53 -0700 (PDT)
In-Reply-To: <1508250370.6492.2.camel@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2017-10-17 at 10:26 -0400, Laurence Oberman wrote:
> On Fri, 2017-09-29 at 10:01 -0400, Laurence Oberman wrote:
> > On Fri, 2017-09-29 at 09:21 -0400, Martin K. Petersen wrote:
> > > Laurence,
> > > 
> > > > I am testing this but its not being picked up so I want to know
> > > > if
> > > > I
> > > > have the kernel command line wrong here.
> > > > 
> > > > scsi_dev_flags=LIO-ORG:thin2:0x80000000
> > > > 
> > > > What am I doing wrong to pass the BLIST flags.
> > > 
> > > This worked for me:
> > > 
> > > [root@kvm ~]# echo "Linux:scsi_debug:0x80000000" >
> > > /proc/scsi/device_info
> > > [root@kvm ~]# grep Linux /proc/scsi/device_info 
> > > 'Linux   ' 'scsi_debug      ' 0x80000000
> > > [root@kvm ~]# modprobe scsi_debug unmap_max_blocks=10
> > > unmap_max_desc=1 write_same_length=20 lbpws=1
> > > [root@kvm ~]# lsblk -D
> > > NAME DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
> > > sda         0      512B       5K         0
> > > 
> > > (With the caveat that I tweaked scsi_debug to report the UNMAP
> > > parameters despite lbpu being 0).
> > > 
> > 
> > OK, Thanks, that is working now and I pick up the correct size now.
> > Its going to be very useful for these corner case array
> > inconsistencies.
> > 
> > Tested-by: Laurence Oberman <loberman@redhat.com>
> > 
> > Sep 29 09:56:11 localhost kernel: scsi 1:0:0:50: Direct-
> > Access     LIO-
> > ORG  thin2            4.0  PQ: 0 ANSI: 5
> > Sep 29 09:56:11 localhost kernel: scsi 1:0:0:50: alua: supports
> > implicit and explicit TPGS
> > Sep 29 09:56:11 localhost kernel: scsi 1:0:0:50: alua: device
> > naa.6001405f7aa27ca453f4381a00f22ea6 port group 0 rel port 2
> > Sep 29 09:56:11 localhost kernel: sd 1:0:0:50: Attached scsi
> > generic
> > sg64 type 0
> > Sep 29 09:56:11 localhost kernel: RHDEBUG: unmap_limit_for_ws set
> > by
> > kernel flag for case SD_LBP_WS16
> > Sep 29 09:56:11 localhost kernel: sd 1:0:0:50: [sdbl] 81920000 512-
> > byte 
> > logical blocks: (41.9 GB/39.1 GiB)
> > Sep 29 09:56:11 localhost kernel: sd 1:0:0:50: [sdbl] Write Protect
> > is
> > off
> > Sep 29 09:56:11 localhost kernel: sd 1:0:0:50: [sdbl] Write cache:
> > enabled, read cache: enabled, supports DPO and FUA
> > Sep 29 09:56:11 localhost kernel: sd 1:0:0:50: alua: transition
> > timeout
> > set to 60 seconds
> 
> 
> Hi Martin
> 
> We have the code accepted for the patch above and its working fine
> with
> echo after boot as you already know.
> 
> However I am still fighting with trying to pass this on the kernel
> command line. We need to be able to do this as a dynamic method for
> adding devices to the list so that the list is populated prior to the
> device scan.
> 
> Using scsi_dev_flags=LIO-ORG:thin2:0x80000000 on the kernel line is
> ignored and not filled in.
> Its apparent to me that we have no longer have code to actually copy
> the string from the kernel line after boot.
> 
> I ran some tests and added a couple of printk;s to see if we have any
> capture and its NULL.
> 
> So when did this stop working, is what I am now chasing
> 
> [    1.524595] RHDEBUG:In scsi_init_devinfo scsi_dev_flags=
> [    1.524705] RHDEBUG: In scsi_init_devinfo error=0
> 
> We have this in  drivers/scsi/scsi_devinfo.c
> 
> module_param_string(dev_flags, scsi_dev_flags,
> sizeof(scsi_dev_flags),
> 0);
> MODULE_PARM_DESC(dev_flags,
> 
>          "Given scsi_dev_flags=vendor:model:flags[,v:m:f] add
> black/white"
>          " list entries for vendor and model with an integer value of
> flags"
>          " to the scsi device info list");
> 
> and we have:
> 
> /**
>  * scsi_init_devinfo - set up the dynamic device list.
>  *
>  * Description:
>  *      Add command line entries from scsi_dev_flags, then add
>  *      scsi_static_device_list entries to the scsi device info list.
>  */
> int __init scsi_init_devinfo(void)
> {
> #ifdef CONFIG_SCSI_PROC_FS
>         struct proc_dir_entry *p;
> #endif
>         int error, i;
> 
>         printk("RHDEBUG:In scsi_init_devinfo
> scsi_dev_flags=%s\n",scsi_dev_flags);
> 
>         error = scsi_dev_info_add_list(SCSI_DEVINFO_GLOBAL, NULL);
>         printk("RHDEBUG: In scsi_init_devinfo error=%d\n",error);
>         if (error) {
>                 printk("RHDEBUG: In scsi_init_devinfo, calling
> scsi_dev_info_add_list returning with error=%d\n",error);
>                 return error;
>         }
> 
>         error = scsi_dev_info_list_add_str(scsi_dev_flags);
>         if (error) {
>                 printk("RHDEBUG: In scsi_init_devinfo, calling
> scsi_info_list_add returning with error=%d\n",error);
>                 goto out;
>         }
> 
>         for (i = 0; scsi_static_device_list[i].vendor; i++) {
>                 error = scsi_dev_info_list_add(1 /* compatibile */,
>                                 scsi_static_device_list[i].vendor,
>                                 scsi_static_device_list[i].model,
>                                 NULL,
>                                 scsi_static_device_list[i].flags);
>                 if (error)
>                         goto out;
>         }
> 
> #ifdef CONFIG_SCSI_PROC_FS
>         p = proc_create("scsi/device_info", 0, NULL,
> &scsi_devinfo_proc_fops);
>         if (!p) {
>                 error = -ENOMEM;
>                 goto out;
>         }
> #endif /* CONFIG_SCSI_PROC_FS */
> 
>  out:
>         if (error)
>                 scsi_exit_devinfo();
>         return error;
> }
> 
> 
> But I fail to see where we actually copy the string off the kernel
> line.
> 
> I intend to add code and test and submit a patch but first wanted to
> know if its me simply missing something here.
> 
> Thanks
> Laurence

Answering my own post here.
As soon as I sent this Ewan emailed me explaining what I was doing
wrong.

Its working now by using 
scsi_mod.use_blk_mq=y scsi_mod.dev_flags=LIO-ORG:thin2:0x80000000

[root@segstorage1 ~]# dmesg | grep RHDEBUG
[    1.498639] RHDEBUG:In scsi_init_devinfo scsi_dev_flags=LIO-
ORG:thin2:0x80000000
[    1.499003] RHDEBUG: In scsi_init_devinfo error=0
[    9.031071] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[    9.202887] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[    9.246251] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[    9.423062] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[    9.632754] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[    9.781824] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   15.706504] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   16.254131] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   16.373697] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   16.443442] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   16.503806] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   16.582369] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   21.484123] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   21.552131] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   21.692909] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   21.975010] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   22.153413] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   22.685256] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   22.687920] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   22.692079] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   22.697259] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   22.721023] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   22.724256] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16
[   22.728566] RHDEBUG: unmap_limit_for_ws set by kernel flag for case
SD_LBP_WS16

Sorry for the noise
Thanks
Laurence
