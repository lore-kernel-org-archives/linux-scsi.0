From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH v1] mpt3sas: Use driver scsi lookup to track outstanding IOs
Date: Thu, 28 Feb 2019 18:55:38 +0530
Message-ID: <CAK=zhgqXecz0bSXYiNiQn7WXbQq1eC2pWuhkYw53RirkukPC5g@mail.gmail.com>
References: <1550751105-46065-1-git-send-email-sreekanth.reddy@broadcom.com>
 <d0672a75-2900-5f6b-368f-5808914322a8@suse.de> <CAK=zhgpuB9Y+Z1e64D1Dm4fJtJ2rjZPf5g_TLNwnKbauRpqrJQ@mail.gmail.com>
 <61a8f703-3f20-b777-08b9-54ae34dffa59@suse.de> <CAK=zhgrWWtCf+N7EmbhK69PEc2L0hfc8ybOyFddUed8yufhvJQ@mail.gmail.com>
 <0dfb09ca-8723-3a3c-a6a8-c643856c57e3@suse.de> <20190226143313.GA23865@infradead.org>
 <6f94a905-45c9-4a77-bbb6-9669197e8d8f@suse.de> <CAHsXFKGbNfJ32EE_Gyz9yC0k+yNB=rgMQZc+jAQr2nFPDC+oFg@mail.gmail.com>
 <yq14l8p9tgf.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq14l8p9tgf.fsf@oracle.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 27, 2019 at 8:20 PM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Kashyap,
>
> > Primary drawback of using "blk_mq_tagset_busy_iter" is API is only for
> > blk-mq and it is not available for all the kernel with blk-mq
> > support. We have seen multiple failures from customer and those
> > kernels does not support blk_mq_tagset_busy_iter. In fact, blk-mq and
> > non-mq stack is alive in many Linux distribution and customer is using
> > those.
>
> I'm afraid the burden falls upon Broadcom to manage enablement patches
> for older kernels. So the non-MQ/non-tagset-busy-iter cases are not
> particularly relevant for the discussion here.
>
> Let's focus on getting some usable plumbing that drivers can use to
> abort oustanding tags.

Today I have discussed with Kashyap internally and found below solution,

Solution:
Instead of calling scsi_host_find_tag() API for each and every smid
from one to shost->can_queue, now driver will call this API only for
those smid's which are outstanding at the driver level. Driver will
determine whether this smid is outstanding at driver level by looking
into it's corresponding MPI request frame, if it's MPI request frame
is empty then it means that this smid is free and no need to call
scsi_host_find_tag() API for this smid. By doing this driver will
invoke scsi_host_find_tag() for only those tags which are outstanding
at the driver level.

Driver will check whether particular MPI request frame is empty or not
by looking into the "DevHandle" field. if this field is zero then it
means that this MPI request is empty. Also driver will memset the MPI
request frame once the corresponding scmd is processed (i.e. just
before calling scmd->done function).

Here is the code change. currently I am testing this code and will
post this patch once the testing completes. Please let us known your
thoughts on this.

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
b/drivers/scsi/mpt3sas/mpt3sas_base.c
index e577744..1d8c584 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3281,12 +3281,18 @@ void mpt3sas_base_clear_st(struct MPT3SAS_ADAPTER *ioc,

        if (smid < ioc->hi_priority_smid) {
                struct scsiio_tracker *st;
+               void *request;

                st = _get_st_from_smid(ioc, smid);
                if (!st) {
                        _base_recovery_check(ioc);
                        return;
                }
+
+               /* Clear MPI request frame */
+               request = mpt3sas_base_get_msg_frame(ioc, smid);
+               memset(request, 0, ioc->request_sz);
+
                mpt3sas_base_clear_st(ioc, st);
                _base_recovery_check(ioc);
                return;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8bb5b8f..55bec88 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1462,11 +1462,20 @@ struct scsi_cmnd *
 {
        struct scsi_cmnd *scmd = NULL;
        struct scsiio_tracker *st;
+       Mpi25SCSIIORequest_t *mpi_request;

        if (smid > 0  &&
            smid <= ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT) {
                u32 unique_tag = smid - 1;

+               mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+
+               /* DevHandle zero means that this smid is free
+                * at driver level, So return NULL.
+                */
+               if (!mpi_request->DevHandle)
+                       return scmd;
+
                scmd = scsi_host_find_tag(ioc->shost, unique_tag);
                if (scmd) {
                        st = scsi_cmd_priv(scmd);
---

Thanks,
Sreekanth



>
> --
> Martin K. Petersen      Oracle Linux Engineering
