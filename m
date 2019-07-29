From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] target: iscsi: iscsi_target_tpg: Fix a possible
 null-pointer dereference in iscsit_tpg_add_network_portal()
Date: Mon, 29 Jul 2019 08:02:42 -0700
Message-ID: <1564412562.3501.9.camel@HansenPartnership.com>
References: <20190729022956.18192-1-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729022956.18192-1-baijiaju1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>, martin.petersen@oracle.com, kstewart@linuxfoundation.org, allison@lohutok.net, rfontana@redhat.com, tglx@linutronix.de, gregkh@linuxfoundation.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2019-07-29 at 10:29 +0800, Jia-Ju Bai wrote:
> In iscsit_tpg_add_network_portal(), there is an if statement on line
> 496
> to check whether tpg->tpg_tiqn is NULL:
>     if (tpg->tpg_tiqn)
> 
> When tpg->tpg_tiqn is NULL, it is used on line 508:
>     pr_debug(..., tpg->tpg_tiqn->tiqn, ...);
> 
> Thus, a possible null-pointer dereference may occur.
> 
> To fix this bug, tpg->tpg_tiqn is checked before being used.
> 
> This bug is found by a static analysis tool STCheck written by us.

I don't really think this is helpful.  The first question is, is the
implied might be NULL check correct?  The tpg_tiqn is always set by a
non-dummy driver and I think network configuration is only done for the
non dummy driver, so I suspect the NULL check is wrong.  Secondly even
if the NULL check were correct, I think there's still a need for some
debugging output, so the proposed patch also looks wrong.

James
