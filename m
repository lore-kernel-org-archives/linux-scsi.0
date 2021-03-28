Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,HK_RANDOM_REPLYTO,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA71AC433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Mar 2021 21:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 753FA61958
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Mar 2021 21:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhC1Vyn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Mar 2021 17:54:43 -0400
Received: from mout.perfora.net ([74.208.4.197]:48451 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231511AbhC1VyR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 28 Mar 2021 17:54:17 -0400
Received: from [192.168.0.186] ([108.168.115.113]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0LlU7F-1m1cXK47R1-00bMqq
 for <linux-scsi@vger.kernel.org>; Sun, 28 Mar 2021 23:54:14 +0200
To:     linux-scsi@vger.kernel.org
Reply-To: tomkcpr@mdevsys.com
From:   TomK <tomkcpr@mdevsys.com>
Subject: QLE2432 initiator fails to see any LUN's on one of servers while
 using 5QLE2464 as a target.
Message-ID: <8b378821-59bd-ebca-e7e9-b9a2219d124e@mdevsys.com>
Date:   Sun, 28 Mar 2021 17:54:11 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------47EB76A1A5D5C0DA2C4D1F4E"
Content-Language: en-US
X-Provags-ID: V03:K1:IkLmjA1cgR9//1Bd4Arjdeypkd42TRaDaCMImvNjHZWnutrx/4l
 ZlhE5i5iQ0IU684BAG6FKgGJpaqrGFDJbxg2Li3vvsONqJzd1bk8TrBhZAybXMmZzvQqDMh
 72AJc38P2BE5vdELK0qIXmxoJKlBiitdleuLkZoHtpAvQ97Ft/lr/iJOJuyQixJ5xXiBVxf
 W/V5PpjsuE59q0lgrbc3A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:AxJUYhteBx8=:hG3ZxH4e63itBaEXpLGMM1
 tigCvR1Onc/zcRFTg0sXb7ucz0rB+v8+alTx/gTPbYL4XS82VpTwmKfPjHCYlFnxAXThk7SEq
 9lDqdn/MbRHCQ1xmFSJacZoh720wqQO9V/FptmUV6ChUXnYMykIJrEifjr4+hwh+Rl4L4x6ro
 iCTc/+L12yeQ8BLPlIrvfRUHTLw2gKpROucai+GRR969bxHC/eeeTM/Js/B9DoPkarNg26PT0
 zLkV31aZ3bHk38RYPJEvrEf3EDrsok+29DSFLcWUGyvCM3Bl/d9s69S3Tk4+WezfJ/jap4gwB
 jyu3+Nw87k5P3kqpVrbL+tvKGG6NAU+Rj/tyClIEITs9gsfQOriaT8QtSkLocJDcNaHCCrvK7
 MZhNrOtIX00bB8Jo5hIA8JmXBI87cPKAv46/lRnpca80GXyRF8IBwLPZFfLXcUXzKOuQ1dtNm
 IL00B5oQm+4HCJ0A+5GzWF/3GMbW5Um/SzwOfa414aTRiLr5b5th
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------47EB76A1A5D5C0DA2C4D1F4E
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

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

https://www.spinics.net/lists/linux-scsi/msg136622.html

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
https://www.spinics.net/lists/linux-scsi/msg136470.html


Log link:

https://www.microdevsys.com/WordPressDownloads/qla2xxx-hba.log-recent.start.end.event.txt


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
                 DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency L0s 
<4us, L1 <1us
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
                 LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         Capabilities: [64] MSI: Enable- Count=1/16 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [74] Vital Product Data
                 Product Name: PCI-Express Quad Channel 4Gb Fibre 
Channel HBA
                 Read-only fields:
                         [PN] Part number: QLE2464
                         [SN] Serial number: GFC0840A74113
                         [V0] Vendor specific: PW=15W
                         [MN] Manufacture ID: 50 58 32 36 31 30 34 30 31 
2d 31 31 20 20 41
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

--------------47EB76A1A5D5C0DA2C4D1F4E
Content-Type: image/png;
 name="brocade-san-issue.png"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="brocade-san-issue.png"

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
tW5+kD1lrbFbbN/fau5trgzHB531tXaz2YxrQflZ4Wnt/itN0uBsGj7NIMQuK3eudfsus791
P+nYCfX7P3NvYzluPk3h2Nfu91934IqYReGQj3qM1Vd45kj9kLxfhzurcfP86Z3Ibmv4p/Hg
hTt7rVar0b47kz+lH3v3h556+6W4ciSXHnvyKz/169m//99/9Zuv/e434taZISucEbF/4TzE
qxAA4PQJDS+2EAA0Wje6edTqTk02tbqz22rs3XkhxCbLG/d6gcjyxo1WYyg+CFlaa/f2tbia
Kz+reNreg/3u2rgGZ1PVaeYJaLu5tZ/0YzjDkwn9QkunF0cdbN9sN1q7pUOtvSIWTfkKv8j9
kFq9vtUc+GnMM8Nnd56d1dTwqbdf+o0f/6Xs39GiwyceffwX3v3BuDKHYqIgUwAAAE6C0PBi
W376yoQR3crlwYK6QtjevLwS14KQuDS3ro8Mtg5evh+Xhgw3OOSgN7A0qf4qDawsb+/vnYyo
LO2dlFL1t4+ud6w+zYEUtlbNKYwXDi89sMqmst2ytXgu3f3rTrmrc2tzb/Q713+tmj6rPYZM
6SkjHsqUmqs8zr5wPGvtRmNvcyXZu/Sej22jq3+Fj++HCeWHkR5Uvlacfv8g6zqt+9TqDimd
ZH9r5cbjSX4ai8xwtbE6s6lhrogO3/uOH4jrE3ji0cf/8Xs/+tL7f/l97/zhuGl+xKRQVggA
AJwooeEFV5QSrY1PGPYf7MWlRB6SXXm6n5EdbD+32di6PTI1C/vUpTJDDQ5pr608uJF/QS4P
njzYvnrzchxUub/V6G3vrK9sXoljn3cbN2M601lf6o2IDgNTu6lN2N5uFQ/sNtZCHlWt5jSL
zPDZcXFT9SkcSX1T2Vrskbwyse6U+/Ikd1TXt9eea9wOz0+Gl9f1fNA/hnREeqbuofHHWRIK
L3dbvfG0RQlmdkD99zxvY6L8rHeFj+2HieV1s+21/NXzi761260SzU7/eG9c5YVdfbUfXR6f
Xnum3xXhAi9CxBlPDXOTDFUussKv/NSvz0tcmL21cUlWCAAAnLb4nYPzFt+Prrj1dISYJSZj
uf2tbo1Vf2vY1ru1WbFD+SlRKbAplJrOn1R+TngsSp5TNtRgavDIB9ejfitDBxEk51ZeHXz1
muaTB5JXSF8u7NXT3TrYZs1r5C2VdA+rvPuIpsJi+UxqT7kkPfgBA681+NJd5dcd8ZTah+qP
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
dRRaup1jJqSFNV1d3MywNKg73uJxREYLAAAAAEuHh4dxkXN1sH115c61/X6qGWoc72+VNgAA
AADAmTiPexpSpzd5chxXXBqRDQAAAABnRaXhDEnvn9hUZQgAAADAuRAaAgAAAAAJw5MBAAAA
gITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABI
CA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQ
EAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0B
AAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAA
AABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAA
gITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABI
CA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQ
EAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0B
AAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAA
AABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAA
gITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABI
CA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQ
EAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0B
AAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAA
AABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAA
gITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABI
CA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQ
EAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0B
AAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAA
AABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAA
gITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABI
CA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQ
EAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0B
AAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAA
AABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAA
gITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABI
CA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQ
EAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0B
AAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAA
AABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAA
gITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABI
CA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQ
EAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0B
AAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAA
AABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAA
gITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABI
CA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQ
EAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0B
AAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAA
AABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAA
gITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABI
CA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQ
EAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0B
AAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAA
AABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAA
gITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABI
CA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQ
EAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0B
AAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAA
AABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAA
gITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABI
CA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQ
EAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0B
AAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEAAA
AABICA0BAAAAgITQEAAAAABICA0BAAAAgITQEOD/344dEwAAwDAMqn/VexcPIAMAAAAgpCEA
AAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQh
AAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCk
IQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAg
pCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAA
IKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAA
ACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAA
AAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMA
AAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhD
AAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBI
QwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABA
SEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAA
QEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAA
AEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAA
AABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYA
AAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCG
AAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQ
hgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACA
kIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAA
gJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAA
AICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEA
AACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0B
AAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACEN
AQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAh
DQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAA
IQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAA
ACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAA
AAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIA
AAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoC
AAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIa
AgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABC
GgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAA
QhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAA
AEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAA
AABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQA
AAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQE
AAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0
BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACE
NAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAA
hDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAA
AIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAA
AACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgA
AAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkI
AAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhp
CAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAI
aQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAA
CGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAA
AAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAA
AAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAA
AAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQ
AAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDS
EAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ
0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAA
ENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAA
ABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAA
AAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEA
AAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQh
AAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCk
IQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAg
pCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAA
IKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAA
ACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAA
AAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMA
AAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhD
AAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBI
QwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABA
SEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAA
QEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAA
AEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAA
AABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYA
AAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCG
AAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQ
hgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACA
kIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAA
gJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAA
AICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEA
AACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0B
AAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACEN
AQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAh
DQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAA
IQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAA
ACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAA
AAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIA
AAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoC
AAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIa
AgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABC
GgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAA
QhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAA
AEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAA
AABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQA
AAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQE
AAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0
BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACE
NAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAA
hDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAA
AIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAA
AACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgA
AAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkI
AAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhp
CAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAI
aQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAA
CGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAA
AAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAA
AAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAA
AAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQ
AAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDS
EAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ
0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAA
ENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAA
ABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAA
AAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEA
AAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQh
AAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCk
IQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAg
pCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAA
IKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAA
ACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAA
AAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMA
AAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhD
AAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBI
QwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABA
SEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAA
QEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAA
AEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAA
AABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYA
AAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCG
AAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQ
hgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACA
kIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAA
gJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAA
AICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEA
AACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0B
AAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACEN
AQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAh
DQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAA
IQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAA
ACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAA
AAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIA
AAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoC
AAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIa
AgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABC
GgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAA
QhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAA
AEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAA
AABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQA
AAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQE
AAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0
BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACE
NAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAA
hDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAA
AIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAA
AACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgA
AAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkI
AAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhp
CAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAI
aQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAA
CGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAA
AAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAA
AAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAA
AAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQ
AAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAAABDS
EAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAAAAAQ
0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEAAAAA
ENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQhAAAA
ABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCkIQAA
AAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAgpCEA
AAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAAIKQh
AAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAAACCk
IQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAAAAAg
pCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMAAAAA
IKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhDAAAA
ACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBIQwAA
AAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABASEMA
AAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAAQEhD
AAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAAAEBI
QwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAAAABA
SEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYAAAAA
QEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCGAAAA
AEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQhgAA
AABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACAkIYA
AAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAAgJCG
AAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAAAICQ
hgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAhDQEAAAAAEIaAgAAAAAhDQEAAACA
kIYAAAAAQEhDAAAAACCkIQAAAAAQ0hAAAAAACGkIAAAAAIQ0BAAAAABCGgIAAAAAIQ0BAAAA
gJCGAAAAAEBIQwAAAAAgpCEAAAAAENIQAAAAAAhpCAAAAACENAQAAAAAQhoCAAAAACENAQAA
AICQhgAAAABASEMAAAAAIKQhAAAAABDSEAAAAAAIaQgAAAAAPNsBbM5DG8lSHLMAAAAASUVO
RK5CYII=
--------------47EB76A1A5D5C0DA2C4D1F4E--
