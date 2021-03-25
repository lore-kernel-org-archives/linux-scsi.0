Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9765C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 02:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 669C5619C7
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 02:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhCYC6L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 22:58:11 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:33110 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCYC55 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 22:57:57 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 5DBEA2EA28A;
        Wed, 24 Mar 2021 22:57:56 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id tNWVsBozGjtv; Wed, 24 Mar 2021 22:39:59 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 768692EA0B8;
        Wed, 24 Mar 2021 22:57:54 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: Isssues with very large LUN count servers and booting becoming
 more and more of a problem
To:     Laurence Oberman <loberman@redhat.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, Ewan Milne <emilne@redhat.com>,
        "Van Assche, Bart" <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>
References: <fa08c1edd1aeede6d5c8109b8a473120cca5e35b.camel@redhat.com>
 <0d042d7604e57b8cdd3fe4a0a6914e6ab1d7c85c.camel@redhat.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <390ace87-f779-1d27-1e9b-e0a6144efb5f@interlog.com>
Date:   Wed, 24 Mar 2021 22:57:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0d042d7604e57b8cdd3fe4a0a6914e6ab1d7c85c.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-24 8:28 p.m., Laurence Oberman wrote:
> On Mon, 2021-03-22 at 17:02 -0400, Laurence Oberman wrote:
>> Hello
>> We have been struggling with this for years.
>> Systems are getting so large now that a system with multi-terabyte
>> memory and 1000's of device paths is becoming common.
>>
>> For example, customers are seeing 16 paths and with a 1000 LUNS thats
>> 16000 multiline console log discovery etc.
>>
>> We land up in Emergency mode and various incatanations of "cant boot"
>> due to console putput slowdown that (while worse on serial consoles)
>> is
>> still huge overhead that can even require us to use watchdog_thresh
>> on
>> the kernel line to prevent the NMI's
>>
>> I started thinking about a new parameter for scsi_mod that could be
>> used by sd and the scsi_dh_alua probing / discovery messaging (that
>> is
>> so noisy), to quieten it down.
>>
>> Before I even put efort into this, I wanted to see if you folks have
>> an
>> appetite for this.
>>
>> We have been blacklisting HBA drivers and using verious printk masks
>> etc to overcome this but a way to mask this within sd.c and
>> scsi_dh_alua.c I think could work better.
>> It would not be the default of course but an option to be added for
>> these huge customers.
>> I would look do do the minimal logging for a device discovery, just
>> so
>> some messaging is there for debug etc and I think it will help.
>>
>> If this is a crazy idea, let me know and I wont pursue it, but I
>> decided to just put it out there.
>>
>> Best Regards
>> Laurence Oberman
>>
> 
> Replying to my own thread with more information
> 
> RFE: Introduce two new macros to manage the crazy amount of boot
> logging we get with the large LUN count systems
> 
> sd_printk_boot_control
> sdev_printk_boot_control
> 
> These macros have an extra parameter boot_log_enable and if its default
> (1) then logs are printed
> adding scsi_mod.scsi_alua_boot_logging=0 will quiet down the logging
> for these huge systems
> 
> With no parameter (default) nothing changes in the logging
> 
> With boot log control and regular console
> 134s to boot and 1987 lines with 80 devices and 2 paths
> 
> With no boot control (default) and regular console
> 170s to boot and about 4000 lines of logging
> 
> The patch inline is not final so I did not send with git given this is
> an RFE.
> t is included to show the changes I was thinking about.
> 
> Tests
> ---------
> One Example
> With boot log control and regular console
> 134s to boot and 1987 lines with 80 devices and 2 paths
> 
> With no boot control (default) and regular console
> 170s to boot and about 4000 lines of logging
> 
> This one is even easier to explain why we need this.
> I could not boot this host unless I blacklisted the lpfc and qla2xxx
> drivers.
> It has 128 CPUS. (DL980G7)
> 
> I am not using a serial console either, I see the same hard lockup for
> the console vprintk on the VGA console.
> It has 4 Adapter ports and 8 paths for some LUNS and 16 for others and
> would hard lockup on both consoles even with watchdog_thresh=30
> Anyway Now I am able to boot.
> 
> This issue is not uncommon lately with a lot of customers landing up in
> Emergency Shells or having crazy long boot times or worse not booting
> at all
> 
> Proposed code changes, if there is any interest will clean up after
> comments and send.
> 
> Note that there is no way I could find to change the current macros to
> allow a new argument when passed to be used such that I did not have to
> change every sd_printk and every sdev_printk.
> 
> This way I aonly change the wones I wanted a small selection and I call
> the new macros.
> 
> Again, just need a OK, clean maybe we can consider or simply a NAK.
> 
> A NAK is fine with a simple explanation why.
> 
> Thanks fr the consideration
> 
> Laurence
> 
> Example patch only, to still be checked and fixed and correct the
> wrapping and column length later.
> It was tested against 5.12 latest and against RHEL8.3 kernels
> 
> commit 52105c69ef20d57ed9f219486ac821e5d29ea5eb (HEAD -> loberman-
> upstream)
> Author: Laurence Oberman <loberman@redhat.com>
> Date:   Wed Mar 24 14:10:49 2021 -0400
> 
>      Add two new macros for managing the boot logging for large LUN
> count configurations
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index ea436a14087f..9ce5e70ecbcc 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -58,6 +58,8 @@ static LIST_HEAD(port_group_list);
>   static DEFINE_SPINLOCK(port_group_lock);
>   static struct workqueue_struct *kaluad_wq;
>   
> +extern int scsi_alua_boot_logging;
> +
>   struct alua_port_group {
>          struct kref             kref;
>          struct rcu_head         rcu;
> @@ -282,16 +284,18 @@ static int alua_check_tpgs(struct scsi_device
> *sdev)
>          tpgs = scsi_device_tpgs(sdev);
>          switch (tpgs) {
>          case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
> -               sdev_printk(KERN_INFO, sdev,
> +               sdev_printk_boot_control(KERN_INFO, sdev,
> scsi_alua_boot_logging,
>                              "%s: supports implicit and explicit
> TPGS\n",
>                              ALUA_DH_NAME);
>                  break;
>          case TPGS_MODE_EXPLICIT:
> -               sdev_printk(KERN_INFO, sdev, "%s: supports explicit
> TPGS\n",
> +               sdev_printk_boot_control(KERN_INFO, sdev,
> scsi_alua_boot_logging,
> +                       "%s: supports explicit TPGS\n",
>                              ALUA_DH_NAME);
>                  break;
>          case TPGS_MODE_IMPLICIT:
> -               sdev_printk(KERN_INFO, sdev, "%s: supports implicit
> TPGS\n",
> +               sdev_printk_boot_control(KERN_INFO, sdev,
> scsi_alua_boot_logging,
> +                       "%s: supports implicit TPGS\n",
>                              ALUA_DH_NAME);
>                  break;
>          case TPGS_MODE_NONE:
> @@ -343,13 +347,14 @@ static int alua_check_vpd(struct scsi_device
> *sdev, struct alua_dh_data *h,
>                          return SCSI_DH_NOMEM;
>                  return SCSI_DH_DEV_UNSUPP;
>          }
> -       if (pg->device_id_len)
> -               sdev_printk(KERN_INFO, sdev,
> +       if (pg->device_id_len) {
> +               sdev_printk_boot_control(KERN_INFO, sdev,
> scsi_alua_boot_logging,
>                              "%s: device %s port group %x rel port
> %x\n",
>                              ALUA_DH_NAME, pg->device_id_str,
>                              group_id, rel_port);
> +       }
>          else
> -               sdev_printk(KERN_INFO, sdev,
> +               sdev_printk_boot_control(KERN_INFO, sdev,
> scsi_alua_boot_logging,
>                              "%s: port group %x rel port %x\n",
>                              ALUA_DH_NAME, group_id, rel_port);
>   
> @@ -635,7 +640,7 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_port_group *pg)
>                  pg->transition_tmo = ALUA_FAILOVER_TIMEOUT;
>   
>          if (orig_transition_tmo != pg->transition_tmo) {
> -               sdev_printk(KERN_INFO, sdev,
> +               sdev_printk_boot_control(KERN_INFO, sdev,
> scsi_alua_boot_logging,
>                              "%s: transition timeout set to %d
> seconds\n",
>                              ALUA_DH_NAME, pg->transition_tmo);
>                  pg->expiry = jiffies + pg->transition_tmo * HZ;
> @@ -686,7 +691,7 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_port_group *pg)
>          if (transitioning_sense)
>                  pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
>   
> -       sdev_printk(KERN_INFO, sdev,
> +       sdev_printk_boot_control(KERN_INFO, sdev,
> scsi_alua_boot_logging,
>                      "%s: port group %02x state %c %s supports
> %c%c%c%c%c%c%c\n",
>                      ALUA_DH_NAME, pg->group_id, print_alua_state(pg-
>> state),
>                      pg->pref ? "preferred" : "non-preferred",
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 24619c3bebd5..b91c46be345d 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -86,6 +86,9 @@ unsigned int scsi_logging_level;
>   EXPORT_SYMBOL(scsi_logging_level);
>   #endif
>   
> +int scsi_alua_boot_logging = 1;
> +EXPORT_SYMBOL(scsi_alua_boot_logging);
> +
>   /*
>    * Domain for asynchronous system resume operations.  It is marked
> 'exclusive'
>    * to avoid being included in the async_synchronize_full() that is
> invoked by
> @@ -749,6 +752,8 @@ MODULE_LICENSE("GPL");
>   
>   module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
>   MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
> +module_param(scsi_alua_boot_logging, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(scsi_alua_boot_logging, "If set to 0 will silence
> SCSI and ALUA discovery logging on boot");
>   
>   static int __init init_scsi(void)
>   {
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 9af50e6f94c4..282e7ad8370f 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -87,6 +87,8 @@ static const char *scsi_null_device_strs =
> "nullnullnullnull";
>   
>   static u64 max_scsi_luns = MAX_SCSI_LUNS;
>   
> +extern int scsi_alua_boot_logging;
> +
>   module_param_named(max_luns, max_scsi_luns, ullong, S_IRUGO|S_IWUSR);
>   MODULE_PARM_DESC(max_luns,
>                   "last scsi LUN (should be between 1 and 2^64-1)");
> @@ -863,7 +865,8 @@ static int scsi_add_lun(struct scsi_device *sdev,
> unsigned char *inq_result,
>          if (inq_result[7] & 0x10)
>                  sdev->sdtr = 1;
>   
> -       sdev_printk(KERN_NOTICE, sdev, "%s %.8s %.16s %.4s PQ: %d "
> +       sdev_printk_boot_control(KERN_NOTICE, sdev,
> scsi_alua_boot_logging,
> +                       "%s %.8s %.16s %.4s PQ: %d "
>                          "ANSI: %d%s\n", scsi_device_type(sdev->type),
>                          sdev->vendor, sdev->model, sdev->rev,
>                          sdev->inq_periph_qual, inq_result[2] & 0x07,
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index ed0b1bb99f08..c64451a6d1fd 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -104,6 +104,8 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
>   #define SD_MINORS      0
>   #endif
>   
> +extern int scsi_alua_boot_logging;
> +
>   static void sd_config_discard(struct scsi_disk *, unsigned int);
>   static void sd_config_write_same(struct scsi_disk *);
>   static int  sd_revalidate_disk(struct gendisk *);
> @@ -2205,7 +2207,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>                           * Issue command to spin up drive when not
> ready
>                           */
>                          if (!spintime) {
> -                               sd_printk(KERN_NOTICE, sdkp, "Spinning
> up disk...");
> +                               sd_printk_boot_control(KERN_NOTICE,
> sdkp, scsi_alua_boot_logging,
> +                                       "Spinning up disk...");
>                                  cmd[0] = START_STOP;
>                                  cmd[1] = 1;     /* Return immediately
> */
>                                  memset((void *) &cmd[2], 0, 8);
> @@ -2407,7 +2410,7 @@ static int read_capacity_16(struct scsi_disk
> *sdkp, struct scsi_device *sdp,
>          alignment = ((buffer[14] & 0x3f) << 8 | buffer[15]) *
> sector_size;
>          blk_queue_alignment_offset(sdp->request_queue, alignment);
>          if (alignment && sdkp->first_scan)
> -               sd_printk(KERN_NOTICE, sdkp,
> +               sd_printk_boot_control(KERN_NOTICE, sdkp,
> scsi_alua_boot_logging,
>                            "physical block alignment offset: %u\n",
> alignment);
>   
>          if (buffer[14] & 0x80) { /* LBPME */
> @@ -2524,11 +2527,11 @@ sd_read_capacity(struct scsi_disk *sdkp,
> unsigned char *buffer)
>                  if ((sizeof(sdkp->capacity) > 4) &&
>                      (sdkp->capacity > 0xffffffffULL)) {
>                          int old_sector_size = sector_size;
> -                       sd_printk(KERN_NOTICE, sdkp, "Very big device.
> "
> +                       sd_printk_boot_control(KERN_NOTICE, sdkp,
> scsi_alua_boot_logging, "Very big device. "
>                                          "Trying to use READ
> CAPACITY(16).\n");
>                          sector_size = read_capacity_16(sdkp, sdp,
> buffer);
>                          if (sector_size < 0) {
> -                               sd_printk(KERN_NOTICE, sdkp,
> +                               sd_printk_boot_control(KERN_NOTICE,
> sdkp, scsi_alua_boot_logging,
>                                          "Using 0xffffffff as device
> size\n");
>                                  sdkp->capacity = 1 + (sector_t)
> 0xffffffff;
>                                  sector_size = old_sector_size;
> @@ -2613,13 +2616,13 @@ sd_print_capacity(struct scsi_disk *sdkp,
>          string_get_size(sdkp->capacity, sector_size,
>                          STRING_UNITS_10, cap_str_10,
> sizeof(cap_str_10));
>   
> -       sd_printk(KERN_NOTICE, sdkp,
> +       sd_printk_boot_control(KERN_NOTICE,
> sdkp,scsi_alua_boot_logging,
>                    "%llu %d-byte logical blocks: (%s/%s)\n",
>                    (unsigned long long)sdkp->capacity,
>                    sector_size, cap_str_10, cap_str_2);
>   
>          if (sdkp->physical_block_size != sector_size)
> -               sd_printk(KERN_NOTICE, sdkp,
> +               sd_printk_boot_control(KERN_NOTICE, sdkp,
> scsi_alua_boot_logging,
>                            "%u-byte physical blocks\n",
>                            sdkp->physical_block_size);
>   }
> @@ -2687,9 +2690,10 @@ sd_read_write_protect_flag(struct scsi_disk
> *sdkp, unsigned char *buffer)
>                  sdkp->write_prot = ((data.device_specific & 0x80) !=
> 0);
>                  set_disk_ro(sdkp->disk, sdkp->write_prot);
>                  if (sdkp->first_scan || old_wp != sdkp->write_prot) {
> -                       sd_printk(KERN_NOTICE, sdkp, "Write Protect is
> %s\n",
> +                       sd_printk_boot_control(KERN_NOTICE, sdkp,
> scsi_alua_boot_logging,
> +                               "Write Protect is %s\n",
>                                    sdkp->write_prot ? "on" : "off");
> -                       sd_printk(KERN_DEBUG, sdkp, "Mode Sense:
> %4ph\n", buffer);
> +                       sd_printk_boot_control(KERN_DEBUG, sdkp,
> scsi_alua_boot_logging, "Mode Sense: %4ph\n", buffer);
>                  }
>          }
>   }
> @@ -2837,7 +2841,7 @@ sd_read_cache_type(struct scsi_disk *sdkp,
> unsigned char *buffer)
>   
>                  if (sdkp->first_scan || old_wce != sdkp->WCE ||
>                      old_rcd != sdkp->RCD || old_dpofua != sdkp->DPOFUA)
> -                       sd_printk(KERN_NOTICE, sdkp,
> +                       sd_printk_boot_control(KERN_NOTICE, sdkp,
> scsi_alua_boot_logging,
>                                    "Write cache: %s, read cache: %s,
> %s\n",
>                                    sdkp->WCE ? "enabled" : "disabled",
>                                    sdkp->RCD ? "disabled" : "enabled",
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index b59136c4125b..7e88ff08c063 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -137,7 +137,15 @@ static inline struct scsi_disk *scsi_disk(struct
> gendisk *disk)
>           (sdsk)->disk
> ?                                                 \
>                sdev_prefix_printk(prefix, (sdsk)-
>> device,                \
>                                   (sdsk)->disk->disk_name, fmt, ##a)
> :   \
> -             sdev_printk(prefix, (sdsk)->device, fmt, ##a)
> +             sdev_printk(prefix, (sdsk)->device, fmt, ##a)
> +
> +#define sd_printk_boot_control(prefix, sdsk, boot_log_enable, fmt,
> a...)                               \
> +       if (boot_log_enable)
> {                                          \
> +        (sdsk)->disk
> ?                                                 \
> +             sdev_prefix_printk(prefix, (sdsk)-
>> device,                \
> +                                (sdsk)->disk->disk_name, fmt, ##a)
> :   \
> +             sdev_printk(prefix, (sdsk)->device, fmt,
> ##a);             \
> +             }
>   
>   #define sd_first_printk(prefix, sdsk, fmt,
> a...)                       \
>          do
> {                                                            \
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 4383d93110f8..5802b17c21f3 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -62,6 +62,8 @@ static int sg_version_num = 30536;    /* 2 digits for
> each component */
>   static char *sg_version_date = "20140603";
>   
>   static int sg_proc_init(void);
> +
> +extern int scsi_alua_boot_logging;

Perhaps you could put that declaration in include/scsi/scsh.h (or something
that it includes) so you don't need to repeat it in every file that needs
to access scsi_alua_boot_logging .

Otherwise it looks fine to me.

When I test the scsi_debug driver with 10,000 LUNs I purposely choose a
PDT that won't trigger any udev hassles:

# time modprobe scsi_debug ptype=0x1d max_luns=500 num_tgts=4 add_host=5
real	0m2.558s
user	0m0.006s
sys	0m0.032s
# lsscsi -gs | wc
   10005   80040  849316
#

But the 10,000 lines like this is /var/log/syslog :
     kernel: scsi 4:0:0:16595: Attached scsi generic sg1015 type 29

are a bit annoying. And your patch will quash those.

Doug Gilbert


P.S. The following 'rmmod scsi_debug' takes 2.9 seconds.

>   #endif
>   
>   #define SG_ALLOW_DIO_DEF 0
> @@ -1572,7 +1574,8 @@ sg_add_device(struct device *cl_dev, struct
> class_interface *cl_intf)
>          } else
>                  pr_warn("%s: sg_sys Invalid\n", __func__);
>   
> -       sdev_printk(KERN_NOTICE, scsidp, "Attached scsi generic sg%d "
> +       sdev_printk_boot_control(KERN_NOTICE, scsidp,
> scsi_alua_boot_logging,
> +                       "Attached scsi generic sg%d "
>                      "type %d\n", sdp->index, scsidp->type);
>   
>          dev_set_drvdata(cl_dev, sdp);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 1a5c9a3df6d6..5ec57a767d9c 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -264,6 +264,14 @@ sdev_prefix_printk(const char *, const struct
> scsi_device *, const char *,
>   __printf(3, 4) void
>   scmd_printk(const char *, const struct scsi_cmnd *, const char *,
> ...);
>   
> +#define sdev_printk_boot_control(l, sdev, boot_log_enable, fmt, a...)\
> +        if (boot_log_enable) {                                 \
> +               sdev_prefix_printk(l, sdev, NULL, fmt, ##a);    \
> +       }
> +
> +__printf(3, 4) void
> +scmd_printk(const char *, const struct scsi_cmnd *, const char *,
> ...);
> +
>   #define scmd_dbg(scmd, fmt,
> a...)                                         \
>          do
> {                                                               \
>                  if ((scmd)->request-
>> rq_disk)                              \
> 

