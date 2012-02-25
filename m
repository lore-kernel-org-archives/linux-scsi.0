From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: Fix memory leak if iscsit_alloc_buffs()
 fails
Date: Sat, 25 Feb 2012 13:28:00 -0800
Message-ID: <1330205280.4528.200.camel@haakon2.linux-iscsi.org>
References: <1330046923-4034-1-git-send-email-roland@kernel.org>
	 <1330132633.4528.148.camel@haakon2.linux-iscsi.org>
	 <CAL1RGDU7ZJ2hRh1tnpofMQcP5LD=y2qhoL0TPGNmB-4OSVLOUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDU7ZJ2hRh1tnpofMQcP5LD=y2qhoL0TPGNmB-4OSVLOUw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-02-24 at 21:19 -0800, Roland Dreier wrote:
> On Fri, Feb 24, 2012 at 5:17 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > This looks like a double free here on the second failure of
> > iscsit_allocate_iovecs().  Fixing this up now to drop the extra bogus
> > kfree(cmd->t_mem_sg) here..
> 
> I don't see how the patch you committed:
> 
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -830,7 +830,7 @@ page_alloc_failed:
>                 __free_page(sg_page(&sgl[i]));
>                 i--;
>         }
> -       kfree(cmd->t_mem_sg);
> +       kfree(sgl);
>         cmd->t_mem_sg = NULL;
>         return -ENOMEM;
>  }
> 
> could possibly be right... you drop the kfree() of cmd->t_mem_sg but leave
> in the "cmd->t_mem_sg = NULL".  Isn't that a guaranteed leak of cmd->t_mem_sg?
> 

It's the same memory that's being allocated in iscsit_alloc_buffs(), but
you're right that this is bogus for the iscsit_allocate_iovecs() failure
case.

> I think the old code was probably OK (although I get lost a bit in the
> twisty maze of what exactly happens to the cmd on this failure path), and
> maybe the new code would be OK if you got rid of the "cmd->t_mem_sg = NULL".
> 

After testing with simulated alloc_page() + iscsit_allocate_iovecs()
failures in iscsit_alloc_buffs(), the old code was in fact doing the
wrong thing.

Here is the incremental patch that I'm pushing for lio-core, and will
get this fixed up in for-next shortly.

Thanks,

--nab

commit 742c0d2e4436c7bc3c62c07dd838c7f52b3ccdcf
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Sat Feb 25 12:18:48 2012 -0800

    iscsi-target: Fix iscsit_alloc_buffs() failure cases
    
    Make iscsit_alloc_buffs() failure case for page_alloc_failed use correct
    __free_page() SGL pointer, and return -ENOMEM for iscsit_allocate_iovecs
    failure to push se_cmd->t_mem_sg release into iscsit_release_cmd()
    callback during iscsit_add_reject_from_cmd() connection reset.
    
    Also drop cmd->t_mem_sg = NULL assignment from page_alloc_failed
    failure case.
    
    Cc: Roland Dreier <roland@purestorage.com>
    Cc: Andy Grover <agrover@redhat.com>
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 3e18efd..eb25737 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -780,7 +780,7 @@ static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
        struct scatterlist *sgl;
        u32 length = cmd->se_cmd.data_length;
        int nents = DIV_ROUND_UP(length, PAGE_SIZE);
-       int i = 0, ret;
+       int i = 0, j = 0, ret;
        /*
         * If no SCSI payload is present, allocate the default iovecs used for
         * iSCSI PDU Header
@@ -821,17 +821,15 @@ static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
         */
         ret = iscsit_allocate_iovecs(cmd);
         if (ret < 0)
-               goto page_alloc_failed;
+               return -ENOMEM;
 
        return 0;
 
 page_alloc_failed:
-       while (i >= 0) {
-               __free_page(sg_page(&sgl[i]));
-               i--;
-       }
+       while (j < i)
+               __free_page(sg_page(&sgl[j++]));
+
        kfree(sgl);
-       cmd->t_mem_sg = NULL;
        return -ENOMEM;
 }
