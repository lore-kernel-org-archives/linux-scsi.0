From: James Smart <james.smart@emulex.com>
Subject: Re: lpfc SAN/SCSI issue
Date: Wed, 5 May 2010 10:01:11 -0400
Message-ID: <4BE17A27.5040603@emulex.com>
References: <20100422164739.GA15813@lsil.com>	 <1271964275.2480.1.camel@localhost> <4BD1A071.2010202@emulex.com>	 <j2o29ae894c1004230922le8baf635y563e50e3edc53bc3@mail.gmail.com>	 <4BD226F4.6070908@emulex.com> <1272109999.2983.30.camel@localhost>	 <4BD5D258.8030309@emulex.com> <1272318721.16254.7.camel@localhost>	 <1272389874.4245.2.camel@localhost> <k2w29ae894c1005030939lc95722dds328a2ee956b06ba1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:56902 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755927Ab0EEOBd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2010 10:01:33 -0400
In-Reply-To: <k2w29ae894c1005030939lc95722dds328a2ee956b06ba1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brem belguebli <brem.belguebli@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



brem belguebli wrote:
> Hi james,
> 
> We haven't yet been able to ask our Telco to switch back the DWDM
> links to original situation.
> 
> However, since logging was activated on the server I'm having a lot of
> messages :
> 
> lpfc 0000:10:00.1: 1:(0):0730 FCP command x26 failed: x2 SNS x70000500
> x20000000 Data: xa x200 x10 x0 x0
> 
> for which I couldn't find no explanation
> (http://www-dl.emulex.com/support/linux/820482p/linux.pdf)
> 
> Do you have any information on this ?

This is saying that SCSI command opcode 0x26 (Vendor-specific opcode ??) 
failed, with Status code x2 (Check Condition) followed by the SCSI sense data, 
w/ Sense Key 5 (ILLEGAL REQUEST).

I don't know who would be issuing this command (opcode 0x26), most likely some 
utility/daemon using sgio, but the target is rejecting the command (not valid 
for the vendor).  Very reasonable.


> Also, there are other lpfc parameters that could be tweaked if I
> understand well their meaning:
> 
> lpfc_hba_queue_depth currently set to 1024 :   Does it represent the
> number of [IOs/Exchanges] the HBA will queue untill the remote port
> acks them or untill it is considered down ?

This is the total number of i/o's outstanding on the wire, to all 
targets/luns, at any point in time.  This is typically the capacity of the 
adapter, which is used in a FIFO basis as I/O is received from the midlayer. 
The default value of the attribute takes the maximum from the adapter. On your 
adapter, the value is 1024. On most newer adapters, it is 2x this or more. 
The only time I've seen this value tweaked is when our adapter is connected to 
a single target (array), and overruns or fully utilizes the capacity of the 
target, causing the target to work harder, and actually accomplish less, than 
it could at say an 80% utilization level (note: capacity level is 
target-specific).   (another reason per-target queue_depth handling was put in 
- see next comment).


> 
> lpfc_max_scsicmpl_time set to 0 : Does 0 represent some infinite
> value, meaning it won't timeout any IO for which the driver did not
> receive any completion ack ?

No, unrelated.  This is relative to target queue depth mgmt.  The midlayer 
doesn't do queue depth management by target - only per sdev (lun). Our driver 
does though.  Target queue depth is the sum of all i/o to all luns on the same 
target,  with a threshold that may or may not be capped based on the array 
type, and which scales/ramps down to the existing outstanding i/o count when 
the target reports QUEUE_FULL/TASK_SET_FULL.  This behavior is valid only on 
targets that have a shared i/o queue for all luns.  This value controls the 
per-target ramp-up processing. If 0, we use a constant compiled-in interval 
which ramps our target queue depth back up by x%. When non-zero, it specifies 
a shost-specific time interval for the ramp up (it's actually a little 
trickier than this as it's tailored on some arrays that really depended upon 
not being overrun beyond their capacity levels).


-- james s

