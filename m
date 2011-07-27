From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: linux-next: Tree for July 27 (iscsi_target) [resend/lost]
Date: Wed, 27 Jul 2011 13:11:07 -0700
Message-ID: <1311797467.6931.20.camel@haakon2.linux-iscsi.org>
References: <20110727141151.d31e3da6a8d21a255473293c@canb.auug.org.au>
	 <20110727104716.dda819dc.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34117 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1G0UU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2011 16:20:27 -0400
In-Reply-To: <20110727104716.dda819dc.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, target-devel@vger.kernel.org

On Wed, 2011-07-27 at 10:47 -0700, Randy Dunlap wrote:
> On Wed, 27 Jul 2011 14:11:51 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> 
> iscsi_target_login.c:(.text+0x13d3f5): undefined reference to `iscsit_thread_get_cpumask'
> iscsi_target_login.c:(.text+0x13d594): undefined reference to `iscsit_thread_get_cpumask'
> 
> kernel config file is attached.
> 
> 

Hi Randy,

Addressing this config with the following patch:

commit b7123c56c95dcf3cc5fbdfeaceb416699d378e08
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Wed Jul 27 20:13:22 2011 +0000

    iscsi-target: Fix CONFIG_SMP=n and CONFIG_MODULES=n build failure
    
    This patch fixes the following CONFIG_SMP=n and CONFIG_MODULES=n build
    failure, because iscsit_thread_get_cpumask() is defined as a macro in
    iscsi_target.c, but needed by iscsi_target_login.c
    
    drivers/built-in.o: In function `iscsi_post_login_handler':
    iscsi_target_login.c:(.text+0x13a315): undefined reference to `iscsit_thread_get_cpumask'
    iscsi_target_login.c:(.text+0x13a4b4): undefined reference to `iscsit_thread_get_cpumask'
    make: *** [.tmp_vmlinux1] Error 1
    
    Reported-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 5ae3017..8f92d0d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3468,7 +3468,12 @@ static inline void iscsit_thread_check_cpumask(
 }
 
 #else
-#define iscsit_thread_get_cpumask(X) ({})
+
+void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
+{
+       return;
+}
+
 #define iscsit_thread_check_cpumask(X, Y, Z) ({})
 #endif /* CONFIG_SMP */
 

> Shouldn't MAINTAINERS list target-devel@vger.kernel.org ?
> 

Adding this as well now..

Thanks!

--nab

