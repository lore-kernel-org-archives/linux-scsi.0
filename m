From: Matej Kenda <matejkenda@REMOVE.volja.net.hermes.si>
Subject: Re: 2.4.1[89]: SMP computer hangs when accessing tape drive via scsi
 generic
Date: Tue, 08 Oct 2002 16:55:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DA2F1DC.4040500@REMOVE.volja.net>
References: <3D9848FD.6040007@REMOVE.volja.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

Hi Gilbert,

I have been wrestling with this problem for quite a while, using different 
computers (UP, SMP), connecting tape drives to SCSI sdapters in different ways 
(one drive per adapter, multiple drives per adapter, etc).

I have also tried to use different Linux distributions with different kernel 
versions:

* RedHat 7.3 with vanilla 2.4.18 + EA patch
* RedHat 8.0 with RedHat's 2.8.18 kernel
* SuSE Linux Enterprise Edition B3 with SuSE's 2.4.19 kernel

I came to the conclusion that the "lethal" combination that displays kernel 
oops and the machine hangs is:

* SMP computer,
* scsi generic direct I/O turned on (/proc/scsi/sg/allow_dio)

All other combinations are irrelevant.

For now, I won't use the direct I/O feature of SG. If you need any help on 
locationg the cause of the problem, I will be happy to assist.

I hope that this information will be of any help to you.

Best regards,

Matej

Matej Kenda wrote:
> Hi,
> 
> We have experienced major problems dealing with tape drives via SCSI 
> generic driver on RedHat ((null)) and SuSE Linux Enterprise Server 8 
> Beta3. The computer just hangs without logging anything to the 
> /var/log/messages.
> 
> On RedHat ((null)) we got the stack trace on the screen and managed to 
> get some more information.
> 
> Manually copied stack trace (last function on top):
> 
> sg_cmd_done_bh
> sg_common_write
> scsi_insert_special_req
> scsi_insert_special
> ahc_linux_run_device_queue (+offset 666)
> pci_map_sg (asm-386/pci.h)
> 
> Macro BUG() is called in that function, because one of the parameters is 
> not OK. We were not able to detect which parameter was not OK.
> 
> The application that we develop was writing one 64kB and one 32kB block 
> of data via sg using direct IO flag at the time of the hang.
> 

