From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Tue, 24 Aug 2010 14:23:34 -0700
Message-ID: <1282685014.32007.51.camel@haakon2.linux-iscsi.org>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	 <1282144271.3035.31.camel@mulgrave.site>
	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>
	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>
	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	 <1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	 <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site>
	 <4C73DA15.2010207@vlnb.net> <1282661876.2993.20.camel@mulgrave.site>
	 <4C7421FB.2060007@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:20204 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755435Ab0HXV1W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2010 17:27:22 -0400
In-Reply-To: <4C7421FB.2060007@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@suse.de>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Tue, 2010-08-24 at 23:48 +0400, Vladislav Bolkhovitin wrote:
> James Bottomley, on 08/24/2010 06:57 PM wrote:
> > On Tue, 2010-08-24 at 18:41 +0400, Vladislav Bolkhovitin wrote:
> >> James Bottomley, on 08/22/2010 12:43 AM wrote:
> >>> Interface re-use (or at least ABI compatibility) is the whole point,
> >>> it's what makes the solution a drop in replacement.
> >>
> >> I see now. You want ABI compatibility to keep the "contract" that no
> >> kernel changes can break applications binary compatibility for unlimited
> >> time.
> >>
> >> OK, we will write the compatibility module. It shouldn't take much time.
> >>
> >> But before we start, I'd like to clear 2 related questions:
> >>
> >> 1. How far the ABI compatibility "contract" goes? Are there cases, where
> >> it isn't so strong? I'm asking, because I can recall that open-iscsi at
> >> least once has broken ABI compatibility with user space tools. Was it an
> >> accidental (but not corrected) mistake or was it deliberate? If the
> >> latter, then, I guess, there must be some exceptions defining when ABI
> >> compatibility can be not followed.
> > 
> > I don't think it has to be complete.  As long as the STGT people think
> > it's good enough, that's fine by me.
> 
> Tomonori, Mike, could you comment on that, please?
>  
> >> 2. Currently STGT in the kernel is just 2 files, scsi_tgt_if.c and
> >> scsi_tgt_lib.c (with headers), + ibmvstgt driver. The C files define the
> >> STGT interface in question. So, if we keep ABI compatibility with the
> >> new target engine, we would have to keep those 2 files included in the
> >> kernel,
> > 
> > This isn't really correct.  The ABI is defined by the headers not the
> > implementation.
> 
> Yes, but we on the target side would not be able to implement the ABI compatible interface without using library functions provided by those C files. Or, at least, it would be much harder.
> 
> So, would it be OK for you to keep those files?
>  
> >> which would effectively mean that STGT would stay in the kernel.
> >> This would lead to the situation you are trying to avoid: 2 SCSI target
> >> infrastructures in the kernel. Would it be OK?
> > 
> > If you mean is the marketing solution of wedging two products into the
> > kernel and calling it a single one going to fly, the answer is no.
> 
> I mean that if we keep those 2 files to ease our ABI compatibility effort, it would effectively mean that we would leave STGT merged. It isn't something we would create, it just would be so itself as a matter of fact. Ultimately, STGT is an user space engine. What it has in the kernel is the interface helper functions to interact with the in-kernel drivers. The simplest way to achieve the ABI compatibility is to make a backend module acting as an STGT in-target driver.
> 
> (Actually, I may not ask it, because this is the way how LIO seems[1] implemented that, which was approved on the LSF summit. I only want to make all pros and cons clear from the very beginning.)
> 
> Thanks,
> Vlad
> 
> 1. I wrote "seems", because currently LIO has the following code for STGT commands execution: 
> 
> int stgt_do_task(se_task_t *task)
> {
> 	stgt_plugin_task_t *st = (stgt_plugin_task_t *) task->transport_req;
> 	struct Scsi_Host *sh = task->se_dev->se_hba->hba_ptr;
> 	struct scsi_cmnd *sc;
> 	int tag = MSG_SIMPLE_TAG;
> 
> 	sc = scsi_host_get_command(sh, st->stgt_direction, GFP_KERNEL);
> 	if (!sc) {
> 		printk(KERN_ERR "Unable to allocate memory for struct"
> 			" scsi_cmnd\n");
> 		return PYX_TRANSPORT_LU_COMM_FAILURE;
> 	}
> 
> 	memcpy(sc->cmnd, st->stgt_cdb, MAX_COMMAND_SIZE);
> 	sc->sdb.length = task->task_size;
> 	sc->sdb.table.sgl = task->task_sg;
> 	sc->tag = tag;
> 
> 	BUG();
> #warning FIXME: Get struct scsi_lun for scsi_tgt_queue_command()
> #if 0
> 	err = scsi_tgt_queue_command(sc, itn_id, (struct scsi_lun *)&cmd->lun,
> 			cmd->tag);
> 	if (err) {
> 		printk(KERN_INFO "scsi_tgt_queue_command() failed for sc:"
> 			" %p\n", sc);
> 		scsi_host_put_command(sh, sc);
> 	}
> #endif
> 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
> }

Vlad,

As mentioned explictly earlier in this thread, my WIP code for the
kernel level subsystem backstore using STGT kernel <-> user CDB
passthrough logic in drivers/target/target_core_stgt.c is a item on my
TODO list, but I will repeat, is NOT being tagged as a mainline .37
item.

Tomo-san, mnc, and other storage folks have been briefed on the
remaining issues that would be involved to get a prototype functioning
with drivers/target/target_core_stgt.c, and rough idea of what it would
take in existing mainline drivers/scsi/scsi_tgt_*.c code.  With the
current WIP code this will allow the userspace CDB -> LUN passthrough to
function transparently with all TCM SPC-4 compliant logic as a
standalone struct se_subsystem_api tcm_core_stgt.ko backstore.

Best,

--nab

