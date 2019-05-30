From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas_ctl: fix double-fetch bug in _ctl_ioctl_main()
Date: Wed, 29 May 2019 22:22:03 -0400
Message-ID: <yq1ef4gy94k.fsf@oracle.com>
References: <20190530011030.GA6314@zhanggen-UX430UQ>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190530011030.GA6314@zhanggen-UX430UQ> (Gen Zhang's message of
        "Thu, 30 May 2019 09:10:30 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Gen Zhang <blackgod016574@gmail.com>
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, suganath-prabu.subramani@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gen,

> In _ctl_ioctl_main(), 'ioctl_header' is fetched the first time from 
> userspace. 'ioctl_header.ioc_number' is then checked. The legal result 
> is saved to 'ioc'. Then, in condition MPT3COMMAND, the whole struct is
> fetched again from the userspace. Then _ctl_do_mpt_command() is called,
> 'ioc' and 'karg' as inputs.
>
> However, a malicious user can change the 'ioc_number' between the two 
> fetches, which will cause a potential security issues.  Moreover, a 
> malicious user can provide a valid 'ioc_number' to pass the check in 
> first fetch, and then modify it in the second fetch.
>
> To fix this, we need to recheck the 'ioc_number' in the second fetch.

Applied to 5.3/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
