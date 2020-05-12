Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FB0CA90AF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 18:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83B2B20673
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 18:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbgELSvG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 14:51:06 -0400
Received: from smtp.infotech.no ([82.134.31.41]:35148 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbgELSvG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 14:51:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id C599D204248;
        Tue, 12 May 2020 20:51:03 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2hEcAiZqvWfv; Tue, 12 May 2020 20:51:00 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 3550F20415B;
        Tue, 12 May 2020 20:50:59 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [bug report] scsi: scsi_debug: Add per_host_store option
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20200512103123.GA261906@mwanda>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <df0e1c90-1c3f-260e-c863-286c4c3c7138@interlog.com>
Date:   Tue, 12 May 2020 14:50:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200512103123.GA261906@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-12 6:31 a.m., Dan Carpenter wrote:
> Hello Douglas Gilbert,
> 
> The patch 87c715dcde63: "scsi: scsi_debug: Add per_host_store option"
> from Apr 21, 2020, leads to the following static checker warning:
> 
> drivers/scsi/scsi_debug.c:3748 resp_write_same() warn: inconsistent returns '*macc_lckp'.
>    Locked on  : 3728
>    Unlocked on: 3708,3748
> drivers/scsi/scsi_debug.c:3712 resp_write_same() error: we previously assumed 'sip' could be null (see line 3699)
> drivers/scsi/scsi_debug.c:3902 resp_comp_write() error: we previously assumed 'sip' could be null (see line 3859)
> drivers/scsi/scsi_debug.c:3965 resp_unmap() error: we previously assumed 'sip' could be null (see line 3926)
> drivers/scsi/scsi_debug.c:4261 resp_verify() error: we previously assumed 'sip' could be null (see line 4208)

Dan,
It is probably a bit much to expect a static analyzer to follow a table
driven parser. Before any resp_*() functions are invoked there is this
code in scsi_debug_queuecommand() . It starts with pfp=NULL :

         if (sdebug_fake_rw && (F_FAKE_RW & flags))
                 goto fini;
         if (unlikely(sdebug_every_nth)) {
                 if (fake_timeout(scp))
                         return 0;       /* ignore command: make trouble */
         }
         if (likely(oip->pfp))
                 pfp = oip->pfp; /* calls a resp_* function */
         else
                 pfp = r_pfp;    /* if leaf function ptr NULL, try the root's */
fini:

So iff those tables are properly set up then any media-touching (i.e.
store touching) SCSI command will have the F_FAKE_RW flag set and pfp
will reach the 'fini:' label still set to NULL. In that case the
corresponding resp_*() function will _not_ be called and this code's
static analysis becomes moot.

That said, a quick audit of those tables finds that some recently added
commands break that invariant so a new patch is coming. The static
analyzer may still complain, so can it be told to STFU ?

The code in that area is going to get the tripwire shown below.
check_patch.pl warns against BUG_ON() but there seems to be no simple
way to enforce these relationships.

/*
  * Note: if BUG_ON() fires it usually indicates a problem with the parser
  * tables. Perhaps a missing F_FAKE_RW or FF_MEDIA_IO flag. Response functions
  * that access any of the "stores" in struct sdeb_store_info should call this
  * function with bug_if_fake_rw set to true.
  */
static inline struct sdeb_store_info *devip2sip(struct sdebug_dev_info *devip,
                                                 bool bug_if_fake_rw)
{
         if (sdebug_fake_rw) {
                 BUG_ON(bug_if_fake_rw); /* See note above */
                 return NULL;
         }
         return xa_load(per_store_ap, devip->sdbg_host->si_idx);
}


Doug Gilbert


> drivers/scsi/scsi_debug.c
>    3688  static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
>    3689                             u32 ei_lba, bool unmap, bool ndob)
>    3690  {
>    3691          struct scsi_device *sdp = scp->device;
>    3692          struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
>    3693          unsigned long long i;
>    3694          u64 block, lbaa;
>    3695          u32 lb_size = sdebug_sector_size;
>    3696          int ret;
>    3697          struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
>    3698                                                  scp->device->hostdata);
>    3699          rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
>                            ^^^^^^^^^
> If "sip" is non-NULL we use that lock.
> 
>    3700          u8 *fs1p;
>    3701          u8 *fsp;
>    3702
>    3703          write_lock(macc_lckp);
>    3704
>    3705          ret = check_device_access_params(scp, lba, num, true);
>    3706          if (ret) {
>    3707                  write_unlock(macc_lckp);
>    3708                  return ret;
>    3709          }
>    3710
>    3711          if (unmap && scsi_debug_lbp()) {
>    3712                  unmap_region(sip, lba, num);
> 
> How do we know "sip" is non-NULL?
> 
>    3713                  goto out;
>    3714          }
>    3715          lbaa = lba;
>    3716          block = do_div(lbaa, sdebug_store_sectors);
>    3717          /* if ndob then zero 1 logical block, else fetch 1 logical block */
>    3718          fsp = sip->storep;
>                        ^^^^^^^^^^^
> Same.
> 
>    3719          fs1p = fsp + (block * lb_size);
>    3720          if (ndob) {
>    3721                  memset(fs1p, 0, lb_size);
>    3722                  ret = 0;
>    3723          } else
>    3724                  ret = fetch_to_dev_buffer(scp, fs1p, lb_size);
>    3725
>    3726          if (-1 == ret) {
>    3727                  write_unlock(&sip->macc_lck);
> 
> If we know that "sip" is non-NULL then this is fine, but it is probably
> less confusing to use write_unlock(macc_lckp); consistently everywhere.
> 
>    3728                  return DID_ERROR << 16;
>    3729          } else if (sdebug_verbose && !ndob && (ret < lb_size))
>    3730                  sdev_printk(KERN_INFO, scp->device,
>    3731                              "%s: %s: lb size=%u, IO sent=%d bytes\n",
>    3732                              my_name, "write same", lb_size, ret);
> 
> regards,
> dan carpenter
> 

