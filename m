From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [BUG] modprobe qla2300 doesn't complete
Date: Fri, 5 Mar 2004 10:21:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040305172147.GB17305@colo.lackof.org>
References: <20040305041850.GA9124@colo.lackof.org> <20040305071721.GA9684@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:26524 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S262043AbUCERVx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2004 12:21:53 -0500
Content-Disposition: inline
In-Reply-To: <20040305071721.GA9684@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>, linux-scsi@vger.kernel.org, Grant Grundler <grundler@parisc-linux.org>

On Thu, Mar 04, 2004 at 11:17:21PM -0800, Andrew Vasquez wrote:
...
> In the interim, could you just enable a couple of
> debug settings in the driver and rerun against the volitile fabric
> (just a short period, say 30 seconds), then send the /var/log/messages
> file.
...

appended. I've trimmed it down...full log is at:
ftp://gsyprf10.external.hp.com/kernels/rx2600/gsyprf3.log_qla2300_F_Port

BTW, this is running on an HP rx2600 (ia64) and both qla2312 ports
are connected to one HP FC16 (IIRC) switch. Three DS2405 disk enclosures
are also connected to the switch.  IIRC, only two are powered up.
Other HBAs/hosts are connected to the switch but I'm not actively using
any of them.

thanks,
grant

grundler@gsyprf3:/usr/src/linux-ia64-2.5$ uname -a
Linux gsyprf3.external.hp.com 2.6.4-rc1 #1 SMP Thu Mar 4 13:14:20 PST 2004 ia64 GNU/Linux
and than ran "modprobe qla2300"

...
Mar  5 08:03:16 gsyprf3 kernel: QLogic Fibre Channel HBA Driver (a000000200324d30)
Mar  5 08:03:16 gsyprf3 kernel: PCI: Found IRQ 66 for device 0000:80:01.0
Mar  5 08:03:16 gsyprf3 kernel: IOSAPIC: vector 66 -> CPU 0x0100, enabled
Mar  5 08:03:16 gsyprf3 kernel: qla2300 0000:80:01.0: Found an ISP2312, irq 66, iobase 0xc0000000c8041000
Mar  5 08:03:16 gsyprf3 kernel: qla2300 0000:80:01.0: Configuring PCI space...
Mar  5 08:03:16 gsyprf3 kernel: qla2300 0000:80:01.0: Configure NVRAM parameters...
Mar  5 08:03:16 gsyprf3 kernel: qla2300 0000:80:01.0: Verifying loaded RISC code...
Mar  5 08:03:16 gsyprf3 kernel: scsi(4): **** Load RISC code ****
Mar  5 08:03:16 gsyprf3 kernel: scsi(4): Verifying Checksum of loaded RISC code.
Mar  5 08:03:16 gsyprf3 kernel: scsi(4): Checksum OK, start firmware.
Mar  5 08:03:16 gsyprf3 kernel: scsi(4): Issue init firmware.
Mar  5 08:03:16 gsyprf3 kernel: scsi(4): Asynchronous LIP RESET (f7f7).
Mar  5 08:03:16 gsyprf3 kernel: qla2300 0000:80:01.0: LIP reset occured (f7f7).
Mar  5 08:03:16 gsyprf3 kernel: qla2300 0000:80:01.0: Waiting for LIP to complete...
Mar  5 08:03:16 gsyprf3 kernel: scsi(4): Asynchronous P2P MODE received.
Mar  5 08:03:17 gsyprf3 kernel: scsi(4): Asynchronous PORT UPDATE.
Mar  5 08:03:17 gsyprf3 kernel: scsi(4): Port database changed 0000 0004.
Mar  5 08:03:17 gsyprf3 kernel: scsi(4): Asynchronous LOOP UP (2 Gbps).
Mar  5 08:03:17 gsyprf3 kernel: qla2300 0000:80:01.0: LOOP UP detected (2 Gbps).
Mar  5 08:03:17 gsyprf3 kernel: scsi(4): Asynchronous PORT UPDATE ignored.
Mar  5 08:03:17 gsyprf3 kernel: scsi(4): F/W Ready - OK 
Mar  5 08:03:17 gsyprf3 kernel: scsi(4): fw_state=3 curr time=102690bd1.
Mar  5 08:03:17 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:03:17 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80040
Mar  5 08:03:17 gsyprf3 kernel: scsi(4): RSCN queue entry[0] = [00/000000].
Mar  5 08:03:17 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:03:17 gsyprf3 kernel: scsi(4): RFT_ID exiting normally.
Mar  5 08:03:17 gsyprf3 kernel: scsi(4): RFF_ID exiting normally.
Mar  5 08:03:17 gsyprf3 kernel: scsi(4): RNN_ID exiting normally.
Mar  5 08:03:17 gsyprf3 kernel: scsi(4): RSNN_NN exiting normally.
Mar  5 08:03:18 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:03:18 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:03:18 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:03:18 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:03:18 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:03:18 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:03:18 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:03:18 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:03:18 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:03:18 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:03:18 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:03:19 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:03:19 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:03:19 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:03:19 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:03:19 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:03:19 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:03:19 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:03:19 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:03:19 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:03:19 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:03:20 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:03:20 gsyprf3 kernel: scsi(4): device wrap (0b1f00)
Mar  5 08:03:20 gsyprf3 kernel: scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
Mar  5 08:03:21 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:03:21 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:03:22 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:03:22 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:03:24 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:03:24 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:03:25 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:03:25 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:03:40 gsyprf3 kernel: qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=4, mbx2=7, cmd=6f ****
Mar  5 08:03:40 gsyprf3 kernel: qla2x00_login_fabric(4): failed=0 mb[0]=4005 mb[1]=4 mb[2]=7.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:03:40 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): RSCN queue entry[0] = [01/0b1000].
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:03:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:03:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:03:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:03:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:03:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:03:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:03:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:03:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:03:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:03:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:03:41 gsyprf3 kernel: scsi(4): device wrap (0b1f00)
Mar  5 08:03:41 gsyprf3 kernel: scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
Mar  5 08:03:43 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:03:43 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:03:44 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:03:44 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:00 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:00 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:01 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:01 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:01 gsyprf3 kernel: qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=4, mbx2=7, cmd=6f ****
Mar  5 08:04:01 gsyprf3 kernel: qla2x00_login_fabric(4): failed=0 mb[0]=4005 mb[1]=4 mb[2]=7.
Mar  5 08:04:01 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:04:01 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:04:01 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:04:01 gsyprf3 kernel: scsi(4): RSCN queue entry[4] = [01/0b1000].
Mar  5 08:04:01 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:04:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:04:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:04:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:04:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:04:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:04:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:04:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:04:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:04:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:04:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:04:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:04:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:04:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:04:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:04:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:04:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:04:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:04:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:04:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:04:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:04:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:04:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:04:03 gsyprf3 kernel: scsi(4): device wrap (0b1f00)
Mar  5 08:04:03 gsyprf3 kernel: scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
Mar  5 08:04:06 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:06 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:08 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:08 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:10 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:10 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:11 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:11 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:13 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:13 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:15 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:15 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:17 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:17 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:21 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:21 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:23 gsyprf3 kernel: qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=4, mbx2=7, cmd=6f ****
Mar  5 08:04:23 gsyprf3 kernel: qla2x00_login_fabric(4): failed=0 mb[0]=4005 mb[1]=4 mb[2]=7.
Mar  5 08:04:23 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:04:23 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:04:23 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:04:23 gsyprf3 kernel: scsi(4): RSCN queue entry[8] = [01/0b1000].
Mar  5 08:04:23 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:04:23 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:04:23 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:04:23 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:04:23 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:04:23 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:04:23 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:04:23 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:04:24 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:04:24 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:04:24 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:04:24 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:04:24 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:04:24 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:04:24 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:04:24 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:04:25 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:04:25 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:04:25 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:04:25 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:04:25 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:04:25 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:04:25 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:04:25 gsyprf3 kernel: scsi(4): device wrap (0b1f00)
Mar  5 08:04:25 gsyprf3 kernel: scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
Mar  5 08:04:27 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:27 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:27 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:27 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:29 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:29 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:31 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:31 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:33 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:33 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:34 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:34 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:36 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:36 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:38 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:38 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:41 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:41 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:45 gsyprf3 kernel: qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=4, mbx2=7, cmd=6f ****
Mar  5 08:04:45 gsyprf3 kernel: qla2x00_login_fabric(4): failed=0 mb[0]=4005 mb[1]=4 mb[2]=7.
Mar  5 08:04:45 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:04:45 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:04:45 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:04:45 gsyprf3 kernel: scsi(4): RSCN queue entry[16] = [01/0b1000].
Mar  5 08:04:45 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:04:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:04:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:04:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:04:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:04:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:04:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:04:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:04:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:04:46 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:04:47 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): RSCN queue entry[25] = [01/0b1000].
Mar  5 08:04:47 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:04:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:04:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:04:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:04:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:04:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:04:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:04:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:04:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:04:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:04:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:04:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:04:49 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:04:50 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): RSCN queue entry[26] = [01/0b1000].
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:04:50 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:04:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:04:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:04:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:04:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:04:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:04:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:04:52 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:52 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:04:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:04:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:04:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:04:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:04:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:04:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:04:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:04:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:04:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:04:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:04:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:04:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:04:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:04:53 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:04:53 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:04:53 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:04:53 gsyprf3 kernel: scsi(4): RSCN queue entry[27] = [01/0b1000].
Mar  5 08:04:53 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:04:54 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:54 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:04:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:04:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:04:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:04:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:04:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:04:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:04:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:04:55 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:04:55 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:04:55 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:04:55 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:04:55 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:04:55 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:04:55 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:04:56 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:56 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:56 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:04:56 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:04:56 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:04:56 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:04:56 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:04:56 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:04:56 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:04:56 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:04:56 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:04:56 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:04:56 gsyprf3 kernel: scsi(4): RSCN queue entry[28] = [01/0b1000].
Mar  5 08:04:56 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:04:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:04:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:04:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:04:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:04:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:04:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:04:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:04:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:05:00 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:00 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:00 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:05:00 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:05:00 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:05:00 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:05:00 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:05:00 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:05:00 gsyprf3 kernel: scsi(4): RSCN queue entry[30] = [01/0b1000].
Mar  5 08:05:00 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:05:00 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:05:00 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:05:00 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:05:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:05:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:05:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:05:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:05:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:05:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:05:02 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:02 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:05:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:05:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:05:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:05:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:05:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:05:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:05:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:05:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:05:02 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:05:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:05:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:05:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:05:03 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:05:03 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:05:03 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:05:03 gsyprf3 kernel: scsi(4): RSCN queue entry[0] = [01/0b1000].
Mar  5 08:05:03 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:05:04 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:04 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:05:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:05:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:05:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:05:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:05:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:05:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:05:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:05:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:05:05 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:05:05 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:05:05 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:05:05 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:05:05 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:05:05 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:05:05 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:05:05 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:05:05 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:05:05 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:05:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:05:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:05:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:05:06 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:05:06 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:05:06 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:05:06 gsyprf3 kernel: scsi(4): RSCN queue entry[1] = [01/0b1000].
Mar  5 08:05:06 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:05:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:05:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:05:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:05:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:05:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:05:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:05:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:05:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:05:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:05:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:05:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:05:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:05:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:05:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:05:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:05:08 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:05:08 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:05:08 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:05:08 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:05:08 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:05:08 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:05:08 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:05:08 gsyprf3 kernel: scsi(4): device wrap (0b1f00)
Mar  5 08:05:08 gsyprf3 kernel: scsi(4): Trying Fabric Login w/loop id 0x0081 for port 0b10ce.
Mar  5 08:05:10 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:10 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:12 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:12 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:13 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:13 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:15 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:15 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:17 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:17 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:19 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:19 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:21 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:21 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:23 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:23 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:25 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:25 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:28 gsyprf3 kernel: qla2x00_mailbox_command(4): **** FAILED. mbx0=4005, mbx1=4, mbx2=7, cmd=6f ****
Mar  5 08:05:28 gsyprf3 kernel: qla2x00_login_fabric(4): failed=0 mb[0]=4005 mb[1]=4 mb[2]=7.
Mar  5 08:05:28 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:05:28 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:05:28 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:05:28 gsyprf3 kernel: scsi(4): RSCN queue entry[2] = [01/0b1000].
Mar  5 08:05:28 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:05:29 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:05:30 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:05:30 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:05:30 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:05:30 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:05:30 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:05:30 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:05:30 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:05:30 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:05:30 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:05:30 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:05:30 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:05:30 gsyprf3 kernel: scsi(4): RSCN queue entry[11] = [01/0b1000].
Mar  5 08:05:30 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:05:31 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:31 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:32 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:05:32 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:05:32 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:05:32 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:05:32 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:05:32 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:05:32 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:05:32 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:05:32 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:05:32 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:05:32 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:05:33 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:05:33 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:05:33 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:05:34 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): RSCN queue entry[12] = [01/0b1000].
Mar  5 08:05:34 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:05:36 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:36 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:38 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:38 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:38 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:05:38 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:05:38 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:05:38 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:05:38 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:05:38 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:05:38 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:05:38 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:05:38 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:05:38 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:05:39 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:39 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:39 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:05:39 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:05:39 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:05:39 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:05:39 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:05:39 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:05:39 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:05:39 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:05:39 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:05:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:05:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:05:40 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:05:40 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:05:40 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:05:40 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:05:40 gsyprf3 kernel: scsi(4): RSCN queue entry[14] = [01/0b1000].
Mar  5 08:05:40 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:05:41 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:41 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:05:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:05:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:05:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:05:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:05:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:05:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:05:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:05:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:05:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:05:41 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:05:42 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:05:42 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:05:42 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:05:42 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:05:42 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:05:42 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:05:42 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:05:43 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:43 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:43 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:05:43 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:05:43 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:05:43 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:05:43 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:05:43 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:05:43 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:05:43 gsyprf3 kernel: scsi(4): RSCN queue entry[17] = [01/0b1000].
Mar  5 08:05:43 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:05:43 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:05:43 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:05:44 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:05:44 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:05:44 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:05:44 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:05:44 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:05:44 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:05:44 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:05:45 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:45 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:05:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:05:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:05:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:05:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:05:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:05:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:05:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:05:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:05:45 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:05:46 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:05:46 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:05:46 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:05:46 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:05:46 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:05:46 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:05:46 gsyprf3 kernel: scsi(4): RSCN queue entry[19] = [01/0b1000].
Mar  5 08:05:46 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:05:46 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:05:46 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:05:46 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:05:46 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:05:46 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:05:47 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:47 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:05:47 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:05:48 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:48 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:05:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:05:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:05:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:05:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:05:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:05:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:05:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:05:48 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:05:49 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:05:49 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:05:49 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:05:49 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:05:49 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:05:49 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:05:49 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:05:49 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:05:49 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:05:49 gsyprf3 kernel: scsi(4): RSCN queue entry[20] = [01/0b1000].
Mar  5 08:05:49 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:05:50 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:50 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:05:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:05:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:05:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:05:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:05:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:05:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:05:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:05:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:05:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:05:51 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:05:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:05:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:05:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:05:52 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:05:53 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): RSCN queue entry[22] = [01/0b1000].
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:05:53 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:05:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:05:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:05:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:05:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:05:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:05:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:05:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:05:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:05:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:05:54 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:05:55 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:05:55 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:05:55 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:05:56 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:56 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:56 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:05:56 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:05:57 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:05:57 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:05:57 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:05:57 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:05:57 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:05:57 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:05:57 gsyprf3 kernel: scsi(4): RSCN queue entry[24] = [01/0b1000].
Mar  5 08:05:57 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:05:57 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:05:57 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:05:57 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:05:57 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:05:57 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:05:58 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:05:58 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:05:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:05:58 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:05:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:05:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:05:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:05:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:05:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:05:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:05:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:05:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:05:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:05:59 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:06:00 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:06:00 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:06:00 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:06:00 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:06:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:06:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:06:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:06:01 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:06:01 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:06:01 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:06:01 gsyprf3 kernel: scsi(4): RSCN queue entry[25] = [01/0b1000].
Mar  5 08:06:01 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:06:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:06:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:06:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:06:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:06:01 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:06:03 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:06:03 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:06:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:06:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:06:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:06:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:06:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:06:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:06:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:06:03 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:06:04 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:06:04 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:06:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:06:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:06:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:06:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:06:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:06:04 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:06:05 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:06:06 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): Configure loop -- dpc flags =0x80
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): RSCN queue entry[27] = [01/0b1000].
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): device_resync: rscn overflow.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00001cab39 pn 50060b00001e386f portid=0b10ce.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e35bb8 pn 2200002037e35bb8 portid=0b10d3.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e329dd pn 2200002037e329dd portid=0b10d4.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33bd9 pn 2200002037e33bd9 portid=0b10d5.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf03a6 pn 22000004cfcf03a6 portid=0b10d6.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037e33667 pn 2200002037e33667 portid=0b10d9.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 2000002037d943bb pn 2200002037d943bb portid=0b10e1.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f539 pn 22000004cf87f539 portid=0b10e4.
Mar  5 08:06:06 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf096b pn 22000004cfcf096b portid=0b10e8.
Mar  5 08:06:07 gsyprf3 kernel: scsi(4): Asynchronous RSCR UPDATE.
Mar  5 08:06:07 gsyprf3 kernel: scsi(4): RSCN database changed -- 010b 1000.
Mar  5 08:06:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d81f pn 22000004cf87d81f portid=0b10ef.
Mar  5 08:06:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d77d pn 22000004cf87d77d portid=0b189f.
Mar  5 08:06:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d75a pn 22000004cf87d75a portid=0b18a3.
Mar  5 08:06:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02c4 pn 22000004cfcf02c4 portid=0b18a5.
Mar  5 08:06:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf099a pn 22000004cfcf099a portid=0b18a6.
Mar  5 08:06:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87d7f6 pn 22000004cf87d7f6 portid=0b18a7.
Mar  5 08:06:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cf87f614 pn 22000004cf87f614 portid=0b18ac.
Mar  5 08:06:07 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0460 pn 22000004cfcf0460 portid=0b18ad.
Mar  5 08:06:08 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf0407 pn 22000004cfcf0407 portid=0b18ae.
Mar  5 08:06:08 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b1 pn 22000004cfcf02b1 portid=0b18b1.
Mar  5 08:06:08 gsyprf3 kernel: scsi(4): GID_PT entry - nn 20000004cfcf02b3 pn 22000004cfcf02b3 portid=0b18b2.
Mar  5 08:06:08 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28f pn 50060b00641cc28e portid=0b1e00.
Mar  5 08:06:08 gsyprf3 kernel: scsi(4): GID_PT entry - nn 50060b00641cc28d pn 50060b00641cc28c portid=0b1f00.
Mar  5 08:06:08 gsyprf3 kernel: scsi(4): Loop down counter running= 0 or Resync needed- dpc flags= 144
Mar  5 08:06:08 gsyprf3 kernel: qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
...
