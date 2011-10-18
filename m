From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: ib_srpt status
Date: Tue, 18 Oct 2011 09:48:31 -0700
Message-ID: <1318956511.2454.11.camel@haakon2.linux-iscsi.org>
References: <20111012092318.GA9405@lst.de>
	 <CAO+b5-rqc7Dq-7p1XRHrxVMP9JS5N26Ht1q8ee=KGRqpUintFQ@mail.gmail.com>
	 <1318956075.2454.10.camel@haakon2.linux-iscsi.org>
	 <20111018164321.GA588@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20111018164321.GA588@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bvanassche@acm.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-10-18 at 18:43 +0200, Christoph Hellwig wrote:
> On Tue, Oct 18, 2011 at 09:41:15AM -0700, Nicholas A. Bellinger wrote:
> > I'm having no problems with the patch posted for v3.2 review on MT26428
> > HCAs
> > 
> > Can you verify you are actually using this patch, and not your private
> > tree from github..?  The reason is that your tree did not contain the
> > bugfix below to ib_srpt code that was originally causing problems:
> > 
> > ib_srpt: Fix bug with chainged SGLs in srpt_map_sg_to_ib_sge
> > http://www.risingtidesystems.com/git/?p=lio-core-2.6.git;a=commitdiff;h=ea485147563b6555a97dbf811825fbb586519252
> 
> Also it would be useful to know the workload that causes the corruption.

>From the above commit:

This patch fixes a bug in srpt_map_sg_to_ib_sge() that assumed a single
contigious array of struct scatterlist.  This was causing a OOPs when
se_cmd->t_task->t_tasks_no > 1 was using a set of sg_chained struct
se_task->task_sg[] memory into srpt_map_sg_to_ib_sge() code.
