From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
Date: Fri, 16 Mar 2012 17:58:35 +0900
Message-ID: <4F6300BB.9060503@ce.jp.nec.com>
References: <4EE8E419.8010000@pre-sense.de> <CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com> <20111225215804.03ef9402@stein> <4F3A46DD.8030305@ce.jp.nec.com> <4F5F8D82.2040704@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F5F8D82.2040704@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, jbottomley@parallels.com, linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>, Axel Theilmann <theilmann@pre-sense.de>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 03/14/12 03:10, Bart Van Assche wrote:
> Now that I've had some more time to think about this: has anyone
> considered to hold a reference on the SCSI host instead of the SCSI
> device as long as sd_probe_async() is active ? If sd_prep_fn() can ever
> see a NULL queuedata pointer then that means that
> scsi_host_dev_release() can get invoked while sd_prep_fn() is running.

Holding a host reference does not help, I think.
It does not stop __scsi_remove_device() setting NULL
to sdev's q->queuedata.

So, while there might be another race between sd_probe_async
and scsi_host_remove, I believe your "[PATCH] Fix device
removal NULL pointer dereference" still makes sense.

> That doesn't look correct to me.

-- 
Jun'ichi Nomura, NEC Corporation
