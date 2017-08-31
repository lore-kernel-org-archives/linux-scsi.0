From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 00/14] mpt3sas driver NVMe support:
Date: Wed, 30 Aug 2017 23:05:37 -0400
Message-ID: <yq1a82gxwqm.fsf@oracle.com>
References: <1503322344-5900-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        <yq1lgmbauxt.fsf@oracle.com>
        <CA+RiK65F0CUNkc7AXN7n-rwvmf=Xm-t6dNvG134hY9yapwgDYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+RiK65F0CUNkc7AXN7n-rwvmf=Xm-t6dNvG134hY9yapwgDYg@mail.gmail.com>
        (Suganath Prabu Subramani's message of "Wed, 30 Aug 2017 18:00:26
        +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, linux-kernel@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org


Hi Suganath,

> Theoretically we want to use h/w capability (to translate IEEE to PRP)
> for smaller IO size to leverage h/w capability.

Nobody says we have to use the capability just because the hardware has
it.

Unlike some other operating systems, Linux will only submit I/Os to the
driver that conform to the reported underlying constraints of the
hardware. I fail to understand how letting the HBA firmware translate an
SGL to a PRP for a subset of I/Os could do anything but add latency.
Plus complexity in the hot path of the driver.

> - If the unmap translation in firmware is slow, why don't you translate
>   WRITE SAME/w UNMAP set to DSM DEALLOCATE without requiring
>   applications to do encapsulated passthrough?

> => As of now, current FW supports UNMAP command but not WRITE_SAME for
> NVME drive. We did some experiment to convert UMAP command in driver,
> but that is not really giving any performance improvement.

It is imperative that the common use case, Linux' discard
infrastructure, is working correctly and is as performant as any
application-driven passthrough workaround.

Unlike SCSI-to-SATA translation you have the benefit of a 1:1 mapping
between UNMAP and DEALLOCATE. I'm not even sure why there would be a
significant performance penalty in the firmware?

> We would like to continue with UNMAP (and all other non-read/write
> commands) to be handled in FW.

And yet patch 4 circumvents that statement by adding support for
encapsulated commands to bypass the FW translation...

-- 
Martin K. Petersen	Oracle Linux Engineering
