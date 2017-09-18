From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v4 00/14] mpt3sas driver NVMe support:
Date: Mon, 18 Sep 2017 16:09:09 +0530
Message-ID: <CA+RiK65GPnfqpQAuUWEs_NdW9crumkGparCqynN_dBti8BPXqQ@mail.gmail.com>
References: <1503322344-5900-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <yq1lgmbauxt.fsf@oracle.com> <CA+RiK65F0CUNkc7AXN7n-rwvmf=Xm-t6dNvG134hY9yapwgDYg@mail.gmail.com>
 <yq1a82gxwqm.fsf@oracle.com> <CA+RiK67f59U5Ss_Z2=veBRODtBSp1-4VTbosLkHkgaxY9XA6hQ@mail.gmail.com>
 <yq13787w1a3.fsf@oracle.com> <CA+RiK667V9nDEr7RywED2_RoSq97m511HZTpGqPbij9-=vADvQ@mail.gmail.com>
 <CA+RiK64sJZzTcTHODHj0monB2_0xKAkvjrC79rGv2mNUPO87-A@mail.gmail.com> <yq1wp50rcqw.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1wp50rcqw.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, linux-kernel@vger.kernel.org, Chaitra Basappa <chaitra.basappa@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Hi Martin,

On Fri, Sep 15, 2017 at 6:37 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Suganath,
>
>> Is there any update on the submitted mpt3sas patches.
>
> We are waiting for you to report back your findings on PRP vs. SGL.

We are working on this, since there is h/w dependent, we are in
discussion with H/W & F/W team and doing experiments. If there is no
impact, and if SGL translation has to be removed, this change has to
go through some phase of testing, before we post it to upstream, since
that is not inline with H/W requirement.

The hardware translation of IEEE SGL to NVMe PRPs has limitation.

We have added the below comment in patch 3 as well:

if a command cannot be translated by hardware then it will go
to firmware and the firmware needs to translate it. And this will
have a performance reduction. To avoid that driver proactively
checks whether the translation will be done in hardware or not,
if not then driver try to translate inside the driver

Current code posted to upstream is inline with hardware requirements
and well tested internally.

SGL vs NVMe PRP building in driver is small sanity check for decision making
and it is not going to change in long run.

Also, Making all PRP buffer may or may not need FW changes (assuming
it is possible.),
we may end up into multiple FW version check.

Since this is main IO path and current driver is following H/W limitation,
we should avoid any changes in this area until and unless change is
universal acceptable in FW (for all type of work load).

Hope this clarifies.
>
> --
> Martin K. Petersen      Oracle Linux Engineering

Thanks,
Suganath Prabu S
