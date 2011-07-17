From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 09/20] target: Remove custom debug macros in non-iscsi
	fabrics
Date: Sun, 17 Jul 2011 13:02:45 -0700
Message-ID: <1310932965.26130.39.camel@haakon2.linux-iscsi.org>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
	 <1310174329-22228-10-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46084 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab1GQUL5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jul 2011 16:11:57 -0400
In-Reply-To: <1310174329-22228-10-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2011-07-08 at 18:18 -0700, Andy Grover wrote:
> pr_debug and dynamic debug messages are cool, we don't need specialized
> debug infrastructure.
> 
> Use pr_err etc. instead of printk(KERN_ERR...).
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/loopback/Kconfig                   |    6 -
>  drivers/target/loopback/tcm_loop.c                |   94 +++++-----
>  drivers/target/loopback/tcm_loop.h                |    6 -
>  drivers/target/tcm_fc/tcm_fc.h                    |   24 ---
>  drivers/target/tcm_fc/tfc_cmd.c                   |   37 ++---
>  drivers/target/tcm_fc/tfc_conf.c                  |   33 ++--
>  drivers/target/tcm_fc/tfc_io.c                    |   22 ++--
>  drivers/target/tcm_fc/tfc_sess.c                  |   18 +-
>  drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h     |    6 -
>  drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c |  190 ++++++++++----------
>  drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c   |   20 +-
>  drivers/target/tcm_vhost/tcm_vhost_configfs.c     |   50 +++---
>  drivers/target/tcm_vhost/tcm_vhost_fabric.c       |   10 +-
>  drivers/target/tcm_vhost/tcm_vhost_scsi.c         |    8 +-
>  14 files changed, 239 insertions(+), 285 deletions(-)
> 

Great stuff, however with the amount of I/O path code that was removed
in:

    commit 0b5660d2eebadc5853cf268d6136aeecbd251d6a
    Author: Andy Grover <agrover@redhat.com>
    Date:   Fri Jul 8 17:25:13 2011 -0700
    
        target: Make all control CDBs scatter-gather

and:

    commit 84b6dd77a6035dff105f628589b8aac8a227031e
    Author: Andy Grover <agrover@redhat.com>
    Date:   Fri Jul 8 15:22:14 2011 -0700
    
        target: Eliminate usage of struct se_mem
    
really made things difficult to debug the bigger issue with this
series..

So that said, some new pr_debug() messages for the I/O path would be
really helpful..  ;)

--nab


