From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 13/13] target: Change target_submit_cmd() to return void
Date: Fri, 20 Jan 2012 19:27:00 -0800
Message-ID: <1327116420.16983.444.camel@haakon2.linux-iscsi.org>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
	 <1327009163-10177-14-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1327009163-10177-14-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, kiran.patil@intel.com, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-01-19 at 13:39 -0800, Andy Grover wrote:
> Retval not very useful, and may even be harmful. Once submitted, fabrics
> should expect a sense error if anything goes wrong. All fabrics checking
> of this retval are useless or broken:
> 
> fc checks it just to emit more debug output.
> ib_srpt trickles retval up, then it is ignored.
> qla2xxx trickles it up, which then causes a bug because the abort goto
> in qla_target.c thinks cmd hasn't been sent to target.
> 
> Just returning nothing is best.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c  |    5 +----
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    7 ++-----
>  drivers/target/target_core_transport.c |    5 ++---
>  drivers/target/tcm_fc/tfc_cmd.c        |    9 ++-------
>  include/target/target_core_fabric.h    |    2 +-
>  5 files changed, 8 insertions(+), 20 deletions(-)
> 

Just a heads-up for Sebastian..

I've merged Andy's patch with the following change to usb-gadget to also
ignore the return from target_submit_cmd() and let target-core invoke
the proper response callbacks, et al with the recently posted kref_put
leak bugfix..

AFAICT this should work as expected with usb-gadget, but please let me
know if you run into problems.  ;)

Thanks,

--nab

diff --git a/drivers/target/usb-gadget/fabric.c b/drivers/target/usb-gadget/fabric.c
index f56319a..7f432c2 100644
--- a/drivers/target/usb-gadget/fabric.c
+++ b/drivers/target/usb-gadget/fabric.c
@@ -181,7 +181,6 @@ static void usbg_cmd_work(struct work_struct *work)
        struct se_cmd *se_cmd;
        struct tcm_usbg_nexus *tv_nexus;
        struct usbg_tpg *tpg;
-       int ret;
        int dir;
 
        se_cmd = &cmd->se_cmd;
@@ -199,11 +198,9 @@ static void usbg_cmd_work(struct work_struct *work)
                return;
        }
 
-       ret = target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
+       target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
                        cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
                        0, cmd->prio_attr, dir, TARGET_SCF_UNKNOWN_SIZE);
-       if (ret)
-               kref_put(&cmd->ref, usbg_cmd_release);
 }
 
 int usbg_submit_command(struct f_uas *fu,
