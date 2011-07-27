From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [smatch stuff] iscsi-target: string size issue in
	lio_target_call_addnptotpg()
Date: Wed, 27 Jul 2011 12:40:46 -0700
Message-ID: <1311795646.6931.14.camel@haakon2.linux-iscsi.org>
References: <20110727113450.GA7382@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39742 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab1G0TuH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2011 15:50:07 -0400
In-Reply-To: <20110727113450.GA7382@shale.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On Wed, 2011-07-27 at 14:34 +0300, Dan Carpenter wrote:
> Smatch complains about the string handling in lio_target_call_addnptotpg().
> 
> drivers/target/iscsi/iscsi_target_configfs.c +184 lio_target_call_addnptotpg(21)
> 	error: snprintf() chops off the last chars of 'name': 257 vs 256
> 
>    176          char buf[MAX_PORTAL_LEN + 1];
> 
> 	buffer holds 257 chars.
> 
>    177  
>    178          if (strlen(name) > MAX_PORTAL_LEN) {
> 
> 	string is 256 chars plus NUL.  (257 chars).
> 
>    179                  pr_err("strlen(name): %d exceeds MAX_PORTAL_LEN: %d\n",
>    180                          (int)strlen(name), MAX_PORTAL_LEN);
>    181                  return ERR_PTR(-EOVERFLOW);
>    182          }
>    183          memset(buf, 0, MAX_PORTAL_LEN + 1);
> 
> 	set 257 chars to NULL.
> 
>    184          snprintf(buf, MAX_PORTAL_LEN, "%s", name);
> 
> 	Copy 255 chars and write a NUL char to the second last char
> 	in the buffer.  The last char is also NUL.
> 

Addressing this smatch warning with the following patch:

Thanks Dan!

--nab

---------------------------------------------------------------
commit 92819a50ea5d36692aef38e5eb99d72f27e66832
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Wed Jul 27 12:37:03 2011 -0700

    iscsi-target: Fix snprintf usage with MAX_PORTAL_LEN
    
    This patch makes lio_target_call_addnptotpg() use sprintf() with
    MAX_PORTAL_LEN + 1 to address the following smatch warning:
    
    drivers/target/iscsi/iscsi_target_configfs.c +184 lio_target_call_addnptotpg(21)
            error: snprintf() chops off the last chars of 'name': 257 vs 256
    
    Reported-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 5599747..1466c93 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -181,7 +181,7 @@ struct se_tpg_np *lio_target_call_addnptotpg(
                return ERR_PTR(-EOVERFLOW);
        }
        memset(buf, 0, MAX_PORTAL_LEN + 1);
-       snprintf(buf, MAX_PORTAL_LEN, "%s", name);
+       snprintf(buf, MAX_PORTAL_LEN + 1, "%s", name);
 
        memset(&sockaddr, 0, sizeof(struct __kernel_sockaddr_storage));
 


