From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: avoid false-positive gcc-8 warning
Date: Wed, 23 Aug 2017 09:20:52 -0700
Message-ID: <82a428c6-a1d9-00e9-8a6c-fb8f2a84828f@broadcom.com>
References: <20170823150143.2746796-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170823150143.2746796-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 8/23/2017 8:01 AM, Arnd Bergmann wrote:
> This is an interesting regression with gcc-8, showing a harmless
> warning for correct code:
>
> In file included from include/linux/kernel.h:13:0,
>                   ...
>                   from drivers/scsi/lpfc/lpfc_debugfs.c:23:
> include/linux/printk.h:301:2: error: 'eq' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>    printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>    ^~~~~~
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
> ---
>   drivers/scsi/lpfc/lpfc_debugfs.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
>
looks good. Thanks

Signed-off-by: James Smart <james.smart@broadcom.com>

-- james
