From: "Prabhakaran, Rajesh" <rajeshpr@lsil.com>
Subject: RE: megaraid megaraid2-2.10.7 causing kernel panic
Date: Wed, 8 Sep 2004 18:24:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570345E040@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61065 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S269184AbUIHWY6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2004 18:24:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>, 'Aleks Sheynkman' <aleks@Narus.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Aleks,
   Try this,we need to store the data transfer address in the mailbox of
uioctl packet, for the application to run with 2.10.7 driver.This
requirement is removed, in the later versions of driver.

#include "megaraid.h"

int main()
{
        int    fd;
        struct uioctl_t uioctl;
	mega_inquiry3 *inq3;
	mbox_t	*mail_ptr;

       if ( (fd = open("/dev/megadev0", O_RDWR)) < 0 && (fd =
open("/dev/megadev", O_RDWR)) < 0)
                return -1;

        uioctl.inlen =  1024;
        uioctl.outlen = 1024;

        if(!(uioctl.data = malloc(1024))){
                return 0;
        }
        memset(uioctl.data, 0, 1024);

        uioctl.ui.fcs.opcode     = 0x80;
        uioctl.ui.fcs.subopcode  = 0;
        uioctl.ui.fcs.adapno     = MKADAP(0);

        uioctl.mbox[0]           = FC_NEW_CONFIG;
        uioctl.mbox[2]           = NC_SUBOP_ENQUIRY3;
        uioctl.mbox[3]           = ENQ3_GET_SOLICITED_FULL;
        mail_ptr		         = uioctl.mbox;
	  mail_ptr->xferaddr  	   = (u32) uioctl.data;


        if(ioctl(fd, MEGAIOCCMD, &uioctl) == -1){
                printf("Error %d \n\n",uioctl.ui.fcs.adapno);
                free(uioctl.data);
                close(fd);
                return 0;
        }
	inq3 = uioctl.data;
	printf("Rebuild Rate %d\n\n",inq3->rebuild_rate);
	
    	free(uioctl.data);	
   	close(fd);
 return 0;
}


-----Original Message-----
From: Aleks Sheynkman [mailto:aleks@Narus.com]
Sent: Tuesday, September 07, 2004 4:59 PM
To: Mukker, Atul
Subject: RE: megaraid megaraid2-2.10.7 causing kernel panic


Mr. Atul ,

 I'm sorry for keep bother you , I was wondering to ask you for advice since
you are the author of the driver
what else I can try. It seem like no matter what I do, I can not
successfully execute ioctl to the driver. I tried 
passing address to xerraddress with different data buffer, always fails with
error and quite often resolves in kernel panic.

Thank you!

Aleks

> -----Original Message-----
> From: Aleks Sheynkman 
> Sent: Friday, September 03, 2004 2:06 PM
> To: 'Mukker, Atul'
> Subject: RE: megaraid megaraid2-2.10.7 causing kernel panic
> 
> 
> Thanks a lot for your help, it seems that no matter what I do 
> I never can get any status back from device even by 
> initializing  xferaddr to same address of data.
> 
> 
> Thank you !
> 
> Alesk
> 
> > -----Original Message-----
> > From: Mukker, Atul [mailto:Atulm@lsil.com]
> > Sent: Friday, September 03, 2004 1:50 PM
> > To: Aleks Sheynkman; Mukker, Atul
> > Subject: RE: megaraid megaraid2-2.10.7 causing kernel panic
> > 
> > 
> > You are already doing it
> > 
> > > > > > > > 
> > > > > > > >         uioctl.mbox[0]           = FC_NEW_CONFIG;
> > > > > > > >         uioctl.mbox[2]           = NC_SUBOP_ENQUIRY3;
> > > > > > > >         uioctl.mbox[3]           = 
> > ENQ3_GET_SOLICITED_FULL;
> > > > > > > > 
> > 
> > 
> > > -----Original Message-----
> > > From: Aleks Sheynkman [mailto:aleks@Narus.com]
> > > Sent: Friday, September 03, 2004 4:14 PM
> > > To: Mukker, Atul
> > > Subject: RE: megaraid megaraid2-2.10.7 causing kernel panic
> > > 
> > > 
> > > Correct me if I'm wrong by , my apology in advance ,
> > > 
> > >  what u saying that I have to send as an argument to ioctl a 
> > > mbox also? because mbox is not part of ioctl structure 
> > > 
> > > Thank you !
> > > 
> > > Aleks
> > > > -----Original Message-----
> > > > From: Mukker, Atul [mailto:Atulm@lsil.com]
> > > > Sent: Friday, September 03, 2004 12:51 PM
> > > > To: Aleks Sheynkman; Mukker, Atul; linux-raid@vger.kernel.org;
> > > > linux-scsi@vger.kernel.org
> > > > Subject: RE: megaraid megaraid2-2.10.7 causing kernel panic
> > > > 
> > > > 
> > > > The mailbox structure has the data transfer field 
> > > "xferaddr" as well.
> > > > 
> > > > 
> > > > > -----Original Message-----
> > > > > From: Aleks Sheynkman [mailto:aleks@Narus.com]
> > > > > Sent: Friday, September 03, 2004 3:36 PM
> > > > > To: Mukker, Atul; linux-raid@vger.kernel.org; 
> > > > > linux-scsi@vger.kernel.org
> > > > > Subject: RE: megaraid megaraid2-2.10.7 causing kernel panic
> > > > > 
> > > > > 
> > > > > I'm sorry for asking, but looking at ioctl structure I only 
> > > > > see single data field in both
> > > > > version. Is there are anyway you can explain about 
> both fields ?
> > > > > 
> > > > > Thank you ,
> > > > > 
> > > > > Aleks
> > > > > 
> > > > > > -----Original Message-----
> > > > > > From: Mukker, Atul [mailto:Atulm@lsil.com]
> > > > > > Sent: Friday, September 03, 2004 12:32 PM
> > > > > > To: Aleks Sheynkman; Mukker, Atul; 
> linux-raid@vger.kernel.org;
> > > > > > linux-scsi@vger.kernel.org
> > > > > > Subject: RE: megaraid megaraid2-2.10.7 causing kernel panic
> > > > > > 
> > > > > > 
> > > > > > 1.18f reads the user address from the data field, 
> but the new 
> > > > > > interface
> > > > > > packet has one data transfer field. So your best bet is to 
> > > > > > provide addresses
> > > > > > in both fields.
> > > > > > 
> > > > > > Thanks
> > > > > > -Atul
> > > > > > 
> > > > > > > -----Original Message-----
> > > > > > > From: Aleks Sheynkman [mailto:aleks@Narus.com]
> > > > > > > Sent: Friday, September 03, 2004 3:25 PM
> > > > > > > To: Mukker, Atul; linux-raid@vger.kernel.org; 
> > > > > > > linux-scsi@vger.kernel.org
> > > > > > > Subject: RE: megaraid megaraid2-2.10.7 causing 
> kernel panic
> > > > > > > 
> > > > > > > 
> > > > > > > Isn't the same as was before in version megraid1.8f ?
> > > > > > > 
> > > > > > > Thanks !
> > > > > > > 
> > > > > > > Aleks
> > > > > > > 
> > > > > > > > -----Original Message-----
> > > > > > > > From: Mukker, Atul [mailto:Atulm@lsil.com]
> > > > > > > > Sent: Friday, September 03, 2004 12:20 PM
> > > > > > > > To: Aleks Sheynkman; linux-raid@vger.kernel.org;
> > > > > > > > linux-scsi@vger.kernel.org
> > > > > > > > Subject: RE: megaraid megaraid2-2.10.7 causing 
> > kernel panic
> > > > > > > > 
> > > > > > > > 
> > > > > > > > Aleks,
> > > > > > > > 
> > > > > > > > What you are using are undocumented interfaces to issue 
> > > > > > > > commands to the
> > > > > > > > driver. We do not provide support for these. But you 
> > > > > could easily
> > > > > > > > reverse-engineer the driver code to see what you are 
> > > > > > doing wrong :-)
> > > > > > > > 
> > > > > > > > This driver version expects the data transfer 
> > address to be 
> > > > > > > > available in the
> > > > > > > > FW packet transfer address field, which you are not 
> > > > > > > > providing. That mean the
> > > > > > > > HBA is doing DMA to a junk address causing the bizzare 
> > > > > > > > behaviors observed by
> > > > > > > > you.
> > > > > > > > 
> > > > > > > > Thanks
> > > > > > > > -Atul Mukker
> > > > > > > > 
> > > > > > > > -----Original Message-----
> > > > > > > > From: Aleks Sheynkman [mailto:aleks@Narus.com]
> > > > > > > > Sent: Friday, September 03, 2004 1:06 PM
> > > > > > > > To: linux-raid@vger.kernel.org; 
> linux-scsi@vger.kernel.org
> > > > > > > > Subject: megaraid megaraid2-2.10.7 causing kernel panic
> > > > > > > > 
> > > > > > > > 
> > > > > > > > Greetings,
> > > > > > > >   I'm really sorry to bother you ,and I hope this is a 
> > > > > > > > correct list to post
> > > > > > > > these kind of messages. I did post a similar 
> > message a day 
> > > > > > > ago. We are
> > > > > > > > currently experiencing problem with a new version of 
> > > > > > megaraid driver
> > > > > > > > (megaraid2-2.10.7). All our severs in the past 
> > were running 
> > > > > > > > RH 7.3 and now
> > > > > > > > we started migration process AS 2.1 specifically 
> > to update 
> > > > > > > > 2.4.9-e.49smp and
> > > > > > > > dkms megaraid version 2.10.7. After upgrade, all 
> > > our systems 
> > > > > > > > were stable
> > > > > > > > until we started to run our hardware monitoring 
> software. 
> > > > > > > > What it does, it
> > > > > > > > polls the status of all physical and logical 
> > driver through 
> > > > > > > > ioctl call.
> > > > > > > > Please see sample code below that would cause a 
> > > kernel panic. 
> > > > > > > >  The code was
> > > > > > > > working just fine until version 1.8f version of 
> megaraid 
> > > > > > > drivers, with
> > > > > > > > introduction of new driver it started to fail and cause 
> > > > > > > > kernel panics, which
> > > > > > > > kind of inconstant, sometimes it kills kernel swapper 
> > > > > > > > sometimes wait queues.
> > > > > > > > It seems like ioctl "M_RD_IOCTL_CMD " is totally 
> > broken, we 
> > > > > > > > can retrieve
> > > > > > > > correct number of adapters!
> > > > > > > >   by issuing ioctl suboption MEGAIOC_QNADAP.
> > > > > > > > 
> > > > > > > > Did any one ever seen this before, can you 
> please advice ?
> > > > > > > > 
> > > > > > > > Thank you !
> > > > > > > > 
> > > > > > > > Code that will panic the kernel, run it few times:
> > > > > > > > 
> > > > > > > > #include "megaraid.h"
> > > > > > > > 
> > > > > > > > int main()
> > > > > > > > {
> > > > > > > >         int         fd;
> > > > > > > >        struct uioctl_t uioctl;
> > > > > > > > 
> > > > > > > >        if ( (fd = open("/dev/megadev0", O_RDWR)) < 
> > > 0 && (fd =
> > > > > > > > open("/dev/megadev", O_RDWR)) < 0)
> > > > > > > >                 return -1;
> > > > > > > > 
> > > > > > > >         uioctl.inlen =  1024;
> > > > > > > >         uioctl.outlen = 1024;
> > > > > > > > 
> > > > > > > >         if(!(uioctl.data = malloc(1024))){
> > > > > > > >                 return 0;
> > > > > > > >         }
> > > > > > > >         memset(uioctl.data, 0, 1024);
> > > > > > > > 
> > > > > > > >         uioctl.ui.fcs.opcode     = M_RD_IOCTL_CMD;
> > > > > > > >         uioctl.ui.fcs.subopcode  = 0;
> > > > > > > >         uioctl.ui.fcs.adapno     = MKADAP(0);
> > > > > > > > 
> > > > > > > >         uioctl.mbox[0]           = FC_NEW_CONFIG;
> > > > > > > >         uioctl.mbox[2]           = NC_SUBOP_ENQUIRY3;
> > > > > > > >         uioctl.mbox[3]           = 
> > ENQ3_GET_SOLICITED_FULL;
> > > > > > > > 
> > > > > > > >         if(ioctl(fd, MEGAIOCCMD, &uioctl) == -1){
> > > > > > > >                 fprintf(stderr,"Error %d \n\n", 
> > > > > > > uioctl.ui.fcs.adapno);
> > > > > > > >                 fflush(stderr);
> > > > > > > >                 free(uioctl.data);
> > > > > > > >                 close(fd);
> > > > > > > >                 return 0;
> > > > > > > >         }
> > > > > > > > 
> > > > > > > >      close(fd);
> > > > > > > >  return 0;
> > > > > > > > }
> > > > > > > > 
> > > > > > > > 
> > > > > > > > Panic:
> > > > > > > > 1) 
> > > > > > > > ug 31 20:54:03 Analyzer kernel: EIP is at iput_free 
> > > > > [kernel] 0x1e
> > > > > > > > Aug 31 20:54:03 Analyzer kernel: eax: 2e0001e3   ebx: 
> > > > > > > f6880e40   ecx:
> > > > > > > > f6880e50   edx: f6880e50
> > > > > > > > Aug 31 20:54:03 Analyzer kernel: esi: f6880e40   edi: 
> > > > > > > 00000000   ebp:
> > > > > > > > 0008e000   esp: f7383f60
> > > > > > > > Aug 31 20:54:03 Analyzer kernel: ds: 0018   es: 0018  
> > > >  ss: 0018
> > > > > > > > Aug 31 20:54:03 Analyzer kernel: Process kswapd 
> (pid: 10,
> > > > > > > > stackpage=f7383000)
> > > > > > > > Aug 31 20:54:03 Analyzer kernel: Stack: 
> f587cb40 f5753b60 
> > > > > > > > c015a45c f587cb40
> > > > > > > > f393c3e0 f6880e40 00000006 c015a41b
> > > > > > > > Aug 31 20:54:03 Analyzer kernel:        
> f6880e40 f393c3f8 
> > > > > > > > f393c3e0 c015a806
> > > > > > > > f393c3e0 c02fa190 00000286 00000286
> > > > > > > > Aug 31 20:54:03 Analyzer kernel:        
> 00000000 f7382000 
> > > > > > > > 00000000 00000000
> > > > > > > > 00000000 00000000 00000000 00000000
> > > > > > > > Aug 31 20:54:03 Analyzer kernel: Call Trace: 
> > [dput+28/304] 
> > > > > > > > dput [kernel]
> > > > > > > > 0x1c (0xf7383f68)
> > > > > > > > Aug 31 20:54:03 Analyzer kernel: Call Trace: 
> [<c015a45c>] 
> > > > > > > > dput [kernel] 0x1c
> > > > > > > > (0xf7383f68)
> > > > > > > > Aug 31 20:54:03 Analyzer kernel: [dentry_iput+75/112] 
> > > > > > > > dentry_iput [kernel]
> > > > > > > > 0x4b (0xf7383f7c)
> > > > > > > > Aug 31 20:54:03 Analyzer kernel: [<c015a41b>] 
> dentry_iput 
> > > > > > > > [kernel] 0x4b
> > > > > > > > (0xf7383f7c)
> > > > > > > > Aug 31 20:54:03 Analyzer kernel: [prune_dcache+182/336] 
> > > > > > prune_dcache
> > > > > > > > [kernel] 0xb6 (0xf7383f8c)
> > > > > > > >  
> > > > > > > > 2)p  1 18:41:36 Analyzer kernel: Oops: 0000
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: Kernel 2.4.9-e.49smp
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: CPU:    1
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: EIP:    
> > > > > > > > 0010:[__wake_up+51/144]    Tainted:
> > > > > > > > P
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: EIP:    
> > > 0010:[<c01198a3>]    
> > > > > > > > Tainted: P
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: EFLAGS: 00010046
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: EIP is at __wake_up 
> > > > > [kernel] 0x33
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: eax: f688800c   ebx: 
> > > > > > > f6888014   ecx:
> > > > > > > > 00000001   edx: 00000000
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: esi: 00000001   edi: 
> > > > > > > f4c8a880   ebp:
> > > > > > > > f4f25a94   esp: f4f25a7c
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: ds: 0018   es: 0018  
> > > >  ss: 0018
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: Process snmpd 
> (pid: 626,
> > > > > > > > stackpage=f4f25000)
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: Stack: 
> 00000000 00000282 
> > > > > > > > 00000001 f4c8a880
> > > > > > > > f4c7f040 00000000 f4ec28c0 c01daad9
> > > > > > > > Sep  1 18:41:36 Analyzer kernel:        
> 00000002 00000026 
> > > > > > > > f4c7f178 00001060
> > > > > > > > 00007fff f4c7f178 c01ff422 f4c7f040
> > > > > > > > Sep  1 18:41:36 Analyzer kernel:        
> 00000000 c01fe2f4 
> > > > > > > > f4c7f040 f4c7f178
> > > > > > > > ffffffff f4a8f0c0 3a6ade00 00000000
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: Call Trace: 
> > > > > > > > [sock_def_readable+57/112]
> > > > > > > > sock_def_readable [kernel] 0x39 (0xf4f25a98)
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: Call Trace: 
> [<c01daad9>] 
> > > > > > > > sock_def_readable
> > > > > > > > [kernel] 0x39 (0xf4f25a98)
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: 
> > [tcp_data_queue+898/2688] 
> > > > > > > > tcp_data_queue
> > > > > > > > [kernel] 0x382 (0xf4f25ab4)
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: [<c01ff422>] 
> > > tcp_data_queue 
> > > > > > > > [kernel] 0x382
> > > > > > > > (0xf4f25ab4)
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: 
> > [tcp_ack+180/784] tcp_ack 
> > > > > > > > [kernel] 0xb4
> > > > > > > > (0xf4f25ac0)
> > > > > > > > Sep  1 18:41:36 Analyzer kernel: [<c01fe2f4>] tcp_ack 
> > > > > > [kernel] 0xb4
> > > > > > > > (0xf4f25ac0)
> > > > > > > > -
> > > > > > > > To unsubscribe from this list: send the line 
> "unsubscribe 
> > > > > > > > linux-scsi" in
> > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > More majordomo info at  
> > > > > http://vger.kernel.org/majordomo-info.html
> > > > > > > > 
> > > > > > > 
> > > > > > 
> > > > > 
> > > > 
> > > 
> > 
> 
