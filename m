From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] block: ratelimite pr_err on IO path
Date: Fri, 13 Apr 2018 12:59:38 -0400
Message-ID: <yq1bment539.fsf@oracle.com>
References: <1523524915-25170-1-git-send-email-jinpu.wangl@profitbricks.com>
        <yq1y3hsunnt.fsf@oracle.com>
        <CAMGffEkaTLLEs+i-EWUmo-Y8KSNBeyth63L1hXxP++PBcPPXbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMGffEkaTLLEs+i-EWUmo-Y8KSNBeyth63L1hXxP++PBcPPXbg@mail.gmail.com>
        (Jinpu Wang's message of "Fri, 13 Apr 2018 10:37:25 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Jinpu,

[CC:ed the mpt3sas maintainers]

The ratelimit patch is just an attempt to treat the symptom, not the
cause.

> Thanks for asking, we updated mpt3sas driver which enables DIX support
> (prot_mask=0x7f), all disks are SATA SSDs, no DIF support.
> After reboot, kernel reports the IO errors from all the drives behind
> HBA, seems for almost every read IO, which turns the system unusable:
> [   13.079375] sda: ref tag error at location 0 (rcvd 143196159)
> [   13.079989] sda: ref tag error at location 937702912 (rcvd 143196159)
> [   13.080233] sda: ref tag error at location 937703072 (rcvd 143196159)
> [   13.080407] sda: ref tag error at location 0 (rcvd 143196159)
> [   13.080594] sda: ref tag error at location 8 (rcvd 143196159)

That sounds like a bug in the mpt3sas driver or firmware. I guess the
HBA could conceivably be operating a SATA device as DIX Type 0 and strip
the PI on the drive side. But that doesn't seem to be a particularly
useful mode of operation.

Jinpu: Which firmware are you running? Also, please send us the output
of:

        sg_readcap -l /dev/sda
        sg_inq -x /dev/sda
        sg_vpd /dev/sda

Broadcom: How is DIX supposed to work for SATA drives behind an mpt3sas
controller?

-- 
Martin K. Petersen	Oracle Linux Engineering
