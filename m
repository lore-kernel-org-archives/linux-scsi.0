From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Sat, 21 Aug 2010 22:42:16 +0400
Message-ID: <4C701E08.2020005@vlnb.net>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>	 <1282144271.3035.31.camel@mulgrave.site>	 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>	 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>	 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>	 <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de> <1282256949.30453.278.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1282256949.30453.278.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Nicholas A. Bellinger, on 08/20/2010 02:29 AM wrote:
> "We will be extending the scsi_tgt_[lib,if].c mapped ring interface to
> allow TCM to access userspace backstores transparently with existing
> kernel level TCM fabric modules, and using the generic configfs fabric
> module infrastructure in target_core_fabric_configfs.c for the port and
> I_T nexus control plane just as you would with any TCM backstore
> subsystem today.
>
> Again, in open source you have to build upon what already exists and
> move forward.  The original STGT kernel<->  userspace ring abstraction
> and logic in drivers/scsi/scsi_tgt_lib.c:scsi_tgt_queue_command() ->
> scsi_tgt_uspace_send_cmd() is already going to do the vast majority of
> what is required for handling fabric I/O processing and I_T Nexus and
> Port management in kernel space with a userspace backstore.  It is
> really just a matter of allowing the STGT ring request to optionally be
> sent out to userspace as a standalone LUN instead of as a target port."

You forgot to mention one small thing. You are going to (re)use current 
STGT interface for user space backend, which in 5 years of being 
mainline has not gained any noticeable interest, because it is 
fundamentally slow. It needs a complete redesign to become fast. In 
contrast, interface provided by scst_user has just 3% overhead comparing 
with fully in-kernel backend and allows to build storage capable of 
handling 1,500,000 IOPSes (Kaminario).

Vlad
