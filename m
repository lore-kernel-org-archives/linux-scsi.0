From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2] scsi: mpt3sas: remove redundant wmb
Date: Wed, 19 Apr 2017 22:28:30 -0400
Message-ID: <yq1y3uvq0c1.fsf@oracle.com>
References: <1491591978-17880-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19796 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966609AbdDTC3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 22:29:06 -0400
In-Reply-To: <1491591978-17880-1-git-send-email-okaya@codeaurora.org> (Sinan
        Kaya's message of "Fri, 7 Apr 2017 15:06:18 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, timur@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:LSILOGIC MPT FUSION DRIVERS
        FC/SAS/SPI" <MPT-FusionLinux.pdl@broadcom.com>, open list <linux-kernel@vger.kernel.org>

Sinan Kaya <okaya@codeaurora.org> writes:

> Due to relaxed ordering requirements on multiple architectures,
> drivers are required to use wmb/rmb/mb combinations when they need to
> guarantee observability between the memory and the HW.
>
> The mpt3sas driver is already using wmb() for this purpose.  However,
> it issues a writel following wmb(). writel() function on arm/arm64
> arhictectures have an embedded wmb() call inside.
>
> This results in unnecessary performance loss and code duplication.
>
> writel already guarantees ordering for both cpu and bus. we don't need
> additional wmb()

Broadcom folks, please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
