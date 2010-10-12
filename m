From: Jing Huang <huangj@Brocade.COM>
Subject: RE: linux-next: Tree for October 12 (scsi/bfa)
Date: Tue, 12 Oct 2010 15:44:44 -0700
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A5CF75DA53@HQ1-EXCH01.corp.brocade.com>
References: <20101012163552.7306165b.sfr@canb.auug.org.au>
 <20101012101414.045f62d5.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20101012101414.045f62d5.randy.dunlap@oracle.com>
Content-Language: en-US
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Krishna Gudipati <kgudipat@Brocade.com>, Maggie Zhang <xmzhang@Brocade.COM>
List-Id: linux-scsi@vger.kernel.org

>bfa has one function that probably uses too much stack space and a few
>others that might be a problem.
>
>With CONFIG_FRAME_WARN=1024:
>
>drivers/scsi/bfa/bfad_im.c:939: warning: the frame size of 1604 bytes is larger than
>1024 bytes
>
>and with CONFIG_FRAME_WARN=512:
>
>
>drivers/scsi/bfa/bfad.c: In function 'bfad_fcs_port_cfg':
>drivers/scsi/bfa/bfad.c:900: warning: the frame size of 676 bytes is larger than 512
>bytes
>drivers/scsi/bfa/bfad_im.c: In function 'bfad_im_supported_speeds':
>drivers/scsi/bfa/bfad_im.c:939: warning: the frame size of 1604 bytes is larger than
>512 bytes
>drivers/scsi/bfa/bfad_im.c: In function 'bfad_os_fc_host_init':
>drivers/scsi/bfa/bfad_im.c:976: warning: the frame size of 736 bytes is larger than
>512 bytes
>drivers/scsi/bfa/bfa_fcs_lport.c: In function
>'bfa_fcs_lport_fdmi_build_portattr_block':
>drivers/scsi/bfa/bfa_fcs_lport.c:2010: warning: the frame size of 572 bytes is larger
>than 512 bytes
>drivers/scsi/bfa/bfa_fcs_lport.c: In function 'bfa_fcs_lport_fdmi_build_rhba_pyld':
>drivers/scsi/bfa/bfa_fcs_lport.c:1803: warning: the frame size of 784 bytes is larger
>than 512 bytes
>

For these specific cases, we declare some big data structures in the stack, which is not good
and I will fix them. But is general, is passing 512 stack size check a requirement? This seems
too strict for me since the default stack size is 8k.

>Also, there are many comment blocks that begin with "/**", which means "beginning
>of kernel-doc comment block" for Linux kernel code.  :(
>

Not aware of this convention. I will fix them. Thanks.
