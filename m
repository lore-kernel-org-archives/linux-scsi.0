From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: lpfc: avoid false-positive gcc-8 warning
Date: Wed, 23 Aug 2017 21:02:39 +0200
Message-ID: <CAK8P3a0ztyGg6Lt8pWk530zFjhTFP3EAQpmswESkjk=HPZTwKw@mail.gmail.com>
References: <20170823150143.2746796-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36813 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932458AbdHWTCl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 15:02:41 -0400
In-Reply-To: <20170823150143.2746796-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Wed, Aug 23, 2017 at 5:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> This is an interesting regression with gcc-8, showing a harmless
> warning for correct code:
>
> In file included from include/linux/kernel.h:13:0,
>                  ...
>                  from drivers/scsi/lpfc/lpfc_debugfs.c:23:
> include/linux/printk.h:301:2: error: 'eq' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>   printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>   ^~~~~~
> In file included from drivers/scsi/lpfc/lpfc_debugfs.c:58:0:
> drivers/scsi/lpfc/lpfc_debugfs.h:451:31: note: 'eq' was declared here
>
> I tried to come up with a reduced test case for gcc here
> a few times, but every time ended up with code that is actually
> wrong with older gcc versions missing the bug and gcc-8 finding
> it. As this is the only false-positive -Wmaybe-uninitialized
> warnign I got with gcc-8 randconfig builds, I'd suggest we
> work around it.
>
> Making the index variable 'unsigned' is enough to shut up
> the warning, as gcc can then see that comparing eqidx to
> phba->io_channel_irqs is fine here.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Sorry, I have to retract my patch. While it apparently solved the problem
for most randconfig builds, I have now run into another case that it did
not address, and I still get the warning for one caller:

In file included from /git/arm-soc/include/linux/kernel.h:13:0,
                 from /git/arm-soc/arch/x86/include/asm/percpu.h:44,
                 from /git/arm-soc/arch/x86/include/asm/current.h:5,
                 from /git/arm-soc/include/linux/sched.h:11,
                 from /git/arm-soc/include/linux/blkdev.h:4,
                 from /git/arm-soc/drivers/scsi/lpfc/lpfc_debugfs.c:23:
/git/arm-soc/drivers/scsi/lpfc/lpfc_debugfs.c: In function
'lpfc_debug_dump_all_queues':
/git/arm-soc/include/linux/printk.h:301:2: error: 'eq' may be used
uninitialized in this function [-Werror=maybe-uninitialized]
  printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
  ^~~~~~
In file included from /git/arm-soc/drivers/scsi/lpfc/lpfc_debugfs.c:58:0:
/git/arm-soc/drivers/scsi/lpfc/lpfc_debugfs.h:451:31: note: 'eq' was
declared here
  struct lpfc_queue *wq, *cq, *eq;
                               ^~
In file included from /git/arm-soc/include/linux/kernel.h:13:0,
                 from /git/arm-soc/arch/x86/include/asm/percpu.h:44,
                 from /git/arm-soc/arch/x86/include/asm/current.h:5,
                 from /git/arm-soc/include/linux/sched.h:11,
                 from /git/arm-soc/include/linux/blkdev.h:4,
                 from /git/arm-soc/drivers/scsi/lpfc/lpfc_debugfs.c:23:
/git/arm-soc/include/linux/printk.h:301:2: error: 'eq' may be used
uninitialized in this function [-Werror=maybe-uninitialized]
  printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
  ^~~~~~
In file included from /git/arm-soc/drivers/scsi/lpfc/lpfc_debugfs.c:58:0:
/git/arm-soc/drivers/scsi/lpfc/lpfc_debugfs.h:451:31: note: 'eq' was
declared here
  struct lpfc_queue *wq, *cq, *eq;
                               ^~
cc1: all warnings being treated as errors

     Arnd
