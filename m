From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/3] target/iscsi networkportal race fixes
Date: Tue, 28 Jan 2014 11:15:35 -0800
Message-ID: <1390936535.20018.3.camel@haakon3.risingtidesystems.com>
References: <1390609136-28674-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33155 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaA1TNY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jan 2014 14:13:24 -0500
In-Reply-To: <1390609136-28674-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Andy,

On Fri, 2014-01-24 at 16:18 -0800, Andy Grover wrote:
> see https://bugzilla.redhat.com/show_bug.cgi?id=1055064
> 
> Summary: if thread doesn't run before 2nd identical portal is created,
> it misses the existing one and the kernel_bind returns an error.
> 
> The first one-line patch fixes the issue for a single thread creating
> multiple network portals via configfs.
> 
> The second two close the race between multiple threads creating
> network portals.
> 
> Testing: failing test script now works.
> 

Applied, squashed into a single bugfix patch, and adding a CC'ed to
stable.

FYI, on patch #3, there where a few exception path mutex_unlocks
missing, so the following incremental has been applied + squashed as
well.

Thanks,

--nab

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 13868ff..1ab9b18 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -365,6 +365,7 @@ struct iscsi_np *iscsit_add_np(
        np = kzalloc(sizeof(struct iscsi_np), GFP_KERNEL);
        if (!np) {
                pr_err("Unable to allocate memory for struct iscsi_np\n");
+               mutex_unlock(&np_lock);
                return ERR_PTR(-ENOMEM);
        }
 
@@ -387,6 +388,7 @@ struct iscsi_np *iscsit_add_np(
        ret = iscsi_target_setup_login_socket(np, sockaddr);
        if (ret != 0) {
                kfree(np);
+               mutex_unlock(&np_lock);
                return ERR_PTR(ret);
        }
 
@@ -395,6 +397,7 @@ struct iscsi_np *iscsit_add_np(
                pr_err("Unable to create kthread: iscsi_np\n");
                ret = PTR_ERR(np->np_thread);
                kfree(np);
+               mutex_unlock(&np_lock);
                return ERR_PTR(ret);
        }
        /*


