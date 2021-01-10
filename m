Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB5BC433E9
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 16:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98CC022AAD
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 16:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbhAJQOm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 11:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbhAJQOl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2021 11:14:41 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C317C061794;
        Sun, 10 Jan 2021 08:14:01 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ga15so21307487ejb.4;
        Sun, 10 Jan 2021 08:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hUIw/nQqKpmlB0LX7fZYjedVZ73tS4UDQsHeVsWivWU=;
        b=qA5T/4+s55rBE7aykCobTB5b7Ej1gNd0JL9rkT0EkZs7mpB6L8GHP8b984yE721KYx
         lwoRxWysBjc901LC4hC44sw7m2W0TzbzeOYPT2SNeCrCDYs4XAf/TbZyGqs1uy8Snk6f
         kXnCM3BK5Op2vO21qq1tAXzo5wgjkldrPFjQ/BUudUNh3c+PKwo03eJmFgvPEQL8YYMs
         pHzTlG0414PfpwTFrTZknwM3cpunaIvu122fxCp9b5YpUSg4ZiawCWRQFDsEJP0r2h2S
         KIaEgkMo7O+rETOw6aKsm9/ZQp1I7z/eJn1DJTqolFXR6O5PItJoN/hOIMxGn+ImAc2j
         VyWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hUIw/nQqKpmlB0LX7fZYjedVZ73tS4UDQsHeVsWivWU=;
        b=jCFUGxMelHAxS6Gf1RjbxJNua0U9OpVxpva9grUX7evlUqn614RgMuVfT07Ee+OHuy
         4BXunF6R2NpnbAE/pqrK61+fXsTbbh0YTkX5kmMEDZFRwPNYLATVc+xeMALxwrmU6Oc6
         vSAvSLI424wLtLXBqlV/JahOShsp1BRnMjWTNePvid1Zw0ZCtOb5FyBCGWs6T0AIX1L6
         rUki87H0enPlI5yYYpEh+/GMrw4eyfpQYYUb1iaQG0RH8sAjrBx9W8HTstDqgmkHF1sA
         RAxHP8wsZxINWRGZehLwe6/AlQbj9aYaE4NWMeq1T1O3o3b5x1QjapcFQMYj0z0CI4pJ
         IsFQ==
X-Gm-Message-State: AOAM532UfBMJimrpEX+5s5o+rc2sucUpnsiNbJk1e0C8kXp28X+C6jQb
        X4fnK1Sq7eyf+fASZa5yNQk=
X-Google-Smtp-Source: ABdhPJyrHP+u3Fhe0Clym/KALuark5kdYq9bAHr7c7nUYJ0LUmaDRC0T5Ss9gB22b7pH77dNVeIeDg==
X-Received: by 2002:a17:906:3ac8:: with SMTP id z8mr8295904ejd.273.1610295239874;
        Sun, 10 Jan 2021 08:13:59 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id l1sm5900091eje.12.2021.01.10.08.13.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 10 Jan 2021 08:13:59 -0800 (PST)
Message-ID: <146b46a5c38f4582a9a8e6df1d87cdfc0684f549.camel@gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        rjw@rjwysocki.net, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Sun, 10 Jan 2021 17:13:57 +0100
In-Reply-To: <606774efd4d89f0ea78cefeb428cc9e1@codeaurora.org>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
         <1609595975-12219-3-git-send-email-cang@codeaurora.org>
         <80a15afab8024d0b61d312b57585c9322ac91958.camel@gmail.com>
         <7d49c1dfc3f648c484076f3c3a7f4e1e@codeaurora.org>
         <1514403adf486ac8069253c09f45b021bad32e00.camel@gmail.com>
         <f814b71d1d4ea87a72df4851a8190807@codeaurora.org>
         <cb388d8ea15b2c80a072dec74d9ededecb183a08.camel@gmail.com>
         <e69bd5a6b73d5c652130bf4fa077aac0@codeaurora.org>
         <606774efd4d89f0ea78cefeb428cc9e1@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2021-01-09 at 12:51 +0800, Can Guo wrote:
> On 2021-01-09 12:45, Can Guo wrote:
> > On 2021-01-08 19:29, Bean Huo wrote:
> > > On Wed, 2021-01-06 at 09:20 +0800, Can Guo wrote:
> > > > Hi Bean,
> > > > 
> > > > On 2021-01-06 02:38, Bean Huo wrote:
> > > > > On Tue, 2021-01-05 at 09:07 +0800, Can Guo wrote:
> > > > > > On 2021-01-05 04:05, Bean Huo wrote:
> > > > > > > On Sat, 2021-01-02 at 05:59 -0800, Can Guo wrote:
> > > > > > > > + * @shutting_down: flag to check if shutdown has been
> > > > > > > > invoked
> > > > > > > 
> > > > > > > I am not much sure if this flag is need, since once PM
> > > > > > > going in
> > > > > > > shutdown path, what will be returnded by
> > > > > > > pm_runtime_get_sync()?
> > > > > > > 
> > > > > > > If pm_runtime_get_sync() will fail, just check its
> > > > > > > return.
> > > > > > > 
> > > > > > 
> > > > > > That depends. During/after shutdown, for UFS's case only,
> > > > > > pm_runtime_get_sync(hba->dev) will most likely return 0,
> > > > > > because it is already RUNTIME_ACTIVE, pm_runtime_get_sync()
> > > > > > will directly return 0... meaning you cannot count on it.
> > > > > > 
> > > > > > Check Stanley's change -
> > > > > > https://lore.kernel.org/patchwork/patch/1341389/
> > > > > > 
> > > > > > Can Guo.
> > > > > 
> > > > > Can,
> > > > > 
> > > > > Thanks for pointing out that.
> > > > > 
> > > > > Based on my understanding, that patch is redundent. maybe I
> > > > > misundestood Linux shutdown sequence.
> > > > 
> > > > Sorry, do you mean Stanley's change is redundant?
> > > 
> > > yes.
> > > 
> > 
> > No, it is definitely needed. As Stanley replied you in another
> > thread, it is not protecting I/Os from user layer, but from
> > other subsystems during shutdown.
> > 
> > > > 
> > > > > 
> > > > > I checked the shutdown flow:
> > > > > 
> > > > > 1. Set the "system_state" variable
> > > > > 2. Disable usermod to ensure that no user from userspace can
> > > > > start
> > > > > a
> > > > > request
> > > > 
> > > > I hope it is like what you interpreted, but step #2 only stops
> > > > UMH(#265)
> > > > but not all user space activities. Whereas, UMH is for kernel
> > > > space
> > > > calling
> > > > user space.
> > > 
> > > 
> > > Can,
> > > 
> > > I did further study and homework on the Linux shutdown in the
> > > last few
> > > days. Yes, you are right, usermodehelper_disable() is to prevent
> > > executing the process from the kernel space.
> > > 
> > > But I didn't reproduce this "maybe" race issue while shutdown. no
> > > matter how I torment my system, once Linux shutdown/halt/reboot 
> > > starts,
> > > nobody can access the sysfs node. I create 10 processes in the
> > > user
> > > space and constantly access UFS sysfs node, also, fio is running
> > > in 
> > > the
> > > background for the normal data read/write. there is a shutdown
> > > thread
> > > that will randomly trigger shutdown/halt/reboot. but no race
> > > issue
> > > appears.
> > > 
> > > I don't know if this is a hypothetical issue(the race between
> > > shutdown
> > > flow and sysfs node access), it may not really exist in the Linux
> > > envriroment. everytime, the shutdonw flow will be:
> > > 
> > > e10_sync_handler()->e10_svc()->do_e10_svc()->__do_sys_reboot()-
> > > > kernel_poweroff/kernel_halt()->device_shutdown()-
> > > > >platform_shutdown()-
> > > > ufshcd_platform_shutdown()->ufshcd_shutdown().
> > > 
> > > I think before going into the kernel shutdown, the userspace
> > > cannot
> > > issue new requests anymore. otherwise, this would be a big issue.
> > > 
> > > pm_runtime_get_sync() will return 0 or failure while shutdown?
> > > the
> > > answer is not important now, maybe as you said, it is always 0.
> > > But in
> > > my testing, it didn't get there the system has been shutdown.
> > > Which
> > > means once shutdonw starts, sysfs node access path cannot reach
> > > pm_runtime_get_sync(). (note, I don't know if sysfs node access
> > > thread
> > > has been disabled or not)
> > > 
> > > 
> > > Responsibly say, I didn't reproduce this issue on my system
> > > (ubuntu),
> > > maybe you are using Android. I am not an expert on this topic, if
> > > you
> > > have the best idea on how to reproduce this issue. please please
> > > let 
> > > me
> > > try. appreciate it!!!!!
> > > 
> > 
> > When you do a reboot/shutdown/poweroff, how your system behaves
> > highly
> > depends on how the reboot cmd is implemented in C code under
> > /sbin/.
> > 
> > On Ubuntu, reboot looks like:
> > $ reboot --help
> > reboot [OPTIONS...] [ARG]
> > 
> > Reboot the system.
> > 
> >       --help      Show this help
> >       --halt      Halt the machine
> >    -p --poweroff  Switch off the machine
> >       --reboot    Reboot the machine
> >    -f --force     Force immediate halt/power-off/reboot
> >    -w --wtmp-only Don't halt/power-off/reboot, just write wtmp
> > record
> >    -d --no-wtmp   Don't write wtmp record
> >       --no-wall   Don't send wall message before halt/power-
> > off/reboot
> > 
> > 
> > On a pure Linux with a initrd RAM FS built from busybox, reboot
> > looks 
> > like:
> > # reboot --help
> > BusyBox v1.30.1 (2019-05-24 12:53:36 IST) multi-call binary.
> > 
> > Usage: reboot [-d DELAY] [-n] [-f]
> > 
> > Reboot the system
> > 
> >          -d SEC  Delay interval
> >          -n      Do not sync
> >          -f      Force (don't go through init)
> > 
> > 
> > For example, when you work on a pure Linux with a filesystem built
> > from
> > busybox, when you hit reboot cmd, halt_main() will be called. And
> > based
> > on the reboot options passed to reboot cmd, halt_main() behaves 
> > differently.
> > 
> > A plain reboot cmd does things like sync filesystem, send SIGKILL
> > to 
> > all
> > processes (except for init), remount all filesytem as read-only and
> > so 
> > on
> > before invoking linux kernel reboot syscall. In this case, we are
> > safe.
> > 
> > However, if you do a "reboot -f", halt_main() directly invokes 
> > reboot().
> > And with "reboot -f", I can easily reproduce the race condition we
> > are
> > talking about here - it is not based on imagination.
> > 
> > Find the patch I used for replication in the attachment, fix
> > conflicts
> > if any. After boot up, the cmd lines I used are
> > 
> > # while true; do cat /sys/devices/platform/soc@0/*ufshc*/rpm_lvl;
> > done 
> > &
> > # reboot -f
> > 
> > Can Guo.
> 
> Oops... forgot the logs:
> 
> #
> # while true; do cat /sys/devices/platform/soc@0/*ufshc*/rpm_lvl;
> done &
> 3
> 3
> 3
> 3
> ....
> # reboot -f
> 3
> 3
> 3
> ....
> [   17.959206] sd 0:0:0:5: [sdf] Synchronizing SCSI cache
> 3
> [   17.964833] sd 0:0:0:4: [sde] Synchronizing SCSI cache
> [   17.970224] sd 0:0:0:3: [sdd] Synchronizing SCSI cache
> [   17.975574] sd 0:0:0:2: [sdc] Synchronizing SCSI cache
> 3
> [   17.981034] sd 0:0:0:1: [sdb] Synchronizing SCSI cache
> [   17.986493] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> 3
> [   17.991870] [DEBUG]ufshcd_shutdown: UFS SHUTDOWN START
> [   17.998902] ------------[ cut here ]------------
> [   18.003648] kernel BUG at drivers/scsi/ufs/ufs-sysfs.c:62!
> [   18.009286] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> [   18.034249] pstate: 40c00005 (nZcv daif +PAN +UAO)
> [   18.039185] pc : rpm_lvl_show+0x38/0x40
> [   18.043137] lr : dev_attr_show+0x1c/0x58
> [   18.132552] Call trace:
> [   18.135076]  rpm_lvl_show+0x38/0x40
> [   18.138672]  sysfs_kf_seq_show+0xa8/0x140
> [   18.142802]  kernfs_seq_show+0x28/0x30
> [   18.146665]  seq_read+0x1d8/0x4b0
> [   18.150072]  kernfs_fop_read+0x12c/0x1f0
> [   18.154109]  do_iter_read+0x184/0x1c0
> [   18.157882]  vfs_readv+0x68/0xb0
> ....

Hi Can
Please forgive me for being verbose. 

The above BUG log is from your BUG_ON() called, not becuase of the race
betwen shutdown flow and sysfs node access(if I misunderstood, correct
me). But it tells that the user can still access UFS by sysfs node in
the "reboot -f" flow since it skips the actual shutdown process, "
--force" is not a safe way anyway.


If accessing sysfs nodes, which triggers a UFS UPIU request to
read/write UFS device descriptors during shutdown flow, there is only 
one issue that sysfs node access failure since UFS device and LINK has
been shutdown. Strictly speaking, the failure comes after
ufshcd_set_dev_pwr_mode().

   __ufshcd_query_descriptor: opcode 0x01 for idn 0 failed, index 0,
err = -11

Since the shutdown is oneway process, this failure is not big issue. If
you meant to avoid this failure for unsafe shutdown, I agree with you,
But for the race issue, I don't know.

Bean











