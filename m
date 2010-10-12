From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for October 12 (scsi/bfa)
Date: Tue, 12 Oct 2010 15:55:49 -0700 (PDT)
Message-ID: <dac0cbc8-0509-46eb-812f-3ef8ec9e037e@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: huangj@Brocade.COM
Cc: sfr@canb.auug.org.au, linux-scsi@vger.kernel.org, kgudipat@Brocade.COM, linux-kernel@vger.kernel.org, xmzhang@Brocade.COM, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,


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

| For these specific cases, we declare some big data structures in the stack, which is not good
| and I will fix them. But is general, is passing 512 stack size check a requirement? This seems
| too strict for me since the default stack size is 8k.

Fixing the warnings for frame size exceeding 1024 is OK IMO.
The 512 test was just for more info.

Ah, I see, 8 KB stack is default on X86_32.


>Also, there are many comment blocks that begin with "/**", which means "beginning
>of kernel-doc comment block" for Linux kernel code.  :(
>

| Not aware of this convention. I will fix them. Thanks.

Thanks.
