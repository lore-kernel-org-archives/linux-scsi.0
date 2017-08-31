From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v4 00/14] mpt3sas driver NVMe support:
Date: Thu, 31 Aug 2017 10:28:06 +0530
Message-ID: <CA+RiK67f59U5Ss_Z2=veBRODtBSp1-4VTbosLkHkgaxY9XA6hQ@mail.gmail.com>
References: <1503322344-5900-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <yq1lgmbauxt.fsf@oracle.com> <CA+RiK65F0CUNkc7AXN7n-rwvmf=Xm-t6dNvG134hY9yapwgDYg@mail.gmail.com>
 <yq1a82gxwqm.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1a82gxwqm.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, linux-kernel@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Hi Martin,
Replied inline.

Thanks,
Suganath Prabu S

On Thu, Aug 31, 2017 at 8:35 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Hi Suganath,
>
>> Theoretically we want to use h/w capability (to translate IEEE to PRP)
>> for smaller IO size to leverage h/w capability.
>
> Nobody says we have to use the capability just because the hardware has
> it.
>
> Unlike some other operating systems, Linux will only submit I/Os to the
> driver that conform to the reported underlying constraints of the
> hardware.

<Suganath> In general, h/w constraints are handled. What we missed is
Fast Path h/w
which is not exposed to OS.

> I fail to understand how letting the HBA firmware translate an
> SGL to a PRP for a subset of I/Os could do anything but add latency.

<Suganath> Let me explain - NVME device fast path is possible in two ways.
IEEE SGL and PRP SGL. Due to h/w constraint we choose IEEE SGL only for
smaller IO size.
Both above is true h/w Fast Path and no firmware involvement.

> Plus complexity in the hot path of the driver.

<Suganath> Agree with you. We are planning to see if we can keep only
simple Fast
Path using only PRP. It will take some time to finalize as we have to
engage h/w and f/w team.  BTW - This area is h/w dependent and we do not
see further changes in this area.

>
>> - If the unmap translation in firmware is slow, why don't you translate
>>   WRITE SAME/w UNMAP set to DSM DEALLOCATE without requiring
>>   applications to do encapsulated passthrough?
>
>> => As of now, current FW supports UNMAP command but not WRITE_SAME for
>> NVME drive. We did some experiment to convert UMAP command in driver,
>> but that is not really giving any performance improvement.
>
> It is imperative that the common use case, Linux' discard
> infrastructure, is working correctly and is as performant as any
> application-driven passthrough workaround.
>
> Unlike SCSI-to-SATA translation you have the benefit of a 1:1 mapping
> between UNMAP and DEALLOCATE. I'm not even sure why there would be a
> significant performance penalty in the firmware?

<Suganath> I agree. Currently there is no performance issue for UNMAP
translation in
FW.


>> We would like to continue with UNMAP (and all other non-read/write
>> commands) to be handled in FW.
>
> And yet patch 4 circumvents that statement by adding support for
> encapsulated commands to bypass the FW translation...

<Suganath> This path is not due to performance reason. User wants to
interact with
NVME drive in native NVME command for management.

>
> --
> Martin K. Petersen      Oracle Linux Engineering
