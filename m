From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Sat, 21 Aug 2010 13:25:16 -0700
Message-ID: <1282422316.30453.498.camel@haakon2.linux-iscsi.org>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	 <1282144271.3035.31.camel@mulgrave.site>
	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>
	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>
	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	 <1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	 <4C701E08.2020005@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C701E08.2020005@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2010-08-21 at 22:42 +0400, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger, on 08/20/2010 02:29 AM wrote:
> > "We will be extending the scsi_tgt_[lib,if].c mapped ring interface to
> > allow TCM to access userspace backstores transparently with existing
> > kernel level TCM fabric modules, and using the generic configfs fabric
> > module infrastructure in target_core_fabric_configfs.c for the port and
> > I_T nexus control plane just as you would with any TCM backstore
> > subsystem today.
> >
> > Again, in open source you have to build upon what already exists and
> > move forward.  The original STGT kernel<->  userspace ring abstraction
> > and logic in drivers/scsi/scsi_tgt_lib.c:scsi_tgt_queue_command() ->
> > scsi_tgt_uspace_send_cmd() is already going to do the vast majority of
> > what is required for handling fabric I/O processing and I_T Nexus and
> > Port management in kernel space with a userspace backstore.  It is
> > really just a matter of allowing the STGT ring request to optionally be
> > sent out to userspace as a standalone LUN instead of as a target port."
> 
> You forgot to mention one small thing. You are going to (re)use current 
> STGT interface for user space backend, which in 5 years of being 
> mainline has not gained any noticeable interest, because it is 
> fundamentally slow.

First, 'build upon' and blind '(re)use' are different approaches.
Building on is an important requirement for working with any existing
mainline code regardless of how much much attention the code itself may
require.  Initially re-using pieces of the mainline code is acceptable
to get a prototype up and running, and since we don't have many users
for this piece of STGT, it will easier to make larger changes (eg: move
beyond simple re-use) without breaking a large legacy base.

This is what I actually prefer moving forward, as it gives us more
flexibility for the future.

>  It needs a complete redesign to become fast.

Secondly, not being the original author of drivers/scsi/scsi_tgt_*, I am
happy to do the work and submit the necessary patches to achieve the
desired goal.  Also, considering now we have the TCM v4 HBA/DEV
abstraction with a fabric independent control path in
target_core_fabric_configfs.c, there suddenly new interest to build upon
tomo's and mnc'c original STGT work in drivers/scsi/scsi_tgt_*.c

Using struct scsi_cmnd allocation from a specially allocated struct
request_queue still my preferred method for doing this, unless tomo and
mnc state otherwise.   Also if we need to change the request_queue from
being per struct Scsi_Host to struct scsi_device that is one thing that
will be fine.  If we need to make more drastic changes to
drivers/scsi/scsi_tgt_if.c that is also fine.

However saying that it needs a 'complete redesign', especially without
ever consulting or offering to creat patches with STGT guys is not how
mainline development functions.

>  In 
> contrast, interface provided by scst_user has just 3% overhead comparing 
> with fully in-kernel backend and allows to build storage capable of 
> handling 1,500,000 IOPSes (Kaminario).
> 

Great!  Please understand that you are more than welcome to create your
own TCM subsystem plugin for your SCST kernel <-> user passthrough
interface so it can take advantage of all the drivers/target/ code has
to offer.   Also, now that target_core_iblock.c, target_core_pscsi.c,
target_core_file.c, and target_core_stgt.c are seperate standalone LKMs
loaded on-demand by TCM/ConfigFS, creating a new TCM struct
se_subsystem_api module will be even easier for you now.

I would even be happy to send a functioning struct se_subsystem_api
skeleton for your efforts once the tcm_mod_builder.py script I am
currently working on for producing unlimited ready-to-run configfs
skeletons for new TCM fabric modules is ready to be pushed.

Best,

--nab
