Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,HK_RANDOM_REPLYTO,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CC4C43460
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 15:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2EC76113A
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 15:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhDJP13 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 11:27:29 -0400
Received: from mout.perfora.net ([74.208.4.194]:59099 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234768AbhDJP12 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 10 Apr 2021 11:27:28 -0400
Received: from [192.168.0.156] ([108.168.115.113]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MAP5I-1lPEyp2gVG-00BbQc
 for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 17:27:13 +0200
From:   TomK <tomkcpr@mdevsys.com>
Subject: QLE2432 initiator fails to see any LUN's on one of servers while
 using 5QLE2464 as a target.
Reply-To: tomkcpr@mdevsys.com
To:     linux-scsi@vger.kernel.org
Message-ID: <912519f2-69f7-b31a-8c25-af6254e5d0d3@mdevsys.com>
Date:   Sat, 10 Apr 2021 11:27:12 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:CGAhHsJQrLmAGb3AtPL9Q/u+nvW4a14w8Z+LFnh0Rd0+FVQ0C2w
 39lOGlFLm8iBzpOyfZ7BbCgepafnhRr4f7N/lpaJCSCRHSB9Sub/dy8zdVOYUVvQ6/meWr6
 R0gxgfUixt+Rq6WCuvCEd3Nyuow4lYTRm7KNY97pUh9YP1Vvap7nbHcOHMXn5SLWSjfwnCS
 3XoZg8DWGUc8owsqHUIyw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:o+Wpu58l3Jg=:DtIq74DCCyWIJBgB6FRc2x
 FuCwFv8leKP8emCejWwTQHuYkPnjZ6ymYju5/63SIoS10ZJGB+IDBQAntNVsn2/YKKAD57uhv
 8A6WScShvjVvqXbAH25VZd4V1iJLq9iXHtQtqjEOr13vaL+yPolKUsybfaqKg8mhsA4rmV+wA
 NyP23ASgQaNB0JFDXYpbgcSGZO0pBO5DkNJgABAVtwRyrQ0w6FHQLpkfaNJ0wBVfh7jvn+7eh
 F0RSKLWOuDzT2K71gcK+M7Fid0qEK/jnva8N1wJUvt2EUn9zOhH3npo06Pa+PIbwKfXXPL+P4
 98QTC761OEeyeqpvFkvV6fs/C1bCQPLhfqtWUVNzZoyAJkfWeDuNfVg8yX326ZnmwmHkf4ZqJ
 SR+Ky2AVDjy4wnBTdo/jrHvdqVlLspUBn+YDcSRIHdjA77KCetRfcTRhBIFT2lBGcFfOglRzv
 0/9Ju32NyaBnOl/7jMeZK1FqOXkRVfeSm8C5v3VxmtXOVxIfUbLy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey Everyone,

In a basic SAN config using a few QLE2432 adapters connected to a target 
using a QLE2464 adapter via a EMC Brocade 5000B switch, one of the 
initiators fails to present a LUN after being online for sometime.  Over 
a period of time, few months, the initiator on one of the hosts stops 
showing available LUN's to the underlying VMware clients.

All the other hosts are fine, except for this specific one.  Unless that 
is, I reboot the target completely, affecting all the other working 
hosts in the process.

Digging a bit closer, I notice that the issue seems to strike an uncanny 
similarity to the following one:

ht tps://www.spinics.net/lists/linux-scsi/msg136622.html

However, I'm wondering why only one of the servers is affected and not 
the others?  Seems it is a card issue with the first host (please see 
image) however I'm not familiar with all the messages printed so can't 
be sure of the reason nor link things as effectively. Neither of the two 
ports of the HBA on Server 1 work, when in this disconnected state, 
despite switching SFP's on the Brocade switch, switching cables etc. 
That is, again, until I reboot the target entirely.

Initiator:
                  50:01:43:80:16:77:99:38; 50:01:43:80:16:77:99:3a;
                  50:01:43:80:16:77:99:3b; 50:01:43:80:16:77:99:39

Target:
		(see below)

This also started to happen a few months ago.  Everything was fine for a 
few years before that.


Log snippet:

Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e818: 
is_send_status=1, cmd->bufflen=73728, cmd->sg_cnt=0, 
cmd->dma_data_direction=2 se_cmd[00000000cc1dc466] qp 0
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e874:2: 
qlt_free_cmd: se_cmd[00000000cc1dc466] ox_id 00e1
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:2: 
qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0110
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e818: 
is_send_status=1, cmd->bufflen=10240, cmd->sg_cnt=0, 
cmd->dma_data_direction=2 se_cmd[00000000cc1dc466] qp 0
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e874:2: 
qlt_free_cmd: se_cmd[00000000cc1dc466] ox_id 0110
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:2: 
qlt_24xx_atio_pkt_all_vps: qla_target(0): type d ox_id 0000
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e82e:2: 
IMMED_NOTIFY ATIO
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f826:2: 
qla_target(0): Port ID: 01:09:00 ELS opcode: 0x03 lid 7 
50:01:43:80:16:77:99:3a
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f897:2: Linking 
sess 00000000088a6dfa [0] wwn 50:01:43:80:16:77:99:3a with PLOGI ACK to 
wwn 50:01:43:80:16:77:99:3a s_id 01:09:00, ref=1 pla 000000004bdf1d76 link 0
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28f9:2: 
qlt_handle_login 4772 50:01:43:80:16:77:99:3a  DS 8
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28f9:2: 
qlt_handle_login 4803 50:01:43:80:16:77:99:3a post del sess
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e801:2: 
Scheduling sess 00000000088a6dfa for deletion
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f826:2: 
qla_target(0): Exit ELS opcode: 0x03 res 0
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-290a:2: 
qlt_unreg_sess sess 00000000088a6dfa for deletion 50:01:43:80:16:77:99:3a
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-287d:2: FCPort 
50:01:43:80:16:77:99:3a state transitioned from ONLINE to LOST - 
portid=010900.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28a3:2: Port 
login retry 500143801677993a, lid 0x0007 retry cnt=45.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f884:2: 
qlt_free_session_done: se_sess 000000001f2eac78 / sess 00000000088a6dfa 
from port 50:01:43:80:16:77:99:3a loop_id 0x07 s_id 01:09:00 logout 1 
keep 1 els_logo 0
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f886:2: 
qlt_free_session_done: waiting for sess 00000000088a6dfa logout
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2870:2: 
Async-logout - hdl=172 loop-id=7 portid=010900 50:01:43:80:16:77:99:3a.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-5836:2: 
Async-logout complete - 50:01:43:80:16:77:99:3a hdl=172 portid=010900 
iop0=0.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f893:2: 
qlt_logo_completion_handler: se_sess 000000001f2eac78 / sess 
00000000088a6dfa from port 50:01:43:80:16:77:99:3a loop_id 0x07 s_id 
01:09:00 LOGO failed: 0x0
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:2: 
qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 008a
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e818: 
is_send_status=1, cmd->bufflen=4096, cmd->sg_cnt=0, 
cmd->dma_data_direction=2 se_cmd[00000000cc1dc466] qp 0
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e874:2: 
qlt_free_cmd: se_cmd[00000000cc1dc466] ox_id 008a
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-680b:2: 
isp_abort_needed=0 loop_resync_needed=0 fcport_update_needed=0 
start_dpc=0 reset_marker_needed=0
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-680c:2: 
beacon_blink_needed=0 isp_unrecoverable=0 fcoe_ctx_reset_needed=0 
vp_dpc_needed=0 relogin_needed=1.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-4801:2: DPC 
handler waking up, dpc_flags=0x100.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-480d:2: Relogin 
scheduled.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-4800:2: DPC 
handler sleeping.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2908:2: 
qla2x00_relogin 21:01:00:1b:32:a1:81:21 DS 0 LS 7
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2902:2: 
qla24xx_handle_relogin_event 21:01:00:1b:32:a1:81:21 DS 0 LS 7 P 0 del 2 
cnfl           (null) rscn 0|0 login 0|0 fl 3
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28d8:2: 
qla24xx_fcport_handle_login 21:01:00:1b:32:a1:81:21 DS 0 LS 7 P 0 fl 3 
confl           (null) rscn 0|0 login 0 retry 45 lid 4096 scan 2
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2908:2: 
qla2x00_relogin 50:01:43:80:16:77:99:38 DS 3 LS 4
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2902:2: 
qla24xx_handle_relogin_event 50:01:43:80:16:77:99:38 DS 3 LS 4 P 0 del 1 
cnfl           (null) rscn 0|0 login 4|18 fl 1
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28d8:2: 
qla24xx_fcport_handle_login 50:01:43:80:16:77:99:38 DS 3 LS 4 P 0 fl 1 
confl           (null) rscn 0|0 login 18 retry 45 lid 4 scan 2
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2908:2: 
qla2x00_relogin 50:01:43:80:16:77:99:3a DS 10 LS 3
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2902:2: 
qla24xx_handle_relogin_event 50:01:43:80:16:77:99:3a DS 10 LS 3 P 0 del 
1 cnfl           (null) rscn 0|0 login 8|9 fl 1
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-480e:2: Relogin end.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f887:2: 
qlt_free_session_done: sess 00000000088a6dfa logout completed
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f89a:2: se_sess 
          (null) / sess 00000000088a6dfa port 50:01:43:80:16:77:99:3a is 
gone, releasing own PLOGI (ref=1)
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-5889:2: Sending 
PLOGI ACK to wwn 50:01:43:80:16:77:99:3a s_id 01:09:00 loop_id 0x07 exch 
0x11223c ox_id 0xae
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f801:2: 
Unregistration of sess 00000000088a6dfa 50:01:43:80:16:77:99:3a finished 
fcp_cnt 4
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28f4:2: 
Async-nack 50:01:43:80:16:77:99:3a hndl 175 PLOGI
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28f2:2: Async 
done-nack res 0 50:01:43:80:16:77:99:3a  type 16
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-5811:2: 
Asynchronous PORT UPDATE ignored 0007/0004/0600.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f83d:2: 
qla_target(0): Port update async event 0x8014 occurred: updating the 
ports database (m[0]=8014, m[1]=7, m[2]=4, m[3]=600)
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f83e:2: Async MB 
2: Got PLOGI Complete





Thanks,




Seems similar to this issue:
ht tps://www.spinics.net/lists/linux-scsi/msg136470.html


Log link:

ht 
tps://www.microdevsys.com/WordPressDownloads/qla2xxx-hba.log-recent.start.end.event.txt

Infra Setup (image):

ht tps://www.microdevsys.com/WordPressImages/brocade-san-issue.png



Adapter details on the target.

# QLogic Corp. ISP2432-based 4Gb Fibre Channel to PCI Express HBA ^C
You have mail in /var/spool/mail/root



[root@mbpc-pc 1]# lspci -vvv -s 03:00.0
03:00.0 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to 
PCI Express HBA (rev 03)
          Subsystem: QLogic Corp. Device 0146
          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
          Latency: 0, Cache Line Size: 64 bytes
          Interrupt: pin A routed to IRQ 18
          Region 0: I/O ports at ee00 [size=256]
          Region 1: Memory at fdffc000 (64-bit, non-prefetchable) [size=16K]
          [virtual] Expansion ROM at fdf00000 [disabled] [size=256K]
          Capabilities: [44] Power Management version 2
                  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                  Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
          Capabilities: [4c] Express (v1) Endpoint, MSI 00
                  DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency 
L0s <4us, L1 <1us
                          ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
                  DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+ 
Unsupported+
                          RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                          MaxPayload 128 bytes, MaxReadReq 4096 bytes
                  DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ 
AuxPwr- TransPend-
                  LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, 
Latency L0 <4us, L1 unlimited
                          ClockPM- Surprise- LLActRep- BwNot-
                  LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk-
                          ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                  LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- 
SlotClk+ DLActive- BWMgmt- ABWMgmt-
          Capabilities: [64] MSI: Enable- Count=1/16 Maskable- 64bit+
                  Address: 0000000000000000  Data: 0000
          Capabilities: [74] Vital Product Data
                  Product Name: PCI-Express Quad Channel 4Gb Fibre 
Channel HBA
                  Read-only fields:
                          [PN] Part number: QLE2464
                          [SN] Serial number: GFC0840A74113
                          [V0] Vendor specific: PW=15W
                          [MN] Manufacture ID: 50 58 32 36 31 30 34 30 
31 2d 31 31 20 20 41
                          [V1] Vendor specific: 06.12
                          [V3] Vendor specific: 08.01.02
                          [V4] Vendor specific: 03.29
                          [V5] Vendor specific: 03.23
                          [YA] Asset tag:
                          [RV] Reserved: checksum good, 0 byte(s) reserved
                  End
          Capabilities: [7c] MSI-X: Enable- Count=16 Masked-
                  Vector table: BAR=1 offset=00002000
                  PBA: BAR=1 offset=00003000
          Capabilities: [100 v1] Advanced Error Reporting
                  UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                  UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                  UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                  CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                  CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                  AERCap: First Error Pointer: 14, GenCap+ CGenEn- 
ChkCap+ ChkEn-
          Capabilities: [138 v1] Power Budgeting <?>
          Kernel driver in use: qla2xxx



Target details:


[root@mbpc-pc 1]# systool -c fc_host -v
Class = "fc_host"

    Class Device = "host0"
    Class Device path = 
"/sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:00.0/0000:03:00.0/host0/fc_host/host0"
      dev_loss_tmo        = "45"
      fabric_name         = "0xffffffffffffffff"
      issue_lip           = <store method only>
      max_npiv_vports     = "127"
      node_name           = "0x2002001b32c18121"
      npiv_vports_inuse   = "0"
      port_id             = "0x000000"
      port_name           = "0x2102001b32c18121"
      port_state          = "Linkdown"
      port_type           = "Unknown"
      speed               = "unknown"
      supported_classes   = "Class 3"
      supported_speeds    = "1 Gbit, 2 Gbit, 4 Gbit"
      symbolic_name       = "QLE2464 FW:v8.06.02 DVR:v10.00.00.07-k-debug"
      system_hostname     = ""
      tgtid_bind_type     = "wwpn (World Wide Port Name)"
      uevent              =
      vport_create        = <store method only>
      vport_delete        = <store method only>

      Device = "host0"
      Device path = 
"/sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:00.0/0000:03:00.0/host0"
        fw_dump             =
        issue_logo          = <store method only>
        nvram               = "ISP "
        optrom_ctl          = <store method only>
        optrom              =
        reset               = <store method only>
        sfp                 = ""
        uevent              = "DEVTYPE=scsi_host"
        vpd                 = "▒."


    Class Device = "host1"
    Class Device path = 
"/sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:00.0/0000:03:00.1/host1/fc_host/host1"
      dev_loss_tmo        = "45"
      fabric_name         = "0xffffffffffffffff"
      issue_lip           = <store method only>
      max_npiv_vports     = "127"
      node_name           = "0x2003001b32e18121"
      npiv_vports_inuse   = "0"
      port_id             = "0x000000"
      port_name           = "0x2103001b32e18121"
      port_state          = "Linkdown"
      port_type           = "Unknown"
      speed               = "unknown"
      supported_classes   = "Class 3"
      supported_speeds    = "1 Gbit, 2 Gbit, 4 Gbit"
      symbolic_name       = "QLE2464 FW:v8.06.02 DVR:v10.00.00.07-k-debug"
      system_hostname     = ""
      tgtid_bind_type     = "wwpn (World Wide Port Name)"
      uevent              =
      vport_create        = <store method only>
      vport_delete        = <store method only>

      Device = "host1"
      Device path = 
"/sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:00.0/0000:03:00.1/host1"
        fw_dump             =
        issue_logo          = <store method only>
        nvram               = "ISP "
        optrom_ctl          = <store method only>
        optrom              =
        reset               = <store method only>
        sfp                 = ""
        uevent              = "DEVTYPE=scsi_host"
        vpd                 = "▒."


    Class Device = "host2"
    Class Device path = 
"/sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:01.0/0000:04:00.0/host2/fc_host/host2"
      dev_loss_tmo        = "45"
      fabric_name         = "0x100000051e903dab"
      issue_lip           = <store method only>
      max_npiv_vports     = "127"
      node_name           = "0x2000001b32818121"
      npiv_vports_inuse   = "0"
      port_id             = "0x011300"
      port_name           = "0x2100001b32818121"
      port_state          = "Online"
      port_type           = "NPort (fabric via point-to-point)"
      speed               = "4 Gbit"
      supported_classes   = "Class 3"
      supported_speeds    = "1 Gbit, 2 Gbit, 4 Gbit"
      symbolic_name       = "QLE2464 FW:v8.06.02 DVR:v10.00.00.07-k-debug"
      system_hostname     = ""
      tgtid_bind_type     = "wwpn (World Wide Port Name)"
      uevent              =
      vport_create        = <store method only>
      vport_delete        = <store method only>

      Device = "host2"
      Device path = 
"/sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:01.0/0000:04:00.0/host2"
        fw_dump             =
        issue_logo          = <store method only>
        nvram               = "ISP "
        optrom_ctl          = <store method only>
        optrom              =
        reset               = <store method only>
        sfp                 = ""
        uevent              = "DEVTYPE=scsi_host"
        vpd                 = "▒."


    Class Device = "host3"
    Class Device path = 
"/sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:01.0/0000:04:00.1/host3/fc_host/host3"
      dev_loss_tmo        = "45"
      fabric_name         = "0x100000051e903dab"
      issue_lip           = <store method only>
      max_npiv_vports     = "127"
      node_name           = "0x2001001b32a18121"
      npiv_vports_inuse   = "0"
      port_id             = "0x011700"
      port_name           = "0x2101001b32a18121"
      port_state          = "Online"
      port_type           = "NPort (fabric via point-to-point)"
      speed               = "4 Gbit"
      supported_classes   = "Class 3"
      supported_speeds    = "1 Gbit, 2 Gbit, 4 Gbit"
      symbolic_name       = "QLE2464 FW:v8.06.02 DVR:v10.00.00.07-k-debug"
      system_hostname     = ""
      tgtid_bind_type     = "wwpn (World Wide Port Name)"
      uevent              =
      vport_create        = <store method only>
      vport_delete        = <store method only>

      Device = "host3"
      Device path = 
"/sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:01.0/0000:04:00.1/host3"
        fw_dump             =
        issue_logo          = <store method only>
        nvram               = "ISP "
        optrom_ctl          = <store method only>
        optrom              =
        reset               = <store method only>
        sfp                 = ""
        uevent              = "DEVTYPE=scsi_host"
        vpd                 = "▒."


[root@mbpc-pc 1]#




-- 
Thx,
TK.

