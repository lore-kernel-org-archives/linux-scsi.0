From: "Andreas Krebbel1" <Andreas.Krebbel@de.ibm.com>
Subject: Re: [PATCH v2 02/16] scsi: don't use fc_bsg_job::request and fc_bsg_job::reply
 directly
Date: Fri, 28 Oct 2016 18:29:38 +0200
Message-ID: <OF02C91110.A5599383-ONC125805A.00581A77-C125805A.005A9A28@notes.na.collabserv.com>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <b92d12e4f78c4998bc8ad000359c127e673379f3.1476276823.git.jthumshirn@suse.de>
 <2ea07f3f-88eb-b795-fa37-a223bf80e581@linux.vnet.ibm.com>
 <20161013162405.aoxy3bdkc4bqtwsk@linux-x5ow.site>
 <4b411836-e76f-b67a-3d49-ad3d51b8f216@linux.vnet.ibm.com>
 <d9a73963-1ade-2b6f-77bd-044e19675fd8@suse.de>
 <132d8dc4-e8d0-6eba-9ae2-4a7e2c9a589b@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <132d8dc4-e8d0-6eba-9ae2-4a7e2c9a589b@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dick Kennedy <dick.kennedy@avagotech.com>, "open list:FCOE SUBSYSTEM (libfc, libfcoe, fcoe)" <fcoe-devel@open-fcoe.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, heicars2@linux.vnet.ibm.com, James Smart <james.smart@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Johannes Thumshirn <jth@kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, "open list:S390 ZFCP DRIVER" <linux-s390@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>"Martin K . Petersen" <mart>
List-Id: linux-scsi@vger.kernel.org

> On 10/28/2016 01:31 PM, Hannes Reinecke wrote:
> > On 10/28/2016 11:53 AM, Steffen Maier wrote:
> >> On 10/13/2016 06:24 PM, Johannes Thumshirn wrote:
> >>> On Thu, Oct 13, 2016 at 05:15:25PM +0200, Steffen Maier wrote:
...
> fc_bsg_request_handler()
>                          req->errors = -ENXIO;
> 
> > 0x7c8e6e <fc_bsg_request_handler+0x86>: mvhi    260(%r12),-6
> 
> crash> struct -od request.errors
> struct request {
>    [260] int errors;
> }
> 
> ********************************************************************
> 
> BUT this seems the first time %r12 is used in fc_bsg_request_handler(),
> especially I seem to miss %r12 being initalized with anything.
> But then again I'm not at all well versed in disassembly.
> Maybe fc_bsg_request_handler() is itself in turn inlined and I would 
> need to start disassembling even earlier to get to %r12 init?
> s390x ELF ABI says %r12:
> usage: Local variable, commonly used as GOT pointer;
> call effect: saved.
> Even if it wasn't initialized and remained NULL below why did it not 
> already page fault at above instruction? Silly me, we did not execute 
> this instruction as it's "if" conditional. This makes me wonder even 
> more where the content of %r12 comes from.
> 
> Ulli, Andreas, could you please shed some light on this?
> 
> ********************************************************************

r12 holds variable req for that access. It is initialized here:

  req = blk_fetch_request(q);    
  if (!req)   
    break;

The asm code ends up down below in the function and loads the return value 
into r12. The code
invoking blk_fetch_request got duplicated and there are three jumps before 
the r12 access to these
locations.

  7c8e48:       ec a8 02 14 00 7c       cgije   %r10,0,7c9270 
<fc_bsg_request_handler+0x488>  <--- x
  7c8e4e:       d5 03 d0 04 a0 28       clc     4(4,%r13),40(%r10)
  7c8e54:       a7 74 02 02             jne     7c9258 
<fc_bsg_request_handler+0x470>         <--- y
  7c8e58:       91 04 a0 48             tm      72(%r10),4
  7c8e5c:       a7 74 01 fe             jne     7c9258 
<fc_bsg_request_handler+0x470>         <--- y
  7c8e60:       a7 f4 01 d5             j       7c920a 
<fc_bsg_request_handler+0x422>
  7c8e64:       d5 03 d0 00 a0 28       clc     0(4,%r13),40(%r10)
  7c8e6a:       a7 84 00 1a             je      7c8e9e 
<fc_bsg_request_handler+0xb6>
  7c8e6e:       e5 4c c1 04 ff fa       mvhi    260(%r12),-6
...

  7c9258:       b9 04 00 29             lgr     %r2,%r9
  7c925c:       c0 e5 ff f7 b3 a6       brasl   %r14,6bf9a8 
<blk_fetch_request>
  7c9262:       b9 04 00 c2             lgr     %r12,%r2
  7c9266:       ec 26 fd ff 00 7c       cgijne  %r2,0,7c8e64 
<fc_bsg_request_handler+0x7c>
  7c926c:       a7 f4 ff cf             j       7c920a 
<fc_bsg_request_handler+0x422>

  7c9270:       b9 04 00 29             lgr     %r2,%r9
  7c9274:       c0 e5 ff f7 b3 9a       brasl   %r14,6bf9a8 
<blk_fetch_request>
  7c927a:       b9 04 00 c2             lgr     %r12,%r2
  7c927e:       ec 26 fe 10 00 7c       cgijne  %r2,0,7c8e9e 
<fc_bsg_request_handler+0xb6>

-Andreas-
