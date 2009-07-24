From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some
 USB Disks
Date: Fri, 24 Jul 2009 18:17:39 +0300
Message-ID: <4A69D093.8020108@turknet.net.tr>
References: <4A4472DF.1050900@turknet.net.tr>	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr> <yq1fxcmnpqa.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.netone.net.tr ([193.192.98.182]:42977 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZGXPRk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2009 11:17:40 -0400
In-Reply-To: <yq1fxcmnpqa.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

On 07/24/2009 05:02 PM, Martin K. Petersen wrote:
> Tarkan>  Today, I had time to bisect and you were right: The below commit
> Tarkan>  related to capacity detection changes in SCSI subsystem,as you
> Tarkan>  mentioned, seems the cause of the problem.
>
> Thanks for bisecting this.
>
>    
You're welcome ;-)
> Tarkan>      Detect non-rotational devices and set the queue flag
> Tarkan>      accordingly.
>
> Aha, so you're getting USB resets because your USB-ATA bridge gets
> confused when we ask it a simple question.  What a marvel of modern
> engineering that thing is...
>
> Please send me the output of:
>
> sg_inq -e /dev/foo
> sg_inq -l 16 /dev/foo
> sg_inq -l 16 -e /dev/foo
> sg_inq -l 36 /dev/foo
> sg_inq -l 36 -e /dev/foo
> sg_vpd -p sv /dev/foo
> sg_vpd -p bl /dev/foo
> sg_vpd -p bdc /dev/foo
>
>    

Here are the results of the commands you asked :

root@tarkane:~# sg_inq -e /dev/sdb
VPD INQUIRY: extended INQUIRY data page

inquiry: transport: Host_status=0x05 [DID_ABORT]
Driver_status=0x00 [DRIVER_OK, SUGGEST_OK]

     inquiry: failed, res=-1


root@tarkane:~# sg_inq -l 16 /dev/sdb
standard INQUIRY:
   PQual=0  Device_type=0  RMB=0  version=0x00  [no conformance claimed]
   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=0
   SCCS=0  ACC=0  TGPS=0  3PC=0  Protect=0  BQue=0
   EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
   [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=0
     length=74 (0x4a), but only fetched 16 bytes   Peripheral device 
type: disk
  Vendor identification: WD
  Product identification: <none>
  Product revision level: <none>


root@tarkane:~# sg_inq -l 16 -e /dev/sdb
VPD INQUIRY: extended INQUIRY data page
inquiry: transport: Host_status=0x05 [DID_ABORT]
Driver_status=0x00 [DRIVER_OK, SUGGEST_OK]

     inquiry: failed, res=-1


root@tarkane:~# sg_inq -l 36 /dev/sdb
standard INQUIRY:
   PQual=0  Device_type=0  RMB=0  version=0x00  [no conformance claimed]
   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=0
   SCCS=0  ACC=0  TGPS=0  3PC=0  Protect=0  BQue=0
   EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
   [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=0
    length=74 (0x4a), but only fetched 36 bytes   Peripheral device 
type: disk
  Vendor identification: WD
  Product identification: 2500JB External
  Product revision level: 0108


root@tarkane:~# sg_inq -l 36 -e /dev/sdb
VPD INQUIRY: extended INQUIRY data page
inquiry: transport: Host_status=0x05 [DID_ABORT]
Driver_status=0x00 [DRIVER_OK, SUGGEST_OK]

     inquiry: failed, res=-1


root@tarkane:~# sg_vpd -p sv /dev/sdb
Supported VPD pages VPD page:
inquiry: transport: Host_status=0x05 [DID_ABORT]
Driver_status=0x00 [DRIVER_OK, SUGGEST_OK]

fetching VPD page failed


root@tarkane:~# sg_vpd -p bl /dev/sdb
inquiry: transport: Host_status=0x05 [DID_ABORT]
Driver_status=0x00 [DRIVER_OK, SUGGEST_OK]

VPD page=0xb0
fetching VPD page failed


root@tarkane:~# sg_vpd -p bdc /dev/sdb
abbreviation doesn't match a VPD page
available VPD pages:
   ai         0x89      ATA information (SAT)
   aod        0x82      ASCII implemented operating definition (obs)
   bl         0xb0      Block limits (SBC)
   di         0x83      Device identification
   di_asis    0x83      Like 'di' but designators ordered as found
   di_lu      0x83      Device identification, lu only
   di_port    0x83      Device identification, target port only
   di_target  0x83      Device identification, target device only
   ei         0x86      Extended inquiry data
   iod        0x81      Implemented operating definition (obs)
   mas        0xb1      Manufacturer assigned serial number (SSC)
   mna        0x85      Management network addresses
   mpp        0x87      Mode page policy
   oi         0xb0      OSD information
   sad        0xb0      Sequential access device capabilities (SSC)
   sii        0x84      Software interface identification
   sn         0x80      Unit serial number
   sp         0x88      SCSI ports
   st         0xb1      Security token (OSD)
   sv         0x00      Supported VPD pages
   tas        0xb2      TapeAlert supported flags (SSC)

Vendor specific VPD pages:
   datc       0xc1,0      Date code (Seagate)
   devb       0xc3,0      Device behavior (Seagate)
   firm       0xc0,0      Firmware numbers (Seagate)
   jump       0xc2,0      Jump setting (Seagate)
   sver       0xc2,1      Software version (RDAC)
   upr        0xc0,1      Unit path report (EMC)
   vac        0xc9,0      Volume access control (RDAC)

