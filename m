From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Thu, 19 Aug 2010 15:29:08 -0700
Message-ID: <1282256949.30453.278.camel@haakon2.linux-iscsi.org>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	 <1282144271.3035.31.camel@mulgrave.site>
	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>
	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>
	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:38544 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751864Ab0HSWcw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2010 18:32:52 -0400
In-Reply-To: <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dirk Meister <dmeister@uni-paderborn.de>
Cc: linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@suse.de>, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>

On Thu, 2010-08-19 at 23:20 +0200, Dirk Meister wrote:
> Am 19.08.2010 um 03:18 schrieb jack wang:
> > [Jack]Vote for SCST as a user and target driver developer based on  
> > SCST.
> > SCST really do good job.
> [dmeister] Vote for SCST. I am working with SCST to develop an user- 
> space target backend using the scst_user feature.
> The functionality, the stability of SCST, and the wide range of target  
> drivers for SCST are really nice.
> 

Just FYI, as myself and other folks do have a need for a proper target
mode kernel fabric -> userspace LUN passthrough, this will be addressed
by building upon Tomo-san and mnc's already existing mainline code in
drivers/scsi/scsi_tgt_*.c

Pretty much everything already exists there for doing a userspace
target, which is then registered as a seperate TCM/STGT subsystem plugin
that can be configfs symlinked into fabric module SCSI ports at will
with full SPC-3 PR and ALUA support for all supported TCM fabric
modules.  The complete discussion for that is mentioned in this thread:
http://lkml.org/lkml/2010/5/27/672  Here is the 'meat' of the
discussion, which is mentioned in the context of the '2nd phase of STGT
<-> LIO compatibility':


"We will be extending the scsi_tgt_[lib,if].c mapped ring interface to
allow TCM to access userspace backstores transparently with existing
kernel level TCM fabric modules, and using the generic configfs fabric
module infrastructure in target_core_fabric_configfs.c for the port and
I_T nexus control plane just as you would with any TCM backstore
subsystem today.

Again, in open source you have to build upon what already exists and
move forward.  The original STGT kernel <-> userspace ring abstraction
and logic in drivers/scsi/scsi_tgt_lib.c:scsi_tgt_queue_command() ->
scsi_tgt_uspace_send_cmd() is already going to do the vast majority of
what is required for handling fabric I/O processing and I_T Nexus and
Port management in kernel space with a userspace backstore.  It is
really just a matter of allowing the STGT ring request to optionally be
sent out to userspace as a standalone LUN instead of as a target port."


Note this code was left out of the last postings on linux-scsi, and will
most likely be left out initially for v2.6.37.  I do plan to have
something up and running on lio-core-2.6.git for one of my QEMU-KVM
projects by then however.  Here is how the code currently looks:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_stgt.c;hb=refs/heads/lio-4.0

Best,

--nab

