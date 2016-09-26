From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [patch v2] arcmsr: buffer overflow in arcmsr_iop_message_xfer()
Date: Mon, 26 Sep 2016 15:29:49 +0200
Message-ID: <fb69655d-ddee-7961-0ad4-1a66f64d8c60@redhat.com>
References: <20160915134456.GA30277@mwanda>
 <yq17fadz2l6.fsf@sermon.lab.mkp.net>
 <20160923112226.rteir5ivjou64ffh@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935875AbcIZN36 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Sep 2016 09:29:58 -0400
In-Reply-To: <20160923112226.rteir5ivjou64ffh@pd.tnic>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Ching Huang <ching2048@areca.com.tw>, Hannes Reinicke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, security@kernel.org

On 23.9.2016 13:22, Borislav Petkov wrote:
> On Thu, Sep 15, 2016 at 09:59:01AM -0400, Martin K. Petersen wrote:
>>>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:
>> Dan> We need to put an upper bound on "user_len" so the memcpy() doesn't
>> Dan> overflow.
>>
>> Applied to 4.9/scsi-queue.
> Yap, Tomas said the kfree was missing on the error path but can we
> simplify this further by doing the user_len check first so that the
> kfree() is not even needed?
>
> Patch ontop:
>
> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Fri, 23 Sep 2016 13:04:51 +0200
> Subject: [PATCH] scsi: arcmsr: Simplify user_len checking
>
> Do the user_len check first and then the ver_addr allocation so that
> we can save us the kfree() on the error path when user_len is >
> ARCMSR_API_DATA_BUFLEN.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Marco Grassi <marco.gra@gmail.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Tomas Henzl <thenzl@redhat.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>

Looks good,
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

