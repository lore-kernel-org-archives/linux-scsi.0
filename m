From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aacraid: SCSI bus appears hung
Date: Fri, 20 Mar 2009 15:42:58 +0000
Message-ID: <1237563778.12008.65.camel@localhost.localdomain>
References: <gq09cm$abq$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36831 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908AbZCTPnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Mar 2009 11:43:04 -0400
In-Reply-To: <gq09cm$abq$2@ger.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Mueller <thomas@chaschperli.ch>
Cc: linux-scsi@vger.kernel.org, aacraid@adaptec.com

On Fri, 2009-03-20 at 14:31 +0000, Thomas Mueller wrote:
> hi 
> 
> this is on debian etch with kernel 2.6.26 (backports.org) and aacraid 
> 1.1-5[2456]-ms. the adapter is an adaptec 5805 (rebranded as Supermicro 
> AOC-USAS-S8iR, f/w 15758), 4+1 WD VelociRaptor 300GB disks, RAID10.
> 
> the disks aren't very good. about every 2 months the background consistency
> check detects defectiv blocks on some disks. the hotspare disk takes
>  over. that's where the  troubles start.
> 
> Mar 19 20:44:30 ib001 kernel: [4312641.290691] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:44:30 ib001 kernel: [4312641.290792] aacraid: Host adapter reset request. SCSI hang ?
> Mar 19 20:57:53 ib001 kernel: [4312700.999164] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4312880.704289] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4312880.704388] aacraid: Host adapter reset request. SCSI hang ?
> Mar 19 20:57:53 ib001 kernel: [4312941.412927] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4312941.413039] aacraid: Host adapter reset request. SCSI hang ?
> Mar 19 20:57:53 ib001 kernel: [4312951.930474] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
> Mar 19 20:57:53 ib001 kernel: [4313001.400935] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4313001.401042] aacraid: Host adapter reset request. SCSI hang ?
> Mar 19 20:57:53 ib001 kernel: [4313061.796830] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4313061.796930] aacraid: Host adapter reset request. SCSI hang ?
> Mar 19 20:57:53 ib001 kernel: [4313122.675845] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4313122.675931] aacraid: Host adapter reset request. SCSI hang ?
> Mar 19 20:57:53 ib001 kernel: [4313183.252118] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4313183.252227] aacraid: Host adapter reset request. SCSI hang ?
> Mar 19 20:57:53 ib001 kernel: [4313239.408236] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4313239.408337] aacraid: Host adapter reset request. SCSI hang ?
> Mar 19 20:57:53 ib001 kernel: [4313295.503066] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4313295.503145] aacraid: Host adapter reset request. SCSI hang ?
> Mar 19 20:57:53 ib001 kernel: [4313305.669682] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT,SUGGEST_OK
> Mar 19 20:57:53 ib001 kernel: [4313351.860988] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4313351.861020] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4313351.861047] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4313351.861073] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4313351.861100] aacraid: Host adapter abort request (0,0,0,0)
> Mar 19 20:57:53 ib001 kernel: [4313351.861191] aacraid: Host adapter reset request. SCSI hang ?
> Mar 19 20:57:53 ib001 kernel: [4313413.717370] aacraid: SCSI bus appears hung
> Mar 19 20:58:09 ib001 kernel: [4313517.692627] sd 0:0:0:0: [sda] 585084928 512-byte hardware sectors (299563 MB)
> Mar 19 20:58:09 ib001 kernel: [4313517.692627] sd 0:0:0:0: [sda] Write Protect is off
> Mar 19 20:58:09 ib001 kernel: [4313517.692627] sd 0:0:0:0: [sda] Mode Sense: 06 00 10 00
> Mar 19 20:58:09 ib001 kernel: [4313517.692627] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
> Mar 19 21:46:34 ib001 kernel: [4317148.271355] sd 0:0:0:0: [sda] 585084928 512-byte hardware sectors (299563 MB)
> Mar 19 21:46:34 ib001 kernel: [4317148.271355] sd 0:0:0:0: [sda] Write Protect is off
> Mar 19 21:46:34 ib001 kernel: [4317148.271355] sd 0:0:0:0: [sda] Mode Sense: 06 00 10 00
> Mar 19 21:46:34 ib001 kernel: [4317148.271355] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
> (many "process hung" kernel warnings suppressed)
> 
> the aacraid seems to be unresponsive after this event. blocking the system.
> on top of the aacraid device there is drbd running. which 
> also gets mad about aacraid not responding - and then 
> the second drbd node (identical machine) also gets stuck.
> 
> sometimes this is only "resolveable" by rebooting the host. 
> 
> same problem on 2 other servers with nearly identical hardware.
> 
> is this expected on an disk failure event?
> 
> maybe i should try the vanilla 2.6.28.x kernel? 

Part of the problem seems to be the way the aacraid firmware is reacting
to disk failures.  It's possible it might recovery faster with a newer
kernel (I seem to remember seeing "hit it with a bigger hammer" type
patches going into that).  However, your basic problem of running RAID
on unreliable disks will still remain.

James


