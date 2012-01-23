From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: linux-next: build failure after merge of the nfs tree
Date: Mon, 23 Jan 2012 13:13:09 -0500
Message-ID: <1327342389.2628.6.camel@lade.trondhjem.org>
References: <20120123113949.b8d1940bb60128c5c4efeece@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20120123113949.b8d1940bb60128c5c4efeece@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-01-23 at 11:39 +1100, Stephen Rothwell wrote: 
> Hi Trond,
> 
> After merging the nfs tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/target/iscsi/iscsi_target_configfs.c: In function 'lio_target_call_addnptotpg':
> drivers/target/iscsi/iscsi_target_configfs.c:214:3: error: implicit declaration of function 'in6_pton' [-Werror=implicit-function-declaration]
> drivers/target/iscsi/iscsi_target_configfs.c:239:3: error: implicit declaration of function 'in_aton' [-Werror=implicit-function-declaration]
> 
> Presumably caused by some include file cleanup in the nfs tree (probably
> commit 0b5357cfc2e6 "NFS: Remove unnecessary includes from
> linux/nfs_fs_i.h").
> 
> I applied the following patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 23 Jan 2012 11:35:02 +1100
> Subject: [PATCH] iscsi: in_aton needs linux/inet.h
> 
> so include it directly.
> 
> Fixes this error after a recent nfs cleanup:
> 
> drivers/target/iscsi/iscsi_target_configfs.c: In function 'lio_target_call_addnptotpg':
> drivers/target/iscsi/iscsi_target_configfs.c:214:3: error: implicit declaration of function 'in6_pton' [-Werror=implicit-function-declaration]
> drivers/target/iscsi/iscsi_target_configfs.c:239:3: error: implicit declaration of function 'in_aton' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/target/iscsi/iscsi_target_configfs.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
> index 3468caa..6b35b37 100644
> --- a/drivers/target/iscsi/iscsi_target_configfs.c
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> @@ -21,6 +21,7 @@
>  
>  #include <linux/configfs.h>
>  #include <linux/export.h>
> +#include <linux/inet.h>
>  #include <target/target_core_base.h>
>  #include <target/target_core_fabric.h>
>  #include <target/target_core_fabric_configfs.h>

Hi Stephen,

Yep. I believe that is identical to the patch Bryan sent to James
Bottomley a few days ago. Could you please carry the above in your tree
until the iscsi folks get around to fixing this?

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
