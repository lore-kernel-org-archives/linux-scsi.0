From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] lpfc: nvmet_fc: fix format string
Date: Sat, 20 May 2017 21:10:59 +0200
Message-ID: <CAK8P3a37qj9szwsmksxFr_pWXK8LLzTG+4_mJ7t9WB76pO6A2A@mail.gmail.com>
References: <20170519080447.1043039-1-arnd@arndb.de> <1495276127.27714.4.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32885 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751414AbdETTLB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 May 2017 15:11:01 -0400
In-Reply-To: <1495276127.27714.4.camel@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Sat, May 20, 2017 at 12:28 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2017-05-19 at 10:04 +0200, Arnd Bergmann wrote:
>> The lpfc_nvmeio_data() tracing helper always takes a format string and
>> three additional arguments.
>
> No it doesn't.  It takes a format and arguments.
>
> I don't disagree with the patch, just the characterization
> of the lpfc_mvmeio_data call in the commit message.

I think my description is correct, it's just not obvious from
reading the code until you also look at the lpfc_debugfs_nvme_trc
prototype:

extern void lpfc_debugfs_nvme_trc(struct lpfc_hba *phba, char *fmt,
                                uint16_t data1, uint16_t data2, uint32_t data3);
#define lpfc_nvmeio_data(phba, fmt, arg...) \
        { \
        if (phba->nvmeio_trc_on) \
                lpfc_debugfs_nvme_trc(phba, fmt, ##arg); \
        }


This is trying to do the same thing as the regular Linux tracepoints,
but is called in a lot of places that are all required to pass exactly
three integer arguments along with a matching format string.

      Arnd
