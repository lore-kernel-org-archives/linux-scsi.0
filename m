From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for October 12 (scsi/bfa)
Date: Tue, 12 Oct 2010 10:14:14 -0700
Message-ID: <20101012101414.045f62d5.randy.dunlap@oracle.com>
References: <20101012163552.7306165b.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20101012163552.7306165b.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jing Huang <huangj@brocade.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 12 Oct 2010 16:35:52 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101011:


bfa has one function that probably uses too much stack space and a few
others that might be a problem.

With CONFIG_FRAME_WARN=1024:

drivers/scsi/bfa/bfad_im.c:939: warning: the frame size of 1604 bytes is larger than 1024 bytes

and with CONFIG_FRAME_WARN=512:


drivers/scsi/bfa/bfad.c: In function 'bfad_fcs_port_cfg':
drivers/scsi/bfa/bfad.c:900: warning: the frame size of 676 bytes is larger than 512 bytes
drivers/scsi/bfa/bfad_im.c: In function 'bfad_im_supported_speeds':
drivers/scsi/bfa/bfad_im.c:939: warning: the frame size of 1604 bytes is larger than 512 bytes
drivers/scsi/bfa/bfad_im.c: In function 'bfad_os_fc_host_init':
drivers/scsi/bfa/bfad_im.c:976: warning: the frame size of 736 bytes is larger than 512 bytes
drivers/scsi/bfa/bfa_fcs_lport.c: In function 'bfa_fcs_lport_fdmi_build_portattr_block':
drivers/scsi/bfa/bfa_fcs_lport.c:2010: warning: the frame size of 572 bytes is larger than 512 bytes
drivers/scsi/bfa/bfa_fcs_lport.c: In function 'bfa_fcs_lport_fdmi_build_rhba_pyld':
drivers/scsi/bfa/bfa_fcs_lport.c:1803: warning: the frame size of 784 bytes is larger than 512 bytes


Also, there are many comment blocks that begin with "/**", which means "beginning
of kernel-doc comment block" for Linux kernel code.  :(

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
