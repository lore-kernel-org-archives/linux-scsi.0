From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: ib_srpt status
Date: Wed, 19 Oct 2011 18:59:46 +0200
Message-ID: <CAO+b5-oxcWM+Sh4t00SxPqbaNGj7uCJK8xgsoRaOxp-6Ac5EmQ@mail.gmail.com>
References: <20111012092318.GA9405@lst.de> <CAO+b5-rqc7Dq-7p1XRHrxVMP9JS5N26Ht1q8ee=KGRqpUintFQ@mail.gmail.com>
 <1318956075.2454.10.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318956075.2454.10.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 18, 2011 at 6:41 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> I'm having no problems with the patch posted for v3.2 review on MT264=
28
> HCAs
>
> Can you verify you are actually using this patch, and not your privat=
e
> tree from github..? =A0The reason is that your tree did not contain t=
he
> bugfix below to ib_srpt code that was originally causing problems:
>
> ib_srpt: Fix bug with chainged SGLs in srpt_map_sg_to_ib_sge
> http://www.risingtidesystems.com/git/?p=3Dlio-core-2.6.git;a=3Dcommit=
diff;h=3Dea485147563b6555a97dbf811825fbb586519252

Yes, that patch was included - sorry, but I had made another mistake.
3.1-rc10 + ib_srpt + patch below is now working fine here. I noticed
only one unusual issue so far (with kernel debugging enabled) and that
is that the watchdog thread CPU time was unusually high:

root         7  2.3  0.0      0     0 ?        S    18:39   0:22 [watch=
dog/0]
root        12  0.6  0.0      0     0 ?        S    18:39   0:06 [watch=
dog/1]


The patch I used to backport ib_srpt from LIO-4.1 to kernel 3.1-rc10 is=
:

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c
b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 109b412..b3947fe 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1340,7 +1340,7 @@ static void srpt_put_send_ioctx(struct
srpt_send_ioctx *ioctx)
        WARN_ON(srpt_get_cmd_state(ioctx) !=3D SRPT_STATE_DONE);

        srpt_unmap_sg_to_ib_sge(ioctx->ch, ioctx);
-       transport_generic_free_cmd(&ioctx->cmd, 0);
+       transport_generic_free_cmd(&ioctx->cmd, 0, 0);

        if (ioctx->n_rbuf > 1) {
                kfree(ioctx->rbufs);
@@ -1899,7 +1899,7 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma=
_ch *ch,
                        TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
                goto process_tmr;
        }
-       cmd->se_tmr_req =3D core_tmr_alloc_req(cmd, NULL, tcm_tmr, GFP_=
KERNEL);
+       cmd->se_tmr_req =3D core_tmr_alloc_req(cmd, NULL, tcm_tmr);
        if (!cmd->se_tmr_req) {
                send_ioctx->cmd.se_cmd_flags |=3D SCF_SCSI_CDB_EXCEPTIO=
N;
                send_ioctx->cmd.se_tmr_req->response =3D TMR_FUNCTION_R=
EJECTED;

Bart.
