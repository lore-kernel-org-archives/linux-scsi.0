From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v4 00/14] mpt3sas driver NVMe support:
Date: Wed, 30 Aug 2017 18:00:26 +0530
Message-ID: <CA+RiK65F0CUNkc7AXN7n-rwvmf=Xm-t6dNvG134hY9yapwgDYg@mail.gmail.com>
References: <1503322344-5900-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <yq1lgmbauxt.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1lgmbauxt.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, linux-kernel@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Hi Martin,

Replied in line.

- I don't understand why you go through all these hoops to decide
  whether to use PRPs or IEEE scatterlists. If the firmware translation
  is slow, why even bother with the SG format in the first place? Set
  the max I/O size to match MDTS and you're done.

=>  We will  set MDTS value as max hw sectors using
blk_queue_max_hw_sectors(). As of now, we see correct MDTS value is
being set to block layer via VPD page 0xb0 (Block limits VPD page )
response from FW for NVME device.
=> I will remove MDTS checks in IO path.


- What's the benefit of using SG for regular I/O commands?

=>  Broadcom's IT Tri-mode HBA hardware has a capability of
translating IEEE SGLs to PRP's only up to ~4 page block size.
If the IO block size is greater than that (along with other condition
described code base_is_prp_possible), driver has to frame the PRP's to
avoid FW intervention. Both the case is a fast path, but for smaller
IO (up to 20K) size will frame IEEE SGL and large IO size will frame
PRP format SGL. Theoretically we want to use h/w capability (to
translate IEEE to PRP) for smaller IO size to leverage h/w capability.
We are investigating if at all we can send all PRP and avoid checks in
driver, but that exercise may take time as we have many different
opinions. We prefer to use existing code as it is stable and in-line
with h/w requirement.


- If the unmap translation in firmware is slow, why don't you translate
  WRITE SAME/w UNMAP set to DSM DEALLOCATE without requiring
  applications to do encapsulated passthrough?

=> As of now, current FW supports UNMAP command but not WRITE_SAME for
NVME drive. We did some experiment to convert UMAP command in driver,
but that is not really giving any performance improvement. We would
like to continue with UNMAP (and all other non-read/write commands) to
be handled in FW.


- Also make sure you attribute your patches correctly (From: root
<root@dhcp-135-24-192-103.dhcp.avagotech.net>). And you don't need
that long CC: list. Just send the patch series to
linux-scsi@vger.kernel.org.

=>  I will fix this type of issue going forward

Thanks,
Suganath Prabu S

On Wed, Aug 23, 2017 at 7:48 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Suganath,
>
>>   mpt3sas: SGL to PRP Translation for I/Os to NVMe  devices
>
> I'm still confused about this patch.
>
>  - I don't understand why you go through all these hoops to decide
>    whether to use PRPs or IEEE scatterlists. If the firmware translation
>    is slow, why even bother with the SG format in the first place? Set
>    the max I/O size to match MDTS and you're done.
>
>  - What's the benefit of using SG for regular I/O commands?
>
>  - If the unmap translation in firmware is slow, why don't you translate
>    WRITE SAME/w UNMAP set to DSM DEALLOCATE without requiring
>    applications to do encapsulated passthrough?
>
> Also make sure you attribute your patches correctly (From: root
> <root@dhcp-135-24-192-103.dhcp.avagotech.net>). And you don't need that
> long CC: list. Just send the patch series to linux-scsi@vger.kernel.org.
>
> Thanks!
>
> --
> Martin K. Petersen      Oracle Linux Engineering
