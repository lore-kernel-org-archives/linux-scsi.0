From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [BUG] modprobe qla2300 doesn't complete
Date: Wed, 10 Mar 2004 15:12:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040310221241.GA7903@colo.lackof.org>
References: <20040305041850.GA9124@colo.lackof.org> <20040305071721.GA9684@praka.local.home> <20040305172147.GB17305@colo.lackof.org> <20040309164033.GA21648@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:22759 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S262905AbUCJWMp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 17:12:45 -0500
Content-Disposition: inline
In-Reply-To: <20040309164033.GA21648@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>, Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org

On Tue, Mar 09, 2004 at 08:40:33AM -0800, Andrew Vasquez wrote:
> Ok, the driver is being flodded with RSCNs from the switch due to the
> JBOD hanging off of 0b10xx.  
> 
> There are three places where the driver could fall into stuck case of
> handling RSCNs.  The attached patch introduces behaviour consistent
> with what we have for several of our other platform drivers.  The end
> result is the will be 1) The driver will not hang during
> init/post-init due to the stream of RSCNs.  2) The driver after init,
> will *not* present any devices to the mid-layer due to the volatility
> within the fabric.

Still doesn't seem to make forward progress...console output appended.
(cut/pasted...white space is probably mangled)

And now the ssh sessions are "hung" (un responsive).
So I can't reboot the box to 'clear' the error.
We must be pretty close to a fix. :^)

thanks,
grant

gsyprf3:/usr/src/linux-ia64-2.5# sync
gsyprf3:/usr/src/linux-ia64-2.5# modprobe qla2300
QLogic Fibre Channel HBA Driver (a000000200324d90)
PCI: Found IRQ 66 for device 0000:80:01.0
IOSAPIC: vector 66 -> CPU 0x0100, enabled
qla2300 0000:80:01.0: Found an ISP2312, irq 66, iobase 0xc0000000c8041000
qla2300 0000:80:01.0: Configuring PCI space...
qla2300 0000:80:01.0: Configure NVRAM parameters...
qla2300 0000:80:01.0: Verifying loaded RISC code...
scsi(4): **** Load RISC code ****
scsi(4): Verifying Checksum of loaded RISC code.
scsi(4): Checksum OK, start firmware.
scsi(4): Issue init firmware.
scsi(4): Asynchronous LIP RESET (f7f7).
qla2300 0000:80:01.0: LIP reset occured (f7f7).
qla2300 0000:80:01.0: Waiting for LIP to complete...
scsi(4): Asynchronous P2P MODE received.
scsi(4): Asynchronous PORT UPDATE.
scsi(4): Port database changed 0000 0004.
scsi(4): Asynchronous LOOP UP (2 Gbps).
qla2300 0000:80:01.0: LOOP UP detected (2 Gbps).
scsi(4): Asynchronous PORT UPDATE ignored.
scsi(4): F/W Ready - OK 
scsi(4): fw_state=3 curr time=104c6bb1f.
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80040
scsi(4): RSCN queue entry[0] = [00/000000].
scsi(4): device_resync: rscn overflow.
scsi(4): RFT_ID exiting normally.
scsi(4): RFF_ID exiting normally.
scsi(4): RNN_ID exiting normally.
scsi(4): RSNN_NN exiting normally.
scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
scsi(4): device wrap (0b1f00)
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=4, mbx2=7, cmd=6f ****
qla2x00_login_fabric(4): failed=0 mb[0]=4005 mb[1]=4 mb[2]=7.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[0] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
scsi(4): device wrap (0b1f00)
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=4, mbx2=7, cmd=6f ****
qla2x00_login_fabric(4): failed=0 mb[0]=4005 mb[1]=4 mb[2]=7.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[3] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
scsi(4): device wrap (0b1f00)
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=4, mbx2=7, cmd=6f ****
qla2x00_login_fabric(4): failed=0 mb[0]=4005 mb[1]=4 mb[2]=7.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[7] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
scsi(4): device wrap (0b1f00)
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=4, mbx2=7, cmd=6f ****
qla2x00_login_fabric(4): failed=0 mb[0]=4005 mb[1]=4 mb[2]=7.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[14] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[23] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[24] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
scsi(4): device wrap (0b1f00)
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=4, mbx2=7, cmd=6f ****
qla2x00_login_fabric(4): failed=0 mb[0]=4005 mb[1]=4 mb[2]=7.
scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi(4): Configure loop -- dpc flags =0x80
scsi(4): RSCN queue entry[26] = [01/0b1000].
scsi(4): device_resync: rscn overflow.
scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
scsi(4): device wrap (0b1f00)
scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
scsi(4): Asynchronous RSCR UPDATE.
scsi(4): RSCN database changed -- 010b 1000.
...

